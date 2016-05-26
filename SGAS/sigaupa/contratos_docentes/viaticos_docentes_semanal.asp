<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				  :	Obtiene el consolidado de los dias que un profesor tiene clase en la semana
'FECHA CREACIÓN			      : 04-04-2015
'CREADO POR					  : Mario Riffo
'ENTRADA					  : NA
'SALIDA						  : NA
'MODULO QUE ES UTILIZADO	: CONTRATOS DOCENTES
'
'********************************************************************

server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_viaticos_docentes_semanal.xls"
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


sql_listado_viaticos = " select semanas.inicio as inicio_semana, semanas.fin as fin_semana,  " & vbcrlf & _
" case when count(Lunes)>=1 then '1' else '0' end  as viaticos_lunes,case when count(Martes)>=1 then '1' else '0' end  as viaticos_Martes,case when count(Miercoles)>=1 then '1' else '0' end  as viaticos_Miercoles, " & vbcrlf & _ 
" case when count(Jueves)>=1 then '1' else '0' end  as viaticos_Jueves,case when count(Viernes)>=1 then '1' else '0' end  as viaticos_Viernes,case when count(Sabado)>=1 then '1' else '0' end  as viaticos_Sabado,case when count(Domingo)>=1 then '1' else '0' end  as viaticos_Domingo, " & vbcrlf & _
" rut_docente ,nombre_docente,direccion, comuna_ciudad,tipo_docente " & vbcrlf & _ 
" from ( " & vbcrlf & _ 
" select distinct case when isnull(a.TPRO_CCOD,1) = 1 then 'Profesor' else 'Ayudante' end tipo_docente,protic.obtener_direccion(a.pers_ncorr,1,'CNPB') as direccion, "& vbcrlf & _ 
" protic.obtener_direccion(a.pers_ncorr,1,'C-C') as comuna_ciudad,protic.obtener_nombre_completo(a.pers_ncorr, 'n') as nombre_docente," & vbcrlf & _ 
" protic.obtener_rut(a.pers_ncorr) as rut_docente,carr_tdesc as carrera, jorn_tdesc as jornada, " & vbcrlf & _ 
" case when k.dias_ccod=1 then 'Lunes' end as Lunes,  " & vbcrlf & _ 
" case when k.dias_ccod=2 then 'Martes' end as Martes, " & vbcrlf & _ 
" case when k.dias_ccod=3 then 'Miercoles' end as Miercoles, " & vbcrlf & _ 
" case when k.dias_ccod=4 then 'Jueves' end as Jueves, " & vbcrlf & _ 
" case when k.dias_ccod=5 then 'Viernes' end as Viernes, " & vbcrlf & _ 
" case when k.dias_ccod=6 then 'Sabado' end as Sabado, " & vbcrlf & _ 
" case when k.dias_ccod=7 then 'Domingo' end as Domingo, " & vbcrlf & _ 
" j.bloq_ccod, k.bloq_finicio_modulo as inicio_modulo,k.bloq_ftermino_modulo as fin_modulo " & vbcrlf & _ 
" from contratos_docentes_upa a, anexos b, personas c, carreras d, sedes e,  " & vbcrlf & _ 
" jornadas h, detalle_anexos j,bloques_horarios k " & vbcrlf & _ 
" where ano_contrato=year(getdate())  " & vbcrlf & _ 
" and a.cdoc_ncorr=b.cdoc_ncorr " & vbcrlf & _ 
" and b.eane_ccod not in (3) " & vbcrlf & _ 
" and b.sede_ccod=4 " & vbcrlf & _ 
" and a.pers_ncorr=c.pers_ncorr " & vbcrlf & _ 
" and b.carr_ccod=d.carr_ccod " & vbcrlf & _ 
" and b.sede_ccod=e.sede_ccod " & vbcrlf & _ 
" and b.jorn_ccod=h.jorn_ccod " & vbcrlf & _ 
" and b.anex_ncorr=j.anex_ncorr " & vbcrlf & _ 
" and j.bloq_ccod=k.bloq_ccod " & vbcrlf & _ 
" and j.secc_ccod=k.secc_ccod  " & vbcrlf & _ 
" ) as tabla, (select semana, anio,protic.trunc(min(fecha)) as inicio, protic.trunc(max(fecha)) as fin from Dim_Tiempo where anio=year(getdate())  " & vbcrlf & _ 
" group by semana, anio) as semanas " & vbcrlf & _ 
" where semanas.inicio between tabla.inicio_modulo and tabla.fin_modulo " & vbcrlf & _ 
" and semanas.fin between tabla.inicio_modulo and tabla.fin_modulo " & vbcrlf & _ 
" group by tabla.rut_docente,semanas.inicio,semanas.fin, nombre_docente,direccion, comuna_ciudad,tipo_docente " 



 

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
<title>Agrupado x Mes</title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Rut Docente</strong></div></td>
    <td><div align="center"><strong>Nombre Docente</strong></div></td>	
    <td><div align="center"><strong>Tipo Docente</strong></div></td>	
    <td><div align="center"><strong>Direccion</strong></div></td>	
    <td><div align="center"><strong>Ciudad-Comuna</strong></div></td>	
    <td><div align="center"><strong>Inicio Semana</strong></div></td>
    <td><div align="center"><strong>Fin Semana</strong></div></td>
	<td><div align="center"><strong>Viajes Lunes</strong></div></td>
    <td><div align="center"><strong>Viajes Martes</strong></div></td>
	<td><div align="center"><strong>Viajes Miercoles</strong></div></td>
    <td><div align="center"><strong>Viajes Jueves</strong></div></td>
    <td><div align="center"><strong>Viajes Viernes</strong></div></td>
	<td><div align="center"><strong>Viajes Sabado</strong></div></td>
	<td><div align="center"><strong>Viajes Domingo</strong></div></td>
  </tr>
  <%  while f_valor_viatico.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("rut_docente")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("nombre_docente")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("tipo_docente")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("direccion")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("comuna_ciudad")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("inicio_semana")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("fin_semana")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_lunes")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_martes")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_miercoles")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_jueves")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_viernes")%></div></td>
    <td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_sabado")%></div></td>
	<td><div align="left"><%=f_valor_viatico.ObtenerValor("viaticos_domingo")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>