package junlas.textengine{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;

	/**
	 *@author lvjun01
	 */
	public class GraphicSectionElement extends SectionElement implements IEventDispatcher {
		private var _graphic:DisplayObject;
		private var _elementFormat:ElementFormat;
		private var _hasEvent:Boolean;
		private var _graphicElement:GraphicElement;
		private var _eventDispatcher:EventDispatcher;
		//
		private var _graphicWidth:Number;
		private var _graphicHeight:Number;
		
		
		public function GraphicSectionElement(graphic:DisplayObject,graphicWidth:Number,graphicHeight:Number,eleFormat:ElementFormat,hasEvent:Boolean = false) {
			_graphic = graphic;
			_graphicWidth = graphicWidth;
			_graphicHeight = graphicHeight;
			_elementFormat = eleFormat;
			_hasEvent = hasEvent;
			initGraphicElement();
		}
		
		private function initGraphicElement():void {
			_graphicElement = new GraphicElement(_graphic,_graphicWidth,_graphicHeight,_elementFormat);
			if(_hasEvent) {
				_eventDispatcher = new EventDispatcher();
				_graphicElement.eventMirror = _eventDispatcher;
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
		
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
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
		
		override public function getTextElement():ContentElement{
			return _graphicElement;
		}
		
	}
}