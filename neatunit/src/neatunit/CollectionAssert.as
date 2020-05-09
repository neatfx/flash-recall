/*

   Copyright (c) 2007-2008 Ryan Christiansen

   This software is provided 'as-is', without any express or implied
   warranty. In no event will the authors be held liable for any damages
   arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it
   freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.

 */

package neatunit {
	import flash.utils.Dictionary;

	public class CollectionAssert {
		public static function allItemsAreInstancesOf(enumerable:Array, definition:Class):void {
			for each (var value:Object in enumerable){
				if (!(value is definition)){
					fail("item : < " + value + " > in < " + enumerable + " > is not an instance of " + definition);
				}
			}
		}

		public static function allItemsAreNotNull(enumerable:Array):void {
			for each (var value:Object in enumerable){
				if (value == null){
					fail("item : < " + value + " > in < " + enumerable + " > is null!");
				}
			}
		}

		public static function allItemsAreUnique(enumerable:Array):void {
			var valueCache:Dictionary = new Dictionary();
			for each (var value:Object in enumerable){
				if (valueCache[value] == true){
					fail("item : < " + value + " > in < " + enumerable + " > is not unique!");
				}
				valueCache[value] = true;
			}
		}

		public static function contains(enumerable:Array, instance:Object):void {
			for each (var value:Object in enumerable){
				if (value == instance){
					return;
				}
			}
			fail("< " + instance + " > is not a member of < " + enumerable + " >");
		}

		public static function doesNotContain(enumerable:Array, instance:Object):void {
			for each (var value:Object in enumerable){
				if (value == instance){
					fail("< " + enumerable + " > contains < " + instance + " >");
				}
			}
		}

		public static function isEmpty(enumerable:Array):void {
			if (enumerable.length != 0){
				fail("< " + enumerable + " > is not empty!");
			}
		}

		public static function isNotEmpty(enumerable:Array):void {
			if (enumerable.length > 0){
				return;
			}
			fail("< " + enumerable + " > is empty!");
		}

		public static function areEquivalent(expected:Array, actual:Array):void {
			var isFailure:Boolean = false;
			assert:  {
				if (expected.length != actual.length){
					isFailure = true;
					break assert;
				}
				var expectedIndexer:CollectionIndexer = new CollectionIndexer(expected);
				var actualIndexer:CollectionIndexer = new CollectionIndexer(actual);
				for each (var value:Object in actualIndexer.values){
					if (expectedIndexer.getCount(value) != actualIndexer.getCount(value)){
						isFailure = true;
						break assert;
					}
				}
			}
			if (isFailure){
				fail("< " + actual + " > is not equivalent to < " + expected + " >");
			}
		}

		public static function areNotEquivalent(expected:Array, actual:Array):void {
			if (expected.length != actual.length){
				return;
			}
			var expectedIndexer:CollectionIndexer = new CollectionIndexer(expected);
			var actualIndexer:CollectionIndexer = new CollectionIndexer(actual);
			for each (var value:Object in actualIndexer.values){
				if (expectedIndexer.getCount(value) != actualIndexer.getCount(value)){
					return;
				}
			}
			fail("< " + actual + " > is equivalent to < " + expected + " >");
		}

		public static function isSubsetOf(subset:Array, superset:Array):void {
			var isFailure:Boolean = false;
			assert:  {
				if (subset.length > superset.length){
					isFailure = true;
					break assert;
				}
				var subsetIndexer:CollectionIndexer = new CollectionIndexer(subset);
				var supersetIndexer:CollectionIndexer = new CollectionIndexer(superset);
				for each (var value:Object in subsetIndexer.values){
					if (supersetIndexer.getCount(value) == 0){
						isFailure = true;
						break assert;
					} else if (subsetIndexer.getCount(value) > supersetIndexer.getCount(value)){
						isFailure = true;
						break assert;
					}
				}
			}
			if (isFailure){
				fail("< " + subset + " > is not a subset of < " + superset + " >");
			}
		}

		public static function isNotSubsetOf(subset:Array, superset:Array):void {
			if (subset.length > superset.length){
				return;
			}
			var subsetIndexer:CollectionIndexer = new CollectionIndexer(subset);
			var supersetIndexer:CollectionIndexer = new CollectionIndexer(superset);
			for each (var value:Object in subsetIndexer.values){
				if (supersetIndexer.getCount(value) == 0){
					return;
				} else if (subsetIndexer.getCount(value) > supersetIndexer.getCount(value)){
					return;
				}
			}
			fail("< " + subset + " > is a subset of < " + superset + " >");
		}

		//////
		private static function fail(message:String):void {
			TestCase._errors.push(message + new Error().getStackTrace().substr(5));
		}
	}
}

import flash.utils.Dictionary;

internal class CollectionIndexer {
	private static const NULL:Object = new Object();
	private var _hash:Dictionary = new Dictionary();
	private var _values:Array = new Array();

	public function CollectionIndexer(collection:Object){
		var value:Object;
		for each (value in collection){
			if (value == null){
				value == new Object();
			}
			_hash[value] = getCount(value) + 1;
		}
		for (value in _hash){
			_values.push(value);
		}
	}

	public function getCount(value:Object):int {
		return (_hash[value] != null) ? int(_hash[value]) : 0;
	}

	public function get values():Array {
		return _values;
	}
}
