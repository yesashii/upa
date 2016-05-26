<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=docentes_sin_contratos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct j.jorn_tdesc,pa.peri_tdesc,g.sede_tdesc as sede,d.carr_tdesc as carrera, cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut ,"& vbCrLf &_
		   " f.pers_tape_paterno + ' ' + f.pers_tape_materno+' '+ f.pers_tnombre as docente,h.tpro_tdesc as tipo_profesor,protic.trunc(c.audi_fmodificacion) as fecha_ingreso, "& vbCrLf &_
		   " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as encargado,ltrim(rtrim(asig.asig_ccod)) + ' ' + asig_tdesc as asignatura, "& vbCrLf &_
		   "  (select protic.trunc(min (bloq_finicio_modulo)) from secciones aa, bloques_horarios bb, bloques_profesores cc "& vbCrLf &_
		   "  where aa.carr_ccod=a.carr_ccod and aa.sede_ccod=a.sede_ccod and aa.peri_ccod=a.peri_ccod and aa.secc_ccod=bb.secc_ccod "& vbCrLf &_
		   "  and bb.bloq_ccod=cc.bloq_ccod and cc.pers_ncorr=c.pers_ncorr and cc.bloq_anexo is null) as finicio, "& vbCrLf &_
		   " (select protic.trunc(min (bloq_ftermino_modulo)) from secciones aa, bloques_horarios bb, bloques_profesores cc "& vbCrLf &_
		   " where aa.carr_ccod=a.carr_ccod and aa.sede_ccod=a.sede_ccod and aa.peri_ccod=a.peri_ccod and aa.secc_ccod=bb.secc_ccod "& vbCrLf &_
		   " and bb.bloq_ccod=cc.bloq_ccod and cc.pers_ncorr=c.pers_ncorr and cc.bloq_anexo is null) as ftermino "& vbCrLf &_
		   " from secciones a,bloques_horarios b, bloques_profesores c,carreras d, personas f,sedes g, "& vbCrLf &_
		   " tipos_profesores h,personas pp, asignaturas asig,periodos_academicos pa, jornadas j "& vbCrLf &_
		   " where a.secc_ccod=b.secc_ccod "& vbCrLf &_
		   " and a.asig_ccod=asig.asig_ccod "& vbCrLf &_
		   " and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
		   " and a.carr_ccod=d.carr_ccod "& vbCrLf &_
		   " and c.pers_ncorr=f.pers_ncorr	 "& vbCrLf &_
		   " and a.sede_ccod=g.sede_ccod "& vbCrLf &_
		   " and c.bloq_anexo is null "& vbCrLf &_
		   " and c.tpro_ccod=h.tpro_ccod "& vbCrLf &_
		   " and a.peri_ccod=pa.peri_ccod "& vbCrLf &_		   
		   " and c.pers_ncorr not in (27208) "& vbCrLf &_
		   " and cast(pp.pers_nrut as varchar) = c.audi_tusuario " & vbCrLf &_
		   " and a.jorn_ccod=j.jorn_ccod "& vbCrLf &_
		   " order by docente asc"		   

'response.Write("<pre>"&consulta&"</pre>")
f_listado.Consultar consulta

dia_actual = conexion.consultaUno("select datePart(day,getDate())")
mes_actual = conexion.consultaUno("select datePart(month,getDate())")
%>
<html>
<head>
<title>docentes sin contrato</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        Docentes sin contrato asociado</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  <tr> 
    <td width="10%">&nbsp;</td>
    <td width="90%" colspan="3">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#FFFFCC"><div align="left"><strong></strong></div></td>
    <td width="35%" bgcolor="#FFFFCC" colspan="4"><div align="center"><strong>CARRERA</strong></div></td>
	<td width="43%" bgcolor="#FFFFCC" colspan="3"><div align="center"><strong>DATOS DOCENTE</strong></div></td>
    <td width="45%" bgcolor="#FFFFCC" colspan="4"><div align="center"><strong>AUDITORIA</strong></div></td>
 </tr>

  <tr> 
    <td width="2%" bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="left"><strong>JORNADA</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="left"><strong>PERIODO ACADEMICO</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="left"><strong>ASIGNATURA</strong></div></td>
	<td width="8%" bgcolor="#FFFFCC"><div align="left"><strong>R.U.T.</strong></div></td>
    <td width="25%" bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE DOCENTE</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>TIPO DOCENTE</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>FECHA INGRESO</strong></div></td>
	<td width="25%" bgcolor="#FFFFCC"><div align="left"><strong>ENCARGADO</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>F.INICIO</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>F.TERMINO</strong></div></td>
 </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
   	<td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("jorn_tdesc")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("peri_tdesc")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("asignatura")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("docente")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("tipo_profesor")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_ingreso")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("encargado")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("finicio")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("ftermino")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>