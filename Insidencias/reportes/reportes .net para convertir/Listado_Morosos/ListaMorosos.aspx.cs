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

namespace Listado_Morosos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DbDataAdapter;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected Listado_Morosos.DataSetAlumnos dataSetAlumnos1;
		protected CrystalDecisions.Web.CrystalReportViewer VisorCrystalReport;
		protected System.Data.OleDb.OleDbConnection DbConnection;
	

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

		private void ExportarEXCEL(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			//ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
			ExportOptions exportOpts = new ExportOptions();
			DiskFileDestinationOptions diskOpts = new DiskFileDestinationOptions();

			exportOpts = rep.ExportOptions;
			exportOpts.ExportFormatType = ExportFormatType.Excel; 

			exportOpts.ExportDestinationType = ExportDestinationType.DiskFile;
			diskOpts.DiskFileName = ruta_exportacion + Session.SessionID.ToString() + ".xls";
			exportOpts.DestinationOptions = diskOpts;

			rep.Export();
						
			Response.ClearContent();
			Response.ClearHeaders();

			Response.AddHeader ("Content-Disposition", "attachment;filename=Morosidad.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		private string Generar_SQL_Alumnos(string SEDE, string FIN)
		{
		    string sql = "";
				sql =       "select '" + FIN + "' as fecha_corte, d.sede_tdesc, obtener_nombre_carrera(c.ofer_ncorr, 'CEJ') as carrera, a.pers_nrut || '-' || a.pers_xdv as rut, a.PERS_TAPE_PATERNO || ' ' || a.pers_tape_materno || ', ' || a.PERS_TNOMBRE as nombre \n";
				sql = sql + "from personas a, alumnos b, ofertas_academicas c, sedes d \n";
				sql = sql + "where a.pers_ncorr = b.pers_ncorr \n";
				sql = sql + "  and b.ofer_ncorr = c.ofer_ncorr \n";
				sql = sql + "  and c.sede_ccod = d.sede_ccod \n";
				sql = sql + "  and b.ofer_ncorr = ultima_oferta_matriculado(a.pers_ncorr)   \n";
				sql = sql + "  and b.emat_ccod = 1   \n";
				sql = sql + "  and c.sede_ccod = '" + SEDE + "'   \n";
				sql = sql + "group by c.ofer_ncorr, a.pers_ncorr, d.sede_tdesc, a.pers_nrut,a.pers_xdv, a.PERS_TAPE_PATERNO ,a.pers_tape_materno, a.PERS_TNOMBRe \n";
				sql = sql + "having es_moroso(a.pers_ncorr, nvl(to_date('" + FIN + "', 'dd/mm/yyyy'), sysdate)) = 'S' \n";
				//-------------------------------------------------------------------------
				sql = "";
				//-------------------------------------------------------------------------
				sql = " select '" + FIN + "' as fecha_corte, d.sede_tdesc, protic.obtener_nombre_carrera(c.ofer_ncorr, 'CEJ') as carrera, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, a.PERS_TAPE_PATERNO + ' ' + a.pers_tape_materno + ', ' + a.PERS_TNOMBRE as nombre \n"; 
				sql = sql + " From personas a, alumnos b, ofertas_academicas c, sedes d \n";
				sql = sql + " where a.pers_ncorr = b.pers_ncorr \n";
				sql = sql + "  and b.ofer_ncorr = c.ofer_ncorr \n";
				sql = sql + "  and c.sede_ccod = d.sede_ccod \n";
				sql = sql + "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr)   \n";
				sql = sql + "  and b.emat_ccod = 1   \n";
				sql = sql + "  and c.sede_ccod = '" + SEDE + "'   \n";
				sql = sql + " group by c.ofer_ncorr, a.pers_ncorr, d.sede_tdesc, a.pers_nrut,a.pers_xdv, a.PERS_TAPE_PATERNO ,a.pers_tape_materno, a.PERS_TNOMBRE \n";
				sql = sql + " having protic.es_moroso(a.pers_ncorr, isnull('10/10/2004', getdate())) = 'S' \n";


			return(sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", sede = "", inicio = "", fin = "", tipodoc = "";
			CrystalReport Reporte = new CrystalReport();

			sede = Request.QueryString["sede"];
			fin = Request.QueryString["fin"];
			tipodoc = Request.QueryString["tipodoc"];
		
			sql = Generar_SQL_Alumnos(sede, fin);
            			
			//Response.Write("<PRE>" + sql + "</PRE>");
			//Response.End();
			
			DbDataAdapter.SelectCommand.CommandText = sql;
            
			DbDataAdapter.Fill(dataSetAlumnos1);
			Reporte.SetDataSource(dataSetAlumnos1);
			VisorCrystalReport.ReportSource = Reporte;
			
			if (tipodoc == "1")
				ExportarPDF(Reporte);		
			else
				ExportarEXCEL(Reporte);
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
			this.DbConnection = new System.Data.OleDb.OleDbConnection();
			this.DbDataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSetAlumnos1 = new Listado_Morosos.DataSetAlumnos();
			((System.ComponentModel.ISupportInitialize)(this.dataSetAlumnos1)).BeginInit();
			// 
			// DbConnection
			// 
			this.DbConnection.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DbDataAdapter
			// 
			this.DbDataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DbDataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "T_Alumnos", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("FECHA_CORTE", "FECHA_CORTE"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				 new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS FECHA_CORTE, \'\' AS SEDE_TDESC, \'\' AS CARRERA, \'\' AS RUT, \'\' AS NOMBR" +
				"E FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.DbConnection;
			// 
			// dataSetAlumnos1
			// 
			this.dataSetAlumnos1.DataSetName = "DataSetAlumnos";
			this.dataSetAlumnos1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSetAlumnos1.Namespace = "http://www.tempuri.org/DataSetAlumnos.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSetAlumnos1)).EndInit();

		}
		#endregion
	}
}
