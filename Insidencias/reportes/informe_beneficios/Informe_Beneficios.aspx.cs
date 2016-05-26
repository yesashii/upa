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

namespace informe_beneficios
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected informe_beneficios.DataSet1 dataSet11;
	
		
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

		private string Generar_SQL_Informe()
		{
			string sql = "", rut = "", periodo = "", tipo_beneficio="";
			string estado_beneficio="", beneficio = "", sede = "", pers_ncorr = "";

			rut = Request.QueryString["rut"];
			periodo = Request.QueryString["periodo"];
			tipo_beneficio = Request.QueryString["t_bene"];
			beneficio = Request.QueryString["bene"];
			estado_beneficio = Request.QueryString["e_bene"];
			sede = Request.QueryString["sede"];
			pers_ncorr = Request.QueryString["pers_ncorr"];

			sql =        "SELECT i.tben_tdesc, a.stde_ccod, b.stde_tdesc, c.esde_tdesc, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod, ";
			sql = sql +	        "f.pers_nrut || '-' || f.pers_xdv as rut_alumno, f.pers_nrut, c.ESDE_TDESC, ";
			sql = sql +			"f.pers_tape_paterno || ' ' || f.pers_tape_materno || ' ' || f.pers_tnombre as nombre_alumno, ";
			sql = sql +			"h.carr_tdesc, to_number(a.sdes_mmatricula) as sdes_mmatricula, to_number(a.sdes_nporc_matricula) as sdes_nporc_matricula, ";
			sql = sql +			"to_number(a.sdes_mcolegiatura) as sdes_mcolegiatura, to_number(a.sdes_nporc_colegiatura) as sdes_nporc_colegiatura, ";
			sql = sql +			"nvl(a.sdes_mmatricula, 0) + nvl(a.sdes_mcolegiatura, 0) as subtotal, c.esde_ccod ";
			sql = sql +  "FROM sdescuentos a, stipos_descuentos b, sestados_descuentos c,  postulantes d, ";
			sql = sql +		  "ofertas_academicas e,  personas_postulante f,  especialidades g,  carreras h, ";
			sql = sql +		  "tipos_beneficios i, sedes j ";
			sql = sql +	  "WHERE a.stde_ccod = b.stde_ccod ";
			sql = sql +		"and b.tben_ccod = i.tben_ccod ";
			sql = sql +		"and a.esde_ccod = c.esde_ccod ";
			sql = sql +		"and a.post_ncorr = d.post_ncorr ";
			sql = sql +		"and a.ofer_ncorr = d.ofer_ncorr ";
			sql = sql +		"and d.ofer_ncorr = e.ofer_ncorr ";
			sql = sql +		"and d.pers_ncorr = f.pers_ncorr ";
			sql = sql +		"and e.espe_ccod = g.espe_ccod ";
			sql = sql +		"and g.carr_ccod = h.carr_ccod ";
			sql = sql +		"and e.sede_ccod = j.sede_ccod ";
			sql = sql +		"and d.peri_ccod ='" + periodo + "' ";
			sql = sql +		"and b.tben_ccod = nvl('" + tipo_beneficio + "', b.tben_ccod) ";
			sql = sql +		"and a.stde_ccod =  nvl('" + beneficio + "', a.stde_ccod) ";
			sql = sql +		"and f.pers_nrut =  nvl('" + rut + "', f.pers_nrut) ";
			sql = sql +		"and a.esde_ccod =  nvl('" + estado_beneficio + "', a.esde_ccod) ";
			sql = sql +		"and j.sede_ccod =  nvl('" + sede + "', j.sede_ccod) ";
			sql = sql +		"and EXISTS (SELECT 1 ";
			sql = sql +				"FROM sis_sedes_usuarios a2 ";
			sql = sql +				"WHERE a2.pers_ncorr =" + pers_ncorr + " ";
			sql = sql +				"and a2.sede_ccod = j.sede_ccod ";
			sql = sql +			        ") ";
			sql = sql +		"ORDER BY nombre_alumno";
          
			return (sql);
		}
		
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql = "";
			CrystalReport1 INFORME = new CrystalReport1();
					
			
			sql = Generar_SQL_Informe();			
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);	

			INFORME.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = INFORME;
			ExportarPDF(INFORME);
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
			this.dataSet11 = new informe_beneficios.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("TBEN_TDESC", "TBEN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("STDE_CCOD", "STDE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("STDE_TDESC", "STDE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("ESDE_TDESC", "ESDE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("POST_NCORR", "POST_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("PERS_NCORR", "PERS_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("ESDE_TDESC1", "ESDE_TDESC1"),
																																																				 new System.Data.Common.DataColumnMapping("OFER_NCORR", "OFER_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("PERS_NRUT", "PERS_NRUT"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("SDES_MMATRICULA", "SDES_MMATRICULA"),
																																																				 new System.Data.Common.DataColumnMapping("SDES_NPORC_MATRICULA", "SDES_NPORC_MATRICULA"),
																																																				 new System.Data.Common.DataColumnMapping("SDES_MCOLEGIATURA", "SDES_MCOLEGIATURA"),
																																																				 new System.Data.Common.DataColumnMapping("SDES_NPORC_COLEGIATURA", "SDES_NPORC_COLEGIATURA"),
																																																				 new System.Data.Common.DataColumnMapping("SUBTOTAL", "SUBTOTAL"),
																																																				 new System.Data.Common.DataColumnMapping("ESDE_CCOD", "ESDE_CCOD")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS TBEN_TDESC, '' AS STDE_CCOD, '' AS STDE_TDESC, '' AS ESDE_TDESC, '' AS POST_NCORR, '' AS PERS_NCORR, '' AS ESDE_TDESC, '' AS OFER_NCORR, '' AS SEDE_CCOD, '' AS RUT_ALUMNO, '' AS PERS_NRUT, '' AS NOMBRE_ALUMNO, '' AS CARR_TDESC, '' AS SDES_MMATRICULA, '' AS SDES_NPORC_MATRICULA, '' AS SDES_MCOLEGIATURA, '' AS SDES_NPORC_COLEGIATURA, '' AS SUBTOTAL, '' AS ESDE_CCOD FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
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

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
