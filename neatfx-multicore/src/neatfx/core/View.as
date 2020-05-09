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
	 * View
	 * 持有并维护View实例缓存池"_viewMap"
	 * 提供注册、取回、注销View实例的方法
	 * 维护一个或多个视图组件，封装其内部运行细节
	 * 通过订阅、发送、响应事件实现视图间、视图与控制器间的通信
	 */
	public class View {

		protected static var _viewMap:Array = []; //View实例缓存池
		protected var _coreId:String; //核心标识
		protected var _viewComponent:Object; //视图组件，通常在子类中使用getter将其转换为原始类型
		protected var _eventList:Array = []; //响应事件列表

		/**
		 * 构造函数
		 * @param viewComponent 关联视图组件
		 * @param coreId 核心标识
		 * @throws Error 核心类无需实例化
		 * @throws Error 重复注册
		 */
		public function View(viewComponent:Object, coreId:String){
			this.init(viewComponent, coreId);
		}

		/**
		 * 初始化
		 */
		protected function init(viewComponent:Object, coreId:String):void {
			var thisClass:Class = this["constructor"];
			if (thisClass == View)
				throw new Error("Abstract " + thisClass + " should not be instantiated !");
			if (View._viewMap[coreId] == undefined)
				View._viewMap[coreId] = new Vector.<View>(); //初始化
			if (View.retrieveView(thisClass, coreId) != null)
				throw new Error(thisClass + " instance " + '@ "' + coreId + '"' + " already constructed !");
			this._coreId = coreId; //标记核心归属
			this._viewComponent = viewComponent;
			this._eventList = this.listEventInterests();
			View._viewMap[coreId].push(this);
			trace(" + " + StringUtils.pad(this, 37) + StringUtils.pad("-->", 3) + StringUtils.pad("View / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
			this.onRegister(); //注册附加操作
		}

		/**
		 * 取回指定核心中的View实例
		 * @param classObj View子类
		 * @param coreId 核心标识
		 * @return View View子类实例
		 */
		internal static function retrieveView(classObj:Class, coreId:String):View {
			var views:Vector.<View> = View._viewMap[coreId];
			if (views){
				var len:uint = views.length;
				for (var i:uint = 0; i < len; ++i){
					if (views[i]["constructor"] == classObj){
						trace(" * " + StringUtils.pad(views[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("View / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
						return views[i];
					}
				}
			}
			return null;
		}

		/**
		 * 注销指定核心中的View实例
		 * @param classObj View子类
		 * @param coreId 核心标识
		 * @return View View子类实例
		 */
		internal static function removeView(classObj:Class, coreId:String):View {
			var views:Vector.<View> = View._viewMap[coreId];
			var view:View;
			if (views){
				var len:uint = views.length;
				for (var i:uint = 0; i < len; ++i){
					view = views[i];
					if (view["constructor"] == classObj){
						views[i].viewComponent = null; //解除对关联视图组件的引用
						views[i].eventList = null;
						views[i] = null;
						views.splice(i, 1); //确保view总是非空
						view.onRemove(); //注销附加操作
						trace(" - " + StringUtils.pad(view, 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("View / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
						break;
					} else {
						view = null;
					}
				}
			}
			return view;
		}

		/**
		 * 注销指定核心
		 * @param coreId 核心标识
		 */
		public static function removeCore(coreId:String):void {
			var views:Vector.<View> = View._viewMap[coreId];
			if (views){
				var len:uint = views.length;
				for (var i:uint = 0; i < len; ++i){
					trace(" - " + StringUtils.pad(views[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("View / ", 15, " ", true) + '"' + coreId + '"'); //调试语句
				}
			}
			delete View._viewMap[coreId];
		}

		/**
		 * 视图范围内广播事件
		 * @param e ControlEvent
		 */
		internal static function notifyViews(e:ControlEvent):void {
			if (e.coreId == "*")
				throw new ArgumentError(e); //Model&View不具备模块通信能力
			var views:Vector.<View> = View._viewMap[e.coreId];
			if (views){
				var len:uint = views.length;
				for (var i:uint = 0; i < len; ++i){
					var eventLen:uint = views[i].eventList.length;
					for (var k:uint = 0; k < eventLen; ++k){
						if (views[i].eventList[k] == e.type){
							if (e.tracking)
								trace(" e " + StringUtils.pad(views[i], 37) + StringUtils.pad(" @ ", 3) + StringUtils.pad("View / ", 15, " ", true) + StringUtils.pad('"' + e.coreId + '"', 15) + "  <--  " + e["constructor"] + ' / "' + e.type + '"'); //调试语句
							views[i].handleEvent(e); //分类处理事件
						}
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
		 * 取回Model
		 * @param classObj Model子类
		 * @return Model Model子类实例
		 */
		protected function retrieveModel(classObj:Class):Model {
			return Model.retrieveModel(classObj, this._coreId);
		}

		/**
		 * 核心标识
		 */
		public function get coreId():String {
			return _coreId;
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