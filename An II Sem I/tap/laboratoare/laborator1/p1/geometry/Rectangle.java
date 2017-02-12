package geometry;

public class Rectangle implements BaseGeometry {
  protected double width_, height_;

  public Rectangle(double width_, double height_) {
    this.width_ = width_;
    this.height_ = height_;
  }

  public double area() {
    return width_ * height_;
  }
}
