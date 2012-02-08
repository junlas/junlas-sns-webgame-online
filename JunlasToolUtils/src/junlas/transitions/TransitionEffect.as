package junlas.transitions
{
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class TransitionEffect
	{
		/**
		 * 从上到下 分片卷帘
		 */
		public static const Blinds_0:int = 0;
		/**
		 * 从左到右 分片卷帘 
		 */
		public static const Blinds_1:int = 1;
		/**
		 * 闪烁淡入效果 
		 */
		public static const Fade_2:int = 2;
		/**
		 * 圆形 从下倒下打开 效果
		 */
		public static const Iris_3:int = 3;
		/**
		 * 淡入效果 闪光结束 
		 */
		public static const Photo_4:int = 4;
		/**
		 * 棋盘马赛克 一小方块的打开
		 */
		public static const PixelDissolve_5:int = 5;
		/**
		 * 从左上向右下侧卷帘
		 */
		public static const Wipe_6:int = 6;
		/**
		 * 从上到下 逐渐卷帘
		 */
		public static const Wipe_7:int = 7;
		/**
		 * 向左下侧卷帘
		 */
		public static const Wipe_8:int = 8;
		/**
		 * 从左到右 逐渐卷帘
		 */
		public static const Wipe_9:int = 9;
		/**
		 * 从左上向右下侧卷帘
		 */
		public static const Wipe_10:int = 10;
		/**
		 * 从右到左 逐渐卷帘
		 */
		public static const Wipe_11:int = 11;
		/**
		 * 从左下到右上卷帘
		 */
		public static const Wipe_12:int = 12;
		/**
		 * 从下到上 逐渐卷帘
		 */
		public static const Wipe_13:int = 13;
		/**
		 * 从右下到左上逐渐卷帘
		 */
		public static const Wipe_14:int = 14;
		/**
		 * 淡入效果 
		 */
		public static const Wipe_default:int = -1;
		
		public static function showEffect(showMC:MovieClip,type:int=-1,durationTime:Number = 2):void {
			//var randomNum:Number = Math.floor(Math.random()*16);
			switch (type) {
				case 0 :
					//横向卷帘
					TransitionManager.start(showMC, {type:Blinds, direction:Transition.IN, duration:durationTime, easing:None.easeNone, numStrips:10, dimension:0});
					break;
				case 1 :
					//纵向卷帘
					TransitionManager.start(showMC, {type:Blinds, direction:Transition.IN, duration:durationTime, easing:None.easeNone, numStrips:10, dimension:1});
					break;
				case 2 :
					//淡入效果
					TransitionManager.start(showMC, {type:Fade, direction:Transition.IN, duration:durationTime, easing:None.easeNone});
					break;
				case 3 :
					//圆形打开
					TransitionManager.start(showMC, {type:Iris, direction:Transition.IN, duration:durationTime, easing:Strong.easeOut, startPoint:2, shape:Iris.CIRCLE});
					break;
				case 4 :
					//淡入闪光
					TransitionManager.start(showMC, {type:Photo, direction:Transition.IN, duration:durationTime, easing:None.easeNone});
					break;
				case 5 :
					//棋盘马赛克
					TransitionManager.start(showMC, {type:PixelDissolve, direction:Transition.IN, duration:durationTime, easing:None.easeNone, xSections:10, ySections:10});
					break;
				case 6 :
					//向右下侧卷帘
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:1});
					break;
				case 7 :
					//向下卷帘
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:2});
					break;
				case 8 :
					//向左下侧卷帘
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:3});
					break;
				case 9 :
					//各种卷帘
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:4});
					break;
				case 10 :
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:5});
					break;
				case 11 :
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:6});
					break;
				case 12 :
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:7});
					break;
				case 13 :
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:8});
					break;
				case 14 :
					TransitionManager.start(showMC, {type:Wipe, direction:Transition.IN, duration:durationTime, easing:None.easeNone, startPoint:9});
					break;
				default :
					TransitionManager.start(showMC, {type:Fade, direction:Transition.IN, duration:durationTime, easing:None.easeNone});
					break;
			}
		}
	}
}