package quadtree {
	import flash.geom.Rectangle;

	/**
	 * @author lvjun01
	 */
	public class QuadTree {
		public var _topLeft:QuadTree;
		public var _topRight:QuadTree;
		public var _bottomLeft:QuadTree;
		public var _bottomRight:QuadTree;
		
		public var _rect:Rectangle;//图形范围
		public var _depth:int;//当前深度
		public var _maxDepth:int;//最大深度
		
		public var _hw:int;
		public var _hh:int;
		public var _midX:int;
		public var _midY:int;
	 
		public var _children:Array = [];
			
		public function QuadTree(p_rect:Rectangle,p_maxDepth:int = 3,currentDepth:int = 0):void {
		    this._depth = currentDepth;
			this._maxDepth = p_maxDepth;
			this._rect = p_rect;
			this._hw = this._rect.width >>1;
			this._hh = this._rect.height >>1;
			this._midX = _rect.x + _hw;
			this._midY = _rect.y + _hh;
		}
		
		/**
		 * 销毁
		 */
		public function clear():void {
			this._children  = [];
			this._topLeft = this._topRight = this._bottomLeft = this._bottomRight = null;
		}
		
		public function toString():String {
			var s:String = "[QuadTreeNode> ";
			var l:int = this._children.length;
			s+= l>1? (l+" children"): (l+" child");
				
			return s;
		}
		
		/**
		 *   节点按 <左上，右上，左下，右下>输出
		 */
		public function dump():String {
			var s:String = "";
			this.preorder(this, function(node:QuadTree):void {
				var d:int = node._depth;
				for (var i:int = 0; i < d; i++) {
					if (i == d - 1)
						s += "+---";
					else
						s += "|    ";
				}
				s += node + "\n";
			});
			return s;
		}
		
		public function preorder(Node:QuadTree,Process:Function):void {
			Process(Node);
			if(Node._topLeft)preorder(Node._topLeft,Process);
			if(Node._topRight)preorder(Node._topRight,Process);
			if(Node._bottomLeft)preorder(Node._bottomLeft,Process);
			if(Node._bottomRight)preorder(Node._bottomRight,Process);
		}
		
		// obj {x:,y:,width:,height:}
		public function retrieve(obj:Rectangle):Array {
			var r:Array = [];
			if(!this._topLeft) {
				r.push.apply(r,this._children);
				return r;
			}
				
			//如果所取区块比本身区域还大，那么它所有子树的children都取出
			if( obj.x <= _rect.x && obj.y<= _rect.y && obj.x+obj.width>=_rect.right && obj.y+obj.height >= _rect.bottom) {
			   r.push.apply(r,this._children);

			   r.push.apply(r,this._topLeft.retrieve(obj));
			   r.push.apply(r,this._topRight.retrieve(obj));
			   r.push.apply(r,this._bottomLeft.retrieve(obj));
			   r.push.apply(r,this._bottomRight.retrieve(obj))	;			   
 
			   return r;
			}
			
			//否则就只取对应的区域子树
			var objRight:Number = obj.x+obj.width;
			var objBottom:Number = obj.y+obj.height;
		  
			// 完全在分区里 
			if((obj.x>_rect.x) && (objRight< this._midX)) {				
				if( obj.y > _rect.y && objBottom <this._midY) {
					r.push.apply(r,this._topLeft.retrieve(obj));
					return r;
				}
				if(obj.y >this._midY && objBottom < this._rect.bottom) {
					r.push.apply(r,this._bottomLeft.retrieve(obj));
					return r;
				}
			}
			if(obj.x > _midX && objRight < _rect.right) {
				if(obj.y>_rect.y && objBottom < _midY) {
					r.push.apply(r,this._topRight.retrieve(obj));
					return r;
				}
				if(obj.y > _midY && objBottom < _rect.bottom) {
					r.push.apply(r,this._bottomRight.retrieve(obj));
					return r;
				}
			}
				
			//只要有部分在分区里，也放到对应分区里，但注意可以重复放			
			
			//上边
			if(objBottom > _rect.y && obj.y< _midY) {
				if(obj.x < _midX &&   objRight > _rect.x  ) {
					r.push.apply(r,this._topLeft.retrieve(obj));
				}
				if( obj.x < _rect.right && objRight > _midX  ) {
					r.push.apply(r,this._topRight.retrieve(obj));
				}
			}
			// 下边
			if(objBottom > _midY && obj.y < _rect.bottom) {
				if(obj.x < _midX && objRight >_rect.x) {
					r.push.apply(r,this._bottomLeft.retrieve(obj));
				}
				if(obj.x < _rect.right && objRight >_midX) {
					r.push.apply(r,this._bottomRight.retrieve(obj));
				}
			}
			return r;
			
		}
		
		/**
		 * 删除
		 */
		public function remove(obj:IQuadTreeTarget):void{
			if(!obj.isNode)return;//不是四叉树结点，不考虑
			if(!this._topLeft){
				if(!removeObj(obj)){
					throw new ArgumentError("四叉树中不存在:"+obj);
				}
				return;
			}
			//只取对应的区域子树
			var objRight:Number = obj.qX+obj.qWidth;
			var objBottom:Number = obj.qY+obj.qHeight;
			
			// 完全在分区里 
			if((obj.qX>_rect.x) && (objRight< this._midX)) {
				if( obj.qY > _rect.y && objBottom <this._midY) {
					this._topLeft.remove(obj);
					return;
				}
				if(obj.qY >this._midY && objBottom < this._rect.bottom) {
					this._bottomLeft.remove(obj);
					return;
				}
			}
			if(obj.qX > _midX && objRight < _rect.right) {
				if(obj.qY>_rect.y && objBottom < _midY) {
					this._topRight.remove(obj);
					return;
				}
				if(obj.qY > _midY && objBottom < _rect.bottom) {
					this._bottomRight.remove(obj);
					return;
				}
			}
			
			//只要有部分在分区里，也放到对应分区里，但注意可以重复放	
			//上边
			if(objBottom > _rect.y && obj.qY< _midY) {
				if(obj.qX < _midX &&   objRight > _rect.x) {
					this._topLeft.remove(obj);
				}
				if( obj.qX < _rect.right && objRight > _midX) {
					this._topRight.remove(obj);
				}
			}
			// 下边
			if(objBottom > _midY && obj.qY < _rect.bottom) {
				if(obj.qX < _midX && objRight >_rect.x) {
					this._bottomLeft.remove(obj);
				}
				if(obj.qX < _rect.right && objRight >_midX) {
					this._bottomRight.remove(obj);
				}
			}
			return;
		}
		
		private function removeObj(obj:IQuadTreeTarget):Boolean{
			var index:int = _children.indexOf(obj);
			if(index != -1){
				_children.splice(index,1);
				return true;
			}else{
				return false;
			}
		}
		/**
		 * 插入
		 */
		public function insert(obj:IQuadTreeTarget):void
		{
			if(!obj.isNode)return;//不作为四叉树的结点考虑的对象，直接return.
			// 如果不能切分或者obj比整个区域还大，就放到children里
			if(this._depth >= this._maxDepth ||( obj.qX <= _rect.x && obj.qY<= _rect.y && obj.qX+obj.qWidth>=_rect.right && obj.qY+obj.qHeight >= _rect.bottom)) {
				this._children.push(obj);
				return;
			}
			if(!this._topLeft) {
				var d:int = this._depth +1;
				this._topLeft = new QuadTree(new Rectangle(this._rect.x,this._rect.y,this._hw,this._hh),this._maxDepth,d);
				this._topRight = new QuadTree( new Rectangle(this._rect.x+this._hw,this._rect.y,this._hw,this._hh ),this._maxDepth,d);
				this._bottomLeft =new QuadTree( new Rectangle(this._rect.x ,this._rect.y+this._hh,this._hw,this._hh),this._maxDepth,d);
				this._bottomRight= new QuadTree( new Rectangle(this._rect.x+this._hw,this._rect.y+this._hh,this._hw,this._hh),this._maxDepth,d);		
			}
			
			var objRight:Number = obj.qX+obj.qWidth;
			var objBottom:Number = obj.qY+obj.qHeight;
			
			// 可以完全放到分区里就递归放到对应分区里
			if((obj.qX>_rect.x) && (objRight< this._midX)) {
				if(obj.qY > _rect.y && objBottom <this._midY) {
					this._topLeft.insert(obj);
					return;
				}
				if(obj.qY >this._midY && objBottom < this._rect.bottom) {
					this._bottomLeft.insert(obj);
					return;
				}
			}
			if(obj.qX > _midX && objRight < _rect.right) {
				if(obj.qY>_rect.y && objBottom < _midY) {
					this._topRight.insert(obj);
					return;
				}
				if(obj.qY > _midY && objBottom < _rect.bottom) {
					this._bottomRight.insert(obj);
					return;
				}
			}
			
			//只要有部分在分区里，也放到对应分区里，但注意可以重复放			
			//上边
		    if(objBottom > _rect.y && obj.qY< _midY) {
				if(obj.qX < _midX &&   objRight > _rect.x) {
					this._topLeft.insert(obj);
				}
				if( obj.qX < _rect.right && objRight > _midX) {
					this._topRight.insert(obj);
				}
			}
			// 下边
			if(objBottom > _midY && obj.qY < _rect.bottom) {
				if(obj.qX < _midX && objRight >_rect.x) {
					this._bottomLeft.insert(obj);
				}
				if(obj.qX < _rect.right && objRight >_midX) {
					this._bottomRight.insert(obj);
				}
			}

		}
		
		
	}
}