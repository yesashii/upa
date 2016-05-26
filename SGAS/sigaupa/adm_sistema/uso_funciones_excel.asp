<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 50000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_uso_usuarios.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_sfun_ccod = Request.QueryString("sfun_ccod")
q_fecha_ini= Request.QueryString("fecha_ini")
q_fecha_fin= Request.QueryString("fecha_fin")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



consulta_er = "select smod_tdesc, sfun_tdesc from sis_funciones_modulos fm,sis_modulos sm  where fm.smod_ccod not in (select smod_ccod from log_funciones)and fm.smod_ccod=sm.smod_ccod"
	
set fv_valor_documentos  = new cformulario 
fv_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla_vacia" 
fv_valor_documentos.inicializar conexion							
fv_valor_documentos.consultar consulta_er	

'response.Write("askhdkjashd"&fv_valor_documentos.nrofilas)


'response.Write("<pre>"&consulta_er&"</pre>")
if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and lf.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_sfun_ccod <> "" then
	

  	filtro2=filtro2&"and lf.sfun_ccod='" &q_sfun_ccod&"'"
  					
end if
		
  if q_fecha_ini <> ""  and q_fecha_fin <> "" then
	

  	filtro3=filtro3&"and convert(datetime,fecha_log,103)  between convert(datetime,'" &q_fecha_ini&"',103) and  convert(datetime,'" &q_fecha_fin&"',103)"
  					
end if

sql_funciones= "select pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,smod_tdesc,sfun_tdesc,convert(datetime,fecha_log,103)as fecha_log"& vbCrLf &_ 
				"from log_funciones lf,sis_modulos sm,sis_funciones_modulos sf,personas p"& vbCrLf &_
  				"where lf.smod_ccod=sm.smod_ccod"& vbCrLf &_
  				"and lf.sfun_ccod=sf.sfun_ccod"& vbCrLf &_
 				"and lf.pers_ncorr=p.pers_ncorr"& vbCrLf &_
 				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
 				"order by fecha_log desc"


	
'response.Write("<pre>"&sql_funciones&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_funciones

'-------------------------------------------------------------------------------

		
 

sql_funciones2= "select  smod_tdesc,sfun_tdesc,count(lf.sfun_ccod) as total"& vbCrLf &_
				"from log_funciones lf,sis_modulos sm,sis_funciones_modulos sf,personas p"& vbCrLf &_
				"where lf.smod_ccod=sm.smod_ccod"& vbCrLf &_
				"and lf.sfun_ccod=sf.sfun_ccod"& vbCrLf &_
				"and lf.pers_ncorr=p.pers_ncorr"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				"group by sfun_tdesc,smod_tdesc"


	
'response.Write("<pre>"&sql_funciones2&"</pre>")
'response.End()
set f_valor_documentos2  = new cformulario
f_valor_documentos2.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos2.inicializar conexion							
f_valor_documentos2.consultar sql_funciones2



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
<td VALIGN="top">

<table width="100%" border="2">
  <tr>    
   <td><div align="up"><strong>Nombre</strong></div></td>
  <td><div align="center"><strong>Modulo</strong></div></td>
    <td><div align="center"><strong>Funcion</strong></div></td>
	<td><div align="center"><strong>hora y fecha</strong></div></td>
		
  </tr>
 <%  while f_valor_documentos.Siguiente %> 
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("smod_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sfun_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("fecha_log")%></div></td>

  </tr>
 <%  wend %>
</table>

</td>

<td VALIGN="top">
<table width="100%" border="2">
 
  <tr>    
   <td><div align="center"><strong>Modulo no utilizados</strong></div></td>
    
	<td><div align="center"><strong>Funcion no utilizadas</strong></div></td>
	
  </tr>
  <%  while fv_valor_documentos.Siguiente %>
  <tr> 
      <td><div align="left"><%=fv_valor_documentos.ObtenerValor("smod_tdesc")%></div></td>
	<td><div align="left"><%=fv_valor_documentos.ObtenerValor("sfun_tdesc")%></div></td>
	
  </tr>
 <%  wend %>
</table>

</td>

<td VALIGN="top">
<table width="100%" border="2">
 
  <tr>    
   <td><div align="center"><strong>Modulo </strong></div></td>
    
	<td><div align="center"><strong>Funcion</strong></div></td>
	<td><div align="center"><strong>N° Veces Utilizado</strong></div></td>
	
  </tr>
  <%  while f_valor_documentos2.Siguiente %>
  <tr> 
      <td><div align="left"><%=f_valor_documentos2.ObtenerValor("smod_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos2.ObtenerValor("sfun_tdesc")%></div></td>
	 <td><div align="left"><%=f_valor_documentos2.ObtenerValor("total")%></div></td>
  </tr>
 <%  wend %>
</table>

</td>
</table>

</html>