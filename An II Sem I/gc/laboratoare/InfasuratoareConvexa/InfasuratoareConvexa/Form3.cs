using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InfasuratoareConvexa
{
    public partial class Form3 : Form
    {
        private int step = 0;
        private int n;
        private Puncte[] P;
        private Puncte nowP;

        public Form3(int n, Puncte[] P, Puncte nowP)
        {
            InitializeComponent();
            this.n = n;
            this.nowP = new Puncte(nowP.x, nowP.y);
            this.P = new Puncte[this.n + 1];
            for (int i = 1; i <= n; ++i)
            {
                this.P[i] = new Puncte(P[i].x, P[i].y);
            }
        }

        private void Form3_Load(object sender, EventArgs e)
        {

        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            Application.Exit();
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            if (step == 0)
            {
                inPolygon.init(ref n, P, nowP, Bounds.Width, Bounds.Height, this.CreateGraphics());
                ++step;
            }
            else if (step == 1)
            {
                inPolygon.drawDiagonals(n, P, nowP, this.CreateGraphics());
                ++step;
            }
            else if (step == 2)
            {
                MessageBox.Show(inPolygon.solve(n, nowP));
                Application.Restart();
            }
        }
    }
}
