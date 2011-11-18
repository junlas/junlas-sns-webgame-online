package  junlas.components.piclist.test {
	import flash.display.*;
	import junlas.utils.math.*;
	import flash.utils.*;
	
	public class AbstractRail {
		public function AbstractRail(){
			if (getQualifiedClassName(this) == "zlong::breathxue::utils::RailMap::AbstractRail"){
				throw (new ArgumentError("can't be constructed"));
			};
		}
		public function del():void{
		}
		public function get distance():Number{
			return (0);
		}
		public function getPointByDistance(_arg1:Number):mVector{
			return (null);
		}
		public function getRotationByDistance(_arg1:Number):Number{
			return (0);
		}
		public function get startPoint():mVector{
			return (null);
		}
		public function get endPoint():mVector{
			return (null);
		}
		function set debugMc(_arg1:Sprite):void{
		}
		
	}
}//package zlong.breathxue.utils.RailMap 