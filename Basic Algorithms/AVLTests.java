import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.junit.Test;

public class AVLTests {
	
/** TO USE: ADD THIS TO AVL.JAVA CLASS
 * 
 * 	public void setSize(int newSize) {
		size = newSize;
	}
	public void setRoot(AVLNode<T> newRoot) {
		root = newRoot;
	}
	public AVLNode<T> getRoot() {
		return root;
	}
 * 
 */

	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testLeft() {
		AVL<Thing> avl = avl(1, 2, 3);
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testLeftWithSubtrees() {
		AVL<Thing> avl = avl(2, 1, 4, 3, 5, 6);
		List<Thing> list = list(4, 2, 1, 3, 5, 6);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}

	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRight() {
		AVL<Thing> avl = avl(3, 2, 1);
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRightWithSubtrees() {
		AVL<Thing> avl = avl(6, 4, 7, 2, 5, 3);
		List<Thing> list = list(4, 2, 3, 6, 5, 7);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRightLeft() {
		AVL<Thing> avl = avl(1, 3, 2);
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRightLeftWithSubtrees() {
		AVL<Thing> avl = avl(2, 1, 5, 3, 6, 4);
		List<Thing> list = list(3, 2, 1, 5, 4, 6);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testLeftRight() {
		AVL<Thing> avl = avl(3, 1, 2);
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testLeftRightWithSubtrees() {
		AVL<Thing> avl = avl(6, 2, 7, 1, 4, 5);
		List<Thing> list = list(4, 2, 1, 6, 5, 7);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testAddAllLeft() {
		AVL<Thing> avl = new AVL<>();
		avl.addAll(list(1, 2, 3));
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testAddAllRight() {
		AVL<Thing> avl = new AVL<>();
		avl.addAll(list(3, 2, 1));
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRemoveLeft() {
		AVL<Thing> avl = avl(2, 1, 3, 4);
		assertEquals(thing(1), avl.remove(thing(1)));
		List<Thing> list = list(3, 2, 4);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRemoveRight() {
		AVL<Thing> avl = avl(3, 2, 4, 1);
		assertEquals(thing(4), avl.remove(thing(4)));
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRemoveRightLeft() {
		AVL<Thing> avl = avl(2, 1, 4, 3);
		assertEquals(thing(1), avl.remove(thing(1)));
		List<Thing> list = list(3, 2, 4);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testRemoveLeftRight() {
		AVL<Thing> avl = avl(3, 1, 4, 2);
		assertEquals(thing(4), avl.remove(thing(4)));
		List<Thing> list = list(2, 1, 3);
		assertEquals(list, preorder(avl));
		Collections.sort(list);
		assertEquals(list, inorder(avl));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testContains() {
		assertTrue(t1().contains(thing(0)));
		assertFalse(t1().contains(thing(-1)));
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testIsEmpty() {
		assertTrue(new AVL<>().isEmpty());
		assertFalse(t1().isEmpty());
	}

	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testClear() {
		AVL<Thing> avl = t1();
		assertEquals(4, avl.size());
		avl.clear();
		assertEquals(0, avl.size());
		assertTrue(avl.isEmpty());
	}

	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testSize() {
		assertEquals(4, t1().size());
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testSizeAdd() {
		AVL<Thing> avl = t1();
		avl.add(thing(-1));
		assertEquals(5, avl.size());
	}
	
	@Test(timeout = 300)
	//@Worth(points = 5)
	public void testSizeRemove() {
		AVL<Thing> avl = t1();
		avl.remove(thing(3));
		assertEquals(3, avl.size());
	}

	/*
	 * Some trees to test with
	 */
	private AVL<Thing> t1() {
		AVLNode<Thing> n0 = node(0);
		n0.setBF(0);
		n0.setHeight(0);
		
		AVLNode<Thing> n1 = node(1);
		n1.setBF(-1);
		n1.setHeight(2);

		AVLNode<Thing> n2 = node(2);
		n1.setBF(-1);
		n1.setHeight(1);

		AVLNode<Thing> n3 = node(3);
		n1.setBF(0);
		n1.setHeight(0);

		n1.setLeft(n0);
		n1.setRight(n2);
		n2.setRight(n3);
		
		AVL<Thing> avl = new AVL<>();
		avl.setRoot(n1);
		avl.setSize(4);
		return avl;
	}
	
	/*
	 * Methods for testing
	 */
	private AVL<Thing> avl(int...ints) {
		AVL<Thing> avl = new AVL<>();
		for (int i : ints) {
			avl.add(thing(i));
		}
		return avl;
	}
	
	private List<Thing> list(int...ints) {
		List<Thing> list = new ArrayList<>();
		for (int i : ints) {
			list.add(thing(i));
		}
		return list;
	}
	
	private List<Thing> preorder(AVL<Thing> avl) {
		List<Thing> l = new ArrayList<>();
		preorder(avl.getRoot(), l);
		return l;
	}
	
	private void preorder(AVLNode<Thing> n, List<Thing> l) {
		if (n != null) {
			l.add(n.getData());
			preorder(n.getLeft(), l);
			preorder(n.getRight(), l);
		}
	}
	
	private List<Thing> inorder(AVL<Thing> avl) {
		List<Thing> l = new ArrayList<>();
		inorder(avl.getRoot(), l);
		return l;
	}
	
	private void inorder(AVLNode<Thing> n, List<Thing> l) {
		if (n != null) {
			inorder(n.getLeft(), l);
			l.add(n.getData());
			inorder(n.getRight(), l);
		}
	}
	
	/**
	 * Returns a node with a thing representing the given integer
	 */
	private AVLNode<Thing> node(int i) {
		return new AVLNode<AVLTests.Thing>(thing(i));
	}
	
	/**
	 * Returns a thing representing the given integer
	 */
	private Thing thing(int i) {
		return new Thing(i);
	}
	
	/**
	 * A comparable class used for testing, gives each object
	 * created a unique identifier, that is not factored into
	 * equals or compareTo. Useful for testing purposes.
	 */
	public static class Thing implements Comparable<Thing> {
		private static int counter = 0;
		
		final int id = counter++;
		int i;
		
		public Thing(int i) {
			this.i = i;
		}
		
		@Override
		public int compareTo(Thing tht) {
			return Integer.compare(i, tht.i);
		}
		
		@Override
		public boolean equals(Object obj) {
			if (obj instanceof Thing) {
				return ((Thing) obj).i == i;
			}
			return false;
		}
		
		@Override
		public int hashCode() {
			return i;
		}
		
		@Override
		public String toString() {
			return i + " (" + id + ")";
		}
	}
}