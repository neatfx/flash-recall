//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.net.URLRequest;

	public class TestSuite {
		protected static var _globalTestCases:Vector.<TestCase> = new Vector.<TestCase>();

		//TODO:重新加入对测试配置文件的支持（B2）
		public function TestSuite(testData:String = null){
			//var loader:Loader = new Loader();
			//loader.load(new URLRequest(testData));
		}

		public function addCase(testCase:Class):void {
			TestSuite._globalTestCases.push(new testCase());
		}

		public function addSuit(testSuit:Class):void {
			new testSuit();
		}

		public function run():void {
			//初始化
			TestResult.globalCasesNumber = TestSuite._globalTestCases.length;
			TestRunner.updateAsyncsInfo();
			TestRunner.updateProgress();
			TestSuite.setVisualTestEnvironment(TestRunner.visualTestDisplayRoot);
			//计时开始
			if (TestSuite._globalTestCases.length > 0){
				TestSuite._globalTestCases[0].run();
			}
		}

		internal static function runNextTestCase():void {
			TestSuite._globalTestCases.shift();
			if (TestSuite._globalTestCases.length > 0){
				TestSuite._globalTestCases[0].run();
			} else {
				//计时结束
				TestRunner.showFailures();
			}
		}

		private static function setVisualTestEnvironment(visualTestDisplayRoot:DisplayObjectContainer):void {
			for each (var test:TestCase in TestSuite._globalTestCases){
				test.visualTestDisplayRoot = visualTestDisplayRoot;
			}
		}
	}
}