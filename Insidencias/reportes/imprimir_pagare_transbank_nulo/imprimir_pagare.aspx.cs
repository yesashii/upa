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
		protected imprimir_pagare.datosPagare datosPagare1;

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

		private string EscribirCodigo( string post_ncorr)
		{
			string sql;
		    
sql =" select con.CONT_NCORR as ciudad_codeudor1, pag.PAGA_NCORR nro_pagare,(isnull(bba.BENE_MMONTO_ACUM_MATRICULA,0) + isnull(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,\n ";
    sql = sql + " cast(datepart(dd,getdate()) as varchar) dd_hoy,(select mes_tdesc from meses where mes_ccod=datepart(mm,getdate()))as mm_hoy, \n ";
    sql = sql + " cast(datepart(mm,getdate()) as varchar) mm_antiguo,cast(datepart(yy,getdate())as varchar) yy_hoy, \n ";
    sql = sql + " ciu.ciud_tdesc ciudad_sede, pac.anos_ccod periodo_academico, \n ";
    sql = sql + " (pac.anos_ccod  + 1) as inicio_vencimiento, \n ";
    sql = sql + " (pac.anos_ccod  + 2) as final_vencimiento, \n ";
    sql = sql + " cast(pp.PERS_NRUT as varchar) +'-'+cast(pp.PERS_XDV as varchar) as rut_post, \n ";
    sql = sql + " pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_alumno, \n ";
    sql = sql + " cc.carr_tdesc as carrera, \n ";
    sql = sql + " cast(ppc.PERS_NRUT as varchar) +'-'+cast(ppc.PERS_XDV as varchar) as rut_codeudor,  \n ";
    sql = sql + " ppc.pers_tnombre+' '+ppc.pers_tape_paterno+' '+ppc.pers_tape_materno  as nombre_codeudor, \n ";
    sql = sql + " ddc.DIRE_TCALLE+' '+cast(ddc.DIRE_TNRO as varchar) as direccion_codeudor, \n ";
    sql = sql + " c.CIUD_TDESC ciudad_codeudor, \n ";
    sql = sql + " ddp.DIRE_TCALLE+' '+cast(ddp.DIRE_TNRO as varchar) as direccion_postulante, \n ";
    sql = sql + " ccp.CIUD_TDESC ciudad_codeudor1_x_contrato \n ";
	sql = sql + " from postulantes p,personas_postulante pp, \n ";
    sql = sql + " personas_postulante ppc,ofertas_academicas oa,  \n ";
    sql = sql + " especialidades ee, carreras cc,  \n ";
    sql = sql + " codeudor_postulacion cp, \n ";
    sql = sql + " direcciones_publica ddp, ciudades c,ciudades ccp, \n ";
    sql = sql + " direcciones_publica ddc,periodos_academicos pac, \n ";
    sql = sql + " beneficios bba, contratos con, pagares pag, sedes ss, ciudades ciu \n ";
sql = sql + " where p.pers_ncorr=pp.pers_ncorr  \n ";
sql = sql + " and p.post_ncorr=   isnull('" +post_ncorr+ "','0')\n ";
sql = sql + " and con.post_ncorr=p.post_ncorr  \n ";
sql = sql + " and con.CONT_NCORR=pag.CONT_NCORR  \n ";
sql = sql + " and pag.PAGA_NCORR=bba.PAGA_NCORR  \n ";
sql = sql + " and bba.EBEN_CCOD <>3  \n ";
sql = sql + " and con.econ_ccod<>3  \n ";
sql = sql + " and p.post_ncorr=cp.post_ncorr \n ";
sql = sql + " and cp.pers_ncorr =ppc.pers_ncorr  \n ";
sql = sql + " and ppc.pers_ncorr = ddc.pers_ncorr \n ";
sql = sql + " and ddc.tdir_ccod=1 \n ";
sql = sql + " and ddc.ciud_ccod*=c.ciud_ccod \n ";
sql = sql + " and pp.pers_ncorr = ddp.pers_ncorr \n ";
sql = sql + " and ddp.tdir_ccod=1 \n ";
sql = sql + " and ddp.ciud_ccod*=ccp.ciud_ccod \n ";
sql = sql + " and p.ofer_ncorr=oa.ofer_ncorr  \n ";
sql = sql + " and oa.peri_ccod=pac.peri_ccod \n "; 
sql = sql + " and oa.espe_ccod=ee.espe_ccod  \n ";
sql = sql + " and oa.sede_ccod=ss.sede_ccod  \n ";
sql = sql + " and ss.ciud_ccod= ciu.ciud_ccod \n ";
sql = sql + " and ee.carr_ccod=cc.carr_ccod \n ";
	
			return (sql);

		}


		private string EscribirPagareFinanza( string paga_ncorr)
		{
			string sql;
		    
			sql = " select  pag.PAGA_NCORR nro_pagare, pag.PAGA_NCORR, pag.epag_ccod, \n";
			sql = sql + " cast(datepart(dd,getdate()) as varchar) dd_hoy,  \n";
			sql = sql + " cast(datepart(mm,getdate()) as varchar) mm_hoy,cast(datepart(yy,getdate()) as varchar) yy_hoy,  \n";
			sql = sql + " (isnull(bba.BENE_MMONTO_ACUM_MATRICULA,0) + isnull(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,  \n";
			sql = sql + " cast(pp.PERS_NRUT as varchar) +'-'+cast(pp.PERS_XDV as varchar) as rut_post,   \n";
			sql = sql + " pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' '+ pp.pers_tape_materno nombre_alumno,  \n";
			sql = sql + " cast(ppc.PERS_NRUT as varchar) +'-'+cast(ppc.PERS_XDV as varchar) as rut_codeudor , \n";
			sql = sql + " ciu.ciud_tdesc ciudad_sede, cast(datepart(yy,getdate()) as varchar) periodo_academico,\n"; 
			sql = sql + " cast(pag.PAGA_FINICIO_PAGO as varchar) as inicio_vencimiento,  \n";
			sql = sql + " cast(pag.PAGA_FTERMINO_PAGO as varchar) as final_vencimiento, \n";
			sql = sql + " pag.paga_fpagare as FECHA_PAGARE, \n";
			sql = sql + " cc.carr_tdesc as carrera,  \n";
			sql = sql + " ppc.pers_tnombre +' '+ ppc.pers_tape_paterno +' '+ ppc.pers_tape_materno  as nombre_codeudor,  \n";
			sql = sql + " ddc.DIRE_TCALLE +' '+cast(ddc.DIRE_TNRO as varchar) as direccion_codeudor,  \n";
			sql = sql + " c.CIUD_TDESC ciudad_codeudor,  \n";
			sql = sql + " ddp.DIRE_TCALLE +' '+cast(ddp.DIRE_TNRO as varchar) as direccion_postulante,  \n";
			sql = sql + " ccp.CIUD_TDESC ciudad_codeudor1  \n";
			sql = sql + " 						 from postulantes p,personas_postulante pp,   \n";
			sql = sql + " 						 personas_postulante ppc,  \n";
			sql = sql + " 						 codeudor_postulacion cp,   \n";
			sql = sql + " 						 direcciones_publica ddp, ciudades c,ciudades ccp,  \n";
			sql = sql + " 			 			 direcciones_publica ddc, \n";
			sql = sql + " 						 sedes ss, ciudades ciu,   \n";
			sql = sql + " 						 beneficios bba,  \n";
			sql = sql + " 						 ofertas_academicas oa,   \n";
			sql = sql + " 			 			 especialidades ee, carreras cc,    \n";
			sql = sql + " 						 contratos con, pagares pag  \n";
			sql = sql + " 						 where pag.paga_ncorr='" +paga_ncorr+ "' \n";
			sql = sql + " 						 and con.CONT_NCORR=pag.CONT_NCORR  \n";
			sql = sql + " 						 and con.post_ncorr=p.post_ncorr    \n";
			sql = sql + " 						 and p.pers_ncorr=pp.pers_ncorr   \n";
			sql = sql + " 						 and pag.PAGA_NCORR=bba.PAGA_NCORR    \n";
			sql = sql + " 						 and pag.EPAG_CCOD=1  \n";
			sql = sql + " 			 			 and bba.EBEN_CCOD =1    \n";
			sql = sql + " 						 and con.econ_ccod=1    \n";
			sql = sql + " 						 and p.post_ncorr=cp.post_ncorr   \n";
			sql = sql + " 						 and cp.pers_ncorr =ppc.pers_ncorr  \n";
			sql = sql + " 						 and ppc.pers_ncorr = ddc.pers_ncorr  \n";
			sql = sql + " 						 and ddc.tdir_ccod=1  \n";
			sql = sql + " 						 and ddc.ciud_ccod*=c.ciud_ccod  \n";
			sql = sql + " 						 and pp.pers_ncorr = ddp.pers_ncorr  \n";
			sql = sql + " 						 and ddp.tdir_ccod=1  \n";
			sql = sql + " 						 and ddp.ciud_ccod*=ccp.ciud_ccod  \n";
			sql = sql + " 						 and p.ofer_ncorr=oa.ofer_ncorr   \n";
			sql = sql + " 						 and oa.espe_ccod=ee.espe_ccod  \n";
			sql = sql + " 						 and ee.carr_ccod=cc.carr_ccod	  \n";
			sql = sql + " 						 and oa.sede_ccod=ss.sede_ccod   \n";
			sql = sql + " 						 and ss.ciud_ccod= ciu.ciud_ccod \n";
			
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
			int fila = 0;	
			
			//post_ncorr = "11845";
			post_ncorr = Request.QueryString["post_ncorr"];
			//paga_ncorr = Request.QueryString["paga_ncorr"];

			imprimirFinanza= Request.QueryString["imprimir"];
			
			if ( imprimirFinanza=="S")
			{
				for (int i = 0; i < Request.Form.Count; i++)
				{
					paga_ncorr_d="letras[" + fila + "][paga_ncorr]";
					//Response.Write(paga_ncorr_d+ "<br>");
                    
					if (Request.Form[i] != "") 
					{
						paga_ncorr=Request.Form[i];
					    
						//Response.Write(Request.Form[i]);
						
						sql = EscribirPagareFinanza(paga_ncorr);
						oleDbDataAdapter1.SelectCommand.CommandText = sql;
						oleDbDataAdapter1.Fill(datosPagare1);
					   fila++;	
					
					}
					
				}

			}
			else
				{
					sql = EscribirCodigo(post_ncorr);
					oleDbDataAdapter1.SelectCommand.CommandText = sql;
					oleDbDataAdapter1.Fill(datosPagare1);
					
				}
			
             //Response.End();
			//Response.Write(sql);
			//Response.End();
			CrystalReportPagare reporte = new CrystalReportPagare();
			
				
			reporte.SetDataSource(datosPagare1);
			VerPagare.ReportSource = reporte;
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
			this.datosPagare1 = new imprimir_pagare.datosPagare();
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "pagare", new System.Data.Common.DataColumnMapping[] {
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
																																																				  new System.Data.Common.DataColumnMapping("CONTRATO", "CONTRATO"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_CODEUDOR1", "CIUDAD_CODEUDOR1")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CIUDAD_SEDE, '' AS NRO_PAGARE, '' AS VALOR_PAGAR, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS PERIODO_ACADEMICO, '' AS INICIO_VENCIMIENTO, '' AS FINAL_VENCIMIENTO, '' AS RUT_POST, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS DIRECCION_CODEUDOR, '' AS CIUDAD_CODEUDOR, '' AS DIRECCION_POSTULANTE, '' AS CIUDAD_CODEUDOR FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datosPagare1
			// 
			this.datosPagare1.DataSetName = "datosPagare";
			this.datosPagare1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosPagare1.Namespace = "http://www.tempuri.org/datosPagare.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosPagare1)).EndInit();

		}
		#endregion
	}
}
