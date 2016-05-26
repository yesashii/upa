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
using System.Data.OleDb;

namespace comp_cajas
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbConnection oleDbConnection2;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected comp_cajas.datos_comprobante datos_comprobante1;
		private bool b_intereses_repactacion;
	
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


		private string EscribirCodigo_doc(string nfolio, string nro_ting_ccod, string nombre_banco, string total)
		{
			string sql;

			sql = "";

			if (!b_intereses_repactacion) 	
			{		    
				sql = "select ii.pers_ncorr,di.ding_ndocto nro_documento,di.ding_fdocto fecha_documento, bb.banc_tdesc as nombre_banco,'"+nfolio+"' as nfolio,"; 
				sql = sql + " case isnull(di.ting_ccod,6) when 6 then 'EFECTIVO' else ti.ting_tdesc end as tipo_pago,";
				sql = sql + " case isnull(di.ting_ccod,6) when 6 then ii.ingr_mefectivo else di.ding_mdetalle end as monto_doc, ";
				sql = sql + " protic.trunc(ii.ingr_fpago) as ingr_fpago, ";
				sql = sql + " '' as detalles_compromiso, '"+total+"' total, case ii.ting_ccod when  17 then 'COMPROBANTE\n DE\n REGULARIZACIÓN' else replace(tii.ting_tdesc, ' ', '\n') end AS tdocumento,ii.ingr_ncorrelativo_caja ";
				sql = sql + " from ";
				sql = sql + " ingresos ii left outer join detalle_ingresos di";
				sql = sql + "    on ii.ingr_ncorr = di.ingr_ncorr ";
				sql = sql + " left outer join tipos_ingresos ti ";
				sql = sql + "    on di.TING_CCOD =ti.ting_ccod ";
				sql = sql + " left outer join bancos bb ";
				sql = sql + "    on di.BANC_CCOD =bb.BANC_CCOD ";
				sql = sql + " join  tipos_ingresos tii ";
				sql = sql + "    on ii.ting_ccod = tii.ting_ccod ";
				sql = sql + " where ii.ingr_nfolio_referencia= "+nfolio+" ";
				sql = sql + " and ii.ting_ccod="+nro_ting_ccod +" ";
				sql = sql + " and ii.EING_CCOD in (1,4,6,7)";

			}
			else {
				sql = "select a.pers_ncorr, '' as nro_documento, convert(varchar,max(a.ingr_fpago),103) as fecha_documento, convert(varchar,max(a.ingr_fpago),103) as ingr_fpago, \n";
				sql = sql +  " '' as nombre_banco, a.ingr_nfolio_referencia as nfolio, \n";
				sql = sql +  " '' as detalles_compromiso, d.ting_tdesc as tdocumento, \n";
				sql = sql +  " sum(a.ingr_mtotal) as monto_doc, sum(a.ingr_mtotal) as total, a.ingr_ncorrelativo_caja \n";
				sql = sql +  " from ingresos a, abonos b, detalle_ingresos c, tipos_ingresos d \n";
				sql = sql +  " where a.ingr_ncorr = b.ingr_ncorr \n";
				sql = sql +  "  and a.ingr_ncorr = c.ingr_ncorr \n";
				sql = sql +  "  and a.ting_ccod = d.ting_ccod \n";
				sql = sql +  "  and a.eing_ccod = 7 \n";
				sql = sql +  "  and b.tcom_ccod = 3 \n";
				sql = sql +  "  and cast(a.ingr_nfolio_referencia as varchar)= '" + nfolio + "' \n";
				sql = sql +  "  and cast(a.ting_ccod as varchar)= '" + nro_ting_ccod + "' \n";
				sql = sql +  " group by a.ingr_ncorrelativo_caja,a.pers_ncorr, a.ingr_nfolio_referencia, d.ting_tdesc \n";

			}

			
			return (sql);
		
		}

		private string EscribirCodigo_alumno( string pers_ncorr, string periodo)
		{
			string sql;
		    
			sql = " select pp.pers_ncorr,protic.codigo_alumno("+ pers_ncorr +",oa.peri_ccod) as codigo_alumno, ";
			sql = sql + " protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') nombre_carrera,oa.ofer_ncorr oferta, ";
			sql = sql + " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno nombre_alumno, "; 
			sql = sql + " cast(pp.pers_nrut as varchar) + '-' + pp.pers_xdv rut_alumno, ";
			sql = sql + " convert(varchar,getDate(),103) fecha_dia, ";
			sql = sql + " pp_c.pers_tnombre + ' ' + pp_c.pers_tape_paterno + ' ' + pp_c.pers_tape_materno nombre_codeudor, ";
			sql = sql + " cast(pp_c.pers_nrut as varchar)+ '-' + pp_c.pers_xdv rut_codeudor ";
			sql = sql + " from ofertas_academicas oa ";
			sql = sql + " right outer join alumnos aa ";
			sql = sql + "    on oa.ofer_ncorr = aa.ofer_ncorr and aa.emat_ccod = 1 ";
			sql = sql + " right outer join personas pp ";
			sql = sql + "    on aa.pers_ncorr = pp.pers_ncorr ";
			sql = sql + " right outer join postulantes pos ";
			sql = sql + "    on pos.pers_ncorr = pp.pers_ncorr and pos.peri_ccod = "+ periodo +" ";
			sql = sql + " left outer join codeudor_postulacion cp ";
			sql = sql + "    on pos.post_ncorr = cp.post_ncorr ";
			sql = sql + " right outer join  personas pp_c ";
			sql = sql + "    on pp_c.pers_ncorr  = cp.pers_ncorr ";
			sql = sql + " where pp.pers_ncorr= "+ pers_ncorr +"";
			sql = sql + " ORDER BY oa.peri_ccod DESC ";
			
			
			return (sql);
		
		}

		private string EscribirCodigo_compromiso(string nfolio, string nro_ting_ccod)
		{
			string sql;
		    
			if (!b_intereses_repactacion) 	{

				sql =  " SELECT dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO nro_documento,convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, ";
				sql = sql + " tc.tcom_tdesc tipo_compromiso,SUM(ab.ABON_MABONO) monto_abono, protic.initcap(ti.ting_tdesc) as ting_tdesc, protic.Documento_Asociado_Cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') AS ding_ndocto, ";
				sql = sql + " protic.initcap(isnull(td.tdet_tdesc, tc.tcom_tdesc)) as tipo_detalle, ";
				sql = sql + " protic.initcap(case ti.ting_tdesc when  null then '' else ti.ting_tdesc + ' Nº ' + cast(protic.Documento_Asociado_Cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')as varchar)end ) as detalle ";
				sql = sql + " FROM INGRESOS ii ";
				sql = sql + " join ABONOS ab ";
				sql = sql + "    on ii.ingr_ncorr=ab.INGR_NCORR ";
				sql = sql + " join DETALLE_COMPROMISOS dc ";
				sql = sql + "    on ab.TCOM_CCOD= dc.tcom_ccod AND ab.INST_CCOD=dc.INST_CCOD AND ab.COMP_NDOCTO=dc.COMP_NDOCTO AND ab.DCOM_NCOMPROMISO=dc.DCOM_NCOMPROMISO ";
				sql = sql + " join TIPOS_COMPROMISOS tc ";
				sql = sql + "    on dc.TCOM_CCOD=tc.TCOM_CCOD ";
				sql = sql + " left outer join detalles dd ";
				sql = sql + "    on  dc.tcom_ccod = dd.tcom_ccod and dc.inst_ccod = dd.inst_ccod and dc.comp_ndocto = dd.comp_ndocto ";
				sql = sql + " join tipos_detalle td ";
				sql = sql + "    on  dd.tdet_ccod = td.tdet_ccod ";
				sql = sql + " left outer join TIPOS_INGRESOS ti ";
				sql = sql + "    on  protic.Documento_Asociado_Cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod ";
				sql = sql + " WHERE cast(ii.ingr_nfolio_referencia as varchar)='"+nfolio +"'"; 
				sql = sql + "   AND cast(ii.ting_ccod as varchar)='"+nro_ting_ccod +"'"; 
				sql = sql + "   and isnull(ab.abon_mabono, 0) >= 0 ";
				sql = sql + "   and case dd.tdet_ccod when null then dc.tcom_ccod else  td.tcom_ccod end = dc.tcom_ccod ";
				sql = sql + "   GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ";
				sql = sql + "   ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc ";
				
				//Response.Write("Primer If <hr> ");
				//Response.Write(sql);
				//Response.Flush();

			}
			else {

				sql = " select 0 as tdet_ccod, 0 as tcom_ccod, 0 as tcom_ccod, b.comp_ndocto as nro_documento,  \n";
				sql = sql +  "           convert(varchar,max(protic.trunc(a.ingr_fpago)),103) as fecha_vencimiento,  \n";
				sql = sql +  " 			 protic.initcap(d.ting_tdesc) as tipo_compromiso,  \n"; 
				sql = sql +  " 			 sum(a.ingr_mtotal) as monto_abono,  \n"; 
				sql = sql +  "  			 protic.initcap(protic.DET_COMPINGRESO_INTREPACT(a.ingr_nfolio_referencia, a.ting_ccod)) as detalle, \n";
				sql = sql +  "  			 '*' as ding_ndocto,  \n"; 
				sql = sql +  "  			 protic.initcap(d.ting_tdesc) as tipo_detalle  \n";    
				sql = sql +  " from ingresos a, abonos b, detalle_ingresos c, tipos_ingresos d  \n"; 
				sql = sql +  " where a.ingr_ncorr = b.ingr_ncorr  \n";
				sql = sql +  "     and a.ingr_ncorr = c.ingr_ncorr  \n";
				sql = sql +  "     and c.ting_ccod = d.ting_ccod  \n";  
				sql = sql +  "     and a.eing_ccod = 7  \n";
				sql = sql +  "     and b.tcom_ccod = 3  \n";
				sql = sql +  "     and a.ingr_nfolio_referencia = '" + nfolio + "' \n";  
				sql = sql +  "     and a.ting_ccod = '" + nro_ting_ccod + "'  \n";   
				sql = sql +  "  group by a.ingr_nfolio_referencia, a.ting_ccod, b.comp_ndocto, d.ting_tdesc  \n";

				//Response.Write("Else <hr> ");
				//Response.Write(sql);
				//Response.Flush();

			}

			
			return (sql);

			
		
		}


		private void ComprobarTipoImpresion(string p_ingr_nfolio_referencia, string p_ting_ccod, string p_pers_ncorr)
		{
			OleDbCommand comando = new OleDbCommand();
			int v_eing_ccod;


			oleDbConnection1.Open();

			comando.Connection = oleDbConnection1;
			comando.CommandText = "select distinct a.eing_ccod from ingresos a where cast(a.ingr_nfolio_referencia as varchar) = '" + p_ingr_nfolio_referencia + "' and cast(a.ting_ccod as varchar)= '" + p_ting_ccod + "' and cast(a.pers_ncorr as varchar)= '" + p_pers_ncorr + "'";
			OleDbDataReader dr = comando.ExecuteReader();
			
			dr.Read();
			v_eing_ccod = (int) dr.GetDecimal(0);

			b_intereses_repactacion = ((v_eing_ccod == 7) && (!dr.Read())) ? true : false;

			dr.Close();
			
		}




		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql_alumno;
			string sql_documento;
			string sql_compromiso;

			string nfolio;
			string nro_ting_ccod;
			string pers_ncorr;
            string total;
			string detalle_compromiso;
			string nombre_banco;
			string periodo;
			
			
			nfolio = Request.QueryString["nfolio"];
			nro_ting_ccod = Request.QueryString["nro_ting_ccod"];
			pers_ncorr = Request.QueryString["pers_ncorr"];
			total = Request.QueryString["total"];
			detalle_compromiso = Request.QueryString["detalle_compromiso"];
			nombre_banco = Request.QueryString["nombre_banco"];
			periodo = Request.QueryString["peri_ccod"];
			
           /*
			nfolio="1121";
            nro_ting_ccod="36";
            pers_ncorr="23366";
            total="502";
            periodo="300";

			nfolio="10742";
			nro_ting_ccod="36";
			pers_ncorr="22430";
			total="25000";
			periodo="164";
			*/
			//nfolio=10742&nro_ting_ccod=36&pers_ncorr=22430&total=25000&peri_ccod=164
			//nfolio=1121&nro_ting_ccod=36&pers_ncorr=23366&total=502&peri_ccod=300 --> nota credito
			//nfolio=991&nro_ting_ccod=16&pers_ncorr=23122&total=6001&peri_ccod=300


			//CrystalReportReporte reporte = new CrystalReportReporte();
			CrystalNuevo reporte = new CrystalNuevo();


			ComprobarTipoImpresion(nfolio, nro_ting_ccod, pers_ncorr);


			sql_documento	= EscribirCodigo_doc(nfolio,nro_ting_ccod,nombre_banco,total);
			sql_alumno		= EscribirCodigo_alumno(pers_ncorr,periodo);
			sql_compromiso  = EscribirCodigo_compromiso(nfolio,nro_ting_ccod);

			/*Response.Write(sql_documento);
			Response.Write("<hr>");
			Response.Write(sql_alumno);
			Response.Write("<hr>");
			Response.Write(sql_compromiso);
			Response.Write("<hr>");
			Response.End();*/


			
				oleDbDataAdapter1.SelectCommand.CommandText = sql_documento;
				oleDbDataAdapter1.Fill(datos_comprobante1);
				
				oleDbDataAdapter2.SelectCommand.CommandText = sql_alumno;
				oleDbDataAdapter2.Fill(datos_comprobante1);

				oleDbDataAdapter3.SelectCommand.CommandText = sql_compromiso;
				oleDbDataAdapter3.Fill(datos_comprobante1);
				
			reporte.SetDataSource(datos_comprobante1);
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
			System.Configuration.AppSettingsReader configurationAppSettings = new System.Configuration.AppSettingsReader();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter2 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection2 = new System.Data.OleDb.OleDbConnection();
			this.datos_comprobante1 = new comp_cajas.datos_comprobante();
			this.oleDbDataAdapter3 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.datos_comprobante1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "t_documento", new System.Data.Common.DataColumnMapping[] {
																																																					   new System.Data.Common.DataColumnMapping("NRO_DOCUMENTO", "NRO_DOCUMENTO"),
																																																					   new System.Data.Common.DataColumnMapping("FECHA_DOCUMENTO", "FECHA_DOCUMENTO"),
																																																					   new System.Data.Common.DataColumnMapping("NOMBRE_BANCO", "NOMBRE_BANCO"),
																																																					   new System.Data.Common.DataColumnMapping("NFOLIO", "NFOLIO"),
																																																					   new System.Data.Common.DataColumnMapping("TIPO_PAGO", "TIPO_PAGO"),
																																																					   new System.Data.Common.DataColumnMapping("MONTO_DOC", "MONTO_DOC"),
																																																					   new System.Data.Common.DataColumnMapping("DETALLES_COMPROMISO", "DETALLES_COMPROMISO"),
																																																					   new System.Data.Common.DataColumnMapping("TOTAL", "TOTAL")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS NRO_DOCUMENTO, \'\' AS FECHA_DOCUMENTO, \'\' AS NOMBRE_BANCO, \'\' AS NFOL" +
				"IO, \'\' AS TIPO_PAGO, \'\' AS MONTO_DOC, \'\' AS DETALLES_COMPROMISO, \'\' AS TOTAL, \'\'" +
				" AS TDOCUMENTO, \'\' AS pers_ncorr, \'\' AS INGR_FPAGO, \'\' AS OTRO, \'\' AS ingr_ncorr" +
				"elativo_caja";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter2
			// 
			this.oleDbDataAdapter2.SelectCommand = this.oleDbSelectCommand2;
			this.oleDbDataAdapter2.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "t_alumno", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("CODIGO_ALUMNO", "CODIGO_ALUMNO"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_CARRERA", "NOMBRE_CARRERA"),
																																																					new System.Data.Common.DataColumnMapping("OFERTA", "OFERTA"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_CODEUDOR", "NOMBRE_CODEUDOR"),
																																																					new System.Data.Common.DataColumnMapping("RUT_CODEUDOR", "RUT_CODEUDOR")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS PERS_NCORR, \'\' AS CODIGO_ALUMNO, \'\' AS NOMBRE_CARRERA, \'\' AS OFERTA," +
				" \'\' AS NOMBRE_ALUMNO, \'\' AS RUT_ALUMNO, \'\' AS FECHA_DIA, \'\' AS NOMBRE_CODEUDOR, " +
				"\'\' AS RUT_CODEUDOR ";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection2;
			// 
			// oleDbConnection2
			// 
			this.oleDbConnection2.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datos_comprobante1
			// 
			this.datos_comprobante1.DataSetName = "datos_comprobante";
			this.datos_comprobante1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datos_comprobante1.Namespace = "http://www.tempuri.org/datos_comprobante.xsd";
			// 
			// oleDbDataAdapter3
			// 
			this.oleDbDataAdapter3.SelectCommand = this.oleDbSelectCommand3;
			this.oleDbDataAdapter3.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "t_compromisos", new System.Data.Common.DataColumnMapping[] {
																																																						 new System.Data.Common.DataColumnMapping("NRO_DOCUMENTO", "NRO_DOCUMENTO"),
																																																						 new System.Data.Common.DataColumnMapping("FECHA_VENCIMIENTO", "FECHA_VENCIMIENTO"),
																																																						 new System.Data.Common.DataColumnMapping("TIPO_COMPROMISO", "TIPO_COMPROMISO"),
																																																						 new System.Data.Common.DataColumnMapping("MONTO_ABONO", "MONTO_ABONO")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT \'\' AS NRO_DOCUMENTO, \'\' AS FECHA_VENCIMIENTO, \'\' AS TIPO_COMPROMISO, \'\' AS" +
				" MONTO_ABONO, \'\' AS TIPO_DETALLE ";
			this.oleDbSelectCommand3.Connection = this.oleDbConnection1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datos_comprobante1)).EndInit();

		}
		#endregion
	}
}
