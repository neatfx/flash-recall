/**
 *
 */
package shell.view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import shell.view.vc.Site;
	import shell.event.ShellEvent;

	public final class SiteView extends View {

		public function SiteView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
		}

		override protected function listEventInterests():Array {
			return [ShellEvent.SITE_PAGE_CHANGED];
		}

		override protected function handleEvent(e:ControlEvent):void {
			site.tip.text = e.data.data[e.data.now].content; //根据NavView的currentSection值更新显示
		}

		private function get site():Site {
			return viewComponent as Site;
		}
	}
}