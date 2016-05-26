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
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace ficha_antecedentes_personales
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected ficha_antecedentes_personales.dsFicha dsFicha1;
		protected CrystalDecisions.Web.CrystalReportViewer VerFicha;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string rut_env;

			CrystalReportFicha reporte = new CrystalReportFicha();
			
			rut_env = Request.QueryString["rut_env"];
			rut_env = "16125125";

			sql = EscribirCodigo(rut_env);

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dsFicha1);

			reporte.SetDataSource(dsFicha1);
			VerFicha.ReportSource = reporte;
			ExportarPDF(reporte);
		}
		private string EscribirCodigo( string rut_env)
		{
			string sql;

			sql="exec LIST_FICHA_ANTECEDENTES_PERS "+rut_env;
			return (sql);
		}
		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);

			ExportOptions exportOpts = new ExportOptions();
			DiskFileDestinationOptions diskOpts = new DiskFileDestinationOptions();

			exportOpts = rep.ExportOptions;
			exportOpts.ExportFormatType = ExportFormatType.PortableDocFormat;

			exportOpts.ExportDestinationType = ExportDestinationType.DiskFile;
			diskOpts.DiskFileName = ruta_exportacion + Session.SessionID.ToString() + ".pdf";			
			exportOpts.DestinationOptions = diskOpts;

			rep.Export();

			Response.ClearContent();
			Response.ClearHeaders();
			Response.ContentType = "application/pdf";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());

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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.dsFicha1 = new ficha_antecedentes_personales.dsFicha();
			((System.ComponentModel.ISupportInitialize)(this.dsFicha1)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = "Provider=SQLOLEDB;server=edoras;OLE DB Services = -2;uid=protic;pwd=,.protic;init" +
				"ial catalog=protic2";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"select '' as nombre, '' as rut, '' as pasaporte, '' as fecha_nac, '' as fono, '' as nacionalidad, '' as Estado_civil, '' as Direccion, '' as comuna, '' as ciudad, '' as region, '' as colegio_egreso, '' as ano_egreso, '' as proced_educ, '' as inst_educ_sup, '' as Carrera, '' as ano_ingr, '' as FinanciaEst, '' as ultimo_post_ncorr, '' as nombre_sost_ec, '' as RUT_sost_ec, '' as fnac_sost_ec, '' as edad_sost, '' as fono_sost_ec, '' as pare_sost_ec, '' as dire_tdesc_sost_ec, '' as comu_sost_ec, '' as ciud_sost_ec, '' as regi_sost_ec";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			// 
			// dsFicha1
			// 
			this.dsFicha1.DataSetName = "dsFicha";
			this.dsFicha1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dsFicha1.Namespace = "http://www.tempuri.org/dsFicha.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dsFicha1)).EndInit();

		}
		#endregion
	}
}
