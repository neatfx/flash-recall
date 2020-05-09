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
	 * View
	 * 持有并维护View实例缓存池"_viewMap"
	 * 提供注册、取回、注销View实例的方法
	 * 维护一个或多个视图组件，封装其内部运行细节
	 * 通过订阅、发送、响应事件实现视图间、视图与控制器间的通信
	 */
	public class View {

		protected static var _viewMap:Vector.<View> = new Vector.<View>(); //View实例缓存池
		protected var _viewComponent:Object; //视图组件，通常在子类中使用getter将其转换为原始类型
		protected var _eventList:Array = []; //响应事件列表

		/**
		 * 构造函数
		 * @param viewComponent 关联视图组件
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function View(viewComponent:Object){
			this.init(viewComponent);
		}

		/**
		 * 初始化
		 */
		protected function init(viewComponent:Object):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == View)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (View.retrieveView(thisClass) != null)
				throw new Error(thisClass + " instance already constructed !");
			this._viewComponent = viewComponent;
			this._eventList = this.listEventInterests();
			View._viewMap.push(this);
			trace(" + " + StringUtils.pad(this, 37) + "--> View"); //调试语句
			this.onRegister(); //注册附加操作
		}

		/**
		 * 取回View实例
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		internal static function retrieveView(classObj:Class):View {
			var len:uint = View._viewMap.length;
			for (var i:uint = 0; i < len; ++i){
				if (View._viewMap[i]["constructor"] == classObj){
					trace(" * " + StringUtils.pad(View._viewMap[i], 37) + " @  View"); //调试语句
					return View._viewMap[i];
				}
			}
			return null;
		}

		/**
		 * 注销View实例
		 * @param classObj View子类
		 * @return View View子类实例
		 */
		public static function removeView(classObj:Class):View {
			var len:uint = View._viewMap.length;
			var view:View;
			for (var i:uint = 0; i < len; ++i){
				view = View._viewMap[i];
				if (view["constructor"] == classObj){
					View._viewMap[i].viewComponent = null; //解除对关联视图组件的引用
					View._viewMap[i].eventList = null;
					View._viewMap[i] = null;
					View._viewMap.splice(i, 1); //确保view总是非空
					view.onRemove(); //注销附加操作
					trace(" - " + StringUtils.pad(view, 37) + " @  View"); //调试语句
					break;
				} else {
					view = null;
				}
			}
			return view;
		}

		/**
		 * 视图范围内广播事件
		 * @param e ControlEvent
		 */
		internal static function notifyViews(e:ControlEvent):void {
			var len:uint = View._viewMap.length;
			for (var i:uint = 0; i < len; ++i){
				var eventLen:uint = View._viewMap[i].eventList.length;
				for (var k:uint = 0; k < eventLen; ++k){
					if (View._viewMap[i].eventList[k] == e.type){
						if (e.tracking)
							trace(" e " + StringUtils.pad(View._viewMap[i], 37) + " @  View " + "  <--  " + e["constructor"] + ' / "' + e.type + '"'); //调试语句
						View._viewMap[i].handleEvent(e); //分类处理事件
					}
				}
			}
		}

		/**
		 * 返回需要响应的事件类型列表，需在子类中覆盖使用
		 * @return Array 需要响应的事件类型列表
		 */
		protected function listEventInterests():Array {
			return [];
		}

		/**
		 * 分类响应事件，需在子类中覆盖使用
		 * @param e ControlEvent
		 */
		protected function handleEvent(e:ControlEvent):void {
		}

		/**
		 * 框架范围内广播事件
		 * @param e ControlEvent
		 */
		protected function sendEvent(e:ControlEvent):void {
			if (!e.strict)
				Controller.notifyControllers(e);
			View.notifyViews(e);
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
		 * 取回Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function retrieveModel(classObj:Class):Model {
			return Model.retrieveModel(classObj);
		}

		/**
		 * 关联视图组件
		 */
		public function get viewComponent():Object {
			return _viewComponent;
		}

		public function set viewComponent(value:Object):void {
			_viewComponent = value;
		}

		/**
		 * 响应事件类型列表
		 */
		public function get eventList():Array {
			return _eventList;
		}

		public function set eventList(value:Array):void {
			_eventList = value;
		}
	}
}