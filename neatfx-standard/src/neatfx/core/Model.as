//////////////////////////////////////////////////////////
// Neatfx Framework Standard v1.0
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.core {

	import neatfx.event.ControlEvent;
	import neatfx.utils.StringUtils;

	/**
	 * Model
	 * 持有并维护Model实例缓存池"_modelMap"
	 * 提供注册、取回、注销Model实例的方法
	 * 封装与本地或者远程服务之间的数据交互细节
	 * 维护一个或多个缓存数据，对外提供数据访问服务
	 * 与视图进行单向通信，当持有数据变化时通知视图作出响应
	 */
	public class Model {

		protected static var _modelMap:Vector.<Model> = new Vector.<Model>(); //Model实例缓存池
		protected var _data:Object; //持有数据

		/**
		 * 构造函数
		 * @param data 持有数据(可选)
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function Model(data:Object = null){
			this.init(data);
		}

		/**
		 * 初始化
		 */
		protected function init(data:Object):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == Model)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (Model.retrieveModel(thisClass) != null)
				throw new Error(thisClass + " instance already constructed !");
			(data == null) ? this._data = {} : this._data = data;
			Model._modelMap.push(this);
			trace(" + " + StringUtils.pad(this, 37) + "--> Model");
			this.onRegister(); //注册附加操作
		}

		/**
		 * 取回Model实例
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		internal static function retrieveModel(classObj:Class):Model {
			var len:uint = Model._modelMap.length;
			for (var i:uint = 0; i < len; ++i){
				if (Model._modelMap[i]["constructor"] == classObj){
					trace(" * " + StringUtils.pad(Model._modelMap[i], 37) + " @  Model");
					return Model._modelMap[i];
				}
			}
			return null;
		}

		/**
		 * 注销Model实例
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		public static function removeModel(classObj:Class):Model {
			var len:uint = Model._modelMap.length;
			var model:Model;
			for (var i:uint = 0; i < len; ++i){
				model = Model._modelMap[i];
				if (model["constructor"] == classObj){
					Model._modelMap[i].data = null;
					Model._modelMap[i] = null;
					Model._modelMap.splice(i, 1); //确保model总是非空
					model.onRemove(); //注销附加操作
					trace(" - " + StringUtils.pad(model, 37) + " @  Model");
					break;
				} else {
					model = null;
				}
			}
			return model;
		}

		/**
		 * 通知视图
		 * @param e ControlEvent
		 */
		protected function sendEvent(e:ControlEvent):void {
			View.notifyViews(e); //internal
			//Controller.notifyControllers(e);//internal
		}

		/**
		 * 注册附加操作，需在子类中覆盖使用
		 */
		protected function onRegister():void {
		}

		/**
		 * 注销附加操作，需在子类中覆盖使用
		 */
		protected function onRemove():void {
		}

		/**
		 * 缓存数据对象
		 */
		public function set data(data:Object):void {
			this._data = data;
		}

		public function get data():Object {
			return this._data;
		}
	}
}