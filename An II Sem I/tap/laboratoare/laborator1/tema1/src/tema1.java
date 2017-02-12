import java.util.Iterator;
import java.util.ArrayList;
import java.util.Random;

interface RandMethodBase extends Iterable<Integer> {
	
}

class RandMethodA implements RandMethodBase {
	private Random random_ = new Random();
	private int N_;
	private ArrayList<Integer> V_ = new ArrayList<Integer>();
	
	RandMethodA(int N_) {
		this.N_ = N_;
	}
	
	public Iterator<Integer> iterator() {
		return new MyIterator();
	}
	
	private class MyIterator implements Iterator<Integer> {
		public boolean hasNext() {
			if (V_.size() == N_)
				return false;
			return true;
		}
		public Integer next() {
			boolean ok_ = false;
			int x_ = 0;
			while (!ok_) {
				x_= random_.nextInt() % N_;
				if (x_ < 0 || V_.contains(x_))
					continue;
				
				ok_ = true;
				V_.add(x_);
			}
			
			return x_;
		}
	}
}

class RandMethodB implements RandMethodBase {
	private Random random_ = new Random();
	private int N_;
	private ArrayList<Integer> V_ = new ArrayList<Integer>();
	
	RandMethodB(int N_) {
		for (int i = 0; i < N_; ++i) {
			V_.add(i);
		}
		this.N_ = N_;
	}
	
	public Iterator<Integer> iterator() {
		return new MyIterator();
	}
	
	private class MyIterator implements Iterator<Integer> {
		public boolean hasNext() {
			if (V_.size() == 0)
				return false;
			return true;
		}
		public Integer next() {
			boolean ok_ = false;
			int x_ = 0;
			while (!ok_) {
				x_= random_.nextInt() % N_;
				if (x_ < 0 || !V_.contains(x_))
					continue;
				
				ok_ = true;
				V_.remove(V_.indexOf(x_));
			}
			
			return x_;
		}
	}
}

public class tema1 {
	public static void main(String[] args) {
		RandMethodA x = new RandMethodA(10);
		Iterator<Integer> i = x.iterator();
		
		while (i.hasNext()) {
			System.out.println(i.next());
		}
		
		System.out.println();
		
		RandMethodB y = new RandMethodB(10);
		Iterator<Integer> ii = y.iterator();
		
		while (ii.hasNext()) {
			System.out.println(ii.next());
		}
	}
}
