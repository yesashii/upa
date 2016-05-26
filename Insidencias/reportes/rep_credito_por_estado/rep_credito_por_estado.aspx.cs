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



namespace rep_credito_por_estado
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection conexion;
		protected rep_credito_por_estado.DataSet1 ds;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		private const int N_CARRERAS_PAGINA = 4;


		private void ExportarPDF(ReportDocument rep) {
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

		private void ExportarEXCEL(ReportDocument rep) {
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



		private string ObtenerSql(string p_sede_ccod, string p_anos_ccod)
		{
			string SQL;

			SQL = " select a.carr_tdesc, a.emat_tdesc, a.ncarrera, trunc( ( a.ncarrera - 1 ) / " + N_CARRERAS_PAGINA + " ) + 1 as pagina, \n";
			SQL = SQL +  "        nvl(b.n_pagares, 0) as n_pagares, \n";
			SQL = SQL +  " 	   nvl(b.nuevos_uf, 0) as nuevos_uf, \n";
			SQL = SQL +  " 	   nvl(b.nuevos_pesos, 0) as nuevos_pesos, \n";
			SQL = SQL +  " 	   nvl(b.antiguos_uf, 0) as antiguos_uf, \n";
			SQL = SQL +  " 	   nvl(b.antiguos_pesos, 0) as antiguos_pesos, \n";
			SQL = SQL +  " 	   nvl(b.total_uf, 0) as total_uf, \n";
			SQL = SQL +  " 	   nvl(b.total_pesos, 0) as total_pesos, \n";
			SQL = SQL +  " 	   nvl(b.porc_nuevos, 0) as porc_nuevos, \n";
			SQL = SQL +  " 	   nvl(b.porc_antiguos, 0) as porc_antiguos \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select a.tipo, a.ncarrera, a.carr_ccod, a.carr_tdesc, b.emat_ccod, b.emat_tdesc \n";
			SQL = SQL +  " 	  from ( \n";
			SQL = SQL +  " 	        select rownum as ncarrera, a.tipo, a.carr_ccod, a.carr_tdesc \n";
			SQL = SQL +  " 			from ( \n";
			SQL = SQL +  " 			      select distinct 0 as tipo, d.carr_ccod, d.carr_tdesc \n";
			SQL = SQL +  " 				  from ofertas_academicas a, especialidades b, periodos_academicos c, carreras d \n";
			SQL = SQL +  " 				  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 				    and a.peri_ccod = c.peri_ccod \n";
			SQL = SQL +  " 					and b.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  " 					and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 					and c.anos_ccod = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " 				  union \n";
			SQL = SQL +  " 				  select 1 as tipo, 'TT' as carr_ccod, 'TODAS LAS CARRERAS' as carr_tdesc from dual \n";
			SQL = SQL +  " 			      order by tipo asc, carr_tdesc asc \n";
			SQL = SQL +  " 				 ) a \n";
			SQL = SQL +  " 			) a, estados_matriculas b \n";
			SQL = SQL +  " 	  where b.emat_ccod <> 9 \n";
			SQL = SQL +  " 	 ) a,  \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select decode(grouping(j.carr_ccod), 1, 'TT', j.carr_ccod) as carr_ccod, k.emat_ccod, count(f.paga_ncorr) as n_pagares_2,        \n";
			SQL = SQL +  " 			   sum(case when nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) > 0 then 1 else 0 end ) as n_pagares, \n";
			SQL = SQL +  " 			   sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) else 0 end) as nuevos_uf, \n";
			SQL = SQL +  " 			   sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then round(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) * nvl(i.ufom_mvalor, 0)) else 0 end) as nuevos_pesos, \n";
			SQL = SQL +  " 			   sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) else 0 end) as antiguos_uf, \n";
			SQL = SQL +  " 			   sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then round(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) * nvl(i.ufom_mvalor, 0)) else 0 end) as antiguos_pesos, \n";
			SQL = SQL +  " 			   sum(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0)) as total_uf, \n";
			SQL = SQL +  " 			   sum(round(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) * nvl(i.ufom_mvalor, 0))) as total_pesos, \n";
			SQL = SQL +  " 			   case when sum(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0)) = 0 then 0 else round(sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) else 0 end) / sum(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0)) * 100, 2) end as porc_nuevos, \n";
			SQL = SQL +  " 			   case when sum(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0)) = 0 then 0 else round(sum(case when es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0) else 0 end) / sum(nvl(g.bene_mmonto_matricula, 0) + nvl(g.bene_mmonto_colegiatura, 0)) * 100, 2) end as porc_antiguos \n";
			SQL = SQL +  " 		from alumnos a, ofertas_academicas b, especialidades c, periodos_academicos d, \n";
			SQL = SQL +  " 		     contratos e, pagares f, beneficios g, tipos_detalle h, uf i, \n";
			SQL = SQL +  " 			 carreras j, estados_matriculas k  \n";
			SQL = SQL +  " 		where a.ofer_ncorr = b.ofer_ncorr \n";
			SQL = SQL +  " 		  and b.espe_ccod = c.espe_ccod \n";
			SQL = SQL +  " 		  and b.peri_ccod = d.peri_ccod \n";
			SQL = SQL +  " 		  and a.post_ncorr = e.post_ncorr \n";
			SQL = SQL +  " 		  and a.matr_ncorr = e.matr_ncorr \n";
			SQL = SQL +  " 		  and e.cont_ncorr = f.cont_ncorr \n";
			SQL = SQL +  " 		  and f.paga_ncorr = g.paga_ncorr \n";
			SQL = SQL +  " 		  and e.cont_ncorr = g.cont_ncorr \n";
			SQL = SQL +  " 		  and g.stde_ccod = h.tdet_ccod   \n";
			SQL = SQL +  " 		  and g.ufom_ncorr = i.ufom_ncorr \n";
			SQL = SQL +  " 		  and c.carr_ccod = j.carr_ccod \n";
			SQL = SQL +  " 		  and a.emat_ccod = k.emat_ccod \n";
			SQL = SQL +  " 		  and e.econ_ccod = 1   \n";
			SQL = SQL +  " 		  and a.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and f.epag_ccod not in (6, 8) \n";
			SQL = SQL +  " 		  and g.eben_ccod = 1 \n";
			SQL = SQL +  " 		  and h.tben_ccod = 1 \n";			
			SQL = SQL +  " 		  and d.anos_ccod = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " 		  and b.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by rollup(k.emat_ccod, j.carr_ccod) \n";
			SQL = SQL +  " 	 ) b \n";
			SQL = SQL +  " where a.emat_ccod = b.emat_ccod (+) \n";
			SQL = SQL +  "   and a.carr_ccod = b.carr_ccod (+) \n";
			SQL = SQL +  " order by a.tipo asc, a.carr_tdesc asc, a.emat_ccod asc \n";


//-----------------------------------------------------------------
			SQL ="";
//-----------------------------------------------------------------

			SQL =" select a.carr_tdesc, a.emat_tdesc, a.ncarrera, ( ( a.ncarrera - 1 ) / " + N_CARRERAS_PAGINA + " ) + 1 as pagina, \n";
			SQL = SQL +  "       isnull(b.n_pagares, 0) as n_pagares, \n";
			SQL = SQL +  " 	   isnull(b.nuevos_uf, 0) as nuevos_uf, \n";
			SQL = SQL +  " 	   isnull(b.nuevos_pesos, 0) as nuevos_pesos, \n";
			SQL = SQL +  " 	   isnull(b.antiguos_uf, 0) as antiguos_uf, \n";
			SQL = SQL +  " 	   isnull(b.antiguos_pesos, 0) as antiguos_pesos, \n";
			SQL = SQL +  " 	   isnull(b.total_uf, 0) as total_uf, \n";
			SQL = SQL +  " 	   isnull(b.total_pesos, 0) as total_pesos, \n";
			SQL = SQL +  " 	   isnull(b.porc_nuevos, 0) as porc_nuevos, \n";
			SQL = SQL +  " 	   isnull(b.porc_antiguos, 0) as porc_antiguos \n";
			SQL = SQL +  " from ( \n";
			SQL = SQL +  "       select a.tipo, a.ncarrera, a.carr_ccod, a.carr_tdesc, b.emat_ccod, b.emat_tdesc \n";
			SQL = SQL +  " 	  from ( \n";
			SQL = SQL +  " 	        select ncarrera=count(*), a.tipo, a.carr_ccod, a.carr_tdesc \n";
			SQL = SQL +  " 			from ( \n";
			SQL = SQL +  " 			      select distinct 0 as tipo, d.carr_ccod, d.carr_tdesc \n";
			SQL = SQL +  " 				  from ofertas_academicas a, especialidades b, periodos_academicos c, carreras d \n";
			SQL = SQL +  " 				  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 				    and a.peri_ccod = c.peri_ccod \n";
			SQL = SQL +  " 					and b.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  " 					and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 					and c.anos_ccod = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " 				  union \n";
			SQL = SQL +  " 				  select 1 as tipo, 'TT' as carr_ccod, 'TODAS LAS CARRERAS' as carr_tdesc  \n";
			SQL = SQL +  " 			      --order by tipo asc, carr_tdesc asc \n";
			SQL = SQL +  " 				 ) a, \n";
			SQL = SQL +  " 			      select distinct 0 as tipo, d.carr_ccod, d.carr_tdesc \n";
			SQL = SQL +  " 				  from ofertas_academicas a, especialidades b, periodos_academicos c, carreras d \n";
			SQL = SQL +  " 				  where a.espe_ccod = b.espe_ccod \n";
			SQL = SQL +  " 				    and a.peri_ccod = c.peri_ccod \n";
			SQL = SQL +  " 					and b.carr_ccod = d.carr_ccod \n";
			SQL = SQL +  " 					and a.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 					and c.anos_ccod = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " 				  union \n";
			SQL = SQL +  " 				  select 1 as tipo, 'TT' as carr_ccod, 'TODAS LAS CARRERAS' as carr_tdesc  \n";
			SQL = SQL +  " 			      --order by tipo asc, carr_tdesc asc \n";
			SQL = SQL +  " 				 ) b \n";
			SQL = SQL +  " 				where a.carr_tdesc  >=  b.carr_tdesc";
			SQL = SQL +  "             group by a.tipo, a.carr_ccod, a.carr_tdesc    \n";
			SQL = SQL +  " 			) a, estados_matriculas b \n";
			SQL = SQL +  " 	  where b.emat_ccod <> 9 \n";
			SQL = SQL +  " 	 ) a,  \n";
			SQL = SQL +  " 	 ( \n";
			SQL = SQL +  " 	  select case grouping(j.carr_ccod) when 1 then 'TT' else j.carr_ccod end as carr_ccod,k.emat_ccod, count(f.paga_ncorr) as n_pagares_2, \n";
			SQL = SQL +  " 			   sum(case when isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) > 0 then 1 else 0 end ) as n_pagares, \n";
			SQL = SQL +  " 			   sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) else 0 end) as nuevos_uf, \n";
			SQL = SQL +  " 			   sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then round(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) * isnull(i.ufom_mvalor, 0) ,2) else 0 end) as nuevos_pesos, \n";
			SQL = SQL +  " 			   sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) else 0 end) as antiguos_uf, \n";
			SQL = SQL +  " 			   sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then round(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) * isnull(i.ufom_mvalor, 0) ,2) else 0 end) as antiguos_pesos, \n";
			SQL = SQL +  " 			   sum(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0)) as total_uf, \n";
			SQL = SQL +  " 			   sum(round(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) * isnull(i.ufom_mvalor, 0) ,2)) as total_pesos, \n";
			SQL = SQL +  " 			   case when sum(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0)) = 0 then 0 else round(sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'S' then isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) else 0 end) / sum(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0)) * 100, 2) end as porc_nuevos, \n";
			SQL = SQL +  " 			   case when sum(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0)) = 0 then 0 else round(sum(case when protic.es_nuevo_carrera(a.pers_ncorr, c.carr_ccod, b.peri_ccod) = 'N' then isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0) else 0 end) / sum(isnull(g.bene_mmonto_matricula, 0) + isnull(g.bene_mmonto_colegiatura, 0)) * 100, 2) end as porc_antiguos \n";
			SQL = SQL +  " 		from alumnos a, ofertas_academicas b, especialidades c, periodos_academicos d, \n";
			SQL = SQL +  " 		     contratos e, pagares f, beneficios g, tipos_detalle h, uf i, \n";
			SQL = SQL +  " 			 carreras j, estados_matriculas k  \n";
			SQL = SQL +  " 		where a.ofer_ncorr = b.ofer_ncorr \n";
			SQL = SQL +  " 		  and b.espe_ccod = c.espe_ccod \n";
			SQL = SQL +  " 		  and b.peri_ccod = d.peri_ccod \n";
			SQL = SQL +  " 		  and a.post_ncorr = e.post_ncorr \n";
			SQL = SQL +  " 		  and a.matr_ncorr = e.matr_ncorr \n";
			SQL = SQL +  " 		  and e.cont_ncorr = f.cont_ncorr \n";
			SQL = SQL +  " 		  and f.paga_ncorr = g.paga_ncorr \n";
			SQL = SQL +  " 		  and e.cont_ncorr = g.cont_ncorr \n";
			SQL = SQL +  " 		  and g.stde_ccod = h.tdet_ccod   \n";
			SQL = SQL +  " 		  and g.ufom_ncorr = i.ufom_ncorr \n";
			SQL = SQL +  " 		  and c.carr_ccod = j.carr_ccod \n";
			SQL = SQL +  " 		  and a.emat_ccod = k.emat_ccod \n";
			SQL = SQL +  " 		  and e.econ_ccod = 1   \n";
			SQL = SQL +  " 		  and a.emat_ccod <> 9 \n";
			SQL = SQL +  " 		  and f.epag_ccod not in (6, 8) \n";
			SQL = SQL +  " 		  and g.eben_ccod = 1 \n";
			SQL = SQL +  " 		  and h.tben_ccod = 1 	\n";		
			SQL = SQL +  " 		  and d.anos_ccod = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " 		  and b.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  " 		group by k.emat_ccod, j.carr_ccod \n";
            SQL = SQL +  "        with rollup \n";
			SQL = SQL +  " 	 ) b \n";
			SQL = SQL +  " where a.emat_ccod *= b.emat_ccod  \n";
			SQL = SQL +  "   and a.carr_ccod *= b.carr_ccod \n";
			SQL = SQL +  " order by a.tipo asc, a.carr_tdesc asc, a.emat_ccod asc \n";

			return SQL;

		}

	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			crCreditosCarreras rep = new crCreditosCarreras();
			string q_sede_ccod = Request["filtros[0][sede_ccod]"].ToString();
			string q_anos_ccod = Request["filtros[0][anos_ccod]"].ToString();
			string q_formato = Request["filtros[0][formato]"].ToString();


			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_sede_ccod, q_anos_ccod);
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
			this.ds = new rep_credito_por_estado.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "CARRERAS_ESTADOS", new System.Data.Common.DataColumnMapping[] {
																																																					  new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("EMAT_TDESC", "EMAT_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("N_PAGARES", "N_PAGARES"),
																																																					  new System.Data.Common.DataColumnMapping("NUEVOS_UF", "NUEVOS_UF"),
																																																					  new System.Data.Common.DataColumnMapping("NUEVOS_PESOS", "NUEVOS_PESOS"),
																																																					  new System.Data.Common.DataColumnMapping("ANTIGUOS_UF", "ANTIGUOS_UF"),
																																																					  new System.Data.Common.DataColumnMapping("ANTIGUOS_PESOS", "ANTIGUOS_PESOS"),
																																																					  new System.Data.Common.DataColumnMapping("TOTAL_UF", "TOTAL_UF"),
																																																					  new System.Data.Common.DataColumnMapping("TOTAL_PESOS", "TOTAL_PESOS"),
																																																					  new System.Data.Common.DataColumnMapping("PORC_NUEVOS", "PORC_NUEVOS"),
																																																					  new System.Data.Common.DataColumnMapping("PORC_ANTIGUOS", "PORC_ANTIGUOS")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS CARR_TDESC, \'\' AS EMAT_TDESC, 0 AS N_PAGARES, 0 AS NUEVOS_UF, 0 AS N" +
				"UEVOS_PESOS, 0 AS ANTIGUOS_UF, 0 AS ANTIGUOS_PESOS, 0 AS TOTAL_UF, 0 AS TOTAL_PE" +
				"SOS, 0 AS PORC_NUEVOS, 0 AS PORC_ANTIGUOS FROM DUAL";
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
