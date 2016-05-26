<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_becas_mineduc.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.form("b[0][pers_nrut]")
q_pers_xdv = Request.form("b[0][pers_xdv]")
q_tdet_ccod =Request.form("b[0][tdet_ccod]")
q_sede_ccod= request.form("b[0][sede_ccod]")
q_anos_ccod= request.form("b[0][anos_ccod]")
q_facu_ccod=request.form("b[0][facu_ccod]")
q_ano_adjudicacion=request.form("b[0][ano_adjudicacion]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
else

	filtro2=filtro2&"and a.tdet_ccod in (910,1390,1446,1537,1538,1539,1912)"  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  					
end if
  if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  					
end if

  if q_facu_ccod<> "" then
	

  	filtro5=filtro5&"and i.facu_ccod ="&q_facu_ccod&""
  					
end if

if q_carr_ccod<> "" then
	

  	filtro6=filtro6&"and f.carr_ccod ="&q_carr_ccod&""
  					
end if

if q_ano_adjudicacion<> "" then
	

  	filtro7=filtro7&"and ano_adjudicacion="&q_ano_adjudicacion&""
  					
end if

if q_anos_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select a.post_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				",ano_adjudicacion,monto_bene,tdet_tdesc,facu_tdesc,(select cast(max(espe_nduracion)as varchar)+' semestres' from especialidades aa, ofertas_academicas bb,alumnos cc where aa.ESPE_CCOD=bb.ESPE_CCOD and bb.OFER_NCORR=cc.OFER_NCORR  and cc.post_ncorr=a.post_ncorr group by espe_nduracion)as duracion,protic.ANO_INGRESO_CARRERA_EGRESA2(c.pers_ncorr,f.CARR_CCOD)as ano_ingreso_carrera"& vbCrLf &_
				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f,tipos_detalle g,areas_academicas h,facultades i"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
				"and a.tdet_ccod=g.tdet_ccod"& vbCrLf &_
				"and f.area_ccod=h.area_ccod"& vbCrLf &_
				"and h.facu_ccod=i.facu_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" " &filtro5&" "& vbCrLf &_
				" " &filtro6&" "& vbCrLf &_
				" " &filtro7&" "& vbCrLf &_
				"group by a.post_ncorr,c.pers_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,carr_tdesc,d.sede_ccod,ano_adjudicacion,monto_bene,tdet_tdesc,i.facu_tdesc,f.CARR_CCOD"& vbCrLf &_
				"order by carrera,pers_tnombre"
				
		

total=numero_total			
end if			
				
fecha=conexion.ConsultaUno("select protic.trunc(getdate())")
hora =conexion.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")




	
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
  <tr align="center">
    <td></td>
    
    <td><div align="center"><strong>Año <%=q_anos_ccod%></strong></div></td>
	 <td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
      <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
  	<td width="22%"><div align="up"><strong>Apellido Paterno</strong></div></td>
  	<td width="22%"><div align="up"><strong>Apellido Materno</strong></div></td>
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	 <td width="11%"><div align="center"><strong>DV</strong></div></td>
	<td width="11%"><div align="center"><strong>Facultad</strong></div></td>
    <td width="38%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="38%"><div align="center"><strong>Año Ingreso Carrera</strong></div></td>
	<td width="38%"><div align="center"><strong>Duración</strong></div></td>
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
	 <td width="29%"><div align="center"><strong>Beca</strong></div></td>
	  <td width="29%"><div align="center"><strong>Monto Beneficio</strong></div></td>
	   <td width="29%"><div align="center"><strong>A&ntilde;o Adjudicacion</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
  	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
  	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_nrut")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_xdv")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("facu_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_ingreso_carrera")%></div></td>
	    <td><div align="left"><%=f_valor_documentos.ObtenerValor("duracion")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("tdet_tdesc")%></div></td>
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("monto_bene")%></div></td>
	   <td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_adjudicacion")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>