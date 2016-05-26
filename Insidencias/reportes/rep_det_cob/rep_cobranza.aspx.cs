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

/*
		private string EscribirCodigo(string periodo,string sede,string empresa,
			                          string folio,string inicio,string termino,
									  string tipo_docto,string nro_docto,string estado_docto,
									  string rut_alumno,string rut_alumno_digito,
								      string rut_apoderado,string  rut_apoderado_digito,
			                          string nro_cuenta_corriente)
		{
			string sql;
			
			sql = " SELECT i.ting_tdesc tipo,to_char(b.ingr_fpago,'DD/MM/YYYY')  fecha_emision, ";
			sql = sql + " 	a.ding_ndocto nro_ndocto, a.ding_mdocto monto,a.ding_tcuenta_corriente c_corriente, trunc(a.ding_fdocto) fecha_ven,    ";
			sql = sql + " 	h.edin_tdesc estado,  ";
			sql = sql + " 	obtener_rut(b.pers_ncorr) as rut_alumno,    ";
			sql = sql + " 	obtener_rut(a.pers_ncorr_codeudor)  as rut_apoderado    ";
			sql = sql + " 	 from envios ee,   ";
			sql = sql + " 	 detalle_envios de,   ";
			sql = sql + " 	 detalle_ingresos a,    ";
			sql = sql + " 	 estados_detalle_ingresos a1,    ";
			sql = sql + " 	 ingresos b,    ";
			sql = sql + " 	 estados_detalle_ingresos h,    ";
			sql = sql + " 	 tipos_ingresos i,     ";
			sql = sql + " 		  personas j,   ";
			sql = sql + " 		  personas k,    ";
			sql = sql + " 		  abonos l,    ";
			sql = sql + " 		  detalle_compromisos m,    ";
			sql = sql + " 		  postulantes n,   ";
			sql = sql + " 		  ofertas_academicas o ,instituciones_envio h,familias_estados_detalle_ingr fe   ";
			sql = sql + " 	 where    ";
			sql = sql + " 	   ee.envi_ncorr = de.envi_ncorr  ";
			sql = sql + " 	   and de.ting_ccod = a.ting_ccod   ";
			sql = sql + " 	   and de.ding_ndocto = a.ding_ndocto    ";
			sql = sql + " 	 and de.ingr_ncorr = a.ingr_ncorr    ";
			sql = sql + " 	   and a.ingr_ncorr = b.ingr_ncorr      ";
			sql = sql + "       and a.edin_ccod = a1.edin_ccod    ";
			sql = sql + " 		and a1.fedi_ccod = fe.fedi_ccod   ";
			sql = sql + "       and a.ding_ncorrelativo = 1     ";
			sql = sql + " 	   and a.edin_ccod = h.edin_ccod     ";
			sql = sql + " 	   and a.ting_ccod = i.ting_ccod    ";
			sql = sql + " 	   and b.pers_ncorr = j.pers_ncorr    ";
			sql = sql + " 	   and a.pers_ncorr_codeudor  = k.pers_ncorr  (+)   ";
			sql = sql + " 	   and b.ingr_ncorr = l.ingr_ncorr    ";
			sql = sql + " 	   and l.tcom_ccod = m.tcom_ccod    ";
			sql = sql + " 	   and l.inst_ccod = m.inst_ccod    ";
			sql = sql + " 	   and l.comp_ndocto = m.comp_ndocto   ";
			sql = sql + " 	   and l.dcom_ncompromiso = m.dcom_ncompromiso    ";
			sql = sql + " 	   and b.pers_ncorr = n.pers_ncorr    ";
			sql = sql + " 	   and m.peri_ccod = n.peri_ccod    ";
			sql = sql + " 	   and n.ofer_ncorr = o.ofer_ncorr   ";
			sql = sql + " 	   and ee.inen_ccod = h.inen_ccod     ";
			sql = sql + " 	   and h.TINE_CCOD in (3,4)  ";
			if (rut_alumno !="") 
			{
				sql = sql + "and j.pers_nrut = '"  + rut_alumno + "'";
			}
			if (rut_apoderado !="")
			{
				sql = sql + "and k.pers_nrut = '"  + rut_apoderado +"' ";

			}
			if (inicio != "" && termino != "" )
			{
				sql = sql + " and b.ingr_fpago BETWEEN '"+ inicio+ "'";
				sql = sql + " and '"+ termino+ "' ";
			}

			if (sede != ""  )
			{
				sql = sql + " and o.sede_ccod ='"  + sede + " '";
				
			}
			
			if (nro_docto != ""  )
			{
				sql = sql + " and a.ding_ndocto = '"  + nro_docto +"' ";
				
			}
			if (nro_cuenta_corriente != ""  )
			{
				sql = sql + " and nvl(a.ding_tcuenta_corriente , ' ') = nvl(nvl('"  + nro_cuenta_corriente + " ',a.ding_tcuenta_corriente), ' ')  ";
				
			}
			if (tipo_docto != ""  )
			{
				sql = sql + " and de.ting_ccod = '"  + tipo_docto +"' ";
				
			}
			if (estado_docto != ""  )
			{
				sql = sql + " and fe.fedi_ccod  = '"  + estado_docto +"' ";
				
			}

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
		LINEA			: 124,125
		********************************************************************/

		private string EscribirCodigo(string periodo,string sede,string empresa,
			string folio,string inicio,string termino,
			string tipo_docto,string nro_docto,string estado_docto,
			string rut_alumno,string rut_alumno_digito,
			string rut_apoderado,string  rut_apoderado_digito,
			string nro_cuenta_corriente)
		{
			string sql;

			sql = "";

			sql = " SELECT i.ting_tdesc tipo, CONVERT(VARCHAR,b.ingr_fpago,105) fecha_emision,  ";
			sql = sql + " 	a.ding_ndocto nro_ndocto, a.ding_mdocto monto, a.ding_tcuenta_corriente c_corriente, CONVERT(VARCHAR(12),a.ding_fdocto, 101) fecha_ven,     ";
			sql = sql + "	h.edin_tdesc estado,   ";
			sql = sql + " 	PROTIC.obtener_rut(b.pers_ncorr) as rut_alumno,     ";
			sql = sql + " 	PROTIC.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado     ";
			sql = sql + " 	 from envios ee  ";
			sql = sql + " 	 INNER JOIN detalle_envios de  ";
			sql = sql + " 	 ON ee.envi_ncorr = de.envi_ncorr   ";

			if (tipo_docto != ""  )
			{
				sql = sql + "	 and de.ting_ccod = '"  + tipo_docto +"' 	 ";
			}

			sql = sql + "	 INNER JOIN detalle_ingresos a  ";
			sql = sql + "	 ON de.ting_ccod = a.ting_ccod and de.ding_ndocto = a.ding_ndocto and de.ingr_ncorr = a.ingr_ncorr and a.ding_ncorrelativo = 1  ";

			if (nro_docto != ""  )
			{
				sql = sql + "	 and a.ding_ndocto = '"  + nro_docto +"' 	 ";
			}

			if (nro_cuenta_corriente != ""  )
			{
				sql = sql + "	 and ISNULL(a.ding_tcuenta_corriente , ' ') = ISNULL(ISNULL('"  + nro_cuenta_corriente + " ',a.ding_tcuenta_corriente), ' ')   ";
			}

			sql = sql + " 	 INNER JOIN ingresos b  ";
			sql = sql + " 	 ON a.ingr_ncorr = b.ingr_ncorr   ";

			if (inicio != "" && termino != "" )
			{
				sql = sql + "	 and b.ingr_fpago BETWEEN '"+ inicio+ "' and '"+ termino+ "'   ";
			}

			sql = sql + " 	 INNER JOIN estados_detalle_ingresos a1  ";
			sql = sql + " 	 ON a.edin_ccod = a1.edin_ccod     ";
			sql = sql + " 	 INNER JOIN familias_estados_detalle_ingr fe  ";
			sql = sql + " 	 ON a1.fedi_ccod = fe.fedi_ccod  ";

			if (estado_docto != ""  )
			{
				sql = sql + "	 and fe.fedi_ccod  = '"  + estado_docto +"'  ";
			}	

			sql = sql + " 	 INNER JOIN estados_detalle_ingresos h  ";
			sql = sql + " 	 ON a.edin_ccod = h.edin_ccod      ";
			sql = sql + "	 INNER JOIN tipos_ingresos i  ";
			sql = sql + " 	 ON a.ting_ccod = i.ting_ccod   ";
			sql = sql + " 	 INNER JOIN personas j     ";
			sql = sql + "	 ON b.pers_ncorr = j.pers_ncorr     ";

			if (rut_alumno !="") 
			{
				sql = sql + "	and j.pers_nrut = '"  + rut_alumno + "'  ";
			}

			sql = sql + " 	 RIGHT OUTER JOIN personas k   ";
			sql = sql + " 	 ON a.pers_ncorr_codeudor = k.pers_ncorr   ";

			if (rut_apoderado !="")
			{
				sql = sql + "	and k.pers_nrut = '"  + rut_apoderado +"'  ";
			}

			sql = sql + "	 INNER JOIN abonos l  ";
			sql = sql + "	 ON b.ingr_ncorr = l.ingr_ncorr  ";
			sql = sql + "	 INNER JOIN detalle_compromisos m  ";
			sql = sql + " 	 ON l.tcom_ccod = m.tcom_ccod and l.inst_ccod = m.inst_ccod and l.comp_ndocto = m.comp_ndocto and l.dcom_ncompromiso = m.dcom_ncompromiso  ";
			sql = sql + " 	 INNER JOIN postulantes n  ";
			sql = sql + "	 ON b.pers_ncorr = n.pers_ncorr and m.peri_ccod = n.peri_ccod  ";
			sql = sql + " 	 INNER JOIN ofertas_academicas o  ";
			sql = sql + "	 ON n.ofer_ncorr = o.ofer_ncorr  ";

			if (sede != ""  )
			{
				sql = sql + "	 and o.sede_ccod = '"  + sede + "'  ";
			}

			sql = sql + " 	 INNER JOIN instituciones_envio hh  ";
			sql = sql + " 	 ON ee.inen_ccod = hh.inen_ccod and hh.TINE_CCOD in (3,4)   ";

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
			string nro_cuenta_corriente;
     
			
			
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
            nro_cuenta_corriente = Request.QueryString["busqueda[0][ding_tcuenta_corriente]"];

			CrystalReportReporte reporte = new CrystalReportReporte();
			
			sql = EscribirCodigo(periodo,sede,empresa,folio,inicio,termino,tipo_docto,nro_docto,estado_docto,rut_alumno,rut_alumno_digito,rut_apoderado,rut_apoderado_digito,nro_cuenta_corriente);
			
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datosReporte1);
					
				
			reporte.SetDataSource(datosReporte1);
			VerReporte.ReportSource = reporte;
			//Response.Write(sql);
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
			this.datosReporte1 = new rep_det_cob.datosReporte();
			((System.ComponentModel.ISupportInitialize)(this.datosReporte1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "reporte", new System.Data.Common.DataColumnMapping[] {
																																																				   new System.Data.Common.DataColumnMapping("TIPO", "TIPO"),
																																																				   new System.Data.Common.DataColumnMapping("FECHA_EMISION", "FECHA_EMISION"),
																																																				   new System.Data.Common.DataColumnMapping("NRO_NDOCTO", "NRO_NDOCTO"),
																																																				   new System.Data.Common.DataColumnMapping("MONTO", "MONTO"),
																																																				   new System.Data.Common.DataColumnMapping("FECHA_VEN", "FECHA_VEN"),
																																																				   new System.Data.Common.DataColumnMapping("ESTADO", "ESTADO"),
																																																				   new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				   new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS TIPO, \'\' AS FECHA_EMISION, \'\' AS NRO_NDOCTO, \'\' AS MONTO, \'\' AS FECH" +
				"A_VEN, \'\' AS ESTADO, \'\' AS RUT_ALUMNO, \'\' AS RUT_APODERADO, \'\' AS C_CORRIENTE FR" +
				"OM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosReporte1
			// 
			this.datosReporte1.DataSetName = "datosReporte";
			this.datosReporte1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosReporte1.Namespace = "http://www.tempuri.org/datosReporte.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosReporte1)).EndInit();

		}
		#endregion
	}
}
