<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=egresados.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
carr_ccod=request.Querystring("carr_ccod")
jorn_ccod=request.Querystring("jorn_ccod")


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
jornada = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")



set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select * from ( "& vbCrLf &_
			" select cast(pers_nrut as varchar)+'-'+dbo.dv(pers_nrut) as rut, b.sede_tdesc as sede, 'Sin identificar' as especialidad, case entidad when 'I' then 'Instituto' when 'U' then 'Universidad' end entidad,"& vbCrLf &_
			" apellidos + ' ' + nombres as alumno,'<font color=#330099><b>' + 'EGRESADO' + '</b></font>' as estado, '<font color=#330099><b>' + año + '</b></font>' as realizado,'<font color=#330099><b>' + 'No'  + '</b></font>' as en_SIGAF, año as egreso_fox  "& vbCrLf &_
			" from egresados_upa2 a,sedes b where carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' and a.sede_ccod=b.sede_ccod "& vbCrLf &_
			" and not exists (select 1 from personas aa , alumnos ba, ofertas_academicas ca, especialidades da "& vbCrLf &_
			"                where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
			"                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
			"                and da.carr_ccod = a.carr_ccod and ba.emat_ccod in (4,8)) "& vbCrLf &_
			" union                 "& vbCrLf &_
			" select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,g.sede_tdesc as sede, c.espe_tdesc as especialidad,'Universidad' as entidad,"& vbCrLf &_
			" d.pers_tape_paterno + ' ' + d.pers_tape_materno + ' ' + d.pers_tnombre as alumno, "& vbCrLf &_
			" f.emat_tdesc as estado,e.peri_tdesc as realizado,'Sí' as en_SIGAF,(select top 1 año from egresados_upa2 aa where aa.pers_nrut=d.pers_nrut and aa.carr_ccod=c.carr_ccod) as egreso_fox"& vbCrLf &_
			" from alumnos a, ofertas_academicas b, especialidades c, personas d,periodos_Academicos e,estados_matriculas f,sedes g "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			" and c.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
			" and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
			" and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = e.peri_ccod and b.sede_ccod=g.sede_ccod "& vbCrLf &_
			" and a.emat_ccod= f.emat_ccod "& vbCrLf &_
			" and a.emat_ccod in (4,8))a "& vbCrLf &_
			" order by alumno"& vbCrLf		
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_alumnos.Consultar consulta
%>
<html>
<head>
<title>Listado alumnos egresados</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado alumnos egresados y titulados Universidad</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=carrera %> </td>
  </tr>
  <tr>
    <td><strong>Jornada</strong></td>
    <td colspan="3"> <strong>:</strong><%=jornada%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr>
    <td><div align="center"><strong>Fila</strong></div></td> 
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Entidad</strong></div></td>
	<td><div align="center"><strong>Sede</strong></div></td>
	<td><div align="center"><strong>Especialidad</strong></div></td>
    <td><div align="center"><strong>Estado</strong></div></td>
	<td><div align="center"><strong>Realizado</strong></div></td>
    <td><div align="center"><strong>En Sistema</strong></div></td>
	<td><div align="center"><strong>Egreso en Fox</strong></div></td>
  </tr>
  <%fila = 1  
    while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_alumnos.ObtenerValor("alumno")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("entidad")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("sede")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("especialidad")%></div></td>
    <td><div align="center"><%=f_alumnos.ObtenerValor("estado")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("realizado")%></div></td>
    <td><div align="center"><%=f_alumnos.ObtenerValor("en_SIGAF")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("egreso_fox")%></div></td>
  </tr>
  <%fila = fila + 1  
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>