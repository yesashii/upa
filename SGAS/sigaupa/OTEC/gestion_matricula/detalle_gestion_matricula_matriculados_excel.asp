<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_gestion_matricula.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
sede_ccod= request.QueryString("sede_ccod")
ano_ccod  = request.querystring("ano_ccod")
epot_ccod= request.QueryString("epot_ccod")
dgso_ncorr = request.querystring("dgso_ncorr")
if ano_ccod ="" then 
ano_ccod=0
end if

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

if sede_ccod="" then
 sede_ccod=conexion.consultaUno("select sede_ccod from sedes where sede_tdesc='"&sede_tdesc&"'")
 end if
if epot_ccod="4" then
epot_ccod="3,4"
end if
sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
 
consulta ="select distinct upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre) as nombre, "& vbcrlf & _
			" cast(pers_nrut as varchar)+'-'+pers_xdv as rut,a.dgso_ncorr,lower(b.pers_temail) as email, pers_tfono as fono, pers_tcelular as celular, "& vbcrlf & _
			" (select epot_tdesc from estados_postulacion_otec where epot_ccod=a.epot_ccod)as estado , "& vbcrlf & _
			" protic.trunc (a.fecha_postulacion) as fecha_post,protic.trunc (a.audi_fmodificacion) as fecha_matr, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_empresa)as empresa, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_otic)as otic, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_empresa)as rut_empresa, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_otic)as rut_otic, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC2(a.pers_ncorr,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.pers_ncorr and tipo_institucion=1),getdate()) as deuda_particuar, "& vbcrlf & _
			"  isnull(protic.ES_MOROSO_OTEC2(a.empr_ncorr_empresa,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_empresa and tipo_institucion=2),getdate()),1) as deuda_empresa, "& vbcrlf & _
			"  isnull(protic.ES_MOROSO_OTEC2(a.empr_ncorr_otic,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_otic and tipo_institucion=3),getdate()),1) as deuda_otic, "& vbcrlf & _
			"protic.Obtiene_resultado_moroso_otec(a.pers_ncorr,1,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.pers_ncorr and tipo_institucion=1),a.pote_ncorr,getdate())as tipo_p,"& vbcrlf & _
 		    "protic.Obtiene_resultado_moroso_otec(a.empr_ncorr_empresa,2,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_empresa and tipo_institucion=2),a.pote_ncorr,getdate())as tipo_e,"& vbcrlf & _
            "protic.Obtiene_resultado_moroso_otec(a.empr_ncorr_otic,3,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_otic and tipo_institucion=3),a.pote_ncorr,getdate())as tipo_o,"& vbcrlf & _
			"protic.MONTO_TOTAL_PORVENCER(a.pers_ncorr,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.pers_ncorr and tipo_institucion=1),getdate()) as por_pagar_particuar, "& vbcrlf & _
		    "isnull(protic.MONTO_TOTAL_PORVENCER(a.empr_ncorr_empresa,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_empresa and tipo_institucion=2),getdate()),1) as por_pagar_empresa, "& vbcrlf & _
		    "isnull(protic.MONTO_TOTAL_PORVENCER(a.empr_ncorr_otic,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_otic and tipo_institucion=3),getdate()),1) as por_pagar_otic"& vbcrlf & _
			" from postulacion_otec a "& vbcrlf & _
			" join personas b"& vbcrlf & _
			" on a.pers_ncorr=b.pers_ncorr"& vbcrlf & _
			" and a.epot_ccod in ("&epot_ccod&")"& vbcrlf & _
			" and a.dgso_ncorr="&dgso_ncorr&""& vbcrlf & _
			" join datos_generales_secciones_otec c"& vbcrlf & _
			" on a.dgso_ncorr=c.dgso_ncorr"& vbcrlf & _
			" and sede_ccod="&sede_ccod&""& vbcrlf & _
			" left outer join postulantes_cargos_otec d"& vbcrlf & _
			" on d.pote_ncorr=a.pote_ncorr"& vbcrlf & _
			" order by nombre"


	
	 sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
	curso=conexion.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr in (select dcur_ncorr from datos_generales_secciones_otec where dgso_ncorr='"&dgso_ncorr&"')")
	
'response.Write("<pre>"&sede_tdesc&"</pre>")
'response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&consulta2&"</pre>")
'response.End()
set lista  = new cformulario
lista.carga_parametros "tabla_vacia.xml", "tabla" 
lista.inicializar conexion							
lista.consultar consulta


fecha_impresion=conexion.consultaUno("select getDate() ")


