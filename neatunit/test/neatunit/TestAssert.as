package neatunit {
	import flash.errors.IllegalOperationError;

	public final class TestAssert extends TestCase {
		public function assertThrowsTest():void {
			assertThrows(IllegalOperationError, function():void {
					throw new IllegalOperationError("Expected IllegalOperationError");
				});
		}

		public function assertEqualsFloatTest():void {
			assertEqualsFloat(12, 16, 4);
			assertEqualsFloat(12, 16, 7);
		}

		public function assertTrueTest():void {
			assertTrue(true);
		}

		public function assertFalseTest():void {
			assertFalse(false);
		}

		public function assertSameTest():void {
			assertSame(12, 12);
		}

		public function assertNotSameTest():void {
			assertNotSame("peter", "mona");
		}

		public function assertNullTest():void {
			assertNull(null);
		}

		public function assertNotNullTest():void {
			assertNotNull("not null");
		}

		public function assertEqualTest():void {
			assertEqual("neatunit", "neatunit");
			assertEqual(120, 120);
			assertEqual(null, null);
			assertEqual(["x", "y", "z"], ["x", "y", "z"]);
			assertEqual([null, null, null], [null, null, null]);
		}

		public function assertNotEqualTest():void {
			assertNotEqual("neatunit", "Peter");
			assertNotEqual(120, 160);
			assertNotEqual(null, "hello world!");
			assertNotEqual(["x", "y", "a"], ["x", "y", "z"]);
			assertNotEqual([null, "a", null], [null, null, null]);
		}
	}
}