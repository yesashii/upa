<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.Form()
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
RUT =request.Form("usuario")
session("rut_usuario") = RUT

Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_matriculados_ufe.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 1500000
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos"

set conexion = new CConexion
conexion.Inicializar "upacifico"
carrera =request.Form("busqueda[0][carr_ccod]")
periodo =request.Form("busqueda[0][peri_ccod]")
aran_nano_ingreso = request.Form("busqueda[0][aran_nano_ingreso]")
emat_tdesc = request.Form("busqueda[0][emat_tdesc]")
activa=request.Form("busqueda[0][activa]")
activa_=request.Form("_busqueda[0][activa]")
abandono=request.Form("busqueda[0][abandono]")
abandono_=request.Form("_busqueda[0][abandono]")
anulacion_estudios=request.Form("busqueda[0][anulacion_estudios]")
anulacion_estudios_=request.Form("_busqueda[0][anulacion_estudios]")
anulado=request.Form("busqueda[0][anulado]")
anulado_=request.Form("_busqueda[0][anulado]")
cambio_carrera=request.Form("busqueda[0][cambio_carrera]")
cambio_carrera_=request.Form("_busqueda[0][cambio_carrera]")
cambio_jornada=request.Form("busqueda[0][cambio_jornada]")
cambio_jornada_=request.Form("_busqueda[0][cambio_jornada]")
eliminacion_academica=request.Form("busqueda[0][eliminacion_academica]")
eliminacion_academica_=request.Form("_busqueda[0][eliminacion_academica]")
egresado=request.Form("busqueda[0][egresado]")
egresado_=request.Form("_busqueda[0][egresado]")
eliminado=request.Form("busqueda[0][eliminado]")
eliminado_=request.Form("_busqueda[0][eliminado]")
postergado=request.Form("busqueda[0][postergado]")
postergado_=request.Form("_busqueda[0][postergado]")
retirado=request.Form("busqueda[0][retirado]")
retirado_=request.Form("_busqueda[0][retirado]")
suspendido=request.Form("busqueda[0][suspendido]")
suspendido_=request.Form("_busqueda[0][suspendido]")
suspension_estudios=request.Form("busqueda[0][suspension_estudios]")
suspension_estudios_=request.Form("_busqueda[0][suspension_estudios]")
titulado=request.Form("busqueda[0][titulado]") 
titulado_=request.Form("_busqueda[0][titulado]") 

if activa_<>"" then

activa=activa_

end if

if anulacion_estudios_<>"" then

anulacion_estudios=anulacion_estudios_

end if


if anulado_<>"" then

anulado=anulado_

end if

if cambio_carrera_<>"" then

cambio_carrera=cambio_carrera_

end if

if cambio_jornada_<>"" then

cambio_jornada=cambio_jornada_

end if

if eliminacion_academica_<>"" then

eliminacion_academica=eliminacion_academica_

end if

if egresado_<>"" then

egresado=egresado_

end if

if eliminado_<>"" then

eliminado=eliminado_

end if


if postergado_<>"" then

postergado=postergado_

end if


if retirado_<>"" then

retirado=retirado_

end if

if suspendido_<>"" then

suspendido=suspendido_

end if


if suspension_estudios_<>"" then

suspension_estudios=suspension_estudios_

end if

if titulado_<>"" then

titulado=titulado_

end if

if abandono_<>"" then

abandono=abandono_

end if

if not esVacio(carrera) then
	filtro1= " where cast(cod_carrera as varchar)='"&carrera&"'"
else
	filtro1=" "	
end if


if not esVacio(periodo) then
		
		if esVacio(carrera) then
		filtro2= " where cast(periodo_aca as varchar)='"&periodo&"'"
		else
		filtro2= " and cast(periodo_aca as varchar)='"&periodo&"'"
		end if
	
else
	filtro2=" "	
end if

if not esVacio(aran_nano_ingreso) then
		
		if esVacio(carrera) and esVacio(periodo) then
			filtro3= " where cast(ano_ingreso as varchar)='"&aran_nano_ingreso&"'"
		else
			filtro3= " and cast(ano_ingreso as varchar)='"&aran_nano_ingreso&"'"
		end if
