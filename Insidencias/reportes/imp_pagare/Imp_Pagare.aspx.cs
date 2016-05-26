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

namespace imp_pagare
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected imp_pagare.DataSet1 datosPagare1;
		protected CrystalDecisions.Web.CrystalReportViewer VerPagare;
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

		private string EscribirCodigo( string post_ncorr)
		{
			string sql;
		    
			sql = "select pag.PAGA_NCORR nro_pagare,(nvl(bba.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,";
			sql = sql + "to_char(sysdate, 'DD') dd_hoy, ";
			sql = sql + " to_char(sysdate, 'MONTH') mm_hoy,to_char(sysdate, 'YYYY') yy_hoy, ";
			sql = sql + "ciu.ciud_tdesc ciudad_sede, pac.anos_ccod periodo_academico, ";
			sql = sql + " (pac.anos_ccod  + 1) as inicio_vencimiento, ";
			sql = sql + " (pac.anos_ccod  + 2) as final_vencimiento, ";
			sql = sql + " pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post, ";
			sql = sql + " pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno nombre_alumno, ";
			sql = sql + " cc.carr_tdesc as carrera, ";
		
			sql = sql + " ppc.PERS_NRUT ||'-'||ppc.PERS_XDV as rut_codeudor,  ";
			sql = sql + " ppc.pers_tnombre ||' '|| ppc.pers_tape_paterno || ' ' || ppc.pers_tape_materno  as nombre_codeudor, ";
			sql = sql + " ddc.DIRE_TCALLE ||' ' || ddc.DIRE_TNRO as direccion_codeudor, ";
			sql = sql + " c.CIUD_TDESC ciudad_codeudor, ";
			sql = sql + " ddp.DIRE_TCALLE ||' ' || ddp.DIRE_TNRO as direccion_postulante, ";
			sql = sql + " ccp.CIUD_TDESC ciudad_codeudor1 ";
			sql = sql + " from postulantes p,personas_postulante pp, ";
			sql = sql + " personas_postulante ppc,ofertas_academicas oa,  ";
			sql = sql + " especialidades ee, carreras cc,  ";
			sql = sql + " codeudor_postulacion cp, ";

			sql = sql + " direcciones_publica ddp, ciudades c,ciudades ccp, ";
			sql = sql + " direcciones_publica ddc,periodos_academicos pac, ";
        
			sql = sql + " beneficios bba, ";
			sql = sql + " contratos con, pagares pag, sedes ss, ciudades ciu  ";
			sql = sql + " where p.pers_ncorr=pp.pers_ncorr  ";
			sql = sql + " and p.post_ncorr=   nvl('" + post_ncorr +"',0)";
		
			sql = sql + " and con.post_ncorr=p.post_ncorr  ";
			sql = sql + " and con.CONT_NCORR=pag.CONT_NCORR  ";
			sql = sql + " and pag.PAGA_NCORR=bba.PAGA_NCORR  ";
 		
 		
			sql = sql + " and bba.EBEN_CCOD <>3  ";
			sql = sql + " and con.econ_ccod<>3  ";
		
			sql = sql + " and p.post_ncorr=cp.post_ncorr ";
			sql = sql + " and cp.pers_ncorr =ppc.pers_ncorr  ";
		
			sql = sql + " and ppc.pers_ncorr = ddc.pers_ncorr ";
			sql = sql + " and ddc.tdir_ccod=1 ";
			sql = sql + " and ddc.ciud_ccod=c.ciud_ccod (+) ";
		
		
			sql = sql + " and pp.pers_ncorr = ddp.pers_ncorr ";
			sql = sql + " and ddp.tdir_ccod=1 ";
			sql = sql + " and ddp.ciud_ccod=ccp.ciud_ccod (+) ";
		
			sql = sql + " and p.ofer_ncorr=oa.ofer_ncorr  ";
			sql = sql + " and oa.peri_ccod=pac.peri_ccod  ";
			sql = sql + " and oa.espe_ccod=ee.espe_ccod  ";

			sql = sql + " and oa.sede_ccod=ss.sede_ccod  ";
			sql = sql + " and ss.ciud_ccod= ciu.ciud_ccod ";

			sql = sql + " and ee.carr_ccod=cc.carr_ccod	";
			return (sql);
		
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string post_ncorr;
			post_ncorr = Request.QueryString["post_ncorr"];

			sql = EscribirCodigo(post_ncorr);
			//Response.Write(sql);
			//Response.End();
			CrystalReportPagare reporte = new CrystalReportPagare();
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datosPagare1);
					
				
			reporte.SetDataSource(datosPagare1);
			VerPagare.ReportSource = reporte;
			ExportarPDF(reporte);}

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
			this.datosPagare1 = new imp_pagare.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Pagare", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_SEDE", "CIUDAD_SEDE"),
																																																				  new System.Data.Common.DataColumnMapping("NRO_PAGARE", "NRO_PAGARE"),
																																																				  new System.Data.Common.DataColumnMapping("VALOR_PAGAR", "VALOR_PAGAR"),
																																																				  new System.Data.Common.DataColumnMapping("DD_HOY", "DD_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("MM_HOY", "MM_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("YY_HOY", "YY_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("PERIODO_ACADEMICO", "PERIODO_ACADEMICO"),
																																																				  new System.Data.Common.DataColumnMapping("INICIO_VENCIMIENTO", "INICIO_VENCIMIENTO"),
																																																				  new System.Data.Common.DataColumnMapping("FINAL_VENCIMIENTO", "FINAL_VENCIMIENTO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_CODEUDOR", "RUT_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_CODEUDOR", "NOMBRE_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECCION_CODEUDOR", "DIRECCION_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_CODEUDOR", "CIUDAD_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECCION_POSTULANTE", "DIRECCION_POSTULANTE"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_CODEUDOR1", "CIUDAD_CODEUDOR1")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CIUDAD_SEDE, '' AS NRO_PAGARE, '' AS VALOR_PAGAR, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS PERIODO_ACADEMICO, '' AS INICIO_VENCIMIENTO, '' AS FINAL_VENCIMIENTO, '' AS RUT_POST, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS DIRECCION_CODEUDOR, '' AS CIUDAD_CODEUDOR, '' AS DIRECCION_POSTULANTE, '' AS CIUDAD_CODEUDOR FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// datosPagare1
			// 
			this.datosPagare1.DataSetName = "DataSet1";
			this.datosPagare1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.datosPagare1.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).EndInit();

		}
		#endregion
	}
}
