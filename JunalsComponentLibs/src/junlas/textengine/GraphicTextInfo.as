package junlas.textengine{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 *@author lvjun01
	 */
	public class GraphicTextInfo implements IEventDispatcher{
		private var _textBlock:TextBlock;
		private var _eventDispatcher:EventDispatcher;
		
		private var _graphicTextContainer:Sprite;
		private var _textLineVect:Vector.<TextLine>;
		
		private var _allText:String;
		private var _selectable:Boolean = false;
		private var _selectColor:uint = 0x00FF00;
		
		private var _startIndex:SelectableItem;
		private var _endIndex:SelectableItem;
		
		public function GraphicTextInfo(config:GraphicTextConfig) {
			if(config){
				_textBlock = new TextBlock();
				switch(config.engine_rotation){
					case "0":
						_textBlock.lineRotation = TextRotation.ROTATE_0;
						break;
					case "90":
						_textBlock.lineRotation = TextRotation.ROTATE_90;
						break;
					case "180":
						_textBlock.lineRotation = TextRotation.ROTATE_180;
						break;
					case "270":
						_textBlock.lineRotation = TextRotation.ROTATE_270;
						break;
					default:
						_textBlock.lineRotation = TextRotation.AUTO;
				}
				///eventMirror///
				_eventDispatcher = new EventDispatcher();
				_graphicTextContainer = new Sprite();
				_textLineVect = new Vector.<TextLine>();
				//定义config信息
				_graphicTextContainer.x = config.engine_x;
				_graphicTextContainer.y = config.engine_y;
				//总文本串//
				_allText = "";
			}
		}
		
		/**
		 * 将所有的文本连接起来
		 */
		public function linkAllText(text:String):void {
			_allText += text;
		}
		
		private function invalidate():void {
			_eventDispatcher.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			_eventDispatcher.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			_eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_eventDispatcher.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_graphicTextContainer.addEventListener(Event.COPY,onCopy);
		}
		
		private function disvalidate():void {
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_graphicTextContainer.removeEventListener(Event.COPY,onCopy);
		}
		
		protected function onMouseOut(event:MouseEvent):void {
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		protected function onMouseOver(event:MouseEvent):void {
			Mouse.cursor = MouseCursor.IBEAM;
		}
		
		/**
		 * copy操作
		 */
		protected function onCopy(event:Event):void {
			if(!_startIndex || !_endIndex)return;
			var isWellSort:Boolean = (_endIndex.rowIndex >= _startIndex.rowIndex);
			var tempHasGraphicItemIndexVect:Vector.<int> = new Vector.<int>();
			var rowIndex:int = -1;
			var tl:TextLine = _textBlock.firstLine;
			while(tl != null){
				++rowIndex;
				var index:int = -1;
				while(++index < tl.atomCount){
					var disObj:DisplayObject = tl.getAtomGraphic(index);
					if(disObj){
						tempHasGraphicItemIndexVect.push(tl.getAtomTextBlockBeginIndex(index));
					}
				}
				tl = tl.nextLine;
			}
			var start:int;
			var end:int;
			if(isWellSort){
				start = _startIndex.getTextBlockIndex();
				end = _endIndex.getTextBlockIndex() + 1;
			}else{
				start = _startIndex.getTextBlockIndex() + 1;
				end = _endIndex.getTextBlockIndex();
			}
			//var indexArr:Array = checkSubStringIndex(tempHasGraphicItemIndexVect,start,end,isWellSort);
			//如果选中区域中间夹有graphic，索引值将发生变化，暂留
			var copyStr:String = _allText.substring(start,end);
			System.setClipboard(copyStr);
		}
		
		private function checkSubStringIndex(selectableItemVect:Vector.<int>,start:int,end:int,isWellSort:Boolean):Array{
			for each(var graphicItemIndex:int in selectableItemVect){
				trace(graphicItemIndex);
				if(isWellSort){
					if(graphicItemIndex > start){
						++start;
					}
					if(graphicItemIndex <= end){
						++end;
					}
				}else{
					if(graphicItemIndex <= start){
						++start;
					}
					if(graphicItemIndex > end){
						++end;
					}
				}
				
			}
			return [start,end];
		}
		
		protected function onMouseDown(event:MouseEvent):void {
			_eventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			clearGraphic();
			if(_graphicTextContainer.stage)_graphicTextContainer.stage.focus = _graphicTextContainer;
			////
			var rowIndex:int = -1;
			var colIndex:int;
			var tl:TextLine = _textBlock.firstLine;
			while (tl != null) {
				++rowIndex;
				colIndex = tl.getAtomIndexAtPoint(event.stageX,event.stageY);
				if (colIndex > -1) {
					//_stattIndex = tl.getAtomTextBlockBeginIndex(colIndex);
					_startIndex = new SelectableItem(tl,rowIndex,colIndex);
					return;
				}
				tl = tl.nextLine;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void {
			_eventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void {
			//鼠标一旦离开区域，做mouse_up处理
			if(!event.buttonDown){
				onMouseUp(null);
				return;
			}
			var rowIndex:int = -1;
			var colIndex:int;
			var tl:TextLine = _textBlock.firstLine;
			while (tl != null) {
				rowIndex++;
				colIndex = tl.getAtomIndexAtPoint(event.stageX,event.stageY);
				if (colIndex > -1) {
					//_endIndex = tl.getAtomTextBlockBeginIndex(colIndex);
					_endIndex = new SelectableItem(tl,rowIndex,colIndex);
					if(!_endIndex.equals(_startIndex)){
						draw();
					}
					return;
				}
				tl = tl.nextLine;
			}
		}
		
		private function draw():void{
			//var rectStart:Rectangle = _startIndex.getAtomBounds();
			//var rectEnd:Rectangle = _endIndex.getAtomBounds();
			clearGraphic();
			
			if(_startIndex.currTextLine == _endIndex.currTextLine){
				drawGraphic(_startIndex.currTextLine,_startIndex.getAtomBounds(),_endIndex.getAtomBounds());
				return;
			}
			var isWellSort:Boolean = (_endIndex.rowIndex >= _startIndex.rowIndex);
			var isDraw:Boolean = false;
			var tl:TextLine = isWellSort?_textBlock.firstLine:_textBlock.lastLine;
			while (tl != null) {
				if(tl == _startIndex.currTextLine){
					if(isWellSort){
						drawGraphic(_startIndex.currTextLine,_startIndex.getAtomBounds(),_startIndex.getEndAtomBounds());
					}else{
						drawGraphic(_startIndex.currTextLine,_startIndex.getStartAtomBounds(),_startIndex.getAtomBounds());
					}
					isDraw = true;
				}else if(tl == _endIndex.currTextLine){
					if(isWellSort){
						isDraw && drawGraphic(_endIndex.currTextLine,_endIndex.getStartAtomBounds(),_endIndex.getAtomBounds());
					}else{
						isDraw && drawGraphic(_endIndex.currTextLine,_endIndex.getAtomBounds(),_endIndex.getEndAtomBounds());
					}
					break;
				}else{
					isDraw && drawGraphic(tl,tl.getAtomBounds(0),tl.getAtomBounds(tl.atomCount-1));
				}
				tl = isWellSort?tl.nextLine:tl.previousLine;
			}
			
		}
		
		/**
		 * 绘制
		 */
		private function drawGraphic(tl:TextLine,rectS:Rectangle,rectE:Rectangle):void {
			_graphicTextContainer.graphics.beginFill(_selectColor, 1.0);
			_graphicTextContainer.graphics.drawRect (tl.x+rectS.x, tl.y+rectS.y, rectE.x-rectS.x+rectE.width, rectE.height) ;
			_graphicTextContainer.graphics.endFill();
		}
		
		/**
		 * 清空画板
		 */
		private function clearGraphic():void{
			_graphicTextContainer.graphics.clear();
		}
		
		/**************************************************************
		 *************************************************************
		 * 接口实现
		 *************************************************************
		 **************************************************************/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
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
		
		/******************************************************
		 *** getter and setter
		 ******************************************************/
		public function getTextBlock():TextBlock{
			return _textBlock;
		}
		
		public function getEventDispatcher():EventDispatcher{
			return _eventDispatcher;
		}
		
		public function getGraphicTextContainer():Sprite{
			return _graphicTextContainer;
		}
		
		public function getTextLineVect():Vector.<TextLine>{
			return _textLineVect;
		}
		
		/**
		 * 添加选择功能、copy功能<br/>
		 * 注:在有旋转条件下暂不支持。
		 */
		public function set selectable(s:Boolean):void{
			_selectable = s;
			if(_selectable){
				invalidate();
			}else{
				disvalidate();
				clearGraphic();
			}
		}
		
		public function get selectable():Boolean{
			return _selectable;
		}
		
		public function set selectColor(s:uint):void{
			_selectColor = s;
		}
		
		public function get selectColor():uint{
			return _selectColor;
		}
		
		/**
		 * 销毁
		 */
		public function destroy():void {
			clearGraphic();
			disvalidate();
			while(_graphicTextContainer.numChildren){
				_graphicTextContainer.removeChildAt(0);
			}
			if(_graphicTextContainer.parent){
				_graphicTextContainer.parent.removeChild(_graphicTextContainer);
			}
		}
	}
}