<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Estados de Evaluaciones Asignaturas"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	periodo = negocio.obtenerPeriodoAcademico("CLASES18")
end if

'Sede = negocio.ObtenerSede()
'sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "listado_evaluaciones.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 asig_ccod	=	request.querystring("busqueda[0][asig_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	=	request.querystring("busqueda[0][sede_ccod]")
 todas	=	request.querystring("busqueda[0][todas]")
 sin_alumnos	=	request.querystring("busqueda[0][sin_alumnos]")
 sin_cerrar	=	request.querystring("busqueda[0][sin_cerrar]")
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	asig_tdesc = conexion.consultaUno("select asig_ccod + ' --> '+ asig_tdesc from asignaturas where cast(asig_ccod as varchar) ='"&asig_ccod&"'")
 else
    asig_tdesc = "<< Todas las Asignaturas >>"
 end if	
 codigo = asig_ccod

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_evaluaciones.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 'sede = negocio.obtenerSede
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas,'"&sin_alumnos&"' as sin_alumnos,'"&sin_cerrar&"' as sin_cerrar "
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = "select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc,ltrim(rtrim(d.asig_ccod))as asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es --, bloques_horarios c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod " & vbCrLf & _
		   " and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod" & vbCrLf &_
		   " --and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
		   " and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and cast(b.peri_ccod as varchar)='"&peri&"' order by f.sede_tdesc,a.carr_tdesc,d.asig_tdesc,d.asig_ccod asc" 

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo

'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "listado_evaluaciones.xml", "f_asignaturas"
f_asignaturas.Inicializar conexion

set f_copia = new CFormulario
f_copia.Carga_Parametros "listado_evaluaciones.xml", "f_asignaturas"
f_copia.Inicializar conexion

 if asig_ccod = "" and carr_ccod= "" then
    codigo = "  "
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if
 
 ' consulta = "SELECT  a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod  "& vbCrLf &_
 '		   "FROM asignaturas a, secciones b  "& vbCrLf &_
 '		   "WHERE a.asig_ccod=b.asig_ccod "& vbCrLf &_
 '		   "  and cast(b.sede_ccod as varchar) = '" & Sede & "'"& vbCrLf &_
 '		   "  and cast(b.peri_ccod as varchar)='" & Periodo & "'"& vbCrLf &_
 '		   "  and (cast(a.asig_ccod as varchar) = '" & codigo & "' or '" & codigo & "' is null )"& vbCrLf &_
 '		   "  and b.secc_finicio_sec is not null "& vbCrLf &_
 ' 		   "  and b.secc_ftermino_sec is not null "& vbCrLf &_
 '		   "ORDER BY a.asig_tdesc, b.secc_tdesc"& vbCrLf
 
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	filtro_asignaturas = "and (cast(a.asig_ccod as varchar) = '"&asig_ccod&"' or '"&asig_ccod&"' is null )"
 else
	filtro_asignaturas = ""
 end if	
   
 consulta = "SELECT distinct a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod,"& vbCrLf	&_
		    "(select case count(*) when '0' then 'No' else 'Sí' end  from bloques_horarios bb, bloques_profesores cc where bb.secc_ccod=b.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and tpro_ccod=1) as con_docente, "& vbCrLf	&_
			"protic.PROFESORES_SECCION_CON_CORREO(b.secc_ccod) nombre_correo," & vbCrLf	&_
			"(select count(distinct cc.pers_ncorr) from bloques_horarios bb, bloques_profesores cc where bb.secc_ccod=b.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and tpro_ccod=1) as Num, "& vbCrLf	&_
			"case isnull(b.estado_cierre_ccod,1) when 1 then 'Sin Cerrar' else 'Cerrada' end as estado, "& vbCrLf	&_
			"(select case count(*) when 0 then 'No' else 'Sí' end from calificaciones_seccion bb where b.secc_ccod=bb.secc_ccod)as con_evaluaciones, "& vbCrLf	&_
			"(select case count(*) when 0 then 'No' else 'Sí' end from calificaciones_alumnos bb where b.secc_ccod=bb.secc_ccod)as notas_parciales, "& vbCrLf &_	
			"(select case count(*) when 0 then 'No' else 'Sí' end from cargas_Academicas bb where b.secc_ccod=bb.secc_ccod and isnull(sitf_ccod,'0') <>'0' )as notas_finales, "& vbCrLf	&_
			"(select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " --and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_alumnos "& vbCrLf	&_ 
			"FROM asignaturas a, secciones b, bloques_horarios c"& vbCrLf	&_
			"WHERE a.asig_ccod=b.asig_ccod "& vbCrLf	&_
			"  and cast(b.sede_ccod as varchar) = '"&sede_ccod&"'"& vbCrLf	&_
			"  and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbCrLf	&_
			"  and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf	&_
			"  and cast(b.carr_ccod as varchar)='"&carr_ccod&"'"& vbCrLf &_	
			"  "& filtro_asignaturas & vbCrLf	&_
			"  and b.secc_finicio_sec is not null "& vbCrLf	&_
			"  and b.secc_ftermino_sec is not null "& vbCrLf	&_
			"  and b.secc_ccod  = c.secc_ccod "

