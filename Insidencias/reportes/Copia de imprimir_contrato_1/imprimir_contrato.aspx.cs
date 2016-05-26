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

namespace imprimir_contrato_1
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected imprimir_contrato_1.datosContrato datosContrato1;
		protected CrystalDecisions.Web.CrystalReportViewer VerContrato;
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
			string sql2;

			// DATOS DEL CONTRATO OBTENIDOS A TRAVES DE UN PROCEDIMIENTO
			sql2="exec detalle_forma_pago "+post_ncorr+","+i+","+nombre_informe;
			return (sql2);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string post_ncorr;
			string post_nuevo;
			post_ncorr = Request.QueryString["post_ncorr"];
			post_nuevo = Request.QueryString["post_nuevo"];
			
			//post_ncorr = "11406";
			//post_ncorr = "51364";
			//post_ncorr = "56914";
			//post_nuevo="P";
			
			//string[] informe = new string[4] {"ORIGINAL","DUPLICADO","TRIPLICADO","CUADRIPLICADO"};
			//string[] informe = new string[2] {"ORIGINAL","DUPLICADO"};
			string[] informe = new string[1] {"ORIGINAL"};

			CrystalReportContrato reporte = new CrystalReportContrato();
			CrystalReportContratoAntiguo reporteAntiguo = new CrystalReportContratoAntiguo();
			ReporteContadoresAntiguo reporteContadorAntiguo = new ReporteContadoresAntiguo();
			ReporteContadoresNuevo reporteContadorNuevo = new ReporteContadoresNuevo();
			ReporteMagister Magister = new ReporteMagister();
			ReportePostgradoMagister reportePostgradoMagister = new ReportePostgradoMagister();
			ReportePostgradov2 reportev2 = new ReportePostgradov2();
			ReporteLaAraucana reporteAraucana = new ReporteLaAraucana();
			ReporteLaAraucanaConce reporteAraucanaConce = new ReporteLaAraucanaConce();
			ReporteLaAraucana2014 reporteAraucana2014 = new ReporteLaAraucana2014(); // Las Condes (LAL2014)
			ReporteLaAraucanaConce2014 reporteAraucanaConce2014 = new ReporteLaAraucanaConce2014(); // Concepcion LAC2014)			
			ReportePostgrado2014 reportePostgrado2014 = new ReportePostgrado2014();
			ReporteLaAraucana2015 reporteAraucana2015 = new ReporteLaAraucana2015(); // Concepcion LAC2015)

			for (int i=0; i<1; i++)
			{
				sql = EscribirCodigo(post_ncorr, i, informe[i]);
				oleDbDataAdapter1.SelectCommand.CommandTimeout=9000;			
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(datosContrato1);
			}		

				switch (post_nuevo)
				{
					case "N":
						reporteAntiguo.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAntiguo;
						ExportarPDF(reporteAntiguo);
						break;
					case "S":
						reporte.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporte;
						ExportarPDF(reporte);
						break;
					case "CN":
						reporteContadorNuevo.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteContadorNuevo;
						ExportarPDF(reporteContadorNuevo);
						break;
					case "CA": //contratos contador autditor
						reporteContadorAntiguo.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteContadorAntiguo;
						ExportarPDF(reporteContadorAntiguo);
						break;
					case "P": //contratos magister 
						Magister.SetDataSource(datosContrato1);
						VerContrato.ReportSource = Magister;
						ExportarPDF(Magister);
						break;
					case "PM": //contratos postgrado y magister 
						reportePostgradoMagister.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reportePostgradoMagister;
						ExportarPDF(reportePostgradoMagister);
						break;
					case "PV2": //postgrado version dos
						reportev2.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reportev2;
						ExportarPDF(reportev2);
						break;
					case "LA": // la araucana las condes
						reporteAraucana.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAraucana;
						ExportarPDF(reporteAraucana);
						break;
					case "LAC": // la araucana de concepcion
						reporteAraucanaConce.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAraucanaConce;
						ExportarPDF(reporteAraucanaConce);
						break;
					case "LAL2014": // la araucana 2014 - Las Condes-
						reporteAraucana2014.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAraucana2014;
						ExportarPDF(reporteAraucana2014);
						break;
					case "LAC2014": // la araucana 2014 - Concepcion -
						reporteAraucanaConce2014.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAraucanaConce2014;
						ExportarPDF(reporteAraucanaConce2014);
						break;
					case "PG2014": // Postgrado 2014
						reportePostgrado2014.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reportePostgrado2014;
						ExportarPDF(reportePostgrado2014);
						break;
					case "LAC2015": // la araucana 2015 - Concepcion -
						reporteAraucana2015.SetDataSource(datosContrato1);
						VerContrato.ReportSource = reporteAraucana2015;
						ExportarPDF(reporteAraucana2015);
						break;
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
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.datosContrato1 = new imprimir_contrato_1.datosContrato();
			((System.ComponentModel.ISupportInitialize)(this.datosContrato1)).BeginInit();
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
																																																					new System.Data.Common.DataColumnMapping("TOTAL_A", "TOTAL_A"),
																																																					new System.Data.Common.DataColumnMapping("DIRECCION_ALUMNO", "DIRECCION_ALUMNO"),
																																																					new System.Data.Common.DataColumnMapping("COMUNA_ALUMNO", "COMUNA_ALUMNO"),
																																																					new System.Data.Common.DataColumnMapping("texto", "texto"),
																																																					new System.Data.Common.DataColumnMapping("CIUDAD_ALUMNO", "CIUDAD_ALUMNO")})});
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated_1);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS text_antiguo, '' AS jorn_tdesc, '' AS emailp, '' AS eciv_tdescp, '' AS pais_tdescp, ' ' AS pers_tprofesionp, '' AS emailppc, '' AS eciv_tdescppc, '' AS pais_tdescppc, '' AS pers_tprofesionppc, 0 AS nro_informe, '' AS NOMBRE_INFORME, '' AS NRO_CONTRATO, '' AS DD_HOY, '' AS MM_HOY, '' AS YY_HOY, '' AS NOMBRE_INSTITUCION, '' AS PERIODO_ACADEMICO, '' AS RUT_INSTITUCION, '' AS NOMBRE_REPRESENTANTE, '' AS RUT_POSTULANTE, '' AS EDAD, '' AS NOMBRE_ALUMNO, '' AS CARRERA, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS PROFESION, '' AS DIRECCION, '' AS DIRECCION_ALUMNO, '' AS CIUDAD, '' AS COMUNA, '' AS CIUDAD_ALUMNO, '' AS COMUNA_ALUMNO, '' AS TIPO_DOCUMENTO, '' AS DOCUMENTO, '' AS NOMBRE_BANCO, '' AS VALOR_DOCTO, '' AS NRO_DOCTO, '' AS FECHA_VENCIMIENTO, '' AS TOTAL_M, '' AS TOTAL_A, '' AS matricula, '' AS arancel, '' AS sede, '' AS comuna_sede,'' AS texto";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			//
			//  CONECTIOS STRING DE DESARROLLO
			//this.oleDbConnection1.ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=protic_desa;pwd=fglio9085;Initial Catalog=sigaupa_desa;Data Source=172.16.11.111;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=MRIFFOI;Use Encryption for Data=False;Tag with column collation when possible=False";
			//  CONECTIOS STRING DE Prueba ADMISION2016
			//this.oleDbConnection1.ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=protic;pwd=proticprueba;Initial Catalog=sigaupa_prueba;Data Source=10.10.10.77;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=MRIFFOI;Use Encryption for Data=False;Tag with column collation when possible=False";
			//  CONECTIOS STRING DE PRODUCCION
			this.oleDbConnection1.ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=protic;pwd=pu7685bt,yet;Initial Catalog=sigaupa;Data Source=172.16.254.2;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=MRIFFOI;Use Encryption for Data=False;Tag with column collation when possible=False";
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
			// 
			// datosContrato1
			// 
			this.datosContrato1.DataSetName = "datosContrato";
			this.datosContrato1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datosContrato1.Namespace = "http://www.tempuri.org/datosContrato.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosContrato1)).EndInit();

		}
		#endregion

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void oleDbDataAdapter1_RowUpdated_1(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
