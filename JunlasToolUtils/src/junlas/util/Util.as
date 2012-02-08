package junlas.util
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.Transform;
    import flash.system.Capabilities;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.display.AVM1Movie;
    import flash.utils.Endian;   

    public class Util
    {

    
        private static var cache:Dictionary = new Dictionary(true);
        
        public static function get sessionRunTime():Number{
        
            return 0;	
        }
        /* 
        public static function announce(str:String,str2:String):void{
            var c:Confirm = new Confirm(str,null,null,false,Confirm.INVERSE,true);
            var f:JFrameTitleBar = c.getTitleBar() as JFrameTitleBar;
            f.setForeground(ASColor.HALO_GREEN);
            if(str2) c.contentPane.append(new JobDescription(str2));
            Util.prepare(c.contentPane,c);
            c.show();   
        }
        */
        
        public static function unpackloadedMC(mc:MovieClip):*{
        	var child:* = mc.getChildAt(0);
        	var mov:MovieClip;
        	if (child is Loader){
        		var lc:* = (child as Loader).content;
        		if(lc is MovieClip) return lc;
        		if(lc is AVM1Movie) mov = convertToAVM2(lc);
        	}
        	if(!mov) mov = mc;
        	return mov;
        }
        
        public static function convertToAVM2(lc:AVM1Movie):*{
        	var bytes:ByteArray = new ByteArray(); 
            bytes.writeObject(lc); 
		    
		    //uncompress if compressed
		    bytes.endian=Endian.LITTLE_ENDIAN;
		    trace("loadBytes" + bytes[0] );
		    if (bytes[0] == 0x43) {
			    //many thanks for be-interactive.org
			    var compressedBytes:ByteArray=new ByteArray() ;
			    compressedBytes.writeBytes(bytes,8);
			    compressedBytes.uncompress();
			
			    bytes.length=8;
			    bytes.position=8;
			    bytes.writeBytes(compressedBytes);
			    compressedBytes.length=0;
			
			    //flag uncompressed
			    bytes[0]=0x46;
		    }
		    hackBytes(bytes);
		    if(bytes.bytesAvailable) return bytes.readObject() else return null;
		}
		
		
		private static function hackBytes(bytes:ByteArray):void {
		    //trace(" hackB");
		    if (bytes[4] < 0x09) {
			    trace("hack 9");
			    bytes[4]=0x09;
		    }
		    //trace(" hackC");
		    //dirty dirty
		    var imax:int=Math.min(bytes.length,100);
		    for (var i:int=23; i < imax; i++) {
			    if (bytes[i - 2] == 0x44 && bytes[i - 1] == 0x11) {
			      bytes[i]=bytes[i] | 0x08;
			      return;
			    }
            }
        }
      
        public static function padStringWithZeroes(string:String, totalDigits:uint):String
	    {
	        var zeroString:String = "";
	        for (var i:uint = 0; i < totalDigits - string.length; i++)
	        {
	            zeroString += "0";
	        }
	        return zeroString + string;
	    }   


        public static function cachedAsset(instance:Class):DisplayObject{
        	var inst:DisplayObject =  new instance as DisplayObject;
        	//inst.cacheAsBitmap = true;
        	if(inst is MovieClip){
        		inst = unpackloadedMC(inst as MovieClip);
        	}
        	return inst;
        	/*
        	if(!cache[instance]){
        		var bmp:BitmapData;
        		var i:DisplayObject = new instance() as DisplayObject;
        		//var r:Rectangle = i.getBounds(i);
        		var r:Rectangle = Util.getVisibleDimensions(i);
        		if(r.width && r.height){
                    bmp = new BitmapData(r.width,r.height,true,0);          
                    bmp.draw(i,new Matrix(1,0,0,1,-r.x,-r.y),null,null,null,true);
                } else {
                	bmp = new BitmapData(50,50,true,0xffff0000);  
                	bmp.noise(1);
                }
        		//bmp = new BitmapData(bnds.width,bnds.height,true,0);
        		//bmp.draw(i);
        		cache[instance] = bmp;
        	}
        	return new Bitmap(cache[instance] as BitmapData) as DisplayObject;
        	*/
        }
  
        //for the full dimensions, regardless of scrollrect
        public static function getFullBounds ( displayObject:DisplayObject ) :Rectangle
        { 
            var bounds:Rectangle, transform:Transform,
                                toGlobalMatrix:Matrix, currentMatrix:Matrix;
         
            transform = displayObject.transform;
            currentMatrix = transform.matrix;
            toGlobalMatrix = transform.concatenatedMatrix;
            toGlobalMatrix.invert();
            transform.matrix = toGlobalMatrix;
         
            bounds = transform.pixelBounds.clone();
         
            transform.matrix = currentMatrix;
         
            return bounds;
        }
        
        //for the visible width and height
        public static function getVisibleDimensions (o:DisplayObject):Rectangle {
          var bitmapDataSize:int = 800;
          var bounds:Rectangle;
          var bitmapData:BitmapData = new BitmapData(bitmapDataSize, 
                                                 bitmapDataSize,
                                                 true,
                                                 0);
          bitmapData.draw(o);
          bounds = bitmapData.getColorBoundsRect( 0xFF000000, 0x00000000, false );
          bitmapData.dispose(); 
          return bounds;
        }
        
        public static function getBitmap(s:DisplayObject):Bitmap{
            var bnds:Rectangle = s.getBounds(s);
            if(bnds.width && bnds.height){
                var bitmapData:BitmapData = new BitmapData(bnds.width,bnds.height,true,0x00ffff00);
                bitmapData.draw(s,new Matrix(1,0,0,1,-bnds.x,-bnds.y),null,null,null,true);
                return new Bitmap(bitmapData);
            }           
            var bmpData:BitmapData = new BitmapData(50,50);
            bmpData.noise(2);
            return new Bitmap(bmpData);     
        }
        /* 
        public static function routeMouseDownToViewport(evt:MouseEvent):void{
        	var stage:Stage = (evt.target as DisplayObject).stage;
            var arr:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX,stage.mouseY));
            if(arr && arr.length){
                for each(var obj:DisplayObject in arr){
                    //trace("! got "+obj.name);
                    if(obj is Bitmap && (obj as Bitmap).bitmapData is renderer.MapChunkBitmapData){
                        //trace("vp!");
                        //undelyingthing.dispatchEvent(evt);
                        break;
                    }
                }
            }
        } */




      public static function urlEncode(str:String):String
      {
         /* var uv:URLVariables = new URLVariables("data=" + str);
         var encoded:String = uv.toString();
         encoded = encoded.substr(5); */
         
         var encoded:String = URLEncoding.encode(str);
         return encoded;
      }


      public static function urlDecode(str:String):String
      {
         /* var uv:URLVariables = new URLVariables("data=" + str);
         var encoded:String = uv["data"].toString(); */
        
         var decoded:String = URLEncoding.decode(str);
         return decoded;
      }

    public static function getItemAttribute (event:*, name:String):String
    {
       var attribs:Object;
       var value:String;
       if (event && event.params && event.params.attributes) {
          attribs = event.params.attributes;
          value = attribs[name];
          if (value) {
             return value;
          }
       }
       return null;
    }

    public static function getItemAttributeFromParams (params:Object, name:String):String
    {
       var attribs:Object;
       var value:String;
       if (params && params.attributes) {
          attribs = params.attributes;
          value = attribs[name];
          if (value) {
             return value;
          }
       }
       return null;
    }



    public static function getItemAttributeAsNumber (event:*, name:String):Number
    {
       var attribs:Object;
       var value:String;

       if (event && event.params && event.params.attributes) {
          attribs = event.params.attributes;
          value = attribs[name];
          if (value) {
             return parseFloat(value);
          }
       }
       return NaN;
    }

    public static function isAttributeTrue (event:*, name:String):Boolean
    {
       var value:String = getItemAttribute(event, name);
       if (value && (value.length > 0)) {
          value = value.toLowerCase();
          if ((value == "1") || (value == "true")) {
             return true;
          }
       }
       return false;
    }

    public static function getTimeString(seconds:int):String
    {
       var minutes:int = Math.round(seconds / 60);
       var hours:int = Math.round(minutes / 60);
       var days:int = Math.round(hours / 24);

       if (seconds < 60) {
          if (seconds == 1) return "1 second";
          return seconds + " seconds";
       }

       if (minutes < 60) {
          if (minutes == 1) return "1 minute";
          return minutes + " minutes";
       }

       if (hours < 24) {
          if (hours == 1) return "1 hour";
          return hours + " hours";
       }

       if (days == 1) return "1 day";
       return days + " days";

    }


    public static function getTimeObject(seconds:int):Object
    {
       var obj:Object = {};

       var minutes:int = Math.round(seconds / 60);
       var hours:int = Math.round(seconds / 60 / 60);
       var days:int = Math.round(seconds / 60 / 60 / 24);

       if (seconds < 60) {

          if (seconds == 1) {
             obj.message =  "1 second";
          } else {
             obj.message = seconds + " seconds";
          }
          obj.duration = seconds;
          obj.uom = "second"

       } else if (minutes < 60) {

          if (minutes == 1) {
             obj.message = "1 minute";
          } else {
             obj.message = minutes + " minutes";
          }
          obj.duration = minutes;
          obj.uom = "minute"

       } else if (hours < 24) {

          if (hours == 1) {
             obj.message = "1 hour";
          } else {
             obj.message = hours + " hours";
          }
          obj.duration = hours;
          obj.uom = "hour"

       } else {

          if (days == 1) {
             obj.message = "1 day";
          } else {
             obj.message = days + " days";
          }
          obj.duration = days;
          obj.uom = "day"
       }

       return obj;

    }


      public static function rgbToHex(rgbColors:String):String
      {
         var vals:Array = rgbColors.split(",");
         if (vals.length) {
            var r:uint = parseInt(vals[0]);
            var g:uint = parseInt(vals[1]);
            var b:uint = parseInt(vals[2]);

            var hexColor:uint = (r << 16) + (g << 8) + b;
            return "0x" + hexColor.toString(16);
         }
         return "0x000000";
      }


      public static function hextorgb(hex:Number):Object
      {
         var rgb24:Number = (isNaN(hex)) ? parseInt(""+hex, 16) : hex;
         var r:int = (rgb24 >> 16) & 0x000000FF;
         var g:int = ((rgb24 ^ (r << 16)) >> 8) & 0x000000FF;
         var b:int  = ((rgb24 ^ (r << 16)) ^ (g << 8)) & 0x000000FF;
         return {r:r, g:g, b:b};
      }

      public static function getColorString(hex:Number):String
      {
         var obj:Object = hextorgb(hex);
         var colorString:String;

         if (obj) {
            colorString = obj.r + "," + obj.g + "," + obj.b;
         }

         return colorString;
      }

      private static function convertPrefix (color:String):String
      {
         var index:int = color.search("#");
         if (index >= 0) {
            color = color.substr(index + 1);
         }
         index = color.search("0x");
         if (index >= 0) {
            return color;
         }
         return "0x" + color;
      }

      public static function getColorFromString(strHex:String):uint
      {
         var stripped:String = convertPrefix(strHex);
         return parseInt(stripped);
      }

      public static function getColorStringFromString(strHex:String):String
      {
         var stripped:String = convertPrefix(strHex);
         var hex:uint = parseInt(stripped);
         if (hex <= 0) {
            return "";
         }

         var obj:Object = hextorgb(hex);
         var colorString:String;

         if (obj) {
            colorString = obj.r + "," + obj.g + "," + obj.b;
         }

         return colorString;
      }

      // time routines pulled from MasterOfTime
      public static var clientTime:Number = 0;

      public static function get timeElapsed():Number
      {
         return flash.utils.getTimer() - clientTime;
      }

      public static function get timeNow():Number
      {
         return 0; //serverTime + timeElapsed;
      }
      // done from MasterOfTime

      public static function createDateStamp():String
      {
         var dt:Date = new Date(timeNow); // now using master of time rather than client.
         var strDate:String = dt.fullYear + "-" + (dt.month +1) + "-" + dt.date
            + "_" + dt.hours + "-" + dt.minutes + "-" + dt.seconds;
         return strDate;
      }


      public static function stripAllWhitespace(str:String):String
      {
         var temp:String;
         var pat:RegExp;

         temp = str.replace(/ /g, "");
         temp = temp.replace(/\n/g, "");
         temp = temp.replace(/\r/g, "");

         return temp;
      }

      public static function stripAllBackslashes(str:String):String
      {
         if (!str) return str;
         
         var temp:String;

         temp = str.replace(/\\/g, "");

         return temp;
      }


      public static function encodeAllBackslashes(str:String):String
      {
         var temp:String;
         var pat:RegExp;

         temp = str.replace(/\\/g, "@");

         return temp;
      }


      public static function decodeAllBackslashes(str:String):String
      {
         var temp:String;
        
         temp = str.replace(/@/g, "\\");

         return temp;
      }


  
      public static function logMachineInfo ():void
      {
         var str:String = ""; //"Username: " + myUserName + " (" + myUserId + ") | ";
         str += "Flash Version: " + flash.system.Capabilities.version + " | ";
         str += "Language: " + flash.system.Capabilities.language + " | ";
         str += "O/S: " + flash.system.Capabilities.os + " | ";
         str += "Screen Resolution : " + flash.system.Capabilities.screenResolutionX + " x " + flash.system.Capabilities.screenResolutionY + " | ";
         str += "Total Memory in use by Flash: " + (flash.system.System.totalMemory / (1024 * 1024)).toFixed(3) + " MB | ";
         //str += "Browser: " + ExtIntBase.call("getUserAgent") + "";

         //to do: send this somewhere
      }

      
      protected static var timers:Dictionary;
      
           
      public static function startTimer (name:String, delay:Number, completeFunc:Function, count:int = 1, timerFunc:Function = null):void
      {
         if (!timers) {
            timers = new Dictionary();
         }
         
         if (timers[name]) {
            throw new Error("Already have a live timer by that name");
            return;
         }
         
         var timer:Timer = new Timer(delay, count);
         if (completeFunc != null) {
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeFunc, false, 0, true);
         }
         if (timerFunc != null) {
            timer.addEventListener(TimerEvent.TIMER, timerFunc, false, 0, true);
         }
         timer.start();
         
         timers[name] = {timer:timer, func:completeFunc, timerFunc:timerFunc};
      }

      
      public static function deepCopy(obj:Object):Object
      {
          var myBA:ByteArray = new ByteArray();
          myBA.writeObject(obj);
          myBA.position = 0;
          return(myBA.readObject() as Object);
      }

      public static function killTimer (name:String):void
      {
         if (!timers) {
            return;
         }
         
         if (timers[name] && timers[name].timer) {
            var timer:Timer = timers[name].timer as Timer;
            var func:Function = timers[name].func as Function;
            var timerFunc:Function = timers[name].timerFunc as Function;
           
            if (timer && func != null) {
               timer.removeEventListener(TimerEvent.TIMER_COMPLETE, func);
            }
            
            if (timer && timerFunc != null) {
               timer.removeEventListener(TimerEvent.TIMER, timerFunc);
            }
            
            timer.stop();
            timer = null;
            timers[name] = null;
         }
      }
      
   }
}
