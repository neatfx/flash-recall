package neatunit {

	//异常测试
	public final class TestException extends TestCase {
		//方法运行时抛出ArgumentError，该异常将被捕捉输出为测试异常，不影响后续测试，期间的断言失败输出将被忽略
		public function testMethodWithException(info:String):void { //异常位置1
			throw new Error("position 2") //异常位置2
			assertFalse(true);
			throw new Error("position 3") //异常位置3
		}

		//异步测试

	}

}