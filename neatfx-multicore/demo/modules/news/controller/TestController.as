/**
 *
 */
package modules.news.controller {

	import neatfx.core.*;
	import neatfx.event.ControlEvent;

	public final class TestController extends Controller {

		public function TestController(e:ControlEvent, tag:String = null){
			super(e,tag);
		}

		override protected function execute(e:ControlEvent):void {
			//trace(this);//仅在debug时输出
			//MonsterDebugger.trace(this, this);//De Monster Debugger
			//Debug.trace(this);//Alcon
		}
	}
}