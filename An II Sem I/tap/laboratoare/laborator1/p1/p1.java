import geometry.*;

public class p1 {
  public static void main(String[] args) {
    BaseGeometry[] vec = new BaseGeometry[3];
    vec[0] = new Square(2);
    vec[1] = new Rectangle(2, 2);
    vec[2] = new Rectangle(2, 3);

    for (int i = 0; i < 3; ++i) {
      System.out.println(vec[i].area());
    }
  }
}
