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

namespace depositos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected depositos.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbCommand oleDbInsertCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbUpdateCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbDeleteCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter2;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	
		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			//ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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

		private string generar_sql_detalle_deposito(string envio)
		{
			string sql = "";
		 
			sql = "SELECT a.envi_ncorr, j.CCTE_TDESC, a.envi_fenvio, h.inen_tdesc, i.tdep_tdesc,  c.ding_tcuenta_corriente, ";
			sql = sql +		"b.ding_ndocto, c.ding_mdocto, d.ingr_fpago, ";
			sql = sql +		"c.ding_fdocto, c1.edin_tdesc, ";
			sql = sql +		"g1.pers_nrut || '-' || g1.pers_xdv as rut_apoderado, ";
			sql = sql +		"g1.pers_tnombre || ' ' || g1.pers_tape_paterno as nombre_apoderado ";
			sql = sql + "FROM envios a, ";
			sql = sql +		"detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1, ";  
			sql = sql +		"ingresos d, personas e, postulantes f, codeudor_postulacion g, ";
			sql = sql +		"personas g1, instituciones_envio h, tipos_depositos i, cuentas_corrientes j ";
			sql = sql +	"WHERE a.envi_ncorr = b.envi_ncorr "; 
			sql = sql +		"and b.ting_ccod = c.ting_ccod "; 
			sql = sql +		"and c.DING_NCORRELATIVO = 1 "; 
			sql = sql +		"and b.ding_ndocto = c.ding_ndocto "; 
			sql = sql +		"and b.ingr_ncorr = c.ingr_ncorr "; 
			sql = sql +		"and c.ingr_ncorr = d.ingr_ncorr "; 
			sql = sql +		"and b.edin_ccod = c1.edin_ccod "; 
			sql = sql +		"and d.pers_ncorr = e.pers_ncorr "; 
			sql = sql +		"and e.pers_ncorr = f.pers_ncorr "; 
			sql = sql +		"and f.post_ncorr = g.post_ncorr  ";
			sql = sql +		"and g.pers_ncorr = g1.pers_ncorr ";
			sql = sql +		"and a.inen_ccod = h.inen_ccod ";
			sql = sql +		"and a.TDEP_CCOD = i.TDEP_CCOD ";
			sql = sql +		"and a.CCTE_CCOD = j.ccte_ccod ";
			sql = sql +		"and a.envi_ncorr =" + envio;
		  
			return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", envio = "";
			CrystalReport1 RepDetalleDeposito = new CrystalReport1();
			
			envio = Request.QueryString["folio_envio"];
		    
			sql = generar_sql_detalle_deposito(envio);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			RepDetalleDeposito.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = RepDetalleDeposito;
			ExportarPDF(RepDetalleDeposito);
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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new depositos.DataSet1();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbInsertCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbUpdateCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDeleteCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter2 = new System.Data.OleDb.OleDbDataAdapter();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("TDEP_TDESC", "TDEP_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("DING_TCUENTA_CORRIENTE", "DING_TCUENTA_CORRIENTE"),
																																																				 new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("DING_MDOCTO", "DING_MDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO"),
																																																				 new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("EDIN_TDESC", "EDIN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS ENVI_NCORR, '' AS ENVI_FENVIO, '' AS CCTE_TDESC, '' AS INEN_TDESC, '' AS TDEP_TDESC, '' AS DING_TCUENTA_CORRIENTE, '' AS DING_NDOCTO, '' AS DING_MDOCTO, '' AS INGR_FPAGO, '' AS DING_FDOCTO, '' AS EDIN_TDESC, '' AS RUT_APODERADO, '' AS NOMBRE_APODERADO ";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS ENVI_NCORR, \'\' AS INEN_CCOD, \'\' AS CCTE_TDESC, \'\' AS TDEP_TDESC, \'\' " +
				"AS ENVI_FENVIO";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter2
			// 
			this.oleDbDataAdapter2.DeleteCommand = this.oleDbDeleteCommand1;
			this.oleDbDataAdapter2.InsertCommand = this.oleDbInsertCommand1;
			this.oleDbDataAdapter2.SelectCommand = this.oleDbSelectCommand2;
			this.oleDbDataAdapter2.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_CCOD", "INEN_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("TDEP_TDESC", "TDEP_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO")})});
			this.oleDbDataAdapter2.UpdateCommand = this.oleDbUpdateCommand1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
