#!/usr/bin/env python3
"""Build first, then run base/PR pairs on one runner. Preserve samples and logs."""
import json
import os
from pathlib import Path
import statistics
import subprocess
import sys


def run(command, cwd, log, **env):
    with log.open("w") as stream:
        result = subprocess.run(command, cwd=cwd, env={**os.environ, **env},
                                stdout=stream, stderr=subprocess.STDOUT)
    if result.returncode:
        print(log.read_text()[-12000:], file=sys.stderr)
        raise SystemExit(result.returncode)


def indexed(entries):
    result = {entry["name"]: entry for entry in entries}
    if len(result) != len(entries):
        raise ValueError("Duplicate benchmark names")
    return result


def aggregate(samples):
    first = samples[0]
    for sample in samples:
        if sample.keys() != first.keys():
            raise ValueError("Benchmark names changed between rounds")
        if any(sample[name]["unit"] != entry["unit"] for name, entry in first.items()):
            raise ValueError("Benchmark units changed between rounds")
    return {
        name: {**entry, "value": (max if entry["unit"] == "count" else statistics.median)(
            [sample[name]["value"] for sample in samples])}
        for name, entry in first.items()
    }


def main():
    current = Path(sys.argv[1]).resolve()
    output = Path(sys.argv[2]).resolve()
    output.mkdir(parents=True, exist_ok=True)
    roots = {"pr": current}
    if len(sys.argv) > 3:
        roots = {"base": Path(sys.argv[3]).resolve(), **roots}
    # Separate targets prevent one revision's library from replacing the other's.
    for label, root in roots.items():
        target = output / f"{label}-target"
        run(["cargo", "bench", "--locked", "-p", "shalom_runtime", "--bench",
             "runtime_bench", "--no-run"], root, output / f"{label}-rust-build.log",
            CARGO_TARGET_DIR=str(target))
        run(["cargo", "build", "--locked", "--release", "-p", "shalom_ffi"],
            root, output / f"{label}-ffi-build.log", CARGO_TARGET_DIR=str(target))
        dart = root / "dart/shalom"
        run(["dart", "pub", "get"], dart, output / f"{label}-pub.log")
        run(["dart", "compile", "exe", "benchmark/subscribers.dart",
             "-o", str(output / f"{label}-subscribers")],
            dart, output / f"{label}-dart-build.log")
        print(f"Built {label}", flush=True)

    samples = {label: [] for label in roots}
    for index in range(3):
        # Each base sample is immediately followed by its PR sample.
        for label, root in roots.items():
            prefix = output / f"{label}-run-{index + 1}"
            rust = prefix.with_suffix(".rust.json")
            dart = prefix.with_suffix(".dart.json")
            target = output / f"{label}-target"
            run(["cargo", "bench", "--locked", "-p", "shalom_runtime", "--bench",
                 "runtime_bench"], root, prefix.with_suffix(".rust.log"),
                CARGO_TARGET_DIR=str(target), BENCH_OUTPUT=str(rust))
            run([str(output / f"{label}-subscribers"),
                 str(target / "release/libshalom_ffi.so"), str(dart)],
                root / "dart/shalom", prefix.with_suffix(".dart.log"))
            samples[label].append(indexed(json.loads(rust.read_text()) +
                                          json.loads(dart.read_text())))
            print(f"Completed {label} round {index + 1}/3", flush=True)

    merged = {label: aggregate(rounds) for label, rounds in samples.items()}
    if "base" in merged:
        for name, entry in merged["pr"].items():
            base = merged["base"].get(name)
            if base is None or base["unit"] != entry["unit"]:
                continue
            # Ratios are paired by round, not computed from independent medians.
            if entry["unit"] == "ns" and all(s[name]["value"] > 0 for s in samples["base"]):
                entry["comparison_ratio"] = statistics.median([
                    pr[name]["value"] / base[name]["value"]
                    for pr, base in zip(samples["pr"], samples["base"])
                ])
    for label, entries in merged.items():
        (output / f"{label}-results.json").write_text(
            json.dumps(list(entries.values()), indent=2))


if __name__ == "__main__":
    main()
