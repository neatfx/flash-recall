package neatunit {

	public final class TestCollectionAssert extends TestCase {
		public function allItemsAreInstancesOfTest():void {
			CollectionAssert.allItemsAreInstancesOf(["a", "b", "c"], String);
		}

		public function allItemsAreNotNullTest():void {
			CollectionAssert.allItemsAreNotNull(["a", "b", "c"]);
			CollectionAssert.allItemsAreNotNull(["a", "b", 1, 2, 3, new Object()]);
		}

		public function allItemsAreUniqueTest():void {
			CollectionAssert.allItemsAreUnique([new Object(), new Object(), new Object()]);
			CollectionAssert.allItemsAreUnique(["x", "y", "z"]);
			CollectionAssert.allItemsAreUnique(["x", "y", null, "z"]);
		}

		public function containsTest():void {
			var collection:Array = ["a", "b", "c", null];
			CollectionAssert.contains(collection, "a");
			CollectionAssert.contains(collection, null);
		}

		public function doesNotContainTest():void {
			var collection:Array = ["a", "b", "c"];
			CollectionAssert.doesNotContain(collection, "d");
			CollectionAssert.doesNotContain([], "x");
		}

		public function isEmptyTest():void {
			CollectionAssert.isEmpty([]);
		}

		public function isNotEmptyTest():void {
			CollectionAssert.isNotEmpty(["x", "y", "z"]);
		}

		public function areEquivalentTest():void {
			CollectionAssert.areEquivalent(["x", "y", "z"], ["z", "y", "x"]);
			CollectionAssert.areEquivalent([null, "a", null, "b"], ["b", null, "a", null]);
		}

		public function areNotEquivalentTest():void {
			CollectionAssert.areNotEquivalent(["x", "y", "z"], ["x", "y", "x"]);
			CollectionAssert.areNotEquivalent(["x", null, "z"], ["x", null, "x"]);
		}

		public function isSubsetOfTest():void {
			CollectionAssert.isSubsetOf(["y", "z"], ["x", "y", "z"]);
			CollectionAssert.isSubsetOf([null, "z"], ["x", null, "z"]);
		}

		public function isNotSubsetOfTest():void {
			CollectionAssert.isNotSubsetOf(["x", "y", "z"], ["y", "z", "a"]);
			CollectionAssert.isNotSubsetOf(["x", null, "z"], [null, "z", "a"]);
		}

	}

}