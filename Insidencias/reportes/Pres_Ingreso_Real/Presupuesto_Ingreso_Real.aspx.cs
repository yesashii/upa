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

namespace Pres_Ingreso_Real
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected Pres_Ingreso_Real.Datos datos1;
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
			
            //exportOpts.ExportFormatType = ExportFormatType.Excel;
			exportOpts.ExportDestinationType = ExportDestinationType.DiskFile;
			diskOpts.DiskFileName = ruta_exportacion + Session.SessionID.ToString() + ".pdf";
	        
			//diskOpts.DiskFileName = ruta_exportacion + Session.SessionID.ToString() + ".xls";	
			exportOpts.DestinationOptions = diskOpts;

			rep.Export();
						
			Response.ClearContent();
			Response.ClearHeaders();
			
			Response.ContentType = "application/pdf";
			//Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}


		private void ExportarEXCEL(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			//ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=presupuesto_ingreso_real.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

	/*
		private string EscribirCodigo(string periodo, string sede, string fecha_inicio, string fecha_termino) {
			string SQL;

			SQL = " select a.peri_tdesc as periodo, '" + fecha_inicio + "' as fecha_inicio, '" + fecha_termino + "' as fecha_termino, \n";
			SQL = SQL +  "        a.carr_tdesc, a.carr_ccod, a.sede_tdesc, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) as total_matr_comprometida, \n";
			SQL = SQL +  " 	   isnull(b.total_colegiatura, 0) as total_col_comprometida, \n";
			SQL = SQL +  " 	   isnull(c.real_matricula, 0) as total_matr_real, \n";
			SQL = SQL +  " 	   isnull(c.real_colegiatura, 0) as total_col_real, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0) - isnull(c.real_matricula, 0) - isnull(c.real_colegiatura, 0) as saldo \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct b.peri_tdesc, d.carr_tdesc, d.carr_ccod, e.sede_tdesc  \n";
			SQL = SQL +  " 		from ofertas_academicas a, periodos_academicos b, especialidades c, carreras d, sedes e \n";
			SQL = SQL +  " 		where a.peri_ccod = b.peri_ccod \n";
			SQL = SQL +  " 		  and a.espe_ccod = c.espe_ccod \n";
			SQL = SQL +  " 		  and c.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  " 		  and a.sede_ccod = e.sede_ccod \n";
			SQL = SQL +  " 		  and a.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		  and a.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select i.carr_ccod,         	    \n";
			SQL = SQL +  " 		 	   sum(case when a.tcom_ccod_origen = 1 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_matricula, \n";
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_colegiatura	    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod in (1, 2) \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1 \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen in (1, 2) \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, detalle_ingresos c, \n";
			SQL = SQL +  " 			 contratos e, alumnos f, ofertas_academicas g, especialidades h, carreras i \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')	*= c.ingr_ncorr		\n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')	*= c.ting_ccod		\n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')	*= c.ding_ndocto	\n";
			SQL = SQL +  " 		  and a.comp_ndocto_origen = e.cont_ncorr \n";
			SQL = SQL +  " 		  and e.matr_ncorr = f.matr_ncorr \n";
			SQL = SQL +  " 		  and f.ofer_ncorr = g.ofer_ncorr \n";
			SQL = SQL +  " 		  and g.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 		  and h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  " 		  and b.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.econ_ccod = 1 \n";
			SQL = SQL +  " 		  and f.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and b.dcom_fcompromiso between '" + fecha_inicio + "' and '" + fecha_termino + "' \n";
			SQL = SQL +  " 		  and g.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and g.sede_ccod = '" + sede + "'   \n";
			SQL = SQL +  " 		group by i.carr_ccod \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	(	 \n";
			SQL = SQL +  " 	 select k.carr_ccod, \n";
			SQL = SQL +  " 		       sum(case when a.tcom_ccod_origen = 1 and cast(datepart(year,d.ingr_fpago) as varchar) = '2004' then c.abon_mabono else 0 end) as real_matricula, \n";
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 and cast(datepart(year,d.ingr_fpago) as varchar) = '2004' then c.abon_mabono else 0 end) as real_colegiatura			    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a, detalles b, tipos_detalle c \n";
			SQL = SQL +  " 				where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 				  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 				  and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.tcom_ccod in (1, 2) \n";
			SQL = SQL +  " 				  and a.ecom_ccod = 1    \n";
			SQL = SQL +  " 				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  " 				from repactaciones a, compromisos b, detalles c, tipos_detalle d \n";
			SQL = SQL +  " 				where a.repa_ncorr = b.comp_ndocto \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  " 				  and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				  and c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				  and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 				  and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 				  and a.tcom_ccod_origen in (1, 2) \n";
			SQL = SQL +  " 				  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		     ) a, detalle_compromisos b, abonos c, ingresos d, tipos_ingresos e, movimientos_cajas f, \n";
			SQL = SQL +  " 			 contratos g, alumnos h, ofertas_academicas i, especialidades j, carreras k \n";
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
			SQL = SQL +  " 		  and a.comp_ndocto_origen = g.cont_ncorr \n";
			SQL = SQL +  " 		  and g.matr_ncorr = h.matr_ncorr \n";
			SQL = SQL +  " 		  and h.ofer_ncorr = i.ofer_ncorr \n";
			SQL = SQL +  " 		  and i.espe_ccod = j.espe_ccod \n";
			SQL = SQL +  " 		  and j.carr_ccod = k.carr_ccod \n";
			SQL = SQL +  " 		  and h.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and g.econ_ccod = 1 \n";
			SQL = SQL +  " 		  and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and c.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.ting_bingreso_real = 'S' \n";
			SQL = SQL +  " 		  and isnull(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		  and i.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and i.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		group by k.carr_ccod 		 \n";
			SQL = SQL +  " 	) c	 \n";
			SQL = SQL +  " where a.carr_ccod *= b.carr_ccod  \n";
			SQL = SQL +  "   and a.carr_ccod *= c.carr_ccod \n";
			SQL = SQL +  " order by a.carr_tdesc asc \n";
//Response.Write(SQL);
//Response.Flush();
			return SQL;
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
		LINEA			: 39 - 66,67,68 - 82
		********************************************************************/

		private string EscribirCodigo(string periodo, string sede, string fecha_inicio, string fecha_termino) 
		{
			string SQL;

			SQL = " select a.peri_tdesc as periodo, '" + fecha_inicio + "' as fecha_inicio, '" + fecha_termino + "' as fecha_termino, \n";
			SQL = SQL +  "        a.carr_tdesc, a.carr_ccod, a.sede_tdesc, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) as total_matr_comprometida, \n";
			SQL = SQL +  " 	   isnull(b.total_colegiatura, 0) as total_col_comprometida, \n";
			SQL = SQL +  " 	   isnull(c.real_matricula, 0) as total_matr_real, \n";
			SQL = SQL +  " 	   isnull(c.real_colegiatura, 0) as total_col_real, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0) - isnull(c.real_matricula, 0) - isnull(c.real_colegiatura, 0) as saldo \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct b.peri_tdesc, d.carr_tdesc, d.carr_ccod, e.sede_tdesc  \n";
			SQL = SQL +  " 		from ofertas_academicas a \n";
			SQL = SQL +  " 		INNER JOIN periodos_academicos b \n";
			SQL = SQL +  " 		ON a.peri_ccod = b.peri_ccod and a.sede_ccod = '" + sede + "' and a.peri_ccod = '" + periodo + "'  \n";
			SQL = SQL +  "  		INNER JOIN especialidades c \n";
			SQL = SQL +  "  		ON a.espe_ccod = c.espe_ccod \n";
			SQL = SQL +  "  		INNER JOIN carreras d \n";
			SQL = SQL +  " 		ON c.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  "  		INNER JOIN sedes e \n";
			SQL = SQL +  "  		ON a.sede_ccod = e.sede_ccod  ";
			SQL = SQL +  " 	 ) a ";
			SQL = SQL +  " 	LEFT OUTER JOIN ";
			SQL = SQL +  " 	(  \n";
			SQL = SQL +  " 	  select i.carr_ccod,         	    \n";
			SQL = SQL +  " 		 	   sum(case when a.tcom_ccod_origen = 1 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_matricula, \n";
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_colegiatura	    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  "		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  "				from compromisos a \n";
			SQL = SQL +  "				INNER JOIN detalles b \n";
			SQL = SQL +  "				ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "				and a.tcom_ccod in (1, 2) and a.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle c \n";
			SQL = SQL +  " 				ON b.tdet_ccod = c.tdet_ccod and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  "				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  "				from repactaciones a \n";
			SQL = SQL +  "				INNER JOIN compromisos b \n";
			SQL = SQL +  " 				ON a.repa_ncorr = b.comp_ndocto and a.tcom_ccod_origen in (1, 2) and b.tcom_ccod = 3 and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 				INNER JOIN detalles c \n";
			SQL = SQL +  " 				ON a.tcom_ccod_origen = c.tcom_ccod and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle d \n";
			SQL = SQL +  " 				ON c.tdet_ccod = d.tdet_ccod and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 		     ) a \n";
			SQL = SQL +  "		     INNER JOIN detalle_compromisos b \n";
			SQL = SQL +  "		     ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		     and b.tcom_ccod in (1, 2, 3) and b.dcom_fcompromiso between '" + fecha_inicio + "' and '" + fecha_termino + "' \n";
			SQL = SQL +  " 		     LEFT OUTER JOIN detalle_ingresos c \n";
			SQL = SQL +  "		     ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr		\n";
			SQL = SQL +  " 		     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')	= c.ting_ccod		\n";
			SQL = SQL +  "		     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto	\n";
			SQL = SQL +  " 		     INNER JOIN contratos e \n";
			SQL = SQL +  " 		     ON a.comp_ndocto_origen = e.cont_ncorr and e.econ_ccod = 1 \n";
			SQL = SQL +  " 		     INNER JOIN alumnos f \n";
			SQL = SQL +  " 		     ON e.matr_ncorr = f.matr_ncorr and f.emat_ccod <> 9 \n";
			SQL = SQL +  " 		     INNER JOIN ofertas_academicas g \n";
			SQL = SQL +  " 		     ON f.ofer_ncorr = g.ofer_ncorr and g.peri_ccod ='" + periodo + "'  and g.sede_ccod =  '" + sede + "'  \n";
			SQL = SQL +  "		     INNER JOIN especialidades h \n";
			SQL = SQL +  "		     ON g.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 		     INNER JOIN carreras i \n";
			SQL = SQL +  " 		     ON h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  " 		group by i.carr_ccod \n";
			SQL = SQL +  "	) b \n";
			SQL = SQL +  "ON a.carr_ccod = b.carr_ccod  \n";
			SQL = SQL +  "LEFT OUTER JOIN \n";
			SQL = SQL +  "	(	 \n";
			SQL = SQL +  " 	 select k.carr_ccod, \n";
			SQL = SQL +  " 		       sum(case when a.tcom_ccod_origen = 1 and cast(datepart(year,d.ingr_fpago) as varchar) = '2004' then c.abon_mabono else 0 end) as real_matricula, \n";
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 and cast(datepart(year,d.ingr_fpago) as varchar) = '2004' then c.abon_mabono else 0 end) as real_colegiatura			    \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a \n";
			SQL = SQL +  "				INNER JOIN detalles b \n";
			SQL = SQL +  "				ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "				and a.tcom_ccod in (1, 2) and a.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle c \n";
			SQL = SQL +  " 				ON b.tdet_ccod = c.tdet_ccod and a.tcom_ccod = c.tcom_ccod    \n";
			SQL = SQL +  "				union all \n";
			SQL = SQL +  "				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  "				from repactaciones a \n";
			SQL = SQL +  "				INNER JOIN compromisos b \n";
			SQL = SQL +  "				ON a.repa_ncorr = b.comp_ndocto and a.tcom_ccod_origen in (1, 2) and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 				INNER JOIN detalles c \n";
			SQL = SQL +  " 				ON a.tcom_ccod_origen = c.tcom_ccod and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  " 				INNER JOIN tipos_detalle d \n";
			SQL = SQL +  " 				ON c.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 				and d.tcom_ccod = a.tcom_ccod_origen and b.tcom_ccod = 3 \n";
			SQL = SQL +  " 		     ) a \n";
			SQL = SQL +  " 		     INNER JOIN detalle_compromisos b \n";
			SQL = SQL +  " 		     ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "		     INNER JOIN abonos c \n";
			SQL = SQL +  " 		     ON b.tcom_ccod = c.tcom_ccod and b.inst_ccod = c.inst_ccod and b.comp_ndocto = c.comp_ndocto \n";
			SQL = SQL +  "		     and b.dcom_ncompromiso = c.dcom_ncompromiso and c.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  "		     INNER JOIN ingresos d \n";
			SQL = SQL +  "		     ON c.ingr_ncorr = d.ingr_ncorr and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		     INNER JOIN tipos_ingresos e \n";
			SQL = SQL +  " 		     ON d.ting_ccod = e.ting_ccod and e.ting_bingreso_real = 'S' and isnull(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		     INNER JOIN movimientos_cajas f  \n";
			SQL = SQL +  " 			 ON d.mcaj_ncorr = f.mcaj_ncorr \n";
			SQL = SQL +  " 			 INNER JOIN contratos g \n";
			SQL = SQL +  " 			 ON a.comp_ndocto_origen = g.cont_ncorr and g.econ_ccod = 1 \n";
			SQL = SQL +  " 			 INNER JOIN alumnos h \n";
			SQL = SQL +  "			 ON g.matr_ncorr = h.matr_ncorr and h.emat_ccod <> 9 \n";
			SQL = SQL +  "			 INNER JOIN ofertas_academicas i \n";
			SQL = SQL +  " 			 ON h.ofer_ncorr = i.ofer_ncorr and i.peri_ccod = '" + periodo + "' and i.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  "			 INNER JOIN especialidades j \n";
			SQL = SQL +  "			 ON i.espe_ccod = j.espe_ccod \n";
			SQL = SQL +  " 			 INNER JOIN carreras k \n";
			SQL = SQL +  " 			 ON j.carr_ccod = k.carr_ccod \n";
			SQL = SQL +  "			 group by k.carr_ccod 	\n";
			SQL = SQL +  "	) c	 \n";
			SQL = SQL +  "ON a.carr_ccod = c.carr_ccod  \n";
			SQL = SQL +  " order by a.carr_tdesc asc \n";
			//Response.Write(SQL);
			//Response.Flush();
			return SQL;
		}


		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string periodo;
			string sede;
			string fecha_termino;
			string fecha_inicio;
			string tipo_informe;

			//string paga_ncorr;
			//string imprimirFinanza;
			//string paga_ncorr_d;
			//int fila = 0;	

			periodo = Request.QueryString["periodo"];
			sede = Request.QueryString["sede"];
			fecha_inicio = Request.QueryString["fecha_inicio"];
			fecha_termino = Request.QueryString["fecha_termino"];
			tipo_informe = Request.QueryString["tipo_informe"];

			//periodo = "164";
			//sede = "1";
			//fecha_inicio = "01/11/2004";
			//fecha_termino = "01/12/2004";
			//tipo_informe = "1";

			sql = EscribirCodigo(periodo,sede,fecha_inicio,fecha_termino);

			//Response.Write("<pre>"+sql + "</pre>");
			//Response.End();

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datos1);
					
			//}
			
			//Response.End();
			
			CrystalReport1 reporte = new CrystalReport1();
			
				
			reporte.SetDataSource(datos1);
			VerReporte.ReportSource = reporte;
			if (tipo_informe=="1")
			{
				ExportarPDF(reporte);
			}
			else
			{
				ExportarEXCEL(reporte);
			}
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
			this.datos1 = new Pres_Ingreso_Real.Datos();
			((System.ComponentModel.ISupportInitialize)(this.datos1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "ProsupuestadoReal", new System.Data.Common.DataColumnMapping[] {
																																																							 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																							 new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																							 new System.Data.Common.DataColumnMapping("TOTAL_MATR_COMPROMETIDA", "TOTAL_MATR_COMPROMETIDA"),
																																																							 new System.Data.Common.DataColumnMapping("TOTAL_COL_COMPROMETIDA", "TOTAL_COL_COMPROMETIDA"),
																																																							 new System.Data.Common.DataColumnMapping("TOTAL_MATR_REAL", "TOTAL_MATR_REAL"),
																																																							 new System.Data.Common.DataColumnMapping("TOTAL_COL_REAL", "TOTAL_COL_REAL"),
																																																							 new System.Data.Common.DataColumnMapping("SALDO", "SALDO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS SEDE_TDESC, \'\' AS CARR_TDESC, \'\' AS CARR_CCOD, \'\' AS TOTAL_MATR_COMP" +
				"ROMETIDA, \'\' AS TOTAL_COL_COMPROMETIDA, \'\' AS TOTAL_MATR_REAL, \'\' AS TOTAL_COL_R" +
				"EAL, \'\' AS SALDO, \'\' AS PERIODO, \'\' AS FECHA_INICIO, \'\' AS FECHA_TERMINO FROM DU" +
				"AL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datos1
			// 
			this.datos1.DataSetName = "Datos";
			this.datos1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datos1.Namespace = "http://www.tempuri.org/Datos.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datos1)).EndInit();

		}
		#endregion
	}
}
