package neatunit {

	public class TestSetUpTearDown extends TestCase {
		protected var num:Number = 3;
		protected var obj:Object;

		override public function setUp():void {
			num = 7;
		}

		override public function tearDown():void {
			obj = null;
		}

		public function setUpTearDownTest():void {
			assertNull(obj);
			assertEqual(num, 7);
			obj = new Object();
		}

		public function setUpTearDownTest2():void {
			assertNull(obj);
			assertEqual(num, 7);
			obj = new Object();
		}
	}
}