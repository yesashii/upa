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

namespace CartaGuia
{
	/// <summary>
	/// Descripción breve de WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter1;
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		protected CartaGuia.DataSet1 dataSet11;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter2;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand2;
		protected CartaGuia.DataSet2 dataSet21;
		protected System.Data.OleDb.OleDbDataAdapter oleDbDataAdapter3;
		protected CartaGuia.DataSet3 dataSet31;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand3;
		protected System.Data.OleDb.OleDbCommand oleDbSelectCommand1;
		protected System.Data.OleDb.OleDbConnection oleDbConnection1;
	
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
		
		private string Filtrar_Carta_Guia()
		{   // esta funcion procesa el formulario con los datos de cual carta guia imprimir
			// retorna la lista con los rut de los alumnos...
			string carta, alumno, rut_alumno = "", apoderado, rut_apoderado = "";
			string rut_alumnos = "";
			int fila = 0;			  
			//Response.Write(Request.Form.Count);
			//Response.Flush();
			for (int i = 0; i < Request.Form.Count; i++)
			{
				//Response.Write("<br>Obteniendo alumno: " + Request.Form.GetKey(i) + " : " + Request.Form[i]);
				//Response.Flush();
				
				carta = "detalle_agrupado[" + fila + "][carta]";
				alumno = "detalle_agrupado[" + fila + "][r_alumno]";
				apoderado = "detalle_agrupado[" + fila + "][r_apoderado]";			  			  
			 
				if (Request.Form.GetKey(i) == alumno)  
					//Response.Write("<br>"+Request.Form.GetKey(i)+" =="+ alumno+"<br>");
					rut_alumno = Request.Form[i];
				if (Request.Form.GetKey(i) == apoderado)
					rut_apoderado = Request.Form[i];
			  
				if ((Request.Form.GetKey(i) == carta) && (Request.Form[i] == "1"))
				{  // si encuentra la variable carta con el valor 1					
					rut_alumnos = rut_alumnos + "'" + rut_alumno + "',";
					
					//Response.Write("<br>"+rut_alumnos+"->"+Request.Form.GetKey(i)+" =="+ carta+"<br>");
					//Response.Flush();
					
				}				  
			  
				if (Request.Form.GetKey(i) == carta)
					fila++;			  
			}
			//rut_alumnos = rut_alumnos + "''";
		    rut_alumnos = rut_alumnos+ "'0'";	     		    
			return(rut_alumnos);
		}
		
