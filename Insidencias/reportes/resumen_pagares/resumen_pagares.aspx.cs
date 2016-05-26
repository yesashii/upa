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


namespace resumen_pagares
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected resumen_pagares.DataSet1 ds;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbConnection conexion;


		private void ExportarPDF(ReportDocument rep) 
		{
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


		private string ObtenerSql(string p_anos_ccod, string p_peri_ccod, string p_sede_ccod)
		{
			string SQL;

			SQL = " select a.carr_tdesc, \n";
			SQL = SQL +  "        nvl(b.npagares, 0) as npagares, \n";
			SQL = SQL +  " 	   nvl(b.npagares_asignados, 0) as npagares_asignados, \n";
			SQL = SQL +  " 	   nvl(b.npagares_acumulados, 0) as npagares_acumulados, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_uf_nuevos, 0) as monto_periodo_uf_nuevos, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_uf_antiguos,  0) as monto_periodo_uf_antiguos, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_uf, 0) as monto_periodo_uf, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_uf_nuevos, 0) as monto_anterior_uf_nuevos, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_uf_antiguos,  0) as monto_anterior_uf_antiguos, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_uf, 0) as monto_anterior_uf, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_pesos_nuevos, 0) as monto_periodo_pesos_nuevos, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_pesos_antiguos, 0) as monto_periodo_pesos_antiguos, \n";
			SQL = SQL +  " 	   nvl(b.monto_periodo_pesos, 0) as monto_periodo_pesos, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_pesos_nuevos, 0) as monto_anterior_pesos_nuevos, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_pesos_antiguos, 0) as monto_anterior_pesos_antiguos, \n";
			SQL = SQL +  " 	   nvl(b.monto_anterior_pesos, 0) as monto_anterior_pesos, \n";
			SQL = SQL +  " 	   nvl(c.npagares_pactado, 0) as npagares_pactado, \n";
			SQL = SQL +  " 	   nvl(c.npagares_prorrogado, 0) as npagares_prorrogado, \n";
			SQL = SQL +  " 	   nvl(c.npagares_pac_parcial, 0) as npagares_pac_parcial, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_nuevos_pactado, 0) as monto_uf_nuevos_pactado, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_nuevos_prorrogado, 0) as monto_uf_nuevos_prorrogado, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_nuevos_pac_parcial, 0) as monto_uf_nuevos_pac_parcial, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_antiguos_pactado, 0) as monto_uf_antiguos_pactado, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_antiguos_prorrogado, 0) as monto_uf_antiguos_prorrogado, \n";
			SQL = SQL +  " 	   nvl(c.monto_uf_antiguos_pac_parcial, 0) as monto_uf_antiguos_pac_parcial, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_nuevos_pactado, 0) as monto_pss_nuevos_pactado, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_nuevos_prorrogado, 0) as monto_pss_nuevos_prorrogado, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_nuevos_pac_parcial, 0) as monto_pss_nuevos_pac_parcial, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_antiguos_pactado, 0) as monto_pss_antiguos_pactado, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_antiguos_prorrogado, 0) as monto_pss_antiguos_prorrogado, \n";
			SQL = SQL +  " 	   nvl(c.monto_pss_antiguos_pac_parcial, 0) as monto_pss_antiguos_pac_parcial \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct 0 as tipo, c.carr_ccod, c.carr_tdesc \n";
			SQL = SQL +  " 	  from ofertas_academicas a, especialidades b, carreras c \n";
			SQL = SQL +  " 	  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 	    and b.carr_ccod = c.carr_ccod \n";
			SQL = SQL +  " 		and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL + "     union \n";
			SQL = SQL + "     select 1 as tipo, 'TT', 'TODAS LAS CARRERAS' from dual \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select decode(grouping(k.carr_ccod), 1, 'TT', k.carr_ccod) as carr_ccod, \n";
			SQL = SQL +  " 	         count(b.paga_ncorr) as npagares, \n";
			SQL = SQL +  " 			 sum(case when g.anos_ccod = '" + p_anos_ccod + "' and (nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0)) = (nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0)) then 1 else 0 end) as npagares_asignados, \n";
			SQL = SQL +  " 			 sum(case when g.anos_ccod <> '" + p_anos_ccod + "' or (nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0)) <> (nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0)) then 1 else 0 end) as npagares_acumulados, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'S' and g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf_nuevos, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'N' and g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf_antiguos, \n";
			SQL = SQL +  " 			 sum(round(case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'S' then nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end) else 0 end, 2)) as monto_anterior_uf_nuevos, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'N' then nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end) else 0 end, 2)) as monto_anterior_uf_antiguos, \n";
			SQL = SQL +  " 			 sum(round(nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end), 2)) as monto_anterior_uf, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'S' and g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end * nvl(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos_nuevos, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'N' and g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end * nvl(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos_antiguos, \n";
			SQL = SQL +  " 			 sum(round(case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end * nvl(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'S' then (nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end)) * nvl(j.ufom_mvalor, 0) else 0 end, 2)) as monto_anterior_pesos_nuevos, \n";
			SQL = SQL +  " 			 sum(round(case when es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') = 'N' then (nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end)) * nvl(j.ufom_mvalor, 0) else 0 end, 2)) as monto_anterior_pesos_antiguos, \n";
			SQL = SQL +  " 			 sum(round((nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then nvl(a.bene_mmonto_matricula, 0) + nvl(a.bene_mmonto_colegiatura, 0) else 0 end)) * nvl(j.ufom_mvalor, 0), 2)) as monto_anterior_pesos    \n";
			SQL = SQL +  " 	  from beneficios a, pagares b, contratos c, tipos_detalle d, alumnos e, ofertas_academicas f, periodos_academicos g, \n";
			SQL = SQL +  " 		   especialidades h, carreras k, \n";
			SQL = SQL +  " 		   estados_pagares i, uf j \n";
			SQL = SQL +  " 	  where a.paga_ncorr = b.paga_ncorr \n";
			SQL = SQL +  " 		and b.cont_ncorr = c.cont_ncorr \n";
			SQL = SQL +  " 		and a.cont_ncorr = c.cont_ncorr \n";
			SQL = SQL +  " 		and a.stde_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 		and c.matr_ncorr = e.matr_ncorr  \n";
			SQL = SQL +  " 		and e.ofer_ncorr = f.ofer_ncorr \n";
			SQL = SQL +  " 		and f.peri_ccod = g.peri_ccod \n";
			SQL = SQL +  " 		and f.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 		and b.epag_ccod = i.epag_ccod \n";
			SQL = SQL +  " 		and a.ufom_ncorr = j.ufom_ncorr \n";
			SQL = SQL +  " 		and h.carr_ccod = k.carr_ccod \n";
			SQL = SQL +  " 		and b.paga_ncorr = ultimo_pagare_asignado(e.pers_ncorr) \n";
			SQL = SQL +  " 		and e.emat_ccod <> 9 \n";
			SQL = SQL +  " 		and d.tben_ccod = 1 \n";
			SQL = SQL +  " 		and a.eben_ccod = 1 \n";
			SQL = SQL +  " 		and c.econ_ccod = 1   \n";
			SQL = SQL +  " 		and b.epag_ccod not in (6, 8) \n";
			SQL = SQL +  " 		and f.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		and g.anos_ccod <= " + p_anos_ccod + " \n";
			SQL = SQL +  " 	  group by rollup(k.carr_ccod)  \n";
			SQL = SQL +  " 	 ) b, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select decode(grouping(carr_ccod), 1, 'TT', carr_ccod) as carr_ccod, \n";
			SQL = SQL +  " 	         sum(case when epag_ccod = 4 then 1 else 0 end) as npagares_pactado, \n";
			SQL = SQL +  " 			 sum(case when epag_ccod = 6 then 1 else 0 end) as npagares_prorrogado, \n";
			SQL = SQL +  " 			 sum(case when epag_ccod = 8 then 1 else 0 end) as npagares_pac_parcial, \n";
			SQL = SQL +  " 		     sum(case when nuevo = 'S' and epag_ccod = 4 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_pactado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'S' and epag_ccod = 6 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_prorrogado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'S' and epag_ccod = 8 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_pac_parcial, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 4 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_pactado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 6 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_prorrogado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 8 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_pac_parcial, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'S' and epag_ccod = 4 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_pactado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'S' and epag_ccod = 6 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_prorrogado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'S' and epag_ccod = 8 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_pac_parcial, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 4 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_pactado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 6 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_prorrogado, \n";
			SQL = SQL +  " 			 sum(case when nuevo = 'N' and epag_ccod = 8 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_pac_parcial \n";
			SQL = SQL +  " 	  from ( \n";
			SQL = SQL +  " 			select g.anos_ccod, k.carr_ccod, b.epag_ccod, l.comp_mdocumento, l.comp_fdocto,	    \n";
			SQL = SQL +  " 				   nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (nvl(m.bene_mmonto_acum_matricula, 0) + nvl(m.bene_mmonto_acum_colegiatura, 0)) as pactado_uf, \n";
			SQL = SQL +  " 				   es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_peri_ccod + "') as nuevo, \n";
			SQL = SQL +  " 				   case when b.epag_ccod = 4 then nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0)  \n";
			SQL = SQL +  " 				        when b.epag_ccod = 6 then nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) \n";
			SQL = SQL +  " 						when b.epag_ccod = 8 then nvl(a.bene_mmonto_acum_matricula, 0) + nvl(a.bene_mmonto_acum_colegiatura, 0) - (nvl(m.bene_mmonto_acum_matricula, 0) + nvl(m.bene_mmonto_acum_colegiatura, 0))      \n";
			SQL = SQL +  " 				   end as monto_uf, \n";
			SQL = SQL +  " 				   nvl(o.ufom_mvalor, p.ufom_mvalor) as ufom_mvalor	    	       	    \n";
			SQL = SQL +  " 			from beneficios a, pagares b, contratos c, tipos_detalle d, alumnos e, ofertas_academicas f, periodos_academicos g, \n";
			SQL = SQL +  " 			     especialidades h, carreras k, \n";
			SQL = SQL +  " 				 estados_pagares i, uf j, \n";
			SQL = SQL +  " 				 compromisos l, \n";
			SQL = SQL +  " 				 beneficios m, pagares n, uf o, uf p \n";
			SQL = SQL +  " 			where a.paga_ncorr = b.paga_ncorr \n";
			SQL = SQL +  " 			  and b.cont_ncorr = c.cont_ncorr \n";
			SQL = SQL +  " 			  and a.cont_ncorr = c.cont_ncorr \n";
			SQL = SQL +  " 			  and a.stde_ccod = d.tdet_ccod \n";
			SQL = SQL +  " 			  and c.matr_ncorr = e.matr_ncorr  \n";
			SQL = SQL +  " 			  and e.ofer_ncorr = f.ofer_ncorr \n";
			SQL = SQL +  " 			  and f.peri_ccod = g.peri_ccod \n";
			SQL = SQL +  " 			  and f.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 			  and b.epag_ccod = i.epag_ccod \n";
			SQL = SQL +  " 			  and a.ufom_ncorr = j.ufom_ncorr \n";
			SQL = SQL +  " 			  and h.carr_ccod = k.carr_ccod \n";
			SQL = SQL +  " 			  and b.paga_ncorr = l.comp_ndocto (+) \n";
			SQL = SQL +  " 			  and b.paga_ncorr = m.paga_ncorr_anterior (+) \n";
			SQL = SQL +  " 			  and m.paga_ncorr = n.paga_ncorr (+) \n";
			SQL = SQL +  " 			  and m.ufom_ncorr = o.ufom_ncorr (+) \n";
			SQL = SQL +  " 			  and p.ufom_ncorr (+) = obtener_ufom_ncorr(l.comp_fdocto) \n";
			SQL = SQL +  " 			  and l.tcom_ccod (+) = 11 \n";
			SQL = SQL +  " 			  and l.ecom_ccod (+) = 1   \n";
			SQL = SQL +  " 			  and e.emat_ccod <> 9 \n";
			SQL = SQL +  " 			  and d.tben_ccod = 1 \n";
			SQL = SQL +  " 			  and a.eben_ccod = 1 \n";
			SQL = SQL +  " 			  and c.econ_ccod = 1 \n";
			SQL = SQL +  " 			  and b.epag_ccod in (6, 8, 4)   \n";
			SQL = SQL +  " 			  and f.sede_ccod = '" + p_sede_ccod + "'   \n";
			SQL = SQL +  " 			  and g.anos_ccod <= " + p_anos_ccod + " \n";
			SQL = SQL +  " 			order by e.pers_ncorr, c.cont_fcontrato, a.bene_fbeneficio, b.paga_fpagare	 \n";
			SQL = SQL +  " 		) \n";
			SQL = SQL +  " 		group by rollup(carr_ccod) \n";
			SQL = SQL +  " 	 ) c \n";
			SQL = SQL +  " where a.carr_ccod = b.carr_ccod (+) \n";
			SQL = SQL +  "   and a.carr_ccod = c.carr_ccod (+) \n";
			SQL = SQL +  " order by a.tipo asc, a.carr_tdesc asc \n";
//-----------------------------------------------------------------------------------------
			SQL="";
//-----------------------------------------------------------------------------------------

			SQL =  " select a.carr_tdesc, \n";
		    SQL = SQL +  "        isnull(b.npagares, 0) as npagares, \n";
		 	SQL = SQL +  "   isnull(b.npagares_asignados, 0) as npagares_asignados, \n";
		 	SQL = SQL +  "   isnull(b.npagares_acumulados, 0) as npagares_acumulados, \n";
		 	SQL = SQL +  "   isnull(b.monto_periodo_uf_nuevos, 0) as monto_periodo_uf_nuevos,\n"; 
		 	SQL = SQL +  "   isnull(b.monto_periodo_uf_antiguos,  0) as monto_periodo_uf_antiguos, \n";
		 	SQL = SQL +  "   isnull(b.monto_periodo_uf, 0) as monto_periodo_uf, \n";
		 	SQL = SQL +  "   isnull(b.monto_anterior_uf_nuevos, 0) as monto_anterior_uf_nuevos, \n";
		 	SQL = SQL +  "   isnull(b.monto_anterior_uf_antiguos,  0) as monto_anterior_uf_antiguos, \n";
		 	SQL = SQL +  "   isnull(b.monto_anterior_uf, 0) as monto_anterior_uf, \n";
		 	SQL = SQL +  "   isnull(b.monto_periodo_pesos_nuevos, 0) as monto_periodo_pesos_nuevos, \n";
		 	SQL = SQL +  "   isnull(b.monto_periodo_pesos_antiguos, 0) as monto_periodo_pesos_antiguos, \n";
		 	SQL = SQL +  "   isnull(b.monto_periodo_pesos, 0) as monto_periodo_pesos, \n";
		 	SQL = SQL +  "   isnull(b.monto_anterior_pesos_nuevos, 0) as monto_anterior_pesos_nuevos,\n"; 
		 	SQL = SQL +  "   isnull(b.monto_anterior_pesos_antiguos, 0) as monto_anterior_pesos_antiguos, \n";
		 	SQL = SQL +  "   isnull(b.monto_anterior_pesos, 0) as monto_anterior_pesos, \n";
		 	SQL = SQL +  "   isnull(c.npagares_pactado, 0) as npagares_pactado, \n";
		 	SQL = SQL +  "   isnull(c.npagares_prorrogado, 0) as npagares_prorrogado, \n";
		 	SQL = SQL +  "   isnull(c.npagares_pac_parcial, 0) as npagares_pac_parcial, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_nuevos_pactado, 0) as monto_uf_nuevos_pactado, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_nuevos_prorrogado, 0) as monto_uf_nuevos_prorrogado, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_nuevos_pac_parcial, 0) as monto_uf_nuevos_pac_parcial, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_antiguos_pactado, 0) as monto_uf_antiguos_pactado, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_antiguos_prorrogado, 0) as monto_uf_antiguos_prorrogado, \n";
		 	SQL = SQL +  "   isnull(c.monto_uf_antiguos_pac_parcial, 0) as monto_uf_antiguos_pac_parcial, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_nuevos_pactado, 0) as monto_pss_nuevos_pactado, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_nuevos_prorrogado, 0) as monto_pss_nuevos_prorrogado, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_nuevos_pac_parcial, 0) as monto_pss_nuevos_pac_parcial, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_antiguos_pactado, 0) as monto_pss_antiguos_pactado, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_antiguos_prorrogado, 0) as monto_pss_antiguos_prorrogado, \n";
		 	SQL = SQL +  "   isnull(c.monto_pss_antiguos_pac_parcial, 0) as monto_pss_antiguos_pac_parcial \n";
			SQL = SQL +  " from ( \n";
		    SQL = SQL +  "  Select distinct 0 as tipo, c.carr_ccod, c.carr_tdesc \n";
		 	SQL = SQL +  "  from ofertas_academicas a, especialidades b, carreras c \n";
		 	SQL = SQL +  "  where a.espe_ccod = b.espe_ccod \n";
		 	SQL = SQL +  "    and b.carr_ccod = c.carr_ccod \n";
		 	SQL = SQL +  "	and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  "     union \n";
			SQL = SQL +  "  select 1 as tipo, 'TT', 'TODAS LAS CARRERAS'  \n";
		 	SQL = SQL +  " ) a left outer join \n";
		 	SQL = SQL +  " ( \n";
		 	SQL = SQL +  "  select case grouping(k.carr_ccod) when 1 then 'TT' else k.carr_ccod end as carr_ccod, \n";
		 	SQL = SQL +  "         count(b.paga_ncorr) as npagares, \n";
		 	SQL = SQL +  "		 sum(case when g.anos_ccod = '" + p_anos_ccod + "' and (isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0)) = (isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0)) then 1 else 0 end) as npagares_asignados, \n";
		 	SQL = SQL +  "		 sum(case when g.anos_ccod <> '" + p_anos_ccod + "' or (isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0)) <> (isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0)) then 1 else 0 end) as npagares_acumulados, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'S' and g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf_nuevos, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'N' and g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf_antiguos, \n";
		 	SQL = SQL +  "		 sum(round(case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end, 2)) as monto_periodo_uf, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'S' then isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end) else 0 end, 2)) as monto_anterior_uf_nuevos, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'N' then isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end) else 0 end, 2)) as monto_anterior_uf_antiguos, \n";
		 	SQL = SQL +  "		 sum(round(isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end), 2)) as monto_anterior_uf, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'S' and g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end * isnull(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos_nuevos, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'N' and g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end * isnull(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos_antiguos, \n";
		 	SQL = SQL +  "		 sum(round(case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end * isnull(j.ufom_mvalor, 0), 2)) as monto_periodo_pesos, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'S' then (isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end)) * isnull(j.ufom_mvalor, 0) else 0 end, 2)) as monto_anterior_pesos_nuevos, \n";
		 	SQL = SQL +  "		 sum(round(case when protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') = 'N' then (isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end)) * isnull(j.ufom_mvalor, 0) else 0 end, 2)) as monto_anterior_pesos_antiguos, \n";
		 	SQL = SQL +  "		 sum(round((isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (case when g.anos_ccod = '" + p_anos_ccod + "' then isnull(a.bene_mmonto_matricula, 0) + isnull(a.bene_mmonto_colegiatura, 0) else 0 end)) * isnull(j.ufom_mvalor, 0), 2)) as monto_anterior_pesos    \n";
		 	SQL = SQL +  "  from beneficios a, pagares b, contratos c, tipos_detalle d, alumnos e, ofertas_academicas f, periodos_academicos g, \n";
		 	SQL = SQL +  "	   especialidades h, carreras k, \n";
		 	SQL = SQL +  "	   estados_pagares i, uf j \n";
		 	SQL = SQL +  "  where a.paga_ncorr = b.paga_ncorr \n";
		 	SQL = SQL +  "	and b.cont_ncorr = c.cont_ncorr \n";
		 	SQL = SQL +  "	and a.cont_ncorr = c.cont_ncorr \n";
		 	SQL = SQL +  "	and a.stde_ccod = d.tdet_ccod \n";
		 	SQL = SQL +  "	and c.matr_ncorr = e.matr_ncorr  \n";
		 	SQL = SQL +  "	and e.ofer_ncorr = f.ofer_ncorr \n";
		 	SQL = SQL +  "	and f.peri_ccod = g.peri_ccod \n";
		 	SQL = SQL +  "	and f.espe_ccod = h.espe_ccod \n";
		 	SQL = SQL +  "	and b.epag_ccod = i.epag_ccod \n";
		 	SQL = SQL +  "	and a.ufom_ncorr = j.ufom_ncorr \n";
		 	SQL = SQL +  "	and h.carr_ccod = k.carr_ccod \n";
		 	SQL = SQL +  "	and b.paga_ncorr = protic.ultimo_pagare_asignado(e.pers_ncorr) \n";
		 	SQL = SQL +  "	and e.emat_ccod <> 9 \n";
		 	SQL = SQL +  "	and d.tben_ccod = 1 \n";
		 	SQL = SQL +  "	and a.eben_ccod = 1 \n";
		 	SQL = SQL +  "	and c.econ_ccod = 1   \n";
		 	SQL = SQL +  "	and b.epag_ccod not in (6, 8) \n";
		 	SQL = SQL +  "	and f.sede_ccod = '" + p_sede_ccod + "' \n";
		 	SQL = SQL +  "	and g.anos_ccod <= '" + p_anos_ccod + "' \n";
		 	SQL = SQL +  "  group by k.carr_ccod \n";
            SQL = SQL +  "  with rollup  \n";
		 	SQL = SQL +  " ) b on a.carr_ccod = b.carr_ccod left outer join \n";
		 	SQL = SQL +  " ( \n";
		 	SQL = SQL +  "  select case grouping(carr_ccod) when 1 then 'TT' else carr_ccod end as carr_ccod, \n";
		 	SQL = SQL +  "         sum(case when epag_ccod = 4 then 1 else 0 end) as npagares_pactado, \n";
		 	SQL = SQL +  "		 sum(case when epag_ccod = 6 then 1 else 0 end) as npagares_prorrogado, \n";
		 	SQL = SQL +  "		 sum(case when epag_ccod = 8 then 1 else 0 end) as npagares_pac_parcial, \n";
		 	SQL = SQL +  "	     sum(case when nuevo = 'S' and epag_ccod = 4 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_pactado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'S' and epag_ccod = 6 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_prorrogado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'S' and epag_ccod = 8 then round(monto_uf, 2) else 0 end) as monto_uf_nuevos_pac_parcial, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 4 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_pactado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 6 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_prorrogado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 8 then round(monto_uf, 2) else 0 end) as monto_uf_antiguos_pac_parcial, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'S' and epag_ccod = 4 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_pactado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'S' and epag_ccod = 6 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_prorrogado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'S' and epag_ccod = 8 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_nuevos_pac_parcial, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 4 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_pactado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 6 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_prorrogado, \n";
		 	SQL = SQL +  "		 sum(case when nuevo = 'N' and epag_ccod = 8 then round(monto_uf, 2) else 0 end * ufom_mvalor) as monto_pss_antiguos_pac_parcial \n";
		 	SQL = SQL +  "  from ( \n";
            SQL = SQL +  "        select g.anos_ccod, k.carr_ccod, b.epag_ccod, l.comp_mdocumento, l.comp_fdocto,	\n";    
		 	SQL = SQL +  "			   isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (isnull(m.bene_mmonto_acum_matricula, 0) + isnull(m.bene_mmonto_acum_colegiatura, 0)) as pactado_uf, \n";
		 	SQL = SQL +  "			   protic.es_nuevo_carrera(e.pers_ncorr, h.carr_ccod, '" + p_anos_ccod + "') as nuevo, \n";
		 	SQL = SQL +  "			   case when b.epag_ccod = 4 then isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0)  \n";
		 	SQL = SQL +  "			        when b.epag_ccod = 6 then isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) \n";
		 	SQL = SQL +  "					when b.epag_ccod = 8 then isnull(a.bene_mmonto_acum_matricula, 0) + isnull(a.bene_mmonto_acum_colegiatura, 0) - (isnull(m.bene_mmonto_acum_matricula, 0) + isnull(m.bene_mmonto_acum_colegiatura, 0))      \n";
		 	SQL = SQL +  "			   end as monto_uf, '0' as ufom_mvalor \n";
            SQL = SQL +  "               --, isnull(o.ufom_mvalor, p.ufom_mvalor) as ufom_mvalor	\n";    	       	    
		 	SQL = SQL +  "		from beneficios a \n";
            SQL = SQL +  "        join pagares b \n";
            SQL = SQL +  "            on a.paga_ncorr = b.paga_ncorr \n";
            SQL = SQL +  "        join contratos c \n";
            SQL = SQL +  "            on b.cont_ncorr = c.cont_ncorr \n";
            SQL = SQL +  "            and a.cont_ncorr = c.cont_ncorr  \n";
            SQL = SQL +  "        join tipos_detalle d \n";
            SQL = SQL +  "            on a.stde_ccod = d.tdet_ccod \n";
            SQL = SQL +  "        join alumnos e \n";
            SQL = SQL +  "            on c.matr_ncorr = e.matr_ncorr  \n";
            SQL = SQL +  "        join ofertas_academicas f \n";
            SQL = SQL +  "            on e.ofer_ncorr = f.ofer_ncorr \n";
            SQL = SQL +  "        join periodos_academicos g \n";
            SQL = SQL +  "            on f.peri_ccod = g.peri_ccod  \n";
		 	SQL = SQL +  "	    join especialidades h \n";
            SQL = SQL +  "            on f.espe_ccod = h.espe_ccod \n";
            SQL = SQL +  "        join carreras k \n";
            SQL = SQL +  "            on h.carr_ccod = k.carr_ccod \n";
		 	SQL = SQL +  "	    join estados_pagares i \n";
            SQL = SQL +  "            on b.epag_ccod = i.epag_ccod \n";
		 	SQL = SQL +  "	    left outer join compromisos l \n";
            SQL = SQL +  "            on b.paga_ncorr = l.comp_ndocto \n";
		 	SQL = SQL +  "	    left outer join beneficios m \n";
            SQL = SQL +  "            on b.paga_ncorr = m.paga_ncorr_anterior \n";
            SQL = SQL +  "        left outer join pagares n  \n";
            SQL = SQL +  "            on m.paga_ncorr = n.paga_ncorr \n";
		 	SQL = SQL +  "		where l.tcom_ccod  = 11 -- ( l.tcom_ccod  =* 11)\n";
		 	SQL = SQL +  "		  and l.ecom_ccod  = 1 -- (l.ecom_ccod  =* 1 )   \n";
		 	SQL = SQL +  "		  and e.emat_ccod <> 9 \n";
		 	SQL = SQL +  "		  and d.tben_ccod = 1 \n";
		 	SQL = SQL +  "		  and a.eben_ccod = 1 \n";
		 	SQL = SQL +  "		  and c.econ_ccod = 1 \n";
		 	SQL = SQL +  "		  and b.epag_ccod in (6, 8, 4)   \n";
		 	SQL = SQL +  "		  and f.sede_ccod = '" + p_sede_ccod + "'   \n";
		 	SQL = SQL +  "		  and g.anos_ccod <= '" + p_anos_ccod + "' \n";
		 	SQL = SQL +  "		--order by e.pers_ncorr, c.cont_fcontrato, a.bene_fbeneficio, b.paga_fpagare \n";
		 	SQL = SQL +  "	) as tabla \n";
		 	SQL = SQL +  "	group by tabla.carr_ccod \n";
            SQL = SQL +  "    with rollup  \n";
		 	SQL = SQL +  " ) c on a.carr_ccod = c.carr_ccod \n";
		    SQL = SQL +  " order by a.tipo asc, a.carr_tdesc asc \n"; 


			return SQL;
		}
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string q_sede_ccod = Request["filtros[0][sede_ccod]"].ToString();
			string q_anos_ccod = Request["filtros[0][anos_ccod]"].ToString();
			string q_peri_ccod = Request["filtros[0][peri_ccod]"].ToString();
			string q_formato = Request["filtros[0][formato]"].ToString();
			crResumenPagares rep = new crResumenPagares();


			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_anos_ccod, q_peri_ccod, q_sede_ccod);
			adpDetalles.Fill(ds);

			adpEncabezado.SelectCommand.Parameters["sede_ccod"].Value = q_sede_ccod;
			adpEncabezado.SelectCommand.Parameters["anos_ccod"].Value = q_anos_ccod;
			adpEncabezado.Fill(ds);
			
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
			this.ds = new resumen_pagares.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "CARRERAS", new System.Data.Common.DataColumnMapping[] {
																																																			  new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES", "NPAGARES"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES_ASIGNADOS", "NPAGARES_ASIGNADOS"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES_ACUMULADOS", "NPAGARES_ACUMULADOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_UF_NUEVOS", "MONTO_PERIODO_UF_NUEVOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_UF_ANTIGUOS", "MONTO_PERIODO_UF_ANTIGUOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_UF", "MONTO_PERIODO_UF"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_UF_NUEVOS", "MONTO_ANTERIOR_UF_NUEVOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_UF_ANTIGUOS", "MONTO_ANTERIOR_UF_ANTIGUOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_UF", "MONTO_ANTERIOR_UF"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_PESOS_NUEVOS", "MONTO_PERIODO_PESOS_NUEVOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_PESOS_ANTIGUOS", "MONTO_PERIODO_PESOS_ANTIGUOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PERIODO_PESOS", "MONTO_PERIODO_PESOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_PESOS_NUEVOS", "MONTO_ANTERIOR_PESOS_NUEVOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_PESOS_ANTIGUOS", "MONTO_ANTERIOR_PESOS_ANTIGUOS"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_ANTERIOR_PESOS", "MONTO_ANTERIOR_PESOS"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES_PACTADO", "NPAGARES_PACTADO"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES_PRORROGADO", "NPAGARES_PRORROGADO"),
																																																			  new System.Data.Common.DataColumnMapping("NPAGARES_PAC_PARCIAL", "NPAGARES_PAC_PARCIAL"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_NUEVOS_PACTADO", "MONTO_UF_NUEVOS_PACTADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_NUEVOS_PRORROGADO", "MONTO_UF_NUEVOS_PRORROGADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_NUEVOS_PAC_PARCIAL", "MONTO_UF_NUEVOS_PAC_PARCIAL"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_ANTIGUOS_PACTADO", "MONTO_UF_ANTIGUOS_PACTADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_ANTIGUOS_PRORROGADO", "MONTO_UF_ANTIGUOS_PRORROGADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_UF_ANTIGUOS_PAC_PARCIAL", "MONTO_UF_ANTIGUOS_PAC_PARCIAL"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_NUEVOS_PACTADO", "MONTO_PSS_NUEVOS_PACTADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_NUEVOS_PRORROGADO", "MONTO_PSS_NUEVOS_PRORROGADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_NUEVOS_PAC_PARCIAL", "MONTO_PSS_NUEVOS_PAC_PARCIAL"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_ANTIGUOS_PACTADO", "MONTO_PSS_ANTIGUOS_PACTADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_ANTIGUOS_PRORROGADO", "MONTO_PSS_ANTIGUOS_PRORROGADO"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO_PSS_ANTIGUOS_PAC_PARCIAL", "MONTO_PSS_ANTIGUOS_PAC_PARCIAL")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CARR_TDESC, 0 AS NPAGARES, 0 AS NPAGARES_ASIGNADOS, 0 AS NPAGARES_ACUMULADOS, 0 AS MONTO_PERIODO_UF_NUEVOS, 0 AS MONTO_PERIODO_UF_ANTIGUOS, 0 AS MONTO_PERIODO_UF, 0 AS MONTO_ANTERIOR_UF_NUEVOS, 0 AS MONTO_ANTERIOR_UF_ANTIGUOS, 0 AS MONTO_ANTERIOR_UF, 0 AS MONTO_PERIODO_PESOS_NUEVOS, 0 AS MONTO_PERIODO_PESOS_ANTIGUOS, 0 AS MONTO_PERIODO_PESOS, 0 AS MONTO_ANTERIOR_PESOS_NUEVOS, 0 AS MONTO_ANTERIOR_PESOS_ANTIGUOS, 0 AS MONTO_ANTERIOR_PESOS, 0 AS NPAGARES_PACTADO, 0 AS NPAGARES_PRORROGADO, 0 AS NPAGARES_PAC_PARCIAL, 0 AS MONTO_UF_NUEVOS_PACTADO, 0 AS MONTO_UF_NUEVOS_PRORROGADO, 0 AS MONTO_UF_NUEVOS_PAC_PARCIAL, 0 AS MONTO_UF_ANTIGUOS_PACTADO, 0 AS MONTO_UF_ANTIGUOS_PRORROGADO, 0 AS MONTO_UF_ANTIGUOS_PAC_PARCIAL, 0 AS MONTO_PSS_NUEVOS_PACTADO, 0 AS MONTO_PSS_NUEVOS_PRORROGADO, 0 AS MONTO_PSS_NUEVOS_PAC_PARCIAL, 0 AS MONTO_PSS_ANTIGUOS_PACTADO, 0 AS MONTO_PSS_ANTIGUOS_PRORROGADO, 0 AS MONTO_PSS_ANTIGUOS_PAC_PARCIAL FROM DUAL";
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
			// 
			// adpEncabezado
			// 
			this.adpEncabezado.SelectCommand = this.oleDbSelectCommand2;
			this.adpEncabezado.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "SEDES", new System.Data.Common.DataColumnMapping[] {
																																																			 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("ANOS_CCOD", "ANOS_CCOD"),
																																																			 new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT A.SEDE_TDESC, B.ANOS_CCOD, A.SEDE_CCOD FROM SEDES A, ANOS B WHERE (A.SEDE_" +
				"CCOD = ?) AND (B.ANOS_CCOD = ?)";
			this.oleDbSelectCommand2.Connection = this.conexion;
			this.oleDbSelectCommand2.Parameters.Add(new System.Data.OleDb.OleDbParameter("SEDE_CCOD", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(3)), ((System.Byte)(0)), "SEDE_CCOD", System.Data.DataRowVersion.Current, null));
			this.oleDbSelectCommand2.Parameters.Add(new System.Data.OleDb.OleDbParameter("ANOS_CCOD", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(4)), ((System.Byte)(0)), "ANOS_CCOD", System.Data.DataRowVersion.Current, null));
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
