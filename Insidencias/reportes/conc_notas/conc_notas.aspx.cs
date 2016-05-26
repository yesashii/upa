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
using System.Data.OleDb;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace conc_notas
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter adpDetalle;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected conc_notas.DataSet1 ds;
		protected System.Data.OleDb.OleDbDataAdapter adpEncabezado;
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



		private string ObtenerSqlNotas(string p_pers_nrut)
		{
			string sql;
			OleDbCommand comando = new OleDbCommand();

			comando.Connection = conexion;
			//comando.CommandText = "select obtener_sql_notas('" + p_pers_nrut + "') from dual";
			comando.CommandText = "select protic.obtener_sql_notas_nuevo('" + p_pers_nrut + "')";

			OleDbDataReader dr = comando.ExecuteReader();
			dr.Read();
			sql = dr.GetString(0);
			dr.Close();

			return sql;
		}


		private string SqlDetalle(string p_pers_nrut, string p_peri_ccod, string p_solo_aprobadas, string p_plan_ccod,string carrera)
		{
			string sql;
			string sql_notas;

			/*sql_notas = ObtenerSqlNotas(p_pers_nrut);
            
			sql =       " select tabla3.T,tabla2.asig_ccod,tabla2.asig_tdesc,tabla3.carg_nnota_final,tabla2.peri_ccod,tabla3.anos_ccod,tabla3.plec_ccod,tabla3.sitf_ccod, \n";
            sql = sql + " tabla3.sitf_baprueba,tabla3.nota_final,tabla3.ano_cursado,tabla3.periodo,tabla3.estado,tabla3.p1, tabla3.p2,cast(tabla2.cantidad as varchar) +'ª Vez' as cantidad \n ";
            sql = sql + " from \n ";
            sql = sql + "    ( \n ";
            sql = sql + " select * from ( \n ";
            sql = sql + "				 select asig_ccod,asig_tdesc, \n";
            sql = sql + "                case sitf_baprueba when 'N' then (select top 1 rtrim(ltrim(cast(ca.carg_nnota_final as decimal(2,1)))) from alumnos alu, cargas_academicas ca, secciones se \n ";
            sql = sql + "                                                  where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod \n";
            sql = sql + "                                                  and se.asig_ccod=tabla1.asig_ccod) \n";
            sql = sql + "                else nota_final end as nota_final, \n";
            sql = sql + "                case sitf_baprueba when 'N' then (select top 1 se.peri_ccod from alumnos alu, cargas_academicas ca, secciones se \n";
            sql = sql + "                                                  where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod \n";
            sql = sql + "                                                  and se.asig_ccod= tabla1.asig_ccod order by se.peri_ccod desc) \n";
            sql = sql + "                else peri_ccod end as peri_ccod, \n ";
            sql = sql + "                case sitf_baprueba when 'N' then (select count(*) from alumnos alu, cargas_academicas ca, secciones se \n";
            sql = sql + "                                                  where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod \n";
            sql = sql + "                                                  and se.asig_ccod= tabla1.asig_ccod) \n";
            sql = sql + "                else 1 end as cantidad \n ";
			sql = sql + "		  		 from          \n ";
			sql = sql + "                    (          \n ";
			sql = sql + "                     SELECT distinct a.pers_ncorr,cast(b.asig_nhoras as numeric(4)) as T,a.asig_ccod, b.asig_tdesc AS asig_tdesc, \n";
			sql = sql + "                     a.carg_nnota_final, c.peri_ccod, c.anos_ccod, c.plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, \n";
			sql = sql + "                     LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal (2, 1))AS varchar))) AS nota_final, \n";
			sql = sql + "                     SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, \n"; 
			sql = sql + "                     SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, \n";
			sql = sql + "                     cast(c.anos_ccod as varchar)+ ' '+ case c.plec_ccod when 1 then '01' when 2 then '02' when 3 then '03' when 4 then '04' end  as ano_cursado, g.duas_tdesc as periodo, \n";
			sql = sql + "                     case isnull(cast(a.carg_nnota_final as varchar),'-') when '-' then case sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' end  else '' end as estado \n";
			sql = sql + "            FROM ( \n";
			sql = sql +                    sql_notas + " \n ";	 
			sql = sql + "                  ) a join  asignaturas b   \n";
			sql = sql + "        				on a.asig_ccod = b.asig_ccod \n";
			sql = sql +	"					 join periodos_academicos c \n";
			sql = sql +	"						on a.peri_ccod = c.peri_ccod \n";
			sql = sql +	"					 join  duracion_asignatura g \n";
			sql = sql +	" 						on b.duas_ccod = g.duas_ccod \n";
			sql = sql +	"		     WHERE  sitf_ccod <> '' and isnull(clas_ccod,1)= 2 \n";

			if (p_solo_aprobadas !="")
			{
				sql = sql + "  AND a.sitf_baprueba =  '" + p_solo_aprobadas + "' \n";
			}

			if ((p_peri_ccod !="") && (p_peri_ccod !="1"))
			{
				sql = sql + "  AND cast(a.peri_ccod as varchar) =  '" + p_peri_ccod + "' \n";
			}

			sql = sql + " AND sitf_ccod <> '' \n";
			if (carrera !="" )
			{
				sql = sql + " and cast(a.plan_ccod as varchar) = '" + carrera + "' \n";
			}
			sql = sql + ") as tabla1 ) as tabla_alfa  \n";
            sql = sql + " UNION ALL  \n";
            sql = sql + " select * from (  \n";
			sql = sql + " 	 select asig_ccod,asig_tdesc,max(nota_final) as nota_final,max(peri_ccod) as peri_ccod,count(*) as cantidad \n ";
            sql = sql + "      from          \n ";
            sql = sql + "          (          \n ";
            sql = sql + "            SELECT distinct cast(b.asig_nhoras as numeric(4)) as T,a.asig_ccod, b.asig_tdesc AS asig_tdesc, \n";
			sql = sql + "            a.carg_nnota_final, c.peri_ccod, c.anos_ccod, c.plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, \n";
			sql = sql + "            LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal (2, 1))AS varchar))) AS nota_final, \n";
			sql = sql + "            SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, \n"; 
			sql = sql + "            SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, \n";
			sql = sql + "            cast(c.anos_ccod as varchar)+ ' '+ case c.plec_ccod when 1 then '01' when 2 then '02' when 3 then '03' when 4 then '04' end  as ano_cursado, g.duas_tdesc as periodo, \n";
            sql = sql + "            case isnull(cast(a.carg_nnota_final as varchar),'-') when '-' then case sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' end  else '' end as estado \n";
			sql = sql + "            FROM ( \n";
			sql = sql +                    sql_notas + " \n ";	 
			sql = sql + "                  ) a join  asignaturas b   \n";
            sql = sql + "        				on a.asig_ccod = b.asig_ccod \n";
			sql = sql +	"					 join periodos_academicos c \n";
			sql = sql +	"						on a.peri_ccod = c.peri_ccod \n";
			sql = sql +	"					 join  duracion_asignatura g \n";
			sql = sql +	" 						on b.duas_ccod = g.duas_ccod \n";
			sql = sql +	"		     WHERE  sitf_ccod <> '' and isnull(clas_ccod,1)<> 2  \n";

			if (p_solo_aprobadas !="")
			{
				sql = sql + "  AND a.sitf_baprueba =  '" + p_solo_aprobadas + "' \n";
			}

			if ((p_peri_ccod !="") && (p_peri_ccod !="1"))
			{
				sql = sql + "  AND cast(a.peri_ccod as varchar) =  '" + p_peri_ccod + "' \n";
			}

			sql = sql + " AND sitf_ccod <> '' \n";
			if (carrera !="" )
			{
				sql = sql + " and cast(a.plan_ccod as varchar) = '" + carrera + "' \n";
			}
            sql = sql + ") as tabla1   \n";
			sql = sql +	" group by asig_ccod,asig_tdesc ) as tabla_beta ) as tabla2 ,\n";
			sql = sql + "          (          \n ";
			sql = sql + "            SELECT distinct cast(b.asig_nhoras as numeric(4)) as T,a.asig_ccod, b.asig_tdesc AS asig_tdesc, \n";
			sql = sql + "            a.carg_nnota_final, c.peri_ccod, c.anos_ccod, c.plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, \n";
			sql = sql + "            LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal (2, 1))AS varchar))) AS nota_final, \n";
			sql = sql + "            SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, \n"; 
			sql = sql + "            SUBSTRING(LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.carg_nnota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, \n";
			sql = sql + "            cast(c.anos_ccod as varchar)+ ' '+ case c.plec_ccod when 1 then '01' when 2 then '02' when 3 then '03' when 4 then '04' end  as ano_cursado, g.duas_tdesc as periodo, \n";
			sql = sql + "            case isnull(cast(a.carg_nnota_final as varchar),'-') when '-' then case sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'HM' then 'C' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' end  else '' end as estado \n";
			sql = sql + "            FROM ( \n";
			sql = sql +                    sql_notas + " \n ";	 
			sql = sql + "                  ) a join  asignaturas b   \n";
			sql = sql + "        				on a.asig_ccod = b.asig_ccod \n";
			sql = sql +	"					 join periodos_academicos c \n";
			sql = sql +	"						on a.peri_ccod = c.peri_ccod \n";
			sql = sql +	"					 join  duracion_asignatura g \n";
			sql = sql +	" 						on b.duas_ccod = g.duas_ccod \n";
			sql = sql +	"		     WHERE  sitf_ccod <> '' \n";

			if (p_solo_aprobadas !="")
			{
				sql = sql + "  AND a.sitf_baprueba =  '" + p_solo_aprobadas + "' \n";
			}

			if ((p_peri_ccod !="") && (p_peri_ccod !="1"))
			{
				sql = sql + "  AND cast(a.peri_ccod as varchar) =  '" + p_peri_ccod + "' \n";
			}

			sql = sql + " AND sitf_ccod <> '' \n";
			if (carrera !="" )
			{
				sql = sql + " and cast(a.plan_ccod as varchar) = '" + carrera + "' \n";
			}
            sql = sql + ") as tabla3 \n";
            sql = sql + "     where tabla2.asig_ccod = tabla3.asig_ccod \n";
			sql = sql + "     and tabla2.asig_tdesc = tabla3.asig_tdesc \n";
			sql = sql + "     and tabla2.peri_ccod = tabla3.peri_ccod \n";
			sql = sql + "     --and isnull(tabla2.nota_final,1) = isnull(tabla3.nota_final,1) \n";
            sql = sql + " ORDER BY tabla2.peri_ccod ASC, tabla2.asig_tdesc ASC \n";*/

			sql = " select cast(horas as numeric(4)) as T,a.asig_ccod,b.asig_tdesc,case when c.sitf_ccod <> 'RI' then nota_final else NULL end as carg_nnota_final,anos_ccod as peri_ccod,\n";
			sql = sql + " anos_ccod,plec_ccod,c.sitf_ccod,c.sitf_baprueba,nota_final,anos_ccod as ano_cursado,plec_ccod as periodo, \n";
			sql = sql + " case when c.sitf_ccod <> 'RI' then case isnull(cast(nota_final as varchar),'-') when '-' then case c.sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' when 'RI' then 'RI' end  else '' end else 'RI' end as estado, \n";
			sql = sql + " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, \n";
			sql = sql + " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, \n";
			sql = sql + " cantidad \n";
			sql = sql + " from concentracion_notas a, asignaturas b,situaciones_finales c \n";
			sql = sql + " where a.asig_ccod=b.asig_ccod \n";
			sql = sql + " and case a.sitf_ccod when 'HM' then 'H' else a.sitf_ccod end = c.sitf_ccod \n";
			sql = sql + " and a.pers_ncorr in (select pers_ncorr from personas where cast(pers_nrut as varchar)='" + p_pers_nrut + "')\n";
			sql = sql + " and cast(plan_ccod as varchar)='" + p_plan_ccod + "' \n";
			sql = sql + " order by peri_ccod asc,b.asig_tdesc asc  \n";

			//Response.Write("Sql superior:<hr>"+sql+"<hr>");
			//Response.Flush();
			return sql;
		}



		private string SqlEncabezado(string p_pers_nrut, string p_peri_ccod, string p_sede_ccod, string p_tdes_ccod, string p_pperiodo, string carrera)
		{
			string sql;
			string filtro_plan;
			if (carrera!="")
			{
				filtro_plan = " and pn.plan_ccod='"+carrera+"'";
			}
			else
			{
				filtro_plan = "";
			}

			/*sql = " select obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre, \n";
			sql = sql +  "        obtener_nombre_carrera(b.ofer_ncorr) as carrera_bak, ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, e.duas_tdesc, \n";
			sql = sql +  " 	   f.sede_secret, f.sede_tregistr, g.desc_periodo, g.peri_ccod, decode(g.peri_ccod, 'N', 'N', 'S') as por_periodo, decode(g.peri_ccod, 'N', 'Certificado de Concentración de Notas', 'Concentración de Notas por Período') as titulo, initcap(f.sede_tdesc) as sede, g.tdes_tdesc, d.espe_tcertific as carrera \n";
			sql = sql +  " from personas a, alumnos b, ofertas_academicas c, especialidades d, duracion_asignatura e, \n";
			sql = sql +  "      sedes f, tipos_descripciones g, \n";
			sql = sql +  " 	 (select 'N' as peri_ccod, '' as desc_periodo from dual union \n";
			sql = sql +  " 	  select to_char(peri_ccod) as peri_ccod, anos_ccod || ' - ' || plec_ccod from periodos_academicos where peri_ccod = '" + p_peri_ccod + "') g \n";
			sql = sql +  " where a.pers_ncorr = b.pers_ncorr   \n";
			sql = sql +  "   and b.ofer_ncorr = c.ofer_ncorr \n";
			sql = sql +  "   and c.espe_ccod = d.espe_ccod \n";
			sql = sql +  "   and nvl(d.duas_ccod, 1) = e.duas_ccod   \n";
			sql = sql +  "   and b.emat_ccod <> 9 \n";
			sql = sql +  "   and b.ofer_ncorr = ultima_oferta_matriculado(a.pers_ncorr) \n";
			sql = sql +  "   and nvl('" + p_peri_ccod + "', 'N') = g.peri_ccod \n";
			sql = sql +  "   and g.tdes_ccod = '" + p_tdes_ccod + "' \n";
			sql = sql +  "   and f.sede_ccod = '" + p_sede_ccod + "' \n";
			sql = sql +  "   and a.pers_nrut = '" + p_pers_nrut + "' \n";*/

			sql = " select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n')+ ',' as nombre, \n";
            //sql = sql +  "--------------notas alumno\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else 'Promedio Calificaciones Finales de la Carrera' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+")as concepto_notas,\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else ' :    ' + cast(calificacion_notas as varchar) + '    *    ' + cast(porcentaje_notas as varchar)+ ' %' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+")as calculo_notas,\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_notas,0) *  isnull(porcentaje_notas,0))/100) as decimal (5,2)) as varchar) end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+")as resultado_notas,                                 \n";
			//sql = sql +  "---------------examen de título \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else 'Calificación Examen de Título' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as concepto_tesis,\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else ' :    ' + cast(calificacion_tesis as varchar) + '    *    ' + cast(porcentaje_tesis as varchar)+ ' %' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as calculo_tesis,                                                  \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_tesis,0) *  isnull(porcentaje_tesis,0))/100) as decimal (5,2)) as varchar) end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as resultado_tesis,                                       \n";
			//sql = sql +  "---------------Práctica Profesional \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else 'Calificación Práctica Profesional' end\n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as concepto_practica,\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else ' :    ' + cast(calificacion_practica as varchar) + '    *    ' + cast(porcentaje_practica as varchar)+ ' %' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as calculo_practica,                                                         \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_practica,0) *  isnull(porcentaje_practica,0))/100) as decimal (5,2))as varchar) end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as resultado_practica,                                                              \n";
			
			//sql = sql +  "---------------Nota de tesis \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else 'Calificación de Tesis' end\n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as concepto_nota_tesis,\n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else ' :    ' + cast(nota_tesis as varchar) + '    *    ' + cast(porcentaje_nota_tesis as varchar)+ ' %' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as calculo_nota_tesis,                                                         \n";
			sql = sql +  "(select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else '=      ' + cast(cast(((isnull(nota_tesis,0) *  isnull(porcentaje_nota_tesis,0))/100) as decimal (5,2))as varchar) end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as resultado_nota_tesis,                                                              \n";
			
			//sql = sql +  "---------------Nota final\n";
			sql = sql +  "(select top 1 case isnull(promedio_final,0)  when  0 then '' else 'Promedio Final de Titulación' end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as concepto_final,\n";
			sql = sql +  "(select top 1 case isnull(promedio_final,0)  when  0 then '' else ' :    ' + cast(promedio_final as varchar) end \n";
			sql = sql +  "from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr "+filtro_plan+") as nota_final,\n";
			sql = sql +  "  \n";
			sql = sql +  "     protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, \n";
			sql = sql +  " 	   f.sede_secret, f.sede_tregistr, gg.desc_periodo, gg.peri_ccod, case gg.peri_ccod when 'N' then 'N' else 'S' end as por_periodo, 'CERTIFICADO' as titulo, protic.initcap(f.sede_tdesc) as sede,case c.jorn_ccod when 1 then 'Diurno' when '2' then 'Vespertino' end as jornada, \n";
			if ((p_peri_ccod !="" ) && (p_peri_ccod !="1"))
			{
				//sql = sql +  "     case protic.es_alumno(" + p_pers_nrut + "," + p_peri_ccod + ") when 1 then 'es' else 'fue' end as duas_tdesc, \n";
				if (carrera!="")
				{
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + "," + p_peri_ccod + ",'" + carrera + "',1) as CARRERA, \n";
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + "," + p_peri_ccod + ",'" + carrera + "',2) as DUAS_TDESC, \n";
				}
				else
				{
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + "," + p_peri_ccod + ",'0',1) as CARRERA, \n";
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + "," + p_peri_ccod + ",'0',2) as DUAS_TDESC, \n";
				}
			}
			else
			{
				//sql = sql +  "     case protic.es_alumno(" + p_pers_nrut + ",204) when 1 then 'es' else 'fue' end as duas_tdesc, \n";
				if (carrera!="")
				{
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + ",214,'" + carrera + "',1) as CARRERA, \n";
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + ",214,'" + carrera + "',2) as DUAS_TDESC, \n";
				}
				else
				{
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + ",214,'0',1) as CARRERA, \n";
					sql = sql +  "     protic.es_alumno_nueva_version(" + p_pers_nrut + ",214,'0',2) as DUAS_TDESC, \n";
				}
			}
			sql = sql +  " case '" + p_tdes_ccod + "' when '' then ', para los fines que estime conveniente.'\n";
			sql = sql +  " when '3' then ', para los fines que estime conveniente.'\n";
			sql = sql +  " when '1' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '4' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '5' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '9' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '10' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '11' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '12' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '13' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '6' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '7' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '8' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '14' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '18' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '16' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '15' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '17' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' \n";
			sql = sql +  " when '2' then ',  a petición del (la) interesado(a) para ser presentado en Cantón de Reclutamiento.' \n";
			sql = sql +  " end as tdes_tdesc \n";
			sql = sql +  " from personas a, alumnos b, ofertas_academicas c, especialidades d,carreras car, \n";
			sql = sql +  "      sedes f, tipos_descripciones g,planes_estudio pl, \n";
			sql = sql +  " 	 (select 'N' as peri_ccod, '' as desc_periodo union \n";
			if ((p_peri_ccod !="" ) && (p_peri_ccod !="1"))
			{ 
				sql = sql +  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '" + p_peri_ccod + "') gg \n";
			}
			else
			{ 
				sql = sql +  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '214') gg \n";
			}

			sql = sql +  " where a.pers_ncorr = b.pers_ncorr   \n";
			sql = sql +  "   and b.ofer_ncorr = c.ofer_ncorr \n";
			sql = sql +  "   and c.espe_ccod = d.espe_ccod and b.plan_ccod = pl.plan_ccod \n";
			sql = sql +  "   and d.carr_ccod = car.carr_ccod \n";
			sql = sql +  "   and b.emat_ccod <> 9 \n";
			if (carrera!="")
			{ 
				sql = sql + " and cast(pl.plan_ccod as varchar)='" + carrera + "' \n";
			}
			else
			{
				sql = sql + " and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) \n";
            }
			sql = sql +  "  \n";
			if ((p_peri_ccod !="" ) && (p_peri_ccod !="1"))
			{
				sql = sql +  "   and isnull('" + p_peri_ccod + "', 'N') = gg.peri_ccod \n";
			}
			else
			{
				sql = sql +  "   and isnull('214', 'N') = gg.peri_ccod \n";
			}
			sql = sql +  "   and c.sede_ccod = f.sede_ccod \n";
			sql = sql +  "   and cast(g.tdes_ccod as varchar)= '" + p_tdes_ccod + "' \n";
			sql = sql +  "   and cast(a.pers_nrut as varchar)= '" + p_pers_nrut + "' \n";
			sql = sql +  "   order by b.alum_fmatricula desc \n";

			//Response.Write("<hr>Sql inferior:"+sql+"<hr>");
			//Response.Flush();
			return sql;
		}
	

		private void Page_Load(object sender, System.EventArgs e)
		{
			// Introducir aquí el código de usuario para inicializar la página					
			string q_pers_nrut = Request.Form["p[0][pers_nrut]"];
			string q_peri_ccod =Request.Form["p[0][peri_ccod]"];
			string q_solo_aprobadas = Request.Form["p[0][solo_aprobadas]"];
			string q_plan_ccod = Request.Form["p[0][plan_ccod]"];
			string q_sede_ccod =Request.Form["p[0][sede_ccod]"];
			string q_tdes_ccod =Request.Form["p[0][tdes_ccod]"];
			string q_agrupar_periodo = Request.Form["p[0][agrupar_periodo]"];
			string q_carrera =Request.Form["p[0][carrera]"];
			string titulado = Request.QueryString["titulado"];

			
			
			/*else
            {
				crConcentracionNotas rep = new crConcentracionNotas();
			}*/
			
			//crConcentracionNotas rep = new crConcentracionNotas();

			conexion.Open();

			adpDetalle.SelectCommand.CommandText = SqlDetalle(q_pers_nrut, q_peri_ccod, q_solo_aprobadas, q_plan_ccod,q_carrera);
			//Response.Write(adpDetalle.SelectCommand.CommandText);
			//Response.End();

			adpDetalle.Fill(ds);

			adpEncabezado.SelectCommand.CommandText = SqlEncabezado(q_pers_nrut, q_peri_ccod, q_sede_ccod, q_tdes_ccod, q_agrupar_periodo,q_carrera);
			adpEncabezado.Fill(ds);

			if (titulado != "SI")
			{
				crConcentracionNotas rep = new crConcentracionNotas();
				rep.SetDataSource(ds);
				ExportarPDF(rep);
			}
			else
			{
				crConcentracionTitulados rep2 = new crConcentracionTitulados();
				rep2.SetDataSource(ds);
				ExportarPDF(rep2);

			}			

			conexion.Close();
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
			this.ds = new conc_notas.DataSet1();
			this.adpEncabezado = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			((System.ComponentModel.ISupportInitialize)(this.ds)).BeginInit();
			// 
			// adpDetalle
			// 
			this.adpDetalle.SelectCommand = this.oleDbSelectCommand1;
			this.adpDetalle.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																								 new System.Data.Common.DataTableMapping("Table", "DETALLE", new System.Data.Common.DataColumnMapping[] {
																																																			new System.Data.Common.DataColumnMapping("T", "T")})});
			this.adpDetalle.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.adpDetalle_RowUpdated);
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = "SELECT 0 AS T FROM DUAL";
			this.oleDbSelectCommand1.Connection = this.conexion;
			// 
			// conexion
			// 
			this.conexion.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			this.conexion.InfoMessage += new System.Data.OleDb.OleDbInfoMessageEventHandler(this.conexion_InfoMessage);
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
																																																				  new System.Data.Common.DataColumnMapping("T", "T")})});
			this.adpEncabezado.RowUpdated += new System.Data.OleDb.OleDbRowUpdatedEventHandler(this.adpEncabezado_RowUpdated);
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = "SELECT 0 AS T FROM DUAL";
			this.oleDbSelectCommand2.Connection = this.conexion;
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.ds)).EndInit();

		}
		#endregion

		private void adpDetalle_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void adpEncabezado_RowUpdated(object sender, System.Data.OleDb.OleDbRowUpdatedEventArgs e)
		{
		
		}

		private void conexion_InfoMessage(object sender, System.Data.OleDb.OleDbInfoMessageEventArgs e)
		{
		
		}
	}
}
