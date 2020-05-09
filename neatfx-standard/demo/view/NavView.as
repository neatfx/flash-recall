/**
 *
 */
package view {

	import flash.events.MouseEvent;
	
	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import view.vc.Nav;
	import event.ModuleEvent;
	import model.SiteDataModel;

	public final class NavView extends View {

		private var currentSection:String;

		public function NavView(viewComponent:Object){
			super(viewComponent);
			//初始化Nav:VC
			var _data:Object = retrieveModel(SiteDataModel).data; //取回SiteDataModel并获得其数据
			currentSection = _data.navs[0].id; //初始选择项
			this.nav.init(_data.navs); //初始化Nav:VC
			this.nav.update(currentSection); //设置默认选择项目
			sendEvent(new ModuleEvent(ModuleEvent.SITE_PAGE_CHANGED, {"now": currentSection, "data": _data})); //应用程序视图范围内广播事件
			this.nav.addEventListener(MouseEvent.MOUSE_DOWN, onNavButtonPressed); //处理导航菜单事件
		}

		//处理Nav:VC鼠标事件
		private function onNavButtonPressed(e:MouseEvent):void {
			if (e.target.label != currentSection){
				currentSection = e.target.label;
				var _data:Object = retrieveModel(SiteDataModel).data; //取回SiteDataModel并获得其数据
				sendEvent(new ModuleEvent(ModuleEvent.SITE_PAGE_CHANGED, {"now": currentSection, "data": _data}, true)); //应用程序视图范围内广播事件
			}
		}

		//注册监听事件
		override protected function listEventInterests():Array {
			return [ModuleEvent.SITE_PAGE_CHANGED]; //事件列表
		}

		//分类处理事件
		override protected function handleEvent(e:ControlEvent):void {
			nav.update(currentSection); //调用Nav:VC的方法更新当前显示状态
		}

		private function get nav():Nav {
			return viewComponent as Nav;
		}
	}
}