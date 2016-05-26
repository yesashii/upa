<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next

Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
sede = request.QueryString("sede")
espe_ccod = request.QueryString("espe_ccod")
epos_ccod = request.QueryString("epos_ccod")
emat_ccod = request.QueryString("emat_ccod")
nuevo = request.QueryString("nuevo")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
'------------------------------------------------------------------------------------
if sede<>"" and sede<>"-1" then
  nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
else
  nombre_sede="Todas las sedes"  
end if
if carr_ccod<>"" and carr_ccod<>"-1" then
  nombre_carrera = conexion.consultaUno("Select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
else
  nombre_carrera="Todas las carreras inpartidas en la sede"  
end if

if espe_ccod <> "" then
	filtro_espe=" And e.espe_ccod="&espe_ccod
  	nombre_especialidad = "- "&conexion.consultaUno("Select espe_tdesc from especialidades where espe_ccod='"&espe_ccod&"'")
end if


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
tituloPag = "Alumnos"

if nuevo="S" then tituloPag = tituloPag + " Nuevos"
if nuevo="N" then tituloPag = tituloPag + " Antiguos"
tituloPag = tituloPag + " por Carrera"

if epos_ccod = "1" then tituloPag = tituloPag + " (en Proceso)"
if epos_ccod = "2" then tituloPag = tituloPag + " (Enviados)"
if epos_ccod = ""  then tituloPag = tituloPag + " (Matriculados)"

set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_matricula.xml","listado_matriculados"
f_matriculados.inicializar conexion

periodo=negocio.ObtenerPeriodoAcademico("postulacion")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	
	'filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"'  order by nombre asc"
	if epos_ccod <> "" then
		filtro_nuevo = "  having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=b.post_ncorr) = '"&nuevo&"'  order by nombre asc"
	elseif emat_ccod = "1" then
		filtro_nuevo = "  having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=d.post_ncorr) = '"&nuevo&"'  order by nombre asc"
	end if
' and c.peri_ccod=max(g.peri_ccod) 
' AGREGADO PARA FILTRAR LOS ALUMNOS DEL PRIMER Y SEGUNDO SEMESTRE Y ASI INCLUIR ALUMNOS DE TODO EL AÑO
' PERO TRAE SOLO LA ULTIMA MATRICULA ACTIVA EN CASO DE TENER 2 MATRICULAS)
' NO FUNCIONA PARA CAMBIOS DE CARRERA (FALTA REVISAR,  MRIFFO)

end if
consulta=""		



if epos_ccod <> "" then

'###########################################################################################
'###########################	VERSION SEPARADA POR CARRERA Y JORNADA #####################
'###########################################################################################

consulta2 =  " select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut," & vbCrLf &_
			"  pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre  as nombre, " & vbCrLf &_
			"   pers_fnacimiento,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ano_ingreso " & vbCrLf &_
			" from personas_postulante a, postulantes b, ofertas_academicas c, especialidades e, detalle_postulantes f " & vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
			"   and b.post_ncorr=f.post_ncorr " & vbCrLf &_
			"   and c.ofer_ncorr=f.ofer_ncorr " & vbCrLf &_			
			"   and c.espe_ccod = e.espe_ccod " & vbCrLf &_
			"   and b.epos_ccod='" & epos_ccod & "' " & vbCrLf &_
			"   and e.carr_ccod='" & carr_ccod & "' " & vbCrLf &_
			"   and c.jorn_ccod='" & jorn_ccod & "' " & vbCrLf &_
			"   and c.peri_ccod='" & periodo & "' " & vbCrLf &_
			"   and c.sede_ccod='" & sede & "' "  & vbCrLf &_
			" "&filtro_espe&" "& vbCrLf &_
			"   and b.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49'," & vbCrLf &_
			"   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', " & vbCrLf &_
			"   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88'," & vbCrLf &_
			"   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1','ContinuidadAlumnosPet') " & vbCrLf &_
  			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento " & vbCrLf & _
			filtro_nuevo 					
			
elseif emat_ccod = "1" then

'###########################################################################################
'###########################	VERSION SEPARADA POR CARRERA Y JORNADA #####################
'###########################################################################################

				
		consulta2 =  "   select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut,  " & vbCrLf &_
			"   pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre,  " & vbCrLf &_
			"   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo,  " & vbCrLf &_
			"   isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr   " & vbCrLf &_
	   		"   From alumnos where matr_ncorr=d.matr_ncorr order by matr_ncorr desc),'CC'))) ,    " & vbCrLf &_
            "   protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso  " & vbCrLf &_
			" from personas a, ofertas_academicas c, alumnos d,especialidades e   " & vbCrLf &_
			" where a.pers_ncorr = d.pers_ncorr   " & vbCrLf &_
			"    and c.ofer_ncorr= d.ofer_ncorr   " & vbCrLf &_
			"    and c.espe_ccod = e.espe_ccod " & vbCrLf &_
            "    and c.jorn_ccod='" & jorn_ccod & "'   " & vbCrLf &_
			"    and e.carr_ccod='" & carr_ccod & "'  " & vbCrLf &_
			"    and c.sede_ccod='" & sede & "' " & vbCrLf &_
			" "&filtro_espe&" "& vbCrLf &_
			"    and d.emat_ccod in (1,4,8,2,15,16) and d.audi_tusuario not like '%ajunte matricula%'   " & vbCrLf &_
	        "    and protic.afecta_estadistica(d.matr_ncorr) > 0   " & vbCrLf &_
			"   and isnull(d.alum_nmatricula,1) not  in (7777) "& vbCrLf  & _
			"	and c.peri_ccod=protic.retorna_max_periodo_matricula(a.pers_ncorr,'" & periodo & "',e.carr_ccod)  " & vbCrLf &_
			"	and d.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',  " & vbCrLf &_
			"                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',   " & vbCrLf &_
			"                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',   " & vbCrLf &_
			"                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',   " & vbCrLf &_
			"                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',   " & vbCrLf &_
			"                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2','ContinuidadAlumnosPet')   " & vbCrLf &_
			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento,d.matr_ncorr, d.post_ncorr  "& vbCrLf & _
			filtro_nuevo	
				
				
	url_carga="gestion_cargas_alumnos.asp?sede_ccod="&sede&"&espe_ccod="&espe_ccod&"&nuevo="&nuevo&"&emat_ccod="&emat_ccod
end if


'response.Write("<pre>"&consulta2&"</pre>")
'response.Flush()
f_matriculados.Consultar consulta2
'response.Write(f_matriculados.nro_filas)
'response.End()
%>
<html>
<head>
<title> Listado Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =nombre_sede%> </td>
    
  </tr>
  <tr> 
    <td height="22"><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_carrera %> <%=nombre_especialidad%></td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%"><div align="center"><strong>N°</strong></div></td>
    <td width="10%"><div align="center"><strong>Rut</strong></div></td>
    <td width="45%"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="10%"><div align="center"><strong>Fecha Nacimiento</strong></div></td>
	<td width="10%"><div align="center"><strong>Ingreso</strong></div></td>
  </tr>
  <% fila = 1 
     while f_matriculados.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_matriculados.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_matriculados.ObtenerValor("nombre")%></div></td>
    <td><div align="center"><%=f_matriculados.ObtenerValor("pers_fnacimiento")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("ano_ingreso")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>