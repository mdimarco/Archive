

import java.util.Collection;
import java.util.List;
import java.util.ArrayList;
/**
 * CS 1332 Fall 2013
 * Binary Search Tree
 * 
 * In this assignment, you will be coding methods to make a functional
 * binary search tree. If you do this right, you will save a lot of time
 * in the next two assignments (since they are just augmenting the BST to 
 * make it efficient). Let's get started!
 * 
 * **************************NOTE************************
 * YOU WILL HAVE TO HANDLE NULL DATA IN THIS ASSIGNMENT!!
 * PLEASE TREAT NULL AS POSITIVE INFINITY!!!!
 * **************************NOTE************************
 * 
 * DO NOT CHANGE ANY OF THE PUBLIC METHOD HEADERS
 * 
 * Please make any extra inner classes, instance fields, and methods private
 */



public class BST<T extends Comparable<T>> {
	

	private Node<T> root;
	private int size;
	
	
	
	public void setSize(int newSize) {
		size = newSize;
	}
	public void setRoot(Node<T> newRoot) {
		root = newRoot;
	}
	public Node<T> getRoot() {
		return root;
	}
	
	/**
	 * Add data to the binary search tree. Remember to adhere to the BST Invariant:
	 * All data to the left of a node must be smaller and all data to the right of
	 * a node must be larger. Don't forget to update the size. 
	 * 
	 * For this method, you will need to traverse the tree and find the appropriate
	 * location of the data. Depending on the data's value, you will either explore
	 * the right subtree or the left subtree. When you reach a dead end (you have 
	 * reached a null value), simply return a new node with the data that was passed
	 * in.
	 * 
	 * PLEASE TREAT NULL DATA AS POSITIVE INFINITY!!!!
	 * 
	 * @param data A comparable object to be added to the tree.
	 */
	public Node<T> add(T data) {
		if(root == null){
			Node<T> newNode = new Node<T>(data);
			root = newNode;
			size++;
			return newNode;
		}
		else return addRecurse(root,data);
	
	}
	
	
	public Node<T> addRecurse(Node<T> node, T data){
		if( compare(data,node.getData()) == 1) {
			if(node.getRight() == null){
				Node<T> newNode = new Node<T>(data);
				node.setRight(newNode);
				size++;
				return newNode;
			}
			else addRecurse(node.getRight(), data);
		}
		
		else if( compare(data,node.getData()) == -1){
			if(node.getLeft() == null){
				Node<T> newNode = new Node<T>(data);
				node.setLeft(newNode);
				size++;
				return newNode;
			}
			else addRecurse(node.getLeft(), data);
		}
		
		Node<T> newNode = new Node<T>(data);
		return newNode;
		
		}
	
	/**
	 * Add the contents of the collection to the BST. To do this method, notice that
	 * most every collection in the java collections API implements the iterable 
	 * interface. This means that you can iterate through every element in these 
	 * structures with a for-each loop. Don't forget to update the size.
	 * 
	 * @param collection A collection of data to be added to the tree.
	 */
	public void addAll(Collection<? extends T> c) {
		for ( T element:c ){
			this.add(element);
			}
	}
	
	
	
	/**
	 * Remove the data element from the tree. 
	 * 
	 * There are three cases you have to deal with:
	 * 1. The node to remove has no children
	 * 2. The node to remove has one child
	 * 2. The node to remove has two children
	 * 
	 * In the first case, return null. In the second case, return the non-null 
	 * child. The third case is where things get interesting. Here, you have two 
	 * you will have to find the successor or predecessor and then copy their data 
	 * into the node you want to remove. You will also have to fix the successor's
	 * or predecessor's children if necessary. Don't forget to update the size.
	 *  
	 * PLEASE TREAT NULL DATA AS POSITIVE INFINITY!
	 *  
	 * @param data The data element to be searched for.
	 * @return retData The data that was removed from the tree. Return null if the
	 * data doesn't exist.
	 */
	
	private Node<T> findSuccessor(Node<T> root){
		Node<T> succ = root;
		succ = succ.getLeft();
		while(succ.getRight() != null){
			succ = succ.getRight();
		}
		return succ;
	}
	
	public T remove(T data){
		if(isEmpty() || data.equals(null) || !contains(data)) return null;
		else{
			T dataRem = this.get(data);
			root = removeRecurse(root,data);
			return dataRem;
		}
	}
	
