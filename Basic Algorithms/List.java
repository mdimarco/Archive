import java.util.Collection;

/**
 * Refer to the java API for how each method should behave. (don't
 * worry about the return type for add and addAll) 
 * 
 * You should throw exceptions where appropriate.
 * 
 * http://docs.oracle.com/javase/7/docs/api/java/util/List.html
 * @author - Mason DiMarco
 * mdimarco3
 */
public interface List<E> {
	/**
	 * inserts an item in between the end of the list and the head node.
	 * @param e- the data that the new node contains
	 * @return void
	 */
	void add(E e);
	
	
	
	/**
	 * Appends all of the elements in the specified collection to the end of this list
	 * @param Collection - collection to be added
	 */
	void addAll(Collection<? extends E> c);
	
	/**
	 * clears the list, removing all elements.
	 */
	void clear();
	/**
	 * Tells whether or not object is in the List
	 * @param o- object to be located
	 * @return true if there false if not
	 */
	boolean contains(Object o);
	
	/**
	 * returns the element at the specified index of the list
	 * Throws IndexOutOfBoundsException if index<0 || >size
	 * @param index - the index
	 * @return E- the element returned
	 */
	E get(int index);
	
	/**
	 * finds the index of the specified object
	 * @param o - specified object
	 * @return int- the index
	 */
	int indexOf(Object o);
	
	/**
	 * Checks to see if the list is empty or not
	 * @param - none
	 * @return true if empty
	 */
	boolean isEmpty();
	/**
	 * removes the node from the specified index and returns it's value
	 * @param index- the index
	 * @return E- the value of the removed node
	 */
	E remove(int index);
	
	/**
	 * removes the first occurrence of the specified object from the list
	 * @param o - element to signify removal
	 * @return E- value of node
	 */
	E remove(Object o);
	
	/**
	 * sets the element at the specified index to be the specified element
	 * @param index - the index
	 * @param e - the value to be replaced
	 * @return E- the previous value at the node
	 */
	E set(int index, E e);
	
	/**
	 * returns size of the list
	 * @param - none
	 * @return int- size of list
	 */
	int size();
	
}