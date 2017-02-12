using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;

namespace InfasuratoareConvexa
{
    class inPolygon
    {
        private static double eps = 1e-6;
        private static Puncte ldP, p, ldPP;
        private static int W, H;
        private static double maxX, maxY;
        private static Puncte[] PP;

        public static double getEps()
        {
            return eps;
        }

        public static Puncte getLdP()
        {
            return ldP;
        }

        private static void getMaxX(int n, Puncte[] P, Puncte nowP)
        {
            maxX = nowP.x;
            for (int i = 1; i <= n; ++i)
            {
                if (cmp(maxX, Math.Abs(P[i].x)) < 0)
                {
                    maxX = P[i].x;
                }
            }
        }

        private static void getMaxY(int n, Puncte[] P, Puncte nowP)
        {
            maxY = nowP.y;
            for (int i = 1; i <= n; ++i)
            {
                if (cmp(maxY, Math.Abs(P[i].y)) < 0)
                {
                    maxY = P[i].y;
                }
            }
        }

        private static double getArea(Puncte A, Puncte B, Puncte C)
        {
            double s = A.x * B.y - A.y * B.x;
            s += B.x * C.y - B.y * C.x;
            s += C.x * A.y - C.y * A.x;

            return Math.Abs(s);
        }

        private static double det(Puncte A, Puncte B, Puncte C)
        {
            return A.x * B.y + B.x * C.y + C.x * A.y
                   - C.x * B.y - A.x * C.y - B.x * A.y;
        }

        public static double cross_slope(Puncte A, Puncte B, Puncte C)
        {
            return (A.y - B.y) * (A.x - C.x) - (A.y - C.y) * (A.x - B.x);
        }

        public static int cmpPuncte(Puncte A, Puncte B)
        {
            if (A.x - B.x < -getEps())
            {
                return -1;
            }
            else if (A.x - B.x > getEps())
            {
                return 1;
            }
            else
            {
                if (A.y - B.y < -getEps())
                {
                    return -1;
                }
                else if (A.y - B.y > getEps())
                {
                    return 1;
                }
            }

            return 0;
        }

        public static int cmp(double A, double B)
        {
            if (A - B < -getEps())
            {
                return -1;
            }
            else if (A - B > getEps())
            {
                return 1;
            }

            return 0;
        }

        private static void decrease(int n, Puncte[] P)
        {
            double k = maxX / ((double)W - 10);
            if (cmp(maxX / ((double)W - 10), maxY / ((double)H - 10)) < 0)
            {
                k = maxY / ((double)H - 10);
            }

            maxX /= k;
            maxY /= k;

            p.x /= k;
            p.y /= k;
            ldP.x /= k;
            ldP.y /= k;
            for (int i = 1; i <= n; ++i)
            {
                P[i].x /= k;
                P[i].y /= k;
            }
        }

        private static void increase(int n, Puncte[] P)
        {
            double k = ((double)H - 10) / maxY;
            if (cmp(((double)W - 10) / maxX, ((double)H - 10) / maxY) < 0)
            {
                k = ((double)W - 10) / maxX;
            }

            p.x *= k;
            p.y *= k;
            ldP.x *= k;
            ldP.y *= k;
            for (int i = 1; i <= n; ++i)
            {
                P[i].x *= k;
                P[i].y *= k;
                
            }
        }

        private static void translate(int n, Puncte[] P)
        {
            p.x = W + p.x;
            p.y = H - p.y;
            ldP.x = W + ldP.x;
            ldP.y = H - ldP.y;
            for (int i = 1; i <= n; ++i)
            {
                P[i].x = W + P[i].x;
                P[i].y = H - P[i].y;
            }
        }

        private static void drawPolygon(int n, Puncte[] P, Graphics g)
        {
            Brush b = Brushes.Black;
            g.FillRectangle(b, (float)ldP.x, (float)ldP.y, 3, 3);
            for (int i = 1; i <= n; ++i)
            {
                g.FillRectangle(b, (float)P[i].x, (float)P[i].y, 3, 3);
            }

            Pen blackPen = new Pen(Color.Black, 1);
            g.DrawLine(blackPen, (float)ldP.x + 1, (float)ldP.y + 1, (float)P[1].x + 1, (float)P[1].y + 1);
            for (int i = 1; i < n; ++i)
            {
                g.DrawLine(blackPen, (float)P[i].x + 1, (float)P[i].y + 1, (float)P[i + 1].x + 1, (float)P[i + 1].y + 1);
            }
            g.DrawLine(blackPen, (float)P[n].x + 1, (float)P[n].y + 1, (float)ldP.x + 1, (float)ldP.y + 1);

            b = Brushes.Blue;
            g.FillRectangle(b, (float)p.x, (float)p.y, 3, 3);
        }

