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

namespace imprimir_pagare
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	/// 
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer VerPagare;
		protected imprimir_pagare.DataSet1 dataSet11;
		protected imprimir_pagare.datosPagare datosPagare1;

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

		private string EscribirCodigo( string post_ncorr)
		{
			string sql;

			sql =  "SELECT con.cont_ncorr AS ciudad_codeudor1, pag.paga_ncorr nro_pagare, \n ";
					sql = sql + " cps.comp_mdocumento AS valor_pagar,cps.COMP_NCUOTAS AS NUMERO_CUOTAS, \n ";
					sql = sql + " cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago, \n ";
					sql = sql + " (SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy, \n ";
					sql = sql + " cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,\n "; 
					sql = sql + " dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco ,\n";
					sql = sql + " cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc \n ";
					sql = sql + " ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento, \n ";
					sql = sql + "(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post, \n ";
					sql = sql + " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno, \n ";
					sql = sql + " cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor, \n ";
					sql = sql + " ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno \n ";
					sql = sql + " AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor, \n ";
					sql = sql + " c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,\n ";
					sql = sql + "  ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor \n ";
					sql = sql + " FROM postulantes p \n ";
					sql = sql + " join personas_postulante pp \n ";
					sql = sql + "     on p.pers_ncorr = pp.pers_ncorr \n ";
					sql = sql + " join codeudor_postulacion cp \n ";
					sql = sql + "     on p.post_ncorr = cp.post_ncorr \n ";
					sql = sql + " join personas_postulante ppc \n ";
					sql = sql + "     on cp.pers_ncorr = ppc.pers_ncorr \n ";
					sql = sql + " join ofertas_academicas oa \n ";
					sql = sql + "     on p.ofer_ncorr = oa.ofer_ncorr \n ";
					sql = sql + " join especialidades ee \n ";
					sql = sql + "     on oa.espe_ccod = ee.espe_ccod \n ";
					sql = sql + " join carreras cc \n ";
					sql = sql + "     on ee.carr_ccod = cc.carr_ccod \n ";
					sql = sql + " join direcciones_publica ddp \n ";
					sql = sql + "     on pp.pers_ncorr = ddp.pers_ncorr \n ";
					sql = sql + " left outer join ciudades ccp \n ";
					sql = sql + "     on ddp.ciud_ccod =ccp.ciud_ccod \n ";
					sql = sql + " join direcciones_publica ddc \n ";
					sql = sql + "     on ppc.pers_ncorr = ddc.pers_ncorr \n ";
					sql = sql + " left outer join ciudades c \n ";
					sql = sql + "     on ddc.ciud_ccod =c.ciud_ccod \n ";
					sql = sql + " join periodos_academicos pac \n ";
					sql = sql + "     on oa.peri_ccod = pac.peri_ccod \n ";
					sql = sql + " join contratos con  \n ";
					sql = sql + "     on con.post_ncorr = p.post_ncorr \n ";
					sql = sql + " join pagares pag \n ";
					sql = sql + "     on con.cont_ncorr = pag.cont_ncorr  \n ";
					sql = sql + "     and isnull(pag.opag_ccod,1) not in (2)  \n ";
					sql = sql + " join sedes ss \n ";
					sql = sql + "     on oa.sede_ccod = ss.sede_ccod \n ";
					sql = sql + " join ciudades ciu  \n ";
					sql = sql + "     on ss.ciud_ccod = ciu.ciud_ccod \n ";
					sql = sql + " join compromisos cps   \n ";
					sql = sql + "     on con.cont_ncorr=cps.comp_ndocto   \n ";
					sql = sql + "  join detalle_compromisos dc  \n ";
					sql = sql + "     on cps.comp_ndocto=dc.comp_ndocto \n ";  
					sql = sql + " 	and cps.inst_ccod=dc.inst_ccod   \n ";
					sql = sql + " 	and cps.tcom_ccod=dc.tcom_ccod    \n ";
					sql = sql + "  left outer join detalle_ingresos dii  \n ";
					sql = sql + "     on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod   \n ";
					sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
					sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto     \n ";
					sql = sql + "  left outer join ingresos ii  \n ";
					sql = sql + "     on dii.ingr_ncorr = ii.ingr_ncorr \n ";
					sql = sql + "  left outer join tipos_ingresos tii  \n ";
					sql = sql + "     on dii.ting_ccod =tii.ting_ccod  \n ";
					sql = sql + "  left outer join bancos bn  \n ";
					sql = sql + "     on dii.banc_ccod = bn.banc_ccod \n ";
					sql = sql + " WHERE   \n ";
					sql = sql + "  p.post_ncorr = ISNULL('" +post_ncorr+ "', '0')  \n ";
					sql = sql + "  AND ddc.tdir_ccod = 1  \n ";
					sql = sql + " AND ddp.tdir_ccod = 1  \n ";
					sql = sql + "  and isnull(dii.ting_ccod, 0) in (52) \n ";
					sql = sql + "  and cps.ecom_ccod <> 3   \n ";
					sql = sql + " and con.econ_ccod in (1, 2)   \n ";
					sql = sql + " and cps.tcom_ccod in (2)   \n ";
					sql = sql + " and dc.tcom_ccod in (2)   \n ";
			
//Response.Write(sql);
//Response.Flush();
			return (sql);

		}

		private string EscribirCodigoMultidebito( string post_ncorr)
		{
			string sql;

			sql =  "SELECT con.cont_ncorr AS ciudad_codeudor1, pag.pmul_ncorr nro_pagare, \n ";
			sql = sql + " cps.comp_mdocumento AS valor_pagar,cps.COMP_NCUOTAS AS NUMERO_CUOTAS, \n ";
			sql = sql + " cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago, \n ";
			sql = sql + " (SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy, \n ";
			sql = sql + " cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,\n "; 
			sql = sql + " dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco ,\n";
			sql = sql + " cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc \n ";
			sql = sql + " ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento, \n ";
			sql = sql + "(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post, \n ";
			sql = sql + " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno, \n ";
			sql = sql + " cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor, \n ";
			sql = sql + " ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno \n ";
			sql = sql + " AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor, \n ";
			sql = sql + " c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,\n ";
			sql = sql + "  ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor \n ";
			sql = sql + " FROM postulantes p \n ";
			sql = sql + " join personas_postulante pp \n ";
			sql = sql + "     on p.pers_ncorr = pp.pers_ncorr \n ";
			sql = sql + " join codeudor_postulacion cp \n ";
			sql = sql + "     on p.post_ncorr = cp.post_ncorr \n ";
			sql = sql + " join personas_postulante ppc \n ";
			sql = sql + "     on cp.pers_ncorr = ppc.pers_ncorr \n ";
			sql = sql + " join ofertas_academicas oa \n ";
			sql = sql + "     on p.ofer_ncorr = oa.ofer_ncorr \n ";
			sql = sql + " join especialidades ee \n ";
			sql = sql + "     on oa.espe_ccod = ee.espe_ccod \n ";
			sql = sql + " join carreras cc \n ";
			sql = sql + "     on ee.carr_ccod = cc.carr_ccod \n ";
			sql = sql + " join direcciones_publica ddp \n ";
			sql = sql + "     on pp.pers_ncorr = ddp.pers_ncorr \n ";
			sql = sql + " left outer join ciudades ccp \n ";
			sql = sql + "     on ddp.ciud_ccod =ccp.ciud_ccod \n ";
			sql = sql + " join direcciones_publica ddc \n ";
			sql = sql + "     on ppc.pers_ncorr = ddc.pers_ncorr \n ";
			sql = sql + " left outer join ciudades c \n ";
			sql = sql + "     on ddc.ciud_ccod =c.ciud_ccod \n ";
			sql = sql + " join periodos_academicos pac \n ";
			sql = sql + "     on oa.peri_ccod = pac.peri_ccod \n ";
			sql = sql + " join contratos con  \n ";
			sql = sql + "     on con.post_ncorr = p.post_ncorr \n ";
			sql = sql + " join pagare_multidebito pag \n ";
			sql = sql + "     on con.cont_ncorr = pag.cont_ncorr  \n ";
			sql = sql + "     and isnull(pag.opag_ccod,1) not in (2)  \n ";
			sql = sql + " join sedes ss \n ";
			sql = sql + "     on oa.sede_ccod = ss.sede_ccod \n ";
			sql = sql + " join ciudades ciu  \n ";
			sql = sql + "     on ss.ciud_ccod = ciu.ciud_ccod \n ";
			sql = sql + " join compromisos cps   \n ";
			sql = sql + "     on con.cont_ncorr=cps.comp_ndocto   \n ";
			sql = sql + "  join detalle_compromisos dc  \n ";
			sql = sql + "     on cps.comp_ndocto=dc.comp_ndocto \n ";  
			sql = sql + " 	and cps.inst_ccod=dc.inst_ccod   \n ";
			sql = sql + " 	and cps.tcom_ccod=dc.tcom_ccod    \n ";
			sql = sql + "  left outer join detalle_ingresos dii  \n ";
			sql = sql + "     on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod   \n ";
			sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
			sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto     \n ";
			sql = sql + "  left outer join ingresos ii  \n ";
			sql = sql + "     on dii.ingr_ncorr = ii.ingr_ncorr \n ";
			sql = sql + "  left outer join tipos_ingresos tii  \n ";
			sql = sql + "     on dii.ting_ccod =tii.ting_ccod  \n ";
			sql = sql + "  left outer join bancos bn  \n ";
			sql = sql + "     on dii.banc_ccod = bn.banc_ccod \n ";
			sql = sql + " WHERE   \n ";
			sql = sql + "  p.post_ncorr = ISNULL('" +post_ncorr+ "', '0')  \n ";
			sql = sql + "  AND ddc.tdir_ccod = 1  \n ";
			sql = sql + " AND ddp.tdir_ccod = 1  \n ";
			sql = sql + "  and isnull(dii.ting_ccod, 0) in (59) \n ";
			sql = sql + "  and cps.ecom_ccod <> 3   \n ";
			sql = sql + " and con.econ_ccod in (1, 2)   \n ";
			sql = sql + " and cps.tcom_ccod in (2)   \n ";
			sql = sql + " and dc.tcom_ccod in (2)   \n ";
			
			//Response.Write(sql);
			//Response.Flush();
			return (sql);

		}

		private string EscribirCodigoPagaUpa( string post_ncorr)
		{
			string sql;

			sql =  "SELECT con.cont_ncorr AS ciudad_codeudor1, pag.pupa_ncorr nro_pagare, \n ";
			sql = sql + " cps.comp_mdocumento AS valor_pagar,cps.COMP_NCUOTAS AS NUMERO_CUOTAS, \n ";
			sql = sql + " cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago, \n ";
			sql = sql + " (SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy, \n ";
			sql = sql + " cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,\n "; 
			sql = sql + " dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco ,\n";
			sql = sql + " cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc \n ";
			sql = sql + " ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento, \n ";
			sql = sql + "(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post, \n ";
			sql = sql + " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno, \n ";
			sql = sql + " cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor, \n ";
			sql = sql + " ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno \n ";
			sql = sql + " AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor, \n ";
			sql = sql + " c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,\n ";
			sql = sql + "  ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor \n ";
			sql = sql + " FROM postulantes p \n ";
			sql = sql + " join personas_postulante pp \n ";
			sql = sql + "     on p.pers_ncorr = pp.pers_ncorr \n ";
			sql = sql + " join codeudor_postulacion cp \n ";
			sql = sql + "     on p.post_ncorr = cp.post_ncorr \n ";
			sql = sql + " join personas_postulante ppc \n ";
			sql = sql + "     on cp.pers_ncorr = ppc.pers_ncorr \n ";
			sql = sql + " join ofertas_academicas oa \n ";
			sql = sql + "     on p.ofer_ncorr = oa.ofer_ncorr \n ";
			sql = sql + " join especialidades ee \n ";
			sql = sql + "     on oa.espe_ccod = ee.espe_ccod \n ";
			sql = sql + " join carreras cc \n ";
			sql = sql + "     on ee.carr_ccod = cc.carr_ccod \n ";
			sql = sql + " join direcciones_publica ddp \n ";
			sql = sql + "     on pp.pers_ncorr = ddp.pers_ncorr \n ";
			sql = sql + " left outer join ciudades ccp \n ";
			sql = sql + "     on ddp.ciud_ccod =ccp.ciud_ccod \n ";
			sql = sql + " join direcciones_publica ddc \n ";
			sql = sql + "     on ppc.pers_ncorr = ddc.pers_ncorr \n ";
			sql = sql + " left outer join ciudades c \n ";
			sql = sql + "     on ddc.ciud_ccod =c.ciud_ccod \n ";
			sql = sql + " join periodos_academicos pac \n ";
			sql = sql + "     on oa.peri_ccod = pac.peri_ccod \n ";
			sql = sql + " join contratos con  \n ";
			sql = sql + "     on con.post_ncorr = p.post_ncorr \n ";
			sql = sql + " join pagare_upa pag \n ";
			sql = sql + "     on con.cont_ncorr = pag.cont_ncorr  \n ";
			sql = sql + "     and isnull(pag.opag_ccod,1) not in (2)  \n ";
			sql = sql + " join sedes ss \n ";
			sql = sql + "     on oa.sede_ccod = ss.sede_ccod \n ";
			sql = sql + " join ciudades ciu  \n ";
			sql = sql + "     on ss.ciud_ccod = ciu.ciud_ccod \n ";
			sql = sql + " join compromisos cps   \n ";
			sql = sql + "     on con.cont_ncorr=cps.comp_ndocto   \n ";
			sql = sql + "  join detalle_compromisos dc  \n ";
			sql = sql + "     on cps.comp_ndocto=dc.comp_ndocto \n ";  
			sql = sql + " 	and cps.inst_ccod=dc.inst_ccod   \n ";
			sql = sql + " 	and cps.tcom_ccod=dc.tcom_ccod    \n ";
			sql = sql + "  left outer join detalle_ingresos dii  \n ";
			sql = sql + "     on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod   \n ";
			sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
			sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto     \n ";
			sql = sql + "  left outer join ingresos ii  \n ";
			sql = sql + "     on dii.ingr_ncorr = ii.ingr_ncorr \n ";
			sql = sql + "  left outer join tipos_ingresos tii  \n ";
			sql = sql + "     on dii.ting_ccod =tii.ting_ccod  \n ";
			sql = sql + "  left outer join bancos bn  \n ";
			sql = sql + "     on dii.banc_ccod = bn.banc_ccod \n ";
			sql = sql + " WHERE   \n ";
			sql = sql + "  p.post_ncorr = ISNULL('" +post_ncorr+ "', '0')  \n ";
			sql = sql + "  AND ddc.tdir_ccod = 1  \n ";
			sql = sql + " AND ddp.tdir_ccod = 1  \n ";
			sql = sql + "  and isnull(dii.ting_ccod, 0) in (66) \n ";
			sql = sql + "  and cps.ecom_ccod <> 3   \n ";
			sql = sql + " and con.econ_ccod in (1, 2)   \n ";
			sql = sql + " and cps.tcom_ccod in (2)   \n ";
			sql = sql + " and dc.tcom_ccod in (2)   \n ";
			
			//Response.Write(sql);
			//Response.Flush();
			return (sql);

		}

		private string EscribirPagareFinanza( string paga_ncorr)
		{
			string sql;
		    
			sql =  "SELECT con.cont_ncorr AS ciudad_codeudor1, pag.paga_ncorr nro_pagare, \n ";
				sql = sql + " cps.comp_mdocumento AS valor_pagar,cps.COMP_NCUOTAS AS NUMERO_CUOTAS, \n ";
				sql = sql + " cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago, \n ";
				sql = sql + " (SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy, \n ";
				sql = sql + " cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,\n "; 
				sql = sql + " dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco ,\n";
				sql = sql + " cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc \n ";
				sql = sql + " ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento, \n ";
				sql = sql + "(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post, \n ";
				sql = sql + " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno, \n ";
				sql = sql + " cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor, \n ";
				sql = sql + " ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno \n ";
				sql = sql + " AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor, \n ";
				sql = sql + " c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,\n ";
				sql = sql + "  ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor \n ";
				sql = sql + " FROM postulantes p \n ";
				sql = sql + " join personas_postulante pp \n ";
				sql = sql + "     on p.pers_ncorr = pp.pers_ncorr \n ";
				sql = sql + " join codeudor_postulacion cp \n ";
				sql = sql + "     on p.post_ncorr = cp.post_ncorr \n ";
				sql = sql + " join personas_postulante ppc \n ";
				sql = sql + "     on cp.pers_ncorr = ppc.pers_ncorr \n ";
				sql = sql + " join ofertas_academicas oa \n ";
				sql = sql + "     on p.ofer_ncorr = oa.ofer_ncorr \n ";
				sql = sql + " join especialidades ee \n ";
				sql = sql + "     on oa.espe_ccod = ee.espe_ccod \n ";
				sql = sql + " join carreras cc \n ";
				sql = sql + "     on ee.carr_ccod = cc.carr_ccod \n ";
				sql = sql + " join direcciones_publica ddp \n ";
				sql = sql + "     on pp.pers_ncorr = ddp.pers_ncorr \n ";
				sql = sql + " left outer join ciudades ccp \n ";
				sql = sql + "     on ddp.ciud_ccod =ccp.ciud_ccod \n ";
				sql = sql + " join direcciones_publica ddc \n ";
				sql = sql + "     on ppc.pers_ncorr = ddc.pers_ncorr \n ";
				sql = sql + " left outer join ciudades c \n ";
				sql = sql + "     on ddc.ciud_ccod =c.ciud_ccod \n ";
				sql = sql + " join periodos_academicos pac \n ";
				sql = sql + "     on oa.peri_ccod = pac.peri_ccod \n ";
				sql = sql + " join contratos con  \n ";
				sql = sql + "     on con.post_ncorr = p.post_ncorr \n ";
				sql = sql + " join pagares pag \n ";
				sql = sql + "     on con.cont_ncorr = pag.cont_ncorr  \n ";
				sql = sql + " join sedes ss \n ";
				sql = sql + "     on oa.sede_ccod = ss.sede_ccod \n ";
				sql = sql + " join ciudades ciu  \n ";
				sql = sql + "     on ss.ciud_ccod = ciu.ciud_ccod \n ";
				sql = sql + " join compromisos cps   \n ";
				sql = sql + "     on con.cont_ncorr=cps.comp_ndocto   \n ";
				sql = sql + "  join detalle_compromisos dc  \n ";
				sql = sql + "     on cps.comp_ndocto=dc.comp_ndocto \n ";  
				sql = sql + " 	and cps.inst_ccod=dc.inst_ccod   \n ";
				sql = sql + " 	and cps.tcom_ccod=dc.tcom_ccod    \n ";
				sql = sql + "  left outer join detalle_ingresos dii  \n ";
				sql = sql + "     on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod   \n ";
				sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
				sql = sql + " 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto     \n ";
				sql = sql + "  left outer join ingresos ii  \n ";
				sql = sql + "     on dii.ingr_ncorr = ii.ingr_ncorr \n ";
				sql = sql + "  left outer join tipos_ingresos tii  \n ";
				sql = sql + "     on dii.ting_ccod =tii.ting_ccod  \n ";
				sql = sql + "  left outer join bancos bn  \n ";
				sql = sql + "     on dii.banc_ccod = bn.banc_ccod \n ";
				sql = sql + " WHERE   \n ";
				sql = sql + "  cast(pag.paga_ncorr as varchar) = '" +paga_ncorr+ "'  \n ";
				sql = sql + "  AND ddc.tdir_ccod = 1  \n ";
				sql = sql + " AND ddp.tdir_ccod = 1  \n ";
				sql = sql + "  and isnull(dii.ting_ccod, 0) in (52) \n ";
				sql = sql + "  and cps.ecom_ccod <> 3   \n ";
				sql = sql + " and con.econ_ccod in (1, 2)   \n ";
				sql = sql + " and cps.tcom_ccod in (2)   \n ";
				sql = sql + " and dc.tcom_ccod in (2)   \n ";


			return (sql);
		
		}
		private string EscribirPagareRepactacion( string repa_ncorr, string post_ncorr)
		{
			string sql;
				sql =  " SELECT \n ";
				sql = sql + "	rp.repa_ncorr AS ciudad_codeudor1, pag.paga_ncorr nro_pagare,   \n ";
				sql = sql + "	protic.obtiene_monto_pagare(rp.repa_ncorr,'M') AS valor_pagar,protic.obtiene_monto_pagare(rp.repa_ncorr,'C') AS NUMERO_CUOTAS,   \n ";
				sql = sql + "	cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago,   \n ";
				sql = sql + "	(SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy,   \n ";
				sql = sql + "	cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,   \n ";
				sql = sql + "	dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco , \n ";
				sql = sql + "	cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc   \n ";
				sql = sql + "	ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento,   \n ";
				sql = sql + "	(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post,   \n ";
				sql = sql + "	pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno,   \n ";
				sql = sql + "	cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor,   \n ";
				sql = sql + "	ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno   \n ";
				sql = sql + "	AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor,   \n ";
				sql = sql + "	c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,  \n ";
				sql = sql + "	ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor   \n ";
				sql = sql + " FROM postulantes p   \n ";
				sql = sql + "join personas_postulante pp   \n ";
				sql = sql + "	on p.pers_ncorr = pp.pers_ncorr \n ";
				sql = sql + "	and cast(p.post_ncorr as varchar)='"+post_ncorr+"'   \n ";
				sql = sql + "join codeudor_postulacion cp   \n ";
				sql = sql + "	on p.post_ncorr = cp.post_ncorr   \n ";
				sql = sql + "join personas_postulante ppc   \n ";
				sql = sql + "	on cp.pers_ncorr = ppc.pers_ncorr \n ";  
				sql = sql + "join ofertas_academicas oa   \n ";
				sql = sql + "	on p.ofer_ncorr = oa.ofer_ncorr \n ";  
				sql = sql + "join especialidades ee   \n ";
				sql = sql + "	on oa.espe_ccod = ee.espe_ccod   \n ";
				sql = sql + "join carreras cc   \n ";
				sql = sql + "	on ee.carr_ccod = cc.carr_ccod   \n ";
				sql = sql + "join direcciones_publica ddp   \n ";
				sql = sql + "	on pp.pers_ncorr = ddp.pers_ncorr \n ";  
				sql = sql + "left outer join ciudades ccp   \n ";
				sql = sql + "	on ddp.ciud_ccod =ccp.ciud_ccod   \n ";
				sql = sql + "join direcciones_publica ddc   \n ";
				sql = sql + "	on ppc.pers_ncorr = ddc.pers_ncorr   \n ";
				sql = sql + "left outer join ciudades c   \n ";
				sql = sql + "	on ddc.ciud_ccod =c.ciud_ccod   \n ";
				sql = sql + "join periodos_academicos pac   \n ";
				sql = sql + "	on oa.peri_ccod = pac.peri_ccod   \n ";
				sql = sql + "join compromisos cps     \n ";
				sql = sql + "	on p.pers_ncorr=cps.pers_ncorr \n ";
				sql = sql + "	and cps.tcom_ccod=3     \n ";
				sql = sql + "join repactaciones rp \n ";
				sql = sql + "	on cps.comp_ndocto=rp.repa_ncorr \n ";
				sql = sql + "join pagares pag   \n ";
				sql = sql + "	on rp.repa_ncorr=pag.cont_ncorr  \n ";
				sql = sql + "	and opag_ccod=2       \n ";
				sql = sql + "join sedes ss   \n ";
				sql = sql + "	on oa.sede_ccod = ss.sede_ccod   \n ";
				sql = sql + "join ciudades ciu    \n ";
				sql = sql + "	on ss.ciud_ccod = ciu.ciud_ccod   \n ";
				sql = sql + "join detalle_compromisos dc    \n ";
				sql = sql + "	on cps.comp_ndocto=dc.comp_ndocto \n ";    
				sql = sql + "	and cps.inst_ccod=dc.inst_ccod     \n ";
				sql = sql + "	and cps.tcom_ccod=dc.tcom_ccod      \n ";
				sql = sql + "left outer join detalle_ingresos dii    \n ";
				sql = sql + "	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod    \n ";
				sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
				sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto  \n ";
				sql = sql + "left outer join ingresos ii    \n ";
				sql = sql + "	on dii.ingr_ncorr = ii.ingr_ncorr \n ";  
				sql = sql + "left outer join tipos_ingresos tii   \n ";
				sql = sql + "	on dii.ting_ccod =tii.ting_ccod   \n ";
				sql = sql + "left outer join bancos bn    \n ";
				sql = sql + "	on dii.banc_ccod = bn.banc_ccod \n ";  
				sql = sql + "WHERE  cast(rp.repa_ncorr as varchar) = '"+repa_ncorr+"' \n ";
				sql = sql + "and ddc.tdir_ccod = 1    \n ";
				sql = sql + "AND ddp.tdir_ccod = 1    \n ";
				sql = sql + "and isnull(dii.ting_ccod, 0) in (52)   \n ";
				sql = sql + "and cps.ecom_ccod <> 3     \n ";
				sql = sql + "and cps.tcom_ccod in (3)   \n ";
				sql = sql + "and dc.tcom_ccod in (3)    \n ";
//Response.Write(sql);
//Response.Flush();
		return (sql);
		
	}

		private string EscribirPagareRepactacionMultidebito( string repa_ncorr, string post_ncorr)
		{
			string sql;
			sql =  " SELECT \n ";
			sql = sql + "	rp.repa_ncorr AS ciudad_codeudor1, pag.pmul_ncorr nro_pagare,   \n ";
			sql = sql + "	protic.obtiene_monto_pagare_multidebito(rp.repa_ncorr,'M') AS valor_pagar,protic.obtiene_monto_pagare_multidebito(rp.repa_ncorr,'C') AS NUMERO_CUOTAS,   \n ";
			sql = sql + "	cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago,   \n ";
			sql = sql + "	(SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy,   \n ";
			sql = sql + "	cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,   \n ";
			sql = sql + "	dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco , \n ";
			sql = sql + "	cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc   \n ";
			sql = sql + "	ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento,   \n ";
			sql = sql + "	(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post,   \n ";
			sql = sql + "	pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno,   \n ";
			sql = sql + "	cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor,   \n ";
			sql = sql + "	ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno   \n ";
			sql = sql + "	AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor,   \n ";
			sql = sql + "	c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,  \n ";
			sql = sql + "	ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor   \n ";
			sql = sql + " FROM postulantes p   \n ";
			sql = sql + "join personas_postulante pp   \n ";
			sql = sql + "	on p.pers_ncorr = pp.pers_ncorr \n ";
			sql = sql + "	and cast(p.post_ncorr as varchar)='"+post_ncorr+"'   \n ";
			sql = sql + "join codeudor_postulacion cp   \n ";
			sql = sql + "	on p.post_ncorr = cp.post_ncorr   \n ";
			sql = sql + "join personas_postulante ppc   \n ";
			sql = sql + "	on cp.pers_ncorr = ppc.pers_ncorr \n ";  
			sql = sql + "join ofertas_academicas oa   \n ";
			sql = sql + "	on p.ofer_ncorr = oa.ofer_ncorr \n ";  
			sql = sql + "join especialidades ee   \n ";
			sql = sql + "	on oa.espe_ccod = ee.espe_ccod   \n ";
			sql = sql + "join carreras cc   \n ";
			sql = sql + "	on ee.carr_ccod = cc.carr_ccod   \n ";
			sql = sql + "join direcciones_publica ddp   \n ";
			sql = sql + "	on pp.pers_ncorr = ddp.pers_ncorr \n ";  
			sql = sql + "left outer join ciudades ccp   \n ";
			sql = sql + "	on ddp.ciud_ccod =ccp.ciud_ccod   \n ";
			sql = sql + "join direcciones_publica ddc   \n ";
			sql = sql + "	on ppc.pers_ncorr = ddc.pers_ncorr   \n ";
			sql = sql + "left outer join ciudades c   \n ";
			sql = sql + "	on ddc.ciud_ccod =c.ciud_ccod   \n ";
			sql = sql + "join periodos_academicos pac   \n ";
			sql = sql + "	on oa.peri_ccod = pac.peri_ccod   \n ";
			sql = sql + "join compromisos cps     \n ";
			sql = sql + "	on p.pers_ncorr=cps.pers_ncorr \n ";
			sql = sql + "	and cps.tcom_ccod=3     \n ";
			sql = sql + "join repactaciones rp \n ";
			sql = sql + "	on cps.comp_ndocto=rp.repa_ncorr \n ";
			sql = sql + "join pagare_multidebito pag   \n ";
			sql = sql + "	on rp.repa_ncorr=pag.cont_ncorr  \n ";
			sql = sql + "	and opag_ccod=2       \n ";
			sql = sql + "join sedes ss   \n ";
			sql = sql + "	on oa.sede_ccod = ss.sede_ccod   \n ";
			sql = sql + "join ciudades ciu    \n ";
			sql = sql + "	on ss.ciud_ccod = ciu.ciud_ccod   \n ";
			sql = sql + "join detalle_compromisos dc    \n ";
			sql = sql + "	on cps.comp_ndocto=dc.comp_ndocto \n ";    
			sql = sql + "	and cps.inst_ccod=dc.inst_ccod     \n ";
			sql = sql + "	and cps.tcom_ccod=dc.tcom_ccod      \n ";
			sql = sql + "left outer join detalle_ingresos dii    \n ";
			sql = sql + "	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod    \n ";
			sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
			sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto  \n ";
			sql = sql + "left outer join ingresos ii    \n ";
			sql = sql + "	on dii.ingr_ncorr = ii.ingr_ncorr \n ";  
			sql = sql + "left outer join tipos_ingresos tii   \n ";
			sql = sql + "	on dii.ting_ccod =tii.ting_ccod   \n ";
			sql = sql + "left outer join bancos bn    \n ";
			sql = sql + "	on dii.banc_ccod = bn.banc_ccod \n ";  
			sql = sql + "WHERE  cast(rp.repa_ncorr as varchar) = '"+repa_ncorr+"' \n ";
			sql = sql + "and ddc.tdir_ccod = 1    \n ";
			sql = sql + "AND ddp.tdir_ccod = 1    \n ";
			sql = sql + "and isnull(dii.ting_ccod, 0) in (59)   \n ";
			sql = sql + "and cps.ecom_ccod <> 3     \n ";
			sql = sql + "and cps.tcom_ccod in (3)   \n ";
			sql = sql + "and dc.tcom_ccod in (3)    \n ";
			//Response.Write(sql);
			//Response.Flush();
			return (sql);
		
		}

		private string EscribirPagareRepactacionUpa( string repa_ncorr, string post_ncorr)
		{
			string sql;
			sql =  " SELECT \n ";
			sql = sql + "	rp.repa_ncorr AS ciudad_codeudor1, pag.pupa_ncorr nro_pagare,   \n ";
			sql = sql + "	protic.obtiene_monto_pagare_upa(rp.repa_ncorr,'M') AS valor_pagar,protic.obtiene_monto_pagare_upa(rp.repa_ncorr,'C') AS NUMERO_CUOTAS,   \n ";
			sql = sql + "	cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,protic.trunc(dii.ding_fdocto) as fecha_pago,   \n ";
			sql = sql + "	(SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy,   \n ";
			sql = sql + "	cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,   \n ";
			sql = sql + "	dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco , \n ";
			sql = sql + "	cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc   \n ";
			sql = sql + "	ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento,   \n ";
			sql = sql + "	(pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post,   \n ";
			sql = sql + "	pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno,   \n ";
			sql = sql + "	cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor,   \n ";
			sql = sql + "	ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno   \n ";
			sql = sql + "	AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor,   \n ";
			sql = sql + "	c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,  \n ";
			sql = sql + "	ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor   \n ";
			sql = sql + " FROM postulantes p   \n ";
			sql = sql + "join personas_postulante pp   \n ";
			sql = sql + "	on p.pers_ncorr = pp.pers_ncorr \n ";
			sql = sql + "	and cast(p.post_ncorr as varchar)='"+post_ncorr+"'   \n ";
			sql = sql + "join codeudor_postulacion cp   \n ";
			sql = sql + "	on p.post_ncorr = cp.post_ncorr   \n ";
			sql = sql + "join personas_postulante ppc   \n ";
			sql = sql + "	on cp.pers_ncorr = ppc.pers_ncorr \n ";  
			sql = sql + "join ofertas_academicas oa   \n ";
			sql = sql + "	on p.ofer_ncorr = oa.ofer_ncorr \n ";  
			sql = sql + "join especialidades ee   \n ";
			sql = sql + "	on oa.espe_ccod = ee.espe_ccod   \n ";
			sql = sql + "join carreras cc   \n ";
			sql = sql + "	on ee.carr_ccod = cc.carr_ccod   \n ";
			sql = sql + "join direcciones_publica ddp   \n ";
			sql = sql + "	on pp.pers_ncorr = ddp.pers_ncorr \n ";  
			sql = sql + "left outer join ciudades ccp   \n ";
			sql = sql + "	on ddp.ciud_ccod =ccp.ciud_ccod   \n ";
			sql = sql + "join direcciones_publica ddc   \n ";
			sql = sql + "	on ppc.pers_ncorr = ddc.pers_ncorr   \n ";
			sql = sql + "left outer join ciudades c   \n ";
			sql = sql + "	on ddc.ciud_ccod =c.ciud_ccod   \n ";
			sql = sql + "join periodos_academicos pac   \n ";
			sql = sql + "	on oa.peri_ccod = pac.peri_ccod   \n ";
			sql = sql + "join compromisos cps     \n ";
			sql = sql + "	on p.pers_ncorr=cps.pers_ncorr \n ";
			sql = sql + "	and cps.tcom_ccod=3     \n ";
			sql = sql + "join repactaciones rp \n ";
			sql = sql + "	on cps.comp_ndocto=rp.repa_ncorr \n ";
			sql = sql + "join pagare_upa pag   \n ";
			sql = sql + "	on rp.repa_ncorr=pag.cont_ncorr  \n ";
			sql = sql + "	and opag_ccod=2       \n ";
			sql = sql + "join sedes ss   \n ";
			sql = sql + "	on oa.sede_ccod = ss.sede_ccod   \n ";
			sql = sql + "join ciudades ciu    \n ";
			sql = sql + "	on ss.ciud_ccod = ciu.ciud_ccod   \n ";
			sql = sql + "join detalle_compromisos dc    \n ";
			sql = sql + "	on cps.comp_ndocto=dc.comp_ndocto \n ";    
			sql = sql + "	and cps.inst_ccod=dc.inst_ccod     \n ";
			sql = sql + "	and cps.tcom_ccod=dc.tcom_ccod      \n ";
			sql = sql + "left outer join detalle_ingresos dii    \n ";
			sql = sql + "	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod    \n ";
			sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr   \n ";
			sql = sql + "	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto  \n ";
			sql = sql + "left outer join ingresos ii    \n ";
			sql = sql + "	on dii.ingr_ncorr = ii.ingr_ncorr \n ";  
			sql = sql + "left outer join tipos_ingresos tii   \n ";
			sql = sql + "	on dii.ting_ccod =tii.ting_ccod   \n ";
			sql = sql + "left outer join bancos bn    \n ";
			sql = sql + "	on dii.banc_ccod = bn.banc_ccod \n ";  
			sql = sql + "WHERE  cast(rp.repa_ncorr as varchar) = '"+repa_ncorr+"' \n ";
			sql = sql + "and ddc.tdir_ccod = 1    \n ";
			sql = sql + "AND ddp.tdir_ccod = 1    \n ";
			sql = sql + "and isnull(dii.ting_ccod, 0) in (66)   \n ";
			sql = sql + "and cps.ecom_ccod <> 3     \n ";
			sql = sql + "and cps.tcom_ccod in (3)   \n ";
			sql = sql + "and dc.tcom_ccod in (3)    \n ";
			//Response.Write(sql);
			//Response.Flush();
			return (sql);
		
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			
			string sql;
			string post_ncorr;
			string paga_ncorr;
			string imprimirFinanza;
			string paga_ncorr_d;
			string repa_ncorr;
			int fila = 0;	
			string tipo_pagare;
			
			
			post_ncorr = Request.QueryString["post_ncorr"];
			imprimirFinanza= Request.QueryString["imprimir"];
			repa_ncorr= Request.QueryString["repa_ncorr"];
			tipo_pagare = Request.QueryString["tipo_pagare"];


			if ( imprimirFinanza=="S")
			{
				
				// para las repactaciones
				if(repa_ncorr !="") 
				{
						
					//sql = EscribirPagareRepactacion(repa_ncorr,post_ncorr);

					if (tipo_pagare=="U")
					{ 
						sql = EscribirPagareRepactacionUpa(repa_ncorr,post_ncorr);
					}
					else if(tipo_pagare=="M")
					{
						sql = EscribirPagareRepactacionMultidebito(repa_ncorr,post_ncorr);
					}
					else
					{
						sql = EscribirPagareRepactacion(repa_ncorr,post_ncorr);
					}

					oleDbDataAdapter1.SelectCommand.CommandText = sql;
					oleDbDataAdapter1.Fill(datosPagare1);
					fila++;	
				}
				else
				{
					for (int i = 0; i < Request.Form.Count; i++)
					{
						paga_ncorr_d="letras[" + fila + "][paga_ncorr]";
						//Response.Write(paga_ncorr_d+ "<br>");
	                    
						if (Request.Form[i] != "") 
						{
							paga_ncorr=Request.Form[i];
						    
							sql = EscribirPagareFinanza(paga_ncorr);
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(datosPagare1);
							fila++;	
						
						}
						
					}
				}
			}
			else
				{
				if (tipo_pagare=="U")
				{ 
					sql = EscribirCodigoPagaUpa(post_ncorr);
					oleDbDataAdapter1.SelectCommand.CommandText = sql;
					oleDbDataAdapter1.Fill(datosPagare1);

				}				
				else if(tipo_pagare=="M")
				{
					sql = EscribirCodigoMultidebito(post_ncorr);
					oleDbDataAdapter1.SelectCommand.CommandText = sql;
					oleDbDataAdapter1.Fill(datosPagare1);
				}
				else
				{
					sql = EscribirCodigo(post_ncorr);
					oleDbDataAdapter1.SelectCommand.CommandText = sql;
					oleDbDataAdapter1.Fill(datosPagare1);
				}
			
			}

			CrystalReportPagare reporte = new CrystalReportPagare();
			CrystalReportMultidebito reporteMulti = new CrystalReportMultidebito();
			CrystalReportPagaUpa reporteUpa = new CrystalReportPagaUpa();


			
			if(tipo_pagare=="U")
			{
				reporteUpa.SetDataSource(datosPagare1);
				VerPagare.ReportSource = reporteUpa;
				ExportarPDF(reporteUpa);
			}
			else if(tipo_pagare=="M")
			{
				reporteMulti.SetDataSource(datosPagare1);
				VerPagare.ReportSource = reporteMulti;
				ExportarPDF(reporteMulti);
			}
			else
			{
				reporte.SetDataSource(datosPagare1);
				VerPagare.ReportSource = reporte;
				ExportarPDF(reporte);
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
			this.datosPagare1 = new imprimir_pagare.datosPagare();
			this.dataSet11 = new imprimir_pagare.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "PAGARE", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_SEDE", "CIUDAD_SEDE"),
																																																				  new System.Data.Common.DataColumnMapping("NRO_PAGARE", "NRO_PAGARE"),
																																																				  new System.Data.Common.DataColumnMapping("VALOR_PAGAR", "VALOR_PAGAR"),
																																																				  new System.Data.Common.DataColumnMapping("DD_HOY", "DD_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("MM_HOY", "MM_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("YY_HOY", "YY_HOY"),
																																																				  new System.Data.Common.DataColumnMapping("PERIODO_ACADEMICO", "PERIODO_ACADEMICO"),
																																																				  new System.Data.Common.DataColumnMapping("INICIO_VENCIMIENTO", "INICIO_VENCIMIENTO"),
																																																				  new System.Data.Common.DataColumnMapping("FINAL_VENCIMIENTO", "FINAL_VENCIMIENTO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_CODEUDOR", "RUT_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_CODEUDOR", "NOMBRE_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECCION_CODEUDOR", "DIRECCION_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_CODEUDOR", "CIUDAD_CODEUDOR"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECCION_POSTULANTE", "DIRECCION_POSTULANTE"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_CODEUDOR1", "CIUDAD_CODEUDOR1"),
																																																				  new System.Data.Common.DataColumnMapping("VALOR_CUOTA", "VALOR_CUOTA"),
																																																				  new System.Data.Common.DataColumnMapping("NUMERO_CUOTAS", "NUMERO_CUOTAS"),
																																																				  new System.Data.Common.DataColumnMapping("FECHA_PAGO", "FECHA_PAGO"),
																																																				  new System.Data.Common.DataColumnMapping("BANCO", "BANCO"),
																																																				  new System.Data.Common.DataColumnMapping("CUENTA_CTE", "CUENTA_CTE")})});
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CIUDAD_SEDE, '' AS NRO_PAGARE, '' AS VALOR_PAGAR, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS PERIODO_ACADEMICO, '' AS INICIO_VENCIMIENTO, '' AS FINAL_VENCIMIENTO, '' AS RUT_POST, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS DIRECCION_CODEUDOR, '' AS CIUDAD_CODEUDOR, '' AS DIRECCION_POSTULANTE, '' AS CIUDAD_CODEUDOR, '' AS VALOR_CUOTA, '' AS NUMERO_CUOTAS, '' AS FECHA_PAGO, '' AS BANCO, '' AS CUENTA_CTE, '' AS COMUNA_CODEUDOR";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
			// 
			// datosPagare1
			// 
			this.datosPagare1.DataSetName = "datosPagare";
			this.datosPagare1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosPagare1.Namespace = "http://www.tempuri.org/datosPagare.xsd";
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}
	}
}
