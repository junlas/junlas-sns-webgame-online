package junlas.tooltip
{
	import flash.text.TextField;
	
    public interface ITooltip
    {
        function beginRender( style : uint = 0 ) : void
        function finishRender( ) : void
        function addText(txt:String, color:uint):void  
        function addTitle( text : String, color : uint ) : TextField      
        function addHeader( text : String, color : uint ) : TextField   
        function addKeyValue( key : String, keyColor : uint, value : String, valueColor : uint ) : void  
        function addTextBullet( text : String, color : uint ) : void 
        function addVerticalPadding () : void
        function addVerticalSpace( n : uint ) : void      
        function addRule() : void
    }
}