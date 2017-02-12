import java.io.*;
import java.util.*;

public class p2_b {
	private static int n, p;
	private static class pair implements Comparable<pair> {
		int l, nr;
		
		pair(int l, int nr) {
			this.l = l;
			this.nr = nr;
		}
		
		public int compareTo(pair obj) {
			return this.l - obj.l;
		}
	}
	
	private static ArrayList<pair> v = new ArrayList<pair>();
	private static ArrayList<ArrayList<Integer>> w = new ArrayList<ArrayList<Integer>>();
	
	private static void read() throws Exception {
		File fin = new File("date_b.in");
		Scanner sc = null;
		
		try {
			sc = new Scanner(fin);
			
			n = sc.nextInt();
			p = sc.nextInt();
			for (int i = 1; i <= n; ++i) {
				int l = sc.nextInt();
				
				v.add(new pair(l, i));
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
		Writer wr = new FileWriter("date_b.out");
		
		Collections.sort(v);
		for (int i = 1; i <= p; ++i) {
			ArrayList<Integer> now = new ArrayList<Integer>();
			w.add(now);
		}
			
		int pos = 0;
		for (pair el : v) {
			w.get(pos).add(el.nr);
			pos += 1;
			
			if (pos == p) {
				pos = 0;
			}
		}
		
		for (int i = 0; i < w.size(); ++i) {
			wr.write("Banda cu numarul " + i + ": ");
			for (int el : w.get(i)) {
				wr.write(el + " ");
			}
			wr.write("\n");
		}
		wr.write("\n");
		
		wr.close();
	}
	
	public static void main(String[] args) throws Exception {
		read();
		solve();
	}
}
