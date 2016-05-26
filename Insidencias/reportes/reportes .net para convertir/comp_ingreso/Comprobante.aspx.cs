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

namespace comp_ingreso
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter2;
		protected comp_ingreso.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter4;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand4;
		protected System.Data.OleDb.OleDbConnection oleDbConnection2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand5;
		protected System.Data.OleDb.OleDbCommand oleDbInsertCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbUpdateCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbDeleteCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter5;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	
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
//listo
		private string generar_sql_contrato(string Contrato, string Periodo, int numero_hoja, string nombre_hoja) 
		{
		  string sql = "";
          
			sql=" SELECT  '"+numero_hoja +" ' as numero_hoja, '"+ nombre_hoja+" ' as nombre_hoja, a.cont_ncorr, protic.trunc(a.cont_fcontrato) as f_contrato, a.audi_tusuario, 'Carrera       :   ' +cast(e.carr_tdesc as varchar(100)) as carrera, ";
			sql = sql +"					protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.ano_ingreso_carrera(b.pers_ncorr, e.carr_ccod) as ano_ingreso, ";
			sql = sql +"		f.PERS_TAPE_PATERNO as paterno_alumno, f.PERS_TAPE_MATERNO as materno_alumno, f.PERS_TNOMBRE as nombres_alumno, ";
			sql = sql +"		protic.obtener_direccion(b.pers_ncorr,1,'CN') as direccion_alumno, h.CIUD_TCOMUNA as ciudad_alumno,h.CIUD_TDESC  as comuna_alumno, f.pers_tfono as fono_alumno, ";
			sql = sql +"		protic.obtener_rut(i.pers_ncorr) as rut_apoderado, j.pers_tfono as fono_apoderado,  ";
			sql = sql +"		j.PERS_TAPE_PATERNO as paterno_apoderado, j.PERS_TAPE_MATERNO as materno_apoderado, j.PERS_TNOMBRE  as nombres_apoderado,     ";
			sql = sql +"		protic.obtener_direccion(i.pers_ncorr,1,'CN') as direccion_apoderado, l.CIUD_TCOMUNA as ciudad_apoderado, l.CIUD_TDESC as comuna_apoderado  ";     
			sql = sql +"     FROM contratos a join alumnos b ";
			sql = sql +"         on a.matr_ncorr = b.matr_ncorr ";
			sql = sql +"         join ofertas_academicas c ";
			sql = sql +"          on b.ofer_ncorr = c.ofer_ncorr ";
			sql = sql +"          join especialidades d ";
			sql = sql +"                             on c.ESPE_CCOD = d.espe_ccod ";
			sql = sql +"                       join carreras e ";
			sql = sql +"                             on d.CARR_CCOD = e.carr_ccod ";
			sql = sql +"			    		join personas f ";
			sql = sql +"                             on  b.pers_ncorr = f.pers_ncorr ";
			sql = sql +"                        left outer join  direcciones g ";
			sql = sql +"                             on b.pers_ncorr = g.pers_ncorr ";
			sql = sql +"                        left outer join ciudades h ";
			sql = sql +"                             on g.CIUD_CCOD = h.ciud_ccod ";
			sql = sql +"                        join codeudor_postulacion i ";
			sql = sql +"                             on a.post_ncorr = i.post_ncorr ";
			sql = sql +"                        join personas j ";
			sql = sql +"                            on i.pers_ncorr = j.pers_ncorr ";
			sql = sql +"			    		left outer join direcciones k ";
			sql = sql +"                             on i.pers_ncorr = k.pers_ncorr ";
			sql = sql +"                        left  outer join   ciudades l ";
			sql = sql +"                            on k.ciud_ccod = l.ciud_ccod ";
			sql = sql +"			     WHERE  a.cont_ncorr = "+ Contrato +"   ";
			sql = sql +"				and a.peri_ccod = "+ Periodo  +"   "; 
			sql = sql +"					and g.TDIR_CCOD = 1 ";
			sql = sql +"				and k.TDIR_CCOD = 1 ";

		//Response.Write("<br>"+sql+"<br>");
		//Response.Flush();

			return (sql);
		}
