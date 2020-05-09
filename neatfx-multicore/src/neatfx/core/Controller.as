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
	 * Controller
	 * 持有并维护Controller实例缓存池"_controllerMap"
	 * 提供注册、注销Controller实例的方法
	 * 可以通过注册时关联到模块事件来处理模块通信
	 * 无状态，按需创建，与视图双向通信，
	 * 响应视图请求，操作模型数据，或者调用其他控制器，处理复杂应用逻辑
	 */
	public class Controller {

		protected static var _controllerMap:Array = []; //Controller实例缓存池
		protected var _coreId:String; //核心标识，负责模块通信的Controller统一注册到核心“*”
		protected var _eventType:String; //关联事件类型

		/**
		 * 构造函数
		 * @param e ControlEvent
		 * @param tag 使用模块事件注册，负责模块通信的时候，需加核心标签(可选)
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function Controller(e:ControlEvent, tag:String = null){
			this.init(e, tag);
		}

		/**
		 * 初始化
		 */
		protected function init(e:ControlEvent, tag:String):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == Controller)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (!Controller._controllerMap[e.coreId])
				Controller._controllerMap[e.coreId] = new Vector.<Controller>(); //初始化
			if (e.coreId != "*"){
				if (Controller.hasController(thisClass, e.coreId))
					throw new Error(thisClass + " instance " + '@ "' + e.coreId + '"' + " already constructed !");
			}
			this._eventType = e.type;
			(e.coreId != "*") ? this._coreId = e.coreId : this._coreId = tag; //标记核心
			Controller._controllerMap[e.coreId].push(this);
			trace((e.coreId == "*" ? "[+]" : " + ") + StringUtils.pad(this, 37) + StringUtils.pad("-->", 3) + StringUtils.pad("Controller / ", 15, " ", true) + '"' + e.coreId + '"'); //调试语句
			this.onRegister(); //注册附加操作
		}

		/**
		 * 检查指定的Controller实例是否已注册
		 * @param classObj Controller子类
		 * @param coreId 核心标识
		 * @return Boolean 如果已注册，返回true，否则返回false
		 */
		private static function hasController(classObj:Class, coreId:String):Boolean {
			var controllers:Vector.<Controller> = Controller._controllerMap[coreId];
			if (controllers){
				var len:uint = controllers.length;
				for (var i:uint = 0; i < len; ++i){
					if (controllers[i]["constructor"] == classObj){
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 注销指定核心中的Controller实例
		 * @param className Controller子类
		 * @param coreId 核心标识
		 * @return Boolean 移除成功，返回true，否则返回false
		 */
		private static function removeController(classObj:Class, coreId:String):Boolean {
			var controllers:Vector.<Controller> = Controller._controllerMap[coreId];
			if (controllers){
				var len:uint = controllers.length;
				for (var i:uint = 0; i < len; ++i){
					var controller:Controller = controllers[i];
					if (controller["constructor"] == classObj){
						controllers[i] = null;
						controllers.splice(i, 1); //确保controller总是非空
						controller.onRemove(); //注销附加操作
						trace(" - " + StringUtils.pad(controller, 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Controller / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 注销指定核心
		 * @param coreId 核心标识
		 */
		public static function removeCore(coreId:String):void {
			var controllers:Vector.<Controller> = Controller._controllerMap[coreId];
			if (controllers){
				var len:uint = controllers.length;
				for (var i:uint = 0; i < len; ++i){
					trace(" - " + StringUtils.pad(controllers[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Controller / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
				}
			}
			delete Controller._controllerMap[coreId]; //删除核心
			Controller.removeRouter(coreId);
		}

		/**
		 * 注销与指定核心关联，用于模块通信的Controller实例
		 * @param coreId 核心标识
		 */
		private static function removeRouter(coreId:String):void {
			var routers:Vector.<Controller> = Controller._controllerMap["*"];
			if (routers){
				var routerslen:uint = routers.length;
				for (var i:uint = 0; i < routerslen; --routerslen){
					if (routers[i].coreId == coreId){
						trace("[-]" + StringUtils.pad(routers[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Controller / ", 15, " ", true) + '"*"'); //调试语句
						routers.splice(i, 1);
					}
				}
			}
		}

		/**
		 * 控制器范围内广播事件
		 * @param e ControlEvent
		 */
		internal static function notifyControllers(e:ControlEvent):void {
			var controllers:Vector.<Controller> = Controller._controllerMap[e.coreId];
			if (controllers){
				var len:uint = controllers.length;
				for (var i:uint = 0; i < len; ++i){
					if (controllers[i].event == e.type){
						if (e.tracking)
							trace((e.coreId == "*" ? "[e]" : " e ") + StringUtils.pad(controllers[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("Controller / ", 15, " ", true) + StringUtils.pad('"' + e.coreId + '"', 15) + "  <--  " + e["constructor"] + ' / "' + e.type + '"'); //调试语句
						controllers[i].execute(e); //执行一个或多个命令（FIFO）
					}
				}
			}
		}

		/**
		 * 框架范围内广播事件
		 * @param e ControlEvent
		 */
		protected function sendEvent(e:ControlEvent):void {
			if (!e.strict)
				View.notifyViews(e); //internal
			Controller.notifyControllers(e); //internal
		}

		/**
		 * 执行Controller逻辑处理，需在子类中覆盖使用
		 * @param e ControlEvent
		 */
		protected function execute(e:ControlEvent):void {
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
		 * 注册View
		 * @param classObj View子类
		 * @param viewComponent 关联视图组件
		 */
		protected function registerView(classObj:Class, viewComponent:Object):void {
			new classObj(viewComponent, this._coreId);
		}

		/**
		 * 取回View
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		protected function retrieveView(classObj:Class):View {
			return View.retrieveView(classObj, this._coreId);
		}

		/**
		 * 注销View
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		protected function removeView(classObj:Class):View {
			return View.removeView(classObj, this._coreId);
		}

		/**
		 * 注册Controller
		 * @param classObj Controller子类
		 * @param e ControlEvent
		 */
		protected function registerController(classObj:Class, e:ControlEvent):void {
			e.coreId != "*" ? new classObj(e) : new classObj(e, this._coreId);
		}

		/**
		 * 注销Controller
		 * @param classObj Controller子类
		 * @return Boolean 注销成功返回true，否则为false
		 */
		protected function removeController(classObj:Class):Boolean {
			return Controller.removeController(classObj, this._coreId);
		}

		/**
		 * 注册Model
		 * @param classObj Model子类
		 * @param data 持有数据
		 */
		protected function registerModel(classObj:Class, data:Object = null):void {
			new classObj(this._coreId, data);
		}

		/**
		 * 取回Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function retrieveModel(classObj:Class):Model {
			return Model.retrieveModel(classObj, this._coreId);
		}

		/**
		 * 注销Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function removeModel(classObj:Class):Model {
			return Model.removeModel(classObj, this._coreId);
		}

		/**
		 * 核心标识
		 */
		public function get coreId():String {
			return _coreId;
		}

		/**
		 * 关联事件
		 */
		public function get event():String {
			return _eventType;
		}

		public function set event(value:String):void {
			_eventType = value;
		}
	}
}