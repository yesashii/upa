<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


pers_nrut=request.Form("pnr")

'pers_nrut="17704018"
'response.Write(pers_nrut)

'response.End()

sql_existe="select case when count(*)>0 then 'S' else 'N' end as existe from personas a, alumnos b ,ofertas_academicas c"& vbCrLf &_
"where a.pers_ncorr=b.PERS_NCORR"& vbCrLf &_
"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
"and c.PERI_CCOD in (228,230) "& vbCrLf &_
"and c.post_bnuevo='S'"& vbCrLf &_
"and cast(pers_nrut as varchar)='"&pers_nrut&"'"

es_alumno_nuevo = conectar.consultaUno(sql_existe)


if es_alumno_nuevo="S" then 

estado_encuestas = conectar.consultaUno("select protic.Encuestaadmision2012("&pers_nrut&")")

response.write(estado_encuestas)

else

response.Write("no aplica")

end if


%>