package {
	import neatunit.*;

	public final class NeatUnitSuit extends TestSuite {
		//预期:98-36-2-1-54-2,10
		public function NeatUnitSuit(){
			addCase(TestAssert); //10
			addCase(TestStringAssert); //7
			addCase(TestCollectionAssert); //11

			addCase(TestAsynchronous); //54,36,1,0
			//addCase(TestAsynchronousSetUpTearDown); //6

			addCase(TestException); //1,0,1
			addCase(TestIgnore); //2,0,0,1
			addCase(TestSetUpTearDown); //2
			addCase(TestBeforeClassAfterClass); //3
			addCase(TestVisualCase); //3
			addCase(TestMethodOrder); //5
		}
	}
}