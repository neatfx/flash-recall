//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {

	//TODO:优化数据结构，储存所有测试信息，封装（B2）
	internal final class TestResult {
		internal static var globalCasesNumber:uint; //测试用例总数
		internal static var globalTestedCasesNumber:uint; //已测试数目
		internal static var globalFailedCases:Array = []; //失败用例列表

		internal static var globalTestMethodsNumber:uint; //测试方法总数
		internal static var globalTestedMethodsNumber:uint; //已测试数目
		internal static var globalFailures:Array = []; //失败测试方法列表
		internal static var globalFailuresDetail:Array = []; //测试失败信息

		internal static var globalIgnoredTestMethods:Array = []; //忽略方法列表

		internal static var globalAssertionErrorsNumber:uint; //断言错误总数

		internal static var globalErrors:Array = []; //异常列表
		internal static var globalErrorsDetail:Array = []; //异常信息

		internal static var globalTestTime:uint; //测试耗时

		internal static var globalAsyncTests:Array = []; //异步测试列表
		internal static var globalTestedAsyncTestsNumber:uint; //已测试数目

		//public static var globalTestResult:Array = [];
		public var _testCaseName:String;
		//public var _testMethodsNumber:uint;
		//public var _ignoredTestMethodsNumber:uint;
		//public var _assertionsNumber:uint;
		//public var _assertionErrorsNumber:uint;
		public var _errorsNumber:uint;
		public var _failuresNumber:uint;

		//public var _failuresDetail:Array = [];

		public function TestResult(testCaseName:String){
			this._testCaseName = testCaseName;
			this._failuresNumber = TestResult.globalFailures.length;
			this._errorsNumber = TestResult.globalErrors.length;
			//TestResult.globalTestResult.push(this);
		}
	}
}