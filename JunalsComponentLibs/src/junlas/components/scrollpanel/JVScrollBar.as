package junlas.components.scrollpanel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import junlas.components.base.JVisiualConfig;
	
	public class JVScrollBar extends JScrollBar
	{
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ScrollBar.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function JVScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null,visibleShow:Sprite = null,visibleConfig:JVisiualConfig = null)
		{
			super(JSlider.VERTICAL, parent, xpos, ypos, defaultHandler,visibleShow,visibleConfig);
		}
		
	}
}