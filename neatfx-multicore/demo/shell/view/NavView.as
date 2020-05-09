/**
 *
 */
package shell.view {

	import shell.model.SiteDataModel;
	import flash.events.MouseEvent;
	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	import shell.view.vc.Nav;
	import shell.event.ShellEvent;

	public final class NavView extends View {

		private var currentSection:String;

		public function NavView(viewComponent:Object, coreId:String){
			super(viewComponent, coreId);
			//初始化Nav
			var _data:Object = retrieveModel(SiteDataModel).data; //取回SiteDataModel并获得其数据
			currentSection = _data.navs[0].id; //初始选择项
			this.nav.init(_data.navs); //初始化Nav
			this.nav.update(currentSection); //设置默认选择项目
			sendEvent(new ShellEvent(ShellEvent.SITE_PAGE_CHANGED, {"now": currentSection, "data": _data})); //广播事件
			this.nav.addEventListener(MouseEvent.MOUSE_DOWN, onNavButtonPressed); //处理导航菜单事件
		}

		//处理Nav鼠标事件
		private function onNavButtonPressed(e:MouseEvent):void {
			if (e.target.label != currentSection){
				currentSection = e.target.label;
				(currentSection == "LOAD MODULES") ? sendEvent(new ShellEvent(ShellEvent.ADD_MODULE, null, true)) : sendEvent(new ShellEvent(ShellEvent.REMOVE_MODULE, null, true)); //广播事件
				var _data:Object = retrieveModel(SiteDataModel).data; //取回SiteDataModel并获得其数据
				sendEvent(new ShellEvent(ShellEvent.SITE_PAGE_CHANGED, {"now": currentSection, "data": _data})); //广播事件
			}
		}

		override protected function listEventInterests():Array {
			return [ShellEvent.SITE_PAGE_CHANGED];
		}

		override protected function handleEvent(e:ControlEvent):void {
			nav.update(currentSection); //更新Nav显示状态
		}

		private function get nav():Nav {
			return viewComponent as Nav;
		}
	}
}