//listo
		private string generar_sql_compromisos_beneficios(string Contrato) 
		{
			string sql = "";

			/*
			sql= " Select comp_ndocto, tcom_ccod, item, fecha_beneficio, monto, porcentaje " ;
			sql = sql +" From (select a.comp_ndocto,  a.tcom_ccod, b.tcom_tdesc as item, protic.trunc(a.comp_fdocto) as fecha_beneficio, " ;  
			sql = sql +"	a.comp_mneto + a.comp_mintereses - isnull(a.comp_mtraspasado, 0) as monto, '0' as porcentaje  " ;
			sql = sql +"	FROM compromisos a, tipos_compromisos b  " ;
			sql = sql +"	WHERE a.tcom_ccod = b.tcom_ccod  " ;
			sql = sql +"	and a.comp_ndocto = '"+Contrato+"'" ;
			sql = sql +"	and a.tcom_ccod in (1,2)  " ;
			sql = sql +"	)as tabla1 " ;
			sql = sql +" UNION " ;
			sql = sql +" select  a.COMP_NDOCTO, c.stde_ccod, c.STDE_TDESC, protic.trunc(d.BENE_FBENEFICIO) as f_beneficio, b.DETA_MVALOR_DETALLE, '0' as porcentaje " ;
			sql = sql +"		from compromisos a, detalles b, stipos_descuentos c , beneficios d " ;
			sql = sql +"		where a.comp_ndocto = b.COMP_NDOCTO " ;
			sql = sql +"	       and a.tcom_ccod = b.tcom_ccod " ;
			sql = sql +"		  and a.inst_ccod = b.inst_ccod " ;
			sql = sql +"		  and a.tcom_ccod in (1,2) " ;
			sql = sql +"		  and b.tdet_ccod  = c.STDE_CCOD " ;
			sql = sql +"		  and c.stde_ccod = c.stde_ccod " ;
			sql = sql +"		  and a.COMP_NDOCTO = d.CONT_NCORR " ;
			sql = sql +"		  and c.STDE_CCOD = d.stde_ccod " ;
			sql = sql +"		  and a.comp_ndocto = '"+Contrato+"'"; 
			*/

		    //Response.Write("<br>"+sql+"<br>");
		    //Response.Flush(); 
  
			sql= " Select comp_ndocto, tcom_ccod, item, fecha_beneficio, monto, porcentaje " ;
			sql = sql +" From (select a.comp_ndocto,  a.tcom_ccod, b.tcom_tdesc as item, protic.trunc(a.comp_fdocto) as fecha_beneficio, " ;  
			//sql = sql +"	--a.comp_mneto + a.comp_mintereses - isnull(a.comp_mtraspasado, 0) as monto, '0' as porcentaje  " ;
			sql = sql +"	a.comp_mneto - isnull(a.comp_mtraspasado, 0) as monto, '0' as porcentaje  " ;
			sql = sql +"	FROM compromisos a, tipos_compromisos b  " ;
			sql = sql +"	WHERE a.tcom_ccod = b.tcom_ccod  " ;
			sql = sql +"	and a.comp_ndocto = '"+Contrato+"'" ;
			sql = sql +"	and a.tcom_ccod in (1,2)  " ;
			sql = sql +"	)as tabla1 " ;
			sql = sql +" UNION " ;
			sql = sql +" Select cont_ncorr as COMP_NDOCTO,stde_ccod,stde_tdesc,protic.trunc(max(bene_fbeneficio)) as f_beneficio," ;
			sql = sql +"	case  when cast(bene_mmonto as numeric)>0 then  bene_mmonto * -1 else bene_mmonto end as DETA_MVALOR_DETALLE,'0' as porcentaje  " ;
			sql = sql +"		From ( " ;
			sql = sql +"			select b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc," ;
			sql = sql +"			isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," ;
			sql = sql +"			c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio " ;
			sql = sql +"            from postulantes a, contratos b, beneficios c, stipos_descuentos e " ;
			sql = sql +"			where a.post_ncorr = b.post_ncorr " ;
			sql = sql +"				and b.cont_ncorr = c.cont_ncorr " ;
			sql = sql +"				and c.stde_ccod = e.stde_ccod " ;
			sql = sql +"				and e.tben_ccod <> 1 " ;
			sql = sql +"				and b.econ_ccod = '1' " ;
			sql = sql +"				and c.eben_ccod = '1' " ;
			sql = sql +"				and b.econ_ccod <> 3 " ;
			sql = sql +"				and b.cont_ncorr='"+Contrato+"'" ;
			sql = sql +"		union " ;
			sql = sql +"			select k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.stde_tdesc, " ;
			sql = sql +"			cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto, " ;
			sql = sql +"			1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura, " ;
			sql = sql +"			i.tben_ccod, cont_fcontrato as bene_fbeneficio " ;
			sql = sql +"			from sdescuentos a,stipos_descuentos b,sestados_descuentos c, " ;
			sql = sql +"				postulantes d,ofertas_academicas e,personas_postulante f, " ;
			sql = sql +"				especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k " ;
			sql = sql +"			where a.stde_ccod = b.stde_ccod " ;
			sql = sql +"				and a.esde_ccod = c.esde_ccod  " ;
			sql = sql +"				and a.post_ncorr = d.post_ncorr  " ;
			sql = sql +"				and a.ofer_ncorr = d.ofer_ncorr " ;
			sql = sql +"				and d.ofer_ncorr = e.ofer_ncorr  " ;
			sql = sql +"				and d.pers_ncorr = f.pers_ncorr " ;
			sql = sql +"				and e.espe_ccod = g.espe_ccod  " ;
			sql = sql +"				and g.carr_ccod = h.carr_ccod " ;
			sql = sql +"				and e.sede_ccod = j.sede_ccod  " ;
			sql = sql +"				and b.tben_ccod = i.tben_ccod  " ;
			sql = sql +"				and d.post_ncorr=k.post_ncorr " ;
			sql = sql +"				and k.econ_ccod <> 3 " ;
			sql = sql +"				and k.cont_ncorr='"+Contrato+"'" ;
			sql = sql +" ) as tabla2  " ;  
			sql = sql +" group by cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod " ;
			sql= sql  +" order by comp_ndocto,tcom_ccod ";

			return (sql);
		}
