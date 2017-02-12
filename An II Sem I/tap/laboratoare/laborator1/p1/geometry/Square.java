package geometry;

public class Square extends Rectangle {
  public Square(double width_) {
    super(width_, width_);
    this.width_ = width_;
  }

  public double area() {
    return width_ * width_;
  }
}
