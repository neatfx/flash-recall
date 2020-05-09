//////////////////////////////////////////////////////////
// Neatfx Framework MultiCore v1.6.10
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

		protected static var _modelMap:Array = []; //Model实例缓存池
		//protected var _coreId:String; //核心标识
		protected var _data:Object; //持有数据

		/**
		 * 构造函数
		 * @param coreId 核心标识
		 * @param data 持有数据(可选)
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function Model(coreId:String, data:Object = null){
			this.init(coreId, data);
		}

		/**
		 * 初始化
		 */
		protected function init(coreId:String, data:Object):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == Model)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (Model._modelMap[coreId] == undefined)
				Model._modelMap[coreId] = new Vector.<Model>();
			if (Model.retrieveModel(thisClass, coreId) != null)
				throw new Error(thisClass + " instance " + '@ "' + coreId + '"' + " already constructed !");
			//this._coreId = coreId;
			(data == null) ? this._data = {} : this._data = data;
			Model._modelMap[coreId].push(this);
			trace(" + " + StringUtils.pad(this, 37) + StringUtils.pad("-->", 3) + StringUtils.pad("Model / ", 15, " ", true) + '"' + coreId + '"');
			this.onRegister(); //注册附加操作
		}

		/**
		 * 取回指定核心中的Model实例
		 * @param classObj Model子类
		 * @param coreId 核心标识
		 * @return Model Model子类实例
		 */
		internal static function retrieveModel(classObj:Class, coreId:String):Model {
			var models:Vector.<Model> = Model._modelMap[coreId];
			if (models){
				var len:uint = models.length;
				for (var i:uint = 0; i < len; ++i){
					if (models[i]["constructor"] == classObj){
						trace(" * " + StringUtils.pad(models[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Model / ", 15, " ", true) + '"' + coreId + '"');
						return models[i];
					}
				}
			}
			return null;
		}

		/**
		 * 注销指定核心中的Model实例
		 * @param classObj Model子类
		 * @param coreId 核心标识
		 * @return Model Model子类实例
		 */
		internal static function removeModel(classObj:Class, coreId:String):Model {
			var models:Vector.<Model> = Model._modelMap[coreId];
			var model:Model;
			if (models){
				var len:uint = models.length;
				for (var i:uint = 0; i < len; ++i){
					model = models[i];
					if (model["constructor"] == classObj){
						models[i].data = null;
						models[i] = null;
						models.splice(i, 1); //确保model总是非空
						model.onRemove(); //注销附加操作
						trace(" - " + StringUtils.pad(model, 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Model / ", 15, " ", true) + '"' + coreId + '"');
						break;
					} else {
						model = null;
					}
				}
			}
			return model;
		}

		/**
		 * 注销指定核心
		 * @param coreId 核心标识
		 */
		public static function removeCore(coreId:String):void {
			var models:Vector.<Model> = Model._modelMap[coreId];
			if (models){
				var len:uint = models.length;
				for (var i:uint = 0; i < len; ++i){
					trace(" - " + StringUtils.pad(models[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Model / ", 15, " ", true) + '"' + coreId + '"');
				}
			}
			delete Model._modelMap[coreId];
		}

		/**
		 * 通知视图
		 * @param e ControlEvent
		 */
		protected function sendEvent(e:ControlEvent):void {
			View.notifyViews(e); //TODO:internal,later,namespace
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