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

namespace detalle_envio_banco
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected detalle_envio_banco.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
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

		private string Crear_Consulta_Listado_Letras(string envio, string periodo)
		{
			string sql;

			sql = "select a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto, \n";
			sql = sql +  "        c.ding_mdocto,c.ding_mdetalle, a.envi_fenvio, d.ingr_fpago, convert(varchar,d.ingr_fpago,103) as ingr_fpago, \n";
			sql = sql +  "        c.ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno, \n";
			sql = sql +  "        protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado,   \n";
			sql = sql +  "        (select ccte_tdesc from  cuentas_corrientes where ccte_ccod = a.ccte_ccod) ccte_tdesc, (select inen_tdesc from instituciones_envio where inen_ccod = a.inen_ccod) as inen_tdesc, cast(f.pers_tnombre as varchar) + ' ' + f.pers_tape_paterno as nombre_apoderado  \n";
			sql = sql +  "    from envios a,detalle_envios b,detalle_ingresos c,estados_detalle_ingresos c1, \n";
			sql = sql +  "    ingresos d,personas e,personas f \n";
			sql = sql +  "    where a.envi_ncorr = b.envi_ncorr \n";
			sql = sql +  "    and b.ting_ccod = c.ting_ccod   \n";
			sql = sql +  "    and b.ding_ndocto = c.ding_ndocto   \n";
			sql = sql +  "    and b.ingr_ncorr = c.ingr_ncorr \n";
			sql = sql +  "    and b.edin_ccod = c1.edin_ccod  \n";
			sql = sql +  "    and c.ingr_ncorr = d.ingr_ncorr \n";
			sql = sql +  "    and d.pers_ncorr = e.pers_ncorr \n";
			sql = sql +  "    and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr \n";
			sql = sql +  "    and c.DING_NCORRELATIVO = 1 \n";
			sql = sql +  "    and cast(a.envi_ncorr as varchar) ='" + envio + "'";

		return (sql);
		}


		private void Page_Load(object sender, System.EventArgs e)
		{
			
			string sql, envio, periodo; 		

			periodo = Request.QueryString["periodo"];
			envio = Request.QueryString["folio_envio"];
			//envio="97";
			//periodo="300";
			CrystalReport1 ListadoAgrupado = new CrystalReport1();
			sql = Crear_Consulta_Listado_Letras(envio,periodo);
			//Response.Write(sql);
            //Response.Flush();
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			ListadoAgrupado.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = ListadoAgrupado;
			ExportarPDF(ListadoAgrupado);


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
			this.dataSet11 = new detalle_envio_banco.DataSet1();
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
																																																					  new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																					  new System.Data.Common.DataColumnMapping("INEN_CCOD", "INEN_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("PLAZ_CCOD", "PLAZ_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("PLAZ_TDESC", "PLAZ_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																					  new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																					  new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																					  new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("DING_MDETALLE", "DING_MDETALLE"),
																																																					  new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																					  new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																					  new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("SEDE_TCALLE", "SEDE_TCALLE"),
																																																					  new System.Data.Common.DataColumnMapping("SEDE_TNRO", "SEDE_TNRO"),
																																																					  new System.Data.Common.DataColumnMapping("CCTE_CCOD", "CCTE_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD"),
																																																					  new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("EDIN_TDESC", "EDIN_TDESC"),
																																																					  new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS ENVI_NCORR, '' AS ENVI_FENVIO, '' AS INEN_CCOD, '' AS INEN_TDESC, '' AS PLAZ_CCOD, '' AS PLAZ_TDESC, '' AS RUT_ALUMNO, '' AS NOMBRE_APODERADO, '' AS RUT_APODERADO, '' AS DIRECCION, '' AS DING_FDOCTO, '' AS DING_MDETALLE, '' AS DING_NDOCTO, '' AS INGR_NCORR, '' AS TING_CCOD, '' AS CCTE_TDESC, '' AS SEDE_TCALLE, '' AS SEDE_TNRO, '' AS CCTE_CCOD, '' AS SEDE_CCOD, '' AS ESPE_TDESC, '' AS EDIN_TDESC, '' AS INGR_FPAGO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
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
