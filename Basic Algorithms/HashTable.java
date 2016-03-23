import java.util.Collection;
import java.util.Set;
import java.util.HashSet;
import java.util.ArrayList;
/**
 * 
 * 
 * Mason DiMarco
 * 
 * This class will represent a modified linear probing hash table. 
 * The modification is specified in the comments for the put method.
 */
public class HashTable<K,V> {
	
	/**
	 * Constant determining the max load factor
	 */
	private final double MAX_LOAD_FACTOR = 0.71;
	/**
	 * Constant determining the initial table size
	 */
	private final int INITIAL_TABLE_SIZE = 11;
	
	/**
	 * Number of elements in the table
	 */
	private int size;
	
	/**
	 * The backing array of this hash table
	 */
	private MapEntry<K,V>[] table;
	
	/**
	 * Initialize the instance variables
	 * Initialize the backing array to the initial size given
	 */
	@SuppressWarnings("unchecked")
	public HashTable() {
		this.size = 0;
		this.table = new MapEntry[INITIAL_TABLE_SIZE];
	}
	
	/**
	 * Add the key value pair in the form of a MapEntry
	 * Use the default hash code function for hashing
	 * This is a linear probing hash table so put the entry in the table accordingly
	 * 
	 * Make sure to use the given max load factor for resizing
	 * Also, resize by doubling and adding one. In other words:
	 * 
	 * newSize = (oldSize * 2) + 1
	 *
	 * The load factor should never exceed maxLoadFactor at any point. So if adding this element
	 * will cause the load factor to be exceeded, you should resize BEFORE adding it. Otherwise
	 * do not resize.
	 * 
	 * IMPORTANT Modification: If the given key already exists in the table
	 * then set it as the next entry for the already existing key. This means
	 * that you will never be replacing values in the hashtable, only adding or removing.
	 * This is similar to external chaining
	 * 
	 * @param key This will never be null
	 * @param value This can be null
	 */
	public void put(K key,V value){
		
		double filled = (this.size+1) / (double)table.length;
		if(filled >= MAX_LOAD_FACTOR) this.resize();
		
		MapEntry<K,V> toBePut = new MapEntry<K,V>(key,value);
		
		//Case of key already being there, in which case, chain
		if(contains(key)) {
			int slot = findSlot(key);
			addToChain(table[slot],toBePut);
			size++;
			return;
		}
		
		
		int slot = Math.abs(key.hashCode())%table.length;
		//Slot's empty, put it in
		if(table[slot] == null ){
			table[slot] = toBePut;
			size++;
			return;
		}
		
		else{
			while(table[slot] != null && !table[slot].isRemoved()){
				slot++;
				if(slot >= table.length) slot = 0;
			}
			table[slot] = toBePut;
			size++;
		}
		
		
		
	}
	
	private void addToChain(MapEntry<K,V> chain, MapEntry<K,V> entry){
		while(chain.getNext() != null){
			chain = chain.getNext();
		}
		chain.setNext(entry);
	}
	
	@SuppressWarnings("unchecked")
	private void resize(){
		MapEntry<K,V>[] oldTable = table;
		this.table = new MapEntry[table.length*2+1];
		size = 0;
		for(int i =0; i<oldTable.length; i++){
			if(oldTable[i] != null && !oldTable[i].isRemoved()){
				MapEntry<K,V> current = oldTable[i];
				while(current != null){
					this.put(current.getKey(),current.getValue());
					current = current.getNext();
				}
		}
	}
	}
	
	/**
	 * Remove the entry with the given key.
	 * 
	 * If there are multiple entries with the same key then remove the last one
	 * 
	 * @param key
	 * @return The value associated with the key removed
	 */
	public V remove(K key){
		if(!contains(key))return null;
		
		int slot = Math.abs(key.hashCode())%table.length;
		
		if(table[slot] == null) return null;
		
		
		else if(table[slot].getKey().equals(key)){
			size--;
			return removeFromChain(slot);
		}
		
		else{
			while(!table[slot].getKey().equals(key) &&
					table[slot] != null){
				slot++;
				if(slot >= table.length) slot = 0;
			}
			if(table[slot] == null) return null;
			else{
				size--;
				return removeFromChain(slot);
			}
		}
	}
	