'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="93%" border="1" align="center">
<tr>
	<td colspan="17"><div align="right"><%=fecha_impresion%></div></td>
</tr>
<tr>
	<td colspan="17"><div align="center"><font size="+2"><strong>Diplomado/Curso :<%=curso%></strong></font></div></td>
</tr>
<tr>
  		<td bgcolor="#FF9900" ><div align="center"><strong>Estado</strong></div></td>
		<td bgcolor="#FF9900" ><div align="center"><strong>Sede</strong></div></td>
		<td bgcolor="#FF9900" ><div align="center"><strong>Nombre</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
        <td bgcolor="#FF9900"><div align="center"><strong>E-mail</strong></div></td>	 
		<td bgcolor="#FF9900"><div align="center"><strong>Teléfono</strong></div></td>	 
		<td bgcolor="#FF9900"><div align="center"><strong>Celular</strong></div></td>	 
		<td bgcolor="#FF9900"><div align="center"><strong>Fecha Postulacion </strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Fecha Matricula </strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Estado</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Empresa</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Rut Empresa</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Otic</strong></div></td> 
		<td bgcolor="#FF9900"><div align="center"><strong>Rut Otic</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Deuda particular</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Deuda Empresa</strong></div></td> 
		<td bgcolor="#FF9900"><div align="center"><strong>Deuda Otic</strong></div></td>	
  </tr>
  <% total_particular = 0
     total_empresa = 0
	 total_otic = 0 
     while lista.Siguiente 
  v_tipo_p= lista.Obtenervalor("tipo_p") 
				  v_tipo_e=lista.Obtenervalor("tipo_e") 
				  v_tipo_o=lista.Obtenervalor("tipo_o")
				  
				  'response.Write("<br>"&v_deuda)
					 if ((v_tipo_p="1")and(v_tipo_e="1")and (v_tipo_o="1")) then
						'img_deuda="on_x_mora.gif"
						estado_deuda="No es Mororoso"
					end if
							 
				   if ((v_tipo_p="2")or(v_tipo_e="2")or(v_tipo_o="2")) then
				   'img_deuda="amarillo.gif"
				   estado_deuda="No es Moroso pero tiene cuotas por vencer"
				   end if
				   
				   if ((v_tipo_p="3")or(v_tipo_e="3")or(v_tipo_o="3")) then
					'img_deuda="stop_x_mora.gif"
					estado_deuda="Es Moroso"
				   end if
				   
				     total_particular = total_particular + clng(lista.Obtenervalor("deuda_particuar"))
					 total_empresa    = total_empresa + clng(lista.Obtenervalor("deuda_empresa"))
					 total_otic       = total_otic + clng(lista.Obtenervalor("deuda_otic"))
				   %>
  <tr bordercolor="#999999">
  	<td ><div align="center"><%=estado_deuda%></div></td>	
    <td ><div align="center"><%=sede_tdesc%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("nombre")%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("rut")%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("email")%></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("fono")%></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("celular")%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("fecha_post")%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("fecha_matr")%></div></td>
    <td ><div align="center"><%=lista.Obtenervalor("estado")%></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("empresa")%></strong></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("rut_empresa")%></strong></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("otic")%></strong></div></td>
	<td ><div align="center"><%=lista.Obtenervalor("rut_otic")%></strong></div></td>
	<td ><div align="center">$ <%=lista.Obtenervalor("deuda_particuar")%></div></td>
	<td ><div align="center">$ <%=lista.Obtenervalor("deuda_empresa")%></div></td>
	<td ><div align="center">$ <%=lista.Obtenervalor("deuda_otic")%></div></td>
  </tr>
  <%  wend %>
  <tr bordercolor="#999999">
  	<td bgcolor="#FFFF66" colspan="14" align="right"><strong>Totales por categoría :</strong></td>	
    <td bgcolor="#FFFF66" ><div align="center">$ <%=total_particular%></div></td>
	<td bgcolor="#FFFF66" ><div align="center">$ <%=total_empresa%></div></td>
	<td bgcolor="#FFFF66" ><div align="center">$ <%=total_otic%></div></td>
  </tr>
  <tr bordercolor="#999999">
  	<td bgcolor="#FFFF66" colspan="14" align="right"><strong>Totales Deuda programa :</strong></td>	
    <td bgcolor="#FFFF66" colspan="3" ><div align="left"><strong>$ <%=total_particular + total_empresa + total_otic%></strong></div></td>
  </tr>
</table>
</body>
</html>
