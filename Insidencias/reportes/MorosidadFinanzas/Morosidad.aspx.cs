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

namespace MorosidadFinanzas
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DbDataAdapter;
		protected MorosidadFinanzas.DataSetMorosidad dataSetMorosidad1;
		protected CrystalDecisions.Web.CrystalReportViewer VisorCrystalReport;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection DbConnection;
	

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

		private void ExportarEXCEL(ReportDocument rep) 
		{
			String ruta_exportacion;

			ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			//ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=Morosidad.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		private string Generar_SQL_Morosidad(string SEDE, string FIN)
		{
		  string sql = "";
           
				sql =       "select d.sede_tdesc, '" + FIN + "' as Fecha_corte, obtener_nombre_carrera(c.ofer_ncorr, 'CEJ') as carrera, a.pers_nrut || '-' || a.pers_xdv as rut, a.PERS_TAPE_PATERNO || ' ' || a.pers_tape_materno || ', ' || a.PERS_TNOMBRE   as nombre, \n";
				sql = sql + "       sum(f.dcom_mcompromiso) as comprometido, \n";
				sql = sql + "sum(decode(j.ting_ccod, 4, total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso), 0)) as letras, \n";
				sql = sql + "	   sum(decode(j.ting_ccod, 3, total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso), 0)) as cheques, \n";
				sql = sql + "	   sum(decode(j.ting_ccod, 26, total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso), 0)) as pagare \n";
				sql = sql + "from personas a, alumnos b, ofertas_academicas c, sedes d, \n";
				sql = sql + "     compromisos e, detalle_compromisos f, abonos g, ingresos h, detalle_ingresos i, tipos_ingresos j \n";
				sql = sql + "where a.pers_ncorr = b.pers_ncorr \n";
				sql = sql + "  and b.ofer_ncorr = c.ofer_ncorr \n";
				sql = sql + "  and c.sede_ccod = d.sede_ccod \n";
				sql = sql + "  and b.ofer_ncorr = ultima_oferta_matriculado(a.pers_ncorr) \n";
				sql = sql + "  and a.pers_ncorr = e.pers_ncorr \n";
				sql = sql + "  and e.tcom_ccod = f.tcom_ccod \n";
				sql = sql + "  and e.inst_ccod = f.inst_ccod \n";
				sql = sql + "  and e.comp_ndocto = f.comp_ndocto \n";
				sql = sql + "  and f.tcom_ccod = g.tcom_ccod \n";
				sql = sql + "  and f.inst_ccod = g.inst_ccod \n";
				sql = sql + "  and f.comp_ndocto = g.comp_ndocto \n";
				sql = sql + "  and f.dcom_ncompromiso = g.dcom_ncompromiso \n";
				sql = sql + "  and g.ingr_ncorr = h.ingr_ncorr \n";
				sql = sql + "  and h.ingr_ncorr = i.ingr_ncorr \n";
				sql = sql + "  and i.ting_ccod = j.ting_ccod \n";
				sql = sql + "  and i.ding_bpacta_cuota = 'S' \n";
				sql = sql + "  and e.ecom_ccod = 1   \n";
				sql = sql + "  and f.ecom_ccod = 1 \n";
				sql = sql + "  and b.emat_ccod = 1   \n";
				sql = sql + "  and h.eing_ccod <> 3 \n";
				sql = sql + "  and h.eing_ccod = 4 \n";
				sql = sql + "  and j.ting_ccod in (3, 4, 26) \n";
				sql = sql + "  and f.dcom_fcompromiso between nvl(to_date('', 'dd/mm/yyyy'), f.dcom_fcompromiso) and nvl(to_date('" + FIN + "', 'dd/mm/yyyy'), f.dcom_fcompromiso) \n";
				sql = sql + "  and c.sede_ccod = '" + SEDE + "'       \n";				    
				sql = sql + "group by d.sede_tdesc, c.ofer_ncorr, a.pers_ncorr, a.pers_nrut,a.pers_xdv, a.PERS_TAPE_PATERNO ,a.pers_tape_materno, a.PERS_TNOMBRe \n";
			    sql = sql + "having es_moroso(a.pers_ncorr,to_date('" + FIN + "','dd/mm/yyyy')) = 'S' \n";

//--------------------------------------------------------------------------------------------
sql = " ";
//--------------------------------------------------------------------------------------------
				sql = " select d.sede_tdesc, '" + FIN + "' as Fecha_corte, protic.obtener_nombre_carrera(c.ofer_ncorr, 'CEJ') as carrera, \n";
				sql = sql + " cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, a.PERS_TAPE_PATERNO + ' ' + a.pers_tape_materno + ', ' + a.PERS_TNOMBRE   as nombre, \n";
				sql = sql + " sum(f.dcom_mcompromiso) as comprometido, \n";
				sql = sql + " sum(case i.ting_ccod when 4 then protic.total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso) else 0 end) as letras, \n";
				sql = sql + " sum(case i.ting_ccod when 3 then protic.total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso) else 0 end) as cheques, \n";
				sql = sql + " sum(case i.ting_ccod when 52 then protic.total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso) else 0 end) as pagare \n";
				sql = sql + "	from personas a, alumnos b, ofertas_academicas c, sedes d, \n";
				sql = sql + "	     compromisos e, detalle_compromisos f, abonos g, ingresos h, detalle_ingresos i --, tipos_ingresos j \n";
				sql = sql + "	where a.pers_ncorr = b.pers_ncorr \n";
				sql = sql + "	  and b.ofer_ncorr = c.ofer_ncorr \n";
				sql = sql + "	  and c.sede_ccod = d.sede_ccod \n";
				sql = sql + "	  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) \n";
				sql = sql + "	  and a.pers_ncorr = e.pers_ncorr \n";
				sql = sql + "	  and e.tcom_ccod = f.tcom_ccod \n";
				sql = sql + "	  and e.inst_ccod = f.inst_ccod \n";
				sql = sql + "	  and e.comp_ndocto = f.comp_ndocto \n";
				sql = sql + "	  and f.tcom_ccod = g.tcom_ccod \n";
				sql = sql + "	  and f.inst_ccod = g.inst_ccod \n";
				sql = sql + "	  and f.comp_ndocto = g.comp_ndocto \n";
				sql = sql + "	  and f.dcom_ncompromiso = g.dcom_ncompromiso \n";
				sql = sql + "	  and g.ingr_ncorr = h.ingr_ncorr \n";
				sql = sql + "	  and h.ingr_ncorr = i.ingr_ncorr \n";
				sql = sql + "	  --and i.ting_ccod = j.ting_ccod \n";
				sql = sql + "	  and i.ding_bpacta_cuota = 'S' \n";
				sql = sql + "	  and e.ecom_ccod = 1   \n";
				sql = sql + "	  and f.ecom_ccod = 1 \n";
				sql = sql + "	  and b.emat_ccod = 1   \n";
				sql = sql + "	  and h.eing_ccod <> 3 \n";
				sql = sql + "	  and h.eing_ccod = 4 \n";
				sql = sql + "	  and i.ting_ccod in (3, 4, 52) \n";
				sql = sql + "	  and f.dcom_fcompromiso between isnull('',f.dcom_fcompromiso) and isnull('" + FIN + "', f.dcom_fcompromiso) \n";
				sql = sql + "	  and c.sede_ccod = '" + SEDE + "'       				    \n";
				sql = sql + "	group by d.sede_tdesc, c.ofer_ncorr, a.pers_ncorr, a.pers_nrut,a.pers_xdv, a.PERS_TAPE_PATERNO ,a.pers_tape_materno, a.PERS_TNOMBRe \n";
				sql = sql + "    having protic.es_moroso(a.pers_ncorr,'" + FIN + "') = 'S' \n";

			//Response.Write(sql);
			//Response.Flush();

		  return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", sede = "", fin = "", tipodoc = "";
			CrystalReport Reporte = new CrystalReport();

			//Server.ScriptTimeout=12;

			sede = Request.QueryString["sede"];
			fin = Request.QueryString["fin"];
			tipodoc = Request.QueryString["tipodoc"];
		
			sql = Generar_SQL_Morosidad(sede, fin);
            			
			//Response.Write("<PRE>" + sql + "</PRE>");
			//Response.End();
			
			DbDataAdapter.SelectCommand.CommandText = sql;
            //aumenta el tiempo de espera para evitar la caida del reporte 
			// 900=15 minutos
			DbDataAdapter.SelectCommand.CommandTimeout=900;

			DbDataAdapter.Fill(dataSetMorosidad1);
			Reporte.SetDataSource(dataSetMorosidad1);
			VisorCrystalReport.ReportSource = Reporte;
			
			if (tipodoc == "1")
			  ExportarPDF(Reporte);		
			else
			  ExportarEXCEL(Reporte);

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
			this.DbConnection = new System.Data.OleDb.OleDbConnection();
			this.DbDataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSetMorosidad1 = new MorosidadFinanzas.DataSetMorosidad();
			((System.ComponentModel.ISupportInitialize)(this.dataSetMorosidad1)).BeginInit();
			// 
			// DbConnection
			// 
			this.DbConnection.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DbDataAdapter
			// 
			this.DbDataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DbDataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "T_Morosidad", new System.Data.Common.DataColumnMapping[] {
																																																				   new System.Data.Common.DataColumnMapping("FECHA_CORTE", "FECHA_CORTE"),
																																																				   new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				   new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																				   new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																				   new System.Data.Common.DataColumnMapping("COMPROMETIDO", "COMPROMETIDO"),
																																																				   new System.Data.Common.DataColumnMapping("LETRAS", "LETRAS"),
																																																				   new System.Data.Common.DataColumnMapping("CHEQUES", "CHEQUES"),
																																																				   new System.Data.Common.DataColumnMapping("PAGARE", "PAGARE")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS FECHA_CORTE, \'\' AS SEDE_TDESC, \'\' AS CARRERA, \'\' AS RUT, \'\' AS NOMBR" +
				"E, \'\' AS COMPROMETIDO, \'\' AS LETRAS, \'\' AS CHEQUES, \'\' AS PAGARE FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.DbConnection;
			// 
			// dataSetMorosidad1
			// 
			this.dataSetMorosidad1.DataSetName = "DataSetMorosidad";
			this.dataSetMorosidad1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSetMorosidad1.Namespace = "http://www.tempuri.org/DataSetMorosidad.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSetMorosidad1)).EndInit();

		}
		#endregion
	}
}