if sin_alumnos="S" then
consulta = consulta & " and (select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) = 0 "
end if

if sin_cerrar = "S" then
consulta = consulta & " and isnull(b.estado_cierre_ccod,1)= 1 "
end if

			
'response.Write("<pre>"&consulta&"</pre>")			   
'response.End()
  if Request.QueryString <> "" then
     f_asignaturas.consultar consulta & " ORDER BY a.asig_tdesc, b.secc_tdesc " 
  else
	f_asignaturas.consultar "select * from secciones where 1=2 "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

'response.Write(carr_ccod)

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="listado_evaluaciones.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="13%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="54%"><% f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Asignatura</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Sin alumnos</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><%f_busqueda.dibujaCampo("sin_alumnos")%>&nbsp;&nbsp; Sin Cerrar <%f_busqueda.dibujaCampo("sin_cerrar")%>&nbsp;&nbsp; Todas las asignaturas <%f_busqueda.dibujaCampo("todas")%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                       </tr>
                    </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if Request.QueryString <> "" then%>
					  <tr> 
                        <td width="9%">Sede</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Asignatura</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=asig_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=periodo_tdesc%> (Seleccionado de la actividad Toma de Carga)</td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                        <td><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div></td>
                  </tr>
				  <tr>
                    <td>
                      <br>
					  <%f_asignaturas.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr>
				      <td>&nbsp;</td>
				  </tr>
				  <%if sede_Ccod <> "" and carr_ccod <> "" and jorn_ccod <> "" then %>
				  <tr>
				      <td>&nbsp;</td>
				  </tr>
				  <tr>
				      <td align="center">
					  	  <table width="80%" bgcolor="#666666" border="1" bordercolor="#999999">
						  	 <tr>
							     <td align="center">
								 	    <%
				                           botonera.agregabotonparam "excel_parciales", "url", "reporte_semestral.asp?sede_ccod="&sede_ccod&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&peri_ccod="&peri
										   botonera.dibujaboton "excel_parciales"
										%>
								 </td>
								 <td align="center">
								 	    <%
				                           botonera.agregabotonparam "rojos_excel", "url", "parciales_reprobados_excel.asp?sede_ccod="&sede_ccod&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&peri_ccod="&peri
										   botonera.dibujaboton "rojos_excel"
										%>
								 </td>
							 </tr>	
						  </table>
					  </td>
				  </tr>
				  <tr><td><br><strong>- Avance ingreso Notas: </strong>Genera un listado Excel con el avance de ingreso de programa y evaluaciones para cada asignatura de la escuela seleccionada.
				                  <br>
						  <strong>- Notas Insuficientes: </strong> Genera un listado Excel de alumnos que se encuentran al día de hoy con más de 2 asignaturas evaluadas con alguna de sus notas parciales insuficientes.
								  </td></tr>
				  <%end if%>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td width="14%"> <div align="center">  <%
				                           botonera.agregabotonparam "excel", "url", "listado_evaluaciones_excel.asp?sede_ccod="&sede_ccod
										   botonera.dibujaboton "excel"
										%>
							 </div>
						 </td>
						 <td width="14%"> <div align="center">  <% if carr_ccod <> "" then
				                           botonera.agregabotonparam "excel2", "url", "situaciones_pendientes_excel.asp?carr_ccod="&carr_ccod
										   botonera.dibujaboton "excel2"
										   end if
										%></div>
                         </td>
						 <td width="14%"> <div align="center">  <% if carr_ccod <> "" then
				                           botonera.agregabotonparam "excel3", "url", "listado_alumnos_excel.asp?carr_ccod="&carr_ccod
										   botonera.dibujaboton "excel3"
										   end if
										%></div>
                         </td>
						 <td width="14%"> <div align="center">  <% if carr_ccod <> "" then
				                           botonera.agregabotonparam "excel_nomina_profesores", "url", "listado_correos_docentes.asp?carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod
										   botonera.dibujaboton "excel_nomina_profesores"
										   end if
										%></div>
                         </td>
						</tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
