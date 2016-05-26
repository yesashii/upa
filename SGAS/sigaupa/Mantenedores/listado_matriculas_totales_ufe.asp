<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
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
'agrega_carga =request.Form("agrega_carga")
'agrega_morosidad =request.Form("agrega_morosidad")
'agrega_documentos =request.Form("agrega_documentos")
aran_nano_ingreso = request.Form("busqueda[0][aran_nano_ingreso]")
'post_nano_paa = request.Form("busqueda[0][post_nano_paa]")
emat_tdesc = request.Form("busqueda[0][emat_tdesc]")
'fecha_inicio = request.Form("inicio")
'min_puntaje = request.Form("min_puntaje")
'max_puntaje = request.Form("max_puntaje")
'ingreso_especial = request.Form("ingreso_especial")
'response.Write("ingreso_especial "&ingreso_especial)

if not esVacio(carrera) then
    
	filtro1= " where cast(cod_carrera as varchar)='"&carrera&"'"
else
	filtro1=" "	
end if


if not esVacio(periodo) then
    
		if esVacio(carrera) then
		filtro2= " and cast(periodo_aca as varchar)='"&periodo&"'"
		else
		filtro2= " where cast(periodo_aca as varchar)='"&periodo&"'"
		end if
	
else
	filtro2=" "	
end if

if not esVacio(aran_nano_ingreso) then
		
		if esVacio(carrera) and esVacio(periodo) then
			filtro3= " and cast(ano_ingreso as varchar)='"&aran_nano_ingreso&"'"
		else
			filtro3= " where cast(ano_ingreso as varchar)='"&aran_nano_ingreso&"'"
		end if
else
	filtro3=" "	
end if


if not esVacio(emat_tdesc) then
    
		if esVacio(carrera) and esVacio(periodo) and esVacio(emat_tdesc) then
		filtro4= " and cast(estado_academico as varchar)='"&emat_tdesc&"'"
		else
		filtro4= " where cast(estado_academico as varchar)='"&emat_tdesc&"'"
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
  <tr>
    <td><%=NUMERO%></td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
    <td><%=f_listado.ObtenerValor("AP_PATERNO")%></td>
    <td><%=f_listado.ObtenerValor("AP_MATERNO")%></td>
    <td><%=f_listado.ObtenerValor("nombre")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento")%></td>
	<td><%=f_listado.ObtenerValor("edad")%></td>
	<td><%=f_listado.ObtenerValor("sexo")%></td>
	<td><%=f_listado.ObtenerValor("pais")%></td>
	<td><%=f_listado.ObtenerValor("email")%></td>
	<td><%=f_listado.ObtenerValor("dire_particular")%></td>
	<td><%=f_listado.ObtenerValor("telefono_particular")%></td>
	<td><%=f_listado.ObtenerValor("comuna_particular")%> , <%=f_listado.ObtenerValor("ciudad_particular")%></td>
	<td><%=f_listado.ObtenerValor("region_particular")%></td>
	<td><%=f_listado.ObtenerValor("dire_academica")%></td>
	<td><%=f_listado.ObtenerValor("telefono_academica")%></td>
	<td><%=f_listado.ObtenerValor("comuna_academica")%> , <%=f_listado.ObtenerValor("ciudad_academica")%></td>
	<td><%=f_listado.ObtenerValor("tipo")%></td>
	<td><%=f_listado.ObtenerValor("tipo_intercambio")%></td>
	<td><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td><%=f_listado.ObtenerValor("condicion")%></td>
	<td><%=f_listado.ObtenerValor("observacion")%></td>
	<td><%=f_listado.ObtenerValor("fecha_matricula")%></td>
	<td><%=f_listado.ObtenerValor("fecha_modificacion")%></td>
	<td><%=f_listado.ObtenerValor("facultad")%></td>
	<td><%=f_listado.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("sede")%></td>
	<td><%=f_listado.ObtenerValor("jornada")%></td>
	<td><%=f_listado.ObtenerValor("especialidad")%></td>
	<td><%=f_listado.ObtenerValor("ARAN_MMATRICULA")%></td>
	<td><%=f_listado.ObtenerValor("ARAN_MCOLEGIATURA")%></td>
	<td><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td><%=f_listado.ObtenerValor("plan_est")%></td>
	<td><%=f_listado.ObtenerValor("nombre_colegio")%> <%=f_listado.ObtenerValor("comuna_colegio")%>, <%=f_listado.ObtenerValor("ciudad_colegio")%></td>
	<td><%=f_listado.ObtenerValor("ano_egreso")%></td>
	<td><%=f_listado.ObtenerValor("tipo_prueba")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_verbal")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_matematicas")%></td>
	<td><%=f_listado.ObtenerValor("promedio_prueba")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_verbal_real")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_matematicas_real")%></td>
	<td><%=f_listado.ObtenerValor("promedio_prueba_real")%></td>
	<td><%=f_listado.ObtenerValor("ano_paa")%></td>
	<td><%=f_listado.ObtenerValor("promedio_media")%></td>
	<td><%=f_listado.ObtenerValor("tipo_colegio")%></td>
	<td><%=f_listado.ObtenerValor("tipo_ensenanza")%></td>
	<td><%=f_listado.ObtenerValor("rut_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("codeudor")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("direccion_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("ciudad_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("email_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("con_carga")%></td>
	<td><%=f_listado.ObtenerValor("cant_asignaturas")%></td>
	<td><%=f_listado.ObtenerValor("es_moroso")%></td>
	<td><%=f_listado.ObtenerValor("monto_morosidad")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Ced_identidad")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Lic_Ensenanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Conc_de_notas_Ensenanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Puntaje_PSU")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Fotografias")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Certificado_Residencia")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Seguro_Salud")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
   <%end if%>
  <%wend%>
</table>
</body>
</html>
