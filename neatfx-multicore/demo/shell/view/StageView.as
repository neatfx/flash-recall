/**
 *
 */
package shell.view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import flash.display.Stage;

	import shell.view.vc.Site;
	import shell.event.ShellEvent;

	public final class StageView extends View {

		public function StageView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
		}

		override protected function listEventInterests():Array {
			return [ShellEvent.SITE_DATA_OK]; //事件列表
		}

		override protected function handleEvent(e:ControlEvent):void {
			var site:Site = new Site();
			registerView(SiteView, site);
			registerView(NavView, site.nav);
			this.stage.addChild(site); //Stage.addChild(site)
		}

		private function get stage():Stage {
			return viewComponent as Stage;
		}
	}
}