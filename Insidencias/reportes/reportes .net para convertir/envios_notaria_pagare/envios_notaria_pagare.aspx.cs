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
namespace envios_notaria_pagare
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReportePagare;
		protected envios_notaria_pagare.datosPagare datosPagare1;
	
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


		private string EscribirCodigo( string folio_envio,string empresa, string fecha)
		{
			string sql;
		    
			sql =  " SELECT  '"+folio_envio+"' as folio, '"+empresa+"' as empresa,'"+fecha+"' as fecha_en, ";
			sql = sql + "			to_char(a.enpa_fenvio, 'DD/MM/YYYY') fecha_envio,  ";
			sql = sql + "                 (nvl(bb.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bb.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,  ";
			sql = sql + " 				p1.EPAG_TDESC estado_pagare, p.paga_ncorr, ";
			sql = sql + " 				e.pers_nrut || '-' || e.pers_xdv as rut_alumno,   ";
			sql = sql + " 		        g1.pers_nrut || '-' || g1.pers_xdv as rut_apoderado,   ";
			sql = sql + " 		        g1.pers_tnombre || ' ' || g1.pers_tape_paterno as nombre_apoderado    ";
			sql = sql + " 		   FROM envios_pagares a,   ";
			sql = sql + " 				detalle_envios_pagares b,   ";
			sql = sql + " 				pagares p,  ";
			sql = sql + " 				estados_pagares p1,  ";
			sql = sql + " 				contratos c,  ";
			sql = sql + " 			    personas e,   ";
			sql = sql + " 				postulantes f,   ";
			sql = sql + " 				codeudor_postulacion g,   ";
			sql = sql + " 				personas g1,  ";
			sql = sql + " 				beneficios bb   ";
			sql = sql + " 		  WHERE a.enpa_ncorr = b.enpa_ncorr   ";
			sql = sql + " 			  and b.paga_ncorr = p.paga_ncorr  ";
			sql = sql + " 			  and b.enpa_ncorr = p.enpa_ncorr  ";
			sql = sql + " 			  and p.epag_ccod = p1.epag_ccod  ";
			sql = sql + " 			  and p.cont_ncorr = c.cont_ncorr  ";
			sql = sql + " 			  and c.econ_ccod  <>3   ";
			sql = sql + " 			  and p.PAGA_NCORR=bb.PAGA_NCORR    ";
			sql = sql + "  		      and bb.EBEN_CCOD <>3   ";
			sql = sql + " 			  and c.post_ncorr=f.post_ncorr   ";
			sql = sql + " 			  and f.pers_ncorr = e.pers_ncorr   ";
			sql = sql + "  			  and f.post_ncorr = g.post_ncorr    ";
			sql = sql + " 			  and g1.pers_ncorr (+)= g.pers_ncorr   ";
			sql = sql + " 			  and a.enpa_ncorr=" +folio_envio;
			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string folio_envio;
			
			string fecha;
			string empresa;

			folio_envio  = Request.QueryString["folio_envio"];
			empresa  = Request.QueryString["empresa"];
			fecha = Request.QueryString["fecha"];
			

			CrystalReport1 reporte = new CrystalReport1();
			
			sql = EscribirCodigo( folio_envio, empresa, fecha);
			//Response.Write(sql);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datosPagare1);
					
				
			reporte.SetDataSource(datosPagare1);
			VerReportePagare.ReportSource = reporte;
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
			this.datosPagare1 = new envios_notaria_pagare.datosPagare();
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "envioPagare", new System.Data.Common.DataColumnMapping[] {
																																																					   new System.Data.Common.DataColumnMapping("FOLIO", "FOLIO"),
																																																					   new System.Data.Common.DataColumnMapping("EMPRESA", "EMPRESA"),
																																																					   new System.Data.Common.DataColumnMapping("FECHA_EN", "FECHA_EN"),
																																																					   new System.Data.Common.DataColumnMapping("FECHA_ENVIO", "FECHA_ENVIO"),
																																																					   new System.Data.Common.DataColumnMapping("VALOR_PAGAR", "VALOR_PAGAR"),
																																																					   new System.Data.Common.DataColumnMapping("ESTADO_PAGARE", "ESTADO_PAGARE"),
																																																					   new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																					   new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																					   new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS FOLIO, \'\' AS EMPRESA, \'\' AS FECHA_EN, \'\' AS FECHA_ENVIO, \'\' AS VALOR" +
				"_PAGAR, \'\' AS ESTADO_PAGARE, \'\' AS RUT_ALUMNO, \'\' AS RUT_APODERADO, \'\' AS NOMBRE" +
				"_APODERADO, \'\' AS PAGA_NCORR FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosPagare1
			// 
			this.datosPagare1.DataSetName = "datosPagare";
			this.datosPagare1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosPagare1.Namespace = "http://www.tempuri.org/datosPagare.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).EndInit();

		}
		#endregion
	}
}
