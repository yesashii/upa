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

namespace edicion_envios_cobranza
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected edicion_envios_cobranza.datosEnvios datosEnvios1;
		protected CrystalDecisions.Web.CrystalReportViewer VerEnvios;
	
		

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


		private string EscribirCodigo( string periodo, string folio_envio,string empresa, string fecha)
		{
			string sql;
		    
			sql =  " SELECT distinct  i.ting_tdesc tipo_docto,a.ding_ndocto nro_docto, a.ding_mdocto monto,a.ding_tcuenta_corriente c_corriente, trunc(b.ingr_fpago) fecha_emision,  ";
			sql = sql + " '"+folio_envio+"' as nro_folio, '"+empresa+"' as nombre_empresa, '"+fecha + "' as fecha_reporte,";
			
			sql = sql + "          h.edin_tdesc estado, obtener_rut(b.pers_ncorr) as rut_alumno,  ";
			sql = sql + " 		obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado,  ";
			sql = sql + " tiene_multa_protesto(a.ting_ccod,a.ding_ndocto,a.ingr_ncorr) multa_protesto,";
			sql = sql + " 		obtener_nombre_completo(a.pers_ncorr_codeudor) as nombre_apoderado   ";
			sql = sql + " 	 from envios ee,  \n";
			sql = sql + " 	 detalle_envios de,  \n";
			sql = sql + " 	 detalle_ingresos a,   \n";
			sql = sql + " 	 estados_detalle_ingresos a1,   \n";
			sql = sql + " 	 ingresos b,   \n";
			sql = sql + " 	 estados_detalle_ingresos h,   \n";
			sql = sql + " 	 tipos_ingresos i,    \n";
			sql = sql + " 		  personas j,  \n";
			sql = sql + " 		  personas k,   \n";
			sql = sql + " 		  abonos l,   \n";
			sql = sql + " 		  detalle_compromisos m,   \n";
			sql = sql + " 		  postulantes n,  \n";
			sql = sql + " 		  ofertas_academicas o  \n";
			sql = sql + " 	 where   \n";
			sql = sql + " 	   ee.envi_ncorr = de.envi_ncorr  \n";
			sql = sql + " 	   and de.ting_ccod = a.ting_ccod  \n";
			sql = sql + " 	   and de.ding_ndocto = a.ding_ndocto   \n";
			sql = sql + " 	 and de.ingr_ncorr = a.ingr_ncorr   \n";
			sql = sql + " 	   and a.ingr_ncorr = b.ingr_ncorr     \n";
			sql = sql + "       and a.edin_ccod = a1.edin_ccod   \n";
			sql = sql + "       and a.ding_ncorrelativo = 1    \n";
			sql = sql + " 	   and a.edin_ccod = h.edin_ccod    \n";
			sql = sql + " 	   and a.ting_ccod = i.ting_ccod   \n";
			sql = sql + " 	   and b.pers_ncorr = j.pers_ncorr    \n";
			sql = sql + " 	   and a.pers_ncorr_codeudor  = k.pers_ncorr  (+)  \n";
			sql = sql + " 	   and b.ingr_ncorr = l.ingr_ncorr    \n";
			sql = sql + " 	   and l.tcom_ccod = m.tcom_ccod   \n";
			sql = sql + " 	   and l.inst_ccod = m.inst_ccod   \n";
			sql = sql + " 	   and l.comp_ndocto = m.comp_ndocto   \n";
			sql = sql + " 	   and l.dcom_ncompromiso = m.dcom_ncompromiso   \n";
			sql = sql + " 	   and b.pers_ncorr = n.pers_ncorr  (+) \n";
			//sql = sql + " 	   and m.peri_ccod = n.peri_ccod   \n";
			sql = sql + " 	   and n.ofer_ncorr = o.ofer_ncorr  (+) \n";
			sql = sql + " 	   AND ee.envi_ncorr=" + folio_envio;
			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string folio_envio;
			string periodo;
			string fecha;
			string empresa;

			folio_envio  = Request.QueryString["folio_envio"];
			empresa  = Request.QueryString["empresa"];
			fecha = Request.QueryString["fecha"];
            periodo  = Request.QueryString["periodo"];

			CrystalReportEnvios reporte = new CrystalReportEnvios();
			
				sql = EscribirCodigo( periodo , folio_envio, empresa, fecha);
			    //Response.Write(sql);
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(datosEnvios1);
					
				
			reporte.SetDataSource(datosEnvios1);
			VerEnvios.ReportSource = reporte;
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
			this.datosEnvios1 = new edicion_envios_cobranza.datosEnvios();
			((System.ComponentModel.ISupportInitialize)(this.datosEnvios1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "envios_cobranza", new System.Data.Common.DataColumnMapping[] {
																																																						   new System.Data.Common.DataColumnMapping("ESTADO", "ESTADO"),
																																																						   new System.Data.Common.DataColumnMapping("NRO_DOCTO", "NRO_DOCTO"),
																																																						   new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																						   new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																						   new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																						   new System.Data.Common.DataColumnMapping("FECHA_EMISION", "FECHA_EMISION"),
																																																						   new System.Data.Common.DataColumnMapping("MONTO", "MONTO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS TIPO_DOCTO, '' AS ESTADO, '' AS NRO_DOCTO, '' AS RUT_ALUMNO, '' AS RUT_APODERADO, '' AS NOMBRE_APODERADO, '' AS FECHA_EMISION, '' AS MONTO, '' AS NOMBRE_EMPRESA, '' AS FECHA_REPORTE, '' AS NRO_FOLIO, '' AS C_CORRIENTE, '' AS MULTA_PROTESTO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosEnvios1
			// 
			this.datosEnvios1.DataSetName = "datosEnvios";
			this.datosEnvios1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosEnvios1.Namespace = "http://www.tempuri.org/datosEnvios.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosEnvios1)).EndInit();

		}
		#endregion
	}
}
