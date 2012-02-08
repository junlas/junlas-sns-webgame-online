package junlas.bitmap{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 矢量图转位图
	 *@author lvjun01
	 */
	public class BmDisplayObjectManage{
		private static var _instance:BmDisplayObjectManage;
		
		public function BmDisplayObjectManage(s:Single) {
			_classNameDict = new Dictionary();
			_defineNameMcDict = new Dictionary();
		}
		
		public static function get instance():BmDisplayObjectManage{
			if(!_instance){
				_instance = new BmDisplayObjectManage(new Single());
			}
			return _instance;
		}
		
		private var _classNameDict:Dictionary;
		private var _defineNameMcDict:Dictionary;
		
		/**
		 * 注册资源
		 */
		public function regResource(mc:DisplayObject,name:String=null):void{
			var className:String = getQualifiedClassName(mc);
			var bmSprite:BmDisplayObject = _classNameDict[className];
			if(bmSprite){
				return;
			}
			bmSprite = new BmDisplayObject(mc); 
			_classNameDict[className] = bmSprite;
			if(name){
				_defineNameMcDict[name] = bmSprite;
			}
		}
		
		/**
		*是否包含此className的加载资源  
		* @param className
		* @return 
		* 
		*/		
		public function isContainsResByClassName(className:String):Boolean{
			return _classNameDict[className] != null;
		}
		
		/**
		*是否包含此name的加载资源  
		* @param name
		* @return 
		* 
		*/		
		public function isContainsResByName(name:String):Boolean{
			return _defineNameMcDict[name] != null;
		}
		
		/**
		 * 获取资源(根据mc)
		 */
		public function getResourceByMc(mc:DisplayObject):BmDisplayObject{
			return (_classNameDict[getQualifiedClassName(mc)] as BmDisplayObject).clone();
		}
		
		/**
		 *获取资源(根据className) 
		 * @param className
		 * @return 
		 * 
		 */		
		public function getResourceByClassName(className:String):BmDisplayObject{
			return (_classNameDict[className] as BmDisplayObject).clone();
		}
		
		/**
		 * 获取资源(根据name)
		 */
		public function getResourceByDefineName(name:String):BmDisplayObject{
			return (_defineNameMcDict[name] as BmDisplayObject).clone();
		}
		
		
	}
}

class Single{}