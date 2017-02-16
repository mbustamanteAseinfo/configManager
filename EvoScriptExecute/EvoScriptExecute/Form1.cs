using Microsoft.Data.ConnectionUI;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
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
        List<Item> scriptsList;
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
                if (!File.Exists(_directory + "\\mapadeejecucion.json")) {
                    MessageBox.Show("El directorio no contiene el mapa de ejecución(mapadeejecución.json)");
                    _directory = "";
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (_directory.Length > 0)
            {
                if (_conString.Length > 0)
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
                                string script = File.ReadAllText(fileInfo.FullName, Encoding.GetEncoding("iso-8859-1"));
                                string scriptutf8 = File.ReadAllText(fileInfo.FullName, Encoding.UTF8);
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
                                    if (script.Contains("Ã"))
                                    {
                                        sqlConnectionHelper.ExecuteScript(scriptutf8);
                                    }
                                    else {
                                        sqlConnectionHelper.ExecuteScript(script);

                                    }
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
                    string fileToSave = _directory + @"\mapadeejecucion.json";
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
                else {
                    MessageBox.Show("Debe seleccionar una base de datos.");
                }
            }
            else {
                MessageBox.Show("Debe seleccionar la ruta del mapa de ejecución(mapadeejecucion.json)");
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                textBox3.Text = "Ruta: " + folderBrowserDialog.SelectedPath;
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
                    if (f.Extension == ".sql") {
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
            if (directorio.Length > 0)
            {
                List<Item> iList = new List<Item>();
                ProcessDirectory(directorio, "0", iList);
                string json = JsonConvert.SerializeObject(iList, Formatting.Indented);
                string fileToSave = directorio + "\\mapadeejecucion.json";
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
            else {
                MessageBox.Show("Debe seleccionar la ruta donde se encuentra el folder estructurado que contiene los scripts.");
            }

        }

        private void btnLimpiar_Click(object sender, EventArgs e)
        {
            _conString = "";
            _directory = "";
            _evoConfig = "";
            _evoData = "";
            _evoTemp = "";
            directorio = "";
            button3.Text = "Ejecutar";
            button3.Enabled = true;
            textBox1.Text = "";
            textBox2.Text = "";
        }

        private void populateCheckBoxList() {
            string jsonConfig = _directory + "\\mapadeejecucion.json";
            string json = File.ReadAllText(jsonConfig);
            scriptsList = JsonConvert.DeserializeObject<List<Item>>(json);

            foreach (Item i in scriptsList)
            {
                checkedListBox1.Items.Add(i, i.Ejecutado == "0" ? false : true);
            }
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedIndex == 2) {
                if (_directory != "")
                {

                    populateCheckBoxList();
                }
            }   
        }

        private void btnFolderScripts_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {

                _directory = folderBrowserDialog.SelectedPath;
                if (!File.Exists(_directory + "\\mapadeejecucion.json"))
                {
                    MessageBox.Show("El directorio no contiene el mapa de ejecución(mapadeejecución.json)");
                    _directory = "";
                }
                else {
                    populateCheckBoxList();
                }
            }
        }

        private void checkedListBox1_Click(object sender, EventArgs e)
        {
            Item i = (Item)checkedListBox1.SelectedItem;
            checkedListBox1.SetItemChecked(checkedListBox1.SelectedIndex, checkedListBox1.GetItemCheckState(checkedListBox1.SelectedIndex) == CheckState.Checked ? false : true);
            MessageBox.Show(i.Nombre);
            
        }

        private void btnUncheck_Click(object sender, EventArgs e)
        {
            
        }
    }
}
