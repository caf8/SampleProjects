
public class keyWordObj implements Comparable<keyWordObj>{
	String name;
	int priority;
	
	public keyWordObj(String name, int priority){
		this.name = name;
		this.priority = priority; 
	}

	@Override
	public int compareTo(keyWordObj o) {
		if(Integer.valueOf(priority) == o.priority){
			return -1;
		}
		return Integer.valueOf(priority).compareTo(o.priority) * -1 ;
	}
}