	private Node<T> removeRecurse(Node<T> node, T data){
		int comp = compare(data,node.getData());
		if(comp == -1){
			node.setLeft(removeRecurse(node.getLeft(),data));
			return node;
		}
		else if(comp == 1){
			node.setRight(removeRecurse(node.getRight(),data));
			return node;
		}
		else{
			if(node.getLeft() == null && node.getRight() == null){
				size--;
				return null;
			}
			if(node.getLeft() == null){
				size--;
				return node.getRight();
			}
			if(node.getRight() ==  null){
				size--;
				return node.getLeft();
			}
			else{
				Node<T> succ = findSuccessor(node);
				node.setData(remove(succ.getData()));
				return node;
			}
		}
		
	}
	
	
	
	
	
	
	/**
	 * Get the data from the tree.
	 * 
	 * This method simply returns the data that was stored in the tree.
	 * 
	 * TREAT NULL DATA AS POSITIVE INFINITY!
	 * 
	 * @param data The datum to search for in the tree.
	 * @return The data that was found in the tree. Return null if the data doesn't
	 * exist.
	 */
	public T get(T data) {
		Node<T> current = root;
		while(current != null){
			int comp = compare(current.getData(),data);
			if (comp == 1) current = current.getLeft();
			else if(comp == -1) current = current.getRight();
			else return current.getData();
		}
		return null;
	}
	
	/**
	 * See if the tree contains the data.
	 * 
	 * TREAT NULL DATA AS POSITIVE INFINITY!
	 * 
	 * @param data The data to search for in the tree.
	 * @return Return true if the data is in the tree, false otherwise.
	 */
	public boolean contains(T data) {
		if(isEmpty()){
			return false;
		}
		
		Node<T> cursor = root;
		
		if( compare(cursor.getData(), data) == 0){
			return true;
		}
		
		while(cursor != null){
			if(compare(cursor.getData(), data) == 0){
				return true;
			}
			else if(compare(cursor.getData(),data) == 1){
				cursor = cursor.getLeft();
			}
			else{
				cursor = cursor.getRight();
			}
		}
		
		return false;
	}
	
	/**
	 * Linearize the tree using the pre-order traversal.
	 * 
	 * @return A list that contains every element in pre-order.
	 */
	
	private ArrayList<T> preOrder(ArrayList<T> pred,Node<T> root){
		if (root == null) return null;
		pred.add(root.getData());
		preOrder(pred, root.getLeft());
		preOrder(pred, root.getRight());
		return pred;
	}
	
	public List<T> preOrder() {
		ArrayList<T> pred = new ArrayList<T>();
		pred = preOrder(pred, root);
		return pred;
	}
	
	
	/**
	 * Linearize the tree using the in-order traversal.
	 * 
	 * @return A list that contains every element in-order.
	 */
	private ArrayList<T> inOrder(ArrayList<T> inOrd,Node<T> root){
		if (root == null) return null;
		inOrder(inOrd, root.getLeft());
		inOrd.add(root.getData());
		inOrder(inOrd, root.getRight());
		return inOrd;
	}
	
	public List<T> inOrder() {
		ArrayList<T> inOrd = new ArrayList<T>();
		inOrd = inOrder(inOrd, root);
		return inOrd;
	}
	
	/**
	 * Linearize the tree using the post-order traversal.
	 * 
	 * @return A list that contains every element in post-order.
	 */
	private ArrayList<T> postOrder(ArrayList<T> postOrd,Node<T> root){
		if (root == null) return null;
		postOrder(postOrd, root.getLeft());
		postOrder(postOrd, root.getRight());
		postOrd.add(root.getData());
		return postOrd;
	}
	
	public List<T> postOrder() {
		ArrayList<T> postOrd = new ArrayList<T>();
		postOrd = postOrder(postOrd, root);
		return postOrd;
	}
	
	/**
	 * Test to see if the tree is empty.
	 * 
	 * @return Return true if the tree is empty, false otherwise.
	 */
	public boolean isEmpty() {
		if(root == null) return true;
		return false;
	}
	
	/**
	 * 
	 * @return Return the number of elements in the tree.
	 */
	public int size() {
		return size;
	}
	
	/**
	 * Clear the tree. (ie. set root to null and size to 0)
	 */
	public void clear() {
			root = null;
			size = 0;
	}
	
	/**
	 * Clear the existing tree, and rebuilds a unique binary search tree 
	 * with the pre-order and post-order traversals that are passed in.
	 * Draw a tree out on paper and generate the appropriate traversals.
	 * See if you can manipulate these lists to generate the same tree.
	 * 
	 * TL;DR - at the end of this method, the tree better have the same
	 * pre-order and post-order as what was passed in.
	 * 
	 * @param preOrder A list containing the data in a pre-order linearization.
	 * @param postOrder A list containing the data in a post-order linearization.
	 */
	public void reconstruct(List<? extends T> preOrder, List<? extends T> postOrder) {
		this.clear();
		for(int i = 0; i<preOrder.size();i++){
			this.add(preOrder.get(i));
			}
		
			
	}
	
	/**
	 * compareTo helper method
	 * @param a - val 1 to be compared
	 * @param b - val 2 to be compared
	 * @return - compare val
	 */
	private int compare(T a, T b) {
	    if(a == null && b == null) return 0;
	    else if (a == null) return 1;
	    else if (b == null) return -1;
	    else return a.compareTo(b);
	}
	
}





