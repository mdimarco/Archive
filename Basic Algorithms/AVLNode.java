

/**
 * Don't modify this class
 */
public class AVLNode<T> {

	private T data;
	private AVLNode<T> left;
	private AVLNode<T> right;
	private int height;
	private int bf;
	
	public AVLNode(T data) {
		this.data = data;
	}
	
	public T getData() {
		return data;
	}
	
	public AVLNode<T> getLeft() {
		return left;
	}
	
	public AVLNode<T> getRight() {
		return right;
	}
	
	public int getHeight() {
		return height;
	}
	
	public int getBf() {
		return bf;
	}
	
	public void setData(T data) {
		this.data = data;
	}
	
	public void setLeft(AVLNode<T> node) {
		left = node;
	}
	
	public void setRight(AVLNode<T> node) {
		right = node;
	}
	
	public void setHeight(int height) {
		this.height = height;
	}
	
	public void setBF(int bf) {
		this.bf = bf;
	}
}