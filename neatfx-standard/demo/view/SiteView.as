/**
 *
 */
package view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import view.vc.Site;
	import event.ModuleEvent;

	public final class SiteView extends View {

		public function SiteView(viewComponent:Object){
			super(viewComponent);
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