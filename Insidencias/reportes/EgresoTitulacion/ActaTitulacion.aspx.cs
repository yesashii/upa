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
using System.Data.OleDb;

namespace EgresoTitulacion
{
	/// <summary>
	/// Descripción breve de ActaTitulacion.
	/// </summary>
	public class ActaTitulacion : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected EgresoTitulacion.DataSet2 ds;
		protected System.Data.OleDb.OleDbConnection conexion;
		protected CrystalDecisions.Web.CrystalReportViewer visor;
		protected System.Data.OleDb.OleDbDataAdapter adpTitulados;
		protected System.Data.OleDb.OleDbDataAdapter adpGrupos;

		private String v_acti_ncorr;
		private const int N_LINEAS_PAGINA = 20;
		private const int MAX_REQUISITOS_CALIFICADOS = 10;
		private int v_nRequisitos, v_nGrupos, v_nRequisitosCalificados;
		protected System.Data.OleDb.OleDbDataAdapter adpEncRequisitosCalificados;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand4;

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



		private void ObtenerDatos()
		{
			OleDbCommand comando = new OleDbCommand();

			comando.Connection = conexion;

			comando.CommandText = "select count(*) as nrequisitos from actas_titulacion a, requisitos_plan b where a.plan_ccod = b.plan_ccod and a.sede_ccod = b.sede_ccod and a.peri_ccod = b.peri_ccod and a.acti_ncorr = '" + v_acti_ncorr + "'";			
			OleDbDataReader dr = comando.ExecuteReader();
			dr.Read();
			v_nRequisitos = (int) dr.GetDecimal(0);			
			dr.Close();


			comando.CommandText = "select count(*) as nrequisitos from actas_titulacion a, requisitos_plan b, tipos_requisitos_titulo c where a.plan_ccod = b.plan_ccod and a.sede_ccod = b.sede_ccod and a.peri_ccod = b.peri_ccod and b.treq_ccod = c.treq_ccod and c.teva_ccod = 1 and a.acti_ncorr = '" + v_acti_ncorr + "'";
			dr = comando.ExecuteReader();
			dr.Read();
			v_nRequisitosCalificados = (int) dr.GetDecimal(0);			
			dr.Close();


			comando.CommandText = "select ceil(count(distinct b.egre_ncorr) / " + N_LINEAS_PAGINA + ") from detalle_actas_titulacion a, requisitos_titulacion b where a.reti_ncorr = b.reti_ncorr and a.acti_ncorr = '" + v_acti_ncorr + "'";
			dr = comando.ExecuteReader();
			dr.Read();
			v_nGrupos = (int) dr.GetDecimal(0);			
			dr.Close();
		}

		private string FormarSqlGrupos()
		{
			int i;
			string consulta = "";

			for (i = 1; i <= v_nGrupos; i++) 
			{
				consulta += "select " + i + " as grupo from dual";

				if (i != v_nGrupos) 
				{
					consulta += " union ";
				}
			}

			return consulta;
		}