        public static void drawDiagonals(int n, Puncte[] P, Puncte nowP, Graphics g)
        {
            Pen redPen = new Pen(Color.Red, 1);
            g.DrawLine(redPen, (float)ldP.x + 1, (float)ldP.y + 1, (float)P[1].x + 1, (float)P[1].y + 1);
            for (int i = 1; i < n; ++i)
            {
                g.DrawLine(redPen, (float)ldP.x + 1, (float)ldP.y + 1, (float)P[i].x + 1, (float)P[i].y + 1);
            }
            g.DrawLine(redPen, (float)P[n].x + 1, (float)P[n].y + 1, (float)ldP.x + 1, (float)ldP.y + 1);

            Pen bluePen = new Pen(Color.Blue, 1);
            bluePen.DashStyle = System.Drawing.Drawing2D.DashStyle.DashDot;
            g.DrawLine(bluePen, (float)ldP.x + 1, (float)ldP.y + 1, (float)p.x + 1, (float)p.y + 1);
        }

        public static string solve(int n, Puncte nowP)
        {
            if (Math.Abs(det(ldPP, PP[1], nowP)) < eps)
            {
                return "Punctul se afla pe dreapta determinata de punctele: (" + ldPP.x + ", " + ldPP.y + "), (" +
                       PP[1].x + ", " + PP[1].y + ")!";
            }
            for (int i = 1; i < n; ++i)
            {
                if (Math.Abs(det(PP[i], PP[i + 1], nowP)) < eps)
                {
                    return "Punctul se afla pe dreapta determinata de punctele: (" + PP[i].x + ", " + PP[i].y + "), (" +
                           PP[i + 1].x + ", " + PP[i + 1].y + ")!";
                }
            }
            if (Math.Abs(det(PP[n], ldPP, nowP)) < eps)
            {
                return "Punctul se afla pe dreapta determinata de punctele: (" + PP[n].x + ", " + PP[n].y + "), (" +
                       ldPP.x + ", " + ldPP.y + ")!";
            }

            int lt = 0, rt = n + 1;
            while (rt - lt > 1)
            {
                int mid = (lt + rt) / 2;
                double cs = cross_slope(ldPP, nowP, PP[mid]);
                if (cs < -getEps())
                {
                    rt = mid;
                }
                else
                {
                    lt = mid;
                }
            }

            if (lt == 0 || rt == n + 1)
            {
                return "Punctul se afla in exteriorul poligonului!";
            }

            double t1 = getArea(ldPP, nowP, PP[lt]);
            double t2 = getArea(PP[lt], nowP, PP[rt]);
            double t3 = getArea(PP[rt], nowP, ldPP);
            double t = getArea(ldPP, PP[lt], PP[rt]);
            if (Math.Abs(t1 + t2 + t3 - t) < eps)
            {
                return "Punctul se afla in interiorul poligonului";
            }

            return "Punctul se afla in exteriorul poligonului!";
        }

        public static void init(ref int n, Puncte[] P, Puncte nowP, int new_W, int new_H, Graphics g)
        {
            W = new_W / 2 - 7;
            H = new_H / 2 - 33;
            getMaxX(n, P, nowP);
            getMaxY(n, P, nowP);

            int pos = 1;
            ldP = P[1];
            for (int i = 2; i <= n; ++i)
            {
                if (cmpPuncte(P[i], ldP) < 0)
                {
                    pos = i;
                    ldP = P[i];
                }
            }
            ldPP = new Puncte(ldP.x, ldP.y);
            p = new Puncte(nowP.x, nowP.y);

            for (int i = pos; i < n; ++i)
            {
                P[i] = P[i + 1];
            }
            --n;

            Array.Sort(P, 1, n, new cmpSlope());

            PP = new Puncte[n + 1];
            for (int i = 1; i <= n; ++i)
            {
                PP[i] = new Puncte(P[i].x, P[i].y);
            }

            if (maxX > W || maxY > H)
            {
                decrease(n, P);
            }
            else
            {
                increase(n, P);
            }
            translate(n, P);
            drawPolygon(n, P, g);

            /*
            Pen blackPen = new Pen(Color.Black, 1);
            g.DrawLine(blackPen, W, 0, W, H);
            g.DrawLine(blackPen, W, 2 * H, W, H);
            g.DrawLine(blackPen, 0, H, W, H);
            g.DrawLine(blackPen, 2 * W, H, W, H);
            */
        }
    }

    public class cmpSlope : IComparer<Puncte>
    {
        public int Compare(Puncte A, Puncte B)
        {
            double cs = inPolygon.cross_slope(inPolygon.getLdP(), A, B);
            if (cs < -inPolygon.getEps())
            {
                return -1;
            }
            else if (cs > inPolygon.getEps())
            {
                return 1;
            }

            return 0;
        }
    }
}
