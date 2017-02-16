﻿using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System.Data.SqlClient;



namespace EvoScriptExecute
{
    class SqlConnectionHelper
    {
        private string _connectionString;
        private readonly SqlConnectionStringBuilder _connectionStringBuilder;

        public SqlConnectionHelper(string connectionString)
        {
            _connectionString = connectionString;
            _connectionStringBuilder = new SqlConnectionStringBuilder(_connectionString);
        }

        public SqlConnectionHelper(SqlConnectionStringBuilder sqlConnectionStringBuilder)
        {
            _connectionString = sqlConnectionStringBuilder.ToString();
            _connectionStringBuilder = sqlConnectionStringBuilder;
        }

        public string ConnectionString
        {
            get { return _connectionString; }
            set { _connectionString = value; }
        }

        public string ServerName
        {
            get { return _connectionStringBuilder.DataSource; }
            
        }

        public string DatabaseName
        {
            get { return _connectionStringBuilder.InitialCatalog; }
            set { _connectionStringBuilder.InitialCatalog = value; ConnectionString = _connectionStringBuilder.ToString(); }
        }

        public Server GetServer()
        {
            var sqlConnection = new SqlConnection(_connectionString);
            return new Server(new ServerConnection(sqlConnection));
        }

        public void ExecuteScript(string scriptText)
        {
            var server = GetServer();
            server.ConnectionContext.ExecuteNonQuery(scriptText);
        }
    }
}
