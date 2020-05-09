//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {
	import com.bit101.components.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.fscommand;

	public final class TestRunner extends Sprite {
		//TODO:改进详情窗口，使用List、着色、过滤、中文支持(B2)
		//TODO:结果窗口改用多List，避免重复读写数据&重绘闪烁，增加过滤功能（B2）
		//TODO:更换默认嵌入字体（B2）
		//TODO:改进测试信息的实时更新，优化代码，减少消耗(B2)
		private static var _infoWin:Window;
		private static var _progressBar:ProgressBar;
		private static var _progressInfoLabel:Label;
		private static var _globalFailuresNumberLabel:Label;
		private static var _globalErrorsNumberLabel:Label;
		private static var _globalIgnoredTestMethodsNumberLabel:Label;
		private static var _globalAsyncTestInfoLabel:Label;
		private static var _globalTestCasesNumberLabel:Label;
		private static var _globalTestTimeLabel:Label;

		private static var _detailWin:Window;
		//private static var _showMoreInfo:CheckBox
		private static var _detailTextArea:TextArea;

		private static var _testResultWin:Window;
		private static var _testResultWinHBox:HBox;
		private static var _testResultList:List;
		private static var _showStatus:String;

		internal static var visualTestDisplayRoot:DisplayObjectContainer;

		public function TestRunner(){
			fscommand("showmenu", "false"); //RESIZE/安全沙箱
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			TestRunner.visualTestDisplayRoot = this.stage;
			creatUI();
		}

		private function creatUI():void {
			_infoWin = new Window(stage, 5, 5, "NeatUnit GUI Runner *");
			_infoWin.content.parent.filters = [];
			_infoWin.draggable = false;
			_infoWin.setSize(111, 190);
			var _testInfoWin_vbox:VBox = new VBox(_infoWin.content, 6, 7);
			_testInfoWin_vbox.spacing = 3;
			_progressBar = new ProgressBar(_testInfoWin_vbox);
			_progressInfoLabel = new Label(_testInfoWin_vbox, 0, 0, "Runs :  ");
			_globalFailuresNumberLabel = new Label(_testInfoWin_vbox, 0, 0, "Failures : 0");
			_globalErrorsNumberLabel = new Label(_testInfoWin_vbox, 0, 0, "  Errors : ");
			_globalIgnoredTestMethodsNumberLabel = new Label(_testInfoWin_vbox, 0, 0, " Ignored : ");
			_globalAsyncTestInfoLabel = new Label(_testInfoWin_vbox, 0, 0, " Asynch : ");
			_globalTestCasesNumberLabel = new Label(_testInfoWin_vbox, 0, 0, "Cases : 0,0,0");
			_globalTestTimeLabel = new Label(_testInfoWin_vbox, 0, 0, "Duration : 0 s");

			_detailWin = new Window(stage, 120, 5, "Failure Trace ( debugger version of Flash Player required )");
			_detailWin.content.parent.filters = [];
			_detailWin.draggable = false;
			//_showMoreInfo = new CheckBox(_detailWin.titleBar, 0, 5, "MoreInfo", null);
			//_detailWin.setSize(stage.stageWidth - _infoWin.width - 16, _infoWin.height);
			//_showMoreInfo.x = _testResultWin.width - 175;
			_detailTextArea = new TextArea(_detailWin.content, 3, 3);
			//_detailTextArea.setSize(_detailWin.width - 6, _detailWin.height - 26);

			_testResultWin = new Window(stage, 5, _infoWin.height + 10, "TestResult");
			_testResultWin.content.parent.filters = [];
			//_testResultWin.setSize(stage.stageWidth - 12, stage.stageHeight - _infoWin.height - 16);
			_testResultWin.draggable = false;
			_testResultWinHBox = new HBox(_testResultWin.titleBar, 5, 5);
			new RadioButton(_testResultWinHBox, 0, 0, "Failures", true, showFailures);
			new RadioButton(_testResultWinHBox, 0, 0, "Errors", false, showErrors);
			new RadioButton(_testResultWinHBox, 0, 0, "Ignored", false, showIgnored);
			new RadioButton(_testResultWinHBox, 0, 0, "Asynch", false, showAsynch);
			new RadioButton(_testResultWinHBox, 0, 0, "Cases", false, showCases);
			//_testResultWinHBox.x = _testResultWin.width - 250;
			_testResultList = new List(_testResultWin.content, 3, 3);
			_testResultList.alternateRows = true;
			_testResultList.selectedColor = 0xbbbbbb;
			_testResultList.alternateColor = 0xdddddd;
			_testResultList.rolloverColor = 0xcccccc;
			_testResultList.defaultColor = 0xf0f0f0;
			_testResultList.addEventListener(Event.SELECT, onResultItemSelect);
			//_testResultList.setSize(_testResultWin.width - 6, _testResultWin.height - 26);
		}

		private function onStageResize(e:Event):void {
			TestRunner._detailWin.setSize(stage.stageWidth - _infoWin.width - 16, _infoWin.height);
			TestRunner._detailTextArea.setSize(_detailWin.width - 6, _detailWin.height - 26);
			TestRunner._testResultWin.setSize(stage.stageWidth - 12, stage.stageHeight - _infoWin.height - 17);
			TestRunner._testResultWinHBox.x = _testResultWin.width - 250;
			TestRunner._testResultList.setSize(_testResultWin.width - 6, _testResultWin.height - 26);
			//TestRunner._showMoreInfo.x = _testResultWin.width - 175;
		}

		private function onResultItemSelect(e:Event):void {
			TestRunner._detailTextArea.text = "";
			switch (_showStatus){
				case "showFailures":
					for (var k:uint = 0; k < TestResult.globalFailuresDetail[e.target.selectedIndex].length; ++k){
						TestRunner._detailTextArea.text += TestResult.globalFailuresDetail[e.target.selectedIndex][k] + "\n\n";
					}
					break;
				case "showErrors":
					TestRunner._detailTextArea.text = TestResult.globalErrorsDetail[e.target.selectedIndex];
					break;
				default:
					TestRunner._detailTextArea.text = "";
			}
		}

		private function showErrors(e:Event):void {
			TestRunner._detailTextArea.text = "";
			TestRunner._showStatus = "showErrors";
			TestRunner._testResultList.items = TestResult.globalErrors;
		}

		private function showIgnored(e:Event):void {
			TestRunner._detailTextArea.text = "";
			TestRunner._showStatus = "showIgnored";
			TestRunner._testResultList.items = TestResult.globalIgnoredTestMethods;
		}

		private function showAsynch(e:Event):void {
			TestRunner._detailTextArea.text = "";
			TestRunner._showStatus = "showAsynch";
			TestRunner._testResultList.items = TestResult.globalAsyncTests;
		}

		private function showCases(e:Event):void {
			TestRunner._detailTextArea.text = "";
			TestRunner._showStatus = "showCases";
			TestRunner._testResultList.items = TestResult.globalFailedCases;
		}

		internal static function updateProgress():void {
			TestRunner._progressBar.value = TestResult.globalTestedMethodsNumber / TestResult.globalTestMethodsNumber;
			TestRunner._progressInfoLabel.text = "Runs :  " + TestResult.globalTestedMethodsNumber + " / " + TestResult.globalTestMethodsNumber;
			TestRunner._globalIgnoredTestMethodsNumberLabel.text = " Ignored :  " + TestResult.globalIgnoredTestMethods.length;
			TestRunner._globalErrorsNumberLabel.text = "  Errors :  " + TestResult.globalErrors.length;
			TestRunner._globalTestCasesNumberLabel.text = "Cases : " + TestResult.globalFailedCases.length + " / " + TestResult.globalTestedCasesNumber + " / " + TestResult.globalCasesNumber;
		}

		internal static function updateFailureInfo():void {
			TestRunner._globalFailuresNumberLabel.text = "Failures :  " + TestResult.globalFailures.length;
		}

		internal static function updateAssertionErrorInfo():void {
			TestRunner._testResultWin.title = "Assertion Failed Errors :  " + TestResult.globalAssertionErrorsNumber;
		}

		internal static function updateAsyncsInfo():void {
			TestRunner._globalAsyncTestInfoLabel.text = " Asynch :  " + TestResult.globalTestedAsyncTestsNumber + " / " + TestResult.globalAsyncTests.length;
		}

		internal static function updateTimeInfo():void {
			TestRunner._globalTestTimeLabel.text = "Duration : " + String(TestResult.globalTestTime / 1000 + " s");
		}

		internal static function showFailures(e:Event = null):void {
			TestRunner._detailTextArea.text = "";
			TestRunner._showStatus = "showFailures";
			TestRunner._testResultList.items = TestResult.globalFailures;
		}
	}
}