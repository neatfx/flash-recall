package {
	import flash.display.Sprite;
	import neatunit.*;

	public final class NeatUnitRunner extends Sprite {
		public function NeatUnitRunner(){
			//初始化GUI
			this.addChild(new TestRunner());

			var suit:TestSuite = new TestSuite();

			//添加多个TestSuit
			suit.addSuit(NeatUnitSuit);
			//suit.addSuit(NeatUnitSuit);

			//添加多个TestCase
			suit.addCase(TestAssert);
			suit.addCase(TestStringAssert);
			suit.addCase(TestCollectionAssert);

			//运行测试
			suit.run();
		}
	}
}