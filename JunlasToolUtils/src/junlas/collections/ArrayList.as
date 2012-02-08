package junlas.collections
{

dynamic public class ArrayList extends Array
{
    public function ArrayList()
    {
        super();
    }

    /**
     * 参数最大可以是一个一维数组，不允许时二维的。
     * <br>
     * 会逐个取出一维数组中的数据，逐个加入到这个arrayList的后面
     * <br>
     * <strong>建议:参数传递单个对象</strong>
     */
    public function add(... args) : void
    {
        for(var i : int = 0;i < args.length;i++)
        {
            if(!(args[i] is Array))
            {
                if(!this.contains(args[i]))
                {
                    this.push(args[i]);
                }
            }
            else
            {
                var ary : Array = args[i];
                for(var j : int = 0;j < ary.length;j++)
                {
                    if(!this.contains(ary[j]))
                    {
                        this.push(ary[j]);
                    }
                }
            }
        }
    }

    /**
     * 是否包含一个元素
     */
    public function contains(a : Object) : Boolean
    {
        var index:int = this.indexOf(a);
        return index != -1;
    } 

    /**
     * 删除一个元素
     */
    public function removeByItem(item : Object) : void
    {
        /*for(var i : int = 0;i < this.length;i++)
        {
            if(this[i] === item)
            {
                var deletes : Array = this.splice(i, 1);
                return ;
            }
        }*/
        var index:int = this.indexOf(item);
        if(index != -1){
        	this.splice(index, 1);
        }
    }

    /**
     * 根据索引删除一个元素
     */
    public function removeByIndex(index : int) : Object
    {
        var deletes : Array = this.splice(index, 1);
        return deletes[0];
    }
	
    /**
     * 根据索引在其后插入一个新元素
     */
    public function insert(item : Object,index : int) : void
    {
        this.splice(index, 0, item);
    }

    /**
     * @param startPos
     * 从startPos位置 （包括该位置） 开始，切断后面所有的元素，并返回切断的数组
     */
    public function cutNextAll(startPos : uint) : ArrayList
    {
        var temp : Array = this.splice(startPos);
        var newArr : ArrayList = new ArrayList();
        newArr.add(temp);
        return newArr;
    }

    public function getNext(currItem : Object) : Object
    {
        var l : int = this.length;
        for(var i : int = 0;i < l;i++)
        {
            if(this[i] === currItem && (i+1) < l)
            {
                return this[i + 1];
            }
        }
        return null;
    }

    public function getItem(index : int) : Object
    {
        return this[index];
    }

    public function reverseTo() : ArrayList
    {
        var al : ArrayList = new ArrayList();
        var j : int = 0;
        for(var i : int = this.length - 1;i >= 0;i--)
        {
            al[j] = this[i];
            j++;
        }
        return al;
    }

    public function clear() : void
    {
        while(this.length)
        {
            this.pop();
        }
    }
}
}