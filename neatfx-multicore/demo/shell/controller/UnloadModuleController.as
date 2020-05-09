/**
 * 
 */
package shell.controller{
	
	import neatfx.core.*;
	import neatfx.event.ControlEvent;
	import neatfx.modules.ModuleManager;
	
	public final class UnloadModuleController extends Controller {
		
		public function UnloadModuleController(e:ControlEvent) {
			super(e);
		}
		
		override protected function execute(e:ControlEvent):void {
			ModuleManager.unloadModule("News.swf");
			ModuleManager.unloadModule("Projects.swf");
		}
	}
}