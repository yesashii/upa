using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace informe_1
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected informe_1.datosInforme datosInforme1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		private string EscribirCodigo()
		{
			string sql;
		    
			sql = " select sede_tdesc as nombre from sedes";
			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			
			CrystalReportInforme reporte = new CrystalReportInforme();
			
			sql = EscribirCodigo();
			//Response.Write(sql);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datosInforme1);
					
				
			reporte.SetDataSource(datosInforme1);
			VerReporte.ReportSource = reporte;
			//Response.End();
			//ExportarPDF(reporte);
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: llamada requerida por el Diseñador de Web Forms ASP.NET.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Método necesario para admitir el Diseñador, no se puede modificar
		/// el contenido del método con el editor de código.
		/// </summary>
		private void InitializeComponent()
		{    
			System.Configuration.AppSettingsReader configurationAppSettings = new System.Configuration.AppSettingsReader();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.datosInforme1 = new informe_1.datosInforme();
			((System.ComponentModel.ISupportInitialize)(this.datosInforme1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS NOMBRE FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosInforme1
			// 
			this.datosInforme1.DataSetName = "datosInforme";
			this.datosInforme1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosInforme1.Namespace = "http://www.tempuri.org/datosInforme.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosInforme1)).EndInit();

		}
		#endregion
	}
}
