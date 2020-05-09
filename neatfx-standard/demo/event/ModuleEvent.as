/**
 *
 */
package event {

	import neatfx.event.ControlEvent;

	public final class ModuleEvent extends ControlEvent {

		public static const SITE_DATA_OK:String = "siteDataOk";
		public static const SITE_PAGE_CHANGED:String = "sitePageChanged";

		public function ModuleEvent(type:String, data:Object = null, tracking:Boolean = false, strict:Boolean = false){
			super(type, data, tracking, strict);
		}
	}
}