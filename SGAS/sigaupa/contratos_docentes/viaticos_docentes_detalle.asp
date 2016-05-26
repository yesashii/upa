<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				      :	obtiene el detalle de los dias que un profesor tiene clase por sede
'FECHA CREACIÓN			      : 04-04-2015
'CREADO POR					      : Mario Riffo
'ENTRADA					        : NA
'SALIDA						        : NA
'MODULO QUE ES UTILIZADO	: CONTRATOS DOCENTES
'
'********************************************************************

server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_viaticos_docentes_detalle.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------


set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

'periodo = negocio.ObtenerPeriodoAcademico("PLANIFICACION")
'anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&Periodo&"'")


sql_listado_viaticos = " select distinct  bloq_ccod,tabla.inicio_modulo,  tabla.fin_modulo,dia_semana,rut_docente,  " & vbcrlf & _ 
" semanas.inicio, semanas.fin, semanas.semana, tabla.carrera, tabla.jornada from ( " & vbcrlf & _ 
" select distinct a.pers_ncorr,protic.obtener_rut(a.pers_ncorr) as rut_docente,carr_tdesc as carrera, jorn_tdesc as jornada, " & vbcrlf & _ 
" case  " & vbcrlf & _ 
" when k.dias_ccod=1 then 'Lunes' " & vbcrlf & _ 
" when k.dias_ccod=2 then 'Martes' " & vbcrlf & _ 
" when k.dias_ccod=3 then 'Miercoles' " & vbcrlf & _ 
" when k.dias_ccod=4 then 'Jueves' " & vbcrlf & _ 
" when k.dias_ccod=5 then 'Viernes' " & vbcrlf & _ 
" when k.dias_ccod=6 then 'Sabado' " & vbcrlf & _ 
" when k.dias_ccod=7 then 'Domingo' " & vbcrlf & _ 
" end as dia_semana,j.bloq_ccod, " & vbcrlf & _ 
"  k.bloq_finicio_modulo as inicio_modulo,k.bloq_ftermino_modulo as fin_modulo " & vbcrlf & _ 
" from contratos_docentes_upa a, anexos b, personas c, carreras d, sedes e,  " & vbcrlf & _ 
" jornadas h, detalle_anexos j,bloques_horarios k " & vbcrlf & _ 
" where ano_contrato=year(getdate()) " & vbcrlf & _ 
" and a.cdoc_ncorr=b.cdoc_ncorr " & vbcrlf & _ 
" and b.eane_ccod not in (3)  " & vbcrlf & _ 
" and b.sede_ccod=4 " & vbcrlf & _ 
" and a.pers_ncorr=c.pers_ncorr " & vbcrlf & _ 
" and b.carr_ccod=d.carr_ccod " & vbcrlf & _ 
" and b.sede_ccod=e.sede_ccod " & vbcrlf & _ 
" and b.jorn_ccod=h.jorn_ccod " & vbcrlf & _ 
" and b.anex_ncorr=j.anex_ncorr " & vbcrlf & _ 
" and j.bloq_ccod=k.bloq_ccod " & vbcrlf & _ 
" and j.secc_ccod=k.secc_ccod  " & vbcrlf & _ 
" ) as tabla, (select semana, anio,protic.trunc(min(fecha)) as inicio, protic.trunc(max(fecha)) as fin from Dim_Tiempo where anio=year(getdate()) " & vbcrlf & _ 
" group by semana, anio) as semanas " & vbcrlf & _ 
" where semanas.inicio between tabla.inicio_modulo and tabla.fin_modulo " & vbcrlf & _ 
" and semanas.fin between tabla.inicio_modulo and tabla.fin_modulo " & vbcrlf & _ 
" order by rut_docente,semana, dia_semana " 



 

'response.Write("<pre>"&sql_listado_viaticos&"</pre>")
'response.End()
set f_valor_viatico  = new cformulario
f_valor_viatico.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_viatico.inicializar conexion							
f_valor_viatico.consultar sql_listado_viaticos

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title>Detalle</title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Inicio modulo</strong></div></td>
    <td><div align="center"><strong>Fin modulo</strong></div></td>
    <td><div align="center"><strong>Rut_docente</strong></div></td>
	<td><div align="center"><strong>Inicio semana</strong></div></td>
    <td><div align="center"><strong>Fin semana</strong></div></td>
	<td><div align="center"><strong>Dia semana</strong></div></td>
    <td><div align="center"><strong>N° semana</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Jornada</strong></div></td>
  </tr>
  <%  while f_valor_viatico.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("inicio_modulo")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("fin_modulo")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("dia_semana")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("rut_docente")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("inicio")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("fin")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("semana")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("jornada")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>