﻿namespace EvoScriptExecute
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtEvoData = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtEvoConfig = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtEvoTemp = new System.Windows.Forms.TextBox();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.btnLimpiar = new System.Windows.Forms.Button();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.btnGenerarME = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.btnSFolderME = new System.Windows.Forms.Button();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.btnUncheck = new System.Windows.Forms.Button();
            this.btnFolderScripts = new System.Windows.Forms.Button();
            this.checkedListBox1 = new System.Windows.Forms.CheckedListBox();
            this.btnFolderReportes = new System.Windows.Forms.Button();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage3.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(417, 33);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(100, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "Conexión";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(25, 140);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(492, 207);
            this.textBox1.TabIndex = 1;
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(293, 114);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(224, 20);
            this.textBox2.TabIndex = 2;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(26, 33);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(156, 23);
            this.button2.TabIndex = 3;
            this.button2.Text = "Folder Scripts y Reportes";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(212, 112);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 4;
            this.button3.Text = "Ejecutar";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(24, 90);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(52, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "EvoData:";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // txtEvoData
            // 
            this.txtEvoData.Location = new System.Drawing.Point(82, 87);
            this.txtEvoData.Name = "txtEvoData";
            this.txtEvoData.Size = new System.Drawing.Size(100, 20);
            this.txtEvoData.TabIndex = 6;
            this.txtEvoData.Text = "EvoData";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(184, 90);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(59, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "EvoConfig:";
            // 
            // txtEvoConfig
            // 
            this.txtEvoConfig.Location = new System.Drawing.Point(249, 86);
            this.txtEvoConfig.Name = "txtEvoConfig";
            this.txtEvoConfig.Size = new System.Drawing.Size(100, 20);
            this.txtEvoConfig.TabIndex = 8;
            this.txtEvoConfig.Text = "EvoConfig";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(355, 89);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(56, 13);
            this.label3.TabIndex = 9;
            this.label3.Text = "EvoTemp:";
            // 
            // txtEvoTemp
            // 
            this.txtEvoTemp.Location = new System.Drawing.Point(417, 86);
            this.txtEvoTemp.Name = "txtEvoTemp";
            this.txtEvoTemp.Size = new System.Drawing.Size(100, 20);
            this.txtEvoTemp.TabIndex = 10;
            this.txtEvoTemp.Text = "EvoTemp";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage3);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(-5, -2);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(555, 385);
            this.tabControl1.SizeMode = System.Windows.Forms.TabSizeMode.FillToRight;
            this.tabControl1.TabIndex = 12;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tabPage1
            // 
            this.tabPage1.BackColor = System.Drawing.SystemColors.Control;
            this.tabPage1.Controls.Add(this.btnFolderReportes);
            this.tabPage1.Controls.Add(this.btnLimpiar);
            this.tabPage1.Controls.Add(this.button2);
            this.tabPage1.Controls.Add(this.txtEvoTemp);
            this.tabPage1.Controls.Add(this.button1);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Controls.Add(this.textBox1);
            this.tabPage1.Controls.Add(this.txtEvoConfig);
            this.tabPage1.Controls.Add(this.textBox2);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.button3);
            this.tabPage1.Controls.Add(this.txtEvoData);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Size = new System.Drawing.Size(547, 359);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Ejecutar Scripts";
            // 
            // btnLimpiar
            // 
            this.btnLimpiar.Location = new System.Drawing.Point(212, 3);
            this.btnLimpiar.Name = "btnLimpiar";
            this.btnLimpiar.Size = new System.Drawing.Size(75, 23);
            this.btnLimpiar.TabIndex = 11;
            this.btnLimpiar.Text = "Limpiar";
            this.btnLimpiar.UseVisualStyleBackColor = true;
            this.btnLimpiar.Click += new System.EventHandler(this.btnLimpiar_Click);
            // 
            // tabPage3
            // 
            this.tabPage3.BackColor = System.Drawing.SystemColors.Control;
            this.tabPage3.Controls.Add(this.textBox3);
            this.tabPage3.Controls.Add(this.btnGenerarME);
            this.tabPage3.Controls.Add(this.label4);
            this.tabPage3.Controls.Add(this.btnSFolderME);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Size = new System.Drawing.Size(547, 307);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Mapa de Ejecución";
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(107, 42);
            this.textBox3.Name = "textBox3";
            this.textBox3.ReadOnly = true;
            this.textBox3.Size = new System.Drawing.Size(330, 20);
            this.textBox3.TabIndex = 8;
            // 
            // btnGenerarME
            // 
            this.btnGenerarME.Location = new System.Drawing.Point(443, 40);
            this.btnGenerarME.Name = "btnGenerarME";
            this.btnGenerarME.Size = new System.Drawing.Size(75, 23);
            this.btnGenerarME.TabIndex = 7;
            this.btnGenerarME.Text = "Generar";
            this.btnGenerarME.UseVisualStyleBackColor = true;
            this.btnGenerarME.Click += new System.EventHandler(this.btnGenerarME_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(26, 10);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(248, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Seleccionar la ruta donde se encuentran los scripts";
            // 
            // btnSFolderME
            // 
            this.btnSFolderME.Location = new System.Drawing.Point(26, 40);
            this.btnSFolderME.Name = "btnSFolderME";
            this.btnSFolderME.Size = new System.Drawing.Size(75, 23);
            this.btnSFolderME.TabIndex = 5;
            this.btnSFolderME.Text = "Folder";
            this.btnSFolderME.UseVisualStyleBackColor = true;
            this.btnSFolderME.Click += new System.EventHandler(this.button5_Click);
            // 
            // tabPage2
            // 
            this.tabPage2.BackColor = System.Drawing.SystemColors.Control;
            this.tabPage2.Controls.Add(this.btnUncheck);
            this.tabPage2.Controls.Add(this.btnFolderScripts);
            this.tabPage2.Controls.Add(this.checkedListBox1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(547, 307);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Scripts";
            // 
            // btnUncheck
            // 
            this.btnUncheck.Location = new System.Drawing.Point(386, 7);
            this.btnUncheck.Name = "btnUncheck";
            this.btnUncheck.Size = new System.Drawing.Size(143, 23);
            this.btnUncheck.TabIndex = 7;
            this.btnUncheck.Text = "Volver ejecución 0 a todos";
            this.btnUncheck.UseVisualStyleBackColor = true;
            this.btnUncheck.Click += new System.EventHandler(this.btnUncheck_Click);
            // 
            // btnFolderScripts
            // 
            this.btnFolderScripts.Location = new System.Drawing.Point(13, 7);
            this.btnFolderScripts.Name = "btnFolderScripts";
            this.btnFolderScripts.Size = new System.Drawing.Size(75, 23);
            this.btnFolderScripts.TabIndex = 6;
            this.btnFolderScripts.Text = "Folder";
            this.btnFolderScripts.UseVisualStyleBackColor = true;
            this.btnFolderScripts.Click += new System.EventHandler(this.btnFolderScripts_Click);
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Location = new System.Drawing.Point(13, 36);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(516, 259);
            this.checkedListBox1.TabIndex = 0;
            this.checkedListBox1.Click += new System.EventHandler(this.checkedListBox1_Click);
            // 
            // btnFolderReportes
            // 
            this.btnFolderReportes.Location = new System.Drawing.Point(187, 33);
            this.btnFolderReportes.Name = "btnFolderReportes";
            this.btnFolderReportes.Size = new System.Drawing.Size(224, 23);
            this.btnFolderReportes.TabIndex = 12;
            this.btnFolderReportes.Text = "Folder Para Almacenar Reportes";
            this.btnFolderReportes.UseVisualStyleBackColor = true;
            this.btnFolderReportes.Click += new System.EventHandler(this.btnFolderReportes_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(540, 379);
            this.Controls.Add(this.tabControl1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "Form1";
            this.Text = "Ejecución de Scripts";
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtEvoData;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtEvoConfig;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtEvoTemp;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.Button btnGenerarME;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnSFolderME;
        private System.Windows.Forms.Button btnLimpiar;
        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Button btnFolderScripts;
        private System.Windows.Forms.Button btnUncheck;
        private System.Windows.Forms.Button btnFolderReportes;
    }
}

