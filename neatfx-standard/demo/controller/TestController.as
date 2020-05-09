package controller {
	import neatfx.core.Controller;
	import neatfx.event.ControlEvent;

	/**
	 * ...
	 * @author
	 */
	public final class TestController extends Controller {

		public function TestController(e:ControlEvent){
			super(e);
		}

		override protected function execute(e:ControlEvent):void {
			trace("TestController::" + e);
		}
	}

}