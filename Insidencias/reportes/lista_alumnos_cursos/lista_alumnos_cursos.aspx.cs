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



namespace lista_alumnos_cursos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection conexion;
		protected lista_alumnos_cursos.DataSet1 ds;



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



		private void ExportarEXCEL(ReportDocument rep) 
		{
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
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());						
		}

		private string ObtenerSql(string p_anos_ccod, string p_sede_ccod, string p_tdet_ccod)
		{
			string SQL;


			SQL = " select a.tdet_ccod, a.tdet_tdesc, a.igas_tcodigo, a.ccos_tcodigo, a.pers_ncorr, obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr, 'PM,N') as nombre, \n";
			SQL = SQL +  "        nvl(b.comprometido, 0) as comprometido, nvl(c.recibido, 0) as recibido, nvl(b.comprometido, 0) - nvl(c.recibido, 0) as saldo, es_moroso(a.pers_ncorr) as moroso, d.sede_tdesc, '" + p_anos_ccod + "' as anos_ccod    \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct a.pers_ncorr, b.tdet_ccod, c.tdet_tdesc, e.igas_tcodigo, f.ccos_tcodigo \n";
			SQL = SQL +  "       from compromisos a, detalles b, tipos_detalle c, \n";
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
			SQL = SQL +  " 		and c.tdet_ccod = nvl('" + p_tdet_ccod + "', c.tdet_ccod) \n";
			SQL = SQL +  " 		and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	 select a.tdet_ccod, a.pers_ncorr, \n";
			SQL = SQL +  " 		       sum(decode(to_char(a.comp_fdocto, 'yyyy'), '" + p_anos_ccod + "', b.dcom_mcompromiso - nvl(d.abon_mabono, 0), 0)) as comprometido			    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select a.pers_ncorr, b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_fdocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 				  and a.sede_ccod = '" + p_sede_ccod + "'		     \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select b.pers_ncorr, c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, e.comp_fdocto \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d, compromisos e \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and c.tcom_ccod = e.tcom_ccod \n";
			SQL = SQL +  " 				  and c.comp_ndocto = e.comp_ndocto \n";
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
			SQL = SQL +  " 				  and d.sede_ccod = '" + p_sede_ccod + "' \n";
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
			SQL = SQL +  " 		  and a.tdet_ccod = nvl('" + p_tdet_ccod + "', a.tdet_ccod) \n";
			SQL = SQL +  " 		group by a.tdet_ccod, a.pers_ncorr		 \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	(	 \n";
			SQL = SQL +  " 	select a.tdet_ccod, a.pers_ncorr, \n";
			SQL = SQL +  " 			   sum(c.abon_mabono) as recibido			   	    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select a.pers_ncorr, b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = 7 \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1    \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select b.pers_ncorr, c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto \n";
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
			SQL = SQL +  " 		  and a.tdet_ccod = nvl('" + p_tdet_ccod + "', a.tdet_ccod) \n";
			SQL = SQL +  " 		  and f.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by a.tdet_ccod, a.pers_ncorr		 \n";
			SQL = SQL +  " 	) c, sedes d \n";
			SQL = SQL +  " where a.tdet_ccod = b.tdet_ccod (+)  \n";
			SQL = SQL +  "   and a.pers_ncorr = b.pers_ncorr (+) \n";
			SQL = SQL +  "   and a.tdet_ccod = c.tdet_ccod (+) \n";
			SQL = SQL +  "   and a.pers_ncorr = c.pers_ncorr (+)  \n";
			SQL = SQL +  "   and d.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " order by a.tdet_tdesc asc, nombre asc \n";

//----------------------------------------------------------------------------------------
SQL = " ";
//----------------------------------------------------------------------------------------

SQL =  " select a.tdet_ccod, a.tdet_tdesc, a.igas_tcodigo, a.ccos_tcodigo, a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr, 'PM,N') as nombre,  \n";
SQL = SQL +  "			        isnull(b.comprometido, 0) as comprometido, isnull(c.recibido, 0) as recibido, isnull(b.comprometido, 0) - isnull(c.recibido, 0) as saldo, protic.es_moroso(a.pers_ncorr,getdate()) as moroso, d.sede_tdesc, '" + p_anos_ccod + "' as anos_ccod  \n";
SQL = SQL +  "			 from (  \n";
SQL = SQL +  "			       select distinct a.pers_ncorr, b.tdet_ccod, c.tdet_tdesc, e.igas_tcodigo, f.ccos_tcodigo  \n";
SQL = SQL +  "			       from compromisos a, detalles b, tipos_detalle c,  \n";
SQL = SQL +  "			 	       itemes_gasto e, centros_costo f  \n";
SQL = SQL +  "			 	  where a.tcom_ccod = b.tcom_ccod  \n";
SQL = SQL +  "			 	    and a.inst_ccod = b.inst_ccod  \n";
SQL = SQL +  "			 		and a.comp_ndocto = b.comp_ndocto  \n";
SQL = SQL +  "			 		and b.tdet_ccod = c.tdet_ccod  \n";
SQL = SQL +  "			 		and c.tcom_ccod = a.tcom_ccod  \n";
SQL = SQL +  "			 		and c.igas_ccod = e.igas_ccod  \n";
SQL = SQL +  "			 		and c.ccos_ccod = f.ccos_ccod  \n";
SQL = SQL +  "			 		and a.tcom_ccod = 7  \n";
SQL = SQL +  "			 		and a.ecom_ccod = 1  \n";
SQL = SQL +  "			 		and cast(c.tdet_ccod as varchar) = isnull('" + p_tdet_ccod + "', c.tdet_ccod)  \n";
SQL = SQL +  "			 		and a.sede_ccod = '" + p_sede_ccod + "'  \n";
SQL = SQL +  "			 	 ) a,  \n";
SQL = SQL +  "			 	 (  \n";
SQL = SQL +  "			 	 select a.tdet_ccod, a.pers_ncorr,  \n";
SQL = SQL +  "			 		       sum(case cast(datepart(year,a.comp_fdocto) as varchar) when '" + p_anos_ccod + "' then b.dcom_mcompromiso - isnull(d.abon_mabono, 0) else 0 end) as comprometido \n";		    
SQL = SQL +  "			 		from (	  \n";
SQL = SQL +  "			 		        select a.pers_ncorr, b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_fdocto  \n";
SQL = SQL +  "			 				from compromisos a, detalles b, tipos_detalle c  \n";
SQL = SQL +  "			 				where a.tcom_ccod = b.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.inst_ccod = b.inst_ccod  \n";
SQL = SQL +  "			 				  and a.comp_ndocto = b.comp_ndocto  \n";
SQL = SQL +  "			 				  and b.tdet_ccod = c.tdet_ccod  \n";
SQL = SQL +  "			 				  and a.tcom_ccod = c.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.tcom_ccod = 7  \n";
SQL = SQL +  "			 				  and a.ecom_ccod = 1  \n";
SQL = SQL +  "			 				  and a.sede_ccod = '" + p_sede_ccod + "'	\n";
SQL = SQL +  "			 				union all  \n";
SQL = SQL +  "			 				select b.pers_ncorr, c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, e.comp_fdocto  \n";
SQL = SQL +  "			 				from repactaciones a, compromisos b, detalles c, tipos_detalle d, compromisos e  \n";
SQL = SQL +  "			 				where a.repa_ncorr = b.comp_ndocto  \n";
SQL = SQL +  "			 				  and a.tcom_ccod_origen = c.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.comp_ndocto_origen = c.comp_ndocto  \n";
SQL = SQL +  "			 				  and c.tdet_ccod = d.tdet_ccod  \n";
SQL = SQL +  "			 				  and d.tcom_ccod = a.tcom_ccod_origen  \n";
SQL = SQL +  "			 				  and c.tcom_ccod = e.tcom_ccod  \n";
SQL = SQL +  "			 				  and c.comp_ndocto = e.comp_ndocto  \n";
SQL = SQL +  "			 				  and b.tcom_ccod = 3  \n";
SQL = SQL +  "			 				  and a.tcom_ccod_origen = 7  \n";
SQL = SQL +  "			 				  and b.ecom_ccod = 1  \n";
SQL = SQL +  "			 				  and b.sede_ccod = '" + p_sede_ccod + "'  \n";
SQL = SQL +  "			 		     ) a, detalle_compromisos b, detalle_ingresos c,  \n";
SQL = SQL +  "			 			 (  	   \n";
SQL = SQL +  "			 			    select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.abon_mabono, a.pers_ncorr  \n";
SQL = SQL +  "			 				from ingresos a, abonos b, detalle_compromisos c, compromisos d  \n";
SQL = SQL +  "			 				where a.ingr_ncorr = b.ingr_ncorr  \n";
SQL = SQL +  "			 				  and b.tcom_ccod = c.tcom_ccod  \n";
SQL = SQL +  "			 				  and b.inst_ccod = c.inst_ccod  \n";
SQL = SQL +  "			 				  and b.comp_ndocto = c.comp_ndocto  \n";
SQL = SQL +  "			 				  and b.dcom_ncompromiso = c.dcom_ncompromiso  \n";
SQL = SQL +  "			 				  and c.tcom_ccod = d.tcom_ccod  \n";
SQL = SQL +  "			 				  and c.inst_ccod = d.inst_ccod  \n";
SQL = SQL +  "			 				  and c.comp_ndocto = d.comp_ndocto  \n";
SQL = SQL +  "			 				  and d.ecom_ccod = 1  \n";
SQL = SQL +  "			 				  and d.tcom_ccod in (3, 7) \n"; 
SQL = SQL +  "			 				  and a.ting_ccod = 9  \n";
SQL = SQL +  "			 				  and a.eing_ccod <> 3  \n";
SQL = SQL +  "			 				  and d.sede_ccod = '" + p_sede_ccod + "'  \n";
SQL = SQL +  "			 			 ) d  \n";
SQL = SQL +  "			 		where a.tcom_ccod = b.tcom_ccod  \n";
SQL = SQL +  "			 		  and a.inst_ccod = b.inst_ccod  \n";
SQL = SQL +  "			 		  and a.comp_ndocto = b.comp_ndocto  \n";
SQL = SQL +  "			 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  *= c.ingr_ncorr   \n";
SQL = SQL +  "			 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')   *= c.ting_ccod   \n";
SQL = SQL +  "			 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto  \n";
SQL = SQL +  "			 		  and b.tcom_ccod   *= d.tcom_ccod   \n";
SQL = SQL +  "			 		  and b.inst_ccod   *= d.inst_ccod   \n";
SQL = SQL +  "			 		  and b.comp_ndocto *= d.comp_ndocto  \n";
SQL = SQL +  "			 		  and b.dcom_ncompromiso *= d.dcom_ncompromiso   \n";
SQL = SQL +  "			 		  and b.pers_ncorr *= d.pers_ncorr  \n";
SQL = SQL +  "			 		  and b.dcom_mcompromiso - isnull(d.abon_mabono, 0) > 0  \n";
SQL = SQL +  "			 		  and cast(a.tdet_ccod as varchar) = isnull('" + p_tdet_ccod + "', a.tdet_ccod)  \n";
SQL = SQL +  "			 		group by a.tdet_ccod, a.pers_ncorr		  \n";
SQL = SQL +  "			 	) b,  \n";
SQL = SQL +  "			 	(	  \n";
SQL = SQL +  "			 	select a.tdet_ccod, a.pers_ncorr,  \n";
SQL = SQL +  "			 			   sum(c.abon_mabono) as recibido	 \n";		   	    
SQL = SQL +  "			 		from (	  \n";
SQL = SQL +  "			 		        select a.pers_ncorr, b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto  \n";
SQL = SQL +  "			 				from compromisos a, detalles b, tipos_detalle c  \n";
SQL = SQL +  "			 				where a.tcom_ccod = b.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.inst_ccod = b.inst_ccod  \n";
SQL = SQL +  "			 				  and a.comp_ndocto = b.comp_ndocto  \n";
SQL = SQL +  "			 				  and b.tdet_ccod = c.tdet_ccod  \n";
SQL = SQL +  "			 				  and a.tcom_ccod = c.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.tcom_ccod = 7  \n";
SQL = SQL +  "			 				  and a.ecom_ccod = 1     \n";
SQL = SQL +  "			 				union all  \n";
SQL = SQL +  "			 				select b.pers_ncorr, c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto  \n";
SQL = SQL +  "			 				from repactaciones a, compromisos b, detalles c, tipos_detalle d  \n";
SQL = SQL +  "			 				where a.repa_ncorr = b.comp_ndocto  \n";
SQL = SQL +  "			 				  and a.tcom_ccod_origen = c.tcom_ccod  \n";
SQL = SQL +  "			 				  and a.comp_ndocto_origen = c.comp_ndocto  \n";
SQL = SQL +  "			 				  and c.tdet_ccod = d.tdet_ccod  \n";
SQL = SQL +  "			 				  and d.tcom_ccod = a.tcom_ccod_origen  \n";
SQL = SQL +  "			 				  and b.tcom_ccod = 3  \n";
SQL = SQL +  "			 				  and a.tcom_ccod_origen = 7  \n";
SQL = SQL +  "			 				  and b.ecom_ccod = 1  \n";
SQL = SQL +  "			 		     ) a, detalle_compromisos b, abonos c, ingresos d, tipos_ingresos e, movimientos_cajas f  \n";
SQL = SQL +  "			 		where a.tcom_ccod = b.tcom_ccod  \n";
SQL = SQL +  "			 		  and a.inst_ccod = b.inst_ccod  \n";
SQL = SQL +  "			 		  and a.comp_ndocto = b.comp_ndocto  \n";
SQL = SQL +  "			 		  and b.tcom_ccod = c.tcom_ccod  \n";
SQL = SQL +  "			 		  and b.inst_ccod = c.inst_ccod  \n";
SQL = SQL +  "			 		  and b.comp_ndocto = c.comp_ndocto  \n";
SQL = SQL +  "			 		  and b.dcom_ncompromiso = c.dcom_ncompromiso  \n";
SQL = SQL +  "			 		  and c.ingr_ncorr = d.ingr_ncorr  \n";
SQL = SQL +  "			 		  and d.ting_ccod = e.ting_ccod  \n";
SQL = SQL +  "			 		  and d.mcaj_ncorr = f.mcaj_ncorr  \n";
SQL = SQL +  "			 		  and d.eing_ccod = 1  \n";
SQL = SQL +  "			 		  and e.ting_bingreso_real = 'S'  \n";
SQL = SQL +  "			 		  and isnull(e.ting_brebaje, 'N') = 'N'  \n";
SQL = SQL +  "			 		  and cast(a.tdet_ccod as varchar) = isnull('" + p_tdet_ccod + "', a.tdet_ccod)  \n";
SQL = SQL +  "			 		  and f.sede_ccod = '" + p_sede_ccod + "'  \n";
SQL = SQL +  "			 		group by a.tdet_ccod, a.pers_ncorr	\n";
SQL = SQL +  "			 	) c, sedes d 	  \n";
SQL = SQL +  "			 where a.tdet_ccod  *= b.tdet_ccod  \n";
SQL = SQL +  "			   and a.pers_ncorr *= b.pers_ncorr  \n";
SQL = SQL +  "			   and a.tdet_ccod  *= c.tdet_ccod  \n";
SQL = SQL +  "			   and a.pers_ncorr *= c.pers_ncorr  \n";
SQL = SQL +  "			   and d.sede_ccod = '" + p_sede_ccod + "' \n";
SQL = SQL +  "			 order by a.tdet_tdesc asc, nombre asc \n";


			return SQL;
		}
	


		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			crListaAlumnos rep = new crListaAlumnos();		

			string q_anos_ccod = Request["filtros[0][anos_ccod]"];
			string q_sede_ccod = Request["filtros[0][sede_ccod]"];
			string q_tdet_ccod = Request["filtros[0][tdet_ccod]"];
			string q_formato = Request["filtros[0][formato]"];


			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_anos_ccod, q_sede_ccod, q_tdet_ccod);
			adpDetalles.Fill(ds);

			rep.SetDataSource(ds);


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
			this.adpDetalles = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.ds = new lista_alumnos_cursos.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "ALUMNOS", new System.Data.Common.DataColumnMapping[] {
																																																			 new System.Data.Common.DataColumnMapping("TDET_TDESC", "TDET_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("IGAS_TCODIGO", "IGAS_TCODIGO"),
																																																			 new System.Data.Common.DataColumnMapping("CCOS_TCODIGO", "CCOS_TCODIGO"),
																																																			 new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																			 new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																			 new System.Data.Common.DataColumnMapping("COMPROMETIDO", "COMPROMETIDO"),
																																																			 new System.Data.Common.DataColumnMapping("RECIBIDO", "RECIBIDO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS TDET_TDESC, \'\' AS IGAS_TCODIGO, \'\' AS CCOS_TCODIGO, \'\' AS RUT, \'\' AS" +
				" NOMBRE, 0 AS COMPROMETIDO, 0 AS RECIBIDO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.conexion;
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
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
