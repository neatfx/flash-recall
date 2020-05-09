package neatunit {

	public class TestIgnore extends TestCase {
		protected var testCounter:int = 0;

		override public function tearDown():void {
			if (testCounter == 2){
				throw new Error("Ignored method ran");
			}
		}

		//忽略测试方法（以“_”结尾）
		public function testOne_():void {
			testCounter++;
		}

		public function testTwo():void {
			testCounter++;
		}
	}
}