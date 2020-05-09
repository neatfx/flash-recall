//////////////////////////////////////////////////////////
// Neatfx Framework MultiCore v1.6.10
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.modules {

	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;

	import neatfx.core.*;
	import neatfx.utils.XLoader;

	/**
	 * ModuleManager类
	 * 持有并维护Module缓存池"_moduleMap"
	 * 提供加载，卸载模块的方法
	 */
	public final class ModuleManager {

		private static var _moduleMap:Array = []; //全局模块缓存池
		private static var _stage:Stage; //模块容器
		private static var _pattern:RegExp = /\w+\.swf/;

		/**
		 * 构造函数
		 * @param stage
		 */
		public function ModuleManager(stage:Stage){
			ModuleManager._stage = stage; //获取Stage引用
		}

		/**
		 * 参数选项
		 * @param url swf模块url
		 * @param option 参数选项（target,onComplete,onError）
		 */
		public static function loadModule(url:String, option:Object):void {
			var moduleName:String = ModuleManager._pattern.exec(url);
			if (_moduleMap[moduleName] != undefined){ //文件重复
				throw new Error("模块文件命名重复！" + moduleName);
			} else {
				_moduleMap[moduleName] = new XLoader(url, {onComplete: onModuleLoaded, onProgress: option.onProgress, onError: onErrorHandler, type: Module});
			}
			function onModuleLoaded(module:Module):void {
				_moduleMap[moduleName] = module; //使用文件名注册模块
				module.loaded = true; //加载完成
				if (option.target != null && option.target is DisplayObjectContainer){ //指定模块容器
					option.target.addChild(module);
				} else { //默认加载到Stage
					ModuleManager._stage.addChild(module); //此时module的stage属性可访问
				}
				module.ready = true; //加载到显示列表
				if (option.onComplete != null)
					option.onComplete(module); //附加操作
			}

			function onErrorHandler(e:IOErrorEvent):void {
				trace("模块加载发生错误@" + url);
				if (option.onError != null){
					option.onError(e);
				}
			}
		}

		/**
		 * 卸载模块
		 * @param moduleName 模块文件名
		 */
		public static function unloadModule(moduleName:String):void {
			var moduleName:String = ModuleManager._pattern.exec(moduleName); //获取文件名
			var module:* = _moduleMap[moduleName];
			if (module){
				if (module.loaded){
					var coreId:String = module.coreId;
					module.parent.removeChild(module); //从显示列表中移除

					Model.removeCore(coreId);
					View.removeCore(coreId);
					Controller.removeCore(coreId);

					module = null;
					delete _moduleMap[moduleName];
				} else {
					var loader:Loader = _moduleMap[moduleName] as Loader;
					loader.unloadAndStop(); //gc == true
				}
			}
		}
	}
}