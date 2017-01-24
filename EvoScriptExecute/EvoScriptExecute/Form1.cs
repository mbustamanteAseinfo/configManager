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
        string _conString = "";
        string _directory = "";
        string _evoConfig = "";
        string _evoData = "";
        string _evoTemp = "";
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
            _evoConfig = txtEvoConfig.Text;
            _evoData = txtEvoData.Text;
            _evoTemp = txtEvoTemp.Text;
            var sqlConnectionHelper = new SqlConnectionHelper(_conString);
            string jsonConfig = _directory + "\\mapadeejecucion.json";
            string json = File.ReadAllText(jsonConfig);
            var items = JsonConvert.DeserializeObject<List<Item>>(json);

            var ordered = from c in items orderby c.Posicion select c;
            var orderedEvoConfig = from c in items where c.DataBase == "EvoConfig" orderby c.Posicion select c;
            var orderedEvoTemp = from c in items where c.DataBase == "EvoTemp" orderby c.Posicion select c;

            if (ordered.Count() > 0)
            {

                /*string[] arr = _conString.Split(';');
                var catalog = arr.Select((value, index) => new { Value = value, Index = index }).Where(x => x.Value.Contains("Catalog")).FirstOrDefault();
                string[] dataBase = catalog.Value.Split('=');
                dataBase[1] = _evoData;
                arr[catalog.Index] = string.Join("=", dataBase);
                _conString = string.Join(";", arr);*/
                
                foreach (Item i in ordered)
                {
                    if (i.Ejecutado == "0")
                    {
                        textBox1.Text += "Ejecutando el script " + i.Nombre + "\r\n";
                        var fileInfo = new FileInfo(i.Ruta);
                        string script = fileInfo.OpenText().ReadToEnd();
                        try
                        {
                            if (i.DataBase == "EvoData")
                            {
                                if (sqlConnectionHelper.DatabaseName != _evoData)
                                {
                                    sqlConnectionHelper.DatabaseName = _evoData;
                                }
                            }
                            else
                            {
                                if (i.DataBase == "EvoConfig")
                                {
                                    if (sqlConnectionHelper.DatabaseName != _evoConfig)
                                    {
                                        sqlConnectionHelper.DatabaseName = _evoConfig;
                                    }
                                }
                                else
                                {
                                    if (i.DataBase == "EvoTemp")
                                    {
                                        if (sqlConnectionHelper.DatabaseName != _evoTemp)
                                        {
                                            sqlConnectionHelper.DatabaseName = _evoTemp;
                                        }
                                    }
                                }
                            }
                            sqlConnectionHelper.ExecuteScript(script);
                            i.Ejecutado = "1";
                        }
                        catch (Exception ex)
                        {
                            textBox1.Text += "Error " + ex.Message + " en el script " + i.Nombre + "\r\n";
                            error = true;
                            break;
                        }
                    }
                }
            }
            string nJson = JsonConvert.SerializeObject(ordered, Formatting.Indented);
            string fileToSave = @"C:\Users\mbustamante\Source\Repos\configManager\mapadeejecucion.json";
            if (File.Exists(fileToSave))
            {
                File.Delete(fileToSave);
                File.WriteAllText(fileToSave, nJson);
            }
            else
            {
                File.WriteAllText(fileToSave, nJson);
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