		private string Crear_Consulta_Carta_Guia_Ant(string envio, string periodo, string alumnos, string todos)
		{
			string sql;			

			sql = "SELECT A.ENVI_NCORR, A.ENVI_FENVIO, A.INEN_CCOD, B.INEN_TDESC, A.PLAZ_CCOD, C.PLAZ_TDESC, "; 
			sql = sql +     "nvl(numero_compromiso (e.ingr_ncorr,e.ting_ccod, e.ding_ndocto),'0') as numero_compromiso, "; 
            sql = sql +     "nvl(total_documentos(e.ingr_ncorr,e.ting_ccod, e.ding_ndocto),'0') as total_documentos, ";
			sql = sql +		"obtener_rut(G.PERS_NCORR) AS RUT_ALUMNO, j.pers_nrut, ";  
			sql = sql +		"obtener_nombre_completo(J.PERS_NCORR, 'PMN') AS NOMBRE_APODERADO, "; 
			sql = sql +		"obtener_rut(J.PERS_NCORR) AS RUT_APODERADO, K.DIRE_TCALLE || ' ' || K.DIRE_TNRO AS DIRECCION, "; 
			sql = sql +		"E.DING_FDOCTO, E.DING_MDETALLE, E.DING_NDOCTO, E.INGR_NCORR, E.TING_CCOD, M.CCTE_TTIPO,  "; 
			sql = sql +		"M.CCTE_TDESC, M.CCTE_TREFERENCIA, N.SEDE_TCALLE, N.SEDE_TNRO, B.INEN_CCOD AS EXPR1, f.ingr_fpago, "; 
			sql = sql +		"C.PLAZ_CCOD AS EXPR2, M.CCTE_CCOD,N.SEDE_CCOD, q.ciud_tdesc, q.ciud_tcomuna, r.CARR_TDESC, a.tins_ccod "; 
			sql = sql + "FROM ENVIOS A, INSTITUCIONES_ENVIO B, PLAZAS C, DETALLE_ENVIOS D,  "; 
			//sql = sql +		"DETALLE_INGRESOS E, INGRESOS F, PERSONAS G, POSTULANTES H, CODEUDOR_POSTULACION I,  "; 
			sql = sql +		"DETALLE_INGRESOS E, INGRESOS F, PERSONAS G, POSTULANTES H,  "; 
			sql = sql +		"PERSONAS J, DIRECCIONES K, TIPOS_DIRECCIONES L, CUENTAS_CORRIENTES M, SEDES N, ";
			sql = sql +		"Ofertas_academicas o, especialidades p, ciudades q, carreras r   "; 
			sql = sql + "WHERE E.DING_NCORRELATIVO = 1 ";
			sql = sql +   "AND A.INEN_CCOD = B.INEN_CCOD  "; 
			sql = sql +	  "AND A.PLAZ_CCOD = C.PLAZ_CCOD  "; 
			sql = sql +   "AND A.ENVI_NCORR = D.ENVI_NCORR  "; 
			sql = sql +   "AND D.TING_CCOD = E.TING_CCOD  "; 
			sql = sql +   "AND D.DING_NDOCTO = E.DING_NDOCTO  "; 
			sql = sql +   "AND D.INGR_NCORR = E.INGR_NCORR  "; 
			sql = sql +   "AND E.INGR_NCORR = F.INGR_NCORR  "; 
			sql = sql +   "AND F.PERS_NCORR = G.PERS_NCORR  "; 
			sql = sql +   "AND G.PERS_NCORR = H.PERS_NCORR  ";
			sql = sql +   "AND H.ofer_ncorr = o.OFER_NCORR ";
			sql = sql +   "AND o.espe_ccod = p.ESPE_CCOD ";
			//sql = sql +   "AND H.POST_NCORR = I.POST_NCORR  "; 
			sql = sql +   "AND E.PERS_NCORR_CODEUDOR = J.PERS_NCORR  "; 
			sql = sql +   "AND J.PERS_NCORR = K.PERS_NCORR  "; 
			sql = sql +   "AND K.TDIR_CCOD = L.TDIR_CCOD  "; 
			sql = sql +   "AND A.CCTE_CCOD = M.CCTE_CCOD  "; 
			sql = sql +   "AND M.SEDE_CCOD = N.SEDE_CCOD  ";
			sql = sql +   "AND k.CIUD_CCOD = q.CIUD_CCOD ";
			sql = sql +   "AND p.CARR_CCOD = r.CARR_CCOD ";
			sql = sql +   "AND (H.PERI_CCOD =" + periodo + ")  "; 
			//sql = sql +   "AND (H.PERI_CCOD = ultimo_periodo_matriculado(g.pers_ncorr))  "; 
			sql = sql +   "AND o.ofer_ncorr = ultima_oferta_matriculado(g.pers_ncorr)  "; 
			sql = sql +   "AND (L.TDIR_CCOD = 1)  "; 
			sql = sql +   "AND (A.ENVI_NCORR = " + envio +" )  "; 
			if (todos == "NO")
			   sql = sql +   "AND (G.PERS_NRUT IN(" + alumnos + "))";			
			
            //Response.Write(sql);
			//Response.End();
			return (sql);		
			 
		}

		
	
		
		private string Crear_Consulta_Carta_Guia(string envio, string periodo, string alumnos, string todos)
		{   //Consulta para mostra as cartas guias
			string sql;

			sql = "	Select a.envi_ncorr, getdate() as envi_fenvio, a.inen_ccod, e.inen_tdesc, f.plaz_ccod, f.plaz_tdesc,   \n";
			sql = sql +   "	isnull(protic.numero_compromiso(c.ingr_ncorr, c.ting_ccod, c.ding_ndocto), '0') as numero_compromiso,   \n";
			sql = sql +   " isnull(protic.total_documentos(c.ingr_ncorr, c.ting_ccod, c.ding_ndocto), '0') as total_documentos,   \n";
			sql = sql +   "    protic.obtener_rut(d.pers_ncorr) as rut_alumno, h.pers_nrut, protic.obtener_nombre_completo(c.pers_ncorr_codeudor, 'PMN') as nombre_apoderado,   \n";
			sql = sql +   "    protic.obtener_rut(c.pers_ncorr_codeudor) as rut_apoderado, isnull(protic.obtener_direccion_letra(c.pers_ncorr_codeudor, 1,'CNPB'),protic.obtener_direccion(c.pers_ncorr_codeudor, 1,'CNPB')) as direccion,   \n";
			sql = sql +   "    protic.trunc(c.ding_fdocto) as ding_fdocto, c.ding_mdetalle, c.ding_ndocto, c.ingr_ncorr, c.ting_ccod,   \n";
			sql = sql +   "    i.ccte_ttipo, i.ccte_tdesc, i.ccte_treferencia, k.sede_ccod, isnull(m.ciud_tdesc,o.ciud_tdesc) as ciud_tdesc, isnull(m.ciud_tcomuna,o.ciud_tcomuna) as ciud_tcomuna, \n";
			sql = sql +   "	   protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(d.pers_ncorr), 'C') as carr_tdesc, a.tins_ccod, a.tcob_ccod,   \n";
			sql = sql +   "		ISNULL((select top 1 STUFF(codigo_plaza,1, 0,REPLICATE('0',cast(4-len(codigo_plaza) as numeric))) from codigos_plazas_corpbanca where descripcion_plaza=m.ciud_tdesc),'0001') as codigo_plaza   \n";
			sql = sql +   " From   \n";
			sql = sql +   "    envios a   \n";
			sql = sql +   "    join detalle_envios b  \n";
			sql = sql +   "        on a.envi_ncorr = b.envi_ncorr   \n";
			sql = sql +   "    join detalle_ingresos c   \n";
			sql = sql +   "        on b.ding_ndocto = c.ding_ndocto   \n";
			sql = sql +   "        and b.ting_ccod = c.ting_ccod   \n";
			sql = sql +   "        and b.ingr_ncorr = c.ingr_ncorr   \n";
			sql = sql +   "    join ingresos d   \n";
			sql = sql +   "        on c.ingr_ncorr = d.ingr_ncorr  \n";
			sql = sql +   "    join instituciones_envio e   \n";
			sql = sql +   "        on a.inen_ccod = e.inen_ccod  \n";
			sql = sql +   "    join plazas f   \n";
			sql = sql +   "        on a.plaz_ccod = f.plaz_ccod  \n";
			sql = sql +   "    join personas g   \n";
			sql = sql +   "        on d.pers_ncorr = g.pers_ncorr  \n"; 
			sql = sql +   "    left outer join personas h  \n";
			sql = sql +   "        on c.pers_ncorr_codeudor = h.pers_ncorr  \n";
			sql = sql +   "    join cuentas_corrientes i  \n";
			sql = sql +   "        on a.ccte_ccod = i.ccte_ccod   \n";
			sql = sql +   "    join abonos j  \n";
			sql = sql +   "        on d.ingr_ncorr = j.ingr_ncorr  \n";
			sql = sql +   "    join compromisos k  \n";
			sql = sql +   "        on j.tcom_ccod = k.tcom_ccod  \n";
			sql = sql +   "        and j.inst_ccod = k.inst_ccod   \n";
			sql = sql +   "        and j.comp_ndocto = k.comp_ndocto  \n";
			sql = sql +   "    left outer join direcciones_publica l  \n";
			sql = sql +   "        on  h.pers_ncorr = l.pers_ncorr  \n";
			sql = sql +   "		   and l.tdir_ccod = 1   \n";
			sql = sql +   "   left outer join ciudades m   \n";
			sql = sql +   "       on l.ciud_ccod = m.ciud_ccod  \n";
			sql = sql +   "    left outer join direcciones n  \n";
			sql = sql +   "        on  h.pers_ncorr = n.pers_ncorr  \n";
			sql = sql +   "		   and n.tdir_ccod = 1   \n";
			sql = sql +   "   left outer join ciudades o   \n";
			sql = sql +   "       on n.ciud_ccod = o.ciud_ccod  \n";
			sql = sql +   " where    \n";
			sql = sql +   " d.eing_ccod not in (3,6) \n";
			sql = sql +   " and a.envi_ncorr = '"+ envio+" '   \n";


			if (todos == "NO")
			{
				sql = sql +   "AND (G.PERS_NRUT IN(" + alumnos + "))";
			}
			
				//sql = sql +   " Order by c.ding_ndocto asc";
				
				sql = sql +   " Order by nombre_apoderado,convert(datetime,ding_fdocto,103) asc";
				

			return sql;
		}

		
		// corregida
		private string Crear_Consulta_Listado_Letras(string envio, string periodo)
		{
			string sql;

			sql =  "			SELECT A.ENVI_NCORR, A.ENVI_FENVIO, A.INEN_CCOD, B.INEN_TDESC, A.PLAZ_CCOD, C.PLAZ_TDESC,";  
			sql = sql +   "    protic.obtener_rut(G.PERS_NCORR) AS RUT_ALUMNO,   ";
			sql = sql +   "    protic.obtener_nombre_completo(J.PERS_NCORR, 'PMN') AS NOMBRE_APODERADO,   ";
			sql = sql +   "     protic.obtener_rut(J.PERS_NCORR) AS RUT_APODERADO, cast(K.DIRE_TCALLE as varchar) + ' ' + cast(K.DIRE_TNRO as varchar) AS DIRECCION,   ";
			sql = sql +   "    protic.trunc(E.DING_FDOCTO) as DING_FDOCTO, E.DING_MDETALLE, E.DING_NDOCTO, E.INGR_NCORR, E.TING_CCOD,    ";
			sql = sql +   "    M.CCTE_TDESC, N.SEDE_TCALLE, N.SEDE_TNRO, B.INEN_CCOD AS EXPR1,    ";
			sql = sql +   "    C.PLAZ_CCOD AS EXPR2, M.CCTE_CCOD,N.SEDE_CCOD, p.ESPE_TDESC ,q.edin_tdesc, protic.trunc(f.INGR_FPAGO) as INGR_FPAGO  ";
			sql = sql +   " FROM ENVIOS A, INSTITUCIONES_ENVIO B, PLAZAS C, DETALLE_ENVIOS D,    ";
			sql = sql +   "	DETALLE_INGRESOS E, INGRESOS F, PERSONAS G, POSTULANTES H, "; 
			sql = sql +   "	PERSONAS J, DIRECCIONES K, TIPOS_DIRECCIONES L, CUENTAS_CORRIENTES M, SEDES N,   ";
			sql = sql +   "	Ofertas_academicas o, especialidades p, estados_detalle_ingresos q    ";
			sql = sql +   " WHERE E.DING_NCORRELATIVO = 1 ";
			sql = sql +   " AND A.INEN_CCOD = B.INEN_CCOD  ";  
			sql = sql +   " AND A.PLAZ_CCOD = C.PLAZ_CCOD  ";  
			sql = sql +   " AND A.ENVI_NCORR = D.ENVI_NCORR  ";  
			sql = sql +   " AND D.TING_CCOD = E.TING_CCOD  ";
			sql = sql +   " AND D.DING_NDOCTO = E.DING_NDOCTO   "; 
			sql = sql +   " AND D.INGR_NCORR = E.INGR_NCORR  ";
			sql = sql +   " AND e.EDIN_CCOD = q.EDIN_CCOD  ";  
			sql = sql +   " AND E.INGR_NCORR = F.INGR_NCORR  ";  
			sql = sql +   " AND F.PERS_NCORR = G.PERS_NCORR  ";  
			sql = sql +   " AND G.PERS_NCORR = H.PERS_NCORR  ";  
			sql = sql +   " AND H.ofer_ncorr = o.OFER_NCORR  "; 
			sql = sql +   " AND o.espe_ccod = p.ESPE_CCOD  "; 
			sql = sql +   " AND E.PERS_NCORR_CODEUDOR = J.PERS_NCORR  ";  
			sql = sql +   " AND J.PERS_NCORR = K.PERS_NCORR  ";  
			sql = sql +   " AND K.TDIR_CCOD = L.TDIR_CCOD  ";  
			sql = sql +   " AND A.CCTE_CCOD = M.CCTE_CCOD  ";  
			sql = sql +   " AND M.SEDE_CCOD = N.SEDE_CCOD  ";  
			sql = sql +   " AND (H.PERI_CCOD =" + periodo + ") ";  
			sql = sql +   " AND (L.TDIR_CCOD = 1)  ";
			sql = sql +   " AND (A.ENVI_NCORR =" + envio + ")";
			sql = sql +   " order by E.DING_NDOCTO asc ";

			return (sql);
		}

		



