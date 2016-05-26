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

namespace imprimir_letra
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected CrystalDecisions.Web.CrystalReportViewer ViewerLetra;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
		protected imprimir_letra.letra_cambio letra_cambio1;




		private string EscribirCodigo(string v_post_ncorr)
		{
			string sql;
		    
			sql = "select protic.nro_letra(dii.ding_ndocto,ii.ingr_ncorr, "+ v_post_ncorr +" ) as valores,";
			sql = sql + "convert(varchar,pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post, ";
			sql = sql + "cc.carr_tdesc as carrera,ciu.ciud_tdesc ciudad_sede, ";
			sql = sql + "convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v, ";
			sql = sql + "datepart (month,dii.DING_FDOCTO) as mes_v, ";
			sql = sql + "datepart (dd,dii.DING_FDOCTO) as dd_v, ";
			sql = sql + "datepart (yyyy,dii.DING_FDOCTO) as ano_v, ";
			sql = sql + "SELECT MES_TDESC FROM MESES WHERE MES_CCOD=datepart(month,cps.COMP_FDOCTO)) as mes_e, ";
			sql = sql + "datepart (dd,cps.COMP_FDOCTO) as dd_e, ";
			sql = sql + "datepart (yyyy,cps.COMP_FDOCTO) as ano_e, ";
			sql = sql + "dii.DING_MDETALLE monto, ";
			sql = sql + "dii.ding_ndocto nro_docto, ";
			sql = sql + "convert(varchar,ppc.PERS_NRUT) +'-'+ppc.PERS_XDV as rut_codeudor,  ";
			sql = sql + "ppc.PERS_TFONO as fono_codeudor, 'Carrera' as descripcion, ";
			sql = sql + "ppc.pers_tnombre +' '+ ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno  as nombre_codeudor, ";
			sql = sql + "ddp.DIRE_TCALLE +' ' + ddp.DIRE_TNRO as direccion, ";
			sql = sql + "c.CIUD_TDESC ciudad, c.CIUD_TCOMUNA comuna ";
			sql = sql + "from postulantes p,personas_postulante pp, ";
			sql = sql + "personas_postulante ppc,ofertas_academicas oa,  ";
			sql = sql + "especialidades ee, carreras cc, ";
			sql = sql + "direcciones_publica ddp, ciudades c, ";
			sql = sql + "contratos con,compromisos cps , detalle_compromisos dc, ";
	        sql = sql + "abonos bb, ingresos ii, detalle_ingresos dii, sedes ss, ciudades ciu ";
			sql = sql + " where p.pers_ncorr=pp.pers_ncorr  ";
            sql = sql + "and con.post_ncorr=p.post_ncorr and ";  
	        sql = sql + "con.cont_ncorr>=protic.contrato_origen_repactacion(cps.comp_ndocto) and  ";   
	        sql = sql + "cps.ecom_ccod <> 3 and "; 
	        sql = sql + "con.econ_ccod <> 3 and     "; 
	        sql = sql + "cps.comp_ndocto=dc.comp_ndocto and   ";  
	        sql = sql + "cps.tcom_ccod=dc.tcom_ccod and    "; 
	        sql = sql + "bb.comp_ndocto=dc.comp_ndocto and    "; 
	        sql = sql + "bb.tcom_ccod=dc.tcom_ccod and     "; 
	        sql = sql + "bb.dcom_ncompromiso=dc.dcom_ncompromiso and  ";    
	        sql = sql + "bb.ingr_ncorr=ii.ingr_ncorr and "; 
	        sql = sql + "ii.eing_ccod <> 3 and     "; 
	        sql = sql + "dii.ingr_ncorr = ii.ingr_ncorr and "; 
			sql = sql + "dii.ting_ccod =4 ";
			sql = sql + "and dii.pers_ncorr_codeudor = ppc.pers_ncorr  ";
			sql = sql + "and ppc.pers_ncorr = ddp.pers_ncorr ";
			sql = sql + "and ddp.tdir_ccod =1 ";
			sql = sql + "and ddp.ciud_ccod=c.ciud_ccod  ";
			sql = sql + "and p.ofer_ncorr=oa.ofer_ncorr  ";
			sql = sql + "and oa.espe_ccod=ee.espe_ccod  ";
			sql = sql + " and oa.sede_ccod=ss.sede_ccod  ";
			sql = sql + " and ss.ciud_ccod= ciu.ciud_ccod ";
			sql = sql + "and ee.carr_ccod=cc.carr_ccod ";
Response.Write(sql);
Response.Flush();
			return (sql);
		 
		}

		private string EscribirCodigo_Pact() 
		{
			string SQL;

			SQL = " select protic.nro_letra(dii.ding_ndocto, dii.ingr_ncorr, null) as valores, protic.obtener_rut(p.pers_ncorr) as rut_post, g.tdet_tdesc as carrera, n.ciud_tdesc as ciudad_sede,";
			SQL = SQL +  "        convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v,";
			SQL = SQL +  " 	   datepart (month,dii.DING_FDOCTO) as mes_v,";
			SQL = SQL +  " 	   datepart (dd,dii.DING_FDOCTO) as dd_v,";
			SQL = SQL +  " 	   datepart (yyyy,dii.DING_FDOCTO) as ano_v,";
			SQL = SQL +  " 	   (SELECT MES_TDESC FROM MESES WHERE MES_CCOD= datepart(month,e.COMP_FDOCTO)) as mes_e,";
			SQL = SQL +  " 	   datepart (dd,e.COMP_FDOCTO) as dd_e,";
			SQL = SQL +  " 	   datepart (yyyy,e.COMP_FDOCTO) as ano_e, 'Curso' as descripcion, ";
			SQL = SQL +  " 	   dii.ding_mdetalle as monto, dii.ding_ndocto as nro_docto,";
			SQL = SQL +  " 	   protic.obtener_rut(j.pers_ncorr) as rut_codeudor, j.pers_tfono as fono_codeudor, protic.obtener_nombre_completo(j.pers_ncorr,'n') as nombre_codeudor, protic.obtener_direccion(j.pers_ncorr, 1,'CN') as direccion, l.ciud_tdesc as ciudad, l.ciud_tcomuna as comuna";
			SQL = SQL +  " from detalle_ingresos dii, ingresos b, abonos c, detalle_compromisos d, compromisos e, sim_pactaciones f, tipos_detalle g,";
			SQL = SQL +  "      personas p, personas j, direcciones k, ciudades l,";
			SQL = SQL +  " 	 sedes m, ciudades n";
			SQL = SQL +  " where dii.ingr_ncorr = b.ingr_ncorr";
			SQL = SQL +  "   and b.ingr_ncorr = c.ingr_ncorr";
			SQL = SQL +  "   and c.tcom_ccod = d.tcom_ccod";
			SQL = SQL +  "   and c.inst_ccod = d.inst_ccod";
			SQL = SQL +  "   and c.comp_ndocto = d.comp_ndocto";
			SQL = SQL +  "   and c.dcom_ncompromiso = d.dcom_ncompromiso";
			SQL = SQL +  "   and d.tcom_ccod = e.tcom_ccod";
			SQL = SQL +  "   and d.inst_ccod = e.inst_ccod";
			SQL = SQL +  "   and d.comp_ndocto = e.comp_ndocto";			
			SQL = SQL +  "   and e.inst_ccod = f.inst_ccod";
			SQL = SQL +  "   and protic.compromiso_origen_repactacion(e.comp_ndocto, 'comp_ndocto') = f.comp_ndocto";
			SQL = SQL +  "   and f.tdet_ccod = g.tdet_ccod";
			SQL = SQL +  "   and e.pers_ncorr = p.pers_ncorr";			
			SQL = SQL +  "   and dii.pers_ncorr_codeudor = j.pers_ncorr";
			SQL = SQL +  "   and j.pers_ncorr = k.pers_ncorr";
			SQL = SQL +  "   and k.ciud_ccod = l.ciud_ccod";
			SQL = SQL +  "   and e.sede_ccod = m.sede_ccod";
			SQL = SQL +  "   and m.ciud_ccod = n.ciud_ccod";
			SQL = SQL +  "   and k.tdir_ccod = 1";
			Response.Write(SQL);
			Response.Flush();
			return (SQL);
		}

		private string EscribirCodigo_Repactaciones() {
			string SQL;

			SQL = "";

			return SQL;
		}




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
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página
			string sql;
			string sql_2="";
			string v_post_ncorr="";
			
			string ting_ccod, ding_ndocto, ingr_ncorr,post_ncorr = "";
			
			string datos= "";
			int contador = 0;	
			int fila = 0;			  
			int pase = 0;
			string tipo_impresion;

			tipo_impresion = Request.QueryString["tipo_impresion"];


			CrystalReport1 reporte = new CrystalReport1();

			for (int i = 0; i < Request.Form.Count; i++)
			{
				//Response.Write("<br>res:" + Request.Form.GetKey(i) + " : " + Request.Form[i]);
                //Response.End();

				ting_ccod   = "envios[" + fila + "][ting_ccod]";
				post_ncorr  = "envios[" + fila + "][post_ncorr]";			  			  
				ding_ndocto = "envios[" + fila + "][ding_ndocto]";
				ingr_ncorr  = "envios[" + fila + "][ingr_ncorr]";
				
				
     


				if ((Request.Form.GetKey(i) == ding_ndocto)&& (Request.Form[i] != "")) 
				{
					
					datos = datos +  " and dii.ding_ndocto=" + Request.Form[i];
					pase++;
					contador++;
					
					
				}
				if (pase!=0)
				{
					if (Request.Form.GetKey(i)==ting_ccod)
					{

						datos = datos +  " and dii.ting_ccod=" + Request.Form[i];
						
					}
					if ((Request.Form.GetKey(i)==post_ncorr) && (tipo_impresion != "2"))
					{
						datos = datos +  " and p.post_ncorr=" + Request.Form[i];
						v_post_ncorr = Request.Form[i];
					}
					
					if (Request.Form.GetKey(i)==ingr_ncorr)
					{
						datos = datos +  " and dii.ingr_ncorr=" + Request.Form[i];

						switch (tipo_impresion) {
							case "2" :
								sql = EscribirCodigo_Pact();
								break;							
							default:
								sql = EscribirCodigo(v_post_ncorr);
								break;
						}					
						

						sql_2 = sql + datos;

						//Response.Write(sql_2);
                        //Response.End();
						oleDbDataAdapter1.SelectCommand.CommandText = sql_2;
						oleDbDataAdapter1.Fill(letra_cambio1);
							
					}
												      
				}

				if (Request.Form.GetKey(i) == ingr_ncorr) 
				{
					
					
                
					
					datos="";
					fila++;	
					
					pase=0;
				}
				
			}

			//Response.End();
			reporte.SetDataSource(letra_cambio1);
			ViewerLetra.ReportSource = reporte;
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
			this.letra_cambio1 = new imprimir_letra.letra_cambio();
			((System.ComponentModel.ISupportInitialize)(this.letra_cambio1)).BeginInit();
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("RUT_POST", "RUT_POST"),
																																																				 new System.Data.Common.DataColumnMapping("CARRERA", "CARRERA"),
																																																				 new System.Data.Common.DataColumnMapping("FECHA_ENTERA_V", "FECHA_ENTERA_V"),
																																																				 new System.Data.Common.DataColumnMapping("MES_V", "MES_V"),
																																																				 new System.Data.Common.DataColumnMapping("DD_V", "DD_V"),
																																																				 new System.Data.Common.DataColumnMapping("ANO_V", "ANO_V"),
																																																				 new System.Data.Common.DataColumnMapping("MES_E", "MES_E"),
																																																				 new System.Data.Common.DataColumnMapping("DD_E", "DD_E"),
																																																				 new System.Data.Common.DataColumnMapping("ANO_E", "ANO_E"),
																																																				 new System.Data.Common.DataColumnMapping("MONTO", "MONTO"),
																																																				 new System.Data.Common.DataColumnMapping("NRO_DOCTO", "NRO_DOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_CODEUDOR", "RUT_CODEUDOR"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_CODEUDOR", "NOMBRE_CODEUDOR"),
																																																				 new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																				 new System.Data.Common.DataColumnMapping("CIUDAD", "CIUDAD"),
																																																				 new System.Data.Common.DataColumnMapping("COMUNA", "COMUNA")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS FONO_CODEUDOR, '' AS CIUDAD_SEDE, '' AS RUT_POST, '' AS CARRERA, '' AS FECHA_ENTERA_V, '' AS MES_V, '' AS DD_V, '' AS ANO_V, '' AS MES_E, '' AS DD_E, '' AS ANO_E, '' AS MONTO, '' AS NRO_DOCTO, '' AS RUT_CODEUDOR, '' AS NOMBRE_CODEUDOR, '' AS DIRECCION, '' AS CIUDAD, '' AS COMUNA, '' AS VALORES, '' AS DESCRIPCION FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// letra_cambio1
			// 
			this.letra_cambio1.DataSetName = "letra_cambio";
			this.letra_cambio1.Locale = new System.Globalization.CultureInfo("es-ES");
			this.letra_cambio1.Namespace = "http://www.tempuri.org/letra_cambio.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.letra_cambio1)).EndInit();

		}
		#endregion
	}
}
