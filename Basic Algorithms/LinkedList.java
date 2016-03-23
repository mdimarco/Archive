import java.util.Collection;

/**
 * @author-Mason DiMarco
 * mdimarco3 902911178
 * 
 * This is a circular, singly linked list.
 */
public class LinkedList<E> implements List<E> {

	protected Node<E> head;
	protected int size;

	@Override
	/*
	 * (non-Javadoc)
	 * @see List#add(java.lang.Object)
	 */
	public void add(E e) {
		
		if (this.isEmpty()){
			//Initialize head
			head = new Node<E>(e);
			this.head.setNext(head);
			this.size = 1;
			}
		else{
			Node<E> newNode = new Node<E>(e);
			
			Node<E> current = head;
			for(int i = 0; i < size; i++){
				if (current.getNext() != head){
					current = current.getNext();
				}
				else{
					current.setNext(newNode);
					newNode.setNext(head);
					newNode.setData(e);
					size++;
					//Done
					return;
				}
			}
			
		}
		
		// TODO Auto-generated method stub
	}

	/*
	 * You will want to look at Iterator, Iterable, and 
	 * how to use a for-each loop for this method.
	 */
	@Override
	public void addAll(Collection<? extends E> c) {
		for ( E element:c ){
			this.add(element);
		}
		
		// TODO Auto-generated method stub
	}

	@Override
	public void clear() {
		if(isEmpty()){
			return;
		}
		else{
			while(!isEmpty()){
				remove(0);
			}
		}
		// TODO Auto-generated method stub
	}

	@Override
	public boolean contains(Object o) {
		
		Node<E> current = head;
		for(int i = 0; i<this.size();i++){
			if (current.getData().equals(o)){
				return true;
			}
			current=current.getNext();

		}
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public E get(int index) {
		if (index >= this.size() || index<0){
			throw new IndexOutOfBoundsException();
		}
		// TODO Auto-generated method stub
		Node<E> current = head;
		for(int i = 0; i<index; i++){
			current = current.getNext();
		}
		
		return current.getData();
	}

	@Override
	public int indexOf(Object o) {
		if (this.contains(o)){
			Node<E> current = head;
			for(int i = 0; i<this.size();i++){
				if(current.getData().equals(o)){
					return i;
				}
				current=current.getNext();
			}
			current.setNext(null);
			return -1;
			}
		else{
		return -1;
		}
	}

	@Override
	public boolean isEmpty() {
		if (head==null){
			return true;}
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public E remove(int index) {
		if(!isEmpty()){
			if(index >= this.size() || index<0){
				throw new IndexOutOfBoundsException();
			}
					
			Node<E> current = head;
			//If trying to remove head, make index the last index+1
			
			for(int i = 0; i<this.size();i++){
				if(index == i+1){
					Node<E> temp = current.getNext();
					current.setNext(temp.getNext());
					temp.setNext(null);
					size--;
					return temp.getData();
				}
				
				if(i == this.size()-1){//must be head node to remove
					Node<E> temp = current.getNext();
					current.setNext(temp.getNext());
					temp.setNext(null);
					head = current.getNext();
					size--;
					return temp.getData();
				}
				
				current = current.getNext();
			}
		}
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public E remove(Object o) {
		if (this.contains(o)){
			int ind = this.indexOf(o);
			return this.remove(ind);
			}
		else{
			return null;
		}
		
		
	}

	@Override
	public E set(int index, E e) {
		if(index >= size() || index<0){
			throw new IndexOutOfBoundsException();
		}
		
		Node<E> current = head;
		for(int i = 0; i<this.size();i++){
			if(index == i){
				E temp = current.getData();
				current.setData(e);
				return temp;
			}
			current = current.getNext();
		}
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int size() {
		// TODO Auto-generated method stub
		return this.size;
	}

	/*
	 * The following methods are for grading. Do not modify them, and do not use them.
	 */

	public void setSize(int size) {
		this.size = size;
	}

	public Node<E> getHead() {
		return head;
	}

	public void setHead(Node<E> head) {
		this.head = head;
	}
}