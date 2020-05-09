/**
 *
 */
package shell.model {

	import neatfx.core.Model;
	import neatfx.utils.Request;

	import shell.event.ShellEvent;

	public final class SiteDataModel extends Model {

		public function SiteDataModel(coreId:String, data:Object = null){
			super(coreId, data);
			new Request("../assets/xml/shell.xml", {onComplete: onDataLoaded, format: "xml"});
		}

		private function onDataLoaded(xml:XML):void {
			xml.ignoreWhitespace = true;

			var navs:Array = new Array();
			var sections:XMLList = xml..section;
			var len:uint = sections.length();
			for (var i:uint = 0; i < len; i++){
				var section:XML = sections[i];
				var ids:String = section.@id;
				data[ids] = {"id": ids, "content": section.content};
				navs[i] = {"id": ids, "content": section.content};
			}
			data.navs = navs;

			sendEvent(new ShellEvent(ShellEvent.SITE_DATA_OK, null, true));
		}
	}
}
