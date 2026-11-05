#!/usr/bin/env python3
"""Compare two bench-results.json files and print a markdown table.

usage: bench_compare.py CURRENT.json [BASELINE.json]
Smaller is better for every metric. Time is noisy on shared CI runners so it
gets a looser threshold than (deterministic) memory.
"""
import json
import sys

THRESHOLDS = {"ns": 0.25, "bytes": 0.05, "count": 0.0}
MARKER = "<!-- shalom-benchmarks -->"


def load(path):
    with open(path) as f:
        return {e["name"]: e for e in json.load(f)}


def fmt(value, unit):
    if unit == "ns":
        for div, suffix in ((1e9, "s"), (1e6, "ms"), (1e3, "µs")):
            if value >= div:
                return f"{value / div:.2f} {suffix}"
        return f"{value:.0f} ns"
    if unit == "count":
        return f"{value:.0f}"
    for div, suffix in ((1 << 20, "MiB"), (1 << 10, "KiB")):
        if value >= div:
            return f"{value / div:.2f} {suffix}"
    return f"{value:.0f} B"


def main():
    cur = load(sys.argv[1])
    base = load(sys.argv[2]) if len(sys.argv) > 2 else {}
    out = [MARKER, "## Benchmark results", ""]
    if not base:
        out += ["_Showing current results only._", ""]
    if base:
        out += ["Base and PR ran on the same runner in three alternating rounds. "
                "Time Δ is the median of paired ratios; values are medians "
                "(counts use maximum). RSS is informational.", ""]
    rows = []
    flagged = []
    header = ["| Benchmark | Base | PR | Δ | |", "|---|---:|---:|---:|---|"]
    for name, e in cur.items():
        unit, val = e["unit"], e["value"]
        b = base.get(name)
        if b is None or b["unit"] != unit:
            rows.append(f"| {name} | – | {fmt(val, unit)} | – | |")
            continue
        old = b["value"]
        if old == 0:
            delta, mark = ("0%" if val == 0 else "new"), ("" if val == 0 else "⚠️")
            regression = val != 0 and unit in THRESHOLDS
        else:
            ratio = e.get("comparison_ratio", val / old) - 1
            delta = f"{ratio:+.1%}"
            thr = THRESHOLDS.get(unit, float("inf"))
            mark = "🔴 regression" if ratio > thr else ("🟢 improvement" if ratio < -thr else "")
            regression = ratio > thr
        if unit == "rss":
            mark = "informational"
        row = f"| {name} | {fmt(old, unit)} | {fmt(val, unit)} | {delta} | {mark} |"
        rows.append(row)
        if regression:
            flagged.append(row)
    if flagged:
        out += [f"**{len(flagged)} possible regression(s).**", "", *header, *flagged, ""]
    elif base:
        out += ["No suspected regressions.", ""]
    out += ["<details>", "<summary>Full benchmark results</summary>", "",
            *header, *rows, "",
            f"Regression thresholds: time +{THRESHOLDS['ns']:.0%}, "
            f"allocated memory +{THRESHOLDS['bytes']:.0%}, counts any increase. "
            "RSS does not trigger regression flags.", "", "</details>"]
    print("\n".join(out))


if __name__ == "__main__":
    main()
