public interface Heap<T> {

	/**
	 * Adds item to this heap
	 * 
	 * @param item
	 */
	public void add(T item);

	/**
	 * @return true if this heap is empty, false otherwise
	 */
	public boolean isEmpty();

	/**
	 * @return the minimum element of this heap as defined by the comparator,
	 *         without modifying the heap
	 */
	public T peek();

	/**
	 * Removes and returns the minimum element of this heap
	 * 
	 * @return the minimum element of this heap as defined by the comparator
	 */
	public T remove();

	/**
	 * @return the number of elements in this heap
	 */
	public int size();

}