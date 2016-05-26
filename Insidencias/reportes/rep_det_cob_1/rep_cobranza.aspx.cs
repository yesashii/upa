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

namespace rep_det_cob
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected rep_det_cob.datosReporte datosReporte1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
	
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


		private string EscribirCodigo(string periodo,string sede,string empresa,
			                          string folio,string inicio,string termino,
									  string tipo_docto,string nro_docto,string estado_docto,
									  string rut_alumno,string rut_alumno_digito,
								      string rut_apoderado,string  rut_apoderado_digito)
		{
			string sql;
		    
			sql = " SELECT d1.ting_tdesc tipo,to_char(d.ingr_fpago,'DD/MM/YYYY')  fecha_emision, ";
			sql = sql + " 				b.ding_ndocto nro_ndocto, c.ding_mdocto monto, to_char(c.ding_fdocto,'DD/MM/YYYYY') fecha_ven,    ";
			sql = sql + " 				c1.edin_tdesc estado,  ";
			sql = sql + " 				e.pers_nrut || '-' || e.pers_xdv as rut_alumno,    ";
			sql = sql + " 				g1.pers_nrut || '-' || g1.pers_xdv as rut_apoderado    ";
			sql = sql + " 				FROM envios a, detalle_envios b, detalle_ingresos c,    ";
			sql = sql + " 				estados_detalle_ingresos c1, ingresos d, tipos_ingresos d1,    ";
			sql = sql + " 				personas e, postulantes f, codeudor_postulacion g,   ";
			sql = sql + " 				personas g1,instituciones_envio h,   ";
			sql = sql + " 				alumnos k,ofertas_academicas l, sedes m    ";
			sql = sql + " 				WHERE a.envi_ncorr = b.envi_ncorr and    ";
			sql = sql + " 				b.ting_ccod = c.ting_ccod and    ";
			sql = sql + " 				c.ting_ccod = d1.ting_ccod and    ";
			sql = sql + " 				b.ding_ndocto = c.ding_ndocto and    ";
			sql = sql + " 				b.ingr_ncorr = c.ingr_ncorr and    ";
			sql = sql + " 				c.ingr_ncorr = d.ingr_ncorr and    ";
			sql = sql + " 				c.edin_ccod = c1.edin_ccod and    ";
			sql = sql + " 				d.pers_ncorr = e.pers_ncorr and    ";
			sql = sql + " 				e.pers_ncorr = f.pers_ncorr and    ";
			sql = sql + " 				f.post_ncorr = g.post_ncorr and    ";
			sql = sql + " 				g.pers_ncorr = g1.pers_ncorr and    ";
			sql = sql + " 				f.peri_ccod= "+ periodo +" AND    ";
			sql = sql + " 				f.post_ncorr = k.post_ncorr (+) and    ";
			sql = sql + " 				k.ofer_ncorr = l.ofer_ncorr (+) and  ";
			sql = sql + " 				l.sede_ccod = m.sede_ccod (+) and   ";
			sql = sql + " 				a.inen_ccod = h.inen_ccod and    ";
			sql = sql + " 				h.TINE_CCOD in (3,4) and   ";
			sql = sql + " 				e.pers_nrut = nvl('"+ rut_alumno+ "', e.pers_nrut) and    ";
			sql = sql + " 				g1.pers_nrut = nvl('"+ rut_apoderado+ "', g1.pers_nrut) and    ";
			sql = sql + " 				trunc(d.ingr_fpago) BETWEEN nvl('"+ inicio+ "', d.ingr_fpago) AND nvl('"+ termino+ "', d.ingr_fpago) and      ";
			
			sql = sql + " 				m.sede_ccod = nvl('"+ sede+ "', m.sede_ccod) and    ";
			sql = sql + " 				b.ting_ccod = nvl('"+ tipo_docto+ "', b.ting_ccod) and    ";
			sql = sql + " 				b.ding_ndocto = nvl('"+ nro_docto+ "', b.ding_ndocto) and    ";
			sql = sql + " 				c.edin_ccod  = nvl('"+ estado_docto+ "', c.edin_ccod )   ";
			sql = sql + "				and c.repa_ncorr is null ";
		    sql = sql + "				and c.ding_ncorrelativo = 1 ";
			sql = sql + " 				ORDER BY a.envi_ncorr   ";

			
			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			
			string periodo;
			string sede;
 			string empresa;
 			string folio;
 			string inicio;
 			string termino;
 			string tipo_docto;
 			string nro_docto; 
 			string estado_docto;
 			string rut_alumno;
 			string rut_alumno_digito;
 			string rut_apoderado;
			string  rut_apoderado_digito;
     
			
			
			sede= Request.QueryString["busqueda[0][sede_ccod]"];
			periodo = Request.QueryString["periodo"];
			empresa = Request.QueryString["busqueda[0][inen_ccod]"];
			folio = Request.QueryString["busqueda[0][envi_ncorr]"];
			inicio = Request.QueryString["busqueda[0][envi_fenvio]"];
			termino = Request.QueryString["busqueda[0][envio_termino]"];
			tipo_docto = Request.QueryString["busqueda[0][ting_ccod]"];
			nro_docto = Request.QueryString["busqueda[0][ding_ndocto]"]; 
			estado_docto = Request.QueryString["busqueda[0][edin_ccod]"]; 
			rut_alumno = Request.QueryString["busqueda[0][pers_nrut]"];
			rut_alumno_digito = Request.QueryString["busqueda[0][pers_xdv]"];
			rut_apoderado = Request.QueryString["busqueda[0][code_nrut]"];
			rut_apoderado_digito = Request.QueryString["busqueda[0][code_xdv]"];


			CrystalReportReporte reporte = new CrystalReportReporte();
			
			sql = EscribirCodigo(periodo,sede,empresa,folio,inicio,termino,tipo_docto,nro_docto,estado_docto,rut_alumno,rut_alumno_digito,rut_apoderado,rut_apoderado_digito);
			//Response.Write(sql);
			//Response.End();
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datosReporte1);
					
				
			reporte.SetDataSource(datosReporte1);
			VerReporte.ReportSource = reporte;
			//Response.Write("holaa" + periodo);
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
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();

		}
		#endregion

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}
	}
}
