#include <iostream>
#include <algorithm>

using namespace std;

int a_A1A2, b_A1A2, c_A1A2;
int a_A3A4, b_A3A4, c_A3A4;
int det, rang;

struct Points {
    double x, y;
    int ind;
} A1, A2, A3, A4, P[5];

bool cmp(Points A, Points B) {
    return (A.x < B.x || (A.x == B.x && A.y < B.y) || (A.x == B.x && A.y == B.y && A.ind > B.ind));
}

int main() {
    cin >> A1.x >> A1.y;
    cin >> A2.x >> A2.y;
    cin >> A3.x >> A3.y;
    cin >> A4.x >> A4.y;
    A1.ind = 1;
    A2.ind = 2;
    A3.ind = 3;
    A4.ind = 4;

    a_A1A2 = A1.y - A2.y;
    b_A1A2 = A2.x - A1.x;
    c_A1A2 = A1.x * A2.y - A2.x * A1.y;

    a_A3A4 = A3.y - A4.y;
    b_A3A4 = A4.x - A3.x;
    c_A3A4 = A3.x * A4.y - A4.x * A3.y;

    int det = a_A1A2 * b_A3A4 - b_A1A2 * a_A3A4;

    if (det != 0) {
        double x = -1.0 * (double)(c_A1A2 * b_A3A4 - b_A1A2 * c_A3A4) / (double)det;
        double y = -1.0 * (double)(a_A1A2 * c_A3A4 - c_A1A2 * a_A3A4) / (double)det;

        bool isOk = true;
        Points PP;
        PP.x = x;
        PP.y = y;
        PP.ind = 5;

        P[1] = A1;
        P[2] = A2;
        P[3] = PP;
        sort (P + 1, P + 3 + 1, cmp);
        if (P[2].ind != 5)
            isOk = false;

        P[1] = A1;
        P[2] = A2;
        P[3] = PP;
        sort (P + 1, P + 3 + 1, cmp);
        if (P[2].ind != 5)
            isOk = false;

        if (isOk) {
            cout << "Intersectia celor doua segmente este punctul: (" << x << ", " << y << ").\n";
        } else {
            cout << "Intersectia celor doua segmente este vida.\n";
        }
    } else {
        rang = 0;
        det = a_A1A2 * c_A3A4 - c_A1A2 * a_A3A4;
        if (det != 0) {
            rang = 2;
        } else if (a_A1A2 != 0 || b_A1A2 != 0 || c_A1A2 != 0 || a_A3A4 != 0 || b_A3A4 != 0 || c_A3A4 != 0) {
            rang = 1;
        }

        if (rang == 2) {
            cout << "Intersectia celor doua segmente este vida.\n";
        } else {
            P[1] = A1;
            P[2] = A2;
            P[3] = A3;
            P[4] = A4;

            sort(P + 1, P + 4 + 1, cmp);

            if ((P[1].ind == 1 && P[2].ind == 2) || (P[1].ind == 3 && P[2].ind == 4)) {
                cout << "Intersectia celor doua segmente este vida.\n";
            } else {
                cout << "Intersectia celor doua segmente este: (" << P[2].x << ", " << P[2].y << ") - (" << P[3].x << ", " << P[3].y << ").";
            }
        }
    }

    return 0;
}
