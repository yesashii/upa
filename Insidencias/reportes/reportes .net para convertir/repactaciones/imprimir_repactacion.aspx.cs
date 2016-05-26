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

namespace repactaciones
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbConnection conexion;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected CrystalDecisions.Web.CrystalReportViewer visor;
		protected System.Data.OleDb.OleDbDataAdapter adpDetalles;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected repactaciones.DataSet1 ds;


		private void ExportarPDF(ReportDocument rep) 
		{
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


	


		private string ObtenerSql(string p_repa_ncorr)
		{
			string SQL;

			SQL = " SELECT 1 AS ORDEN, 'Se cambian documentos :' AS ENCABEZADO, A.TING_CCOD, A.INGR_NCORR,\n";
			SQL = SQL +  " CASE A.TING_CCOD WHEN 52 THEN PROTIC.OBTENER_NUMERO_PAGARE_PAGADO(B.INGR_NCORR) ELSE A.DING_NDOCTO END AS DING_NDOCTO, \n";
			SQL = SQL +  " D.BANC_TDESC, A.DING_FDOCTO, D.BANC_CCOD, CASE A.TING_CCOD WHEN 52 THEN 'PAG. TRANS.' else G.TING_TDESC end + ' ' + H.EDIN_TDESC AS TING_TDESC, A.DING_MDETALLE AS MONTO1, 0 as MONTO2, E.ABON_MABONO AS MONTO3 \n";
			SQL = SQL +  " FROM DETALLE_INGRESOS A, INGRESOS B, ABONOS C, TIPOS_INGRESOS G, ABONOS E, INGRESOS F, BANCOS D, ESTADOS_DETALLE_INGRESOS H \n";
			SQL = SQL +  " WHERE A.INGR_NCORR = B.INGR_NCORR \n"; 
			SQL = SQL +  "   AND (cast(A.REPA_NCORR as varchar)= '" + p_repa_ncorr + "') \n";
			SQL = SQL +  "   AND B.INGR_NCORR = C.INGR_NCORR \n";
			SQL = SQL +  "   AND A.TING_CCOD = G.TING_CCOD \n"; 
			SQL = SQL +  "   AND C.TCOM_CCOD = E.TCOM_CCOD \n"; 
			SQL = SQL +  "   AND C.INST_CCOD = E.INST_CCOD \n"; 
			SQL = SQL +  "   AND C.COMP_NDOCTO = E.COMP_NDOCTO \n";
			SQL = SQL +  "   AND C.DCOM_NCOMPROMISO = E.DCOM_NCOMPROMISO \n"; 
			SQL = SQL +  "   AND E.INGR_NCORR = F.INGR_NCORR \n"; 
			SQL = SQL +  "   AND A.REPA_NCORR = F.INGR_NFOLIO_REFERENCIA \n";
			SQL = SQL +  "   AND A.BANC_CCOD *= D.BANC_CCOD \n";  
			SQL = SQL +  "   AND A.EDIN_CCOD *= H.EDIN_CCOD \n";  
			SQL = SQL +  "   AND (B.EING_CCOD <> 3) \n";   
			SQL = SQL +  "   AND (F.TING_CCOD = 9) \n";
			SQL = SQL +  "   AND (F.EING_CCOD = 5) \n"; 
			SQL = SQL +  "   AND (isnull(F.INGR_MTOTAL, 0) > 0)\n"; 
			SQL = SQL +  " UNION \n";
			SQL = SQL +  " SELECT 2 AS ORDEN, 'Nuevos documentos :' AS ENCABEZADO, F.TING_CCOD, F.INGR_NCORR, \n";
			SQL = SQL +  " CASE F.TING_CCOD WHEN 52 THEN F.DING_NDOCTO ELSE F.DING_NDOCTO END AS DING_NDOCTO, \n";
			SQL = SQL +  " G.BANC_TDESC, F.DING_FDOCTO, G.BANC_CCOD, CASE F.TING_CCOD WHEN 52 THEN 'PAG. TRANS.' else H.TING_TDESC end as TING_TDESC, C.DCOM_MNETO AS MONTO1, C.DCOM_MINTERESES AS MONTO2, F.DING_MDETALLE AS MONTO3 \n";
			SQL = SQL +  " FROM REPACTACIONES A, COMPROMISOS B, DETALLE_COMPROMISOS C, ABONOS D, INGRESOS E, DETALLE_INGRESOS F, TIPOS_INGRESOS H, BANCOS G \n"; 
			SQL = SQL +  " WHERE A.REPA_NCORR = B.COMP_NDOCTO \n";
			SQL = SQL +  "   AND B.TCOM_CCOD = C.TCOM_CCOD \n"; 
			SQL = SQL +  "   AND B.INST_CCOD = C.INST_CCOD \n"; 
			SQL = SQL +  "   AND B.COMP_NDOCTO = C.COMP_NDOCTO \n";
			SQL = SQL +  "   AND C.TCOM_CCOD = D.TCOM_CCOD \n"; 
			SQL = SQL +  "   AND C.INST_CCOD = D.INST_CCOD \n"; 
			SQL = SQL +  "   AND C.COMP_NDOCTO = D.COMP_NDOCTO \n"; 
			SQL = SQL +  "   AND C.DCOM_NCOMPROMISO = D.DCOM_NCOMPROMISO \n"; 
			SQL = SQL +  "   AND D.INGR_NCORR = E.INGR_NCORR \n"; 
			SQL = SQL +  "   AND A.REPA_NCORR = E.INGR_NFOLIO_REFERENCIA \n"; 
			SQL = SQL +  "   AND E.INGR_NCORR = F.INGR_NCORR \n"; 
			SQL = SQL +  "   AND F.TING_CCOD = H.TING_CCOD \n"; 
			SQL = SQL +  "   AND F.BANC_CCOD *= G.BANC_CCOD \n";  
			SQL = SQL +  "   AND (B.TCOM_CCOD = 3) \n"; 
			SQL = SQL +  "   AND (E.EING_CCOD = 4) \n";  
			SQL = SQL +  "   AND (E.TING_CCOD = 15) \n";
			SQL = SQL +  "   AND (cast(A.REPA_NCORR as varchar)= '" + p_repa_ncorr + "') \n";
			SQL = SQL +  " ORDER BY ORDEN ASC, A.TING_CCOD ASC, A.DING_FDOCTO ASC \n";

			return SQL;
		}

		private string ObtenerSqlEncabezado(string p_repa_ncorr)
		{
			string SQL;

			SQL = " SELECT  protic.obtener_nombre_completo(B.PERS_NCORR, 'n') AS NOMBRE_COMPLETO, \n";
			SQL = SQL +  "	protic.obtener_rut(B.PERS_NCORR) AS RUT, A.REPA_NCORR, \n";
            SQL = SQL +  "          A.REPA_FREPACTACION, C.MREP_TDESC,\n";
            SQL = SQL +  "              (SELECT     TOP 1 ingr_ncorrelativo_caja \n";
            SQL = SQL +  "                FROM          ingresos \n";
            SQL = SQL +  "                WHERE      ingr_nfolio_referencia = " + p_repa_ncorr + " \n";
            SQL = SQL +  "                GROUP BY ingr_ncorrelativo_caja) AS correlativo \n";
			SQL = SQL +  "  FROM REPACTACIONES A \n";
			SQL = SQL +  "		INNER JOIN  COMPROMISOS B \n";
			SQL = SQL +  "			ON A.REPA_NCORR = B.COMP_NDOCTO \n";
			SQL = SQL +  "		INNER JOIN MOTIVOS_REPACTACION C \n";
			SQL = SQL +  "			ON A.MREP_CCOD = C.MREP_CCOD\n";
			SQL = SQL +  "  WHERE     A.REPA_NCORR = " + p_repa_ncorr + " \n";
			SQL = SQL +  "	AND B.TCOM_CCOD = 3 \n";
		
			return SQL;
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			crRepactaciones2 rep = new crRepactaciones2();
			string q_repa_ncorr;

			q_repa_ncorr = Request.QueryString["repa_ncorr"];
			//q_repa_ncorr="53213";

			//adpEncabezado.SelectCommand.Parameters["repa_ncorr"].Value = q_repa_ncorr;
			adpEncabezado.SelectCommand.CommandText = ObtenerSqlEncabezado(q_repa_ncorr);
			adpDetalles.SelectCommand.CommandText = ObtenerSql(q_repa_ncorr);
			

			adpEncabezado.Fill(ds);
			//adpDocumentosOrigen.Fill(ds);
			//adpDocumentosDestino.Fill(ds);
			adpDetalles.Fill(ds);

			rep.SetDataSource(ds);

			visor.ReportSource = rep;

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
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			this.ds = new repactaciones.DataSet1();
			this.adpDetalles = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// adpEncabezado
			// 
			this.adpEncabezado.SelectCommand = this.oleDbSelectCommand3;
			this.adpEncabezado.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "ENCABEZADO", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_COMPLETO", "NOMBRE_COMPLETO"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("REPA_NCORR", "REPA_NCORR"),
																																																				  new System.Data.Common.DataColumnMapping("REPA_FREPACTACION", "REPA_FREPACTACION")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT \'\' AS NOMBRE_COMPLETO, \'\' AS RUT, \'\' AS REPA_NCORR, \'\' AS REPA_FREPACTACIO" +
				"N, \'\' AS MREP_TDESC, \'\' AS correlativo";
			this.oleDbSelectCommand3.Connection = this.conexion;
			// 
			// ds
			// 
			this.ds.DataSetName = "dataSet1";
			this.ds.Locale = new System.Globalization.CultureInfo("es-ES");
			this.ds.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// adpDetalles
			// 
			this.adpDetalles.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalles.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								  new System.Data.Common.DataTableMapping("Table", "DETALLES", new System.Data.Common.DataColumnMapping[] {
																																																			  new System.Data.Common.DataColumnMapping("ORDEN", "ORDEN"),
																																																			  new System.Data.Common.DataColumnMapping("ENCABEZADO", "ENCABEZADO"),
																																																			  new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																			  new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																			  new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																			  new System.Data.Common.DataColumnMapping("BANC_TDESC", "BANC_TDESC"),
																																																			  new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																			  new System.Data.Common.DataColumnMapping("BANC_CCOD", "BANC_CCOD"),
																																																			  new System.Data.Common.DataColumnMapping("TING_TDESC", "TING_TDESC"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO1", "MONTO1"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO2", "MONTO2"),
																																																			  new System.Data.Common.DataColumnMapping("MONTO3", "MONTO3")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT 0 AS ORDEN, \'\' AS ENCABEZADO, 0 AS TING_CCOD, 0 AS INGR_NCORR, 0 AS DING_N" +
				"DOCTO, \'\' AS BANC_TDESC, GETDATE() AS DING_FDOCTO, 0 AS BANC_CCOD, \'\' AS TING_TD" +
				"ESC, 0 AS MONTO1, 0 AS MONTO2, 0 AS MONTO3";
			this.oleDbSelectCommand1.Connection = this.conexion;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
