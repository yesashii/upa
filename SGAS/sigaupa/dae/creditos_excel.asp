<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_Creditos.xls"
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
if q_anos_ccod <> "" then
anio_ante=q_anos_ccod-1
end if

if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
  filtro5=filtro5&"and e.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  	filtro6=filtro6&"and f.sede_ccod='" &q_sede_ccod&"'"			
end if

 if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  	filtro7=filtro7&"and f.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
					
end if
 
if q_tdet_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos="select stde_ccod as tdet_ccod,isnull(acre_ncorr,0)acre_ncorr, a.post_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=f.sede_ccod)sede,"& vbCrLf &_
"isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion,protic.tipo_alumno_CAE (d.pers_ncorr,d.post_ncorr) as tipo_alumno "& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=f.peri_ccod)as perio"& vbCrLf &_
"from  sdescuentos a  left outer join alumno_credito b "& vbCrLf &_
"on a.post_ncorr=b.post_ncorr"& vbCrLf &_
"join alumnos d "& vbCrLf &_
"on a.post_ncorr=d.post_ncorr"& vbCrLf &_
"join personas e"& vbCrLf &_
"on d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"join ofertas_academicas f"& vbCrLf &_
"on d.ofer_ncorr=f.ofer_ncorr"& vbCrLf &_
"join especialidades g"& vbCrLf &_
"on f.espe_ccod=g.espe_ccod"& vbCrLf &_
"join carreras h"& vbCrLf &_
"on g.carr_ccod=h.carr_ccod"& vbCrLf &_

"where a.post_ncorr in (select post_ncorr from postulantes where peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")) "& vbCrLf &_
"and stde_ccod='" &q_tdet_ccod&"' and a.esde_ccod=1"& vbCrLf &_
"and a.post_ncorr not in (select a.post_ncorr from alumno_credito a , postulantes b where a.post_ncorr=b.post_ncorr and peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&"))"& vbCrLf &_
			" " &filtro5&" "& vbCrLf &_
			" " &filtro6&" "& vbCrLf &_
			" " &filtro7&" "& vbCrLf &_

"union"& vbCrLf &_
"select distinct tdet_ccod,acre_ncorr, a.post_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre  ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion ,protic.tipo_alumno_CAE (b.pers_ncorr,b.post_ncorr) as tipo_alumno"& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
"and emat_ccod <>9"& vbCrLf &_
" and a.tdet_ccod='" &q_tdet_ccod&"'"& vbCrLf &_
		
			" " &filtro2&" "& vbCrLf &_
			" " &filtro1&" "& vbCrLf &_
			" " &filtro3&" "& vbCrLf &_
			" " &filtro4&" "& vbCrLf &_
 

"order by carrera,perio,pers_tape_paterno"




'"select a.post_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,monto_bene,observacion,(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
' 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
'				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
'				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
'				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
'				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
'				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
'				" " &filtro2&" "& vbCrLf &_
'				" " &filtro1&" "& vbCrLf &_
'				" " &filtro3&" "& vbCrLf &_
'				" " &filtro4&" "& vbCrLf &_
'				"order by carrera,perio,pers_tape_paterno"
				
				'
					
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
<title><%=pagina.Titulo%></title></head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr align="center">
    <td></td>
    <td></td>
    <td></td>
    <td><div align="center"><strong>Año <%=q_anos_ccod%></strong></div></td>
    <td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
    <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  <tr>
    <td width="22%"><div align="up"><strong>Apellido Paterno </strong></div></td>
    <td width="22%"><div align="up"><strong>Apellido Materno </strong></div></td>
    <td width="22%"><div align="up"><strong>Nombre </strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	<td width="38%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="38%"><div align="center"><strong>Periodo Academico</strong></div></td>
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
	<td width="38%"><div align="center"><strong>Monto Beneficio</strong></div></td>
    <td width="29%"><div align="center"><strong>Observacion</strong></div></td>
	<%if q_tdet_ccod="1402" then%>
	<td width="29%"><div align="center"><strong>Tipo Alumno</strong></div></td>
	<%end if%>
  </tr>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("perio")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("monto_bene")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("observacion")%></div></td>
	<%if q_tdet_ccod="1402" then%>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_alumno")%></div></td>
	<%end if%>
  </tr>
  <%  wend %>
</table>
</html>