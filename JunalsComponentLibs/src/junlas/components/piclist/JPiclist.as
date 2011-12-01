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
		private var _isStart:Boolean;
		
		public function JPiclist(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,direction:String = "horizontal", visibleShow:Sprite=null,visibleConfig:JVisiualPiclistConf = null) {
			_direction = direction;
			visibleConfig = (visibleConfig?visibleConfig:new JVisiualPiclistConf());
			super(parent, xpos, ypos, visibleShow,visibleConfig);
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
			_rightButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{nextItems(2)});
			_leftButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{previousItems(1)});
			_rightEndButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{nextEnd()});
			_leftEndButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{previousEnd()});
			
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
			_minIndex = _dataInfo._firstShowIndex;
			_maxIndex = _dataInfo._firstShowIndex+_dataInfo._pageNum - 1;
			wellCheckPos();
		}
		
		/**
		 * 精确卸载
		 */
		private function wellUploadPos():void{
			var tweenArr:Vector.<JItem> = _dataInfo._contentArr.slice(_minIndex,_maxIndex+1);
			for(var i:int = 0;i<tweenArr.length;i++){
				var item:JItem = tweenArr[i];
				item.stopUpdatePos();
			}
		}
		
		/**
		 * 精确定位
		 */
		private function wellCheckPos():void{
			var tweenArr:Vector.<JItem> = _dataInfo._contentArr.slice(_minIndex,_maxIndex+1);
			for(var i:int = 0;i<tweenArr.length;i++){
				var distance:mVector = _lineRail.distanceInFact.clone();
				distance.length *= i;
				var pos:mVector = _lineRail.startPosInFactPoint.plus(distance);
				var item:JItem = tweenArr[i];
				item.updatePos(pos);
			}
		}
		
		/**
		 * 开始启动
		 */
		public function start():void{
			if(_isStart)return;
			_isStart = true;
			createRails();
			calculateSpeed();
			drawHandle();
		}
		
		private var _goDirection:String;
		private function run(event:Event):void {
			switch(_goDirection){
				case "previous":
					checkPrevious();
					break;
				case "next":
					checkNext();
					break;
				case "previousEnd":
					checkPreviousEnd();
					break;
				case "nextEnd":
					checkNextEnd();
					break;
				default:
					break;
			}
		}
		
		private function checkPrevious():void{
			var minItemPos:mVector = _dataInfo._contentArr[_minIndex].getPos().clone();
			minItemPos.rotateAngleEquals(-_lineRail.startPosInFactPoint.angle);
			var maxItemPos:mVector = _dataInfo._contentArr[_maxIndex].getPos().clone();
			maxItemPos.rotateAngleEquals(-_lineRail.posRightPoint.angle);
			if(maxItemPos.y <=0){
				_dataInfo._contentArr[_maxIndex].stopUpdatePos();
				_maxIndex--;
			}
			if(minItemPos.y <=0 && _maxIndex - _minIndex == _dataInfo._pageNum - 1){
				_goDirection = null;
				wellCheckPos();
				return;
			}
			var item:JItem;
			for(var i:int = _minIndex;i<=_maxIndex;i++){
				item = _dataInfo._contentArr[i];
				if(minItemPos.y <= 0 && i < _minIndex + _dataInfo._pageNum)continue;
				item.go(_dataInfo.speedVector);
			}
		}
		
		private function checkNext():void{
			var maxItemPos:mVector = _dataInfo._contentArr[_maxIndex].getPos().clone();
			maxItemPos.rotateAngleEquals(-_lineRail.endPosInFactPoint.angle);
			var minItemPos:mVector = _dataInfo._contentArr[_minIndex].getPos().clone();
			minItemPos.rotateAngleEquals(-_lineRail.posLeftPoint.angle);
			if(minItemPos.y >=0){
				_dataInfo._contentArr[_minIndex].stopUpdatePos();
				_minIndex++;
			}
			if(maxItemPos.y>=0 && _maxIndex - _minIndex == _dataInfo._pageNum - 1){
				_goDirection = null;
				wellCheckPos();
				return;
			}
			var item:JItem;
			for(var i:int = _minIndex;i<=_maxIndex;i++){
				item = _dataInfo._contentArr[i];
				if(maxItemPos.y >= 0 && i>_maxIndex-_dataInfo._pageNum)continue;
				item.go(_dataInfo.speedNegateVector);
			}
		}
		
		private function checkPreviousEnd():void{
			wellUploadPos();
			_minIndex = 0;
			_maxIndex = _dataInfo._pageNum - 1;
			_maxIndex = _dataInfo._contentArr.length > _maxIndex ? _maxIndex:(_dataInfo._contentArr.length - 1);
			wellCheckPos();
			_goDirection = null;
		}
		
		private function checkNextEnd():void{
			wellUploadPos();
			_minIndex = _dataInfo._contentArr.length - _dataInfo._pageNum;
			_maxIndex = _dataInfo._contentArr.length - 1;
			_maxIndex = _maxIndex >= _minIndex ? _maxIndex:_minIndex;
			wellCheckPos();
			_goDirection = null;
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
			_isStart && wellUploadPos();
		}
		
		/**
		 * 滚动栏一页需要显示的数目
		 */
		public function setPageNum(pageNum:int):void{
			_dataInfo._pageNum = pageNum;
			_isStart && _lineRail.createSeparate();
		}
		
		/**
		 * 设置半径
		 */
		public function setItemRadius(itemRadius:Number):void{
			_dataInfo._itemRadius = itemRadius;
			_isStart && _lineRail.init();//createSeparate();在init();方法里已经执行过
		}
		
		/**
		 * 设置速度
		 */
		public function setSpeed(speed:Number):void{
			_dataInfo._speed = speed;
			_isStart && calculateSpeed();
		}
		
		/**
		 * 设置2边的边距
		 */
		public function setBetweenSidesDist(betweenSidesDist:Number):void{
			_dataInfo._betweenSidesDist = betweenSidesDist;
			_isStart && _lineRail.createSeparate();
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
			drawHandle();
		}
		
		/**
		 * 删除PicList中的某一个显示Item(效率不高，不建议频繁调用)
		 */
		public function deleteByItem(item:DisplayObject):void{
			for(var i:int = _dataInfo._contentArr.length - 1;i>=0;i--){
				var itemObj:JItem = _dataInfo._contentArr[i];
				if(itemObj.child == item){
					_dataInfo._contentArr.splice(i,1);
					itemObj.destroy();
					break;
				}
			}
			if(i >= 0){
				if(i < _minIndex){
					_minIndex--;
					_maxIndex--;
				}
			}
			wellCheckPos();
		}
		
		/**
		 * 删除PicList中的某一个显示Item(效率不高，不建议频繁调用)
		 */
		public function deleteByIndex(index:int):void{
			if(!(index >= 0 && index < _dataInfo._contentArr.length)) {
				return;
			}
			var itemObj :JItem = _dataInfo._contentArr.splice(index,1)[0] as JItem;
			itemObj.destroy();
			if(index >= 0){
				if(index < _minIndex){
					_minIndex--;
					_maxIndex--;
				}
			}
			wellCheckPos();
		}
		//////////////////////////////////////////////////////////////////////
		// 对外主要接口1,2,3,4个函数
		//////////////////////////////////////////////////////////////////////
		public function previousItems(itemsNum:int = 1):void {
			var index:int = _minIndex - 1;
			for(var i:int = index;(i>index-itemsNum) && (i >= 0);i--){
				var item:JItem = _dataInfo._contentArr[i];
				item.updatePos(_dataInfo._contentArr[_minIndex].getPos().plus(_lineRail.distanceNegateInFact));
				_minIndex = i;
			}
			_goDirection = "previous";
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
			_goDirection = "previousEnd";
		}
		
		public function nextEnd():void {
			_goDirection = "nextEnd";
		}
		
		/**
		 * 销毁
		 */
		override public function destroy():void {
			removeEventListener(Event.ENTER_FRAME,run);
			_dataInfo.destroy();
			_dataInfo = null;
			_lineRail.destroy();
			_lineRail = null;
			this.content.removeChild(_pmc);
			_isStart = false;
			super.destroy();
		}
		
	}
}