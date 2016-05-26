<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_email.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
periodo = negocio.obtenerPeriodoAcademico("Postulacion")

'-----------------------------------------------------------------------
tipo = request.QueryString("tipo")
'------------------------------------------------------------------------------------
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
periodo = "218" 'Primer semestre 2010
'------------------------------------------------------------------------------------

set alumnos		=	new cformulario
alumnos.carga_parametros "notas.xml" , "alumnos"
alumnos.Inicializar conexion

fecha_inicio = conexion.consultaUno("select protic.trunc(getDate() - 1)  + ' 08:00:00.000'")
fecha_termino = conexion.consultaUno("select protic.trunc(getDate())  + ' 08:00:00.000'")

'fecha_inicio = conexion.consultaUno("select '05/12/2007 18:00:00.000'")
'fecha_termino = conexion.consultaUno("select '12/12/2007 08:00:00.000'")
if tipo = "1" then
consulta = " select email,fono,celular,alumno as nombre, " & vbCrlf & _
		   " case cantidad when 0 then 'Sin Carrera' " & vbCrlf & _
		   " when 1 then (select carr_tdesc " & vbCrlf & _
		   "             from detalle_postulantes bb, ofertas_academicas cc,  especialidades ee, carreras ff " & vbCrlf & _
		   "             where bb.post_ncorr=aa.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr " & vbCrlf & _
		   "             and cc.espe_ccod=ee.espe_ccod " & vbCrlf & _
		   "             and ee.carr_ccod = ff.carr_ccod ) " & vbCrlf & _
		   " else 'Varias' end " & vbCrlf & _
		   " as carrera, " & vbCrlf & _
		   " fecha,hora " & vbCrlf & _
		   " from  " & vbCrlf & _
		   " ( " & vbCrlf & _
		   " select a.post_ncorr, b.pers_tnombre as alumno,b.pers_temail as email, isnull(b.pers_tfono,'--') as fono, isnull(b.pers_tcelular,'--') as celular, " & vbCrlf & _
		   " (select count(*) from detalle_postulantes aa where aa.post_ncorr=a.post_ncorr) as cantidad, " & vbCrlf & _
		   " protic.trunc(a.audi_fmodificacion) as fecha, " & vbCrlf & _
		   " case when datepart(hour,a.audi_fmodificacion) < 10 then '0' else '' end + cast(datepart(hour,a.audi_fmodificacion)as varchar) + ':' +  " & vbCrlf & _
		   " case when datepart(minute,a.audi_fmodificacion) < 10 then '0' else '' end + cast(datepart(minute,a.audi_fmodificacion) as varchar) as hora " & vbCrlf & _
		   " from postulantes a, personas_postulante b " & vbCrlf & _
		   " where a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
		   " and cast(a.peri_ccod as varchar) = '"&periodo&"'" & vbCrlf & _
		   " and post_bnuevo='S' and a.epos_ccod in (1) " & vbCrlf & _
		   " --and isnull(b.pers_temail,'')<>'' " & vbCrlf & _
		   " and a.audi_fmodificacion >= '"&fecha_inicio&"' " & vbCrlf & _
		   " and a.audi_fmodificacion <= '"&fecha_termino&"' " & vbCrlf & _
		   " and not exists (select 1 from alumnos aa where aa.post_ncorr=a.post_ncorr and emat_ccod <> '9' and alum_nmatricula <> '7777') " & vbCrlf & _
		   " )aa " & vbCrlf & _
		   " where cantidad <> 0 " 
		   
		   titulo = "Listado de Personas Postulante en las últimas 24 hrs."
		   
