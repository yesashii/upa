<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next


set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "crea_modulos_sicologos.xml", "cambia_bloques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

peri_ccod=request.Form("cambiar[0][peri_ccod]")
side_ncorr=request.Form("cambiar[0][side_ncorr]")


for filai = 0 to f_agrega.CuentaPost - 1

blsi_ncorr = f_agrega.ObtenerValorPost (filai, "blsi_ncorr")
lunes = f_agrega.ObtenerValorPost (filai, "lunes")
martes = f_agrega.ObtenerValorPost (filai, "martes")
miercoles = f_agrega.ObtenerValorPost (filai, "miercoles")
jueves = f_agrega.ObtenerValorPost (filai, "jueves")
viernes = f_agrega.ObtenerValorPost (filai, "viernes")


existen_bloques=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end from bloque_dia_sicologo where blsi_ncorr="&blsi_ncorr&"")

if existen_bloques="S" then
elimina="delete from bloque_dia_sicologo where blsi_ncorr="&blsi_ncorr&""

response.Write("<br>"&elimina)

conectar.EjecutaS(elimina)
end if

response.Write("<br>"&existen_bloques)
response.write("<br>"&blsi_ncorr&" /"&lunes&" /"&martes&" "&miercoles&" /"&jueves&" /"&viernes)

if lunes="1" then
's_bdsi_ncorr="exec ObtenerSecuencia 'bloque_dia_sicologo' "
bdsi_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'bloque_dia_sicologo'")
insert_lunes="insert into bloque_dia_sicologo (bdsi_ncorr,blsi_ncorr,dias_ccod) values ("&bdsi_ncorr&","&blsi_ncorr&",1)"
response.Write("<br>"&insert_lunes)
conectar.ejecutaS(insert_lunes)
end if
if martes="1" then
's_bdsi_ncorr="exec ObtenerSecuencia 'bloque_dia_sicologo' "
bdsi_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'bloque_dia_sicologo'")
insert_martes="insert into bloque_dia_sicologo (bdsi_ncorr,blsi_ncorr,dias_ccod) values ("&bdsi_ncorr&","&blsi_ncorr&",2)"
response.Write("<br>"&insert_martes)
conectar.ejecutaS(insert_martes)
end if
if miercoles="1" then
's_bdsi_ncorr="exec ObtenerSecuencia 'bloque_dia_sicologo' "
bdsi_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'bloque_dia_sicologo'")
insert_miercoles="insert into bloque_dia_sicologo (bdsi_ncorr,blsi_ncorr,dias_ccod) values ("&bdsi_ncorr&","&blsi_ncorr&",3)"
response.Write("<br>"&insert_miercoles)
conectar.ejecutaS(insert_miercoles)
end if
if jueves="1" then
's_bdsi_ncorr="exec ObtenerSecuencia 'bloque_dia_sicologo' "
bdsi_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'bloque_dia_sicologo'")
insert_jueves="insert into bloque_dia_sicologo (bdsi_ncorr,blsi_ncorr,dias_ccod) values ("&bdsi_ncorr&","&blsi_ncorr&",4)"
response.Write("<br>"&insert_jueves)
conectar.ejecutaS(insert_jueves)
end if
if viernes="1" then
's_bdsi_ncorrr="exec ObtenerSecuencia 'bloque_dia_sicologo' "
bdsi_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'bloque_dia_sicologo'")
insert_viernes="insert into bloque_dia_sicologo (bdsi_ncorr,blsi_ncorr,dias_ccod) values ("&bdsi_ncorr&","&blsi_ncorr&",5)"
response.Write("<br>"&insert_viernes)
conectar.ejecutaS(insert_viernes)
end if

'
'response.write("<br>"&blsi_ncorr&" /"&lunes&" /"&martes&" "&miercoles&" /"&jueves&" /"&viernes)





 'usu=negocio.obtenerUsuario
'	p_insert="update  talleres_sicologia set tasi_tdesc='"&tasi_tdesc&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where tasi_ncorr="&tasi_ncorr&""		  
	'response.Write("<pre>"&p_insert&"</pre>")
	'conectar.ejecutaS (p_insert)

'response.Write("respuesta "&Respuesta)	

next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
'session("mensajeerror")= " El Taller fue Actualizado con Éxito"
else
 ' session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("muestra_bloques_sicologos_final.asp?side_ncorr="&side_ncorr&"&peri_ccod="&peri_ccod&"")
%>


