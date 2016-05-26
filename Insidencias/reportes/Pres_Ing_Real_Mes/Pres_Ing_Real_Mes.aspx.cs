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

namespace Pres_Ing_Real_Mes
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
		protected Pres_Ing_Real_Mes.datos datos1;
	
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=pres_ing_real_mes.xls");
            Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}
		private string EscribirCodigo_Antiguo(int i, int mes_i, int mes_f, string periodo,string sede,string ano)
		{
			string sql;
		    
			// FECHA DE LO REAL -> SI ES LO QUE SE PAGO EFECTIVAMENTE ESE MES (FECHA INGRESO)
			

			sql = " select "+ i +" as nro_informe, z.CARR_TDESC,z.CARR_CCOD,z.SEDE_TDESC,'"+ano+"' ano,   ";

			sql =  sql + " z.PERI_TDESC  periodo, '' fecha_inicio, '' fecha_termino,\n";
			
			sql = sql + "   round(nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)+nvl(matr_comp_saldo_01,0)) as MATR_COMPR_01,  ";
			sql = sql + "   round(nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)+nvl(matr_comp_saldo_02,0)) as MATR_COMPR_02,  ";
			sql = sql + "   round(nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)+nvl(matr_comp_saldo_03,0)) as MATR_COMPR_03,   ";
			sql = sql + "   round(nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)+nvl(matr_comp_saldo_04,0)) as MATR_COMPR_04,  ";
			sql = sql + "   round(nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)+nvl(matr_comp_saldo_05,0)) as MATR_COMPR_05,   ";
			sql = sql + "   round(nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)+nvl(matr_comp_saldo_06,0)) as MATR_COMPR_06,   ";
			sql = sql + " round(nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)+nvl(col_comp_saldo_01,0)) as col_COMPR_01,   ";
			sql = sql + "   round(nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)+nvl(col_comp_saldo_02,0)) as col_COMPR_02,   ";
			sql = sql + "    round(nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)+nvl(col_comp_saldo_03,0)) as col_COMPR_03,   ";
			sql = sql + "   round(nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)+nvl(col_comp_saldo_04,0)) as col_COMPR_04,   ";
			sql = sql + "   round(nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)+nvl(col_comp_saldo_05,0)) as col_COMPR_05,  ";
			sql = sql + "   round(nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)+nvl(col_comp_saldo_06,0)) as col_COMPR_06,  ";
			sql = sql + " round(nvl(matr_real_01,0)) as MATR_realR_01,  ";
			sql = sql + "   round(nvl(matr_real_02,0)) as MATR_realR_02,  ";
			sql = sql + "   round(nvl(matr_real_03,0)) as MATR_realR_03,   ";
			sql = sql + "   round(nvl(matr_real_04,0)) as MATR_realR_04,  ";
			sql = sql + "   round(nvl(matr_real_05,0)) as MATR_realR_05,  ";
			sql = sql + "   round(nvl(matr_real_06,0)) as MATR_realR_06,  ";
			sql = sql + " round(nvl(col_real_01,0)) as col_realR_01,  ";
			sql = sql + "   round(nvl(col_real_02,0)) as col_realR_02,  ";
			sql = sql + "   round(nvl(col_real_03,0)) as col_realR_03,   ";
			sql = sql + "   round(nvl(col_real_04,0)) as col_realR_04,  ";
			sql = sql + "   round(nvl(col_real_05,0)) as col_realR_05,  ";
			sql = sql + "   round(nvl(col_real_06,0)) as col_realR_06,  ";
			sql = sql + " ((nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)+nvl(matr_comp_saldo_01,0))- nvl(matr_real_01,0)) SALDO_01,    "; 
			sql = sql + " ( (nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)+nvl(matr_comp_saldo_02,0))- nvl(matr_real_02,0)) SALDO_02,    "; 
			sql = sql + " ((nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)+nvl(matr_comp_saldo_03,0))- nvl(matr_real_03,0)) SALDO_03,     ";
			sql = sql + " ((nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)+nvl(matr_comp_saldo_04,0))- nvl(matr_real_04,0)) SALDO_04,     ";
			sql = sql + " ((nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)+nvl(matr_comp_saldo_05,0))- nvl(matr_real_05,0)) SALDO_05,     ";
			sql = sql + " ((nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)+nvl(matr_comp_saldo_06,0))- nvl(matr_real_06,0)) SALDO_06,     ";
			sql = sql + " ((nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)+nvl(col_comp_saldo_01,0))- nvl(col_real_01,0)) SALDO_07,     ";
			sql = sql + " ((nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)+nvl(col_comp_saldo_02,0))- nvl(col_real_02,0)) SALDO_08,     ";
			sql = sql + " ((nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)+nvl(col_comp_saldo_03,0))- nvl(col_real_03,0)) SALDO_09,     ";
			sql = sql + " ((nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)+nvl(col_comp_saldo_04,0))- nvl(col_real_04,0)) SALDO_10,     ";
			sql = sql + " ((nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)+nvl(col_comp_saldo_05,0))- nvl(col_real_05,0)) SALDO_11,     ";
			sql = sql + " ((nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)+nvl(col_comp_saldo_06,0))- nvl(col_real_06,0)) SALDO_12  ";
			
			sql = sql + "  from    ";
			sql = sql + "    (    ";

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


			sql = sql + "    ) z,    ";
			sql = sql + "   (   ";
			

			sql = sql + "  select CARR_TDESC,CARR_CCOD,       ";
			sql = sql + "      	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_01,    ";
			sql = sql + "   		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_02,      ";
			sql = sql + "   		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_03,    ";
			sql = sql + "   		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_04,     ";
			sql = sql + "   		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_05,    ";
			sql = sql + "   		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_06,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_01,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_02,      ";
			sql = sql + "   		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_03,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_04,     ";
			sql = sql + "   		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_05,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_06    ";
			sql = sql + "   		from (      ";
			sql = sql + " 			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,        ";
			sql = sql + "      					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD      ";
			sql = sql + "      			   from (  ";
			sql = sql + " 				   		select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,        ";
			sql = sql + "      					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes    ";
			sql = sql + "      						from alumnos aa, contratos cc, compromisos com,        ";
			sql = sql + "      						detalle_compromisos dc,    ";
			sql = sql + "      						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii     ";
			sql = sql + " 							where aa.emat_ccod<>9       ";
			sql = sql + "      						and cc.CONT_NCORR=com.comp_ndocto  ";
			sql = sql + "      						and com.TCOM_CCOD=dc.TCOM_CCOD       ";
			sql = sql + "      						and com.INST_CCOD=dc.INST_CCOD       ";
			sql = sql + "      						and oo.PERI_CCOD="+periodo;
			sql = sql + "      						and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)       ";
			sql = sql + "      						and aa.OFER_NCORR=oo.OFER_NCORR       ";
			sql = sql + "      						and oo.ESPE_CCOD=ee.ESPE_CCOD       ";
			sql = sql + "      						and ee.CARR_CCOD=car.CARR_CCOD       ";
			sql = sql + "      						and cc.ECON_CCOD=1       ";
			sql = sql + "      						and aa.MATR_NCORR=cc.MATR_NCORR       ";
			sql = sql + "      						and com.ECOM_CCOD=1       ";
			sql = sql + "      						and com.COMP_NDOCTO=dc.COMP_NDOCTO    ";
			sql = sql + " 							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)     ";
			sql = sql + " 	     					and dc.INST_CCOD=ab.INST_CCOD   (+)      ";
			sql = sql + " 	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)        ";
			sql = sql + " 	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)      ";
			sql = sql + " 	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)        ";
			sql = sql + " 							and ii.TING_CCOD =tii.TING_CCOD	(+)   ";
			sql = sql + " 							and ii.INGR_NCORR  =dii.INGR_NCORR (+)   ";
			sql = sql + " 							and  nvl(dii.EDIN_CCOD,0)<>11   ";
			sql = sql + " 							and nvl(tii.TING_BREBAJE,'N') <> 'S'     ";
			sql = sql + "      						and dc.ECOM_CCOD=1   ";
			sql = sql + "  							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = "+ano;

			sql = sql + " 							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')    ";
			sql = sql + "  						) a        ";
			sql = sql + "      					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes   ";
			sql = sql + " 						HAVING a.mes between "+mes_i+" and "+mes_f;
			sql = sql + "      					)        ";
			sql = sql + "      					group by CARR_CCOD,CARR_TDESC   ";
			sql = sql + " )a,	 ";
			sql = sql + "   ( ";

			//sql = sql + "   ------------------------------COMPROMISOS REPACTACIONES--------------------------------------------- ";
			
			sql = sql + "   select CARR_TDESC,CARR_CCOD,       ";
			sql = sql + "      	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_repa_01,    ";
			sql = sql + "   		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_repa_02,      ";
			sql = sql + "   		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_repa_03,    ";
			sql = sql + "   		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_repa_04,     ";
			sql = sql + "   		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_repa_05,    ";
			sql = sql + "   		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_repa_06,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_repa_01,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_repa_02,      ";
			sql = sql + "   		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_repa_03,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_repa_04,     ";
			sql = sql + "   		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_repa_05,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_repa_06    ";
			sql = sql + "   		from (   ";
			sql = sql + " 		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,        ";
			sql = sql + "      					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD      ";
			sql = sql + "      			   from (  ";
			sql = sql + " 				      select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,        ";
			sql = sql + "      					  aa.PERS_NCORR, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes, ";
			sql = sql + " 						    compromiso_origen_repactacion(com.COMP_NDOCTO, 'tcom_ccod') TCOM_CCOD ";
			sql = sql + "      						from alumnos aa, contratos cc, compromisos com,        ";
			sql = sql + "      						detalle_compromisos dc,    ";
			sql = sql + "      						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii     ";
			sql = sql + " 							where aa.emat_ccod<>9       ";
			sql = sql + "      						and cc.CONT_NCORR in (select comp_ndocto_origen  from repactaciones  ";
			sql = sql + " 											  	 		 where repa_ncorr = com.COMP_NDOCTO) ";
			sql = sql + " 							and com.tcom_ccod=3 ";
			sql = sql + "      						and com.TCOM_CCOD=dc.TCOM_CCOD       ";
			sql = sql + "      						and com.INST_CCOD=dc.INST_CCOD       ";
			sql = sql + "      						and oo.PERI_CCOD="+periodo;
			sql = sql + "      						and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)       ";
			sql = sql + "      						and aa.OFER_NCORR=oo.OFER_NCORR       ";
			sql = sql + "      						and oo.ESPE_CCOD=ee.ESPE_CCOD       ";
			sql = sql + "      						and ee.CARR_CCOD=car.CARR_CCOD       ";
			sql = sql + "      						and cc.ECON_CCOD=1       ";
			sql = sql + "      						and aa.MATR_NCORR=cc.MATR_NCORR       ";
			sql = sql + "      						and com.ECOM_CCOD=1       ";
			sql = sql + "      						and com.COMP_NDOCTO=dc.COMP_NDOCTO    ";
			sql = sql + " 							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)     ";
			sql = sql + " 	     					and dc.INST_CCOD=ab.INST_CCOD   (+)      ";
			sql = sql + " 	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)        ";
			sql = sql + " 	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)      ";
			sql = sql + " 	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)        ";
			sql = sql + " 							and ii.TING_CCOD =tii.TING_CCOD	(+)   ";
			sql = sql + " 							and ii.INGR_NCORR   =dii.INGR_NCORR (+)   ";
			sql = sql + " 							and  nvl(dii.EDIN_CCOD,0)<>11   ";
			sql = sql + " 							and nvl(tii.TING_BREBAJE,'N') <> 'S'     ";
			sql = sql + "      						and dc.ECOM_CCOD=1   ";
			sql = sql + "  							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = "+ano;
			sql = sql + " 							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR, ";
			sql = sql + " 							com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM'),com.COMP_NDOCTO  ";
			sql = sql + " 						) a        ";
			sql = sql + "      					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes   ";
			sql = sql + " 						HAVING a.mes between "+mes_i+" and "+mes_f;
			sql = sql + " 						)        ";
			sql = sql + "      					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " )c,	 ";
			sql = sql + " ( ";

			//sql = sql + " --REPACTACIONES Y ABONOS PARCIALES lo qe se abona genera un compromiso ficticio para que cuadre posteriormente------ ";
			
			sql = sql + " select CARR_TDESC,CARR_CCOD,       ";
			sql = sql + "      	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_saldo_01,    ";
			sql = sql + "   		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_saldo_02,      ";
			sql = sql + "   		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_saldo_03,    ";
			sql = sql + "   		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_saldo_04,     ";
			sql = sql + "   		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_saldo_05,    ";
			sql = sql + "   		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_saldo_06,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_saldo_01,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_saldo_02,      ";
			sql = sql + "   		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_saldo_03,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_saldo_04,     ";
			sql = sql + "   		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_saldo_05,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_saldo_06    ";
			sql = sql + "   		from (      ";
			sql = sql + " 			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,        ";
			sql = sql + "      					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD      ";
			sql = sql + "      			   from (  ";
			sql = sql + " 				   select sum(nvl(dc.DCOM_MCOMPROMISO,0)- nvl(iin.ingr_mtotal,0)) valor_efectivo, ";
			sql = sql + " 					 car.CARR_CCOD, car.CARR_TDESC,        ";
			sql = sql + "      					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes    ";
			sql = sql + "      						from alumnos aa, contratos cc, compromisos com,        ";
			sql = sql + "      						detalle_compromisos dc,    ";
			sql = sql + "      						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii, ";
			sql = sql + " 							ingresos iin, abonos abn     ";
			sql = sql + " 							where aa.emat_ccod<>9       ";
			sql = sql + "      						and cc.CONT_NCORR=com.comp_ndocto  ";
			sql = sql + "      						and oo.PERI_CCOD="+periodo;
			sql = sql + "      						and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)       ";
			sql = sql + "      						and aa.OFER_NCORR=oo.OFER_NCORR       ";
			sql = sql + "      						and oo.ESPE_CCOD=ee.ESPE_CCOD       ";
			sql = sql + "      						and ee.CARR_CCOD=car.CARR_CCOD       ";
			sql = sql + "      						and cc.ECON_CCOD=1       ";
			sql = sql + "      						and aa.MATR_NCORR=cc.MATR_NCORR       ";
			sql = sql + "      						and com.ECOM_CCOD=1       ";
			sql = sql + "      						and com.COMP_NDOCTO=dc.COMP_NDOCTO    ";
			sql = sql + " 							and com.TCOM_CCOD=dc.TCOM_CCOD       ";
			sql = sql + "      						and com.INST_CCOD=dc.INST_CCOD  ";
			sql = sql + " 							and dc.TCOM_CCOD=ab.TCOM_CCOD      ";
			sql = sql + " 	     					and dc.INST_CCOD=ab.INST_CCOD       ";
			sql = sql + " 	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO         ";
			sql = sql + " 	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO       ";
			sql = sql + " 	     					and ab.INGR_NCORR =ii.INGR_NCORR        ";
			sql = sql + " 							and ii.TING_CCOD =tii.TING_CCOD	 ";
			sql = sql + " 							and ii.INGR_NCORR  =dii.INGR_NCORR  ";
			sql = sql + " 							and ab.TCOM_CCOD=abn.TCOM_CCOD ";
			sql = sql + " 							and ab.INST_CCOD=abn.INST_CCOD ";
			sql = sql + " 							and ab.COMP_NDOCTO=abn.COMP_NDOCTO ";
			sql = sql + " 							and ab.DCOM_NCOMPROMISO=abn.DCOM_NCOMPROMISO ";
			sql = sql + " 							and abn.INGR_NCORR =iin.INGR_NCORR   ";
			sql = sql + " 							and iin.INGR_NFOLIO_REFERENCIA=dii.REPA_NCORR ";
			sql = sql + " 							and iin.EING_CCOD=5 ";
			sql = sql + " 							and iin.TING_CCOD=9 ";
			sql = sql + " 							and  dii.EDIN_CCOD=11   ";
			sql = sql + " 							and nvl(tii.TING_BREBAJE,'N') <> 'S'     ";
			sql = sql + "      						and dc.ECOM_CCOD=1   ";

			sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = "+ano;

			sql = sql + " 							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')    ";
			sql = sql + "  						) a        ";
			sql = sql + "      					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes   ";
			sql = sql + " 						HAVING a.mes between "+mes_i+" and "+mes_f;
			sql = sql + "      					)        ";
			sql = sql + "      					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " )d,			     ";
			sql = sql + "    (	 ";
			//sql = sql + "   ---------------------------VALORES REALES------------------------------------------------------- 	    ";
			sql = sql + "   select  CARR_TDESC,CARR_CCOD,   ";
			sql = sql + "    		sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_real_01,    ";
			sql = sql + "   		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_real_02,      ";
			sql = sql + "   		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_real_03,    ";
			sql = sql + "   		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_real_04,     ";
			sql = sql + "   		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_real_05,    ";
			sql = sql + "   		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_real_06,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_real_01,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_real_02,      ";
			sql = sql + "   		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_real_03,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_real_04,     ";
			sql = sql + "   		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_real_05,    ";
			sql = sql + "   		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_real_06       ";
			sql = sql + "       from (       ";
			sql = sql + "      		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,    ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,     ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,     ";
			sql = sql + "   			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,   ";
			sql = sql + "   					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,       ";
			sql = sql + "      		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD       ";
			sql = sql + "      		    from (       ";
			sql = sql + " 				    select sum(ii.INGR_MTOTAL) valor_efectivo,car.CARR_CCOD,       ";
			sql = sql + "      				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM') mes        ";
			sql = sql + "      					from alumnos aa, contratos cc, compromisos com,        ";
			sql = sql + "      					detalle_compromisos dc, abonos ab,       ";
			sql = sql + "      					ingresos ii, tipos_ingresos tii,        ";
			sql = sql + "      					ofertas_academicas oo , especialidades ee, carreras car       ";
			sql = sql + "      					where aa.emat_ccod<>9       ";
			sql = sql + "      					and cc.CONT_NCORR=com.COMP_NDOCTO       ";
			sql = sql + "      					and com.TCOM_CCOD=dc.TCOM_CCOD       ";
			sql = sql + "      					and com.INST_CCOD=dc.INST_CCOD       ";
			sql = sql + "      					and oo.PERI_CCOD="+periodo;
			sql = sql + "      					and oo.SEDE_CCOD=nvl('"+sede+"',oo.SEDE_CCOD)       ";
			sql = sql + "      					and aa.OFER_NCORR=oo.OFER_NCORR       ";
			sql = sql + "      					and oo.ESPE_CCOD=ee.ESPE_CCOD       ";
			sql = sql + "      					and ee.CARR_CCOD=car.CARR_CCOD       ";
			sql = sql + "      					and cc.ECON_CCOD=1       ";
			sql = sql + "      					and aa.MATR_NCORR=cc.MATR_NCORR       ";
			sql = sql + "      					and com.ECOM_CCOD=1       ";
			sql = sql + "      					and com.COMP_NDOCTO=dc.COMP_NDOCTO       ";
			sql = sql + "      					and dc.TCOM_CCOD=ab.TCOM_CCOD       ";
			sql = sql + "      					and dc.INST_CCOD=ab.INST_CCOD       ";
			sql = sql + "      					and dc.COMP_NDOCTO=ab.COMP_NDOCTO       ";
			sql = sql + "      					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO       ";
			sql = sql + "      					and dc.ECOM_CCOD=1      ";
			sql = sql + "      					and ii.EING_CCOD=1			       ";
			sql = sql + "   						and ab.INGR_NCORR=ii.INGR_NCORR       ";
			sql = sql + " 						and ii.TING_CCOD=tii.TING_CCOD		 ";
			sql = sql + " 						and nvl(tii.TING_BREBAJE,'N') <> 'S'  ";
			sql = sql + " 						and tii.TING_BINGRESO_REAL = 'S'  ";
			sql = sql + "  						and to_char(ii.INGR_FPAGO,'YYYY') = "+ano;
			sql = sql + "      					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM')    ";
			sql = sql + " 						) a        ";
			sql = sql + "      				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD, a.mes       ";
			sql = sql + "  					HAVING a.mes  between "+mes_i+" and "+mes_f;
			sql = sql + "   				)        ";
			sql = sql + "      				group by CARR_CCOD,CARR_TDESC	   ";
			sql = sql + "   ) b    ";
			sql = sql + "    where      ";
			sql = sql + "      z.CARR_CCOD=a.CARR_CCOD (+)     ";
			sql = sql + "      and z.CARR_CCOD=b.CARR_CCOD  (+)     ";
			sql = sql + " 	 and z.CARR_CCOD=c.CARR_CCOD  (+)   ";
			sql = sql + " 	 and z.CARR_CCOD=d.CARR_CCOD  (+)   ";

			return (sql);		
		}

