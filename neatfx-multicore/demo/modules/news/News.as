/**
 *
 */
package modules.news {

	//import demo.modules.news.model.SiteDataModel;
	import neatfx.modules.Module;

	import common.AppEvent;
	import modules.news.controller.*;
	import modules.news.view.*;

	public final class News extends Module {

		//该模块由Shell发送模块事件启动
		public function News(){
			super("news", 250, 200);
		}

		override public function creat():void {
			registerController(TestController, new AppEvent(AppEvent.START));
			registerController(StartupController, new AppEvent(AppEvent.STARTUP));
			registerView(StageView, this);
			//registerModel(SiteDataModel);
		}
	}
}