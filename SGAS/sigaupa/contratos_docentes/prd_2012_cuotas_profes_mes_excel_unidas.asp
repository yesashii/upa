<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_softland_mes_fusion.xls"
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

conexion.inicializar "upacifico"
negocio.inicializa conexion


sql_cuotas_profes=	" Select codigo,rut,pers_tnombre,pers_tape_paterno,pers_tape_materno,tipo_profesor,sum(valor) as monto_mensual from ( " & vbcrlf & _
					" select d.pers_nrut as codigo,protic.obtener_rut(a.pers_ncorr) as rut,pers_tnombre,pers_tape_paterno,pers_tape_materno, " & vbcrlf & _
					" cast((((c.dane_nsesiones/2)+b.anex_nhoras_coordina)*c.dane_msesion)/b.anex_ncuotas as numeric) as valor, o.tpro_tdesc as tipo_profesor " & vbcrlf & _
					"	  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  " & vbcrlf & _
					"			     asignaturas j, secciones n,tipos_profesores o,profesores p   " & vbcrlf & _
					"			  Where a.cdoc_ncorr    =   b.cdoc_ncorr  " & vbcrlf & _
					"			     and b.anex_ncorr    =   c.anex_ncorr  " & vbcrlf & _
					"			     and a.pers_ncorr    =   d.pers_ncorr  " & vbcrlf & _
					"			     and b.sede_ccod     =   e.sede_ccod  " & vbcrlf & _
					"			     and c.asig_ccod     =   j.asig_ccod  " & vbcrlf & _
					"			     and n.secc_ccod     =   c.secc_ccod  " & vbcrlf & _
					"			     and o.TPRO_CCOD     =   p.TPRO_CCOD  " & vbcrlf & _
					"			     and p.pers_ncorr    =   d.pers_ncorr  " & vbcrlf & _
					"			     AND b.SEDE_CCOD     =   p.sede_ccod " & vbcrlf & _
					"                and a.ecdo_ccod     <>   3 " & vbcrlf & _
					"                 and convert(datetime,getdate(),103) between  convert(datetime,b.anex_finicio,103) and convert(datetime,b.anex_ffin,103) " & vbcrlf & _
					"               ) z " & vbcrlf & _
					"  Group by codigo,rut,pers_tnombre,pers_tape_paterno,pers_tape_materno,tipo_profesor "              
               

