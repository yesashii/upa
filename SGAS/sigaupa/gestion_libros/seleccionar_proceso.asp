<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Prestar o Devolver el libro"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Planificacion")
'---------------------------------------------------------------------------------------------------
pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
bloq_ccod = request.querystring("bloq_ccod")
libr_ncorr = request.querystring("libr_ncorr")
'pres_ncorr = request.querystring("pres_ncorr")

   if libr_ncorr <> "0" then
   		estado_libro = conexion.consultaUno("select libr_nestado from libros_clases where cast(libr_ncorr as varchar)='"&libr_ncorr&"'")
   else
   		'si el libro no esta creado en esta misma página lo debemos crear y devolver un mensaje como libro creado
		libr_ncorr=conexion.consultauno("execute obtenersecuencia 'libros_clases'")
		sede_temporal = conexion.consultaUno("select sede_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		jornada_temporal = conexion.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		carrera_temporal = conexion.consultaUno("select carr_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		asignatura_temporal = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		periodo_temporal = conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		consulta_insercion = " insert into libros_clases (LIBR_NCORR,SECC_CCOD,SEDE_CCOD,JORN_CCOD,CARR_CCOD,ASIG_CCOD,pers_ncorr,LIBR_NESTADO,PERI_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
						     " values("&libr_ncorr&","&secc_ccod&","&sede_temporal&","&jornada_temporal&",'"&carrera_temporal&"','"&asignatura_temporal&"',"&pers_ncorr&",null,"&periodo_temporal&",'creación de libro',getDate())"
		
		'response.Write(consulta_insercion)
		conexion.ejecutaS consulta_insercion
		session("mensajeError") = "El Libro ha sido creado con exito, ahora podrá disponer de el para hacer lo prestamos"
		%>
		<script language="javascript" src="../biblioteca/funciones.js"></script>
		<script language="javascript">
				CerrarActualizar();
				//alert("volver a la otra pagina");
		</script>
		<%
		
   end if
   '--------------si estado del libro es igual a prestado debemos revisar si se presto para el bloque seleccionado o para otro
   '--------en caso de ser otro el bloque de prestamo debemos dejar el estado como disponible para poderlo prestar y así evitar
   '---------el problema de inasistencias que figuraba en el sistema,   ----- agregado por MSandoval 18-04-2006
   
   if estado_libro = "2" then
      prestado_bloque = conexion.consultaUno("select count(*) from prestamos_libros cc where cast(cc.bloq_ccod as varchar) = '"&bloq_ccod&"' and cast(cc.libr_ncorr as varchar) = '"&libr_ncorr&"' and cc.pres_fdevolucion is null and cc.pres_estado_devolucion is null")
       if prestado_bloque = "0" then
	   		estado_libro = null
	   end if
	else
	  prestado_bloque = conexion.consultaUno("select count(*) from prestamos_libros cc where cast(cc.bloq_ccod as varchar) = '"&bloq_ccod&"' and cast(cc.libr_ncorr as varchar) = '"&libr_ncorr&"' and cc.pres_fdevolucion is null and cc.pres_estado_devolucion is null")
       if prestado_bloque <> "0" then
	   		estado_libro = "2"
	   end if   
   end if
   
   '------------------------------en caso que el prestamo ya se halla devuelto debemos anular el pres_ncorr------------------
   if estado_libro="2" then'el libro esta prestado s debe buscar el último prestamo que tiene sin devolución
   		pres_ncorr=conexion.consultaUno("select pres_ncorr from prestamos_libros where pres_fdevolucion is null and pres_estado_devolucion is null and cast(libr_ncorr as varchar)='"&libr_ncorr&"'")
   else
		pres_ncorr=null
		estado_libro=null	
   end if
   'response.Write(pres_ncorr)
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "asignaturas_diarias.xml", "botonera_prestamo"
'--------------------------------------------------------------------------
sede = conexion.consultaUno("select sede_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombre_carrera= conexion.consultaUno("select carr_tdesc from secciones a, carreras b where cast(secc_ccod as varchar)='"&secc_ccod&"' and a.carr_ccod = b.carr_ccod")
nombre_asignatura= conexion.consultaUno("select ltrim(rtrim(b.asig_ccod)) +'-->' + asig_tdesc from secciones a, asignaturas b where cast(secc_ccod as varchar)='"&secc_ccod&"' and a.asig_ccod = b.asig_ccod")
fecha_01 = Date & " " & Time
'estado_libro = conexion.consultaUno("select libr_nestado from libros_clases where cast(libr_ncorr as varchar)='"&libr_ncorr&"'")
'----------------------------------------------cálculo de horas -------------------------------
consulta_hora = " select datepart(hour,b.hora_hinicio) as hora "& vbcrlf & _
				" from bloques_horarios a, horarios_sedes b "& vbcrlf & _
			    " where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "& vbcrlf & _
				" and a.hora_ccod=b.hora_ccod "& vbcrlf & _
				" and cast(b.sede_ccod as varchar) = '"&sede&"' "
hora_inicio = conexion.consultaUno(consulta_hora)

consulta_minuto = " select datepart(minute,b.hora_hinicio) as minuto "& vbcrlf & _
				" from bloques_horarios a, horarios_sedes b "& vbcrlf & _
			    " where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "& vbcrlf & _
				" and a.hora_ccod=b.hora_ccod "& vbcrlf & _
				" and cast(b.sede_ccod as varchar) = '"&sede&"' "				
minuto_inicio = conexion.consultaUno(consulta_minuto)

consulta_hora = " select datepart(hour,b.hora_htermino) as hora "& vbcrlf & _
				" from bloques_horarios a, horarios_sedes b "& vbcrlf & _
			    " where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "& vbcrlf & _
				" and a.hora_ccod=b.hora_ccod "& vbcrlf & _
				" and cast(b.sede_ccod as varchar) = '"&sede&"' "
hora_fin = conexion.consultaUno(consulta_hora)

consulta_minuto = " select datepart(minute,b.hora_htermino) as minuto "& vbcrlf & _
				" from bloques_horarios a, horarios_sedes b "& vbcrlf & _
			    " where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "& vbcrlf & _
				" and a.hora_ccod=b.hora_ccod "& vbcrlf & _
				" and cast(b.sede_ccod as varchar) = '"&sede&"'"				
minuto_fin = conexion.consultaUno(consulta_minuto)

consulta_hora = " select datepart(hour,getDate())"
hora_gestion = conexion.consultaUno(consulta_hora)

consulta_minuto = " select datepart(minute,getDate())"
minuto_gestion = conexion.consultaUno(consulta_minuto)

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////Nueva versión prestamo libros////////////////////////////////////////////
consulta_prueba_1 =   " select protic.trunc(getDate()) + ' ' + case when datepart(hour,b.hora_hinicio) < 10 then '0' + cast(datepart(hour,b.hora_hinicio) as varchar) else cast(datepart(hour,b.hora_hinicio) as varchar) end +':'+ "& vbcrlf & _
					" case when datepart(minute,b.hora_hinicio) < 10 then '0' + cast(datepart(minute,b.hora_hinicio) as varchar) else cast(datepart(minute,b.hora_hinicio) as varchar) end +':00.000'"& vbcrlf & _    
					" from bloques_horarios a, horarios_sedes b "& vbcrlf & _
					" where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "& vbcrlf & _
					" and a.hora_ccod=b.hora_ccod "& vbcrlf & _
					" and cast(b.sede_ccod as varchar) = '"&sede&"'"				
fecha_prueba_01 = conexion.consultaUno(consulta_prueba_1)
'response.Write(fecha_prueba_01)
diferencia_prestamo = conexion.consultaUno("select datediff(minute,'"&fecha_prueba_01&"',getDate())")
'response.Write("<br>"&diferencia_prestamo)
estado_prestamo = 0
if clng(diferencia_prestamo) < 0  then
	estado_prestamo = 1
else
	estado_prestamo = 2	
end if
'response.Write("<br> "&estado_prestamo)
'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


hora_inicio=conexion.consultaUno("select '"&hora_inicio&"' + ':' + '"&minuto_inicio&"'")
hora_gestion=conexion.consultaUno("select '"&hora_gestion&"'  + ':' + '"&minuto_gestion&"'")
diferencia = conexion.consultaUno("select datediff(minute,'"&hora_inicio&"','"&hora_gestion&"')")
'response.Write("diferencia "&diferencia)
'diferencia_prestamo = diferencia
'estado_prestamo=0
'if (hora_gestion < hora_inicio) then
'	estado_prestamo = 1'horario de prestamo correcto, hora acertada
'elseif (hora_gestion >= hora_inicio) and (hora_gestion <= hora_fin) then
	'if (diferencia <= 0) then
'		estado_prestamo = 1 'horario de prestamo correcto, minutos antes de comenzar la clases.
'	else
'		estado_prestamo = 2 'horario de prestamo atrasado, minutos despues de comenzar las clases.	
'	end if
'elseif (hora_gestion > hora_fin) then
'	estado_prestamo = 2 
'end if
'response.Write("==> "&estado_prestamo)
'---------------------------ahora nos vamos con las devoluciones----------------
consulta_diferencia_dias = "  select isnull(dateDiff(day,pres_fprestamo,getDate()),0) as diferencia "& vbcrlf & _
						   " from prestamos_libros "& vbcrlf & _
						   " where cast(pres_ncorr as varchar)='"&pres_ncorr&"' "
			   			   
diferencia_dias = conexion.consultaUno(consulta_diferencia_dias)
hora_termino=conexion.consultaUno("select '"&hora_fin&"' + ':' + '"&minuto_fin&"'")
diferencia_devolucion = conexion.consultaUno("select datediff(minute,'"&hora_gestion&"','"&hora_termino&"')")
'response.Write("select datediff(minute,'"&hora_gestion&"','"&hora_termino&"')")				
estado_devolucion = 0
if diferencia_dias > "0" then
	estado_devolucion = 3
else

if (hora_gestion < hora_inicio) then
	estado_devolucion = 3
else
	if (hora_gestion > hora_termino) then
	     'response.Write("entre al de horas ("&hora_gestion&">"&hora_termino)
		estado_devolucion = 3'horario de devolución correcto, hora acertada despues de clases
	elseif (hora_gestion <= hora_termino) and (diferencia_devolucion > 0 ) then
	   'response.Write("y ahora acá")
		estado_devolucion = 4 'horario de devolución adelantada, minutos antes de terminar las clases.	
	end if
end if	
end if
'response.Write(estado_devolucion)
'----------------------------------------------fin de cálculos----------------------------------
prestamo= conexion.consultaUno("select espr_tdesc from estados_prestamo where cast(espr_ccod as varchar)='"&estado_prestamo&"'")
devolucion= conexion.consultaUno("select espr_tdesc from estados_prestamo where cast(espr_ccod as varchar)='"&estado_devolucion&"'")
'response.Write("prestamo "&prestamo&" devolucion "&devolucion)

'----------------------debemos cuidar que el docente no halla renunciado a la clase-------------------------

retirado = conexion.consultaUno("select count(*) from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and isnull(ebpr_ccod,1)=2")

'response.Write(retirado)
if retirado <> "0" then
    consulta_nuevo= " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' -->RUT: ' +cast(b.pers_nrut as varchar)+'-'+b.pers_xdv "& vbcrlf & _
					" from bloques_profesores a, personas b  "& vbcrlf & _
					" where cast(a.bloq_ccod as varchar)='"&bloq_ccod&"'  "& vbcrlf & _
				    " and cast(a.pers_ncorr as varchar) <> '"&pers_ncorr&"' "& vbcrlf & _
					" and tpro_ccod=1 and isnull(ebpr_ccod,1)=1 "& vbcrlf & _
					" and a.pers_ncorr = b.pers_ncorr"
	nuevo_profesor= conexion.consultaUno(consulta_nuevo)
end if

set f_observacion = new CFormulario
f_observacion.Carga_Parametros "asignaturas_diarias.xml", "f_observaciones"
f_observacion.Inicializar conexion
f_observacion.Consultar "select ''"
if not esVacio(estado_libro) then
	cons_obs = "(select opli_ccod,opli_tdesc from observaciones_prestamos_libros where opli_ccod in (8,9,10,11))a"
else
	cons_obs = "(select opli_ccod,opli_tdesc from observaciones_prestamos_libros where opli_ccod in (1,2,3,4,6,7))a"
end if

f_observacion.AgregaCampoParam "opli_ccod","destino" , cons_obs 
f_observacion.Siguiente

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

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="403" height="207" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="448" valign="top" bgcolor="#EAEAEA">
	<br>
	<form name="edicion">
   	<table width="72%" height="190" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="79%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="359" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="360" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="7" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="122" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">¿Qu&eacute; 
                          desea hacer?</font></div></td>
                      <td width="231" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="360" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              
            <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
              <tr>
                  <td width="1" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td width="380" bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
					<br><% if not esVacio(estado_libro) then%>
						<font color="#0000CC"><strong>(Libro Prestado)</strong></font>
					<%end if%><br>
                  </div>
                  <table  width="100%" border="0">
				    <tr> 
                      <td colspan="3" bgcolor="#990000" align="center"><font size="1" color="#FFFFFF"><strong>Opción válida sólo para registro de Préstamos y Devoluciones</strong></font></td>
                    </tr>
                    <tr> 
                      <td width="20%"><strong>Docente</strong></td>
					  <td width="2%"><strong>:</strong></td>
					  <td width="78%"><%=nombre_docente%></td>
                    </tr>
					<tr> 
                      <td width="20%"><strong>Carrera</strong></td>
					  <td width="2%"><strong>:</strong></td>
					  <td width="78%"><%=nombre_carrera%></td>
                    </tr>
					 <tr> 
                      <td width="20%"><strong>Asignatura</strong></td>
					  <td width="2%"><strong>:</strong></td>
					  <td width="78%"><%=nombre_asignatura%></td>
                    </tr>
					<tr> 
                      <td width="20%"><strong>Fecha</strong></td>
					  <td width="2%"><strong>:</strong></td>
					  <td width="78%"><%=fecha_01%></td>
                    </tr>
					<tr> 
                      <td width="20%"><strong>Observaci&oacute;n</strong></td>
					  <td width="2%"><strong>:</strong></td>
					  <td width="78%"><% f_observacion.dibujaCampo ("opli_ccod") %></td>
                    </tr>
					<tr>
					  <td colspan="3" bgcolor="#333333" align="center"><% if (not esVacio(estado_libro)) or libr_ncorr= "0"  then
																					   botonera.agregaBotonParam "prestar_correcto","deshabilitado","TRUE"
																				  end if
																			botonera.dibujaboton "prestar_correcto"%>
					 </td>
					</tr>
					<%if retirado <> "0" then%>
					<tr> 
                      <td  colspan="3"><strong>Docente eliminado de esta clase y reemplazado por : <%=nuevo_profesor%></strong></td>
					</tr>
					<%end if%>
				  </table> 
                  <br></td>
                 <td width="10" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              
            <table width="100%" height="26" border="0" cellpadding="0" cellspacing="0">
              
			  <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="123" nowrap bgcolor="#D8D8DE">
				  <table width="53%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="32%">
                        <%  botonera.dibujaboton "cancelar"%>
                      </td>
					  <td width="31%">
                        <% if (not esVacio(estado_libro)) or libr_ncorr= "0"  then
						       botonera.agregaBotonParam "prestar","deshabilitado","TRUE"
						  end if
						  botonera.dibujaboton "prestar"%>
                      </td>
					   <td width="31%">
                        <% if (esVacio(pres_ncorr)) then
						       botonera.agregaBotonParam "devolver","deshabilitado","TRUE"
						  end if 
						   botonera.dibujaboton "devolver"%>
                      </td>
                    </tr>
					<input type="hidden" name="bloq_ccod" value="<%=bloq_ccod%>">
					<input type="hidden" name="libr_ncorr" value="<%=libr_ncorr%>">
					<input type="hidden" name="estado_prestamo" value="<%=estado_prestamo%>">
					<%if estado_prestamo = 2 then%>
						<input type="hidden" name="diferencia_prestamo" value="<%=diferencia_prestamo%>">
					<%end if%>
					<input type="hidden" name="estado_devolucion" value="<%=estado_devolucion%>">
					<%if estado_devolucion = 4 then %>
						<input type="hidden" name="diferencia_devolucion" value="<%=diferencia_devolucion%>">
					<%end if%>
					<input type="hidden" name="pres_ncorr" value="<%=pres_ncorr%>">
                  </table>
				  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="119" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
				
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	  </form>	
   </td>
  </tr>  
</table>
</body>
</html>
