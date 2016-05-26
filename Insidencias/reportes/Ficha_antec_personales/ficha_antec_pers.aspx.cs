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

namespace ficha_antec_personales
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbConnection oleDbConnection;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter;
		protected ficha_antec_personales.DatosFicha datosFicha1;
		protected ficha_antec_personales.DataSet1 dataSet11;

		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;

		private void Page_Load(object sender, System.EventArgs e)
		{
			string rut_env;
			string sql;
			rut_env = Request.QueryString["rut_env"];

			sql = EscribirCodigo(rut_env);
			
			oleDbDataAdapter1.SelectCommand.CommandText = sql;
			//oleDbDataAdapter1.Fill(datosFicha1);

			Response.Write(sql);

			
		}

		private string EscribirCodigo( string rut_env)
		{
			string sql;
			if (rut_env == "")
			{
				rut_env = "12981115";
			}
			sql="exec LIST_FICHA_ANTECEDENTES_PERS "+rut_env;
			return (sql);
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
			this.oleDbConnection = new System.Data.OleDb.OleDbConnection();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.oleDbDataAdapter = new System.Data.OleDb.OleDbDataAdapter();
			this.datosFicha1 = new ficha_antec_personales.DatosFicha();
			this.dataSet11 = new ficha_antec_personales.DataSet1();
			((System.ComponentModel.ISupportInitialize)(this.datosFicha1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			// 
			// oleDbConnection
			// 
			this.oleDbConnection.ConnectionString = "Provider=SQLOLEDB;server=edoras;OLE DB Services = -2;uid=protic;pwd=,.protic;init" +
				"ial catalog=protic2";
			this.oleDbConnection.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.oleDbConnection_InfoMessage);
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = @"select '' as nombre, '' as rut, '' as pasaporte, '' as fecha_nac, '' as fono, '' as nacionalidad, '' as Estado_civil, '' as Direccion, '' as comuna, '' as ciudad, '' as region, '' as colegio_egreso, '' as ano_egreso, '' as proced_educ, '' as inst_educ_sup, '' as Carrera, '' as ano_ingr, '' as FinanciaEst, '' as ultimo_post_ncorr, '' as nombre_sost_ec, '' as RUT_sost_ec, '' as fnac_sost_ec, '' as edad_sost, '' as fono_sost_ec, '' as pare_sost_ec, '' as dire_tdesc_sost_ec, '' as comu_sost_ec, '' as ciud_sost_ec, '' as regi_sost_ec";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection;
			// 
			// oleDbDataAdapter
			// 
			this.oleDbDataAdapter.SelectCommand = this.oleDbSelectCommand2;
			this.oleDbDataAdapter.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									   new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				new System.Data.Common.DataColumnMapping("nombre", "nombre"),
																																																				new System.Data.Common.DataColumnMapping("rut", "rut"),
																																																				new System.Data.Common.DataColumnMapping("pasaporte", "pasaporte"),
																																																				new System.Data.Common.DataColumnMapping("fecha_nac", "fecha_nac"),
																																																				new System.Data.Common.DataColumnMapping("fono", "fono"),
																																																				new System.Data.Common.DataColumnMapping("nacionalidad", "nacionalidad"),
																																																				new System.Data.Common.DataColumnMapping("Estado_civil", "Estado_civil"),
																																																				new System.Data.Common.DataColumnMapping("Direccion", "Direccion"),
																																																				new System.Data.Common.DataColumnMapping("comuna", "comuna"),
																																																				new System.Data.Common.DataColumnMapping("ciudad", "ciudad"),
																																																				new System.Data.Common.DataColumnMapping("region", "region"),
																																																				new System.Data.Common.DataColumnMapping("colegio_egreso", "colegio_egreso"),
																																																				new System.Data.Common.DataColumnMapping("ano_egreso", "ano_egreso"),
																																																				new System.Data.Common.DataColumnMapping("proced_educ", "proced_educ"),
																																																				new System.Data.Common.DataColumnMapping("inst_educ_sup", "inst_educ_sup"),
																																																				new System.Data.Common.DataColumnMapping("Carrera", "Carrera"),
																																																				new System.Data.Common.DataColumnMapping("ano_ingr", "ano_ingr"),
																																																				new System.Data.Common.DataColumnMapping("FinanciaEst", "FinanciaEst"),
																																																				new System.Data.Common.DataColumnMapping("ultimo_post_ncorr", "ultimo_post_ncorr"),
																																																				new System.Data.Common.DataColumnMapping("nombre_sost_ec", "nombre_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("RUT_sost_ec", "RUT_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("fnac_sost_ec", "fnac_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("edad_sost", "edad_sost"),
																																																				new System.Data.Common.DataColumnMapping("fono_sost_ec", "fono_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("pare_sost_ec", "pare_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("dire_tdesc_sost_ec", "dire_tdesc_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("comu_sost_ec", "comu_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("ciud_sost_ec", "ciud_sost_ec"),
																																																				new System.Data.Common.DataColumnMapping("regi_sost_ec", "regi_sost_ec")})});
			// 
			// datosFicha1
			// 
			this.datosFicha1.DataSetName = "DatosFicha";
			this.datosFicha1.Locale = new System.Globalization.CultureInfo("es-CL");
			this.datosFicha1.Namespace = "http://www.tempuri.org/DatosFicha.xsd";
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("en-US");
			this.dataSet11.Namespace = "http://tempuri.org/DataSet1.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.datosFicha1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();

		}
		#endregion

		private void oleDbConnection_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