	private V removeFromChain(int slot){
		V valRemoved;
		MapEntry<K,V> current = table[slot];
		if(current.getNext() == null){
			table[slot].setRemoved(true);
			valRemoved = table[slot].getValue();
		}
		else{
			while(current.getNext().getNext() != null){
				current = current.getNext();
			}
			valRemoved = current.getNext().getValue();
			current.setNext(null);
			}
		return valRemoved;
	}
	
	/**
	 * Checks whether an entry with the given key exists in the hash table
	 * 
	 * @param key
	 * @return
	 */
	public boolean contains(K key){
        if(table[findSlot(key)] == null) return false;
        else{
            MapEntry<K, V> entry = table[findSlot(key)];
            if(entry!=null && !entry.isRemoved()) return true;
           
        }
        return false;    
    }
	
	/**
	 * Return a collection of all the values
	 * 
	 * We recommend using an ArrayList here
	 *
	 * @return 
	 */
	public Collection<V> values(){
		ArrayList<V> vals = new ArrayList<V>();
		for(K key: keySet()){
			MapEntry<K,V> entry = table[findSlot(key)];
			while(entry != null){
				vals.add(entry.getValue());
				entry = entry.getNext();
			}
		}
		return vals;
	}
	
	/**
	 * Return a set of all the distinct keys
	 * 
	 * We recommend using a HashSet here
	 * 
	 * Note that the map can contain multiple entries with the same key
	 * 
	 * @return
	 */
	public Set<K> keySet(){
		
		Set<K> keys = new HashSet<K>();
		for(int i = 0; i<table.length; i++){
			if(table[i] != null && !table[i].isRemoved()) {
				MapEntry<K,V> entry = table[i];
				keys.add(entry.getKey());
			}
		}
		return keys;
	}
	
	/**
	 * Return the number of values associated with one key
	 * Return -1 if the key does not exist in this table
	 * @param key
	 * @return
	 */
	public int keyValues(K key){
		int counter = -1;
		if(contains(key)){
			int slot = findSlot(key);
			counter = 1;
			MapEntry<K,V> current = table[slot%table.length];
			while(current.getNext() != null){
					counter++;
					current = current.getNext();
				}
			}
		return counter;
	}
	
	/**
	 * Return a set of all the unique key-value entries
	 * 
	 * Note that two map entries with both the same key and value
	 * could exist in the map.
	 * 
	 * @return
	 */
	public Set<MapEntry<K,V>> entrySet(){
		Set<MapEntry<K,V>> entries = new HashSet<MapEntry<K,V>>();
		for (K keys: keySet()){
			int slot = findSlot(keys);
			if(slot != -1){
				MapEntry<K,V> current = table[slot];
				while(current != null && !current.isRemoved()){
					entries.add(current);
					current = current.getNext();
				}
				
			}
			
			
		}
		return entries;
	}
	
	/**
	 * Clears the hash table
	 */
	@SuppressWarnings("unchecked")
	public void clear(){
		this.size = 0;
		this.table = new MapEntry[INITIAL_TABLE_SIZE];
	}
	

	
	
	
	
	
	
	
private int findSlot(K key){
        int slot = Math.abs(key.hashCode()) % table.length;
        while(table[slot] != null && !table[slot].getKey().equals(key)){
           slot++;
           if(slot >= table.length)slot = 0; 
        }
        return slot;
    }


	
	
	
	/*
	 * The following methods will be used for grading purposes do not modify them
	 */
	
	public int size(){
		return size;
	}
	
	public void setSize(int size) {
		this.size = size;
	}
	
	public MapEntry<K, V>[] getTable() {
		return table;
	}
	
	public void setTable(MapEntry<K, V>[] table) {
		this.table = table;
	}
}