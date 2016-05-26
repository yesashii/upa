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

namespace CuentaCorriente
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected CuentaCorriente.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand4;
		protected System.Data.OleDb.OleDbCommand oleDbInsertCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbUpdateCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbDeleteCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter4;

		private bool bsolo_pendientes;

	
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
			//Response.Write(ruta_exportacion);
			//Response.Flush();
			//diskOpts.DiskFileName = ruta_exportacion + "preuba" + ".pdf";			
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

		string generar_sql_detalles(string pers_ncorr,string filtro,string peri_sel)
		{
			string sql;


			sql="";

			sql = " select b.inst_ccod, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')' else cast(b.comp_ndocto as varchar) end as comp_ndocto, \n";
			sql = sql +  "		b.tcom_ccod, b.dcom_ncompromiso, cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, \n";
			sql = sql +  "         protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod, \n";
			sql = sql +  "         protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, \n";
			sql = sql +  "         protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, \n";
			sql = sql +  "     	isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,  \n";
			sql = sql +  " 		d.edin_ccod, protic.initcap(d.edin_tdesc +protic.obtener_institucion(c.ingr_ncorr)) as edin_tdesc, i.ting_tdesc, \n";
			sql = sql +  "	--protic.initcap(case d.edin_ccod when 10 then d.edin_tdesc + ' (' + g.tine_tdesc + ')' else d.edin_tdesc end) as edin_tdesc \n";
			sql = sql +  " case ";
			sql = sql +  "   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35";
			sql = sql +  "	 then ";
			sql = sql +  "   (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod ";
			sql = sql +  "   and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) ";
			sql = sql +  "   else h.tcom_tdesc ";
			sql = sql +  " end as tcom_tdesc,";
			sql = sql +  " case  \n";
			sql = sql +  " when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 \n";
			sql = sql +  "    then \n";
			sql = sql +  "      (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) \n";
			sql = sql +  "    else \n";
			sql = sql +  "        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') \n";
			sql = sql +  "    end as ding_ndocto \n";
			sql = sql +  " 		from compromisos a \n";
			sql = sql +  "         join  detalle_compromisos b \n";
			sql = sql +  "             on a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto \n";    
			sql = sql +  "         left outer join detalle_ingresos c \n";
			sql = sql +  "             on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod \n";  
			sql = sql +  " 			and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto \n";
			sql = sql +  " 			and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr \n";
			sql = sql +  "         left outer join estados_detalle_ingresos d \n";
			sql = sql +  "             on c.edin_ccod = d.edin_ccod \n";
			sql = sql +  " 		left outer join envios e \n";
			sql = sql +  "             on c.envi_ncorr = e.envi_ncorr \n";
			sql = sql +  "         left outer join instituciones_envio f \n";
			sql = sql +  "             on e.inen_ccod = f.inen_ccod \n";
			sql = sql +  "         left outer join tipos_instituciones_envio g \n";
			sql = sql +  "             on f.tine_ccod = g.tine_ccod \n";
			sql = sql +  "         join tipos_compromisos h \n";
			sql = sql +  "             on a.tcom_ccod = h.tcom_ccod \n";
			sql = sql +  "         left outer join tipos_ingresos i \n";  
			sql = sql +  " 	        on c.ting_ccod = i.ting_ccod \n";
			sql = sql +  "         where a.ecom_ccod = '1' \n"; 
			sql = sql +  " 			  and b.ecom_ccod = '1' \n"; 
			sql = sql +  " 			  and isnull(b.ecom_ccod, 3) <> 3 \n"; 
			sql = sql +  " 			  and a.pers_ncorr = '" + pers_ncorr + "' \n";

			if (bsolo_pendientes) 
			{			
				
				sql = sql + "  and protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 ";
			}
			
			if (filtro=="SI")
			{
				sql = sql +  " and b.peri_ccod="+peri_sel+ " ";
			}

			sql = sql +  " order by b.dcom_fcompromiso desc \n";
 
			return (sql);
		}

		string generar_sql_datos_alumno(string pers_ncorr, string periodo, string persona,string peri_sel)
		{
			string sql;
		
			if(persona=="SI")
			{	
					sql =  " Select  a.pers_ncorr, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, ";
					sql = sql + "  protic.obtener_rut(a.pers_ncorr) as rut,ISNULL(max(c.sede_tdesc),(select sede_tdesc from sedes where sede_ccod in (select sede_ccod from ofertas_academicas where ofer_ncorr in (protic.ultima_oferta_matriculado(a.pers_ncorr))))) as sede_tdesc, ";
					sql = sql + "  protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CE') as carr_tdesc,";
                    sql = sql + "  isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CC')),protic.ANO_INGRESO_UNIVERSIDAD('"+ pers_ncorr +"')) as ano_ingreso,";
                    sql = sql + " isnull((select upper(ec.econ_tdesc) from contratos co, estados_contrato ec where post_ncorr in (d.post_ncorr)and co.econ_ccod=ec.econ_ccod and co.cont_ncorr in (select max(cont_ncorr) from contratos where post_ncorr in (d.post_ncorr))),'NO MATRICULADO') as estado_matricula, ";
					sql = sql + "  (select case b.emat_ccod when 1 then 'ACTIVO' else b.emat_tdesc end  from alumnos a , estados_matriculas b ";
					sql = sql + " Where a.matr_ncorr in (select max(matr_ncorr) from alumnos where pers_ncorr='"+ pers_ncorr +"') ";
					sql = sql + "    and a.emat_ccod=b.emat_ccod ";
					sql = sql + " ) as estado_alumno ";
					sql = sql + " From  personas a ";
                    sql = sql + "        left outer join  alumnos d";
                    sql = sql + "            on a.pers_ncorr=d.pers_ncorr ";
					sql = sql + "				and d.emat_ccod <>9 ";
                    sql = sql + "        left outer join  ofertas_academicas b ";
                    sql = sql + "            on protic.ultima_oferta_matriculado(a.pers_ncorr) = b.ofer_ncorr ";
                    sql = sql + "            and d.ofer_ncorr=b.ofer_ncorr ";
                    sql = sql + "        left outer join sedes c  ";
                    sql = sql + "            on b.sede_ccod=c.sede_ccod ";
					sql = sql + "  where  a.pers_ncorr = '"+ pers_ncorr +"' ";
					sql = sql + "  Group by a.pers_ncorr,d.post_ncorr ";
			}
			else
			{
				
				/*sql =  "	select  a.pers_ncorr,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, ";   
				sql = sql + " protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,";
				sql = sql + " protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carr_tdesc,      ";
				sql = sql + " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr   ";
				sql = sql + " From alumnos where matr_ncorr='"+ matricula +"' order by matr_ncorr desc),'CC'))) ,     ";
				sql = sql + " protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, case d.econ_ccod when 1 then 'MATRICULADO' when 2 then 'PENDIENTE' else 'NO MATRICULADO' end as estado_matricula,      ";
				sql = sql + " case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno, '' as ingreso_u";
				sql = sql + " From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e ,estados_contrato f     ";
				sql = sql + " where a.ofer_ncorr = b.ofer_ncorr    ";
				sql = sql + " and b.sede_ccod = c.sede_ccod    ";
				sql = sql + " and a.matr_ncorr *= d.matr_ncorr    ";
				sql = sql + " and a.emat_ccod  = e.emat_ccod    ";
				sql = sql + " and a.matr_ncorr = '"+ matricula +"' ";
				sql = sql + " order by d.cont_ncorr desc ";*/

				sql =	" select * from ";
				sql = sql +	" ( select a.pers_ncorr,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, ";
				sql = sql +	" protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,  ";
				sql = sql +	" protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carr_tdesc, ";
				sql = sql +	" isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr  ";
				sql = sql +	" From alumnos where matr_ncorr=a.matr_ncorr ),'CC'))) , protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, ";
				sql = sql +	" case when protic.tiene_contrato_periodo('"+peri_sel+"',a.pers_ncorr)>=1 then 'MATRICULADO' else 'NO MATRICULADO' end as estado_matricula, ";
				sql = sql +	" case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ingreso_u,  ";
				sql = sql +	" (select peri_tdesc from periodos_academicos where peri_ccod='"+peri_sel+"' ) as peri_tdesc  ";
				sql = sql +	" From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e   ";
				sql = sql +	" Where a.ofer_ncorr = b.ofer_ncorr  ";
				sql = sql +	"  and b.sede_ccod  = c.sede_ccod  ";
				sql = sql +	"  and a.matr_ncorr *= d.matr_ncorr  ";
				sql = sql +	"  and d.econ_ccod<>3 ";
				sql = sql +	"  and a.emat_ccod  = e.emat_ccod "; 
				sql = sql +	"  and cast(a.pers_ncorr as varchar)= '" + pers_ncorr + "' ";
				sql = sql +	"  and b.peri_ccod = '" + periodo + "' ";
				sql = sql +	"  and a.emat_ccod<>9) as tabla";
				sql = sql +	" union ";
				sql = sql +	" select * from (";
				sql = sql +	" select a.pers_ncorr,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, ";
				sql = sql +	" protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,  ";
				sql = sql +	" protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carr_tdesc, ";
				sql = sql +	" isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr  ";
				sql = sql +	" From alumnos where matr_ncorr=a.matr_ncorr ),'CC'))) , protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, ";
				sql = sql +	" case when protic.tiene_contrato_periodo('"+peri_sel+"',a.pers_ncorr)>=1 then 'MATRICULADO' else 'NO MATRICULADO' end as estado_matricula, ";
				sql = sql +	" case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ingreso_u,  ";
				sql = sql +	" (select peri_tdesc from periodos_academicos where peri_ccod='"+peri_sel+"' ) as peri_tdesc  ";				
				sql = sql +	" From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e   ";
				sql = sql +	" Where a.ofer_ncorr = b.ofer_ncorr  ";
				sql = sql +	"  and b.sede_ccod  = c.sede_ccod  ";
				sql = sql +	"  and a.matr_ncorr = d.matr_ncorr  ";
				sql = sql +	"  and d.econ_ccod<>3 ";
				sql = sql +	"  and a.emat_ccod  = e.emat_ccod  ";
				sql = sql +	"  and cast(a.pers_ncorr as varchar)= '" + pers_ncorr + "' ";
				sql = sql +	"  and b.peri_ccod = '" + periodo + "' ) as tabla";

			}

			//Response.Write(sql);
			//Response.Flush();

			return sql;
			
		}


		
		string generar_sql_credito(string pers_ncorr)
		{
			string sql="";


			sql =		" SELECT contrato,cont_ncorr, STDE_CCOD, STDE_TDESC, BENE_MMONTO,MONE_CCOD,MAX(BENE_NPORCENTAJE_MATRICULA) AS BENE_NPORCENTAJE_MATRICULA,MAX(BENE_NPORCENTAJE_COLEGIATURA) AS BENE_NPORCENTAJE_COLEGIATURA,TBEN_CCOD,MAX(BENE_FBENEFICIO) AS BENE_FBENEFICIO  ";
			sql = sql + "	From ( ";
			sql = sql + "	select b.peri_ccod,isnull(b.contrato,b.cont_ncorr) as contrato,b.cont_ncorr, e.stde_ccod, e.stde_tdesc, ";
			sql = sql + "	isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto, ";
			sql = sql + "	c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio  ";
			sql = sql + "	from postulantes a, contratos b, beneficios c, stipos_descuentos e  ";
			sql = sql + "	where a.post_ncorr = b.post_ncorr  ";
			sql = sql + "		and b.cont_ncorr = c.cont_ncorr  ";
			sql = sql + "		and c.stde_ccod = e.stde_ccod  ";
			sql = sql + "		and e.tben_ccod <> 1  ";
			sql = sql + "		and b.econ_ccod = '1'  ";
			sql = sql + "		and c.eben_ccod = '1'  ";
			sql = sql + "		and b.econ_ccod <> 3  ";
			sql = sql + "		and cast(a.pers_ncorr as varchar) = '" + pers_ncorr + "' ";			
			sql = sql + "	union  ";
			sql = sql + "	select k.peri_ccod, isnull(k.contrato,k.cont_ncorr) as contrato,k.cont_ncorr, a.stde_ccod, b.stde_tdesc,  ";
			sql = sql + "	cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto,  ";
			sql = sql + "	1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura,  ";
			sql = sql + "	i.tben_ccod, cont_fcontrato as bene_fbeneficio  ";
			sql = sql + "	from sdescuentos a,stipos_descuentos b,sestados_descuentos c,  ";
			sql = sql + "		postulantes d,ofertas_academicas e,personas_postulante f,  ";
			sql = sql + "		especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k  ";
			sql = sql + "	where a.stde_ccod = b.stde_ccod  ";
			sql = sql + "	and a.esde_ccod = c.esde_ccod   ";
			sql = sql + "	and a.post_ncorr = d.post_ncorr   ";
			sql = sql + "	and a.ofer_ncorr = d.ofer_ncorr  ";
			sql = sql + "	and d.ofer_ncorr = e.ofer_ncorr   ";
			sql = sql + "	and d.pers_ncorr = f.pers_ncorr  ";
			sql = sql + "	and e.espe_ccod = g.espe_ccod   ";
			sql = sql + "	and g.carr_ccod = h.carr_ccod  ";
			sql = sql + "	and e.sede_ccod = j.sede_ccod    ";
			sql = sql + "	and b.tben_ccod = i.tben_ccod   ";
			sql = sql + "	and d.post_ncorr=k.post_ncorr  ";
			sql = sql + "	and a.esde_ccod=1 ";
			sql = sql + "	and k.econ_ccod <> 3  ";
			sql = sql + "	and cast(f.pers_ncorr as varchar) ='" + pers_ncorr + "'";
			sql = sql + "	) as tabla  ";																										
			sql = sql + "	group by contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,tben_ccod	";
			
			//sql="select '' ";
			//Response.Write(sql);
			//Response.Flush();

			return (sql);

		}

		string generar_sql_comentarios(string pers_ncorr)
		{
			string sql="";

			sql = " Select a.COME_NCORR, a.COME_TCOMENTARIO,protic.trunc(a.COME_FCOMENTARIO) as COME_FCOMENTARIO,b.TICO_TDESC ,";
			sql=  sql + "   SUBSTRING(c.pers_tnombre, 1, 1)+''+c.pers_tape_paterno as PERS_NCORR_AUTOR  ";
			sql=  sql + "	From comentarios a, tipos_comentarios b, personas c ";
			sql=  sql + "	where a.tico_ccod=b.tico_ccod ";
			sql=  sql + "	and a.pers_ncorr_autor*=c.pers_ncorr ";
			sql=  sql + "	and cast(a.pers_ncorr as varchar)='" + pers_ncorr + "'";
			return (sql);
		}



		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string pers_ncorr,periodo,persona,filtro,peri_sel;
			string q_ocultar_sin_saldo;


			
			pers_ncorr	= Request.QueryString["pers_ncorr"];
			periodo		= Request.QueryString["periodo"];
			persona		= Request.QueryString["persona"];
			filtro	= Request.QueryString["filtro"];
			q_ocultar_sin_saldo = Request.QueryString["ocultar"];
			peri_sel			= Request.QueryString["peri_sel"];
			//pers_ncorr="18949";
			//Periodo="164";

			bsolo_pendientes = false;
			if (q_ocultar_sin_saldo == "S")
				bsolo_pendientes = true;


								
			CrystalReport1 reporte = new CrystalReport1();
			
			
			sql = generar_sql_detalles(pers_ncorr,filtro,peri_sel);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			
			sql = generar_sql_datos_alumno(pers_ncorr,periodo,persona,peri_sel);
			oleDbDataAdapter2.SelectCommand.CommandText = sql;
			oleDbDataAdapter2.Fill(dataSet11);
		

			sql = generar_sql_credito(pers_ncorr);
			oleDbDataAdapter3.SelectCommand.CommandText = sql;
			oleDbDataAdapter3.Fill(dataSet11);

			sql = generar_sql_comentarios(pers_ncorr);
			oleDbDataAdapter4.SelectCommand.CommandText = sql;
			oleDbDataAdapter4.Fill(dataSet11);
            
			reporte.SetDataSource(dataSet11);           			
			CrystalReportViewer1.ReportSource = reporte;
			ExportarPDF(reporte);
		
		}

 

		private void InitializeComponent()
		{
			System.Configuration.AppSettingsReader configurationAppSettings = new System.Configuration.AppSettingsReader();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new CuentaCorriente.DataSet1();
			this.oleDbDataAdapter2 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter3 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			this.oleDbSelectCommand4 = new System.Data.OleDb.OleDbCommand();
			this.oleDbInsertCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbUpdateCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDeleteCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter4 = new System.Data.OleDb.OleDbDataAdapter();
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
																										new System.Data.Common.DataTableMapping("Table", "T_detalles", new System.Data.Common.DataColumnMapping[] {
																																																					  new System.Data.Common.DataColumnMapping("PERS_NCORR", "PERS_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("INST_CCOD", "INST_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("COMP_NDOCTO", "COMP_NDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("TCOM_CCOD", "TCOM_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("DCOM_NCOMPROMISO", "DCOM_NCOMPROMISO"),
																																																					  new System.Data.Common.DataColumnMapping("NCUOTA", "NCUOTA"),
																																																					  new System.Data.Common.DataColumnMapping("COMP_FDOCTO", "COMP_FDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("DCOM_FCOMPROMISO", "DCOM_FCOMPROMISO"),
																																																					  new System.Data.Common.DataColumnMapping("DCOM_MCOMPROMISO", "DCOM_MCOMPROMISO"),
																																																					  new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("ABONOS", "ABONOS"),
																																																					  new System.Data.Common.DataColumnMapping("SALDO", "SALDO"),
																																																					  new System.Data.Common.DataColumnMapping("EDIN_CCOD", "EDIN_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("EDIN_TDESC", "EDIN_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("TCOM_TDESC", "TCOM_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("TING_TDESC", "TING_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("DOCUMENTADO", "DOCUMENTADO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS PERS_NCORR, '' AS INST_CCOD, '' AS COMP_NDOCTO, '' AS TCOM_CCOD, '' AS DCOM_NCOMPROMISO, '' AS NCUOTA, '' AS COMP_FDOCTO, '' AS DCOM_FCOMPROMISO, '' AS DCOM_MCOMPROMISO, '' AS TING_CCOD, '' AS DING_NDOCTO, '' AS ABONOS, '' AS SALDO, '' AS EDIN_CCOD, '' AS EDIN_TDESC, '' AS TCOM_TDESC, '' AS TING_TDESC, '' AS DOCUMENTADO ";
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
																										new System.Data.Common.DataTableMapping("Table", "T_Alumno", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("PERS_NCORR", "PERS_NCORR"),
																																																					new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																					new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("ANO_INGRESO", "ANO_INGRESO"),
																																																					new System.Data.Common.DataColumnMapping("ESTADO_MATRICULA", "ESTADO_MATRICULA"),
																																																					new System.Data.Common.DataColumnMapping("ESTADO_ALUMNO", "ESTADO_ALUMNO")})});
			this.oleDbDataAdapter2.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter2_RowUpdated);
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS PERS_NCORR, \'\' AS RUT, \'\' AS NOMBRE, \'\' AS CARR_TDESC, \'\' AS SEDE_TD" +
				"ESC, \'\' AS ANO_INGRESO, \'\' AS ESTADO_MATRICULA, \'\' AS ESTADO_ALUMNO, \'\' AS ingre" +
				"so_u, \'\' AS PERI_TDESC";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter3
			// 
			this.oleDbDataAdapter3.SelectCommand = this.oleDbSelectCommand3;
			this.oleDbDataAdapter3.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "T_Creditos", new System.Data.Common.DataColumnMapping[] {
																																																					  new System.Data.Common.DataColumnMapping("CONT_NCORR", "CONT_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("STDE_CCOD", "STDE_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("STDE_TDESC", "STDE_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("BENE_MMONTO", "BENE_MMONTO"),
																																																					  new System.Data.Common.DataColumnMapping("MONE_CCOD", "MONE_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("BENE_NPORCENTAJE_MATRICULA", "BENE_NPORCENTAJE_MATRICULA"),
																																																					  new System.Data.Common.DataColumnMapping("BENE_NPORCENTAJE_COLEGIATURA", "BENE_NPORCENTAJE_COLEGIATURA"),
																																																					  new System.Data.Common.DataColumnMapping("TBEN_CCOD", "TBEN_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("BENE_FBENEFICIO", "BENE_FBENEFICIO")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT \'\' AS contrato, \'\' AS CONT_NCORR, \'\' AS STDE_CCOD, \'\' AS STDE_TDESC, \'\' AS" +
				" BENE_MMONTO, \'\' AS MONE_CCOD, \'\' AS BENE_NPORCENTAJE_MATRICULA, \'\' AS BENE_NPOR" +
				"CENTAJE_COLEGIATURA, \'\' AS TBEN_CCOD, \'\' AS BENE_FBENEFICIO";
			this.oleDbSelectCommand3.Connection = this.oleDbConnection1;
			// 
			// oleDbSelectCommand4
			// 
			this.oleDbSelectCommand4.CommandText = "SELECT \'\' AS COME_NCORR, \'\' AS COME_TCOMENTARIO, \'\' AS COME_FCOMENTARIO, \'\' AS TI" +
				"CO_TDESC, \'\' AS PERS_NCORR_AUTOR";
			this.oleDbSelectCommand4.Connection = this.oleDbConnection1;
			// 
			// oleDbDataAdapter4
			// 
			this.oleDbDataAdapter4.DeleteCommand = this.oleDbDeleteCommand1;
			this.oleDbDataAdapter4.InsertCommand = this.oleDbInsertCommand1;
			this.oleDbDataAdapter4.SelectCommand = this.oleDbSelectCommand4;
			this.oleDbDataAdapter4.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Comentarios", new System.Data.Common.DataColumnMapping[] {
																																																					   new System.Data.Common.DataColumnMapping("COME_NCORR", "COME_NCORR"),
																																																					   new System.Data.Common.DataColumnMapping("COME_TCOMENTARIO", "COME_TCOMENTARIO"),
																																																					   new System.Data.Common.DataColumnMapping("COME_FCOMENTARIO", "COME_FCOMENTARIO"),
																																																					   new System.Data.Common.DataColumnMapping("TICO_TDESC", "TICO_TDESC"),
																																																					   new System.Data.Common.DataColumnMapping("PERS_NCORR_AUTOR", "PERS_NCORR_AUTOR")})});
			this.oleDbDataAdapter4.UpdateCommand = this.oleDbUpdateCommand1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

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

		private void oleDbDataAdapter2_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}
		
		/// <summary>
		/// Método necesario para admitir el Diseñador, no se puede modificar
		/// el contenido del método con el editor de código.
		/// </summary>
		
		#endregion
	}
}
