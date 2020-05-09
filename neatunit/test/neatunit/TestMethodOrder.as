package neatunit {

	public final class TestMethodOrder extends TestCase {
		protected var testCounter:int = 0;

		public function TestMethodOrder():void {
			super(["testFive", "testFour", "testThree", "testTwo", "testOne"]); //指定测试顺序
			//super(["testFive", "testFour"]); //指定测试方法
		}

		public function testOne():void {
			testCounter++;
			assertEqual(testCounter, 5);
			//fail(this._currentMethod);
		}

		public function testTwo():void {
			testCounter++;
			assertEqual(testCounter, 4);
			//fail(this._currentMethod);
		}

		public function testThree():void {
			testCounter++;
			assertEqual(testCounter, 3);
			//fail(this._currentMethod);
		}

		public function testFour():void {
			testCounter++;
			assertEqual(testCounter, 2);
			//fail(this._currentMethod);
		}

		public function testFive():void {
			testCounter++;
			assertEqual(testCounter, 1);
			//fail(this._currentMethod);
		}
	}
}