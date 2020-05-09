/**
 * 
 */
package modules.news.view {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import modules.news.view.vc.Site;
	import modules.news.event.ModuleEvent;

	public final class StageView extends View {

		public function StageView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
		}

		override protected function listEventInterests():Array {
			return [ModuleEvent.SITE_DATA_OK];
		}

		override protected function handleEvent(e:ControlEvent):void {
			var site:Site = new Site();
			registerView(SiteView,site);
			registerView(NavView,site.nav);
			this.viewComponent.addChild(site); //News.site
		}
	}
}