else
	filtro3=" "	
end if

'activa
'anulacion_estudios
'anulado
'cambio_carrera
'cambio_jornada
'eliminacion_academica
'egresado
'eliminado
'postergado
'retirado
'suspendido
'suspension_estudios
'titulado
estados=""
if activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera<>"2" or cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2" or retirado<>"2" or suspendido<>"2" or suspension_estudios<>"2" or titulado<>"2" then
    
		if activa<>"2" then 
			estados=estados&"'"&activa&"'"
		end if
		'-----------------------------------------
		if activa="2" and anulacion_estudios<>"2" then
		
			estados="'"&anulacion_estudios&"'"
		
		elseif activa<>"2" and anulacion_estudios<>"2" then
			
			estados=estados&",'"&anulacion_estudios&"'"
			
		end if
		'---------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado<>"2" then
			estados="'"&anulado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2") and (anulado<>"2") then
			estados=estados&",'"&anulado&"'"
		end if
		
		'---------------------------------------------------
		
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera <>"2" then
			estados="'"&cambio_carrera&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2") and (cambio_carrera <>"2") then 
			estados=estados&",'"&cambio_carrera&"'"
		end if
		
		'-------------------------------------------------------
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada<>"2" then
			estados="'"&cambio_jornada&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2") and (cambio_jornada<>"2") then 
			estados=estados&",'"&cambio_jornada&"'"
		end if
		
		'------------------------------------------------------- 
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica<>"2" then
			estados="'"&eliminacion_academica&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2") and (eliminacion_academica<>"2") then 
			estados=estados&",'"&eliminacion_academica&"'"
		end if
		
		'-------------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado<>"2" then
			estados="'"&egresado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2") and (egresado<>"2") then 
			estados=estados&",'"&egresado&"'"
		end if
		
		'-------------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado<>"2" then
			estados="'"&eliminado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2") and (eliminado<>"2") then 
			estados=estados&",'"&eliminado&"'"
		end if
		
		'-------------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado<>"2" then
			estados="'"&postergado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2") and (postergado<>"2") then 
			estados=estados&",'"&postergado&"'"
		end if
		
		'-------------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado="2" and retirado<>"2" then
			estados="'"&retirado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2") and (retirado<>"2") then 
			estados=estados&",'"&retirado&"'"
		end if
		
		'-------------------------------------------------------
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado="2" and retirado="2" and suspendido<>"2" then
			estados="'"&suspendido&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2" or retirado<>"2") and (suspendido<>"2") then 
			estados=estados&",'"&suspendido&"'"
		end if
		
		'-------------------------------------------------------

		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado="2" and retirado="2" and suspendido="2" and suspension_estudios<>"2" then
			estados="'"&suspension_estudios&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2" or retirado<>"2" or suspendido<>"2") and (suspension_estudios<>"2") then 
			estados=estados&",'"&suspension_estudios&"'"
		end if
		
		'-------------------------------------------------------
		
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado<>"2" and retirado="2" and suspendido="2" and suspension_estudios="2" and  titulado<>"2" then
			estados="'"&titulado&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2" or retirado<>"2" or suspendido<>"2" or suspension_estudios<>"2")  and  (titulado<>"2")  then 
			estados=estados&",'"&titulado&"'"
		end if
		
		if activa="2" and anulacion_estudios="2" and anulado="2" and cambio_carrera ="2" and cambio_jornada="2" and eliminacion_academica="2" and egresado="2" and eliminado="2" and postergado<>"2" and retirado="2" and suspendido="2" and suspension_estudios="2" and  titulado="2" and abandono<>"2" then
			estados="'"&abandono&"'"
		elseif (activa<>"2" or anulacion_estudios<>"2" or anulado<>"2" or cambio_carrera <>"2" or  cambio_jornada<>"2" or eliminacion_academica<>"2" or egresado<>"2" or eliminado<>"2" or postergado<>"2" or retirado<>"2" or suspendido<>"2" or suspension_estudios<>"2" or titulado<>"2")  and  (abandono<>"2")  then 
			estados=estados&",'"&abandono&"'"
		end if
		
		'-------------------------------------------------------
		
		if esVacio(carrera) and esVacio(periodo) and esVacio(aran_nano_ingreso) then
			filtro4= " where cast(estado_academico as varchar)in ("&estados&")"
		else
			filtro4= " and cast(estado_academico as varchar)in ("&estados&")"
		end if
