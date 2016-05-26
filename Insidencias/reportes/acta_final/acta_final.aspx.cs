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

namespace acta_final
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpAlumnos;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected acta_final.DataSet1 ds;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbConnection conexion;


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
		private string  consulta_encabezado(string var_secc_ccod)
		{string sql;

			sql = " SELECT B.ASIG_TDESC, ISNULL(C.DUAS_TDESC, ' ') AS DUAS_TDESC, A.SECC_TDESC, case when d.carr_ccod= 220 then 'DIPLOMADO EN METO. Y GEST. DE PROYECTO DE INVESTIGACIÓN' else D.CARR_TDESC end as CARR_TDESC, E.ANOS_CCOD, E.PLEC_CCOD, ";
            sql = sql + " protic.retorna_profesor(CAST(A.SECC_CCOD AS varchar)) AS PROFESOR, protic.initcap(case protic.retorna_profesor(CAST(A.SECC_CCOD AS varchar)) when '' then 'ENCARGADO' when null then 'ENCARGADO' else protic.retorna_profesor(CAST(A.SECC_CCOD AS varchar)) end) ";
            sql = sql + " AS PROFESOR_MIN, Case ma.plan_ccod when 378 then 'Andrés Lillo Allain' else protic.initcap(case protic.obtener_nombre_completo(F.PERS_NCORR, 'n') when '' then 'ENCARGADO' when null then 'ENCARGADO' else protic.obtener_nombre_completo(F.PERS_NCORR, 'n') end) end AS DIRECTOR_CARRERA, CASE WHEN F.FIRMA_COMO IS NULL THEN 'Director de Escuela' ELSE F.FIRMA_COMO END AS FIRMA_COMO, A.SECC_CCOD, B.ASIG_CCOD, ";
            sql = sql + " CASE a.estado_cierre_ccod when 2 then 'ACTA FINAL' else 'ACTA FINAL (PROVISORIA)' end as CARR_CCOD, E.PERI_CCOD ";
			sql = sql + " FROM SECCIONES A INNER JOIN ";
            sql = sql + "      ASIGNATURAS B ON A.ASIG_CCOD = B.ASIG_CCOD INNER JOIN ";
            sql = sql + "      CARRERAS D ON A.CARR_CCOD = D.CARR_CCOD INNER JOIN ";
			sql = sql + "      PERIODOS_ACADEMICOS E ON A.PERI_CCOD = E.PERI_CCOD LEFT OUTER JOIN ";
            sql = sql + "      DURACION_ASIGNATURA C ON B.DUAS_CCOD = C.DUAS_CCOD LEFT OUTER JOIN ";
            sql = sql + "      CARGOS_CARRERA F ON A.CARR_CCOD = F.CARR_CCOD AND A.JORN_CCOD = F.JORN_CCOD AND A.SEDE_CCOD = F.SEDE_CCOD AND D.TCAR_CCOD = F.TCAR_CCOD ";
			sql = sql + "  join malla_curricular ma on a.asig_ccod = ma.asig_ccod and a.mall_ccod = ma.mall_ccod ";
		    sql = sql + " WHERE  cast(A.SECC_CCOD  as varchar)= '"+ var_secc_ccod + "'" ;
            
			//Response.Write(sql);
			//Response.Flush();
			return sql;
			

		}

		private string  consulta_alumnos(string var_secc_ccod)
		{
				string sql;

			/*sql = " SELECT protic.obtener_rut(C.PERS_NCORR) AS RUT, D.PERS_NRUT, D.PERS_TAPE_PATERNO, D.PERS_TAPE_MATERNO, D.PERS_TNOMBRE, ";
            sql = sql + " cast(CAST(B.CARG_NNOTA_PRESENTACION AS decimal(2, 1)) as varchar) AS CARG_NNOTA_PRESENTACION, ISNULL(CAST(CAST(B.CARG_NNOTA_EXAMEN AS decimal(2,"; 
            sql = sql + " 1))AS VARCHAR), B.EEXA_CCOD) AS CARG_NNOTA_EXAMEN, ISNULL(CAST(CAST(B.CARG_NNOTA_REPETICION AS decimal(2, 1)) AS varchar), B.EEXA_CCOD_REP)"; 
            sql = sql + " AS CARG_NNOTA_REPETICION, CAST(CAST(B.CARG_NNOTA_FINAL AS decimal(2, 1)) As VARCHAR) AS CARG_NNOTA_FINAL, D.PERS_NCORR ";
            sql = sql + " FROM SECCIONES A INNER JOIN ";
            sql = sql + " CARGAS_ACADEMICAS B ON A.SECC_CCOD = B.SECC_CCOD INNER JOIN ";
            sql = sql + " ALUMNOS C ON B.MATR_NCORR = C.MATR_NCORR INNER JOIN ";
			sql = sql + " PERSONAS D ON C.PERS_NCORR = D.PERS_NCORR ";
		    sql = sql + " WHERE  C.EMAT_CCOD = 1 AND cast(A.SECC_CCOD as varchar) = '" + var_secc_ccod + "'";
			sql = sql + " ORDER BY D.PERS_TAPE_PATERNO, D.PERS_TAPE_MATERNO, D.PERS_TNOMBRE" ;
            */
			sql = " SELECT protic.obtener_rut(C.PERS_NCORR) AS RUT, D.PERS_NRUT, D.PERS_TAPE_PATERNO + '   ' + D.PERS_TAPE_MATERNO as pers_tape_paterno, d.pers_tnombre as pers_tnombre, ";
			sql = sql + " replace(CAST(CAST(B.CARG_NNOTA_PRESENTACION AS decimal(2,1))AS VARCHAR),',','.')AS CARG_NNOTA_PRESENTACION,";
			sql = sql + " replace(CAST(CAST(B.CARG_NNOTA_EXAMEN AS decimal(2,1))AS VARCHAR),',','.') AS CARG_NNOTA_EXAMEN, B.SITF_CCOD,";
			sql = sql + " CARG_NASISTENCIA AS CARG_NNOTA_REPETICION,";
			sql = sql + " replace(CAST(CAST(B.CARG_NNOTA_FINAL AS decimal(2, 1)) As VARCHAR),',','.') AS CARG_NNOTA_FINAL, D.PERS_NCORR ";
			sql = sql + " FROM SECCIONES A ";
			sql = sql + " JOIN CARGAS_ACADEMICAS B ";
			sql = sql + "	ON A.SECC_CCOD = B.SECC_CCOD ";
			sql = sql + " JOIN ALUMNOS C ";
			sql = sql + "   ON B.MATR_NCORR = C.MATR_NCORR ";
			sql = sql + " JOIN PERSONAS D ";
			sql = sql + "	 ON C.PERS_NCORR = D.PERS_NCORR ";
			sql = sql + " JOIN ASIGNATURAS E ";
			sql = sql + "	 ON A.ASIG_CCOD = E.ASIG_CCOD ";
			sql = sql + " WHERE  cast(A.SECC_CCOD as varchar) = '" + var_secc_ccod + "'";
			sql = sql + " and  c.emat_ccod = case when (a.peri_ccod >= 202 and e.duas_ccod=3) or (a.peri_ccod > 202) then c.emat_ccod else 1 end ";
			sql = sql + " ORDER BY D.PERS_TAPE_PATERNO, D.PERS_TAPE_MATERNO, D.PERS_TNOMBRE";
            //Response.Write(sql);
			//Response.Flush();
			return sql;
		}


	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string q_secc_ccod = Request.QueryString["secc_ccod"];
			
			//q_secc_ccod="699";
			crActaFinal rep = new crActaFinal();
            
			
			//adpAlumnos.SelectCommand.Parameters["secc_ccod"].Value = q_secc_ccod;
			adpAlumnos.SelectCommand.CommandText = consulta_alumnos(q_secc_ccod);
			adpAlumnos.Fill(ds);

            //Response.End();
			//adpEncabezado.SelectCommand.Parameters["secc_ccod"].Value = q_secc_ccod;
			adpEncabezado.SelectCommand.CommandText = consulta_encabezado(q_secc_ccod);
			adpEncabezado.Fill(ds);

			rep.SetDataSource(ds);
			CrystalReportViewer1.ReportSource = rep;

			ExportarPDF(rep);

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
			this.adpAlumnos = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.ds = new acta_final.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpAlumnos
			// 
			this.adpAlumnos.SelectCommand = this.oleDbSelectCommand1;
			this.adpAlumnos.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								 new System.Data.Common.DataTableMapping("Table", "ALUMNOS", new System.Data.Common.DataColumnMapping[] {
																																																			new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																			new System.Data.Common.DataColumnMapping("PERS_NRUT", "PERS_NRUT"),
																																																			new System.Data.Common.DataColumnMapping("PERS_TAPE_PATERNO", "PERS_TAPE_PATERNO"),
																																																			new System.Data.Common.DataColumnMapping("PERS_TAPE_MATERNO", "PERS_TAPE_MATERNO"),
																																																			new System.Data.Common.DataColumnMapping("PERS_TNOMBRE", "PERS_TNOMBRE"),
																																																			new System.Data.Common.DataColumnMapping("CARG_NNOTA_PRESENTACION", "CARG_NNOTA_PRESENTACION"),
																																																			new System.Data.Common.DataColumnMapping("CARG_NNOTA_EXAMEN", "CARG_NNOTA_EXAMEN"),
																																																			new System.Data.Common.DataColumnMapping("CARG_NNOTA_REPETICION", "CARG_NNOTA_REPETICION"),
																																																			new System.Data.Common.DataColumnMapping("CARG_NNOTA_FINAL", "CARG_NNOTA_FINAL")})});
			this.adpAlumnos.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.adpAlumnos_RowUpdated);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS RUT, \'\' AS PERS_NRUT, \'\' AS PERS_TAPE_PATERNO, \'\' AS PERS_TAPE_MATER" +
				"NO, \'\' AS PERS_TNOMBRE, \'\' AS CARG_NNOTA_PRESENTACION, \'\' AS CARG_NNOTA_EXAMEN, " +
				"\'\' AS CARG_NNOTA_REPETICION, \'\' AS CARG_NNOTA_FINAL, \'\' AS PERS_NCORR, \'\' AS SIT" +
				"F_CCOD";
			this.oleDbSelectCommand1.Connection = this.conexion;
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.conexion.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.conexion_InfoMessage);
			// 
			// adpEncabezado
			// 
			this.adpEncabezado.SelectCommand = this.oleDbSelectCommand2;
			this.adpEncabezado.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "ENCABEZADO", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("ASIG_TDESC", "ASIG_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("DUAS_TDESC", "DUAS_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("SECC_TDESC", "SECC_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("ANOS_CCOD", "ANOS_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("PLEC_CCOD", "PLEC_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("PROFESOR", "PROFESOR"),
																																																				  new System.Data.Common.DataColumnMapping("PROFESOR_MIN", "PROFESOR_MIN"),
																																																				  new System.Data.Common.DataColumnMapping("DIRECTOR_CARRERA", "DIRECTOR_CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("SECC_CCOD", "SECC_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("ASIG_CCOD", "ASIG_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("PERI_CCOD", "PERI_CCOD")})});
			this.adpEncabezado.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.adpEncabezado_RowUpdated);
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS ASIG_TDESC, \'\' AS DUAS_TDESC, \'\' AS SECC_TDESC, \'\' AS CARR_TDESC, \'\'" +
				" AS ANOS_CCOD, \'\' AS PLEC_CCOD, \'\' AS PROFESOR, \'\' AS PROFESOR_MIN, \'\' AS DIRECT" +
				"OR_CARRERA, \'\' AS SECC_CCOD, \'\' AS ASIG_CCOD, \'\' AS CARR_CCOD, \'\' AS PERI_CCOD";
			this.oleDbSelectCommand2.Connection = this.conexion;
			// 
			// ds
			// 
			this.ds.DataSetName = "DataSet1";
			this.ds.Locale = new System.Globalization.CultureInfo("es-CL");
			this.ds.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion

		private void adpEncabezado_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void adpAlumnos_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void conexion_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
