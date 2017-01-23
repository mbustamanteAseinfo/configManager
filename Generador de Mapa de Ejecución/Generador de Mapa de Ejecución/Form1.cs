using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Generador_de_Mapa_de_Ejecución
{
    public partial class Form1 : Form
    {
        string directorio;
        
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == DialogResult.OK) {
                textBox1.Text = "Ruta: " + folderBrowserDialog.SelectedPath;
                directorio = folderBrowserDialog.SelectedPath;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            List<Item> iList = new List<Item>();
            ProcessDirectory(directorio, "0", iList);
            string json = JsonConvert.SerializeObject(iList, Formatting.Indented);
            string fileToSave = directorio + "\\mapadeejecucion.json";
            if (File.Exists(fileToSave)) {
                File.Delete(fileToSave);
                File.WriteAllText(fileToSave, json);
            } else {
                File.WriteAllText(fileToSave, json);
            }
            MessageBox.Show("Proceso finalizado con exito. Encontrara el mapa de ejecución en la ruta " + fileToSave);

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
                    nItem.Path = f.FullName;
                    nItem.Daddy = dadStep.Replace(' ', '.') + f.Name.Split('-')[0].Trim().ToString();
                    nItem.Step = f.Name.Split('-')[0].Trim().ToString();
                    nItem.Necesary = "1";
                    nItem.ScriptName = f.Name;
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
    }
}
