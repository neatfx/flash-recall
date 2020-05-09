//////////////////////////////////////////////////////////
// Neatfx Framework MultiCore v1.6.10
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.modules {

	import flash.display.*;
	import flash.events.*;

	import neatfx.event.ControlEvent;
	import neatfx.core.*;

	public class Module extends Sprite {
		protected var _coreId:String; //核心标识
		protected var _ready:Boolean;
		protected var _loaded:Boolean;
		protected var _base:DisplayObjectContainer;

		public function Module(coreId:String, xpos:Number = 0, ypos:Number = 0){
			if (this["constructor"] == Module)
				throw new Error("Abstract " + Module + " should not be instantiated !");
			this._coreId = coreId;
			this.x = xpos;
			this.y = ypos;
			this.stage ? this.creat() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		protected function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.creat();
		}

		public function creat():void {
			//publish to Shell
		}

		protected function registerModel(classObj:Class, data:Object = null):void {
			Model(new classObj(this._coreId, data));
		}

		protected function registerView(classObj:Class, viewComponent:Object):void {
			View(new classObj(viewComponent, this._coreId));
		}

		protected function registerController(classObj:Class, e:ControlEvent):void {
			Controller(e.coreId != "*" ? new classObj(e) : new classObj(e, this._coreId));
		}

		public function get coreId():String {
			return this._coreId;
		}

		public function get ready():Boolean {
			return _ready;
		}

		public function set ready(value:Boolean):void {
			_ready = value;
		}

		public function get loaded():Boolean {
			return _loaded;
		}

		public function set loaded(value:Boolean):void {
			_loaded = value;
		}

		public function get base():DisplayObjectContainer {
			return _base;
		}
	}

}