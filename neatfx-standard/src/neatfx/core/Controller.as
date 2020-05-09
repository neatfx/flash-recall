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
	 * Controller
	 * 持有并维护Controller实例缓存池"_controllerMap"
	 * 提供注册、注销Controller实例的方法
	 * 可以通过注册时关联到模块事件来处理模块通信
	 * 无状态，按需创建，与视图双向通信
	 * 响应视图请求，操作模型数据，或者调用其他控制器，处理复杂应用逻辑
	 */
	public class Controller {

		protected static var _controllerMap:Vector.<Controller> = new Vector.<Controller>(); //Controller实例缓存池
		protected var _eventType:String; //关联事件类型

		/**
		 * 构造函数
		 * @param e ControlEvent
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function Controller(e:ControlEvent){
			this.init(e);
		}

		/**
		 * 初始化
		 */
		protected function init(e:ControlEvent):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == Controller)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (Controller.hasController(thisClass))
				throw new Error(thisClass + " instance already constructed !");
			this._eventType = e.type;
			Controller._controllerMap.push(this);
			trace(" + " + StringUtils.pad(this, 37) + "--> Controller"); //调试语句
			this.onRegister(); //注册附加操作
		}

		/**
		 * 检查指定的Controller实例是否已注册
		 * @param classObj Controller子类
		 * @return Boolean 如果已注册，返回true，否则返回false
		 */
		private static function hasController(classObj:Class):Boolean {
			var len:uint = Controller._controllerMap.length;
			for (var i:uint = 0; i < len; ++i){
				if (Controller._controllerMap[i]["constructor"] == classObj){
					return true;
				}
			}
			return false;
		}

		/**
		 * 注销指定核心中的Controller实例
		 * @param className Controller子类
		 * @return Boolean 移除成功，返回true，否则返回false
		 */
		public static function removeController(classObj:Class):Boolean {
			var len:uint = Controller._controllerMap.length;
			for (var i:uint = 0; i < len; ++i){
				var controller:Controller = Controller._controllerMap[i];
				if (controller["constructor"] == classObj){
					Controller._controllerMap[i] = null;
					Controller._controllerMap.splice(i, 1); //确保controller总是非空
					controller.onRemove(); //注销附加操作
					trace(" - " + StringUtils.pad(controller, 37) + " @  Controller"); //调试语句
					return true;
				}
			}
			return false;
		}

		/**
		 * 控制器范围内广播事件
		 * @param e ControlEvent
		 */
		internal static function notifyControllers(e:ControlEvent):void {
			var len:uint = Controller._controllerMap.length;
			for (var i:uint = 0; i < len; ++i){
				if (Controller._controllerMap[i].event == e.type){
					if (e.tracking)
						trace(" e " + StringUtils.pad(Controller._controllerMap[i], 37) + " @  Controller" + "  <--  " + e["constructor"] + ' / "' + e.type + '"'); //调试语句
					Controller._controllerMap[i].execute(e); //执行一个或多个命令（FIFO）
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
		 * 取回View
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		protected function retrieveView(classObj:Class):View {
			return View.retrieveView(classObj);
		}

		/**
		 * 注销View
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		protected function removeView(classObj:Class):View {
			return View.removeView(classObj);
		}

		/**
		 * 注销Controller
		 * @param classObj Controller子类
		 * @return Boolean 注销成功返回true，否则为false
		 */
		protected function removeController(classObj:Class):Boolean {
			return Controller.removeController(classObj);
		}

		/**
		 * 取回Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function retrieveModel(classObj:Class):Model {
			return Model.retrieveModel(classObj);
		}

		/**
		 * 注销Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function removeModel(classObj:Class):Model {
			return Model.removeModel(classObj);
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