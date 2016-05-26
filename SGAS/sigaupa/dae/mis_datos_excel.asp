<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_peri_ccod= request.QueryString("peri_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



set f_mis_datos = new CFormulario
f_mis_datos.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_mis_datos.Inicializar conexion


 
 if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
   filtro1=filtro1&"and pers_nrut="&q_pers_nrut&""
 
                    
end if
 
 if q_sede_ccod <> "" then
	

  	filtro2=filtro2&"and c.sede_ccod="&q_sede_ccod&""
  					
end if
 

 
 
 
if q_peri_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos="select a.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"&q_peri_ccod&"as peri_ccod,"& vbCrLf &_
				"upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre)as nombre"& vbCrLf &_
				"from personas a, "& vbCrLf &_
				"alumnos b,"& vbCrLf &_
				"ofertas_academicas c,"& vbCrLf &_
				"especialidades d,"& vbCrLf &_
				"mis_datos g"& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
				"and c.espe_ccod=d.espe_ccod"& vbCrLf &_
				"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
				"and peri_ccod="&q_peri_ccod&""& vbCrLf &_
				""&filtro1&""& vbCrLf &_
				""&filtro2&""& vbCrLf &_
				"and emat_ccod=1"& vbCrLf &_
				"order by nombre"
					
end if
'response.Write("<pre>"&sql_descuentos&"</pre>")
f_mis_datos.Consultar sql_descuentos



	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()

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
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	
  </tr>
  <%  while f_mis_datos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_mis_datos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_mis_datos.ObtenerValor("rut")%></div></td>
   
  </tr>
  <%  wend %>
</table>
</html>