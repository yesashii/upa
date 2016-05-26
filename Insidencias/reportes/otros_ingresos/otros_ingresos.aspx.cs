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

namespace otros_ingresos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected otros_ingresos.DataSet1 ds;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbConnection conexion;
	
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


		private string ObtenerSql(string p_anos_ccod, string p_sede_ccod) {
			string SQL;

			SQL = " select c.tdet_ccod, initcap(c.tdet_tdesc) as tdet_tdesc,        \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '01', f.abon_mabono, 0)) as recibido_01, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '02', f.abon_mabono, 0)) as recibido_02, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '03', f.abon_mabono, 0)) as recibido_03, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '04', f.abon_mabono, 0)) as recibido_04, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '05', f.abon_mabono, 0)) as recibido_05, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '06', f.abon_mabono, 0)) as recibido_06, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '07', f.abon_mabono, 0)) as recibido_07, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '08', f.abon_mabono, 0)) as recibido_08, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '09', f.abon_mabono, 0)) as recibido_09, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '10', f.abon_mabono, 0)) as recibido_10, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '11', f.abon_mabono, 0)) as recibido_11, \n";
			SQL = SQL +  " 	   sum(decode(to_char(g.ingr_fpago, 'mm'), '12', f.abon_mabono, 0)) as recibido_12, \n";
			SQL = SQL +  " 	   sum(f.abon_mabono) as recibido_ano \n";
			SQL = SQL +  " from compromisos a, detalles b, tipos_detalle c, tipos_compromisos d, detalle_compromisos e,  \n";
			SQL = SQL +  "      abonos f, ingresos g, tipos_ingresos h, movimientos_cajas i \n";
			SQL = SQL +  " where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  "   and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  "   and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "   and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  "   and c.tcom_ccod = a.tcom_ccod \n";
			SQL = SQL +  "   and a.tcom_ccod = d.tcom_ccod \n";
			SQL = SQL +  "   and a.tcom_ccod = e.tcom_ccod \n";
			SQL = SQL +  "   and a.inst_ccod = e.inst_ccod \n";
			SQL = SQL +  "   and a.comp_ndocto = e.comp_ndocto \n";
			SQL = SQL +  "   and e.tcom_ccod = f.tcom_ccod \n";
			SQL = SQL +  "   and e.inst_ccod = f.inst_ccod \n";
			SQL = SQL +  "   and e.comp_ndocto = f.comp_ndocto \n";
			SQL = SQL +  "   and e.dcom_ncompromiso = f.dcom_ncompromiso \n";
			SQL = SQL +  "   and f.ingr_ncorr = g.ingr_ncorr \n";
			SQL = SQL +  "   and g.ting_ccod = h.ting_ccod \n";
			SQL = SQL +  "   and g.mcaj_ncorr = i.mcaj_ncorr \n";
			SQL = SQL +  "   and d.tcom_bcargo = 'S' \n";
			SQL = SQL +  "   and g.eing_ccod = 1 \n";
			SQL = SQL +  "   and h.ting_bingreso_real = 'S' \n";
			SQL = SQL +  "   and a.tcom_ccod <> 7 \n";
			SQL = SQL +  "   and a.ecom_ccod = 1 \n";
			SQL = SQL +  "   and e.ecom_ccod = 1  \n";
			SQL = SQL +  "   and i.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  "   and to_char(g.ingr_fpago, 'yyyy') = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " group by c.tdet_ccod, c.tdet_tdesc \n";
			SQL = SQL +  " order by c.tdet_tdesc asc ";
//----------------------------------------------------------------------------------------
			SQL="";
//----------------------------------------------------------------------------------------

			SQL = " Select c.tdet_ccod, protic.initcap(c.tdet_tdesc) as tdet_tdesc, \n";       
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '01' then f.abon_mabono else 0 end) as recibido_01, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '02' then f.abon_mabono else 0 end) as recibido_02, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '03' then f.abon_mabono else 0 end) as recibido_03, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '04' then f.abon_mabono else 0 end) as recibido_04, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '05' then f.abon_mabono else 0 end) as recibido_05, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '06' then f.abon_mabono else 0 end) as recibido_06, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '07' then f.abon_mabono else 0 end) as recibido_07, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '08' then f.abon_mabono else 0 end) as recibido_08, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '09' then f.abon_mabono else 0 end) as recibido_09, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '10' then f.abon_mabono else 0 end) as recibido_10, \n";
			SQL = SQL +  "	   sum(case datepart(month,g.ingr_fpago) when '11' then f.abon_mabono else 0 end) as recibido_11, \n";
			SQL = SQL +  " 	   sum(case datepart(month,g.ingr_fpago) when '12' then f.abon_mabono else 0 end) as recibido_12, \n";
			SQL = SQL +  " 	   sum(f.abon_mabono) as recibido_ano \n";
			SQL = SQL +  " from compromisos a, detalles b, tipos_detalle c, tipos_compromisos d, detalle_compromisos e,  \n";
			SQL = SQL +  "      abonos f, ingresos g, tipos_ingresos h, movimientos_cajas i \n";
			SQL = SQL +  " where a.tcom_ccod = b.tcom_ccod \n";
			SQL = SQL +  "   and a.inst_ccod = b.inst_ccod \n";
			SQL = SQL +  "   and a.comp_ndocto = b.comp_ndocto \n";
			SQL = SQL +  "   and b.tdet_ccod = c.tdet_ccod \n";
			SQL = SQL +  "   and c.tcom_ccod = a.tcom_ccod \n";
			SQL = SQL +  "   and a.tcom_ccod = d.tcom_ccod \n";
			SQL = SQL +  "   and a.tcom_ccod = e.tcom_ccod \n";
			SQL = SQL +  "   and a.inst_ccod = e.inst_ccod \n";
			SQL = SQL +  "   and a.comp_ndocto = e.comp_ndocto \n";
			SQL = SQL +  "   and e.tcom_ccod = f.tcom_ccod \n";
			SQL = SQL +  "   and e.inst_ccod = f.inst_ccod \n";
			SQL = SQL +  "   and e.comp_ndocto = f.comp_ndocto \n";
			SQL = SQL +  "   and e.dcom_ncompromiso = f.dcom_ncompromiso \n";
			SQL = SQL +  "   and f.ingr_ncorr = g.ingr_ncorr \n";
			SQL = SQL +  "   and g.ting_ccod = h.ting_ccod \n";
			SQL = SQL +  "   and g.mcaj_ncorr = i.mcaj_ncorr \n";
			SQL = SQL +  "   and d.tcom_bcargo = 'S' \n";
			SQL = SQL +  "   and g.eing_ccod = 1 \n";
			SQL = SQL +  "   and h.ting_bingreso_real = 'S' \n";
			SQL = SQL +  "   and a.tcom_ccod <> 7 \n";
			SQL = SQL +  "   and a.ecom_ccod = 1 \n";
			SQL = SQL +  "   and e.ecom_ccod = 1 \n";
			SQL = SQL +  "   and i.sede_ccod = '" + p_sede_ccod + "' \n";
			SQL = SQL +  "   and datepart(year,g.ingr_fpago) = '" + p_anos_ccod + "' \n";
			SQL = SQL +  " group by c.tdet_ccod, c.tdet_tdesc \n";
			SQL = SQL +  " order by c.tdet_tdesc asc \n";

			return SQL;
		}

	
		private void Page_Load(object sender, System.EventArgs e) {
			// Introducir aquí el código de usuario para inicializar la página
			string q_anos_ccod = Request["filtros[0][anos_ccod]"];
			string q_sede_ccod = Request["filtros[0][sede_ccod]"];
			string q_formato = Request["filtros[0][formato]"];
		


			crOtrosIngresos rep = new crOtrosIngresos();

			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_anos_ccod, q_sede_ccod);
			adpDetalles.Fill(ds);

			//Response.Write("<pre>" + adpDetalles.SelectCommand.CommandText + "</pre>");
			//Response.Flush();

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
			this.ds = new otros_ingresos.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "OTROS_INGRESOS", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("TDET_CCOD", "TDET_CCOD"),
																																																					new System.Data.Common.DataColumnMapping("TDET_TDESC", "TDET_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_01", "RECIBIDO_01"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_02", "RECIBIDO_02"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_03", "RECIBIDO_03"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_04", "RECIBIDO_04"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_05", "RECIBIDO_05"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_06", "RECIBIDO_06"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_07", "RECIBIDO_07"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_08", "RECIBIDO_08"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_09", "RECIBIDO_09"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_10", "RECIBIDO_10"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_11", "RECIBIDO_11"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_12", "RECIBIDO_12"),
																																																					new System.Data.Common.DataColumnMapping("RECIBIDO_ANO", "RECIBIDO_ANO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT 0 AS TDET_CCOD, '' AS TDET_TDESC, 0 AS RECIBIDO_01, 0 AS RECIBIDO_02, 0 AS RECIBIDO_03, 0 AS RECIBIDO_04, 0 AS RECIBIDO_05, 0 AS RECIBIDO_06, 0 AS RECIBIDO_07, 0 AS RECIBIDO_08, 0 AS RECIBIDO_09, 0 AS RECIBIDO_10, 0 AS RECIBIDO_11, 0 AS RECIBIDO_12, 0 AS RECIBIDO_ANO FROM DUAL";
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
