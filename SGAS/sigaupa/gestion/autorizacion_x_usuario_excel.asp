<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_descuentos_x_usuario.xls"
Response.ContentType = "application/vnd.ms-excel"
q_pers_nrut=request.QueryString("pers_nrut")
q_pers_xdv=request.QueryString("pers_xdv")
q_peri_ccod = Request.QueryString("peri_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_pers_nrut <> "" and q_pers_xdv <> "" then
	filtro1=filtro1&"join personas pb" & vbCrLf &_
                    "on CAST(pb.pers_nrut AS VARCHAR)='"&q_pers_nrut&"' "& vbCrLf &_
					"and CAST(pb.pers_xdv AS VARCHAR)='"&q_pers_xdv&"' "& vbCrLf &_
                    "and c.pers_ncorr=pb.pers_ncorr"
end if


if q_peri_ccod <> "" then
	filtro2 =filtro2&" join contratos con " & vbCrLf &_
	                 "on cast(con.peri_ccod as varchar)='"&q_peri_ccod&"' "& vbCrLf &_
					 "and c.post_ncorr=con.post_ncorr"
	                
end if



	sql_descuentos=   " select a.audi_tusuario as autor,p.pers_tnombre+' ' +p.pers_tape_paterno as nombre," & vbCrLf &_
                      "isnull(a.sdes_nporc_matricula,0) as sdes_nporc_matricula, "& vbCrLf &_
			    "isnull(a.sdes_nporc_colegiatura,0) as sdes_nporc_colegiatura, a.esde_ccod, "& vbCrLf &_
			    "b.stde_tdesc as tipo_desc, cast(isnull(a.sdes_mmatricula,0) as numeric) as sdes_mmatricula, "& vbCrLf &_
			    "cast(isnull(a.sdes_mcolegiatura,0) as numeric) as sdes_mcolegiatura, "& vbCrLf &_
			    "isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as subtotal, a.audi_fmodificacion as fmodificacion"& vbCrLf &_
			    "from stipos_descuentos b"& vbCrLf &_
                    "join sdescuentos a"& vbCrLf &_
                   "on a.stde_ccod = b.stde_ccod"  & vbCrLf &_                  
                    "join postulantes c"& vbCrLf &_
                    "on a.ofer_ncorr = c.ofer_ncorr"& vbCrLf &_
                    "and a.post_ncorr = c.post_ncorr"& vbCrLf &_
					" " &filtro2&" "& vbCrLf &_
					" " &filtro1&" "& vbCrLf &_
                    "left outer join personas p"& vbCrLf &_
			        "on a.audi_tusuario=cast(p.pers_nrut as varchar)"

	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

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
   <td><div align="center"><strong>Autor</strong></div></td>
  <td><div align="center"><strong>Autorizado por</strong></div></td>
    <td><div align="center"><strong>Tipo Descuento</strong></div></td>
	<td><div align="center"><strong>% Descuetno Matricula</strong></div></td>
	<td><div align="center"><strong>Monto Descuento Matricula</strong></div></td>
	<td><div align="center"><strong>% Descuento Colegiatura</strong></div></td>
    <td><div align="center"><strong>Monto Descuento Colegiatura</strong></div></td>
    <td><div align="center"><strong>Subtotal</strong></div></td>
    <td><div align="center"><strong>Fecha y Hora</strong></div></td>
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("autor")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_desc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sdes_nporc_matricula")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("sdes_mmatricula")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("sdes_nporc_colegiatura")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("sdes_mcolegiatura")%></div></td>
   <td><div align="left"><%=f_valor_documentos.ObtenerValor("subtotal")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("fmodificacion")%></div></td>
	
    
  </tr>
  <%  wend %>
</table>
</body>
</html>