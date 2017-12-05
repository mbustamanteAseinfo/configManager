namespace EvoScriptExecute
{
    class Item
    {

        string ruta;
        string paso;
        string necesario;
        string posicion;
        string nombre;
        string dataBase;
        string ejecutado;
        public string Ruta
        {
            get
            {
                return ruta;
            }

            set
            {
                ruta = value;
            }
        }

        public string Paso
        {
            get
            {
                return paso;
            }

            set
            {
                paso = value;
            }
        }

        public string Necesario
        {
            get
            {
                return necesario;
            }

            set
            {
                necesario = value;
            }
        }

        public string Posicion
        {
            get
            {
                return posicion;
            }

            set
            {
                posicion = value;
            }
        }

        public string Nombre
        {
            get
            {
                return nombre;
            }

            set
            {
                nombre = value;
            }
        }

        public string DataBase
        {
            get
            {
                return dataBase;
            }

            set
            {
                dataBase = value;
            }
        }

        public string Ejecutado
        {
            get
            {
                return ejecutado;
            }

            set
            {
                ejecutado = value;
            }
        }

        public override string ToString()
        {
            return this.posicion + " - " + this.nombre.Split('-')[1].Trim() + " - " + this.nombre.Split('-')[2];
        }
    }
}
