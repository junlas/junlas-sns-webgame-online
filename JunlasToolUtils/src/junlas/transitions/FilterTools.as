package junlas.transitions
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class FilterTools
	{
		/**
		 * 灰色 滤镜
		 */
		public static function colorOffset(target:DisplayObject):void
		{
			var filterObj:ColorMatrixFilter = new ColorMatrixFilter();    
			filterObj.matrix = new Array(    
				1/3,1/3,1/3,0,0,    
				1/3,1/3,1/3,0,0,    
				1/3,1/3,1/3,0,0,    
				0,  0,  0,1,0);    
			target.filters = [filterObj]; 
		}
		
		/**
		 * 红褐色滤镜
		 */
		public static function colorDark(target:DisplayObject):void
		{
			var filterObj:ColorMatrixFilter = new ColorMatrixFilter();    
			filterObj.matrix = new Array(    
				1,0,0,0,-80,    
				0,1,0,0,-80,    
				0,0,1,0,-80,    
				0,0,0,1,0);    
			target.filters = [filterObj]; 
		}
	}
}