import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import bench_ci
import bench_compare


class BenchmarksTest(unittest.TestCase):
    def test_paired_rounds_and_worst_counts(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            output = root / "results"
            calls = []
            values = {"base": [10, 100, 1000], "pr": [20, 1000, 1100]}

            def fake_run(command, cwd, log, **env):
                # Compilation must finish before the first measurement.
                if "BENCH_OUTPUT" in env:
                    path = Path(env["BENCH_OUTPUT"])
                    label, _, number = path.name.split(".")[0].split("-")
                    index = int(number) - 1
                    calls.append(label)
                    path.write_text(json.dumps([
                        dict(name="time", unit="ns", value=values[label][index]),
                        dict(name="notifications", unit="count",
                             value=1 if label == "pr" and index == 0 else 0),
                    ]))
                elif command[0].endswith("-subscribers"):
                    Path(command[2]).write_text(json.dumps([
                        dict(name="RSS", unit="rss", value=100 if "pr-" in command[0] else 1)
                    ]))

            with patch.object(bench_ci, "run", side_effect=fake_run), patch(
                "sys.argv", ["bench_ci.py", str(root / "pr"), str(output), str(root / "base")]
            ), contextlib.redirect_stdout(io.StringIO()):
                bench_ci.main()
            self.assertEqual(calls, ["base", "pr"] * 3)
            current = bench_ci.indexed(json.loads((output / "pr-results.json").read_text()))
            self.assertEqual(current["time"]["comparison_ratio"], 2)
            self.assertEqual(current["notifications"]["value"], 1)
            # A 100x RSS increase must not become a third regression.
            with patch("sys.argv", ["bench_compare.py", str(output / "pr-results.json"),
                                   str(output / "base-results.json")]):
                report = io.StringIO()
                with contextlib.redirect_stdout(report):
                    bench_compare.main()
            visible, details = report.getvalue().split("<details>")
            self.assertIn("2 possible regression(s)", visible)
            self.assertIn("+100.0%", visible)
            self.assertNotIn("| RSS |", visible)
            self.assertIn("informational", details)

    def test_rejects_inconsistent_rounds(self):
        with self.assertRaises(ValueError):
            bench_ci.aggregate([{"a": dict(unit="ns", value=1)}, {}])


if __name__ == "__main__":
    unittest.main()
