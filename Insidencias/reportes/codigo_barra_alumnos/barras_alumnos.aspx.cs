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

namespace codigo_barra_alumnos
{
	/// <summary>
	/// Summary description for WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected codigo_barra_alumnos.DataSet1 dataSet11;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	

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

		private string EscribirCodigo(string tipo_alumno, string sede, string carr_ccod, string rut_alumno )
		{
			string sql;
		    
			sql=	" Select  distinct protic.obtener_rut(c.pers_ncorr) as rut_alumno, ";
			sql= sql +	"	protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre_alumno,";
			sql= sql +	"	protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,";
			sql= sql +	"	sede_tdesc as sede, '"+tipo_alumno+"' as tipo_alumno";
			sql= sql +	"		from ofertas_academicas a ";   
			sql= sql +	"			left outer join sedes b ";   
			sql= sql +	"				on a.sede_ccod =b.sede_ccod ";   
			sql= sql +	"			left outer join alumnos c ";   
			sql= sql +	"				on a.ofer_ncorr =c.ofer_ncorr ";   
			sql= sql +	"			join personas e "; 
			sql= sql +	"				on c.pers_ncorr=e.pers_ncorr";
			sql= sql +	"			right outer join especialidades d ";   
			sql= sql +	"				on a.espe_ccod = d.espe_ccod ";
			sql= sql +	"			where c.emat_ccod in (1,4,8,2,13) ";    
			sql= sql +	"			and protic.afecta_estadistica(c.matr_ncorr) > 0 ";   
			sql= sql +	"			and a.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod =datepart(year, getdate())) ";     
			sql= sql +	"			And c.pers_ncorr > 0 ";   
			
			if(tipo_alumno!=null)
			{
				sql= sql +  " and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) in('"+tipo_alumno+"')  ";
			}else{
				sql= sql +	" and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) in('S','N')  ";
			}

			if (sede!=null){
				sql= sql +	" and cast(a.sede_ccod as varchar) = '"+sede+"'";
			}
			if (carr_ccod!=null)
			{
				sql= sql +	" and cast(d.carr_ccod as varchar) = '"+carr_ccod+"'";
			}

			if(rut_alumno!=null)
			{
				sql= sql +  " AND e.pers_nrut = '"+rut_alumno+"' ";
			}

			sql= sql +	" order by carrera,nombre_alumno desc ";

//Response.Write(sql);
//Response.Flush();
			return (sql);	
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string pers_ncorr;
			string sede;
			string tipo_alumno;
			string carr_ccod;
			string rut_alumno;

			pers_ncorr = Request.Form["pers_ncorr"];
			carr_ccod = Request.Form["carr_ccod"];
			sede = Request.Form["sede_ccod"];
			tipo_alumno = Request.Form["tipo_alumno"];
			rut_alumno = Request.Form["rut_alumno"];

			oleDbDataAdapter1.SelectCommand.CommandTimeout=450;
			
				
				sql = EscribirCodigo(tipo_alumno,sede, carr_ccod,rut_alumno);

				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(dataSet11);
	
			
			codigo_barra_alumnos.barras_alumnos reporte = new codigo_barra_alumnos.barras_alumnos();
			reporte.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = reporte;
			ExportarPDF(reporte);
		
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			System.Configuration.AppSettingsReader configurationAppSettings = new System.Configuration.AppSettingsReader();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.dataSet11 = new codigo_barra_alumnos.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("rut_alumno", "rut_alumno"),
																																																				 new System.Data.Common.DataColumnMapping("nombre_alumno", "nombre_alumno"),
																																																				 new System.Data.Common.DataColumnMapping("carrera", "carrera"),
																																																				 new System.Data.Common.DataColumnMapping("sede", "sede")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS rut_alumno, \'\' AS nombre_alumno, \'\' AS carrera, \'\' AS sede, \'\' AS ti" +
				"po_alumno";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("en-US");
			this.dataSet11.Namespace = "http://tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion
	}
}