//listo		
		private string generar_sql_cuotas (string Contrato, string Periodo)
		{
			string sql = "";
			sql = "SELECT a.cont_ncorr, e.ingr_ncorr, protic.trunc(e.ingr_fpago) as f_emision,f.ding_ndocto,"; 
			sql = sql +"     case e.ingr_mefectivo when 0 then f.ding_mdetalle else e.ingr_mefectivo end as monto,";
			sql = sql +" 	case isnull(cast(f.ting_ccod as varchar),'') when '' then 'EFECTIVO' else g.ting_tdesc end as tipo_doc,";
			sql = sql +"     case cast(f.banc_ccod as varchar) when '' then '' else h.banc_tdesc end as banco,";
			sql = sql +"     case CAST(f.plaz_ccod as varchar) when '' then '' else i.plaz_tdesc end  as plaza,";
			sql = sql +"     case protic.trunc(f.ding_fdocto) when '' then protic.trunc(e.ingr_fpago) else f.ding_fdocto end as f_vencimiento ";
			sql = sql +" FROM contratos a ";
			sql = sql +"     JOIN compromisos b ";
			sql = sql +"         ON a.cont_ncorr = b.comp_ndocto ";
			sql = sql +"     JOIN detalle_compromisos c ";
			sql = sql +"         ON b.tcom_ccod =  c.tcom_ccod ";
			sql = sql +"        	and b.inst_ccod = c.inst_ccod  ";
			sql = sql +"     	and b.comp_ndocto = c.comp_ndocto  ";
			sql = sql +"     JOIN abonos d  ";
			sql = sql +"         ON  c.tcom_ccod = d.tcom_ccod  ";
			sql = sql +"     	and c.inst_ccod = d.inst_ccod  ";
			sql = sql +" 	    and c.comp_ndocto = d.comp_ndocto  ";
			sql = sql +"     	and c.dcom_ncompromiso = d.dcom_ncompromiso  "; 
			sql = sql +" 	JOIN ingresos e  ";
			sql = sql +"         ON d.ingr_ncorr = e.ingr_ncorr  ";
			sql = sql +"     LEFT OUTER JOIN detalle_ingresos f  ";
			sql = sql +"         ON e.ingr_ncorr = f.ingr_ncorr ";
			sql = sql +"     LEFT OUTER JOIN tipos_ingresos g  ";
			sql = sql +"         ON f.ting_ccod = g.ting_ccod  ";
			sql = sql +"     LEFT OUTER JOIN bancos h ";
			sql = sql +"        ON f.banc_ccod = h.banc_ccod  ";
			sql = sql +"     LEFT OUTER JOIN plazas i   ";
			sql = sql +"         ON f.plaz_ccod = i.plaz_ccod ";
			sql = sql +" WHERE a.cont_ncorr =  '"+Contrato+"'   ";
			sql = sql +" 	and b.tcom_ccod in (1,2)  ";
			sql = sql +" 	and isnull(f.ting_ccod,0) in (0, 3, 4,13,51,52,59,66)  ";
			sql = sql +"     and isnull(c.dcom_mtraspasado, 0) = 0  ";
			sql = sql +"     and e.ting_ccod = 7  ";
			sql = sql +"     and e.eing_ccod IN (1,4)  ";
			sql = sql +" 	and a.peri_ccod =  '"+Periodo+"' ";
			sql = sql +" ORDER BY c.tcom_ccod, f_vencimiento";
		   
			//Response.Write("<br>"+sql+"<br>");
			//Response.Flush();
			return (sql);
		}



