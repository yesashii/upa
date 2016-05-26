<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_softland_mes.xls"
Response.ContentType = "application/vnd.ms-excel"

'---------------------------------------------------------------------------------------------------

v_mes=request.form("test[0][mes_ccod]")
'response.Write("<b> Mes: "&v_mes&"</b>")
'response.End()
if v_mes="" then
	v_mes= 	Month(now())
end if
set pagina = new CPagina


set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

Periodo = negocio.ObtenerPeriodoAcademico("planificacion")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&Periodo&"'")

sql_cuotas_profes=	"	select jerarquia,tipo_contrato,b.pers_nrut as codigo,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor, sum(valor_mensual) as monto_mensual " & vbcrlf & _
					" from (" & vbcrlf & _
					"    select jerarquia,pers_ncorr,cast(((sum(sesiones)+b.anex_nhoras_coordina)*monto_cuota) /b.anex_ncuotas as numeric) as valor_mensual,tipo_profesor,tipo_contrato " & vbcrlf & _
					"    from ( " & vbcrlf & _
					"        select r.jdoc_tdesc as jerarquia,tcdo_tdesc as tipo_contrato,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor " & vbcrlf & _
					"	          From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbcrlf & _
					"			             asignaturas j, secciones n,tipos_profesores o,profesores p, tipos_contratos_docentes q ,jerarquias_docentes r  " & vbcrlf & _
					"			          Where a.cdoc_ncorr     =   b.cdoc_ncorr  " & vbcrlf & _
					"			             and b.anex_ncorr    =   c.anex_ncorr  " & vbcrlf & _
					"			             and a.pers_ncorr    =   d.pers_ncorr  " & vbcrlf & _
					"			             and b.sede_ccod     =   e.sede_ccod  " & vbcrlf & _
					"			             and c.asig_ccod     =   j.asig_ccod  " & vbcrlf & _
					"			             and n.secc_ccod     =   c.secc_ccod  " & vbcrlf & _
					"			             and o.TPRO_CCOD     =   p.TPRO_CCOD  " & vbcrlf & _
					"			             and p.pers_ncorr    =   d.pers_ncorr  " & vbcrlf & _
					"			             AND b.SEDE_CCOD     =   p.sede_ccod " & vbcrlf & _
					"			             and a.tcdo_ccod     =   q.tcdo_ccod " & vbcrlf & _
					"                        and a.ecdo_ccod     <>   3 " & vbcrlf & _
					"                        and b.eane_ccod     <> 3 " & vbcrlf & _
					"						 and p.jdoc_ccod=r.jdoc_ccod " & vbcrlf & _
					"                        and datepart(year,b.anex_finicio)='"&anos_ccod&"' " & vbcrlf & _
					" 						 and a.ano_contrato='"&anos_ccod&"' " & vbcrlf & _
					"                        and convert(datetime,'28/"&v_mes&"/'+cast(datepart(year,getdate()) as varchar),103) between  convert(datetime,b.anex_finicio,103) and convert(datetime,b.anex_ffin,103) " & vbcrlf & _
					" --and '"&v_mes&"' between  datepart(month,b.anex_finicio) and datepart(month,b.anex_ffin) " & vbcrlf & _
					"        group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc,tcdo_tdesc,r.jdoc_tdesc " & vbcrlf & _
					"    ) as aa, " & vbcrlf & _
					"    anexos b" & vbcrlf & _
					"    where aa.anex_ncorr=b.anex_ncorr " & vbcrlf & _
					"    group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor,tipo_contrato,jerarquia " & vbcrlf & _
					") ss ,personas b " & vbcrlf & _
					" where ss.pers_ncorr=cast(b.pers_ncorr as varchar) " & vbcrlf & _
					" group by  b.pers_nrut,b.pers_ncorr,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor,tipo_contrato,jerarquia "

'response.Write("<pre>"&sql_cuotas_profes&"</pre>")
'response.End()
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
	<td><div align="center"><strong>Tipo Contrato</strong></div></td>
	<td><div align="center"><strong>Jerarquia</strong></div></td>		
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
	<td><div align="right"><%=f_valor_mes.ObtenerValor("tipo_contrato")%></div></td>
	<td><div align="right"><%=f_valor_mes.ObtenerValor("jerarquia")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>