		private string FormarSqlTitulados()
		{
			string consulta = "";
			int i;

			consulta  = "select ceil(a.n / " + N_LINEAS_PAGINA + ") as grupo, \n";
			consulta += "       a.* \n";
			consulta += "from (select rownum as n, a.* \n";
			consulta += "      from (select e.egre_ncorr, \n";
			consulta += "                   f.pers_tape_paterno || ' ' || f.pers_tape_materno || ' ' || f.pers_tnombre as nombre, \n";
			consulta += "                   f.pers_nrut || '-' || f.pers_xdv as rut, \n";
			consulta += "            	   a.acti_ncorr, i.aceg_ncorr, \n";
			consulta += "            	   g.anos_ccod || '/' || substr(upper(g.peri_tdesc), 1, 1) as periodo_ingreso, \n";
			consulta += "            	   h.anos_ccod || '/' || substr(upper(h.peri_tdesc), 1, 1) as periodo_egreso, \n";
			consulta += "                  e.egre_nregistro_titulo || ' / ' || e.egre_nfolio_titulo as reg_folio, \n";
			consulta += "            	   max(c.reti_ftermino) as fecha_entrega, \n";


			for (i = 1; i <= v_nRequisitosCalificados; i++) 
			{
				consulta += "                   to_char(max(decode(d.nrequisito, " + i + ", c.reti_nnota)), '0.0') as n" + i + ", \n";
				consulta += "                   to_char(max(decode(d.nrequisito, " + i + ", c.reti_nnota * d.repl_nponderacion / 100 )), '0.00') as p" + i + ", \n";
			}


			consulta += "            	   to_char(nota_titulacion(e.egre_ncorr), '0.0') as nota_titulacion	\n";
			consulta += "            from actas_titulacion a, detalle_actas_titulacion b, requisitos_titulacion c, \n";
			consulta += "                 (select rownum as nrequisito, a.* \n";
			consulta += "            	  from (select b.* \n";
			consulta += "            	        from actas_titulacion a, requisitos_plan b, tipos_requisitos_titulo c \n";
			consulta += "            			where a.plan_ccod = b.plan_ccod \n";
			consulta += "            			  and a.sede_ccod = b.sede_ccod \n";
			consulta += "            			  and a.peri_ccod = b.peri_ccod \n";
			consulta += "                         and b.treq_ccod = c.treq_ccod \n";
			consulta += "						  and c.teva_ccod = 1 \n";
			consulta += "            			  and a.acti_ncorr = '" + v_acti_ncorr + "' \n";
			consulta += "            			order by b.repl_bobligatorio desc, b.treq_ccod asc) a) d, \n";
			consulta += "            	  egresados e, personas f, periodos_academicos g, periodos_academicos h, detalle_actas_egresos i \n";
			consulta += "            where a.acti_ncorr = b.acti_ncorr \n";
			consulta += "              and b.reti_ncorr = c.reti_ncorr \n";
			consulta += "              and c.repl_ncorr = d.repl_ncorr \n";
			consulta += "              and c.egre_ncorr = e.egre_ncorr \n";
			consulta += "              and e.pers_ncorr = f.pers_ncorr \n";
			consulta += "              and e.peri_ccod_ingreso = g.peri_ccod \n";
			consulta += "              and e.peri_ccod = h.peri_ccod \n";
			consulta += "              and e.egre_ncorr = i.egre_ncorr \n";
			consulta += "              and a.acti_ncorr = '" + v_acti_ncorr + "' \n";
			consulta += "            group by e.egre_ncorr, f.pers_tape_paterno, f.pers_tape_materno, f.pers_tnombre, f.pers_nrut, f.pers_xdv, \n";
			consulta += "                     a.acti_ncorr, i.aceg_ncorr, g.anos_ccod, substr(upper(g.peri_tdesc), 1, 1), \n";
			consulta += "            		 h.anos_ccod, substr(upper(h.peri_tdesc), 1, 1), \n";
			consulta += "                    e.egre_nregistro_titulo, e.egre_nfolio_titulo \n";
			consulta += "            order by nombre asc \n";
			consulta += "      ) a \n";
			consulta += ") a";

			return consulta;
		}
	


		private string FormarSqlEncReqCalificados()
		{
			string consulta = "";
			int i;

			consulta  = "select \n";
			for (i = 1; i <= MAX_REQUISITOS_CALIFICADOS; i++) 
			{

				consulta += "max(decode(nrequisito, " + i + ", a.treq_tdesc)) as t" + i + ", \n";
				consulta += "max(decode(nrequisito, " + i + ", a.repl_nponderacion)) as p" + i;

				if (i != MAX_REQUISITOS_CALIFICADOS)
					consulta += ", ";

				consulta += " \n";
			}

			consulta += "from (select rownum as nrequisito, a.* \n";
			consulta += "      from (select c.*, b.repl_nponderacion \n";
			consulta += "	        from actas_titulacion a, requisitos_plan b, tipos_requisitos_titulo c \n";
			consulta += "			where a.plan_ccod = b.plan_ccod \n";
			consulta += "			  and a.sede_ccod = b.sede_ccod \n";
			consulta += "			  and a.peri_ccod = b.peri_ccod \n";
			consulta += "			  and b.treq_ccod = c.treq_ccod \n";
			consulta += "			  and c.teva_ccod = 1 \n";
			consulta += "			  and a.acti_ncorr = '" + v_acti_ncorr + "' \n";
			consulta += "			order by b.treq_ccod \n";
			consulta += "	 ) a \n";
			consulta += ") a \n";

			return consulta;
		}


