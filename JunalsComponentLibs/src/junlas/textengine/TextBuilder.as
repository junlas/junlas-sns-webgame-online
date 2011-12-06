package junlas.textengine{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;

	/**
	 * 文本创建器
	 *@author lvjun01
	 */
	public class TextBuilder implements IEventDispatcher{
		private var _config:GraphicTextConfig;
		private var _textBlock:TextBlock;
		private var _eventDispatcher:EventDispatcher;
		
		private var _graphicTextContainer:Sprite;
		private var _textLineVect:Vector.<TextLine>;
		private var _generateTextContainer:Sprite;
		
		public function TextBuilder(config:GraphicTextConfig = null) {
			_config = config;
			initBuilder();
		}
		
		private function initBuilder():void {
			if(_config){
				_textBlock = new TextBlock();
				switch(_config.engine_rotation){
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
			}else{
				_generateTextContainer = new Sprite();
			}
		}
		
		/**
		 * 创建图文并茂的排版显示对象
		 */
		public function createGraphicText(sections:Vector.<SectionElement>):Sprite{
			_graphicTextContainer.x = _config.engine_x;
			_graphicTextContainer.y = _config.engine_y;
			
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			for each(var sectionEle:SectionElement in sections){
				var contentEle:ContentElement = sectionEle.getTextElement();
				if(contentEle is GraphicElement){
					if(GraphicElement(contentEle).elementWidth > _config.engine_width){
						throw new IllegalOperationError("GraphicWidth显示宽带大于EngineWidth,显示可能异常");
					}
				}
				groupVector.push(contentEle);
			}
			var groupElement:GroupElement = new GroupElement(groupVector);
			groupElement.eventMirror = _eventDispatcher;
			_textBlock.content = groupElement;
			
			var textLine:TextLine = null;
			var yPos:Number = 0;
			var isFirstRow:Boolean = true;
			while(true){
				textLine = _textBlock.createTextLine(textLine,_config.engine_width);
				if(!textLine) break;
				yPos += textLine.y + _config.engine_line_spacing;
				if(isFirstRow) {yPos = textLine.height;isFirstRow = false;}
				textLine.y = yPos;
				_graphicTextContainer.addChild(textLine);
				_textLineVect.push(textLine);
			}
			return _graphicTextContainer;
		}
		
		/**
		 * 创建普通排版的文本显示对象
		 */
		public function createGenerateText(str:String,textWidth:Number,lineSpace:Number,fontSize:int,fontColor:uint,fontAlpha:Number,fontName:String,isDevice:Boolean = true):Sprite{
			var fontDesc:FontDescription = new FontDescription(fontName);
			if(isDevice){
				fontDesc.fontLookup = FontLookup.DEVICE;
			}else{
				fontDesc.fontLookup = FontLookup.EMBEDDED_CFF;
			}
			var format:ElementFormat = new ElementFormat(fontDesc,fontSize,fontColor,fontAlpha);
			var textEle:TextElement = new TextElement(str,format);
			var textBlock:TextBlock = new TextBlock(textEle);
			
			var textLine:TextLine = null;
			var yPos:Number = 0;
			var isFirstRow:Boolean = true;
			while(true){
				textLine = textBlock.createTextLine(textLine,textWidth);
				if(!textLine) break;
				yPos += textLine.y +lineSpace;
				if(isFirstRow) {yPos = textLine.height;isFirstRow = false;}
				textLine.y = yPos;
				_generateTextContainer.addChild(textLine);
			}
			//关闭鼠标
			_generateTextContainer.mouseChildren = _generateTextContainer.mouseEnabled = false;
			return _generateTextContainer;
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
		
		/**
		 * 获取textLineVector数据
		 */
		public function getTextLineVect():Vector.<TextLine> {
			return _textLineVect;
		}
		
		//////////////////////////销毁处理////////////////////////////
		public function destroyGraphicText():void{
		
		}
		
		public function destroyGenerateText():void{
		
		}
		
		public function destroy():void{
			destroyGraphicText();
			destroyGenerateText();
		}

	}
}