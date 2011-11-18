package junlas.utils.display {
    import flash.display.*;
    import flash.media.*;
    import flash.utils.*;

	/**
	 * @author lvjun
	 */
    public class Attach {
        private static var bitMapDataArray:Array;

		/**
		 * 当前域下获取DisplayObject
		 */
        public static function getDisplayObject(className:String):DisplayObject{
            var definitionClass:Class = (getDefinitionByName(className) as Class);
            var definitionDisplayObject:DisplayObject = new (definitionClass)();
            return definitionDisplayObject;
        }
		
		/**
		 * 当前域下获取Sprite
		 */
        public static function getSprite(className:String):Sprite{
            var definitionClass:Class = (getDefinitionByName(className) as Class);
            var definitionSprite:Sprite = new (definitionClass)();
            return definitionSprite;
        }
		
		/**
		 * 当前域下获取MovieClip
		 */
        public static function getMovieClip(className:String):MovieClip{
            var definitionClass:Class = (getDefinitionByName(className) as Class);
            var definitionMovieClip:MovieClip = new (definitionClass)();
            return definitionMovieClip;
        }
		
		/**
		 * 当前域下获取BitmapData
		 */
        public static function getBitmapData(className:String, isCache:Boolean=false):BitmapData{
            var index:int;
            if (isCache){
                if (!bitMapDataArray){
                    bitMapDataArray = new Array();
                }
				index = 0;
                while (index < bitMapDataArray.length) {
                    if (bitMapDataArray[index][0] == className){
                        return (bitMapDataArray[index][1]);
                    }
					index++;
                }
            }
            var definitionClass:Class = (getDefinitionByName(className) as Class);
            var definitionBmd:BitmapData = new definitionClass(null, null);
            if (isCache){
                bitMapDataArray.push([className, definitionBmd]);
            }
            return definitionBmd;
        }
		
		/**
		 * 清空位图缓存
		 */
        public static function clearBitmapDataCache():void{
            var index:int;
            while (index < bitMapDataArray.length) {
                (bitMapDataArray[index][1] as BitmapData).dispose();
				index++;
            }
            bitMapDataArray = new Array();
        }
		
		/**
		 * 当前域下获取Sound
		 */
        public static function getSound(className:String):Sound{
            var definitionClass:Class = (getDefinitionByName(className) as Class);
            var definitionSound:Sound = new (definitionClass)();
            return definitionSound;
        }

    }
}
