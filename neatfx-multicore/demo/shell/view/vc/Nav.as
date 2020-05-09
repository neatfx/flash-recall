/**
 *
 */
package shell.view.vc {

	import flash.display.Sprite;
	import com.bit101.components.*;

	public final class Nav extends Sprite {

		private var navBtns:Array = [new PushButton(null, 0, 5), new PushButton(null, 0, 5), new PushButton(null, 0, 5)];

		public function Nav(){
		}

		public function init(navs:Array):void {
			var navLen:uint = navs.length;
			var btn:PushButton;
			for (var i:uint = 0; i < navLen; i++){
				navBtns[i].x = 105 * i + 5;
				navBtns[i].label = navs[i].id;
				this.addChild(navBtns[i]);
			}
		}

		public function update(s:String):void {
			for (var i:uint = 0; i < navBtns.length; i++){
			}
		}
	}

}