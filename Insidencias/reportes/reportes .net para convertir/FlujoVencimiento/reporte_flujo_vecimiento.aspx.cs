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

namespace FlujoVencimiento
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected CrystalDecisions.Web.CrystalReportViewer VerReporte;
		protected FlujoVencimiento.FlujoVencimientoData flujoVencimientoData1;
	
		private void ExportarPDF(ReportDocument rep) 
		{
			String ruta_exportacion;

			//ruta_exportacion = Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"]);
			ruta_exportacion = System.Configuration.ConfigurationSettings.AppSettings["ruta_exportacion_pdf"];
			
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

		private string EscribirCodigo()
		{
			string sql;
		    
			
			sql =  " 	select CARR_TDESC,CARR_CCOD,sum(CHEQUE) total_cheque_a,sum(LETRA) total_letra_a   ";
			sql = sql + " 	from (  ";
			sql = sql + " 			   select DECODE( a.TING_CCOD,3,a.valor_efectivo) CHEQUE,  ";
			sql = sql + " 			   		  DECODE( a.TING_CCOD,4,a.valor_efectivo) LETRA,  ";
			sql = sql + " 			    	  a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD   ";
			sql = sql + " 			   from (  ";
			sql = sql + " 			   		  select sum(dii.DING_MDOCTO) valor_efectivo,car.CARR_CCOD, car.CARR_TDESC,  ";
			sql = sql + " 					  		  aa.PERS_NCORR,dii.TING_CCOD  ";
			sql = sql + " 						from alumnos aa, contratos cc, compromisos com,   ";
			sql = sql + " 						detalle_compromisos dc, abonos ab,  ";
			sql = sql + " 						ingresos ii,detalle_ingresos dii,  ";
			sql = sql + " 						ofertas_academicas oo , especialidades ee, carreras car  ";
			sql = sql + " 						where aa.emat_ccod<>9  ";
			sql = sql + " 						and cc.CONT_NCORR=com.COMP_NDOCTO  ";
			sql = sql + " 						and com.TCOM_CCOD=dc.TCOM_CCOD  ";
			sql = sql + " 						and com.INST_CCOD=dc.INST_CCOD  ";
			sql = sql + " 						and oo.PERI_CCOD=160  ";
			sql = sql + " 						and oo.SEDE_CCOD=nvl('1',oo.SEDE_CCOD)  ";
			sql = sql + " 						and aa.OFER_NCORR=oo.OFER_NCORR  ";
			sql = sql + " 						and oo.ESPE_CCOD=ee.ESPE_CCOD  ";
			sql = sql + " 						and ee.CARR_CCOD=car.CARR_CCOD  ";
			sql = sql + " 						and cc.ECON_CCOD=1  ";
			sql = sql + " 						and aa.MATR_NCORR=cc.MATR_NCORR  ";
			sql = sql + " 						and com.ECOM_CCOD=1  ";
			sql = sql + " 						and com.TCOM_CCOD in (1,2)  ";
			sql = sql + " 						and com.COMP_NDOCTO=dc.COMP_NDOCTO  ";
			sql = sql + " 						and dc.TCOM_CCOD=ab.TCOM_CCOD  ";
			sql = sql + " 						and dc.INST_CCOD=ab.INST_CCOD  ";
			sql = sql + " 						and dc.COMP_NDOCTO=ab.COMP_NDOCTO  ";
			sql = sql + " 						and dc.DCOM_NCOMPROMISO=ab.DCOM_NCOMPROMISO  ";
			sql = sql + " 						and ii.EING_CCOD=4	  ";
			sql = sql + " 						and ii.INGR_MEFECTIVO=0  ";
			sql = sql + " 						and ab.INGR_NCORR=ii.INGR_NCORR  ";
			sql = sql + " 						and ii.INGR_NCORR=dii.INGR_NCORR  ";
			sql = sql + " 						and dii.DING_NCORRELATIVO=1  ";
			sql = sql + " 						and dii.DING_BPACTA_CUOTA='S'  ";
			sql = sql + " 						and trunc(dii.DING_FDOCTO) between nvl('',dii.DING_FDOCTO)   ";
			sql = sql + " 						and nvl('',dii.DING_FDOCTO)  ";
			sql = sql + " 						group by car.CARR_CCOD, car.CARR_TDESC,aa.PERS_NCORR,dii.TING_CCOD  ";
			sql = sql + " 						) a   ";
			sql = sql + " 					group by  a.valor_efectivo, a.CARR_CCOD,a.CARR_TDESC, a.PERS_NCORR,a.TING_CCOD   ";
			sql = sql + " 					having ano_ingreso_carrera(a.PERS_NCORR,a.CARR_CCOD)=2004  ";
			sql = sql + " 					)   ";
			sql = sql + " 					group by CARR_CCOD,CARR_TDESC  ";
			return (sql);
		
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			//string post_ncorr;
			//string paga_ncorr;
			//string imprimirFinanza;
			//string paga_ncorr_d;
			//int fila = 0;	
			//post_ncorr = Request.QueryString["post_ncorr"];
			
			sql = EscribirCodigo();

			//Response.Write(sql);
			//Response.End();

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(flujoVencimientoData1);
					
			//}
			
			//Response.End();
			
			CrystalReportFlujo reporte = new CrystalReportFlujo();
			
				
			reporte.SetDataSource(flujoVencimientoData1);
			VerReporte.ReportSource = reporte;
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
			this.flujoVencimientoData1 = new FlujoVencimiento.FlujoVencimientoData();
			((System.ComponentModel.ISupportInitialize)(this.flujoVencimientoData1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "flujoVencimiento", new System.Data.Common.DataColumnMapping[] {
																																																							new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																							new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_CHEQUE_A", "TOTAL_CHEQUE_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_LETRA_A", "TOTAL_LETRA_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_CHEQUE_N", "TOTAL_CHEQUE_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_LETRA_N", "TOTAL_LETRA_N"),
																																																							new System.Data.Common.DataColumnMapping("EFECTIVO_A", "EFECTIVO_A"),
																																																							new System.Data.Common.DataColumnMapping("EFECTIVO_N", "EFECTIVO_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_CREDITO_A", "TOTAL_CREDITO_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_BECA_A", "TOTAL_BECA_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_DESCUENTO_A", "TOTAL_DESCUENTO_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_CREDITO_N", "TOTAL_CREDITO_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_BECA_N", "TOTAL_BECA_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_DESCUENTO_N", "TOTAL_DESCUENTO_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_CHEQUE_A", "TOTAL_MATR_CHEQUE_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_LETRA_A", "TOTAL_MATR_LETRA_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_A", "TOTAL_COL_LETRA_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_CHEQUE_A", "TOTAL_COL_CHEQUE_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_CHEQUE_N", "TOTAL_MATR_CHEQUE_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_LETRA_N", "TOTAL_MATR_LETRA_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_LETRA_N", "TOTAL_COL_LETRA_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_CHEQUE_N", "TOTAL_COL_CHEQUE_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_EFECTIVO_A", "TOTAL_MATR_EFECTIVO_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_EFECTIVO_A", "TOTAL_COL_EFECTIVO_A"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_MATR_EFECTIVO_N", "TOTAL_MATR_EFECTIVO_N"),
																																																							new System.Data.Common.DataColumnMapping("TOTAL_COL_EFECTIVO_N", "TOTAL_COL_EFECTIVO_N")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS CARR_TDESC, '' AS CARR_CCOD, '' AS TOTAL_CHEQUE_A, '' AS TOTAL_LETRA_A, '' AS TOTAL_CHEQUE_N, '' AS TOTAL_LETRA_N, '' AS EFECTIVO_A, '' AS EFECTIVO_N, '' AS TOTAL_CREDITO_A, '' AS TOTAL_BECA_A, '' AS TOTAL_DESCUENTO_A, '' AS TOTAL_CREDITO_N, '' AS TOTAL_BECA_N, '' AS TOTAL_DESCUENTO_N, '' AS TOTAL_MATR_CHEQUE_A, '' AS TOTAL_MATR_LETRA_A, '' AS TOTAL_COL_LETRA_A, '' AS TOTAL_COL_CHEQUE_A, '' AS TOTAL_MATR_CHEQUE_N, '' AS TOTAL_MATR_LETRA_N, '' AS TOTAL_COL_LETRA_N, '' AS TOTAL_COL_CHEQUE_N, '' AS TOTAL_MATR_EFECTIVO_A, '' AS TOTAL_COL_EFECTIVO_A, '' AS TOTAL_MATR_EFECTIVO_N, '' AS TOTAL_COL_EFECTIVO_N FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// flujoVencimientoData1
			// 
			this.flujoVencimientoData1.DataSetName = "FlujoVencimientoData";
			this.flujoVencimientoData1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.flujoVencimientoData1.Namespace = "http://www.tempuri.org/FlujoVencimientoData.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.flujoVencimientoData1)).EndInit();

		}
		#endregion
	}
}
