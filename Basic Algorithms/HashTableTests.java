import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.HashSet;

import org.junit.Test;


@SuppressWarnings("unchecked")
public class HashTableTests {
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testPut1() {
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.put(stuff(0),stuff(0));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)));
		assertArrayEquals(arr,ht.getTable());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testPut2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0))));
		ht.setSize(1);
		ht.put(stuff(11), stuff(11));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),entry(stuff(11)));
		assertArrayEquals(arr,ht.getTable());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testPut3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0))));
		ht.setSize(1);
		ht.put(stuff(22), stuff(22));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),entry(stuff(22)));
		assertArrayEquals(arr,ht.getTable());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testPut4(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),entry(stuff(1))));
		ht.setSize(2);
		ht.put(stuff(1), stuff(2));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),entry(stuff(1)));
		assertArrayEquals(arr,ht.getTable());
		arr[1].setNext(entry(stuff(1),stuff(2)));
		MapEntry<Stuff,Stuff>[] table = ht.getTable();
		assertEquals(table[1].getNext(),arr[1].getNext());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testPut5(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0),stuff(0),true),entry(stuff(1))));
		ht.setSize(1);
		ht.put(stuff(1),stuff(2));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),entry(stuff(1)));
		assertArrayEquals(arr,ht.getTable());
		arr[1].setNext(entry(stuff(1),stuff(2)));
		MapEntry<Stuff,Stuff>[] table = ht.getTable();
		assertEquals(table[1].getNext(),arr[1].getNext());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testPut6(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0),stuff(0),true),entry(stuff(1))));
		ht.setSize(1);
		ht.put(stuff(0),stuff(1));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0),stuff(1)),entry(stuff(1)));
		assertArrayEquals(arr,ht.getTable());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testPut7(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.put(stuff(Integer.MIN_VALUE), stuff(0xDEADBEEF));
		assertTrue(ht.contains(stuff(Integer.MAX_VALUE)));;
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testRemove1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(1))));
		ht.setSize(1);
		ht.remove(stuff(1));
		MapEntry<Stuff,Stuff>[] arr = array(11,null,entry(stuff(1),stuff(1),true));
		assertArrayEquals(ht.getTable(),arr);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testRemove2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(1),stuff(2))));
		ht.setSize(1);
		assertEquals(stuff(2),ht.remove(stuff(1)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testRemove3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,null,entry(stuff(1),stuff(2)));
		arr[1].setNext(entry(stuff(1)));
		arr[1].getNext().setNext(entry(stuff(5)));
		ht.setTable(arr);
		ht.setSize(3);
		assertEquals(ht.remove(stuff(1)),stuff(5));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testRemove4(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,null,entry(stuff(1),stuff(2)));
		ht.setTable(arr);
		ht.setSize(1);
		assertNull(ht.remove(stuff(4)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testResize1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		int initSize = ht.getTable().length;
		ht.setSize(initSize-2);
		ht.put(stuff(1),stuff(1));
		int newSize = ht.getTable().length;
		assertEquals(newSize,initSize*2+1);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testResize2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(5,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(3))));
		ht.setSize(3);
		ht.put(stuff(0),stuff(0));
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),null,entry(stuff(2)),entry(stuff(3)),null,null,entry(stuff(6)));
		assertArrayEquals(arr,ht.getTable());
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testResize3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(5,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(3))));
		ht.setSize(3);
		ht.put(stuff(0),stuff(0));
		assertEquals(ht.getTable().length,11);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testContains1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(3))));
		ht.setSize(3);
		assertTrue(ht.contains(stuff(2)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testContains2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(3))));
		ht.setSize(3);
		assertFalse(ht.contains(stuff(14)));
	}
	
	@Test
	//@Worth (points = 2)
	public void testContains3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(6)),entry(stuff(2),stuff(2),true),entry(stuff(3))));
		ht.setSize(2);
		assertFalse(ht.contains(stuff(2)));
	}
	
	@Test
	//@Worth (points = 2)
	public void testContains4(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(3))));
		ht.setSize(3);
		assertFalse(ht.contains(stuff(6)));
	}
	
	@Test
	//@Worth (points = 2)
	public void testContains5(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(13))));
		ht.setSize(3);
		assertTrue(ht.contains(stuff(13)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testClear1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(20,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(13))));
		ht.setSize(3);
		ht.clear();
		assertTrue(ht.size()==0);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 2)
	public void testClear2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(20,null,entry(stuff(6)),entry(stuff(2)),entry(stuff(13))));
		ht.setSize(3);
		ht.clear();
		assertTrue(ht.getTable().length==11);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testSize1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		assertTrue(ht.size()==0);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testSize2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.put(stuff(1),stuff(1));
		assertTrue(ht.size()==1);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testSize3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0))));
		ht.setSize(1);
		ht.remove(stuff(0));
		assertTrue(ht.size()==0);
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testValues1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4))));
		ht.setSize(3);
		ArrayList<Stuff> list = new ArrayList<>();
		list.add(stuff(0));
		list.add(stuff(1));
		list.add(stuff(4));
		assertTrue(list.equals(ht.values()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testValues2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1),true),entry(stuff(4))));
		ht.setSize(2);
		ArrayList<Stuff> list = new ArrayList<>();
		list.add(stuff(0));
		list.add(stuff(4));
		assertTrue(list.equals(ht.values()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testValues3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4)));
		arr[3].setNext(entry(stuff(3),stuff(2)));
		arr[0].setNext(entry(stuff(4)));
		ht.setTable(arr);
		ht.setSize(5);
		ArrayList<Stuff> list = new ArrayList<>();
		list.add(stuff(0));
		list.add(stuff(4));
		list.add(stuff(1));
		list.add(stuff(2));
		list.add(stuff(4));
		assertTrue(list.equals(ht.values()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeySet1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4))));
		ht.setSize(3);
		HashSet<Stuff> set = new HashSet<>();
		set.add(stuff(0));
		set.add(stuff(3));
		set.add(stuff(4));
		assertTrue(set.equals(ht.keySet()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeySet2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1),true),entry(stuff(4))));
		ht.setSize(2);
		HashSet<Stuff> set = new HashSet<>();
		set.add(stuff(0));
		set.add(stuff(4));
		assertTrue(set.equals(ht.keySet()));	
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeySet3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4)));
		arr[3].setNext(entry(stuff(3),stuff(2)));
		arr[4].setNext(entry(stuff(4)));
		ht.setTable(arr);
		ht.setSize(5);
		HashSet<Stuff> set = new HashSet<>();
		set.add(stuff(0));
		set.add(stuff(3));
		set.add(stuff(4));
		assertTrue(set.equals(ht.keySet()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeyValues1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4))));
		ht.setSize(3);
		assertEquals(1,ht.keyValues(stuff(4)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeyValues2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1),true),entry(stuff(4))));
		ht.setSize(2);
		assertEquals(-1,ht.keyValues(stuff(3)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testKeyValues3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4)));
		arr[4].setNext(entry(stuff(4),stuff(2)));
		arr[4].getNext().setNext(entry(stuff(4),stuff(1)));
		ht.setTable(arr);
		ht.setSize(5);
		assertEquals(3,ht.keyValues(stuff(4)));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testEntrySet1(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4))));
		ht.setSize(3);
		HashSet<MapEntry<Stuff,Stuff>> set = new HashSet<>();
		set.add(entry(stuff(0)));
		set.add(entry(stuff(3),stuff(1)));
		set.add(entry(stuff(4)));
		assertTrue(set.equals(ht.entrySet()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testEntrySet2(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		ht.setTable(array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1),true),entry(stuff(4))));
		ht.setSize(2);
		HashSet<MapEntry<Stuff,Stuff>> set = new HashSet<>();
		set.add(entry(stuff(0)));
		set.add(entry(stuff(4)));
		assertTrue(set.equals(ht.entrySet()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 3)
	public void testEntrySet3(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,entry(stuff(0)),null,null,entry(stuff(3),stuff(1)),entry(stuff(4)));
		arr[4].setNext(entry(stuff(4),stuff(2)));
		arr[4].getNext().setNext(entry(stuff(4),stuff(1)));
		arr[0].setNext(entry(stuff(0)));
		ht.setTable(arr);
		ht.setSize(6);
		HashSet<MapEntry<Stuff,Stuff>> set = new HashSet<MapEntry<Stuff,Stuff>>();
		set.add(entry(stuff(0)));
		set.add(entry(stuff(3),stuff(1)));
		set.add(entry(stuff(4)));
		set.add(entry(stuff(4),stuff(2)));
		set.add(entry(stuff(4),stuff(1)));
		assertTrue(set.equals(ht.entrySet()));
	}
	
	@Test (timeout = 300)
	//@Worth (points = 5)
	public void testLoop(){
		HashTable<Stuff,Stuff> ht = new HashTable<Stuff,Stuff>();
		MapEntry<Stuff,Stuff>[] arr = array(11,(MapEntry<Stuff,Stuff>)null);
		for(int i=0; i<arr.length; i++){
			arr[i]=entry(stuff(i),stuff(i),true);
		}
		ht.setTable(arr);
		ht.setSize(11);
		assertFalse(ht.contains(stuff(0)));
	}
	
	
	
	/*
	 * Non-tests
	 */
	private MapEntry<Stuff,Stuff>[] array(int size,MapEntry<Stuff,Stuff>...entries){
		MapEntry<Stuff,Stuff>[] arr = new MapEntry[size];
		int index=0;
		for(MapEntry<Stuff,Stuff> entry:entries){
			arr[index]=entry;
			index++;
		}
		return arr;
	}
	
	private MapEntry<Stuff,Stuff> entry(Stuff a,Stuff b,boolean bool){
		MapEntry<Stuff,Stuff> entry = new MapEntry<Stuff,Stuff>(a,b);
		entry.setRemoved(bool);
		return entry;
	}
	private MapEntry<Stuff,Stuff> entry(Stuff a,Stuff b){
		return entry(a,b,false);
	}
	
	private MapEntry<Stuff,Stuff> entry(Stuff a){
		return entry(a,a,false);
	}
	
	private Stuff stuff(int a){
		return new Stuff(a);
	}
	
	private class Stuff{
		int a;
		
		public Stuff(int a){
			this.a=a;
		}
		
		@Override
		public int hashCode(){
			return a;
		}
		
		@Override
		public boolean equals(Object o){
			if(o instanceof Stuff && ((Stuff)o).a==this.a){
				return true;
			}
			return false;
		}
	}

}