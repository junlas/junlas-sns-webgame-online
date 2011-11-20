package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import junlas.components.base.JComponent;
	import junlas.components.base.JPanel;
	import junlas.components.base.JPushButton;
	import junlas.utils.math.mVector;
	
	
	/**
	 *@author lvjun01
	 */
	public class JPiclist extends JPanel {
		public static var __debug__:Boolean = false;
		protected var _leftButton:JPushButton;
		protected var _rightButton:JPushButton;
		protected var _leftEndButton:JPushButton;
		protected var _rightEndButton:JPushButton;
		protected var _isFirstShow:Boolean = true;
		private var _debugContent:Sprite;
		
		////////////////////
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		//标识：横向 or 竖向
		private var _direction:String;
		private var _lineRail:JLineRail;
		
		protected var _itemCompose:JItemCompose;
		protected var _firstShowIndex:int;
		protected var _itemRadius:Number;
		protected var _speed:Number;
		protected var _pageNum:int;
		protected var _isCircle:Boolean;
		
		public function JPiclist(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,direction:String = "horizontal", visibleShow:Sprite=null) {
			_direction = direction;
			super(parent, xpos, ypos, visibleShow);
		}
		
		override protected function init():void{
			super.init();
			_itemCompose = new JItemCompose();
			_firstShowIndex = 0;
			_itemRadius = 0;
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
			
			if(__debug__){
				_debugContent = new Sprite();
				_debugContent.name = "jpiclist_debug_content";
				_debugContent.x = content.x;
				_debugContent.y = content.y;
				addRawChild(_debugContent);
			}
		}
		
		override public function setSize(w:Number,h:Number):void{
			super.setSize(w,h);
			createRails();
		}
		
		private function createRails():void {
			_lineRail && _lineRail.destroy();
			var start:mVector;
			var end:mVector;
			switch(_direction){
				case HORIZONTAL:{
					start = new mVector(0,height>>1);
					end = new mVector(width,height>>1);
					break;
				}
				case VERTICAL:{
					start = new mVector(width>>1,0);
					end = new mVector(width>>1,height);
					break;
				}
			}
			_lineRail = new JLineRail(start,end);
			if(__debug__){
				_lineRail.drawLine(_debugContent);
			}
		}
		
		override public function draw():void{
			super.draw();
			
			_rightButton.x = width + 20;
			_leftEndButton.y = height - 20;
			_rightEndButton.x = width + 20;
			_rightEndButton.y = height - 20;
			
		}
		
		/**
		 * 
		 */
		private function drawHandle():void{
			var posArr:Vector.<mVector> = _lineRail.getPosPoints();
			if(_isFirstShow){
				_itemCompose.itemIndex = 0;
				_itemCompose.handleItemsPos(posArr,_pageNum,false);
				return;
			}
		}
		
		
		//////////////////////////////////////////////////////////////////////
		// 内部初始化构造需要设置的一些参数信息
		//////////////////////////////////////////////////////////////////////
		/**
		 * @initial 添加元素数组到Piclist中
		 */
		public function addPush(contentArr:Vector.<DisplayObject>):void {
			var item:JListItem;
			for each (var dis:DisplayObject in contentArr) {
				item = new JListItem(this.content,dis);
				_itemCompose.push(item);
			}
		}
		
		/**
		 * @initial 设置在第一个显示的item的索引
		 */
		public function addFirstShowIndex(firstShowIndex:int):void{
			if(firstShowIndex <0 || firstShowIndex >= _itemCompose.getLength()){
				throw new ArgumentError("起始显示的索引不在范围之内,请检查");
				return;
			}
			_firstShowIndex = firstShowIndex;
			_isFirstShow = true;
			drawHandle();
		}
		
		/**
		 * @initial 滚动栏一页需要显示的数目
		 */
		public function addPageNum(pageNum:int):void{
			_pageNum = pageNum;
			_lineRail.createSeparate(_pageNum,_itemRadius);
			drawHandle();
		}
		
		/**
		 * @initial 设置半径
		 */
		public function addItemRadius(itemRadius:Number):void{
			_itemRadius = itemRadius;
			_lineRail.createSeparate(_pageNum,_itemRadius);
			drawHandle();
		}
		
		/**
		 * @initial 设置速度
		 */
		public function addSpeed(speed:Number):void{
			_speed = speed;
		}
		
		/**
		 * @initial 设置是否是循环滚动
		 */
		public function addIsCircle(isCircle:Boolean):void{
			_isCircle = isCircle;
		}
		
		/**
		 * 重置Piclist
		 */
		public function reset():void{
			
		}
		//////////////////////////////////////////////////////////////////////
		// 对外主要接口
		//////////////////////////////////////////////////////////////////////
		public function previous():void {
			_isFirstShow = false;
			
		}
		
		public function next():void {
			_isFirstShow = false;
			
		}
		
		public function previousItems(itemsNum:int = 1):void {
			_isFirstShow = false;
			
		}
		
		public function nextItems(itemsNum:int = 1):void {
			_isFirstShow = false;
			
		}
		
		/**
		 * 销毁
		 */
		override public function destroy():void {
			
		}
		
	}
}