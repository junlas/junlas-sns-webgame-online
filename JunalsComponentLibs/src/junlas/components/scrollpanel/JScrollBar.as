package junlas.components.scrollpanel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import junlas.components.base.JComponent;
	import junlas.components.base.JPushButton;
	import junlas.components.base.JVisiualConfig;

	[Event(name="change", type="flash.events.Event")]
	public class JScrollBar extends JComponent
	{
		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100; 
		protected const UP:String = "up";
		protected const DOWN:String = "down";

        protected var _autoHide:Boolean = false;
		private var _upButton:JPushButton;
		private var _downButton:JPushButton;
		private var _upButtonSprite:Sprite;
		private var _downButtonSprite:Sprite;
		//
		protected var _scrollSlider:JScrollSlider;
		protected var _orientation:String;
		protected var _lineSize:int = 16;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;
		//
		private var _defaultHandler:Function;
		
		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function JScrollBar(orientation:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function = null,visibleShow:Sprite = null,visibleConfig:JVisiualConfig = null)
		{
			_orientation = orientation;
			super(parent, xpos, ypos,visibleShow,visibleConfig);
			if(defaultHandler != null)
			{
				_defaultHandler = defaultHandler;
				addEventListener(Event.CHANGE, _defaultHandler);
			}
		}
		
		//public function 
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_scrollSlider = new JScrollSlider(_orientation, this, 0, 10, onChange,_visibleShow,_visibleConfig);
			if(_visibleShow && ((_orientation == JSlider.VERTICAL &&_visibleShow.hasOwnProperty(_visibleConfig.slider_btn_up))||(_orientation != JSlider.VERTICAL &&_visibleShow.hasOwnProperty(_visibleConfig.slider_btn_left)))){
				if(_orientation == JSlider.VERTICAL){
					_upButtonSprite = _visibleShow[_visibleConfig.slider_btn_up];
				}else{
					_upButtonSprite = _visibleShow[_visibleConfig.slider_btn_left];
				}
				_upButtonSprite.x = _upButtonSprite.y = 0;
				_upButtonSprite.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
				_upButtonSprite.width = _visibleConfig.button_up_left_width;
				_upButtonSprite.height = _visibleConfig.button_up_left_height;
				_upButtonSprite.buttonMode = _upButtonSprite.useHandCursor = true;
				this.addChild(_upButtonSprite);
			} else {
				_upButton = new JPushButton(this, 0, 0, "");
				_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
				_upButton.setSize(_visibleConfig.button_up_left_width, _visibleConfig.button_up_left_height);
				var upArrow:Shape = new Shape();
				_upButton.addChild(upArrow);
			}
			
			if(_visibleShow && ((_orientation == JSlider.VERTICAL && _visibleShow.hasOwnProperty(_visibleConfig.slider_btn_down))||(_orientation != JSlider.VERTICAL && _visibleShow.hasOwnProperty(_visibleConfig.slider_btn_right)))){
				if(_orientation == JSlider.VERTICAL){
					_downButtonSprite = _visibleShow[_visibleConfig.slider_btn_down];
				}else{
					_downButtonSprite = _visibleShow[_visibleConfig.slider_btn_right];
				}
				_downButtonSprite.x = _downButtonSprite.y = 0;
				_downButtonSprite.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
				_downButtonSprite.width = _visibleConfig.button_down_right_width;
				_downButtonSprite.height = _visibleConfig.button_down_right_height;
				_downButtonSprite.buttonMode = _downButtonSprite.useHandCursor = true;
				this.addChild(_downButtonSprite);
			}else{
				_downButton = new JPushButton(this, 0, 0, "");
				_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
				_downButton.setSize(_visibleConfig.button_down_right_width, _visibleConfig.button_down_right_height);
				var downArrow:Shape = new Shape();
				_downButton.addChild(downArrow);
			}
			
			if(_visibleShow)return;
			if(_orientation == JSlider.VERTICAL)
			{
				upArrow.graphics.beginFill(JStyle.DROPSHADOW, 0.5);
				upArrow.graphics.moveTo(5, 3);
				upArrow.graphics.lineTo(7, 6);
				upArrow.graphics.lineTo(3, 6);
				upArrow.graphics.endFill();
				
				downArrow.graphics.beginFill(JStyle.DROPSHADOW, 0.5);
				downArrow.graphics.moveTo(5, 7);
				downArrow.graphics.lineTo(7, 4);
				downArrow.graphics.lineTo(3, 4);
				downArrow.graphics.endFill();
			}
			else
			{
				upArrow.graphics.beginFill(JStyle.DROPSHADOW, 0.5);
				upArrow.graphics.moveTo(3, 5);
				upArrow.graphics.lineTo(6, 7);
				upArrow.graphics.lineTo(6, 3);
				upArrow.graphics.endFill();
				
				downArrow.graphics.beginFill(JStyle.DROPSHADOW, 0.5);
				downArrow.graphics.moveTo(7, 5);
				downArrow.graphics.lineTo(4, 7);
				downArrow.graphics.lineTo(4, 3);
				downArrow.graphics.endFill();
			}

			
		}
		
		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			if(_orientation == JSlider.HORIZONTAL)
			{
				setSize(100, 10);
			}
			else
			{
				setSize(10, 100);
			}
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			_scrollSlider.setSliderParams(min, max, value);
		}
		
		/**
		 * Sets the percentage of the size of the thumb button.
		 */
		public function setThumbPercent(value:Number):void
		{
			_scrollSlider.setThumbPercent(value);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			if(_orientation == JSlider.VERTICAL)
			{
				_scrollSlider.x = 0;
				_scrollSlider.y = _visibleConfig.button_up_left_height;
				_scrollSlider.width = _visibleConfig.button_up_left_width;
				_scrollSlider.height = _height - _visibleConfig.button_down_right_height - _visibleConfig.button_up_left_height;
				_downButton && (_downButton.x = 0);
				_downButton && (_downButton.y = _height - _visibleConfig.button_down_right_height);
				_downButtonSprite && (_downButtonSprite.x = 0);
				_downButtonSprite && (_downButtonSprite.y = _height - _visibleConfig.button_down_right_height);
			}
			else
			{
				_scrollSlider.x = _visibleConfig.button_up_left_width;
				_scrollSlider.y = 0;
				_scrollSlider.width = _width - _visibleConfig.button_down_right_width-_visibleConfig.button_up_left_width;
				_scrollSlider.height = _visibleConfig.button_up_left_height;
				_downButton && (_downButton.x = _width - _visibleConfig.button_down_right_width);
				_downButton && (_downButton.y = 0);
				_downButtonSprite && (_downButtonSprite.x = _width - _visibleConfig.button_down_right_width);
				_downButtonSprite && (_downButtonSprite.y = 0);
			}
			_scrollSlider.draw();
            if(_autoHide)
            {
                visible = _scrollSlider.thumbPercent < 1.0;
            }
            else
            {
                visible = true;
            }
		}

		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHide(value:Boolean):void
        {
            _autoHide = value;
            invalidate();
        }
        public function get autoHide():Boolean
        {
            return _autoHide;
        }

		/**
		 * Sets / gets the current value of this scroll bar.
		 */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
		}
		public function get value():Number
		{
			return _scrollSlider.value;
		}
		
		/**
		 * Sets / gets the minimum value of this scroll bar.
		 */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
		}
		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}
		
		/**
		 * Sets / gets the maximum value of this scroll bar.
		 */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
		}
		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}
		
		/**
		 * Sets / gets the amount the value will change when up or down buttons are pressed.
		 */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		public function get lineSize():int
		{
			return _lineSize;
		}
		
		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_scrollSlider.pageSize = value;
			invalidate();
		}
		public function get pageSize():int
		{
			return _scrollSlider.pageSize;
		}
		

		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
				
		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goDown():void
		{
			_scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}
		
		protected function onChange(event:Event):void
		{
			dispatchEvent(event);
		}
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			if(_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}
		
		protected function onRepeat(event:TimerEvent):void
		{
			if(_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}
		
		///////////////////////////////////////////
		//   dispose 
		///////////////////////////////////////////
		override public function destroy():void{
			_defaultHandler && removeEventListener(Event.CHANGE, _defaultHandler);
			_upButtonSprite && _upButtonSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_upButton && _upButton.removeEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_downButtonSprite && _downButtonSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			_downButton && _downButton.removeEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			_delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);
			_delayTimer.stop();
			_repeatTimer.stop();
			_scrollSlider.destroy();
			_upButton && _upButton.destroy();
			_downButton && _downButton.destroy();
			super.destroy();
		}


	}
}


