package junlas.flash {
    import flash.utils.*;
    import flash.display.*;
    import flash.media.*;

    public class Attach {

        public static function getDisplayObject(s:String):DisplayObject{
            var temp:Class = (getDefinitionByName(s) as Class);
            var returnObj:DisplayObject = new (temp)();
            return (returnObj);
        }
        public static function getSprite(s:String):Sprite{
            var temp:Class = (getDefinitionByName(s) as Class);
            var returnObj:Sprite = new (temp)();
            return (returnObj);
        }
        public static function getMovieClip(s:String):MovieClip{
            var temp:Class = (getDefinitionByName(s) as Class);
            var returnObj:MovieClip = new (temp)();
            return (returnObj);
        }
        public static function getBitmapData(s:String):BitmapData{
            var temp:Class = (getDefinitionByName(s) as Class);
            var returnObj:BitmapData = new temp(null, null);
            return (returnObj);
        }
        public static function getSound(s:String):Sound{
            var temp:Class = (getDefinitionByName(s) as Class);
            var returnObj:Sound = new (temp)();
            return (returnObj);
        }

    }
}//package zlong.breathxue.utils 
