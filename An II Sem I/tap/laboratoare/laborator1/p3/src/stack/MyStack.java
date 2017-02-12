package stack;

import java.util.Iterator;

class FullStackException extends RuntimeException {
	FullStackException(String str_) {
		super(str_);
	}
}

class EmptyStackException extends RuntimeException {
	EmptyStackException(String str_) {
		super(str_);
	}
}

public class MyStack<E> implements Iterable<E>{
	private int capacity_;
	private E[] elems_;
	private int top_;

	public Iterator<E> iterator() {
		return new MyStackIterator();
	}
//	
	private class MyStackIterator implements Iterator<E> {
		private int current_ = 0;
		public boolean hasNext() {
			return current_ < capacity_;
		}
		public E next() {
			return elems_[++current_];
		}
	}
	
	public MyStack(int capacity_) {
		elems_ = (E[]) new Object[capacity_ + 1];
		this.capacity_ = capacity_;
		top_ = 0;
	}

	public void push(E elem_) {
		if (top_ == capacity_) {
			throw new FullStackException("Stack full, can't push!");
		} else {
			elems_[++top_] = elem_;
		}
	}

	public void pop() {
		if (top_ == 0) {
			throw new EmptyStackException("Stack empty, can't pop!");
		} else {
			elems_[top_--] = null;
		}
	}

	public E top() {
		if (top_ == 0) {
			throw new EmptyStackException("Stack empty!");
		} else {
			return elems_[top_];
		}
	}
}