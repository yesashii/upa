<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=cumpleanos_docentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
periodo_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct cast(datePart(day,d.pers_fnacimiento) as varchar)+'  de ' + protic.initcap(h.mes_tdesc) as cumpleaños,c.pers_ncorr,d.pers_nrut as rut, d.pers_xdv as dv, d.pers_tape_paterno as ap_paterno, d.pers_tape_materno as ap_materno, d.pers_tnombre as nombre,"& vbCrLf &_
		   " isnull(pers_tfono,'') as telefono,isnull(pers_tcelular,'') as celular, isnull(pers_temail,'') as email,isnull(protic.obtener_direccion_letra(c.pers_ncorr,1,'CNPB'),'') as direccion, "& vbCrLf &_
		   " case c.tpro_ccod  when 1 then 'Docente' else 'Ayudante' end as tipo_cargo, "& vbCrLf &_
		   " protic.MAX_DURACION_ASIGNATURA(c.pers_ncorr,a.peri_ccod,'fini') AS FECHA_INICIO, "& vbCrLf &_
		   " protic.MAX_DURACION_ASIGNATURA(c.pers_ncorr,a.peri_ccod,'ffin') AS FECHA_FIN, g.duas_tdesc as duracion, "& vbCrLf &_
		   " datePart(month,d.pers_fnacimiento) as mes,datePart(day,d.pers_fnacimiento) as dia"& vbCrLf &_
		   " from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,duracion_asignatura g, meses h "& vbCrLf &_
		   " where a.secc_ccod=b.secc_ccod "& vbCrLf &_
		   " and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
		   " and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
		   " and cast(peri_ccod as varchar)='"&periodo&"' "& vbCrLf &_
		   " and a.asig_ccod=f.asig_ccod "& vbCrLf &_
		   " and h.mes_ccod = datePart(month,d.pers_fnacimiento) "& vbCrLf &_
		   " and f.duas_ccod=g.duas_ccod	"& vbCrLf &_
		   " and a.asig_ccod = protic.MAX_DURACION_ASIGNATURA(c.pers_ncorr,a.peri_ccod,'asig') "& vbCrLf &_
		   " order by datePart(month,d.pers_fnacimiento),datePart(day,d.pers_fnacimiento)"		   

'response.Write("<pre>"&consulta&"</pre>")
f_listado.Consultar consulta

dia_actual = conexion.consultaUno("select datePart(day,getDate())")
mes_actual = conexion.consultaUno("select datePart(month,getDate())")
%>
<html>
<head>
<title>clasificacion por grado academico</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        Cumplea&ntilde;os Docentes </font></div>
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
    <td width="10%"><strong>Periodo</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=periodo_tdesc%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2" bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>CUMPLEA&Ntilde;OS</strong></div></td>
	<td width="8%" bgcolor="#FFFFCC"><div align="left"><strong>R.U.T.</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE DOCENTE</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>TEL&Eacute;FONO</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>CELULAR</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>EMAIL</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>DIRECCI&Oacute;N</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>TIPO DOCENTE</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>FECHA INICIO</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>FECHA FIN</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>DURACIÓN</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <%if dia_actual=f_listado.ObtenerValor("dia") and mes_actual=f_listado.ObtenerValor("mes") then%> 
    <td bgcolor="#FF9900"><div align="left"><%=fila%></div></td>
	<%else%>
	<td><div align="left"><%=fila%></div></td>
	<%end if%>
	<td><div align="left"><%=f_listado.ObtenerValor("cumpleaños")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("rut")%>-<%=f_listado.ObtenerValor("dv")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("nombre")%>&nbsp;<%=f_listado.ObtenerValor("ap_paterno")%>&nbsp;<%=f_listado.ObtenerValor("ap_materno")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("telefono")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("celular")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("email")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("direccion")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("tipo_cargo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("duracion")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>