<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=estados_pagos_bancos.xls"
Response.ContentType = "application/vnd.ms-excel"

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

q_pers_nrut =Request.Form("b[0][pers_nrut]")
q_pers_xdv = Request.Form("b[0][pers_xdv]")
q_carr_ccod =Request.Form("b[0][carr_ccod]")
q_sede_ccod= request.Form("b[0][sede_ccod]")
q_facu_ccod= request.Form("b[0][facu_ccod]")
q_anos_ccod= request.Form("b[0][anos_ccod]")
q_rut_banco= request.Form("b[0][rut_banco]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and a.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_carr_ccod <> "" then
	

  	filtro2=filtro2&"and i.carr_ccod='" &q_carr_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and l.sede_ccod='" &q_sede_ccod&"'"
  					
end if

 if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  					
end if


if q_facu_ccod <> "" then
	

  	filtro5=filtro5&"and k.facu_ccod='"&q_facu_ccod&"'"
  					
end if

if q_rut_banco <> "" then
	

  	filtro6=filtro6&"and g.rut_banco="&q_rut_banco&""
  					
end if
'if (request.QueryString) = "" then
'sql_descuentos= "select ''"

'else 
sql_descuentos= "select  pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,nom_carrera_ing,facu_tdesc,sede_tdesc,(select isnull(baca_tdesc,'--') from ufe_bancos_cae aa where aa.baca_nrut=g.rut_banco) as rut_banco,a.pers_ncorr,i.CARR_CCOD,protic.ANO_INGRESO_CARRERA_EGRESA2(a.pers_ncorr,i.CARR_CCOD)as ano_ingreso,"& vbCrLf &_
				"monto_pagado_banco as monto,(select anos_ccod from ufe_alumnos_cae aaa where taca_ccod=1 and aaa.rut=pers_nrut)as ano_beneficio"& vbCrLf &_
				"from personas a,"& vbCrLf &_
				"ufe_alumnos_cae g,"& vbCrLf &_
				"ufe_carreras_ingresa h,"& vbCrLf &_
				"carreras i,"& vbCrLf &_
				"areas_academicas j,"& vbCrLf &_
				"facultades k,"& vbCrLf &_
				"sedes l,"& vbCrLf &_
				"ufe_sedes_ies m,"& vbCrLf &_
				"ufe_carreras_homologadas n,"& vbCrLf &_
				"alumnos o,"& vbCrLf &_
				"postulantes p,"& vbCrLf &_
				"ofertas_academicas r,"& vbCrLf &_
				"especialidades s"& vbCrLf &_
				"where h.cod_carrera_ing= g.carrera"& vbCrLf &_
				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod"& vbCrLf &_
				"and h.car_ing_ncorr= n.car_ing_ncorr"& vbCrLf &_
				"and i.area_ccod=j.area_ccod"& vbCrLf &_
				"and j.facu_ccod=k.facu_ccod"& vbCrLf &_
				"and g.sede=m.seie_ing_ccod"& vbCrLf &_
				"and m.sede_ccod=l.SEDE_CCOD"& vbCrLf &_
				"and a.pers_nrut=g.rut"& vbCrLf &_
				"and a.pers_ncorr=o.PERS_NCORR"& vbCrLf &_
				"and o.post_ncorr=p.post_ncorr"& vbCrLf &_
				"and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod))"& vbCrLf &_
				"and o.OFER_NCORR=r.OFER_NCORR"& vbCrLf &_
				"and g.anos_ccod="&q_anos_ccod&""& vbCrLf &_
				"and r.ESPE_CCOD=s.ESPE_CCOD"& vbCrLf &_
				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" " &filtro5&" "& vbCrLf &_
				" " &filtro6&" "& vbCrLf &_
				"group by pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,nom_carrera_ing,facu_tdesc,sede_tdesc,rut_banco,a.pers_ncorr,i.CARR_CCOD,monto_pagado_banco"& vbCrLf &_
				"order by pers_tape_paterno,pers_tape_materno,pers_tnombre"
				
				'
'end if			
				
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
	<td width="22%"><div align="up"><strong>Aepllido Materno</strong></div></td>
	<td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	 <td width="11%"><div align="center"><strong>DV</strong></div></td>
	<td width="38%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="38%"><div align="center"><strong>facultad</strong></div></td>
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
	 <td width="11%"><div align="center"><strong>Año Ingreso Carrera</strong></div></td>
	 <td width="11%"><div align="center"><strong>Año Obtencion Beneficio</strong></div></td>
	 <td width="11%"><div align="center"><strong>Banco</strong></div></td>
	 <td width="11%"><div align="center"><strong>Monto Pagado</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_nrut")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_xdv")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("facu_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("nom_carrera_ing")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_beneficio")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("rut_banco")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("monto")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>