/**
 * 
 */
package modules.news.controller{
	
	import neatfx.core.*;
	import neatfx.event.ControlEvent;
	
	import modules.news.model.*;
	
	public final class StartupController extends Controller {
		
		public function StartupController(e:ControlEvent, tag:String = null) {
			super(e,tag);
		}
		
		override protected function execute(e:ControlEvent):void {
			registerModel(SiteDataModel);
		}
	}
}