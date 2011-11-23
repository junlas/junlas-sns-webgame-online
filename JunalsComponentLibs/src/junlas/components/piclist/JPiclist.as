package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
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
		private var _debugContent:Sprite;
		private var _pmc:Sprite;
		////参数信息///
		protected var _dataInfo:JDataInfo;
		private var _lineRail:JLineRail;
		
		protected var _leftButton:JPushButton;
		protected var _rightButton:JPushButton;
		protected var _leftEndButton:JPushButton;
		protected var _rightEndButton:JPushButton;
		
		///////////横向、纵向2个常量定义/////////
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		//标识：横向 or 竖向
		private var _direction:String;
		/////////////////////////////
		private var _minIndex:int;
		private var _maxIndex:int;
		
		public function JPiclist(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,direction:String = "horizontal", visibleShow:Sprite=null) {
			_direction = direction;
			super(parent, xpos, ypos, visibleShow);
		}
		
		override protected function init():void{
			super.init();
			_pmc = new Sprite();
			this.content.addChild(_pmc);
			_dataInfo = new JDataInfo();
			_dataInfo._contentArr = new Vector.<JItem>();
			_dataInfo._firstShowIndex = 0;
			_dataInfo._itemRadius = 1;
			_dataInfo._speed = 2;
			_dataInfo._pageNum = 4;
			_dataInfo._betweenSidesDist = 10;
			_dataInfo._isCircle = false;
			addEventListener(Event.ENTER_FRAME,run);
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
			_rightButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{nextItems(3)});
			_leftButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{previousItems(3)});
			
			if(__debug__){
				_debugContent = new Sprite();
				_debugContent.name = "jpiclist_debug_content";
				_debugContent.x = content.x;
				_debugContent.y = content.y;
				addChildAt(_debugContent,1);
				_debugContent.mouseChildren = _debugContent.mouseEnabled = false;
			}
			
		}
		
		override public function draw():void{
			super.draw();
			
			_rightButton.x = width + 20;
			_leftEndButton.y = height - 20;
			_rightEndButton.x = width + 20;
			_rightEndButton.y = height - 20;
			
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
			_lineRail = new JLineRail(start,end,_dataInfo);
			if(__debug__){
				_lineRail.drawDebug(_debugContent);
			}
		}
		
		private function calculateSpeed():void{
			_dataInfo.calculateSpeedVect(_lineRail.betweenPointsVector);
		}
		
		private function drawHandle():void{
			var tweenArr:Vector.<JItem> = _dataInfo._contentArr.slice(_dataInfo._firstShowIndex,_dataInfo._firstShowIndex+_dataInfo._pageNum);
			checkPos(tweenArr);
		}
		
		/**
		 * 精确定位
		 */
		private function checkPos(tweenArr:Vector.<JItem>):void{
			_minIndex = tweenArr[0].getItsIndex();
			for(var i:int = 0;i<tweenArr.length;i++){
				var distance:mVector = _lineRail.distanceInFact.clone();
				distance.length *= i;
				var pos:mVector = _lineRail.startPosInFactPoint.plus(distance);
				var item:JItem = tweenArr[i];
				item.updatePos(pos);
			}
			_maxIndex = item.getItsIndex();
		}
		
		/**
		 * 开始启动
		 */
		public function start():void{
			createRails();
			calculateSpeed();
			drawHandle();
		}
		
		private var _goDirection:String;
		private function run(event:Event):void {
			switch(_goDirection){
				case "previous":
					
					break;
				case "next":
					checkNext();
					break;
				case "previousEnd":
					
					break;
				case "nextEnd":
					
					break;
				default:
					break;
			}
		}
		
		private function checkNext():void{
			var maxItemPos:mVector = _dataInfo._contentArr[_maxIndex].getPos().clone();
			maxItemPos.angle += _lineRail.endPosInFactPoint.angle;
			trace(maxItemPos.y);
			if(maxItemPos.y<=0)return;
			//这里做好做一次检验坐标......先保留，迟会做
			var item:JItem;
			for(var i:int = _minIndex;i<=_maxIndex;i++){
				item = _dataInfo._contentArr[i];
				item.go(_dataInfo.speedNegateVector);
			}
		}
		
		//////////////////////////////////////////////////////////////////////
		// 内部初始化构造需要设置的一些参数信息
		//////////////////////////////////////////////////////////////////////
		/**
		 * 添加元素数组到Piclist中
		 */
		public function setPushData(contentArr:Vector.<DisplayObject>):void {
			var transContentArr:Vector.<JItem> = _dataInfo._contentArr;
			var item:JItem;
			for each(var dis:DisplayObject in contentArr){
				item = new JItem(_pmc,dis);
				transContentArr.push(item);
				item.setItsIndex(transContentArr.indexOf(item));
				if(__debug__) {
					item.initDebugPmc(_debugContent);
				}
			}
		}
		
		/** 
		 * 设置在第一个显示的item的索引
		 */
		public function setFirstShowIndex(firstShowIndex:int):void{
			_dataInfo._firstShowIndex = firstShowIndex;
		}
		
		/**
		 * 滚动栏一页需要显示的数目
		 */
		public function setPageNum(pageNum:int):void{
			_dataInfo._pageNum = pageNum;
		}
		
		/**
		 * 设置半径
		 */
		public function setItemRadius(itemRadius:Number):void{
			_dataInfo._itemRadius = itemRadius;
		}
		
		/**
		 * 设置速度
		 */
		public function setSpeed(speed:Number):void{
			_dataInfo._speed = speed;
		}
		
		/**
		 * 设置2边的边距
		 */
		public function setBetweenSidesDist(betweenSidesDist:Number):void{
			_dataInfo._betweenSidesDist = betweenSidesDist;
		}
		
		/**
		 * 设置是否是循环滚动
		 */
		public function setIsCircle(isCircle:Boolean):void{
			_dataInfo._isCircle = isCircle;
		}
		
		/**
		 * 重置Piclist
		 */
		public function reset():void{
			
		}
		//////////////////////////////////////////////////////////////////////
		// 对外主要接口1,2,3,4个函数
		//////////////////////////////////////////////////////////////////////
		public function previousItems(itemsNum:int = 1):void {
			
		}
		
		public function nextItems(itemsNum:int = 1):void {
			var index:int = _maxIndex+1;
			for(var i:int = index;(i<index +itemsNum) && (i<_dataInfo._contentArr.length);i++){
				var item:JItem = _dataInfo._contentArr[i];
				item.updatePos(_dataInfo._contentArr[_maxIndex].getPos().plus(_lineRail.distanceInFact));
				_maxIndex = i;
			}
			_goDirection = "next";
		}
		
		public function previousEnd():void {
			
		}
		
		public function nextEnd():void {
			
		}
		
		/**
		 * 销毁
		 */
		override public function destroy():void {
			
		}
		
	}
}