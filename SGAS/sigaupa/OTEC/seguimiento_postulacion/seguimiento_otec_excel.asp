<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=seguimiento_matricula_excel.xls"
Response.ContentType = "application/vnd.ms-excel"

pers_nrut =Request.QueryString("pers_nrut")
'q_pers_xdv = Request.QueryString("pers_xdv")
'q_tdet_ccod =Request.QueryString("tdet_ccod")
'q_sede_ccod= request.QueryString("sede_ccod")
'q_anos_ccod= request.QueryString("anos_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

usu=negocio.ObtenerUsuario()
	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion	


if pers_nrut<>"" then
filtro=filtro&"and a.pers_ncorr=protic.Obtener_pers_ncorr("&pers_nrut&")"
end if


sql_descuentos= "select a.PERS_NCORR,cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv," & vbCrlf & _ 
 "pers_tnombre +' '+ pers_tape_paterno + ' ' + pers_tape_materno as alumno, " & vbCrlf & _
 "protic.trunc((select min(fecha_postulacion) from postulacion_otec zz, ofertas_otec yy where zz.dgso_ncorr=yy.dgso_ncorr and zz.pers_ncorr=a.PERS_NCORR and yy.anio_admision=datepart(yyyy,getdate())))as fecha_ingreso," & vbCrlf & _
 "(select count( distinct aa.dgso_ncorr) from postulacion_otec aa,ofertas_otec bb,ofertas_otec cc,responsable_unidad dd,responsable_programa ee  where aa.dgso_ncorr=bb.dgso_ncorr and bb.anio_admision=datepart(yyyy,getdate()) and aa.pers_ncorr=a.pers_ncorr and aa.epot_ccod<>5 and aa.dgso_ncorr=bb.dgso_ncorr and dd.udpo_ccod=bb.udpo_ccod and dd.reun_ncorr=ee.reun_ncorr and aa.dgso_ncorr=ee.dgso_ncorr and dd.pers_ncorr=protic.obtener_pers_ncorr("&usu&"))as n_programas," & vbCrlf & _
"(select case when count(*)> 0 then 'Si' else 'No' end  from observaciones_postulacion_otec aa, ofertas_otec bb,responsable_unidad cc,responsable_programa dd where aa.dgso_ncorr=bb.dgso_ncorr and bb.udpo_ccod=cc.udpo_ccod and cc.reun_ncorr=dd.reun_ncorr and dd.dgso_ncorr=aa.dgso_ncorr and cc.pers_ncorr=protic.Obtener_pers_ncorr("&usu&") and aa.pote_ncorr=b.pote_ncorr)as gestionado,"& vbCrlf & _
"(select protic.trunc(max(aa.audi_fmodificacion))  from observaciones_postulacion_otec aa, ofertas_otec bb,responsable_unidad cc,responsable_programa dd where aa.dgso_ncorr=bb.dgso_ncorr and bb.udpo_ccod=cc.udpo_ccod and cc.reun_ncorr=dd.reun_ncorr and dd.dgso_ncorr=aa.dgso_ncorr and cc.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")and aa.pote_ncorr=b.pote_ncorr)as ultima_gestion"& vbCrlf & _
 "from personas a, " & vbCrlf & _
 "postulacion_otec b," & vbCrlf & _
 "estados_postulacion_otec c," & vbCrlf & _
 "ofertas_otec d," & vbCrlf & _
 "responsable_unidad e," & vbCrlf & _
 "responsable_programa f" & vbCrlf & _
 "where a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
 "and b.epot_ccod=c.epot_ccod " & vbCrlf & _
 "and b.dgso_ncorr=d.dgso_ncorr" & vbCrlf & _
 "and d.udpo_ccod=e.udpo_ccod" & vbCrlf & _
 "and e.reun_ncorr=f.reun_ncorr" & vbCrlf & _
 "and b.dgso_ncorr=f.dgso_ncorr" & vbCrlf & _
 "and e.esre_ccod=1" & vbCrlf & _
 "and b.epot_ccod<>5" & vbCrlf & _
 ""&filtro&""& vbCrlf & _
 "and e.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")" & vbCrlf & _
 "group by a.pers_nrut,a.pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,a.PERS_NCORR,b.pote_ncorr"& vbCrlf & _
 "order by fecha_ingreso asc"

						
f_valor_documentos.consultar sql_descuentos

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
  <td width="22%"><div align="up"><strong>Nombre Postulante</strong></div></td>
  <td width="38%"><div align="center"><strong>N° de Programas Postulados</strong></div></td>
  <td width="29%"><div align="center"><strong>Gestionado</strong></div></td>
  <td width="29%"><div align="center"><strong>Última Gestión</strong></div></td>
 
		
  </tr>
 <%  while f_valor_documentos.Siguiente %> 
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("alumno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("n_programas")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("gestionado")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ultima_gestion")%></div></td>
  </tr>
 <%  wend %>
</table>






</html>