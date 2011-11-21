package junlas.utils.math{
	/**
	 *@author lvjun01
	 */
	public class MathTool{
		public static function abs(val:Number):Number {
			return val >= 0?val:-val;
		}
		
		public static function normal(val:Number):Number{
			return val >= 0?1:-1;
		} 
	}
}