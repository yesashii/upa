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

namespace procedencia
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected procedencia.DataSet1 dataSet11;
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
		private string generar_sql(string p_sede, string p_carrera, string p_ano)
		{
		  string sql="";

			sql =       " SELECT '" + p_ano + "' as ano, D.sede_tdesc, D.carr_tdesc, D.jorn_tdesc, D.colegio_egreso, D.ciud_tdesc, D.tcol_tdesc, ";
			sql = sql + "       count(D.pers_ncorr) as alumnos,  ";
			sql = sql + "		avg(decode(D.prom_psu, 0, '', D.prom_psu)) as PSU  ";
			sql = sql + " FROM (  ";
			sql = sql + "	    select a.pers_ncorr, f.carr_ccod, f.carr_tdesc, k.jorn_tdesc,  decode(a.PERS_TCOLE_EGRESO, '',  ";
			sql = sql + "		  	   g.COLE_TDESC, a.pers_tcole_egreso) as colegio_egreso, h.tcol_tdesc, i.CIUD_TDESC,  ";
			sql = sql + "		  	   j.sede_tdesc, ((nvl(b.post_npaa_verbal,0) + nvl(b.post_npaa_matematicas,0)) /2) as prom_psu  ";
			sql = sql + "		from personas a, postulantes b, alumnos c, ofertas_academicas d, especialidades e,  ";
			sql = sql + "			 carreras f, colegios g, tipos_colegios h, ciudades i, sedes j, jornadas k ";
			sql = sql + "		where a.pers_ncorr = b.pers_ncorr  ";
			sql = sql + "	  	  and b.post_ncorr = c.post_ncorr  ";
			sql = sql + "		  and c.emat_ccod = 1  ";
			sql = sql + "		  and c.ofer_ncorr = d.ofer_ncorr  ";
			sql = sql + "		  and d.jorn_ccod = k.jorn_ccod  ";
			sql = sql + "		  and d.espe_ccod = e.espe_ccod ";
			sql = sql + "		  and d.sede_ccod = j.sede_ccod  ";
			sql = sql + "		  and e.carr_ccod = f.carr_ccod	 ";	   
			sql = sql + "		  and a.cole_ccod = g.cole_ccod (+) "; 
			sql = sql + "		  and g.tcol_ccod = h.tcol_ccod (+)  ";
			sql = sql + "		  and g.ciud_ccod = i.ciud_ccod (+)	 ";	 
			
			if (p_sede != "")
				sql = sql + " and j.SEDE_CCOD = '" + p_sede + "' ";
			
			if (p_carrera != "")
				sql = sql + " and f.CARR_CCOD = '" + p_carrera + "' ";
			
			sql = sql + " 	    group by a.pers_ncorr, f.carr_ccod, a.cole_ccod, a.PERS_TCOLE_EGRESO, g.COLE_TDESC, j.sede_tdesc,  ";
			sql = sql + "			     h.tcol_tdesc, f.carr_tdesc, b.post_npaa_verbal , b.post_npaa_matematicas, i.CIUD_TDESC ,k.jorn_tdesc ";
			sql = sql + "	    having ano_ingreso_carrera(a.pers_ncorr, f.carr_ccod) ='" + p_ano + "'  ";
			sql = sql + " 	 ) D  ";
			sql = sql + "GROUP BY D.sede_tdesc, D.carr_ccod, D.carr_tdesc, D.jorn_tdesc, D.colegio_egreso, D.ciud_tdesc, D.tcol_tdesc  ";
			sql = sql + "ORDER BY D.sede_tdesc, D.carr_tdesc, D.jorn_tdesc, d.colegio_egreso, d.ciud_tdesc   ";

//------------------------------------------------------------------------------------
			sql="";

			sql =       " SELECT '" + p_ano + "' as ano, D.sede_tdesc, D.carr_tdesc, D.jorn_tdesc, D.colegio_egreso, D.ciud_tdesc, D.tcol_tdesc, ";
			sql = sql + "      count(D.pers_ncorr) as alumnos,  ";
            sql = sql + "         avg(case D.prom_psu when 0 then 0 else D.prom_psu end ) as PSU  ";
			sql = sql + " FROM ( select a.pers_ncorr, f.carr_ccod, f.carr_tdesc, k.jorn_tdesc,  ";
            sql = sql + "     case a.PERS_TCOLE_EGRESO when '' then g.COLE_TDESC else a.pers_tcole_egreso end as colegio_egreso, ";
            sql = sql + "     h.tcol_tdesc, i.CIUD_TDESC,j.sede_tdesc, ((isnull(b.post_npaa_verbal,0) + isnull(b.post_npaa_matematicas,0)) /2) as prom_psu  ";
            sql = sql + "     From personas a ";
            sql = sql + "     join postulantes b ";
            sql = sql + "         on a.pers_ncorr = b.pers_ncorr ";
            sql = sql + "     join alumnos c ";
            sql = sql + "         on  b.post_ncorr = c.post_ncorr ";
            sql = sql + "     join ofertas_academicas d ";
            sql = sql + "         on c.ofer_ncorr = d.ofer_ncorr ";
            sql = sql + "     join especialidades e ";
            sql = sql + "         on d.espe_ccod = e.espe_ccod ";
            sql = sql + "     join carreras f ";
            sql = sql + "         on e.carr_ccod = f.carr_ccod ";
            sql = sql + "     left outer join colegios g ";
            sql = sql + "         on a.cole_ccod = g.cole_ccod "; 
            sql = sql + "     left outer join tipos_colegios h ";
            sql = sql + "         on g.tcol_ccod = h.tcol_ccod ";
            sql = sql + "     left outer join ciudades i ";
            sql = sql + "         on g.ciud_ccod = i.ciud_ccod ";
            sql = sql + "     join sedes j ";
            sql = sql + "         on d.sede_ccod = j.sede_ccod ";
            sql = sql + "     join jornadas k ";
            sql = sql + "         on d.jorn_ccod = k.jorn_ccod ";
            sql = sql + "     where c.emat_ccod = 1 "; 

			if (p_sede != "")
            sql = sql + "         and j.SEDE_CCOD = '" + p_sede + "' ";

			if (p_carrera != "")
            sql = sql + "         and f.CARR_CCOD = '" + p_carrera + "' ";

            sql = sql + " group by a.pers_ncorr, f.carr_ccod, a.cole_ccod, a.PERS_TCOLE_EGRESO, g.COLE_TDESC, j.sede_tdesc,  ";
            sql = sql + " h.tcol_tdesc, f.carr_tdesc, b.post_npaa_verbal , b.post_npaa_matematicas, i.CIUD_TDESC ,k.jorn_tdesc ";
            sql = sql + " having protic.ano_ingreso_carrera(a.pers_ncorr, f.carr_ccod) ='" + p_ano + "'  ";
			sql = sql + "  	 ) D  ";
			sql = sql + " GROUP BY D.sede_tdesc, D.carr_ccod, D.carr_tdesc, D.jorn_tdesc, D.colegio_egreso, D.ciud_tdesc, D.tcol_tdesc  ";
			sql = sql + " ORDER BY D.sede_tdesc, D.carr_tdesc, D.jorn_tdesc, d.colegio_egreso, d.ciud_tdesc   ";
//Response.Write(sql);
//			Response.Flush();
		     return (sql);
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql = "", sede = "", carrera = "", ano = "", tipodoc = "";
			CrystalReport1 Reporte = new CrystalReport1();
			
			sede = Request.QueryString["sede_ccod"];
			carrera = Request.QueryString["carr_ccod"];
			ano = Request.QueryString["ano"];
			tipodoc = Request.QueryString["tipodoc"];
		    
			sql = generar_sql(sede,carrera,ano);
			//Response.Write(sql);
			//Response.End();
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
			Reporte.SetDataSource(dataSet11);
			CrystalReportViewer1.ReportSource = Reporte;
			
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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new procedencia.DataSet1();
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
																										new System.Data.Common.DataTableMapping("Table", "T_Datos", new System.Data.Common.DataColumnMapping[] {
																																																				   new System.Data.Common.DataColumnMapping("ANO", "ANO"),
																																																				   new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("JORN_TDESC", "JORN_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("COLEGIO_EGRESO", "COLEGIO_EGRESO"),
																																																				   new System.Data.Common.DataColumnMapping("CIUD_TDESC", "CIUD_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("TCOL_TDESC", "TCOL_TDESC"),
																																																				   new System.Data.Common.DataColumnMapping("ALUMNOS", "ALUMNOS"),
																																																				   new System.Data.Common.DataColumnMapping("PSU", "PSU")})});
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS ANO, \'\' AS SEDE_TDESC, \'\' AS CARR_TDESC, \'\' AS JORN_TDESC, \'\' AS COL" +
				"EGIO_EGRESO, \'\' AS CIUD_TDESC, \'\' AS TCOL_TDESC, \'\' AS ALUMNOS, \'\' AS PSU FROM D" +
				"UAL";
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

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		
	}
}
