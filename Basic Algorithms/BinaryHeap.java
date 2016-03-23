import java.util.Comparator;

/**
 * This is an implementation of a heap that is backed by an array.
 * 
 * This implementation will accept a comparator object that can be used to
 * define an ordering of the items contained in this heap, other than the
 * objects' default compareTo method (if they are comparable). This is useful if
 * you wanted to sort strings by their length rather than their lexicographic
 * ordering. That's just one example.
 * 
 * Null should be treated as positive infinity if no comparator is provided. If
 * a comparator is provided, you should let it handle nulls, which means it
 * could possibly throw a NullPointerException, which in this case would be
 * fine.
 * 
 * If a comparator is provided that should always be what you use to compare
 * objects. If no comparator is provided you may assume the objects are
 * Comparable and cast them to type Comparable<T> for comparisons. If they
 * happen to not be Comparable you do not need to handle anything, and you can
 * just let your cast throw a ClassCastException.
 * 
 * This is a minimum heap, so the smallest item should always be at the root.
 * 
 * @param <T>
 *            The type of objects in this heap
 */
public class BinaryHeap<T> implements Heap<T> {

	/**
	 * The comparator that should be used to order the elements in this heap
	 */
	private Comparator<T> comp;

	/**
	 * The backing array of this heap
	 */
	private T[] data;

	/**
	 * The number of elements that have been added to this heap, this is NOT the
	 * same as data.length
	 */
	private int size;

	/**
	 * Default constructor, this should initialize data to a default size (11 is
	 * normally a good choice)
	 * 
	 * This assumes that the generic objects are Comparable, you will need to
	 * cast them when comparing since there are no bounds on the generic
	 * parameter
	 */
	public BinaryHeap() {
		// TODO Implement this.
	}

	/**
	 * Constructor that accepts a comparator to use with this heap. Also
	 * initializes data to a default size.
	 * 
	 * When a comparator is provided it should be preferred over the objects'
	 * compareTo method
	 * 
	 * If the comparator given is null you should attempt to cast the objects to
	 * Comparable as if a comparator were not given
	 * 
	 * @param comp
	 */
	public BinaryHeap(Comparator<T> comp) {
		// TODO Implement this.
	}

	@Override
	public void add(T item) {
		// TODO Implement this.
	}

	@Override
	public boolean isEmpty() {
		// TODO Implement this.
		return false;
	}

	@Override
	public T peek() {
		// TODO Implement this.
		return null;
	}

	@Override
	public T remove() {
		// TODO Implement this.
		return null;
	}

	@Override
	public int size() {
		// TODO Implement this.
		return 0;
	}
}