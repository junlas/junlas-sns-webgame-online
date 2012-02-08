package junlas.util.aswing
{
    import junlas.util.Fonts;
    
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Dictionary;
    
    import org.aswing.ASColor;
    import org.aswing.ASFont;
    import org.aswing.ASFontAdvProperties;
    import org.aswing.AssetPane;
    import org.aswing.Component;
    import org.aswing.JPanel;
    import org.aswing.LayoutManager;
    import org.aswing.SoftBoxLayout;
    import org.aswing.border.DecorateBorder;
    import org.aswing.border.EmptyBorder;
    import org.aswing.border.LineBorder;
    import org.aswing.geom.IntDimension;
  
    
    public class ASwingHelper
    {
        private static var _sbl:SoftBoxLayout;
        private static var _vbl:SoftBoxLayout;
        private static var _dlb:DecorateBorder;
        private static var cache:Dictionary = new Dictionary(true);
        public static var _debugOff:Boolean = true;
        public static function get debugOff():Boolean{
			//uses compiler configuration, ex:  -define+=CONFIG::debugLayoutOff,true
			var debugConfig:Boolean = false; //CONFIG::debugLayoutOff;
			_debugOff = debugConfig;
			return _debugOff;
        }
       
		
		
		public static function setDebug(jp:*):void{
			
			jp.setBorder(new EmptyBorder(ASwingHelper.debugLB));
			
		}
		
		public static function setDebugAll(jp:*):void
		{
			
			setDebug(jp);
			
			
			
			if(jp.hasOwnProperty("getComponentCount")) {
				for (var i:int = 0; i<jp.getComponentCount(); i++) {
					
					if(jp.getComponentCount() > 0) {
						ASwingHelper.setDebugAll(jp.getComponent(i));
					} else {
						setDebug(jp);
					}
					
				}
				
			}
			
		}
		
		
		public static function makeMultilineText(txt:String, textWidth:int, fontName:String, fontAlign:String=TextFormatAlign.LEFT, fontSize:int=12, fontColor:uint=0x000000, filters:Array = null):AssetPane
		{
			var tf:TextField = new TextField();
			
			
			if(textWidth == -1) {
				tf.multiline = false;
				tf.wordWrap = false;
				tf.text = txt;
				tf.width = tf.textWidth;
				  
			} else {
				tf.width = textWidth;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.text = txt;
			}
			
			tf.selectable = false;
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.PIXEL;
			tf.autoSize = TextFieldAutoSize.CENTER;
			 
			var tform:TextFormat = new TextFormat();
			tform.font = fontName;
			tform.color = fontColor;
			tform.align = fontAlign;
			tform.size = fontSize;
			
			tf.setTextFormat(tform);
			
			tf.filters = filters;
			
			var textAP:AssetPane = new AssetPane(tf);
			ASwingHelper.prepare(textAP);
			
			return textAP;
		}
		
		public static function makeJPanel(layout:LayoutManager=null):JPanel
		{
			
			var jp:JPanel = new JPanel(layout);
			setDebug(jp);
			return jp;
			
		}
		
		public static function makeFont(nm:String, size:int):ASFont
		{
			var name:String = Fonts.ensureFont(nm);
			if (name){
				return new ASFont(name,size,false,false,false,new ASFontAdvProperties(true,AntiAliasType.ADVANCED, GridFitType.PIXEL));
			} else {
				return new ASFont(nm,size,false,false,false,new ASFontAdvProperties(false,AntiAliasType.ADVANCED, GridFitType.PIXEL));
			}
		}

        public static function prepare(...args:*):void{
        	if(args){
	        	for (var i:int=0; i < args.length; i++){
	        		var c:Component = args[i] as Component;
	        		if(c){
		        		c.invalidatePreferSizeCaches();
		        		c.pack();
		        		c.revalidate();
	        		}
	        	}
        	}
        }
        
  
        public static function get softBoxLayout():SoftBoxLayout{
            //if(!_sbl || !_sbl is SoftBoxLayout || !_sbl.getAxis() == SoftBoxLayout.X_AXIS) 
            if(!_sbl) _sbl = new SoftBoxLayout(SoftBoxLayout.X_AXIS,1);
            return _sbl;
        }
        
        public static function get softBoxLayoutVertical():SoftBoxLayout{
            //if(!_vbl || !_vbl is SoftBoxLayout || !_vbl.getAxis() == SoftBoxLayout.Y_AXIS)
             if(!_vbl) _vbl = new SoftBoxLayout(SoftBoxLayout.Y_AXIS,1);
            return _vbl;
        }
        
        public static function get debugLB():DecorateBorder{
            if(debugOff) return null;
            //if(!_dlb) _dlb = new LineBorder(null,ASColor.BLUE,2,5);
             _dlb = new LineBorder(null,new ASColor(0xffffff * Math.random()),.5,0);
            return _dlb;
        }
        
        public static function debug(n:String):DecorateBorder{
            //return null;
            return debugLB;
            //if(!_dlb) _dlb = new LineBorder(null,ASColor.BLUE,2,5);
           /*  _dlb = new TitledBorder(debugLB,n);
            return _dlb;*/
        }
        
        private static var _glow:GlowFilter;
        public static function get borderGlow():GlowFilter{
        	if(!_glow) _glow = new GlowFilter(0x111122,.8,9,9,3,1,true);
        	return _glow;
        }
        
        public static function get debugOnce():DecorateBorder{
            return debugLB;
            //if(!_dlb) _dlb = new LineBorder(null,ASColor.BLUE,2,5);
            return new LineBorder(null,new ASColor(0xffffff * Math.random()),1,0);
        }

        public static function verticalStrut(height:int, bHasBorder:Boolean=false):JPanel{
            var fake:JPanel = new JPanel();
            fake.setPreferredSize(new IntDimension(1,height));
            if(bHasBorder == true) {
				fake.setBorder(debugLB);
			}
			return fake; 
        }
        
        public static function horizontalStrut(width:int, bHasBorder:Boolean=false):JPanel{
            var fake:JPanel = new JPanel();
            fake.setPreferredSize(new IntDimension(width,1));
			if(bHasBorder == true) {
				fake.setBorder(debugLB);
			}
            return fake; 
        }
        

    }
}
