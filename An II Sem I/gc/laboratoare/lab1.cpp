#include <iostream>

using namespace std;

bool coliniar;

struct Point {
    int x, y, z;
};
Point P[4], V[3];

bool is_equal(Point A, Point B) {
    if (A.x == B.x && A.y == B.y && A.z == B.z) {
        return true;
    }
    return false;
}

int main() {
    cin >> P[1].x >> P[1].y >> P[1].z;
    cin >> P[2].x >> P[2].y >> P[2].z;
    cin >> P[3].x >> P[3].y >> P[3].z;

    for (int i = 1; i <= 3 && !coliniar; ++i) {
        for (int j = i + 1; j <= 3 && !coliniar; ++j) {
            if (is_equal(P[i], P[j])) {
                coliniar = true;
                cout << "Punctele sunt coliniare.\n";
                cout << "Combinatia afina este: ";
                cout << "(" << P[i].x << ", " << P[i].y << ", " << P[i].z << ") = ";
                cout << "1 * (" << P[j].x << ", " << P[j].y << ", " << P[j].z << ") + 0 * ";

                int k;
                if (i == 1 && j == 2) {
                    k = 3;
                } else if (i == 1 && j == 3) {
                    k = 2;
                } else {
                    k = 1;
                }

                cout << "(" << P[k].x << ", " << P[k].y << ", " << P[k].z << ")";
            }
        }
    }

    if (!coliniar) {
        for (int i = 1; i <= 2; ++i) {
            V[i].x = P[i + 1].x - P[i].x;
            V[i].y = P[i + 1].y - P[i].y;
            V[i].z = P[i + 1].z - P[i].z;
        }

        double l;
        if (V[2].x != 0 && V[2].y != 0 && V[2].z != 0) {
            int prod1 = V[2].x * V[1].y;
            int prod2 = V[2].y * V[1].x;
            if (prod1 != prod2) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            }

            prod1 = V[2].x * V[1].z;
            prod2 = V[2].z * V[1].x;
            if (prod1 != prod2) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].x / (double)V[2].x;
            }
        } else if (V[2].x == 0 && V[2].y != 0 && V[2].z != 0) {
            if (V[1].x != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            }

            int prod1 = V[2].y * V[1].z;
            int prod2 = V[2].z * V[1].y;
            if (prod1 != prod2) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].y / (double)V[2].y;
            }
        } else if (V[2].x != 0 && V[2].y == 0 && V[2].z != 0) {
            if (V[1].y != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            }

            int prod1 = V[2].x * V[1].z;
            int prod2 = V[2].z * V[1].x;
            if (prod1 != prod2) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].x / (double)V[2].x;
            }
        } else if (V[2].x != 0 && V[2].y != 0 && V[2].z == 0) {
            if (V[1].z != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            }

            int prod1 = V[2].x * V[1].y;
            int prod2 = V[2].y * V[1].x;
            if (prod1 != prod2) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].x / (double)V[2].x;
            }
        } else if (V[2].x == 0 && V[2].y == 0 && V[2].z != 0) {
            if (V[1].x != 0 || V[1].y != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].z / (double)V[2].z;
            }
        } else if (V[2].x == 0 && V[2].y != 0 && V[2].z == 0) {
            if (V[1].x != 0 && V[1].z != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].y / (double)V[2].y;
            }
        } else if (V[2].x != 0 && V[2].y == 0 && V[2].z == 0) {
            if (V[1].y != 0 && V[1].z != 0) {
                cout << "Punctele nu sunt coliniare.";
                return 0;
            } else {
                l = (double)V[1].x / (double)V[2].x;
            }
        }

        cout << "Punctele sunt coliniare.\n";
        cout << "Combinatia afina este: ";
        cout << "(" << P[1].x << ", " << P[1].y << ", " << P[1].z << ") = ";
        cout << 1 + l << " * (" << P[2].x << ", " << P[2].y << ", " << P[2].z << ") + ";
        l *= -1;
        cout << l << " * (" << P[3].x << ", " << P[3].y << ", " << P[3].z << ")";
    }

    return 0;
}
