
class BinarySearchTree<Key extends Comparable<Key>, Value> {
	private class Node {
		private Key key;
		private Value val;
		private Node left, right;
		
		public Node(Key _key, Value _val) {
			key = _key;
			val = _val;
			left = null;
			right = null;
		}
	}
	
	private Node root = null;
	
	private void _insert(Node nod, Node aux) {
		int cmp = aux.key.compareTo(nod.key);
		if (cmp == 0 || cmp == 1) {
			if (nod.right == null) {
				nod.right = aux;
				return;
			}
			_insert(nod.right, aux);
		} else {
			if (nod.left == null) {
				nod.left = aux;
				return;
			}
			_insert(nod.left, aux);
		}
	}
	
	public void insert(Key key, Value val) {
		Node aux = new Node(key, val);
		if (root == null) {
			root = aux;
			return;
		}
		
		_insert(root, aux);
	}
	
	private Value _get(Node nod, Key key) {
		int cmp = key.compareTo(nod.key);
		
		if (cmp == 1) {
			return _get(nod.right, key);
		} else if (cmp == -1) {
			return _get(nod.left, key);
		}
		
		return nod.val;
	}
	
	public Value get(Key key) {
		return _get(root, key);
	}
}

public class ex1 {
	public static void main(String[] args) {
		BinarySearchTree<Integer, Integer> t = new BinarySearchTree<Integer, Integer>();
		t.insert(1, 2);
		t.insert(2, 5);
		t.insert(3, 9);
		t.insert(4, 10);
		t.insert(5, 15);
		System.out.println(t.get(5));
	}
}
