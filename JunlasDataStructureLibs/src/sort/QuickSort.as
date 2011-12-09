package sort{
	public class QuickSort {
		/*public static void main(String[] args) {
			int[] a = {1501,545,414,78,3,18,611,578,114,125,94,67,157};
			sort(a,0,a.length);
			print(a);
		}*/
		public function sort(a:Array,p1:int,p3:int):void {
			if((p3-p1) <= 1) return;
			var p2:int = get(a,p1,p3);
			sort(a,p1,p2);
			sort(a,p2+1,p3);
		}
		public function get(a:Array, b:int,e:int):int {
			var pos:int=b, temp:int=a[b];
			var dir:Boolean = true;
			while(b<e) {
				if(dir) {
					if(a[--e] <= temp) {
						a[pos] = a[e];
						pos = e;
						dir = false;
					}
				} else {
					if(a[++b] >= temp) {
						a[pos] = a[b];
						pos = b;
						dir = true;
					}
				}
			}
			a[pos] = temp;
			return pos;
		}
		
		public function print(a:Array):void {
			for each (var i:int in a) {
				trace(i);
			}
		}
		
	}
}