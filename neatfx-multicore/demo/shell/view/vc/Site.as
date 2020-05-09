/**
 * 
 */
package shell.view.vc {

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import com.bit101.components.*;

	public class Site extends Sprite {
		public var tip:Label;
		public var nav:Nav;
		public var bgshadow:Sprite = new Sprite();

		public function Site(){
			this.x = 120;
			this.y = 20;
			tip = new Label(this, 5, 30, "section");
			nav = new shell.view.vc.Nav();
			addChild(nav);
			this.graphics.beginFill(0xdddddd)
			this.graphics.drawRect(0, 0, 320, 51)
			this.graphics.endFill()

			this.bgshadow.graphics.lineStyle(2, 0xaaaaaa, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			this.bgshadow.graphics.moveTo(this.width + 1, 3);
			this.bgshadow.graphics.lineTo(this.width + 1, this.height + 1);
			this.bgshadow.graphics.lineTo(4, this.height + 1);
			addChild(bgshadow);
		}
	}
}