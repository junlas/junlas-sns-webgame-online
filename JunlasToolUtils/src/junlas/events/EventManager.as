package junlas.events
{
import flash.display.Sprite;	
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

/**
 */
public final class EventManager
{
    static private var events : Dictionary = new Dictionary(true);

    /**
     * 获得一个对象的所有事件
     * 
     * @param obj
     * @return 
     * 
     */
    static public function getEvents(obj : EventDispatcher) : Array
    {
        return events[obj];
    }

    /**
     * 添加事件
     * 
     * @param obj 监听器
     * @param type 事件类型
     * @param listener 事件函数
     * @param autoRemove 是否在移出显示列表的时候自动卸除事件
     * 
     */
    static public function addEventListener(obj : EventDispatcher,type : String,listener : Function,autoRemove : Boolean = false,priority : int = 0) : void
    {
		if(!obj)
		{
			return;
		}
        if (!events[obj])
        {
            events[obj] = [];
            if (obj is DisplayObject)
					obj.addEventListener(Event.REMOVED_FROM_STAGE, autoRemoveHandler);
        }
        var item : EventItem = new EventItem(type, listener, autoRemove, priority);
        for (var i:int = (events[obj] as Array).length - 1; i >= 0; i--) 
        {
         	var val : EventItem = (events[obj] as Array)[i];
         	if(val.equals(item))
         	{
         		return;
         	}
        }
        obj.addEventListener(type, listener,false,priority);
        (events[obj] as Array).push(item);
    }

    /**
     * 卸除事件
     * 
     * @param obj 监听器
     * @param type 事件类型，为空则为不限定类型
     * @param listener 事件监听器，为空则为不限定监听器。两者皆为空则会卸除监听器的所有事件
     * @param onlyAutoRemove 是否只卸除允许自动卸除的事件
     * 
     */
    static public function removeEventListener(obj : EventDispatcher,type : String = null,listener : Function = null,onlyAutoRemove : Boolean = false) : void
    {
        var arr : Array = events[obj] as Array;
        if (!arr)
				return;
		
        for (var i : int = arr.length - 1;i >= 0;i--)
        {
            var eventItem : EventItem = arr[i] as EventItem;
            if ((type == null || type == eventItem.type) && (listener == null || listener == eventItem.listener) && (!onlyAutoRemove || eventItem.autoRemove))
            {
                obj.removeEventListener(eventItem.type, eventItem.listener);
                arr.splice(i, 1);
            }
        }
        if (arr.length == 0)
        {
            if (obj is DisplayObject)
					obj.removeEventListener(Event.REMOVED_FROM_STAGE, autoRemoveHandler);
				
            delete events[obj];
        }
    }

    /**
     * 销毁对象
     *  
     * @param obj 对象
     * @param child 是否销毁子对象
     * 
     */
    static public function destory(obj : EventDispatcher,child : Boolean = true) : void
    {
        removeEventListener(obj);
			
        var displayObj : DisplayObject = obj as DisplayObject;
        if (!displayObj)
				return;
			
        if (displayObj is Bitmap)
        {
            (displayObj as Bitmap).bitmapData.dispose();
        }
        if(displayObj is Sprite)
        {
            Sprite(displayObj).graphics.clear();
        }
        if (displayObj is DisplayObjectContainer)
        {
            if (child)
            {
                for (var i : int = (displayObj as DisplayObjectContainer).numChildren - 1;i >= 0; i--) 
                {
                    destory((displayObj as DisplayObjectContainer).getChildAt(i), true);
                }
            }
        }
			
        if (displayObj.parent)
				displayObj.parent.removeChild(displayObj);
    }

    static private function autoRemoveHandler(event : Event) : void
    {
        var obj : DisplayObject = event.currentTarget as DisplayObject;
        obj.removeEventListener(Event.REMOVED_FROM_STAGE, autoRemoveHandler);
			
        removeEventListener(obj, null, null, true); 
    }
}
}

class EventItem
{
    private var _type : String;
    private var _listener : Function;
    private var _autoRemove : Boolean;
    private var _priority : int;

    public function EventItem(type : String,listener : Function,autoRemove : Boolean,priority:int)
    {
        this._type = type;
        this._listener = listener;
        this._autoRemove = autoRemove;
        this._priority = priority;
    }

    public function equals(item : EventItem) : Boolean
    {
        if(_type === item._type && _listener === item._listener && _autoRemove === item._autoRemove && _priority === item._priority)
        {
        	return true;
        }
        return false;
    }
    
    public function get type() : String
    {
        return _type;
    }
    
    public function get listener() : Function
    {
        return _listener;
    }
    
    public function get autoRemove() : Boolean
    {
        return _autoRemove;
    }
    
    public function get priority() : int
    {
        return _priority;
    }
}