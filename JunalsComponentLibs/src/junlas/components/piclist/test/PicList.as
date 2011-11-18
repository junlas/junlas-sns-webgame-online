package junlas.components.piclist.test
{
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	import flash.display.Sprite;	
	import junlas.utils.math.*;

	//TODO:考虑祖玛移动模式
	//TODO:插件系统;
	//TODO:做一个模板设定插件
	//TODO:自动放大插件_itemAutoSize
	//TODO:调整贝塞尔曲线的效率
	//TODO:位图插件
	
	/**
	 * 当ITEM被点击时触发
	 * @eventType zlong.breathxue_zelda.PicList.ItemEvent.CLICK_ITEM
	 */
	[Event(name="CLICK_ITEM", type="zlong.breathxue_zelda.PicList.ItemEvent")]

	/**
	 * ITEM被建立时触发
	 * @eventType zlong.breathxue_zelda.PicList.ItemEvent.ITEM_CREATE
	 */
	[Event(name="ITEM_CREATE", type="zlong.breathxue_zelda.PicList.ItemEvent")]

	/**
	 * ITEM被删除时触发
	 * @eventType zlong.breathxue_zelda.PicList.ItemEvent.ITEM_DELETE
	 */
	[Event(name="ITEM_DELETE", type="zlong.breathxue_zelda.PicList.ItemEvent")]

	/**
	 * ITEM被鼠标略过时触发
	 * @eventType zlong.breathxue_zelda.PicList.ItemEvent.ITEM_ROLL_OVER
	 */
	[Event(name="ITEM_ROLL_OVER", type="zlong.breathxue_zelda.PicList.ItemEvent")]

	/**
	 * ITEM被鼠标略出时触发
	 * @eventType zlong.breathxue_zelda.PicList.ItemEvent.ITEM_ROLL_OUT
	 */
	[Event(name="ITEM_ROLL_OUT", type="zlong.breathxue_zelda.PicList.ItemEvent")]

	/**
	 * @author breath xue
	 * PicList类,图片列表类
	 * 将用户加入一组显示对象或显示对象反射类名.根据设定放在指定轨道上显示.形成一个显示列表.
	 * 用户可以移动整个显示列表,以到达翻阅效果
	 */
	public class PicList extends EventDispatcher
	{
		/**
		 * 全局debug开关
		 */
		public static var __debug__ : Boolean = false;
		/**
		 * 停止速度,当移动速度小于该速度就完全停止
		 */
		public static const MINI_SPEED_RATIO : Number = 0.3;
		/**
		 * 规格移动误差
		 */
		public static const IGNORE_SPACE : Number = 12;
		private static var DesignObjectId : int = 0;

		
		private static function GetDefinedName(Oj : PicList) : String
		{
			var name : String = typeof(Oj) + DesignObjectId;
			DesignObjectId++;
			return name;
		}

		
		//父显对象,传入
		private var __pmc : Sprite;
		private var __mc : Sprite;
		private var _picArr : Array;
		private var _firstHandInPicArr : int;
		private var _showItemArr : Array;

		private var _running : Boolean;

		private var _firstHand : int;
		private var _endHand : int;

		private var _autoAdjust : Boolean;
		private var _chiefItemNum : int;
		private var _chiefItemPoint : Number;
		private var _isUserSettingChief : Boolean;

		
		//轨道
		internal var _railMap : RailMap;
		private var _speed : Number;

		//***********************************getter_setter******************************
		//PicList对象名,无意义
		private var _name : String;
		private var _x : Number;
		private var _y : Number;
		private var _rails : Array;

		private var _isAddSpeed : Boolean;
		private var _addSpeed : Number;
		private var _friction : Number;

		internal var _itemRadius : Number;
		private var _isFixedItemSpaceBetween : Boolean;
		//item间距
		private var _itemSpaceBetween : Number;//TODO:等大小模式和非等大小模式
		internal var _itemAlignVecter : mVector;
		internal var _itemChangeAngleByRail : Boolean;

		//item是否循环移动,//到底就不能动了
		private var _isCircular : Boolean;  
		private var _isSeriesCreateItem : Boolean;
		private var _maskLength : Number;

		
		/**
		 * picList移动图形列表工具
		 * @param pmc 提供的父显示容器,piclist将放在这个显示容器中显示
		 * @param picArr 提供的需要显示的数组,数组中可以放置显示对象,或者用于反射的显示对象的类名
		 * @param firstHandInPicArr 设置picArr在picList中第一个位置的名字.
		 */
		public function PicList(pmc : Sprite,picArr : Array = null,firstHandInPicArr : int = 0) 
		{
			CurveRail.MINI_BLOCK = 1.5;
			_running = false;
			__pmc = pmc;
			_firstHandInPicArr = firstHandInPicArr;
			_picArr = picArr;
			_isUserSettingChief = false;
			if(_picArr == null) 
			{
				_picArr = new Array();
			}
			
			__pmc.addEventListener(Event.ENTER_FRAME, run);
			
			//默认参数设定
			undefinedSetting();
			//初始化	
			initialzation();
		}

		public function del() : void
		{
			_picArr = null;
			_running = false;
			__pmc.removeEventListener(Event.ENTER_FRAME, run);
			delRails();
			delItem();
			delDis();
		}

		/**
		 * 设置需要显示的数组,设置完之后,自动reset刷新.
		 * @param arr 提供的需要显示的数组,数组中可以放置显示对象,或者用于反射的显示对象的类名
		 * @param firstHandInPicArr 设置picArr在picList中第一个位置的名字.
		 */
		public function setItemArray(arr : Array,firstHandInPicArr : int = 0) : void
		{
			_picArr = arr;
			_firstHandInPicArr = firstHandInPicArr;
			reset();
		}

		/**
		 * 刷新picList
		 */
		public function reset() : void
		{
			_running = false;
			delItem();
			delDis();
			initialzation();
		}
		/**
		 * 向前移动
		 */
		public function forward() : void 
		{
			if(_running)
			{
				if(_isAddSpeed) 
				{
					_speed -= _addSpeed;
				}
				else 
				{
					_speed = -_addSpeed;
				}
				_autoAdjust = false;
			}
		}
		/**
		 * 向后移动
		 */
		public function back() : void 
		{
			if(_running)
			{
				if(_isAddSpeed) 
				{
					_speed += _addSpeed;
				}
				else 
				{
					_speed = _addSpeed;
				}
				_autoAdjust = false;
			}
		}
		/**
		 * 向前移动一个定量距离,1个或数个item的距离
		 * @param num 移动ITEM距离的数量
		 */
		public function nextItem(num : int = 1) : void 
		{
			if(_running)
			{
				if( !_autoAdjust)
				{
					_chiefItemNum = getItemNumInChiefPoint();
					_autoAdjust = true;
				}
				//当第一多个移动到一般时,反推就不会不规则了//或者已经被打断过
				else if(_chiefItemNum < getItemNumInChiefPoint()) 
				{
					var temp : int = _chiefItemNum % num;
					_chiefItemNum = temp;
				}
				_chiefItemNum += num;
			}
		}
		
		/**
		 * 向后移动一个定量距离,1个或数个item的距离
		 * @param num 移动ITEM距离的数量
		 */
		public function prevItem(num : int = 1) : void 
		{
			if(_running)
			{
				if( !_autoAdjust)
				{
					_chiefItemNum = getItemNumInChiefPoint();
					_autoAdjust = true;
				}
				//当第一多个移动到一般时,反推就不会不规则了
				else if(_chiefItemNum > getItemNumInChiefPoint()) 
				{
					var temp : int = _chiefItemNum % num;
					_chiefItemNum = temp;
				}
				//trace("b", getItemNumInChiefPoint());
				_chiefItemNum -= num;
			}
		}

		/**
		 * 获得轨道长度,除去了遮罩缓冲距离
		 */
		public function getRailsLength() : Number
		{
			return _railMap.totalDistance - 2 * _maskLength;
		}

		//////////////////////////private///////////////////////////////

		/**
		 * 默认参数设定
		 */
		private function undefinedSetting() : void 
		{
			_name = GetDefinedName(this);

			_x = 0;
			_y = 0;
			
			_itemRadius = 30;
			_itemAlignVecter = new mVector(0, 0);
			_itemSpaceBetween = 15;
			
			_itemChangeAngleByRail = false;
			_isSeriesCreateItem = true;
			
			_rails = new Array(new LineRail(0, 0, 300, 0));
			_maskLength = this._itemRadius * 2;
			_rails = addMaskRails(_rails);
			//trace("a", (_rails[0] as AbstractRail).distance);
			_chiefItemPoint = (_rails[0] as AbstractRail).distance + _itemSpaceBetween / 2;
			//trace(_chiefItemPoint);
			//			_itemStaticScaleX = 1;
			//			_itemStaticScaleY = 1;
			//			_itemScaleSpeed = 0.2;
			//			_itemScaleValues = 2;
			//			_itemButtonMode = true;
			//			_itemAutoSize = false;

			_isCircular = true;
			_isAddSpeed = true;
			_addSpeed = 2;
			_friction = 0.8;
		}

		/**
		 * 添加遮罩缓冲轨道
		 */
		private function addMaskRails(rails : Array) : Array 
		{
			var addRails : AbstractRail;
			var end : mVector;
				
			addRails = rails[0] as AbstractRail;
			end = new mVector(0, _maskLength);
			end.angle = addRails.getRotationByDistance(0) - 180;
			end.plusEquals(new mVector(addRails.startPoint.x, addRails.startPoint.y));
			rails.unshift(new LineRail(end.x, end.y, addRails.startPoint.x, addRails.startPoint.y));
				
			addRails = rails[rails.length - 1] as AbstractRail;
			end = new mVector(0, _maskLength);
			end.angle = addRails.getRotationByDistance(addRails.distance);
			end.plusEquals(new mVector(addRails.endPoint.x, addRails.endPoint.y));
			rails.push(new LineRail(addRails.endPoint.x, addRails.endPoint.y, end.x, end.y));
			return rails;
		}
		/**
		 * 删除遮罩缓冲轨道
		 */
		private function removeMaskRails(rails : Array) : Array 
		{
			rails.pop();
			rails.shift();
			return rails;
		}
		/**
		 * 初始化
		 */
		private function initialzation() : void
		{
			_firstHand = _endHand = this._firstHandInPicArr % _picArr.length;
			_showItemArr = new Array();
			_speed = 0;
			_chiefItemNum = 0;
			_autoAdjust = true;
			initDis();
			initRails();
			initItem();
		}
		/**
		 * 初始化轨道
		 */
		private function initRails() : void 
		{
			RailMap.__debug__ = __debug__;
			_railMap = new RailMap(__mc);
			_railMap.rails = _rails;
		}
		/**
		 * 删除轨道
		 */
		private function delRails() : void 
		{
			_railMap.del();
			_railMap = null;
		}
		/**
		 * 初始化显示对象
		 */
		private function initDis() : void 
		{
			__mc = new Sprite();
			__mc.x = _x;
			__mc.y = _y;
			__pmc.addChild(__mc);
		}

		/**
		 * 删除显示对象
		 */
		private function delDis() : void
		{
			__pmc.removeChild(__mc);
			__mc = null;
		}

		/**
		 * 初始化单个ITEM
		 */
		private function initItem() : void 
		{
			if(_picArr == null || _picArr.length == 0) 
			{
				return;
			}

			_running = true;
		}
		/**
		 * 删除全部ITEM
		 */
		private function delItem() : void
		{
			for (var i : int = 1;i < _showItemArr.length;i++) 
			{
				(_showItemArr[i] as Item).del();
			}
			_showItemArr = null;
		}
		/**
		 * 每帧运行函数
		 */
		private function run(e : Event) : void 
		{
			if(_running) 
			{
				checkEndItem();
				checkFirstItem();
				checkCircular();
				autoMove();
				runMove();
			}
		}
		/**
		 * 检查循环控制
		 */
		private function checkCircular() : void 
		{
			if(!_isCircular)
			{
				if(_firstHand == _firstHandInPicArr)
				{			
					if(_chiefItemNum < 0 && (_showItemArr[0] as Item).frontDistance - _chiefItemPoint > _itemRadius || _speed > 0 && !_autoAdjust && (_showItemArr[0] as Item).frontDistance > _chiefItemPoint)
					{
						_chiefItemNum = 0;
						_autoAdjust = true;
					}
				}
				if(_firstHandInPicArr == 0 && _endHand == _picArr.length - 1 || _endHand == _firstHandInPicArr - 1)
				{
					//trace("bbbbbbbb");
					if((_showItemArr[_showItemArr.length - 1] as Item).behindDistance < _railMap.totalDistance - _maskLength && _speed < 0)
					{
						//计算最后一个出借后,第一个的编号
						_chiefItemNum = _showItemArr.length - Math.round((_railMap.totalDistance - _maskLength - _chiefItemPoint) / (_itemRadius * 2 + _itemSpaceBetween));
						//trace("aaaa",_chiefItemNum);
						_autoAdjust = true;
					}
					//										if(_chiefItemNum >= 0)
					//										{
					//					_chiefItemNum = getItemNumInChiefPoint() - 1;
					//										}

					//					_autoAdjust = true;
				}
			}
		}
		/**
		 * 控制移动函数
		 */
		private function runMove() : void 
		{
			for (var i : int = 0;i < _showItemArr.length;i++) 
			{
				var tempItem : Item = _showItemArr[i];
				tempItem.forward(_speed);
			}
			if(_isAddSpeed) 
			{
				_speed *= _friction;
				if(Math.abs(_speed) < _addSpeed * PicList.MINI_SPEED_RATIO)
				{
					_speed = 0;
				}
			}
			else 
			{
				_speed = 0;
			}
		}
		/**
		 * 自动移动函数
		 */
		private function autoMove() : void
		{
			//oldautoMove();
			//trace(_chiefItemNum);
			if(_autoAdjust && (_showItemArr[0] as Item))
			{
				var targetItemPoint : Number = (_showItemArr[0] as Item).frontDistance + _chiefItemNum * (_itemRadius * 2 + _itemSpaceBetween);//目标点的前边界的距离
				if(Math.abs(targetItemPoint - _chiefItemPoint) < PicList.IGNORE_SPACE)
				{
					return;
				}
				if(targetItemPoint > _chiefItemPoint) 
				{
					if(_isAddSpeed) 
					{
						_speed -= _addSpeed;
					}
					else 
					{
						_speed = -_addSpeed;
					}
				}
				else
				{
					if(_isAddSpeed) 
					{
						_speed += _addSpeed;
					}
					else 
					{
						_speed = _addSpeed;
					}
				}
				//trace(targetItemPoint);
			}
		}

		//		private function oldautoMove() : void 
		//		{
		//			//在没有到达目的前适时加速
		//			if(_moveItemNum != 0)
		//			{
		//				var lessSpeedLength : Number = 0;
		//				for(var i : Number = Math.abs(_speed) + Math.abs(_addSpeed);i > Math.abs(_addSpeed) * PicList.MINI_SPEED_RATIO;i *= _friction) 
		//				{
		//					lessSpeedLength += i;
		//				}
		////				lessSpeedLength + Math.abs(_speed);
		//			}
		//			if(_moveItemNum > 0) 
		//			{
		//				var targetItemLeftX : Number = (_showItemArr[0] as Item).frontDistance + _moveItemNum * (_itemRadius * 2 + _itemSpaceBetween);//目标点的前边界的距离
		//				if((targetItemLeftX - _itemSpaceBetween) > lessSpeedLength) 
		//				{
		//					forward();
		//				}
		//				_autoAdjust = 1;
		//			}
		//			else if(_moveItemNum < 0) 
		//			{
		//				var targetItemRightX : Number = (_showItemArr[_showItemArr.length - 1] as Item).behindDistance + _moveItemNum * (_itemRadius * 2 + _itemSpaceBetween);
		//				if(_railMap.totalDistance - _itemSpaceBetween - targetItemRightX > lessSpeedLength) 
		//				{
		//					back();
		//				}
		//				_autoAdjust = -1;
		//			}//在到达目的后调整.
		//			else if(_autoAdjust > 0) 
		//			{
		//				
		//				var tempItem3 : Item = _showItemArr[0];
		//				if(Math.abs(tempItem3.frontDistance - _itemSpaceBetween) > _addSpeed * PicList.MINI_SPEED_RATIO)
		//				{
		//					_speed += tempItem3.frontDistance < _itemSpaceBetween ? _addSpeed * PicList.MINI_SPEED_RATIO : -_addSpeed * PicList.MINI_SPEED_RATIO;
		//				}
		//				else if(_speed == 0)
		//				{
		//					_autoAdjust = 0;
		//				}
		//			}
		//			else if(_autoAdjust < 0)
		//			{
		//				var tempItem4 : Item = _showItemArr[_showItemArr.length - 1];
		//				if(Math.abs(_railMap.totalDistance - _itemSpaceBetween - tempItem4.behindDistance) > _addSpeed * PicList.MINI_SPEED_RATIO)
		//				{
		//					_speed += tempItem4.behindDistance < (_railMap.totalDistance - _itemSpaceBetween) ? _addSpeed * PicList.MINI_SPEED_RATIO : -_addSpeed * PicList.MINI_SPEED_RATIO;
		//				}
		//				else if(_speed == 0)
		//				{
		//					_autoAdjust = 0;
		//				}
		//			}
		//		}

		/**
		 * 创建第一个ITEM
		 */
		private function createFirstItem() : void 
		{					
			if(_endHand > _picArr.length - 1)
			{
				_firstHand = _endHand = this._firstHandInPicArr % _picArr.length;
			}	
			var tempItem : Item = new Item(this, __mc);
			_railMap.addCar(tempItem.car);
			tempItem.frontDistance = _chiefItemPoint;
			tempItem.addDis(_picArr[_endHand], _endHand);
			_showItemArr.push(tempItem);
			updateItemListNum();
		}
		/**
		 * 为尾部创建ITEM
		 */
		private function createNextItem() : Boolean 
		{
			
			//非循环
			if(!_isCircular && (_firstHandInPicArr == 0 && _endHand == _picArr.length - 1 || _endHand == _firstHandInPicArr - 1))
			{
				return false;
			}
			
			
			//***********调整指针*************
			if(_endHand >= _picArr.length - 1)
			{
				_endHand = 0;
			}
			else
			{
				_endHand++;
			}
			

			//trace("_endHand", _endHand);

			var lastItem : Item = _showItemArr[_showItemArr.length - 1] as Item;
			if(!lastItem)
			{
				throw new ArgumentError("_showItemArr[" + (_showItemArr.length - 1) + "] is not a Item");
			}
			
			var tempItem : Item = new Item(this, __mc);
			_railMap.addCar(tempItem.car);

			tempItem.distance = lastItem.distance + _itemSpaceBetween + _itemRadius * 2;//TODO:动态半径
			tempItem.addDis(_picArr[_endHand], _endHand);
			_showItemArr.push(tempItem);
			
			updateItemListNum();
			return true;
		}

		
		/**
		 * 为头部创建ITEM
		 */
		private function createPrevItem() : Boolean 
		{		
			//非循环检查
			if(!_isCircular && _firstHand == _firstHandInPicArr)
			{
				return false;
			}
			
			//***********调整指针*************
			if(_firstHand <= 0)
			{
				_firstHand = _picArr.length - 1;
			}
			else
			{
				_firstHand--;
			}
			
			//trace("_firstHand", _firstHand);
			var firstItem : Item = _showItemArr[0] as Item;
			if(!firstItem)
			{
				throw new ArgumentError("_showItemArr[0] is not a Item");
			}
			
			var tempItem : Item = new Item(this, __mc);
			_railMap.addCar(tempItem.car);
			tempItem.distance = firstItem.distance - _itemSpaceBetween - _itemRadius * 2;//TODO:动态半径
			tempItem.addDis(_picArr[_firstHand], _firstHand);
			_showItemArr.unshift(tempItem);
			
			if(this._autoAdjust)
			{
				_chiefItemNum++;
			}
			//trace(_chiefItemNum);

			updateItemListNum();
			
			return true;
		}

		/**
		 * 删除头部ITEM
		 */
		private function removePrevItem() : Boolean 
		{
			_firstHand++;
			if(_firstHand >= _picArr.length) 
			{
				_firstHand = 0;
			}
			//trace("_firstHand", _firstHand);
			var tempItem : Item = _showItemArr.shift();
			tempItem.del();
			
			if(this._autoAdjust)
			{
				_chiefItemNum--;
			}
			//trace(_chiefItemNum);

			updateItemListNum();
			return true;
		}

		/**
		 * 删除尾部ITEM
		 */
		private function removeNextItem() : Boolean 
		{
			
			_endHand--;
			if(_endHand < 0) 
			{
				_endHand = _picArr.length - 1;
			}
			//trace("_endHand", _endHand);
			var tempItem : Item = _showItemArr.pop();
			tempItem.del();
			
			updateItemListNum();
			return true;
		}

		/**
		 * 检查头部ITEM位置
		 */
		private function checkFirstItem() : void 
		{
			var firstItem : Item;
			var hasRuning : Boolean = true;
			
			//*********如果显示数组中没有内容************
			if(_showItemArr.length == 0)
			{
				createFirstItem();
				hasRuning = _isSeriesCreateItem;
			}
			
			//连续制造直到无法制造
			for (;hasRuning;) 
			{
				hasRuning = false;
				firstItem = _showItemArr[0] as Item;
				//检查是否需要建立新ITEM
				if(firstItem.distance - _itemSpaceBetween - _itemRadius * 2 > 0) 
				{
					//trace(firstItem.frontDistance);
					hasRuning = createPrevItem() && _isSeriesCreateItem;
				}
			}
			
			//删除一定是连续的
			hasRuning = true;
			for (;hasRuning;) 
			{
				hasRuning = false;
				firstItem = _showItemArr[0] as Item;
				if(!firstItem)
				{
					break;
				}
				if(firstItem.distance < 0) 
				{
					hasRuning = removePrevItem();
				}
			}
		}

		
		/**
		 * 检查尾部ITEM位置
		 */
		private function checkEndItem() : void 
		{
			var endItem : Item;
			var hasRuning : Boolean = true;
			//*********如果显示数组中没有内容************
			if(_showItemArr.length == 0)
			{
				createFirstItem();
				hasRuning = _isSeriesCreateItem;
			}
			
			//连续制造直到无法制造
			for (;hasRuning;) 
			{
				hasRuning = false;
				endItem = _showItemArr[_showItemArr.length - 1] as Item;
				//检查是否需要建立新ITEM
				if(endItem.distance + _itemSpaceBetween + _itemRadius * 2 < _railMap.totalDistance) 
				{	
					hasRuning = createNextItem() && _isSeriesCreateItem;
				}
			}
			
			//删除一定是连续的
			hasRuning = true;
			for (;hasRuning;) 
			{
				endItem = _showItemArr[_showItemArr.length - 1] as Item;
				hasRuning = false;
				if(!endItem)
				{
					break;
				}
				if(endItem.distance > _railMap.totalDistance) 
				{
					hasRuning = removeNextItem();
				}
			}
		}

		/**
		 * 更新ITEM的显示编号
		 */
		private function updateItemListNum() : void
		{
			for(var i : int = 0 ;i < _showItemArr.length ;i++)
			{
				(_showItemArr[i] as Item).setPicListNum(i);
			}
		}

		//获得离基本点最近的ITEM数据编号
		private function getItemNumInChiefPoint() : int 
		{
			var tempDistance : Number = Number.MAX_VALUE;
			var t : Number;
			for (var i : int = 0;i < _showItemArr.length;i++) 
			{
				t = Math.abs((_showItemArr[i] as Item).frontDistance - this._chiefItemPoint);
				if( t > tempDistance)
				{
					return i - 1;
				}
				else
				{
					tempDistance = t;
				}
			}
			return _showItemArr.length - 1;
		}

		////////////////////////get/set/////////////////////////////////

		/**
		 * 暂停
		 */
		public function set pause(v : Boolean) : void
		{
			_running = !v;
		}

		public function get pause() : Boolean
		{
			return !_running;
		}

		/**
		 * piclist对象的名字
		 */
		public function set name(v : String) : void
		{
			_name = v;
		}

		public function get name() : String
		{
			return _name;
		}
		/**
		 * 是否显示
		 */
		public function set visible(v : Boolean) : void
		{
			__mc.visible = v;
		}

		public function get visible() : Boolean
		{
			return __mc.visible;
		}
		
		public function set x(num : Number) : void 
		{
			__mc.x = _x = num;
		}

		public function get x() : Number 
		{
			return _x;
		}

		public function set y(num : Number) : void 
		{
			
			__mc.y = _y = num;
		}

		public function get y() : Number 
		{
			
			return _y;
		}

		/**
		 * 设定轨道
		 */
		public function set rails(rails : Array) : void
		{
			_rails = rails;
			_railMap.rails = addMaskRails(_rails);
			if(!this._isUserSettingChief)
			{
				_chiefItemPoint = (_rails[0] as AbstractRail).distance + _itemSpaceBetween / 2;
			}
		}

		public function get rails() : Array
		{
			return removeMaskRails(_railMap.rails.slice(0));
		}
		/**
		 * 是否连续创建ITEM.否则每帧只创建一额ITEM
		 */
		public function get isSeriesCreateItem() : Boolean
		{
			return _isSeriesCreateItem;
		}

		public function set isSeriesCreateItem(value : Boolean) : void
		{
			_isSeriesCreateItem = value;
		}
		/**
		 * 是否循环显示,是否循环显示数据列表中的东西.
		 */
		public function get isCircular() : Boolean
		{
			return _isCircular;
		}

		public function set isCircular(value : Boolean) : void
		{
			_isCircular = value;
		}

		/**
		 * 遮罩缓冲的长度
		 */
		public function get maskLength() : Number
		{
			return _maskLength;
		}

		public function set maskLength(value : Number) : void
		{
			_maskLength = value;
			rails = rails;
			//_railMap.rails = addMaskRails(removeMaskRails(_railMap.rails.slice(0)));
		}
		/**
		 * 基本点,第一个ITEM的开始点.
		 */
		public function get chiefItemPoint() : Number
		{
			return _chiefItemPoint - this._maskLength;
		}

		public function set chiefItemPoint(value : Number) : void
		{
			_chiefItemPoint = value + this._maskLength;
			this._isUserSettingChief = true;
		}
		/**
		 * 速度/加速度
		 */
		public function set speed(num : Number) : void 
		{
			
			_addSpeed = num;
		}

		public function get speed() : Number 
		{
			
			return _addSpeed;
		}
		/**
		 * 是否存在加速度
		 */
		public function set isAddSpeed(b : Boolean) : void 
		{
			
			_isAddSpeed = b;
		}

		public function get isAddSpeed() : Boolean 
		{
			
			return _isAddSpeed;
		}
		/**
		 * 摩擦力
		 */
		public function set friction(num : Number) : void
		{
			if(num > 1)
			{
				num = 1;
			}
			if(num < 0)
			{
				num = 0;
			}
			_friction = (1 - num);
		}

		public function get friction() : Number 
		{
			return (1 - _friction);
		}

		/**
		 * ITEM半径
		 */
		public function get itemRadius() : Number
		{
			return _itemRadius;
		}

		public function set itemRadius(value : Number) : void
		{
			_itemRadius = value;
		}

		/**
		 * ITEM数量,改变该值会自动修改itemSpaceBetween值或itemRadius
		 */
		public function set itemCount(value : uint) : void
		{
			if(value < 1)
			{
				value = 1;
			}
			if(_isFixedItemSpaceBetween)
			{
				this.itemRadius = ((getRailsLength() - this._itemSpaceBetween) / value - _itemSpaceBetween) / 2;
			}
			else
			{
				//trace((this._railMap.totalDistance + itemRadius));
				//trace((value + 1));
				this._itemSpaceBetween = (getRailsLength() + itemRadius * 2) / (value + 1) - itemRadius * 2;
			}
		}

		public function get itemCount() : uint
		{
			return _showItemArr.length;
		}
		/**
		 * 是否固定ITEM之间的间距,该值影响在修改itemCount是修改itemSpaceBetween还是itemRadius
		 */
		public function set isFixedItemSpaceBetween(v : Boolean) : void
		{
			_isFixedItemSpaceBetween = v;
		}

		
		public function get isFixedItemSpaceBetween() : Boolean
		{
			return _isFixedItemSpaceBetween;
		}

		/**
		 * item之间的间距
		 */
		public function set itemSpaceBetween(num : Number) : void 
		{
			_itemSpaceBetween = num;
			if(!this._isUserSettingChief)
			{
				_chiefItemPoint = (_rails[0] as AbstractRail).distance + _itemSpaceBetween / 2;
			}
		}

		public function get itemSpaceBetween() : Number 
		{
			
			return _itemSpaceBetween;
		}

		/**
		 * ITEM的水平对齐方式 0-1
		 */
		public function set itemAlign(num : Number) : void 
		{
			if(num > 1)
			{
				num = 1;
			}
			if(num < -1)
			{
				num = -1;
			}
			if(!_itemAlignVecter)
			{
				_itemAlignVecter = new mVector();
			}
			_itemAlignVecter.x = num;
			if(_itemAlignVecter.length > 1)
			{
				_itemAlignVecter = _itemAlignVecter.normalize();
			}
//			trace(_itemAlignVecter);
		}

		public function get itemAlign() : Number 
		{
			if(!_itemAlignVecter)
			{
				_itemAlignVecter = new mVector();
			}
			return _itemAlignVecter.x;
		}

		/**
		 * ITEM的垂直对齐方式 0-1
		 */
		public function set itemValign(num : Number) : void 
		{
			if(num > 1)
			{
				num = 1;
			}
			if(num < -1)
			{
				num = -1;
			}
			if(!_itemAlignVecter)
			{
				_itemAlignVecter = new mVector();
			}
			_itemAlignVecter.y = num;
			if(_itemAlignVecter.length > 1)
			{
				_itemAlignVecter = _itemAlignVecter.normalize();
			}
//			trace(_itemAlignVecter);
		}

		public function get itemValign() : Number 
		{
			if(!_itemAlignVecter)
			{
				_itemAlignVecter = new mVector();
			}
			return _itemAlignVecter.y;
		}

		/**
		 * item是否沿轨道调整角度
		 */
		public function get itemChangeAngleByRail() : Boolean
		{
			return _itemChangeAngleByRail;
		}

		public function set itemChangeAngleByRail(value : Boolean) : void
		{
			_itemChangeAngleByRail = value;
		}
	}
}
