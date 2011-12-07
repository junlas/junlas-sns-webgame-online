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
	public class TextBuilder{
		private var _config:GraphicTextConfig;
		private var _graphicTextInfoVect:Vector.<GraphicTextInfo>;
		private var _generateTextInfoVect:Vector.<GenerateTextInfo>;
		
		public function TextBuilder(config:GraphicTextConfig = null) {
			_config = config;
			_graphicTextInfoVect = new Vector.<GraphicTextInfo>();
			_generateTextInfoVect = new Vector.<GenerateTextInfo>();
		}
		
		/**
		 * 创建图文并茂的排版显示对象
		 */
		public function createGraphicText(sections:Vector.<SectionElement>):GraphicTextInfo{
			var graphicInfo:GraphicTextInfo = new GraphicTextInfo(_config);
			_graphicTextInfoVect.push(graphicInfo);
			
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			for each(var sectionEle:SectionElement in sections){
				var contentEle:ContentElement = sectionEle.getTextElement();
				if(contentEle is GraphicElement){
					if(GraphicElement(contentEle).elementWidth > _config.engine_width){
						throw new IllegalOperationError("GraphicWidth显示宽带大于EngineWidth,显示可能异常");
					}
				}else{
					graphicInfo.linkAllText(TextElement(contentEle).text);
				}
				groupVector.push(contentEle);
			}
			var groupElement:GroupElement = new GroupElement(groupVector);
			groupElement.eventMirror = graphicInfo.getEventDispatcher();
			var graphicInfoTextBlock:TextBlock = graphicInfo.getTextBlock();
			graphicInfoTextBlock.content = groupElement;
			
			var textLine:TextLine = null;
			var xPos:Number = 0;
			var yPos:Number = 0;
			var isFirstRow:Boolean = true;
			while(true){
				textLine = graphicInfoTextBlock.createTextLine(textLine,_config.engine_width);
				if(!textLine) break;
				switch(graphicInfoTextBlock.lineRotation){
					case TextRotation.ROTATE_90:
					case TextRotation.ROTATE_270:
						xPos += textLine.x + _config.engine_line_spacing;
						if(isFirstRow) {xPos = textLine.width;isFirstRow = false;}
						textLine.x = xPos;
						break;
					default:
						yPos += textLine.y + _config.engine_line_spacing;
						if(isFirstRow) {yPos = textLine.height;isFirstRow = false;}
						textLine.y = yPos;
				}
				graphicInfo.getGraphicTextContainer().addChild(textLine);
				graphicInfo.getTextLineVect().push(textLine);
			}
			return graphicInfo;
		}
		
		/**
		 * 创建普通排版的文本显示对象
		 */
		public function createGenerateText(str:String,textWidth:Number,lineSpace:Number,fontSize:int=12,fontColor:uint=0xffffff,fontAlpha:Number=1.0,fontName:String="宋体",isDevice:Boolean = true):GenerateTextInfo{
			var generateInfo:GenerateTextInfo = new GenerateTextInfo();
			_generateTextInfoVect.push(generateInfo);
			
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
				generateInfo.getGenerateTextContainer().addChild(textLine);
			}
			return generateInfo;
		}
		
		//////////////////////////销毁处理////////////////////////////
		public function destroyGraphicText():void{
			while(_graphicTextInfoVect.length){
				_graphicTextInfoVect.pop().destroy();
			}
		}
		
		public function destroyGenerateText():void{
			while(_generateTextInfoVect.length){
				_generateTextInfoVect.pop().destroy();
			}
		}
		
		public function destroy():void{
			destroyGraphicText();
			destroyGenerateText();
		}

	}
}