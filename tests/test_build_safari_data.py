import importlib.util
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "build_safari_data", ROOT / "scripts/build_safari_data.py"
)
BUILD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BUILD)


class PolicyDataTests(unittest.TestCase):
    def test_only_non_ascii_sources_with_ascii_letter_targets_are_retained(self):
        mappings = BUILD.parse_confusables([
            "0430 ; 0061 ; MA # Cyrillic a",
            "11700 ; 0072 006E ; MA # Multiple ASCII letters",
            "00FC ; 0075 0308 ; MA # Accented target",
            "0061 ; 0061 ; MA # ASCII source",
            "0660 ; 002E ; MA # Punctuation target",
        ])
        self.assertEqual(mappings, {"\u0430": "a", "\U00011700": "rn"})

    def test_invalid_or_empty_data_is_not_accepted(self):
        for lines in ([], ["# comment"], ["bad"], ["0430;0061;XX"],
                      ["110000;0061;MA"], ["0430;;MA"]):
            with self.subTest(lines=lines), self.assertRaises(ValueError):
                BUILD.parse_confusables(lines)

    def test_wrong_checksum_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "SHA-256 mismatch"):
            BUILD.verified_mappings(b"unexpected data")

    def test_generated_data_is_deterministic(self):
        first = BUILD.generated_source({"\u0430": "a", "\U00011700": "rn"})
        second = BUILD.generated_source({"\U00011700": "rn", "\u0430": "a"})
        self.assertEqual(first, second)
        self.assertIn(BUILD.SHA256, first)


if __name__ == "__main__":
    unittest.main()
