#!/usr/bin/env python3
"""Run a benchmark three times, preserving logs and reporting median metrics.

Usage: bench_repeat.py OUTPUT COMMAND [ARGS...]
COMMAND must write OUTPUT on each successful run.
"""
import json
import pathlib
import statistics
import subprocess
import sys


def main():
    output = pathlib.Path(sys.argv[1]).resolve()
    samples = []
    for index in range(3):
        output.unlink(missing_ok=True)
        log = output.with_suffix(f".run-{index + 1}.log")
        with log.open("w") as stream:
            result = subprocess.run(sys.argv[2:], stdout=stream, stderr=subprocess.STDOUT)
        if result.returncode:
            print(log.read_text()[-12000:], file=sys.stderr)
            raise SystemExit(result.returncode)
        entries = json.loads(output.read_text())
        sample = {e["name"]: e for e in entries}
        if len(sample) != len(entries):
            raise ValueError("Duplicate benchmark names")
        if samples and sample.keys() != samples[0].keys():
            raise ValueError("Benchmark names changed between runs")
        samples.append(sample)
        output.replace(output.with_suffix(f".run-{index + 1}.json"))
        print(f"Completed benchmark run {index + 1}/3", flush=True)
    merged = []
    for name, entry in samples[0].items():
        if any(s[name]["unit"] != entry["unit"] for s in samples):
            raise ValueError(f"Unit changed for {name}")
        values = [s[name]["value"] for s in samples]
        # Never hide intermittent spurious notifications behind a median.
        value = max(values) if entry["unit"] == "count" else statistics.median(values)
        merged.append({**entry, "value": value})
    output.write_text(json.dumps(merged, indent=2))


if __name__ == "__main__":
    main()