//listo (genera los duplicados)
		private string generar_sql_contrato_pact(string Contrato, string Periodo, int numero_hoja, string nombre_hoja)
		{
			string SQL = "";

			SQL = "SELECT '" + numero_hoja + "' as numero_hoja, '" + nombre_hoja + "' as nombre_hoja, b.comp_ndocto as cont_ncorr, b.comp_fdocto as f_contrato, b.audi_tusuario, 'Curso         :   ' +d.tdet_tdesc as carrera,";
			SQL = SQL +  " 	protic.obtener_rut(b.pers_ncorr) as rut_alumno, '' as ano_ingreso, e.pers_tape_paterno as paterno_alumno, e.pers_tape_materno as materno_alumno, e.pers_tnombre as nombres_alumno,";
			SQL = SQL +  " protic.obtener_direccion(e.pers_ncorr, 1,'CN') as direccion_alumno, g.ciud_tcomuna as ciudad_alumno, g.ciud_tdesc as comuna_alumno, e.pers_tfono as fono_alumno,";
			SQL = SQL +  " protic.obtener_rut(i.pers_ncorr) as rut_apoderado, i.pers_tfono as fono_apoderado, i.pers_tape_paterno as paterno_apoderado, i.pers_tape_materno as materno_apoderado, i.pers_tnombre as nombres_apoderado,";
			SQL = SQL +  " protic.obtener_direccion(i.pers_ncorr, 1,'CN') as direccion_apoderado, k.ciud_tcomuna as ciudad_apoderado,k.ciud_tdesc  as comuna_apoderado,";
			SQL = SQL +  " 	   l.igas_tcodigo, m.ccos_tcodigo, '2' as tipo_impresion ";
			SQL = SQL +  " from sim_pactaciones a, compromisos b, tipos_detalle d, personas e, direcciones f, ciudades g,";
			SQL = SQL +  "        ( \n";
			SQL = SQL +  " 	    select max(d.pers_ncorr_codeudor) as pers_ncorr_codeudor \n";
			SQL = SQL +  " 		from sim_pactaciones a, abonos b, ingresos c, detalle_ingresos d \n";
			SQL = SQL +  " 		where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  " 		  and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  " 		  and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  " 		  and b.ingr_ncorr = c.ingr_ncorr \n";
			SQL = SQL +  " 		  and c.ingr_ncorr = d.ingr_ncorr \n";
			SQL = SQL +  " 		  and a.comp_ndocto = '" + Contrato + "' \n";
			SQL = SQL +  " 	   ) h, \n";
			SQL = SQL +  " 	   personas i, direcciones j, ciudades k, \n";
			SQL = SQL +  " 	   itemes_gasto l, centros_costo m \n";
			SQL = SQL +  "   where a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "     and a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  "     and a.inst_ccod = b.inst_ccod       \n";
			SQL = SQL +  "     and a.tdet_ccod = d.tdet_ccod \n";
			SQL = SQL +  "     and b.pers_ncorr = e.pers_ncorr \n";
			SQL = SQL +  "     and e.pers_ncorr = f.pers_ncorr   \n";
			SQL = SQL +  "     and f.ciud_ccod = g.ciud_ccod \n";
			SQL = SQL +  "     and isnull(h.pers_ncorr_codeudor, b.pers_ncorr) = i.pers_ncorr \n";
			SQL = SQL +  "     and i.pers_ncorr = j.pers_ncorr \n";
			SQL = SQL +  "     and j.ciud_ccod = k.ciud_ccod \n";
			SQL = SQL +  "     and d.igas_ccod *= l.igas_ccod \n";
			SQL = SQL +  "     and d.ccos_ccod *= m.ccos_ccod \n";
			SQL = SQL +  "     and f.tdir_ccod = 1 \n";
			SQL = SQL +  "     and j.tdir_ccod = 1 \n";
			SQL = SQL +  "     and a.comp_ndocto = '" + Contrato + "' \n";

//Response.Write("<br>"+SQL+"<br>");
//Response.Flush();

			return (SQL);
		}

