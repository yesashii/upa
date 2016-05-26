<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

pagina.Titulo = "Resumen general por Escuelas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Planificacion")
peri = negocio.obtenerPeriodoAcademico("CLASES18")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")


ano_seleccionado = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_actual = conexion.consultaUno("Select datepart(year,getDate())")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_seleccionado&"' and plec_ccod=1 ")

if cint(ano_seleccionado)=cint(ano_actual) then
	correcto="S"
else
	correcto="S"
end if


'---------------------------------------------------------------------------------------------------
sede_ccod   =   request.QueryString("a[0][sede_ccod]")
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
jorn_ccod   =   request.QueryString("a[0][jorn_ccod]")
inicio = request.querystring("inicio")
termino = request.querystring("termino")
estado_prestamo = request.querystring("estado_prestamo")
'response.Write("estado "&estado_prestamo)
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "resumen_escuelas.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "resumen_escuelas.xml", "listado_asignaturas"
formulario.Inicializar conexion 
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
	set f_filtros = new cFormulario
	f_filtros.carga_parametros "resumen_escuelas.xml", "buscador"
	f_filtros.inicializar conexion
	consulta="Select '"&carr_ccod&"' as carr_ccod, '"&sede_ccod&"' as sede_ccod, '"&jorn_ccod&"' as jorn_ccod"
	f_filtros.consultar consulta
	consulta = " select distinct b.carr_ccod,b.carr_tdesc,c.sede_ccod,c.sede_tdesc,d.jorn_ccod,d.jorn_tdesc " & vbCrLf & _
			   " from secciones a,carreras b,sedes c, jornadas d,asignaturas e " & vbCrLf & _
			   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
			   " and a.sede_ccod = c.sede_ccod " & vbCrLf & _
			   " and a.asig_ccod = e.asig_ccod " & vbCrLf & _
			   " and a.jorn_ccod = d.jorn_ccod " & vbCrLf & _
			   " and cast(a.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end " & vbCrLf & _
			   " order by sede_tdesc,carr_tdesc,jorn_tdesc" 	
	
	f_filtros.inicializaListaDependiente "filtros", consulta
	f_filtros.siguiente
	'-----------------------------------------------------------------------------------------------------------------

filtro=""
if not esVacio(carr_ccod) then 
	filtro = filtro & " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
end if

if not esVacio(sede_ccod) then 
	filtro = filtro & " and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"
end if
	
if not esVacio(jorn_ccod) then 
	filtro = filtro & " and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"'"	
end if

if filtro="" then
filtro=" and 1=2"
end if

'response.End()

filtro_2 = ""
if not esVacio(inicio) and not esVacio(termino) then
	filtro_2 = "and convert(varchar,pres.pres_fprestamo,103) between " & vbcrlf & _
	           " case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end  " & vbcrlf & _
			   " and case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end"
elseif not esVacio(inicio) and  esVacio(termino) then
	filtro_2 = "and convert(varchar,pres.pres_fprestamo,103) between " & vbcrlf & _
	           " case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end  " & vbcrlf & _
			   " and case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end"
elseif esVacio(inicio) and  not esVacio(termino) then
	filtro_2 = " and convert(varchar,pres.pres_fprestamo,103) between convert(varchar,b.bloq_finicio_modulo,103) " & vbcrlf & _
			   " and case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end"
else
 filtro_2 = "and convert(datetime,pres.pres_fprestamo,103) between convert(datetime,b.bloq_finicio_modulo,103) and case when convert(datetime,b.bloq_ftermino_modulo,103) < convert(datetime,getDate(),103) then convert(datetime,b.bloq_ftermino_modulo,103) else convert(datetime,getDate(),103) end "
end if

filtro_3=""
if not esVacio(estado_prestamo) then
	filtro_3=" and cast(k.espr_ccod as varchar)='"&estado_prestamo&"'"
end if

