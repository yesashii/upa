<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_acreditacion_alumnos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
carr_ccod = request.QueryString("carr_ccod")
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'---------------------------------------------------encuesta Alumnos--------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select distinct a.pers_ncorr,d.sede_tdesc as sede,f.carr_tdesc as carrera,g.jorn_tdesc as jornada, "& vbCrLf &_
		   " cast(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,a.carr_ccod) as varchar) as ano_ingreso, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " sugerencias_carrera  "& vbCrLf &_
		   " from encuestas_alumnos a,alumnos b,ofertas_academicas c,sedes d,especialidades e,carreras f,jornadas g "& vbCrLf &_
		   " where isnull(antiguos,'N')='N' and a.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
		   " and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " and b.ofer_ncorr=c.ofer_ncorr  "& vbCrLf &_
		   " and c.peri_ccod = (select max(peri_ccod) from alumnos aa, ofertas_academicas bb, especialidades cc  "& vbCrLf &_
		   "                   where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
		   "                   and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=a.carr_ccod and aa.emat_ccod in (1,2,4,8,10,13)) "& vbCrLf &_
		   " and c.sede_ccod = d.sede_ccod "& vbCrLf &_                  
		   " and c.espe_ccod = e.espe_ccod "& vbCrLf &_
		   " and b.emat_ccod in (1,2,4,8,10,13) "& vbCrLf &_
		   " and e.carr_ccod = f.carr_ccod "& vbCrLf &_
		   " and c.jorn_ccod = g.jorn_ccod and isnull(a.pers_ncorr,0)<>0"& vbCrLf &_
		   " union all "& vbCrLf &_
           " select a.pers_ncorr,'Anónimo' as sede,'Anónimo' as carrera,'Anónimo' as jornada, "& vbCrLf &_
		   " 'Anónimo' as ano_ingreso, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " sugerencias_carrera  "& vbCrLf &_
		   " from encuestas_alumnos a,carreras f "& vbCrLf &_
		   " where isnull(antiguos,'N')='N' and a.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
		   " and a.carr_ccod = f.carr_ccod "& vbCrLf &_
		   " and isnull(a.pers_ncorr,0)=0"
		   


           
f_alumnos.Consultar consulta
'response.Write("<pre>"&consulta&"</pre>")

%>
<html>
<head>
<title>Resultados Parciales Encuesta Acreditación Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Parciales Encuesta de Acreditación Alumnos</font></div>
	</td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="84%" colspan="3">&nbsp;</td>
  </tr>
</table>
 <p>&nbsp;</p>
  <table width="100%" border="1">
  <tr><td colspan="4" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Alumnos</strong></font></td>
      <td colspan="6" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Sede</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Jornada</strong></div></td>
    <td><div align="center"><strong>Indicativo</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
	<td><div align="center"><strong>Año Ingreso</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="left"><strong>Señale a continuación sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%="Alumno "&fila %></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("sexo")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("ano_ingreso")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("edad_alumno")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("fecha")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("sugerencias_carrera")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>