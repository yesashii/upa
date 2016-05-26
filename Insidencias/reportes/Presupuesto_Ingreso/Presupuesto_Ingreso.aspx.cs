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

namespace Presupuesto_Ingreso
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected Presupuesto_Ingreso.PresupuestoIngreso presupuestoIngreso1;
	
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
			
			Response.AddHeader ("Content-Disposition", "attachment;filename=presupuesto_ingreso.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		private string EscribirCodigo_Ant(string periodo, string fecha_inicio, 
										string fecha_termino, string sede, string porc_morosidad)
		{
			string sql;
		    
			
			sql =  " select " + porc_morosidad + " as p_morosidad, z.PERI_TDESC  periodo, '"+fecha_inicio+"' fecha_inicio, '"+fecha_termino+"' fecha_termino,\n";
			sql = sql + " z.CARR_TDESC,z.CARR_CCOD,z.SEDE_TDESC, round(nvl(total_matr_doc,0) + nvl(total_matr_efectivo,0)) as TOTAL_MATRICULA,   \n";
			sql = sql + " round(nvl(total_col_doc,0) + nvl(total_col_efectivo,0)) as TOTAL_COLEGIATURA,  \n";
			sql = sql + " round((nvl(total_matr_doc,0) + nvl(total_matr_efectivo,0) + nvl(total_col_doc,0) + nvl(total_col_efectivo,0))*("+porc_morosidad+"/100)) morosidad, \n";
			sql = sql + " round((nvl(total_matr_doc,0) + nvl(total_matr_efectivo,0) + nvl(total_col_doc,0) + nvl(total_col_efectivo,0))- \n";
			sql = sql + " (nvl(total_matr_doc,0) + nvl(total_matr_efectivo,0)+nvl(total_col_doc,0) + nvl(total_col_efectivo,0))*("+porc_morosidad+"/100)) estimacion \n";
			sql = sql + " from  \n";
			sql = sql + "  (  \n";


			if (sede != "") 
			{
				sql = sql + "   select distinct car.CARR_TDESC,car.CARR_CCOD,ss.SEDE_TDESC,pa.PERI_TDESC     \n";
				sql = sql + "   from ofertas_academicas oo , especialidades ee, carreras car, sedes ss, periodos_academicos pa   \n";
				sql = sql + "   where oo.PERI_CCOD="+periodo;
				sql = sql + "   						and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)    \n";
				sql = sql + "   						and oo.ESPE_CCOD=ee.ESPE_CCOD    \n";
				sql = sql + "   						and ee.CARR_CCOD=car.CARR_CCOD    \n";
				sql = sql + "   						and ss.SEDE_CCOD= oo.SEDE_CCOD     \n";
				sql = sql + "   						and oo.PERI_CCOD=pa.PERI_CCOD    \n";

			}
			else 
			{
				sql = sql + "     select distinct car.CARR_TDESC,car.CARR_CCOD,'TODAS' SEDE_TDESC,pa.PERI_TDESC    ";
				sql = sql + "     from ofertas_academicas oo , especialidades ee, carreras car,periodos_academicos pa      ";
				sql = sql + "     where oo.PERI_CCOD="+periodo;
				sql = sql + "     						and oo.SEDE_CCOD=nvl('',oo.SEDE_CCOD)      ";
				sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      ";
				sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD      ";
				sql = sql + "   						and oo.PERI_CCOD=pa.PERI_CCOD    \n";
			}



			sql = sql + "  ) z,  \n";
			sql = sql + " ( \n";
			sql = sql + " select CARR_TDESC,CARR_CCOD,    \n";
			sql = sql + "   		sum(MATRICULA) total_matr_doc,    \n";
			sql = sql + "   		sum(COLEGIATURA) total_col_doc    \n";
			sql = sql + "   		from (    \n";
			sql = sql + "   			   select CASE WHEN (a.TCOM_CCOD=1) THEN a.valor_efectivo end MATRICULA,    \n";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2) THEN a.valor_efectivo end COLEGIATURA,    \n";
			sql = sql + "   					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD    \n";
			sql = sql + "   			   from (    \n";
			sql = sql + "   			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,     \n";
			sql = sql + "   					  aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD    \n";
			sql = sql + "   						from alumnos aa, contratos cc, compromisos com,     \n";
			sql = sql + "   						detalle_compromisos dc, abonos ab,    \n";
			sql = sql + "   						ingresos ii,detalle_ingresos dii,    \n";
			sql = sql + "   						ofertas_academicas oo , especialidades ee, carreras car    \n";
			sql = sql + "   						where aa.emat_ccod<>9    \n";
			sql = sql + "   						and cc.CONT_NCORR=com.COMP_NDOCTO    \n";
			sql = sql + "   						and com.TCOM_CCOD=dc.TCOM_CCOD    \n";
			sql = sql + "   						and com.INST_CCOD=dc.INST_CCOD    \n";
			sql = sql + "   						and oo.PERI_CCOD="+periodo;
			sql = sql + "   						and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)    \n";
			sql = sql + "   						and aa.OFER_NCORR=oo.OFER_NCORR    \n";
			sql = sql + "   						and oo.ESPE_CCOD=ee.ESPE_CCOD    \n";
			sql = sql + "   						and ee.CARR_CCOD=car.CARR_CCOD    \n";
			sql = sql + "   						and cc.ECON_CCOD=1    \n";
			sql = sql + "   						and aa.MATR_NCORR=cc.MATR_NCORR    \n";
			sql = sql + "   						and com.ECOM_CCOD=1    \n";
			sql = sql + "   						and com.COMP_NDOCTO=dc.COMP_NDOCTO    \n";
			sql = sql + "   						and dc.TCOM_CCOD=ab.TCOM_CCOD    \n";
			sql = sql + "   						and dc.INST_CCOD=ab.INST_CCOD    \n";
			sql = sql + "   						and dc.COMP_NDOCTO=ab.COMP_NDOCTO    \n";
			sql = sql + "   						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO    \n";
			sql = sql + "   						and ii.EING_CCOD=4	    \n";
			sql = sql + "   						and ii.INGR_MEFECTIVO=0    \n";
			sql = sql + "   						and ab.INGR_NCORR=ii.INGR_NCORR    \n";
			sql = sql + "   						and ii.INGR_NCORR=dii.INGR_NCORR    \n";
			sql = sql + "   						and dii.DING_NCORRELATIVO=1    \n";
			sql = sql + "   						and dii.DING_BPACTA_CUOTA='S'    \n";
			sql = sql + "   						and trunc(dii.DING_FDOCTO) between nvl(to_date('"+fecha_inicio+"','DD/MM/YYYY'),dii.DING_FDOCTO)    \n";
			sql = sql + "   						and nvl(to_date('"+fecha_termino+"','DD/MM/YYYY'),dii.DING_FDOCTO)    \n";
			sql = sql + "   						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD    \n";
			sql = sql + "   						) a     \n";
			sql = sql + "   					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD     \n";
			sql = sql + "   					)     \n";
			sql = sql + "   					group by CARR_CCOD,CARR_TDESC \n";
			sql = sql + " )a,					  \n";
			sql = sql + " (					 \n";
			sql = sql + " select  CARR_TDESC,CARR_CCOD,sum(MATRICULA_EFECTIVO) total_matr_efectivo,sum(COLEGIATURA_EFECTIVO)total_col_efectivo    \n";
			sql = sql + "    from (    \n";
			sql = sql + "   		   select DECODE (a.TCOM_CCOD,1,a.valor_efectivo) MATRICULA_EFECTIVO,    \n";
			sql = sql + "   		   		  DECODE (a.TCOM_CCOD,2,a.valor_efectivo) COLEGIATURA_EFECTIVO,    \n";
			sql = sql + "   		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD    \n";
			sql = sql + "   		    from (    \n";
			sql = sql + "   		   		  select sum(ii.INGR_MEFECTIVO) valor_efectivo,car.CARR_CCOD,    \n";
			sql = sql + "   				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD    \n";
			sql = sql + "   					from alumnos aa, contratos cc, compromisos com,     \n";
			sql = sql + "   					detalle_compromisos dc, abonos ab,    \n";
			sql = sql + "   					ingresos ii,    \n";
			sql = sql + "   					ofertas_academicas oo , especialidades ee, carreras car    \n";
			sql = sql + "   					where aa.emat_ccod<>9    \n";
			sql = sql + "   					and cc.CONT_NCORR=com.COMP_NDOCTO    \n";
			sql = sql + "   					and com.TCOM_CCOD=dc.TCOM_CCOD    \n";
			sql = sql + "   					and com.INST_CCOD=dc.INST_CCOD    \n";
			sql = sql + "   					and oo.PERI_CCOD="+periodo;
			sql = sql + "   					and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)    \n";
			sql = sql + "   					and aa.OFER_NCORR=oo.OFER_NCORR    \n";
			sql = sql + "   					and oo.ESPE_CCOD=ee.ESPE_CCOD    \n";
			sql = sql + "   					and ee.CARR_CCOD=car.CARR_CCOD    \n";
			sql = sql + "   					and cc.ECON_CCOD=1    \n";
			sql = sql + "   					and aa.MATR_NCORR=cc.MATR_NCORR    \n";
			sql = sql + "   					and com.ECOM_CCOD=1    \n";
			sql = sql + "   					and com.COMP_NDOCTO=dc.COMP_NDOCTO    \n";
			sql = sql + "   					and dc.TCOM_CCOD=ab.TCOM_CCOD    \n";
			sql = sql + "   					and dc.INST_CCOD=ab.INST_CCOD    \n";
			sql = sql + "   					and dc.COMP_NDOCTO=ab.COMP_NDOCTO    \n";
			sql = sql + "   					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO    \n";
			sql = sql + "   					and trunc(dc.DCOM_FCOMPROMISO) between nvl(to_date('"+fecha_inicio+"','DD/MM/YYYY'),dc.DCOM_FCOMPROMISO)     \n";
			sql = sql + "   					and nvl(to_date('"+fecha_termino+"','DD/MM/YYYY'),dc.DCOM_FCOMPROMISO)    \n";
			sql = sql + "   					and ii.EING_CCOD=1			    \n";
			sql = sql + "   					and ii.INGR_MEFECTIVO <>0    \n";
			sql = sql + "   					and ab.INGR_NCORR=ii.INGR_NCORR    \n";
			sql = sql + "   					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD    \n";
			sql = sql + "   					) a     \n";
			sql = sql + "   				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD     \n";
			sql = sql + "   				)     \n";
			sql = sql + "   				group by CARR_CCOD,CARR_TDESC					  \n";
			sql = sql + " ) b \n";
			sql = sql + " where   \n";
			sql = sql + "   z.CARR_CCOD=a.CARR_CCOD (+)  \n";
			sql = sql + "   and z.CARR_CCOD=b.CARR_CCOD  (+)  \n";
			sql = sql + "	order by z.CARR_TDESC\n";

			return (sql);		
		}

