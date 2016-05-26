<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=contratos_dia.xls"
Response.ContentType = "application/vnd.ms-excel"
 
inicio = request.QueryString("inicio")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103)")
'------------------------------------------------------------------------------------
tituloPag = "Listado de Alumnos contratados "

set f_matriculados = new cformulario
f_matriculados.carga_parametros "consulta.xml","consulta"
f_matriculados.inicializar conexion

consulta = " select d.sede_tdesc as sede,c.cont_ncorr as n_contrato,e.econ_tdesc as estado,protic.trunc(c.cont_fcontrato) as fecha, " & vbCrLf &_
		   " cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut,f.pers_tnombre + ' ' + f.pers_tape_paterno + ' ' + pers_tape_materno as nombre, " & vbCrLf &_
		   " h.carr_tdesc as carrera, i.jorn_tdesc as jornada,protic.ano_ingreso_carrera(a.pers_ncorr,h.carr_ccod) as promocion " & vbCrLf &_
		   " from alumnos a, ofertas_Academicas b, contratos c,sedes d,estados_contrato e,personas f, " & vbCrLf &_
		   " especialidades g, carreras h, jornadas i " & vbCrLf &_
		   " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
		   " and a.matr_ncorr=c.matr_ncorr " & vbCrLf &_
		   " and b.sede_ccod=d.sede_ccod " & vbCrLf &_
		   " and c.econ_ccod=e.econ_ccod " & vbCrLf &_
		   " and a.pers_ncorr=f.pers_ncorr " & vbCrLf &_
		   " and b.espe_ccod=g.espe_ccod " & vbCrLf &_
		   " and g.carr_ccod=h.carr_ccod " & vbCrLf &_
		   " and b.jorn_ccod=i.jorn_ccod " & vbCrLf &_
		   " and c.audi_tusuario not in ('contrato -CREAR_MATRICULA_SEG_SEMESTRE') "& vbCrLf &_
		   " and datepart(day, c.cont_fcontrato)=datepart(day, convert(datetime,'"&inicio&"',103)) " & vbCrLf &_
		   " and datepart(month, c.cont_fcontrato)=datepart(month, convert(datetime,'"&inicio&"',103)) " & vbCrLf &_
		   " and datepart(year, c.cont_fcontrato)=datepart(year, convert(datetime,'"&inicio&"',103))" 

f_matriculados.Consultar consulta

%>
<html>
<head>
<title>Listado de alumnos contratados por día</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="11%" height="22"><strong>Contratos día </strong></td>
    <td width="89%" colspan="3"><strong>:</strong> <%=inicio %> </td>
  </tr>
  <tr>
    <td><strong>Fecha actual</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha_01%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#FFFFCC" ><div align="center"><strong>N°</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>N° Contrato</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
	<td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Promoci&oacute;n</strong></div></td>
  </tr>
  <% fila = 1 
     while f_matriculados.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("n_contrato")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("fecha")%></div></td>
    <td><div align="left"><%=f_matriculados.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_matriculados.ObtenerValor("nombre")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("estado")%></div></td>
	<td><div align="left"><%=f_matriculados.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_matriculados.ObtenerValor("jornada")%></div></td>
	<td><div align="left"><%=f_matriculados.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("promocion")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>