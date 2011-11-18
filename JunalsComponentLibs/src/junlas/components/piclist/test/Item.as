package junlas.components.piclist.test
{
	import flash.display.Shape;
	import flash.text.TextFormat;	

	import flash.display.DisplayObject;	
	import junlas.utils.display.Attach;	
	import junlas.utils.math.mVector;	
	import flash.events.MouseEvent;	
	import flash.text.TextField;	
	import flash.display.Sprite;	

	/**
	 * @author breath xue
	 * PICLIST中单个ITEM的对象类.
	 * 该类负责显示设定每一个ITEM.
	 * 该类由系统创建.可以通过ItemEvent获得,以获得该ITEM对象数据,或改变内容.
	 */
	public class Item 
	{
		/**
		 * 遮罩相对ITEM半径的倍数,设置该值改变遮罩的大小.默认为4
		 */
		public static var POWER_MASK_RADIUS : uint = 4;
		private var _pmc : Sprite;
		private var _mc : Sprite;
		private var _list : PicList;
		private var _name : String;
		private var _itemMc : DisplayObject;
		private var _car : Car;
		private var _radius : Number;
		private var _angle : Number;
		private var _itemListNum : uint;
		private var _picListNum : uint;
		private var _debugMc : Sprite;
		private var _maskFirstMc : Shape;
		private var _maskEndMc : Shape;

		
		//*******************************************public*************************************
		public function Item(list : PicList,Pmc : Sprite,startDistance : Number = 0)
		{
			_pmc = Pmc;
			_name = "Item";
			_list = list;
			_car = new Car(startDistance);
			_angle = 0;
			_radius = _list._itemRadius;
			
			initDis();
			initEvent();
		}

		public function toString() : String 
		{
			return "Item " + _name;
		}

		/**
		 * 名字,debug状态下显示在ITEM上
		 */
		public function set name(v : String) : void
		{
			_name = v;	
			if(PicList.__debug__ && _debugMc)
			{
				var debugText : TextField = _debugMc.getChildByName("debugText") as TextField;
				debugText.text = _name + "[" + _picListNum + "|" + _itemListNum + "]";
				debugText.x = -debugText.textWidth / 2;
				debugText.y = -debugText.textHeight / 2 - _radius / 2;
				debugText.height = _radius;
				debugText.width = _radius * 1.8;//简略圆弧计算
			}
		}

		public function get name() : String
		{
			return _name;
		}

		/**
		 * 在数据列表中的位置编号
		 */
		public function get itemListNum() : uint
		{
			return _itemListNum;
		}

		/**
		 * 在现实列表中的位置编号
		 */
		public function get picListNum() : uint
		{
			return _picListNum;
		}

		/**
		 * 显示对象
		 */
		public function get mc() : DisplayObject
		{
			return _itemMc;
		}

		/**
		 * 显示对象父容器,父容器实现事件监听移动效果.
		 */
		public function get itemPmc() : DisplayObject
		{
			return _mc;
		}

		//////////////////////////////////internal/////////////////////////////////////////

		internal function del() : void
		{
			_list.dispatchEvent(new ItemEvent(ItemEvent.ITEM_DELETE, this));
			_car.del();
			_car = null;
			delEvent();
			delDis();
		}

		/**
		 * 添加显示对象
		 * @param obj 显示对象或显示对象反射类名
		 * @param itemListNum 数据编号
		 */
		internal function addDis(obj : *,itemListNum : uint) : void
		{
			_itemListNum = itemListNum;
			if(obj is String)
			{
				name = String(obj);
				_itemMc = Attach.getDisplayObject(_name);
				_mc.name = _name;
			}
			else if(obj is DisplayObject)
			{
				var tempMC : DisplayObject = obj as DisplayObject;
				//如果已经被加入,则不再加入
				if(!(tempMC.parent && tempMC.parent.parent && tempMC.parent.parent == _mc.parent))
				{
					name = tempMC.name;
					_itemMc = tempMC;
					_mc.name = tempMC.name;
				}
			}
			if(_itemMc == null)
			{
				_itemMc = new Sprite();
			}
			
			var cC : mVector = _list._itemAlignVecter.mult(_radius);
			_itemMc.x = cC.x;
			_itemMc.y = cC.y;
			
			_mc.addChild(_itemMc);
			if(PicList.__debug__)
			{
				_mc.addChild(_debugMc);
			}
			

			_list.dispatchEvent(new ItemEvent(ItemEvent.ITEM_CREATE, this));
		}

		/**
		 * 是否出界
		 */
		internal function isDerailed() : int
		{
			return _car.isDerailed();
		}

		/**
		 * 前进
		 * @param distance 前进的距离
		 */
		internal function forward(distance : Number) : void
		{
			_car.forward(distance);
			update();
		}

		/**
		 * 后退
		 * @param distance 后退的距离
		 */
		internal function back(distance : Number) : void
		{
			_car.back(distance);
			update();
		}

		/**
		 * 设定显示编号
		 */
		internal function setPicListNum(value : uint) : void
		{
			_picListNum = value;
			name = name;
		}

		/**
		 * 前端位置,根据对齐方式和半径计算出的ITEM对象圆中在相对轨道最前端的位置
		 */
		internal function get frontDistance() : Number
		{
			var cC : mVector;
			if(_list._itemAlignVecter.length == 0)
			{
				cC = new mVector(-_radius, 0);
			}
			else if(this._list._itemChangeAngleByRail)
			{
				//默认水平
				cC = new mVector(_list._itemAlignVecter.x * _radius - _radius, 0);
			}
			else
			{
				cC = _list._itemAlignVecter.mult(_radius);
				//update by ...
				cC.plusEquals(new mVector(_radius, 0).rotateAngle(_car.rotation + 180));
				//upadte by ...
				cC.rotateAngleEquals(-_car.rotation);
			}
			return distance + cC.x;	
		}

		/**
		 * 前端位置,根据对齐方式和半径计算出的ITEM对象圆中在相对轨道最前端的位置
		 */
		internal function set frontDistance(v : Number) : void
		{			
			var cC : mVector;
			if(_list._itemAlignVecter.length == 0)
			{
				cC = new mVector(-_radius, 0);
			}
			else if(this._list._itemChangeAngleByRail)
			{
				//默认水平
				cC = new mVector(_list._itemAlignVecter.x * _radius - _radius, 0);
			}
			else
			{
				//找到圆心
				cC = _list._itemAlignVecter.mult(_radius);
				//
				//				_mc.graphics.lineStyle(1, 0x0000FF, 0.5);
				//				_mc.graphics.beginFill(0x0000FF, 0.3);
				//				
				//				_mc.graphics.drawCircle(cC.x, cC.y, 1);
				//				
				//				trace("rotation",_car.rotation);
				//找到圆相对于路线car的前端点.
				//update by ...
				cC.plusEquals(new mVector(_radius, 0).rotateAngle(_car.rotation + 180));	
				//				_mc.graphics.lineStyle(1, 0x00FF00, 0.5);
				//				_mc.graphics.beginFill(0x00FF00, 0.3);
				//				
				//				_mc.graphics.drawCircle(cC.x, cC.y, 1);
				//获得0,0点(非圆心)到前端点的距离
				//update by ...
				cC.rotateAngleEquals(-_car.rotation);
//				
//				_mc.graphics.lineStyle(1, 0xFF0000, 0.5);
//				_mc.graphics.beginFill(0xFF0000, 0.3);
//				_mc.graphics.drawCircle(cC.x, cC.y, 3);
//				_mc.graphics.endFill();
			}
			distance = v - cC.x;	
		}

		/**
		 * 后端位置,根据对齐方式和半径计算出的ITEM对象圆中在相对轨道最后端的位置
		 */
		internal function get behindDistance() : Number
		{
			var cC : mVector;
			if(_list._itemAlignVecter.length == 0)
			{
				cC = new mVector(_radius, 0);
			}
			else if(this._list._itemChangeAngleByRail)
			{
				//默认水平
				cC = new mVector(_list._itemAlignVecter.x * _radius + _radius, 0);
			}
			else
			{
				cC = _list._itemAlignVecter.mult(_radius);
				//upate by ...
				cC.plusEquals(new mVector(_radius, 0).rotateAngle(_car.rotation));
				//update by ...
				cC.rotateAngleEquals(-_car.rotation);
			}		
			return distance + cC.x;	
		}
		
		/**
		 * 后端位置,根据对齐方式和半径计算出的ITEM对象圆中在相对轨道最后端的位置
		 */
		internal function set behindDistance(v : Number) : void
		{
			var cC : mVector;
			if(_list._itemAlignVecter.length == 0)
			{
				cC = new mVector(_radius, 0);
			}
			else if(this._list._itemChangeAngleByRail)
			{
				//默认水平
				cC = new mVector(_list._itemAlignVecter.x * _radius + _radius, 0);
			}
			else
			{
				cC = _list._itemAlignVecter.mult(_radius);
				//update by ...
				cC.plusEquals(new mVector(_radius, 0).rotateAngle(_car.rotation));
				//update by ...
				cC.rotateAngleEquals(-_car.rotation);
			}	
			distance = v - cC.x;	
		}

		/**
		 * 当前位置
		 */
		internal function get distance() : Number
		{
			return _car.distance;
		}
		
		/**
		 * 当前位置
		 */
		internal function set distance(v : Number) : void
		{
			_car.distance = v;
			update();
		}

		internal function get car() : Car
		{
			return _car;
		}

		private function onClickItem(event : MouseEvent) : void
		{
			_list.dispatchEvent(new ItemEvent(ItemEvent.CLICK_ITEM, this));
		}

		private function onItemRollOut(event : MouseEvent) : void
		{
			_list.dispatchEvent(new ItemEvent(ItemEvent.ITEM_ROLL_OUT, this));
		}

		private function onItemRollOver(event : MouseEvent) : void
		{
			_list.dispatchEvent(new ItemEvent(ItemEvent.ITEM_ROLL_OVER, this));
		}

		private function initDis() : void
		{
			_mc = new Sprite();
			_pmc.addChild(_mc);
			
			initMaskMc();
			
			//TODO:关于是否要默认点击范围
			if(PicList.__debug__)
			{
				_debugMc = new Sprite();
				//圆心
				_debugMc.graphics.lineStyle(1, 0x0000FF, 0.5);
				_debugMc.graphics.beginFill(0x0000FF, 0.3);
				_debugMc.graphics.drawCircle(0, 0, 1);
				//圆
				_debugMc.graphics.lineStyle(1, 0x0000FF, 0.5);
				_debugMc.graphics.beginFill(0x0000FF, 0.3);
				_debugMc.graphics.drawCircle(0, 0, _radius);
				
				
				var cC : mVector = _list._itemAlignVecter.mult(_radius);
				//圆
				_debugMc.graphics.lineStyle(1, 0x00FF00, 0.5);
				_debugMc.graphics.beginFill(0x00FF00, 0.3);
				_debugMc.graphics.drawCircle(-cC.x, -cC.y, 5);
				
				_debugMc.graphics.endFill();
							
				_debugMc.x = cC.x;
				_debugMc.y = cC.y;
				_debugMc.mouseChildren = false;
				_debugMc.mouseEnabled = false;
				_mc.addChild(_debugMc);
				
				var text : TextField = new TextField();
				text.name = "debugText";
				text.defaultTextFormat = new TextFormat("_san", 9, 0x000000);
				text.mouseEnabled = false;
				_debugMc.addChild(text);
			}
		}

		private function initEvent() : void
		{
			_mc.addEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
			_mc.addEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
			_mc.addEventListener(MouseEvent.CLICK, onClickItem);
		}

		
		private function delDis() : void
		{
			delMaskMc();
			if(_mc.getChildByName(_name))
			{
				_mc.removeChild(_itemMc);
			}
			_itemMc = null;
			_mc.parent.removeChild(_mc);
			_mc = null;
		}

		private function delEvent() : void
		{
			_mc.removeEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
			_mc.removeEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
			_mc.removeEventListener(MouseEvent.CLICK, onClickItem);
		}

		private function update() : void
		{
			_mc.x = _car.x;
			_mc.y = _car.y;
			

			if(_list._itemChangeAngleByRail)
			{
				_mc.rotation = _angle = _car.rotation;
			}
			
			updateMaskMc();
			_car.print();
		}

		private function initMaskMc() : void 
		{
			//if(_list.maskLength <= 0)
			//return;
			var tempCar : Car = new Car();
			
			_maskFirstMc = new Shape();
			_maskFirstMc.graphics.beginFill(0xCCCCCC, 1);
			_maskFirstMc.graphics.drawRect(0, -_radius * POWER_MASK_RADIUS / 2, _radius * POWER_MASK_RADIUS, _radius * POWER_MASK_RADIUS);
			_maskFirstMc.graphics.endFill();
			_list._railMap.addCar(tempCar);
			tempCar.distance = _list.maskLength;
			_maskFirstMc.x = tempCar.x;
			_maskFirstMc.y = tempCar.y;
			_maskFirstMc.rotation = tempCar.rotation;
			//_mc.parent.addChild(_maskFirstMc);

			_maskEndMc = new Shape();
			_maskEndMc.graphics.beginFill(0x0000CC, 1);
			_maskEndMc.graphics.drawRect(-_radius * POWER_MASK_RADIUS, -_radius * POWER_MASK_RADIUS / 2, _radius * POWER_MASK_RADIUS, _radius * POWER_MASK_RADIUS);
			_maskEndMc.graphics.endFill();
			tempCar.distance = _list.getRailsLength() + _list.maskLength;
			_maskEndMc.x = tempCar.x;
			_maskEndMc.y = tempCar.y;
			_maskEndMc.rotation = tempCar.rotation;
			
			tempCar.del();
			//_mc.parent.addChild(_maskEndMc);
			//_mc.mask = _maskMc;
		}

		private function updateMaskMc() : void 
		{
			if(_list.maskLength <= 0)
			return;
			//			if(_car.distance > _list.maskLength + _radius * 2)
			//			{
			_mc.mask = null;
			if(_maskFirstMc.parent == _mc.parent)
			{
				_mc.parent.removeChild(_maskFirstMc);
			}
			if(_maskEndMc.parent == _pmc)
			{
				_pmc.removeChild(_maskEndMc);
			}
			if(_car.distance < _list.maskLength + _radius * POWER_MASK_RADIUS / 2)
			{
				_pmc.addChild(_maskFirstMc);
				_mc.mask = _maskFirstMc;
			}else if(_car.distance > _list.getRailsLength() + _list.maskLength - _radius * POWER_MASK_RADIUS / 2)
			{
				_pmc.addChild(_maskEndMc);
				_mc.mask = _maskEndMc;
			}
		}

		private function delMaskMc() : void
		{
			//if(_list.maskLength <= 0)
			//return;
			if(_maskFirstMc.parent == _pmc)
			{
				_pmc.removeChild(_maskFirstMc);
			}
			if(_maskEndMc.parent == _pmc)
			{
				_pmc.removeChild(_maskEndMc);
			}
			
			//			_pmc.removeChild(_maskMc);
			_mc.mask = null;
			_maskFirstMc = null;
			_maskEndMc = null;
			
//			_maskMc = null;
		}
	}
}
