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

namespace flujo_venc_cursos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDatos;
		protected flujo_venc_cursos.DataSet1 ds;
		protected CrystalDecisions.Web.CrystalReportViewer visor;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection conexion;


		private void ExportarPDF(ReportDocument rep) {
			String ruta_exportacion;
			
			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);

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

		private void ExportarEXCEL(ReportDocument rep) {
			String ruta_exportacion;
			
			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);

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
			//Response.AddHeader ("Content-Disposition", diskOpts.DiskFileName.ToString());
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());						
		}

				
		private string ObtenerSql(string p_anos_ccod, string p_sede_ccod) {
			string SQL;

			SQL = "";

			SQL = " select a.tdet_ccod, a.tdet_tdesc, a.igas_tcodigo, a.ccos_tcodigo, a.semestre, \n";
			SQL = SQL +  "        nvl(b.comp_01, 0) as comp_01, \n";
			SQL = SQL +  " 	   nvl(b.comp_02, 0) as comp_02, \n";
			SQL = SQL +  " 	   nvl(b.comp_03, 0) as comp_03, \n";
			SQL = SQL +  " 	   nvl(b.comp_04, 0) as comp_04, \n";
			SQL = SQL +  " 	   nvl(b.comp_05, 0) as comp_05, \n";
			SQL = SQL +  " 	   nvl(b.comp_06, 0) as comp_06, \n";
			SQL = SQL +  " 	   nvl(b.comp_semestre, 0) as comp_semestre, \n";
			SQL = SQL +  " 	   nvl(c.real_01, 0) as real_01, \n";
			SQL = SQL +  " 	   nvl(c.real_02, 0) as real_02, \n";
			SQL = SQL +  " 	   nvl(c.real_03, 0) as real_03, \n";
			SQL = SQL +  " 	   nvl(c.real_04, 0) as real_04, \n";
			SQL = SQL +  " 	   nvl(c.real_05, 0) as real_05, \n";
			SQL = SQL +  " 	   nvl(c.real_06, 0) as real_06, \n";
			SQL = SQL +  " 	   nvl(c.real_semestre, 0) as real_semestre, \n";
			SQL = SQL +  " 	   nvl(b.comp_01, 0) - nvl(c.real_01, 0) as variacion_01, \n";
			SQL = SQL +  " 	   nvl(b.comp_02, 0) - nvl(c.real_02, 0) as variacion_02, \n";
			SQL = SQL +  " 	   nvl(b.comp_03, 0) - nvl(c.real_03, 0) as variacion_03, \n";
			SQL = SQL +  " 	   nvl(b.comp_04, 0) - nvl(c.real_04, 0) as variacion_04, \n";
			SQL = SQL +  " 	   nvl(b.comp_05, 0) - nvl(c.real_05, 0) as variacion_05, \n";
			SQL = SQL +  " 	   nvl(b.comp_06, 0) - nvl(c.real_06, 0) as variacion_06, \n";
			SQL = SQL +  " 	   nvl(b.comp_semestre, 0) - nvl(c.real_semestre, 0) as variacion_semestre \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct b.tdet_ccod, d.semestre, initcap(c.tdet_tdesc) as tdet_tdesc, e.igas_tcodigo, f.ccos_tcodigo \n";
			SQL = SQL +  "       from compromisos a, detalles b, tipos_detalle c, (select 1 as semestre from dual union select 2 as semestre from dual) d, \n";
			SQL = SQL +  " 	       itemes_gasto e, centros_costo f \n";
			SQL = SQL +  " 	  where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 	    and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 		and c.tcom_ccod = a.tcom_ccod \n";
			SQL = SQL +  " 		and c.igas_ccod = e.igas_ccod \n";
			SQL = SQL +  " 		and c.ccos_ccod = f.ccos_ccod \n";
			SQL = SQL +  " 		and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 		and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	 select a.tdet_ccod, \n";
			SQL = SQL +  " 		       round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 1, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_01, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 2, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_02, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 3, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_03, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 4, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_04, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 5, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_05, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6), 6, b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0), 0)) as comp_06, \n";
			SQL = SQL +  " 			   sum(decode(to_char(b.dcom_fcompromiso, 'yyyy'), '" + p_anos_ccod + "', b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0)) as comp_semestre    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = 7 \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and b.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, detalle_ingresos c, \n";
			SQL = SQL +  " 			 (  	  \n";
			SQL = SQL +  " 			    select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.abon_mabono, a.pers_ncorr \n";
			SQL = SQL +  " 				from ingresos a, abonos b, detalle_compromisos c, compromisos d \n";
			SQL = SQL +  " 				where a.ingr_ncorr = b.ingr_ncorr \n";
			SQL = SQL +  " 				  and b.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and b.inst_ccod = c.inst_ccod \n";
			SQL = SQL +  " 				  and b.comp_ndocto = c.comp_ndocto \n";
			SQL = SQL +  " 				  and b.dcom_ncompromiso = c.dcom_ncompromiso \n";
			SQL = SQL +  " 				  and c.tcom_ccod = d.tcom_ccod \n";
			SQL = SQL +  " 				  and c.inst_ccod = d.inst_ccod \n";
			SQL = SQL +  " 				  and c.comp_ndocto = d.comp_ndocto \n";
			SQL = SQL +  " 				  and d.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and d.tcom_ccod in (3, 7) \n";
			SQL = SQL +  " 				  and a.ting_ccod = 9 \n";
			SQL = SQL +  " 				  and a.eing_ccod <> 3 \n";
			SQL = SQL +  " 				  and d.sede_ccod = '" + p_sede_ccod + "'		   \n";
			SQL = SQL +  " 			 ) d \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) \n";
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) \n";
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) \n";
			SQL = SQL +  " 		  and b.tcom_ccod = d.tcom_ccod (+) \n";
			SQL = SQL +  " 		  and b.inst_ccod = d.inst_ccod (+) \n";
			SQL = SQL +  " 		  and b.comp_ndocto = d.comp_ndocto (+) \n";
			SQL = SQL +  " 		  and b.dcom_ncompromiso = d.dcom_ncompromiso (+) \n";
			SQL = SQL +  " 		  and b.pers_ncorr = d.pers_ncorr (+) \n";
			SQL = SQL +  " 		  and b.dcom_mcompromiso - nvl(d.abon_mabono, 0) > 0 \n";
			SQL = SQL +  " 		group by a.tdet_ccod, round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1 \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	( \n";
			SQL = SQL +  " 	select a.tdet_ccod, \n";
			SQL = SQL +  " 		       round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1 as semestre, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 1, c.abon_mabono, 0), 0)) as real_01, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 2, c.abon_mabono, 0), 0)) as real_02, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 3, c.abon_mabono, 0), 0)) as real_03, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 4, c.abon_mabono, 0), 0)) as real_04, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 5, c.abon_mabono, 0), 0)) as real_05, \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', decode(decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6), 6, c.abon_mabono, 0), 0)) as real_06,	    \n";
			SQL = SQL +  " 			   sum(decode(to_char(d.ingr_fpago, 'yyyy'), '" + p_anos_ccod + "', c.abon_mabono, 0)) as real_semestre	    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1    \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = 7 \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, abonos c, ingresos d, tipos_ingresos e, movimientos_cajas f \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and b.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 		  and b.inst_ccod = c.inst_ccod \n";
			SQL = SQL +  " 		  and b.comp_ndocto = c.comp_ndocto \n";
			SQL = SQL +  " 		  and b.dcom_ncompromiso = c.dcom_ncompromiso \n";
			SQL = SQL +  " 		  and c.ingr_ncorr = d.ingr_ncorr \n";
			SQL = SQL +  " 		  and d.ting_ccod = e.ting_ccod \n";
			SQL = SQL +  " 		  and d.mcaj_ncorr = f.mcaj_ncorr \n";
			SQL = SQL +  " 		  and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and e.ting_bingreso_real = 'S' \n";
			SQL = SQL +  " 		  and nvl(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		  and f.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by a.tdet_ccod, round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1 \n";
			SQL = SQL +  " 	) c \n";
			SQL = SQL +  " where a.tdet_ccod = b.tdet_ccod (+) \n";
			SQL = SQL +  "   and a.semestre = b.semestre (+)  \n";
			SQL = SQL +  "   and a.tdet_ccod = c.tdet_ccod (+) \n";
			SQL = SQL +  "   and a.semestre = c.semestre (+) \n";
			SQL = SQL +  " order by a.semestre asc, a.tdet_tdesc asc \n";

