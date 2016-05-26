<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=listado_docentes_asignatura.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
Periodo=negocio.obtenerPeriodoAcademico("Postulacion")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&Periodo&"'")


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_listado = new CFormulario
f_listado.Carga_Parametros "lista_docentes.xml", "f_listado2"
f_listado.Inicializar conexion
		   
consulta = " select distinct b.sede_tdesc as sede, c.carr_tdesc  as carrera,d.asig_ccod as cod_asig,d.asig_tdesc as asignatura, "& vbCrLf &_
		   " a.secc_tdesc as seccion,cast(g.pers_nrut as varchar) + '-' + g.pers_xdv as rut,g.pers_tnombre +' '+ g.pers_tape_paterno +' ' + "& vbCrLf &_
		   " g.pers_tape_materno as nombre,h.tpro_tdesc as tipo, i.peri_tdesc as periodo,protic.trunc(secc_finicio_sec) as finicio, "& vbCrLf &_
		   " protic.trunc(secc_ftermino_sec) as ftermino, j.duas_tdesc as duracion  "& vbCrLf &_
		   " from secciones a,sedes b,carreras c,asignaturas d,bloques_horarios e,bloques_profesores f,personas g, tipos_profesores h, "& vbCrLf &_
		   " periodos_academicos i,duracion_asignatura j  "& vbCrLf &_
		   " where a.sede_ccod=b.sede_ccod "& vbCrLf &_
		   " and a.carr_ccod=c.carr_ccod "& vbCrLf &_
		   " and a.asig_ccod=d.asig_ccod "& vbCrLf &_
		   " and a.secc_ccod=e.secc_ccod "& vbCrLf &_
		   " and e.bloq_ccod=f.bloq_ccod "& vbCrLf &_
		   " and f.pers_ncorr=g.pers_ncorr "& vbCrLf &_
		   " and f.tpro_ccod=h.tpro_ccod "& vbCrLf &_
		   " and a.peri_ccod=i.peri_ccod "& vbCrLf &_
		   " and d.duas_ccod = j.duas_ccod "& vbCrLf &_
		   " and cast(i.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf &_
		   " order by b.sede_tdesc,c.carr_tdesc,d.asig_tdesc"
		   
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta
%>
<html>
<head>
<title> lista docentes </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado De docentes por Asignatura y Sede</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%></td>
    
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%"><div align="center"><strong>N°</strong></div></td>
	<td width="5%"><div align="center"><strong>Sede</strong></div></td>
    <td width="10%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="5%"><div align="center"><strong>Cod.Asig</strong></div></td>
	<td width="15%"><div align="center"><strong>Asignatura</strong></div></td>
	<td width="5%"><div align="center"><strong>Seccion</strong></div></td>
    <td width="5%"><div align="center"><strong>Rut</strong></div></td>
	<td width="15%"><div align="center"><strong>Docente</strong></div></td>
	<td width="5%"><div align="center"><strong>Tipo</strong></div></td>
	<td width="8%"><div align="center"><strong>Periodo</strong></div></td>
	<td width="5%"><div align="center"><strong>Duraci&oacute;n</strong></div></td>
	<td width="5%"><div align="center"><strong>Fecha Inicio</strong></div></td>
	<td width="5%"><div align="center"><strong>Fecha T&eacute;rmino</strong></div></td>
  </tr>
  <% fila=1 
     while f_listado.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("sede")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("cod_asig")%></div></td>
    <td><div align="left"><%=f_listado.ObtenerValor("asignatura")%></div></td>
    <td><div align="left"><%=f_listado.ObtenerValor("seccion")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("nombre")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("tipo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("periodo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("duracion")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("finicio")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("ftermino")%></div></td>
  </tr>
  <% fila=fila+1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>