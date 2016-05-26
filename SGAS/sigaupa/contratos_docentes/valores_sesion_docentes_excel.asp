<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				      :	
'FECHA CREACIÓN			      :
'CREADO POR					      :
'ENTRADA					        : NA
'SALIDA						        : NA
'MODULO QUE ES UTILIZADO	: CONTRATOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/02/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO						      : Corregir código, eliminar sentencia *=
'LINEA						      : 51, 52, 53
'********************************************************************

server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_softland_escuelas.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

periodo = negocio.ObtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&Periodo&"'")


'sql_listado_escuelas = " select distinct  b.pers_nrut as rut,b.pers_xdv as digito, b.pers_tnombre, b.pers_tape_paterno, b.pers_tape_materno," & vbcrlf & _
'						" carr_tdesc as carrera, jorn_tdesc as jornada, sede_tdesc as sede," & vbcrlf & _
'						" f.tcat_valor as monto, jdoc_tdesc as jerarquia,(select ccos_tcompuesto from centros_costo where ccos_ccod=h.ccos_ccod) as centro_costo " & vbcrlf & _
'						" from carreras_docente a, personas b, carreras c, jornadas d, sedes e, tipos_categoria f, jerarquias_docentes g,centros_costos_asignados h, periodos_academicos i " & vbcrlf & _
'						" where a.peri_ccod=i.peri_ccod " & vbcrlf & _
'						" and cast(i.anos_ccod as  varchar)='"&anos_ccod&"' " & vbcrlf & _
'						" and a.pers_ncorr=b.pers_ncorr " & vbcrlf & _
'						" and a.carr_ccod=c.carr_ccod " & vbcrlf & _
'						" and a.jorn_ccod=d.jorn_ccod " & vbcrlf & _
'						" and a.sede_ccod=e.sede_ccod " & vbcrlf & _
'						" and a.tcat_ccod=f.tcat_ccod " & vbcrlf & _
'						" and f.jdoc_ccod=g.jdoc_ccod " & vbcrlf & _
'						" and a.carr_ccod*=h.cenc_ccod_carrera " & vbcrlf & _
'						" and a.jorn_ccod*=h.cenc_ccod_jornada " & vbcrlf & _
'						" and a.sede_ccod*=h.cenc_ccod_sede "

sql_listado_escuelas = "select distinct b.pers_nrut                      as rut, " & vbcrlf & _  
"                b.pers_xdv                       as digito, " & vbcrlf & _  
"                b.pers_tnombre, " & vbcrlf & _  
"                b.pers_tape_paterno, " & vbcrlf & _  
"                b.pers_tape_materno, " & vbcrlf & _  
"                carr_tdesc                       as carrera, " & vbcrlf & _  
"                jorn_tdesc                       as jornada, " & vbcrlf & _  
"                sede_tdesc                       as sede, " & vbcrlf & _  
"                f.tcat_valor                     as monto, " & vbcrlf & _  
"                jdoc_tdesc                       as jerarquia, " & vbcrlf & _  
"                (select ccos_tcompuesto " & vbcrlf & _  
"                 from   centros_costo " & vbcrlf & _  
"                 where  ccos_ccod = h.ccos_ccod) as centro_costo " & vbcrlf & _  
"from   carreras_docente a " & vbcrlf & _  
"       join personas as b " & vbcrlf & _  
"         on a.pers_ncorr = b.pers_ncorr " & vbcrlf & _  
"       join carreras as c " & vbcrlf & _  
"         on a.carr_ccod = c.carr_ccod " & vbcrlf & _  
"       join jornadas as d " & vbcrlf & _  
"         on a.jorn_ccod = d.jorn_ccod " & vbcrlf & _  
"       join sedes as e " & vbcrlf & _  
"         on a.sede_ccod = e.sede_ccod " & vbcrlf & _  
"       join tipos_categoria as f " & vbcrlf & _  
"         on a.tcat_ccod = f.tcat_ccod " & vbcrlf & _  
"       join jerarquias_docentes as g " & vbcrlf & _  
"         on f.jdoc_ccod = g.jdoc_ccod " & vbcrlf & _  
"       left outer join centros_costos_asignados as h " & vbcrlf & _  
"                    on a.carr_ccod = h.cenc_ccod_carrera " & vbcrlf & _  
"                       and a.jorn_ccod = h.cenc_ccod_jornada " & vbcrlf & _  
"                       and a.sede_ccod = h.cenc_ccod_sede " & vbcrlf & _  
"       join periodos_academicos as i " & vbcrlf & _  
"         on a.peri_ccod = i.peri_ccod " & vbcrlf & _  
"            and cast(i.anos_ccod as  varchar)='"&anos_ccod&"' "
 

'response.Write("<pre>"&sql_listado_escuelas&"</pre>")
'response.End()
set f_valor_escuelas  = new cformulario
f_valor_escuelas.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_escuelas.inicializar conexion							
f_valor_escuelas.consultar sql_listado_escuelas

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
   <td><div align="center"><strong>Rut</strong></div></td>
  <td><div align="center"><strong>Digito</strong></div></td>
  <td><div align="center"><strong>Nombre docente</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td><div align="center"><strong>Apellido Materno</strong></div></td>
    <td><div align="center"><strong>Sedes</strong></div></td>
    <td><div align="center"><strong>Carreras</strong></div></td>
    <td><div align="center"><strong>Jornadas</strong></div></td>
	<td><div align="center"><strong>Valor Sesion</strong></div></td>
	<td><div align="center"><strong>Centro Costo</strong></div></td>
	<td><div align="center"><strong>Jerarquia</strong></div></td>		
  </tr>
  <%  while f_valor_escuelas.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("digito")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("jornada")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("monto")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("centro_costo")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("jerarquia")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>