		private void FormatearReporte(crActaTitulacion rep)
		{
			SubreportObject subrep = rep.ReportDefinition.ReportObjects["subrepTitulados"] as SubreportObject;
			ReportDocument srTitulados = subrep.OpenSubreport("srTitulados");
			ReportObjects objSecEncabezado = srTitulados.ReportDefinition.Sections["Section6"].ReportObjects;
			ReportObjects objSecDetalle = srTitulados.ReportDefinition.Sections["Section5"].ReportObjects;
			int x_ini = objSecEncabezado["lnv01"].Left, x_fin = objSecEncabezado["lnv02"].Left;
			int n_distancia = (x_fin - x_ini) / v_nRequisitosCalificados;


			/*Response.Write(objSecEncabezado["lnv11"].GetType().ToString());
			Response.Flush();*/

			LineObject linea = objSecEncabezado["lnv11"] as LineObject;
			/*Response.Write("<br>"+linea.Left.ToString());
			Response.Flush();*/			
			//objSecEncabezado["lnv11"].Left = 11000;


					
			//objSecEncabezado["lnv11"].Left = 8000;
			//objSecEncabezado["lnv12"].Left = n_distancia * 2;
			

			
			//objSecEncabezado["Text37"].Left = 0;
		}


		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página

			v_acti_ncorr = Request.QueryString["acti_ncorr"];

