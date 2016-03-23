import java.util.Collection;


/**
 * CS 1332 Fall 2013
 * AVL Tree
 * 
 * In this class, you will program an AVL Tree (Adelson Veskii-Landis Tree).
 * This is like a better version of a binary search tree in that it 
 * tries to fill out every level of the tree as much as possible. It
 * accomplishes this by keeping track of each node's height and balance
 * factor. As you recurse back up from operations that modify the tree
 * (like add or remove), you will update the height and balance factor
 * of the current node, and perform a rotation on the current node if 
 * necessary. Keeping this in mind, let's get started!
 * 
 * **************************NOTE*************************************
 * please please please  treat null as positive infinity!!!!!!!!
 * PLEASE TREAT NULL AS POSITIVE INFINITY!!!!
 * *************************NOTE**************************************
 * 
 * I STRONLY RECOMMEND THAT YOU IMPLEMENT THIS DATA STRUCTURE RECURSIVELY!
 * 
 * Please make any new internal classes, instance data, and methods private!!
 * 
 * DO NOT CHANGE ANY OF THE PUBLIC METHOD HEADERS
 */
public class AVL<T extends Comparable<T>> {
	
	private AVLNode<T> root;
	private int size;
	

	
	public void setSize(int newSize) {
		size = newSize;
	}
	public void setRoot(AVLNode<T> newRoot) {
		root = newRoot;
	}
	public AVLNode<T> getRoot() {
		return root;
	}
	
	
	/**
	 * I promise you, this is just like the add() method you coded
	 * in the BST part of the homework! You will start off at the
	 * root and find the proper place to add the data. As you 
	 * recurse back up the tree, you will have to update the
	 * heights and balance factors of each node that you visited
	 * while reaching the proper place to add your data. Immediately
	 * before you return out of each recursive step, you should update
	 * the height and balance factor of the current node and then
	 * call rotate on the current node. You will then return the node
	 * that comes from the rotate(). This way, the re-balanced subtrees
	 * will properly be added back to the whole tree. Also, don't forget
	 * to update the size of the tree as a whole.
	 * 
	 * PLEASE TREAT NULL AS POSITIVE INFINITY!!!!
	 * 
	 * @param data The data do be added to the tree.
	 */
	public void add(T data) {
		if(isEmpty()){ 
			root = new AVLNode<T>(data);
			root = rotate(root);
		}
		else{
			addEntry(root,data);
			root = rotate(root);
		}
		
	}
	
	private void addEntry(AVLNode<T> node, T data){
		if(compare(node.getData(),data) == 1){
			if(node.getLeft() != null) {
				addEntry(node.getLeft(),data);
				node.setLeft(rotate(node.getLeft()));
				updateHeightAndBF(node);
			}
			else{
				node.setLeft(new AVLNode<T>(data));
				size++;	
			}
		}
		else if( compare(node.getData(),data) == -1){
			if(node.getRight() != null){
				addEntry(node.getRight(), data);
				node.setRight(rotate(node.getRight()));
				updateHeightAndBF(node);
			}
			else{
				node.setRight(new AVLNode<T>(data));
				size++;
			}
		}
		else{
			node.setData(data);
			size++;
		}
	}
	
	
	/**
	 * This is a pretty simple method. All you need to do is to get
	 * every element in the collection that is passed in into the tree.
	 * 
	 * Try to think about how you can combine a for-each loop and your
	 * add method to accomplish this.
	 * 
	 * @param c A collection of elements to be added to the tree.
	 */
	public void addAll(Collection<? extends T> c){
		for ( T element:c ){
			this.add(element);
			}
	}
	