//listo
		private string generar_sql_compromisos_beneficios_pact(string Contrato)
		{
			string SQL;

			SQL = " select a.comp_ndocto, b.tcom_ccod, d.tdet_tdesc+ isnull((select top 1 case fpot_ccod when 4 then ' (Empresa + Otic)' else '' end  from postulacion_otec po,postulantes_cargos_otec pc where po.pote_ncorr=pc.pote_ncorr and pc.comp_ndocto=a.comp_ndocto),'') as item, ";
			SQL = SQL +  " b.comp_fdocto as fecha_beneficio, c.deta_msubtotal as monto, 0 as porcentaje";
			SQL = SQL +  " from sim_pactaciones a, compromisos b, detalles c, tipos_detalle d";
			SQL = SQL +  " where a.comp_ndocto = b.comp_ndocto";
			SQL = SQL +  "   and a.inst_ccod = b.inst_ccod";
			SQL = SQL +  "   and a.tcom_ccod = b.tcom_ccod";
			SQL = SQL +  "   and b.comp_ndocto = c.comp_ndocto";
			SQL = SQL +  "   and b.inst_ccod = c.inst_ccod";
			SQL = SQL +  "   and b.tcom_ccod = c.tcom_ccod";
			SQL = SQL +  "   and c.tdet_ccod = d.tdet_ccod";
			SQL = SQL +  "   and a.comp_ndocto = '" + Contrato + "'";

			return (SQL);
		}
