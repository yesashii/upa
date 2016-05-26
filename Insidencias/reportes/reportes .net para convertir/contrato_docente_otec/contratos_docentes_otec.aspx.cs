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

namespace contrato_docente_otec
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected contrato_docente_otec.DataSet1 dataSet11;

		private void ExportarPDF(ReportDocument rep) 
		{
			string ruta_exportacion;

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

		private string EscribirCodigo(string pers_ncorr,string dcur_ncorr)
		{
			string sql;
		    
						
			sql=       "         select mote_ccod,mote_tdesc,cdot_ncorr,anot_ncorr,anot_ncodigo,cdot_finicio,cdot_ffin,ano_contrato,anot_inicio,anot_fin,daot_mhora,anot_ncuotas, ";
			sql= sql + "         nombre_docente,Rut_Docente,fecha_nac,estado_civil,comuna,profesion,TipoDocente,Nacionalidad,NombreRepLeg,dcurr_tdesc,inst_trazon_social,sede_tdesc,seot_tdesc,daot_nhora,daot_mhora,anot_ncuotas,valorI,valoII,Dia,Mes,Año,fin_con,ini_con,mes_ini_contrato,mes_fin_contrato,anio_ini_contrato,anio_fin_contrato,Direccion,nacionalidad,grado,institucion_t1 ";
            sql= sql + "         from(Select mo.mote_ccod,mote_tdesc,a.cdot_ncorr,b.anot_ncorr,(select dcur_tdesc from diplomados_cursos  where dcur_ncorr=dg.dcur_ncorr)as dcurr_tdesc,anot_ncodigo,protic.trunc(cdot_finicio)as cdot_finicio, ";
            sql= sql + "         protic.trunc(cdot_ffin)as cdot_ffin,ano_contrato,protic.trunc(anot_finicio)as anot_inicio, ";
			sql= sql + "         protic.trunc(anot_ffin)as anot_fin,daot_nhora,daot_mhora,anot_ncuotas,(daot_mhora*daot_nhora)as valorI,((daot_mhora*daot_nhora)/anot_ncuotas)as valoII, ";
			sql= sql + "         protic.obtener_nombre(a.pers_ncorr,'n') as nombre_docente, ";
			sql= sql + "         protic.obtener_rut(a.pers_ncorr)as Rut_Docente, ";																			
	        sql= sql + "         (select protic.trunc(pers_fnacimiento) from personas p where p.pers_ncorr=a.pers_ncorr)as fecha_nac, ";
            sql= sql + "         (select eciv_tdesc from personas f,estados_civiles e where f.pers_ncorr=a.pers_ncorr and f.eciv_ccod=e.eciv_ccod) as estado_civil, ";
            sql= sql + "         (select ciud_tdesc+' / '+ciud_tcomuna  from direcciones f,ciudades h where f.pers_ncorr=a.pers_ncorr and f.ciud_ccod=h.ciud_ccod and tdir_ccod=1) as comuna, ";
            sql= sql + "         (select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion, ";
            sql= sql + "         'docente'as TipoDocente,seot_tdesc, ";
			sql= sql + "         (select isnull(m.pais_tnacionalidad,'CHILENA') from personas p,paises m where p.pers_ncorr=a.pers_ncorr and p.PAIS_CCOD=m.PAIS_CCOD)as Nacionalidad, ";
            sql= sql + "         protic.obtener_nombre_completo(l.pers_ncorr_representante,'n') as NombreRepLeg,inst_trazon_social,(select sede_tdesc from sedes s where sede_ccod=dg.sede_ccod)as sede_tdesc, ";
			sql= sql + "         (select case when DATEPART(mm, GETDATE()) = 1 then 'Enero' when DATEPART(mm, GETDATE()) = 2 then 'Febrero'  when DATEPART(mm, GETDATE()) = 3 then 'Marzo' when DATEPART(mm, GETDATE()) = 4 then 'Abril' when DATEPART(mm, GETDATE()) = 5 then 'Mayo' when DATEPART(mm, GETDATE()) = 6 then 'Junio'when DATEPART(mm, GETDATE()) = 7 then 'Julio'when DATEPART(mm, GETDATE()) = 8 then 'Agosto'when DATEPART(mm, GETDATE()) = 9 then 'Septiembre'when DATEPART(mm, GETDATE()) = 10 then 'Octubre'when DATEPART(mm, GETDATE()) = 11 then 'Noviembre'when DATEPART(mm, GETDATE()) = 12 then 'Diciembre'end) as mes, ";
			sql= sql + "          (select case when DATEPART(mm,anot_finicio) = 1 then 'Enero' when DATEPART(mm, anot_finicio) = 2 then 'Febrero'  when DATEPART(mm, anot_finicio) = 3 then 'Marzo' when DATEPART(mm,anot_finicio) = 4 then 'Abril' when DATEPART(mm,anot_finicio) = 5 then 'Mayo' when DATEPART(mm,anot_finicio) = 6 then 'Junio'when DATEPART(mm,anot_finicio) = 7 then 'Julio'when DATEPART(mm,anot_finicio) = 8 then 'Agosto'when DATEPART(mm,anot_finicio) = 9 then 'Septiembre'when DATEPART(mm, anot_finicio) = 10 then 'Octubre'when DATEPART(mm, anot_finicio) = 11 then 'Noviembre'when DATEPART(mm, anot_finicio) = 12 then 'Diciembre'end) as ini_con, ";
			sql= sql + "          (select case when DATEPART(mm,anot_ffin) = 1 then 'Enero' when DATEPART(mm, anot_ffin) = 2 then 'Febrero'  when DATEPART(mm, anot_ffin) = 3 then 'Marzo' when DATEPART(mm, anot_ffin) = 4 then 'Abril' when DATEPART(mm, anot_ffin) = 5 then 'Mayo' when DATEPART(mm,anot_ffin) = 6 then 'Junio'when DATEPART(mm, anot_ffin) = 7 then 'Julio'when DATEPART(mm, anot_ffin) = 8 then 'Agosto'when DATEPART(mm, anot_ffin) = 9 then 'Septiembre'when DATEPART(mm, anot_ffin) = 10 then 'Octubre'when DATEPART(mm, anot_ffin) = 11 then 'Noviembre'when DATEPART(mm, anot_ffin) = 12 then 'Diciembre'end) as fin_con, ";
			sql= sql + "			( select dire_tcalle+'  #'+dire_tnro from direcciones where pers_ncorr=a.pers_ncorr and tdir_ccod=1)as Direccion,";
			sql= sql + "		(select case when DATEPART(mm,cdot_finicio) = 1 then 'Enero' when DATEPART(mm, cdot_finicio) = 2 then 'Febrero' when DATEPART(mm, cdot_finicio) = 3 then 'Marzo' when DATEPART(mm,cdot_finicio) = 4 then 'Abril' when DATEPART(mm,cdot_finicio) = 5 then 'Mayo' when DATEPART(mm,cdot_finicio) = 6 then 'Junio'when DATEPART(mm,cdot_finicio) = 7 then 'Julio'when DATEPART(mm,cdot_finicio) = 8 then 'Agosto'when DATEPART(mm,cdot_finicio) = 9 then 'Septiembre'when DATEPART(mm, cdot_finicio) = 10 then 'Octubre'when DATEPART(mm, cdot_finicio) = 11 then 'Noviembre'when DATEPART(mm, cdot_finicio) = 12 then 'Diciembre'end) as mes_ini_contrato,";
			sql= sql + "		(select case when DATEPART(mm,cdot_ffin) = 1 then 'Enero' when DATEPART(mm, cdot_ffin) = 2 then 'Febrero' when DATEPART(mm, cdot_ffin) = 3 then 'Marzo' when DATEPART(mm, cdot_ffin) = 4 then 'Abril' when DATEPART(mm, cdot_ffin) = 5 then 'Mayo' when DATEPART(mm,cdot_ffin) = 6 then 'Junio'when DATEPART(mm, cdot_ffin) = 7 then 'Julio'when DATEPART(mm, cdot_ffin) = 8 then 'Agosto'when DATEPART(mm, cdot_ffin) = 9 then 'Septiembre'when DATEPART(mm, cdot_ffin) = 10 then 'Octubre'when DATEPART(mm, cdot_ffin) = 11 then 'Noviembre'when DATEPART(mm, cdot_ffin) = 12 then 'Diciembre'end) as mes_fin_contrato,";
			sql= sql + "		(select  DATEPART(yyyy,cdot_finicio) ) as anio_ini_contrato,";
			sql= sql + " 		(select  DATEPART(yyyy,cdot_ffin)) as anio_fin_contrato,";
			sql= sql + "         (SELECT DATEPART(d, GETDATE()))as Dia,  ";
			sql= sql + "         (SELECT DATEPART(yy, GETDATE())) as Año,  ";
			sql= sql + "		(select protic.obtener_grado_docente(a.pers_ncorr,'G')) as grado,";
			sql= sql + "		(select protic.obtener_grado_docente(a.pers_ncorr,'I')) as institucion_t1, ";
			sql= sql + "		(select top 1 cudo_tinstitucion from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as institucion_t";
            sql= sql + "          From contratos_docentes_otec a, anexos_otec b , detalle_anexo_otec c,modulos_otec mo,secciones_otec so,datos_generales_secciones_otec dg,instituciones l ";
            sql= sql + "          Where a.cdot_ncorr   = b.cdot_ncorr ";
			sql= sql + "         and b.anot_ncorr  = c.anot_ncorr ";
			sql= sql + "         and c.seot_ncorr=so.seot_ncorr  ";
			sql= sql + "         and b.cdot_ncorr = c.cdot_ncorr ";
			sql= sql + "         and mo.mote_ccod=c.mote_ccod ";
			sql= sql + "         and so.dgso_ncorr=dg.dgso_ncorr ";
			sql= sql + "         and l.INST_CCOD=1  ";
			sql= sql + "         and cast(a.pers_ncorr as varchar)='"+pers_ncorr+"' ";
			sql= sql + "         and cast(dg.dcur_ncorr as varchar)='"+dcur_ncorr+"') as g ";
			sql= sql + "         group by mote_ccod,mote_tdesc,cdot_ncorr,anot_ncorr,anot_ncodigo,cdot_finicio,cdot_ffin,ano_contrato,anot_inicio,anot_fin,daot_mhora,anot_ncuotas, ";
			sql= sql + "         nombre_docente,Rut_Docente,fecha_nac,estado_civil,comuna,profesion,TipoDocente,Nacionalidad,NombreRepLeg,dcurr_tdesc,inst_trazon_social,sede_tdesc,seot_tdesc,daot_nhora,daot_mhora,anot_ncuotas,valorI,valoII,Dia,Mes,Año,fin_con,ini_con,mes_ini_contrato,mes_fin_contrato,anio_ini_contrato,anio_fin_contrato,Direccion,nacionalidad,grado,institucion_t1  ";

																										 
		//Response.Write(sql);
		//Response.Flush();
			return (sql);	
		}
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string pers_ncorr;
			string dcur_ncorr;	
			string tcdo_ccod;

			
			pers_ncorr = Request.QueryString["pers_ncorr"];
			
			dcur_ncorr = Request.QueryString["dcur_ncorr"];
			
			tcdo_ccod = Request.QueryString["tcdo_ccod"];

			//Response.Write(pers_ncorr);
			//Response.Write(dcur_ncorr);
			//Response.Write(tcdo_ccod);
			pers_ncorr = "24518";
			dcur_ncorr = "40";
			//pers_ncorr = "0";
			//dcur_ncorr = "0";
			tcdo_ccod="3";

			//Response.End();
			oleDbDataAdapter1.SelectCommand.CommandTimeout=450;
			
				
			sql = EscribirCodigo(pers_ncorr,dcur_ncorr);

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);

			
			if (tcdo_ccod == "2") {
			contrato_docente_otec.plazo_indef reporte = new contrato_docente_otec.plazo_indef();
			reporte.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = reporte;
				ExportarPDF(reporte);
			}
		
			if (tcdo_ccod == "1")
			{
				contrato_docente_otec.honorario reporte = new contrato_docente_otec.honorario();
				reporte.SetDataSource(dataSet11);
				CrystalReportViewer1.ReportSource = reporte;
				ExportarPDF(reporte);
			}
			if (tcdo_ccod == "3")
			{
				contrato_docente_otec.plazoFijo reporte = new contrato_docente_otec.plazoFijo();
				reporte.SetDataSource(dataSet11);
				CrystalReportViewer1.ReportSource = reporte;
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
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.dataSet11 = new contrato_docente_otec.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT 0 AS CDOt_NCORR, 0 AS pers_ncorr, '' AS Nombre_Docente, '' AS Rut_Docente, '' AS DV, '' AS Fecha_Nac, '' AS Estado_Civil, '' AS Direccion, '' AS Comuna, '' AS Ciudad, '' AS PROFESION, 0 AS Bhot_ANEXO, 0 AS dcurr_CCOD, '' AS dcurr_TDESC, '' AS mote_CCOD, 0 AS daot_NHORA, '' AS mote_TDESC, '' AS daot_mhora, 0 AS anot_ncorr, '' AS INST_TRAZON_SOCIAL, '' AS NombreRepLeg, '' AS tcat_tdesc, '' AS Nacionalidad, '' AS cdot_finicio, '' AS cdot_ffin, '' AS SEot_TDESC, '' AS sede_tdesc, '' AS anot_ncuotas, '' AS anot_inicio, '' AS anot_fin, '' AS institucion_t, '' AS TipoDocente, '' AS ano_contrato, '' AS seot_ncorr, 0 AS daot_ncorr, 0 AS valorI, '' AS Mes, '' AS Dia, '' AS Año, 0 AS valoII, '' AS anot_ncodigo";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated);
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

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
		
	}

}