else
	filtro4=" "	
end if




set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla"  'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta="select * from matriculas_totales_ufe "& vbCrLf &_
""&filtro1&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
"order by  ap_paterno,ap_materno,nombre,periodo_aca desc"
'consulta="select * from matriculas_totales_ufe"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>

<br>

<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#FFFFCC"><div align="center"><strong>NUM</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO PATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO MATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>NOMBRES</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FECHA NACIMIENTO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>SEXO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PAÍS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD PARTICULAR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>REGIÓN PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ALUMNO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ES ALUMNO INTERCAMBIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ESTADO_ACADEMICO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONDICIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MATRICULA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MODIFICACION</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FACULTAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COD. CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>JORNADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>ESPECIALIDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO MATRICULA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO ARANCEL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO INGRESO CARRERA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PLAN DE ESTUDIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COLEGIO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO PRUEBA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL REAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS REAL </strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA REAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO PRUEBA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROCEDENCIA EDUCACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ENSEÑANZA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA NACIMIENTO CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>DIRECCIÓN CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CIUDAD CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>EMAIL CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CON CARGA TOMADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CANTIDAD DE ASIGNATURAS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MOROSO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO MOROSIDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CED. IDENTIDAD/CED. PAÍS DE ORIGEN/PASAPORTE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>LICENCIA ENSEÑANZA MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONCENTRACIÓN DE NOTAS ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PUNTAJE P.A.A. / P.S.U.</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>02 FOTOGRAFÍAS TAM. CARNET, NOMBRE/RUT</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CERTIFICADO DE RESIDENCIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>SEGURO DE SALUD (EXTRANJEROS)</strong></div></td>
  </tr>
  <%NUMERO=1
  	rut_pasado=0%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <%if rut_pasado<>f_listado.ObtenerValor("rut") then%>
  <%rut_pasado=f_listado.ObtenerValor("rut")%>
  	<%rut_s=f_listado.ObtenerValor("rut")%></td>
    <%AP_PATERNO_s=f_listado.ObtenerValor("AP_PATERNO")%></td>
    <%AP_MATERNO_s=f_listado.ObtenerValor("AP_MATERNO")%></td>
    <%nombre_s=f_listado.ObtenerValor("nombre")%></td>
	<%fecha_nacimiento_s=f_listado.ObtenerValor("fecha_nacimiento")%></td>
	<%edad_s=f_listado.ObtenerValor("edad")%></td>
	<%sexo_s=f_listado.ObtenerValor("sexo")%></td>
	<%pais_s=f_listado.ObtenerValor("pais")%></td>
	<%email_s=f_listado.ObtenerValor("email")%></td>
	<%dire_particular_s=f_listado.ObtenerValor("dire_particular")%></td>
	<%telefono_particular_s=f_listado.ObtenerValor("telefono_particular")%></td>
	<%comuna_particular_s=f_listado.ObtenerValor("comuna_particular")%>
	<%ciudad_particular_s=f_listado.ObtenerValor("ciudad_particular")%></td>
	<%region_particular_s=f_listado.ObtenerValor("region_particular")%></td>
	<%dire_academica_s=f_listado.ObtenerValor("dire_academica")%></td>
	<%telefono_academica_s=f_listado.ObtenerValor("telefono_academica")%></td>
	<%comuna_academica_s=f_listado.ObtenerValor("comuna_academica")%> 
	 <%ciudad_academica_s=f_listado.ObtenerValor("ciudad_academica")%></td>
	<%tipo_s=f_listado.ObtenerValor("tipo")%></td>
	<%tipo_intercambio_s=f_listado.ObtenerValor("tipo_intercambio")%></td>
	<%estado_academico_s=f_listado.ObtenerValor("estado_academico")%></td>
	<%condicion_s=f_listado.ObtenerValor("condicion")%></td>
	<%observacion_s=f_listado.ObtenerValor("observacion")%></td>
	<%fecha_matricula_s=f_listado.ObtenerValor("fecha_matricula")%></td>
	<%fecha_modificacion_s=f_listado.ObtenerValor("fecha_modificacion")%></td>
	<%facultad_s=f_listado.ObtenerValor("facultad")%></td>
	<%cod_carrera_s=f_listado.ObtenerValor("cod_carrera")%></td>
	<%carrera_s=f_listado.ObtenerValor("carrera")%></td>
	<%sede_s=f_listado.ObtenerValor("sede")%></td>
	<%jornada_s=f_listado.ObtenerValor("jornada")%></td>
	<%especialidad_s=f_listado.ObtenerValor("especialidad")%></td>
	<%ARAN_MMATRICULA_s=f_listado.ObtenerValor("ARAN_MMATRICULA")%></td>
	<%ARAN_MCOLEGIATURA_s=f_listado.ObtenerValor("ARAN_MCOLEGIATURA")%></td>
	<%ano_ingreso_s=f_listado.ObtenerValor("ano_ingreso")%></td>
	<%plan_est_s=f_listado.ObtenerValor("plan_est")%></td>
	<%nombre_colegio_s=f_listado.ObtenerValor("nombre_colegio")%> 
	<%comuna_colegio_s=f_listado.ObtenerValor("comuna_colegio")%>
	 <%ciudad_colegio_s=f_listado.ObtenerValor("ciudad_colegio")%></td>
	<%ano_egreso_s=f_listado.ObtenerValor("ano_egreso")%></td>
	<%tipo_prueba_s=f_listado.ObtenerValor("tipo_prueba")%></td>
	<%puntaje_verbal_s=f_listado.ObtenerValor("puntaje_verbal")%></td>
	<%puntaje_matematicas_s=f_listado.ObtenerValor("puntaje_matematicas")%></td>
	<%promedio_prueba_s=f_listado.ObtenerValor("promedio_prueba")%></td>
	<%puntaje_verbal_real_s=f_listado.ObtenerValor("puntaje_verbal_real")%></td>
	<%puntaje_matematicas_real_s=f_listado.ObtenerValor("puntaje_matematicas_real")%></td>
	<%promedio_prueba_real_s=f_listado.ObtenerValor("promedio_prueba_real")%></td>
	<%ano_paa_s=f_listado.ObtenerValor("ano_paa")%></td>
	<%promedio_media_s=f_listado.ObtenerValor("promedio_media")%></td>
	<%tipo_colegio_s=f_listado.ObtenerValor("tipo_colegio")%></td>
	<%tipo_ensenanza_s=f_listado.ObtenerValor("tipo_ensenanza")%></td>
	<%rut_codeudor_s=f_listado.ObtenerValor("rut_codeudor")%></td>
	<%codeudor_s=f_listado.ObtenerValor("codeudor")%></td>
	<%fecha_nacimiento_codeudor_s=f_listado.ObtenerValor("fecha_nacimiento_codeudor")%></td>
	<%direccion_codeudor_s=f_listado.ObtenerValor("direccion_codeudor")%></td>
	<%ciudad_codeudor_s=f_listado.ObtenerValor("ciudad_codeudor")%></td>
	<%email_codeudor_s=f_listado.ObtenerValor("email_codeudor")%></td>
	<%con_carga_s=f_listado.ObtenerValor("con_carga")%></td>
	<%cant_asignaturas_s=f_listado.ObtenerValor("cant_asignaturas")%></td>
	<%es_moroso_s=f_listado.ObtenerValor("es_moroso")%></td>
	<%monto_morosidad_s=f_listado.ObtenerValor("monto_morosidad")%></td>
	<%Ced_identidad_s=f_listado.ObtenerValor("Ced_identidad")%></td>
	<%Lic_Ensenanza_Media_s=f_listado.ObtenerValor("Lic_Ensenanza_Media")%></td>
	<%Conc_de_notas_Ensenanza_Media_s=f_listado.ObtenerValor("Conc_de_notas_Ensenanza_Media")%></td>
	<%Puntaje_PSU_s=f_listado.ObtenerValor("Puntaje_PSU")%></td>
	<%Fotografias_s=f_listado.ObtenerValor("Fotografias")%></td>
	<%Certificado_Residencia_s=f_listado.ObtenerValor("Certificado_Residencia")%></td>
	<%Seguro_Salud_s=f_listado.ObtenerValor("Seguro_Salud")%></td>

  <tr>
    <td><%=NUMERO%></td>
	<td><%=rut_s%></td>
    <td><%=AP_PATERNO_s%></td>
    <td><%=AP_MATERNO_s%></td>
    <td><%=nombre_s%></td>
	<td><%=fecha_nacimiento_s%></td>
	<td><%=edad_s%></td>
	<td><%=sexo_s%></td>
	<td><%=sexo_s%></td>
	<td><%=email_s%></td>
	<td><%=dire_particular_s%></td>
	<td><%=telefono_particular_s%></td>
	<td><%=comuna_particular_s%> , <%=ciudad_particular_s%></td>
	<td><%=region_particular_s%></td>
	<td><%=dire_academica_s%></td>
	<td><%=telefono_academica_s%></td>
	<td><%=comuna_academica_s%> , <%=ciudad_academica_s%></td>
	<td><%=tipo_s%></td>
	<td><%=tipo_intercambio_s%></td>
	<td><%=estado_academico_s%></td>
	<td><%=condicion_s%></td>
	<td><%=observacion_s%></td>
	<td><%=fecha_matricula_s%></td>
	<td><%=fecha_modificacion_s%></td>
	<td><%=facultad_s%></td>
	<td><%=cod_carrera_s%></td>
	<td><%=carrera_s%></td>
	<td><%=sede_s%></td>
	<td><%=jornada_s%></td>
	<td><%=especialidad_s%></td>
	<td><%=ARAN_MMATRICULA_s%></td>
	<td><%=ARAN_MCOLEGIATURA_s%></td>
	<td><%=ano_ingreso_s%></td>
	<td><%=plan_est_s%></td>
	<td><%=nombre_colegio_s%> <%=comuna_colegio_s%>, <%=ciudad_colegio_s%></td>
	<td><%=ano_egreso_s%></td>
	<td><%=tipo_prueba_s%></td>
	<td><%=puntaje_verbal_s%></td>
	<td><%=puntaje_matematicas_s%></td>
	<td><%=promedio_prueba_s%></td>
	<td><%=puntaje_verbal_real_s%></td>
	<td><%=puntaje_matematicas_real_s%></td>
	<td><%=promedio_prueba_real_s%></td>
	<td><%=ano_paa_s%></td>
	<td><%=promedio_media_s%></td>
	<td><%=tipo_colegio_s%></td>
	<td><%=tipo_ensenanza_s%></td>
	<td><%=rut_codeudor_s%></td>
	<td><%=codeudor_s%></td>
	<td><%=fecha_nacimiento_codeudor_s%></td>
	<td><%=direccion_codeudor_s%></td>
	<td><%=ciudad_codeudor_s%></td>
	<td><%=email_codeudor_s%></td>
	<td><%=con_carga_s%></td>
	<td><%=cant_asignaturas_s%></td>
	<td><%=es_moroso_s%></td>
	<td><%=monto_morosidad_s%></td>
	<td align="center"><%=Ced_identidad_s%></td>
	<td align="center"><%=Lic_Ensenanza_Media_s%></td>
	<td align="center"><%=Conc_de_notas_Ensenanza_Media_s%></td>
	<td align="center"><%=Puntaje_PSU_s%></td>
	<td align="center"><%=Fotografias_s%></td>
	<td align="center"><%=Certificado_Residencia_s%></td>
	<td align="center"><%=Seguro_Salud_s%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
   <%end if%>
  <%wend%>
</table>
</body>
</html>
