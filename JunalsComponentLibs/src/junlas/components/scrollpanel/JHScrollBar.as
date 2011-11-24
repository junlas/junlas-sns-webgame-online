package junlas.components.scrollpanel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ScrollBar.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public class JHScrollBar extends JScrollBar
	{
		public function JHScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null,visibleShow:Sprite = null)
		{
			super(JSlider.HORIZONTAL, parent, xpos, ypos, defaultHandler,visibleShow);
		}
	}
}