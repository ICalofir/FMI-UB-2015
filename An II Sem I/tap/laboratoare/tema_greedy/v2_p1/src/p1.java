import java.io.*;
import java.util.*;

public class p1 {
	private static int n, p;
	private static class pair implements Comparable<pair> {
		int l, c, nr;

		pair(int l, int c, int nr) {
			this.l = l;
			this.c = c;
			this.nr = nr;
		}

		public int compareTo(pair obj) {
			return obj.l - l;
		}
	}

	private static ArrayList<pair> v = new ArrayList<pair>();

	private static void read() throws Exception {
		File fin = new File("date.in");
		Scanner sc = null;

		try {
			sc = new Scanner(fin);

			n = sc.nextInt();
			p = sc.nextInt();
			for (int i = 1; i <= n; ++i) {
				int l = sc.nextInt();
				int c = sc.nextInt();

				v.add(new pair(l, c, i));
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
		Writer wr = new FileWriter("date.out");

		if (n <= 0) {
			wr.write("Numarul cuburilor trebuie sa fie strict pozitiv!");
		} else {
			Collections.sort(v);
			ArrayList<Integer> W = new ArrayList<Integer>();
			int s = v.get(0).l;
			W.add(v.get(0).nr);
			int now_c = v.get(0).c;

			for (int i = 1; i < v.size(); ++i) {
				if (v.get(i).c != now_c) {
					s += v.get(i).l;
					W.add(v.get(i).nr);
					now_c = v.get(i).c;
				}
			}

			wr.write(s + "\n");
			for (int el : W) {
				wr.write(el + " ");
			}
			wr.write("\n");
		}

		wr.close();
	}

	public static void main(String[] args) throws Exception {
		read();
		solve();
	}
}