sql_cuotas_profes="	select codigo,rut,pers_tape_paterno,pers_tape_materno,pers_tnombre, tipo_profesor , sum(monto_mensual)  as monto_mensual " & vbcrlf & _
" from (" & vbcrlf & _
" select b.pers_nrut as codigo,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_tape_paterno,b.pers_tape_materno,b.pers_tnombre, sum(valor_mensual) as monto_mensual,ss.tipo_profesor " & vbcrlf & _
" from ( " & vbcrlf & _
"    select pers_ncorr,cast(((sum(sesiones)+b.anex_nhoras_coordina)*monto_cuota) /b.anex_ncuotas as numeric) as valor_mensual,tipo_profesor " & vbcrlf & _
"    from ( " & vbcrlf & _
"        select a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor " & vbcrlf & _
"	          From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  " & vbcrlf & _
"			             asignaturas j, secciones n,tipos_profesores o,profesores p    " & vbcrlf & _
"			          Where a.cdoc_ncorr     =   b.cdoc_ncorr   " & vbcrlf & _
"			             and b.anex_ncorr    =   c.anex_ncorr   " & vbcrlf & _
"			             and a.pers_ncorr    =   d.pers_ncorr   " & vbcrlf & _
"			             and b.sede_ccod     =   e.sede_ccod   " & vbcrlf & _
"			             and c.asig_ccod     =   j.asig_ccod   " & vbcrlf & _
"			             and n.secc_ccod     =   c.secc_ccod   " & vbcrlf & _
"			             and o.TPRO_CCOD     =   p.TPRO_CCOD   " & vbcrlf & _
"			             and p.pers_ncorr    =   d.pers_ncorr   " & vbcrlf & _
"			             AND b.SEDE_CCOD     =   p.sede_ccod " & vbcrlf & _
"                         and a.ecdo_ccod     <>   3 " & vbcrlf & _
"                         and b.eane_ccod     <> 3 " & vbcrlf & _
"                         and convert(datetime,getdate(),103) between  convert(datetime,b.anex_finicio,103) and convert(datetime,b.anex_ffin,103) " & vbcrlf & _
"        group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc " & vbcrlf & _
"    ) as aa, " & vbcrlf & _
"   anexos b " & vbcrlf & _
"    where aa.anex_ncorr=b.anex_ncorr  " & vbcrlf & _
"    group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor  " & vbcrlf & _
" ) ss ,personas b " & vbcrlf & _
" where ss.pers_ncorr=cast(b.pers_ncorr as varchar) " & vbcrlf & _
" group by  b.pers_nrut,b.pers_ncorr,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor " & vbcrlf & _
" union all " & vbcrlf & _
" select  a.ficha as codigo,a.rut as rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre,sum(cast(a.total_cuota as integer)) as monto_mensual,a.tipo_profe from (    " & vbcrlf & _ 
"  select  max(d.tpro_tdesc) as tipo_profe,a.pers_ncorr,g.pers_nrut as ficha,pers_xdv,rtrim(convert(char,g.pers_nrut))+'-'+g.pers_xdv as rut,     " & vbcrlf & _
"   g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre,     " & vbcrlf & _
"   c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1,     " & vbcrlf & _
"  (max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0))+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)))/(CASE e.DUAS_CCOD WHEN 1 THEN h.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN h.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN h.PROC_CUOTAS_ANUAL WHEN 4 THEN h.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(max(C.SECC_CCOD)) END) as Total_cuota     " & vbcrlf & _
"	,case F.DUAS_CCOD WHEN 5 then protic.trunc(c.SECC_FINICIO_SEC) else protic.trunc(h.PROC_FINICIO) end AS FECHA_INICIO     " & vbcrlf & _
"    ,protic.trunc(CASE F.DUAS_CCOD WHEN 1 THEN h.PROC_FFIN_TRIMESTRAL WHEN 2 THEN h.PROC_FFIN_SEMESTRAL WHEN 3 THEN h.PROC_FFIN_ANUAL WHEN 4 THEN h.PROC_FFIN_ANUAL WHEN 5 THEN c.SECC_FTERMINO_SEC END) AS FECHA_FIN     " & vbcrlf & _
"  from bloques_profesores a, bloques_horarios b,secciones c,tipos_profesores d,     " & vbcrlf & _
"  asignaturas e,duracion_asignatura f,personas g,procesos h ,horas_profesores Y     " & vbcrlf & _
"  where a.bloq_ccod=b.bloq_ccod     " & vbcrlf & _
"  and a.tpro_ccod=d.tpro_ccod     " & vbcrlf & _
"  and a.proc_ccod=h.proc_ccod     " & vbcrlf & _
"  and b.secc_ccod=c.secc_ccod     " & vbcrlf & _
"  and c.asig_ccod=e.asig_ccod     " & vbcrlf & _
"  and e.duas_ccod=f.duas_ccod     " & vbcrlf & _
"  and a.bloq_anexo is not null     " & vbcrlf & _
"  and a.pers_ncorr=g.pers_ncorr     " & vbcrlf & _
"  and a.PERS_NCORR*=Y.pers_ncorr     " & vbcrlf & _
"  and b.SECC_CCOD *=Y.secc_ccod     " & vbcrlf & _
"  and isnull(a.eblo_ccod,0)<>3      " & vbcrlf & _
"  and Y.hopr_nhoras > 0     " & vbcrlf & _
"  and b.bloq_ccod=(select max(bb.bloq_ccod) from bloques_horarios bb,bloques_profesores cc  where bb.bloq_ccod=cc.bloq_ccod and c.secc_ccod=bb.secc_ccod and a.pers_ncorr=cc.pers_ncorr )     " & vbcrlf & _
"	  group by a.pers_ncorr,g.pers_nrut,g.pers_xdv,g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1,h.PROC_CUOTAS_TRIMESTRAL,h.PROC_CUOTAS_SEMESTRAL,h.PROC_CUOTAS_ANUAL,c.SECC_FINICIO_SEC,F.DUAS_CCOD,h.PROC_FINICIO,h.PROC_FFIN_ANUAL,h.PROC_FFIN_TRIMESTRAL,c.SECC_FTERMINO_SEC,h.PROC_FFIN_SEMESTRAL     " & vbcrlf & _
" ) as a     " & vbcrlf & _
"       where  datepart(month,convert(datetime,getdate(),103)) between  datepart(month,convert(datetime,a.fecha_inicio,103)) and datepart(month,convert(datetime,a.fecha_fin,103))    " & vbcrlf & _
" group by a.tipo_profe,a.ficha,a.rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre     " & vbcrlf & _
" ) as tabla " & vbcrlf & _
" group by codigo,rut,pers_tape_paterno,pers_tape_materno,pers_tnombre, tipo_profesor  "



set f_valor_mes  = new cformulario
f_valor_mes.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_mes.inicializar conexion							
f_valor_mes.consultar sql_cuotas_profes

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Ficha</strong></div></td>
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
    <td><div align="center"><strong>Apellido Materno</strong></div></td>
    <td><div align="center"><strong>Nombres</strong></div></td>
	<td><div align="center"><strong>Valor Cuota</strong></div></td>
	<td><div align="center"><strong>Tipo Profesor</strong></div></td>
  </tr>
  <%  while f_valor_mes.Siguiente %>
  <tr> 
      <td><div align="left"><%=f_valor_mes.ObtenerValor("codigo")%></div></td>
    <td><div align="left"><%=f_valor_mes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_mes.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_valor_mes.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_valor_mes.ObtenerValor("pers_tnombre")%></div></td>
	<td><div align="right"><%=f_valor_mes.ObtenerValor("monto_mensual")%></div></td>
	<td><div align="right"><%=f_valor_mes.ObtenerValor("tipo_profesor")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>