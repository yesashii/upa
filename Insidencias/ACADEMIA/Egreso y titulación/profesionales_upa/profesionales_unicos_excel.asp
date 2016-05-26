<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=titulados_egresados_unicos.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 300000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
           " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email  "& vbCrLf &_
		   "   from alumni_personas a (nolock), alumnos b (nolock) "& vbCrLf &_
		   "   where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8)  "& vbCrLf &_
		   " union  "& vbCrLf &_
		   " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
		   " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email   "& vbCrLf &_
		   "   from alumni_personas a (nolock), egresados_upa2 b  "& vbCrLf &_
		   "   where a.pers_nrut=b.pers_nrut and a.pers_xdv=b.pers_xdv  "& vbCrLf &_
		   " union   "& vbCrLf &_
		   " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
		   " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email   "& vbCrLf &_
		   "   from alumni_personas a, alumnos_salidas_intermedias b,alumnos_salidas_carrera c  "& vbCrLf &_
		   "   where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8)   "& vbCrLf &_
		   "   and b.saca_ncorr=c.saca_ncorr and b.pers_ncorr=c.pers_ncorr  "

'response.End()
f_alumnos.Consultar consulta
%>
<html>
<head>
<title>Listado alumnos pertenecientes a la corporación de profesionales</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado alumnos pertenecientes a la corporación de profesionales</font></div>
	<div align="right"><%=fecha%></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr>
    <td><div align="center"><strong>Fila</strong></div></td> 
    <td><div align="left"><strong>Rut</strong></div></td>
    <td><div align="left"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>AP. Paterno</strong></div></td>
	<td><div align="center"><strong>AP. Materno</strong></div></td>
	<td><div align="center"><strong>Email</strong></div></td>
   </tr>
  <%fila = 1  
    while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("ap_paterno")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("ap_materno")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("email")%></div></td>
  </tr>
  <%fila = fila + 1  
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>