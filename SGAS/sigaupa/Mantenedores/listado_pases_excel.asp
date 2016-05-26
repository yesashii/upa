<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=pases_matricula.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
sede=request.Form("sede")
carrera=request.Form("carrera")
jornada=request.Form("jornada")
rut=request.Form("rut")
'------------------------------------------------------------------------------------
if sede<>"" and sede<>"-1" then
  nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
else
  nombre_sede="Todas las sedes"  
end if
if carrera<>"" and carrera<>"-1" then
  nombre_carrera=conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
else
  nombre_carrera="Todas las carreras inpartidas en la sede"  
end if
if jornada<>"" and jornada<>"-1" then
  nombre_jornada=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jornada&"'")
else
  nombre_jornada="Ambas jornadas (Diurna - Vespertina)"  
end if



fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_pases = new CFormulario
f_pases.Carga_Parametros "listado_pases.xml", "list_alumnos"
f_pases.Inicializar conexion
		   
consulta="select protic.format_rut(d.pers_nrut)as rut,  d.pers_tape_paterno+' '+d.pers_tape_materno +' '+ d.pers_tnombre as nombre," & vbCrLf &_ 
		 " pama_nporc_matricula as porc_matricula,pama_nporc_colegiatura as porc_colegiatura,e.carr_tdesc as carrera,f.pama_tipo_desc as tipo," & vbCrLf &_ 
		 " cast(DATEPART(day,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(month,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(year,a.audi_fmodificacion)as varchar)as fecha," & vbCrLf &_ 
		 " case (select count(*)  from alumnos a, ofertas_academicas b, personas c where c.pers_nrut= d.pers_nrut  and c.pers_ncorr=a.pers_ncorr  and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod=1  and b.peri_ccod="&v_peri_ccod&") when 0 then 'No Matriculado' else 'Matriculado' end as estado, pa.peri_tdesc, a.peri_ccod" & vbCrLf &_ 
		 " from pase_matricula a, ofertas_academicas b,especialidades c,personas d,carreras e, tipo_pase_matricula f , PERIODOS_ACADEMICOS pa " & vbCrLf &_ 
		 " where a.ofer_ncorr=b.ofer_ncorr" & vbCrLf &_ 
		 " and b.espe_ccod=c.espe_ccod" & vbCrLf &_ 
		 " and c.carr_ccod=e.carr_ccod" & vbCrLf &_ 
		 " and a.pers_ncorr=d.pers_ncorr" & vbCrLf &_
		 " and a.peri_ccod = pa.PERI_CCOD"  & vbCrLf &_
		 " and a.peri_ccod="&v_peri_ccod&" "& vbCrLf &_  
		 " and b.espe_ccod in(Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')"
		 if sede<>"" and sede<>"-1" then
		 	consulta=consulta & " and cast(b.sede_ccod as varchar)='"&sede&"'" 
		 end if
		 if jornada<>"" and jornada<>"-1" then	
  		    consulta=consulta & " and cast(b.jorn_ccod as varchar)='"&jornada&"'"
		 end if
		 if carrera<>"" and carrera<>"-1" then
		    consulta=consulta & " and cast(e.carr_ccod as varchar)='"&carrera&"'"
		 end if
		 if rut<>""  then
	        consulta= consulta & " and cast(d.pers_nrut as varchar)='"&rut&"'"
         end if
		consulta = consulta & "and f.pama_tipo_pase = a.pama_tipo_pase"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_pases.Consultar consulta & " order by nombre"
%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Pases de Matricula</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =nombre_sede%> </td>
    
  </tr>
  <tr> 
    <td><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_carrera %> </td>
  </tr>
  <tr>
    <td><strong>Jornada</strong></td>
    <td colspan="3"> <strong>:</strong><%=nombre_jornada%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="5%"><div align="center"><strong>Rut</strong></div></td>
    <td width="15%"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="15%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%"><div align="center"><strong>% Matricula</strong></div></td>
    <td width="5%"><div align="center"><strong>% Colegiatura</strong></div></td>
    <td width="10%"><div align="center"><strong>Tipo Tratamiento</strong></div></td>
    <td width="4%"><div align="center"><strong>Fecha</strong></div></td>
	<td width="4%"><div align="center"><strong>Estado</strong></div></td>
    <td width="4%"><div align="center"><strong>Periodo Academico</strong></div></td>
  </tr>
  <%  while f_pases.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_pases.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_pases.ObtenerValor("nombre")%></div></td>
    <td><div align="center"><%=f_pases.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_pases.ObtenerValor("porc_matricula")%></div></td>
    <td><div align="center"><%=f_pases.ObtenerValor("porc_colegiatura")%></div></td>
	<td><div align="center"><%=f_pases.ObtenerValor("tipo")%></div></td>
	<td><div align="center"><%=f_pases.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=f_pases.ObtenerValor("estado")%></div></td>
    <td><div align="center"><%=f_pases.ObtenerValor("peri_tdesc")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>