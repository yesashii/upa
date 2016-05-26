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

namespace contrato_antiguo
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected contrato_antiguo.datosContrato datosContrato1;
		protected CrystalDecisions.Web.CrystalReportViewer VerContrato;
		protected contrato_antiguo.datosContrato datosContrato2;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	
		
		

		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			//ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			//Response.Write(ruta_exportacion);Response.Flush();Response.Close();

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


		private string EscribirCodigo( string post_ncorr, int i, string nombre_informe)
		{
			string sql;
			string sql2;
		    
			sql = " select case when protic.es_nuevo_carrera(pp.pers_ncorr, ccc.carr_ccod, oa.peri_ccod) <> 'S' then 'Se deja constancia que el presenta Contrato de Servicios Educacionales no contempla el valor del arancel de titulación.' end  as text_antiguo,";
			sql = sql + " jorn_tdesc, case when pp.pers_temail_uas is null then ";
			sql = sql + "            ', correo electrónico: ' + lower(pp.pers_temail) ";
			sql = sql + "       else ";
			sql = sql + "            ', correo electrónico: ' + lower(pp.pers_temail_uas) ";
			sql = sql + "       end emailp, ";
			sql = sql + "       case when estados_civiles.eciv_tdesc is not null then ";
			sql = sql + "            ', estado civil: ' + estados_civiles.eciv_tdesc ";
			sql = sql + "       end eciv_tdescp, ";
			sql = sql + "       case when paises.pais_tdesc is not null then ";
			sql = sql + "            ', nacionalidad: ' + paises.pais_tnacionalidad ";
			sql = sql + "       end pais_tdescp, ";
			sql = sql + "       case when pp.pers_tprofesion is not null then ";
			sql = sql + "            ', profesión: ' + pp.pers_tprofesion ";
			sql = sql + "       end pers_tprofesionp, ";
			sql = sql + "       case when ppc.pers_temail_uas is null then ";
			sql = sql + "            ', correo electrónico: ' + lower(ppc.pers_temail) ";
			sql = sql + "       else ";
			sql = sql + "            ', correo electrónico: ' + lower(ppc.pers_temail_uas) ";
			sql = sql + "       end emailppc, ";
			sql = sql + "       case when ecivppr.eciv_tdesc is not null then ";
			sql = sql + "            ', estado civil: ' + ecivppr.eciv_tdesc ";
			sql = sql + "       end eciv_tdescppc, ";
			sql = sql + "       case when paisesppr.pais_tdesc is not null then ";
			sql = sql + "            ', nacionalidad: ' + paisesppr.pais_tdesc ";
			sql = sql + "       end pais_tdescppc, ";
			sql = sql + "       case when ppc.pers_tprofesion is not null then ";
			sql = sql + "            ', profesión: ' + ppc.pers_tprofesion ";
			sql = sql + "       end pers_tprofesionppc, ";
			sql = sql + "       "+ i +" as nro_informe, ";
			sql = sql + "       'ORIGINAL' as nombre_informe,  ";
			sql = sql + "       cc.cont_ncorr nro_contrato,  ";
			sql = sql + "       DATEPART(dd,getdate()) dd_hoy,  ";
			sql = sql + "       (select mes_tdesc  ";
			sql = sql + "        from meses  ";
			sql = sql + "        where mes_ccod=DATEPART(mm,getdate())) mm_hoy, ";
			sql = sql + "       DATEPART(yyyy,getdate()) yy_hoy,  ";
			sql = sql + "       iin.inst_trazon_social nombre_institucion,  ";
			sql = sql + "       pac.anos_ccod periodo_academico,  ";
			sql = sql + "       convert(varchar,iin.inst_nrut)+'-'+iin.inst_xdv rut_institucion,  ";
			sql = sql + "       ppr.pers_tnombre +' '+ ppr.pers_tape_paterno + ' ' + ppr.pers_tape_materno nombre_representante,  ";
			sql = sql + "       convert(varchar,pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_postulante,  ";
			sql = sql + "       cast((( convert(numeric,convert(datetime,getdate(),103)) - convert(numeric,convert(datetime,pp.pers_fnacimiento,103)) )/365) as numeric) as edad, ";
			sql = sql + "       pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno nombre_alumno,  ";
			sql = sql + "       ccc.carr_tdesc as carrera,  ";
			sql = sql + "       convert(varchar,ppc.PERS_NRUT) +'-'+ppc.PERS_XDV as rut_codeudor,  ";
			sql = sql + "       ppc.pers_tnombre +' '+ ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno as nombre_codeudor,  ";
			sql = sql + "       ppc.pers_tprofesion profesion, ddp.DIRE_TCALLE +' ' + ddp.DIRE_TNRO as direccion,  ";
			sql = sql + "       c.CIUD_TDESC ciudad, c.CIUD_TCOMUNA comuna,  ";
			sql = sql + "       tcps.tcom_tdesc tipo_documento, ";
			sql = sql + "       isnull (tii.ting_tdesc,'EFECTIVO') documento,  ";
			sql = sql + "       bn.banc_tdesc nombre_banco, ";
			sql = sql + "       dc.dcom_mcompromiso valor_docto,  ";
			sql = sql + "       dc.dcom_ncompromiso nro_docto, ";
			sql = sql + "       convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento , ";
			sql = sql + "       case cps.tcom_ccod when '1' then cps.comp_mdocumento end as total_m , ";
			sql = sql + "       case cps.tcom_ccod when '2' then cps.comp_mdocumento end as total_a  ";
			sql = sql + " from postulantes p, ";
			sql = sql + "     personas_postulante pp, ";
			sql = sql + "     personas ppr,  ";
			sql = sql + "     personas_postulante ppc, ";
			sql = sql + "     ofertas_academicas oa, "; 
			sql = sql + "     especialidades ee,  ";
			sql = sql + "     carreras ccc,  ";
			sql = sql + "     instituciones iin,  ";
			sql = sql + "     codeudor_postulacion cp,  ";
			sql = sql + "     periodos_academicos pac,  ";
			sql = sql + "     direcciones_publica ddp,  ";
			sql = sql + "     ciudades c,  ";
			sql = sql + "     contratos cc,  ";
			sql = sql + "     compromisos cps ,  ";
			sql = sql + "     detalle_compromisos dc,  ";
			sql = sql + "     ingresos ii,  ";
			sql = sql + "     detalle_ingresos dii,  ";
			sql = sql + "     tipos_ingresos tii, ";
			sql = sql + "     bancos bn,  ";
			sql = sql + "     tipos_compromisos tcps, ";
			sql = sql + "     paises, paises paisesppr, ";
			sql = sql + "     estados_civiles, estados_civiles ecivppr,";
			sql = sql + "     jornadas ";
			sql = sql + "where p.pers_ncorr=pp.pers_ncorr  ";
			sql = sql + "  and p.post_ncorr=cp.post_ncorr  ";
			sql = sql + "  and cp.pers_ncorr =ppc.pers_ncorr  ";
			sql = sql + "  and ppc.pers_ncorr = ddp.pers_ncorr  ";
			sql = sql + "  and ddp.tdir_ccod=1  ";
			sql = sql + "  and ddp.ciud_ccod*=c.ciud_ccod  ";
			sql = sql + "  and p.ofer_ncorr=oa.ofer_ncorr  ";
			sql = sql + "  and oa.peri_ccod=pac.peri_ccod  ";
			sql = sql + "  and oa.espe_ccod=ee.espe_ccod  ";
			sql = sql + "  and ee.carr_ccod=ccc.carr_ccod  ";
			sql = sql + "  and ccc.inst_ccod=iin.inst_ccod  ";
			sql = sql + "  and iin.PERS_NCORR_REPRESENTANTE=ppr.pers_ncorr  ";
			sql = sql + "  and p.post_ncorr= isnull('" + post_ncorr + "',p.post_ncorr)  ";
			sql = sql + "  and cc.post_ncorr=p.post_ncorr  ";
			sql = sql + "  and cc.cont_ncorr=cps.comp_ndocto  ";
			sql = sql + "  and cps.ecom_ccod <> 3  ";
			sql = sql + "  and cc.econ_ccod in (1, 2)  ";
			sql = sql + "  and cps.tcom_ccod in (1, 2)  ";
			sql = sql + "  and cps.comp_ndocto=dc.comp_ndocto "; 
			sql = sql + "  and cps.inst_ccod=dc.inst_ccod  ";
			sql = sql + "  and cps.tcom_ccod=dc.tcom_ccod  ";
			sql = sql + "  and dc.tcom_ccod in (1,2)  ";
			sql = sql + "  and cps.tcom_ccod=tcps.tcom_ccod  ";
			sql = sql + "  and isnull(dii.ting_ccod, 0) in (0, 3, 4)  ";
			sql = sql + "  and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = dii.ting_ccod  ";
			sql = sql + "  and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr  ";
			sql = sql + "  and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto  ";
			sql = sql + "  and dii.ting_ccod *=tii.ting_ccod  ";
			sql = sql + "  and dii.banc_ccod *= bn.banc_ccod  ";
			sql = sql + "  and dii.ingr_ncorr *= ii.ingr_ncorr  ";
			sql = sql + "  and pp.pais_ccod = paises.pais_ccod ";
			sql = sql + "  and pp.eciv_ccod = estados_civiles.eciv_ccod ";
			sql = sql + "  and ppr.pais_ccod *= paisesppr.pais_ccod ";
			sql = sql + "  and ppr.eciv_ccod *= ecivppr.eciv_ccod ";
			sql = sql + "  and oa.jorn_ccod = jornadas.jorn_ccod";
			sql = sql + "  order by cps.tcom_ccod,dc.DCOM_FCOMPROMISO asc ";

			// DATOS DEL CONTRATO OBTENIDOS A TRAVES DE UN PROCEDIMIENTO
			sql2="exec detalle_forma_pago "+post_ncorr+","+i+","+nombre_informe;
			return (sql2);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string post_ncorr;
			post_ncorr = Request.QueryString["post_ncorr"];
			//post_ncorr = "11865";
			//post_ncorr = "11863";
			post_ncorr = "12187";
			
			//string[] informe = new string[4] {"ORIGINAL","DUPLICADO","TRIPLICADO","CUADRIPLICADO"};
			string[] informe = new string[2] {"ORIGINAL","DUPLICADO"};			
			CrystalReportContrato reporte = new CrystalReportContrato();
			for (int i=0; i<2; i++)
			{
				sql = EscribirCodigo(post_ncorr, i, informe[i]);
							
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(datosContrato1);
				//Response.Write(informe[i]+"**<br>");
				//Response.Write(sql+"<br><br>");
			}		
			//Response.End();
			reporte.SetDataSource(datosContrato1);
			VerContrato.ReportSource = reporte;
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
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.datosContrato2 = new contrato_antiguo.datosContrato();
			((System.ComponentModel.ISupportInitialize)(this.datosContrato2)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "contrato", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("text_antiguo", "text_antiguo"),
																																																					new System.Data.Common.DataColumnMapping("jorn_tdesc", "jorn_tdesc"),
																																																					new System.Data.Common.DataColumnMapping("emailp", "emailp"),
																																																					new System.Data.Common.DataColumnMapping("eciv_tdescp", "eciv_tdescp"),
																																																					new System.Data.Common.DataColumnMapping("pais_tdescp", "pais_tdescp"),
																																																					new System.Data.Common.DataColumnMapping("pers_tprofesionp", "pers_tprofesionp"),
																																																					new System.Data.Common.DataColumnMapping("emailppc", "emailppc"),
																																																					new System.Data.Common.DataColumnMapping("eciv_tdescppc", "eciv_tdescppc"),
																																																					new System.Data.Common.DataColumnMapping("pais_tdescppc", "pais_tdescppc"),
																																																					new System.Data.Common.DataColumnMapping("pers_tprofesionppc", "pers_tprofesionppc"),
																																																					new System.Data.Common.DataColumnMapping("nro_informe", "nro_informe"),
																																																					new System.Data.Common.DataColumnMapping("NRO_INFORME1", "NRO_INFORME1"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_INFORME", "NOMBRE_INFORME"),
																																																					new System.Data.Common.DataColumnMapping("NRO_CONTRATO", "NRO_CONTRATO"),
																																																					new System.Data.Common.DataColumnMapping("DD_HOY", "DD_HOY"),
																																																					new System.Data.Common.DataColumnMapping("MM_HOY", "MM_HOY"),
																																																					new System.Data.Common.DataColumnMapping("YY_HOY", "YY_HOY"),
																																																					new System.Data.Common.DataColumnMapping("PERIODO_ACADEMICO", "PERIODO_ACADEMICO"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_REPRESENTANTE", "NOMBRE_REPRESENTANTE"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_INSTITUCION", "NOMBRE_INSTITUCION"),
																																																					new System.Data.Common.DataColumnMapping("RUT_INSTITUCION", "RUT_INSTITUCION"),
																																																					new System.Data.Common.DataColumnMapping("RUT_POSTULANTE", "RUT_POSTULANTE"),
																																																					new System.Data.Common.DataColumnMapping("EDAD", "EDAD"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																					new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																					new System.Data.Common.DataColumnMapping("RUT_CODEUDOR", "RUT_CODEUDOR"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_CODEUDOR", "NOMBRE_CODEUDOR"),
																																																					new System.Data.Common.DataColumnMapping("PROFESION", "PROFESION"),
																																																					new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																					new System.Data.Common.DataColumnMapping("CIUDAD", "CIUDAD"),
																																																					new System.Data.Common.DataColumnMapping("COMUNA", "COMUNA"),
																																																					new System.Data.Common.DataColumnMapping("TIPO_DOCUMENTO", "TIPO_DOCUMENTO"),
																																																					new System.Data.Common.DataColumnMapping("DOCUMENTO", "DOCUMENTO"),
																																																					new System.Data.Common.DataColumnMapping("NOMBRE_BANCO", "NOMBRE_BANCO"),
																																																					new System.Data.Common.DataColumnMapping("VALOR_DOCTO", "VALOR_DOCTO"),
																																																					new System.Data.Common.DataColumnMapping("NRO_DOCTO", "NRO_DOCTO"),
																																																					new System.Data.Common.DataColumnMapping("FECHA_VENCIMIENTO", "FECHA_VENCIMIENTO"),
																																																					new System.Data.Common.DataColumnMapping("TOTAL_M", "TOTAL_M"),
																																																					new System.Data.Common.DataColumnMapping("TOTAL_A", "TOTAL_A")})});
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated_1);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' text_antiguo, '' AS jorn_tdesc, '' AS emailp, '' AS eciv_tdescp, '' AS pais_tdescp, ' ' AS pers_tprofesionp, '' AS emailppc, '' AS eciv_tdescppc, '' AS pais_tdescppc, '' AS pers_tprofesionppc, 0 AS nro_informe, '' AS NRO_INFORME, '' AS NOMBRE_INFORME, '' AS NRO_CONTRATO, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS PERIODO_ACADEMICO, '' AS NOMBRE_REPRESENTANTE, '' AS NOMBRE_INSTITUCION, '' AS RUT_INSTITUCION, '' AS RUT_POSTULANTE, '' AS EDAD, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS PROFESION, '' AS DIRECCION, '' AS CIUDAD, '' AS COMUNA, '' AS TIPO_DOCUMENTO, '' AS DOCUMENTO, '' AS NOMBRE_BANCO, '' AS VALOR_DOCTO, '' AS NRO_DOCTO, '' AS FECHA_VENCIMIENTO, '' AS TOTAL_M, '' AS TOTAL_A";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = "Provider=SQLOLEDB;server=edoras;OLE DB Services = -2;uid=protic;pwd=,.protic;init" +
				"ial catalog=protic2";
			// 
			// datosContrato2
			// 
			this.datosContrato2.DataSetName = "datosContrato";
			this.datosContrato2.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosContrato2.Namespace = "http://www.tempuri.org/datosContrato.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosContrato2)).EndInit();

		}
		#endregion

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void oleDbDataAdapter1_RowUpdated_1(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}
	}
}
