/**
 *
 */
package shell {

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import neatfx.modules.*;

	import shell.view.*;
	import shell.controller.*;
	import shell.model.*;
	import shell.event.ShellEvent;

	public final class Shell extends Module {

		public function Shell(){
			super("shell");
		}

		override public function creat():void {
			//舞台设置
			this.stage.scaleMode = StageScaleMode.NO_SCALE; //缩放模式
			this.stage.align = StageAlign.TOP; //对齐模式
			//模块管理器初始化
			new ModuleManager(this.stage);

			//addChild(new Stats());
			registerView(StageView, this.stage); //Stage可用
			registerController(LoadModuleController, new ShellEvent(ShellEvent.ADD_MODULE)); //用于加载模块
			registerController(UnloadModuleController, new ShellEvent(ShellEvent.REMOVE_MODULE)); //用于卸载模块
			//启动
			registerModel(SiteDataModel); //注册Model
		}
	}
}