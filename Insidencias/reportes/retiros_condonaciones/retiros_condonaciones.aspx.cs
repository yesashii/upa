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

namespace retiros_condonaciones
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection conexion;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected retiros_condonaciones.DataSet1 ds;

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

/*
		private string ObtenerSql(string p_anos_ccod, string p_sede_ccod)
		{
			string SQL;

			SQL = " select a.tipo || ' ' || a.carr_tdesc as orden, a.carr_tdesc, a.ting_tdesc, \n";
			SQL = SQL +  "        nvl(b.total_01, 0) as total_01, \n";
			SQL = SQL +  " 	   nvl(b.total_02, 0) as total_02, \n";
			SQL = SQL +  " 	   nvl(b.total_03, 0) as total_03, \n";
			SQL = SQL +  " 	   nvl(b.total_04, 0) as total_04, \n";
			SQL = SQL +  " 	   nvl(b.total_05, 0) as total_05, \n";
			SQL = SQL +  " 	   nvl(b.total_06, 0) as total_06, \n";
			SQL = SQL +  " 	   nvl(b.total_07, 0) as total_07, \n";
			SQL = SQL +  " 	   nvl(b.total_08, 0) as total_08, \n";
			SQL = SQL +  " 	   nvl(b.total_09, 0) as total_09, \n";
			SQL = SQL +  " 	   nvl(b.total_10, 0) as total_10, \n";
			SQL = SQL +  " 	   nvl(b.total_11, 0) as total_11, \n";
			SQL = SQL +  " 	   nvl(b.total_12, 0) as total_12, \n";
			SQL = SQL +  " 	   nvl(b.total, 0) as total \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select a.tipo, a.carr_ccod, a.carr_tdesc, b.ting_ccod, b.ting_tdesc \n";
			SQL = SQL +  " 	  from ( \n";
			SQL = SQL +  " 	        select distinct 0 as tipo, c.carr_ccod, c.carr_tdesc \n";
			SQL = SQL +  " 			from ofertas_academicas a, especialidades b, carreras c \n";
			SQL = SQL +  " 			where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 			  and b.carr_ccod = c.carr_ccod \n";
			SQL = SQL +  " 			  and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 			union select 1 as tipo, 'TT' as carr_ccod, 'TODAS LAS CARRERAS' as carr_tdesc from dual \n";
			SQL = SQL +  " 		   ) a, tipos_ingresos b \n";
			SQL = SQL +  " 	  where b.ting_ccod in (20, 25, 40, 43)		 \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select decode(grouping(h.carr_ccod), 1, 'TT', h.carr_ccod) as carr_ccod, f.ting_ccod, \n";
			SQL = SQL +  " 	         sum(case when to_char(a.ingr_fpago, 'mm') = '01' then a.ingr_mtotal else 0 end) as total_01, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '02' then a.ingr_mtotal else 0 end) as total_02, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '03' then a.ingr_mtotal else 0 end) as total_03, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '04' then a.ingr_mtotal else 0 end) as total_04, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '05' then a.ingr_mtotal else 0 end) as total_05, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '06' then a.ingr_mtotal else 0 end) as total_06, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '07' then a.ingr_mtotal else 0 end) as total_07, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '08' then a.ingr_mtotal else 0 end) as total_08, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '09' then a.ingr_mtotal else 0 end) as total_09, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '10' then a.ingr_mtotal else 0 end) as total_10, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '11' then a.ingr_mtotal else 0 end) as total_11, \n";
			SQL = SQL +  " 			 sum(case when to_char(a.ingr_fpago, 'mm') = '12' then a.ingr_mtotal else 0 end) as total_12,		    \n";
			SQL = SQL +  " 			 sum(a.ingr_mtotal) as total \n";
			SQL = SQL +  " 		from ingresos a, detalle_ingresos b, movimientos_cajas c, \n";
			SQL = SQL +  " 		     alumnos d, ofertas_academicas e, especialidades g, carreras h, \n";
			SQL = SQL +  " 			 tipos_ingresos f \n";
			SQL = SQL +  " 		where a.ingr_ncorr = b.ingr_ncorr \n";
			SQL = SQL +  " 		  and a.mcaj_ncorr = c.mcaj_ncorr \n";
			SQL = SQL +  " 		  and a.pers_ncorr = d.pers_ncorr \n";
			SQL = SQL +  " 		  and d.ofer_ncorr = e.ofer_ncorr \n";
			SQL = SQL +  " 		  and b.ting_ccod = f.ting_ccod   \n";
			SQL = SQL +  " 		  and e.espe_ccod = g.espe_ccod \n";
			SQL = SQL +  " 		  and g.carr_ccod = h.carr_ccod  \n";
			SQL = SQL +  " 		  and a.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and a.ting_ccod = 17 \n";
			SQL = SQL +  " 		  and b.ting_ccod in (20, 25, 40, 43) \n";
			SQL = SQL +  " 		  and d.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and e.peri_ccod = ultimo_periodo_matriculado(a.pers_ncorr) \n";
			SQL = SQL +  " 		  and to_char(a.ingr_fpago, 'yyyy') = '" + p_anos_ccod + "'   \n";
			SQL = SQL +  " 		  and e.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by rollup(f.ting_ccod, h.carr_ccod) \n";
			SQL = SQL +  " 	 ) b \n";
			SQL = SQL +  " where a.ting_ccod = b.ting_ccod (+) \n";
			SQL = SQL +  "   and a.carr_ccod = b.carr_ccod (+) \n";
			SQL = SQL +  " order by orden asc, a.ting_tdesc \n";
//---------------------------------------------------------------------------
			SQL =  "";
//---------------------------------------------------------------------------
	 SQL =  " select cast(a.tipo as varchar) + ' ' + a.carr_tdesc as orden, a.carr_tdesc, a.ting_tdesc,"; 
	SQL = SQL +  "		        isnull(b.total_01, 0) as total_01, ";
	SQL = SQL +  "		 	   isnull(b.total_02, 0) as total_02, ";
	SQL = SQL +  "		 	   isnull(b.total_03, 0) as total_03, ";
	SQL = SQL +  "		 	   isnull(b.total_04, 0) as total_04, ";
	SQL = SQL +  "		 	   isnull(b.total_05, 0) as total_05, ";
	SQL = SQL +  "		 	   isnull(b.total_06, 0) as total_06, ";
	SQL = SQL +  "		 	   isnull(b.total_07, 0) as total_07, ";
	SQL = SQL +  "		 	   isnull(b.total_08, 0) as total_08, ";
	SQL = SQL +  "		 	   isnull(b.total_09, 0) as total_09, ";
	SQL = SQL +  "		 	   isnull(b.total_10, 0) as total_10, ";
	SQL = SQL +  "		 	   isnull(b.total_11, 0) as total_11, ";
	SQL = SQL +  "		 	   isnull(b.total_12, 0) as total_12, ";
	SQL = SQL +  "		 	   isnull(b.total, 0) as total ";
	SQL = SQL +  "		 from ( ";
	SQL = SQL +  "		       select a.tipo, a.carr_ccod, a.carr_tdesc, b.ting_ccod, b.ting_tdesc ";
	SQL = SQL +  "		 	  from ( ";
	SQL = SQL +  "		 	        select distinct 0 as tipo, c.carr_ccod, c.carr_tdesc ";
	SQL = SQL +  "		 			from ofertas_academicas a, especialidades b, carreras c ";
	SQL = SQL +  "		 			where a.espe_ccod = b.espe_ccod ";
	SQL = SQL +  "		 			  and b.carr_ccod = c.carr_ccod ";
	SQL = SQL +  "		 			  and a.sede_ccod = '" + p_sede_ccod + "' ";
	SQL = SQL +  "		 			union select 1 as tipo, 'TT' as carr_ccod, 'TODAS LAS CARRERAS' as carr_tdesc  ";
	SQL = SQL +  "		 		   ) a, tipos_ingresos b ";
	SQL = SQL +  "		 	  where b.ting_ccod in (20, 25, 40, 43)		 ";
	SQL = SQL +  "		 	 ) a, ";
	SQL = SQL +  "		 	 ( ";
	SQL = SQL +  "		 	  select case grouping(h.carr_ccod) when 1 then 'TT' else h.carr_ccod end as carr_ccod, f.ting_ccod, ";
	SQL = SQL +  "		 	         sum(case when datepart(month,a.ingr_fpago) = '01' then a.ingr_mtotal else 0 end) as total_01, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '02' then a.ingr_mtotal else 0 end) as total_02, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '03' then a.ingr_mtotal else 0 end) as total_03, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '04' then a.ingr_mtotal else 0 end) as total_04, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '05' then a.ingr_mtotal else 0 end) as total_05, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '06' then a.ingr_mtotal else 0 end) as total_06, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '07' then a.ingr_mtotal else 0 end) as total_07, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '08' then a.ingr_mtotal else 0 end) as total_08, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '09' then a.ingr_mtotal else 0 end) as total_09, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '10' then a.ingr_mtotal else 0 end) as total_10, ";
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '11' then a.ingr_mtotal else 0 end) as total_11, ";	
	SQL = SQL +  "		 			 sum(case when datepart(month,a.ingr_fpago) = '12' then a.ingr_mtotal else 0 end) as total_12, ";
	SQL = SQL +  "		 			 sum(a.ingr_mtotal) as total ";
	SQL = SQL +  "		 		from ingresos a, detalle_ingresos b, movimientos_cajas c, ";
	SQL = SQL +  "		 		     alumnos d, ofertas_academicas e, especialidades g, carreras h, ";
	SQL = SQL +  "		 			 tipos_ingresos f ";
	SQL = SQL +  "		 		where a.ingr_ncorr = b.ingr_ncorr ";
	SQL = SQL +  "		 		  and a.mcaj_ncorr = c.mcaj_ncorr ";
	SQL = SQL +  "		 		  and a.pers_ncorr = d.pers_ncorr ";
	SQL = SQL +  "		 		  and d.ofer_ncorr = e.ofer_ncorr ";
	SQL = SQL +  "		 		  and b.ting_ccod = f.ting_ccod   ";
	SQL = SQL +  "		 		  and e.espe_ccod = g.espe_ccod ";
	SQL = SQL +  "		 		  and g.carr_ccod = h.carr_ccod  ";
	SQL = SQL +  "		 		  and a.eing_ccod = 1 ";
	SQL = SQL +  "		 		  and a.ting_ccod = 17 ";
	SQL = SQL +  "		 		  and b.ting_ccod in (20, 25, 40, 43) ";
	SQL = SQL +  "		 		  and d.emat_ccod <> 9 ";
	SQL = SQL +  "		 		  and e.peri_ccod = protic.ultimo_periodo_matriculado(a.pers_ncorr) ";
	SQL = SQL +  "		 		  and datepart(year,a.ingr_fpago) = '" + p_anos_ccod + "'  "; 
	SQL = SQL +  "		 		  and e.sede_ccod = '" + p_sede_ccod + "' ";
	SQL = SQL +  "		 		group by f.ting_ccod, h.carr_ccod";
    SQL = SQL +  "                WITH ROLLUP ";
	SQL = SQL +  "		 	 ) b ";
	SQL = SQL +  "		 where a.ting_ccod *= b.ting_ccod ";
	SQL = SQL +  "		   and a.carr_ccod *= b.carr_ccod ";
	SQL = SQL +  "		 order by orden asc, a.ting_tdesc ";


			return SQL;
		}
*/

		private string ObtenerSql(string p_anos_ccod, string p_sede_ccod)
		{
			string SQL;
			SQL =  "";
			SQL = SQL +  "select cast(a.tipo as varchar) + ' ' + a.carr_tdesc as orden, ";
			SQL = SQL +  "       a.carr_tdesc, ";
			SQL = SQL +  "       a.ting_tdesc, ";
			SQL = SQL +  "       isnull(b.total_01, 0)                        as total_01, ";
			SQL = SQL +  "       isnull(b.total_02, 0)                        as total_02, ";
			SQL = SQL +  "       isnull(b.total_03, 0)                        as total_03, ";
			SQL = SQL +  "       isnull(b.total_04, 0)                        as total_04, ";
			SQL = SQL +  "       isnull(b.total_05, 0)                        as total_05, ";
			SQL = SQL +  "       isnull(b.total_06, 0)                        as total_06, ";
			SQL = SQL +  "       isnull(b.total_07, 0)                        as total_07, ";
			SQL = SQL +  "       isnull(b.total_08, 0)                        as total_08, ";
			SQL = SQL +  "       isnull(b.total_09, 0)                        as total_09, ";
			SQL = SQL +  "       isnull(b.total_10, 0)                        as total_10, ";
			SQL = SQL +  "       isnull(b.total_11, 0)                        as total_11, ";
			SQL = SQL +  "       isnull(b.total_12, 0)                        as total_12, ";
			SQL = SQL +  "       isnull(b.total, 0)                           as total ";
			SQL = SQL +  "from   (select a.tipo, ";
			SQL = SQL +  "               a.carr_ccod, ";
			SQL = SQL +  "               a.carr_tdesc, ";
			SQL = SQL +  "               b.ting_ccod, ";
			SQL = SQL +  "               b.ting_tdesc ";
			SQL = SQL +  "        from   (select distinct 0 as tipo, ";
			SQL = SQL +  "                                c.carr_ccod, ";
			SQL = SQL +  "                                c.carr_tdesc ";
			SQL = SQL +  "                from   ofertas_academicas as a ";
			SQL = SQL +  "                       inner join especialidades as b ";
			SQL = SQL +  "                               on a.espe_ccod = b.espe_ccod ";
			SQL = SQL +  "                       inner join carreras as c ";
			SQL = SQL +  "                               on b.carr_ccod = c.carr_ccod ";
			SQL = SQL +  "                where  a.sede_ccod = '" + p_sede_ccod + "' ";
			SQL = SQL +  "                union ";
			SQL = SQL +  "                select 1                    as tipo, ";
			SQL = SQL +  "                       'TT'                 as carr_ccod, ";
			SQL = SQL +  "                       'TODAS LAS CARRERAS' as carr_tdesc) as a ";
			SQL = SQL +  "               inner join tipos_ingresos as b ";
			SQL = SQL +  "                       on b.ting_ccod in ( 20, 25, 40, 43 )) as a ";
			SQL = SQL +  "       left outer join (select case grouping(h.carr_ccod) ";
			SQL = SQL +  "                                 when 1 then 'TT' ";
			SQL = SQL +  "                                 else h.carr_ccod ";
			SQL = SQL +  "                               end                as carr_ccod, ";
			SQL = SQL +  "                               f.ting_ccod, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '01' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_01, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '02' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_02, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '03' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_03, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '04' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_04, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '05' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_05, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '06' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_06, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '07' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_07, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '08' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_08, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '09' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_09, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '10' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_10, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '11' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_11, ";
			SQL = SQL +  "                               sum(case ";
			SQL = SQL +  "                                     when datepart(month, a.ingr_fpago) = '12' then a.ingr_mtotal ";
			SQL = SQL +  "                                     else 0 ";
			SQL = SQL +  "                                   end)           as total_12, ";
			SQL = SQL +  "                               sum(a.ingr_mtotal) as total ";
			SQL = SQL +  "                        from   ingresos as a ";
			SQL = SQL +  "                               inner join detalle_ingresos as b ";
			SQL = SQL +  "                                       on a.ingr_ncorr = b.ingr_ncorr ";
			SQL = SQL +  "                                          and b.ting_ccod in ( 20, 25, 40, 43 ) ";
			SQL = SQL +  "                               inner join tipos_ingresos as f ";
			SQL = SQL +  "                                       on b.ting_ccod = f.ting_ccod ";
			SQL = SQL +  "                               inner join movimientos_cajas as c ";
			SQL = SQL +  "                                       on a.mcaj_ncorr = c.mcaj_ncorr ";
			SQL = SQL +  "                               inner join alumnos as d ";
			SQL = SQL +  "                                       on a.pers_ncorr = d.pers_ncorr ";
			SQL = SQL +  "                                          and d.emat_ccod <> 9 ";
			SQL = SQL +  "                               inner join ofertas_academicas as e "; 
			SQL = SQL +  "                                       on d.ofer_ncorr = e.ofer_ncorr ";
			SQL = SQL +  "                                          and e.peri_ccod = protic.ultimo_periodo_matriculado(a.pers_ncorr) ";
			SQL = SQL +  "                                          and e.sede_ccod = '" + p_sede_ccod + "' ";
			SQL = SQL +  "                               inner join especialidades as g ";
			SQL = SQL +  "                                       on e.espe_ccod = g.espe_ccod ";
			SQL = SQL +  "                               inner join carreras as h ";
			SQL = SQL +  "                                       on g.carr_ccod = h.carr_ccod ";
			SQL = SQL +  "                        where  a.eing_ccod = 1 ";
			SQL = SQL +  "                               and a.ting_ccod = 17 ";
			SQL = SQL +  "                               and datepart(year, a.ingr_fpago) = '" + p_anos_ccod + "' ";
			SQL = SQL +  "                        group  by f.ting_ccod, ";
			SQL = SQL +  "                                  h.carr_ccod with rollup) as b ";
			SQL = SQL +  "                    on a.ting_ccod = b.ting_ccod ";
			SQL = SQL +  "                       and a.carr_ccod = b.carr_ccod ";
			SQL = SQL +  "order  by orden asc, ";
			SQL = SQL +  "          a.ting_tdesc ";
			return SQL;
		}

		private string ObtenerSqlEncabezado(string p_anos_ccod, string p_sede_ccod)
		{
			return "select '" + p_anos_ccod + "' as anos_ccod, sede_tdesc from sedes where sede_ccod = '"  +p_sede_ccod + "'";
		}
	

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string q_sede_ccod = Request["filtros[0][sede_ccod]"];
			string q_anos_ccod = Request["filtros[0][anos_ccod]"];
			string q_peri_ccod = Request["filtros[0][peri_ccod]"];
			string q_formato = Request["filtros[0][formato]"];
			crRetirosCondonaciones rep = new crRetirosCondonaciones();


			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_anos_ccod, q_sede_ccod);
			adpDetalles.Fill(ds);

			adpEncabezado.SelectCommand.CommandText = ObtenerSqlEncabezado(q_anos_ccod, q_sede_ccod);			
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
			this.ds = new retiros_condonaciones.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "DETALLES", new System.Data.Common.DataColumnMapping[] {
																																																			  new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																			  new System.Data.Common.DataColumnMapping("TING_TDESC", "TING_TDESC"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_01", "TOTAL_01"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_02", "TOTAL_02"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_03", "TOTAL_03"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_04", "TOTAL_04"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_05", "TOTAL_05"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_06", "TOTAL_06"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_07", "TOTAL_07"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_08", "TOTAL_08"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_09", "TOTAL_09"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_10", "TOTAL_10"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_11", "TOTAL_11"),
																																																			  new System.Data.Common.DataColumnMapping("TOTAL_12", "TOTAL_12")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS CARR_TDESC, \'\' AS TING_TDESC, 0 AS TOTAL_01, 0 AS TOTAL_02, 0 AS TOT" +
				"AL_03, 0 AS TOTAL_04, 0 AS TOTAL_05, 0 AS TOTAL_06, 0 AS TOTAL_07, 0 AS TOTAL_08" +
				", 0 AS TOTAL_09, 0 AS TOTAL_10, 0 AS TOTAL_11, 0 AS TOTAL_12 FROM DUAL";
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
																									new System.Data.Common.DataTableMapping("Table", "ENCABEZADO", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("ANOS_CCOD", "ANOS_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT 0 AS ANOS_CCOD, \'\' AS SEDE_TDESC FROM DUAL";
			this.oleDbSelectCommand2.Connection = this.conexion;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
