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
    public partial class Form2 : Form
    {
        private int i, n;
        private Puncte[] P;
        private Puncte nowP;

        public Form2(int n)
        {
            InitializeComponent();
            this.n = n;
            i = 1;
            P = new Puncte[n + 1];
        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            Application.Exit();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (i == n + 1)
            {
                try
                {
                    string sX = textBoxX.Text;
                    string sY = textBoxY.Text;
                    if (sX.Length == 0)
                    {
                        MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                        textBoxX.Text = "";
                        return;
                    }
                    if (sY.Length == 0)
                    {
                        MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                        textBoxY.Text = "";
                        return;
                    }

                    double x = Convert.ToDouble(sX);
                    double y = Convert.ToDouble(sY);
                    nowP = new Puncte(x, y);

                    Form3 form3 = new Form3(n, P, nowP);
                    form3.Show();
                    Hide();
                }
                catch
                {
                    MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                    textBoxX.Text = "";
                    textBoxY.Text = "";
                }
            }

            if (i <= n)
            {
                try
                {
                    string sX = textBoxX.Text;
                    string sY = textBoxY.Text;
                    if (sX.Length == 0)
                    {
                        MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                        textBoxX.Text = "";
                        return;
                    }
                    if (sY.Length == 0)
                    {
                        MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                        textBoxY.Text = "";
                        return;
                    }

                    double x = Convert.ToDouble(sX);
                    double y = Convert.ToDouble(sY);
                    P[i] = new Puncte(x, y);

                    if (i < n)
                    {
                        punctLabel.Text = "Punctul " + Convert.ToString(i + 1) + ":";
                    }
                    else
                    {
                        punctLabel.Text = "Punct: ";
                    }
                    textBoxX.Text = "";
                    textBoxY.Text = "";
                    ++i;
                }
                catch
                {
                    MessageBox.Show("Va rugam sa introduceti un numar intre [1, 10^5]!", "Error!");
                    textBoxX.Text = "";
                    textBoxY.Text = "";
                }
            }
        }
    }
}
