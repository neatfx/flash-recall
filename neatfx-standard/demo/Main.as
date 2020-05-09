/**
 *
 */
package {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import neatfx.core.*;

	import view.*
	import model.*;
	import controller.*;
	import event.ModuleEvent;

	public final class Main extends Sprite {

		public function Main(){
			this.stage ? this.init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			//设置舞台
			this.stage.scaleMode = StageScaleMode.NO_SCALE; //缩放模式
			this.stage.align = StageAlign.TOP; //对齐模式
			//按需注册
			new StageView(this.stage); //注册View
			
			new TestController(new ModuleEvent(ModuleEvent.SITE_PAGE_CHANGED));
			Controller.removeController(TestController);
			//启动
			new SiteDataModel(null);
		}
	}
}