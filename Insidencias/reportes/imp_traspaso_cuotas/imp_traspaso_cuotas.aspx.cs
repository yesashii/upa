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

namespace imp_traspaso_cuotas
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalle;
		protected imp_traspaso_cuotas.DataSet1 ds;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection conexion;


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

		string generar_sql_detalles(string q_ccar_ncorr)
		{
			string sql;

			sql=  " select d .ting_tdesc, c.ding_ndocto, e.dcom_fcompromiso as ding_fdocto, e.dcom_mcompromiso as ding_mdocto, c.ingr_ncorr, ";
			sql=  sql + "			c.ting_ccod, d .ting_ccod as expr1, e.comp_ndocto, e.dcom_ncompromiso, e.inst_ccod, e.tcom_ccod ";
			sql=  sql + "	From  cambios_carrera a ";
			sql=  sql + "	join  cuotas_traspasadas b ";
			sql=  sql + "		on a.ccar_ncorr = b.ccar_ncorr ";
			sql=  sql + "	join  detalle_compromisos e ";
			sql=  sql + "		on b.tcom_ccod_destino = e.tcom_ccod ";
			sql=  sql + "		and b.inst_ccod_destino = e.inst_ccod ";
			sql=  sql + "		and b.comp_ndocto_destino = e.comp_ndocto ";
			sql=  sql + "		and b.dcom_ncompromiso_destino = e.dcom_ncompromiso ";
			sql=  sql + "	left outer join  detalle_ingresos c ";
			sql=  sql + "		on protic.documento_asociado_cuota(b.tcom_ccod_destino, b.inst_ccod_destino, b.comp_ndocto_destino, b.dcom_ncompromiso_destino, 'ingr_ncorr')   = c.ingr_ncorr  ";
			sql=  sql + "		and protic.documento_asociado_cuota(b.tcom_ccod_destino, b.inst_ccod_destino, b.comp_ndocto_destino, b.dcom_ncompromiso_destino, 'ting_ccod')   = c.ting_ccod   ";
			sql=  sql + "		and protic.documento_asociado_cuota(b.tcom_ccod_destino, b.inst_ccod_destino, b.comp_ndocto_destino, b.dcom_ncompromiso_destino, 'ding_ndocto') = c.ding_ndocto ";
			sql=  sql + "	left outer join  tipos_ingresos d";
			sql=  sql + "		on isnull(c.ting_ccod, 6) = d .ting_ccod";
			sql=  sql + "	Where a.ccar_ncorr = "+q_ccar_ncorr+" ";
			sql=  sql + "	order by e.tcom_ccod, e.dcom_fcompromiso ";
			
			//Response.Write(sql);
			//Response.Flush();

			return (sql);

		}

		string generar_sql_encabezado(string q_ccar_ncorr)
		{
			string sql;

			sql=   "  select a.ccar_ncorr, protic.obtener_nombre_carrera(c.ofer_ncorr,'ce') as carrera_origen, ";
			sql=  sql + " protic.obtener_nombre_carrera(isnull(f.ofer_ncorr, e.ofer_ncorr),'ce') as carrera_destino, ";
			sql=  sql + " protic.obtener_rut(c.pers_ncorr) as rut, protic.obtener_nombre_completo(c.pers_ncorr, 'pmn') as nombre,";
			sql=  sql + " a.ccar_fcambio, protic.obtener_nombre_completo(g.pers_ncorr, 'pmn') as nombre_apoderado, i.sede_tdesc, ";
			sql=  sql + " cast(datepart(day,a.ccar_fcambio) as varchar)+' de '+cast(ltrim(datepart(month,a.ccar_fcambio)) as varchar)+' de '+cast(datepart(year,a.ccar_fcambio) as varchar) as strfecha,";
			sql=  sql + " i.sede_ccod ";
			sql=  sql + " From  contratos b ";
			sql=  sql + " Join cambios_carrera a ";
			sql=  sql + "     on b.cont_ncorr = a.cont_ncorr_origen ";
			sql=  sql + " Join alumnos c ";
			sql=  sql + "     on b.matr_ncorr = c.matr_ncorr ";
			sql=  sql + " Join contratos d ";
			sql=  sql + "     on a.cont_ncorr_destino = d .cont_ncorr ";
			sql=  sql + " Join postulantes e ";
			sql=  sql + "     on d .post_ncorr = e.post_ncorr ";
			sql=  sql + " Join codeudor_postulacion g ";
			sql=  sql + "     on e.post_ncorr = g.post_ncorr ";
			sql=  sql + " Left outer Join alumnos f ";
			sql=  sql + "     on d .matr_ncorr = f.matr_ncorr ";
			sql=  sql + " Join ofertas_academicas h ";
			sql=  sql + "     on (isnull(f.ofer_ncorr, e.ofer_ncorr) = h.ofer_ncorr) ";
			sql=  sql + " Join sedes i ";
			sql=  sql + "     on i.sede_ccod = h.sede_ccod    ";
			sql=  sql + " where a.ccar_ncorr = "+q_ccar_ncorr+" ";

			return (sql);

		}
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string q_ccar_ncorr = Request.QueryString["ccar_ncorr"];
			crTraspasoCuotas rep = new crTraspasoCuotas();


			sql = generar_sql_detalles(q_ccar_ncorr);
			adpDetalle.SelectCommand.CommandText = sql;
			adpDetalle.Fill(ds);

			//adpDetalle.SelectCommand.Parameters["ccar_ncorr"].Value = q_ccar_ncorr;
			//adpDetalle.Fill(ds);


			sql = generar_sql_encabezado(q_ccar_ncorr);
			adpEncabezado.SelectCommand.CommandText = sql;
			adpEncabezado.Fill(ds);

			//adpEncabezado.SelectCommand.Parameters["ccar_ncorr"].Value = q_ccar_ncorr;
			//adpEncabezado.Fill(ds);

			rep.SetDataSource(ds);

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
			this.adpDetalle = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.ds = new imp_traspaso_cuotas.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalle
			// 
			this.adpDetalle.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalle.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								 new System.Data.Common.DataTableMapping("Table", "DETALLE", new System.Data.Common.DataColumnMapping[] {
																																																			new System.Data.Common.DataColumnMapping("TING_TDESC", "TING_TDESC"),
																																																			new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																			new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																			new System.Data.Common.DataColumnMapping("DING_MDOCTO", "DING_MDOCTO"),
																																																			new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																			new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																			new System.Data.Common.DataColumnMapping("EXPR1", "EXPR1")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT \'\' AS TING_TDESC, \'\' AS DING_NDOCTO, \'\' AS DING_FDOCTO, \'\' AS DING_MDOCTO," +
				" \'\' AS INGR_NCORR, \'\' AS TING_CCOD, \'\' AS EXPR1, \'\' AS COMP_NDOCTO, \'\' AS DCOM_N" +
				"COMPROMISO, \'\' AS INST_CCOD, \'\' AS TCOM_CCOD";
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
																																																				  new System.Data.Common.DataColumnMapping("CCAR_NCORR", "CCAR_NCORR"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA_ORIGEN", "CARRERA_ORIGEN"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA_DESTINO", "CARRERA_DESTINO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																				  new System.Data.Common.DataColumnMapping("CCAR_FCAMBIO", "CCAR_FCAMBIO"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																				  new System.Data.Common.DataColumnMapping("SEDE_TDESC", "SEDE_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("STRFECHA", "STRFECHA"),
																																																				  new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT \'\' AS CCAR_NCORR, \'\' AS CARRERA_ORIGEN, \'\' AS CARRERA_DESTINO, \'\' AS RUT, " +
				"\'\' AS NOMBRE, \'\' AS CCAR_FCAMBIO, \'\' AS NOMBRE_APODERADO, \'\' AS SEDE_TDESC, \'\' A" +
				"S STRFECHA, \'\' AS SEDE_CCOD";
			this.oleDbSelectCommand2.Connection = this.conexion;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
