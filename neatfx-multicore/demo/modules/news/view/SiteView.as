/**
 *
 */
package modules.news.view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import modules.news.view.vc.Site;
	import modules.news.event.ModuleEvent;

	public final class SiteView extends View {

		public function SiteView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
		}

		override protected function listEventInterests():Array {
			return [ModuleEvent.SITE_PAGE_CHANGED]; //事件列表
		}

		override protected function handleEvent(e:ControlEvent):void {
			site.chart.barColor = e.data.data[e.data.now].content;
		}

		private function get site():Site {
			return viewComponent as Site;
		}
	}
}