			if (v_acti_ncorr != "") 
			{
				crActaTitulacion rep = new crActaTitulacion();
				
				conexion.Open();

				ObtenerDatos();

				adpEncabezado.SelectCommand.Parameters["acti_ncorr"].Value = v_acti_ncorr;
				adpEncabezado.Fill(ds);							

				adpEncRequisitosCalificados.SelectCommand.CommandText = FormarSqlEncReqCalificados();				
				adpEncRequisitosCalificados.Fill(ds);		
				

				adpGrupos.SelectCommand.CommandText = FormarSqlGrupos();
				adpGrupos.Fill(ds);

				adpTitulados.SelectCommand.CommandText = FormarSqlTitulados();				
				adpTitulados.Fill(ds);
				
				//FormatearReporte(rep);
				
				/*Response.Write("<pre>"+adpEncRequisitosCalificados.SelectCommand.CommandText+"</pre>");
				Response.Write("<pre>"+adpGrupos.SelectCommand.CommandText+"</pre>");
				Response.Write("<pre>"+adpTitulados.SelectCommand.CommandText+"</pre>");
				Response.Flush();*/


						

				rep.SetDataSource(ds);
				visor.ReportSource = rep;


				visor.Visible = false;

				ExportarPDF(rep);

				conexion.Close();
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
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.ds = new EgresoTitulacion.DataSet2();
			this.adpTitulados = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.adpGrupos = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			this.adpEncRequisitosCalificados = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand4 = new System.Data.OleDb.OleDbCommand();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpEncabezado
			// 
			this.adpEncabezado.SelectCommand = this.oleDbSelectCommand1;
			this.adpEncabezado.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									new System.Data.Common.DataTableMapping("Table", "ENCABEZADO", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("LINEA1", "LINEA1"),
																																																				  new System.Data.Common.DataColumnMapping("LINEA2", "LINEA2"),
																																																				  new System.Data.Common.DataColumnMapping("LINEA3", "LINEA3"),
																																																				  new System.Data.Common.DataColumnMapping("LINEA4", "LINEA4"),
																																																				  new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("ACTI_FEMISION", "ACTI_FEMISION"),
																																																				  new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("CODIGO", "CODIGO"),
																																																				  new System.Data.Common.DataColumnMapping("ACTI_NCORR", "ACTI_NCORR"),
																																																				  new System.Data.Common.DataColumnMapping("ESPE_CCOD", "ESPE_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("ESPE_TTITULO", "ESPE_TTITULO")})});
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadena_conexion", typeof(string))));
			// 
			// ds
			// 
			this.ds.DataSetName = "DataSet2";
			this.ds.Locale = new System.Globalization.CultureInfo("es-MX");
			this.ds.Namespace = "http://www.tempuri.org/DataSet2.xsd";
			// 
			// adpTitulados
			// 
			this.adpTitulados.SelectCommand = this.oleDbSelectCommand2;
			this.adpTitulados.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								   new System.Data.Common.DataTableMapping("Table", "TITULADOS", new System.Data.Common.DataColumnMapping[] {
																																																				new System.Data.Common.DataColumnMapping("GRUPO", "GRUPO"),
																																																				new System.Data.Common.DataColumnMapping("N", "N"),
																																																				new System.Data.Common.DataColumnMapping("EGRE_NCORR", "EGRE_NCORR"),
																																																				new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																				new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																				new System.Data.Common.DataColumnMapping("ACTI_NCORR", "ACTI_NCORR"),
																																																				new System.Data.Common.DataColumnMapping("ACEG_NCORR", "ACEG_NCORR"),
																																																				new System.Data.Common.DataColumnMapping("PERIODO_INGRESO", "PERIODO_INGRESO"),
																																																				new System.Data.Common.DataColumnMapping("PERIODO_EGRESO", "PERIODO_EGRESO"),
																																																				new System.Data.Common.DataColumnMapping("REG_FOLIO", "REG_FOLIO"),
																																																				new System.Data.Common.DataColumnMapping("FECHA_ENTREGA", "FECHA_ENTREGA"),
																																																				new System.Data.Common.DataColumnMapping("N1", "N1"),
																																																				new System.Data.Common.DataColumnMapping("P1", "P1"),
																																																				new System.Data.Common.DataColumnMapping("N2", "N2"),
																																																				new System.Data.Common.DataColumnMapping("P2", "P2"),
																																																				new System.Data.Common.DataColumnMapping("N3", "N3"),
																																																				new System.Data.Common.DataColumnMapping("P3", "P3"),
																																																				new System.Data.Common.DataColumnMapping("N4", "N4"),
																																																				new System.Data.Common.DataColumnMapping("P4", "P4"),
																																																				new System.Data.Common.DataColumnMapping("N5", "N5"),
																																																				new System.Data.Common.DataColumnMapping("P5", "P5"),
																																																				new System.Data.Common.DataColumnMapping("N6", "N6"),
																																																				new System.Data.Common.DataColumnMapping("P6", "P6"),
																																																				new System.Data.Common.DataColumnMapping("N7", "N7"),
																																																				new System.Data.Common.DataColumnMapping("P7", "P7"),
																																																				new System.Data.Common.DataColumnMapping("N8", "N8"),
																																																				new System.Data.Common.DataColumnMapping("P8", "P8"),
																																																				new System.Data.Common.DataColumnMapping("NOTA_TITULACION", "NOTA_TITULACION")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = @"SELECT 1 AS GRUPO, 1 AS N, 1 AS EGRE_NCORR, '' AS NOMBRE, '' AS RUT, 1 AS ACTI_NCORR, 1 AS ACEG_NCORR, '' AS PERIODO_INGRESO, '' AS PERIODO_EGRESO, '' AS REG_FOLIO, SYSDATE AS FECHA_ENTREGA, '0.0' AS N1, '0.00' AS P1, '0.0' AS N2, '0.00' AS P2, '0.0' AS N3, '0.00' AS P3, '0.0' AS N4, '0.00' AS P4, '0.0' AS N5, '0.00' AS P5, '0.0' AS N6, '0.00' AS P6, '0.0' AS N7, '0.00' AS P7, '0.0' AS N8, '0.00' AS P8, '0.00' AS NOTA_TITULACION FROM DUAL";
			this.oleDbSelectCommand2.Connection = this.conexion;
			// 
			// adpGrupos
			// 
			this.adpGrupos.SelectCommand = this.oleDbSelectCommand3;
			this.adpGrupos.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								new System.Data.Common.DataTableMapping("Table", "GRUPOS", new System.Data.Common.DataColumnMapping[] {
																																																		  new System.Data.Common.DataColumnMapping("GRUPO", "GRUPO")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT 1 AS GRUPO FROM DUAL";
			this.oleDbSelectCommand3.Connection = this.conexion;
			// 
			// adpEncRequisitosCalificados
			// 
			this.adpEncRequisitosCalificados.SelectCommand = this.oleDbSelectCommand4;
			this.adpEncRequisitosCalificados.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																												  new System.Data.Common.DataTableMapping("Table", "ENC_REQ_CALIFICADOS", new System.Data.Common.DataColumnMapping[] {
																																																										 new System.Data.Common.DataColumnMapping("T1", "T1"),
																																																										 new System.Data.Common.DataColumnMapping("P1", "P1"),
																																																										 new System.Data.Common.DataColumnMapping("T2", "T2"),
																																																										 new System.Data.Common.DataColumnMapping("P2", "P2"),
																																																										 new System.Data.Common.DataColumnMapping("T3", "T3"),
																																																										 new System.Data.Common.DataColumnMapping("P3", "P3"),
																																																										 new System.Data.Common.DataColumnMapping("T4", "T4"),
																																																										 new System.Data.Common.DataColumnMapping("P4", "P4"),
																																																										 new System.Data.Common.DataColumnMapping("T5", "T5"),
																																																										 new System.Data.Common.DataColumnMapping("P5", "P5"),
																																																										 new System.Data.Common.DataColumnMapping("T6", "T6"),
																																																										 new System.Data.Common.DataColumnMapping("P6", "P6"),
																																																										 new System.Data.Common.DataColumnMapping("T7", "T7"),
																																																										 new System.Data.Common.DataColumnMapping("P7", "P7"),
																																																										 new System.Data.Common.DataColumnMapping("T8", "T8"),
																																																										 new System.Data.Common.DataColumnMapping("P8", "P8"),
																																																										 new System.Data.Common.DataColumnMapping("T9", "T9"),
																																																										 new System.Data.Common.DataColumnMapping("P9", "P9"),
																																																										 new System.Data.Common.DataColumnMapping("T10", "T10"),
																																																										 new System.Data.Common.DataColumnMapping("P10", "P10")})});
			// 
			// oleDbSelectCommand4
			// 
			this.oleDbSelectCommand4.CommandText = "SELECT \'T\' AS T1, 1 AS P1, \'T\' AS T2, 2 AS P2, \'T\' AS T3, 3 AS P3, \'T\' AS T4, 4 A" +
				"S P4, \'T\' AS T5, 5 AS P5, \'T\' AS T6, 6 AS P6, \'T\' AS T7, 7 AS P7, \'T\' AS T8, 8 A" +
				"S P8, \'T\' AS T9, 9 AS P9, \'T\' AS T10, 10 AS P10 FROM DUAL";
			this.oleDbSelectCommand4.Connection = this.conexion;
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT E.INST_TRAZON_SOCIAL AS LINEA1, '' AS LINEA2, 'SEDE ' || ': ' || F.SEDE_TDESC || ' ; ' || F.SEDE_TCALLE || ' ' || F.SEDE_TNRO || ' - ' || G.CIUD_TDESC AS LINEA3, '' AS LINEA4, D.CARR_TDESC, A.ACTI_FEMISION, C.ESPE_TDESC, B.ESPE_CCOD || '-' || TO_CHAR(B.PLAN_NCORRELATIVO) AS CODIGO, A.ACTI_NCORR, C.ESPE_CCOD, D.CARR_CCOD, H.TTIT_TDESC AS ESPE_TTITULO FROM ACTAS_TITULACION A, PLANES_ESTUDIO B, ESPECIALIDADES C, CARRERAS D, INSTITUCIONES E, SEDES F, CIUDADES G, TIPOS_TITULOS H WHERE A.PLAN_CCOD = B.PLAN_CCOD AND B.ESPE_CCOD = C.ESPE_CCOD AND C.CARR_CCOD = D.CARR_CCOD AND D.INST_CCOD = E.INST_CCOD AND A.SEDE_CCOD = F.SEDE_CCOD AND F.CIUD_CCOD = G.CIUD_CCOD AND C.TTIT_CCOD = H.TTIT_CCOD (+) AND (A.ACTI_NCORR = ?)";
			this.oleDbSelectCommand1.Connection = this.conexion;
			this.oleDbSelectCommand1.Parameters.Add(new System.Data.OleDb.OleDbParameter("ACTI_NCORR", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(10)), ((System.Byte)(0)), "ACTI_NCORR", System.Data.DataRowVersion.Current, null));
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
