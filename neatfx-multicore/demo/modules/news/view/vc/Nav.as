/**
 *
 */
package modules.news.view.vc {

	import com.bit101.components.RadioButton;
	import flash.display.Sprite;

	public final class Nav extends Sprite {

		private var navBtns:Array = [new RadioButton(null, 0, 5), new RadioButton(null, 0, 5), new RadioButton(null, 0, 5), new RadioButton(null, 0, 5)];

		public function Nav(){
		}

		public function init(navs:Array):void {
			var navLen:uint = navs.length;
			var btn:RadioButton;
			for (var i:uint = 0; i < navLen; i++){
				navBtns[i].x = 70 * i + 5;
				navBtns[i].label = navs[i].id;
				this.addChild(navBtns[i]);
			}
		}

		public function update(s:String):void {
			for (var i:uint = 0; i < navBtns.length; i++){
				var btn:RadioButton = navBtns[i];
				if (btn.label == s)
					btn.selected = true;
			}
		}
	}

}