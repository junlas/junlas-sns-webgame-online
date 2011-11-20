package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import junlas.components.base.JComponent;
	import junlas.components.base.JPanel;
	import junlas.components.base.JPushButton;
	
	
	/**
	 *@author lvjun01
	 */
	public class JPiclist extends JPanel {
		public static var __debug__:Boolean = false;
		protected var _leftButton:JPushButton;
		protected var _rightButton:JPushButton;
		protected var _leftEndButton:JPushButton;
		protected var _rightEndButton:JPushButton;
		
		protected var _itemsArr:Vector.<JPiclistItem>;
		protected var _firstShowIndex:int;
		protected var _speed:Number;
		protected var _pageNum:int;
		protected var _isCircle:Boolean;
		
		public function JPiclist(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, visibleShow:Sprite=null) {
			super(parent, xpos, ypos, visibleShow);
		}
		
		override protected function init():void{
			super.init();
			_itemsArr = new Vector.<JPiclistItem>();
			_speed = 8;
			_pageNum = 1;
			_isCircle = false;
			setSize(320,80);
		}
		
		override protected function addChildren():void {
			super.addChildren();
			_leftButton = new JPushButton(null,-100,0,"left");
			_leftEndButton = new JPushButton(null,-100,height - 20,"leftend");
			_rightButton = new JPushButton(null,width + 100,0,"right");
			_rightEndButton = new JPushButton(null,width + 100,height - 20,"rightend");
			addRawChild(_leftButton);
			addRawChild(_leftEndButton);
			addRawChild(_rightButton);
			addRawChild(_rightEndButton);
		}
		
		override public function draw():void{
			super.draw();
			
			_rightButton.x = width + 20;
			_leftEndButton.y = height - 20;
			_rightEndButton.x = width + 20;
			_rightEndButton.y = height - 20;
			
		}
		
		
		//////////////////////////////////////////////////////////////////////
		// 内部初始化构造需要设置的一些参数信息
		//////////////////////////////////////////////////////////////////////
		/**
		 * @initial 添加元素数组到Piclist中
		 */
		public function addPush(contentArr:Vector.<DisplayObject>):void{
			var item:JPiclistItem;
			for each (var content:DisplayObject in contentArr) {
				item = new JPiclistItem(content);
			}
			
		}
		
		/**
		 * @initial 设置在第一个显示的item的索引
		 */
		public function addFirstShowIndex(firstShowIndex:int):void{
			
		}
		
		/**
		 * @initial 设置速度
		 */
		public function addSpeed(speed:Number):void{
		
		}
		
		/**
		 * @initial 滚动栏一页需要显示的数目
		 */
		public function addPageNum(pageNum:int):void{
			
		}
		
		/**
		 * @initial 设置是否是循环滚动
		 */
		public function addIsCircle(isCircle:Boolean):void{
			
		}
		
		//////////////////////////////////////////////////////////////////////
		// 对外主要接口
		//////////////////////////////////////////////////////////////////////
		public function previous():void {
			
		}
		
		public function next():void {
			
		}
		
		public function previousItems(itemsNum:int = 1):void {
			
		}
		
		public function nextItems(itemsNum:int = 1):void {
			
		}
		
		/**
		 * 销毁
		 */
		override public function destroy():void {
			
		}
		
	}
}