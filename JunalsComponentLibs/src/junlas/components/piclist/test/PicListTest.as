package junlas.components.piclist.test
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * PicListTest
	 * @author 吕军 lvjun01@snda.com
	 * $Id:$
	 * @version 1.0
	 */
	public class PicListTest
	{
		private var _picList:PicList;
		
		public function PicListTest(pmc:Sprite)
		{
			pmc.y = 200;
			var picArr:Array = [];
			for(var i:int = 0;i<40;i++){
				picArr.push(new PGraphic());
			}
			_picList = new PicList(pmc,picArr);
			
			init();
			
			pmc.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.LEFT){
				_picList.back();
				//_picList.nextItem();
			}
			if(e.keyCode == Keyboard.RIGHT){
				_picList.forward();
				//_picList.prevItem();
			}
		}
		
		private function init():void{
			PicList.__debug__ = true;
			_picList.isAddSpeed = false;
			_picList.isSeriesCreateItem = true;
			_picList.isCircular = false;
			_picList.maskLength = 60;
			_picList.chiefItemPoint = 0;
			_picList.speed = 10;
			_picList.friction = 0;
			_picList.itemChangeAngleByRail = false;
			_picList.itemSpaceBetween = 10;
			_picList.itemRadius = 24;
			var _local2:Array = new Array();
			_local2.push(new LineRail(0, 0, 400, 0));
			_picList.rails = _local2;
			_picList.addEventListener(ItemEvent.ITEM_CREATE, this.itemCreateHandler);
		}
		
		private function itemCreateHandler(e:ItemEvent):void{
			trace("===>itemCreate<===");
			trace("-->",e.item.itemListNum,e.item.picListNum);
		}
	}
}
import flash.display.Sprite;

class PGraphic extends Sprite{
	function PGraphic():void{
		this.graphics.beginFill(Math.random() * 0xffffff);
		this.graphics.drawCircle(0,0,18);
		this.graphics.endFill();
	}
}