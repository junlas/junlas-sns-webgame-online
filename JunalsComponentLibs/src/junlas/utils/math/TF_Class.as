package junlas.utils.math
{

	/**
	 * 三角及向量数据工具类
	 * @creath time 2008-11-16
	 */

	public class TF_Class 
	{
		/**
		 * 正弦函数
		 */
		public static function sinD(angle : Number) : Number 
		{
			return Math.sin(angle * (Math.PI / 180));
		}

		/**
		 * 余弦函数
		 */
		public static function cosD(angle : Number) : Number 
		{
			return Math.cos(angle * (Math.PI / 180));
		}

		/**
		 * 正切函数
		 */
		public static function tanD(angle : Number) : Number 
		{
			return Math.tan(angle * (Math.PI / 180));
		}

		/**
		 * 反正弦函数
		 */
		public static function asinD(ratio : Number) : Number 
		{
			return Math.asin(ratio) * (180 / Math.PI);
		}

		/**
		 * 反余弦函数
		 */
		public static function acosD(ratio : Number) : Number 
		{
			return Math.acos(ratio) * (180 / Math.PI);
		}

		/**
		 * 反正切函数
		 */
		public static function atanD(ratio : Number) : Number 
		{
			return Math.atan(ratio) * (180 / Math.PI);
		}

		/**
		 * 两倍反正切函数
		 */
		public static function atan2D(y : Number, x : Number) : Number 
		{
			return Math.atan2(y, x) * (180 / Math.PI);
		}

		/**
		 * 2点之前距离
		 */
		public static function distance(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : Number 
		{
			var dx : Number = x2 - x1;
			var dy : Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}

		/**
		 * 2点连线的角度
		 */
		public static function angleOfLine(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : Number 
		{
			return atan2D(y2 - y1, x2 - x1);
		}

		/**
		 * 角度转弧度
		 */
		public static function degreesToRadians(angle : Number) : Number 
		{
			return angle * (Math.PI / 180);
		}

		/**
		 * 弧度转角度
		 */
		public static function radiansToDegrees(angle : Number) : Number 
		{
			return angle * (180 / Math.PI);
		}

		/**
		 * 角度值归正函数,归正传入参数的角度值,返回0度至360度的角度值.
		 */
		public static function fixAngle(angle : Number) : Number 
		{
			return ((angle %= 360) < 0) ? angle + 360 : angle;
		}

		/**
		 * 计算向量的角度和长度
		 * @return 返回object,object.r为长度,object.t为角度
		 */
		public static function cartesianToPolar(p : mVector) : Object 
		{
			var radius : Number = Math.sqrt(p.x * p.x + p.y * p.y);
			var theta : Number = atan2D(p.y, p.x);
			return {r:radius, t:theta};
		}

		/**
		 * 角度值归正函数,归正传入参数的角度值,返回-180度至180度的角度值.
		 */
		public static function FormatAngle(r : Number) : Number 
		{
			r = (r % 360);
			if (r > 180) 
			{
				r = r - 360;
			}
			if (r < -180) 
			{
				r = r + 360;
			}
			return r;
		}

		/**
		 * 角度值归正函数,归正传入参数的角度值,返回-90度至90度的角度值.
		 */
		public static function FormatAngle90(r : Number) : Number 
		{
			r = (r % 180);
			if (r > 90) 
			{
				r = 180 - r;
			}
			if (r < -90) 
			{
				r = r + 180;
			}
			return r;
		}
	}
}
