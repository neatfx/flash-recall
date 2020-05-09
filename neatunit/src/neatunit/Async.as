//////////////////////////////////////////////////////////
// NeatUnit Beta 1
// Copyright (c) 2008-2010 Peter Sheen
// http://code.google.com/p/neatunit
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatunit {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	import flash.utils.Timer;

	//TODO:补充异步方法，重构（B2）
	public class Async {
		private static var hasError:Boolean;
		private static var currentTestCase:TestCase;

		//基础异步处理方法
		public static function handleEvent(testCase:TestCase, target:IEventDispatcher, eventName:String, eventHandler:Function, timeout:int = 500, passThroughData:Object = null):void {
			Async.currentTestCase = testCase;
			target.addEventListener(eventName, callback);
			var outTimer:Timer = new Timer(timeout, 1);
			outTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			outTimer.start();
			function callback(e:Event):void {
				e.target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				try {
					eventHandler(passThroughData);
				} catch (err:Error){
					hasError = true;
					TestResult.globalErrors.push(testCase.className + " :: " + testCase.currentMethod);
					TestResult.globalErrorsDetail.push(err.getStackTrace());
				} finally {
					clear();
				}
			}
			function onTimeout(e:TimerEvent):void {
				target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				Assert.fail("Asynchronous test timeout !" + new Error().getStackTrace().substr(5));
				clear();
			}
		}

		//类似handleEvent，该方法返回Function可用于注册事件侦听
		public static function asyncHandler(testCase:TestCase, eventHandler:Function, timeout:uint = 500, passThroughData:Object = null):Function {
			Async.currentTestCase = testCase;
			var isTimeout:Boolean;
			var outTimer:Timer = new Timer(timeout, 1);
			outTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			outTimer.start();
			var callback:Function = function(e:Event):void {
				e.target.removeEventListener(e.type, callback);
				if (!isTimeout){
					outTimer.stop();
					outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
					outTimer = null;
					try {
						eventHandler(passThroughData);
					} catch (err:Error){
						hasError = true;
						TestResult.globalErrors.push(testCase.className + " :: " + testCase.currentMethod);
						TestResult.globalErrorsDetail.push(err.getStackTrace());
					} finally {
						clear();
					}
				}
			}
			function onTimeout(e:TimerEvent):void {
				isTimeout = true;
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				Assert.fail("Asynchronous test timeout !" + new Error().getStackTrace().substr(5));
				clear();
			}
			return callback;
		}

		//接收指定事件后标记当前测试失败
		public static function failOnEvent(testCase:TestCase, target:IEventDispatcher, eventName:String, timeout:uint = 500):void {
			Async.currentTestCase = testCase;
			target.addEventListener(eventName, callback);
			var outTimer:Timer = new Timer(timeout, 1);
			outTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			outTimer.start();
			function callback(e:Event):void {
				target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				Assert.fail("Asynchronous failOnEvent !" + new Error().getStackTrace().substr(5));
				clear();
			}
			function onTimeout(e:TimerEvent):void {
				target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				Assert.fail("Asynchronous test timeout !" + new Error().getStackTrace().substr(5));
				clear();
			}
		}

		//确认接收到指定事件后继续测试
		public static function proceedOnEvent(testCase:TestCase, target:IEventDispatcher, eventName:String, timeout:uint = 500):void {
			Async.currentTestCase = testCase;
			target.addEventListener(eventName, callback);
			var outTimer:Timer = new Timer(timeout, 1);
			outTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			outTimer.start();
			function callback(e:Event):void {
				target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				clear();
			}
			function onTimeout(e:TimerEvent):void {
				target.removeEventListener(eventName, callback);
				outTimer.stop();
				outTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				outTimer = null;
				Assert.fail("Asynchronous test timeout !" + new Error().getStackTrace().substr(5));
				clear();
			}
		}

		//public static function asyncNativeResponder(testCase:TestCase, result:Function, fault:Function, timeout:int, passThroughData:Object = null):Responder {
		//return null;
		//}

		//private static function onTimeout(e:TimerEvent):void {
		//e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
		//Assert.fail("Asynchronous test timeout !" + new Error().getStackTrace().substr(5));
		//clear();
		//}

		private static function clear():void {
			var testCase:TestCase = Async.currentTestCase;
			testCase.tearDown();
			if (TestCase._errors.length > 0 && !hasError){
				TestResult.globalFailures.push("< Errors: " + TestCase._errors.length + " >  " + testCase.className + " :: " + testCase.currentMethod);
				TestResult.globalFailuresDetail.push(TestCase._errors);
				TestRunner.updateFailureInfo();
				TestResult.globalAssertionErrorsNumber += TestCase._errors.length;
				TestRunner.updateAssertionErrorInfo();
			}
			Async.hasError = false;
			++TestResult.globalTestedMethodsNumber;
			++TestResult.globalTestedAsyncTestsNumber;
			TestRunner.updateProgress();
			TestRunner.updateAsyncsInfo();
			testCase.testMethods.shift();
			setTimeout(function():void { //debug
					TestCase._waitForAsyncTest = false;
				}, 5);
		}
	}
}