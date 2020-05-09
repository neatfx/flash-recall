package shell {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	/**
	 * FlashDevelop:
	 * Project Properties > "Compiler Options" > "Advanced" > "Additional Compiler Options"
	 * add "-frame main shell.Shell"
	 */
	public class Preloader extends MovieClip {

		public function Preloader(){
			this.addEventListener(Event.ENTER_FRAME, checkFrame);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
		}

		private function progress(e:ProgressEvent):void {
			// update loader
			trace(e.bytesLoaded);
		}

		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames){
				this.removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}

		private function startup():void {
			// remove loader
			stop();
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("shell.Shell") as Class;
			this.stage.addChildAt(new mainClass() as DisplayObject, 0);
			this.stage.removeChild(this);
		}
	}
}