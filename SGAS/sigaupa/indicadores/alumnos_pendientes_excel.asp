<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_pendientes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"


'-----------------------------------------------------------------------
v_anos = request.QueryString("v_anos")

'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = " select distinct d.pers_nrut as rut, d.pers_xdv as dv, d.pers_tnombre as nombres, "& vbCrLf &_
		   " d.pers_tape_paterno + ' ' + d.pers_tape_materno as apellidos, f.carr_tdesc as carrera, "& vbCrLf &_
		   " (select top 1 peri_tdesc from alumnos a1, ofertas_academicas o1,especialidades e1,periodos_academicos p1  "& vbCrLf &_
		   "                         where a1.pers_ncorr=a.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr  "& vbCrLf &_
		   "                         and o1.espe_ccod = e1.espe_ccod and e1.carr_ccod=e.carr_ccod "& vbCrLf &_
		   "                         and o1.peri_ccod=p1.peri_ccod and p1.anos_ccod = '"&v_anos&"' "& vbCrLf &_
		   "                         order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)as ultimo_periodo "& vbCrLf &_
		   " from alumnos a, ofertas_academicas b, periodos_academicos c, personas d, especialidades e, carreras f "& vbCrLf &_
		   " where a.ofer_ncorr=b.ofer_ncorr  "& vbCrLf &_
		   " and b.peri_ccod=c.peri_ccod and c.anos_ccod='"&v_anos&"' "& vbCrLf &_
		   " and a.pers_ncorr=d.pers_ncorr and f.tcar_ccod=1 "& vbCrLf &_
		   " and b.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
		   " and not exists (select 1 from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
		   "                where a.pers_ncorr=aa.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod "& vbCrLf &_
		   "                and cast(cc.anos_ccod as varchar) > '"&v_anos&"' and bb.espe_ccod=dd.espe_ccod and dd.carr_ccod=e.carr_ccod ) "& vbCrLf &_
		   " and (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1,especialidades e1,periodos_academicos p1  "& vbCrLf &_
		   "                        where a1.pers_ncorr=a.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr  "& vbCrLf &_
		   "                        and o1.espe_ccod = e1.espe_ccod and e1.carr_ccod=e.carr_ccod "& vbCrLf &_
		   "                        and o1.peri_ccod=p1.peri_ccod and p1.anos_ccod = '"&v_anos&"' "& vbCrLf &_
		   "                        order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc) = '1'     "

'response.Write("<pre>"&consulta&"</pre>")
formulario.Consultar consulta & " order by carrera, apellidos"

total = conexion.consultaUno("select count(*) from ("&consulta&")a")


%>
<html>
<head>
<title>Listado de alumnos que no renovaron matrículas y permanecen activos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de alumnos que no renovaron matrículas y permanecen activos</font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
 </tr>
 <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%></td>
 </tr>
 <tr> 
    <td width="16%"><strong>Año</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=v_anos%> </td>
 </tr>
  <tr> 
    <td width="16%"><strong>Total</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=total%> Alumnos </td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#9999FF"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Rut</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Nombres</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Apellidos</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Carrera</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Último periodo</strong></div></td>
  </tr>
  <% fila = 1 
   while formulario.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut")%>-<%=formulario.ObtenerValor("dv")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("nombres")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("apellidos")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("ultimo_periodo")%></div></td>
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