<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=pagos_por_programa.xls"
Response.ContentType = "application/vnd.ms-excel"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
z_dcur_ncorr= request.QueryString("dcur_ncorr")
q_dcur_ncorr= request.QueryString("b[0][dcur_ncorr]")
'---------------------------------------------------------------------------------------------------
response.Write("<br>"&q_mes_ccod)
response.Write("<br>"&z_dcur_ncorr)

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion




anio=conexion.ConsultaUno("select datepart(yyyy,getdate())")

if z_dcur_ncorr <>"0" then
filtro=filtro&"and e.dcur_ncorr="&z_dcur_ncorr&""
end if

sql="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre ,dcur_tdesc,ccos_tcompuesto,protic.trunc(dgso_finicio)+' al '+protic.trunc(dgso_ftermino)as duracion,"& vbCrLf &_
"(daot_nhora*daot_mhora)total_pagar,"& vbCrLf &_
"cast(round(((daot_nhora*daot_mhora)/anot_ncuotas),0)as numeric (18,0))valor_cuota,"& vbCrLf &_
"anot_ncuotas,"& vbCrLf &_
"'desde '+protic.trunc(anot_finicio)+' al '+protic.trunc(anot_ffin)as fechas_cuotas"& vbCrLf &_
"from contratos_docentes_otec a,"& vbCrLf &_
"anexos_otec b,"& vbCrLf &_
"detalle_anexo_otec c,"& vbCrLf &_
"personas d,"& vbCrLf &_
"mallas_otec e,"& vbCrLf &_
"centros_costos_asignados f,"& vbCrLf &_
"centros_costo g,"& vbCrLf &_
"diplomados_cursos h,"& vbCrLf &_
"tipos_contratos_docentes i,"& vbCrLf &_
"datos_generales_secciones_otec j"& vbCrLf &_
"where a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
"and b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
"and a.pers_ncorr=d.pers_ncorr"& vbCrLf &_
"and ecdo_ccod=1"& vbCrLf &_
"and eane_ccod=1"& vbCrLf &_
"and c.mote_ccod=e.mote_ccod"& vbCrLf &_
"and f.ccos_ccod=g.ccos_ccod"& vbCrLf &_
"and f.tdet_ccod=h.tdet_ccod"& vbCrLf &_
"and h.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"and a.tcdo_ccod=i.tcdo_ccod"& vbCrLf &_
"and e.dcur_ncorr=j.dcur_ncorr"& vbCrLf &_
""&filtro&""& vbCrLf &_
"and datepart(yyyy,cdot_finicio)in( datepart(yyyy,getdate()),datepart(yyyy,getdate())-1)"& vbCrLf &_
"--and convert(datetime,protic.trunc(getdate()),103)between convert(datetime,protic.trunc(anot_finicio),103) and convert(datetime,protic.trunc(anot_ffin),103)"& vbCrLf &_
"order by pers_tape_paterno,pers_tape_materno"

'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql

'-------------------------------------------------------------------------------



'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title></head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">

 
  <tr>
  	<td width="11%"><div align="center"><strong>Rut</strong></div></td>
   	<td width="11%"><div align="center"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Programa</strong></div></td>
	<td width="22%"><strong>Centro Costo </strong></td>
	<td width="22%"><div align="up"><strong>Duraci&oacute;n Programa </strong></div></td>
	<td width="22%"><div align="up"><strong>Total a Pagar </strong></div></td>
    <td width="38%"><div align="center"><strong>Valor Cuota </strong></div></td>
    <td width="29%"><div align="center"><strong>N° Cuotas</strong></div></td>
	 <td width="29%"><div align="center"><strong>Fechas Cuotas</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
  	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("dcur_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ccos_tcompuesto")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("duracion")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("total_pagar")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("valor_cuota")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("anot_ncuotas")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("fechas_cuotas")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>