	/**
	 * All right, now for the remove method. Just like in the vanilla BST, you
	 * will have to traverse to find the data the user is trying to remove. 
	 * 
	 * You will have three cases:
	 * 
	 * 1. Node to remove has zero children.
	 * 2. Node to remove has one child.
	 * 3. Node to remove has two children.
	 * 
	 * For the first case, you simply return null up the tree. For the second case,
	 * you return the non-null child up the tree. 
	 * 
	 * Just as in add, you'll have to updateHeightAndBF() as well as rotate() just before
	 * you return out of each recursive step.
	 * 
	 * FOR THE THIRD CASE USE THE PREDECESSOR OR YOU WILL LOSE POINTS
	 * 
	 * @param data The data to search in the tree.
	 * @return The data that was removed from the tree.
	 */
	public T remove(T data){
		if(isEmpty() || data.equals(null) || !contains(data)) return null;
		else{
			T dataRem = this.get(data);
			root = removeRecurse(root,data);
			root = rotate(root);
			return dataRem;
		}
	}
	
	private AVLNode<T> removeRecurse(AVLNode<T> node, T data){
		int comp = compare(data,node.getData());
		if(comp == -1){
			node.setLeft(removeRecurse(node.getLeft(),data));
			node.setLeft(rotate(node.getLeft()));
			return node;
		}
		else if(comp == 1){
			node.setRight(removeRecurse(node.getRight(),data));
			node.setRight(rotate(node.getRight()));
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
				AVLNode<T> succ = findSuccessor(node);
				node.setData(remove(succ.getData()));
				return node;
			}
		}
		
	}
	
	
	
	private AVLNode<T> findSuccessor(AVLNode<T> root){
		AVLNode<T> succ = root;
		succ = succ.getLeft();
		while(succ.getRight() != null){
			succ = succ.getRight();
		}
		return succ;
	}

	/**
	 * This method should be pretty simple, all you have to do is recurse
	 * to the left or to the right and see if the tree contains the data.
	 * 
	 * @param data The data to search for in the tree.
	 * @return The boolean flag that indicates if the data was found in the tree or not.
	 */
	public boolean contains(T data) {
		if(isEmpty()){
			return false;
		}
		
		AVLNode<T> cursor = root;
		
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
	 * Again, simply recurse through the tree and find the data that is passed in.
	 * 
	 * @param data The data to fetch from the tree.
	 * @return The data that the user wants from the tree. Return null if not found.
	 */
	public T get(T data) {
		AVLNode<T> current = root;
		while(current != null){
			int comp = compare(current.getData(),data);
			if (comp == 1) current = current.getLeft();
			else if(comp == -1) current = current.getRight();
			else return current.getData();
		}
		return null;
	}
	
	
	/**
	 * Test to see if the tree is empty.
	 * 
	 * @return A boolean flag that is true if the tree is empty.
	 */
	public boolean isEmpty(){
		if(root == null) return true;
		return false;
	}
	
	/**
	 * Return the number of data in the tree.
	 * 
	 * @return The number of data in the tree.
	 */
	public int size() {
		return size;
	}
	
	/**
	 * Reset the tree to its original state. Get rid of every element in the tree.
	 */
	public void clear() {
		root = null;
		size = 0;
	}
	
	// The below methods are all private, so we will not be directly grading them,
	// however we strongly recommend you not change them, and make use of them.
	
	
	/**
	 * Use this method to update the height and balance factor for a node.
	 * 
	 * @param node The node whose height and balance factor need to be updated.
	 */
	private void updateHeightAndBF(AVLNode<T> node) {
		int leftHeight = -1;
		int rightHeight = -1;
		
		if(node.getLeft() != null){
			leftHeight = node.getLeft().getHeight();
		}
		if(node.getRight() != null){
			rightHeight = node.getRight().getHeight();
		}
	
		if( leftHeight > rightHeight) node.setHeight(leftHeight+1);
		else node.setHeight(rightHeight+1);
		
		node.setBF(leftHeight-rightHeight);
		
		
	}
	
	/**
	 * In this method, you will check the balance factor of the node that is passed in and
	 * decide whether or not to perform a rotation. If you need to perform a rotation, simply
	 * call the rotation and return the new root of the balanced subtree. If there is no need
	 * for a rotation, simply return the node that was passed in.
	 * 
	 * @param node - a potentially unbalanced node
	 * @return The new root of the balanced subtree.
	 */
	private AVLNode<T> rotate(AVLNode<T> node) {
		if(node == null) return node;
		updateHeightAndBF(node);
		
		//bf > 1, left heavy, bf < -1, right heavy
		int bf = node.getBf();
		if(bf == 1 || bf == -1 || bf == 0) return node;
		
		else{
			if(bf > 1){
				if(node.getLeft().getBf() > 0){
					node = rightRotate(node);
				}
				else{
					node = leftRightRotate(node);
				}
			}
			else{
				if(node.getRight().getBf() < 0){
					node = leftRotate(node);
				}
				else{
					node = rightLeftRotate(node);
				}
			}
		}
		
		return node;
	}
	
	/**
	 * In this method, you will perform a left rotation. Remember, you perform a 
	 * LEFT rotation when the sub-tree is RIGHT heavy. This moves more nodes over to
	 * the LEFT side of the node that is passed in so that the height differences
	 * between the LEFT and RIGHT subtrees differ by at most one.
	 * 
	 * HINT: DO NOT FORGET TO RE-CALCULATE THE HEIGHT OF THE NODES
	 * WHOSE CHILDREN HAVE CHANGED! YES, THIS DOES MAKE A DIFFERENCE!
	 * 
	 * @param node - the current root of the subtree to rotate.
	 * @return The new root of the subtree
	 */
	private AVLNode<T> leftRotate(AVLNode<T> node) {
		AVLNode<T> newRoot = node.getRight();
		node.setRight(newRoot.getLeft());
		newRoot.setLeft(node);
		updateHeightAndBF(node);
		updateHeightAndBF(newRoot);
		return newRoot;
	}
	
	/**
	 * In this method, you will perform a right rotation. Remember, you perform a
	 * RIGHT rotation when the sub-tree is LEFT heavy. THis moves more nodes over to
	 * the RIGHT side of the node that is passed in so that the height differences
	 * between the LEFT and RIGHT subtrees differ by at most one.
	 * 
	 * HINT: DO NOT FORGET TO RE-CALCULATE THE HEIGHT OF THE NODES
	 * WHOSE CHILDREN HAVE CHANGED! YES, THIS DOES MAKE A DIFFERENCE!
	 * 
	 * @param node - The current root of the subtree to rotate.
	 * @return The new root of the rotated subtree.
	 */
	private AVLNode<T> rightRotate(AVLNode<T> node) {
		AVLNode<T> newRoot = node.getLeft();
		node.setLeft(newRoot.getRight());
		newRoot.setRight(node);
		updateHeightAndBF(node);
		updateHeightAndBF(newRoot);
		return newRoot;
	}
	
	/**
	 * In this method, you will perform a left-right rotation. You can simply use
	 * the left and right rotation methods on the node and the node's child. Remember
	 * that you must perform the rotation on the node's child first, otherwise you will
	 * end up with a mangled tree (sad face). After rotating the child, remember to link up
	 * the new root of the that first rotation with the node that was passed in.
	 * 
	 * The whole point of heterogeneous rotations is to transform the node's 
	 * subtree into one of the cases handled by the left and right rotations.
	 * 
	 * @param node
	 * @return The new root of the subtree.
	 */
	private AVLNode<T> leftRightRotate(AVLNode<T> node) {
		node.setLeft(leftRotate(node.getLeft()));
		return rightRotate(node);
	}
	
	/**
	 * In this method, you will perform a right-left rotation. You can simply use your
	 * right and left rotation methods on the node and the node's child. Remember
	 * that you must perform the rotation on the node's child first, otherwise
	 * you will end up with a mangled tree (super sad face). After rotating the node's child,
	 * remember to link up the new root of that first rotation with the node that was
	 * passed in.
	 * 
	 * Again, the whole point of the heterogeneous rotations is to first transform the
	 * node's subtree into one of the cases handled by the left and right rotations.
	 * 
	 * @param node
	 * @return The new root of the subtree.
	 */
	private AVLNode<T> rightLeftRotate(AVLNode<T> node) {
		node.setRight(rightRotate(node.getRight()));
		return leftRotate(node);
	}
	
	private int compare(T a, T b) {
	    if(a == null && b == null) return 0;
	    else if (a == null) return 1;
	    else if (b == null) return -1;
	    else return a.compareTo(b);
	}
	

}