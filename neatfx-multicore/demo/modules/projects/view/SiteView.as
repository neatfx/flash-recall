/**
 *
 */
package modules.projects.view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import modules.projects.view.vc.Site;
	import modules.projects.event.ModuleEvent;

	public final class SiteView extends View {

		public function SiteView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
		}

		override protected function listEventInterests():Array {
			return [ModuleEvent.SITE_PAGE_CHANGED];
		}

		override protected function handleEvent(e:ControlEvent):void {
			site.chart.barColor = e.data.data[e.data.now].content;
		}

		private function get site():Site {
			return viewComponent as Site;
		}
	}
}