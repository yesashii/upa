<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=control_asistencia.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
periodo = negocio.obtenerPeriodoAcademico("Postulacion")

rut       = "7229257" 
digito    = "K" 

'-----------------------------------------------------------------------
secc_ccod = request.QueryString("secc_ccod")
'------------------------------------------------------------------------------------
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
'------------------------------------------------------------------------------------
asignatura = conexion.consultaUno("select ltrim(rtrim(b.asig_ccod)) +' --> '+b.asig_tdesc from secciones a, asignaturas b where  a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
'dias_tdesc = conexion.consultaUno("select dias_tdesc from dias_semana where dias_ccod=datePart(weekday,getDate())")
seccion = conexion.consultaUno("select secc_tdesc from secciones where  cast(secc_ccod as varchar)='"&secc_ccod&"'")
nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion 

consulta = "  select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, " &vbcrlf &_
		   "  c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', '+c.pers_tnombre as alumno " &vbcrlf &_
		   "  from cargas_academicas a, alumnos b, personas c " &vbcrlf &_
		   "  where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr " &vbcrlf &_
		   "  and cast(secc_ccod as varchar)='"&secc_ccod&"' " &vbcrlf &_
		   "  order by alumno "
		   
formulario.Consultar consulta

set formulario_bloques = new CFormulario
formulario_bloques.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario_bloques.Inicializar conexion 

consulta2 = " select distinct protic.trunc(b.fecha_ingreso) + ':' + cast(hora_ccod as varchar) as fecha,c.bloq_ccod, " &vbcrlf &_
			" c.hora_ccod, b.fecha_ingreso,b.adia_ncorr " &vbcrlf &_
            " from detalle_asistencia_diaria a,asistencia_diaria b,bloques_horarios c " &vbcrlf &_
			" where cast(a.secc_ccod as varchar)='"&secc_ccod&"'" &vbcrlf &_
			" and a.adia_ncorr = b.adia_ncorr " &vbcrlf &_
			" and a.bloq_ccod = c.bloq_ccod " &vbcrlf &_
		    " order by b.fecha_ingreso, c.hora_ccod "

formulario_bloques.Consultar consulta2
total_registros = formulario_bloques.nroFilas
columnas = 3 + total_registros
%>
<html>
<head>
<title>Control asistencia asignatura</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="<%=columnas%>"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Control asistencia asignatura</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="<%=columnas+1%>">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Asignatura</strong></td>
    <td width="84%" colspan="<%=columnas%>"><strong>:</strong> <%=asignatura %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sección</strong></td>
    <td width="84%" colspan="<%=columnas%>"><strong>:</strong> <%=seccion %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Docente</strong></td>
    <td width="84%" colspan="<%=columnas%>"><strong>:</strong> <%=nombre_docente %></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="<%=columnas%>"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
  
</table>

<p>&nbsp;</p>
<table width="100%" border="1" bordercolor="#666666">
  <tr valign="bottom"> 
    <td align="center"><div align="left"><strong>N°</strong></div></td>
    <td align="center"><div align="center"><strong>R.U.T.</strong></div></td>
    <td align="center"><div align="center"><strong>ALUMNO</strong></div></td>
    <%while formulario_bloques.siguiente
	  fecha_asistencia = formulario_bloques.obtenerValor("fecha")
	%>
    <td align="left" width="10">
    	<div style="writing-mode:tb-rl;filter:flipH() flipV()">
       	 <%=fecha_asistencia%>
        </div>
    </td>
    <%wend
	  formulario_bloques.primero%>
      <td align="center"><div align="center"><strong>%</strong></div></td>
  </tr>
  <%  fila = 1
    while formulario.Siguiente 
	pers_ncorr = formulario.obtenerValor("pers_ncorr")
	total_asiste = conexion.consultaUno("select count(*) from detalle_asistencia_diaria where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and isnull(asiste,0)=1")
	porcentaje = formatnumber(cdbl((total_asiste * 100.00) / total_registros),2,-1,0,0)
	%>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("alumno")%></div></td>
    <%while formulario_bloques.siguiente
	  adia_ncorr = formulario_bloques.obtenerValor("adia_ncorr")
	  bloq_ccod = formulario_bloques.obtenerValor("bloq_ccod")
	  muestra = conexion.consultaUno("select case asiste when 0 then '<font color=red size=3>/</font>' else '<font color=blue size=3>.</font>' end from detalle_asistencia_diaria where cast(adia_ncorr as varchar)='"&adia_ncorr&"' and cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	%>
    <td align="center" width="10"><%=muestra%></td>
    <%wend
	  formulario_bloques.primero%>
    <td align="center"><%=porcentaje%></td>  
  </tr>
  <%fila = fila +1
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>