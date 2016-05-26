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

namespace Libro_Venta
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter DataAdapter;
		protected Libro_Venta.DataSet_Contratos dataSet_Contratos1;
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

			Response.AddHeader ("Content-Disposition", "attachment;filename=Procedencia_Alumnos.xls");
			Response.ContentType = "application/vnd.ms-excel";
			Response.WriteFile(diskOpts.DiskFileName.ToString());
			Response.Flush();
			Response.Close();
			System.IO.File.Delete(diskOpts.DiskFileName.ToString());
						
		}

		private string Generar_SQL_Libro(string SEDE, string INICIO, string FIN)
		{
		  string sql = "";

            sql =    "SELECT  CONT_NCORR, cont_fcontrato, ingr_nfolio_referencia, ingr_fpago, jorn_ccod,  jorn_tdesc, sede_ccod, sede_tdesc,   carr_tdesc, espe_tdesc, rut_alumno, nombre_alumno, monto_matricula, monto_colegiatura, intereses, CREDITO, DESCUENTO, BECA, monto_matricula + monto_colegiatura + intereses - CREDITO - BECA - DESCUENTO as total FROM( \n"; 
	        sql = sql +  "SELECT distinct a.CONT_NCORR, trunc(a.CONT_FCONTRATO) as cont_fcontrato, a2.jorn_ccod, i.jorn_tdesc, \n";
	        sql = sql +  "	   j.pers_nrut || '-' || j.pers_xdv as rut_alumno, j.pers_tape_paterno || ' ' || j.pers_tape_materno || ' ' ||  substr(j.pers_tnombre,1,7) as nombre_alumno,  \n";
	        sql = sql +  "	   e.ingr_nfolio_referencia, trunc(e.INGR_FPAGO) as ingr_fpago,  h.carr_tdesc, g.espe_tdesc,   \n";
			sql = sql +  "	   b.comp_mdocumento as monto_matricula, R.arancel as monto_colegiatura, R.intereses, a2.sede_ccod, f.sede_tdesc,  \n";
			sql = sql +  "	   (SELECT nvl(sum(nvl(-y.DETA_MVALOR_DETALLE,0)),0) as Credito \n";
			sql = sql +  "		FROM compromisos x, detalles y, stipos_descuentos z , beneficios t  \n";
			sql = sql +  "		WHERE x.comp_ndocto = y.COMP_NDOCTO  \n";
			sql = sql +  "		  and x.ecom_ccod = 1  \n";
			sql = sql +  "		  and t.eben_ccod = 1  \n";
			sql = sql +  "		  and x.tcom_ccod = y.tcom_ccod  \n";
			sql = sql +  "		  and x.inst_ccod = y.inst_ccod  \n";
			sql = sql +  "		  and x.tcom_ccod in (1,2)  \n";
			sql = sql +  "		  and y.tdet_ccod  = z.STDE_CCOD \n";		
			sql = sql +  "		  and x.COMP_NDOCTO = t.CONT_NCORR  \n";
			sql = sql +  "		  and z.STDE_CCOD = t.stde_ccod  \n";
			sql = sql +  "		  and z.tben_ccod = 1 \n";
			sql = sql +  "		  and x.comp_ndocto = b.comp_ndocto) as CREDITO, \n";
			sql = sql +  "			 (SELECT nvl(sum(nvl(-y.DETA_MVALOR_DETALLE,0)),0) as Beca \n";
			sql = sql +  "			  FROM compromisos x, detalles y, stipos_descuentos z , beneficios t  \n";
			sql = sql +  "			  WHERE x.comp_ndocto = y.COMP_NDOCTO  \n";
			sql = sql +  "				and x.ecom_ccod = 1  \n";
			sql = sql +  "				and t.eben_ccod = 1  \n";
			sql = sql +  "				and x.tcom_ccod = y.tcom_ccod  \n";
			sql = sql +  "				and x.inst_ccod = y.inst_ccod  \n";
			sql = sql +  "				and x.tcom_ccod in (1,2)  \n";
			sql = sql +  "				and y.tdet_ccod  = z.STDE_CCOD \n";			 
			sql = sql +  "				and x.COMP_NDOCTO = t.CONT_NCORR  \n";
			sql = sql +  "				and z.STDE_CCOD = t.stde_ccod  \n";
			sql = sql +  "				and z.tben_ccod = 2 \n";
			sql = sql +  "				and x.comp_ndocto = b.comp_ndocto) as BECA, \n";
			sql = sql +  "			(SELECT nvl(sum(nvl(-y.DETA_MVALOR_DETALLE,0)),0) as Descuento \n";
			sql = sql +  "			 FROM compromisos x, detalles y, stipos_descuentos z , beneficios t  \n";
			sql = sql +  "			 WHERE x.comp_ndocto = y.COMP_NDOCTO  \n";
			sql = sql +  "			   and x.ecom_ccod = 1  \n";
			sql = sql +  "			   and t.eben_ccod = 1  \n";
			sql = sql +  "			   and x.tcom_ccod = y.tcom_ccod  \n";
			sql = sql +  "			   and x.inst_ccod = y.inst_ccod  \n";
			sql = sql +  "			   and x.tcom_ccod in (1,2)  \n";
			sql = sql +  "			   and y.tdet_ccod  = z.STDE_CCOD  \n";
			sql = sql +  "			   and x.COMP_NDOCTO = t.CONT_NCORR  \n";
			sql = sql +  "			   and z.STDE_CCOD = t.stde_ccod  \n";
			sql = sql +  "			   and z.tben_ccod = 3 \n";
			sql = sql +  "			   and x.comp_ndocto = b.comp_ndocto) as DESCUENTO  \n";
			sql = sql +  "FROM contratos a, alumnos al, ofertas_academicas a2, compromisos b, detalle_compromisos c,  \n";
			sql = sql +  "	 abonos d, ingresos e, sedes f, especialidades g, carreras h, jornadas i, personas j, \n";
			sql = sql +  "                           (select b.comp_ndocto, b.comp_mneto as arancel, b.comp_mintereses as intereses  \n";
			sql = sql +  "							from compromisos b  \n";
			sql = sql +  "							where b.ecom_ccod = 1  \n";
			sql = sql +  "							  and b.tcom_ccod = 2) R		    \n";
			sql = sql +  "WHERE b.ecom_ccod = 1  \n";
			sql = sql +  "  and b.tcom_ccod = 1  \n";
			sql = sql +  "  and c.dcom_ncompromiso = 1  \n";
			sql = sql +  "  and al.EMAT_CCOD = 1  \n";
			sql = sql +  "  and a.MATR_NCORR = al.MATR_NCORR   \n";
			sql = sql +  "  and al.ofer_ncorr = a2.ofer_ncorr  \n";
			sql = sql +  "  and a.cont_ncorr = b.comp_ndocto  \n";
			sql = sql +  "  and b.tcom_ccod = c.tcom_ccod  \n";
			sql = sql +  "  and b.inst_ccod = c.inst_ccod  \n";
			sql = sql +  "  and b.comp_ndocto = c.comp_ndocto   \n";
			sql = sql +  "  and c.tcom_ccod = d.tcom_ccod  \n";
			sql = sql +  "  and c.inst_ccod = d.inst_ccod  \n";
			sql = sql +  "  and c.comp_ndocto = d.comp_ndocto  \n";
			sql = sql +  "  and c.dcom_ncompromiso = d.dcom_ncompromiso  \n";
			sql = sql +  "  and d.ingr_ncorr = e.ingr_ncorr  \n";
			sql = sql +  "  and b.comp_ndocto = R.comp_ndocto    \n";
			sql = sql +  "  and a2.sede_ccod = f.sede_ccod    \n";
			sql = sql +  "  and a2.espe_ccod = g.espe_ccod   \n";
            sql = sql +  "  and g.carr_ccod = h.carr_ccod   \n";
			sql = sql +  "  and a2.jorn_ccod = i.jorn_ccod \n";
			sql = sql +  "  and b.pers_ncorr = j.pers_ncorr \n";
			sql = sql +  "  and e.ting_ccod = 7  \n";
	 
		 
		 if ((INICIO  != "")  ||  (FIN != ""))  
		 	sql = sql + "and trunc(a.cont_fcontrato)  BETWEEN nvl(to_date('" + INICIO + "', 'dd/mm/yyyy'), a.cont_fcontrato) AND  nvl(to_date('" + FIN + "', 'dd/mm/yyyy'), a.cont_fcontrato) \n";
		 
		 if (SEDE == "")
			 sql = sql + " ";
         else
		     sql = sql + " and a2.sede_ccod = nvl('" + SEDE + "', a2.sede_ccod) \n";
		
		 
		 sql = sql + " )  \n";			

		  return (sql);
		
		}



		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", sede = "", inicio = "", fin = "";
			CrystalReport1 Libro = new CrystalReport1();

			sede = Request.QueryString["sede"];
			inicio = Request.QueryString["inicio"];
			fin = Request.QueryString["fin"];

			sql = Generar_SQL_Libro(sede, inicio, fin);
			
			//Response.Write("<PRE>" + sql + "</PRE>");
			//Response.End();
			
			DataAdapter.SelectCommand.CommandText = sql;
            
			DataAdapter.Fill(dataSet_Contratos1);
			Libro.SetDataSource(dataSet_Contratos1);
			VisorCrystalReport.ReportSource = Libro;
			//if (formato == "1")
			ExportarPDF(Libro);		
			//else
			//  ExportarEXCEL(Reporte);


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
			this.DataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.dataSet_Contratos1 = new Libro_Venta.DataSet_Contratos();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.dataSet_Contratos1)).BeginInit();
			// 
			// DbConnection
			// 
			this.DbConnection.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// DataAdapter
			// 
			this.DataAdapter.SelectCommand = this.oleDbSelectCommand1;
			this.DataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "T_Contratos", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CONT_NCORR", "CONT_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("CONT_FCONTRATO", "CONT_FCONTRATO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_NFOLIO_REFERENCIA", "INGR_NFOLIO_REFERENCIA"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO"),
																																																				 new System.Data.Common.DataColumnMapping("MONTO_MATRICULA", "MONTO_MATRICULA"),
																																																				 new System.Data.Common.DataColumnMapping("MONTO_COLEGIATURA", "MONTO_COLEGIATURA"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL", "TOTAL"),
																																																				 new System.Data.Common.DataColumnMapping("JORN_CCOD", "JORN_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("JORN_TDESC", "JORN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CREDITO", "CREDITO"),
																																																				 new System.Data.Common.DataColumnMapping("BECA", "BECA"),
																																																				 new System.Data.Common.DataColumnMapping("DESCUENTO", "DESCUENTO"),
																																																				 new System.Data.Common.DataColumnMapping("INTERESES", "INTERESES"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC")})});
			// 
			// dataSet_Contratos1
			// 
			this.dataSet_Contratos1.DataSetName = "DataSet_Contratos";
			this.dataSet_Contratos1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet_Contratos1.Namespace = "http://www.tempuri.org/DataSet_Contratos.xsd";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS SEDE_CCOD, '' AS CARR_TDESC, '' AS ESPE_TDESC, '' AS CONT_NCORR, '' AS CONT_FCONTRATO, '' AS RUT_ALUMNO, '' AS NOMBRE_ALUMNO, '' AS INGR_NFOLIO_REFERENCIA, '' AS INGR_FPAGO, '' AS MONTO_MATRICULA, '' AS MONTO_COLEGIATURA, '' AS TOTAL, '' AS JORN_CCOD, '' AS JORN_TDESC, '' AS CREDITO, '' AS BECA, '' AS DESCUENTO, '' AS INTERESES, '' AS SEDE_TDESC FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.DbConnection;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet_Contratos1)).EndInit();

		}
		#endregion
	}
}
