#include <iostream>
#include <cmath>

using namespace std;

bool is_convex, point_belong;

struct Punct {
    int x, y;
};
Punct P1, P2, P3, P4, P;

int det(Punct P, Punct P1, Punct P2) {
    return P.x * P1.y + P1.x * P2.y + P2.x * P.y -
           (P2.x * P1.y + P.x * P2.y + P1.x * P.y);
}

int main()
{
    cin >> P1.x >> P1.y;
    cin >> P2.x >> P2.y;
    cin >> P3.x >> P3.y;
    cin >> P4.x >> P4.y;
    cin >> P.x >> P.y;

    int prod1 = det(P3, P1, P2) * det(P4, P1, P2);
    int prod2 = det(P1, P2, P3) * det(P4, P2, P3);
    int prod3 = det(P1, P3, P4) * det(P2, P3, P4);
    int prod4 = det(P2, P4, P1) * det(P3, P4, P1);
    if (prod1 < 0 || prod2 < 0 || prod3 < 0 || prod4 < 0) {
        is_convex = false;
    } else {
        is_convex = true;
    }

    int a1 = abs(det(P1, P2, P)) + abs(det(P1, P3, P)) + abs(det(P2, P3, P));
    int a2 = abs(det(P1, P2, P3));
    if (a1 == a2)
        point_belong = true;

    a1 = abs(det(P1, P2, P)) + abs(det(P1, P4, P)) + abs(det(P2, P4, P));
    a2 = abs(det(P1, P2, P4));
    if (a1 == a2)
        point_belong = true;

    a1 = abs(det(P1, P3, P)) + abs(det(P1, P4, P)) + abs(det(P3, P4, P));
    a2 = abs(det(P1, P3, P4));
    if (a1 == a2)
        point_belong = true;

    a1 = abs(det(P2, P3, P)) + abs(det(P2, P4, P)) + abs(det(P3, P4, P));
    a2 = abs(det(P2, P3, P4));
    if (a1 == a2)
        point_belong = true;

    if (is_convex) {
        cout << "Poligonul este convex.\n";
    } else {
        cout << "Poligonul nu este convex.\n";
    }

    if (point_belong) {
        cout << "Punctul apartine acoperirii convexe.\n";
    } else {
        cout << "Punctul nu apartine acoperirii convexe.\n";
    }

    return 0;
}
