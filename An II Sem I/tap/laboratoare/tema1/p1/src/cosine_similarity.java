import java.io.*;
import java.util.*;

public class cosine_similarity {
	private static HashMap<String, Integer> read(String file) throws Exception {
		HashMap<String, Integer> hmap = new HashMap<String, Integer>();
		
		File fin = new File(file);
		Scanner sc = null;
		
		try {
			sc = new Scanner(fin);
			
			while (sc.hasNextLine()) {
				String str = sc.nextLine();
				String[] words = str.split("[^a-zA-Z0-9]+");
				
				for (String word : words) {
					if (hmap.get(word) == null) {
						hmap.put(word, 1);
					} else {
						hmap.replace(word, hmap.get(word) + 1);
					}
				}
			}
			
		} catch (Exception ex) {
			throw ex;
		} finally {
			if (sc != null) {
				sc.close();
			}
		}
		
		return hmap;
	}
	
	private static HashMap<String, Boolean> get_all_words(HashMap<String, Integer> h1, HashMap<String, Integer> h2) {
		HashMap<String, Boolean> hmap = new HashMap<String, Boolean>();
		
		Set<Map.Entry<String, Integer>> s1 = h1.entrySet();
		Iterator<Map.Entry<String, Integer>> it1 = s1.iterator();
		while (it1.hasNext()) {
			Map.Entry<String, Integer> now = it1.next();
			hmap.put(now.getKey(), true);
		}
		
		Set<Map.Entry<String, Integer>> s2 = h2.entrySet();
		Iterator<Map.Entry<String, Integer>> it2 = s2.iterator();
		while (it2.hasNext()) {
			Map.Entry<String, Integer> now = it2.next();
			hmap.put(now.getKey(), true);
		}
		
		return hmap;
	}
	
	public static double solve(String file1, String file2) throws Exception {
		HashMap<String, Integer> h1 = read(file1);
		HashMap<String, Integer> h2 = read(file2);
		HashMap<String, Boolean> h = get_all_words(h1, h2);
		double sol = 0.0;
		int sum = 0;
		double rad1 = 0.0, rad2 = 0.0;
		
		Set<Map.Entry<String, Boolean>> s = h.entrySet();
		Iterator<Map.Entry<String, Boolean>> it = s.iterator();
		while (it.hasNext()) {
			Map.Entry<String, Boolean> now = it.next();
			int val1 = 0, val2 = 0;
			
			if (h1.get(now.getKey()) != null) {
				val1 = h1.get(now.getKey());
			}
			
			if (h2.get(now.getKey()) != null) {
				val2 = h2.get(now.getKey());
			}
			
			sum += val1 * val2;
			rad1 += val1 * val1;
			rad2 += val2 * val2;
		}
		
		rad1 = Math.sqrt(rad1);
		rad2 = Math.sqrt(rad2);
		
		sol = sum / (rad1 * rad2);
		
		return sol;
	}
	
	public static void main(String[] args) throws Exception {
		System.out.println(solve("date1.in", "date2.in"));
	}
}
