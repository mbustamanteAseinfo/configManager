using Microsoft.Data.ConnectionUI;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json;
using System.IO;

namespace EvoScriptExecute
{
    public partial class Form1 : Form
    {
        string _conString;
        string _directory;
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DataConnectionDialog dcd = new DataConnectionDialog();
            DataSource.AddStandardDataSources(dcd);
           
            if (DataConnectionDialog.Show(dcd) == DialogResult.OK)
            {
                _conString = dcd.ConnectionString;

            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                _directory = folderBrowserDialog.SelectedPath;
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            button3.Text = "Iniciado";
            button3.Enabled = false;
            bool error = false;
            var sqlConnectionHelper = new SqlConnectionHelper(_conString);
            string jsonConfig = _directory + "\\mapadeejecucion.json";
            string json = File.ReadAllText(jsonConfig);
            var items = JsonConvert.DeserializeObject<List<Item>>(json);

            var ordered = from c in items orderby c.Daddy select c;

            foreach (Item i in ordered)
            {
                textBox1.Text += "Ejecutando el script " + i.ScriptName + "\r\n";
                var fileInfo = new FileInfo(i.Path);
                string script = fileInfo.OpenText().ReadToEnd();
                try
                {
                    sqlConnectionHelper.ExecuteScript(script);
                }
                catch (Exception ex)
                {
                    textBox1.Text += "Error " + ex.Message + " en el script " + i.ScriptName + "\r\n";
                    error = true;
                    break;
                }
            }

            if (error)
            {
                textBox2.Text = "Ejecución no finalizada";
            }
            else
            {
                textBox2.Text = "Ejecución finalizada con exito";
            }

            button3.Text = "Finalizado";
        }
    }
}
