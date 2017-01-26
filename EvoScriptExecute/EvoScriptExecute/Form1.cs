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
        string directorio = "";
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

        private void button5_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                textBox1.Text = "Ruta: " + folderBrowserDialog.SelectedPath;
                directorio = folderBrowserDialog.SelectedPath;
            }
        }


        private void ProcessDirectory(string targetDirectory, string dadStep, List<Item> iList)
        {
            DirectoryInfo source = new DirectoryInfo(targetDirectory);
            DirectoryInfo[] directoryEntries = source.GetDirectories();
            FileInfo[] fileEntries = source.GetFiles();

            if (fileEntries.Length > 0)
            {
                foreach (FileInfo f in fileEntries)
                {
                    Item nItem = new Item();
                    nItem.Ruta = f.FullName;
                    nItem.Posicion = dadStep.Replace(' ', '.') + f.Name.Split('-')[0].Trim().ToString();
                    nItem.Paso = f.Name.Split('-')[0].Trim().ToString();
                    nItem.Necesario = "1";
                    nItem.Nombre = f.Name;
                    nItem.DataBase = f.Name.Split('-')[1].Trim().ToString();
                    nItem.Ejecutado = "0";
                    iList.Add(nItem);
                }
            }
            if (directoryEntries.Length > 0)
            {
                foreach (DirectoryInfo dinf in directoryEntries)
                {

                    ProcessDirectory(dinf.FullName, joinParent(dinf), iList);
                }
            }
        }

        private string joinParent(DirectoryInfo path)
        {
            string superDad = "";
            if (path.Parent.Name.Split('-').Length > 1)
            {
                superDad += joinParent(path.Parent);
                superDad += path.Name.Split('-')[0];
            }
            else
            {
                superDad += path.Name.Split('-')[0];

            }
            return superDad;
        }

        private void btnGenerarME_Click(object sender, EventArgs e)
        {

            List<Item> iList = new List<Item>();
            ProcessDirectory(directorio, "0", iList);
            string json = JsonConvert.SerializeObject(iList, Formatting.Indented);
            string fileToSave = @"C:\Users\mbustamante\Source\Repos\configManager\mapadeejecucion.json";
            if (File.Exists(fileToSave))
            {
                File.Delete(fileToSave);
                File.WriteAllText(fileToSave, json);
            }
            else
            {
                File.WriteAllText(fileToSave, json);
            }
            MessageBox.Show("Proceso finalizado con exito. Encontrara el mapa de ejecución en la ruta " + fileToSave);

        }
    }
}
