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

namespace contratos_otec
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected contratos_otec.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		//protected CrystalDecisions.Web.CrystalReportViewer VerContrato;
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
		private string EscribirCodigo(string folio_ingreso)
		{
			string sql;
			string sql2;

			// DATOS DEL CONTRATO OBTENIDOS A PARTIR DEL COMPROBANTE
			sql	="	SELECT ingr_mtotal AS monto_total, 'DIURNA' AS jorn_tdesc, ', correo electrónico: '+cast(c.pers_temail as varchar) AS emailp, ', estado civil: ' + cast(d.eciv_tdesc as varchar) AS eciv_tdescp, ";
				sql = sql + "	', nacionalidad: ' + cast(e.pais_tnacionalidad as varchar) AS pais_tdescp, ', profesión: ' + cast(c.pers_tprofesion as varchar)  AS pers_tprofesionp, ', correo electrónico: '+cast(c.pers_temail as varchar) AS emailppc, '' AS eciv_tdescppc, ";
				sql = sql + "	', nacionalidad: ' + cast(e.pais_tnacionalidad as varchar) AS pais_tdescppc, ', profesión: ' + cast(c.pers_tprofesion as varchar) AS pers_tprofesionppc, 0 AS nro_informe, 'Contrato' AS NOMBRE_INFORME,"; 
				sql = sql + "	a.ingr_nfolio_referencia AS NRO_CONTRATO, datepart(dd,a.ingr_fpago) AS DD_HOY, datepart(mm,a.ingr_fpago) AS MM_HOY, datepart(year,a.ingr_fpago) AS YY_HOY, 'Universidad del Pacífico' AS NOMBRE_INSTITUCION,"; 
				sql = sql + "	anio_admision AS PERIODO_ACADEMICO, '71704700-1' AS RUT_INSTITUCION, 'ITALO GIRAUDO TORRES' AS NOMBRE_REPRESENTANTE,";
				sql = sql + "	protic.obtener_rut(a.pers_ncorr) AS RUT_POSTULANTE, '' AS EDAD, protic.obtener_nombre_completo(c.pers_ncorr,'n') AS NOMBRE_ALUMNO, tdet_tdesc AS CARRERA,";
				sql = sql + "	protic.obtener_rut(a.pers_ncorr) AS RUT_CODEUDOR, protic.obtener_nombre_completo(c.pers_ncorr,'n') AS NOMBRE_CODEUDOR, ', profesión: ' + cast(c.pers_tprofesion as varchar) AS PROFESION, '' AS DIRECCION,";
				sql = sql + "	protic.obtener_direccion(c.pers_ncorr,1,'CNPB') AS DIRECCION_ALUMNO, '' AS CIUDAD, '' AS COMUNA, ";
				sql = sql + "	protic.obtener_direccion(c.pers_ncorr,1,'CIU')  AS CIUDAD_ALUMNO,";
				sql = sql + "	protic.obtener_direccion(c.pers_ncorr,1,'COM')  AS COMUNA_ALUMNO,";
				sql = sql + "	isnull(f.ting_tdesc,'EFECTIVO') AS TIPO_DOCUMENTO, isnull(f.ting_tdesc,'EFECTIVO') AS DOCUMENTO, '' AS NOMBRE_BANCO, ";
				sql = sql + "	b.ding_mdetalle AS VALOR_DOCTO, b.ding_ndocto AS NRO_DOCTO, b.ding_fdocto AS FECHA_VENCIMIENTO, '' AS TOTAL_M, ";
				sql = sql + "	'' AS TOTAL_A, ofot_nmatricula AS matricula, ofot_narancel AS arancel, sede_tdesc AS sede, o.ciud_tdesc AS comuna_sede";
				sql = sql + "	from ingresos a  ";
				sql = sql + "			join detalle_ingresos b  ";
				sql = sql + "				on a.ingr_ncorr=b.ingr_ncorr ";
				sql = sql + "			join personas c ";
				sql = sql + "				on a.pers_ncorr=c.pers_ncorr ";
				sql = sql + "			left outer join estados_civiles d ";
				sql = sql + "				on c.eciv_ccod=d.eciv_ccod ";
				sql = sql + "			left outer join paises e ";
				sql = sql + "				on c.pais_ccod = e.pais_ccod ";
				sql = sql + "			left outer join tipos_ingresos f ";
				sql = sql + "				on b.ting_ccod=f.ting_ccod ";
				sql = sql + "			join abonos g ";
				sql = sql + "				on a.ingr_ncorr=g.ingr_ncorr ";
				sql = sql + "			join compromisos h ";
				sql = sql + "				on g.comp_ndocto=h.comp_ndocto ";
				sql = sql + "				and g.tcom_ccod=h.tcom_ccod ";
				sql = sql + "				and g.inst_ccod=h.inst_ccod ";
				sql = sql + "			join detalles i ";
				sql = sql + "				on h.comp_ndocto=i.comp_ndocto";
				sql = sql + "				and h.tcom_ccod=i.tcom_ccod";
				sql = sql + "				and h.inst_ccod=i.inst_ccod";
				sql = sql + "				and i.deta_msubtotal>0";
				sql = sql + "			join tipos_detalle j";
				sql = sql + "				on i.tdet_ccod=j.tdet_ccod ";                     
				sql = sql + "			join postulacion_otec k ";
				sql = sql + "			    on k.pote_ncorr= (select max(pote_ncorr) from postulantes_cargos_otec where comp_ndocto=g.comp_ndocto) ";
				sql = sql + "			join datos_generales_secciones_otec l ";
				sql = sql + "			    on k.dgso_ncorr=l.dgso_ncorr  ";         
				sql = sql + "			join ofertas_otec m  ";
				sql = sql + "			    on l.dcur_ncorr=m.dcur_ncorr  ";
				sql = sql + "			    and l.dgso_ncorr=m.dgso_ncorr  ";
				sql = sql + "			join sedes n  ";
				sql = sql + "			    on m.sede_ccod=n.sede_ccod  ";
				sql = sql + "			join ciudades o  ";
				sql = sql + "			    on n.ciud_ccod=o.ciud_ccod  ";                             
        		sql = sql + "	where cast(a.ingr_nfolio_referencia as varchar)='"+folio_ingreso+"' ";
				sql = sql + "		and a.ting_ccod=33";
				



			sql2	="	SELECT '1234' AS monto_total, '' AS jorn_tdesc, 'aaaa' AS emailp, 'Soltero' AS eciv_tdescp, ";
			sql2 = sql2 + "	'' AS pais_tdescp, ' ' AS pers_tprofesionp, '' AS emailppc, '' AS eciv_tdescppc, ";
			sql2 = sql2 + "	'' AS pais_tdescppc, '' AS pers_tprofesionppc, 0 AS nro_informe, '' AS NOMBRE_INFORME,"; 
			sql2 = sql2 + "	'3435' AS NRO_CONTRATO, '10' AS DD_HOY, '10' AS MM_HOY, '2008' AS YY_HOY, '' AS NOMBRE_INSTITUCION,"; 
			sql2 = sql2 + "	'' AS PERIODO_ACADEMICO, '' AS RUT_INSTITUCION, '' AS NOMBRE_REPRESENTANTE, ";
			sql2 = sql2 + "	'' AS RUT_POSTULANTE, '' AS EDAD, '' AS NOMBRE_ALUMNO, '' AS CARRERA, ";
			sql2 = sql2 + "	'' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS PROFESION, '' AS DIRECCION, ";
			sql2 = sql2 + "	'' AS DIRECCION_ALUMNO, '' AS CIUDAD, '' AS COMUNA, '' AS CIUDAD_ALUMNO, ";
			sql2 = sql2 + "	'' AS COMUNA_ALUMNO, '' AS TIPO_DOCUMENTO, '' AS DOCUMENTO, '' AS NOMBRE_BANCO, ";
			sql2 = sql2 + "	'' AS VALOR_DOCTO, '' AS NRO_DOCTO, '' AS FECHA_VENCIMIENTO, '' AS TOTAL_M, ";
			sql2 = sql2 + "	'' AS TOTAL_A, '' AS matricula, '' AS arancel, 'Casa central' AS sede, '' AS comuna_sede";
			
			return (sql);
		
		}


		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string folio_ingreso;
			folio_ingreso = Request.QueryString["folio_ingreso"];
			folio_ingreso="180949";
			string[] informe = new string[1] {"ORIGINAL"};

			contrato_otec reporte = new contrato_otec();


			for (int i=0; i<1; i++)
			{
				sql = EscribirCodigo(folio_ingreso);
				oleDbDataAdapter1.SelectCommand.CommandTimeout=900;			
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(dataSet11);
			}		

			
					reporte.SetDataSource(dataSet11);
					CrystalReportViewer1.ReportSource = reporte;
					ExportarPDF(reporte);
				
			

			// Introducir aquí el código de usuario para inicializar la página
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
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.dataSet11 = new contratos_otec.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS monto_total, '' AS jorn_tdesc, '' AS emailp, '' AS eciv_tdescp, '' AS pais_tdescp, ' ' AS pers_tprofesionp, '' AS emailppc, '' AS eciv_tdescppc, '' AS pais_tdescppc, '' AS pers_tprofesionppc, 0 AS nro_informe, '' AS NOMBRE_INFORME, '' AS NRO_CONTRATO, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS NOMBRE_INSTITUCION, '' AS PERIODO_ACADEMICO, '' AS RUT_INSTITUCION, '' AS NOMBRE_REPRESENTANTE, '' AS RUT_POSTULANTE, '' AS EDAD, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS PROFESION, '' AS DIRECCION, '' AS DIRECCION_ALUMNO, '' AS CIUDAD, '' AS COMUNA, '' AS CIUDAD_ALUMNO, '' AS COMUNA_ALUMNO, '' AS TIPO_DOCUMENTO, '' AS DOCUMENTO, '' AS NOMBRE_BANCO, '' AS VALOR_DOCTO, '' AS NRO_DOCTO, '' AS FECHA_VENCIMIENTO, '' AS TOTAL_M, '' AS TOTAL_A, '' AS matricula, '' AS arancel, '' AS sede, '' AS comuna_sede";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[0])});
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
