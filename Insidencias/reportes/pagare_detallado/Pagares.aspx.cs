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


namespace pagare_detallado
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DbDataAdapter;
		protected pagare_detallado.DataSetPagares dataSetPagares1;
		protected CrystalDecisions.Web.CrystalReportViewer VisorCrystalReport;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=Pagares.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		private string Generar_SQL_Pagares(string SEDE, string INICIO, string FIN, string ANO)
		{
			string sql = "";				
		
sql = sql + "select "+ANO+" as ano_periodo, j.sede_tdesc, obtener_nombre_carrera (i.ofer_ncorr,'CEJ') as carrera, \n";
sql = sql + "        obtener_nombre_completo(h.pers_ncorr,'PM,N') as alumno, obtener_rut(h.pers_ncorr) as rut_alumno, \n";
sql = sql + "	    obtener_nombre_completo(ultimo_aval(h.pers_ncorr),'PM,N') as aval,  \n";
sql = sql + "		obtener_rut(ultimo_aval(h.pers_ncorr)) as rut_aval, \n";
sql = sql + "	   sum(decode(to_char(trunc(c.BENE_FBENEFICIO),'yyyy'),"+ANO+", nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0), 0)) as uf_beneficio_periodo, \n";
sql = sql + "       sum(decode(to_char(trunc(c.BENE_FBENEFICIO),'yyyy'),"+ANO+", (nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0)) * g.UFOM_MVALOR, 0)) as monto_periodo, \n";
sql = sql + "	   sum(decode(to_char(trunc(c.BENE_FBENEFICIO),'yyyy'),"+ANO+", 0, nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0))) as uf_beneficio_anterior, \n";
sql = sql + "	   sum(decode(to_char(trunc(c.BENE_FBENEFICIO),'yyyy'),"+ANO+", 0, (nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0)) * g.UFOM_MVALOR)) as monto_acumulado, \n";
sql = sql + "	   k.emat_tdesc, ano_ingreso_carrera(h.pers_ncorr, l.carr_ccod) as ano_ingreso, '' as ano_egreso	    \n";
sql = sql + "from postulantes a, contratos b, beneficios c, pagares d, stipos_descuentos e, sdescuentos f, uf g, \n";
sql = sql + "     alumnos h, ofertas_academicas i, sedes j, estados_matriculas k, especialidades l \n";
sql = sql + "where a.post_ncorr = b.post_ncorr \n";
sql = sql + "  and b.cont_ncorr = c.cont_ncorr \n";
sql = sql + "  and c.paga_ncorr = d.paga_ncorr (+) \n";
sql = sql + "  and c.stde_ccod = e.stde_ccod \n";
sql = sql + "  and a.post_ncorr = f.post_ncorr \n";
sql = sql + "  and a.ofer_ncorr = f.ofer_ncorr \n";
sql = sql + "  and c.stde_ccod = f.stde_ccod \n";
sql = sql + "  and c.ufom_ncorr = g.ufom_ncorr \n";
sql = sql + "  and a.post_ncorr = h.post_ncorr 	 \n";
sql = sql + "  and h.ofer_ncorr = i.ofer_ncorr \n";
sql = sql + "  and i.sede_ccod = j.sede_ccod  \n";
sql = sql + "  and h.emat_ccod = k.emat_ccod  \n";
sql = sql + "  and i.espe_ccod = l.espe_ccod \n";
sql = sql + "  and e.tben_ccod = 1 \n";
sql = sql + "  and b.econ_ccod = '1' \n";
sql = sql + "  and c.eben_ccod = '1' \n";
sql = sql + "  and h.emat_ccod <> 9 \n";
sql = sql + "  and c.stde_ccod = 701 \n";
sql = sql + "  and nvl(j.sede_ccod,'') = nvl('" + SEDE + "',j.sede_ccod) \n";
sql = sql + "group by j.sede_tdesc, obtener_nombre_carrera (i.ofer_ncorr,'CEJ'),  \n";
sql = sql + "       obtener_nombre_completo(h.pers_ncorr,'PM,N'), obtener_rut(h.pers_ncorr), h.pers_ncorr,k.emat_tdesc,l.carr_ccod \n";
	

			
			  //sql =       "select '"+INICIO+"' as inicio, '"+FIN+"' as fin, k.sede_tdesc, obtener_nombre_carrera(d.ofer_ncorr,'CEJ') as carrera, obtener_nombre_completo(d.pers_ncorr,'PM,N') as alumno, \n";
			//sql = sql + "  and trunc(b.PAGA_FPAGARE)  BETWEEN nvl(to_date('" + INICIO + "','dd/mm/yyyy'),b.PAGA_FPAGARE) AND  nvl(to_date('" + FIN + "','dd/mm/yyyy'),b.PAGA_FPAGARE) 		 \n";
			return(sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", sede = "", inicio = "", fin = "", tipodoc = "", ano =  "";
			CrystalReport Reporte = new CrystalReport();

			sede = Request.QueryString["sede"];
			inicio = Request.QueryString["inicio"];
			fin = Request.QueryString["fin"];
			tipodoc = Request.QueryString["tipodoc"];
		    ano = Request.QueryString["periodo"];

			sql = Generar_SQL_Pagares(sede, inicio, fin, ano);
            			
			//Response.Write("<PRE>" + sql + "</PRE>");
			//Response.End();
			
			DbDataAdapter.SelectCommand.CommandText = sql;
            
			DbDataAdapter.Fill(dataSetPagares1);
			Reporte.SetDataSource(dataSetPagares1);
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
			this.dataSetPagares1 = new pagare_detallado.DataSetPagares();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.dataSetPagares1)).BeginInit();
			// 
			// DbConnection
			// 
			this.DbConnection.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DbDataAdapter
			// 
			this.DbDataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DbDataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "T_Pagares", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("ANO_PERIODO", "ANO_PERIODO"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				 new System.Data.Common.DataColumnMapping("ALUMNO", "ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("AVAL", "AVAL"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_AVAL", "RUT_AVAL"),
																																																				 new System.Data.Common.DataColumnMapping("UF_BENEFICIO_PERIODO", "UF_BENEFICIO_PERIODO"),
																																																				 new System.Data.Common.DataColumnMapping("MONTO_PERIODO", "MONTO_PERIODO"),
																																																				 new System.Data.Common.DataColumnMapping("UF_BENEFICIO_ANTERIOR", "UF_BENEFICIO_ANTERIOR"),
																																																				 new System.Data.Common.DataColumnMapping("MONTO_ACUMULADO", "MONTO_ACUMULADO"),
																																																				 new System.Data.Common.DataColumnMapping("EMAT_TDESC", "EMAT_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("ANO_INGRESO", "ANO_INGRESO"),
																																																				 new System.Data.Common.DataColumnMapping("ANO_EGRESO", "ANO_EGRESO")})});
			// 
			// dataSetPagares1
			// 
			this.dataSetPagares1.DataSetName = "DataSetPagares";
			this.dataSetPagares1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSetPagares1.Namespace = "http://www.tempuri.org/DataSetPagares.xsd";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS ANO_PERIODO, '' AS SEDE_TDESC, '' AS CARRERA, '' AS ALUMNO, '' AS RUT_ALUMNO, '' AS AVAL, '' AS RUT_AVAL, '' AS UF_BENEFICIO_PERIODO, '' AS MONTO_PERIODO, '' AS UF_BENEFICIO_ANTERIOR, '' AS MONTO_ACUMULADO, '' AS EMAT_TDESC, '' AS ANO_INGRESO, '' AS ANO_EGRESO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.DbConnection;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSetPagares1)).EndInit();

		}
		#endregion
	}
}
