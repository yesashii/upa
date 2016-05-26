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

namespace lista_alumnos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DataAdapterSeccion;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected lista_alumnos.DataSetDatos dataSetDatos1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=Procedencia_Alumnos.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		string generar_sql_seccion(string Seccion) 
		{
			string sql="";

			sql =       "select c.carr_tdesc, b.asig_ccod, b.asig_tdesc, b.asig_nhoras "; 
			sql = sql + "from secciones a , asignaturas b, carreras c  ";
			sql = sql + "where a.asig_ccod = b.asig_ccod ";
			sql = sql + "  and a.carr_ccod = c.carr_ccod   ";
			sql = sql + "  and a.secc_ccod = '" + Seccion + "'";

		 
		    return (sql);
		}

		string generar_sql_listado(string Seccion) 
		{
			string sql="";

				/*sql = "select distinct obtener_nombre_completo(h.pers_ncorr) as profe, y.carr_tdesc, z.asig_ccod, z.asig_tdesc, z.asig_nhoras, a.secc_ccod, b.matr_ncorr, b.alum_nmatricula, c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_TNOMBRE, f.carr_ccod,  f.CARR_TDESC, e.ESPE_TDESC  ";
					sql = sql + "from secciones x, carreras y,  asignaturas z, cargas_academicas a,  ";
						sql = sql + "alumnos b, personas c, ofertas_academicas d, especialidades e, carreras f, ";
						sql = sql + "bloques_horarios g, bloques_profesores h ";
					sql = sql + "where x.secc_ccod = a.secc_ccod ";
					sql = sql + "and x.carr_ccod = y.carr_ccod ";
					sql = sql + "and x.asig_ccod = z.asig_ccod ";
					sql = sql + "and x.secc_ccod = g.secc_ccod (+) ";
					sql = sql + "and g.bloq_ccod = h.bloq_ccod (+) ";
					sql = sql + "and h.TPRO_CCOD (+) = 1  ";
					sql = sql + "and a.matr_ncorr = b.matr_ncorr  ";
					sql = sql + "and b.emat_ccod = 1  ";
					sql = sql + "and b.pers_ncorr = c.pers_ncorr  ";
					sql = sql + "and b.ofer_ncorr = d.ofer_ncorr  ";
					sql = sql + "and d.espe_ccod = e.espe_ccod  ";
					sql = sql + "and e.carr_ccod = f.carr_ccod   ";
			     sql = sql + "  and a.secc_ccod = '" + Seccion + "'";*/

sql = sql + "select h.asig_ccod, h.asig_tdesc, h.ASIG_NHORAS, retorna_profesor(51349) as profe,  a.secc_ccod, b.matr_ncorr, b.alum_nmatricula, c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_TNOMBRE, f.carr_ccod,  f.CARR_TDESC, e.ESPE_TDESC   ";
sql = sql + "from cargas_academicas a, alumnos b, personas c, ofertas_academicas d, especialidades e, carreras f, secciones g, asignaturas h  ";
sql = sql + "where a.matr_ncorr = b.matr_ncorr  ";
  sql = sql + "and b.emat_ccod = 1  ";
  sql = sql + "and b.pers_ncorr = c.pers_ncorr  ";
  sql = sql + "and b.ofer_ncorr = d.ofer_ncorr  ";
  sql = sql + "and d.espe_ccod = e.espe_ccod  ";
  sql = sql + "and e.carr_ccod = f.carr_ccod  ";
  sql = sql + "and a.secc_ccod = g.secc_ccod ";
  sql = sql + "and g.asig_ccod = h.asig_ccod ";
  sql = sql + "and a.secc_ccod = '" + Seccion + "'   ";
		 
			return (sql);
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", secc_ccod = "", formato = "";
			CrystalReport1 Reporte = new CrystalReport1();

			secc_ccod = Request.QueryString["secc_ccod"];
			//formato = Request.QueryString["formato"];

      		sql = generar_sql_listado(secc_ccod);
			DataAdapterSeccion.SelectCommand.CommandText = sql;
            
			DataAdapterSeccion.Fill(dataSetDatos1);
			Reporte.SetDataSource(dataSetDatos1);
			CrystalReportViewer1.ReportSource = Reporte;
            //if (formato == "1")
		      ExportarPDF(Reporte);		
		    //else
			//  ExportarEXCEL(Reporte);

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
			this.DataAdapterSeccion = new System.Data.OleDb.OleDbDataAdapter();
			this.dataSetDatos1 = new lista_alumnos.DataSetDatos();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.dataSetDatos1)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DataAdapterSeccion
			// 
			this.DataAdapterSeccion.SelectCommand = this.oleDbSelectCommand1;
			this.DataAdapterSeccion.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										 new System.Data.Common.DataTableMapping("Table", "T_Datos", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("PROFE", "PROFE"),
																																																					new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_CCOD", "ASIG_CCOD"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_TDESC", "ASIG_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_NHORAS", "ASIG_NHORAS"),
																																																					new System.Data.Common.DataColumnMapping("SECC_CCOD", "SECC_CCOD"),
																																																					new System.Data.Common.DataColumnMapping("MATR_NCORR", "MATR_NCORR"),
																																																					new System.Data.Common.DataColumnMapping("ALUM_NMATRICULA", "ALUM_NMATRICULA"),
																																																					new System.Data.Common.DataColumnMapping("PERS_TAPE_PATERNO", "PERS_TAPE_PATERNO"),
																																																					new System.Data.Common.DataColumnMapping("PERS_TAPE_MATERNO", "PERS_TAPE_MATERNO"),
																																																					new System.Data.Common.DataColumnMapping("PERS_TNOMBRE", "PERS_TNOMBRE"),
																																																					new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																					new System.Data.Common.DataColumnMapping("CARR_TDESC1", "CARR_TDESC1"),
																																																					new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC")})});
			// 
			// dataSetDatos1
			// 
			this.dataSetDatos1.DataSetName = "DataSetDatos";
			this.dataSetDatos1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSetDatos1.Namespace = "http://www.tempuri.org/DataSetDatos.xsd";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS PROFE, '' AS CARR_TDESC, '' AS ASIG_CCOD, '' AS ASIG_TDESC, '' AS ASIG_NHORAS, '' AS SECC_CCOD, '' AS MATR_NCORR, '' AS ALUM_NMATRICULA, '' AS PERS_TAPE_PATERNO, '' AS PERS_TAPE_MATERNO, '' AS PERS_TNOMBRE, '' AS CARR_CCOD, '' AS CARR_TDESC, '' AS ESPE_TDESC FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSetDatos1)).EndInit();

		}
		#endregion
	}
}
