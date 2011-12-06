package junlas.textengine{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;

	/**
	 *@author lvjun01
	 */
	public class TextSectionElement extends SectionElement implements IEventDispatcher{
		private var _text:String;
		private var _elementFormat:ElementFormat;
		private var _hasEvent:Boolean;
		private var _textElement:TextElement;
		private var _eventDispatcher:EventDispatcher;
		
		public function TextSectionElement(str:String,format:ElementFormat,hasEvent:Boolean = false) {
			_text = str;
			_elementFormat = format;
			_hasEvent = hasEvent;
			initTextElement();
			createElement();
		}
		
		private function createElement():void {
			
		}
		
		private function initTextElement():void {
			_textElement = new TextElement(_text,_elementFormat);
			if(_hasEvent){
				_eventDispatcher = new EventDispatcher();
				_textElement.eventMirror = _eventDispatcher;
			}
		}
		
		/**************************************************************
		 *************************************************************
		 * 接口实现
		 *************************************************************
		**************************************************************/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			if(_hasEvent){
				_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
			} else{
				throw new IllegalOperationError("被约束的_hasEvent=false,请开启");
			}
		}
		
		public function dispatchEvent(event:Event):Boolean{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_eventDispatcher.removeEventListener(type,listener,useCapture);
		}
		
		public function willTrigger(type:String):Boolean{
			return _eventDispatcher.willTrigger(type);
		}
		
		override public function getElementFormat():ElementFormat{
			return _elementFormat;
		}
		
		override public function getTextElement():TextElement{
			return _textElement;
		}

	}
}