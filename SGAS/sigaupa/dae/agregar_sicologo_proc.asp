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

usu=negocio.ObtenerUsuario()

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "crea_modulos_sicologos.xml", "actualiza_estado_bloque"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1


pers_nrut = f_agrega.ObtenerValorPost (filai, "pers_nrut")
pers_ncorr=conectar.ConsultaUno("select protic.obtener_pers_ncorr("&pers_nrut&")")
email_upa=f_agrega.ObtenerValorPost (filai, "email")

lascondes=f_agrega.ObtenerValorPost (filai, "lascondes")
baquedano=f_agrega.ObtenerValorPost (filai, "baquedano")
lyon=f_agrega.ObtenerValorPost (filai, "lyon")
melipilla=f_agrega.ObtenerValorPost (filai, "melipilla")
'response.write("<br>"&blsi_ncorr)
sico_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologos'")

if existe="N" then
actualizar="insert into sicologos (sico_ncorr,pers_ncorr,email_upa)values ("&sico_ncorr&","&pers_ncorr&",'"&email_upa&"')"

response.write("<br>"&actualizar)
'response.End()
conectar.ejecutaS(actualizar)

Respuesta_3 = conectar.ObtenerEstadoTransaccion()
		if Respuesta_3  then
			if lascondes="1" then
			side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
			i_lascondes="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",1,'"&usu&"',getdate())" 
			response.write("<br>"&i_lascondes)
			conectar.ejecutaS(i_lascondes)
			end if
			
			if baquedano="1" then
			side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
			i_baquedano="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",8,'"&usu&"',getdate())"
			response.write("<br>"&i_baquedano)
			conectar.ejecutaS(i_baquedano)
			end if
			
			if lyon="1" then
			side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
			i_lyon="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",2,'"&usu&"',getdate())"
			response.write("<br>"&i_lyon)
			conectar.ejecutaS(i_lyon)
			end if
			
			if melipilla="1" then
			side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
			i_melipilla="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",4,'"&usu&"',getdate())"
			response.write("<br>"&i_melipilla)
			conectar.ejecutaS(i_melipilla)
			end if
		end if
end if
next

'response.End()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
if existe="N" then

if Respuesta_3 then
session("mensajeerror")= "El sicólogo ha sido guardado"
else
 session("mensajeerror")= "El sicólogo NO ha sido guardado"
end if
'response.End()
else
 session("mensajeerror")= "El sicólogo ya existe, si quiere editar algún aspecto solo debes hacer clic sobre el sicologo en la tabla de sicólogos"

end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("mantenedor_de_sicologos.asp")
%>


