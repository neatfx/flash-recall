package neatunit {
	import flash.display.Sprite;
	import flash.display.Stage;

	public class TestVisualCase extends TestCase {
		private var instance:Sprite;

		public override function setUp():void {
			instance = new Sprite();
			addChild(instance);
		}

		public override function tearDown():void {
			removeChild(instance);
		}

		public function testInstance():void {
			assertTrue(instance.stage is Stage);
		}

		public function testSize():void {
			assertTrue(instance.width == 0);
			assertTrue(instance.height == 0);

			instance.graphics.beginFill(0x000000);
			instance.graphics.drawRect(0, 0, 10, 20);

			assertTrue(instance.width == 10);
			assertTrue(instance.height == 20);
		}

		public function testSize2():void {
			assertTrue(instance.width == 0);
			assertTrue(instance.height == 0);

			instance.graphics.beginFill(0x000000);
			instance.graphics.drawRect(0, 0, 30, 40);

			assertTrue(instance.width == 30);
			assertTrue(instance.height == 40);
		}
	}
}