package neatunit {

	public final class TestStringAssert extends TestCase {
		public function isEmptyTest():void {
			StringAssert.isEmpty("");
		}

		public function isNotEmptyTest():void {
			StringAssert.isNotEmpty("NeatUnit");
			StringAssert.isNotEmpty(null);
		}

		public function containsTest():void {
			StringAssert.contains("abc", "abc");
			StringAssert.contains("abc", "abc***");
			StringAssert.contains("abc", "***abc");
			StringAssert.contains("abc", "**abc**");
		}

		public function startsWithTest():void {
			StringAssert.startsWith("abc", "abc");
			StringAssert.startsWith("abc", "abcdef");
		}

		public function endsWithTest():void {
			StringAssert.endsWith("NeatUnit", "NeatUnit");
			StringAssert.endsWith("Unit", "NeatUnit");
			StringAssert.endsWith("it", "NeatUnit");
		}

		public function areEqualIgnoringCaseTest():void {
			StringAssert.areEqualIgnoringCase("flash", "FLASH");
			StringAssert.areEqualIgnoringCase("Flash", "FLASH");
		}

		public function isMatchTest():void {
			StringAssert.isMatch("a?bc", "12a3bc45");
		}
	}
}