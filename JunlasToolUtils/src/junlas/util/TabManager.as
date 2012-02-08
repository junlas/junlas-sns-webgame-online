package junlas.util
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.events.FocusEvent;
   import flash.ui.Keyboard;
   import flash.display.Stage;
   import flash.display.InteractiveObject;


   public class TabManager extends EventDispatcher //to do: make this static/a singleton
   {
      private var _objects:Dictionary;
      private var _stage:Stage;

      public function TabManager (stage:Stage):void
      {
         _stage = stage;
         _objects = new Dictionary();
      }

      public function setStage (stage:Stage):void
      {
         _stage = stage;
      }

      public function stageSet ():Boolean
      {
         return (_stage != null);
      }

      public function addUIElement (obj:EventDispatcher, tabstop:int):void
      {
         if (!obj) {
            throw new Error("object cannot be set to null.");
         }

         if (_objects[tabstop]) {
            throw new Error("tabstop " + tabstop + " already being used.");
         }

         _objects[tabstop] = {obj:obj, tabstop:tabstop, tabPressed:false};

         obj.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
         obj.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
      }


      public function clearTabs ():void
      {
         var control:EventDispatcher;

         for each (var obj:Object in _objects) {
            control = obj.obj;
            if (control) {
               control.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
               control.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
            }
         }

         _objects = new Dictionary();
      }


      private function tabPressed (event:KeyboardEvent):Boolean
      {
         if (event.keyCode == Keyboard.TAB) {
            return true;
         }
         return false;
      }


      private function getFromList (list:Dictionary, control:EventDispatcher):int
      {
         for each (var obj:Object in list) {
            if (obj.obj == control) {
               return obj.tabstop;
            }
         }
         return -1;
      }


      private function onKeyDown (event:KeyboardEvent):void
      {
         var control:EventDispatcher = event.currentTarget as EventDispatcher;
         if (!control) {
            return;
         }

         if (!tabPressed(event)) {
            return;
         }

         var tabstop:int = getFromList (_objects, control);

         if (tabstop >= 0) {
            _objects[tabstop].tabPressed = true;
         }
      }

      private function getNextControl (tabstop:int):EventDispatcher
      {
         var returnNextOne:Boolean = false;

         for each (var obj:Object in _objects) {
            if (returnNextOne) {
               return obj.obj;
            }
            if (obj.tabstop == tabstop) {
               returnNextOne = true;
            }
         }
         return null;
      }

      private function onFocusOut (event:FocusEvent):void
      {
         if (event.relatedObject) {

            var tabstop:int = getFromList(_objects, event.currentTarget as EventDispatcher);
            var nextControl:Object;

            if (tabstop >= 0) {
               if (_objects[tabstop].tabPressed) {
                  nextControl = getNextControl(tabstop);
                  if (nextControl) {
                     if (_stage) {
                        _stage.focus = nextControl as InteractiveObject;
                     } else {
                        throw new Error("_stage must not be null");
                     }
                  }
                  _objects[tabstop].tabPressed = false;
               }
            }

         }
      }





   }
}