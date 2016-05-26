<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_cuota_prof_carrera_softlan.xls"
Response.ContentType = "application/vnd.ms-excel"
'Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
'carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
'response.Write("carrera :" & carr_ccod)
'response.End()
set pagina = new CPagina
'pagina.Titulo = "Reporte Planificacion General" 

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

periodo = conexion.consultaUno("select max(peri_ccod) from actividades_periodos where tape_ccod=6 and acpe_bvigente='S'")

sql_detalles_mate = "	select  rtrim(convert(char,g.pers_nrut))+'-'+g.pers_xdv as rut, " & vbcrlf & _
	" g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre, g.pers_nrut," & vbcrlf & _
    " g.pers_tape_paterno+' '+g.pers_tape_materno+' '+g.pers_tnombre as nombre_completo,d.TPRO_TDESC, " & vbcrlf & _
	" i.sede_tdesc,h.carr_tdesc,h.carr_tdesc+'('+j.jorn_tdesc+')' as carrera_jornada,j.jorn_tdesc,e.duas_ccod,bloq_anexo,hcor_valor1," & vbcrlf & _
	"  convert(numeric,round(max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0)),0)) as Total_Hcor, " & vbcrlf & _
	"  convert(numeric,round(sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)),0)) as Total_seccion, " & vbcrlf & _
	"  convert(numeric,round(max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0))+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)),0)) as Total_anexo, " & vbcrlf & _
	"  convert(numeric,convert(numeric,round(max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0))+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)),0))/(CASE e.DUAS_CCOD WHEN 1 THEN k.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN k.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN k.PROC_CUOTAS_ANUAL WHEN 4 THEN k.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(max(C.SECC_CCOD)) END)) as Total_cuota " & vbcrlf & _
	" from bloques_profesores a, bloques_horarios b,secciones c,tipos_profesores d,	asignaturas e, " & vbcrlf & _
	" duracion_asignatura f,personas g,carreras h,sedes i,jornadas j,procesos k ,horas_profesores Y " & vbcrlf & _
	" where a.bloq_ccod=b.bloq_ccod " & vbcrlf & _
	" and a.tpro_ccod=d.tpro_ccod " & vbcrlf & _
	" and a.proc_ccod=k.proc_ccod " & vbcrlf & _
	" and b.secc_ccod=c.secc_ccod " & vbcrlf & _
	" and c.asig_ccod=e.asig_ccod " & vbcrlf & _
    " and c.carr_ccod=h.carr_ccod " & vbcrlf & _
    " and c.sede_ccod=i.sede_ccod " & vbcrlf & _
    " and c.jorn_ccod=j.jorn_ccod  " & vbcrlf & _
	" and e.duas_ccod=f.duas_ccod " & vbcrlf & _
	" and a.bloq_anexo is not null " & vbcrlf & _
	" and a.pers_ncorr=g.pers_ncorr " & vbcrlf & _
	" and a.PERS_NCORR*=Y.pers_ncorr " & vbcrlf & _
    " and b.SECC_CCOD *=Y.secc_ccod " & vbcrlf & _
    " and Y.hopr_nhoras > 0 " & vbcrlf & _
	" and b.bloq_ccod=(select max(bb.bloq_ccod) from bloques_horarios bb,bloques_profesores cc  where bb.bloq_ccod=cc.bloq_ccod and c.secc_ccod=bb.secc_ccod and a.pers_ncorr=cc.pers_ncorr ) " & vbcrlf & _
	" group by g.pers_nrut,g.pers_xdv,g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre,d.TPRO_TDESC, " & vbcrlf & _
    "         i.sede_tdesc,h.carr_tdesc,j.jorn_tdesc,e.duas_ccod,bloq_anexo,hcor_valor1,k.PROC_CUOTAS_TRIMESTRAL,k.PROC_CUOTAS_SEMESTRAL,k.PROC_CUOTAS_ANUAL " & vbcrlf & _
    " order by g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre " 

	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()
set f_detalle_mat  = new cformulario
f_detalle_mat.carga_parametros "planificacion_gral_excel.xml", "f_detalle_serv" 
f_detalle_mat.inicializar conexion							
f_detalle_mat.consultar sql_detalles_mate

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
   <td><div align="center"><strong>Rut Sin Digito</strong></div></td>
  <td><div align="center"><strong>Rut</strong></div></td>
  <td><div align="center"><strong>Docente/Ayudante</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td><div align="center"><strong>Apellido Materno</strong></div></td>
	<td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Nombre Completo</strong></div></td>
    <td><div align="center"><strong>Sedes</strong></div></td>
    <td><div align="center"><strong>Carreras</strong></div></td>
    <td><div align="center"><strong>Jornadas</strong></div></td>
    <td><div align="center"><strong>Carrera Jornada</strong></div></td>
	<td><div align="center"><strong>Valor Cuota</strong></div></td>
  </tr>
  <%  while f_detalle_mat.Siguiente %>
  <tr> 
  <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_nrut")%></div></td>
   <td><div align="left"><%=f_detalle_mat.ObtenerValor("rut")%></div></td>
   <td><div align="left"><%=f_detalle_mat.ObtenerValor("TPRO_TDESC")%></div></td>
      <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tape_paterno")%></div></td>
	  <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tape_materno")%></div></td>
	  <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tnombre")%></div></td>
	  <td><div align="left"><%=f_detalle_mat.ObtenerValor("nombre_completo")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("jorn_tdesc")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("carrera_jornada")%></div></td>
	<td><div align="right"><%=f_detalle_mat.ObtenerValor("total_cuota")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>