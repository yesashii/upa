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

namespace comprobante_prorroga
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected comprobante_prorroga.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
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
	  
		private string Filtrar_Comprobantes()
		{   int fila = 0;			  
			//Response.Write(Request.Form.Count);
			string numero="", folios="";
			for (int i = 0; i < Request.Form.Count; i++)
			{
				//Response.Write("<br>" + Request.Form.GetKey(i) + " : " + Request.Form[i]);
							
				numero = Request.Form[i];
				if (numero != "")
				{
				  //Response.Write(numero);
                  folios = folios + numero + ",";
				}				
			}
			 folios = folios + "''";
			
			return(folios);
		}

		private string sql_comprobante_prorroga(string Folios)
		{
		  string sql;
			sql =        "select distinct a.reca_ncorr, b.ding_ndocto,d.ting_tdesc, x.vencimiento_original, b.ding_mdocto, ding_tcuenta_corriente, c.banc_tdesc, ";
			sql = sql +			"obtener_rut (e.pers_ncorr)as rut_alumno, obtener_nombre_completo(e.pers_ncorr)as nombre_alumno, ";
			sql = sql +			"b.ding_fdocto as nueva_fecha, obtener_nombre_carrera(f.ofer_ncorr,'C') as carrera, a.reca_mmonto as interes  ";
			sql = sql + "from referencias_cargos a, detalle_ingresos b, bancos c, tipos_ingresos d, ingresos e, ";
			sql = sql +			"postulantes f,  ";
			sql = sql +			"(select trunc(ding_fdocto) as vencimiento_original, dilg_ncorr ";
			sql = sql +			"from detalle_ingresos_log ";
			sql = sql +			") x ";
			sql = sql + "where a.reca_ncorr = x.dilg_ncorr ";
			sql = sql +	  "and b.ting_ccod = a.ting_ccod ";
			sql = sql +   "and b.ding_ndocto = a.ding_ndocto ";
			sql = sql +   "and b.ingr_ncorr = a.ingr_ncorr ";
			sql = sql +   "and b.banc_ccod  = c.banc_ccod (+) ";
			sql = sql +   "and b.ting_ccod = d.ting_ccod ";
			sql = sql +   "and b.ingr_ncorr = e.ingr_ncorr ";
			sql = sql +   "and e.pers_ncorr = f.pers_ncorr (+)";
			sql = sql +   "and reca_ncorr IN ("+  Folios + ")";
	 		//Response.Write(sql);  
			//Response.End();
		  return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql="", folios ="";			
            CrystalReport1 comp_prorroga = new CrystalReport1();
			
			folios = Filtrar_Comprobantes();
			sql = sql_comprobante_prorroga(folios);
			
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			comp_prorroga.SetDataSource(dataSet11);
			
			CrystalReportViewer1.ReportSource = comp_prorroga;
			ExportarPDF(comp_prorroga);
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
			this.dataSet11 = new comprobante_prorroga.DataSet1();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
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
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("RECA_NCORR", "RECA_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("VENCIMIENTO_ORIGINAL", "VENCIMIENTO_ORIGINAL"),
																																																				 new System.Data.Common.DataColumnMapping("TING_TDESC", "TING_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("NUEVA_FECHA", "NUEVA_FECHA"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				 new System.Data.Common.DataColumnMapping("DING_TCUENTA_CORRIENTE", "DING_TCUENTA_CORRIENTE"),
																																																				 new System.Data.Common.DataColumnMapping("BANC_TDESC", "BANC_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("DING_MDOCTO", "DING_MDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("INTERES", "INTERES"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO")})});
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS RECA_NCORR, \'\' AS VENCIMIENTO_ORIGINAL, \'\' AS TING_TDESC, \'\' AS DING" +
				"_NDOCTO, \'\' AS NUEVA_FECHA, \'\' AS NOMBRE_ALUMNO, \'\' AS CARRERA, \'\' AS DING_TCUEN" +
				"TA_CORRIENTE, \'\' AS BANC_TDESC, \'\' AS DING_MDOCTO, \'\' AS INTERES, \'\' AS RUT_ALUM" +
				"NO FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
