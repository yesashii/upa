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


namespace Pres_resumen
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DataAdapter;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected Pres_resumen.DataSet1 dataSet11;
		protected System.Data.OleDb.OleDbConnection ConeccionBD;
	
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=Pres_Resumen.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		string Generar_SQL_INGRESOS(string FILA, int N_INFORME, int MES_INI, int MES_FIN, string PERIODO, string SEDE, string ANO)
		{                
		 string sql = "";
		 
			sql = "SELECT '" + FILA + "' as fila, nro_informe, CARR_TDESC, CARR_CCOD, SEDE_TDESC, ano, periodo, fecha_inicio, fecha_termino,  \n";
			sql = sql + "       COMPR_01,COMPR_02,COMPR_03,COMPR_04,COMPR_05,COMPR_06,  \n";
			sql = sql + "	   REAL_01,REAL_02,REAL_03,REAL_04,REAL_05,REAL_06,  \n";
			sql = sql + "	   SALDO_01,SALDO_02,SALDO_03,SALDO_04,SALDO_05,SALDO_06  \n";	   
			sql = sql + "from  \n";
			sql = sql + "(  \n";
			sql = sql + "select " + N_INFORME  + " as nro_informe, z.CARR_TDESC, z.CARR_CCOD,z.SEDE_TDESC, " + ANO + " as ano,  \n";   
			sql = sql + " z.PERI_TDESC as periodo, '' as fecha_inicio, '' as fecha_termino,  \n";
			sql = sql + "   round(nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)+nvl(matr_comp_saldo_01,0))  +  round(nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)+nvl(col_comp_saldo_01,0))  as COMPR_01,    \n";
			sql = sql + "   round(nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)+nvl(matr_comp_saldo_02,0))  +  round(nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)+nvl(col_comp_saldo_02,0))  as COMPR_02,    \n";
			sql = sql + "   round(nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)+nvl(matr_comp_saldo_03,0))  +  round(nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)+nvl(col_comp_saldo_03,0))  as COMPR_03,     \n";
			sql = sql + "   round(nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)+nvl(matr_comp_saldo_04,0))  +  round(nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)+nvl(col_comp_saldo_04,0))  as COMPR_04,    \n";
			sql = sql + "   round(nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)+nvl(matr_comp_saldo_05,0))  +  round(nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)+nvl(col_comp_saldo_05,0))  as COMPR_05,    \n";
			sql = sql + "   round(nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)+nvl(matr_comp_saldo_06,0))  +  round(nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)+nvl(col_comp_saldo_06,0))  as COMPR_06,  \n";  
			sql = sql + "   round(nvl(matr_real_01,0))  +  round(nvl(col_real_01,0))  as REAL_01,    \n";
			sql = sql + "   round(nvl(matr_real_02,0))  +  round(nvl(col_real_02,0))  as REAL_02,    \n";
			sql = sql + "   round(nvl(matr_real_03,0))  +  round(nvl(col_real_03,0))  as REAL_03,     \n";
			sql = sql + "   round(nvl(matr_real_04,0))  +  round(nvl(col_real_04,0))  as REAL_04,    \n";
			sql = sql + "   round(nvl(matr_real_05,0))  +  round(nvl(col_real_05,0))  as REAL_05,    \n";
			sql = sql + "   round(nvl(matr_real_06,0))  +  round(nvl(col_real_06,0))  as REAL_06,  \n";
			sql = sql + "   ((round(nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)+nvl(matr_comp_saldo_01,0))  +  round(nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)+nvl(col_comp_saldo_01,0)))  -  (round(nvl(matr_real_01,0))  +  round(nvl(col_real_01,0)))) as SALDO_01,  \n";
			sql = sql + "   ((round(nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)+nvl(matr_comp_saldo_02,0))  +  round(nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)+nvl(col_comp_saldo_02,0)))  -  (round(nvl(matr_real_02,0))  +  round(nvl(col_real_02,0)))) as SALDO_02,  \n";
			sql = sql + "   ((round(nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)+nvl(matr_comp_saldo_03,0))  +  round(nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)+nvl(col_comp_saldo_03,0)))  -  (round(nvl(matr_real_03,0))  +  round(nvl(col_real_03,0)))) as SALDO_03,  \n";
			sql = sql + "   ((round(nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)+nvl(matr_comp_saldo_04,0))  +  round(nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)+nvl(col_comp_saldo_04,0)))  -  (round(nvl(matr_real_04,0))  +  round(nvl(col_real_04,0)))) as SALDO_04,  \n";
			sql = sql + "   ((round(nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)+nvl(matr_comp_saldo_05,0))  +  round(nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)+nvl(col_comp_saldo_05,0)))  -  (round(nvl(matr_real_05,0))  +  round(nvl(col_real_05,0)))) as SALDO_05,  \n";
			sql = sql + "   ((round(nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)+nvl(matr_comp_saldo_06,0))  +  round(nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)+nvl(col_comp_saldo_06,0)))  -  (round(nvl(matr_real_06,0))  +  round(nvl(col_real_06,0)))) as SALDO_06  \n";    
			sql = sql + "  from      \n";
			sql = sql + "    (      \n";
			sql = sql + "     select distinct car.CARR_TDESC,car.CARR_CCOD, s.SEDE_TDESC, pa.PERI_TDESC      \n";
			sql = sql + "     from ofertas_academicas oo , especialidades ee, carreras car,periodos_academicos pa, sedes s  \n";      
			sql = sql + "     where oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD = nvl('" + SEDE + "',oo.SEDE_CCOD)   \n";     
			sql = sql + "     						and oo.ESPE_CCOD = ee.ESPE_CCOD        \n";
			sql = sql + "     						and ee.CARR_CCOD = car.CARR_CCOD        \n";
			sql = sql + "   						and oo.PERI_CCOD = pa.PERI_CCOD  \n";
			sql = sql + "     						and oo.SEDE_CCOD = s.SEDE_CCOD   \n";     
			sql = sql + "	 ) z,   \n";   
			sql = sql + "   (    \n";
			sql = sql + " select CARR_TDESC,CARR_CCOD,        \n";
			sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_02,     \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_06  \n";   
			sql = sql + "  		from (       \n";
			sql = sql + "			   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
			sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
			sql = sql + "     			   from (   \n";
			sql = sql + "				   		select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
			sql = sql + "     					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes  \n";   
			sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     						detalle_compromisos dc,     \n";
			sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
			sql = sql + "							where aa.emat_ccod<>9        \n";
			sql = sql + "     						and cc.CONT_NCORR=com.comp_ndocto   \n";
			sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     						and cc.ECON_CCOD=1        \n";
			sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     						and com.ECOM_CCOD=1        \n";
			sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
			sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
			sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
			sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
			sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
			sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
			sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
			sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR (+)  \n";  
			sql = sql + "							and  nvl(dii.EDIN_CCOD,0)<>11    \n";
			sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'  \n";    
			sql = sql + "     						and dc.ECOM_CCOD=1    \n";
			sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = "+ANO+"  \n";
			sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
			sql = sql + " 						) a         \n";
			sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
			sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "     					)         \n";
			sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";  
			sql = sql + ")a,	  \n";
			sql = sql + "  (  \n";
			sql = sql + "  select CARR_TDESC,CARR_CCOD,        \n";
			sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_repa_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_repa_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_repa_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_repa_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_repa_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_repa_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_repa_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_repa_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_repa_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_repa_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_repa_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_repa_06  \n";   
			sql = sql + "  		from (    \n";
			sql = sql + "		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
			sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
			sql = sql + "     			   from (   \n";
			sql = sql + "				      select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
			sql = sql + "     					  aa.PERS_NCORR, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes,  \n";
			sql = sql + "						    compromiso_origen_repactacion(com.COMP_NDOCTO, 'tcom_ccod') TCOM_CCOD  \n";
			sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     						detalle_compromisos dc,     \n";
			sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
			sql = sql + "							where aa.emat_ccod<>9        \n";
			sql = sql + "     						and cc.CONT_NCORR in (select comp_ndocto_origen  from repactaciones  \n"; 
			sql = sql + "											  	 		 where repa_ncorr = com.COMP_NDOCTO)  \n";
			sql = sql + "							and com.tcom_ccod=3  \n";
			sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     						and cc.ECON_CCOD=1        \n";
			sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     						and com.ECOM_CCOD=1        \n";
			sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
			sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
			sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
			sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
			sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
			sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
			sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
			sql = sql + "							and ii.INGR_NCORR   =dii.INGR_NCORR (+)  \n";  
			sql = sql + "							and  nvl(dii.EDIN_CCOD,0)<>11    \n";
			sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'  \n";    
			sql = sql + "     						and dc.ECOM_CCOD=1    \n";
			sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = "+ANO+"  \n";
			sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,  \n";
			sql = sql + "							com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM'),com.COMP_NDOCTO  \n"; 
			sql = sql + "						) a         \n";
			sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
			sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "						)         \n";
			sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";
			sql = sql + ")c,	  \n";
			sql = sql + "(  \n";
			sql = sql + "select CARR_TDESC,CARR_CCOD,        \n";
			sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_saldo_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_saldo_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_saldo_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_saldo_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_saldo_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_saldo_06,     \n";
			sql = sql + " 		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_saldo_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_saldo_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_saldo_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_saldo_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_saldo_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_saldo_06  \n";   
			sql = sql + "  		from (       \n";
			sql = sql + "			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
			sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
			sql = sql + "     			   from (   \n";
			sql = sql + "				   select sum(nvl(dc.DCOM_MCOMPROMISO,0)- nvl(iin.ingr_mtotal,0)) valor_efectivo,  \n";
			sql = sql + "					 car.CARR_CCOD, car.CARR_TDESC,         \n";
			sql = sql + "     					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes  \n";   
			sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     						detalle_compromisos dc,     \n";
			sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii,  \n";
			sql = sql + "							ingresos iin, abonos abn      \n";
			sql = sql + "							where aa.emat_ccod<>9        \n";
			sql = sql + "     						and cc.CONT_NCORR=com.comp_ndocto  \n"; 
			sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     						and cc.ECON_CCOD=1        \n";
			sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     						and com.ECOM_CCOD=1        \n";
			sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
			sql = sql + "							and com.TCOM_CCOD=dc.TCOM_CCOD      \n";  
			sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD   \n";
			sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD       \n";
			sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD        \n";
			sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO          \n";
			sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO  \n";      
			sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR     \n";    
			sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	  \n";
			sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR  \n"; 
			sql = sql + "							and ab.TCOM_CCOD=abn.TCOM_CCOD  \n";
			sql = sql + "							and ab.INST_CCOD=abn.INST_CCOD  \n";
			sql = sql + "							and ab.COMP_NDOCTO=abn.COMP_NDOCTO  \n";
			sql = sql + "							and ab.DCOM_NCOMPROMISO=abn.DCOM_NCOMPROMISO  \n";
			sql = sql + "							and abn.INGR_NCORR =iin.INGR_NCORR    \n";
			sql = sql + "							and iin.INGR_NFOLIO_REFERENCIA=dii.REPA_NCORR  \n";
			sql = sql + "							and iin.EING_CCOD=5  \n";
			sql = sql + "							and iin.TING_CCOD=9  \n";
			sql = sql + "							and  dii.EDIN_CCOD=11    \n";
			sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'  \n";    
			sql = sql + "     						and dc.ECOM_CCOD=1    \n";
			sql = sql + "							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = " + ANO + "  \n";
			sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
			sql = sql + " 						) a         \n";
			sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
			sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "     					)         \n";
			sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";
			sql = sql + ")d,		  \n";	    
			sql = sql + "   (	  \n";
			sql = sql + "  select  CARR_TDESC,CARR_CCOD,    \n";
			sql = sql + "   		sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_real_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_real_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_real_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_real_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_real_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_real_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_real_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_real_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_real_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_real_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_real_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_real_06  \n";      
			sql = sql + "      from (        \n";
			sql = sql + "     		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";      
			sql = sql + "     		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";      
			sql = sql + "     		    from (        \n";
			sql = sql + "				    select sum(ii.INGR_MTOTAL) valor_efectivo,car.CARR_CCOD,        \n";
			sql = sql + "     				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM') mes  \n";       
			sql = sql + "     					from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     					detalle_compromisos dc, abonos ab,        \n";
			sql = sql + "     					ingresos ii, tipos_ingresos tii,         \n";
			sql = sql + "     					ofertas_academicas oo , especialidades ee, carreras car  \n";      
			sql = sql + "     					where aa.emat_ccod<>9        \n";
			sql = sql + "     					and cc.CONT_NCORR=com.COMP_NDOCTO     \n";   
			sql = sql + "     					and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     					and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     					and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     					and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     					and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     					and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     					and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     					and cc.ECON_CCOD=1        \n";
			sql = sql + "     					and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     					and com.ECOM_CCOD=1        \n";
			sql = sql + "     					and com.COMP_NDOCTO=dc.COMP_NDOCTO      \n";  
			sql = sql + "     					and dc.TCOM_CCOD=ab.TCOM_CCOD        \n";
			sql = sql + "     					and dc.INST_CCOD=ab.INST_CCOD        \n";
			sql = sql + "     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO        \n";
			sql = sql + "     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO  \n";      
			sql = sql + "     					and dc.ECOM_CCOD=1       \n";
			sql = sql + "     					and ii.EING_CCOD=1			        \n";
			sql = sql + "  						and ab.INGR_NCORR=ii.INGR_NCORR        \n";
			sql = sql + "						and ii.TING_CCOD=tii.TING_CCOD		  \n";
			sql = sql + "						and nvl(tii.TING_BREBAJE,'N') <> 'S'  \n"; 
			sql = sql + "						and tii.TING_BINGRESO_REAL = 'S'   \n";
			sql = sql + " 						and to_char(ii.INGR_FPAGO,'YYYY') = " + ANO + "  \n";
			sql = sql + "     					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM')  \n";   
			sql = sql + "						) a         \n";
			sql = sql + "     				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD, a.mes  \n";      
			sql = sql + " 					HAVING a.mes  between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "  				)         \n";
			sql = sql + "     				group by CARR_CCOD,CARR_TDESC  \n";	  
			sql = sql + "  ) b     \n";
			sql = sql + "   where       \n";
			sql = sql + "     z.CARR_CCOD=a.CARR_CCOD (+)      \n";
			sql = sql + "     and z.CARR_CCOD=b.CARR_CCOD  (+)      \n";
			sql = sql + "	 and z.CARR_CCOD=c.CARR_CCOD  (+)    \n";
			sql = sql + "	 and z.CARR_CCOD=d.CARR_CCOD  (+)  \n";
			sql = sql + "    )  \n";
		
		
		 return (sql);
		}

		string Generar_SQL_RETIROS(string FILA, int N_INFORME, int MES_INI, int MES_FIN, string PERIODO, string SEDE, string ANO)
		{                
			string sql = "";
			
			sql = sql + "  select '" + FILA + "' as fila, nro_informe, CARR_TDESC, CARR_CCOD, SEDE_TDESC, ano,  \n";   
			sql = sql + "       periodo, fecha_inicio, fecha_termino,  \n";
			sql = sql + "	   MATR_COMPR_01 + col_COMPR_01 as COMPR_01,  \n";
			sql = sql + "	   MATR_COMPR_02 + col_COMPR_02 as COMPR_02,  \n";
			sql = sql + "	   MATR_COMPR_03 + col_COMPR_03 as COMPR_03,  \n";
			sql = sql + "	   MATR_COMPR_04 + col_COMPR_04 as COMPR_04,  \n";
			sql = sql + "	   MATR_COMPR_05 + col_COMPR_05 as COMPR_05,  \n";
			sql = sql + "	   MATR_COMPR_06 + col_COMPR_06 as COMPR_06,  \n";
			sql = sql + "    MATR_realR_01 + col_realR_01 as REAL_01,  \n";
			sql = sql + "	MATR_realR_02 + col_realR_02 as REAL_02,  \n";
			sql = sql + "	MATR_realR_03 + col_realR_03 as REAL_03,  \n";
			sql = sql + "	MATR_realR_04 + col_realR_04 as REAL_04,  \n";
			sql = sql + "	MATR_realR_05 + col_realR_05 as REAL_05,  \n";
			sql = sql + "	MATR_realR_06 + col_realR_06 as REAL_06,  \n";
			sql = sql + "	  ((MATR_COMPR_01 + col_COMPR_01)  -  (MATR_realR_01 + col_realR_01)) as  SALDO_01,  \n";
			sql = sql + "	  ((MATR_COMPR_02 + col_COMPR_02)  -  (MATR_realR_02 + col_realR_02)) as  SALDO_02,  \n";
			sql = sql + "  	  ((MATR_COMPR_03 + col_COMPR_03)  -  (MATR_realR_03 + col_realR_03)) as  SALDO_03,  \n";
			sql = sql + "	  ((MATR_COMPR_04 + col_COMPR_04)  -  (MATR_realR_04 + col_realR_04)) as  SALDO_04,  \n";
			sql = sql + "	  ((MATR_COMPR_05 + col_COMPR_05)  -  (MATR_realR_05 + col_realR_05)) as  SALDO_05,  \n";
			sql = sql + "	  ((MATR_COMPR_06 + col_COMPR_06)  -  (MATR_realR_06 + col_realR_06)) as  SALDO_06  \n";
			sql = sql + "from (  \n";
			sql = sql + "select " + N_INFORME + " as nro_informe, z.CARR_TDESC,z.CARR_CCOD,z.SEDE_TDESC, " + ANO + " ano,  \n";   
			sql = sql + " z.PERI_TDESC  periodo, '' fecha_inicio, '' fecha_termino,  \n";
			sql = sql + "round(nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)) as MATR_COMPR_01,    \n";
			sql = sql + "   round(nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)) as MATR_COMPR_02,    \n";
			sql = sql + "   round(nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)) as MATR_COMPR_03,     \n";
			sql = sql + "   round(nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)) as MATR_COMPR_04,    \n";
			sql = sql + "   round(nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)) as MATR_COMPR_05,    \n";
			sql = sql + "   round(nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)) as MATR_COMPR_06,  \n";  
			sql = sql + " round(nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)) as col_COMPR_01,    \n";
			sql = sql + "   round(nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)) as col_COMPR_02,    \n";
			sql = sql + "   round(nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)) as col_COMPR_03,     \n";
			sql = sql + "   round(nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)) as col_COMPR_04,    \n";
			sql = sql + "   round(nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)) as col_COMPR_05,    \n";
			sql = sql + "   round(nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)) as col_COMPR_06,  \n";  
			sql = sql + " round(nvl(matr_real_01,0)) as MATR_realR_01,    \n";
			sql = sql + "   round(nvl(matr_real_02,0)) as MATR_realR_02,    \n";
			sql = sql + "   round(nvl(matr_real_03,0)) as MATR_realR_03,     \n";
			sql = sql + "   round(nvl(matr_real_04,0)) as MATR_realR_04,    \n";
			sql = sql + "   round(nvl(matr_real_05,0)) as MATR_realR_05,    \n";
			sql = sql + "   round(nvl(matr_real_06,0)) as MATR_realR_06,   \n"; 
			sql = sql + " round(nvl(col_real_01,0)) as col_realR_01,    \n";
			sql = sql + "   round(nvl(col_real_02,0)) as col_realR_02,    \n";
			sql = sql + "   round(nvl(col_real_03,0)) as col_realR_03,     \n";
			sql = sql + "   round(nvl(col_real_04,0)) as col_realR_04,    \n";
			sql = sql + "   round(nvl(col_real_05,0)) as col_realR_05,    \n";
			sql = sql + "   round(nvl(col_real_06,0)) as col_realR_06,    \n";
			sql = sql + " ((nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0))- nvl(matr_real_01,0)) SALDO_01,     \n";
			sql = sql + "  ((nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0))- nvl(matr_real_02,0)) SALDO_02,     \n";
			sql = sql + "   ((nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0))- nvl(matr_real_03,0)) SALDO_03,     \n";
			sql = sql + "  ((nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0))- nvl(matr_real_04,0)) SALDO_04,     \n";
			sql = sql + " ( (nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0))- nvl(matr_real_05,0)) SALDO_05,     \n";
			sql = sql + " (  (nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0))- nvl(matr_real_06,0)) SALDO_06,     \n";
			sql = sql + "   ((nvl(col_comp_01,0)+nvl(col_comp_repa_01,0))- nvl(col_real_01,0)) SALDO_07,     \n";
			sql = sql + "   ((nvl(col_comp_02,0)+nvl(col_comp_repa_02,0))- nvl(col_real_02,0)) SALDO_08,     \n";
			sql = sql + "   ((nvl(col_comp_03,0)+nvl(col_comp_repa_03,0))- nvl(col_real_03,0)) SALDO_09,     \n";
			sql = sql + "   ((nvl(col_comp_04,0)+nvl(col_comp_repa_04,0))- nvl(col_real_04,0)) SALDO_10,     \n";
			sql = sql + "   ((nvl(col_comp_05,0)+nvl(col_comp_repa_05,0))- nvl(col_real_05,0)) SALDO_11,    \n"; 
			sql = sql + "   ((nvl(col_comp_06,0)+nvl(col_comp_repa_06,0))- nvl(col_real_06,0)) SALDO_12  \n";   
			sql = sql + "  from      \n";
			sql = sql + "    (      \n";
			sql = sql + "  select distinct car.CARR_TDESC,car.CARR_CCOD, s.SEDE_TDESC, pa.PERI_TDESC      \n";
			sql = sql + "     from ofertas_academicas oo , especialidades ee, carreras car,periodos_academicos pa, sedes s  \n";      
			sql = sql + "     where oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD = nvl('" + SEDE + "',oo.SEDE_CCOD)   \n";     
			sql = sql + "     						and oo.ESPE_CCOD = ee.ESPE_CCOD        \n";
			sql = sql + "     						and ee.CARR_CCOD = car.CARR_CCOD        \n";
			sql = sql + "   						and oo.PERI_CCOD = pa.PERI_CCOD  \n";
            sql = sql + "     						and oo.SEDE_CCOD = s.SEDE_CCOD   \n";     
			sql = sql + "	 ) z,   \n";   
			sql = sql + "   (    \n";
			//sql = sql + " ------------------------------COMPROMISOS DEVOLUCION POR RETIRO --------------------------------------------------  \n";
			sql = sql + " select CARR_TDESC,CARR_CCOD,        \n";
			sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_06  \n";   
			sql = sql + "  		from (       \n";
			sql = sql + "			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
			sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
			sql = sql + "     			   from (   \n";
			sql = sql + "				   select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
			sql = sql + "     					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes  \n";   
			sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     						detalle_compromisos dc,     \n";
			sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
			sql = sql + "							where aa.emat_ccod<>9        \n";
			sql = sql + "     						and cc.CONT_NCORR =com.COMP_NDOCTO  \n";
			sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     						and cc.ECON_CCOD=1        \n";
			sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     						and com.ECOM_CCOD=1        \n";
			sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
			sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
			sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
			sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
			sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
			sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
			sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
			sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR (+)    \n";
			sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'   \n";
			//sql = sql + "							-- LINEAS PARA FILTRAR   RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21 -----  \n";   
			sql = sql + "									and ii.TING_CCOD=17  \n";
			sql = sql + "									and dii.TING_CCOD=25  \n";
			sql = sql + "     						and dc.ECOM_CCOD=1    \n";
			sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = " + ANO + "  \n";
			//sql = sql + "							--and to_char(dc.DCOM_FCOMPROMISO,'MM') = 1  \n";
			sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
			sql = sql + " 						) a         \n";
			sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
			sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "     					)         \n";
			sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";  
			sql = sql + ")a,	  \n";
			sql = sql + "   (    \n";
			//sql = sql + " ------------------------------COMPROMISOS DEVOLUCION POR RETIRO Repactaciones--------------------------------------------------  \n";
			sql = sql + "select CARR_TDESC,CARR_CCOD,        \n";
			sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_repa_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_repa_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_repa_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_repa_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_repa_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_repa_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_repa_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_repa_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_repa_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_repa_04,      \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_repa_05,   \n";  
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_repa_06  \n";   
			sql = sql + "  		from (       \n";
			sql = sql + "			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
			sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
			sql = sql + "     			   from (   \n";
			sql = sql + "				   select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
			sql = sql + "     					  aa.PERS_NCORR, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes,  \n";
			sql = sql + "						  compromiso_origen_repactacion(com.COMP_NDOCTO, 'tcom_ccod') TCOM_CCOD  \n";   
			sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     						detalle_compromisos dc,     \n";
			sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
			sql = sql + "							where aa.emat_ccod<>9        \n";
			sql = sql + "     						and cc.CONT_NCORR in (select comp_ndocto_origen  from repactaciones  \n"; 
			sql = sql + "											  	 		 where repa_ncorr = com.COMP_NDOCTO)  \n";
			sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     						and cc.ECON_CCOD=1        \n";
			sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     						and com.ECOM_CCOD=1        \n";
			sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
			sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
			sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
			sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
			sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
			sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
			sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
			sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR (+)    \n";
			sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'   \n";
			//sql = sql + "							-- LINEAS PARA FILTRAR   RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21 -----  \n";   
			sql = sql + "									and ii.TING_CCOD=17  \n";
			sql = sql + "									and dii.TING_CCOD=25  \n";
			sql = sql + "     						and dc.ECOM_CCOD=1    \n";
			sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = " + ANO + "  \n";
			//sql = sql + "							--and to_char(dc.DCOM_FCOMPROMISO,'MM') = 1  \n";
			sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.COMP_NDOCTO,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
			sql = sql + " 						) a         \n";
			sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
			sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "     					)         \n";
			sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";  
			sql = sql + ")c,  \n";	
			sql = sql + "(	  \n";
			//sql = sql + "---------------------------VALORES REALES POR RETIRO -------------------------------------------------------  \n"; 	   
			sql = sql + "  select  CARR_TDESC,CARR_CCOD,    \n";
			sql = sql + "   		sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_real_01,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_real_02,       \n";
			sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_real_03,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_real_04,      \n";
			sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_real_05,     \n";
			sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_real_06,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_real_01,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_real_02,       \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_real_03,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_real_04,   \n";   
			sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_real_05,     \n";
			sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_real_06  \n";      
			sql = sql + "      from (        \n";
			sql = sql + "     		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
			sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
			sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";      
			sql = sql + "     		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";      
			sql = sql + "     		    from (        \n";
			sql = sql + "				    select sum(ii.INGR_MTOTAL) valor_efectivo,car.CARR_CCOD,        \n";
			sql = sql + "     				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM') mes  \n";       
			sql = sql + "     					from alumnos aa, contratos cc, compromisos com,  \n";       
			sql = sql + "     					detalle_compromisos dc, abonos ab,        \n";
			sql = sql + "     					ingresos ii, tipos_ingresos tii,         \n";
			sql = sql + "     					ofertas_academicas oo , especialidades ee, carreras car  \n";
			sql = sql + "						,detalle_ingresos dii        \n";
			sql = sql + "     					where aa.emat_ccod<>9        \n";
			sql = sql + "     					and cc.CONT_NCORR=com.COMP_NDOCTO     \n";   
			sql = sql + "     					and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
			sql = sql + "     					and com.INST_CCOD=dc.INST_CCOD  \n";      
			sql = sql + "     					and oo.PERI_CCOD=" + PERIODO + "  \n";
			sql = sql + "     					and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
			sql = sql + "     					and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
			sql = sql + "     					and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
			sql = sql + "     					and ee.CARR_CCOD=car.CARR_CCOD  \n";      
			sql = sql + "     					and cc.ECON_CCOD=1        \n";
			sql = sql + "     					and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
			sql = sql + "     					and com.ECOM_CCOD=1        \n";
			sql = sql + "     					and com.COMP_NDOCTO=dc.COMP_NDOCTO        \n";
			sql = sql + "     					and dc.TCOM_CCOD=ab.TCOM_CCOD   (+)     \n";
			sql = sql + "     					and dc.INST_CCOD=ab.INST_CCOD    (+)    \n";
			sql = sql + "     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO      (+)    \n";
			sql = sql + "     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO     (+)  \n";   
			sql = sql + "     					and dc.ECOM_CCOD=1       \n";
			sql = sql + "     					and ii.EING_CCOD   (+)  =1			        \n";
			sql = sql + "  						and ab.INGR_NCORR=ii.INGR_NCORR    (+)    \n";  
			sql = sql + "						and ii.TING_CCOD=tii.TING_CCOD	 (+)   \n";
			sql = sql + "						and ii.INGR_NCORR=dii.INGR_NCORR (+)	  \n";
			sql = sql + "						and nvl(tii.TING_BREBAJE,'N') <> 'S'  \n"; 
			sql = sql + "						and tii.TING_BINGRESO_REAL = 'S'   \n";
			sql = sql + " 						and to_char(ii.INGR_FPAGO,'YYYY') = " + ANO + "  \n";
			//sql = sql + "						--- LINEAS POR RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21  \n";   
			sql = sql + "						and ii.TING_CCOD  =17  \n";
			sql = sql + "					    and dii.TING_CCOD   =25   \n";
			sql = sql + "     					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM')  \n";   
			sql = sql + "						) a         \n";
			sql = sql + "     				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD, a.mes  \n";      
			sql = sql + " 					HAVING a.mes  between " + MES_INI + " and " + MES_FIN + "  \n";
			sql = sql + "  				)         \n";
			sql = sql + "     				group by CARR_CCOD,CARR_TDESC  \n";	  
			sql = sql + "  ) b     \n";
			sql = sql + "   where       \n";
			sql = sql + "     z.CARR_CCOD=a.CARR_CCOD (+)      \n";
			sql = sql + "     and z.CARR_CCOD=b.CARR_CCOD  (+)    \n";  
			sql = sql + "	 and z.CARR_CCOD=c.CARR_CCOD  (+)  \n";    
			sql = sql + ")  \n";

			return (sql);
		}


	 string Generar_SQL_CONDONACIONES(string FILA, int N_INFORME, int MES_INI, int MES_FIN, string PERIODO, string SEDE, string ANO)
	 {                
		 string sql = "";
		 sql = sql + "  select '" + FILA + "' as fila, nro_informe, CARR_TDESC, CARR_CCOD, SEDE_TDESC, ano,  \n";   
		 sql = sql + "       periodo, fecha_inicio, fecha_termino,  \n";
		 sql = sql + "	   MATR_COMPR_01 + col_COMPR_01 as COMPR_01,  \n";
		 sql = sql + "	   MATR_COMPR_02 + col_COMPR_02 as COMPR_02,  \n";
		 sql = sql + "	   MATR_COMPR_03 + col_COMPR_03 as COMPR_03,  \n";
		 sql = sql + "	   MATR_COMPR_04 + col_COMPR_04 as COMPR_04,  \n";
		 sql = sql + "	   MATR_COMPR_05 + col_COMPR_05 as COMPR_05,  \n";
		 sql = sql + "	   MATR_COMPR_06 + col_COMPR_06 as COMPR_06,  \n";
		 sql = sql + "    MATR_realR_01 + col_realR_01 as REAL_01,  \n";
		 sql = sql + "	MATR_realR_02 + col_realR_02 as REAL_02,  \n";
		 sql = sql + "	MATR_realR_03 + col_realR_03 as REAL_03,  \n";
		 sql = sql + "	MATR_realR_04 + col_realR_04 as REAL_04,  \n";
		 sql = sql + "	MATR_realR_05 + col_realR_05 as REAL_05,  \n";
		 sql = sql + "	MATR_realR_06 + col_realR_06 as REAL_06,  \n";
		 sql = sql + "	  ((MATR_COMPR_01 + col_COMPR_01)  -  (MATR_realR_01 + col_realR_01)) as  SALDO_01,  \n";
		 sql = sql + "	  ((MATR_COMPR_02 + col_COMPR_02)  -  (MATR_realR_02 + col_realR_02)) as  SALDO_02,  \n";
		 sql = sql + "  	  ((MATR_COMPR_03 + col_COMPR_03)  -  (MATR_realR_03 + col_realR_03)) as  SALDO_03,  \n";
		 sql = sql + "	  ((MATR_COMPR_04 + col_COMPR_04)  -  (MATR_realR_04 + col_realR_04)) as  SALDO_04,  \n";
		 sql = sql + "	  ((MATR_COMPR_05 + col_COMPR_05)  -  (MATR_realR_05 + col_realR_05)) as  SALDO_05,  \n";
		 sql = sql + "	  ((MATR_COMPR_06 + col_COMPR_06)  -  (MATR_realR_06 + col_realR_06)) as  SALDO_06  \n";
		 sql = sql + "from (  \n";
		 sql = sql + "select " + N_INFORME + " as nro_informe, z.CARR_TDESC,z.CARR_CCOD,z.SEDE_TDESC, " + ANO + " ano,  \n";   
		 sql = sql + " z.PERI_TDESC  periodo, '' fecha_inicio, '' fecha_termino,  \n";
		 sql = sql + "round(nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0)) as MATR_COMPR_01,    \n";
		 sql = sql + "   round(nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0)) as MATR_COMPR_02,    \n";
		 sql = sql + "   round(nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0)) as MATR_COMPR_03,     \n";
		 sql = sql + "   round(nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0)) as MATR_COMPR_04,    \n";
		 sql = sql + "   round(nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0)) as MATR_COMPR_05,    \n";
		 sql = sql + "   round(nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0)) as MATR_COMPR_06,  \n";  
		 sql = sql + " round(nvl(col_comp_01,0)+nvl(col_comp_repa_01,0)) as col_COMPR_01,    \n";
		 sql = sql + "   round(nvl(col_comp_02,0)+nvl(col_comp_repa_02,0)) as col_COMPR_02,    \n";
		 sql = sql + "   round(nvl(col_comp_03,0)+nvl(col_comp_repa_03,0)) as col_COMPR_03,     \n";
		 sql = sql + "   round(nvl(col_comp_04,0)+nvl(col_comp_repa_04,0)) as col_COMPR_04,    \n";
		 sql = sql + "   round(nvl(col_comp_05,0)+nvl(col_comp_repa_05,0)) as col_COMPR_05,    \n";
		 sql = sql + "   round(nvl(col_comp_06,0)+nvl(col_comp_repa_06,0)) as col_COMPR_06,  \n";  
		 sql = sql + " round(nvl(matr_real_01,0)) as MATR_realR_01,    \n";
		 sql = sql + "   round(nvl(matr_real_02,0)) as MATR_realR_02,    \n";
		 sql = sql + "   round(nvl(matr_real_03,0)) as MATR_realR_03,     \n";
		 sql = sql + "   round(nvl(matr_real_04,0)) as MATR_realR_04,    \n";
		 sql = sql + "   round(nvl(matr_real_05,0)) as MATR_realR_05,    \n";
		 sql = sql + "   round(nvl(matr_real_06,0)) as MATR_realR_06,   \n"; 
		 sql = sql + " round(nvl(col_real_01,0)) as col_realR_01,    \n";
		 sql = sql + "   round(nvl(col_real_02,0)) as col_realR_02,    \n";
		 sql = sql + "   round(nvl(col_real_03,0)) as col_realR_03,     \n";
		 sql = sql + "   round(nvl(col_real_04,0)) as col_realR_04,    \n";
		 sql = sql + "   round(nvl(col_real_05,0)) as col_realR_05,    \n";
		 sql = sql + "   round(nvl(col_real_06,0)) as col_realR_06,    \n";
		 sql = sql + " ((nvl(matr_comp_01,0)+nvl(matr_comp_repa_01,0))- nvl(matr_real_01,0)) SALDO_01,     \n";
		 sql = sql + "  ((nvl(matr_comp_02,0)+nvl(matr_comp_repa_02,0))- nvl(matr_real_02,0)) SALDO_02,     \n";
		 sql = sql + "   ((nvl(matr_comp_03,0)+nvl(matr_comp_repa_03,0))- nvl(matr_real_03,0)) SALDO_03,     \n";
		 sql = sql + "  ((nvl(matr_comp_04,0)+nvl(matr_comp_repa_04,0))- nvl(matr_real_04,0)) SALDO_04,     \n";
		 sql = sql + " ( (nvl(matr_comp_05,0)+nvl(matr_comp_repa_05,0))- nvl(matr_real_05,0)) SALDO_05,     \n";
		 sql = sql + " (  (nvl(matr_comp_06,0)+nvl(matr_comp_repa_06,0))- nvl(matr_real_06,0)) SALDO_06,     \n";
		 sql = sql + "   ((nvl(col_comp_01,0)+nvl(col_comp_repa_01,0))- nvl(col_real_01,0)) SALDO_07,     \n";
		 sql = sql + "   ((nvl(col_comp_02,0)+nvl(col_comp_repa_02,0))- nvl(col_real_02,0)) SALDO_08,     \n";
		 sql = sql + "   ((nvl(col_comp_03,0)+nvl(col_comp_repa_03,0))- nvl(col_real_03,0)) SALDO_09,     \n";
		 sql = sql + "   ((nvl(col_comp_04,0)+nvl(col_comp_repa_04,0))- nvl(col_real_04,0)) SALDO_10,     \n";
		 sql = sql + "   ((nvl(col_comp_05,0)+nvl(col_comp_repa_05,0))- nvl(col_real_05,0)) SALDO_11,    \n"; 
		 sql = sql + "   ((nvl(col_comp_06,0)+nvl(col_comp_repa_06,0))- nvl(col_real_06,0)) SALDO_12  \n";   
		 sql = sql + "  from      \n";
		 sql = sql + "    (      \n";
		 sql = sql + "  select distinct car.CARR_TDESC,car.CARR_CCOD, s.SEDE_TDESC, pa.PERI_TDESC      \n";
		 sql = sql + "     from ofertas_academicas oo , especialidades ee, carreras car,periodos_academicos pa, sedes s  \n";      
		 sql = sql + "     where oo.PERI_CCOD=" + PERIODO + "  \n";
		 sql = sql + "     						and oo.SEDE_CCOD = nvl('" + SEDE + "',oo.SEDE_CCOD)   \n";     
		 sql = sql + "     						and oo.ESPE_CCOD = ee.ESPE_CCOD        \n";
		 sql = sql + "     						and ee.CARR_CCOD = car.CARR_CCOD    \n";    
		 sql = sql + "   						and oo.PERI_CCOD = pa.PERI_CCOD  \n";
		 sql = sql + "     						and oo.SEDE_CCOD = s.SEDE_CCOD   \n";   
		 sql = sql + "	 ) z,   \n";   
		 sql = sql + "   (    \n";
		 //sql = sql + " ------------------------------COMPROMISOS DEVOLUCION POR RETIRO --------------------------------------------------  \n";
		 sql = sql + " select CARR_TDESC,CARR_CCOD,        \n";
		 sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_01,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_02,       \n";
		 sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_03,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_04,      \n";
		 sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_05,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_06,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_01,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_02,       \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_03,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_04,      \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_05,   \n";  
		 sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_06  \n";   
		 sql = sql + "  		from (       \n";
		 sql = sql + "			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
		 sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
		 sql = sql + "     			   from (   \n";
		 sql = sql + "				   select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
		 sql = sql + "     					  aa.PERS_NCORR,com.TCOM_CCOD, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes  \n";   
		 sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
		 sql = sql + "     						detalle_compromisos dc,     \n";
		 sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
		 sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
		 sql = sql + "							where aa.emat_ccod<>9        \n";
		 sql = sql + "     						and cc.CONT_NCORR =com.COMP_NDOCTO  \n";
		 sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD     \n";   
		 sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
		 sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
		 sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
		 sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
		 sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
		 sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
		 sql = sql + "     						and cc.ECON_CCOD=1        \n";
		 sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
		 sql = sql + "     						and com.ECOM_CCOD=1        \n";
		 sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
		 sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
		 sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
		 sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
		 sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
		 sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
		 sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
		 sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR (+)    \n";
		 sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'   \n";
		// sql = sql + "							-- LINEAS PARA FILTRAR   RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21 -----  \n";   
		 sql = sql + "									and ii.TING_CCOD=17  \n";
		 sql = sql + "									and dii.TING_CCOD=21  \n";
		 sql = sql + "     						and dc.ECOM_CCOD=1    \n";
		 sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = " + ANO + "  \n";
		// sql = sql + "							--and to_char(dc.DCOM_FCOMPROMISO,'MM') = 1  \n";
		 sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
		 sql = sql + " 						) a         \n";
		 sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes  \n";  
		 sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
		 sql = sql + "     					)         \n";
		 sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";  
		 sql = sql + ")a,  \n";	
		 sql = sql + "   (    \n";
		// sql = sql + " ------------------------------COMPROMISOS DEVOLUCION POR RETIRO Repactaciones--------------------------------------------------  \n";
		 sql = sql + "select CARR_TDESC,CARR_CCOD,        \n";
		 sql = sql + "     	sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_comp_repa_01,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_comp_repa_02,       \n";
		 sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_comp_repa_03,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_comp_repa_04,      \n";
		 sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_comp_repa_05,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_comp_repa_06,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_comp_repa_01,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_comp_repa_02,       \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_comp_repa_03,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_comp_repa_04,      \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_comp_repa_05,   \n";  
		 sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_comp_repa_06  \n";   
		 sql = sql + "  		from (       \n";
		 sql = sql + "			 select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";       
		 sql = sql + "     					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";     
		 sql = sql + "     			   from (   \n";
		 sql = sql + "				   select sum(dc.DCOM_MCOMPROMISO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  \n";       
		 sql = sql + "     					  aa.PERS_NCORR, to_char(dc.DCOM_FCOMPROMISO, 'MM') mes,  \n";
		 sql = sql + "						  compromiso_origen_repactacion(com.COMP_NDOCTO, 'tcom_ccod') TCOM_CCOD  \n";   
		 sql = sql + "     						from alumnos aa, contratos cc, compromisos com,  \n";       
		 sql = sql + "     						detalle_compromisos dc,     \n";
		 sql = sql + "     						ofertas_academicas oo , especialidades ee, carreras car  \n";
		 sql = sql + "							,ingresos ii, detalle_ingresos dii, abonos ab, tipos_ingresos tii  \n";    
		 sql = sql + "							where aa.emat_ccod<>9        \n";
		 sql = sql + "     						and cc.CONT_NCORR in (select comp_ndocto_origen  from repactaciones  \n"; 
		 sql = sql + "											  	 		 where repa_ncorr = com.COMP_NDOCTO)  \n";
		 sql = sql + "     						and com.TCOM_CCOD=dc.TCOM_CCOD   \n";     
		 sql = sql + "     						and com.INST_CCOD=dc.INST_CCOD  \n";      
		 sql = sql + "     						and oo.PERI_CCOD=" + PERIODO + "  \n";
		 sql = sql + "     						and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD)    \n";    
		 sql = sql + "     						and aa.OFER_NCORR=oo.OFER_NCORR       \n"; 
		 sql = sql + "     						and oo.ESPE_CCOD=ee.ESPE_CCOD      \n";  
		 sql = sql + "     						and ee.CARR_CCOD=car.CARR_CCOD  \n";      
		 sql = sql + "     						and cc.ECON_CCOD=1        \n";
		 sql = sql + "     						and aa.MATR_NCORR=cc.MATR_NCORR  \n";      
		 sql = sql + "     						and com.ECOM_CCOD=1        \n";
		 sql = sql + "     						and com.COMP_NDOCTO=dc.COMP_NDOCTO     \n";
		 sql = sql + "							and dc.TCOM_CCOD=ab.TCOM_CCOD  (+)      \n";
		 sql = sql + "	     					and dc.INST_CCOD=ab.INST_CCOD   (+)       \n";
		 sql = sql + "	     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO (+)         \n";
		 sql = sql + "	     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO (+)  \n";     
		 sql = sql + "	     					and ab.INGR_NCORR =ii.INGR_NCORR (+)      \n";   
		 sql = sql + "							and ii.TING_CCOD =tii.TING_CCOD	(+)    \n";
		 sql = sql + "							and ii.INGR_NCORR  =dii.INGR_NCORR (+)    \n";
		 sql = sql + "							and nvl(tii.TING_BREBAJE,'N') <> 'S'   \n";
		 //sql = sql + "							-- LINEAS PARA FILTRAR   RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21 -----  \n";   
		 sql = sql + "									and ii.TING_CCOD=17  \n";
		 sql = sql + "									and dii.TING_CCOD=21  \n";
		 sql = sql + "     						and dc.ECOM_CCOD=1    \n";
		 sql = sql + " 							and to_char(dc.DCOM_FCOMPROMISO,'YYYY') = " + ANO + "  \n";
		// sql = sql + "							--and to_char(dc.DCOM_FCOMPROMISO,'MM') = 1  \n";
		 sql = sql + "							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.COMP_NDOCTO,to_char(dc.DCOM_FCOMPROMISO, 'MM')  \n";   
		 sql = sql + " 						) a         \n";
		 sql = sql + "     					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ,a.mes \n";  
			 sql = sql + "						HAVING a.mes between " + MES_INI + " and " + MES_FIN + "  \n";
		 sql = sql + "     					)         \n";
		 sql = sql + "     					group by CARR_CCOD,CARR_TDESC  \n";  
		 sql = sql + ")c,	  \n";
		 sql = sql + "(	  \n";
		// sql = sql + "---------------------------VALORES REALES POR RETIRO -------------------------------------------------------  \n"; 	   
		 sql = sql + "  select  CARR_TDESC,CARR_CCOD,    \n";
		 sql = sql + "   		sum(nvl(MATRICULA_01,0) + nvl(MATRICULA_07,0)) matr_real_01,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_02,0) + nvl(MATRICULA_08,0)) matr_real_02,       \n";
		 sql = sql + "  		sum(nvl(MATRICULA_03,0) + nvl( MATRICULA_09,0)) matr_real_03,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_04,0) +  nvl(MATRICULA_10,0)) matr_real_04,      \n";
		 sql = sql + "  		sum(nvl(MATRICULA_05,0) + nvl(MATRICULA_11,0)) matr_real_05,     \n";
		 sql = sql + "  		sum(nvl(MATRICULA_06,0) + nvl(MATRICULA_12,0)) matr_real_06,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_01,0) + nvl(COLEGIATURA_07,0)) col_real_01,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_02,0) + nvl(COLEGIATURA_08,0)) col_real_02,       \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_03,0)+ nvl(COLEGIATURA_09,0)) col_real_03,     \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_04,0) + nvl(COLEGIATURA_10,0)) col_real_04,      \n";
		 sql = sql + "  		sum(nvl(COLEGIATURA_05,0) + nvl(COLEGIATURA_11,0)) col_real_05,   \n";  
		 sql = sql + "  		sum(nvl(COLEGIATURA_06,0)+ nvl(COLEGIATURA_12,0)) col_real_06  \n";      
		 sql = sql + "      from (        \n";
		 sql = sql + "     		   select CASE WHEN (a.TCOM_CCOD=1 and a.mes='01' ) THEN a.valor_efectivo end MATRICULA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='02' ) THEN a.valor_efectivo end MATRICULA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='03' ) THEN a.valor_efectivo end MATRICULA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='04' ) THEN a.valor_efectivo end MATRICULA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='05' ) THEN a.valor_efectivo end MATRICULA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='06' ) THEN a.valor_efectivo end MATRICULA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='07' ) THEN a.valor_efectivo end MATRICULA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='08' ) THEN a.valor_efectivo end MATRICULA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='09' ) THEN a.valor_efectivo end MATRICULA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='10' ) THEN a.valor_efectivo end MATRICULA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=1 and a.mes='11' ) THEN a.valor_efectivo end MATRICULA_11,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=1 and a.mes='12' ) THEN a.valor_efectivo end MATRICULA_12,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='01' ) THEN a.valor_efectivo end COLEGIATURA_01,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='02' ) THEN a.valor_efectivo end COLEGIATURA_02,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='03' ) THEN a.valor_efectivo end COLEGIATURA_03,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='04' ) THEN a.valor_efectivo end COLEGIATURA_04,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='05' ) THEN a.valor_efectivo end COLEGIATURA_05,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='06' ) THEN a.valor_efectivo end COLEGIATURA_06,    \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='07' ) THEN a.valor_efectivo end COLEGIATURA_07,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='08' ) THEN a.valor_efectivo end COLEGIATURA_08,     \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='09' ) THEN a.valor_efectivo end COLEGIATURA_09,      \n";
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='10' ) THEN a.valor_efectivo end COLEGIATURA_10,      \n";
		 sql = sql + "  			   		  CASE WHEN (a.TCOM_CCOD=2 and a.mes='11' ) THEN a.valor_efectivo end COLEGIATURA_11,    \n"; 
		 sql = sql + "  					  CASE WHEN (a.TCOM_CCOD=2 and a.mes='12' ) THEN a.valor_efectivo end COLEGIATURA_12,  \n";      
		 sql = sql + "     		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  \n";      
		 sql = sql + "     		    from (        \n";
		 sql = sql + "				    select sum(ii.INGR_MTOTAL) valor_efectivo,car.CARR_CCOD,        \n";
		 sql = sql + "     				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM') mes  \n";       
		 sql = sql + "     					from alumnos aa, contratos cc, compromisos com,  \n";       
		 sql = sql + "     					detalle_compromisos dc, abonos ab,        \n";
		 sql = sql + "     					ingresos ii, tipos_ingresos tii,        \n";
		 sql = sql + "     					ofertas_academicas oo , especialidades ee, carreras car \n";
		 sql = sql + "						,detalle_ingresos dii       \n";
		 sql = sql + "     					where aa.emat_ccod<>9       \n";
		 sql = sql + "     					and cc.CONT_NCORR=com.COMP_NDOCTO  \n";     
		 sql = sql + "     					and com.TCOM_CCOD=dc.TCOM_CCOD   \n";    
		 sql = sql + "     					and com.INST_CCOD=dc.INST_CCOD \n";      
		 sql = sql + "     					and oo.PERI_CCOD=" + PERIODO + " \n";
		 sql = sql + "     					and oo.SEDE_CCOD=nvl('" + SEDE + "',oo.SEDE_CCOD) \n";      
		 sql = sql + "     					and aa.OFER_NCORR=oo.OFER_NCORR    \n";   
		 sql = sql + "     					and oo.ESPE_CCOD=ee.ESPE_CCOD    \n";   
		 sql = sql + "     					and ee.CARR_CCOD=car.CARR_CCOD \n";      
		 sql = sql + "     					and cc.ECON_CCOD=1       \n";
		 sql = sql + "     					and aa.MATR_NCORR=cc.MATR_NCORR \n";      
		 sql = sql + "     					and com.ECOM_CCOD=1       \n";
		 sql = sql + "     					and com.COMP_NDOCTO=dc.COMP_NDOCTO       \n";
		 sql = sql + "     					and dc.TCOM_CCOD=ab.TCOM_CCOD   (+)    \n";
		 sql = sql + "     					and dc.INST_CCOD=ab.INST_CCOD    (+)   \n";
		 sql = sql + "     					and dc.COMP_NDOCTO=ab.COMP_NDOCTO      (+)   \n";
		 sql = sql + "     					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO     (+) \n";   
		 sql = sql + "     					and dc.ECOM_CCOD=1      \n";
		 sql = sql + "     					and ii.EING_CCOD   (+)  =1			      \n"; 
		 sql = sql + "  						and ab.INGR_NCORR=ii.INGR_NCORR    (+)  \n";   
		 sql = sql + "						and ii.TING_CCOD=tii.TING_CCOD	 (+)  \n";
		 sql = sql + "						and ii.INGR_NCORR=dii.INGR_NCORR (+)	 \n";
		 sql = sql + "						and nvl(tii.TING_BREBAJE,'N') <> 'S' \n"; 
		 sql = sql + "						and tii.TING_BINGRESO_REAL = 'S'  \n";
		 sql = sql + " 						and to_char(ii.INGR_FPAGO,'YYYY') = " + ANO + " \n";
		// sql = sql + "						--- LINEAS POR RETIRO EN CASO DE DEVOLUCION dii.TING_CCOD = 21 \n";   
		 sql = sql + "						and ii.TING_CCOD  =17 \n";
		 sql = sql + "					    and dii.TING_CCOD   =21  \n";
		 sql = sql + "     					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,to_char(ii.INGR_FPAGO, 'MM') \n";   
		 sql = sql + "						) a        \n";
		 sql = sql + "     				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD, a.mes \n";      
		 sql = sql + " 					HAVING a.mes  between " + MES_INI + " and " + MES_FIN + " \n";
		 sql = sql + "  				)        \n";
		 sql = sql + "     				group by CARR_CCOD,CARR_TDESC \n";	  
		 sql = sql + "  ) b    \n";
		 sql = sql + "   where      \n";
		 sql = sql + "     z.CARR_CCOD=a.CARR_CCOD (+)     \n";
		 sql = sql + "     and z.CARR_CCOD=b.CARR_CCOD  (+)  \n";   
		 sql = sql + "	 and z.CARR_CCOD=c.CARR_CCOD  (+) \n";    
		 sql = sql + ") \n";

		 return (sql);
	 }		

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			int informe;
			string sql = "", periodo="160", Sede="1", ano="2004", tipo_informe="";

			periodo = Request.QueryString["periodo"];
			ano= Request.QueryString["ano"];
			tipo_informe=Request.QueryString["tipodoc"];
			Sede = Request.QueryString["sede_ccod"];

			CrystalReport1 reporte = new CrystalReport1();
			for (informe = 1; informe < 3; informe++)
			{				
				if (informe == 1)
				{
					sql =       "SELECT * FROM \n";
					sql = sql + " ( (\n";
					sql = sql +       Generar_SQL_INGRESOS("Ingresos", informe,1,6,periodo,Sede,ano);
					sql = sql + " ) UNION ALL ( \n";
					sql = sql +       Generar_SQL_RETIROS("Retiros", informe,1,6,periodo,Sede,ano);
					sql = sql + "     ) \n";
					sql = sql + "  UNION ALL  ( \n";
                    sql = sql +       Generar_SQL_CONDONACIONES("Condonaciones", informe,1,6,periodo,Sede,ano);					
					sql = sql + "     ) \n";
					sql = sql + " ) \n";
					//Response.Write("<PRE>" + sql + "</PRE>");
					//Response.End();					
				}
				else
				{	
					sql =       "SELECT * FROM \n";
					sql = sql + " ( (\n";
					sql = sql +       Generar_SQL_INGRESOS("Ingresos", informe,7,12,periodo,Sede,ano);					
					sql = sql + " ) UNION ALL ( \n";
					sql = sql +       Generar_SQL_RETIROS("Retiros", informe,7,12,periodo,Sede,ano);					
					sql = sql + "     ) \n";
					sql = sql + "  UNION ALL  ( \n";
					sql = sql +       Generar_SQL_CONDONACIONES("Condonaciones",informe,7,12,periodo,Sede,ano);					
					sql = sql + "     ) \n";
					sql = sql + " ) \n";	
				}				
				DataAdapter.SelectCommand.CommandText = sql;
				DataAdapter.Fill(dataSet11);
			}
			
			reporte.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = reporte;
            
			if (tipo_informe == "1")
			  ExportarPDF(reporte);			
			else
              ExportarEXCEL(reporte);			
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
			this.DataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.ConeccionBD = new System.Data.OleDb.OleDbConnection();
			this.dataSet11 = new Pres_resumen.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// DataAdapter
			// 
			this.DataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "T_Datos", new System.Data.Common.DataColumnMapping[] {
																																																			 new System.Data.Common.DataColumnMapping("FILA", "FILA"),
																																																			 new System.Data.Common.DataColumnMapping("NRO_INFORME", "NRO_INFORME"),
																																																			 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																			 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																			 new System.Data.Common.DataColumnMapping("ANO", "ANO"),
																																																			 new System.Data.Common.DataColumnMapping("PERIODO", "PERIODO"),
																																																			 new System.Data.Common.DataColumnMapping("FECHA_INICIO", "FECHA_INICIO"),
																																																			 new System.Data.Common.DataColumnMapping("FECHA_TERMINO", "FECHA_TERMINO"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_01", "COMPR_01"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_02", "COMPR_02"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_03", "COMPR_03"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_04", "COMPR_04"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_05", "COMPR_05"),
																																																			 new System.Data.Common.DataColumnMapping("COMPR_06", "COMPR_06"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_01", "REAL_01"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_02", "REAL_02"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_03", "REAL_03"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_04", "REAL_04"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_05", "REAL_05"),
																																																			 new System.Data.Common.DataColumnMapping("REAL_06", "REAL_06"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_01", "SALDO_01"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_02", "SALDO_02"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_03", "SALDO_03"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_04", "SALDO_04"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_05", "SALDO_05"),
																																																			 new System.Data.Common.DataColumnMapping("SALDO_06", "SALDO_06")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS FILA, '' AS NRO_INFORME, '' AS CARR_TDESC, '' AS CARR_CCOD, '' AS SEDE_TDESC, '' AS ANO, '' AS PERIODO, '' AS FECHA_INICIO, '' AS FECHA_TERMINO, '' AS COMPR_01, '' AS COMPR_02, '' AS COMPR_03, '' AS COMPR_04, '' AS COMPR_05, '' AS COMPR_06, '' AS REAL_01, '' AS REAL_02, '' AS REAL_03, '' AS REAL_04, '' AS REAL_05, '' AS REAL_06, '' AS SALDO_01, '' AS SALDO_02, '' AS SALDO_03, '' AS SALDO_04, '' AS SALDO_05, '' AS SALDO_06 FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.ConeccionBD;
			// 
			// ConeccionBD
			// 
			this.ConeccionBD.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
