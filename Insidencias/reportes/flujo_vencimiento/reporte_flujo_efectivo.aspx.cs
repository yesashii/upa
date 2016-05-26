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


namespace flujo_vencimiento
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
		protected flujo_vencimiento.FlujoEfectivo flujoEfectivo1;
	  

		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			//ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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

		private string EscribirCodigo()
		{
			string sql;
		    
			sql =  " select * from  ";
			sql = sql + " 	(--------TOTALES LETRAS, CHEQUE ALUMNOS VIEJOS ------------------------- ";
			sql = sql + " 	select CARR_TDESC,CARR_CCOD,sum(CHEQUE) total_cheque_a,sum(LETRA) total_letra_a  ";
			sql = sql + " 	from ( ";
			sql = sql + " 			   select DECODE( a.TING_CCOD,3,a.valor_efectivo) CHEQUE, ";
			sql = sql + " 			   		  DECODE( a.TING_CCOD,4,a.valor_efectivo) LETRA, ";
			sql = sql + " 			    	  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD  ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, ";
			sql = sql + " 					  		  aa.PERS_NCORR,dii.TING_CCOD ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii,detalle_ingresos dii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						and com.TCOM_CCOD in (1,2) ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						--and ii.EING_CCOD<>3	 ";
			sql = sql + " 						and ii.EING_CCOD=4	 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO=0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						and ii.INGR_NCORR=dii.INGR_NCORR ";
			sql = sql + " 						and dii.DING_NCORRELATIVO=1 ";
			sql = sql + " 						and dii.DING_BPACTA_CUOTA='S' ";
			sql = sql + " 						and trunc(dii.DING_FDOCTO) between nvl('01/12/2003',dii.DING_FDOCTO)  ";
			sql = sql + " 						and nvl('01/02/2004',dii.DING_FDOCTO) ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,dii.TING_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	)a, ";
			sql = sql + " 	(--------TOTALES LETRAS, CHEQUE ALUMNOS NUEVOS ------------------------- ";
			sql = sql + " 	select CARR_CCOD,sum(CHEQUE) total_cheque_n,sum(LETRA) total_letra_n  ";
			sql = sql + " 	from ( ";
			sql = sql + " 			   select DECODE( a.TING_CCOD,3,a.valor_efectivo) CHEQUE, ";
			sql = sql + " 			   		  DECODE( a.TING_CCOD,4,a.valor_efectivo) LETRA, ";
			sql = sql + " 			    	  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD  ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, ";
			sql = sql + " 					  		  aa.PERS_NCORR,dii.TING_CCOD ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii,detalle_ingresos dii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						and com.TCOM_CCOD in (1,2) ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						--and ii.EING_CCOD<>3	 ";
			sql = sql + " 						and ii.EING_CCOD=4		 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO=0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						and ii.INGR_NCORR=dii.INGR_NCORR ";
			sql = sql + " 						and dii.DING_NCORRELATIVO=1 ";
			sql = sql + " 						and dii.DING_BPACTA_CUOTA='S' ";
			sql = sql + " 						and trunc(dii.DING_FDOCTO) between nvl('01/12/2003',dii.DING_FDOCTO)  ";
			sql = sql + " 						and nvl('01/02/2004',dii.DING_FDOCTO) ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,dii.TING_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	)b, ";
			sql = sql + " 	(-------total efectivo antiguo ------------------------ ";
			sql = sql + " 	select sum(total_alumno) efectivo_a,CARR_CCOD  from ( ";
			sql = sql + " 			   select a.valor_efectivo as total_alumno, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR from ( ";
			sql = sql + " 			   		  select sum(ii.INGR_MEFECTIVO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, aa.PERS_NCORR ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						and com.TCOM_CCOD in (1,2) ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						and trunc(dc.DCOM_FCOMPROMISO) between nvl('01/12/2003',dc.DCOM_FCOMPROMISO)  ";
			sql = sql + " 						and nvl('01/02/2004',dc.DCOM_FCOMPROMISO) ";
			sql = sql + " 						--and ii.EING_CCOD<>3 ";
			sql = sql + " 						and ii.EING_CCOD=1		 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO <>0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR, a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	)c, ";
			sql = sql + " 	(------------total efectivo nuevo ------------------------------- ";
			sql = sql + " 	select sum(total_alumno) efectivo_n, CARR_CCOD from ( ";
			sql = sql + " 			   select a.valor_efectivo as total_alumno, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR from ( ";
			sql = sql + " 			   		  select sum(ii.INGR_MEFECTIVO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, aa.PERS_NCORR ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						and com.TCOM_CCOD in (1,2) ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						and trunc(dc.DCOM_FCOMPROMISO) between nvl('01/12/2003',dc.DCOM_FCOMPROMISO)  ";
			sql = sql + " 						and nvl('01/02/2004',dc.DCOM_FCOMPROMISO) ";
			sql = sql + " 						--and ii.EING_CCOD<>3	 ";
			sql = sql + " 						and ii.EING_CCOD=1		 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO <>0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR, a.CARR_CCOD)= 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	)d, ";
			sql = sql + " 	(---------TOTALES BECAS, CREDITOS, DESCUENTOS, ALUMNOS ANTIGUOS ----------------- ";
			sql = sql + " 	select CARR_CCOD,sum(credito) total_credito_a, sum(beca) total_beca_a, sum(descuento) total_descuento_a  ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   select DECODE(a.TBEN_CCOD,1,a.valor_efectivo) CREDITO, ";
			sql = sql + " 		       		  DECODE(a.TBEN_CCOD,2,a.valor_efectivo) BECA, ";
			sql = sql + " 			   		  DECODE(a.TBEN_CCOD,3,a.valor_efectivo) DESCUENTO ,  ";
			sql = sql + " 					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TBEN_CCOD  ";
			sql = sql + " 					  from ( ";
			sql = sql + " 			   		  select sum(DECODE(be.MONE_CCOD,2, ";
			sql = sql + " 					  		 			round(be.BENE_MMONTO_ACUM_COLEGIATURA*ufom.UFOM_MVALOR),1, ";
			sql = sql + " 										be.BENE_MMONTO_ACUM_COLEGIATURA))+ ";
			sql = sql + " 							sum(DECODE(be.MONE_CCOD,2, ";
			sql = sql + " 									   round(be.BENE_MMONTO_ACUM_MATRICULA*ufom.UFOM_MVALOR),1, ";
			sql = sql + " 									   be.BENE_MMONTO_ACUM_MATRICULA))  		  		    ";
			sql = sql + " 						    valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, aa.PERS_NCORR,tb.TBEN_CCOD ";
			sql = sql + " 							from alumnos aa, contratos cc,  ";
			sql = sql + " 							beneficios be,stipos_descuentos std, tipos_beneficios tb,  ";
			sql = sql + " 							ofertas_academicas oo , especialidades ee, carreras car, uf ufom ";
			sql = sql + " 							where aa.emat_ccod<>9 ";
			sql = sql + " 							and oo.PERI_CCOD=160 ";
			sql = sql + " 							and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 							and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 							and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 							and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 							and cc.ECON_CCOD=1 ";
			sql = sql + " 							and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 							and be.EBEN_CCOD=1 ";
			sql = sql + " 							and be.CONT_NCORR=cc.CONT_NCORR ";
			sql = sql + " 							and trunc(be.BENE_FBENEFICIO) between nvl('01/12/2003',be.BENE_FBENEFICIO) ";
			sql = sql + " 							and nvl('01/02/2004',be.BENE_FBENEFICIO) ";
			sql = sql + " 							and be.STDE_CCOD =std.STDE_CCOD ";
			sql = sql + " 							and std.TBEN_CCOD=tb.TBEN_CCOD ";
			sql = sql + " 							--and tb.TBEN_CCOD=1 ";
			sql = sql + " 							and be.UFOM_NCORR=ufom.UFOM_NCORR (+) ";
			sql = sql + " 							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,tb.TBEN_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR, a.TBEN_CCOD ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	) e,		 ";
			sql = sql + " 	(---------TOTALES BECAS, CREDITOS, DESCUENTOS, ALUMNOS NUEVOS ----------------- ";
			sql = sql + " 	select CARR_CCOD,sum(credito) total_credito_n, sum(beca) total_beca_n, sum(descuento) total_descuento_n ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   select DECODE(a.TBEN_CCOD,1,a.valor_efectivo) CREDITO, ";
			sql = sql + " 		       		  DECODE(a.TBEN_CCOD,2,a.valor_efectivo) BECA, ";
			sql = sql + " 			   		  DECODE(a.TBEN_CCOD,3,a.valor_efectivo) DESCUENTO ,  ";
			sql = sql + " 					  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TBEN_CCOD  ";
			sql = sql + " 					  from ( ";
			sql = sql + " 			   		  select sum(DECODE(be.MONE_CCOD,2, ";
			sql = sql + " 					  		 			round(be.BENE_MMONTO_ACUM_COLEGIATURA*ufom.UFOM_MVALOR),1, ";
			sql = sql + " 										be.BENE_MMONTO_ACUM_COLEGIATURA))+ ";
			sql = sql + " 							sum(DECODE(be.MONE_CCOD,2, ";
			sql = sql + " 									   round(be.BENE_MMONTO_ACUM_MATRICULA*ufom.UFOM_MVALOR),1, ";
			sql = sql + " 									   be.BENE_MMONTO_ACUM_MATRICULA))  		  		    ";
			sql = sql + " 						    valor_efectivo,car.CARR_CCOD, car.CARR_TDESC, aa.PERS_NCORR,tb.TBEN_CCOD ";
			sql = sql + " 							from alumnos aa, contratos cc,  ";
			sql = sql + " 							beneficios be,stipos_descuentos std, tipos_beneficios tb,  ";
			sql = sql + " 							ofertas_academicas oo , especialidades ee, carreras car, uf ufom ";
			sql = sql + " 							where aa.emat_ccod<>9 ";
			sql = sql + " 							and oo.PERI_CCOD=160 ";
			sql = sql + " 							and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 							and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 							and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 							and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 							and cc.ECON_CCOD=1 ";
			sql = sql + " 							and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 							and be.EBEN_CCOD=1 ";
			sql = sql + " 							and be.CONT_NCORR=cc.CONT_NCORR ";
			sql = sql + " 							and trunc(be.BENE_FBENEFICIO) between nvl('01/12/2003',be.BENE_FBENEFICIO) ";
			sql = sql + " 							and nvl('01/02/2004',be.BENE_FBENEFICIO) ";
			sql = sql + " 							and be.STDE_CCOD =std.STDE_CCOD ";
			sql = sql + " 							and std.TBEN_CCOD=tb.TBEN_CCOD ";
			sql = sql + " 							--and tb.TBEN_CCOD=1 ";
			sql = sql + " 							and be.UFOM_NCORR=ufom.UFOM_NCORR (+) ";
			sql = sql + " 							group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,tb.TBEN_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR, a.TBEN_CCOD ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)= 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " ) f,	 ";
			sql = sql + " 	(----------TOTALES LETRAS, CHEQUES POR CONCEPTO DE COLIAGIATURA Y MATRICULA ALUMNOS ANTIGUOS-------- ";
			sql = sql + " 	select CARR_CCOD, ";
			sql = sql + " 		sum(MATRICULA_CHEQUE) total_matr_cheque_a, ";
			sql = sql + " 		sum(MATRICULA_LETRA) total_matr_letra_a, ";
			sql = sql + " 		sum(COLEGIATURA_CHEQUE) total_col_cheque_a,sum(COLEGIATURA_LETRA) total_col_letra_a  ";
			sql = sql + " 		from ( ";
			sql = sql + " 			   select CASE WHEN (a.TCOM_CCOD=1 and a.TING_CCOD=3) THEN a.valor_efectivo end MATRICULA_CHEQUE, ";
			sql = sql + " 			   		  CASE WHEN (a.TCOM_CCOD=1 and a.TING_CCOD=4) THEN a.valor_efectivo end MATRICULA_LETRA, ";
			sql = sql + " 					  CASE WHEN (a.TCOM_CCOD=2 and a.TING_CCOD=3) THEN a.valor_efectivo end COLEGIATURA_CHEQUE, ";
			sql = sql + " 					  CASE WHEN (a.TCOM_CCOD=2 and a.TING_CCOD=4) THEN a.valor_efectivo end COLEGIATURA_LETRA, ";
			sql = sql + " 			   		  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  ";
			sql = sql + " 					  aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii,detalle_ingresos dii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						--and com.TCOM_CCOD=2 ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						--and ii.EING_CCOD<>3		 ";
			sql = sql + " 						and ii.EING_CCOD=4	 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO=0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						and ii.INGR_NCORR=dii.INGR_NCORR ";
			sql = sql + " 						--and dii.TING_CCOD=4 ";
			sql = sql + " 						and dii.DING_NCORRELATIVO=1 ";
			sql = sql + " 						and dii.DING_BPACTA_CUOTA='S' ";
			sql = sql + " 						and trunc(dii.DING_FDOCTO) between nvl('01/12/2003',dii.DING_FDOCTO) ";
			sql = sql + " 						and nvl('01/02/2004',dii.DING_FDOCTO) ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	) g, ";
			sql = sql + " 	(----------TOTALES LETRAS, CHEQUES POR CONCEPTO DE COLEGIATURA Y MATRICULA ALUMNOS NUEVOS-------- ";
			sql = sql + " 	select CARR_CCOD, ";
			sql = sql + " 		sum(MATRICULA_CHEQUE) total_matr_cheque_n, ";
			sql = sql + " 		sum(MATRICULA_LETRA) total_matr_letra_n, ";
			sql = sql + " 		sum(COLEGIATURA_CHEQUE) total_col_cheque_n,sum(COLEGIATURA_LETRA) total_col_letra_n  ";
			sql = sql + " 		from ( ";
			sql = sql + " 			   select CASE WHEN (a.TCOM_CCOD=1 and a.TING_CCOD=3) THEN a.valor_efectivo end MATRICULA_CHEQUE, ";
			sql = sql + " 			   		  CASE WHEN (a.TCOM_CCOD=1 and a.TING_CCOD=4) THEN a.valor_efectivo end MATRICULA_LETRA, ";
			sql = sql + " 					  CASE WHEN (a.TCOM_CCOD=2 and a.TING_CCOD=3) THEN a.valor_efectivo end COLEGIATURA_CHEQUE, ";
			sql = sql + " 					  CASE WHEN (a.TCOM_CCOD=2 and a.TING_CCOD=4) THEN a.valor_efectivo end COLEGIATURA_LETRA, ";
			sql = sql + " 			   		  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD ";
			sql = sql + " 			   from ( ";
			sql = sql + " 			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  ";
			sql = sql + " 					  aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 						detalle_compromisos dc, abonos ab, ";
			sql = sql + " 						ingresos ii,detalle_ingresos dii, ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 						where aa.emat_ccod<>9 ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 						and oo.PERI_CCOD=160 ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 						and cc.ECON_CCOD=1 ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 						and com.ECOM_CCOD=1 ";
			sql = sql + " 						--and com.TCOM_CCOD=2 ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 						--and ii.EING_CCOD<>3		 ";
			sql = sql + " 						and ii.EING_CCOD=4	 ";
			sql = sql + " 						and ii.INGR_MEFECTIVO=0 ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 						and ii.INGR_NCORR=dii.INGR_NCORR ";
			sql = sql + " 						--and dii.TING_CCOD=4 ";
			sql = sql + " 						and dii.DING_NCORRELATIVO=1 ";
			sql = sql + " 						and dii.DING_BPACTA_CUOTA='S' ";
			sql = sql + " 						and trunc(dii.DING_FDOCTO) between nvl('01/12/2003',dii.DING_FDOCTO) ";
			sql = sql + " 						and nvl('01/02/2004',dii.DING_FDOCTO) ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD,dii.TING_CCOD ";
			sql = sql + " 						) a  ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD,a.TING_CCOD  ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 					)  ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC ";
			sql = sql + " 	) h, ";
			sql = sql + " (-------------TOTAL EFECTIVO POR CONCEPTO DE MATRICULA Y COLEGIATURA ALUMNOS ANTIGUOS ------------------- ";
			sql = sql + " select  CARR_CCOD,sum(MATRICULA_EFECTIVO) total_matr_efectivo_a,sum(COLEGIATURA_EFECTIVO)total_col_efectivo_a from ( ";
			sql = sql + " 		   select DECODE (a.TCOM_CCOD,1,a.valor_efectivo) MATRICULA_EFECTIVO, ";
			sql = sql + " 		   		  DECODE (a.TCOM_CCOD,2,a.valor_efectivo) COLEGIATURA_EFECTIVO, ";
			sql = sql + " 		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ";
			sql = sql + " 		    from ( ";
			sql = sql + " 		   		  select sum(ii.INGR_MEFECTIVO) valor_efectivo,car.CARR_CCOD, ";
			sql = sql + " 				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD ";
			sql = sql + " 					from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 					detalle_compromisos dc, abonos ab, ";
			sql = sql + " 					ingresos ii, ";
			sql = sql + " 					ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 					where aa.emat_ccod<>9 ";
			sql = sql + " 					and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 					and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 					and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 					and oo.PERI_CCOD=160 ";
			sql = sql + " 					and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 					and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 					and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 					and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 					and cc.ECON_CCOD=1 ";
			sql = sql + " 					and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 					and com.ECOM_CCOD=1 ";
			sql = sql + " 					and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 					and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 					and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 					and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 					and trunc(dc.DCOM_FCOMPROMISO) between nvl('01/12/2003',dc.DCOM_FCOMPROMISO)  ";
			sql = sql + " 					and nvl('01/02/2004',dc.DCOM_FCOMPROMISO) ";
			sql = sql + " 					--and ii.EING_CCOD<>3	 ";
			sql = sql + " 					and ii.EING_CCOD=1		 ";
			sql = sql + " 					and ii.INGR_MEFECTIVO <>0 ";
			sql = sql + " 					and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD ";
			sql = sql + " 					) a  ";
			sql = sql + " 				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  ";
			sql = sql + " 				having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)< 2004 ";
			sql = sql + " 				)  ";
			sql = sql + " 				group by CARR_CCOD,CARR_TDESC	 ";
			sql = sql + " )i,  ";
			sql = sql + " (-------------TOTAL EFECTIVO POR CONCEPTO DE MATRICULA Y COLEGIATURA ALUMNOS NUEVOS------------------- ";
			sql = sql + " select  CARR_CCOD,sum(MATRICULA_EFECTIVO) total_matr_efectivo_n,sum(COLEGIATURA_EFECTIVO)total_col_efectivo_n ";
			sql = sql + "  from ( ";
			sql = sql + " 		   select DECODE (a.TCOM_CCOD,1,a.valor_efectivo) MATRICULA_EFECTIVO, ";
			sql = sql + " 		   		  DECODE (a.TCOM_CCOD,2,a.valor_efectivo) COLEGIATURA_EFECTIVO, ";
			sql = sql + " 		   		   a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD ";
			sql = sql + " 		    from ( ";
			sql = sql + " 		   		  select sum(ii.INGR_MEFECTIVO) valor_efectivo,car.CARR_CCOD, ";
			sql = sql + " 				   car.CARR_TDESC, aa.PERS_NCORR,com.TCOM_CCOD ";
			sql = sql + " 					from alumnos aa, contratos cc, compromisos com,  ";
			sql = sql + " 					detalle_compromisos dc, abonos ab, ";
			sql = sql + " 					ingresos ii, ";
			sql = sql + " 					ofertas_academicas oo , especialidades ee, carreras car ";
			sql = sql + " 					where aa.emat_ccod<>9 ";
			sql = sql + " 					and cc.CONT_NCORR=com.COMP_NDOCTO ";
			sql = sql + " 					and com.TCOM_CCOD=dc.TCOM_CCOD ";
			sql = sql + " 					and com.INST_CCOD=dc.INST_CCOD ";
			sql = sql + " 					and oo.PERI_CCOD=160 ";
			sql = sql + " 					and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD) ";
			sql = sql + " 					and aa.OFER_NCORR=oo.OFER_NCORR ";
			sql = sql + " 					and oo.ESPE_CCOD=ee.ESPE_CCOD ";
			sql = sql + " 					and ee.CARR_CCOD=car.CARR_CCOD ";
			sql = sql + " 					and cc.ECON_CCOD=1 ";
			sql = sql + " 					and aa.MATR_NCORR=cc.MATR_NCORR ";
			sql = sql + " 					and com.ECOM_CCOD=1 ";
			sql = sql + " 					and com.COMP_NDOCTO=dc.COMP_NDOCTO ";
			sql = sql + " 					and dc.TCOM_CCOD=ab.TCOM_CCOD ";
			sql = sql + " 					and dc.INST_CCOD=ab.INST_CCOD ";
			sql = sql + " 					and dc.COMP_NDOCTO=ab.COMP_NDOCTO ";
			sql = sql + " 					and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO ";
			sql = sql + " 					and trunc(dc.DCOM_FCOMPROMISO) between nvl('01/12/2003',dc.DCOM_FCOMPROMISO)  ";
			sql = sql + " 					and nvl('01/02/2004',dc.DCOM_FCOMPROMISO) ";
			sql = sql + " 					--and ii.EING_CCOD<>3 ";
			sql = sql + " 					and ii.EING_CCOD=1			 ";
			sql = sql + " 					and ii.INGR_MEFECTIVO <>0 ";
			sql = sql + " 					and ab.INGR_NCORR=ii.INGR_NCORR ";
			sql = sql + " 					group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,com.TCOM_CCOD ";
			sql = sql + " 					) a  ";
			sql = sql + " 				group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TCOM_CCOD  ";
			sql = sql + " 				having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)= 2004 ";
			sql = sql + " 				)  ";
			sql = sql + " 				group by CARR_CCOD,CARR_TDESC	 ";
			sql = sql + " )j		 ";
			sql = sql + " where a.CARR_CCOD=b.CARR_CCOD ";
			sql = sql + " and b.CARR_CCOD=c.CARR_CCOD ";
			sql = sql + " and c.CARR_CCOD=d.CARR_CCOD ";
			sql = sql + " and d.CARR_CCOD=e.CARR_CCOD ";
			sql = sql + " and e.CARR_CCOD=f.CARR_CCOD ";
			sql = sql + " and f.CARR_CCOD=g.CARR_CCOD ";
			sql = sql + " and g.CARR_CCOD=h.CARR_CCOD ";
			sql = sql + " and h.CARR_CCOD=i.CARR_CCOD ";
			sql = sql + " and i.CARR_CCOD=j.CARR_CCOD ";

				return (sql);
		
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			//string post_ncorr;
			//string paga_ncorr;
			//string imprimirFinanza;
			//string paga_ncorr_d;
			//int fila = 0;	
			//post_ncorr = Request.QueryString["post_ncorr"];
			
				sql = EscribirCodigo();
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(flujoEfectivo1);
					
			//}
			
			//Response.End();
			//Response.Write(sql);
			//Response.End();
			CrystalReportFlujo reporte = new CrystalReportFlujo();
			
				
			reporte.SetDataSource(flujoEfectivo1);
			VerReporte.ReportSource = reporte;
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
			this.flujoEfectivo1 = new flujo_vencimiento.FlujoEfectivo();
			((System.ComponentModel.ISupportInitialize)(this.flujoEfectivo1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_CHEQUE_A", "TOTAL_CHEQUE_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_LETRA_A", "TOTAL_LETRA_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_CHEQUE_N", "TOTAL_CHEQUE_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_LETRA_N", "TOTAL_LETRA_N"),
																																																				 new System.Data.Common.DataColumnMapping("EFECTIVO_A", "EFECTIVO_A"),
																																																				 new System.Data.Common.DataColumnMapping("EFECTIVO_N", "EFECTIVO_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_CREDITO_A", "TOTAL_CREDITO_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_BECA_A", "TOTAL_BECA_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_DESCUENTO_A", "TOTAL_DESCUENTO_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_CREDITO_N", "TOTAL_CREDITO_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_BECA_N", "TOTAL_BECA_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_DESCUENTO_N", "TOTAL_DESCUENTO_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_CHEQUE_A", "TOTAL_MATR_CHEQUE_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_LETRA_A", "TOTAL_MATR_LETRA_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_A", "TOTAL_COL_LETRA_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_A1", "TOTAL_COL_LETRA_A1"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_CHEQUE_N", "TOTAL_MATR_CHEQUE_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_LETRA_N", "TOTAL_MATR_LETRA_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_N", "TOTAL_COL_LETRA_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_N1", "TOTAL_COL_LETRA_N1"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_EFECTIVO_A", "TOTAL_MATR_EFECTIVO_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_EFECTIVO_A", "TOTAL_COL_EFECTIVO_A"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_MATR_EFECTIVO_N", "TOTAL_MATR_EFECTIVO_N"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_COL_EFECTIVO_N", "TOTAL_COL_EFECTIVO_N")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CARR_TDESC, '' AS CARR_CCOD, '' AS TOTAL_CHEQUE_A, '' AS TOTAL_LETRA_A, '' AS TOTAL_CHEQUE_N, '' AS TOTAL_LETRA_N, '' AS EFECTIVO_A, '' AS EFECTIVO_N, '' AS TOTAL_CREDITO_A, '' AS TOTAL_BECA_A, '' AS TOTAL_DESCUENTO_A, '' AS TOTAL_CREDITO_N, '' AS TOTAL_BECA_N, '' AS TOTAL_DESCUENTO_N, '' AS TOTAL_MATR_CHEQUE_A, '' AS TOTAL_MATR_LETRA_A, '' AS TOTAL_COL_LETRA_A, '' AS TOTAL_COL_CHEQUE_A, '' AS TOTAL_MATR_CHEQUE_N, '' AS TOTAL_MATR_LETRA_N, '' AS TOTAL_COL_LETRA_N, '' AS TOTAL_COL_CHEQUE_N, '' AS TOTAL_MATR_EFECTIVO_A, '' AS TOTAL_COL_EFECTIVO_A, '' AS TOTAL_MATR_EFECTIVO_N, '' AS TOTAL_COL_EFECTIVO_N FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// flujoEfectivo1
			// 
			this.flujoEfectivo1.DataSetName = "FlujoEfectivo";
			this.flujoEfectivo1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.flujoEfectivo1.Namespace = "http://www.tempuri.org/FlujoEfectivo.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.flujoEfectivo1)).EndInit();

		}
		#endregion
	}
}
