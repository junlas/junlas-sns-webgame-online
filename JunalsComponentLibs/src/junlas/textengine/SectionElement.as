package junlas.textengine{
	import flash.errors.IllegalOperationError;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;
	import flash.utils.getQualifiedClassName;

	/**
	 *@author lvjun01
	 */
	public class SectionElement{
		public function SectionElement() {
			if(getQualifiedClassName(this) == "junlas.textengine::SectionElement"){
				throw new IllegalOperationError("类SectionElement不可实例化");
			}
		}
		
		public function getElementFormat():ElementFormat{
			return null;
		}
		
		public function getTextElement():TextElement{
			return null;
		}
	}
}