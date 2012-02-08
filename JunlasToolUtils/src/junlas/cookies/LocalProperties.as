package junlas.cookies
{
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;

   public class LocalProperties
   {
      public var loaded:Boolean = false;
      private var _properties:Object
      private var _objectName:String = "properties";


      public function load():Boolean
      {
         var sharedObj:SharedObject

         try {
            sharedObj = SharedObject.getLocal(_objectName, "/");
         } catch (e:Error) {
            return false;
         }

         if (!sharedObj) return false;

         if (!_properties) {
            _properties = new Object();
         }

         _properties = sharedObj.data.properties;

         if (!_properties) {
            _properties = {};
         }

         loaded = true;

         return true;
      }

      public function getAllProperties ():Array
      {
         loadIfNeeded();
         if (!loaded) return null;

         var arr:Array = new Array();
         for (var name:String in _properties) {
            arr.push({name:name, value:_properties[name]});
         }

         return arr;
      }

      public function setProperty(name:String, value:Object):void
      {
         _properties[name] = value;
         var sharedObj:SharedObject = SharedObject.getLocal(_objectName, "/");
         sharedObj.data.properties = _properties;
         sharedObj.flush();
      }

      public function valueOf(name:String):Object
      {
         loadIfNeeded();
         if (!_properties[name]) {
            return null;
         }
         return _properties[name];
      }

      public function get bbrt():uint
      {
         if (!valueOf("bbrt")) return 0;
         return _properties.bbr as uint;
      }


      private function loadIfNeeded ():void
      {
         if (!loaded) {
            load();
         }
      }

   }
}