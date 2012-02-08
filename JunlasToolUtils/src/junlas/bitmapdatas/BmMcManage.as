package junlas.bitmapdatas{
	import avmplus.getQualifiedClassName;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * 矢量动画转位图管理类
	 *@author lvjun01
	 */
	public class BmMcManage{
		private static var _instance:BmMcManage;
		
		public function BmMcManage(s:Single){
			_classNameDict = new Dictionary();
			_defineNameMcDict = new Dictionary();
		}
		
		public static function get instance():BmMcManage{
			if(!_instance){
				_instance = new BmMcManage(new Single());
			}
			return _instance;
		}
		
		private var _classNameDict:Dictionary;
		private var _defineNameMcDict:Dictionary;
		
		/**
		 * 注册资源
		 */
		public function regResource(mc:MovieClip,maxFrame:int=4,name:String=null):void{
			var className:String = getQualifiedClassName(mc);
			var bmMovieClip:BmMovieClip = _classNameDict[className];
			if(bmMovieClip){
				return;
			}
			bmMovieClip = new BmMovieClip(mc,maxFrame); 
			_classNameDict[className] = bmMovieClip;
			if(name){
				_defineNameMcDict[name] = bmMovieClip;
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
		public function getResourceByMc(mc:MovieClip):BmMovieClip{
			return (_classNameDict[getQualifiedClassName(mc)] as BmMovieClip).clone();
		}
		
		/**
		 *获取资源(根据className) 
		 * @param className
		 * @return 
		 * 
		 */		
		public function getResourceByClassName(className:String):BmMovieClip{
			return (_classNameDict[className] as BmMovieClip).clone();
		}
		
		/**
		 * 获取资源(根据name)
		 */
		public function getResourceByDefineName(name:String):BmMovieClip{
			return (_defineNameMcDict[name] as BmMovieClip).clone();
		}
		
	}
}

class Single{}