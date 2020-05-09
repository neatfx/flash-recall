/**
 *
 */
package modules.projects {

	import neatfx.modules.Module;

	import modules.projects.view.*;
	import modules.projects.model.*;

	public final class Projects extends Module {

		public function Projects(){
			super("projects", 30, 100);
		}

		override public function creat():void {
			//registerView(StageView, this.stage);
			registerView(StageView, this);
			registerModel(SiteDataModel);
		}
	}
}