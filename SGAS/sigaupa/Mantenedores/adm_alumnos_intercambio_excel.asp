<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_de_intercambio.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set intercambio = new CFormulario
intercambio.Carga_Parametros "tabla_vacia.xml", "tabla"
intercambio.Inicializar conexion

consulta_intercambio =  " select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, " & vbCrLf &_
						" cast(h.pers_nrut as varchar)+'-'+h.pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, " & vbCrLf &_
						" pers_tnombre as nombre,pais_tdesc as país,peri_tdesc as periodo_cursado  " & vbCrLf &_
						" from alumnos a, ofertas_academicas b, sedes c, especialidades e, carreras f, jornadas g,  " & vbCrLf &_
						" personas h,periodos_academicos i, paises j " & vbCrLf &_
						" where isnull(alum_trabajador,0)=1 " & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=e.espe_ccod " & vbCrLf &_
						" and e.carr_ccod=f.carr_ccod and b.jorn_ccod=g.jorn_ccod " & vbCrLf &_
						" and a.pers_ncorr=h.pers_ncorr and b.peri_ccod=i.peri_ccod " & vbCrLf &_
						" and isnull(h.pais_ccod,0)=j.pais_ccod " & vbCrLf &_
						" order by sede, carrera, jornada, apellidos "


'response.Write("<pre>"&consulta_salas&"</pre>")
'response.End()
intercambio.Consultar consulta_intercambio

%>
<html>
<head>
<title>Listado alumnos de Intercambio</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de alumnos de intercambio de la Universidad</font></div>
	</td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=fecha%></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#9999CC"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Sede</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Jornada</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Apellidos</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Nombres</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>País</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Periodo Cursado</strong></div></td>
  </tr>
  <% fila = 1 
   while intercambio.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=intercambio.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=intercambio.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=intercambio.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=intercambio.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=intercambio.ObtenerValor("apellidos")%></div></td>
	<td><div align="left"><%=intercambio.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=intercambio.ObtenerValor("país")%></div></td>
	<td><div align="left"><%=intercambio.ObtenerValor("periodo_cursado")%></div></td>
  </tr>
  <% fila = fila + 1  
    wend 
  %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>