'response.Write("<pre>"&filtro_2&"</pre>")
consulta = " select distinct d.carr_tdesc as carrera,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,pres.pres_fprestamo, " & vbcrlf & _
		   " protic.trunc(pres.pres_fprestamo) as fecha,pp.pers_tnombre + ' '+ pp.pers_tape_paterno as docente, " & vbcrlf & _
		   " cast(datepart(hour,j.hora_hinicio) as varchar)+':'+cast(datepart(minute,j.hora_hinicio) as varchar)+' A '+cast(datepart(hour,j.hora_htermino) as varchar)+':'+cast(datepart(minute,j.hora_htermino) as varchar) as horario, " & vbcrlf & _
		   " '<font color=''' + case k.espr_ccod when 4 then '#009966' when 2 then '#0033FF' when 5 then '#FF6600' when 6 then '#FF0000' when 8 then '#FF0033' end +'''>' + k.espr_tdesc + '</font>' as estado,'' as fecha_recuperacion " & vbcrlf & _
		   " from secciones a, bloques_horarios b,carreras d,personas pp, " & vbcrlf & _
		   "  	  asignaturas e, libros_clases g,dias_semana h,horarios i,prestamos_libros pres,horarios_sedes j,estados_prestamo k " & vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod  "& filtro & vbcrlf & _
		   "	and a.carr_ccod=d.carr_ccod " & vbcrlf & _
		   "	and a.asig_ccod=e.asig_ccod " & vbcrlf & _
		   "	and a.secc_ccod=g.secc_ccod " & vbcrlf & _
		   "	and g.pers_ncorr=pp.pers_ncorr" & vbcrlf & _
		   "    and b.hora_ccod=j.hora_ccod and a.sede_ccod=j.sede_ccod " & vbcrlf & _
		   "	and datepart(weekday,pres.pres_fprestamo) = b.dias_ccod " & vbcrlf & _
		   "	and g.libr_ncorr=pres.libr_ncorr and b.bloq_ccod=pres.bloq_ccod " & vbcrlf & _
		   "    and (pres.pres_estado_prestamo in (2,5,6) or pres.pres_estado_devolucion=4) " & vbcrlf & _
		   "    "& filtro_2 & vbcrlf & _
		   "    and k.espr_ccod = case when pres.pres_estado_devolucion=4 then pres.pres_estado_devolucion else pres.pres_estado_prestamo end " & vbcrlf & _
		   " 	and cast(a.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end  " & vbcrlf & _
		   "	"& filtro_3 & vbcrlf & _
   	       "	and datepart(year,pres.pres_fprestamo)='"&anos_ccod&"' "& vbcrlf & _
		   " UNION ALL" &vbcrlf &_
		   " select distinct d.carr_tdesc as carrera,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,pres.pres_fprestamo, " & vbcrlf & _
		   " protic.trunc(pres.pres_fprestamo) as fecha,pp.pers_tnombre + ' '+ pp.pers_tape_paterno as docente, " & vbcrlf & _
		   " cast(datepart(hour,j.hora_hinicio) as varchar)+':'+cast(datepart(minute,j.hora_hinicio) as varchar)+' A '+cast(datepart(hour,j.hora_htermino) as varchar)+':'+cast(datepart(minute,j.hora_htermino) as varchar) as horario, " & vbcrlf & _
		   " '<font color=''' + case k.espr_ccod when 4 then '#009966' when 2 then '#0033FF' when 5 then '#FF6600' when 6 then '#FF0000' when 8 then '#FF0033' end +'''>' + k.espr_tdesc + '</font>' as estado,protic.trunc(fecha_recuperacion) as fecha_recuperacion " & vbcrlf & _
		   " from secciones a, bloques_horarios b,carreras d,personas pp, " & vbcrlf & _
		   "  	  asignaturas e, libros_clases g,dias_semana h,horarios i,registro_recuperativas pres,horarios_sedes j,estados_prestamo k " & vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod  "& filtro & vbcrlf & _
		   "	and a.carr_ccod=d.carr_ccod " & vbcrlf & _
		   "	and a.asig_ccod=e.asig_ccod " & vbcrlf & _
		   "	and a.secc_ccod=g.secc_ccod " & vbcrlf & _
		   "	and g.pers_ncorr=pp.pers_ncorr" & vbcrlf & _
		   "    and b.hora_ccod=j.hora_ccod and a.sede_ccod=j.sede_ccod " & vbcrlf & _
		   "	and datepart(weekday,pres.pres_fprestamo) = b.dias_ccod " & vbcrlf & _
		   "	and g.libr_ncorr=pres.libr_ncorr and b.bloq_ccod=pres.bloq_ccod " & vbcrlf & _
		   "    and (pres.pres_estado_prestamo in (2,5,6)) " & vbcrlf & _
		   "    "& filtro_2 & vbcrlf & _
		   "    and k.espr_ccod = pres.pres_estado_prestamo " & vbcrlf & _
		   " 	and cast(a.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end  " & vbcrlf & _
		   "	"& filtro_3 & vbcrlf & _
   	       "	and datepart(year,pres.pres_fprestamo)='"&anos_ccod&"' "& vbcrlf & _
		   " 	order by pres.pres_fprestamo"		   
		   
'response.Write("<pre>"&consulta&"</pre>")
		   
formulario.Consultar consulta

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","filtrador","fecha_oculta_inicio"
	calendario.MuestraFecha "termino","2","filtrador","fecha_oculta_termino"
	calendario.FinFuncion
