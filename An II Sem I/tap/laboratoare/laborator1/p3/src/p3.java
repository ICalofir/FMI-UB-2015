import stack.MyStack;
import java.util.Iterator;

public class p3 {
	public static void main(String[] args) {
		MyStack<Integer> s = new MyStack<Integer>(2);
	    s.push(2);
	    s.push(5);
	    
	    Iterator<Integer> i = s.iterator();
	    while (i.hasNext()) {
	    	System.out.println(i.next());
	    }
	    
	    s.pop();
	    System.out.println(s.top());
	}
}