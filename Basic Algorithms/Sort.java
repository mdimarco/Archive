import java.util.Random;


public class Sort {
	
	/**
	 * Implement insertion sort.
	 * 
	 * It should be:
	 *  inplace
	 *  stable
	 *  
	 * Have a worst case running time of:
	 *  O(n^2)
	 *  
	 * And a best case running time of:
	 *  O(n)
	 * 
	 * @param arr
	 */
	public static <T extends Comparable<T>> void insertionsort(T[] arr) {
		// TODO Auto-generated method stub
	}
	
	/**
	 * Implement quick sort. 
	 * 
	 * Use the provided random object to select your pivots.
	 * For example if you need a pivot between a (inclusive)
	 * and b (exclusive) where b > a, use the following code:
	 * 
	 * int pivotIndex = r.nextInt(b - a) + a;
	 * 
	 * It should be:
	 *  inplace
	 *  
	 * Have a worst case running time of:
	 *  O(n^2)
	 *  
	 * And a best case running time of:
	 *  O(n log n)
	 * 
	 * @param arr
	 */
	public static <T extends Comparable<T>> void quicksort(T[] arr, Random r) {
		if(arr.length >= 2){
			quickAux(arr,0,arr.length,r);
		}
	}
	
	public static <T extends Comparable<T>> void quickAux(T[] arr, int start, int stop, Random r){
		if(arr.length >=2){
			int partitionInd = partition( arr, r.nextInt(stop-start)+start);
			quickAux(arr,0,partitionInd,r);
			quickAux(arr,partitionInd,arr.length,r);
		}
	}
	public static <T extends Comparable<T>> int partition(T[] arr, int pivot){
		int partInd = 0;
		
		
		return partInd;
	}
	
	/**
	 * Implement merge sort.
	 * 
	 * It should be:
	 *  stable
	 *  
	 * Have a worst case running time of:
	 *  O(n log n)
	 *  
	 * And a best case running time of:
	 *  O(n log n)
	 *  
	 * @param arr
	 * @return
	 */
	public static <T extends Comparable<T>> T[] mergesort(T[] arr) {
		if(arr.length < 2 ) return arr;
		else{
			int pivot = arr.length / 2;
			T[] left = (T[]) new Object[pivot];
			for(int i = 0; i<pivot;i++) left[i] = arr[i];
			
			T[] right = (T[]) new Object[arr.length-pivot];
			for(int i = pivot; i<arr.length; i++) right[i] = arr[i];
			
			left = mergesort(left);
			right = mergesort(right);
			return merge(left,right);
			
		}
	}
	
	
	private static <T extends Comparable<T>> T[] merge(T[] left, T[] right){
		T[] merged =(T[]) new Object[left.length + right.length];
		
		int i = 0;
		int j = 0;
		int k = 0;
		while(k<merged.length){
			while(compare(left[i],right[j]) >= 0){
				merged[k] = left[i];
				i++;
				k++;
			}
			j++;
			while(compare(right[j],left[i]) < 0){
				merged[k] = right[j];
				j++;
				k++;
			}
			i++;
			
			if(j >= right.length){
				while(i < left.length){
					merged[k] = left[i];
					i++;
					k++;
				}
			}
			
			if(i >= left.length){
				while(j < right.length){
					merged[k] = right[j];
					j++;
					k++;
				}
			}
			
		}
		
		return merged;
	}
	
	
	/**
	 * Implement radix sort
	 * 
	 * Hint: You can use Integer.toString to get a string
	 * of the digits. Don't forget to account for negative
	 * integers, they will have a '-' at the front of the
	 * string.
	 * 
	 * It should be:
	 *  stable
	 *  
	 * Have a worst case running time of:
	 *  O(kn)
	 *  
	 * And a best case running time of:
	 *  O(kn)
	 * 
	 * @param arr
	 * @return
	 */
	public static int[] radixsort(int[] arr) {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * compareTo helper method
	 * @param a - val 1 to be compared
	 * @param b - val 2 to be compared
	 * @return - compare val
	 */
	private static <T extends Comparable<T>> int compare(T a, T b) {
	    if(a == null && b == null) return 0;
	    else if (a == null) return 1;
	    else if (b == null) return -1;
	    else return a.compareTo(b);
	}
}