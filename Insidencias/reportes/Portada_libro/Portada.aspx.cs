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

namespace Portada_libro
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected Portada_libro.DataSet1 dataSet11;
		protected System.Data.OleDb.OleDbDataAdapter DataAdapter;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
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

		string generar_sql_Portada(string Seccion) 
		{
			string sql = "";

		sql =      "SELECT distinct i.duas_tdesc,  h.peri_tdesc, decode(g.tpro_ccod, 1,obtener_nombre_completo(g.pers_ncorr)) as profesor, d.sede_tdesc, e.jorn_tdesc as orn_tdesc, c.carr_tdesc, ";
		sql = sql + "				b.asig_ccod, b.asig_tdesc, b.asig_nhoras, a.secc_tdesc, decode(g.tpro_ccod, 2,obtener_nombre_completo(g.pers_ncorr)) as ayudante ";
		sql = sql + "FROM secciones a , asignaturas b, carreras c, sedes d, jornadas e,bloques_horarios f, bloques_profesores g,  ";
		sql = sql + "     periodos_academicos h, duracion_asignatura i ";
		sql = sql + "WHERE a.asig_ccod = b.asig_ccod  ";
		sql = sql + "  and a.carr_ccod = c.carr_ccod    ";
		sql = sql + "  and a.sede_ccod = d.sede_ccod ";
		sql = sql + "  and a.jorn_ccod = e.jorn_ccod ";
		sql = sql + "  and a.secc_ccod = f.secc_ccod ";
		sql = sql + "  and f.bloq_ccod  = g.bloq_ccod ";
		sql = sql + "  and g.tpro_ccod in (1,2) ";
		sql = sql + "  and a.peri_ccod = h.peri_ccod ";
		sql = sql + "  and b.duas_ccod = i.duas_ccod (+) ";
		sql = sql + "  and a.secc_ccod =" + Seccion + " ";
 	    //    Response.Write(sql);
		//	Response.End();
		return (sql);

		}


		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", secc_ccod = "";
			Reporte Reporte = new Reporte();

			secc_ccod = Request.QueryString["secc_ccod"];
		
			//secc_ccod = "43301";
			sql = generar_sql_Portada(secc_ccod);
			DataAdapter.SelectCommand.CommandText = sql;
			
			DataAdapter.Fill(dataSet11);
			Reporte.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = Reporte;

			ExportarPDF(Reporte);		
		
			
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
			this.DataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new Portada_libro.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// DbConnection
			// 
			this.DbConnection.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DataAdapter
			// 
			this.DataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "T_Datos", new System.Data.Common.DataColumnMapping[] {
																																																			 new System.Data.Common.DataColumnMapping("DUAS_TDESC", "DUAS_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("PERI_TDESC", "PERI_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("PROFESOR", "PROFESOR"),
																																																			 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("ORN_TDESC", "ORN_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("ASIG_CCOD", "ASIG_CCOD"),
																																																			 new System.Data.Common.DataColumnMapping("ASIG_TDESC", "ASIG_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("ASIG_NHORAS", "ASIG_NHORAS"),
																																																			 new System.Data.Common.DataColumnMapping("SECC_TDESC", "SECC_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("AYUDANTE", "AYUDANTE")})});
			this.DataAdapter.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS DUAS_TDESC, \'\' AS PERI_TDESC, \'\' AS PROFESOR, \'\' AS SEDE_TDESC, \'\' A" +
				"S ORN_TDESC, \'\' AS CARR_TDESC, \'\' AS ASIG_CCOD, \'\' AS ASIG_TDESC, \'\' AS ASIG_NHO" +
				"RAS, \'\' AS SECC_TDESC, \'\' AS AYUDANTE FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.DbConnection;
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

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}
	}
}
