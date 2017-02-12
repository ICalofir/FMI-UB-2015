import stack.*;

public class p2 {
	public static void main(String[] args) {
		MyStack<Integer> s = new MyStack<Integer>(2);
	    s.push(2);
	    s.push(5);
	    s.pop();
	    System.out.println(s.top());
	}
}
