//////////////////////////////////////////////////////////
// Neatfx Framework Standard v1.0
// Copyright (c) 2009-2010 Peter Sheen
// http://code.google.com/p/neatframework
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.utils {

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.system.System;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ErrorEvent
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * Request（源自历史项目mProject）
	 * 提供Prototype样式的数据请求封装
	 */

	public final class Request extends URLLoader {

		private var _onProgress:Function;
		private var _onComplete:Function;
		private var _onException:Function;

		/**
		 * 构造函数
		 * @param url 数据对象
		 * @param option 附加参数选项
		 *
		 * method:String 请求方式，默认为GET无需设置，如果设置为“post”使用POST
		 * format:String 设置返回数据格式
		 * _onComplete:Function 请求完成后的回调函数（必选参数）
		 * _onProgress:Function 请求过程中收到数据时需要执行的函数，用来处理进度
		 * parameters：String 请求为GET方式时的附加请求参数
		 * postBody:* 请求为POST方式时的附加请求数据，类型包括二进制数据，URL编码字符串，普通字符串，XML
		 * encoding:Boolean 一个布尔值，它告诉 Flash Player 使用哪个代码页来解释外部文本文件
		 * cache:Boolean 是否使用缓存数据
		 *
		 * @throws 参数异常 所提供参数中缺少回调函数
		 * @throws 请求附加POST数据类型错误
		 * @example new Request("php/mp-project.php?id=2",{format:"xml",_onComplete:someFunction});
		 */
		public function Request(url:String, option:Object){
			this.init(url, option);
		}

		private function init(url:String, option:Object):void {
			if (option.onComplete){
				this._onComplete = option.onComplete as Function;
			} else {
				throw new Error("至少得有一个onComplete回调函数吧？");
			}
			this._onProgress = option.onProgress as Function;
			this._onException = option.onException as Function;
			//System.useCodePage = option.encoding as Boolean;

			this.configListeners(); //添加事件侦听

			var request:URLRequest = new URLRequest(url);

			//数据请求设置
			if (option.method != undefined){ //POST
				trace("POST，无附加数据");
				if (option.postBody != undefined){
					request.method = URLRequestMethod.POST; //设置请求类型为POST
					try {
						request.data = new URLVariables(option.postBody); //POST数据类型为包含名称/值对的URL编码的查询字符串
						trace("名称/值对POST"); //调试语句，如果前面抛出异常此语句不会执行
					} catch (e:Error){
						if (option.postBody is XML){ //POST数据类型为XML
							trace("XML数据POST"); //调试语句
							request.contentType = "text/xml"; //设置POST数据MIME类型为text/xml，默认为application/x-www-form-urlencoded
							request.data = option.postBody.toXMLString();
						} else if (option.postBody is ByteArray || option.postBody is String){ //POST数据为二进制数据/普通字符串
							trace("二进制数据/普通字符串POST");
							request.data = option.postBody;
						} else { //不支持的POST数据类型
							throw new Error("POST数据类型错误：" + option.postBody + " @请求地址：" + url);
						}
					}
				}
			} else { //默认GET
				if (option.parameters != undefined){
					//trace("GET，有附加参数，对于未能返回预期结果的情况，请检查播放器运行环境并重新测试！");
					request.data = new URLVariables(option.parameters);
				} else {
					//trace("GET，无请求参数");
				}
			}

			this.setFormat(option);

			//添加HTTP请求标头
			if (option.cache != undefined){
				request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache")); //不使用缓存数据
			}

			//执行数据请求
			load(request);
			request = null;
		}

		private function setFormat(option:Object):void {
			//设置返回数据类型(默认为文本格式)
			if (option.format != undefined){
				var format:String = option.format.toUpperCase();
				if (format == "VAR"){
					this.dataFormat = URLLoaderDataFormat.VARIABLES; //URL编码变量
				} else if (format == "XML"){
					this.dataFormat = "XML"; //自定义返回数据格式XML
				} else {
					this.dataFormat = URLLoaderDataFormat.BINARY; //二进制数据
				}
			}

		}

		/**
		 * 配置事件侦听
		 */
		private function configListeners():void {
			this.addEventListener(Event.COMPLETE, completeHandler);
			this.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}

		/**
		 * 错误处理
		 * @throws IOError以及SecurityError两种异常
		 */
		private function errorHandler(e:ErrorEvent):void {
			if (this._onException != null){
				this._onException(e);
			} else {
				trace(e.text);
			}
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
		 * 请求完成并将已接收数据解码储存到data属性后调度
		 * @param e Event
		 * @throws e 参数类型异常
		 */

		private function completeHandler(e:Event):void {
			//trace("返回数据格式为：" + this.dataFormat); //调试语句
			if (this.dataFormat == "XML"){
				this.data = XML(this.data);
			}

			if (this._onComplete != null){
				try {
					this._onComplete(this.data);
				} catch (e:Error){
					throw e;
				} finally {
					clear();
				}
			}
		}

		/**
		 * 一点点清理工作
		 */
		private function clear():void {
			this.removeEventListener(Event.COMPLETE, completeHandler);
			this.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			this._onProgress = null;
			this._onComplete = null;
			this._onException = null;
			this.data = null;
		}
	}
}