<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=contratos_pendientes.xls"
Response.ContentType = "application/vnd.ms-excel"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_mes_ccod= request.Form("b[0][mes_ccod]")
'---------------------------------------------------------------------------------------------------
response.Write(q_mes_ccod)
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion




anio=conexion.ConsultaUno("select datepart(yyyy,getdate())")
anio2=anio-1
anio3=anio+1
'sql="select rut,pers_tape_paterno,pers_tape_materno,pers_tnombre,mote_tdesc,dcur_tdesc,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino"& vbCrLf &_
'"from (select distinct e.mote_ccod,cast(pers_nrut as varchar)+'-'+pers_xdv as  rut,pers_tape_paterno,pers_tape_materno,pers_tnombre,f.mote_tdesc,g.dcur_tdesc,"& vbCrLf &_
'"(select case when(select count(a.pers_ncorr)"& vbCrLf &_
'"from contratos_docentes_otec a,"& vbCrLf &_
'"anexos_otec b,"& vbCrLf &_
'"detalle_anexo_otec c"& vbCrLf &_
'"where a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
'"and b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
'"and a.pers_ncorr=h.pers_ncorr"& vbCrLf &_
'"and ecdo_ccod=1"& vbCrLf &_
'"and eane_ccod=1"& vbCrLf &_
'"and c.mote_ccod= e.mote_ccod) =0 then 'No' else 'Si' end) as tiene_contr,"& vbCrLf &_
'"dgso_finicio,"& vbCrLf &_
'"dgso_ftermino"& vbCrLf &_
'"from bloques_horarios_otec a,"& vbCrLf &_
'"bloques_relatores_otec b,"& vbCrLf &_
'"secciones_otec c,"& vbCrLf &_ 
'"datos_generales_secciones_otec d,"& vbCrLf &_
'"mallas_otec e," & vbCrLf &_
'"modulos_otec f,"& vbCrLf &_
'"diplomados_cursos g,"& vbCrLf &_
'"personas h"& vbCrLf &_
'"where a.bhot_ccod=b.bhot_ccod"& vbCrLf &_
'"--and b.pers_ncorr=123361"& vbCrLf &_
'"and a.seot_ncorr=c.seot_ncorr"& vbCrLf &_
'"and c.dgso_ncorr=d.dgso_ncorr"& vbCrLf &_
'"and c.maot_ncorr=e.maot_ncorr"& vbCrLf &_
'"and e.mote_ccod=f.mote_ccod"& vbCrLf &_
'"and e.dcur_ncorr=g.dcur_ncorr"& vbCrLf &_
'"and b.pers_ncorr=h.pers_ncorr"& vbCrLf &_
'"and datepart(yyyy,a.bhot_finicio)=datepart(yyyy,getdate()))aaaa"& vbCrLf &_
'"where tiene_contr='No'"& vbCrLf &_
'"order by pers_tape_paterno,pers_tape_materno"

sql= "select cast(pers_nrut as varchar)+'-'+pers_xdv as  rut,pers_tnombre,pers_tape_paterno,pers_tape_materno,g.DCUR_TDESC,i.mote_tdesc,protic.trunc(c.seot_finicio)as seot_finicio,protic.trunc(c.seot_ftermino) as seot_ftermino"& vbCrLf &_
"from bloques_relatores_otec a,"& vbCrLf &_
"bloques_horarios_otec b,"& vbCrLf &_
"secciones_otec c,"& vbCrLf &_
"datos_generales_secciones_otec d,"& vbCrLf &_
"diplomados_cursos e,"& vbCrLf &_
"personas f,"& vbCrLf &_
"diplomados_cursos g,"& vbCrLf &_
"mallas_otec h,"& vbCrLf &_
"modulos_otec i"& vbCrLf &_
"where a.bhot_ccod=b.bhot_ccod"& vbCrLf &_
"and b.seot_ncorr=c.seot_ncorr"& vbCrLf &_
"and c.dgso_ncorr=d.dgso_ncorr"& vbCrLf &_
"and d.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"and a.pers_ncorr=f.PERS_NCORR"& vbCrLf &_
"and d.dcur_ncorr=g.DCUR_NCORR"& vbCrLf &_
"and c.maot_ncorr=h.MAOT_NCORR"& vbCrLf &_
"and h.MOTE_CCOD=i.MOTE_CCOD"& vbCrLf &_
"--and datepart(year,d.dgso_ftermino)in ("&anio&","&anio3&")"& vbCrLf &_
"and datepart(year,d.dgso_finicio)in ("&anio2&","&anio&")"& vbCrLf &_
"and a.anot_ncorr is null"& vbCrLf &_
"group by pers_tnombre,pers_tape_paterno,pers_tape_materno,g.DCUR_TDESC,i.mote_tdesc,c.seot_finicio,c.seot_ftermino,pers_nrut,pers_xdv" 



'response.Write("<pre>"&sql&"</pre>")
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
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">

 
  <tr>
   
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	<td width="22%"><div align="up"><strong>Apellido Paterno</strong></div></td>
	<td width="22%"><div align="up"><strong>Apellido Materno</strong></div></td>
	<td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="38%"><div align="center"><strong>Módulo</strong></div></td>
    <td width="29%"><div align="center"><strong>Diplomado/Curso </strong></div></td>
	<td width="29%"><div align="center"><strong>Fecha Inicio </strong></div></td>
	<td width="29%"><div align="center"><strong>Fecha Termino </strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("mote_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("dcur_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("seot_finicio")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("seot_ftermino")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>