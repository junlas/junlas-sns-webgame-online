package junlas.display
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class PositionTools
	{
		/**
		 * @param localDis:本地容器
		 * @param targetDis:目标容器
		 * @param point:本地容器中的点
		 * @return 该点在目标容器中的相对坐标
		 */
		public static function relativePoint(localDis:DisplayObject, targetDis:DisplayObject, point:Point) :Point
		{
			var p:Point = localDis.localToGlobal(point);
			p = targetDis.globalToLocal(p);
			return p;
		}
	}
}