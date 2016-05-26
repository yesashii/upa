<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_resultados_por_asignatura.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut = Request.Form("b[0][pers_nrut]")
q_pers_xdv = Request.Form("b[0][pers_xdv]")
q_carr_ccod = Request.Form("b[0][carr_ccod]")
q_sede_ccod = Request.Form("b[0][sede_ccod]")
q_peri_ccod =Request.Form("b[0][peri_ccod]")
q_anos_ccod = Request.Form("b[0][anos_ccod]")

'response.Write("<br>periodo academicos "&q_peri_ccod)
'---------------------------------------------------------------------------------------------------
'response.End()
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



'consulta_er = "select smod_tdesc, sfun_tdesc from sis_funciones_modulos fm,sis_modulos sm  where fm.smod_ccod not in (select smod_ccod from log_funciones)and fm.smod_ccod=sm.smod_ccod"
	
'set fv_valor_documentos  = new cformulario 
'fv_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla_vacia" 
'fv_valor_documentos.inicializar conexion							
'fv_valor_documentos.consultar consulta_er	

if q_peri_ccod ="" then
q_peri_ccod=226
else
q_peri_ccod=q_peri_ccod
end if


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and et.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_carr_ccod <> "" then
	

  	filtro2=filtro2&"and esp.carr_ccod='" &q_carr_ccod&"'"
  					
end if
		
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and oa.sede_ccod='" &q_sede_ccod&"'"
  					
end if


sql_descuentos="select nombre,ec,o_r,ca,ea,ca_ec,ea_or,rut,carrera,Paa_verbal,paa_mate,fecha,asig_tdesc,secc_tdesc,"& vbCrLf &_
"case when ea_or > 0 and ca_ec >0  then 'DIVERGENTE' when ea_or < 0 and ca_ec >0  then 'ACOMODADOR' when ea_or > 0 and ca_ec < 0  then 'ASIMILADOR' when ea_or < 0 and ca_ec <0  then 'CONVERGENTE' when ea_or = 0 and ca_ec >0  then 'ACOMODADOR/DIVERGENTE' when ea_or > 0 and ca_ec =0  then 'DIVERGENTE/ASIMILADOR' when ea_or = 0 and ca_ec < 0  then 'ASIMILADOR/CONVERGENTE' when ea_or < 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE' when ea_or = 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE/ASIMILADOR/DIVERGENTE'  end as tipo"& vbCrLf &_
"from (select distinct cast(p.pers_nrut as varchar) + '-' + p.pers_xdv as rut, p.pers_tape_paterno + ' ' + p.pers_tape_materno + ' ' + p.pers_tnombre as 						               	nombre,carr_tdesc as carrera, post_npaa_verbal as Paa_verbal,post_npaa_matematicas as paa_mate,protic.trunc(et.fecha)as fecha,"& vbCrLf &_
              "preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a as ec,"& vbCrLf &_
				"preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b  as o_r,"& vbCrLf &_
				"preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c as ca,"& vbCrLf &_
				"preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d as ea,"& vbCrLf &_
				"((((preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c)-(preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a))*-1)+2)as ca_ec,"& vbCrLf &_
				"((((preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d)-(preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b))*-1)+3)as ea_or,asig_tdesc,secc_tdesc"& vbCrLf &_
				"from encuesta_test et,personas p,alumnos a,postulantes po,ofertas_academicas oa, especialidades esp,carreras car,cargas_academicas caa,secciones sec,asignaturas asi"& vbCrLf &_
				"where et.pers_ncorr=p.pers_ncorr"& vbCrLf &_
				"and p.pers_ncorr=a.pers_ncorr"& vbCrLf &_
				"and a.ofer_ncorr=oa.ofer_ncorr"& vbCrLf &_
				"and po.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				"and po.post_bnuevo='S'"& vbCrLf &_
				"and oa.espe_ccod=esp.espe_ccod"& vbCrLf &_
				"and esp.carr_ccod=car.carr_ccod"& vbCrLf &_
				"and a.post_ncorr=po.post_ncorr"& vbCrLf &_
				"and sec.peri_ccod="&q_peri_ccod&""& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"and caa.matr_ncorr=a.matr_ncorr"& vbCrLf &_
 				"and caa.secc_ccod=sec.secc_ccod"& vbCrLf &_
 				"and sec.asig_ccod=asi.asig_ccod)as aa"& vbCrLf &_
				"order by carrera,asig_tdesc,nombre"




'response.Write("<pre>"&q_peri_ccod&"</pre>")	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos


peri_tdesc=conexion.consultaUno("select peri_tdesc from periodos_academicos where peri_ccod='"&q_peri_ccod&"'")


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
<tr><td colspan="15" align="center"> Listado de Asignaturas del <%=peri_tdesc%></td></tr>
  <tr>    
  <td><div align="up"><strong>Nombre</strong></div></td>
  <td><div align="center"><strong>Rut</strong></div></td>
  <td><div align="center"><strong>Carrera</strong></div></td>
  <td><div align="center"><strong>PAA o PSU MAT</strong></div></td>
  <td><div align="center"><strong>PAA o PSU Verbal</strong></div></td>
  <td><div align="center"><strong>EC</strong></div></td>
  <td><div align="center"><strong>OR</strong></div></td>
  <td><div align="center"><strong>CA</strong></div></td>
  <td><div align="center"><strong>EA</strong></div></td>
   <td><div align="center"><strong>EA-OR(X)</strong></div></td>
  <td><div align="center"><strong>CA-EC(Y)</strong></div></td>
   <td><div align="center"><strong> Tipo</strong></div></td>
  <td><div align="center"><strong> Fecha</strong></div></td>
   <td><div align="center"><strong>Asignatura</strong></div></td>
    <td><div align="center"><strong>Sección</strong></div></td>
		
  </tr>
 <%  while f_valor_documentos.Siguiente %> 
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("Paa_mate")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("Paa_verbal")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ec")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("o_r")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ca")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ea")%></div></td>
	  <td><div align="left"><%=f_valor_documentos.ObtenerValor("ea_or")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("ca_ec")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("fecha")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("asig_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("secc_tdesc")%></div></td>


  </tr>
 <%  wend %>
</table>






</html>