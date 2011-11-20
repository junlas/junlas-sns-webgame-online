package junlas.components.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import junlas.components.scrollpanel.JStyle;
	import junlas.components.scrollpanel.JVisiualScrollPanelConf;
	
	/**
	 * @author lvjun01
	 */
	public class JPanel extends JComponent
	{
		protected var _mask:Sprite;
		protected var _background:Sprite;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _gridSize:int = 10;
		protected var _showGrid:Boolean = false;
		protected var _gridColor:uint = 0xd0d0d0;
		/////////////网格显示容器/////////////
		protected var _gridShow:Sprite;
		/////////////内容显示容器/////////////
		protected var content:Sprite;
		
		public function JPanel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,visibleShow:Sprite = null)
		{
			super(parent, xpos, ypos,visibleShow);
		}
		
		override protected function init():void
		{
			super.init();
			setSize(100, 100);
		}
		
		override protected function addChildren():void
		{
			if(_visibleShow){
				_background = _visibleShow[JVisiualScrollPanelConf.scroll_background];
				_background.x = 0;
				_background.y = 0;
			}else {
				_background = new Sprite();
			}
			super.addChild(_background);
			
			_gridShow = new Sprite();
			_gridShow.name = "jpanel_grid_show";
			super.addChild(_gridShow);
			
			_mask = new Sprite();
			_mask.name = "jpanel_mask_show";
			_mask.mouseEnabled = false;
			super.addChild(_mask);
			
			content = new Sprite();
			content.name = "jpanel_content_show";
			super.addChild(content);
			content.mask = _mask;
			
			filters = [getShadow(2, true)];
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			return child;
		}
		
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			if(_visibleShow){
				_background.width = _width;
				_background.height = _height;
			} else {
				_background.graphics.clear();
				_background.graphics.lineStyle(1, 0, 0.1);
				if(_color == -1)
				{
					_background.graphics.beginFill(JStyle.PANEL);
				}
				else
				{
					_background.graphics.beginFill(_color);
				}
				_background.graphics.drawRect(0, 0, _width, _height);
				_background.graphics.endFill();
			}
			
			drawGrid();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
		}
		
		protected function drawGrid():void
		{
			if(!_showGrid) return;
			
			//_background.graphics.lineStyle(0, _gridColor);
			_gridShow.graphics.lineStyle(0, _gridColor);
			for(var i:int = 0; i < _width; i += _gridSize)
			{
				//_background.graphics.moveTo(i, 0);
				//_background.graphics.lineTo(i, _height);
				_gridShow.graphics.moveTo(i, 0);
				_gridShow.graphics.lineTo(i, _height);
			}
			for(i = 0; i < _height; i += _gridSize)
			{
				//_background.graphics.moveTo(0, i);
				//_background.graphics.lineTo(_width, i);
				_gridShow.graphics.moveTo(0, i);
				_gridShow.graphics.lineTo(_width, i);
			}
		}
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(2, true)];
			}
			else
			{
				filters = [];
			}
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/**
		 * Gets / sets the backgrond color of this panel.
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}

		/**
		 * Sets / gets the size of the grid.
		 */
		public function set gridSize(value:int):void
		{
			_gridSize = value;
			invalidate();
		}
		public function get gridSize():int
		{
			return _gridSize;
		}

		/**
		 * Sets / gets whether or not the grid will be shown.
		 */
		public function set showGrid(value:Boolean):void
		{
			_showGrid = value;
			invalidate();
		}
		
		public function get showGrid():Boolean
		{
			return _showGrid;
		}
		public function set gridColor(value:uint):void
		{
			_gridColor = value;
			invalidate();
		}
		public function get gridColor():uint
		{
			return _gridColor;
		}
		
		//////////////////////////////////////////
		//  dispose
		//////////////////////////////////////////
		override public function destroy():void{
			_background && super.removeChild(_background);
			_gridShow && super.removeChild(_gridShow);
			_mask && super.removeChild(_mask);
			super.destroy();
			
		}
	}
}