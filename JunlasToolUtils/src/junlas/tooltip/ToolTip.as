package junlas.tooltip
{   
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.PixelSnapping;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import org.aswing.ASColor;  
    import junlas.ui.FormattedText;
    import junlas.tooltip.ITooltip;
    import caurina.transitions.Tweener;
    import junlas.util.Util;
    
    public class ToolTip extends FormattedText implements ITooltip
    { 
    	private var event:ToolTipEvent;
        private var bitmapData:BitmapData;
        private var positioningOffset:Number;
        private var yOffset:int = 0;
        public static const BELOW_MOUSE:uint = 66666;
        public static var DEFAULT_FILTERS:Array = [ new GlowFilter(0,.8,5,5,6,2), new GlowFilter(0,.3,2,2,1,1)  ];
        private var m_completionFunction : Function;
        private var m_tooltipControl : *;
        private var m_timer : Timer;
        private var m_renderTimer : Timer;
        private var m_control:*;
        private var floating:Boolean = false;
        private var poolIndex:int;
        private static var currentPoolIndex:uint = 0;
        public static const MAX_TOOLTIPS:uint = 4;
        public static var currentTooltipControl : *;
        private var m_bitmapCache : Bitmap;
        private static var pool:Array;
        public static var owner:DisplayObjectContainer;
        
        public static function onTooltipControlMouseIn( control : *, noIcon : Boolean = false ) : void
        {
        
            if ( control != currentTooltipControl )
            {
                currentTooltipControl = control;
                dispatchTip( noIcon );
            }
        }

        public static function onTooltipControlMouseOut( control : * ) : void
        {
            if ( control == currentTooltipControl )
            {
                currentTooltipControl = null;
                dispatchTip( false );
            }
        }
        
        public static function nextTip():uint{
            currentPoolIndex++;
            if(currentPoolIndex >= MAX_TOOLTIPS){
                currentPoolIndex = 0;
            }
            return currentPoolIndex;
        }
        
        private static function dispatchTip(  noIcon : Boolean = false ) : void
        {
        	if(!pool){
        		pool = new Array;
        		for ( var p : int = 0; p < MAX_TOOLTIPS; p++ )
                {
                    pool.push( new ToolTip( owner, p ));
                }
        	}
            var evt : ToolTipEvent;
            var index : int;
            if ( currentTooltipControl )
            {
                index = ToolTip.nextTip();
            }
            else
            {
                index = -1;
            }
            for ( var i : int = 0; i < ToolTip.MAX_TOOLTIPS; i++ )
            {
                evt = new ToolTipEvent( ToolTipEvent.TOOLTIP_CHANGED + "" + i, ( i != index ? null : currentTooltipControl ), noIcon );
                ToolTipEvent.dispatcher.dispatchEvent( evt );
            }
        }
        
        public function ToolTip(owner:DisplayObjectContainer,poolIndex:int)
        {
            super( 220 );      
            this.poolIndex = poolIndex;
            owner.addChild(this);
            ToolTipEvent.dispatcher.addEventListener( ToolTipEvent.TOOLTIP_CHANGED , handleChanged, false, 0, true );
            ToolTipEvent.dispatcher.addEventListener( ToolTipEvent.TOOLTIP_CHANGED+""+poolIndex, handleChanged, false, 0, true );
            
            addEventListener(MouseEvent.MOUSE_DOWN,tryMouse,false,0,true);
        }  
        
        
        private function tryMouse(evt:MouseEvent):void{
           /*  var arr:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX,stage.mouseY));
            if(arr && arr.length){
                var sendclick:Boolean = false;
                var vport:Boolean = true;
                for each(var obj:DisplayObject in arr){
                    //trace("! clicked oVER "+getQualifiedClassName(obj)+"/"+obj.name); 
                    if(obj is Bitmap){
                        if((obj as Bitmap).bitmapData is renderer.MapChunkBitmapData){
                            sendclick = true;
                        }
                    } else {
                        vport = false;
                    }
                }
                if(vport && sendclick) (UI.instance.viewport as Viewport).viewportSprite.dispatchEvent(evt);
            } */
        }
       
       

        private function handleChanged( evt : ToolTipEvent ) : void
        {       
            this.event = evt;
            var exptime:Number = 1; //200;
            var obj:* = (evt as ToolTipEvent).obj;
            if(obj){
                if(obj is Sprite || obj is SimpleButton || obj is DisplayObject){ 
                    m_control = obj; 
                } else {
                    event = null; //were being replaced!
                    exptime = 1;
                    m_control = null;
                }
            } else {
                event = null;
                m_control = null;
            }
            
            if (m_control) floating = true; 
            var tooltipControl : * = currentTooltipControl;
            if(!m_control) tooltipControl = null;
            if( m_tooltipControl != tooltipControl )
            {
                if( m_tooltipControl )
                    m_tooltipControl.removeEventListener( ToolTipEvent.CHANGE, changeInPlace );
                m_tooltipControl = tooltipControl;
                if( m_tooltipControl )
                    m_tooltipControl.addEventListener( ToolTipEvent.CHANGE, changeInPlace, false, 0, true );
            }
            if( m_tooltipControl )
            {
                if(stage) stage.removeEventListener(MouseEvent.MOUSE_MOVE,mousePosition);
                removeEventListener(Event.ENTER_FRAME,mousePosition); 
                if( m_timer )
                {
                    m_timer.removeEventListener( TimerEvent.TIMER, handleTimerExpired );
                    m_timer.stop();
                    m_timer = null;
                }       
                
                Tweener.removeTweens(this);        
                alpha = 1;
                render();
                doFloating();
            }
            else if( !m_timer && visible)
            {
                m_timer = new Timer( exptime, 1 );
                m_timer.addEventListener( TimerEvent.TIMER, handleTimerExpired, false, 0, true );
                m_timer.start();
            }
        }
        
        private function doFloating():void{
            if(m_control && visible ){
                scaleX = scaleY = .2;
                alpha = .05;
                Tweener.removeTweens(this);
                Tweener.addTween(this, { scaleX : 1, scaleY : 1, time : .3, transition:"easeOutQuad" });
                Tweener.addTween(this, { alpha : 1, time : .5, transition:"easeInQuad" });
                if(stage) stage.addEventListener(MouseEvent.MOUSE_MOVE,mousePosition,false,0,true);
                addEventListener(Event.ENTER_FRAME,mousePosition,false,0,true);
                floating = true;
                positioningOffset = (stage.mouseY < stage.stageHeight / 2 ? 20 : -height/2 - 20);
                if(stage.mouseY < 60 || stage.mouseY > stage.stageHeight - 60) positioningOffset *= 1.3;              
            }
        }
        
        
        private function changeInPlace( evt : Event ) : void
        {
            //trace(poolIndex+" got changed in place!");
            var tooltipControl : * = currentTooltipControl;
            
            if( m_tooltipControl != tooltipControl )
            {
                if( m_tooltipControl )
                    m_tooltipControl.removeEventListener( ToolTipEvent.CHANGE, changeInPlace );

                m_tooltipControl = tooltipControl;
                if( m_tooltipControl )
                    m_tooltipControl.addEventListener( ToolTipEvent.CHANGE, changeInPlace, false, 0, true );
            }
            
            if( m_tooltipControl )
            {
                if( m_timer )
                {
                    m_timer.removeEventListener( TimerEvent.TIMER, handleTimerExpired );
                    m_timer.stop();
                    m_timer = null;
                }
                render();
            }
            else if( !m_timer )
            {
                m_timer = new Timer( 500, 1 );
                m_timer.addEventListener( TimerEvent.TIMER, handleTimerExpired, false, 0, true );
                m_timer.start();
            }
        }
        
        
        private function handleTimerExpired( e:TimerEvent ) : void
        {
            m_timer.removeEventListener( TimerEvent.TIMER, handleTimerExpired );
            if(stage) stage.removeEventListener(MouseEvent.MOUSE_MOVE,mousePosition);
            removeEventListener(Event.ENTER_FRAME,mousePosition);           
            m_timer = null;
            Tweener.removeTweens(this);
            Tweener.addTween(this,{ scaleX: .2, scaleY: .2, time : .4, transition : "linear", onComplete : hide});
            Tweener.addTween(this,{ alpha : 0,  time : .3, transition : "easeOutQuad" });
        }
        
        
        private function hide():void{
            m_control = null;
            event = null;
            visible = false;  
            if(m_bitmapCache) m_bitmapCache = null;
            if(bitmapData) bitmapData.dispose();
            floating = false;
            Tweener.removeTweens(this);
            scaleX = scaleY = 1;
            if(stage) stage.removeEventListener(MouseEvent.MOUSE_MOVE,mousePosition);
            removeEventListener(Event.ENTER_FRAME,mousePosition);         
            removeChildrens();// call below function: 'removeChildrens'
        }
        
		/**
		 * modify 1: previous function name is 'removeChildren', now changed 'removeChildrens' by me
		 */
        private function removeChildrens():void { 
            while( numChildren > 0 ) removeChildAt( numChildren - 1 );
        }
        
        private function hideChildren():void {
            for( var i : int = 0; i < numChildren; ++i )
                getChildAt( i ).visible = false;
        }
        
        private function showChildren():void {
            for( var i : int = 0; i < numChildren; ++i )
                getChildAt( i ).visible = true;
        }
        
        private function renderToBitmap():void{
            //trace("rtb");
            var w:Number = width;
            var h:Number = height;
            if(!w || !h) return;
            
            if(bitmapData) bitmapData.dispose();
            filters = DEFAULT_FILTERS;
            var r:Rectangle = Util.getVisibleDimensions(this);
            if(!r.width || !r.height) return;
            bitmapData = new BitmapData(r.width,r.height,true,0); //0x88000000);
            
            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.lineStyle(); //1.5,0xffffff,0x88/255);
            g.beginFill(0x00ff00,.8);
            g.drawRoundRect(0,0,r.width,r.height,16,16);
            g.endFill();
            bitmapData.draw(s,new Matrix(1,0,0,1),null,null,null,true);
            
            bitmapData.draw(this,new Matrix(1,0,0,1,-r.x,-r.y),null,null,null,true);
            filters = null;
            bitmapData.draw(this,new Matrix(1,0,0,1,-r.x,-r.y),null,null,null,false);
            hideChildren();
            filters = null;
            
            m_bitmapCache = new Bitmap(bitmapData,PixelSnapping.NEVER,true);
            addChild(m_bitmapCache);      
        }
        
        private function render() : void
        {
            visible = false;
            try {
                currentTooltipControl.renderTooltip( this );  
            } catch (e:Error){
                
            }
        }
        
        private function mousePosition(evt:* = null):void{    
            y = (-height/2) + yOffset;
            x = 15;
            var gp:Point = localToGlobal(new Point(x,y));
            if(stage){
                owner.x = stage.mouseX;
                owner.y = stage.mouseY;
	            if(gp.x + this.width > stage.stageWidth - 5){
	                y = 20;
	                x = globalToLocal(new Point(stage.stageWidth - this.width - 5,0)).x;
	            }
            }
            //trace("mp ",y, this.width,this.height);
        }
        
        
        private function formatModifier( modifier : int ) : String
        {
            if( modifier > 0 ) return "+" + modifier.toString();
            return modifier.toString();
        }
        
        private function isNotEmptyString(element : *) : Boolean
        {
            return (element != null && element != "");
        }
        
        public function renderSimpleTooltip( str : String ) : void
        {
            beginRender();
            addTitle( str, 0x00ffff );
            finishRender();
        }
        
       
        
        public override function beginRender( style : uint = 0 ) : void
        {
            if(style == BELOW_MOUSE){ 
                yOffset = 30;
            } else{
                yOffset = 0;
            }
            super.beginRender(style);
        }
        
        
        private function handleRenderTimer( evt : Event ) : void
        {
            m_renderTimer.stop();
            m_renderTimer = null;
            invokeCompletion();
        }
        
        private function invokeCompletion() : void
        {    
            if( null != m_completionFunction )
            {
                var f : Function = m_completionFunction;
                m_completionFunction = null;
                f();
            }
        }
        
        private function reRenderIn( ms : uint ) : void
        {
            if( m_renderTimer )
            {
                m_renderTimer.stop();
                m_renderTimer.delay = ms;
            }
            else
            {
                m_renderTimer = new Timer( ms );
                m_renderTimer.addEventListener( TimerEvent.TIMER, handleRenderTimer );
            }
            
            m_renderTimer.start();
        }
        
        
        public override function finishRender() : void
        {
            super.finishRender();
            //x = stage.stageWidth - width - 5;
            //y = stage.stageHeight - height - 55;
            visible = true;
            renderToBitmap();
        }
        
    }
}
