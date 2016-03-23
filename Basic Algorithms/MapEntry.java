import java.util.Map.Entry;

/**
 * Class represents an entry containing a key and value
 * 
 * Don't modify this class
 */
public class MapEntry<K,V> implements Entry<K, V> {
	
	private K key;
	private V value;
	private MapEntry<K,V> next;
	
	/**
	 * This value determines if they key in this entry has been
	 * completely removed from the hashtable. This is only
	 * an important field for the first entry in the chain
	 * of entries with the same key.
	 * 
	 * If this is true, it implies that next is null. And that
	 * this is the first MapEntry in the chain
	 */
	private boolean removed;
	
	public MapEntry(K key,V value){
		this.key = key;
		this.value = value;
		next = null;
		removed = false;
	}

	@Override
	public K getKey() {
		return key;
	}

	@Override
	public V getValue() {
		return value;
	}

	@Override
	public V setValue(V value) {
		V temp = this.value;
		this.value = value;
		return temp;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((key == null) ? 0 : key.hashCode());
		result = prime * result + ((value == null) ? 0 : value.hashCode());
		return result;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MapEntry other = (MapEntry) obj;
		if (key == null) {
			if (other.key != null)
				return false;
		} else if (!key.equals(other.key))
			return false;
		if (value == null) {
			if (other.value != null)
				return false;
		} else if (!value.equals(other.value))
			return false;
		return true;
	}

	public MapEntry<K,V> getNext(){
		return next;
	}
	
	public void setNext(MapEntry<K,V> next){
		this.next = next;
	}
	
	public boolean isRemoved(){
		return removed;
	}
	
	public void setRemoved(boolean bool){
		removed = bool;
	}
	

}