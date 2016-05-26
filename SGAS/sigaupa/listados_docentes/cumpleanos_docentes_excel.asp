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
anio_periodo = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
periodo_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct cast(datePart(day,d.pers_fnacimiento) as varchar)+'  de ' + protic.initcap(h.mes_tdesc) as cumpleaños,c.pers_ncorr,d.pers_nrut as rut, d.pers_xdv as dv, d.pers_tape_paterno as ap_paterno, d.pers_tape_materno as ap_materno, d.pers_tnombre as nombre,"& vbCrLf &_
		   " isnull(pers_tfono,'') as telefono,isnull(pers_tcelular,'') as celular, isnull(pers_temail,'') as email, "& vbCrLf &_
		   " case c.tpro_ccod  when 1 then 'Docente' else 'Ayudante' end as tipo_cargo, "& vbCrLf &_
		   " protic.trunc(cdoc_finicio) AS FECHA_INICIO, "& vbCrLf &_
		   " protic.trunc(cdoc_ffin) AS FECHA_FIN, g.duas_tdesc as duracion, "& vbCrLf &_
		   " datePart(month,d.pers_fnacimiento) as mes,datePart(day,d.pers_fnacimiento) as dia, "& vbCrLf &_
		   " protic.obtener_direccion(c.pers_ncorr,1,'CNPB') as direccion, protic.obtener_direccion(c.pers_ncorr,1,'C-C') as comuna_ciudad,"& vbCrLf &_
 		   " i.sede_tdesc as sede,j.carr_tdesc as carrera,k.jorn_tdesc as jornada "& vbCrLf &_
		   " from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,duracion_asignatura g, meses h, "& vbCrLf &_
		   " 	sedes i,carreras j, jornadas k, contratos_docentes_upa cdu    "& vbCrLf &_
		   " where a.secc_ccod=b.secc_ccod "& vbCrLf &_
		   " and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
		   " and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
		   " and cast(a.peri_ccod as varchar) in (select peri_ccod from periodos_academicos where anos_ccod='"&anio_periodo&"') "& vbCrLf &_
		   " and a.asig_ccod=f.asig_ccod "& vbCrLf &_
		   " and h.mes_ccod = datePart(month,d.pers_fnacimiento) "& vbCrLf &_
		   " and f.duas_ccod=g.duas_ccod	"& vbCrLf &_
		   "  and a.carr_ccod= j.carr_ccod "& vbCrLf &_
		   " and a.sede_ccod =i.sede_ccod "& vbCrLf &_
		   " and a.jorn_ccod=k.jorn_ccod "& vbCrLf &_
		   " and a.asig_ccod = protic.MAX_DURACION_ASIGNATURA(c.pers_ncorr,a.peri_ccod,'asig') "& vbCrLf &_
		   " and d.pers_ncorr=cdu.pers_ncorr "& vbCrLf &_
           "  and cdu.ano_contrato="&anio_periodo&"   "& vbCrLf &_
           "  and cdu.ecdo_ccod=1  "& vbCrLf &_
		   " order by datePart(month,d.pers_fnacimiento),datePart(day,d.pers_fnacimiento)"		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
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
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>COMUNA-CIUDAD</strong></div></td>	
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>TIPO DOCENTE</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>FECHA INICIO</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>FECHA FIN</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>DURACIÓN</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>CARRERA</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>JORNADA</strong></div></td>

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
	<td><div align="center"><%=f_listado.ObtenerValor("comuna_ciudad")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("tipo_cargo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("duracion")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("jornada")%></div></td>

  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>