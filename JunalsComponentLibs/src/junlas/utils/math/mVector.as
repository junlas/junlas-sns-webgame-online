package junlas.utils.math
{
	/**
	 * <strong>向量类.
	 * </strong>
	 */
	public class mVector 
	{
		public static var PI_OVER_ONE_EIGHTY:Number = Math.PI / 180;
		//属性
		public var x : Number;
		public var y : Number;

		/**
		 * 向量构造函数,构造一个向量
		 * @param px x轴方向值
		 * @param py y轴方向值
		 */
		public function mVector(px : Number = 0, py : Number = 0) 
		{
			x = px;
			y = py;
		}

		/**
		 * 重新设定向量值
		 * @param px x轴方向值
		 * @param py y轴方向值
		 */
		public function setTo(px : Number, py : Number) : void 
		{
			x = px;
			y = py;
		}

		/**
		 * 拷贝传入参数的向量值,重新设定向量值.
		 * @param v 被拷贝的原始向量值
		 */
		public function copyFrom(v : mVector) : mVector 
		{
			x = v.x;
			y = v.y;
			
			return this;
		}

		/**
		 * toString函数
		 */
		public function toString() : String 
		{
			var rx : Number = Math.round(this.x * 1000) / 1000;
			var ry : Number = Math.round(this.y * 1000) / 1000;
			return "[" + rx + ", " + ry + "]";
		}

		/**
		 * 获得当前向量的拷贝
		 */
		public function clone() : mVector 
		{
			return new mVector(this.x, this.y);
		}

		/**
		 * 向量加 +
		 * @param v 向量,加数
		 * @return 返回被加后的新的向量
		 */
		public function plus(v : mVector) : mVector 
		{
			return new mVector(x + v.x, y + v.y); 
		}

		/**
		 * 向量加等于 +=
		 * @param v 向量,加数
		 * @return 返回被加后的向量
		 */
		public function plusEquals(v : mVector) : mVector 
		{
			x += v.x;
			y += v.y;
			return this;
		}

		/**
		 * 向量减 -
		 * @param v 向量,减数
		 * @return 返回被加后的新的向量
		 */
		public function minus(v : mVector) : mVector 
		{
			return new mVector(x - v.x, y - v.y);    
		}

		/**
		 * 向量减等于 -=
		 * @param v 向量,减数
		 * @return 返回被加后的向量
		 */
		public function minusEquals(v : mVector) : mVector 
		{
			x -= v.x;
			y -= v.y;
			return this;
		}

		/**
		 * 向量非 !
		 * @return 返回和原始向量相反的新向量
		 */
		public function negate() : mVector 
		{
			return new mVector(-x, -y);
		}

		/**
		 * 向量非等于 !=
		 * @return 返回被相反计算后的向量
		 */
		public function negateEquals() : void 
		{
			x = -x;
			y = -y;
		}

		
		/**
		 * 向量乘 *
		 * @param s 数字,乘数
		 * @return 返回被加后的新向量
		 */
		public function mult(s : Number) : mVector 
		{
			return new mVector(x * s, y * s);
		}

		/**
		 * 向量乘等于 *=
		 * @param s 数字,乘数
		 * @return 返回被加后的向量
		 */
		public function multEquals(s : Number) : mVector 
		{
			x *= s;
			y *= s;
			return this;
		}

		/**
		 * 向量旋转
		 * @param ang 数字,角度
		 * @return 返回被旋转后的新向量
		 */
		public function rotateAngle(ang : Number) : mVector 
		{
			var cos : Number = TF_Class.cosD(ang);
			var sin : Number  = TF_Class.sinD(ang);
			var result : mVector = new mVector(x * cos - y * sin, y * cos + x * sin);
			return result;
		}

		/**
		 * 向量旋转等于
		 * @param ang 数字,角度
		 * @return 返回被旋转后的向量
		 */
		public function rotateAngleEquals(ang : Number) : mVector 
		{
			return this.copyFrom(rotateAngle(ang));
		}
		
		
		/**
		 * 向量围绕指定点旋转
		 * @param ang 数字,角度
		 * @param targetPoint 目标点
		 * @return 返回被旋转后的新向量
		 */
		public function rotateAngleForTarget(ang : Number , targetPoint : mVector) : mVector 
		{
			var tempVector : mVector = this.minus(targetPoint);
			var cos : Number = TF_Class.cosD(ang);
			var sin : Number  = TF_Class.sinD(ang);
			var tempResult : mVector = new mVector(tempVector.x * cos - tempVector.y * sin, tempVector.y * cos + tempVector.x * sin);
			var result : mVector = tempResult.plus(targetPoint);
			
			return result;
		}
		
		/**
		 * 向量围绕指定点旋转等于
		 * @param ang 数字,角度
		 * @param targetPoint 目标点
		 * @return 返回被旋转后的新向量
		 */
		public function rotateAngleForTargetEquals(ang : Number , targetPoint : mVector) : mVector 
		{
			return this.copyFrom(rotateAngleForTarget(ang , targetPoint));
		}
		
		

		/**
		 * 向量旋转
		 * @param radian 数字,弧度
		 * @return 返回被旋转后的新向量
		 */
		public function rotateRadian(radian : Number) : mVector 
		{
			var cos : Number = Math.cos(radian);
			var sin : Number = Math.sin(radian);
			var result : mVector = new mVector(x * cos - y * sin, y * cos + x * sin);
			return result;
		}

		/**
		 * 向量旋转等于
		 * @param radian 数字,弧度
		 * @return 返回被旋转后的向量
		 */
		public function rotateRadianEquals(radian : Number) : mVector 
		{
			return this.copyFrom(rotateRadian(radian));
		}
		
		
		/**
		 * 向量围绕指定点旋转
		 * @param radian 数字,弧度
		 * @param targetPoint 目标点
		 * @return 返回被旋转后的新向量
		 */
		public function rotateRadianForTarget(radian : Number , targetPoint : mVector) : mVector 
		{
			var tempVector : mVector = this.minus(targetPoint);
			var cos : Number = Math.cos(radian);
			var sin : Number = Math.sin(radian);
			var tempResult : mVector = new mVector(tempVector.x * cos - tempVector.y * sin, tempVector.y * cos + tempVector.x * sin);
			var result : mVector = tempResult.plus(targetPoint);
			
			return result;
		}
		
		/**
		 * 向量围绕指定点旋转等于
		 * @param radian 数字,弧度
		 * @param targetPoint 目标点
		 * @return 返回被旋转后的新向量
		 */
		public function rotateRadianForTargetEquals(radian : Number , targetPoint : mVector) : mVector 
		{
			return this.copyFrom(rotateRadianForTarget(radian , targetPoint));
		}

		
		
		/**
		 * 向量点乘 .*
		 * @param v 向量,乘数
		 * @return 点乘数
		 */
		public function dot(v : mVector) : Number 
		{
			return x * v.x + y * v.y;
		}

		/**
		 * 向量点差 .x
		 * @param v 向量,x数
		 * @return 点x数
		 */
		public function cross(v : mVector) : Number 
		{
			return x * v.y - y * v.x;
		}

		public function times(v : mVector) : mVector 
		{
			return new mVector(x * v.x, y * v.y);
		}

		public function div(s : Number) : mVector 
		{
			if (s == 0) s = 0.0001;
			return new mVector(x / s, y / s);
		}

		public function divEquals(s : Number) : mVector 
		{
			if (s == 0) s = 0.0001;
			x /= s;
			y /= s;
			return this;
		}

		/**
		 * 获得2点之间距离
		 */
		public function distance(v : mVector) : Number 
		{
			var delta : mVector = this.minus(v);
			return delta.length;
		}

		/**
		 * 规格化向量,设置向量长度为1,不改变原向量
		 */
		public function normalize() : mVector 
		{
			var m : Number = this.length;
			if (m == 0) m = 0.0001;
			return mult(1 / m);
		}

		/**
		 * 比较两向量的值是否相同
		 */
		public function compare(v : mVector) : Boolean
		{
			if(this.x == v.x && this.y == v.y)
				return true;
			return false;
		}

		/**
		 * 获得向量法线
		 */
		public function getNormal() : mVector 
		{
			return new mVector(-y, x);
		}

		/**
		 * 两向量是否互相垂直
		 */
		public function isNormalTo(v : mVector) : Boolean 
		{
			return (this.dot(v) == 0);
		}

		/**
		 * 获得2向量的角度差
		 */
		public function angleBetween(v : mVector) : Number 
		{
			var dp : Number = this.dot(v);
			// find dot product
			// divide by the lengths of the two M_Vectors
			var cosAngle : Number = dp / (this.length * v.length);
			return TF_Class.acosD(cosAngle);
		// take the inverse cosine
		}

		/**
		 * 两向量夹角,弧度
		 */
		public function radianBetween(v : mVector) : Number
		{
			var cos : Number = this.dot(v) / (this.length * v.length);
			return Math.acos(cos);
		}

		/**
		 * 获得向量长度
		 */
		public function get length() : Number 
		{
			return Math.sqrt(x * x + y * y);
		}

		/**
		 * 获得向量长度
		 */
		public function set length(len : Number) : void 
		{
			var r : Number = length;
			if (r) 
			{
				this.multEquals(len / r);
			} 
			else 
			{
				this.x = len;
			}
		}

		/**
		 * 设定向量的角度
		 */
		public function set angle(ang : Number) : void 
		{
			var r : Number = length;
			x = r * TF_Class.cosD(ang);
			y = r * TF_Class.sinD(ang);
		}

		/**
		 * 获得向量的角度
		 */
		public function get angle() : Number 
		{
			return TF_Class.atan2D(y, x);
		}
	}
}