//listo
		private string generar_sql_cuotas_pact(string contrato) 
		{
			string SQL;

			SQL = " select a.comp_ndocto as cont_ncorr, e.ingr_ncorr, b.comp_fdocto as f_emision,  ";
			SQL = SQL +  "  	c.dcom_mcompromiso as monto, f.ding_ndocto,  ";
			SQL = SQL +  "  	isnull(g.ting_tdesc, 'EFECTIVO') as tipo_doc, h.banc_tdesc as banco,  ";
			SQL = SQL +  "  	i.plaz_tdesc as plaza, isnull(f.ding_fdocto, c.dcom_fcompromiso) as f_vencimiento ";
			SQL = SQL +  "  	from  ";
			SQL = SQL +  "  sim_pactaciones a  ";
			SQL = SQL +  "  JOIN compromisos b ";
			SQL = SQL +  "  	ON a.comp_ndocto = b.comp_ndocto ";
			SQL = SQL +  "  	and a.inst_ccod = b.inst_ccod ";
			SQL = SQL +  "  	and a.tcom_ccod = b.tcom_ccod ";
			SQL = SQL +  "  JOIN detalle_compromisos c ";
			SQL = SQL +  "  	ON  b.tcom_ccod = c.tcom_ccod ";
			SQL = SQL +  "  	and b.inst_ccod = c.inst_ccod ";
			SQL = SQL +  "  	and b.comp_ndocto = c.comp_ndocto ";
			SQL = SQL +  "  JOIN abonos d ";
			SQL = SQL +  "  	ON c.tcom_ccod = d.tcom_ccod ";
			SQL = SQL +  "  	and c.inst_ccod = d.inst_ccod ";
			SQL = SQL +  "  	and c.comp_ndocto = d.comp_ndocto ";
			SQL = SQL +  "  	and c.dcom_ncompromiso = d.dcom_ncompromiso ";
			SQL = SQL +  "  JOIN ingresos e ";
			SQL = SQL +  "  	ON d.ingr_ncorr = e.ingr_ncorr ";
			SQL = SQL +  "  LEFT OUTER JOIN detalle_ingresos f ";
			SQL = SQL +  "  	ON e.ingr_ncorr = f.ingr_ncorr ";
			SQL = SQL +  "  LEFT OUTER JOIN tipos_ingresos g ";
			SQL = SQL +  "  	ON f.ting_ccod = g.ting_ccod ";
			SQL = SQL +  "  LEFT OUTER JOIN bancos h ";
			SQL = SQL +  "  	ON f.banc_ccod = h.banc_ccod ";
			SQL = SQL +  "  LEFT OUTER JOIN plazas i ";
			SQL = SQL +  "  	ON f.plaz_ccod = i.plaz_ccod ";
			SQL = SQL +  "  where  	e.ting_ccod in (16, 33) ";
			SQL = SQL +  "  	and a.comp_ndocto = ' " + contrato + "'";
			SQL = SQL +  "  	order by f_vencimiento asc";
			return SQL;
		}

		//listo
		private string generar_sql_folio_ref_pact(string contrato) 
		{
			string SQL;

			SQL = " select distinct a.comp_ndocto as cont_ncorr, c.ingr_nfolio_referencia, ingr_ncorrelativo_caja  ";
			SQL = SQL +  " from sim_pactaciones a, abonos b, ingresos c ";
			SQL = SQL +  " where a.comp_ndocto = b.comp_ndocto ";
			SQL = SQL +  "   and a.inst_ccod = b.inst_ccod ";
			SQL = SQL +  "   and a.tcom_ccod = b.tcom_ccod ";
			SQL = SQL +  "   and b.ingr_ncorr = c.ingr_ncorr ";
			SQL = SQL +  "   and a.comp_ndocto = '" + contrato + "'";

			return SQL;
		}

			
		private string generar_sql_folio_ref (string Contrato)
		{
			string sql = "";
			sql = "select a.cont_ncorr, e.ingr_nfolio_referencia, e.ingr_ncorrelativo_caja ";
			sql = sql +	"FROM contratos a, compromisos b, detalle_compromisos c, abonos d, ";
			sql = sql +	"ingresos e  ";
			sql = sql +	"WHERE a.cont_ncorr = b.comp_ndocto ";
			sql = sql +	"and b.tcom_ccod in (1,2) ";
			sql = sql +	"and b.tcom_ccod = c.tcom_ccod ";
			sql = sql +	"and b.inst_ccod = c.inst_ccod ";
			sql = sql +	"and b.comp_ndocto = c.comp_ndocto ";
			sql = sql +	"and c.tcom_ccod = d.tcom_ccod ";
			sql = sql +	"and c.inst_ccod = d.inst_ccod ";
			sql = sql +	"and c.comp_ndocto = d.comp_ndocto ";
			sql = sql +	"and c.dcom_ncompromiso = d.dcom_ncompromiso ";			
			sql = sql +	"and d.ingr_ncorr = e.ingr_ncorr ";
			sql = sql + "and isnull(c.dcom_mtraspasado, 0) = 0 ";
			sql = sql + "and e.ting_ccod = 7 ";
			sql = sql +	"and a.cont_ncorr =" + Contrato;
			
			return (sql);
		}

		private string generar_sql_alumnos (string Contrato)
		{
			string sql = "";
					sql =" select protic.obtener_rut(a.pers_ncorr)as rut, ";
					sql = sql +	" protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre ";
					sql = sql +	" from postulacion_otec a, personas b,postulantes_cargos_otec c ";
					sql = sql +	" where a.pers_ncorr=b.pers_ncorr";
					sql = sql +	" and a.pote_ncorr=c.pote_ncorr";
					sql = sql +	" and c.comp_ndocto=" + Contrato;
			
			return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", num_contrato = "", periodo = "", tipo_impresion,tipo_comprobante;
			string[] nombre_hoja = new string[3] {"ORIGINAL", "COPIA", "TRIPLICADO - ARCHIVO CAJA"};
			
			CrystalReport1 Comprobante = new CrystalReport1();
			ComprobanteCurso ComprobanteC = new ComprobanteCurso();
			
			num_contrato = Request.QueryString["contrato"];
			periodo = Request.QueryString["periodo"];
			tipo_impresion = Request.QueryString["tipo_impresion"];
			tipo_comprobante = Request.QueryString["tipo_comprobante"];
		   	
			//num_contrato = "30122";
			//periodo = "164";
			//tipo_impresion = "1";

			for (int i=0; i<2; i++)
			{
				if (tipo_impresion == "2")
					sql = generar_sql_contrato_pact(num_contrato, periodo, i, nombre_hoja[i]);
				else
					sql = generar_sql_contrato(num_contrato, periodo, i, nombre_hoja[i]);

				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(dataSet11);				
			}
			
			if (tipo_impresion == "2")
			{
				sql = generar_sql_compromisos_beneficios_pact(num_contrato);
			}
			else
			{
				sql = generar_sql_compromisos_beneficios(num_contrato);
			}
			oleDbDataAdapter2.SelectCommand.CommandText = sql;
			oleDbDataAdapter2.Fill(dataSet11);
			
			if (tipo_impresion == "2")
				sql = generar_sql_cuotas_pact(num_contrato);
			else
				sql = generar_sql_cuotas(num_contrato, periodo);


			oleDbDataAdapter3.SelectCommand.CommandText = sql;
			oleDbDataAdapter3.Fill(dataSet11);
			
			
			if (tipo_impresion == "2")
				sql = generar_sql_folio_ref_pact(num_contrato);
			else
				sql = generar_sql_folio_ref(num_contrato);


			oleDbDataAdapter4.SelectCommand.CommandText = sql;
			oleDbDataAdapter4.Fill(dataSet11);
			switch (tipo_comprobante)
			{
				
				case "O":
					sql =generar_sql_alumnos(num_contrato);
					oleDbDataAdapter5.SelectCommand.CommandText = sql;
					oleDbDataAdapter5.Fill(dataSet11);

						ComprobanteC.SetDataSource(dataSet11);
						CrystalReportViewer1.ReportSource = ComprobanteC;
						ExportarPDF(ComprobanteC);
					break;
				default:
					Comprobante.SetDataSource(dataSet11);
					CrystalReportViewer1.ReportSource = Comprobante;
					ExportarPDF(Comprobante);
					break;
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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new comp_ingreso.DataSet1();
			this.oleDbDataAdapter2 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter3 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter4 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand4 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection2 = new System.Data.OleDb.OleDbConnection();
			this.oleDbSelectCommand5 = new System.Data.OleDb.OleDbCommand();
			this.oleDbInsertCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbUpdateCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDeleteCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter5 = new System.Data.OleDb.OleDbDataAdapter();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "T_Contrato", new System.Data.Common.DataColumnMapping[] {
																																																					  new System.Data.Common.DataColumnMapping("NUMERO_HOJA", "NUMERO_HOJA"),
																																																					  new System.Data.Common.DataColumnMapping("NOMBRE_HOJA", "NOMBRE_HOJA"),
																																																					  new System.Data.Common.DataColumnMapping("CONT_NCORR", "CONT_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("F_CONTRATO", "F_CONTRATO"),
																																																					  new System.Data.Common.DataColumnMapping("AUDI_TUSUARIO", "AUDI_TUSUARIO"),
																																																					  new System.Data.Common.DataColumnMapping("ANO_INGRESO", "ANO_INGRESO"),
																																																					  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("PATERNO_ALUMNO", "PATERNO_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("MATERNO_ALUMNO", "MATERNO_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("NOMBRES_ALUMNO", "NOMBRES_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("DIRECCION_ALUMNO", "DIRECCION_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("CIUDAD_ALUMNO", "CIUDAD_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("COMUNA_ALUMNO", "COMUNA_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("FONO_ALUMNO", "FONO_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("PATERNO_APODERADO", "PATERNO_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("MATERNO_APODERADO", "MATERNO_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("NOMBRES_APODERADO", "NOMBRES_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("DIRECCION_APODERADO", "DIRECCION_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("CIUDAD_APODERADO", "CIUDAD_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("COMUNA_APODERADO", "COMUNA_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("FONO_APODERADO", "FONO_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("IGAS_TCODIGO", "IGAS_TCODIGO"),
																																																					  new System.Data.Common.DataColumnMapping("CCOS_TCODIGO", "CCOS_TCODIGO"),
																																																					  new System.Data.Common.DataColumnMapping("TIPO_IMPRESION", "TIPO_IMPRESION")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS NUMERO_HOJA, '' AS NOMBRE_HOJA, '' AS CONT_NCORR, '' AS F_CONTRATO, '' AS AUDI_TUSUARIO, '' AS ANO_INGRESO, '' AS CARRERA, '' AS RUT_ALUMNO, '' AS PATERNO_ALUMNO, '' AS MATERNO_ALUMNO, '' AS NOMBRES_ALUMNO, '' AS DIRECCION_ALUMNO, '' AS CIUDAD_ALUMNO, '' AS COMUNA_ALUMNO, '' AS FONO_ALUMNO, '' AS RUT_APODERADO, '' AS PATERNO_APODERADO, '' AS MATERNO_APODERADO, '' AS NOMBRES_APODERADO, '' AS DIRECCION_APODERADO, '' AS CIUDAD_APODERADO, '' AS COMUNA_APODERADO, '' AS FONO_APODERADO, '' AS igas_tcodigo, '' AS CCOS_TCODIGO, '' AS tipo_impresion";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// oleDbDataAdapter2
			// 
			this.oleDbDataAdapter2.SelectCommand = this.oleDbSelectCommand2;
			this.oleDbDataAdapter2.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "T_Beneficios", new System.Data.Common.DataColumnMapping[] {
																																																						new System.Data.Common.DataColumnMapping("COMP_NDOCTO", "COMP_NDOCTO"),
																																																						new System.Data.Common.DataColumnMapping("TCOM_CCOD", "TCOM_CCOD"),
																																																						new System.Data.Common.DataColumnMapping("ITEM", "ITEM"),
																																																						new System.Data.Common.DataColumnMapping("FECHA_BENEFICIO", "FECHA_BENEFICIO"),
																																																						new System.Data.Common.DataColumnMapping("MONTO", "MONTO"),
																																																						new System.Data.Common.DataColumnMapping("PORCENTAJE", "PORCENTAJE")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS COMP_NDOCTO, \'\' AS TCOM_CCOD, \'\' AS ITEM, \'\' AS FECHA_BENEFICIO, \'\' " +
				"AS MONTO, \'\' AS PORCENTAJE";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter3
			// 
			this.oleDbDataAdapter3.SelectCommand = this.oleDbSelectCommand3;
			this.oleDbDataAdapter3.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "T_Cuotas", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("CONT_NCORR", "CONT_NCORR"),
																																																					new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																					new System.Data.Common.DataColumnMapping("F_EMISION", "F_EMISION"),
																																																					new System.Data.Common.DataColumnMapping("MONTO", "MONTO"),
																																																					new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																					new System.Data.Common.DataColumnMapping("TIPO_DOC", "TIPO_DOC"),
																																																					new System.Data.Common.DataColumnMapping("BANCO", "BANCO"),
																																																					new System.Data.Common.DataColumnMapping("PLAZA", "PLAZA"),
																																																					new System.Data.Common.DataColumnMapping("F_VENCIMIENTO", "F_VENCIMIENTO")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT \'\' AS CONT_NCORR, \'\' AS INGR_NCORR, \'\' AS F_EMISION, \'\' AS MONTO, \'\' AS DI" +
				"NG_NDOCTO, \'\' AS TIPO_DOC, \'\' AS BANCO, \'\' AS PLAZA, \'\' AS F_VENCIMIENTO";
			this.oleDbSelectCommand3.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter4
			// 
			this.oleDbDataAdapter4.SelectCommand = this.oleDbSelectCommand4;
			this.oleDbDataAdapter4.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "T_Folio_Ref", new System.Data.Common.DataColumnMapping[] {
																																																					   new System.Data.Common.DataColumnMapping("CONT_NCORR", "CONT_NCORR"),
																																																					   new System.Data.Common.DataColumnMapping("INGR_NFOLIO_REFERENCIA", "INGR_NFOLIO_REFERENCIA")})});
			// 
			// oleDbSelectCommand4
			// 
			this.oleDbSelectCommand4.CommandText = "SELECT \'\' AS CONT_NCORR, \'\' AS INGR_NFOLIO_REFERENCIA, \'\' AS ingr_ncorrelativo_ca" +
				"ja";
			this.oleDbSelectCommand4.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection2
			// 
			this.oleDbConnection2.ConnectionString = "Provider=SQLOLEDB;server=edoras;OLE DB Services = -2;uid=protic;pwd=,.protic;init" +
				"ial catalog=protic";
			// 
			// oleDbSelectCommand5
			// 
			this.oleDbSelectCommand5.CommandText = "SELECT \'\' AS RUT, \'\' AS NOMBRE";
			this.oleDbSelectCommand5.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter5
			// 
			this.oleDbDataAdapter5.DeleteCommand = this.oleDbDeleteCommand1;
			this.oleDbDataAdapter5.InsertCommand = this.oleDbInsertCommand1;
			this.oleDbDataAdapter5.SelectCommand = this.oleDbSelectCommand5;
			this.oleDbDataAdapter5.UpdateCommand = this.oleDbUpdateCommand1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