/*
		private string EscribirCodigo(string periodo, string sede, string ano) {
			string SQL;

			SQL = "";

			SQL = " select a.carr_tdesc, a.semestre, a.semestre as nro_informe, a.carr_ccod, a.peri_tdesc, a.sede_tdesc, '" + ano + "' as ano,  \n";
			SQL = SQL +  "        nvl(b.matr_compr_01, 0) as matr_compr_01, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_02, 0) as matr_compr_02, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_03, 0) as matr_compr_03, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_04, 0) as matr_compr_04, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_05, 0) as matr_compr_05, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_06, 0) as matr_compr_06, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_01, 0) as col_compr_01, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_02, 0) as col_compr_02, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_03, 0) as col_compr_03, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_04, 0) as col_compr_04, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_05, 0) as col_compr_05, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_06, 0) as col_compr_06, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_01, 0) as matr_realr_01, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_02, 0) as matr_realr_02, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_03, 0) as matr_realr_03, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_04, 0) as matr_realr_04, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_05, 0) as matr_realr_05, \n";
			SQL = SQL +  " 	   nvl(c.matr_realr_06, 0) as matr_realr_06, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_01, 0) as col_realr_01, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_02, 0) as col_realr_02, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_03, 0) as col_realr_03, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_04, 0) as col_realr_04, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_05, 0) as col_realr_05, \n";
			SQL = SQL +  " 	   nvl(c.col_realr_06, 0) as col_realr_06, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_01, 0) - nvl(c.matr_realr_01, 0) as saldo_01, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_02, 0) - nvl(c.matr_realr_02, 0) as saldo_02, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_03, 0) - nvl(c.matr_realr_03, 0) as saldo_03, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_04, 0) - nvl(c.matr_realr_04, 0) as saldo_04, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_05, 0) - nvl(c.matr_realr_05, 0) as saldo_05, \n";
			SQL = SQL +  " 	   nvl(b.matr_compr_06, 0) - nvl(c.matr_realr_06, 0) as saldo_06, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_01, 0) - nvl(c.col_realr_01, 0) as saldo_07, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_02, 0) - nvl(c.col_realr_02, 0) as saldo_08, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_03, 0) - nvl(c.col_realr_03, 0) as saldo_09, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_04, 0) - nvl(c.col_realr_04, 0) as saldo_10, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_05, 0) - nvl(c.col_realr_05, 0) as saldo_11, \n";
			SQL = SQL +  " 	   nvl(b.col_compr_06, 0) - nvl(c.col_realr_06, 0) as saldo_12 \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct c.carr_ccod, c.carr_tdesc, d.semestre, e.sede_tdesc, f.peri_tdesc \n";
			SQL = SQL +  "       from ofertas_academicas a, especialidades b, carreras c, (select 1 as semestre from dual union select 2 as semestre from dual) d, \n";
			SQL = SQL +  " 	       sedes e, periodos_academicos f	 \n";
			SQL = SQL +  " 	  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 	    and b.carr_ccod = c.carr_ccod \n";
			SQL = SQL +  " 		and a.sede_ccod = e.sede_ccod \n";
			SQL = SQL +  " 		and a.peri_ccod = f.peri_ccod \n";
			SQL = SQL +  " 		and a.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		and a.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select i.carr_tdesc, h.carr_ccod, round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 1) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 2) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 3) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 4) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 5) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 6) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 1) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 2) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 3) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 4) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 5) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(b.dcom_fcompromiso, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(b.dcom_fcompromiso, 'mm')), to_number(to_char(b.dcom_fcompromiso, 'mm')) - 6) = 6) then b.dcom_mcompromiso - total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_06   \n";
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
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) \n";
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) \n";
			SQL = SQL +  " 		  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) \n";
			SQL = SQL +  " 		  and a.comp_ndocto_origen = e.cont_ncorr \n";
			SQL = SQL +  " 		  and e.matr_ncorr = f.matr_ncorr \n";
			SQL = SQL +  " 		  and f.ofer_ncorr = g.ofer_ncorr \n";
			SQL = SQL +  " 		  and g.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 		  and h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  " 		  and b.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.econ_ccod in (1, 4) \n";
			SQL = SQL +  "        and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		  and f.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and g.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and g.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		group by i.carr_tdesc, h.carr_ccod, round((to_number(to_char(b.dcom_fcompromiso, 'mm')) - 1) / 12) + 1 \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	( \n";
			SQL = SQL +  " 	 select k.carr_tdesc, j.carr_ccod, round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 1) then c.abon_mabono else 0 end) as matr_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 2) then c.abon_mabono else 0 end) as matr_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 3) then c.abon_mabono else 0 end) as matr_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 4) then c.abon_mabono else 0 end) as matr_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 5) then c.abon_mabono else 0 end) as matr_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 6) then c.abon_mabono else 0 end) as matr_realr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 1) then c.abon_mabono else 0 end) as col_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 2) then c.abon_mabono else 0 end) as col_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 3) then c.abon_mabono else 0 end) as col_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 4) then c.abon_mabono else 0 end) as col_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 5) then c.abon_mabono else 0 end) as col_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (to_char(d.ingr_fpago, 'yyyy') = '" + ano + "') and (decode(round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1, 1, to_number(to_char(d.ingr_fpago, 'mm')), to_number(to_char(d.ingr_fpago, 'mm')) - 6) = 6) then c.abon_mabono else 0 end) as col_realr_06        \n";
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
			SQL = SQL +  " 		  and g.econ_ccod in (1, 4) \n";
			SQL = SQL +  " 		  and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		  and c.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.ting_bingreso_real = 'S' \n";
			SQL = SQL +  " 		  and nvl(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		  and i.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and i.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		group by k.carr_tdesc, j.carr_ccod, round((to_number(to_char(d.ingr_fpago, 'mm')) - 1) / 12) + 1 \n";
			SQL = SQL +  " 	) c \n";
			SQL = SQL +  " where a.carr_ccod = b.carr_ccod (+) \n";
			SQL = SQL +  "   and a.semestre = b.semestre (+) \n";
			SQL = SQL +  "   and a.carr_ccod = c.carr_ccod (+) \n";
			SQL = SQL +  "   and a.semestre = c.semestre (+) \n";
			SQL = SQL +  " order by a.semestre asc, a.carr_tdesc asc \n";
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
			SQL =  " select a.carr_tdesc, a.semestre, a.semestre as nro_informe, a.carr_ccod, a.peri_tdesc, a.sede_tdesc, '" + ano + "' as ano,  \n";
			SQL = SQL +  "       isnull(b.matr_compr_01, 0) as matr_compr_01, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_02, 0) as matr_compr_02, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_03, 0) as matr_compr_03, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_04, 0) as matr_compr_04, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_05, 0) as matr_compr_05, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_06, 0) as matr_compr_06, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_01, 0) as col_compr_01, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_02, 0) as col_compr_02, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_03, 0) as col_compr_03, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_04, 0) as col_compr_04, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_05, 0) as col_compr_05, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_06, 0) as col_compr_06, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_01, 0) as matr_realr_01, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_02, 0) as matr_realr_02, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_03, 0) as matr_realr_03, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_04, 0) as matr_realr_04, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_05, 0) as matr_realr_05, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_06, 0) as matr_realr_06, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_01, 0) as col_realr_01, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_02, 0) as col_realr_02, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_03, 0) as col_realr_03, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_04, 0) as col_realr_04, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_05, 0) as col_realr_05, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_06, 0) as col_realr_06, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_01, 0) - isnull(c.matr_realr_01, 0) as saldo_01, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_02, 0) - isnull(c.matr_realr_02, 0) as saldo_02, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_03, 0) - isnull(c.matr_realr_03, 0) as saldo_03, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_04, 0) - isnull(c.matr_realr_04, 0) as saldo_04, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_05, 0) - isnull(c.matr_realr_05, 0) as saldo_05, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_06, 0) - isnull(c.matr_realr_06, 0) as saldo_06, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_01, 0) - isnull(c.col_realr_01, 0) as saldo_07, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_02, 0) - isnull(c.col_realr_02, 0) as saldo_08, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_03, 0) - isnull(c.col_realr_03, 0) as saldo_09, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_04, 0) - isnull(c.col_realr_04, 0) as saldo_10, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_05, 0) - isnull(c.col_realr_05, 0) as saldo_11, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_06, 0) - isnull(c.col_realr_06, 0) as saldo_12 \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct c.carr_ccod, c.carr_tdesc, d.semestre, e.sede_tdesc, f.peri_tdesc \n";
			SQL = SQL +  "       from ofertas_academicas a, especialidades b, carreras c, (select 1 as semestre union select 2 as semestre ) d, \n";
			SQL = SQL +  " 	       sedes e, periodos_academicos f \n";	 
			SQL = SQL +  " 	  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 	    and b.carr_ccod = c.carr_ccod \n";
			SQL = SQL +  " 		and a.sede_ccod = e.sede_ccod \n";
			SQL = SQL +  " 		and a.peri_ccod = f.peri_ccod \n";
			SQL = SQL +  " 		and a.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		and a.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 	 ) a, \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select i.carr_tdesc, h.carr_ccod, round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12,2) + 1 as semestre, \n";
            SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 1) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 2) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 3) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 4) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 5) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 6) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 1) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 2) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 3) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 4) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 5) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 6) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_06  \n";
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
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')   *= c.ingr_ncorr  \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    *= c.ting_ccod  \n";
			SQL = SQL +  " 		  and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')  *= c.ding_ndocto  \n";
			SQL = SQL +  "		  and a.comp_ndocto_origen = e.cont_ncorr \n";
			SQL = SQL +  " 		  and e.matr_ncorr = f.matr_ncorr \n";
			SQL = SQL +  " 		  and f.ofer_ncorr = g.ofer_ncorr \n";
			SQL = SQL +  " 		  and g.espe_ccod = h.espe_ccod \n";
			SQL = SQL +  " 		  and h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  " 		  and b.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.econ_ccod in (1, 4) \n";
			SQL = SQL +  "        and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		  and f.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and g.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and g.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		group by i.carr_tdesc, h.carr_ccod, round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12,2) + 1 \n";
			SQL = SQL +  " 	) b, \n";
			SQL = SQL +  " 	( \n";
			SQL = SQL +  " 	 select k.carr_tdesc, j.carr_ccod, round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12,2) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 1) then c.abon_mabono else 0 end) as matr_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 2) then c.abon_mabono else 0 end) as matr_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 3) then c.abon_mabono else 0 end) as matr_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 4) then c.abon_mabono else 0 end) as matr_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 5) then c.abon_mabono else 0 end) as matr_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 6) then c.abon_mabono else 0 end) as matr_realr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 1) then c.abon_mabono else 0 end) as col_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 2) then c.abon_mabono else 0 end) as col_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 3) then c.abon_mabono else 0 end) as col_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 4) then c.abon_mabono else 0 end) as col_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 5) then c.abon_mabono else 0 end) as col_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 6) then c.abon_mabono else 0 end) as col_realr_06  \n";
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
			SQL = SQL +  "		  and b.inst_ccod = c.inst_ccod \n";
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
			SQL = SQL +  " 		  and g.econ_ccod in (1, 4) \n";
			SQL = SQL +  " 		  and d.eing_ccod = 1 \n";
			SQL = SQL +  " 		  and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		  and c.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		  and e.ting_bingreso_real = 'S' \n";
			SQL = SQL +  " 		  and isnull(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		  and i.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  " 		  and i.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  " 		group by k.carr_tdesc, j.carr_ccod, round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12,2) + 1 \n";
			SQL = SQL +  " 	) c \n";
			SQL = SQL +  " where a.carr_ccod *= b.carr_ccod  \n";
			SQL = SQL +  "   and a.semestre  *= b.semestre \n";
			SQL = SQL +  "   and a.carr_ccod *= c.carr_ccod \n";
			SQL = SQL +  "   and a.semestre  *= c.semestre \n";
			SQL = SQL +  " order by a.semestre asc, a.carr_tdesc asc \n";
			//Response.Write(SQL);
			//Response.Flush();
				return SQL;
		}*/


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
		LINEA			: 247 - 288,289,290 - 305 - 343
		********************************************************************/

		private string EscribirCodigo(string periodo, string sede, string ano) 
		{
			string SQL;

			SQL = "";

			//--------------------------------------------------------------------------------------------------
			//--------------------------------------------------------------------------------------------------
			SQL =  " select a.carr_tdesc, a.semestre, a.semestre as nro_informe, a.carr_ccod, a.peri_tdesc, a.sede_tdesc, '" + ano + "' as ano,  \n";
			SQL = SQL +  "       isnull(b.matr_compr_01, 0) as matr_compr_01, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_02, 0) as matr_compr_02, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_03, 0) as matr_compr_03, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_04, 0) as matr_compr_04, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_05, 0) as matr_compr_05, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_06, 0) as matr_compr_06, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_01, 0) as col_compr_01, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_02, 0) as col_compr_02, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_03, 0) as col_compr_03, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_04, 0) as col_compr_04, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_05, 0) as col_compr_05, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_06, 0) as col_compr_06, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_01, 0) as matr_realr_01, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_02, 0) as matr_realr_02, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_03, 0) as matr_realr_03, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_04, 0) as matr_realr_04, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_05, 0) as matr_realr_05, \n";
			SQL = SQL +  " 	   isnull(c.matr_realr_06, 0) as matr_realr_06, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_01, 0) as col_realr_01, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_02, 0) as col_realr_02, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_03, 0) as col_realr_03, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_04, 0) as col_realr_04, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_05, 0) as col_realr_05, \n";
			SQL = SQL +  " 	   isnull(c.col_realr_06, 0) as col_realr_06, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_01, 0) - isnull(c.matr_realr_01, 0) as saldo_01, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_02, 0) - isnull(c.matr_realr_02, 0) as saldo_02, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_03, 0) - isnull(c.matr_realr_03, 0) as saldo_03, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_04, 0) - isnull(c.matr_realr_04, 0) as saldo_04, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_05, 0) - isnull(c.matr_realr_05, 0) as saldo_05, \n";
			SQL = SQL +  " 	   isnull(b.matr_compr_06, 0) - isnull(c.matr_realr_06, 0) as saldo_06, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_01, 0) - isnull(c.col_realr_01, 0) as saldo_07, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_02, 0) - isnull(c.col_realr_02, 0) as saldo_08, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_03, 0) - isnull(c.col_realr_03, 0) as saldo_09, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_04, 0) - isnull(c.col_realr_04, 0) as saldo_10, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_05, 0) - isnull(c.col_realr_05, 0) as saldo_11, \n";
			SQL = SQL +  " 	   isnull(b.col_compr_06, 0) - isnull(c.col_realr_06, 0) as saldo_12 \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select distinct c.carr_ccod, c.carr_tdesc, d.semestre, e.sede_tdesc, f.peri_tdesc \n";
			SQL = SQL +  "       from ofertas_academicas a \n";
			SQL = SQL +  "       INNER JOIN especialidades b \n";
			SQL = SQL +  "       ON a.espe_ccod = b.espe_ccod and a.peri_ccod = '" + periodo + "' \n";
			SQL = SQL +  "       INNER JOIN carreras c \n";
			SQL = SQL +  "       ON b.carr_ccod = c.carr_ccod \n";
			SQL = SQL +  "       INNER JOIN sedes e \n";
			SQL = SQL +  "       ON a.sede_ccod = e.sede_ccod \n";
			SQL = SQL +  "       INNER JOIN periodos_academicos f 	 \n";
			SQL = SQL +  "      ON a.peri_ccod = f.peri_ccod \n";
			SQL = SQL +  "       INNER JOIN (select 1 as semestre union select 2 as semestre ) d  \n";
			SQL = SQL +  "       ON a.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  "		) a \n";
			SQL = SQL +  "		LEFT OUTER JOIN  \n";
			SQL = SQL +  "		( \n";
			SQL = SQL +  " 	  select i.carr_tdesc, h.carr_ccod, round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12,2) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 1) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 2) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 3) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 4) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 5) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 6) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as matr_compr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 1) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 2) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 3) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 4) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 5) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(month,b.dcom_fcompromiso)as varchar) = '" + ano + "') and (case round((datepart(month,b.dcom_fcompromiso)  - 1) / 12 , 2) + 1 when 1 then datepart(month,b.dcom_fcompromiso) else datepart(month,b.dcom_fcompromiso)- 6 end  = 6) then b.dcom_mcompromiso - protic.total_rebajar_comp_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) else 0 end) as col_compr_06  \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a \n";
			SQL = SQL +  "				INNER JOIN detalles b \n";
			SQL = SQL +  "				ON a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  "				and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  "				and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "				and a.tcom_ccod in (1, 2) \n";
			SQL = SQL +  "				and a.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle c \n";
			SQL = SQL +  " 				ON b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				and a.tcom_ccod = c.tcom_ccod \n";
			SQL = SQL +  "				union all \n";
			SQL = SQL +  " 				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  "				from repactaciones a \n";
			SQL = SQL +  " 				INNER JOIN compromisos b \n";
			SQL = SQL +  " 				ON a.repa_ncorr = b.comp_ndocto and a.tcom_ccod_origen in (1, 2) and b.tcom_ccod = 3 and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 				INNER JOIN detalles c \n";
			SQL = SQL +  " 				ON a.tcom_ccod_origen = c.tcom_ccod and a.comp_ndocto_origen = c.comp_ndocto \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle d \n";
			SQL = SQL +  "				ON c.tdet_ccod = d.tdet_ccod and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 		     ) a \n";
			SQL = SQL +  " 		     INNER JOIN detalle_compromisos b \n";
			SQL = SQL +  " 		     ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		     and b.tcom_ccod in (1, 2, 3) and b.ecom_ccod = 1 \n";
			SQL = SQL +  " 		     LEFT OUTER JOIN detalle_ingresos c \n";
			SQL = SQL +  "  		     ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')   = c.ingr_ncorr  \n";
			SQL = SQL +  "  		     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')   = c.ting_ccod  \n";
			SQL = SQL +  " 		     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  \n";
			SQL = SQL +  " 		     INNER JOIN contratos e \n";
			SQL = SQL +  " 		     ON a.comp_ndocto_origen = e.cont_ncorr and e.econ_ccod in (1, 4) \n";
			SQL = SQL +  " 		     INNER JOIN alumnos f \n";
			SQL = SQL +  " 		     ON e.matr_ncorr = f.matr_ncorr and f.emat_ccod <> 9 \n";
			SQL = SQL +  " 		     INNER JOIN ofertas_academicas g \n";
			SQL = SQL +  " 		     ON f.ofer_ncorr = g.ofer_ncorr \n";
			SQL = SQL +  " 		     INNER JOIN especialidades h \n";
			SQL = SQL +  " 		     ON g.espe_ccod = h.espe_ccod and g.peri_ccod = '" + periodo + "'  and g.sede_ccod = '" + sede + "'  \n";
			SQL = SQL +  " 		     INNER JOIN carreras i \n";
			SQL = SQL +  " 		     ON h.carr_ccod = i.carr_ccod \n";
			SQL = SQL +  " 		group by i.carr_tdesc, h.carr_ccod, round((cast(datepart(month,b.dcom_fcompromiso) as numeric) - 1) / 12,2) + 1 \n";
			SQL = SQL +  " 		) b \n";
			SQL = SQL +  " 		ON a.carr_ccod = b.carr_ccod  \n";
			SQL = SQL +  " 		and a.semestre = b.semestre  \n";
			SQL = SQL +  " 		LEFT OUTER JOIN \n";
			SQL = SQL +  " 		( \n";
			SQL = SQL +  " 	 select k.carr_tdesc, j.carr_ccod, round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12,2) + 1 as semestre, \n";
			SQL = SQL +  " 		       sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 1) then c.abon_mabono else 0 end) as matr_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 2) then c.abon_mabono else 0 end) as matr_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 3) then c.abon_mabono else 0 end) as matr_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 4) then c.abon_mabono else 0 end) as matr_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 5) then c.abon_mabono else 0 end) as matr_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 1) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 6) then c.abon_mabono else 0 end) as matr_realr_06, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 1) then c.abon_mabono else 0 end) as col_realr_01, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 2) then c.abon_mabono else 0 end) as col_realr_02, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 3) then c.abon_mabono else 0 end) as col_realr_03, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 4) then c.abon_mabono else 0 end) as col_realr_04, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 5) then c.abon_mabono else 0 end) as col_realr_05, \n";
			SQL = SQL +  " 			   sum(case when (a.tcom_ccod_origen = 2) and (cast(datepart(year,d.ingr_fpago) as varchar) = '" + ano + "') and (case round((datepart(month,d.ingr_fpago) - 1) / 12,2) + 1 when 1 then datepart(month,d.ingr_fpago) else datepart(month,d.ingr_fpago) - 6 end  = 6) then c.abon_mabono else 0 end) as col_realr_06  \n";
			SQL = SQL +  " 		from (	 \n";
			SQL = SQL +  " 		        select b.tdet_ccod, a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.comp_ndocto as comp_ndocto_origen, a.tcom_ccod as tcom_ccod_origen \n";
			SQL = SQL +  " 				from compromisos a \n";
			SQL = SQL +  " 				INNER JOIN detalles b \n";
			SQL = SQL +  " 				ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "				and a.tcom_ccod in (1, 2) and a.ecom_ccod = 1  \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle c \n";
			SQL = SQL +  "				ON b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  " 				and a.tcom_ccod = c.tcom_ccod   \n";
			SQL = SQL +  "				union all \n";
			SQL = SQL +  "				select c.tdet_ccod, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, a.comp_ndocto_origen, a.tcom_ccod_origen \n";
			SQL = SQL +  "				from repactaciones a \n";
			SQL = SQL +  "				INNER JOIN compromisos b \n";
			SQL = SQL +  "				ON a.repa_ncorr = b.comp_ndocto and a.tcom_ccod_origen in (1, 2) and b.tcom_ccod = 3 and b.ecom_ccod = 1 \n";
			SQL = SQL +  "				INNER JOIN detalles c \n";
			SQL = SQL +  "				ON a.tcom_ccod_origen = c.tcom_ccod \n";
			SQL = SQL +  "				INNER JOIN tipos_detalle d \n";
			SQL = SQL +  "				ON a.comp_ndocto_origen = c.comp_ndocto and c.tdet_ccod = d.tdet_ccod and d.tcom_ccod = a.tcom_ccod_origen \n";
			SQL = SQL +  " 		     ) a \n";
			SQL = SQL +  "		     INNER JOIN detalle_compromisos b \n";
			SQL = SQL +  "		     ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		     and b.ecom_ccod = 1 \n";
			SQL = SQL +  "		     LEFT OUTER JOIN abonos c \n";
			SQL = SQL +  "		     ON b.tcom_ccod = c.tcom_ccod and b.inst_ccod = c.inst_ccod and b.comp_ndocto = c.comp_ndocto and b.dcom_ncompromiso = c.dcom_ncompromiso \n";
			SQL = SQL +  "		     and c.tcom_ccod in (1, 2, 3) \n";
			SQL = SQL +  " 		     INNER JOIN ingresos d \n";
			SQL = SQL +  " 		     ON c.ingr_ncorr = d.ingr_ncorr and d.eing_ccod = 1 \n";
			SQL = SQL +  "		     INNER JOIN tipos_ingresos e \n";
			SQL = SQL +  "		     ON d.ting_ccod = e.ting_ccod and e.ting_bingreso_real = 'S' and isnull(e.ting_brebaje, 'N') = 'N' \n";
			SQL = SQL +  " 		     INNER JOIN movimientos_cajas f  \n";
			SQL = SQL +  "			 ON d.mcaj_ncorr = f.mcaj_ncorr \n";
			SQL = SQL +  "			 INNER JOIN contratos g \n";
			SQL = SQL +  "			 ON a.comp_ndocto_origen = g.cont_ncorr and g.econ_ccod in (1, 4) \n";
			SQL = SQL +  "			 INNER JOIN alumnos h \n";
			SQL = SQL +  "			 ON g.matr_ncorr = h.matr_ncorr and h.emat_ccod <> 9 \n";
			SQL = SQL +  "			 INNER JOIN ofertas_academicas i \n";
			SQL = SQL +  " 			 ON h.ofer_ncorr = i.ofer_ncorr and i.peri_ccod =  '" + periodo + "'  and i.sede_ccod = '" + sede + "' \n";
			SQL = SQL +  "			 INNER JOIN especialidades j \n";
			SQL = SQL +  " 			 ON i.espe_ccod = j.espe_ccod \n";
			SQL = SQL +  " 			 INNER JOIN carreras k \n";
			SQL = SQL +  "			 ON j.carr_ccod = k.carr_ccod \n";
			SQL = SQL +  " 		group by k.carr_tdesc, j.carr_ccod, round((cast(datepart(month,d.ingr_fpago) as numeric) - 1) / 12,2) + 1 \n";
			SQL = SQL +  " 	) c \n";
			SQL = SQL +  " ON a.carr_ccod = c.carr_ccod \n";
				SQL = SQL +  "		and a.semestre = c.semestre \n";
			SQL = SQL +  " order by a.semestre asc, a.carr_tdesc asc \n";
			//Response.Write(SQL);
			//Response.Flush();
			return SQL;
		}



		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			// Introducir aquí el código de usuario para inicializar la página
			string sql="";
			string periodo;
			string sede;
			string ano;
			string tipo_informe;
			//string imprimirFinanza;
			//string paga_ncorr_d;
			//int fila = 0;	
			periodo = Request.QueryString["periodo"];
			sede = Request.QueryString["sede"];
			ano= Request.QueryString["ano"];
			tipo_informe=Request.QueryString["tipo_informe"];
			
			

			/*
			for (int i=1; i<3; i++) 
			{
				if (i==1)
				{
					sql = EscribirCodigo(i,1,6, periodo, sede, ano);
				}
				if (i==2)
				{
					sql = EscribirCodigo(i,7,12, periodo, sede,ano);
				}
				
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(datos1);
			}*/
		
			sql = EscribirCodigo(periodo, sede, ano);			
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datos1);
			
			
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
			this.datos1 = new Pres_Ing_Real_Mes.datos();
			((System.ComponentModel.ISupportInitialize)(this.datos1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "meses", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_01", "MATR_COMPR_01"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_02", "MATR_COMPR_02"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_03", "MATR_COMPR_03"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_04", "MATR_COMPR_04"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_05", "MATR_COMPR_05"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_06", "MATR_COMPR_06"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_07", "MATR_COMPR_07"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_08", "MATR_COMPR_08"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_09", "MATR_COMPR_09"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_10", "MATR_COMPR_10"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_11", "MATR_COMPR_11"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_COMPR_12", "MATR_COMPR_12"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_01", "COL_COMPR_01"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_02", "COL_COMPR_02"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_03", "COL_COMPR_03"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_04", "COL_COMPR_04"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_05", "COL_COMPR_05"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_06", "COL_COMPR_06"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_07", "COL_COMPR_07"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_08", "COL_COMPR_08"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_09", "COL_COMPR_09"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_10", "COL_COMPR_10"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_11", "COL_COMPR_11"),
																																																				 new System.Data.Common.DataColumnMapping("COL_COMPR_12", "COL_COMPR_12"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_01", "MATR_REALR_01"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_02", "MATR_REALR_02"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_03", "MATR_REALR_03"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_04", "MATR_REALR_04"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_05", "MATR_REALR_05"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_06", "MATR_REALR_06"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_07", "MATR_REALR_07"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_08", "MATR_REALR_08"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_09", "MATR_REALR_09"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_10", "MATR_REALR_10"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_11", "MATR_REALR_11"),
																																																				 new System.Data.Common.DataColumnMapping("MATR_REALR_12", "MATR_REALR_12"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_01", "COL_REALR_01"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_02", "COL_REALR_02"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_03", "COL_REALR_03"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_04", "COL_REALR_04"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_05", "COL_REALR_05"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_06", "COL_REALR_06"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_07", "COL_REALR_07"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_08", "COL_REALR_08"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_09", "COL_REALR_09"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_10", "COL_REALR_10"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_11", "COL_REALR_11"),
																																																				 new System.Data.Common.DataColumnMapping("COL_REALR_12", "COL_REALR_12"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_01", "SALDO_01"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_02", "SALDO_02"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_03", "SALDO_03"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_04", "SALDO_04"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_05", "SALDO_05"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_06", "SALDO_06"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_07", "SALDO_07"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_08", "SALDO_08"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_09", "SALDO_09"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_10", "SALDO_10"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_11", "SALDO_11"),
																																																				 new System.Data.Common.DataColumnMapping("SALDO_12", "SALDO_12")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS NRO_INFORME, '' AS CARR_TDESC, '' AS CARR_CCOD, '' AS MATR_COMPR_01, '' AS MATR_COMPR_02, '' AS MATR_COMPR_03, '' AS MATR_COMPR_04, '' AS MATR_COMPR_05, '' AS MATR_COMPR_06, '' AS MATR_COMPR_07, '' AS MATR_COMPR_08, '' AS MATR_COMPR_09, '' AS MATR_COMPR_10, '' AS MATR_COMPR_11, '' AS MATR_COMPR_12, '' AS COL_COMPR_01, '' AS COL_COMPR_02, '' AS COL_COMPR_03, '' AS COL_COMPR_04, '' AS COL_COMPR_05, '' AS COL_COMPR_06, '' AS COL_COMPR_07, '' AS COL_COMPR_08, '' AS COL_COMPR_09, '' AS COL_COMPR_10, '' AS COL_COMPR_11, '' AS COL_COMPR_12, '' AS MATR_REALR_01, '' AS MATR_REALR_02, '' AS MATR_REALR_03, '' AS MATR_REALR_04, '' AS MATR_REALR_05, '' AS MATR_REALR_06, '' AS MATR_REALR_07, '' AS MATR_REALR_08, '' AS MATR_REALR_09, '' AS MATR_REALR_10, '' AS MATR_REALR_11, '' AS MATR_REALR_12, '' AS COL_REALR_01, '' AS COL_REALR_02, '' AS COL_REALR_03, '' AS COL_REALR_04, '' AS COL_REALR_05, '' AS COL_REALR_06, '' AS COL_REALR_07, '' AS COL_REALR_08, '' AS COL_REALR_09, '' AS COL_REALR_10, '' AS COL_REALR_11, '' AS COL_REALR_12, '' AS SALDO_01, '' AS SALDO_02, '' AS SALDO_03, '' AS SALDO_04, '' AS SALDO_05, '' AS SALDO_06, '' AS SALDO_07, '' AS SALDO_08, '' AS SALDO_09, '' AS SALDO_10, '' AS SALDO_11, '' AS SALDO_12, '' AS PERIODO, '' AS FECHA_INICIO, '' AS FECHA_TERMINO, '' AS SEDE_TDESC, '' AS ANO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
			// 
			// datos1
			// 
			this.datos1.DataSetName = "datos";
			this.datos1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datos1.Namespace = "http://www.tempuri.org/datos.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datos1)).EndInit();

		}
		#endregion

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
