using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace EgresoTitulacion
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class ActaEgresoForm : System.Web.UI.Page
	{

		private String v_aceg_ncorr;
		private String v_plan_ccod, v_espe_ccod, v_carr_ccod;		

		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
		protected System.Data.OleDb.OleDbConnection conexion;
		protected System.Data.OleDb.OleDbDataAdapter adpAlumnos;
		protected CrystalDecisions.Web.CrystalReportViewer visor;
		protected System.Data.OleDb.OleDbCommand comDatos;
		protected EgresoTitulacion.DataSet1 ds;
		protected System.Data.OleDb.OleDbDataAdapter adpAsignaturas;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;


		private const int v_nnotas_fila = 21;
		private int v_nasignaturas_plan, v_ngrupos_notas;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		private String v_lista_alumnos;




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

		private String FormarSqlAsignaturas()
		{
			String consulta;


			consulta  = "select ceil(a.nasignatura / " + v_nnotas_fila + ") as grupo, \n";
			consulta += "       a.* \n";
			consulta += "from (select rownum as nasignatura, to_char(rownum + 10, '099') as cod_asignatura, a.* \n";
			consulta += "      from (select b.asig_ccod, b.asig_tdesc, b.asig_nhoras \n";
			consulta += "	        from malla_curricular a, asignaturas b \n";
			consulta += "			where a.asig_ccod = b.asig_ccod \n";
			consulta += "			  and a.plan_ccod = '" + v_plan_ccod + "' \n";
			consulta += "			order by a.nive_ccod, b.asig_ccod \n";
			consulta += "	 ) a \n";
			consulta += ") a";


			return consulta;
		}


		private void ObtenerDatosSqlNotas()
		{
			
			OleDbCommand comando = new OleDbCommand();

			comando.Connection = conexion;

			comando.CommandText = "SELECT count(*) AS cuenta, ceil(count(*) / " + v_nnotas_fila.ToString() + ") AS ngrupos FROM malla_curricular WHERE plan_ccod = '" + v_plan_ccod + "'";			
			OleDbDataReader dr = comando.ExecuteReader();
			dr.Read();
			v_nasignaturas_plan = (int) dr.GetDecimal(0);
			v_ngrupos_notas = (int) dr.GetDecimal(1);
			dr.Close();

			
			comando.CommandText = "SELECT lista_pers_ncorr_egresados(" + v_aceg_ncorr + ") as lista from dual";			
			dr = comando.ExecuteReader();
			dr.Read();
			v_lista_alumnos = dr["lista"].ToString();
			dr.Close();
						
		}

		/*private String FormarSqlNotas()
		{
			int v_nnota;
			String consulta;
			int i1, i2;
			OleDbCommand comando = new OleDbCommand();
			

			comando.Connection = conexion;

			comando.CommandText = "SELECT count(*) AS cuenta, ceil(count(*) / " + v_nnotas_fila.ToString() + ") AS ngrupos FROM malla_curricular WHERE plan_ccod = '" + v_plan_ccod + "'";			
			OleDbDataReader dr = comando.ExecuteReader();
			dr.Read();
			v_nasignaturas_plan = (int) dr.GetDecimal(0);
			v_ngrupos_notas = (int) dr.GetDecimal(1);
			dr.Close();

			
			comando.CommandText = "SELECT lista_pers_ncorr_egresados(" + v_aceg_ncorr + ") as lista from dual";			
			dr = comando.ExecuteReader();
			dr.Read();
			v_lista_alumnos = dr["lista"].ToString();
			dr.Close();


			
			consulta  = "select * \n";
			consulta += "from ( \n";
			

			for (i1 = 1; i1 <= v_ngrupos_notas; i1++) 
			{				
				consulta += "      select rownum as n, a.* \n";
				consulta += "      from (select " + i1.ToString() + " as grupo, a.pers_ncorr, \n";
				consulta += "	           b.pers_tape_paterno || ' ' || b.pers_tape_materno || ' ' || b.pers_tnombre as nombre, \n";
				consulta += "	           b.pers_nrut || '-' || b.pers_xdv as rut, \n";
				consulta += "		   d.anos_ccod || '/' || case d.plec_ccod when 1 then 'O' when 3 then 'P' end as periodo_ingreso, \n";
				consulta += "		   e.anos_ccod || '/' || case e.plec_ccod when 1 then 'O' when 3 then 'P' end as periodo_egreso, \n";

				for (i2 = 1; i2 <= v_nnotas_fila; i2++) 
				{
					v_nnota = (v_nnotas_fila * (i1 - 1)) + i2;

					consulta += "                   max(case nasignatura when " + v_nnota.ToString() + " then to_char(carg_nnota_final, '0.0') end) as N" + v_nnota.ToString() + ", \n";										
				}

				if (i1 != v_ngrupos_notas) 
				{
					consulta += "                    null as negreso \n";
				}
				else 
				{
					consulta += "                    to_char(nota_egreso(a.pers_ncorr, " + v_plan_ccod + "), '0.0') as negreso \n";
				}

				consulta += "            from (select a.* \n";
				consulta += "                  from (select b.pers_ncorr, a.nasignatura, a.nive_ccod, a.asig_ccod, asig.asig_tdesc, \n";
				consulta += "                               b.carg_nnota_final, \n";
				consulta += "							   b.sitf_ccod, b.peri_ccod \n";
				consulta += "						from (select rownum as nasignatura, a.* \n";
				consulta += "							  from (select ma.nive_ccod, asig_ccod, esp.carr_ccod \n";
				consulta += "									from especialidades esp, planes_estudio pl, malla_curricular ma \n";
				consulta += "									where esp.espe_ccod = pl.espe_ccod \n";
				consulta += "									  and pl.plan_ccod = ma.plan_ccod \n";
				consulta += "									  and pl.plan_ccod = '" + v_plan_ccod + "' \n";
				consulta += "									order by ma.nive_ccod asc, asig_ccod asc) a \n";
				consulta += "							  ) a, \n";
				consulta += "							  (select b.pers_ncorr, h.asig_ccod, a.sitf_ccod, a.carg_nnota_final, g.peri_ccod \n";
				consulta += "							   from cargas_academicas a, alumnos b, ofertas_academicas d, planes_estudio e, especialidades f, secciones g, asignaturas h \n";
				consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
				consulta += "								 and b.ofer_ncorr = d.ofer_ncorr \n";
				consulta += "								 and b.plan_ccod = e.plan_ccod \n";
				consulta += "								 and e.espe_ccod = f.espe_ccod \n";
				consulta += "								 and a.secc_ccod = g.secc_ccod \n";
				consulta += "								 and g.asig_ccod = h.asig_ccod \n";
				consulta += "								 and b.emat_ccod = 1 \n";
				consulta += "								 and b.pers_ncorr in (" + v_lista_alumnos + ") \n";
				consulta += "								 and f.carr_ccod = '" + v_carr_ccod + "' \n";
				consulta += "								 and a.sitf_ccod not in ('EE','EQ','NN') \n";
				consulta += "							   union \n";
				consulta += "							   select b.pers_ncorr, a.asig_ccod, sitf_ccod, \n";				
				consulta += "									  a.conv_nnota, e.peri_ccod \n";
				consulta += "							   from convalidaciones a, alumnos b, personas c, actas_convalidacion d, ofertas_academicas e, planes_estudio f, especialidades g \n";
				consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
				consulta += "								 and b.pers_ncorr = c.pers_ncorr \n";
				consulta += "								 and a.acon_ncorr = d.acon_ncorr \n";
				consulta += "								 and b.ofer_ncorr = e.ofer_ncorr \n";
				consulta += "								 and b.plan_ccod = f.plan_ccod \n";
				consulta += "								 and f.espe_ccod = g.espe_ccod \n";
				consulta += "								 and g.carr_ccod = '" + v_carr_ccod + "' \n";
				consulta += "								 and b.pers_ncorr in (" + v_lista_alumnos + " ) \n";
				consulta += "							   union \n";
				consulta += "							   select g.pers_ncorr, a.asig_ccod, b.sitf_ccod, b.carg_nnota_final, d.peri_ccod \n";
				consulta += "							   from equivalencias a, cargas_academicas b, secciones c, ofertas_academicas d, planes_estudio e, especialidades f, alumnos g, personas h \n";
				consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
				consulta += "								 and a.secc_ccod = b.secc_ccod \n";
				consulta += "								 and b.secc_ccod = c.secc_ccod \n";
				consulta += "								 and b.matr_ncorr = g.matr_ncorr \n";
				consulta += "								 and d.ofer_ncorr = g.ofer_ncorr \n";
				consulta += "								 and e.plan_ccod = g.plan_ccod \n";
				consulta += "								 and e.espe_ccod = f.espe_ccod \n";
				consulta += "								 and g.pers_ncorr = h.pers_ncorr \n";
				consulta += "								 and f.carr_ccod = '" + v_carr_ccod + "' \n";
				consulta += "								 and g.pers_ncorr in (" + v_lista_alumnos + ") \n";
				consulta += "							   union \n";
				consulta += "							   select distinct pers.pers_ncorr, hf.asig_ccod, sitf_ccod, carg_nnota_final, peri_ccod \n";
				consulta += "							   from homologacion_destino hd, homologacion_fuente hf, homologacion h, asignaturas asig, secciones secc, \n";
				consulta += "									(select b.secc_ccod, b.matr_ncorr, b.sitf_ccod, b.carg_nnota_final \n";
				consulta += "									 from (select c.asig_ccod, a.carr_ccod, b.plan_ccod, a.espe_ccod \n";
				consulta += "										   from especialidades a, planes_estudio b, malla_curricular c \n";
				consulta += "										   where a.espe_ccod = b.espe_ccod \n";
				consulta += "											 and b.plan_ccod = c.plan_ccod \n";
				consulta += "											 and  a.carr_ccod = '" + v_carr_ccod + "' \n";
				consulta += "											 and b.plan_ccod <> '" + v_plan_ccod + "' \n";
				consulta += "											 and a.espe_ccod <> '" + v_espe_ccod + "' \n";
				consulta += "										   ) a, \n";
				consulta += "										   (select d.asig_ccod, g.carr_ccod, f.plan_ccod, g.espe_ccod, a.carg_nnota_final, a.sitf_ccod, d.secc_ccod, a.matr_ncorr \n";
				consulta += "											from cargas_academicas a, personas b, alumnos c, secciones d, ofertas_academicas e, planes_estudio f, especialidades g \n";
				consulta += "											where b.pers_ncorr = c.pers_ncorr \n";
				consulta += "											  and c.pers_ncorr in (" + v_lista_alumnos + ") \n";
				consulta += "											  and a.matr_ncorr = c.matr_ncorr \n";
				consulta += "											  and a.secc_ccod = d.secc_ccod \n";
				consulta += "											  and c.ofer_ncorr = e.ofer_ncorr \n";
				consulta += "											  and c.plan_ccod = f.plan_ccod \n";
				consulta += "											  and f.espe_ccod = g.espe_ccod \n";
				consulta += "											  and d.carr_ccod = g.carr_ccod \n";
				consulta += "											  and a.sitf_ccod not in  ('EQ','EE') \n";
				consulta += "											  and g.carr_ccod = '" + v_carr_ccod + "' \n";
				consulta += "											  and f.plan_ccod <>'" + v_plan_ccod + "' \n";
				consulta += "											  and g.espe_ccod <> '" + v_espe_ccod + "' \n";
				consulta += "										   ) b \n";
				consulta += "									 where a.plan_ccod = b.plan_ccod \n";
				consulta += "									   and a.espe_ccod = b.espe_ccod \n";
				consulta += "									   and a.carr_ccod = b.carr_ccod \n";
				consulta += "									   and a.asig_ccod = b.asig_ccod) carg, \n";
				consulta += "alumnos al, personas pers \n";
				consulta += "							   where hd.homo_ccod = h.homo_ccod \n";
				consulta += "								 and hf.homo_ccod = h.homo_ccod \n";
				consulta += "								 and asig.asig_ccod = hd.asig_ccod \n";
                consulta += "								 and asig.asig_ccod = secc.asig_ccod \n";
				consulta += "								 and secc.secc_ccod = carg.secc_ccod \n";
				consulta += "and al.matr_ncorr = carg.matr_ncorr \n";
				consulta += "								 and pers.pers_ncorr = al.pers_ncorr \n";
				consulta += "and hd.asig_ccod <> hf.asig_ccod \n";
				consulta += "								 and sitf_ccod not in ('EQ','EE') \n";
				consulta += "								 and h.THOM_CCOD = 1 \n";
				consulta += "								 and pers.pers_ncorr in (" + v_lista_alumnos + ")) b, \n";
				consulta += "							  asignaturas asig, periodos_academicos pa, carreras ca \n";
				consulta += "						where a.asig_ccod = b.asig_ccod (+) \n";
				consulta += "						  and a.asig_ccod = asig.asig_ccod \n";
				consulta += "						  and pa.peri_ccod (+) = b.peri_ccod \n";
				consulta += "						  and ca.carr_ccod = a.carr_ccod \n";
				consulta += "						order by b.pers_ncorr, a.nasignatura asc) a, situaciones_finales b \n";
				consulta += "where a.sitf_ccod = b.sitf_ccod \n";
				consulta += "					 and b.sitf_baprueba = 1) a, \n";
				consulta += "				personas b, egresados c, periodos_academicos d, periodos_academicos e \n";
				consulta += "			where a.pers_ncorr = b.pers_ncorr \n";
				consulta += "			  and b.pers_ncorr = c.pers_ncorr \n";
				consulta += "			  and c.peri_ccod_ingreso = d.peri_ccod \n";
				consulta += "			  and c.peri_ccod = e.peri_ccod \n";
				consulta += "			  and c.pers_ncorr in (" + v_lista_alumnos + ") \n";
				consulta += "			group by a.pers_ncorr, b.pers_tape_paterno, b.pers_tape_materno, b.pers_tnombre, b.pers_nrut, b.pers_xdv, \n";
				consulta += "					 d.anos_ccod, d.plec_ccod, e.anos_ccod, e.plec_ccod \n";
				consulta += "			order by nombre asc) a \n";
			

				if (i1 != v_ngrupos_notas) 
				{
					consulta += "union \n";
				}

			}
				   
			consulta += ") ";
			consulta += "order by grupo asc, n asc";		

			
			return consulta;
		}*/


		private String FormarSqlNotasGrupo(int p_grupo)
		{			
			int v_nnota;
			String consulta;
			int i;	
			
			consulta = "";
			consulta += "      select rownum as n, a.* \n";
			consulta += "      from (select " + p_grupo.ToString() + " as grupo, a.pers_ncorr, \n";
			consulta += "	           b.pers_tape_paterno || ' ' || b.pers_tape_materno || ' ' || b.pers_tnombre as nombre, \n";
			consulta += "	           b.pers_nrut || '-' || b.pers_xdv as rut, \n";
			consulta += "		   d.anos_ccod || '/' || case when d.plec_ccod = 1 then 'O' when d.plec_ccod = 2 then 'P' end as periodo_ingreso, \n";
			consulta += "		   e.anos_ccod || '/' || case when e.plec_ccod = 1 then 'O' when e.plec_ccod = 2 then 'P' end as periodo_egreso, \n";

			for (i = 1; i <= v_nnotas_fila; i++) 
			{
				v_nnota = (v_nnotas_fila * (p_grupo - 1)) + i;

				consulta += "                   max(case when nasignatura = " + v_nnota.ToString() + " then case when sitf_ccod in ('CC', 'HO') then sitf_ccod else to_char(carg_nnota_final, '0.0') end end) as N" + i.ToString() + ", \n";
			}

			if (p_grupo != v_ngrupos_notas) 
			{
				consulta += "                    null as negreso \n";
			}
			else 
			{
				consulta += "                    to_char(nota_egreso(a.pers_ncorr, " + v_plan_ccod + "), '0.0') as negreso \n";
			}

			consulta += "            from (select a.* \n";
			consulta += "                  from (select b.pers_ncorr, a.nasignatura, a.nive_ccod, a.asig_ccod, asig.asig_tdesc, \n";
			consulta += "                               b.carg_nnota_final, \n";
			consulta += "							   b.sitf_ccod, b.peri_ccod \n";
			consulta += "						from (select rownum as nasignatura, a.* \n";
			consulta += "							  from (select ma.nive_ccod, asig_ccod, esp.carr_ccod \n";
			consulta += "									from especialidades esp, planes_estudio pl, malla_curricular ma \n";
			consulta += "									where esp.espe_ccod = pl.espe_ccod \n";
			consulta += "									  and pl.plan_ccod = ma.plan_ccod \n";
			consulta += "									  and pl.plan_ccod = '" + v_plan_ccod + "' \n";
			consulta += "									order by ma.nive_ccod asc, asig_ccod asc) a \n";
			consulta += "							  ) a, \n";
			consulta += "							  (select b.pers_ncorr, h.asig_ccod, a.sitf_ccod, a.carg_nnota_final, g.peri_ccod \n";
			consulta += "							   from cargas_academicas a, alumnos b, ofertas_academicas d, planes_estudio e, especialidades f, secciones g, asignaturas h \n";
			consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
			consulta += "								 and b.ofer_ncorr = d.ofer_ncorr \n";
			consulta += "								 and b.plan_ccod = e.plan_ccod \n";
			consulta += "								 and e.espe_ccod = f.espe_ccod \n";
			consulta += "								 and a.secc_ccod = g.secc_ccod \n";
			consulta += "								 and g.asig_ccod = h.asig_ccod \n";
			consulta += "								 and b.emat_ccod = 1 \n";
			consulta += "								 and b.pers_ncorr in (" + v_lista_alumnos + ") \n";
			consulta += "								 and f.carr_ccod = '" + v_carr_ccod + "' \n";
			consulta += "								 and a.sitf_ccod not in ('EE','EQ','NN') \n";
			consulta += "							   union \n";
			consulta += "							   select b.pers_ncorr, a.asig_ccod, sitf_ccod, \n";				
			consulta += "									  a.conv_nnota, e.peri_ccod \n";
			consulta += "							   from convalidaciones a, alumnos b, personas c, actas_convalidacion d, ofertas_academicas e, planes_estudio f, especialidades g \n";
			consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
			consulta += "								 and b.pers_ncorr = c.pers_ncorr \n";
			consulta += "								 and a.acon_ncorr = d.acon_ncorr \n";
			consulta += "								 and b.ofer_ncorr = e.ofer_ncorr \n";
			consulta += "								 and b.plan_ccod = f.plan_ccod \n";
			consulta += "								 and f.espe_ccod = g.espe_ccod \n";
			consulta += "								 and g.carr_ccod = '" + v_carr_ccod + "' \n";
			consulta += "								 and b.pers_ncorr in (" + v_lista_alumnos + " ) \n";
			consulta += "							   union \n";
			consulta += "							   select g.pers_ncorr, a.asig_ccod, b.sitf_ccod, b.carg_nnota_final, d.peri_ccod \n";
			consulta += "							   from equivalencias a, cargas_academicas b, secciones c, ofertas_academicas d, planes_estudio e, especialidades f, alumnos g, personas h \n";
			consulta += "							   where a.matr_ncorr = b.matr_ncorr \n";
			consulta += "								 and a.secc_ccod = b.secc_ccod \n";
			consulta += "								 and b.secc_ccod = c.secc_ccod \n";
			consulta += "								 and b.matr_ncorr = g.matr_ncorr \n";
			consulta += "								 and d.ofer_ncorr = g.ofer_ncorr \n";
			consulta += "								 and e.plan_ccod = g.plan_ccod \n";
			consulta += "								 and e.espe_ccod = f.espe_ccod \n";
			consulta += "								 and g.pers_ncorr = h.pers_ncorr \n";
			consulta += "								 and f.carr_ccod = '" + v_carr_ccod + "' \n";
			consulta += "								 and g.pers_ncorr in (" + v_lista_alumnos + ") \n";
			consulta += "							   union \n";
			consulta += "							   select distinct pers.pers_ncorr, hf.asig_ccod, sitf_ccod, carg_nnota_final, peri_ccod \n";
			consulta += "							   from homologacion_destino hd, homologacion_fuente hf, homologacion h, asignaturas asig, secciones secc, \n";
			consulta += "									(select b.secc_ccod, b.matr_ncorr, b.sitf_ccod, b.carg_nnota_final \n";
			consulta += "									 from (select c.asig_ccod, a.carr_ccod, b.plan_ccod, a.espe_ccod \n";
			consulta += "										   from especialidades a, planes_estudio b, malla_curricular c \n";
			consulta += "										   where a.espe_ccod = b.espe_ccod \n";
			consulta += "											 and b.plan_ccod = c.plan_ccod \n";
			consulta += "											 and  a.carr_ccod = '" + v_carr_ccod + "' \n";
			consulta += "											 and b.plan_ccod <> '" + v_plan_ccod + "' \n";
			consulta += "											 and a.espe_ccod <> '" + v_espe_ccod + "' \n";
			consulta += "										   ) a, \n";
			consulta += "										   (select d.asig_ccod, g.carr_ccod, f.plan_ccod, g.espe_ccod, a.carg_nnota_final, a.sitf_ccod, d.secc_ccod, a.matr_ncorr \n";
			consulta += "											from cargas_academicas a, personas b, alumnos c, secciones d, ofertas_academicas e, planes_estudio f, especialidades g \n";
			consulta += "											where b.pers_ncorr = c.pers_ncorr \n";
			consulta += "											  and c.pers_ncorr in (" + v_lista_alumnos + ") \n";
			consulta += "											  and a.matr_ncorr = c.matr_ncorr \n";
			consulta += "											  and a.secc_ccod = d.secc_ccod \n";
			consulta += "											  and c.ofer_ncorr = e.ofer_ncorr \n";
			consulta += "											  and c.plan_ccod = f.plan_ccod \n";
			consulta += "											  and f.espe_ccod = g.espe_ccod \n";
			consulta += "											  and d.carr_ccod = g.carr_ccod \n";
			consulta += "											  and a.sitf_ccod not in  ('EQ','EE') \n";
			consulta += "											  and g.carr_ccod = '" + v_carr_ccod + "' \n";
			consulta += "											  and f.plan_ccod <>'" + v_plan_ccod + "' \n";
			consulta += "											  and g.espe_ccod <> '" + v_espe_ccod + "' \n";
			consulta += "										   ) b \n";
			consulta += "									 where a.plan_ccod = b.plan_ccod \n";
			consulta += "									   and a.espe_ccod = b.espe_ccod \n";
			consulta += "									   and a.carr_ccod = b.carr_ccod \n";
			consulta += "									   and a.asig_ccod = b.asig_ccod) carg, \n";
			consulta += "alumnos al, personas pers \n";
			consulta += "							   where hd.homo_ccod = h.homo_ccod \n";
			consulta += "								 and hf.homo_ccod = h.homo_ccod \n";
			consulta += "								 and asig.asig_ccod = hd.asig_ccod \n";
			consulta += "								 and asig.asig_ccod = secc.asig_ccod \n";
			consulta += "								 and secc.secc_ccod = carg.secc_ccod \n";
			consulta += "and al.matr_ncorr = carg.matr_ncorr \n";
			consulta += "								 and pers.pers_ncorr = al.pers_ncorr \n";
			consulta += "and hd.asig_ccod <> hf.asig_ccod \n";
			consulta += "								 and sitf_ccod not in ('EQ','EE') \n";
			consulta += "								 and h.THOM_CCOD = 1 \n";
			consulta += "								 and pers.pers_ncorr in (" + v_lista_alumnos + ")) b, \n";
			consulta += "							  asignaturas asig, periodos_academicos pa, carreras ca \n";
			consulta += "						where a.asig_ccod = b.asig_ccod (+) \n";
			consulta += "						  and a.asig_ccod = asig.asig_ccod \n";
			consulta += "						  and pa.peri_ccod (+) = b.peri_ccod \n";
			consulta += "						  and ca.carr_ccod = a.carr_ccod \n";
			consulta += "						order by b.pers_ncorr, a.nasignatura asc) a, situaciones_finales b \n";
			consulta += "where a.sitf_ccod = b.sitf_ccod \n";
			consulta += "					 and b.sitf_baprueba = 'S') a, \n";
			consulta += "				personas b, egresados c, periodos_academicos d, periodos_academicos e \n";
			consulta += "			where a.pers_ncorr = b.pers_ncorr \n";
			consulta += "			  and b.pers_ncorr = c.pers_ncorr \n";
			consulta += "			  and c.peri_ccod_ingreso = d.peri_ccod \n";
			consulta += "			  and c.peri_ccod = e.peri_ccod \n";
			consulta += "			  and c.pers_ncorr in (" + v_lista_alumnos + ") \n";
			consulta += "			group by a.pers_ncorr, b.pers_tape_paterno, b.pers_tape_materno, b.pers_tnombre, b.pers_nrut, b.pers_xdv, \n";
			consulta += "					 d.anos_ccod, d.plec_ccod, e.anos_ccod, e.plec_ccod \n";
			consulta += "			order by nombre asc) a \n";
			return consulta;
		}



		private void LlenarDataSetNotas()
		{
			String consulta;
			int i;

			ObtenerDatosSqlNotas();			

			for (i = 1; i <= v_ngrupos_notas; i++) {
				consulta = this.FormarSqlNotasGrupo(i);				

				adpAlumnos.SelectCommand.CommandText = consulta;
				adpAlumnos.Fill(ds);
			}			
		}


		private void Page_Load(object sender, System.EventArgs e)
		{				
			v_aceg_ncorr = Request.Params["aceg_ncorr"];			


			if (v_aceg_ncorr != "") 
			{
				crActaEgreso rep = new crActaEgreso();

				conexion.Open();
	
				comDatos.Parameters["ACEG_NCORR"].Value = v_aceg_ncorr;

				OleDbDataReader dr = comDatos.ExecuteReader();
				if (dr.Read()) 
				{
					v_plan_ccod = dr["plan_ccod"].ToString();
					v_espe_ccod = dr["espe_ccod"].ToString();
					v_carr_ccod = dr["carr_ccod"].ToString();				
				}
				dr.Close();

				
				adpEncabezado.SelectCommand.Parameters["ACEG_NCORR"].Value = v_aceg_ncorr;
				adpEncabezado.Fill(ds);

				adpAsignaturas.SelectCommand.CommandText = FormarSqlAsignaturas();
				adpAsignaturas.Fill(ds);
			
				LlenarDataSetNotas();
			
				visor.Visible = false;
				conexion.Close();
					
			
				rep.SetDataSource(ds);			
				visor.ReportSource = rep;							
				ExportarPDF(rep);
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
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.conexion = new System.Data.OleDb.OleDbConnection();
			this.ds = new EgresoTitulacion.DataSet1();
			this.adpAlumnos = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.comDatos = new System.Data.OleDb.OleDbCommand();
			this.adpAsignaturas = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
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
																																																				  new System.Data.Common.DataColumnMapping("CARR_CCOD", "CARR_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("ACEG_NCORR", "ACEG_NCORR"),
																																																				  new System.Data.Common.DataColumnMapping("ACEG_FEMISION", "ACEG_FEMISION"),
																																																				  new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC"),
																																																				  new System.Data.Common.DataColumnMapping("NOM_JCURRICULAR", "NOM_JCURRICULAR"),
																																																				  new System.Data.Common.DataColumnMapping("NOM_JCARRERA", "NOM_JCARRERA"),
																																																				  new System.Data.Common.DataColumnMapping("NOM_JDOCENTE", "NOM_JDOCENTE"),
																																																				  new System.Data.Common.DataColumnMapping("NOM_DIRECTOR", "NOM_DIRECTOR"),
																																																				  new System.Data.Common.DataColumnMapping("NOM_CTITULOS", "NOM_CTITULOS"),
																																																				  new System.Data.Common.DataColumnMapping("ESPE_CCOD", "ESPE_CCOD"),
																																																				  new System.Data.Common.DataColumnMapping("CODIGO", "CODIGO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT F.INST_TRAZON_SOCIAL AS LINEA1, '' AS LINEA2, 'SEDE ' || ': ' || B.SEDE_TDESC || ' ; ' || B.SEDE_TCALLE || ' ' || B.SEDE_TNRO || ' - ' || C.CIUD_TDESC AS LINEA3, '' AS LINEA4, E.CARR_TDESC, E.CARR_CCOD, A.ACEG_NCORR, TO_CHAR(A.ACEG_FEMISION, 'dd/mm/yyyy') AS ACEG_FEMISION, D.ESPE_TDESC, B.SEDE_TREGISTR AS NOM_JCURRICULAR, '' AS NOM_JCARRERA, '' AS NOM_JDOCENTE, B.SEDE_SECRET AS NOM_DIRECTOR, '' AS NOM_CTITULOS, D.ESPE_CCOD, A.ESPE_CCOD || '-' || TO_CHAR(G.PLAN_NCORRELATIVO) AS CODIGO FROM ACTAS_EGRESOS A, SEDES B, CIUDADES C, ESPECIALIDADES D, CARRERAS E, INSTITUCIONES F, PLANES_ESTUDIO G WHERE A.SEDE_CCOD = B.SEDE_CCOD AND B.CIUD_CCOD = C.CIUD_CCOD AND A.ESPE_CCOD = D.ESPE_CCOD AND D.CARR_CCOD = E.CARR_CCOD AND E.INST_CCOD = F.INST_CCOD AND A.PLAN_CCOD = G.PLAN_CCOD AND (A.ACEG_NCORR = ?)";
			this.oleDbSelectCommand1.Connection = this.conexion;
			this.oleDbSelectCommand1.Parameters.Add(new System.Data.OleDb.OleDbParameter("ACEG_NCORR", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(10)), ((System.Byte)(0)), "ACEG_NCORR", System.Data.DataRowVersion.Current, null));
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadena_conexion", typeof(string))));
			// 
			// ds
			// 
			this.ds.DataSetName = "DataSet1";
			this.ds.Locale = new System.Globalization.CultureInfo("es-MX");
			this.ds.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// adpAlumnos
			// 
			this.adpAlumnos.SelectCommand = this.oleDbSelectCommand2;
			this.adpAlumnos.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								 new System.Data.Common.DataTableMapping("Table", "EGRESADOS", new System.Data.Common.DataColumnMapping[] {
																																																			  new System.Data.Common.DataColumnMapping("N", "N"),
																																																			  new System.Data.Common.DataColumnMapping("GRUPO", "GRUPO"),
																																																			  new System.Data.Common.DataColumnMapping("PERS_NCORR", "PERS_NCORR"),
																																																			  new System.Data.Common.DataColumnMapping("NOMBRE", "NOMBRE"),
																																																			  new System.Data.Common.DataColumnMapping("RUT", "RUT"),
																																																			  new System.Data.Common.DataColumnMapping("PERIODO_INGRESO", "PERIODO_INGRESO"),
																																																			  new System.Data.Common.DataColumnMapping("PERIODO_EGRESO", "PERIODO_EGRESO"),
																																																			  new System.Data.Common.DataColumnMapping("N1", "N1"),
																																																			  new System.Data.Common.DataColumnMapping("N2", "N2"),
																																																			  new System.Data.Common.DataColumnMapping("N3", "N3"),
																																																			  new System.Data.Common.DataColumnMapping("N4", "N4"),
																																																			  new System.Data.Common.DataColumnMapping("N5", "N5"),
																																																			  new System.Data.Common.DataColumnMapping("N6", "N6"),
																																																			  new System.Data.Common.DataColumnMapping("N7", "N7"),
																																																			  new System.Data.Common.DataColumnMapping("N8", "N8"),
																																																			  new System.Data.Common.DataColumnMapping("N9", "N9"),
																																																			  new System.Data.Common.DataColumnMapping("N10", "N10"),
																																																			  new System.Data.Common.DataColumnMapping("N11", "N11"),
																																																			  new System.Data.Common.DataColumnMapping("N12", "N12"),
																																																			  new System.Data.Common.DataColumnMapping("N13", "N13"),
																																																			  new System.Data.Common.DataColumnMapping("N14", "N14"),
																																																			  new System.Data.Common.DataColumnMapping("N15", "N15"),
																																																			  new System.Data.Common.DataColumnMapping("N16", "N16"),
																																																			  new System.Data.Common.DataColumnMapping("N17", "N17"),
																																																			  new System.Data.Common.DataColumnMapping("N18", "N18"),
																																																			  new System.Data.Common.DataColumnMapping("N19", "N19"),
																																																			  new System.Data.Common.DataColumnMapping("N20", "N20"),
																																																			  new System.Data.Common.DataColumnMapping("N21", "N21"),
																																																			  new System.Data.Common.DataColumnMapping("N22", "N22"),
																																																			  new System.Data.Common.DataColumnMapping("N23", "N23"),
																																																			  new System.Data.Common.DataColumnMapping("N24", "N24"),
																																																			  new System.Data.Common.DataColumnMapping("N25", "N25"),
																																																			  new System.Data.Common.DataColumnMapping("NEGRESO", "NEGRESO")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = @"SELECT 1 AS N, 1 AS GRUPO, 143815 AS PERS_NCORR, 'CUBILLOS GUZMAN JUAN CARLOS' AS NOMBRE, '9603176-9' AS RUT, '1997/O' AS PERIODO_INGRESO, '2002/P' AS PERIODO_EGRESO, '6.0' AS N1, '6.0' AS N2, '6.0' AS N3, '6.0' AS N4, '6.0' AS N5, '6.0' AS N6, '6.0' AS N7, '6.0' AS N8, '6.0' AS N9, '6.0' AS N10, '6.0' AS N11, '6.0' AS N12, '6.0' AS N13, '6.0' AS N14, '6.0' AS N15, '6.0' AS N16, '6.0' AS N17, '6.0' AS N18, '6.0' AS N19, '6.0' AS N20, '6.0' AS N21, '6.0' AS N22, '6.0' AS N23, '6.0' AS N24, '6.0' AS N25, '6.0' AS NEGRESO FROM DUAL";
			this.oleDbSelectCommand2.Connection = this.conexion;
			// 
			// comDatos
			// 
			this.comDatos.CommandText = "SELECT B.PLAN_CCOD, C.ESPE_CCOD, C.CARR_CCOD FROM ACTAS_EGRESOS A, PLANES_ESTUDIO" +
				" B, ESPECIALIDADES C WHERE A.PLAN_CCOD = B.PLAN_CCOD AND B.ESPE_CCOD = C.ESPE_CC" +
				"OD AND (A.ACEG_NCORR = ?)";
			this.comDatos.Connection = this.conexion;
			this.comDatos.Parameters.Add(new System.Data.OleDb.OleDbParameter("ACEG_NCORR", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(10)), ((System.Byte)(0)), "ACEG_NCORR", System.Data.DataRowVersion.Current, null));
			// 
			// adpAsignaturas
			// 
			this.adpAsignaturas.SelectCommand = this.oleDbSelectCommand3;
			this.adpAsignaturas.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																									 new System.Data.Common.DataTableMapping("Table", "ASIGNATURAS", new System.Data.Common.DataColumnMapping[] {
																																																					new System.Data.Common.DataColumnMapping("GRUPO", "GRUPO"),
																																																					new System.Data.Common.DataColumnMapping("NASIGNATURA", "NASIGNATURA"),
																																																					new System.Data.Common.DataColumnMapping("COD_ASIGNATURA", "COD_ASIGNATURA"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_CCOD", "ASIG_CCOD"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_TDESC", "ASIG_TDESC"),
																																																					new System.Data.Common.DataColumnMapping("ASIG_NHORAS", "ASIG_NHORAS")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT 1 AS GRUPO, 1 AS NASIGNATURA, \'011\' AS COD_ASIGNATURA, B.ASIG_CCOD, B.ASIG" +
				"_TDESC, B.ASIG_NHORAS FROM MALLA_CURRICULAR A, ASIGNATURAS B WHERE A.ASIG_CCOD =" +
				" B.ASIG_CCOD AND (A.PLAN_CCOD = ?) ORDER BY A.NIVE_CCOD, B.ASIG_CCOD";
			this.oleDbSelectCommand3.Connection = this.conexion;
			this.oleDbSelectCommand3.Parameters.Add(new System.Data.OleDb.OleDbParameter("PLAN_CCOD", System.Data.OleDb.OleDbType.Decimal, 0, System.Data.ParameterDirection.Input, false, ((System.Byte)(3)), ((System.Byte)(0)), "PLAN_CCOD", System.Data.DataRowVersion.Current, null));
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion
	}
}
