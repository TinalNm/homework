// FILEPATH: /c:/Users/89823/Desktop/WareHouseManagSys-master/应用程序C#/WareHouseManagSys/WareHouseManagSys/Form1.cs
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using MySql.Data.MySqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WareHouseManagSys
{
    public partial class Form1 : Form
    {
        public static string thisStr = @"Server=localhost; Port=3306; Database=studb; Uid=root; Pwd=9188821929; CharSet=utf8;";

        public Form1()
        {
            InitializeComponent();
        }

        //登陆
        private void button2_Click(object sender, EventArgs e)
        {
            MySqlConnection thisConnect = new MySqlConnection(thisStr);
            string sql = "SELECT 密码 FROM 管理员 WHERE 用户名 = @user";
            MySqlCommand cmd = new MySqlCommand(sql, thisConnect);
            cmd.Parameters.AddWithValue("@user", textBox1.Text);
            thisConnect.Open();
            object result = cmd.ExecuteScalar();
            if (result == null)
            {
                MessageBox.Show("账号不存在！请重新输入");
            }
            else if (result.ToString() != textBox2.Text)
            {
                MessageBox.Show("密码错误！请重新输入");
            }
            else
            {
                //MessageBox.Show("登陆成功！");
                this.Hide();
                Form2 f2 = new Form2();
                f2.Show();
            }
            thisConnect.Close();
            thisConnect.Dispose();
        }
    }
}