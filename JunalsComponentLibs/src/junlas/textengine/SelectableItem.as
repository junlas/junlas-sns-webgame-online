package junlas.textengine{
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;

	/**
	 *@author lvjun01
	 */
	public class SelectableItem{
		private var _currTextLine:TextLine;
		private var _rowIndex:int;
		private var _colIndex:int;
		
		public function SelectableItem(currTextLine:TextLine,rowIndex:int,colIndex:int) {
			_currTextLine = currTextLine;
			_rowIndex = rowIndex;
			_colIndex = colIndex;
		}

		public function get currTextLine():TextLine {
			return _currTextLine;
		}

		public function get rowIndex():int {
			return _rowIndex;
		}

		public function get colIndex():int {
			return _colIndex;
		}

		/**
		 * 获取Bounds
		 */
		public function getAtomBounds():Rectangle {
			//trace(_currTextLine.getAtomTextBlockBeginIndex(_colIndex));
			return _currTextLine.getAtomBounds(_colIndex);
		}
		
		/**
		 * 检测相等与否
		 */
		public function equals(item:SelectableItem):Boolean {
			if(_currTextLine == item._currTextLine && _rowIndex == item._rowIndex && _colIndex == item._colIndex)true;
			return false;
		}
		
		/**
		 * 获取最后一个原子的Bounds
		 */
		public function getEndAtomBounds():Rectangle {
			return _currTextLine.getAtomBounds(_currTextLine.atomCount-1);
		}
		
		/**
		 * 获取第一个原子的Bounds
		 */
		public function getStartAtomBounds():Rectangle {
			return _currTextLine.getAtomBounds(0);
		}
		
		/**
		 * 获取在TextBlock块的起始索引值
		 */
		public function getTextBlockIndex():int {
			return _currTextLine.getAtomTextBlockBeginIndex(_colIndex);
		}
	}
}