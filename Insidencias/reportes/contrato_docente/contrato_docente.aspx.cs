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

namespace contrato_docente
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		//protected contrato_antiguo.datosContrato datosContrato1;
		//protected contrato_docente.contratodocente datosContrato1;
		protected CrystalDecisions.Web.CrystalReportViewer VerContrato;
		protected contrato_docente.Contrato_Docente14 contrato_Docente141;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
				
		private void ExportarPDF(ReportDocument rep) 
		{
			string ruta_exportacion;

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


		private string EscribirCodigo( string pers_ncorr, string cdoc_ncorr,string peri_ccod,int i, string nombre_informe, string Cerrar, string fechai, string fechaf, string fechaf1, string Porcentaje, string MontoMC)
		{
			string sql2;
		    
			// DATOS DEL CONTRATO OBTENIDOS A TRAVES DE UN PROCEDIMIENTO
			sql2="exec Contrato_Docente "+pers_ncorr+","+cdoc_ncorr+","+peri_ccod+",'"+Cerrar+"'"+",'"+fechai+"','"+fechaf+"','"+fechaf1+"','"+Porcentaje+"','"+MontoMC+"'";
			return (sql2);	
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			string sql;
			string pers_ncorr;
			string peri_ccod;
			string Cerrar;
			string Indefinido;
			string fini;
			string ffin;
			string ffin1;
			string Porcentaje;
			string MontoMC;
			pers_ncorr = Request.QueryString["pers_ncorr"];//"13207";
			peri_ccod = Request.QueryString["peri_ccod"];//"164";
			Cerrar=Request.QueryString["Cerrar"];//"false";
			fini=Request.QueryString["fechai"];//"15/03/2005";
			ffin=Request.QueryString["fechaf"];//"31/12/2005";
			ffin1=Request.QueryString["fechaf1"];//"31/12/2005";
			Indefinido=Request.QueryString["Indefinido"];//"31/12/2005";
			Porcentaje=Request.QueryString["Porcentaje"];
			MontoMC=Request.QueryString["MontoMC"];
			oleDbDataAdapter1.SelectCommand.CommandTimeout=450;
			//pers_ncorr = "23747";
			peri_ccod = "164";
			//post_ncorr = "11865";
		
			//string[] informe = new string[4] {"ORIGINAL","DUPLICADO","TRIPLICADO","CUADRIPLICADO"};
			string[] informe = new string[2] {"ORIGINAL","DUPLICADO"};			
			//CrystalReportContrato reporte = new CrystalReportContrato();
		
			for (int i=0; i<1; i++)
			{
				sql = EscribirCodigo(pers_ncorr, "0",peri_ccod,i, informe[i], Cerrar,fini,ffin, ffin1, Porcentaje, MontoMC);
				//Response.Write(sql+"<br>");
				//Response.Write(oleDbDataAdapter1.SelectCommand.Connection.State+"<br>");
				//Response.Write(oleDbDataAdapter1.SelectCommand.CommandText+"<br>");
				//Response.End();	
				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(contrato_Docente141);
				//oleDbDataAdapter1.Fill(datosContrato1);
				//Response.Write(informe[i]+"**<br>");				
			}		
			//reporte.SetDataSource(datosContrato1);			
			if (Indefinido == "false") {
				contrato_docente.Cryscontrato_docente reporte = new contrato_docente.Cryscontrato_docente();
				reporte.SetDataSource(contrato_Docente141);
				VerContrato.ReportSource = reporte;
				ExportarPDF(reporte);
			} else {
				contrato_docente.Cryscontrato_docenteindefinido  reporte2 = new contrato_docente.Cryscontrato_docenteindefinido();
				reporte2.SetDataSource(contrato_Docente141);
				VerContrato.ReportSource = reporte2;
				ExportarPDF(reporte2);
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
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.contrato_Docente141 = new contrato_docente.Contrato_Docente14();
			((System.ComponentModel.ISupportInitialize)(this.contrato_Docente141)).BeginInit();
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
			this.oleDbSelectCommand1.CommandText = @"SELECT 0 AS CDOC_NCORR, 0 AS pers_ncorr, '' AS Nombre_Docente, 0 AS Rut_Docente, '' AS Fecha_Nac, '' AS Estado_Civil, '' AS Direccion, '' AS Comuna, '' AS Ciudad, '' AS PROFESION, 0 AS BLOQ_ANEXO, 0 AS CARR_CCOD, '' AS CARR_TDESC, '' AS ASIG_CCOD, 0 AS ASIG_NHORAS, '' AS ASIG_TDESC, '' AS DUAS_TDESC, 0 AS BPRO_MVALOR, 0 AS Valor, '' AS INST_TRAZON_SOCIAL, '' AS MombreRepLeg, '' AS TipoDocente, '' AS Nacionalidad, '' AS FechaI, '' AS FechaF, 0 AS HOR_COORDINACION1, 0 AS HOR_COORDINACION2, '' AS DV, '' AS FechaF1, '' AS SECC_TDESC, '' AS PORCENTAJE, '' AS MONTOMC, '' AS sede_tdesc, '' AS num_cuotas, '' AS fecha_inicio, '' AS fecha_fin, '' AS tipo_profesor";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// contrato_Docente141
			// 
			this.contrato_Docente141.DataSetName = "Contrato_Docente14";
			this.contrato_Docente141.Locale = new System.Globalization.CultureInfo("es-CL");
			this.contrato_Docente141.Namespace = "http://www.tempuri.org/Contrato_Docente14.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.contrato_Docente141)).EndInit();

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
