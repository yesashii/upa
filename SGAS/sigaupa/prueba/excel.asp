
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_de_becas_mantencion_externas.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_anos_ccod= request.QueryString("anos_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_descuentos= "select (select ciud_tdesc from ciudades gg where gg.CIUD_CCOD=aaa.ciud_ccod )as ciud,"& vbCrLf &_
				"sum(salud)as a,"& vbCrLf &_
				"sum(ifnormatica)as b,"& vbCrLf &_
				"sum(administracion) as c,"& vbCrLf &_
				"sum(educacion)as d,"& vbCrLf &_
				"sum(comunicacion) as e,"& vbCrLf &_
				"sum(diseno)as f,"& vbCrLf &_
				"count(pers_ncorr)as g"& vbCrLf &_
				
				"from (select pers_ncorr,"& vbCrLf &_
				"isnull((select regi_ccod  from direcciones aa , ciudades bb where  aa.PERS_NCORR=dd.PERS_NCORR and aa.CIUD_CCOD=bb.CIUD_CCOD and tdir_ccod=1),0)as regi_ccod,"& vbCrLf &_
				
				"case when facultad ='AREA CIENCIAS AGROPECUARIAS Y DE SALUD' then 1 else 0 end as salud,"& vbCrLf &_
				"case when facultad ='AREA DE TECNOLOGIAS DE LA INFORMACION Y COMUNICACION'then 1 else 0 end as ifnormatica,"& vbCrLf &_
				"case when facultad ='FACULTAD DE ADMINISTRACIÓN Y MARKETING'then 1 else 0 end as administracion,"& vbCrLf &_
				"case when facultad ='FACULTAD DE CIENCIAS HUMANAS Y EDUCACION'then 1 else 0 end as educacion,"& vbCrLf &_
				"case when facultad ='FACULTAD DE COMUNICACIONES'then 1 else 0 end as comunicacion,"& vbCrLf &_
				"case when facultad ='FACULTAD DE DISEÑO'then 1 else 0 end as diseno,"& vbCrLf &_
				
				"isnull((select aa.ciud_ccod  from direcciones aa , ciudades bb where  aa.PERS_NCORR=dd.PERS_NCORR and aa.CIUD_CCOD=bb.CIUD_CCOD and tdir_ccod=1),0)as ciud_ccod"& vbCrLf &_
				"from sd_totales_2010 a,personas dd"& vbCrLf &_
				"where cast(pers_nrut as varchar)=a.rut )aaa"& vbCrLf &_
				"where"& vbCrLf &_
				"   --regi_ccod in (1,2,3,4,5)--zona norte"& vbCrLf &_
				"   --regi_ccod in (13)--zona norte"& vbCrLf &_
				"   regi_ccod in (6,7,8,9,10,11,12)--zona sur"& vbCrLf &_
				" --regi_ccod =0"& vbCrLf &_
				
				" group by CIUD_CCOD/*,ifnormatica,administracion,educacion,comunicacion,diseno*/"& vbCrLf &_
				"  order by ciud"








	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
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
   
  <td width="33%"><div align="up"><strong>ciud</strong></div></td>
  <td width="67%"><div align="center"><strong></strong></div></td>
 
		
  </tr>
 <%  while f_valor_documentos.Siguiente %> 
  <tr> 
  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("a")%></div></td>
	  </tr>
	   <tr> 
	   <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("b")%></div></td>
	  </tr>
	   <tr>
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("c")%></div></td>
	  </tr>
	   <tr>
	   <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("d")%></div></td>
	  </tr>
	   <tr> 
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("e")%></div></td>
	  </tr>
	   <tr> 
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciud")%></div></td>
<td><div align="left"><%=f_valor_documentos.ObtenerValor("f")%></div></td>
  </tr>
 <%  wend %>
</table>






</html>