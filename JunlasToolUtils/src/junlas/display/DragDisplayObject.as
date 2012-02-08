package junlas.display{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import junlas.notifier.MsgNotifier;
	import flash.display.DisplayObjectContainer;
	
	/**
	 *@author lvjun01
	 */
	public class DragDisplayObject{
		private static var _instance:DragDisplayObject;
		public static const DragDisplayObject_Start:String = "DragDisplayObject_Start";
		public static const DragDisplayObject_End:String = "DragDisplayObject_End"
		private var _isDrag:Boolean = false;
		private var _stage:Stage;
		private var _originalGrids:Array;
		private var _targetGrids:Array;
		private var _originalMc:Sprite;
		private var _originalPmc:DisplayObjectContainer;
		private var _originalPoint:Point = new Point();
		
		public function DragDisplayObject(s:Single) {
		}
		
		public static function get instance():DragDisplayObject{
			if(!_instance){
				_instance = new DragDisplayObject(new Single());
			}
			return _instance;
		}
		
		/**
		 * @param originalMc 当前控制拖动的mc
		 * @param originalGrids mc所在原始插槽组
		 * @param targetGrids mc要拖动的目标的插槽组
		 */
		public function init(originalMc:Sprite,originalGrids:Array,targetGrids:Array):void{
			if(!originalMc || !targetGrids || targetGrids.length<=0 || !originalMc.stage){
				trace("请检查拖动的mc以及目标mc数组");
				return;
			}
			if(!_isDrag){
				_originalMc = originalMc;
				_originalPmc = _originalMc.parent;
				_stage = _originalMc.stage;
				_originalPoint.x = _originalMc.x;
				_originalPoint.y = _originalMc.y;
				_originalGrids = originalGrids;
				_targetGrids = targetGrids;
			}
			run();
		}
		
		private function run():void {
			//var arr:Array = _stage.getObjectsUnderPoint(new Point(_stage.mouseX,_stage.mouseY));
			var originalGridRect:Rectangle;
			var itemRect:Rectangle;
			var originalRect:Rectangle = _originalMc.getRect(_stage);
			if(!_isDrag){//开始
				startCanDo();
				return;
			}
			for each (var originalGrid:Sprite in _originalGrids) {
				originalGridRect = originalGrid.getRect(_stage);
				//trace("original:",arr.indexOf(originalGrid),originalRect.intersects(originalGridRect));
				if(/*arr.indexOf(originalGrid) != -1 && */originalRect.intersects(originalGridRect)){
					originalGrid.addChild(_originalMc);
					dispose(true,originalGrid);
					return;
				}
			}
			for each (var item:Sprite in _targetGrids) {
				itemRect = item.getRect(_stage);
				//trace("target:",arr.indexOf(item),originalRect.intersects(itemRect));
				if(/*arr.indexOf(item) != -1 && */originalRect.intersects(itemRect)) {
					item.addChild(_originalMc);
					dispose(false,item);
					return;
				}
			}
		}
		
		private function updatePos():void {
			 _originalMc.x = _originalPoint.x;
			 _originalMc.y = _originalPoint.y;
		}
		
		private function startCanDo():void {
			MsgNotifier.getInstance(true).sendCommamd(DragDisplayObject_Start);
			_isDrag = true;
			_originalMc.startDrag(true);
			_stage.addChild(_originalMc);
		}
		
		/**
		 * <b>当gridPmc == null时，不发送DragDisplayObject_End消息且将mc的父容器归位，如果外部更改过其父容器，则不做处理</b><br/>
		 * @param isBack true:表示mc有退回到原始插槽了;false:mc回到了目标的插槽
		 * @param gridPmc mc对应的插槽
		 */
		public function dispose(isBack:Boolean,gridPmc:Sprite = null):void{
			if(!_isDrag)//已经销毁了,直接退出
				return;
			_isDrag = false;
			_originalMc.stopDrag();
			updatePos();
			if(gridPmc == null && _originalMc.parent == _stage){
				_originalPmc.addChild(_originalMc);
			}
			_originalMc = null;
			_originalPmc = null;
			_originalGrids = null;
			_targetGrids = null;
			if(gridPmc){
				MsgNotifier.getInstance(true).sendCommamd(DragDisplayObject_End,isBack,gridPmc);
			}
		}
		
	}
}

class Single{}