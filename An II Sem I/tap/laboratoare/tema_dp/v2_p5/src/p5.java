import java.util.*;
import java.io.*;

public class p5 {
	private static int n, tmax;
	private static triplet[] v;
	private static pair[][] pre;
	//dp[i][j] - profitul maxim care se poate obtine aranjand primele i joburi, toate joburile terminandu-se pana la timpul j
	//pentru 1 <= i <= n calculam tt = min(j, t[i]) - l[i], j <= tmax, tt - ultimul timp posibil in care putem pune jobul i
	//tt < 0 => dp[i][j] = dp[i - 1][j]
	//tt >= 0 => dp[i][j] = max(dp[i - 1][j], p[i] + dp[i - 1][tt])
	private static int[][] dp;

	private static class triplet implements Comparable<triplet> {
		int p, t, l, pos;

		triplet(int p, int t, int l, int pos) {
			this.p = p;
			this.t = t;
			this.l = l;
			this.pos = pos;
		}

		public int compareTo(triplet obj) {
			return t - obj.t;
		}
	}

	private static class pair {
		int i, j, pos;

		pair() {
			i = 0;
			j = 0;
			pos = 0;
		}
	}

	private static void read() throws Exception {
		File fin = new File("date.in");
		Scanner sc = null;

		sc = new Scanner(fin);

		n = sc.nextInt();
		v = new triplet[n + 1];
		v[0] = new triplet(0, 0, 0, 0);
		for (int i = 1, p, t, l; i <= n; ++i) {
			p = sc.nextInt();
			t = sc.nextInt();
			l = sc.nextInt();
			v[i] = new triplet(p, t, l, i);

			if (t > tmax) {
				tmax = t;
			}
		}
		dp = new int[n + 1][tmax + 1];
		pre = new pair[n + 1][tmax + 1];
		for (int i = 0; i <= n; ++i) {
			for (int j = 0; j <= tmax; ++j) {
				pre[i][j] = new pair();
			}
		}
		Arrays.sort(v, 1, n + 1);

		if (sc != null) {
			sc.close();
		}
	}

	private static int get_minim(int a, int b) {
		if (a < b)
			return a;
		return b;
	}

	private static void solve() {
		for (int i = 1; i <= n; ++i) {
			for (int j = 1; j <= tmax; ++j) {
				int tt = get_minim(j, v[i].t) - v[i].l;

				if (tt < 0) {
					dp[i][j] = dp[i - 1][j];
					pre[i][j].i = pre[i - 1][j].i;
					pre[i][j].j = pre[i - 1][j].j;
					pre[i][j].pos = pre[i - 1][j].pos;
					continue;
				}

				if (dp[i - 1][j] > v[i].p + dp[i - 1][tt]) {
					dp[i][j] = dp[i - 1][j];
					pre[i][j].i = pre[i - 1][j].i;
					pre[i][j].j = pre[i - 1][j].j;
					pre[i][j].pos = pre[i - 1][j].pos;
				} else {
					dp[i][j] = v[i].p + dp[i - 1][tt];
					pre[i][j].i = i - 1;
					pre[i][j].j = tt;
					pre[i][j].pos = v[i].pos;
				}
			}
		}
	}

	public static void write_path(int i, int j, Writer wr) throws Exception {
		if (pre[i][j].pos == 0) {
			return;
		}

		write_path(pre[i][j].i, pre[i][j].j, wr);
		wr.write(pre[i][j].pos + " ");
	}

	public static void write() throws Exception {
		Writer wr = new FileWriter("date.out");

		wr.write(dp[n][tmax] + "\n");
		write_path(n, tmax, wr);

		wr.close();
	}

	public static void main(String[] args) throws Exception {
		read();
		solve();
		write();
	}
}
