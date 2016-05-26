<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_deposito.xls"
Response.ContentType = "application/vnd.ms-excel"
 deposito 			= request.querystring("envi_ncorr")
 fecha				= request.querystring("envi_fenvio")
 cuenta_corriente 	= request.querystring("ccte_tdesc")
 eenv_ccod 			= request.querystring("eenv_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

  
consulta = "select a.ENVI_MEFECTIVO,a.tdep_ccod,a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, a.envi_ncorr as c2_envi_ncorr,"& vbCrLf &_
			"        b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc, a.envi_tdescripcion, "& vbCrLf &_
			"        protic.cantidad_documentos_envio(a.envi_ncorr) as cant_doc, a.eenv_ccod, "& vbCrLf &_
			"        case a.tdep_ccod when 3 then a.ENVI_MEFECTIVO else protic.total_valor_envio(a.envi_ncorr) end as total "& vbCrLf &_
			"			    From envios a "& vbCrLf &_
			"    join instituciones_envio b "& vbCrLf &_
			"        on a.inen_ccod = b.inen_ccod "& vbCrLf &_
			"    join cuentas_corrientes c "& vbCrLf &_
			"        on a.CCTE_CCOD = c.ccte_ccod "& vbCrLf &_
			"    join estados_envio d "& vbCrLf &_
			"        on a.eenv_ccod = d.eenv_ccod "& vbCrLf &_
			"    left outer join detalle_envios f "& vbCrLf &_
			"        on a.envi_ncorr = f.envi_ncorr "& vbCrLf &_
			"    left outer join detalle_ingresos g "& vbCrLf &_
			"        on f.ting_ccod = g.ting_ccod "& vbCrLf &_
			"        and f.ding_ndocto = g.ding_ndocto "& vbCrLf &_   
			"        and f.ingr_ncorr = g.ingr_ncorr "& vbCrLf &_
			"    left outer join ingresos h "& vbCrLf &_
			"        on g.ingr_ncorr = h.ingr_ncorr "& vbCrLf &_
			"    left outer join personas i "& vbCrLf &_
			"        on h.pers_ncorr = i.pers_ncorr "& vbCrLf &_
			"    left outer join personas j "& vbCrLf &_
			"        on g.PERS_NCORR_CODEUDOR = j.pers_ncorr "& vbCrLf &_
			"   Where a.tenv_ccod = 2 "& vbCrLf &_
			"    "&comentario&" and a.audi_tusuario like '%"&v_usuario&"%' "& vbCrLf &_
			"    and b.TINE_CCOD = 1"
			

				 if  deposito <> ""  then 
				    consulta = consulta & "and a.envi_ncorr = '" & deposito & "' "
				  end if
				  
		  	    if fecha  <> "" then 
				  	consulta = consulta & "and convert(datetime,a.envi_fenvio,103)  ='" & fecha & "' "
				  end if
				
				 if cuenta_corriente  <> "" then 
				  	consulta = consulta & "and c.ccte_tdesc  ='" & cuenta_corriente & "' "
				  end if
				  
				  if eenv_ccod  <> "" then 
				  	consulta = consulta & "and a.eenv_ccod  ='" & eenv_ccod & "' "
				  end if
								
			 	consulta = consulta & "group by a.envi_ncorr,  b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc ,a.ENVI_MEFECTIVO,a.tdep_ccod, a.envi_tdescripcion, a.eenv_ccod"& vbCrLf &_
				"order by a.envi_ncorr DESC "
	
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar consulta

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
  <td><div align="center"><strong>Deposito</strong></div></td>
  <td><div align="center"><strong>Estado</strong></div></td>
    <td><div align="center"><strong>Tipo Deposito</strong></div></td>
	<td><div align="center"><strong>Banco</strong></div></td>
	<td><div align="center"><strong>Cuenta Corriente</strong></div></td>
    <td><div align="center"><strong>Fecha</strong></div></td>
    <td><div align="center"><strong>Documentos</strong></div></td>
    <td><div align="center"><strong>Total</strong></div></td>
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("c_envi_ncorr")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("envi_tdescripcion")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("tdep_ccod")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("inen_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ccte_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("envi_fenvio")%></div></td>
   <td><div align="left"><%=f_valor_documentos.ObtenerValor("cant_doc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("Total")%></div></td>
	
    
  </tr>
  <%  wend %>
</table>
</body>
</html>