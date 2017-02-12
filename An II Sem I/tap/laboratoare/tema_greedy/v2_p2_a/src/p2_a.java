import java.io.*;
import java.util.*;

public class p2_a {
	private static int n;
	private static class pair implements Comparable<pair> {
		int l, f, nr;
		
		pair(int l, int f, int nr) {
			this.l = l;
			this.f = f;
			this.nr = nr;
		}
		
		public int compareTo(pair obj) {
			return obj.f * this.l - this.f * obj.l;
		}
	}
	
	private static ArrayList<pair> v = new ArrayList<pair>();
	
	private static void read() throws Exception {
		File fin = new File("date_a.in");
		Scanner sc = null;
		
		try {
			sc = new Scanner(fin);
			
			n = sc.nextInt();
			for (int i = 1; i <= n; ++i) {
				int l = sc.nextInt();
				int f = sc.nextInt();
				
				v.add(new pair(l, f, i));
			}
		} catch (Exception ex) {
			throw ex;
		} finally {
			if (sc != null) {
				sc.close();
			}
		}
	}
	
	private static void solve() throws Exception {
		Writer wr = new FileWriter("date_a.out");
		
		Collections.sort(v);
			
		for (int i = 0; i < v.size(); ++i) {
			wr.write(v.get(i).nr + " ");
		}
		wr.write("\n");
		
		wr.close();
	}
	
	public static void main(String[] args) throws Exception {
		read();
		solve();
	}
}
