//////////////////////////////////////////////////////////
// Neatfx Framework MultiCore v1.6.10
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.utils {

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	/**
	 * XLoader（源自历史项目mProject）
	 * 加载二进制数据，AVM1Movie，SWF模块Sprite，图片Bitmap，不确定类型DisplayObject，影片MovieClip
	 */
	public final class XLoader extends Loader {

		private var _type:Class;
		private var _onComplete:Function;
		private var _onProgress:Function;
		private var _onError:Function;
		
		private var ready:Boolean;
		
		/**
		 * 构造函数
		 * @param url 数据对象
		 * @param callBack Function
		 * @param _type 可选值：AVM1Movie，Sprite，Bitmap，DisplayObject，MovieClip
		 */
		public function XLoader(url:*, option:Object){
			this.init(url, option);
		}

		private function init(url:*, option:Object):void {
			this._type = option.type;
			this._onProgress = option.onProgress as Function;
			this._onError = option.onError as Function;
			if (option.onComplete){
				this._onComplete = option.onComplete as Function;
			} else {
				throw new Error("至少得有一个onComplete回调函数吧？");
			}
			this.configListeners(); //添加事件侦听

			if (url is String){
				this.load(new URLRequest(url), new LoaderContext(true)); //普通加载
			} else {
				this.loadBytes(url, new LoaderContext(true)); //加载二进制数据
			}
		}

		/**
		 * 配置事件侦听
		 */
		private function configListeners():void {
			this.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		/**
		 * 加载成功后调度
		 * @param e Event
		 */
		private function initHandler(e:Event):void {
			this._onComplete(e.target.content as this._type);
			clear();
		}

		/**
		 * 请求过程中收到数据时调度
		 * @param e ProgressEvent
		 */
		private function progressHandler(e:ProgressEvent):void {
			if (this._onProgress != null){
				this._onProgress(e);
			}
		}

		/**
		 * 错误处理
		 */
		private function ioErrorHandler(e:IOErrorEvent):void {
			if (this._onError != null){
				this._onError(e);
			}
			clear();
		}

		/**
		 * 一点点清理工作
		 */
		private function clear():void {
			this.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			this._type = null;
			this._onComplete = null;
			this._onProgress = null;
			this._onError = null;
		}
	}
}