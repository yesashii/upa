<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=excel_mal_cerradas.xls"
Response.ContentType = "application/vnd.ms-excel"

q_peri_ccod = Request.QueryString("peri_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_asignaturas.Inicializar conexion
		   
consulta=" select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
					 " e.asig_ccod as cod_asignatura, asig_tdesc as asignatura, secc_tdesc as sección,protic.profesores_seccion(a.secc_ccod) as profesores "& vbCrLf &_
					 " from secciones a, sedes b, carreras c, jornadas d, asignaturas e "& vbCrLf &_
					 " where a.sede_ccod=b.sede_ccod and a.carr_ccod=c.carr_ccod "& vbCrLf &_
					 " and a.jorn_ccod=d.jorn_ccod and a.asig_ccod=e.asig_ccod "& vbCrLf &_
					 " and cast(a.peri_ccod as varchar)='"&q_peri_ccod&"' and isnull(a.estado_cierre_ccod,1) = 2 "& vbCrLf &_
					 " and exists ( "& vbCrLf &_
					 "			 select 1  "& vbCrLf &_
					 "			 from cargas_academicas tt  "& vbCrLf &_
					 "			 where tt.secc_ccod=a.secc_ccod and len(ltrim(rtrim(isnull(replace(sitf_ccod,' ',''),'')))) = 0 "& vbCrLf &_
					 "			) "& vbCrLf &_
					 " order by sede,carrera,jornada,asignatura,sección"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_asignaturas.Consultar consulta 

peri_tdesc =  conexion.consultaUno("select protic.initCap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&q_peri_ccod&"'")

%>
<html>
<head>
<title>Asignaturas mal eliminadas <%=peri_tdesc%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Asignaturas mal cerradas <%=peri_tdesc%></font></div>
	<div align="right"><%=fecha%></div></td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td align="left" bgcolor="#FF9933"><strong>Sede</strong></td>
    <td align="left" bgcolor="#FF9933"><strong>Carrera</strong></td>
    <td align="left" bgcolor="#FF9933"><strong>Jornada</strong></td>
	<td align="left" bgcolor="#FF9933"><strong>Cód.Asignatura</strong></td>
    <td align="left" bgcolor="#FF9933"><strong>Asignatura</strong></td>
    <td align="left" bgcolor="#FF9933"><strong>Sección</strong></td>
    <td align="left" bgcolor="#FF9933"><strong>Profesores</strong></td>
  </tr>
  <%while f_asignaturas.Siguiente %>
  <tr> 
    <td><%=f_asignaturas.ObtenerValor("sede")%></td>
    <td><%=f_asignaturas.ObtenerValor("carrera")%></td>
    <td><%=f_asignaturas.ObtenerValor("jornada")%></td>
    <td><%=f_asignaturas.ObtenerValor("cod_asignatura")%></td>
    <td><%=f_asignaturas.ObtenerValor("asignatura")%></td>
	<td><%=f_asignaturas.ObtenerValor("sección")%></td>
	<td><%=f_asignaturas.ObtenerValor("profesores")%></td>
  </tr>
  <%wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>