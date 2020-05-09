//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	//TODO:重构，改进异步处理机制，使用旧方案？（B2）
	public class TestCase extends Assert {
		protected var _className:String;
		protected var _testMethods:Array = [];
		public static var _waitForAsyncTest:Boolean; //异步处理标志
		protected var _currentMethod:String; //当前测试方法
		protected var _visualTestDisplayRoot:DisplayObjectContainer; //可视化测试根显示容器

		protected var testResult:TestResult;
		public static var _errors:Array = []; //测试结果缓存

		public function TestCase(testMethod:Array = null){
			if (this["constructor"] == TestCase){
				throw new IllegalOperationError("Abstract " + TestCase + " should not be instantiated !");
			}
			var description:XML = describeType(this);
			this._className = description.@name.split("::").join(".");
			if (testMethod){ //指定测试方法以及测试顺序
				this._testMethods = testMethod;
				TestResult.globalTestMethodsNumber += testMethod.length;
				return;
			}
			var methods:XMLList = description..method;
			var len:uint = methods.length();
			TestResult.globalTestMethodsNumber += len - 3; //忽略“run”、"setUp"、"tearDown"
			for (var i:int = 0; i < len; i++){
				var methodName:String = methods[i].@name;
				if (methodName == "run" || methodName == "setUp" || methodName == "tearDown"){ //忽略
					continue;
				}
				if (methodName.charAt(0) == "_"){ //异步测试方法
					TestResult.globalAsyncTests.push(this._className + " :: " + methodName);
				}
				this._testMethods.push(methodName);
			}
		}

		private function checkCaseStatus():void {
			this.testResult._failuresNumber = TestResult.globalFailures.length - this.testResult._failuresNumber;
			this.testResult._errorsNumber = TestResult.globalErrors.length - this.testResult._errorsNumber
			if (this.testResult._failuresNumber || this.testResult._errorsNumber){ //测试失败
				var str:String = "< Errors: " + this.testResult._errorsNumber + " >  " + "< Failures: " + this.testResult._failuresNumber + " >  ";
				TestResult.globalFailedCases.push(str.concat(this._className));
			}
			++TestResult.globalTestedCasesNumber;
			TestRunner.updateProgress();
		}

		private static function calculateTimeTaken():void {
			TestResult.globalTestTime += (getTimer() - TestResult.globalTestTime);
			TestRunner.updateTimeInfo();
		}

		private function runBare():void {
			if (this._testMethods.length == 0){
				this.afterClass();
				this.checkCaseStatus();
				TestCase.calculateTimeTaken();
				TestSuite.runNextTestCase(); //测试下一个TestCase
			} else {
				if (TestCase._waitForAsyncTest){
					setTimeout(this.runBare, 5);
				} else {
					this._currentMethod = this._testMethods[0];
					TestCase.calculateTimeTaken();
					runMethod(this._testMethods[0]);
				}
			}
		}

		private function runMethod(methodName:String = null):void {
			var methodName:String = this._currentMethod;
			TestCase._errors = []; //清空结果缓存
			var hasError:Boolean;
			this.setUp();
			try {
				if (methodName.charAt(methodName.length - 1) == "_"){ //忽略
					if (methodName.charAt(0) == "_"){
						++TestResult.globalTestedAsyncTestsNumber;
						TestRunner.updateAsyncsInfo();
					}
					TestResult.globalIgnoredTestMethods.push(this._className + " :: " + methodName);
				} else {
					if (methodName.charAt(0) == "_"){
						TestCase._waitForAsyncTest = true; //设置异步处理标志
					}
					this[methodName]();
				}
			} catch (err:Error){
				hasError = true;
				this.tearDown();
				TestResult.globalErrors.push(this._className + " :: " + methodName);
				TestResult.globalErrorsDetail.push(err.getStackTrace());
				if (TestCase._waitForAsyncTest){
					++TestResult.globalTestedAsyncTestsNumber;
					TestRunner.updateAsyncsInfo();
					TestCase._waitForAsyncTest = false;
				}
				++TestResult.globalTestedMethodsNumber;
				TestRunner.updateProgress();
				this._testMethods.shift(); //测试后移除
			} finally {
				if (!TestCase._waitForAsyncTest && !hasError && TestCase._errors.length > 0){
					TestResult.globalFailures.push("< Errors: " + TestCase._errors.length + " >  " + this._className + " :: " + this._currentMethod);
					TestResult.globalFailuresDetail.push(TestCase._errors);
					TestRunner.updateFailureInfo();
					TestResult.globalAssertionErrorsNumber += TestCase._errors.length;
					TestRunner.updateAssertionErrorInfo();
				}
				if (!TestCase._waitForAsyncTest && !hasError){
					this.tearDown();
					this._testMethods.shift(); //测试后移除
					++TestResult.globalTestedMethodsNumber;
					TestRunner.updateProgress();
				}
				this.runBare();
			}
		}

		public function run():void {
			this.beforeClass();
			testResult = new TestResult(this._className); //此时为正确初始值
			TestCase.calculateTimeTaken(); //计时
			this.runBare();
		}

		public function setUp():void {
		}

		public function tearDown():void {
		}

		protected function beforeClass():void {
		}

		protected function afterClass():void {
		}

		protected function addChild(child:DisplayObject):DisplayObject {
			return this._visualTestDisplayRoot.addChild(child);
		}

		protected function removeChild(child:DisplayObject):DisplayObject {
			if (child == null){
				return null;
			}
			try {
				return this._visualTestDisplayRoot.removeChild(child);
			} catch (e:Error){
			}
			return null;
		}

		/**
		 * Setter & Getter
		 */
		public function set visualTestDisplayRoot(visualTestDisplayRoot:DisplayObjectContainer):void {
			this._visualTestDisplayRoot = visualTestDisplayRoot;
		}

		public function get className():String {
			return _className;
		}

		public function get currentMethod():String {
			return _currentMethod;
		}

		public function get testMethods():Array {
			return _testMethods;
		}
	}
}