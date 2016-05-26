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

namespace detalle_envio_notaria
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected detalle_envio_notaria.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
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
		private string generar_sql_listado_letras(string periodo,string envio)
		{
			string sql;
			sql =  "SELECT distinct a.envi_ncorr, a.envi_fenvio, h.inen_tdesc, b.ting_ccod, b.ingr_ncorr, ";
			sql = sql +		"b.ding_ndocto, d.ingr_fpago, c.DING_MDOCTO, ";
			sql = sql +		"c.ding_fdocto, c1.edin_tdesc, ";
			sql = sql +		"cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno, ";
			sql = sql +		"cast(g1.pers_nrut as varchar) + '-' + g1.pers_xdv as rut_apoderado, ";
			sql = sql +		"g1.pers_tnombre + ' ' + g1.pers_tape_paterno as nombre_apoderado ";
			sql = sql + "FROM envios a, detalle_envios b, detalle_ingresos c, ";
			sql = sql +		"estados_detalle_ingresos c1, ingresos d, ";
			sql = sql +		"personas e, postulantes f, codeudor_postulacion g, ";
			sql = sql +		"personas g1, instituciones_envio h ";
			sql = sql + "WHERE c.DING_NCORRELATIVO = 1 ";
			sql = sql +		"and a.envi_ncorr = b.envi_ncorr ";
			sql = sql +		"and b.ting_ccod = c.ting_ccod ";
			sql = sql +		"and b.ding_ndocto = c.ding_ndocto ";
			sql = sql +		"and b.ingr_ncorr = c.ingr_ncorr ";
			sql = sql +		"and c.ingr_ncorr = d.ingr_ncorr ";
			sql = sql +		"and b.edin_ccod = c1.edin_ccod ";
			sql = sql +		"and d.pers_ncorr = e.pers_ncorr ";
			sql = sql +		"and e.pers_ncorr = f.pers_ncorr ";
			sql = sql +		"and f.post_ncorr = g.post_ncorr ";
			sql = sql +		"and g.pers_ncorr = g1.pers_ncorr ";
			sql = sql +		"and a.inen_ccod = h.inen_ccod ";
			sql = sql +		"AND a.envi_ncorr =" + envio;
			
			// el periodo no es necesario ya que el folio es unico
			//sql = sql +		"and f.peri_ccod =" + periodo + " ";
			//Response.Write(sql);
			//Response.Flush();

		    
			return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql="", periodo="", envio="";
			
			periodo = Request.QueryString["periodo"];
			envio = Request.QueryString["folio_envio"];
			//periodo = "300";
			//envio = "96";

			sql = generar_sql_listado_letras(periodo,envio);
			CrystalReport1 ListadoLetras = new CrystalReport1();
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			ListadoLetras.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = ListadoLetras;
			ExportarPDF(ListadoLetras);
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
			this.dataSet11 = new detalle_envio_notaria.DataSet1();
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
																										new System.Data.Common.DataTableMapping("Table", "T_detalles", new System.Data.Common.DataColumnMapping[] {
																																																					  new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																					  new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("DING_MDOCTO", "DING_MDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO"),
																																																					  new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("EDIN_TDESC", "EDIN_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS ENVI_NCORR, '' AS ENVI_FENVIO, '' AS INEN_TDESC, '' AS TING_CCOD, '' AS INGR_NCORR, '' AS DING_NDOCTO, '' AS DING_MDOCTO, '' AS INGR_FPAGO, '' AS DING_FDOCTO, '' AS EDIN_TDESC, '' AS RUT_ALUMNO, '' AS RUT_APODERADO, '' AS NOMBRE_APODERADO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
