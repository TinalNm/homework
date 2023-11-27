using System;
using System.Collections.Generic;
using System.ComponentModel;
using MySql.Data.MySqlClient;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WareHouseManagSys
{
    public partial class Form2 : Form
    {
        public Form1 f1;
        public static string Str = @"Server=localhost; Port=3306; Database=studb; Uid=root; Pwd=9188821929; CharSet=utf8;";
        public int choice;
        public int InOutStatus;
        public Form2()
        {
            InitializeComponent();
            choice = 0;
            InOutStatus = 0;
            f1 = Program.f1;
        }



        private void button1_Click(object sender, EventArgs e)
        {
            string sql = "SELECT 库存.货物号, 货物.货物名称, 货物.货物类型, 库存.仓库号, 库存.库存量, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);

        }

        private void button2_Click(object sender, EventArgs e)
        {
            string cangku = textBox1.Text;
            string sql = "SELECT 库存.货物号, 货物.货物名称, 货物.货物类型, 库存.仓库号, 库存.库存量, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号 " +
                        "WHERE 库存.仓库号 = @cangku";
            MySqlParameter[] p =
            {
               new MySqlParameter("@cangku", MySqlDbType.VarChar,5){Value=cangku}
            };
            MessageBox.Show("Executing query: " + sql + " with cangku = " + cangku);
            MySqlFunc(p, sql);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string huowu = textBox2.Text;
            string sql = "SELECT 库存.货物号, 库存.库存量, 货物.货物名称, 仓库.仓库名称, 仓库.地址, 供应商.电话, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 仓库 ON 库存.仓库号 = 仓库.仓库号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号 " +
                        "WHERE 库存.货物号 = @huowu";
            MySqlParameter[] p =
            {
               new MySqlParameter("@huowu", MySqlDbType.VarChar,5){Value=huowu}
            };
            MessageBox.Show("Executing query: " + sql + " with cangku = " + huowu);
            MySqlFunc(p, sql);

        }

        private void button4_Click(object sender, EventArgs e)
        {
            string sql = "SELECT 库存.货物号, 库存.库存量, 货物.货物名称, 仓库.仓库名称, 仓库.地址, 供应商.电话, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 仓库 ON 库存.仓库号 = 仓库.仓库号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);

        }


        //通用方法
        private void MySqlFunc(MySqlParameter[] p, string sql)
        {
            try
            {
                MySqlConnection thisConnect = new MySqlConnection(Str);
                thisConnect.Open();
                MessageBox.Show("Database connection opened.");

                MySqlDataAdapter sda = new MySqlDataAdapter(sql, thisConnect);
                sda.SelectCommand.CommandType = CommandType.Text;
                sda.SelectCommand.Parameters.AddRange(p);

                DataSet ds = new DataSet();
                sda.Fill(ds);

                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    MessageBox.Show("Data retrieved: " + dt.Rows.Count + " rows.");
                    this.dataGridView1.DataSource = dt;
                }
                else
                {
                    MessageBox.Show("No data retrieved from the database.");
                }

                thisConnect.Close();
                MessageBox.Show("Database connection closed.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error occurred: " + ex.Message);
            }
        }

        //查询所有货物
        private void button5_Click(object sender, EventArgs e)
        {
            string sql = "SELECT 货物.货物号, 货物.货物名称, 货物.货物类型, 货物.供应商编号, 供应商.电话, 供应商.姓名 " +
                        "FROM 货物 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);
            dataGridView1.Columns["btnDelete"].Visible = false;
        }
        //查询货物
        private void button6_Click(object sender, EventArgs e)
        {
            string huowu = "%" + textBox4.Text + "%"; // 获取输入的文本并添加通配符
            string sql = "SELECT 货物.货物号, 货物.货物名称, 货物.货物类型, 货物.供应商编号, 供应商.电话, 供应商.姓名 " +
                         "FROM 货物 " +
                         "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号 " +
                         "WHERE 货物.货物名称 LIKE @huowu OR 货物.货物拼音 LIKE @huowu"; // 匹配名称或拼音
            MySqlParameter[] p =
            {
               new MySqlParameter("@huowu", MySqlDbType.VarChar,5){Value=huowu}
            };
            MessageBox.Show("Executing query: " + sql + " with cangku = " + huowu);
            MySqlFunc(p, sql);
        }




        //查询所有出入库信息--按钮ALL
        private void button7_Click(object sender, EventArgs e)
        {
            choice = 0;
            this.comboBox1.Text = "";
        }

        //入库单号查询
        private void button9_Click(object sender, EventArgs e)
        {
            if (this.comboBox2.Text.Equals("入库")) InOutStatus = 1;
            else InOutStatus = 0;
            choice = 1;
            this.comboBox1.Text = "";
            comBoxShow();
        }

        //将结果放入comboBox供选择
        private void comBoxShow()
        {
            string sql = "SELECT column FROM 货物 WHERE 货物号 = @in AND 货物名称 = @status";
            MySqlConnection thisConnect = new MySqlConnection(Str);
            MySqlCommand s = new MySqlCommand(sql, thisConnect);
            s.CommandType = CommandType.Text;
            s.Parameters.AddWithValue("@in", InOutStatus);
            s.Parameters.AddWithValue("@status", choice);
            thisConnect.Open();
            MySqlDataReader sr = s.ExecuteReader();
            this.comboBox1.Items.Clear();
            while (sr.Read())
            {
                this.comboBox1.Items.Add(sr[0].ToString());
            }
            thisConnect.Close();
        }

        //最终查询出入库按钮1
        private void button12_Click(object sender, EventArgs e)
        {
            string sql = "SELECT 货物.货物号, 货物.货物名称, 货物.货物类型, 货物.供应商编号, 供应商.电话, 供应商.姓名 " +
                        "FROM 货物 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);
        }
        //仓库查询
        private void button10_Click(object sender, EventArgs e)
        {
            if (this.comboBox2.Text.Equals("入库")) InOutStatus = 1;
            else InOutStatus = 0;
            choice = 2;
            this.comboBox1.Text = "";
            comBoxShow();
        }
        //按时间
        private void button11_Click(object sender, EventArgs e)
        {
            if (this.comboBox2.Text.Equals("入库")) InOutStatus = 1;
            else InOutStatus = 0;
            choice = 3;
            this.comboBox1.Text = "";
            comBoxShow();
        }

        //入库提交按钮
        private void button22_Click(object sender, EventArgs e)
        {
            string sql = "INSERT INTO 临时表 (货物名, 货物数量,仓库号) VALUES (@huowu, @num,@cangku)";
            MySqlParameter[] parameters = new MySqlParameter[]
            {   
                new MySqlParameter("@cangku", MySqlDbType.VarChar) { Value = textBox3.Text },
                new MySqlParameter("@num", MySqlDbType.Int32) { Value = textBox20.Text },
                new MySqlParameter("@huowu", MySqlDbType.VarChar) { Value = textBox6.Text }
            };
            MySqlFunc(parameters, sql);
            string sql_1 = "SELECT 货物名, 货物数量, 仓库号 FROM 临时表";
            MessageBox.Show("Executing query: " + sql_1);
            MySqlFunc(new MySqlParameter[0], sql_1);
            dataGridView1.Columns["btnDelete"].Visible = true;
        }

        //出库提交按钮
        private void button18_Click(object sender, EventArgs e)
        {
            string sql = "out_proc";
            SqlConnection thisConnect = new SqlConnection(Str);
            SqlCommand s = new SqlCommand(sql, thisConnect);
            s.CommandType = CommandType.StoredProcedure;
            s.Parameters.AddWithValue("@cangku", this.textBox8.Text);
            s.Parameters.AddWithValue("@huowu", this.textBox10.Text);
            s.Parameters.AddWithValue("@num", this.textBox11.Text);
            s.Parameters.AddWithValue("@kehu", this.textBox12.Text);
            s.Parameters.AddWithValue("@admin", f1.textBox1.Text);
            SqlParameter par = s.Parameters.Add("@status", SqlDbType.Int);  //定义输出参数
            par.Direction = ParameterDirection.Output;  //参数类型为Output
            thisConnect.Open();
            s.ExecuteNonQuery();
            if ((int)par.Value == 1) MessageBox.Show("货物不在所选仓库！");
            if ((int)par.Value == 2) MessageBox.Show("库存不足！");
            if ((int)par.Value == 3) MessageBox.Show("出库成功！");
            if ((int)par.Value == 4) MessageBox.Show("无此仓库！");
            thisConnect.Close();
        }

  

        //查询
        private void button21_Click(object sender, EventArgs e)
        {
            choice = 4;
            string sql = "selectJieH_proc";
            MySqlParameter[] p =
            {
        new MySqlParameter("@jie", MySqlDbType.Int32) { Value = choice },
    };
            MySqlFunc(p, sql);
        }

 
        private void tabControl3_Selecting(object sender, TabControlCancelEventArgs e)
        {
            this.panel1.Hide();
        }

        private void button28_Click(object sender, EventArgs e)
        {
            this.panel1.Show();
            choice = 1;
            this.textBox13.Text = this.textBox18.Text = this.textBox19.Text = "";
        }

        //确认
        private void button27_Click(object sender, EventArgs e)
        {
            string sql = "admin_proc";
            SqlConnection thisConnect = new SqlConnection(Str);
            SqlCommand s = new SqlCommand(sql, thisConnect);
            s.CommandType = CommandType.StoredProcedure;
            s.Parameters.AddWithValue("@choice", choice);
            s.Parameters.AddWithValue("@num", this.textBox13.Text);
            s.Parameters.AddWithValue("@name", this.textBox18.Text);
            s.Parameters.AddWithValue("@pws", this.textBox19.Text);
            SqlParameter par = s.Parameters.Add("@status", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            thisConnect.Open();
            s.ExecuteNonQuery();
            if ((int)par.Value == 0) MessageBox.Show("添加成功！");
            if ((int)par.Value == 1) MessageBox.Show("修改成功！");
            if ((int)par.Value == 2) MessageBox.Show("删除成功！");
            if ((int)par.Value == 3) MessageBox.Show("操作无效！");
            if ((int)par.Value == 4) MessageBox.Show("默认管理员禁止删除！");
            this.panel1.Hide();
        }

        private void button29_Click(object sender, EventArgs e)
        {
            this.panel1.Show();
            choice = 2;
            this.textBox13.Text = this.textBox18.Text = this.textBox19.Text = "";
        }

        private void button30_Click(object sender, EventArgs e)
        {
            this.panel1.Show();
            choice = 3;
            this.textBox13.Text = this.textBox18.Text = this.textBox19.Text = "";
        }

        //查询
        private void button26_Click(object sender, EventArgs e)
        {
            string sql = "select * from 管理员";
            SqlConnection thisConnect = new SqlConnection(Str);
            thisConnect.Open();
            SqlDataAdapter sda = new SqlDataAdapter(sql, thisConnect);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            DataTable dt = ds.Tables[0];
            this.dataGridView1.DataSource = dt;
            thisConnect.Close();
        }

        //查看设置
        private void button31_Click(object sender, EventArgs e)
        {
            string sql = "select * from 库存设置";
            SqlConnection thisConnect = new SqlConnection(Str);
            thisConnect.Open();
            SqlDataAdapter sda = new SqlDataAdapter(sql, thisConnect);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            DataTable dt = ds.Tables[0];
            this.dataGridView1.DataSource = dt;
            thisConnect.Close();
        }


        //修改设置确认按钮
        private void button33_Click(object sender, EventArgs e)
        {
            string sql = "alterkucun_proc";
            SqlConnection thisConnect = new SqlConnection(Str);
            SqlCommand s = new SqlCommand(sql, thisConnect);
            s.CommandType = CommandType.StoredProcedure;

            SqlParameter par = s.Parameters.Add("@status", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            thisConnect.Open();
            s.ExecuteNonQuery();
            if ((int)par.Value == 0) MessageBox.Show("修改成功！");
            if ((int)par.Value == 1) MessageBox.Show("请选择仓库和货物！");
            this.panel1.Hide();
        }
        //注销
        private void button35_Click(object sender, EventArgs e)
        {
            f1.Show();
            this.Close();
        }

        //退出
        private void button34_Click(object sender, EventArgs e)
        {
            this.Close();
            f1.Close();
        }

        //仓库信息
        private void button36_Click(object sender, EventArgs e)
        {
            string sql = "select * from 仓库";
            SqlConnection thisConnect = new SqlConnection(Str);
            thisConnect.Open();
            SqlDataAdapter sda = new SqlDataAdapter(sql, thisConnect);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            DataTable dt = ds.Tables[0];
            this.dataGridView1.DataSource = dt;
            thisConnect.Close();
        }

        private void button37_Click(object sender, EventArgs e)
        {
            string orderNumber = Guid.NewGuid().ToString();

            // 复制临时表的货物号和仓库号到"入库"表的相应列，并为每一行设置相同的订单编号
            // 因为入库要满足各种编号的要求，各编号生成条件如下，
            // 货物号生成规则：每当一个货物进入表时，与已有的货物进行对比，如果没有该货物数据，则自动生成新编号
            // 订单编号生成规则 ： 每次入库时，给予同时入库的所有货物相同唯一的订单编号
            string sqlCopy = $"INSERT INTO 入库 (订单编号, 货物名, 仓库号，货物数量) SELECT '{orderNumber}', 货物名, 仓库号，货物数量 FROM 临时表";
            MySqlFunc(new MySqlParameter[0], sqlCopy);

            // 删除临时表的内容
            string sqlDelete = "DELETE FROM 临时表";
            MySqlFunc(new MySqlParameter[0], sqlDelete);

            // 重新查询数据并刷新显示
            string sqlSelect = "SELECT * FROM 临时表";
            MySqlFunc(new MySqlParameter[0], sqlSelect);
        }
        //删除
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            var senderGrid = (DataGridView)sender;

            if (senderGrid.Columns[e.ColumnIndex] is DataGridViewButtonColumn && e.RowIndex >= 0)
            {
                dataGridView1.Rows.RemoveAt(e.RowIndex);
            }
        }
        private void Form2_FormClosing(object sender, FormClosingEventArgs e)
        {
            f1.Close();
        }

        private void tabPage9_Click(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox5_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }

        private void button8_Click_1(object sender, EventArgs e)
        {
            string sql = "SELECT 库存.货物号, 货物.货物名称, 货物.货物类型, 库存.仓库号, 库存.库存量, 供应商.姓名 " +
            "FROM 库存 " +
            "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
            "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);
            dataGridView1.Columns["btnDelete"].Visible = false;
        }

        private void button14_Click_1(object sender, EventArgs e)
        {
            string cangku = textBox5.Text;
            string sql = "SELECT 库存.货物号, 货物.货物名称, 货物.货物类型, 库存.仓库号, 库存.库存量, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号 " +
                        "WHERE 库存.仓库号 = @cangku";
            MySqlParameter[] p =
            {
               new MySqlParameter("@cangku", MySqlDbType.VarChar,5){Value=cangku}
            };
            MessageBox.Show("Executing query: " + sql + " with cangku = " + cangku);
            MySqlFunc(p, sql);
        }

        private void button13_Click_1(object sender, EventArgs e)
        {
            string sql = "SELECT 库存.货物号, 库存.库存量, 货物.货物名称, 仓库.仓库名称, 仓库.地址, 供应商.电话, 供应商.姓名 " +
            "FROM 库存 " +
            "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
            "INNER JOIN 仓库 ON 库存.仓库号 = 仓库.仓库号 " +
            "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号";
            MessageBox.Show("Executing query: " + sql);
            MySqlFunc(new MySqlParameter[0], sql);
        }

        private void button15_Click_1(object sender, EventArgs e)
        {
            string huowu = textBox7.Text;
            string sql = "SELECT 库存.货物号, 库存.库存量, 货物.货物名称, 仓库.仓库名称, 仓库.地址, 供应商.电话, 供应商.姓名 " +
                        "FROM 库存 " +
                        "INNER JOIN 货物 ON 库存.货物号 = 货物.货物号 " +
                        "INNER JOIN 仓库 ON 库存.仓库号 = 仓库.仓库号 " +
                        "INNER JOIN 供应商 ON 货物.供应商编号 = 供应商.供应商编号 " +
                        "WHERE 库存.货物号 = @huowu";
            MySqlParameter[] p =
            {
               new MySqlParameter("@huowu", MySqlDbType.VarChar,5){Value=huowu}
            };
            MessageBox.Show("Executing query: " + sql + " with cangku = " + huowu);
            MySqlFunc(p, sql);
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }
    }
}



