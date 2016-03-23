import static org.junit.Assert.*;

import org.junit.Test;

/**
 * Version 1.1
 * Changelog:
 * + Added more tests to testRegrow() to include second regrow to ensure you are using table.length*2+1 and not INITIAL_TABLE_SIZE*2+1 for regrows.
 * * Changed testKeyValues() to test for -1 in the case where the key exists in the table, but has been removed. As per piazza@377
 * 		(I.e. it tests for effective existence, not actual existence.)
 * @author Kevin
 *
 */
public class HashTests {

	String s1 = "abc";
	String s2 = "bcd";
	String s3 = "cde";
	String s4 = "def";
	String s5 = "efg";
	
	@Test
	public void testEmptyHT() {
		HashTable<Integer, String> ht = new HashTable<>();
		assertEquals(0, ht.size());
		assertFalse(ht.contains(100));
		assertTrue(ht.entrySet().isEmpty());
		assertEquals(-1, ht.keyValues(100));
		assertTrue(ht.values().isEmpty());
		
		assertEquals(null, ht.remove(100));
		assertEquals(0, ht.size());
	}

	@Test
	public void testPut() {
		HashTable<String, String> ht = new HashTable<>();
		
		ht.put(s1, s1);
		assertEquals(1, ht.size());
		assertFalse(ht.contains("asdf"));
		assertTrue(ht.contains(s1));
		assertTrue(ht.contains("abc"));
		assertEquals(s1, ht.remove(s1));
	}
	
	@Test
	public void testLinearProbing() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(1, s1);
		ht.put(2, s2);
		ht.put(12, s3);
		assertEquals(3, ht.size());
		assertEquals(s3, ht.getTable()[3].getValue());
	}
	
	@Test
	public void testChaining() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(1, s1);
		ht.put(1, s2);
		ht.put(1, s3);
		assertEquals(3, ht.size());
		assertEquals(null, ht.getTable()[2]);
		assertEquals(s3, ht.remove(1));
	}
	
	@Test
	public void testIsRemovedFlag() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(1, s1);
		ht.remove(1);
		ht.put(12, s2);
		assertEquals(1, ht.size());
		assertEquals(s2, ht.getTable()[1].getValue());
	}
	
	@Test
	public void testChainIfKeyExists() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s2);
		ht.put(12, s3);
		ht.remove(0);
		ht.remove(1);

		ht.put(12, s4);
		assertEquals(s4, ht.getTable()[2].getNext().getValue());
	}
	
	@Test
	public void testRemoveLastChain() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(4, s1);
		ht.put(4, s2);
		ht.put(4, s3);
		ht.remove(4);
		assertEquals(s2, ht.getTable()[4].getNext().getValue());
		assertFalse(ht.getTable()[4].isRemoved());
	}
	
	@Test
	public void testRegrow() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		ht.put(2, s1);
		ht.put(3, s1);
		ht.put(4, s1);
		ht.put(5, s1);
		ht.put(6, s1);
		assertEquals(11, ht.getTable().length);
		ht.put(7, s1);
		assertEquals(23, ht.getTable().length);
		ht.put(8, s1);
		assertEquals(9, ht.size());
		ht.put(9, s1);
		ht.put(10, s1);
		ht.put(11, s1);
		ht.put(12, s1);
		ht.put(13, s1);
		ht.put(14, s1);
		ht.put(15, s1);
		assertEquals(16, ht.size());
		assertEquals(23, ht.getTable().length);
		ht.put(16, s1);
		assertEquals(17, ht.size());
		assertEquals(47, ht.getTable().length);
	}
	
	@Test
	public void testSize() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		ht.put(2, s1);
		ht.put(3, s1);
		ht.put(4, s1);
		ht.put(5, s1);
		ht.put(6, s1);
		ht.put(7, s1);
		assertEquals(8, ht.size());
		ht.put(8, s1);
		assertEquals(9, ht.size());
		ht.put(0, s2);
		assertEquals(10, ht.size());
		ht.put(0, s1);
		ht.put(0, s1);
		ht.put(0, s1);
		ht.put(0, s1);
		ht.put(0, s1);
		ht.put(0, s1);
		ht.put(0, s1);
		assertEquals(17, ht.size());

		ht.put(0, s1);
		ht.put(0, s1);

		ht.put(0, s1);
		assertEquals(20, ht.size());
	}
	
	@Test
	public void testValues() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		assertEquals(2, ht.values().size());
		ht.put(0, s2);
		ht.put(0, s1);
		assertEquals(4, ht.values().size());
		ht.remove(1);
		assertEquals(3, ht.values().size());
	}
	
	@Test
	public void testKeySet() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		assertEquals(2, ht.keySet().size());
		ht.put(0, s2);
		ht.put(0, s1);
		assertEquals(2, ht.keySet().size());
		ht.remove(1);
		assertEquals(1, ht.keySet().size());
	}
	
	@Test
	public void testKeyValues() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		assertEquals(1, ht.keyValues(0));
		assertEquals(1, ht.keyValues(1));
		ht.put(0, s2);
		ht.put(0, s1);
		assertEquals(3, ht.keyValues(0));
		ht.remove(1);
		assertEquals(-1, ht.keyValues(1));
		ht.remove(0);
		assertEquals(2, ht.keyValues(0));
	}
	
	@Test
	public void testEntrySet() {
		HashTable<Integer, String> ht = new HashTable<>();
		ht.put(0, s1);
		ht.put(1, s1);
		assertEquals(2, ht.entrySet().size());
		ht.put(0, s2);
		ht.put(0, s1);
		assertEquals(3, ht.entrySet().size());
		ht.remove(1);
		assertEquals(2, ht.entrySet().size());
		ht.remove(0);
		assertEquals(2, ht.entrySet().size());
	}
}
