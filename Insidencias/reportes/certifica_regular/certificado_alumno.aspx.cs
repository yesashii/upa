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

namespace certifica_regular
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected certifica_regular.datoAlumno datoAlumno1;
		protected CrystalDecisions.Web.CrystalReportViewer VerCertificado;
	
		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			//ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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


		private string EscribirCodigo( string matr_ncorr)
		{
			string sql;
		    
			sql = " select '2004' as periodo,'Primer' as semestre, 'JORGE MÜLLER UBILLA' as nombre_enc_c, 'JAIME RIBERA NEUMANN' as sec_general,";
			sql = sql + "       'ASIGNACIÒN FAMILIAR' AS TIPO_CERTIFICADO,c.CIUD_TDESC ciudad_sede,codigo_alumno(aa.pers_ncorr,160)  as ccod_alumno, ";
			sql = sql + " 		pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno nombre_alumno,  ";
			sql = sql + " 		pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post,  ";
			sql = sql + " 		ccc.carr_tdesc as carrera, ";
			sql = sql + " 		TO_CHAR(sysdate,'DD') dia, TO_CHAR(sysdate,'MONTH') mes,TO_CHAR(sysdate,'YYYY') ano, to_char (sysdate,'Day') n_dia    ";
			sql = sql + " from alumnos aa, ";
			sql = sql + " 		personas_postulante pp,ofertas_academicas oa,  ";
			sql = sql + " 		especialidades ee, carreras ccc, ";
			sql = sql + " 	    ciudades c, sedes ss ";
			sql = sql + " where aa.pers_ncorr=pp.pers_ncorr and   ";
			sql = sql + " 	  aa.ofer_ncorr=oa.ofer_ncorr and   ";
			sql = sql + " 	  oa.espe_ccod=ee.espe_ccod and   ";
			sql = sql + " 	  ee.carr_ccod=ccc.carr_ccod and  ";
			sql = sql + " 	  oa.SEDE_CCOD= ss.sede_ccod and ";
			sql = sql + " 	  ss.CIUD_CCOD=c.CIUD_CCOD and  ";
			sql = sql + " 	  aa.matr_ncorr= nvl('1000',aa.matr_ncorr) ";

			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string matr_ncorr;
			matr_ncorr = Request.QueryString["matr_ncorr"];
			
			CrystalReport1 reporte = new CrystalReport1();
			
			sql = EscribirCodigo(matr_ncorr);
			//Response.Write(sql);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datoAlumno1);
				
				
			reporte.SetDataSource(datoAlumno1);
			VerCertificado.ReportSource = reporte;
			//Response.End();
			ExportarPDF(reporte);
		
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
			this.datoAlumno1 = new certifica_regular.datoAlumno();
			((System.ComponentModel.ISupportInitialize)(this.datoAlumno1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "alumno", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ENC_C", "NOMBRE_ENC_C"),
																																																				  new System.Data.Common.DataColumnMapping("SEC_GENERAL", "SEC_GENERAL"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_SEDE", "CIUDAD_SEDE"),
																																																				  new System.Data.Common.DataColumnMapping("CCOD_ALUMNO", "CCOD_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS SEMESTRE, '' AS PERIODO, 'JORGE MÜLLER UBILLA' AS NOMBRE_ENC_C, 'JAIME RIBERA NEUMANN' AS SEC_GENERAL, '' AS CIUDAD_SEDE, '' AS CCOD_ALUMNO, '' AS NOMBRE_ALUMNO, '' AS RUT_POST, '' AS CARRERA, '' AS DIA, '' AS MES, '' AS ANO, '' AS N_DIA, '' AS TIPO_CERTIFICADO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datoAlumno1
			// 
			this.datoAlumno1.DataSetName = "datoAlumno";
			this.datoAlumno1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datoAlumno1.Namespace = "http://www.tempuri.org/datoAlumno.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datoAlumno1)).EndInit();

		}
		#endregion
	}
}