%>
<% f_filtros.generaJS %>
   
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="15%">Sede</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "sede_ccod"%></td>
                                    </tr>
									<tr> 
                                      <td width="15%">Carrera</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "carr_ccod"%></td>
                                    </tr>
									<tr> 
                                      <td width="15%">Jornada</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "jorn_ccod"%></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE" width="670">&nbsp; 
				  
				  <%'if correcto="S" then %>
					 <div align="center">&nbsp;  
						<BR>
						<%pagina.DibujarTituloPagina%>
						<br><br>
					  </div>
					  <table  width="100%" border="0">
						<form name="filtrador">
						<input name="a[0][sede_ccod]" value="<%=sede_ccod%>" type="hidden">
						<input name="a[0][carr_ccod]" value="<%=carr_ccod%>" type="hidden">
						<input name="a[0][jorn_ccod]" value="<%=jorn_ccod%>" type="hidden">
						 <tr> 
							 <td width="16%"><strong>Inicio</strong></td>
							 <td width="1%"><strong>:</strong></td>
							 <td width="42%"><input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>"> 
							  <%calendario.DibujaImagen "fecha_oculta_inicio","1","filtrador" %></td>
							 <td><strong>T&eacute;rmino</strong></td>
							 <td>:</td>
							 <td width="33%"><div align="left"><input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>">
										   <%calendario.DibujaImagen "fecha_oculta_termino","2","filtrador" %></div></td>
						 </tr>
						 <tr> 
						  <td width="16%"><strong>Ver</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="42%"><select name='estado_prestamo'>
						    					  <%if estado_pretamo="" then%>
                            					  <option value='' selected>TODOS</option>
											      <%else%>
												  <option value=''>TODOS</option>
												  <%end if%>
												  <%if estado_prestamo="2" then%>
												  <option value='2' selected>ATRASOS</option>
												  <%else%>
												  <option value='2' >ATRASOS</option>
												  <%end if%>
												  <%if estado_prestamo="4" then%>
												  <option value='4' selected>SALIDAS ANTICIPADAS</option>
												  <%else%>
												 <option value='4' >SALIDAS ANTICIPADAS</option>
												  <%end if%>
												  <%if estado_prestamo="5" then%>
												  <option value='5' selected>CLASES RECUPERADAS</option>
												  <%else%>
												 <option value='5' >CLASES RECUPERADAS</option>
												  <%end if%>
												  <%if estado_prestamo="6" then%>
												  <option value='6' selected>INASISTENCIAS</option>
												  <%else%>
												 <option value='6' >INASISTENCIAS</option>
												  <%end if%>
											    </select>
								</td>
								<td colspan="3" align="center"><% botonera.dibujaboton "filtrar"%></td>
    					</tr>
						<tr> <td colspan="6"><div align="right">&nbsp;</div></td></tr>
						</form>
						<tr> 
						  <td colspan="6"><div align="right">P&aacute;ginas: &nbsp;<%formulario.AccesoPagina%></div></td>
						</tr>
						<form name="edicion">
						<tr> 
						  <td colspan="6"><div align="center"><% formulario.DibujaTabla %></div></td>
						</tr>
						</form>
						<%if not esVacio(inicio) or not esVacio(termino) or not esVacio(estado_prestamo) then%>
					    <tr> 
						  <td colspan="6"><div align="center"><font color="#FF0000">* observacion:</font> El reporte de todas las carreras se ver&aacute; afectado por las fechas y/o Status que usted ha filtrado</div></td>
						</tr> 
						<%end if%>
						<tr> 
						  <td colspan="6">&nbsp;</td>
						</tr>
						</table> 
				
				 <%'else%>
				  <!--<br><font size="2" color="#0000FF"><strong>El periodo de planificación seleccionado no corresponde al año en curso haga el favor de salir de esta funcionalidad y seleccionar el correcto antes de continuar.</strong></font><br><br>-->
				 <%'end if%>
				 </td>
				 <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="95" nowrap bgcolor="#D8D8DE">
				  <table width="249%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="20%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td width="20%"> <div align="center">  
					                   <% if correcto="S" then
					                       botonera.agregabotonparam "excel", "url", "resumen_escuelas_excel.asp?sede_ccod="&sede_ccod&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&inicio="&inicio&"&termino="&termino&"&estado_prestamo="&estado_prestamo
										   botonera.dibujaboton "excel"
										  end if 
										%>
					 </div>
                   </td>
				   <td width="20%"> 
				     <div align="center">  
					 <%if correcto = "S" then 
					   botonera.agregabotonparam "excel_general", "url", "excel_general.asp?inicio="&inicio&"&termino="&termino&"&estado_prestamo="&estado_prestamo
					   botonera.dibujaboton "excel_general"
					   end if
					 %>
					 </div>
                   </td>
				   <td width="20%"> 
					   <%botonera.agregabotonparam "excel_sin_devolver", "url", "sin_devolucion_excel.asp"
					     botonera.dibujaboton "excel_sin_devolver"
					   %>
                   </td>
				   <td width="20%"> 
				     <div align="center">  
					 <%if correcto = "S" then 
					   botonera.agregabotonparam "excel_general_correctos", "url", "excel_general_correctos.asp?inicio="&inicio&"&termino="&termino
					   botonera.dibujaboton "excel_general_correctos"
					   end if
					 %>
					 </div>
                   </td>
                  </tr>
                  </table></td>
                  <td width="345" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
