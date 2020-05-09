/**
 *
 */
package modules.news.view.vc {

	import flash.display.Sprite;
	import com.bit101.components.*;
	import com.bit101.charts.*;

	public final class Site extends Sprite {
		public var nav:Nav;
		public var chart:BarChart;

		public function Site(){
			var win:Window = new Window(this, 0, 0, "News.swf");
			var vb:VBox = new VBox(win, 5, 25);
			chart = new BarChart(vb, 0, 0, [92, 115, 87, 102, 70, 96, 110, 91, 100, 90, 120]);
			chart.width = 310;
			chart.height = 120;
			
			nav = new modules.news.view.vc.Nav();
			nav.x = 15;

			win.width = 320;
			win.height = 175;

			vb.addChild(nav);
		}
	}
}