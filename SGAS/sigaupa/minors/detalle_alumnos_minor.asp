<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set Errores = new CErrores

minr_ncorr = request.querystring("minr_ncorr")
pers_ncorr = request.querystring("pers_ncorr")

pagina.Titulo = "Asignaturas del Minor cursadas por el Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "alumnos_minor.xml", "botonera"
'----------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")

minr_tdesc = conexion.consultauno("SELECT minr_tdesc FROM minors WHERE cast(minr_ncorr as varchar) = '" & minr_ncorr & "'")
rut_alumno = conexion.consultauno("SELECT cast(pers_nrut as varchar)+'-'+pers_xdv FROM personas WHERE cast(pers_ncorr as varchar) = '" & pers_ncorr & "'")
nombre_alumno = conexion.consultauno("SELECT pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno FROM personas WHERE cast(pers_ncorr as varchar) = '" & pers_ncorr & "'")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where  cast(peri_ccod as varchar)='"&periodo&"'")
'----------------------------------debemos ver si el alumno se encuentra matriculado para el periodo seleccionado.
matriculado = conexion.consultaUno("select count(*) from alumnos a, ofertas_Academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"' and emat_ccod not in (5,6,7,11,13)")
if matriculado ="0" then
 	carrera = "<<este alumno no presenta matricula para el periodo seleccionado>>"
else
 	carrera = conexion.consultaUno("select carr_tdesc from alumnos a, ofertas_Academicas b, especialidades c, carreras d where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"' and emat_ccod not in (5,6,7,11,13) and b.espe_ccod = c.espe_ccod and c.carr_ccod = d.carr_ccod")
end if


'---------------------------------------------------------------------------------------------------
set f_asignaturas_alumnos = new CFormulario
f_asignaturas_alumnos.Carga_Parametros "alumnos_minor.xml", "f_asignaturas_alumno"
f_asignaturas_alumnos.Inicializar conexion
 consulta = " select b.asig_ccod,c.asig_tdesc,'Sin Evaluar' as estado "& vbCrLf &_
			" from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			" where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			" and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			" and EXISTS (SELECT 1  "& vbCrLf &_
		    "	                FROM secciones sa, "& vbCrLf &_
			"                         cargas_academicas sb, "& vbCrLf &_
			"                         alumnos sc "& vbCrLf &_
			"                   WHERE sa.secc_ccod = sb.secc_ccod "& vbCrLf &_
			"                     AND sa.asig_ccod = b.asig_ccod "& vbCrLf &_
			"                     AND sb.matr_ncorr = sc.matr_ncorr "& vbCrLf &_
			"                     AND isnull(sb.sitf_ccod,'1') = '1'"& vbCrLf &_
			"                     AND sc.emat_ccod = 1 "& vbCrLf &_
			"                     AND cast(sc.pers_ncorr as varchar) = '"&pers_ncorr&"') "& vbCrLf &_
			" union all                      "& vbCrLf &_
			" select b.asig_ccod,c.asig_tdesc,'Aprobado' as estado  "& vbCrLf &_
			" from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			" where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			" and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			" and EXISTS (SELECT 1  "& vbCrLf &_
			"                    FROM secciones sa, "& vbCrLf &_
			"                         cargas_academicas sb,"& vbCrLf &_
			"                         alumnos sc, "& vbCrLf &_
			"                         situaciones_finales sd "& vbCrLf &_
			"                   WHERE sa.secc_ccod = sb.secc_ccod "& vbCrLf &_
			"                     AND sa.asig_ccod = b.asig_ccod "& vbCrLf &_
			"                     AND sb.matr_ncorr = sc.matr_ncorr "& vbCrLf &_
			"                     AND sb.sitf_ccod = sd.sitf_ccod "& vbCrLf &_
			"                     and not exists (select 1 from equivalencias eq where eq.matr_ncorr = sb.matr_ncorr and eq.secc_ccod = sb.secc_ccod) "& vbCrLf &_
			"                     AND cast(sd.sitf_baprueba as varchar) = 'S' "& vbCrLf &_
			"                     AND sc.emat_ccod = 1 "& vbCrLf &_
			"                     AND cast(sc.pers_ncorr as varchar) = '"&pers_ncorr&"') "& vbCrLf &_
			" union all "& vbCrLf &_
			" select b.asig_ccod,c.asig_tdesc,'Convalidado' as estado  "& vbCrLf &_
			" from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			" where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			" and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			" and EXISTS (  select 1  "& vbCrLf &_
			"			from   "& vbCrLf &_
			"				 convalidaciones a  "& vbCrLf &_
			" 			 , alumnos b1 "& vbCrLf &_
			"			 , actas_convalidacion d "& vbCrLf &_
			"			 , situaciones_finales h "& vbCrLf &_
			"			where "& vbCrLf &_
			"				 a.matr_ncorr=b1.matr_ncorr "& vbCrLf &_
			"				 and a.acon_ncorr=d.acon_ncorr "& vbCrLf &_
			"				 and a.asig_ccod=b.asig_ccod "& vbCrLf &_
			"				 and a.sitf_ccod=h.sitf_ccod "& vbCrLf &_
			"				 and cast(h.sitf_baprueba as varchar)='S' "& vbCrLf &_
			"                 AND cast(b1.pers_ncorr as varchar) = '"&pers_ncorr&"') "& vbCrLf &_
			" union all "& vbCrLf &_
			" select b.asig_ccod,c.asig_tdesc,'Aprobado por Equivalencia' as estado "& vbCrLf &_
			" from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			" where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			" and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			" and EXISTS (select  1 "& vbCrLf &_
			"		   		  		   from  "& vbCrLf &_
			"								equivalencias a "& vbCrLf &_
			"								, secciones c "& vbCrLf &_
			"								, alumnos g "& vbCrLf &_
			"                                , cargas_Academicas b1"& vbCrLf &_
			"								, situaciones_finales sf "& vbCrLf &_
			"							where "& vbCrLf &_
			"								 a.secc_ccod=c.secc_ccod "& vbCrLf &_
			"								 and a.matr_ncorr=g.matr_ncorr "& vbCrLf &_
			"								 and a.asig_ccod=b.asig_ccod "& vbCrLf &_
			"                                and a.matr_ncorr = b1.matr_ncorr and a.secc_ccod = b1.secc_ccod "& vbCrLf &_
			"								 and b1.sitf_ccod = sf.sitf_ccod "& vbCrLf &_
			"								 and cast(sf.sitf_baprueba as varchar)='S'  "& vbCrLf &_
			"                                 AND cast(g.pers_ncorr as varchar) = '"&pers_ncorr&"') "
			
'response.write("<pre>"&consulta&"</pre>")
f_asignaturas_alumnos.Consultar consulta

'---------------------------------------------------------------------------------------------------

 set f_secciones = new CFormulario
 f_secciones.Carga_Parametros "alumnos_minor.xml", "asignaturas"
 f_secciones.Inicializar conexion
 
 consulta="Select '"&asig_ccod&"' as asig_ccod, '"&secc_ccod&"' as secc_ccod"
 f_secciones.consultar consulta
 
 consulta = " select distinct c.asig_ccod,c.asig_tdesc,d.secc_ccod , d.secc_tdesc + ' --> ' + protic.horario(d.secc_ccod) as secc_tdesc "& vbCrLf &_
			" from asignaturas_minor a, malla_curricular b, asignaturas c,secciones d "& vbCrLf &_
			" where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			" and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			" and b.asig_ccod = d.asig_ccod and b.mall_ccod = d.mall_ccod and cast(peri_ccod as varchar)='"&periodo&"' "& vbCrLf &_
			" and b.asig_ccod  "& vbCrLf &_
			" not in ( "& vbCrLf &_
			"        select b.asig_ccod  "& vbCrLf &_
			"        from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			"        where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			"        and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			"        and EXISTS (SELECT 1  "& vbCrLf &_
			"                            FROM secciones sa, "& vbCrLf &_
			"                                 cargas_academicas sb, "& vbCrLf &_
			"                                 alumnos sc "& vbCrLf &_
			"                           WHERE sa.secc_ccod = sb.secc_ccod "& vbCrLf &_
			"                             AND sa.asig_ccod = b.asig_ccod "& vbCrLf &_
			"                             AND sb.matr_ncorr = sc.matr_ncorr "& vbCrLf &_
			"                             AND isnull(sb.sitf_ccod,'1') = '1' "& vbCrLf &_
			"                             AND sc.emat_ccod = 1 "& vbCrLf &_
			"                             AND cast(sc.pers_ncorr as varchar) = '"&pers_ncorr&"') "& vbCrLf &_
			"        union all                     "& vbCrLf &_
			"        select b.asig_ccod "& vbCrLf &_
			"        from asignaturas_minor a, malla_curricular b,asignaturas c"& vbCrLf &_
			"        where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			"        and b.asig_ccod = c.asig_ccod"& vbCrLf &_
			"        and EXISTS (SELECT 1 "& vbCrLf &_
			"                            FROM secciones sa,"& vbCrLf &_
			"                                 cargas_academicas sb,"& vbCrLf &_
			"                                 alumnos sc,"& vbCrLf &_
			"                                 situaciones_finales sd"& vbCrLf &_
			"                           WHERE sa.secc_ccod = sb.secc_ccod"& vbCrLf &_
			"                             AND sa.asig_ccod = b.asig_ccod"& vbCrLf &_
			"                             AND sb.matr_ncorr = sc.matr_ncorr"& vbCrLf &_
			"                             AND sb.sitf_ccod = sd.sitf_ccod"& vbCrLf &_
			"                             and not exists (select 1 from equivalencias eq where eq.matr_ncorr = sb.matr_ncorr and eq.secc_ccod = sb.secc_ccod)"& vbCrLf &_
			"                             AND cast(sd.sitf_baprueba as varchar) = 'S'"& vbCrLf &_
			"                             AND sc.emat_ccod = 1"& vbCrLf &_
			"                             AND cast(sc.pers_ncorr as varchar) = '"&pers_ncorr&"')"& vbCrLf &_
			"        union all"& vbCrLf &_
			"        select b.asig_ccod"& vbCrLf &_
			"        from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			"        where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			"        and b.asig_ccod = c.asig_ccod"& vbCrLf &_
			"        and EXISTS (  select 1 "& vbCrLf &_
			"			        from  "& vbCrLf &_
			"				         convalidaciones a "& vbCrLf &_
			"				         , alumnos b1 "& vbCrLf &_
			"				         , actas_convalidacion d "& vbCrLf &_
			"				         , situaciones_finales h "& vbCrLf &_
			"			        where "& vbCrLf &_
			"				         a.matr_ncorr=b1.matr_ncorr "& vbCrLf &_
			"				         and a.acon_ncorr=d.acon_ncorr "& vbCrLf &_
			"				         and a.asig_ccod=b.asig_ccod "& vbCrLf &_
			"				         and a.sitf_ccod=h.sitf_ccod "& vbCrLf &_
			"				         and cast(h.sitf_baprueba as varchar)='S' "& vbCrLf &_
			"                         AND cast(b1.pers_ncorr as varchar) = '"&pers_ncorr&"')"& vbCrLf &_
			"        union all "& vbCrLf &_
			"        			select b.asig_ccod  "& vbCrLf &_
			"        from asignaturas_minor a, malla_curricular b,asignaturas c "& vbCrLf &_
			"        where cast(minr_ncorr as varchar)='"&minr_ncorr&"' and a.mall_ccod = b.mall_ccod "& vbCrLf &_
			"        and b.asig_ccod = c.asig_ccod "& vbCrLf &_
			"        and EXISTS (select  1 "& vbCrLf &_
			"		   		  		           from  "& vbCrLf &_
			"								        equivalencias a  "& vbCrLf &_
			"								        , secciones c  "& vbCrLf &_
			"								        , alumnos g  "& vbCrLf &_
			"                                        , cargas_Academicas b1 "& vbCrLf &_
			"								        , situaciones_finales sf  "& vbCrLf &_
			"							        where  "& vbCrLf &_
			"								         a.secc_ccod=c.secc_ccod  "& vbCrLf &_
			"								         and a.matr_ncorr=g.matr_ncorr  "& vbCrLf &_
			"								         and a.asig_ccod=b.asig_ccod  "& vbCrLf &_
			"                                         and a.matr_ncorr = b1.matr_ncorr and a.secc_ccod = b1.secc_ccod "& vbCrLf &_
			"								         and b1.sitf_ccod = sf.sitf_ccod  "& vbCrLf &_
			"								         and cast(sf.sitf_baprueba as varchar)='S'   "& vbCrLf &_
			"                                         AND cast(g.pers_ncorr as varchar) = '"&pers_ncorr&"')           )"
 
 
 f_secciones.inicializaListaDependiente "lBusqueda", consulta

 f_secciones.Siguiente

   consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod not in (9,6,7,5,11)"&_
				  " and cast(c.peri_ccod as varchar)='"&periodo&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
	
	if matr_ncorr = "" or EsVAcio(matr_ncorr) then
		sin_matricula = true
	end if

cantidad_a_asignar = conexion.consultaUno("select count(*) from ("&consulta&")aaa")
'response.Write(cantidad_a_asignar)
'response.Write(matr_ncorr)
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
function horario(){
	self.open('../toma_carga_final/horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
</script>
<% f_secciones.generaJS %>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Asignaturas Minor del Alumno"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><%pagina.DibujarSubtitulo minr_tdesc %>
						
                          <table width="100%" border="0">
                            <tr> 
                              <td width="17%"><strong>Rut Alumno</strong></td>
                              <td width="2%"><div align="center"><strong>:</strong></div></td>
                              <td width="81%"><%=rut_alumno%></td>
                            </tr>
							<tr> 
                              <td width="17%"><strong>Nombre</strong></td>
                              <td width="2%"><div align="center"><strong>:</strong></div></td>
                              <td><%=nombre_alumno%></td>
                            </tr>
							<tr> 
                              <td width="17%"><strong>Periodo</strong></td>
                              <td width="2%"><div align="center"><strong>:</strong></div></td>
                              <td><%=periodo_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="17%"><strong>Carrera</strong></td>
                              <td width="2%"><div align="center"><strong>:</strong></div></td>
                              <td><%=carrera%></td>
                            </tr>
							<tr> 
                              <td width="17%">&nbsp;</td>
                              <td width="2%">&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
							<tr> 
                              <td colspan="3" align="left"><strong>- Listado de asignaturas cursadas por el alumno</strong></td>
                            </tr>
							<tr> 
                              <td colspan="3" align="left">&nbsp;</td>
                            </tr>
							<tr> 
                              <td colspan="3" align="center"><%f_asignaturas_alumnos.DibujaTabla()%></td>
                            </tr>
							<tr> 
                              <td colspan="3" align="left">&nbsp;</td>
                            </tr>
							<%if cantidad_a_asignar > "0" then%>
							<tr> 
                              <td colspan="3" align="left"><strong>- Seleccione la asignatura del minor que desea agregar al alumno.</strong></td>
                            </tr>
							<tr> 
                              <td colspan="3" align="left">
							  <table width="100%" border="1"><tr><td align="center">
							  		<table border="0" width="80%">
									   <tr> 
											<td width="13%"> <div align="left">Asignatura</div></td>
											<td width="2%"> <div align="center">:</div> </td>
											<td width="54%"><% f_secciones.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
											<td width="31%"> <div align="center">
											                  <% if sin_matricula then
															          botonera.agregaBotonParam "asignar","deshabilitado","TRUE"
															     end if
															      botonera.dibujaboton "asignar"
															  %>
															  </div> </td>
										  </tr>
										  <tr> 
											<td width="13%"> <div align="left">Sección</div></td>
											<td width="2%"> <div align="center">:</div> </td>
											<td colspan="2"><% f_secciones.dibujaCampoLista "lBusqueda", "secc_ccod"%>
											<input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
											</td>
										  </tr>
										  <tr> 
											<td colspan="4" align="left"><strong>Atención: </strong>Cualquier asignatura de Minor que asigne al alumno, formará parte de su carga académica y por tanto debe ser aprobada, teniendo las mismas limitaciones de cupos y topones que tiene la carga normal.</td>
										  </tr>
									</table></td></tr></table>
									
							  </td>
                            </tr>
							<%end if%>
                           </table>
                          </td>
                      </tr>
                    </table>
                    
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="53%"><div align="center">
                            <% botonera.agregaBotonParam "volver", "url", "alumnos_minor.asp?busqueda[0][minr_ncorr]=" & minr_ncorr & ""
							   botonera.dibujaBoton "volver" %>
                          </div></td>
						  <td><div align="center">
								<%botonera.DibujaBoton "HORARIO"%>
							  </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
