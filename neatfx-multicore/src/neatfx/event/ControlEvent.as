//////////////////////////////////////////////////////////
// Neatfx Framework MultiCore v1.6.10
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.event {

	/**
	 * ControlEvent
	 */
	public class ControlEvent {

		protected var _coreId:String = "*"; //核心标识，默认为模块事件
		protected var _type:String; //事件类型
		protected var _data:Object; //附加数据
		protected var _tracking:Boolean; //是否追踪
		protected var _strict:Boolean; //是否限制发送范围

		/**
		 * 构造函数
		 * @param	type 事件类型
		 * @param	data 附加数据
		 * @param	tracking 是否追踪
		 * @param	strict 是否限制发送范围
		 */
		public function ControlEvent(type:String, data:Object = null, tracking:Boolean = true, strict:Boolean = false){
			this._type = type;
			this._data = data;
			this._tracking = tracking;
			this._strict = strict;
		}

		/**
		 * 核心标识
		 */
		public function get coreId():String {
			return _coreId;
		}

		/**
		 * 事件类型
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 附加数据
		 */
		public function get data():Object {
			return _data;
		}

		/**
		 * 是否追踪
		 */
		public function get tracking():Boolean {
			return _tracking;
		}

		/**
		 * 是否限制发送范围
		 */
		public function get strict():Boolean {
			return _strict;
		}
	}
}