		/***************************************************************************/
		// DESCRIPCION			    :						  				       
		// FECHA CREACIÓN			:                                              
		// CREADO POR				:                                              
		// ENTRADA				    : NA                                           
		// SALIDA				    : NA                                           
		// MODULO QUE ES UTILIZADO	:---LLENAR---                                  
		//                                                                         
		// --ACTUALIZACION--                                                       
		//                                                                         
		// FECHA ACTUALIZACION		: 12-04-2013                                   
		// ACTUALIZADO POR			: Luis Herrera G.                              
		// MOTIVO				    : Corregir código, eliminar sentencia *=       
		// LINEA				    : 294                             
		/***************************************************************************/


		private string Crear_Consulta_Listado_Letras_Agrupado_Ant(string envio, string periodo)
		{
			string sql;

			sql = "select 0                                                   as carta, "+"\n";
			sql = sql +"       a.envi_ncorr, "+"\n";
			sql = sql +"       a.envi_ncorr                                        as c_envi_ncorr, "+"\n";
			sql = sql +"       c.pers_ncorr, "+"\n";
			sql = sql +"       f.pers_nrut                                         as r_alumno, "+"\n";
			sql = sql +"       f.pers_xdv, "+"\n";
			sql = sql +"       cast(f.pers_nrut as varchar) + '-' "+"\n";
			sql = sql +"       + f.pers_xdv                                        as rut_alumno, "+"\n";
			sql = sql +"       cast(f.pers_nrut as varchar) + '-' "+"\n";
			sql = sql +"       + f.pers_xdv                                        as c_rut_alumno, "+"\n";
			sql = sql +"       isnull(cast(g.pers_nrut as varchar), ' ')           as code_nrut, "+"\n";
			sql = sql +"       isnull(g.pers_xdv, ' ')                             as code_xdv, "+"\n";
			sql = sql +"       isnull(cast(g.pers_nrut as varchar), ' ')           as r_apoderado, "+"\n";
			sql = sql +"       isnull(cast(g.pers_nrut as varchar), ' ') "+"\n";
			sql = sql +"       + '-' + isnull(g.pers_xdv, ' ')                     as rut_apoderado, "+"\n";
			sql = sql +"       isnull(cast(g.pers_nrut as varchar), ' ') "+"\n";
			sql = sql +"       + '-' + isnull(g.pers_xdv, ' ')                     as c_rut_apoderado, "+"\n";
			sql = sql +"       isnull(cast(g.pers_tnombre as varchar), ' ') "+"\n";
			sql = sql +"       + ' ' "+"\n";
			sql = sql +"       + isnull(cast(g.pers_tape_paterno as varchar), ' ') as nombre_apoderado, "+"\n";
			sql = sql +"       count(a.envi_ncorr)                                 as cantdoc, "+"\n";
			sql = sql +"       sum(b.ding_mdocto)                                  as totaldoc "+"\n";
			sql = sql +"from   detalle_envios as a "+"\n";
			sql = sql +"       inner join detalle_ingresos as b "+"\n";
			sql = sql +"               on a.ting_ccod = b.ting_ccod "+"\n";
			sql = sql +"                  and b.ding_ncorrelativo = 1 "+"\n";
			sql = sql +"                  and a.ding_ndocto = b.ding_ndocto "+"\n";
			sql = sql +"                  and a.ingr_ncorr = b.ingr_ncorr "+"\n";
			sql = sql +"       inner join ingresos as c "+"\n";
			sql = sql +"               on b.ingr_ncorr = c.ingr_ncorr "+"\n";
			sql = sql +"       inner join personas as f "+"\n";
			sql = sql +"               on c.pers_ncorr = f.pers_ncorr "+"\n";
			sql = sql +"       left outer join personas as g "+"\n";
			sql = sql +"                    on b.pers_ncorr_codeudor = g.pers_ncorr "+"\n";
			sql = sql +"where  a.envi_ncorr = '\"+ envio + \"' "+"\n";
			sql = sql +"group  by a.envi_ncorr, "+"\n";
			sql = sql +"          c.pers_ncorr, "+"\n";
			sql = sql +"          f.pers_xdv, "+"\n";
			sql = sql +"          g.pers_xdv, "+"\n";
			sql = sql +"          g.pers_tape_paterno, "+"\n";
			sql = sql +"          g.pers_tnombre, "+"\n";
			sql = sql +"          f.pers_nrut, "+"\n";
			sql = sql +"          g.pers_nrut ";
		
			//Response.Write (sql + "<br>");
			//Response.Flush();
			return (sql);
		}




// LISTA  (REEMPLAZA A LA FUNCION QUE ESTA ARRIBA)
		private string Crear_Consulta_Listado_Letras_Agrupado(string envio, string periodo)
		{
			string sql;

				sql = " select a.envi_ncorr,  \n";
				sql = sql +  "       protic.trunc(a.envi_fenvio) as envi_fenvio,  \n";
				sql = sql +  "       a.inen_ccod, g.inen_tdesc, d.pers_nrut, h.plaz_tdesc, p.tine_tdesc,  \n";
				sql = sql +  "       protic.initcap(p.tine_tdesc) as l_tine_tdesc,  \n";
				sql = sql +  "       protic.obtener_rut(i.pers_ncorr) as rut_alumno,  \n";
				sql = sql +  "       protic.obtener_nombre_completo(d.pers_ncorr, 'PMN') as nombre_apoderado,  \n";
				sql = sql +  "       protic.obtener_rut(d.pers_ncorr) as rut_apoderado, k.ccte_tdesc,  \n";
				sql = sql +  "       count(b.ding_ndocto) as cantidad, sum(j.ding_mdetalle) as total_docs  \n";
				sql = sql +  "       from envios a join detalle_envios b on a.envi_ncorr=b.envi_ncorr \n";
				sql = sql +  "                          join detalle_ingresos c on b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr \n";
				sql = sql +  "                               left outer join personas d on c.pers_ncorr_codeudor = d.pers_ncorr \n";
				sql = sql +  "                                    left outer join direcciones e on d.pers_ncorr = e.pers_ncorr \n";
				sql = sql +  "                                         left outer join ciudades f on e.ciud_ccod = f.ciud_ccod \n";
				sql = sql +  "                                         right outer join (select 1 dir) tipo on e.tdir_ccod = tipo.dir \n";
				sql = sql +  "                          join ingresos i on b.ingr_ncorr = i.ingr_ncorr  \n";
				sql = sql +  "                               join detalle_ingresos j on b.ting_ccod = j.ting_ccod and b.ingr_ncorr = j.ingr_ncorr and b.ding_ndocto = j.ding_ndocto \n";
				sql = sql +  "                          join personas o on i.pers_ncorr = o.pers_ncorr \n";
				sql = sql +  "                      left outer join instituciones_envio g on a.inen_ccod = g.inen_ccod \n";
				sql = sql +  "                           join  tipos_instituciones_envio p on g.tine_ccod = p.tine_ccod \n";
				sql = sql +  "                      left outer join plazas h on a.plaz_ccod = h.plaz_ccod \n";
				sql = sql +  "                      left outer join cuentas_corrientes k on a.ccte_ccod = k.ccte_ccod \n";
				sql = sql +  "               left outer join ofertas_academicas l on l.ofer_ncorr = protic.ultima_oferta_matriculado(i.pers_ncorr)  \n";
				sql = sql +  "               left outer join sedes m on l.sede_ccod = m.sede_ccod \n";
				sql = sql +  "               left outer join ciudades n on m.ciud_ccod = n.ciud_ccod \n";
				sql = sql +  "       where c.ding_ncorrelativo > 0  \n";
				sql = sql +  "         and a.envi_ncorr = '" + envio + "' \n";
				sql = sql +  "       group by a.envi_ncorr, protic.trunc(a.envi_fenvio), a.inen_ccod, \n";
				sql = sql +  "          g.inen_tdesc, d.pers_nrut, h.plaz_tdesc, i.pers_ncorr, d.pers_ncorr, k.ccte_tdesc, p.tine_tdesc  \n";
				sql = sql +  "          order by nombre_apoderado asc \n";

			return sql;
		}

		
		private void Page_Load(object sender, System.EventArgs e)
		{
		    string sql, envio, periodo, informe, banco, rut_alumnos = "", todos = ""; 		

			periodo = Request.QueryString["periodo"];
            envio	= Request.QueryString["folio_envio"];
			informe = Request.QueryString["informe"];
			banco = Request.QueryString["banco"];
			todos = Request.QueryString["todos"];	

			// datos de pruebas
			
			/* 
			 periodo = "164";
			 envio = "357"; 
			 informe = "1";
			 banco= "3";	
			 todos="NO";    
			 */

			switch (informe)
			{
				case "1":          //CARTAS GUIAS				
				{	
					rut_alumnos = Filtrar_Carta_Guia ();
					sql = Crear_Consulta_Carta_Guia(envio, periodo, rut_alumnos, todos);					
					//Response.Write(sql);
					//Response.Flush();
					
					switch (banco)
					{
						case "1":  // carta guia banco BCI
							rep_carta_guia_bci CartaGuiaBCI = new rep_carta_guia_bci();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);
							CartaGuiaBCI.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaBCI;
							ExportarPDF(CartaGuiaBCI);
							break;
						
						case "2":   //carta guia banco Chile
							CartaBancoChile CartaGuiaChile = new CartaBancoChile();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);							
							CartaGuiaChile.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaChile;
							ExportarPDF(CartaGuiaChile);
							break;

						case "3":   //carta guia banco SANTANDER - SANTIAGO
							CrystalReport4 CartaGuiaSantiago = new CrystalReport4();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);							
							CartaGuiaSantiago.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaSantiago;
							ExportarPDF(CartaGuiaSantiago);
							break;
						
					
						case "4":   //carta guia banco (Scotiabank Sud-Americano)
							CrystalReport5 CartaGuiaScotiabank = new CrystalReport5();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);							
							CartaGuiaScotiabank.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaScotiabank;
							ExportarPDF(CartaGuiaScotiabank);
							break;

