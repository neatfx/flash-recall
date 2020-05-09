//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {
	import flash.utils.getQualifiedClassName;

	public class Assert {
		protected static function assertEqual(expected:Object, actual:Object):void {
			var comparer:AssertEqualityComparer = new AssertEqualityComparer();
			if (!comparer.equals(expected, actual)){
				fail("< " + actual + " > is not equal to < " + expected + " >");
			}
		}

		protected static function assertNotEqual(expected:Object, actual:Object):void {
			var comparer:AssertEqualityComparer = new AssertEqualityComparer();
			if (comparer.equals(expected, actual)){
				fail("< " + actual + " > is equal to < " + expected + " >");
			}
		}

		protected static function assertTrue(actual:*):void {
			if (!Boolean(actual)){
				fail("Expected: < true > , but was: < " + actual + " >");
			}
		}

		protected static function assertFalse(actual:*):void {
			if (Boolean(actual)){
				fail("Expected: < false > , but was: < " + actual + " >");
			}
		}

		protected static function assertSame(actual:Object, expected:Object):void {
			if (expected === actual){
				return;
			}
			fail("Expected same: < " + expected + " > was not: < " + actual + " >");
		}

		protected static function assertNotSame(actual:*, expected:*):void {
			if (expected === actual){
				fail("Expected not same: < " + expected + " > was : < " + actual + " >");
			}
		}

		protected static function assertNotNull(actual:*):void {
			if (actual == null){
				fail("Expected: < not null > , but was: < " + actual + " >");
			}
		}

		protected static function assertNull(actual:*):void {
			if (actual != null){
				fail("Expected: < null > , but was: < " + actual + " >");
			}
		}

		protected static function assertEqualsFloat(actual:*, expected:*, tolerance:uint):void {
			if (Math.abs(expected - actual) <= tolerance){
				return;
			}
			fail("The two numerical values are not equal within a tolerance range");
		}

		protected static function assertThrows(errorType:Class, block:Function):void {
			try {
				block.call();
				fail("assertThrows block did not throw an expected exception");
				return;
			} catch (e:Error){
				if (!(e is errorType)){
					fail("assertThrows did not throw the expected error type : " + getQualifiedClassName(errorType) + " , instead threw : " + getQualifiedClassName(e));
					return;
				}
			}
		}

		//////
		public static function fail(message:String, isEmptyAsyncTestMethod:Boolean = false):void {
			TestCase._errors.push(message + new Error().getStackTrace().substr(5)); //缓存
			if (isEmptyAsyncTestMethod){ //"Test method Not yet implemented"
				++TestResult.globalTestedAsyncTestsNumber;
				TestRunner.updateAsyncsInfo();
				TestCase._waitForAsyncTest = false;
			}
		}
	}
}
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

internal class AssertEqualityComparer {
	public function equals(a:Object, b:Object):Boolean {
		return objectsEqual(a, b, new Dictionary(true));
	}

	private function objectsEqual(a:Object, b:Object, references:Dictionary):Boolean {
		if (a == null && b == null){
			return true;
		} else if (a == null || b == null){
			return false;
		}
		if (!referenceEquals(getQualifiedClassName(a), getQualifiedClassName(b))){
			return false;
		}
		if (a is Number && b is Number){
			return numericsEqual(a as Number, b as Number);
		}
		if (a is Date && b is Date){
			return numericsEqual((a as Date).getTime(), (b as Date).getTime());
		}
		if (a is Namespace && b is Namespace){
			return namespacesEqual(a as Namespace, b as Namespace);
		}
		if (a is QName && b is QName){
			return qnamesEqual(a as QName, b as QName);
		}
		if (a is XML && b is XML){
			return (a == b) ? true : false;
		}
		if (a is XMLList && b is XMLList){
			return (a == b) ? true : false;
		}
		var aReference:Boolean = references[a];
		var bReference:Boolean = references[b];
		if (aReference && bReference){
			return true;
		} else if (aReference || bReference){
			return false;
		}
		references[a] = true;
		references[b] = true;
		if (a is Array && b is Array){
			return arraysEqual(a as Array, b as Array, references);
		}
		if (a is ByteArray && b is ByteArray){
			return byteArraysEqual(a as ByteArray, b as ByteArray);
		}
		return referenceEquals(a, b);
	}

	private function referenceEquals(a:Object, b:Object):Boolean {
		return (a === b) ? true : false;
	}

	private function arraysEqual(a:Array, b:Array, references:Dictionary):Boolean {
		if (referenceEquals(a, b)){
			return true;
		} else {
			var key:Object;
			for (key in a){
				if (b.hasOwnProperty(key)){
					if (!objectsEqual(a[key], b[key], references)){
						return false;
					}
				} else {
					return false;
				}
			}
			for (key in b){
				if (!a.hasOwnProperty(key)){
					return false;
				}
			}
			return true;
		}
	}

	private function byteArraysEqual(a:ByteArray, b:ByteArray):Boolean {
		if (referenceEquals(a, b)){
			return true;
		} else {
			if (a.length != b.length){
				return false;
			} else {
				a.position = 0;
				b.position = 0;

				var len:int = a.length;
				for (var i:int = 0; i < len; i++){
					if (!numericsEqual(a.readByte(), b.readByte())){
						return false;
					}
				}
				return true;
			}
		}
	}

	private function namespacesEqual(a:Namespace, b:Namespace):Boolean {
		if (referenceEquals(a.prefix, b.prefix) && referenceEquals(a.uri, b.uri)){
			return true;
		} else {
			return false;
		}
	}

	private function qnamesEqual(a:QName, b:QName):Boolean {
		if (referenceEquals(a.localName, b.localName) && referenceEquals(a.uri, b.uri)){
			return true;
		} else {
			return false;
		}
	}

	private function numericsEqual(a:Number, b:Number):Boolean {
		if (referenceEquals(a, b) || isNaN(a) && isNaN(b)){
			return true;
		} else {
			return false;
		}
	}

}