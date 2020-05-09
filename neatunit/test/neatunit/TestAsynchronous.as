package neatunit {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	import flash.utils.Timer;

	public final class TestAsynchronous extends TestCase {
		protected var timer:Timer;
		protected static var SHORT_TIME:int = 30; //30
		protected static var LONG_TIME:int = 50;
		protected var instance:Sprite;

		override public function setUp():void {
			instance = new Sprite();
			timer = new Timer(LONG_TIME, 1);
		}

		override public function tearDown():void {
			if (timer){
				timer.stop();
			}
			timer = null;
			removeChild(instance);
		}

		/**
		 * 异步方法:asyncHandler(9)
		 */
		public function _inTimePassTest():void {
			timer.delay = SHORT_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldPass, LONG_TIME), false, 0, true);
			timer.start();
		}

		public function _inTimeFailTest():void {
			timer.delay = SHORT_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldPassCallFail, LONG_TIME), false, 0, true);
			timer.start();
		}

		public function _inTimeErrorTest():void {
			timer.delay = SHORT_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldPassCauseError, LONG_TIME), false, 0, true);
			timer.start();
		}

		public function _inTimePassTest2():void {
			instance.addEventListener(Event.ADDED, Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			addChild(instance);
		}

		public function _inTimePassTest3():void {
			instance.addEventListener(Event.ADDED, Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			addChild(instance);
		}

		public function _inTimePassTest4():void {
			instance.addEventListener(Event.ADDED, Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			addChild(instance);
		}

		public function _inTimePassTest5():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _inTimePassTest6():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _inTimePassTest7():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		//超时(8)
		public function _tooLatePassTest():void {
			timer.delay = LONG_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldNotPass, SHORT_TIME), false, 0, true);
			timer.start();
		}

		public function _tooLateFailTest():void {
			timer.delay = LONG_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldNotPass, SHORT_TIME), false, 0, true);
			timer.start();
		}

		public function _tooLateErrorTest():void {
			timer.delay = LONG_TIME;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, handleAsyncShouldNotPass, SHORT_TIME), false, 0, true);
			timer.start();
		}

		public function _tooLatePassTest2():void {
			instance.addEventListener(Event.ADDED, Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			//addChild(instance);
		}

		public function _tooLatePassTest3():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			//eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _asyncHandlerTest9():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		public function _asyncHandlerTest10():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		public function _asyncHandlerTest11():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, handleAsyncShouldPass, SHORT_TIME), false, 0, true);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		//传参测试
		public function _asyncHandlerPassThroughDataOnSuccessTest():void {
			var passThroughData:Object = new Object();
			passThroughData.projectName = "NeatUnit";
			passThroughData.author = "Peter Sheen";

			var eventDispatcher:EventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener('immediate', Async.asyncHandler(this, checkPassThroughDataOnSuccess, SHORT_TIME, passThroughData), false, 0, true);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		//测试EventData
		public function _eventDataTest():void {
			fail("Test method Not yet implemented", true);
		}

		/**
		 * 异步方法:failOnEvent
		 */
		public function _failOnEventTest():void {
			Async.failOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _failOnEventTest2():void {
			Async.failOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _failOnEventTest3():void {
			Async.failOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _failOnEventTest4():void {
			Async.failOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _failOnEventTest5():void {
			Async.failOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _failOnEventTest6():void {
			Async.failOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _failOnEventTest7():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.failOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _failOnEventTest8():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.failOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			//eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		//延时调度事件
		public function _failOnEventTest9():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.failOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		public function _failOnEventTest10():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.failOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		public function _failOnEventTest11():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.failOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		/**
		 * 异步方法:proceedOnEvent
		 */
		public function _proceedOnEventTest():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _proceedOnEventTest2():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _proceedOnEventTest3():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, SHORT_TIME);
			addChild(instance);
		}

		public function _proceedOnEventTest4():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _proceedOnEventTest5():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _proceedOnEventTest6():void {
			Async.proceedOnEvent(this, instance, Event.ADDED, LONG_TIME);
			//addChild(instance);
		}

		public function _proceedOnEventTest7():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _proceedOnEventTest8():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			//eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		//延时调度事件
		public function _proceedOnEventTest9():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		public function _proceedOnEventTest10():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		public function _proceedOnEventTest11():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, eventDispatcher, 'immediate', LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 300);
		}

		/**
		 * 异步方法:handleEvent
		 */
		public function _handleEventTest():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldPass, SHORT_TIME);
			addChild(instance);
		}

		public function _handleEventTest2():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldPass, SHORT_TIME);
			addChild(instance);
		}

		public function _handleEventTest3():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldPass, SHORT_TIME);
			addChild(instance);
		}

		public function _handleEventTest4():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldNotPass, SHORT_TIME);
			//addChild(instance);
		}

		public function _handleEventTest5():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldNotPass, SHORT_TIME);
			//addChild(instance);
		}

		public function _handleEventTest6():void {
			Async.handleEvent(this, instance, Event.ADDED, handleEventShouldNotPass, SHORT_TIME);
			//addChild(instance);
		}

		public function _handleEventTest7():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', handleEventShouldPass, LONG_TIME);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		public function _handleEventTest8():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', handleEventShouldNotPass, LONG_TIME);
			//eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		//延时调度事件
		public function _handleEventTest9():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', handleEventShouldNotPass, LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		public function _handleEventTest10():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', handleEventShouldNotPass, LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		public function _handleEventTest11():void {
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', handleEventShouldNotPass, LONG_TIME);
			setTimeout(function():void {
					eventDispatcher.dispatchEvent(new Event('immediate'))
				}, 500);
		}

		//传参测试
		public function _handleEventPassThroughDataOnSuccessTest():void {
			var passThroughData:Object = new Object();
			passThroughData.projectName = "NeatUnit";
			passThroughData.author = "Peter Sheen";

			var eventDispatcher:EventDispatcher = new EventDispatcher();
			Async.handleEvent(this, eventDispatcher, 'immediate', checkPassThroughDataOnSuccess, LONG_TIME, passThroughData);
			eventDispatcher.dispatchEvent(new Event('immediate'));
		}

		/**
		 * 异步方法:asyncResponder
		 */
		public function _asyncNativeResponderTest():void {
			fail("Test method Not yet implemented", true);
			//var responder:Responder = Async.asyncResponder(this, handleIntendedResult, handleUnintendedFault, 50, someVO);
		}

		/**
		 * 辅助方法
		 */
		private function handleAsyncShouldPass(passThroughData:Object):void {
			assertTrue(true);
		}

		private function handleAsyncShouldPassCallFail(passThroughData:Object):void {
			assertTrue(false);
		}

		private function handleAsyncShouldPassCauseError(passThroughData:Object):void {
			throw new Error("AsyncInTimeError");
		}

		private function handleAsyncShouldNotPass(passThroughData:Object):void {
			throw new Error("This method should not be executed.");
		}

		private function handleEventTestPass(passThroughData:Object):void {
		}

		private function checkPassThroughDataOnSuccess(passThroughData:Object):void {
			assertEqual(passThroughData.projectName, "NeatUnit");
			assertEqual(passThroughData.author, "Peter Sheen");
		}

		private function handleEventShouldPass(passThroughData:Object):void {
			assertTrue(true);
		}

		private function handleEventShouldNotPass(passThroughData:Object):void {
			throw new Error("This method should not be called.");
		}
	}

}