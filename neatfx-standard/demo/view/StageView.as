/**
 *
 */
package view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import view.vc.Site;
	import event.ModuleEvent;

	public final class StageView extends View {

		public function StageView(viewComponent:Object){
			super(viewComponent);
		}

		override protected function listEventInterests():Array {
			return [ModuleEvent.SITE_DATA_OK];
		}

		override protected function handleEvent(e:ControlEvent):void {
			var site:Site = new Site();
			new SiteView(site);
			new NavView(site.nav);
			this.viewComponent.addChild(site);
		}
	}
}