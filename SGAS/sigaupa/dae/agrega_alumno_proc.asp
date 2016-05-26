<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "agrega_alumno.xml", "cheques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

pers_nrut = f_agrega.ObtenerValorPost (filai, "pers_nrut")
pers_xdv = f_agrega.ObtenerValorPost (filai, "pers_xdv")
peri_ccod = f_agrega.ObtenerValorPost (filai, "peri_ccod")
tdet_ccod = f_agrega.ObtenerValorPost (filai, "tdet_ccod")
pers_tape_paterno = f_agrega.ObtenerValorPost (filai, "pers_tape_paterno")
monto = f_agrega.ObtenerValorPost (filai, "monto")
observacion = f_agrega.ObtenerValorPost (filai, "observacion")

if tdet_ccod= "" then
tdet_ccod=0
end if

cuenta_post=conectar.consultaUno("select count(post_ncorr) from alumnos a,ofertas_academicas b where pers_ncorr=protic.obtener_pers_ncorr1('"&pers_nrut&"') and a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod="&peri_ccod&" ")
post_ncorr=conectar.consultaUno("select post_ncorr from alumnos a,ofertas_academicas b where pers_ncorr=protic.obtener_pers_ncorr1('"&pers_nrut&"') and a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod="&peri_ccod&" ")
tiene_beca=conectar.consultaUno("select case count(acre_ncorr)when 0 then 'N' else 'S' end from alumno_credito a where cast(post_ncorr as varchar)='"&post_ncorr&"' and  tdet_ccod="&tdet_ccod&" ")

if post_ncorr <>"" and tiene_beca="N" then 

 acre_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")
 'acre_ncorr=10000
 usu=negocio.obtenerUsuario
 
 if monto="" then
   p_insert="insert into alumno_credito(acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion,observacion) values("&acre_ncorr&","&post_ncorr&",'"&tdet_ccod&"','"&usu&"',getDate(),'"&observacion&"')"	

	'conectar.ejecutaS (p_insert)
     
 else
	p_insert="insert into alumno_credito(acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion,monto_bene,observacion) values("&acre_ncorr&","&post_ncorr&",'"&tdet_ccod&"','"&usu&"',getDate(),"&monto&",'"&observacion&"')"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	
		end if
	conectar.ejecutaS (p_insert)

end if

response.Write("<pre>"&p_insert&"</pre>")


	
next

'response.End()

response.Write("<pre>rut= "&pers_nrut&"</pre>")	
response.Write("<pre>xdv= "&pers_xdv&"</pre>")
response.Write("<pre>usu= "&usu&"</pre>")
response.Write("<pre>peri= "&peri_ccod&"</pre>")
response.Write("<pre>pos= "&post_ncorr&"</pre>")
response.Write("<pre>tdet= "&tdet_ccod&"</pre>")
response.Write("<pre>tiene = "&tiene_beca&"</pre>")
response.Write("<pre>tiene = "&cuenta_post&"</pre>")
response.Write("respuesta "&Respuesta)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
response.Write("respuesta "&Respuesta)

if post_ncorr <>""  and tiene_beca="N" then
if Respuesta = true then
session("mensajeerror")= " El alumno fue ingresado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()
else

if cuenta_post = 0 then
 session("mensajeerror")= "El alumno no tiene matricula para el periodo seleccionado "
end if
if tiene_beca="S" then
 session("mensajeerror")= "El alumno ya registra este credito para el periodo academico seleccionado "
end if
end if
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_alumno.asp")
%>