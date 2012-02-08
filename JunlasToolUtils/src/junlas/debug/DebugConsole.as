package junlas.debug{
	import fl.controls.TextArea;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class DebugConsole{
		private var _debugTextArea:DebugTextArea;
		private var _stage:Stage;
		private var _debug:Boolean;
		//
		private var _allConsole:TextArea;
		private var _infoConsole:TextArea;
		private var _warnConsole:TextArea;
		//
		private var _posX:Number=0;
		private var _posY:Number=0;
		private var _posWidth:Number = 0;
		private var _posHeight:Number = 0;
		
		public function DebugConsole()
		{
			super();
		}
		
		public function init(s:Stage,debug:Boolean = false):void{
			_stage = s;
			_debug = debug;
			if(_debug){
				initData();
				initConsole();
				initEvent();
				initDefaultStyle();
			}
		}
		
		public function Trace(...txt):void{
			if(!_debugTextArea)return;
			for each(var t:Object in txt){
				_debugTextArea.txt_area.appendText(t.toString());
				_debugTextArea.txt_area.appendText(" ");
			}
			_debugTextArea.txt_area.appendText("\n");
			_debugTextArea.txt_area.verticalScrollPosition = _debugTextArea.txt_area.maxVerticalScrollPosition;
		}
		
		public function Info(...txt):void{
			if(!_debugTextArea)return;
			for each(var t:Object in txt){
				_infoConsole.appendText(t.toString());
				_infoConsole.appendText(" ");
				_allConsole.appendText(t.toString());
				_allConsole.appendText(" ");
			}
			_infoConsole.appendText("\n");
			_infoConsole.verticalScrollPosition = _infoConsole.maxVerticalScrollPosition;
			_allConsole.appendText("\n");
			_allConsole.verticalScrollPosition = _allConsole.maxVerticalScrollPosition;
		}
		
		public function Warn(...txt):void{
			if(!_debugTextArea)return;
			for each(var t:Object in txt){
				_warnConsole.appendText(t.toString());
				_warnConsole.appendText(" ");
				_allConsole.appendText(t.toString());
				_allConsole.appendText(" ");
			}
			_warnConsole.appendText("\n");
			_warnConsole.verticalScrollPosition = _warnConsole.maxVerticalScrollPosition;
			_allConsole.appendText("\n");
			_allConsole.verticalScrollPosition = _allConsole.maxVerticalScrollPosition;
		}
		
		private function initData():void{
			_debugTextArea = new DebugTextArea();
			_debugTextArea.txt_area.wordWrap = false;
			_posX = _debugTextArea.txt_area.x;
			_posY = _debugTextArea.txt_area.y;
			_posWidth = _debugTextArea.txt_area.width;
			_posHeight = _debugTextArea.txt_area.height;
			_allConsole = _debugTextArea.txt_area;
			_infoConsole = new TextArea();
			_infoConsole.wordWrap = false;
			_warnConsole = new TextArea();
			_warnConsole.wordWrap = false;
		}
		
		private function initConsole():void
		{
			_infoConsole.x = _posX;
			_infoConsole.y = _posY;
			_infoConsole.width = _posWidth;
			_infoConsole.height = _posHeight;
			_warnConsole.x = _posX;
			_warnConsole.y = _posY;
			_warnConsole.width = _posWidth;
			_warnConsole.height = _posHeight;
			_debugTextArea.addChild(_infoConsole);
			_debugTextArea.addChild(_warnConsole);
			_infoConsole.visible = false;
			_warnConsole.visible = false;
		}
		
		private function initEvent():void{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_debugTextArea.btn_all.mouseChildren = false;
			_debugTextArea.btn_all.buttonMode = true;
			_debugTextArea.btn_all.addEventListener(MouseEvent.CLICK,onClick);
			_debugTextArea.btn_info.mouseChildren = false;
			_debugTextArea.btn_info.buttonMode = true;
			_debugTextArea.btn_info.addEventListener(MouseEvent.CLICK,onClick);
			_debugTextArea.btn_warn.mouseChildren = false;
			_debugTextArea.btn_warn.buttonMode = true;
			_debugTextArea.btn_warn.addEventListener(MouseEvent.CLICK,onClick);
			_debugTextArea.txt_ver.text = "ver 1.1";
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target){
				case _debugTextArea.btn_all:{
					_allConsole.visible = true;
					_infoConsole.visible = false;
					_warnConsole.visible = false;
					break;
				}
				case _debugTextArea.btn_info:{
					_allConsole.visible = false;
					_infoConsole.visible = true;
					_warnConsole.visible = false;
					break;
				}
				case _debugTextArea.btn_warn:{
					_allConsole.visible = false;
					_infoConsole.visible = false;
					_warnConsole.visible = true;
					break;
				}
				default:{
					break;
				}
			}
		}
		
		private function initDefaultStyle():void{
			_allConsole.setStyle("textFormat", new TextFormat(null,null,0x000000));
			_infoConsole.setStyle("textFormat", new TextFormat(null,null,0x0000ff));
			_warnConsole.setStyle("textFormat", new TextFormat(null,null,0xff0000));
		}
		
		private function onKeyDown(event:KeyboardEvent):void{
			if(event.keyCode == 110){
				if(_stage.contains(_debugTextArea)){
					_stage.removeChild(_debugTextArea);
				}else{
					_stage.addChild(_debugTextArea);
				}
			}
		}
		
		public function setStyle(textFormat:TextFormat):void{
			_debugTextArea.txt_area.setStyle("textFormat", textFormat);
		}
		
		
	}
}