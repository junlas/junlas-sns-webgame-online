package quadtree{
	/**
	 * @author lvjun
	 * 四叉树面对的目标对象
	 */
	public interface IQuadTreeTarget{
		function get isNode():Boolean;
		function get qX():Number;
		function get qY():Number;
		function get qWidth():Number;
		function get qHeight():Number;
	}
}