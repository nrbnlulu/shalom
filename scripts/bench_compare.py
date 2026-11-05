#!/usr/bin/env python3
"""Compare two bench-results.json files and print a markdown table.

usage: bench_compare.py CURRENT.json [BASELINE.json]
Smaller is better for every metric. Time is noisy on shared CI runners so it
gets a looser threshold than (deterministic) memory.
"""
import json
import sys

THRESHOLDS = {"ns": 0.25, "bytes": 0.05, "rss": 0.15, "count": 0.0}
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
        out += ["_No baseline from `main` found; showing current results only._", ""]
    out += ["Metrics use three runs (median; counts use maximum). Timing and RSS comparisons across shared runners are advisory.", "", "<details>", "<summary>Full benchmark results</summary>", "", "| Benchmark | main | PR | Δ | |", "|---|---:|---:|---:|---|"]
    regressions = 0
    for name, e in cur.items():
        unit, val = e["unit"], e["value"]
        b = base.get(name)
        if b is None:
            out.append(f"| {name} | – | {fmt(val, unit)} | – | |")
            continue
        old = b["value"]
        if old == 0:
            delta, mark = ("0%" if val == 0 else "new"), ("" if val == 0 else "⚠️")
            regressions += val != 0
        else:
            ratio = (val - old) / old
            delta = f"{ratio:+.1%}"
            thr = THRESHOLDS.get(unit, 0.1)
            mark = "🔴 regression" if ratio > thr else ("🟢 improvement" if ratio < -thr else "")
            regressions += ratio > thr
        out.append(f"| {name} | {fmt(old, unit)} | {fmt(val, unit)} | {delta} | {mark} |")
    out += ["", f"Regression thresholds: time +{THRESHOLDS['ns']:.0%} (noisy shared runner), allocated memory +{THRESHOLDS['bytes']:.0%}, process RSS +{THRESHOLDS['rss']:.0%}, counts any increase."]
    out += ["", "</details>"]
    if regressions:
        out.append(f"\n**{regressions} possible regression(s).**")
    print("\n".join(out))


main()
