<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next



set conectar = new cconexion
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false

pers_ncorr = request.querystring("pers_ncorr")
peri_ccod = request.querystring("peri_ccod")

'response.Write("<pre>pers_ncorr "&pers_ncorr&" peri_ccod "&peri_ccod&"</pre>")

cons_insercion = " insert into con_evaluacion_docente_terminada " & vbCrLf &_
				 " select pers_ncorr, matr_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb where cast(aa.pers_ncorr as varchar)='"&pers_ncorr&"' and aa.ofer_ncorr=bb.ofer_ncorr and cast(bb.peri_ccod as varchar)='"&peri_ccod&"' and aa.emat_ccod = 1"

'response.Write(cons_insercion)
conectar.ejecutaS 	cons_insercion   
url = "seleccionar_docente.asp"
response.Redirect(url)
'response.End()

%>


