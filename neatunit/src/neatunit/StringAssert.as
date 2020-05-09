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

	public class StringAssert {
		public static function isEmpty(value:String):void {
			if (value != ""){
				fail('Expected: < "" > , but was: < "' + value + '" >');
			}
		}

		public static function isNotEmpty(value:String):void {
			if (value == ""){
				fail('Expected: String is not empty , but was: < "' + value + '" >');
			}
		}

		public static function contains(substring:String, actual:String):void {
			if (actual.indexOf(substring) == -1){
				fail('Expected: String < "' + actual + '" > contains String < "' + substring + '" >');
			}
		}

		public static function startsWith(starting:String, actual:String):void {
			if (starting != actual && actual.indexOf(starting) != 0){
				fail('String < "' + actual + '" > does not start with String < "' + starting + '" >');
			}
		}

		public static function endsWith(ending:String, actual:String):void {
			if (ending != actual && actual.lastIndexOf(ending) != (actual.length - ending.length)){
				fail('String < "' + actual + '" > does not end with String < "' + ending + '" >');
			}
		}

		public static function areEqualIgnoringCase(expected:String, actual:String):void {
			if (!(expected.toLowerCase() === actual.toLowerCase())){
				fail('String < "' + actual + '" > is not equal to String < "' + expected + '" >');
			}
		}

		public static function isMatch(expression:String, actual:String):void {
			var matches:Array = actual.match(new RegExp(expression));
			if (matches == null || matches.length == 0){
				fail('String < "' + actual + '" > does not match < "' + expression + '" >');
			}
		}

		///////
		private static function fail(message:String):void {
			TestCase._errors.push(message + new Error().getStackTrace().substr(5)); //缓存
		}
	}
}