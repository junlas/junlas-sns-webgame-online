package junlas.components.scrollpanel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import junlas.components.base.JPanel;
	
	/**
	 * @author lvjun01
	 */
	public class JScrollPane extends JPanel
	{
		protected var _vScrollbar:JVScrollBar;
		protected var _hScrollbar:JHScrollBar;
		protected var _corner:Shape;
		protected var _dragContent:Boolean = true;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ScrollPane.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function JScrollPane(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,visibleShow:Sprite = null)
		{
			super(parent, xpos, ypos,visibleShow);
		}
		
		/**
		 * Initializes this component.
		 */
		override protected function init():void
		{
			super.init();
			addEventListener(Event.RESIZE, onResize);
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_background.useHandCursor = true;
			_background.buttonMode = true;
			setSize(100, 100);
		}
		
		protected function onMouseWheel(event:MouseEvent):void {
			if(event.delta > 0){
				_vScrollbar.value -= _vScrollbar.lineSize;
				_vScrollbar.value = _vScrollbar.value < _vScrollbar.minimum ? _vScrollbar.minimum : _vScrollbar.value;
			}else {
				_vScrollbar.value += _vScrollbar.lineSize;
				_vScrollbar.value = _vScrollbar.value > _vScrollbar.maximum ? _vScrollbar.maximum : _vScrollbar.value;
			}
			invalidate();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			super.addChildren();
			_vScrollbar = new JVScrollBar(null, width - 10, 0, onScroll,_visibleShow);
			_hScrollbar = new JHScrollBar(null, 0, height - 10, onScroll,_visibleShow);
			addRawChild(_vScrollbar);
			addRawChild(_hScrollbar);
			_corner = new Shape();
			_corner.graphics.beginFill(JStyle.BUTTON_FACE);
			_corner.graphics.drawRect(0, 0, 10, 10);
			_corner.graphics.endFill();
			addRawChild(_corner);
		}
		
		

		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			
			var vPercent:Number = (_height - 10) / content.height;
			var hPercent:Number = (_width - 10) / content.width; 
			
			_vScrollbar.x = width - 10;
			_hScrollbar.y = height - 10;
			
			if(hPercent >= 1)
			{
				_vScrollbar.height = height;
				_mask.height = height;
			}
			else
			{
				_vScrollbar.height = height - 10;
				_mask.height = height - 10;
			}
			if(vPercent >= 1)
			{
				_hScrollbar.width = width;
				_mask.width = width;
			}
			else
			{
				_hScrollbar.width = width - 10;
				_mask.width = width - 10;
			}
			_vScrollbar.setThumbPercent(vPercent);
			_vScrollbar.maximum = Math.max(0, content.height - _height + 10);
			_vScrollbar.pageSize = _height - 10;
			
			_hScrollbar.setThumbPercent(hPercent);
			_hScrollbar.maximum = Math.max(0, content.width - _width + 10);
			_hScrollbar.pageSize = _width - 10;
			
			_corner.x = width - 10;
			_corner.y = height - 10;
			_corner.visible = (hPercent < 1) && (vPercent < 1);
			content.x = -_hScrollbar.value;
			content.y = -_vScrollbar.value;
		}
		
		/**
		 * Updates the scrollbars when content is changed. Needs to be done manually.
		 */
		public function update():void
		{
			invalidate();
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when either scroll bar is scrolled.
		 */
		protected function onScroll(event:Event):void
		{
			content.x = -_hScrollbar.value;
			content.y = -_vScrollbar.value;
		}
		
		protected function onResize(event:Event):void
		{
			invalidate();
		}
		
		protected function onMouseGoDown(event:MouseEvent):void
		{
			content.startDrag(false, new Rectangle(0, 0, Math.min(0, _width - content.width - 10), Math.min(0, _height - content.height - 10)));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			_hScrollbar.value = -content.x;
			_vScrollbar.value = -content.y;
		}
		
		protected function onMouseGoUp(event:MouseEvent):void
		{
			content.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		public function set dragContent(value:Boolean):void
		{
			_dragContent = value;
			if(_dragContent)
			{
				_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
				_background.useHandCursor = true;
				_background.buttonMode = true;
			}
			else
			{
				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
				_background.useHandCursor = false;
				_background.buttonMode = false;
			}
		}
		public function get dragContent():Boolean
		{
			return _dragContent;
		}

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHideScrollBar(value:Boolean):void
        {
            _vScrollbar.autoHide = value;
            _hScrollbar.autoHide = value;
        }
        public function get autoHideScrollBar():Boolean
        {
            return _vScrollbar.autoHide;
        }
		
		//////////////////////////////////////////
		//  dispose
		//////////////////////////////////////////
		override public function destroy():void{
			removeEventListener(Event.RESIZE, onResize);
			removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			stage && stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage && stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			_vScrollbar.destroy();
			_hScrollbar.destroy();
			super.destroy();
		}


	}
}