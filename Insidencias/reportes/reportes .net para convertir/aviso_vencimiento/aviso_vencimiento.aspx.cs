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

namespace aviso_vencimiento
{
	/// <summary>
	/// Summary description for WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected aviso_vencimiento.DataSet1 dataSet11;
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
		private string EscribirCodigo(string sede, string fecha_inicio, string fecha_fin,string estado,string num_letra,string rut_alumno,string rut_apoderado )
		{
			string sql;
		    
			sql=		" Select  a.ding_ndocto as numero_letra,convert(varchar,a.ding_fdocto,103) as vencimiento, cast(a.ding_mdocto as numeric) as monto, ";
			sql= sql +		"		cast(a.ding_mdocto -protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso) as numeric) as  abonado, ";
			sql= sql +		"		cast(protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso) as numeric) as saldo_letra,  ";
			sql= sql +		"		case  when protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'P' )=1  ";
			sql= sql +		"		and protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'A' )=a.ding_mdocto  ";
			sql= sql +		"		and d.edin_tdesc='PAGADO' then (select ereg_tdesc from estados_regularizados where ereg_ccod=protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'T')) else d.edin_tdesc end as estado,  ";
			sql= sql +		"		protic.obtener_rut(b.pers_ncorr) as rut_alumno,  ";
			sql= sql +		"		protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado,  ";
			sql= sql +		"		k.ciud_tdesc as comuna, k.ciud_tcomuna as ciudad, g.pers_tnombre nombre_apoderado,g.pers_tape_paterno, g.pers_tape_materno,  ";
			sql= sql +		"		protic.obtener_direccion_letra(a.pers_ncorr_codeudor,1,'CNPB') as direccion, g.pers_tfono as telefono  ";
			sql= sql +		" From detalle_ingresos a  ";
			sql= sql +		"	join   ingresos b  ";
			sql= sql +		"		on a.ingr_ncorr = b.ingr_ncorr  ";
			sql= sql +		"	join   estados_detalle_ingresos d  ";
			sql= sql +		"		on a.edin_ccod = d.edin_ccod  ";
			sql= sql +		"	join   personas f  ";
			sql= sql +		"		on b.pers_ncorr = f.pers_ncorr  ";
			sql= sql +		"	left outer join   personas g  ";
			sql= sql +		"		on a.pers_ncorr_codeudor = g.pers_ncorr   ";
			sql= sql +		"	left outer join direcciones j  ";
			sql= sql +		"		on g.pers_ncorr = j.pers_ncorr   ";
			sql= sql +		"	left outer join ciudades k  ";
			sql= sql +		"		on j.ciud_ccod = k.ciud_ccod   ";
			sql= sql +		"	join   abonos h  ";
			sql= sql +		"		on b.ingr_ncorr = h.ingr_ncorr  ";
			sql= sql +		"	join   compromisos i  ";
			sql= sql +		"		on h.tcom_ccod = i.tcom_ccod   ";
			sql= sql +		"		and h.inst_ccod = i.inst_ccod   ";
			sql= sql +		"		and h.comp_ndocto = i.comp_ndocto  ";
			sql= sql +		" Where i.ecom_ccod not in (2,3) ";
			sql= sql +		"	and a.ting_ccod = 4     ";
			sql= sql +		"	and a.ding_ncorrelativo > 0  ";
			sql= sql +		"	and b.eing_ccod <> 3  "; 
 			sql= sql +		"	and j.tdir_ccod=1  ";
			sql= sql +		"	and j.tdir_ccod=1  ";
			sql= sql +		"   and protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso)>0 ";   
			
			if(sede!=null){
				sql= sql +  " AND i.sede_ccod ='"+sede+"' ";
			}

			if(estado!=null)
			{
				sql = sql + " AND d.edin_ccod = '"+estado+"'  ";
			}
			else
			{
				sql= sql +		"	and d.edin_ccod not in('4','6','11','14')  ";
			}

			if(num_letra!=null)
			{
				sql= sql +  " AND a.ding_ndocto ='"+num_letra+"' ";
			}

			if(rut_alumno!=null)
			{
				sql= sql +  " AND f.pers_nrut ='"+rut_alumno+"' ";
			}

			if(rut_apoderado!=null)
			{
				sql= sql +  " AND g.pers_nrut ='"+rut_apoderado+"' ";
			}

			if ((fecha_inicio!=null) || (fecha_fin!=null)){
				sql= sql +	" AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'"+fecha_inicio+"',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'"+fecha_fin+"',103),convert(datetime,a.ding_fdocto,103))";
			}
			
			sql= sql +	" order by a.ding_fdocto asc,g.pers_tape_paterno asc,a.ding_ndocto asc";
			
			//Response.Write("<pre>"+sql+"</pre>");
			//Response.Flush();
			return (sql);	
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
			string sql;
			string sede, estado,num_letra,rut_alumno,rut_apoderado;
			string fecha_inicio,fecha_fin;

			sede = Request.QueryString["sede_ccod"];
			estado = Request.QueryString["estado"];
			num_letra = Request.QueryString["num_letra"];
			rut_alumno = Request.QueryString["rut_alumno"];
			rut_apoderado = Request.QueryString["rut_apoderado"];
			fecha_inicio = Request.QueryString["inicio"];
			fecha_fin = Request.QueryString["termino"];

			/*sede ="2";
			fecha_inicio ="01/05/2006";
			fecha_fin ="07/08/2006";*/

			oleDbDataAdapter1.SelectCommand.CommandTimeout=450;
			
				
			sql = EscribirCodigo(sede,fecha_inicio, fecha_fin,estado,num_letra,rut_alumno,rut_apoderado);

			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(dataSet11);
	
			
			aviso_vencimiento.cartas_vencimiento reporte = new aviso_vencimiento.cartas_vencimiento();
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
			this.dataSet11 = new aviso_vencimiento.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("Expr1", "Expr1")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS numero_letra, '' AS vencimiento, '' AS monto, '' AS abonado, '' AS saldo_letra, '' AS estado, '' AS rut_alumno, '' AS rut_apoderado, '' AS comuna, '' AS ciudad, '' AS nombre_apoderado, '' AS pers_tape_paterno, '' AS pers_tape_materno, '' AS direccion, '' AS telefono";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-ES");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion

	
	}
}
