/**
 *
 */
package shell.controller {

	import common.AppEvent;
	import neatfx.core.*;
	import neatfx.event.ControlEvent;
	import neatfx.modules.ModuleManager;

	public final class LoadModuleController extends Controller {

		public function LoadModuleController(e:ControlEvent){
			super(e);
		}

		override protected function execute(e:ControlEvent):void {
			ModuleManager.loadModule("News.swf", {onComplete: completeHandler});
		}

		private function completeHandler(e:Object):void {
			ModuleManager.loadModule("Projects.swf", new Object());
			sendEvent(new AppEvent(AppEvent.STARTUP, null, true)); //模块通信
			sendEvent(new AppEvent(AppEvent.START, null, true)); //模块通信
		}
	}
}