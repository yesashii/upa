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

namespace certificado_alumno
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected certificado_alumno.datoAlumno datoAlumno1;

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


		private string EscribirCodigo(string matr_ncorr, string peri_ccod, string semestre, string tipo_certificado, string anos_ccod, string p_imprimir_nivel, string p_nivel, string p_parrafo_adicional)
		{
			string sql;
		    
			/*sql = " select '"+anos_ccod+"' as periodo,'"+semestre+"' as semestre, sede_tregistr as nombre_enc_c, sede_secret, decode(oa.sede_ccod, 1, '', 'P.P. ') || 'SECRETARIO GENERAL' as sec_general,";
			sql = sql + "   td.tdes_tdesc AS TIPO_CERTIFICADO,c.CIUD_TDESC ciudad_sede, ";
			sql = sql + " 		pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno nombre_alumno,  ";
			sql = sql + " 		pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post,  ";
			sql = sql + " 		ee.espe_tcertific as carrera, jo.jorn_tdesc, ee.espe_tcertific, ";
			sql = sql + " 		TO_CHAR(sysdate,'DD') dia, TO_CHAR(sysdate,'MONTH') mes,TO_CHAR(sysdate,'YYYY') ano, to_char (sysdate,'Day') n_dia, lower(da.DUAS_TDESC) as DUAS_TDESC, ";
			sql = sql + "       decode('" + p_imprimir_nivel + "', 'S', '. Cursa el " + p_nivel + "º semestre ', 'N', ', ') as txt1, '" + p_parrafo_adicional + "' as parrafo_adicional ";
			sql = sql + " from alumnos aa, ";
			sql = sql + " 		personas pp,ofertas_academicas oa,  ";
			sql = sql + " 		especialidades ee, carreras ccc, ";
			sql = sql + " 	    ciudades c, sedes ss, duracion_asignatura da, tipos_descripciones td, jornadas jo ";
			sql = sql + " where aa.pers_ncorr=pp.pers_ncorr and   ";
			sql = sql + " 	  aa.ofer_ncorr=oa.ofer_ncorr and   ";
			sql = sql + " 	  oa.espe_ccod=ee.espe_ccod and   ";
			sql = sql + " 	  ee.carr_ccod=ccc.carr_ccod and  ";
			sql = sql + " 	  oa.SEDE_CCOD= ss.sede_ccod and ";
			sql = sql + " 	  ee.duas_ccod = da.duas_ccod and ";
			sql = sql + "     oa.jorn_ccod = jo.jorn_ccod and ";
			sql = sql + "     oa.peri_ccod= '" + peri_ccod +"' and ";
			sql = sql + " 	  ss.CIUD_CCOD=c.CIUD_CCOD and  ";
			sql = sql + " 	  td.tdes_ccod = '" + tipo_certificado + "' and  ";
			sql = sql + " 	  aa.matr_ncorr= nvl('" +matr_ncorr+"',0) and ";
			sql = sql + "     aa.emat_ccod=1";*/

			sql = "select '"+anos_ccod+"' as periodo,'"+semestre+"' as semestre, sede_tregistr as nombre_enc_c, sede_secret, ";
			sql = sql + " case oa.sede_ccod when 1 then '' else 'P.P. 'end + 'SECRETARIO GENERAL' as sec_general, ";
			sql = sql + " td.tdes_tdesc AS TIPO_CERTIFICADO,c.CIUD_TDESC ciudad_sede, ";
			sql = sql + " pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as nombre_alumno, ";  
			sql = sql + " cast(pp.PERS_NRUT as varchar)+ '-'+ pp.PERS_XDV as rut_post, ";  
			sql = sql + " ee.espe_tcertific as carrera, jo.jorn_tdesc, ee.espe_tcertific, "; 
			sql = sql + " datepart(day,getDate()) as dia, ";
			sql = sql + " datepart(month,getDate()) mes, ";
			sql = sql + " datepart(year,getDate()) ano, ";
			sql = sql + " datepart(day,getDate()) n_dia, ";
			sql = sql + " lower(da.DUAS_TDESC) as DUAS_TDESC, "; 
			sql = sql + " case '" + p_imprimir_nivel + "' when 'S' then '. Cursa el " + p_nivel + "º semestre ' when 'N' then ', ' end as txt1, ";
			sql = sql + " '" + p_parrafo_adicional + "' as parrafo_adicional ";
			sql = sql + " from alumnos aa, ";
			sql = sql + "    personas pp,ofertas_academicas oa, "; 
			sql = sql + "    especialidades ee, carreras ccc, ";
			sql = sql + "    ciudades c, sedes ss, duracion_asignatura da, tipos_descripciones td, jornadas jo ";
			sql = sql + " where aa.pers_ncorr=pp.pers_ncorr ";
			sql = sql + "    and aa.ofer_ncorr=oa.ofer_ncorr ";
			sql = sql + "    and oa.espe_ccod=ee.espe_ccod ";
			sql = sql + "    and ee.carr_ccod=ccc.carr_ccod ";
			sql = sql + "    and oa.SEDE_CCOD= ss.sede_ccod ";
			sql = sql + "    and ee.duas_ccod = da.duas_ccod ";
			sql = sql + "    and oa.jorn_ccod = jo.jorn_ccod ";
			sql = sql + "    and cast(oa.peri_ccod as varchar)= '" + peri_ccod +"' ";
			sql = sql + "    and ss.CIUD_CCOD=c.CIUD_CCOD ";
			sql = sql + "    and cast(td.tdes_ccod as varchar)= '" + tipo_certificado + "' ";
			sql = sql + "    and cast(aa.matr_ncorr as varchar)= isnull('" +matr_ncorr+"','0') ";
			sql = sql + "    and aa.emat_ccod=1";

			return (sql);
		
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string matr_ncorr = "";
			string periodo = "";
			string semestre = "";
			string tipo_certificado = "";
			string anos_ccod = "";
			string v_nivel;
			string v_imprimir_nivel;
			string v_imp_parrafo_adicional;
			string v_parrafo_adicional;


						
			matr_ncorr = Request.QueryString["matr_ncorr"];
			periodo = Request.QueryString["periodo"];
			semestre = Request.QueryString["semestre"];
			anos_ccod = Request.QueryString["anos_ccod"];			
			for (int i = 0; i < Request.Form.Count; i++)
			{				
				if (Request.Form.GetKey(i)=="envios[0][tipo_certificado]") {
					tipo_certificado = Request.Form[i];			
                }
			}

			v_imprimir_nivel = Request.Form["envios[0][imprimir_nivel]"];
			v_nivel = Request.Form["envios[0][nivel]"];
			v_imp_parrafo_adicional = Request.Form["envios[0][imp_parrafo_adicional]"];
			v_parrafo_adicional = Request.Form["envios[0][h_parrafo_adicional]"];

			v_parrafo_adicional = Server.HtmlDecode(v_parrafo_adicional);

											
			if (v_parrafo_adicional != null) { 				
				v_parrafo_adicional = v_parrafo_adicional.Replace("'", "\"");
				v_parrafo_adicional = "\n" + v_parrafo_adicional + "\n";
			}

			

			
			CrystalReport1 reporte = new CrystalReport1();
			
			sql = EscribirCodigo(matr_ncorr,periodo,semestre,tipo_certificado,anos_ccod, v_imprimir_nivel, v_nivel, v_parrafo_adicional);
			
			/*Response.Write("<PRE>" + sql + "</PRE>");
			Response.End();*/

			//Response.Write(sql);
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			oleDbDataAdapter1.Fill(datoAlumno1);
				
				
			reporte.SetDataSource(datoAlumno1);
			//VerCertificado.ReportSource = reporte;
			//Response.End();
			ExportarPDF(reporte);
		
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
			this.datoAlumno1 = new certificado_alumno.datoAlumno();
			((System.ComponentModel.ISupportInitialize)(this.datoAlumno1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "alumno", new System.Data.Common.DataColumnMapping[] {
																																																				  new System.Data.Common.DataColumnMapping("SEMESTRE", "SEMESTRE"),
																																																				  new System.Data.Common.DataColumnMapping("PERIODO", "PERIODO"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ENC_C", "NOMBRE_ENC_C"),
																																																				  new System.Data.Common.DataColumnMapping("SEC_GENERAL", "SEC_GENERAL"),
																																																				  new System.Data.Common.DataColumnMapping("CIUDAD_SEDE", "CIUDAD_SEDE"),
																																																				  new System.Data.Common.DataColumnMapping("CCOD_ALUMNO", "CCOD_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("NOMBRE_ALUMNO", "NOMBRE_ALUMNO"),
																																																				  new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				  new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("DIA", "DIA"),
																																																				  new System.Data.Common.DataColumnMapping("MES", "MES"),
																																																				  new System.Data.Common.DataColumnMapping("ANO", "ANO"),
																																																				  new System.Data.Common.DataColumnMapping("N_DIA", "N_DIA"),
																																																				  new System.Data.Common.DataColumnMapping("TIPO_CERTIFICADO", "TIPO_CERTIFICADO"),
																																																				  new System.Data.Common.DataColumnMapping("DUAS_TDESC", "DUAS_TDESC")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS SEMESTRE, '' AS PERIODO, 'JORGE MÜLLER UBILLA' AS NOMBRE_ENC_C, 'JAIME RIBERA NEUMANN' AS SEC_GENERAL, '' AS CIUDAD_SEDE, '' AS CCOD_ALUMNO, '' AS NOMBRE_ALUMNO, '' AS RUT_POST, '' AS CARRERA, '' AS DIA, '' AS MES, '' AS ANO, '' AS N_DIA, '' AS TIPO_CERTIFICADO, '' AS DUAS_TDESC FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// datoAlumno1
			// 
			this.datoAlumno1.DataSetName = "datoAlumno";
			this.datoAlumno1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.datoAlumno1.Namespace = "http://www.tempuri.org/datoAlumno.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datoAlumno1)).EndInit();

		}
		#endregion
	}
}
