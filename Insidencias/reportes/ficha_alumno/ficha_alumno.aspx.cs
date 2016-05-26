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

namespace ficha_alumno
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected ficha_alumno.datosAlumno datosAlumno1;
		protected CrystalDecisions.Web.CrystalReportViewer VerAlumno;


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

/*
		private string EscribirCodigo( string post_ncorr)
		{
			string sql;
		    
			sql = " select  isnull (protic.ano_ingreso_carrera(p.pers_ncorr,ee.carr_ccod),pac.ANOS_CCOD) ano_ingreso, ss.SEDE_TDESC as nombre_sede, ";
			sql = sql + " 		pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as nombre_alumno,  ";
			sql = sql + " 		convert(char(8),pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post,  ";
			sql = sql + " 		ccc.carr_tdesc as carrera,  ";
			sql = sql + " 		ddp.DIRE_TCALLE +' ' + ddp.DIRE_TNRO as direccion,  ";
			sql = sql + " 		ddp.DIRE_TFONO as fono, ";
			sql = sql + " 		c.CIUD_TDESC as ciudad, c.CIUD_TCOMUNA as comuna ";
			sql = sql + " from postulantes p, ";
			sql = sql + " 		personas_postulante pp,ofertas_academicas oa,periodos_academicos pac,  ";
			sql = sql + " 		especialidades ee, carreras ccc, ";
			
			sql = sql + " 		direcciones_publica ddp, ciudades c, sedes ss ";
			sql = sql + " 		 ";
			sql = sql + " 		where p.pers_ncorr=pp.pers_ncorr and   ";
			
			sql = sql + " 		pp.pers_ncorr = ddp.pers_ncorr and   ";
			sql = sql + " 		ddp.tdir_ccod=1 and   ";
			sql = sql + " 		ddp.ciud_ccod*=c.ciud_ccod  and   ";
			sql = sql + " 		p.ofer_ncorr=oa.ofer_ncorr and   ";
			sql = sql + " 		oa.espe_ccod=ee.espe_ccod and   ";
			sql = sql + " 		ee.carr_ccod=ccc.carr_ccod and  ";
			sql = sql + " 		oa.SEDE_CCOD= ss.sede_ccod and ";
			sql = sql + "		oa.peri_ccod=pac.peri_ccod and ";
			sql = sql + " 		p.post_ncorr= isnull('" + post_ncorr + "','') ";

			return (sql);

		}
		
*/

		/*******************************************************************
		DESCRIPCION		:
		FECHA CREACIÓN		:
		CREADO POR 		:
		ENTRADA		:NA
		SALIDA			:NA
		MODULO QUE ES UTILIZADO:

		--ACTUALIZACION--

		FECHA ACTUALIZACION 	:15/04/2013
		ACTUALIZADO POR		:JAIME PAINEMAL A.
		MOTIVO			:Corregir código; eliminar sentencia *=
		LINEA			: 34
		********************************************************************/

		private string EscribirCodigo( string post_ncorr)
		{
			string sql;
		    
			sql = " select  isnull (protic.ano_ingreso_carrera(p.pers_ncorr,ee.carr_ccod),pac.ANOS_CCOD) ano_ingreso, ss.SEDE_TDESC as nombre_sede, ";
			sql = sql + " 		pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as nombre_alumno,  ";
			sql = sql + " 		convert(char(8),pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post,  ";
			sql = sql + " 		ccc.carr_tdesc as carrera,  ";
			sql = sql + " 		ddp.DIRE_TCALLE +' ' + ddp.DIRE_TNRO as direccion,  ";
			sql = sql + " 		ddp.DIRE_TFONO as fono, ";
			sql = sql + " 		c.CIUD_TDESC as ciudad, c.CIUD_TCOMUNA as comuna ";
			sql = sql + " from postulantes p ";
			sql = sql + " INNER JOIN personas_postulante pp ";
			sql = sql + " ON p.pers_ncorr = pp.pers_ncorr and p.post_ncorr =  isnull('" + post_ncorr + "','') ";
			sql = sql + " INNER JOIN direcciones_publica ddp ";
			sql = sql + " ON pp.pers_ncorr = ddp.pers_ncorr and ddp.tdir_ccod = 1 ";
			sql = sql + " LEFT OUTER JOIN ciudades c ";
			sql = sql + " ON ddp.ciud_ccod = c.ciud_ccod  ";
			sql = sql + " INNER JOIN ofertas_academicas oa ";
			sql = sql + " ON p.ofer_ncorr = oa.ofer_ncorr ";
			sql = sql + " INNER JOIN especialidades ee ";
			sql = sql + " ON oa.espe_ccod = ee.espe_ccod ";
			sql = sql + " INNER JOIN carreras ccc ";
			sql = sql + " ON ee.carr_ccod = ccc.carr_ccod ";
			sql = sql + " INNER JOIN sedes ss ";
			sql = sql + " ON oa.SEDE_CCOD = ss.sede_ccod ";
			sql = sql + " INNER JOIN periodos_academicos pac ";
			sql = sql + " ON oa.peri_ccod = pac.peri_ccod  ";

			return (sql);
		
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string post_ncorr;
			post_ncorr = Request.QueryString["post_ncorr"];
			
			CrystalFichaAlumno reporte = new CrystalFichaAlumno();
			
				sql = EscribirCodigo(post_ncorr);
			    //Response.Write(sql);
			    //Response.End();
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(datosAlumno1);
				
				
			reporte.SetDataSource(datosAlumno1);
			VerAlumno.ReportSource = reporte;
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
			this.datosAlumno1 = new ficha_alumno.datosAlumno();
			((System.ComponentModel.ISupportInitialize)(this.datosAlumno1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "alumno", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("ANO_INGRESO", "ANO_INGRESO"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_SEDE", "NOMBRE_SEDE"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																				  new System.Data.Common.DataColumnMapping("FONO", "FONO"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD", "CIUDAD"),
																																																				  new System.Data.Common.DataColumnMapping("COMUNA", "COMUNA")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS ANO_INGRESO, \'\' AS NOMBRE_SEDE, \'\' AS NOMBRE_ALUMNO, \'\' AS RUT_POST," +
				" \'\' AS CARRERA, \'\' AS DIRECCION, \'\' AS FONO, \'\' AS CIUDAD, \'\' AS COMUNA FROM DUA" +
				"L";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosAlumno1
			// 
			this.datosAlumno1.DataSetName = "datosAlumno";
			this.datosAlumno1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosAlumno1.Namespace = "http://www.tempuri.org/datosAlumno.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosAlumno1)).EndInit();

		}
		#endregion
	}
}
