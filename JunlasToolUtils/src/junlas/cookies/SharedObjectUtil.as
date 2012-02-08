package junlas.cookies
{
    import flash.events.*;
    import flash.net.*;

    public class SharedObjectUtil
    {
        private static var gameName:String;
        private static var operatedSharedObject:SharedObject;
        private static const PREFIX:String = "SndaGames";
        private static const GLOBAL:String = "global";

        public function SharedObjectUtil()
        {
            return;
        }

        public static function init(gameName:String) : void
        {
            gameName = gameName;
            return;
        }

        public static function getGlobal(param1:String) : SharedObject
        {
            var so:SharedObject;
            var name:* = param1;
            try
            {
                so = SharedObject.getLocal(PREFIX + "_" + GLOBAL + "_" + name, "/");
            }
            catch (err:Error)
            {
                trace("create error");
            }
            return so;
        }

        public static function getLocal(param1:String) : SharedObject
        {
            var so:SharedObject;
            var name:* = param1;
            try
            {
                so = SharedObject.getLocal(PREFIX + "_" + gameName + "_" + name, "/");
            }
            catch (err:Error)
            {
                trace("create error");
            }
            return so;
        }

        public static function save(param1:SharedObject) : void
        {
            var flushResult:String;
            var sharedObject:* = param1;
            operatedSharedObject = sharedObject;
            try
            {
                flushResult = operatedSharedObject.flush();
                if (flushResult == SharedObjectFlushStatus.PENDING)
                {
                    operatedSharedObject.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                }
                else
                {
                    operatedSharedObject = null;
                }
            }
            catch (err:Error)
            {
            }
        }

        private static function statusHandler(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Success")
            {
                trace("save successed");
            }
            operatedSharedObject.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            operatedSharedObject = null;
        }

    }
}