//------------------------------------------------------------------------------------------
			SQL="";
//------------------------------------------------------------------------------------------

			SQL = " select a.tdet_ccod, a.tdet_tdesc, a.igas_tcodigo, a.ccos_tcodigo, a.semestre, \n";
			SQL = SQL +  "       isnull(b.comp_01, 0) as comp_01, \n";
			SQL = SQL +  " 	   isnull(b.comp_02, 0) as comp_02, \n";
			SQL = SQL +  " 	   isnull(b.comp_03, 0) as comp_03, \n";
			SQL = SQL +  " 	   isnull(b.comp_04, 0) as comp_04, \n";
			SQL = SQL +  " 	   isnull(b.comp_05, 0) as comp_05, \n";
			SQL = SQL +  " 	   isnull(b.comp_06, 0) as comp_06, \n";
			SQL = SQL +  " 	   isnull(b.comp_semestre, 0) as comp_semestre, \n";
			SQL = SQL +  " 	   isnull(c.real_01, 0) as real_01, \n";
			SQL = SQL +  " 	   isnull(c.real_02, 0) as real_02, \n";
			SQL = SQL +  " 	   isnull(c.real_03, 0) as real_03, \n";
			SQL = SQL +  " 	   isnull(c.real_04, 0) as real_04, \n";
			SQL = SQL +  " 	   isnull(c.real_05, 0) as real_05, \n";
			SQL = SQL +  " 	   isnull(c.real_06, 0) as real_06, \n";
			SQL = SQL +  " 	   isnull(c.real_semestre, 0) as real_semestre, \n";
			SQL = SQL +  " 	   isnull(b.comp_01, 0) - isnull(c.real_01, 0) as variacion_01, \n";
			SQL = SQL +  " 	   isnull(b.comp_02, 0) - isnull(c.real_02, 0) as variacion_02, \n";
			SQL = SQL +  " 	   isnull(b.comp_03, 0) - isnull(c.real_03, 0) as variacion_03, \n";
			SQL = SQL +  " 	   isnull(b.comp_04, 0) - isnull(c.real_04, 0) as variacion_04, \n";
			SQL = SQL +  " 	   isnull(b.comp_05, 0) - isnull(c.real_05, 0) as variacion_05, \n";
			SQL = SQL +  " 	   isnull(b.comp_06, 0) - isnull(c.real_06, 0) as variacion_06, \n";
			SQL = SQL +  " 	   isnull(b.comp_semestre, 0) - isnull(c.real_semestre, 0) as variacion_semestre \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct b.tdet_ccod, d.semestre, protic.initcap(c.tdet_tdesc) as tdet_tdesc, e.igas_tcodigo, f.ccos_tcodigo \n";
			SQL = SQL +  "       from compromisos a, detalles b, tipos_detalle c, (select 1 as semestre  union select 2 as semestre ) d, \n";
			SQL = SQL +  " 	       itemes_gasto e, centros_costo f \n";
			SQL = SQL +  " 	  where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 	    and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 		and c.tcom_ccod = a.tcom_ccod \n";
			SQL = SQL +  " 		and c.igas_ccod *= e.igas_ccod \n";
			SQL = SQL +  " 		and c.ccos_ccod *= f.ccos_ccod \n";
			SQL = SQL +  " 		and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 		and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	 select a.tdet_ccod, \n";
			SQL = SQL +  " 		       round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12 ,2) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 1 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_01, \n";
			SQL = SQL +  " 			   sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 2 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_02, \n";
            SQL = SQL +  "               sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 3 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_03,\n";
            SQL = SQL +  "               sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 4 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_04,\n";
            SQL = SQL +  "               sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 5 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_05,\n";
            SQL = SQL +  "               sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,b.dcom_fcompromiso) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,b.dcom_fcompromiso) as int) else cast(datepart(month,b.dcom_fcompromiso) as int)-6 end when 6 then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end else 0 end ) as comp_06,\n";
			SQL = SQL +  " 			   sum( case  cast(datepart(year,b.dcom_fcompromiso) as varchar)  when '" + p_anos_ccod + "' then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end) as comp_semestre  \n";  
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = 7 \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and b.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, detalle_ingresos c, \n";
			SQL = SQL +  " 			 ( \n"; 	  
			SQL = SQL +  " 			    select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.abon_mabono, a.pers_ncorr \n";
			SQL = SQL +  " 				from ingresos a, abonos b, detalle_compromisos c, compromisos d \n";
			SQL = SQL +  " 				where a.ingr_ncorr = b.ingr_ncorr \n";
			SQL = SQL +  " 				  and b.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and b.inst_ccod = c.inst_ccod \n";
			SQL = SQL +  " 				  and b.comp_ndocto = c.comp_ndocto \n";
			SQL = SQL +  " 				  and b.dcom_ncompromiso = c.dcom_ncompromiso \n";
			SQL = SQL +  " 				  and c.tcom_ccod = d.tcom_ccod \n";
			SQL = SQL +  " 				  and c.inst_ccod = d.inst_ccod \n";
			SQL = SQL +  " 				  and c.comp_ndocto = d.comp_ndocto \n";
			SQL = SQL +  " 				  and d.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and d.tcom_ccod in (3, 7) \n";
			SQL = SQL +  " 				  and a.ting_ccod = 9 \n";
			SQL = SQL +  " 				  and a.eing_ccod <> 3 \n";
			SQL = SQL +  " 				  and d.sede_ccod = '" + p_sede_ccod + "'	\n";
			SQL = SQL +  " 			 ) d \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto \n";
			SQL = SQL +  " 		  and b.tcom_ccod *= d.tcom_ccod \n";
			SQL = SQL +  " 		  and b.inst_ccod *= d.inst_ccod \n";
			SQL = SQL +  " 		  and b.comp_ndocto *= d.comp_ndocto \n";
			SQL = SQL +  " 		  and b.dcom_ncompromiso *= d.dcom_ncompromiso  \n";
			SQL = SQL +  " 		  and b.pers_ncorr *= d.pers_ncorr  \n";
			SQL = SQL +  " 		  and b.dcom_mcompromiso - isnull(d.abon_mabono, 0) > 0 \n";
			SQL = SQL +  " 		group by a.tdet_ccod, round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12 ,2) + 1 \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	( \n";
			SQL = SQL +  " 	select a.tdet_ccod, \n";
			SQL = SQL +  " 		       round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12 ,2) + 1 as semestre, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 1 then c.abon_mabono else 0 end else 0 end) as real_01, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 2 then c.abon_mabono else 0 end else 0 end) as real_02, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 3 then c.abon_mabono else 0 end else 0 end) as real_03, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 4 then c.abon_mabono else 0 end else 0 end) as real_04, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 5 then c.abon_mabono else 0 end else 0 end) as real_05, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar)  when '" + p_anos_ccod + "' then case case round((cast(datepart(month,d.ingr_fpago) as int) - 1) / 12 ,2) + 1 when 1 then cast(datepart(month,d.ingr_fpago) as int) else cast(datepart(month,d.ingr_fpago) as int)-6 end when 6 then c.abon_mabono else 0 end else 0 end) as real_06, \n";
            SQL = SQL +  "               sum(case  cast(datepart(year,d.ingr_fpago) as varchar) when '" + p_anos_ccod + "' then c.abon_mabono else 0 end ) as real_semestre \n";	    
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = 7 \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, abonos c, ingresos d, tipos_ingresos e, movimientos_cajas f \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and b.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 		  and b.inst_ccod = c.inst_ccod \n";
			SQL = SQL +  " 		  and b.comp_ndocto = c.comp_ndocto \n";
			SQL = SQL +  " 		  and b.dcom_ncompromiso = c.dcom_ncompromiso \n";
			SQL = SQL +  " 		  and c.ingr_ncorr = d.ingr_ncorr \n";
			SQL = SQL +  " 		  and d.ting_ccod = e.ting_ccod \n";
			SQL = SQL +  " 		  and d.mcaj_ncorr = f.mcaj_ncorr \n";
			SQL = SQL +  " 		  and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and e.ting_bingreso_real = 'S' \n";
			SQL = SQL +  " 		  and isnull(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		  and f.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by a.tdet_ccod, round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12 ,2) + 1 \n";
			SQL = SQL +  " 	) c \n";
			SQL = SQL +  " where a.tdet_ccod *= b.tdet_ccod \n";
			SQL = SQL +  "   and a.semestre  *= b.semestre \n";
			SQL = SQL +  "   and a.tdet_ccod *= c.tdet_ccod \n";
			SQL = SQL +  "   and a.semestre  *= c.semestre  \n";
			SQL = SQL +  " order by a.semestre asc, a.tdet_tdesc asc \n";



			return SQL;
		}
	


		private void Page_Load(object sender, System.EventArgs e)
		{						
			string q_anos_ccod = Request["filtros[0][anos_ccod]"].ToString();
			string q_sede_ccod = Request["filtros[0][sede_ccod]"].ToString();
			string q_formato = Request["filtros[0][formato]"].ToString();


			crFlujoCursos rep = new crFlujoCursos(); 

			adpDatos.SelectCommand.CommandText = ObtenerSql(q_anos_ccod, q_sede_ccod);
			adpDatos.Fill(ds);

			adpEncabezado.SelectCommand.Parameters["sede_ccod"].Value = q_sede_ccod;
			adpEncabezado.SelectCommand.Parameters["anos_ccod"].Value = q_anos_ccod;
			adpEncabezado.Fill(ds);
			

			//Response.Write("<pre>" + adpDatos.SelectCommand.CommandText + "</pre>");
			//Response.End();

			rep.SetDataSource(ds);

			visor.ReportSource = rep;

            if (q_formato == "1")
                ExportarPDF(rep);
			else
				ExportarEXCEL(rep);
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
			this.adpDatos = new System.Data.OleDb.OleDbDataAdapter();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.ds = new flujo_venc_cursos.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDatos
			// 
			this.adpDatos.SelectCommand = this.oleDbSelectCommand1;
			this.adpDatos.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																							   new System.Data.Common.DataTableMapping("Table", "CURSOS", new System.Data.Common.DataColumnMapping[] {
																																																		 new System.Data.Common.DataColumnMapping("TDET_TDESC", "TDET_TDESC"),
																																																		 new System.Data.Common.DataColumnMapping("IGAS_TCODIGO", "IGAS_TCODIGO"),
																																																		 new System.Data.Common.DataColumnMapping("CCOS_TCODIGO", "CCOS_TCODIGO"),
																																																		 new System.Data.Common.DataColumnMapping("SEMESTRE", "SEMESTRE"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_01", "COMP_01"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_02", "COMP_02"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_03", "COMP_03"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_04", "COMP_04"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_05", "COMP_05"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_06", "COMP_06"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_01", "REAL_01"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_02", "REAL_02"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_03", "REAL_03"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_04", "REAL_04"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_05", "REAL_05"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_06", "REAL_06"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_01", "VARIACION_01"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_02", "VARIACION_02"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_03", "VARIACION_03"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_04", "VARIACION_04"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_05", "VARIACION_05"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_06", "VARIACION_06"),
																																																		 new System.Data.Common.DataColumnMapping("COMP_SEMESTRE", "COMP_SEMESTRE"),
																																																		 new System.Data.Common.DataColumnMapping("REAL_SEMESTRE", "REAL_SEMESTRE"),
																																																		 new System.Data.Common.DataColumnMapping("VARIACION_SEMESTRE", "VARIACION_SEMESTRE")})});
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// ds
			// 
			this.ds.DataSetName = "DataSet1";
			this.ds.Locale = new System.Globalization.CultureInfo("es-CL");
			this.ds.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// adpEncabezado
			// 
			this.adpEncabezado.SelectCommand = this.oleDbSelectCommand2;
			this.adpEncabezado.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "ENCABEZADO", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("ANOS_CCOD", "ANOS_CCOD")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT A.SEDE_TDESC, B.ANOS_CCOD, A.SEDE_CCOD FROM SEDES A, ANOS B WHERE (A.SEDE_" +
				"CCOD = ?) AND (B.ANOS_CCOD = ?)";
			this.oleDbSelectCommand2.Connection = this.conexion;
			this.oleDbSelectCommand2.Parameters.Add(new System.Data.OleDb.OleDbParameter("SEDE_CCOD", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(3)), ((System.Byte)(0)), "SEDE_CCOD", System.Data.DataRowVersion.Current, null));
			this.oleDbSelectCommand2.Parameters.Add(new System.Data.OleDb.OleDbParameter("ANOS_CCOD", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(4)), ((System.Byte)(0)), "ANOS_CCOD", System.Data.DataRowVersion.Current, null));
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS TDET_TDESC, '' AS IGAS_TCODIGO, '' AS CCOS_TCODIGO, 0 AS SEMESTRE, 0 AS COMP_01, 0 AS COMP_02, 0 AS COMP_03, 0 AS COMP_04, 0 AS COMP_05, 0 AS COMP_06, 0 AS REAL_01, 0 AS REAL_02, 0 AS REAL_03, 0 AS REAL_04, 0 AS REAL_05, 0 AS REAL_06, 0 AS VARIACION_01, 0 AS VARIACION_02, 0 AS VARIACION_03, 0 AS VARIACION_04, 0 AS VARIACION_05, 0 AS VARIACION_06, 0 AS COMP_SEMESTRE, 0 AS REAL_SEMESTRE, 0 AS VARIACION_SEMESTRE FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.conexion;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
