<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=listado_moddle_excel.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = " select replace(replace(replace(replace(replace(replace(b.susu_tlogin,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(b.susu_tclave),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'),'Ñ','N') as passwords, "& vbCrLf &_
		   " cast(pers_nrut as varchar)+'-'+ pers_xdv as rut,c.pers_tnombre  as nombre,   "& vbCrLf &_
		   " c.pers_tape_paterno + ' ' + c.pers_tape_materno as apellidos,  "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(replace(lower(ltrim(rtrim(email_nuevo))),'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n'),' ','') as email_upa, "& vbCrLf &_
		   " (select top 1 carr_tdesc from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd, carreras ee "& vbCrLf &_
		   " where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.ESPE_CCOD "& vbCrLf &_
		   " and dd.carr_ccod=ee.carr_ccod and aa.pers_ncorr=b.pers_ncorr  "& vbCrLf &_
		   " and emat_ccod <> 9 order by bb.peri_ccod) as carrera, "& vbCrLf &_
		   " (select top 1 protic.ano_ingreso_carrera(aa.pers_ncorr,ee.carr_ccod) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd, carreras ee "& vbCrLf &_
		   " where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.ESPE_CCOD "& vbCrLf &_
		   " and dd.carr_ccod=ee.carr_ccod and aa.pers_ncorr=b.pers_ncorr  "& vbCrLf &_
		   " and emat_ccod <> 9 order by bb.peri_ccod) as año_ingreso, "& vbCrLf &_
		   " case when email_nuevo like '%@upacifico%' then 'Administrativo' "& vbCrLf &_
		   "     when email_nuevo like '%@docentes.upacifico%' then 'Docente' "& vbCrLf &_
		   "     else 'Alumno' end as tipo "& vbCrLf &_
		   " from cuentas_email_upa a,sis_usuarios b, personas c "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr  "& vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
		   " order by apellidos "


'response.Write("<pre>"&consulta&"</pre>")
formulario.Consultar consulta 

%>
<html>
<head>
<title>Listado de personas Moddle</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de personas Moddle</font></div></td>
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
    <td bgcolor="#9999FF"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Username</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Nombres</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Apellidos</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Email</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Carrera</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Año ingreso</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Tipo</strong></div></td>
  </tr>
  <% fila = 1 
   while formulario.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("username")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("apellidos")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("email_upa")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("año_ingreso")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("tipo")%></div></td>
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