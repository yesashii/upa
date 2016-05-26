<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=parciales_de_cuidado.xls"
Response.ContentType = "application/vnd.ms-excel"

carr_ccod = request.QueryString("carr_ccod")
sede_ccod = request.QueryString("sede_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
peri_ccod = request.QueryString("peri_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set rojos = new CFormulario
rojos.Carga_Parametros "tabla_vacia.xml", "tabla"
rojos.Inicializar conexion

consulta_rojos =  " select cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, " & vbCrLf &_
				  " e.pers_tnombre as nombre, e.pers_tape_paterno + ' ' + e.pers_tape_materno as apellidos,pers_tfono as telefono, " & vbCrLf &_
				  " pers_tcelular as celular, pers_temail as email, " & vbCrLf &_
				  " protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,d.carr_ccod) as ano_ingreso, " & vbCrLf &_
				  " (select count(*) from cargas_academicas ca where ca.matr_ncorr=a.matr_ncorr) as cantidad_carga, " & vbCrLf &_
				  " (select count(*) from cargas_academicas ca, secciones se " & vbCrLf &_
				  " where ca.matr_ncorr=a.matr_ncorr and ca.secc_ccod=se.secc_ccod " & vbCrLf &_
				  " and exists (select 1 from calificaciones_alumnos cc where cc.matr_ncorr=ca.matr_ncorr and cc.secc_ccod=se.secc_ccod " & vbCrLf &_
				  "             and cala_nnota < 4.0) " & vbCrLf &_
				  " ) as cantidad_asiganturas_con_rojo_parcial,  " & vbCrLf &_
				  " ( select count(*) from cargas_academicas ca,situaciones_finales sf " & vbCrLf &_
   				  "   where ca.matr_ncorr=a.matr_ncorr and ca.sitf_ccod=sf.sitf_ccod and sitf_baprueba='N') as cantidad_carga_reprobada  " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d, personas e" & vbCrLf &_
				  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod=1 " & vbCrLf &_
				  " and d.carr_ccod='"&carr_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' and a.pers_ncorr=e.pers_ncorr " & vbCrLf &_
				  " and (select count(*) from cargas_academicas ca, secciones se " & vbCrLf &_
				  " where ca.matr_ncorr=a.matr_ncorr and ca.secc_ccod=se.secc_ccod " & vbCrLf &_
				  " and exists (select 1 from calificaciones_alumnos cc where cc.matr_ncorr=ca.matr_ncorr and cc.secc_ccod=se.secc_ccod " & vbCrLf &_
				  "             and cala_nnota < 4.0) " & vbCrLf &_
				  " ) > 1 " & vbCrLf &_
				  " order by apellidos  " 

'response.Write("<pre>"&consulta_salas&"</pre>")
'response.End()
rojos.Consultar consulta_rojos

sede = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
jornada = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
periodo = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")

%>
<html>
<head>
<title>Listado alumnos con </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        de alumnos con más de una asignatura con resultado parcial insuficiente.</font></div>
	</td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=sede%></td>
 </tr>
 <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=carrera%></td>
 </tr>
 <tr> 
    <td width="16%"><strong>Jornada</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=jornada%></td>
 </tr>
 <tr> 
    <td width="16%"><strong>Periodo</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=periodo%></td>
 </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:&nbsp;&nbsp;</strong><%=fecha%></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#9999CC"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Rut</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Nombres</strong></div></td>
    <td bgcolor="#9999CC"><div align="center"><strong>Apellidos</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Teléfono</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Celular</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>E-mail</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Año de Ingreso</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Carga Tomada</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Nº de Asignaturas con resultado parcial insuficiente</strong></div></td>
	<td bgcolor="#9999CC"><div align="center"><strong>Carga Reprobada</strong></div></td>
  </tr>
  <% fila = 1 
   while rojos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=rojos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=rojos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=rojos.ObtenerValor("apellidos")%></div></td>
    <td><div align="left"><%=rojos.ObtenerValor("telefono")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("celular")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("email")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("cantidad_carga")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("cantidad_asiganturas_con_rojo_parcial")%></div></td>
	<td><div align="left"><%=rojos.ObtenerValor("cantidad_carga_reprobada")%></div></td>
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