						case "17":   //carta guia banco (Scotiabank Sud-Americano)
							CartaCorpBanca CartaGuiaCorpBanca = new CartaCorpBanca();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);							
							CartaGuiaCorpBanca.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaCorpBanca;
							ExportarPDF(CartaGuiaCorpBanca);
							break;

						default:
							   //carta guia Otros Bancos 
							CrystalReport5 CartaGuiaOtrosBancos = new CrystalReport5();
							oleDbDataAdapter1.SelectCommand.CommandText = sql;
							oleDbDataAdapter1.Fill(dataSet11);							
							CartaGuiaOtrosBancos.SetDataSource(dataSet11);
							CrystalReportViewer1.ReportSource = CartaGuiaOtrosBancos;
							ExportarPDF(CartaGuiaOtrosBancos);
							break;

					}       // end switch banco
                 break;  
				}
				
				case "2":           // LISTADO DETALLE DE LETRAS
				{
					rep_detalle_letras ListadoLetras = new rep_detalle_letras();
					sql = Crear_Consulta_Listado_Letras (envio,periodo);					
					oleDbDataAdapter2.SelectCommand.CommandText = sql;
					oleDbDataAdapter2.Fill(dataSet21);
					ListadoLetras.SetDataSource(dataSet21);
					CrystalReportViewer1.ReportSource = ListadoLetras;
					ExportarPDF(ListadoLetras);
					break;
				}
				
				case "3":          //DETALLE DE LETRAS AGRUPADO                   
					CrystalReport3 ListadoAgrupado = new CrystalReport3();
					sql = Crear_Consulta_Listado_Letras_Agrupado(envio,periodo);
					oleDbDataAdapter3.SelectCommand.CommandText = sql;
					oleDbDataAdapter3.Fill(dataSet31);
					ListadoAgrupado.SetDataSource(dataSet31);
					CrystalReportViewer1.ReportSource = ListadoAgrupado;
					ExportarPDF(ListadoAgrupado);
					break;
			}                    // end switch tipo de informe
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
			this.oleDbConnection1 = new System.Data.OleDb.OleDbConnection();
			this.oleDbDataAdapter1 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand1 = new System.Data.OleDb.OleDbCommand();
			this.dataSet11 = new CartaGuia.DataSet1();
			this.oleDbDataAdapter2 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand2 = new System.Data.OleDb.OleDbCommand();
			this.dataSet21 = new CartaGuia.DataSet2();
			this.oleDbDataAdapter3 = new System.Data.OleDb.OleDbDataAdapter();
			this.oleDbSelectCommand3 = new System.Data.OleDb.OleDbCommand();
			this.dataSet31 = new CartaGuia.DataSet3();
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet21)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet31)).BeginInit();
			// 
			// oleDbConnection1
			// 
			this.oleDbConnection1.ConnectionString = ((string)(configurationAppSettings.GetValue("cadenaConexion", typeof(string))));
			// 
			// oleDbDataAdapter1
			// 
			this.oleDbDataAdapter1.SelectCommand = this.oleDbSelectCommand1;
			this.oleDbDataAdapter1.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("NUMERO_COMPROMISO", "NUMERO_COMPROMISO"),
																																																				 new System.Data.Common.DataColumnMapping("TOTAL_DOCUMENTOS", "TOTAL_DOCUMENTOS"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_CCOD", "INEN_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("PLAZ_CCOD", "PLAZ_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("PERS_NRUT", "PERS_NRUT"),
																																																				 new System.Data.Common.DataColumnMapping("PLAZ_TDESC", "PLAZ_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																				 new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("DING_MDETALLE", "DING_MDETALLE"),
																																																				 new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TCALLE", "SEDE_TCALLE"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TNRO", "SEDE_TNRO"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_CCOD", "CCTE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TREFERENCIA", "CCTE_TREFERENCIA"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CIUD_TDESC", "CIUD_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CIUD_TCOMUNA", "CIUD_TCOMUNA"),
																																																				 new System.Data.Common.DataColumnMapping("CARR_TDESC", "CARR_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO"),
																																																				 new System.Data.Common.DataColumnMapping("TINS_CCOD", "TINS_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TTIPO", "CCTE_TTIPO")})});
			// 
			// oleDbSelectCommand1
			// 
			this.oleDbSelectCommand1.CommandText = @"SELECT '' AS NUMERO_COMPROMISO, '' AS TOTAL_DOCUMENTOS, '' AS ENVI_NCORR, '' AS ENVI_FENVIO, '' AS INEN_CCOD, '' AS INEN_TDESC, '' AS PLAZ_CCOD, '' AS PERS_NRUT, '' AS PLAZ_TDESC, '' AS RUT_ALUMNO, '' AS NOMBRE_APODERADO, '' AS RUT_APODERADO, '' AS DIRECCION, '' AS DING_FDOCTO, '' AS DING_MDETALLE, '' AS DING_NDOCTO, '' AS INGR_NCORR, '' AS TING_CCOD, '' AS CCTE_TDESC, '' AS SEDE_TCALLE, '' AS SEDE_TNRO, '' AS CCTE_CCOD, '' AS CCTE_TREFERENCIA, '' AS SEDE_CCOD, '' AS CIUD_TDESC, '' AS CIUD_TCOMUNA, '' AS CARR_TDESC, '' AS INGR_FPAGO, '' AS TINS_CCOD, '' AS CCTE_TTIPO, '' AS TCOB_CCOD, '' AS codigo_plaza";
			this.oleDbSelectCommand1.Connection = this.oleDbConnection1;
			// 
			// dataSet11
			// 
			this.dataSet11.DataSetName = "DataSet1";
			this.dataSet11.Locale = new System.Globalization.CultureInfo("es-ES");
			this.dataSet11.Namespace = "http://www.tempuri.org/DataSet1.xsd";
			// 
			// oleDbDataAdapter2
			// 
			this.oleDbDataAdapter2.SelectCommand = this.oleDbSelectCommand2;
			this.oleDbDataAdapter2.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_CCOD", "INEN_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("PLAZ_CCOD", "PLAZ_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("PLAZ_TDESC", "PLAZ_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("DIRECCION", "DIRECCION"),
																																																				 new System.Data.Common.DataColumnMapping("DING_FDOCTO", "DING_FDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("DING_MDETALLE", "DING_MDETALLE"),
																																																				 new System.Data.Common.DataColumnMapping("DING_NDOCTO", "DING_NDOCTO"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_NCORR", "INGR_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("TING_CCOD", "TING_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TCALLE", "SEDE_TCALLE"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_TNRO", "SEDE_TNRO"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_CCOD", "CCTE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("SEDE_CCOD", "SEDE_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("ESPE_TDESC", "ESPE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("EDIN_TDESC", "EDIN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("INGR_FPAGO", "INGR_FPAGO")})});
			// 
			// oleDbSelectCommand2
			// 
			this.oleDbSelectCommand2.CommandText = @"SELECT '' AS ENVI_NCORR, '' AS ENVI_FENVIO, '' AS INEN_CCOD, '' AS INEN_TDESC, '' AS PLAZ_CCOD, '' AS PLAZ_TDESC, '' AS RUT_ALUMNO, '' AS NOMBRE_APODERADO, '' AS RUT_APODERADO, '' AS DIRECCION, '' AS DING_FDOCTO, '' AS DING_MDETALLE, '' AS DING_NDOCTO, '' AS INGR_NCORR, '' AS TING_CCOD, '' AS CCTE_TDESC, '' AS SEDE_TCALLE, '' AS SEDE_TNRO, '' AS CCTE_CCOD, '' AS SEDE_CCOD, '' AS ESPE_TDESC, '' AS EDIN_TDESC, '' AS INGR_FPAGO";
			this.oleDbSelectCommand2.Connection = this.oleDbConnection1;
			// 
			// dataSet21
			// 
			this.dataSet21.DataSetName = "DataSet2";
			this.dataSet21.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet21.Namespace = "http://www.tempuri.org/DataSet2.xsd";
			// 
			// oleDbDataAdapter3
			// 
			this.oleDbDataAdapter3.SelectCommand = this.oleDbSelectCommand3;
			this.oleDbDataAdapter3.TableMappings.AddRange(new System.Data.Common.DataTableMapping[] {
																										new System.Data.Common.DataTableMapping("Table", "Table", new System.Data.Common.DataColumnMapping[] {
																																																				 new System.Data.Common.DataColumnMapping("ENVI_NCORR", "ENVI_NCORR"),
																																																				 new System.Data.Common.DataColumnMapping("ENVI_FENVIO", "ENVI_FENVIO"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_CCOD", "INEN_CCOD"),
																																																				 new System.Data.Common.DataColumnMapping("INEN_TDESC", "INEN_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("PLAZ_TDESC", "PLAZ_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_ALUMNO", "RUT_ALUMNO"),
																																																				 new System.Data.Common.DataColumnMapping("NOMBRE_APODERADO", "NOMBRE_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("RUT_APODERADO", "RUT_APODERADO"),
																																																				 new System.Data.Common.DataColumnMapping("CCTE_TDESC", "CCTE_TDESC"),
																																																				 new System.Data.Common.DataColumnMapping("CANTIDAD", "CANTIDAD"),
																																																				 new System.Data.Common.DataColumnMapping("PERS_NRUT", "PERS_NRUT")})});
			// 
			// oleDbSelectCommand3
			// 
			this.oleDbSelectCommand3.CommandText = "SELECT \'\' AS ENVI_NCORR, \'\' AS ENVI_FENVIO, \'\' AS INEN_CCOD, \'\' AS INEN_TDESC, \'\'" +
				" AS PLAZ_TDESC, \'\' AS RUT_ALUMNO, \'\' AS NOMBRE_APODERADO, \'\' AS RUT_APODERADO, \'" +
				"\' AS CCTE_TDESC, \'\' AS CANTIDAD, \'\' AS PERS_NRUT";
			this.oleDbSelectCommand3.Connection = this.oleDbConnection1;
			// 
			// dataSet31
			// 
			this.dataSet31.DataSetName = "DataSet3";
			this.dataSet31.Locale = new System.Globalization.CultureInfo("es-CL");
			this.dataSet31.Namespace = "http://www.tempuri.org/DataSet3.xsd";
			this.Load += new System.EventHandler(this.Page_Load);
			((System.ComponentModel.ISupportInitialize)(this.dataSet11)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet21)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dataSet31)).EndInit();

		}
		#endregion

		
		
	}
}
