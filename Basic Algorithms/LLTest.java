import static org.junit.Assert.*;

import java.util.Collection;
import java.util.Collections;

import org.junit.Test;


public class LLTest {
	private static final int TIMEOUT = 200;
	private static final double DELTA = 1e-6;
	
	@Test(timeout = TIMEOUT)
	public void constructor1() {
		LinkedList test1 = new LinkedList();
		assertEquals(test1.head, null);
		assertEquals(test1.size(), 0);
	}
	
	
	
	@Test(timeout = TIMEOUT)
	public void emptTest(){
		LinkedList emptTest = new LinkedList();
		assertEquals(emptTest.isEmpty(),true);
	}
	
	@Test(timeout = TIMEOUT)
	public void addTest(){
		LinkedList testAdd = new LinkedList();
		int a = 5;
		int b = 6;
		int c = 3;
		testAdd.add(a);
		assertEquals(5,testAdd.head.getData());
		
		testAdd.add(b);
		testAdd.add(c);
		assertEquals(testAdd.size(),3);
	}
	
	@Test(timeout = TIMEOUT)
	public void containTest(){
		LinkedList a1 = new LinkedList();
		String abc = "AB!@#";
		int arg = 5;
		boolean what = false;
		a1.add(arg);
		a1.add(abc);
		a1.add(what);
		assertEquals(true,a1.contains(5));
	}
	
	@Test(timeout=TIMEOUT)
	public void getTest1(){
		LinkedList a1 = new LinkedList();
		String abc = "AB!@#";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		assertEquals("AB!@#",a1.get(0));
		assertEquals(5,a1.get(1));
		assertEquals(false,a1.get(2));
	}
	
	@Test(timeout=TIMEOUT, expected = IndexOutOfBoundsException.class)
	public void getTest2(){
		LinkedList a1 = new LinkedList();
		String abc = "AB!@#";
		int arg = 5;
		boolean what = false;
		a1.add(arg);
		a1.add(abc);
		a1.add(what);
		a1.get(4);
	}
	
	@Test(timeout=TIMEOUT)
	public void indexOfTest(){
		LinkedList a1 = new LinkedList();
		String abc = "cow";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		
		assertEquals(0,a1.indexOf(abc));
		assertEquals(1,a1.indexOf(arg));
		assertEquals(2,a1.indexOf(what));
		assertEquals(-1,a1.indexOf("murica"));
		
	}
	
	//Not done!
	@Test(timeout=TIMEOUT)
	public void removeTest(){
		LinkedList a1 = new LinkedList();
		
		String abc = "cow";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		
		a1.remove(0);
		assertEquals(5,a1.get(0));
		a1.remove(0);
		assertEquals(false,a1.get(0));
		a1.remove(0);
		assertEquals(0,a1.size);
		
		
	}
	@Test(timeout=TIMEOUT, expected=IndexOutOfBoundsException.class)
	public void removeTest2(){
		LinkedList a1 = new LinkedList();
		
		String abc = "cow";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		
		a1.remove(-1);
	}
	
	
	
	
	@Test(timeout=TIMEOUT)
	public void setTest(){
		LinkedList a1 = new LinkedList();
		
		String abc = "cow";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		
		a1.set(1, "Hello");
		assertEquals("Hello",a1.get(1));
		a1.set(0, true);
		assertEquals(true,a1.get(0));
	}
	
	@Test(timeout=TIMEOUT)
	public void clearTest(){
		LinkedList a1 = new LinkedList();
		
		String abc = "cow";
		int arg = 5;
		boolean what = false;
		a1.add(abc);
		a1.add(arg);
		a1.add(what);
		
		a1.clear();
		assertEquals(true,a1.isEmpty());
		a1.clear();
	}
	

	// The following code is applicable to testing TwistList while swing is not being called after
	// the add function is executed
	
	@Test(timeout=TIMEOUT)
	public void addTestTwist(){
		TwistList a1 = new TwistList();
		a1.add(1);
		a1.add(2);
		a1.add(3);
		a1.add(2);
		assertEquals(4,a1.size);
		assertEquals(1,a1.get(0));
		assertEquals(2,a1.get(1));
		assertEquals(3,a1.get(2));
		assertEquals(2,a1.get(3));
	}
	
	@Test(timeout=TIMEOUT)
	public void revTest(){
		TwistList a1 = new TwistList();
		a1.add(1);
		a1.add(2);
		a1.add(3);
		a1.add(2);
		assertEquals(2,a1.get(3));
		a1.reverse(0, 3);
		assertEquals(1,a1.get(3));
		assertEquals(2,a1.get(0));
			
		
	}
	
	@Test(timeout=TIMEOUT)
	public void flipflopTest(){
		TwistList a1 = new TwistList();
		a1.add(1);
		a1.add(2);
		a1.add(3);
		a1.add(4);
		a1.flipFlop(1);
		assertEquals(4,a1.size());
		assertEquals(3,a1.get(0));
		assertEquals(4,a1.get(1));
		assertEquals(1,a1.get(2));
		assertEquals(2,a1.get(3));
		a1.flipFlop(2);
		assertEquals(2,a1.get(0));
		
		TwistList a2 = new TwistList();
		a2.add(1);
		a2.flipFlop(0);
		assertEquals(1,a2.get(0));
		
		a2.add(2);
		a2.flipFlop(1);
		assertEquals(1,a2.get(0));
		
		a2.flipFlop(0);
		assertEquals(2,a2.get(0));
		
	}
	
	
	@Test(timeout=TIMEOUT)
	public void swingTest(){
		TwistList a1 = new TwistList();
		a1.add(1);
		a1.add(2);
		a1.add(3);
		a1.add(4);
		a1.swing(0);
		assertEquals(1, a1.get(0));
		a1.swing(3);
		assertEquals(4, a1.get(3));
		a1.swing(1);
		assertEquals(2, a1.get(0));
		assertEquals(1, a1.get(1));
		assertEquals(4, a1.get(2));
		assertEquals(3, a1.get(3));
	}
	
	
	@SuppressWarnings("unused")
	public void test() {
		List<String> l1 = new LinkedList<>();
		l1.add("A");
		l1.addAll(Collections.<String>emptySet());
		l1.clear();
		boolean b = l1.contains(null);
		String s = l1.get(0);
		int i = l1.indexOf(null);
		b = l1.isEmpty();
		s = l1.remove(0);
		s = l1.remove(null);
		l1.set(0, null);
		i = l1.size();
		LinkedList<String> l2 = new LinkedList<>();
		l2.setSize(0);
		l2.setHead(new Node<String>("A"));
		Node<String> n = l2.getHead();
		TwistList<String> l3 = new TwistList<>();
		l3.reverse(0, 0);
		l3.flipFlop(0);
		l3.swing(0);
	}

}
 	