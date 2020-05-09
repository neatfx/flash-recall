/**
 *
 */
package common {

	import neatfx.event.ControlEvent;

	public final class AppEvent extends ControlEvent {

		public static const STARTUP:String = "startUp";
		public static const START:String = "start";

		public function AppEvent(type:String, data:Object = null, tracking:Boolean = false){
			super(type, data, tracking, true);
		}
	}
}