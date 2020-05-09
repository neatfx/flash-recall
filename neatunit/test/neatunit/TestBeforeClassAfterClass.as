package neatunit {

	public class TestBeforeClassAfterClass extends TestCase {
		protected var testCounter:int = 0;

		public function testOne():void {
			testCounter++;
		}

		public function testTwo():void {
			testCounter++;
		}

		public function testThree():void {
			testCounter++;
		}

		override protected function beforeClass():void {
			if (testCounter > 0){
				throw new Error("beforeClass ran later"); //中断代码运行
			}
		}

		override protected function afterClass():void {
			if (testCounter < 3){
				throw new Error("afterClass ran earlier"); //中断代码运行
			}
		}
	}
}