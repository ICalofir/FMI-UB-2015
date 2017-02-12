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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
           
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                string s = textBoxN.Text;
                if (s.Length == 0)
                {
                    MessageBox.Show("Va rugam sa introduceti un numar natural intre [3, 10^5]!", "Error!");
                    textBoxN.Text = "";
                    return;
                }
                else
                {
                    if (s[0] == '0' || s[0] == '-')
                    {
                        MessageBox.Show("Va rugam sa introduceti un numar natural intre [3, 10^5]!", "Error!");
                        textBoxN.Text = "";
                        return;
                    }
                }
                int n = Convert.ToInt32(s);
                if (n < 3)
                {
                    MessageBox.Show("Va rugam sa introduceti un numar natural intre [3, 10^5]!", "Error!");
                    textBoxN.Text = "";
                    return;
                }
                Form2 form2 = new Form2(n);
                form2.Show();
                Hide();
            }
            catch
            {
                MessageBox.Show("Va rugam sa introduceti un numar natural intre [3, 10^5]!", "Error!");
                textBoxN.Text = "";
            }
        }
    }
}