elseif tipo="2" then
consulta = " select b.pers_temail as email,isnull(b.pers_tfono,'--') as fono, isnull(b.pers_tcelular,'--') as celular, " & vbCrlf & _
 		   " b.pers_tnombre as nombre,carr_tdesc as carrera,  " & vbCrlf & _
		   " protic.trunc(c.audi_fmodificacion) as fecha,  " & vbCrlf & _
		   " case when datepart(hour,c.audi_fmodificacion) < 10 then '0' else '' end + cast(datepart(hour,c.audi_fmodificacion)as varchar) + ':' +   " & vbCrlf & _
		   " case when datepart(minute,c.audi_fmodificacion) < 10 then '0' else '' end + cast(datepart(minute,c.audi_fmodificacion) as varchar) as hora  " & vbCrlf & _
		   " from postulantes a, personas_postulante b, detalle_postulantes c,ofertas_academicas d, especialidades e,carreras f  " & vbCrlf & _
		   " where a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
		   " and a.post_ncorr=c.post_ncorr" & vbCrlf & _
		   " and cast(a.peri_ccod as varchar) = '"&periodo&"' " & vbCrlf & _
		   " and a.post_bnuevo='S'  " & vbCrlf & _
		   " --and isnull(b.pers_temail,'')<>'' " & vbCrlf & _
		   " and c.audi_fmodificacion >= '"&fecha_inicio&"' " & vbCrlf & _
		   " and c.audi_fmodificacion <= '"&fecha_termino&"' " & vbCrlf & _
		   " and c.eepo_ccod = 2 " & vbCrlf & _
		   " and c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod " & vbCrlf & _
		   " and e.carr_ccod=f.carr_ccod " & vbCrlf & _
		   " and not exists (select 1 from alumnos aa where aa.post_ncorr=a.post_ncorr and emat_ccod <> '9' and alum_nmatricula <> '7777') " 

           titulo = "Listado de Personas con test de admisión aprobado en las últimas 24 hrs."     

elseif tipo="3" then
consulta = " select b.pers_temail as email,isnull(b.pers_tfono,'--') as fono, isnull(b.pers_tcelular,'--') as celular, " & vbCrlf & _
		   " b.pers_tnombre as nombre,carr_tdesc as carrera,  " & vbCrlf & _
		   " protic.trunc(g.alum_fmatricula) as fecha,  " & vbCrlf & _
		   " case when datepart(hour,g.alum_fmatricula ) < 10 then '0' else '' end + cast(datepart(hour,g.alum_fmatricula )as varchar) + ':' +   " & vbCrlf & _
		   " case when datepart(minute,g.alum_fmatricula ) < 10 then '0' else '' end + cast(datepart(minute,g.alum_fmatricula ) as varchar) as hora  " & vbCrlf & _
		   " from postulantes a, personas_postulante b, detalle_postulantes c,ofertas_academicas d, especialidades e,carreras f, alumnos g  " & vbCrlf & _
		   " where a.pers_ncorr=b.pers_ncorr  " & vbCrlf & _
		   " and a.post_ncorr=c.post_ncorr " & vbCrlf & _
		   " and a.post_ncorr=g.post_ncorr and c.ofer_ncorr=g.ofer_ncorr " & vbCrlf & _
		   " and g.emat_ccod <> '9' and g.alum_nmatricula <> '7777' " & vbCrlf & _
		   " and cast(a.peri_ccod as varchar) = '"&periodo&"' " & vbCrlf & _
		   " and a.post_bnuevo='S' " & vbCrlf & _
		   " --and isnull(b.pers_temail,'')<>'' " & vbCrlf & _
		   " and g.audi_fmodificacion >= '"&fecha_inicio&"' " & vbCrlf & _
		   " and g.audi_fmodificacion <= '"&fecha_termino&"' " & vbCrlf & _
		   " and g.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod " & vbCrlf & _
		   " and e.carr_ccod=f.carr_ccod " 
		   
		   titulo = "Listado de alumnos matriculados en las últimas 24 hrs."

end if		   
'response.Write("<pre>"&consulta&"</pre>")
alumnos.Consultar consulta
%>
<html>
<head>
<title><%=titulo%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=titulo%><br></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="left"><strong>N°</strong></div></td>
    <td><div align="center"><strong>E-Mail</strong></div></td>
	<td><div align="center"><strong>Teléfono</strong></div></td>
	<td><div align="center"><strong>Celular</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Hora</strong></div></td>
  </tr>
  <%  fila = 1
    while alumnos.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=alumnos.ObtenerValor("email")%></div></td>
	<td><div align="left"><%=alumnos.ObtenerValor("fono")%></div></td>
	<td><div align="left"><%=alumnos.ObtenerValor("celular")%></div></td>
	<td><div align="left"><%=alumnos.ObtenerValor("nombre")%></div></td>
    <td><div align="center"><%=alumnos.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=alumnos.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=alumnos.ObtenerValor("hora")%></div></td>
  </tr>
  <%fila = fila +1
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>