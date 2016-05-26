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

namespace imprimir_anexos
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected imprimir_anexos.contratos contratos1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected CrystalDecisions.Web.CrystalReportViewer VerContrato;
		
	

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


		private string EscribirCodigo( string pers_ncorr, string cdoc_ncorr)
		{
			string sql;
		    
			// DATOS DEL CONTRATO OBTENIDOS A TRAVES DE UN PROCEDIMIENTO
			//sql2="exec Contrato_Docente "+pers_ncorr+","+cdoc_ncorr+","+peri_ccod+",'"+Cerrar+"'"+",'"+fechai+"','"+fechaf+"','"+fechaf1+"','"+Porcentaje+"','"+MontoMC+"'";
			

			sql ="select distinct a.cdoc_ncorr,a.pers_ncorr,d.pers_nrut as rut_docente,protic.obtener_nombre(a.pers_ncorr,'n') as nombre_docente,  ";
			sql = sql + "			  d.pers_xdv as dv,protic.trunc(d.pers_fnacimiento) as fecha_nac,f.eciv_tdesc as estado_civil,protic.obtener_direccion(d.pers_ncorr,1,'cnpb') as direccion,  ";
			sql = sql + "			  h.ciud_tdesc as comuna, h.ciud_tcomuna as ciudad,(select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion,  ";
			sql = sql + "			  b.anex_ncodigo as bloq_anexo, b.carr_ccod,i.carr_tdesc, c.asig_ccod,cast(c.dane_nsesiones/2 as integer) as asig_nhoras,j.asig_tdesc, k.duas_tdesc, c.dane_msesion as monto_sesion,  ";
			sql = sql + "			  cast((c.dane_nsesiones/2)*c.dane_msesion as numeric) as valor,l.inst_trazon_social,protic.obtener_nombre_completo(l.pers_ncorr_representante,'n') as NombreRepLeg,  ";
			sql = sql + "			  lower(o.tpro_tdesc) as tipoDocente,isnull(m.pais_tnacionalidad,'CHILENA') as nacionalidad, protic.trunc(a.cdoc_finicio) as fechai,protic.trunc(a.cdoc_ffin) as fechaf,b.anex_nhoras_coordina as horas_coordinacion,  ";
			sql = sql + "			  n.secc_tdesc, e.sede_tdesc,b.anex_ncuotas as num_cuotas,protic.trunc(b.anex_finicio) as fecha_inicio, protic.trunc(b.anex_ffin) as fecha_fin,q.mcol_mmonto as monto_colacion,p.prof_nporcentaje_colacion as porcentaje, ";
			sql = sql + "			  (select top 1 cudo_tinstitucion from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as institucion_t, ";
			sql = sql + "			  protic.obtener_grado_docente(a.pers_ncorr,'G') as grado,protic.obtener_grado_docente(a.pers_ncorr,'I') as institucion_g,protic.horario_x_persona(n.secc_ccod,a.pers_ncorr) as horario,protic. obtener_jerarquia(jdoc_ccod,'(') as jerarquia ";
			sql = sql + "			  From contratos_docentes_upa a ";
			sql = sql + "                 join anexos b ";
			sql = sql + "                    on a.cdoc_ncorr    =   b.cdoc_ncorr ";
			sql = sql + "                 join detalle_anexos c ";
			sql = sql + "                    on b.anex_ncorr    =   c.anex_ncorr ";
			sql = sql + "                 join personas d ";
			sql = sql + "                    on a.pers_ncorr    =   d.pers_ncorr ";
			sql = sql + "			      join sedes e ";
			sql = sql + "                    on b.sede_ccod     =   e.sede_ccod ";
			sql = sql + "                 join estados_civiles f ";
			sql = sql + "                    on d.eciv_ccod     =   f.eciv_ccod ";
			sql = sql + "                 join direcciones g ";
			sql = sql + "                    on a.pers_ncorr    =   g.pers_ncorr ";
			sql = sql + "                 left outer join ciudades h ";
			sql = sql + "                    on g.ciud_ccod     =  h.ciud_ccod ";
			sql = sql + "                 join carreras i ";
			sql = sql + "                    on  b.carr_ccod     =   i.carr_ccod ";
			sql = sql + "			     join asignaturas j ";
			sql = sql + "                    on c.asig_ccod     =   j.asig_ccod  ";
			sql = sql + "                 join duracion_asignatura k ";
			sql = sql + "                    on c.duas_ccod     =   k.duas_ccod ";
			sql = sql + "                 join instituciones l ";
			sql = sql + "                    on l.INST_CCOD     =   1 ";
			sql = sql + "                 left outer join paises m ";
			sql = sql + "                    on d.PAIS_CCOD     =   m.PAIS_CCOD ";
			sql = sql + "                 join secciones n ";
			sql = sql + "                    on c.secc_ccod     =   n.secc_ccod ";
			sql = sql + "                  join profesores p ";
			sql = sql + "                    on  d.pers_ncorr    =   p.pers_ncorr ";
			sql = sql + "                    and b.SEDE_CCOD     =   p.sede_ccod ";
			sql = sql + "                 join tipos_profesores o ";
			sql = sql + "                    on p.TPRO_CCOD     =   o.TPRO_CCOD ";
			sql = sql + "				left outer join monto_colacion q  ";
			sql = sql + "					on p.mcol_ncorr     =   q.mcol_ncorr  ";  
			sql = sql + "			  Where a.pers_ncorr     =   "+pers_ncorr+"   ";
			sql = sql + "			     and b.cdoc_ncorr    =   "+cdoc_ncorr+" ";
			sql = sql + "			     and g.tdir_ccod     =   1   ";
			sql = sql + "                 and b.eane_ccod	 <>  3 ";

			/*
			sql= "select distinct a.cdoc_ncorr,a.pers_ncorr,d.pers_nrut as rut_docente,protic.obtener_nombre(a.pers_ncorr,'n') as nombre_docente, ";
			sql = sql + " d.pers_xdv as dv,protic.trunc(d.pers_fnacimiento) as fecha_nac,f.eciv_tdesc as estado_civil,protic.obtener_direccion(d.pers_ncorr,1,'cnpb') as direccion, ";
			sql = sql + " h.ciud_tdesc as comuna, h.ciud_tcomuna as ciudad,(select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion, ";
			sql = sql + " b.anex_ncodigo as bloq_anexo, b.carr_ccod,i.carr_tdesc, c.asig_ccod,cast(c.dane_nsesiones/2 as integer) as asig_nhoras,j.asig_tdesc, k.duas_tdesc, c.dane_msesion as monto_sesion, ";
			sql = sql + " cast((c.dane_nsesiones/2)*c.dane_msesion as numeric) as valor,l.inst_trazon_social,protic.obtener_nombre_completo(l.pers_ncorr_representante,'n') as NombreRepLeg, ";
			sql = sql + " lower(o.tpro_tdesc) as tipoDocente,m.pais_tnacionalidad as nacionalidad, protic.trunc(a.cdoc_finicio) as fechai,protic.trunc(a.cdoc_ffin) as fechaf,b.anex_nhoras_coordina as horas_coordinacion, ";
			sql = sql + " n.secc_tdesc, e.sede_tdesc,b.anex_ncuotas as num_cuotas,protic.trunc(b.anex_finicio) as fecha_inicio, protic.trunc(b.anex_ffin) as fecha_fin ";
			sql = sql + " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d, ";
			sql = sql + "    sedes e, estados_civiles f,direcciones g, ciudades h, carreras i, ";
			sql = sql + "    asignaturas j,duracion_asignatura k,instituciones l,paises m, secciones n,tipos_profesores o,profesores p  ";
			sql = sql + " Where a.pers_ncorr     =   "+pers_ncorr+" ";
			sql = sql + "    and b.cdoc_ncorr    =   "+cdoc_ncorr+" ";
			//sql = sql + " Where a.pers_ncorr     =   23979 ";
			//sql = sql + "    and b.cdoc_ncorr    =   31 ";
			sql = sql + "    and a.cdoc_ncorr    =   b.cdoc_ncorr ";
			sql = sql + "    and b.anex_ncorr    =   c.anex_ncorr ";
			sql = sql + "    and a.pers_ncorr    =   d.pers_ncorr ";
			sql = sql + "    and b.sede_ccod     =   e.sede_ccod ";
			sql = sql + "    and d.eciv_ccod     =   f.eciv_ccod ";
			sql = sql + "    and g.ciud_ccod     *=  h.ciud_ccod ";
			sql = sql + "    and g.pers_ncorr    =   a.pers_ncorr ";
			sql = sql + "    and g.tdir_ccod     =   1 ";
			sql = sql + "    and b.carr_ccod     =   i.carr_ccod ";
			sql = sql + "    and c.asig_ccod     =   j.asig_ccod ";
			sql = sql + "    and c.duas_ccod     =   k.duas_ccod ";
			sql = sql + "    and l.INST_CCOD     =   1 ";
			sql = sql + "    and M.PAIS_CCOD     =   d.PAIS_CCOD ";
			sql = sql + "    and n.secc_ccod     =   c.secc_ccod ";
			sql = sql + "    and o.TPRO_CCOD     =   p.TPRO_CCOD ";
			sql = sql + "    and p.pers_ncorr    =   d.pers_ncorr ";
			sql = sql + "    AND b.SEDE_CCOD     =   p.sede_ccod ";
			sql = sql + "	 and a.ecdo_ccod	 =	 1 ";
            sql = sql + "    and b.eane_ccod	 <>  3 ";
*/
			
			return (sql);	
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string pers_ncorr;
			string cdoc_ncorr;
			string indefinido;

			pers_ncorr =Request.QueryString["pers_ncorr"];//"23874";
			cdoc_ncorr =Request.QueryString["cdoc_ncorr"];//"3334";
			indefinido =Request.QueryString["indefinido"];

			oleDbDataAdapter1.SelectCommand.CommandTimeout=450;
			//pers_ncorr = "22262";
			//cdoc_ncorr = "741";
		    //indefinido="SI";

			//string[] informe = new string[4] {"ORIGINAL","DUPLICADO","TRIPLICADO","CUADRIPLICADO"};
			string[] informe = new string[2] {"ORIGINAL","DUPLICADO"};			
			//CrystalReportContrato reporte = new CrystalReportContrato();
		
			for (int i=0; i<1; i++)
			{
				sql = EscribirCodigo(pers_ncorr, cdoc_ncorr);

				oleDbDataAdapter1.SelectCommand.CommandText = sql;
				oleDbDataAdapter1.Fill(contratos1);
		
			}		
		 	
		  if (indefinido == "SI") 
			{
			  imprimir_anexos.ContratoIndefinido  reporte2 = new imprimir_anexos.ContratoIndefinido();
			  reporte2.SetDataSource(contratos1);
			  VerContrato.ReportSource = reporte2;
			  ExportarPDF(reporte2);

			} 
			else 
			{
			  if (indefinido == "NO") 
			  {
				  imprimir_anexos.ContratoHonorario reporte1 = new imprimir_anexos.ContratoHonorario();
				  reporte1.SetDataSource(contratos1);
				  VerContrato.ReportSource = reporte1;
				  ExportarPDF(reporte1);
			  }
			  else
			  {
				  imprimir_anexos.ContratoPlazoFijo reporte3 = new imprimir_anexos.ContratoPlazoFijo();
				  reporte3.SetDataSource(contratos1);
				  VerContrato.ReportSource = reporte3;
				  ExportarPDF(reporte3);
			  }
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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.contratos1 = new imprimir_anexos.contratos();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.contratos1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("CDOC_NCORR", "CDOC_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("pers_ncorr", "pers_ncorr"),
																																																				 new System.Data.Common.DataColumnMapping("Nombre_Docente", "Nombre_Docente"),
																																																				 new System.Data.Common.DataColumnMapping("Rut_Docente", "Rut_Docente"),
																																																				 new System.Data.Common.DataColumnMapping("DV", "DV"),
																																																				 new System.Data.Common.DataColumnMapping("Fecha_Nac", "Fecha_Nac"),
																																																				 new System.Data.Common.DataColumnMapping("Estado_Civil", "Estado_Civil"),
																																																				 new System.Data.Common.DataColumnMapping("Direccion", "Direccion"),
																																																				 new System.Data.Common.DataColumnMapping("Comuna", "Comuna"),
																																																				 new System.Data.Common.DataColumnMapping("Ciudad", "Ciudad"),
																																																				 new System.Data.Common.DataColumnMapping("PROFESION", "PROFESION"),
																																																				 new System.Data.Common.DataColumnMapping("BLOQ_ANEXO", "BLOQ_ANEXO"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("ASIG_CCOD", "ASIG_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("ASIG_NHORAS", "ASIG_NHORAS"),
																																																				 new System.Data.Common.DataColumnMapping("ASIG_TDESC", "ASIG_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("DUAS_TDESC", "DUAS_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("monto_sesion", "monto_sesion"),
																																																				 new System.Data.Common.DataColumnMapping("Valor", "Valor"),
																																																				 new System.Data.Common.DataColumnMapping("INST_TRAZON_SOCIAL", "INST_TRAZON_SOCIAL"),
																																																				 new System.Data.Common.DataColumnMapping("NombreRepLeg", "NombreRepLeg"),
																																																				 new System.Data.Common.DataColumnMapping("TipoDocente", "TipoDocente"),
																																																				 new System.Data.Common.DataColumnMapping("Nacionalidad", "Nacionalidad"),
																																																				 new System.Data.Common.DataColumnMapping("FechaI", "FechaI"),
																																																				 new System.Data.Common.DataColumnMapping("FechaF", "FechaF"),
																																																				 new System.Data.Common.DataColumnMapping("horas_coordinacion", "horas_coordinacion"),
																																																				 new System.Data.Common.DataColumnMapping("SECC_TDESC", "SECC_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("sede_tdesc", "sede_tdesc"),
																																																				 new System.Data.Common.DataColumnMapping("num_cuotas", "num_cuotas"),
																																																				 new System.Data.Common.DataColumnMapping("fecha_inicio", "fecha_inicio"),
																																																				 new System.Data.Common.DataColumnMapping("fecha_fin", "fecha_fin"),
																																																				 new System.Data.Common.DataColumnMapping("porcentaje", "porcentaje"),
																																																				 new System.Data.Common.DataColumnMapping("monto_colacion", "monto_colacion"),
																																																				 new System.Data.Common.DataColumnMapping("institucion_t", "institucion_t"),
																																																				 new System.Data.Common.DataColumnMapping("grado", "grado"),
																																																				 new System.Data.Common.DataColumnMapping("institucion_g", "institucion_g"),
																																																				 new System.Data.Common.DataColumnMapping("horario", "horario"),
																																																				 new System.Data.Common.DataColumnMapping("jerarquia", "jerarquia")})});
			this.oleDbDataAdapter1.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.oleDbDataAdapter1_RowUpdated);
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.oleDbConnection1.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection1_InfoMessage);
			// 
			// contratos1
			// 
			this.contratos1.DataSetName = "contratos";
			this.contratos1.Locale = new System.Globalization.CultureInfo("en-US");
			this.contratos1.Namespace = "http://www.tempuri.org/contratos.xsd";
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT 0 AS CDOC_NCORR, 0 AS pers_ncorr, '' AS Nombre_Docente, 0 AS Rut_Docente, '' AS DV, '' AS Fecha_Nac, '' AS Estado_Civil, '' AS Direccion, '' AS Comuna, '' AS Ciudad, '' AS PROFESION, 0 AS BLOQ_ANEXO, 0 AS CARR_CCOD, '' AS CARR_TDESC, '' AS ASIG_CCOD, 0 AS ASIG_NHORAS, '' AS ASIG_TDESC, '' AS DUAS_TDESC, 0 AS monto_sesion, 0 AS Valor, '' AS INST_TRAZON_SOCIAL, '' AS NombreRepLeg, '' AS TipoDocente, '' AS Nacionalidad, '' AS FechaI, '' AS FechaF, 0 AS horas_coordinacion, '' AS SECC_TDESC, '' AS sede_tdesc, '' AS num_cuotas, '' AS fecha_inicio, '' AS fecha_fin, '' AS porcentaje, '' AS monto_colacion, '' AS institucion_t, '' AS grado, '' AS institucion_g, '' AS horario, '' AS jerarquia";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.contratos1)).EndInit();

		}
		#endregion

		private void oleDbDataAdapter1_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void oleDbConnection1_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
