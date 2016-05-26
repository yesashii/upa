<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_becas_internas_arancel.xls"
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


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and i.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and k.sede_ccod='" &q_sede_ccod&"'"
  					
end if

sql_descuentos= " select  distinct pers_tape_paterno,pers_tape_materno,pers_tnombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,(select carr_tdesc from carreras ca ,ofertas_academicas"& vbCrLf &_
				" oa,especialidades es where oa.ofer_ncorr=c.ofer_ncorr and oa.espe_ccod=es.espe_ccod and es.carr_ccod=ca.carr_ccod)as carrera,(select sede_tdesc from sedes s ,OFERTAS_ACADEMICAS OA  where s.sede_ccod=OA.sede_ccod AND OA.OFER_NCORR=C.OFER_NCORR)as sede,"& vbCrLf &_
				" (select protic.obtener_direccion ((select pers_ncorr from codeudor_postulacion where post_ncorr=c.post_ncorr),1,'COM'))as comuna,"& vbCrLf &_
				" (select protic.obtener_direccion ((select pers_ncorr from codeudor_postulacion where post_ncorr=c.post_ncorr),1,'CIU'))as ciudad,"& vbCrLf &_
				" (select protic.obtener_direccion ((select pers_ncorr from codeudor_postulacion where post_ncorr=c.post_ncorr),1,'CN'))as dire,"& vbCrLf &_
				" (select a.pare_tdesc from parentescos a ,codeudor_postulacion b where a.pare_ccod=b.pare_ccod and post_ncorr=c.post_ncorr)as codeudor,"& vbCrLf &_
  				" tdet_tdesc,i.tdet_ccod,case k.post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end as tipo_alumno, "& vbCrLf &_
				" (select protic.ano_ingreso_carrera(c.pers_ncorr,tt.carr_ccod) from especialidades tt where tt.espe_ccod=k.espe_ccod) as ano_ingreso "& vbCrLf &_
				" from personas a,postulantes b,alumnos c,contratos d,compromisos f,detalle_compromisos g ,detalles h,tipos_detalle i,sdescuentos j,ofertas_academicas k"& vbCrLf &_
				" where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				" and a.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				" and b.post_ncorr=c.post_ncorr"& vbCrLf &_
				" and c.matr_ncorr=d.matr_ncorr"& vbCrLf &_
				" and d.cont_ncorr=f.comp_ndocto"& vbCrLf &_
				" and f.tcom_ccod=g.tcom_ccod"& vbCrLf &_
				" and f.inst_ccod=g.inst_ccod"& vbCrLf &_
				" and f.comp_ndocto=g.comp_ndocto"& vbCrLf &_
				" and g.tcom_ccod=h.tcom_ccod"& vbCrLf &_
				" and g.inst_ccod=h.inst_ccod"& vbCrLf &_
				" and g.comp_ndocto=h.comp_ndocto"& vbCrLf &_
				" and j.stde_ccod=i.tdet_ccod"& vbCrLf &_
				" and c.post_ncorr=j.post_ncorr"& vbCrLf &_
				" and c.ofer_ncorr=j.ofer_ncorr"& vbCrLf &_
				"and j.esde_ccod=1"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" and i.tben_ccod in (2,3)"& vbCrLf &_
				" and d.peri_ccod in(select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" and c.ofer_ncorr=k.ofer_ncorr"& vbCrLf &_
				" order by carrera,sede,pers_tape_paterno"
				
				
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
    <td>&nbsp;</td>
    <td><div align="center"><strong>Año <%=q_anos_ccod%></strong></div></td>
	<td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
    <td colspan="7"><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
  	<td width="22%"><div align="up"><strong>A. paterno</strong></div></td>
  	<td width="22%"><div align="up"><strong>A. materno</strong></div></td>
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
    <td width="38%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
	<td width="29%"><div align="center"><strong>Tipo Alumno</strong></div></td>
	<td width="29%"><div align="center"><strong>Año de ingreso</strong></div></td>
	<td width="29%"><div align="center"><strong>Codeudor</strong></div></td>
	<td width="29%"><div align="center"><strong>Direccion Codedudor</strong></div></td>
	<td width="29%"><div align="center"><strong>Ciudad Codeudor </strong></div></td>
	<td width="29%"><div align="center"><strong>Comuna Codeudor</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
  	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_alumno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("codeudor")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("dire")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ciudad")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("comuna")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>