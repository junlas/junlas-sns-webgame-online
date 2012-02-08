package junlas.components.scrollpanel
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import junlas.components.base.JPanel;
	import junlas.components.base.JVisiualConfig;
	
	/**
	 * @author lvjun01
	 */
	public class JScrollPane extends JPanel
	{
		protected var _vScrollbar:JVScrollBar;
		protected var _hScrollbar:JHScrollBar;
		protected var _corner:Shape;
		protected var _dragContent:Boolean = true;
		protected var _autoVScrollMaxValue:Boolean = false;
		protected var _autoHScrollMaxValue:Boolean = false;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ScrollPane.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function JScrollPane(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,visibleShow:Sprite = null,visibleConfig:JVisiualScrollPanelConf = null)
		{
			visibleConfig = (visibleConfig?visibleConfig:new JVisiualScrollPanelConf());
			super(parent, xpos, ypos,visibleShow,visibleConfig);
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
			_vScrollbar = new JVScrollBar(null, width - _visibleConfig.button_up_left_width, 0, onScroll,_visibleShow,_visibleConfig);
			_hScrollbar = new JHScrollBar(null, 0, height - _visibleConfig.button_up_left_height, onScroll,_visibleShow,_visibleConfig);
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
		 * 增加内容<br>
		 * 超过锁定数目，自动移除的条目，去检查destroy()
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			var contentNum:int = content.numChildren;
			if(contentNum > _visibleConfig.number_panel_content_item){
				var autoDesItem:DisplayObject = removeChild(content.getChildAt(0));
				//超过锁定数目，自动移除的条目，去检查destroy()//
				if(autoDesItem.hasOwnProperty("destroy") && autoDesItem["destroy"] is Function){
					autoDesItem["destroy"]();
				}
			}
			return super.addChild(child);
		}
		
		/**
		 * 增加内容，同时距离上一个Item的距离<br/>
		 * 超过锁定数目，自动移除的条目，去检查destroy()
		 */
		public override function addChildFromDist(child:DisplayObject,distFrom:Number):DisplayObject{
			var contentNum:int = content.numChildren;
			if(contentNum > _visibleConfig.number_panel_content_item){
				var autoDesItem:DisplayObject = removeChild(content.getChildAt(0));
				//超过锁定数目，自动移除的条目，去检查destroy()//
				if(autoDesItem.hasOwnProperty("destroy") && autoDesItem["destroy"] is Function){
					autoDesItem["destroy"]();
				}
			}
			return super.addChildFromDist(child,distFrom);
		}
		
		/**
		 * @param isDestroy
		 * @param funcDestroyName
		 * 清空scrollPanel内容，针对每一个Item，都会去查找是否有destroy方法，如果isDestroy==true且有@funcDestroyName则回调
		 */
		override public function removeAll(isDestroy:Boolean = false,funcDestroyName:String = "destroy"):Array {
			_vScrollbar.value = 0;
			_hScrollbar.value = 0;
			return super.removeAll(isDestroy,funcDestroyName);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			
			var vPercent:Number = (_height - _visibleConfig.button_up_left_height) / content.height;
			var hPercent:Number = (_width - _visibleConfig.button_up_left_width) / content.width; 
			
			_vScrollbar.x = width - _visibleConfig.button_up_left_width;
			_hScrollbar.y = height - _visibleConfig.button_up_left_height;
			
			if(hPercent >= 1)
			{
				_vScrollbar.height = height;
				_mask.height = height;
			}
			else
			{
				_vScrollbar.height = height - _visibleConfig.button_up_left_height;
				_mask.height = height - _visibleConfig.button_up_left_height;
			}
			if(vPercent >= 1)
			{
				_hScrollbar.width = width;
				_mask.width = width;
			}
			else
			{
				_hScrollbar.width = width - _visibleConfig.button_up_left_width;
				_mask.width = width - _visibleConfig.button_up_left_width;
			}
			_vScrollbar.setThumbPercent(vPercent);
			_vScrollbar.maximum = Math.max(0, content.height - _height + _visibleConfig.button_up_left_height);
			_vScrollbar.pageSize = _height - _visibleConfig.button_up_left_height;
			_autoVScrollMaxValue && (_vScrollbar.value = _vScrollbar.maximum);
			
			_hScrollbar.setThumbPercent(hPercent);
			_hScrollbar.maximum = Math.max(0, content.width - _width + _visibleConfig.button_up_left_width);
			_hScrollbar.pageSize = _width - _visibleConfig.button_up_left_width;
			_autoHScrollMaxValue && (_hScrollbar.value = _hScrollbar.maximum);
			
			_corner.x = width - _visibleConfig.button_up_left_width;
			_corner.y = height - _visibleConfig.button_up_left_height;
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
		
		public function get autoVScrollMaxValue():Boolean {
			return _autoVScrollMaxValue;
		}
		
		public function set autoVScrollMaxValue(value:Boolean):void {
			_autoVScrollMaxValue = value;
		}
		
		public function get autoHScrollMaxValue():Boolean {
			return _autoHScrollMaxValue;
		}
		
		public function set autoHScrollMaxValue(value:Boolean):void {
			_autoHScrollMaxValue = value;
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