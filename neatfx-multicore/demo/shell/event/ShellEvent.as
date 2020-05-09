/**
 *
 */
package shell.event {

	import neatfx.event.ControlEvent;

	public final class ShellEvent extends ControlEvent {

		public static const SITE_DATA_OK:String = "siteDataOk";
		public static const SITE_PAGE_CHANGED:String = "sitePageChanged";
		public static const ADD_MODULE:String = "addModule";
		public static const REMOVE_MODULE:String = "removeModule";

		public function ShellEvent(type:String, data:Object = null, tracking:Boolean = false, strict:Boolean = false){
			super(type, data, tracking, strict);
			this._coreId = "shell";
		}
	}
}