/*
		private string EscribirCodigo(string periodo, string fecha_inicio, string fecha_termino, string sede, string porc_morosidad) {
			string SQL;

			SQL = " select " + porc_morosidad + " as p_morosidad, a.peri_tdesc as periodo, '" + fecha_inicio + "' as fecha_inicio, '" + fecha_termino + "' as fecha_termino, \n";
			SQL = SQL +  "        a.carr_tdesc, a.carr_ccod, a.sede_tdesc, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) as total_matricula, \n";
			SQL = SQL +  " 	   isnull(b.total_colegiatura, 0) as total_colegiatura, \n";
			SQL = SQL +  " 	   round((isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0)) * (" + porc_morosidad + " / 100),2) as morosidad,    \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0) -  round((isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0)) * (" + porc_morosidad + " / 100),2) as estimacion       \n";
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
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_colegiatura	\n";
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
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  *= c.ingr_ncorr  \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')   *= c.ting_ccod  \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto  \n";
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
			SQL = SQL +  " 	) b \n";
			SQL = SQL +  " where a.carr_ccod *= b.carr_ccod \n";
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
		ACTUALIZADO POR	:JAIME PAINEMAL A.
		MOTIVO			:Corregir código; eliminar sentencia *=
		LINEA			: 38 - 65,66,67
		********************************************************************/

		private string EscribirCodigo(string periodo, string fecha_inicio, string fecha_termino, string sede, string porc_morosidad) 
		{
			string SQL;

			SQL = " select " + porc_morosidad + " as p_morosidad, a.peri_tdesc as periodo, '" + fecha_inicio + "' as fecha_inicio, '" + fecha_termino + "' as fecha_termino, \n";
			SQL = SQL +  "        a.carr_tdesc, a.carr_ccod, a.sede_tdesc, \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) as total_matricula, \n";
			SQL = SQL +  " 	   isnull(b.total_colegiatura, 0) as total_colegiatura, \n";
			SQL = SQL +  " 	   round((isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0)) * (" + porc_morosidad + " / 100),2) as morosidad,    \n";
			SQL = SQL +  " 	   isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0) -  round((isnull(b.total_matricula, 0) + isnull(b.total_colegiatura, 0)) * (" + porc_morosidad + " / 100),2) as estimacion       \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct b.peri_tdesc, d.carr_tdesc, d.carr_ccod, e.sede_tdesc  \n";
			SQL = SQL +  " 		from ofertas_academicas a \n";
			SQL = SQL +  " 		INNER JOIN periodos_academicos b \n";
			SQL = SQL +  " 		ON a.peri_ccod = b.peri_ccod and a.sede_ccod =  '" + sede + "'  and a.peri_ccod = '" + periodo + "'  \n";
			SQL = SQL +  " 		INNER JOIN  especialidades c \n";
			SQL = SQL +  " 		ON a.espe_ccod = c.espe_ccod \n";
			SQL = SQL +  " 		INNER JOIN carreras d \n";
			SQL = SQL +  " 		ON c.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  " 		INNER JOIN sedes e \n";
			SQL = SQL +  " 		ON a.sede_ccod = e.sede_ccod \n";
			SQL = SQL +  " 	 ) a \n";
			SQL = SQL +  " 		LEFT OUTER JOIN  \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select i.carr_ccod,         	    \n";
			SQL = SQL +  " 		 	   sum(case when a.tcom_ccod_origen = 1 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_matricula, \n";
			SQL = SQL +  " 			   sum(case when a.tcom_ccod_origen = 2 then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as total_colegiatura	\n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a \n";
			SQL = SQL +  "				INNER JOIN detalles b \n";
			SQL = SQL +  "				ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "				and a.tcom_ccod in (1, 2) and a.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle c \n";
			SQL = SQL +  "				ON b.tdet_ccod = c.tdet_ccod and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  "				union all \n";
			SQL = SQL +  "				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  "				from repactaciones a \n";
			SQL = SQL +  "				INNER JOIN compromisos b \n";
			SQL = SQL +  "				ON a.repa_ncorr = b.comp_ndocto and a.tcom_ccod_origen in (1, 2) and b.tcom_ccod = 3 and b.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN detalles c \n";
			SQL = SQL +  "				ON a.tcom_ccod_origen = c.tcom_ccod and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle d \n";
			SQL = SQL +  "				ON c.tdet_ccod = d.tdet_ccod and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  "		     ) a \n";
			SQL = SQL +  "		INNER JOIN detalle_compromisos b \n";
			SQL = SQL +  "		ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "		and b.tcom_ccod in (1, 2, 3) and b.dcom_fcompromiso between '" + fecha_inicio + "' and '" + fecha_termino + "' \n";
			SQL = SQL +  "		LEFT OUTER JOIN detalle_ingresos c  \n";
			SQL = SQL +  "		ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr  \n";
			SQL = SQL +  "		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')  = c.ting_ccod  \n";
			SQL = SQL +  "		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')= c.ding_ndocto  \n";
			SQL = SQL +  "		INNER JOIN contratos e \n";
			SQL = SQL +  "		ON a.comp_ndocto_origen = e.cont_ncorr and e.econ_ccod = 1 \n";
			SQL = SQL +  "		INNER JOIN alumnos f \n";
			SQL = SQL +  "		ON e.matr_ncorr = f.matr_ncorr and f.emat_ccod <> 9 \n";
			SQL = SQL +  "		INNER JOIN ofertas_academicas g \n";
			SQL = SQL +  "		ON f.ofer_ncorr = g.ofer_ncorr \n";
			SQL = SQL +  "		INNER JOIN especialidades h \n";
			SQL = SQL +  "		ON g.espe_ccod = h.espe_ccod and g.peri_ccod = '" + periodo + "' and g.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  "		INNER JOIN carreras i \n";
			SQL = SQL +  "		ON h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  "		group by i.carr_ccod \n";
			SQL = SQL +  "	) b \n";
			SQL = SQL +  "ON a.carr_ccod = b.carr_ccod \n";
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
			string fecha_inicio;
			string fecha_termino;
			string sede;
			string porc_morosidad;
			string tipo_informe;
			//int fila = 0;	
			periodo = Request.QueryString["periodo"];
			sede = Request.QueryString["sede"];
			fecha_inicio=Request.QueryString["fecha_inicio"];
			fecha_termino=Request.QueryString["fecha_termino"];
			porc_morosidad = Request.QueryString["morosidad"];
			tipo_informe = Request.QueryString["tipo_informe"];
			
			sql = EscribirCodigo(periodo,fecha_inicio, fecha_termino,sede,porc_morosidad);

			//Response.Write("<pre>"+sql+"</pre>");
			//Response.End();

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(presupuestoIngreso1);
					
			//}
			
			//Response.End();
			
			CrystalReport1 reporte = new CrystalReport1();
			
				
			reporte.SetDataSource(presupuestoIngreso1);
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
			this.presupuestoIngreso1 = new Presupuesto_Ingreso.PresupuestoIngreso();
			((System.ComponentModel.ISupportInitialize)(this.presupuestoIngreso1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "total_matricula", new System.Data.Common.DataColumnMapping[] {
																																																						   new System.Data.Common.DataColumnMapping("P_MOROSIDAD", "P_MOROSIDAD"),
																																																						   new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																						   new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																						   new System.Data.Common.DataColumnMapping("TOTAL_MATRICULA", "TOTAL_MATRICULA"),
																																																						   new System.Data.Common.DataColumnMapping("TOTAL_COLEGIATURA", "TOTAL_COLEGIATURA"),
																																																						   new System.Data.Common.DataColumnMapping("MOROSIDAD", "MOROSIDAD"),
																																																						   new System.Data.Common.DataColumnMapping("ESTIMACION", "ESTIMACION"),
																																																						   new System.Data.Common.DataColumnMapping("PERIODO", "PERIODO"),
																																																						   new System.Data.Common.DataColumnMapping("FECHA_INICIO", "FECHA_INICIO"),
																																																						   new System.Data.Common.DataColumnMapping("FECHA_TERMINO", "FECHA_TERMINO"),
																																																						   new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS P_MOROSIDAD, \'\' AS CARR_TDESC, \'\' AS CARR_CCOD, \'\' AS TOTAL_MATRICUL" +
				"A, \'\' AS TOTAL_COLEGIATURA, \'\' AS MOROSIDAD, \'\' AS ESTIMACION, \'\' AS PERIODO, \'\'" +
				" AS FECHA_INICIO, \'\' AS FECHA_TERMINO, \'\' AS SEDE_TDESC FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// presupuestoIngreso1
			// 
			this.presupuestoIngreso1.DataSetName = "PresupuestoIngreso";
			this.presupuestoIngreso1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.presupuestoIngreso1.Namespace = "http://www.tempuri.org/PresupuestoIngreso.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.presupuestoIngreso1)).EndInit();

		}
		#endregion
	}
}
