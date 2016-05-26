<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_convenios.xls"
Response.ContentType = "application/vnd.ms-excel"

'-----------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
nuevos=request.Form("nuevos")
antiguos=request.Form("antiguos")
nulos=request.Form("nulos")
total=cint(nuevos)+cint(antiguos)+cint(nulos)
sede=request.Form("sede")
estado=request.Form("estado")
'------------------------------------------------------------------------------------
if sede<>"" then
  nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
else
  nombre_sede="Todas las sedes"  
end if
if estado<>"" then
  nombre_estado=conexion.consultaUno("select econ_tdesc from estados_contrato where cast(econ_ccod as varchar)='"&estado&"'")
else
  nombre_estado="Todos los estados de Contrato"  
end if

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_convenios = new CFormulario
f_convenios.Carga_Parametros "resumen_convenios.xml", "convenios2"
f_convenios.Inicializar conexion
		   
consulta = "select distinct cast(datePart(day,a.cont_fcontrato)as varchar)+'-'+cast(datePart(month,a.cont_fcontrato) as varchar)+'-'+cast(datePart(year,a.cont_fcontrato) as varchar) as fecha," & vbCrLf &_
 		   " a.cont_ncorr as contrato,protic.format_rut(c.pers_nrut) as rut,f.carr_tdesc +' - '+substring(g.jorn_tdesc,1,1) as escuela," & vbCrLf &_
		   " a.cont_ncorr,f.carr_ccod as cod_carrera,h.anos_ccod as promocion," & vbCrLf &_
		   " case j.mcaj_ncorr when null then '' else 'M-'+cast(j.mcaj_ncorr as varchar) end  as caja, i.econ_tdesc as estado" & vbCrLf &_
		   " from contratos a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f," & vbCrLf &_
		   " jornadas g,periodos_academicos h,estados_contrato i,ingresos j" & vbCrLf &_
		   " where a.post_ncorr=b.post_ncorr" & vbCrLf &_
           " and a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=j.pers_ncorr" & vbCrLf &_
           " and b.ofer_ncorr=d.ofer_ncorr" & vbCrLf &_
           " and d.espe_ccod=e.espe_ccod" & vbCrLf &_
           " and e.carr_ccod=f.carr_ccod" & vbCrLf &_
		   " and d.jorn_ccod=g.jorn_ccod" & vbCrLf &_
           " and a.econ_ccod=i.econ_ccod" & vbCrLf &_
		   " and d.peri_ccod=h.peri_ccod" & vbCrLf &_
		   " and j.ting_ccod='7'"
		   
if sede<>""  then
		   consulta= consulta & " and cast(d.sede_ccod as varchar)='"&sede&"'"
end if
if estado<>""  then
		   consulta= consulta & " and cast(a.econ_ccod as varchar)='"&estado&"'"
end if		   
'response.Write("sede "&sede&" estado= "&estado&"<br>")
'response.Write("<pre>"&consulta&"</pre>")		
'response.End()
f_convenios.Consultar consulta
%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resumen de Convenios</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>Sede</strong></td>
    <td colspan="3"><strong>:</strong> <% =nombre_sede%> </td>
    
  </tr>
  <tr> 
    <td><strong>Estado Contrato</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_estado %> </td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td><strong>Emitidos Nuevos</strong></td>
    <td> <strong>:</strong> 
      <%=nuevos%>
    </td>
   <td><strong>Emitidos Antiguos</strong></td>
    <td> <strong>:</strong> 
      <%=antiguos%>
    </td>
  </tr>
  <tr>
    <td><strong>Total Nulos</strong></td>
    <td> <strong>:</strong> 
      <%=nulos%>
    </td>
   <td><strong>Total Emitidos</strong></td>
    <td> <strong>:</strong> 
      <%=total%>
    </td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="5%"><div align="center"><strong>Fecha</strong></div></td>
    <td width="6%"><div align="center"><strong>Contrato</strong></div></td>
    <td width="7%"><div align="center"><strong>Rut</strong></div></td>
	<td width="30%"><div align="center"><strong>Escuela</strong></div></td>
    <td width="2%"><div align="center"><strong>Cod. Esc.</strong></div></td>
    <td width="3%"><div align="center"><strong>Promoci&oacute;n</strong></div></td>
    <td width="3%"><div align="center"><strong>Caja</strong></div></td>
	<td width="4%"><div align="center"><strong>Estado</strong></div></td>
  </tr>
  <%  while f_convenios.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_convenios.ObtenerValor("fecha")%></div></td>
    <td><div align="center"><%=f_convenios.ObtenerValor("contrato")%></div></td>
    <td><div align="center"><%=f_convenios.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_convenios.ObtenerValor("escuela")%></div></td>
    <td><div align="center"><%=f_convenios.ObtenerValor("cod_carrera")%></div></td>
	<td><div align="center"><%=f_convenios.ObtenerValor("promocion")%></div></td>
	<td><div align="center"><%=f_convenios.ObtenerValor("caja")%></div></td>
	<td><div align="center"><%=f_convenios.ObtenerValor("estado")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>