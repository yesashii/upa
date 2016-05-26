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


sico_ncorr = f_agrega.ObtenerValorPost (filai, "sico_ncorr")
pers_ncorr = f_agrega.ObtenerValorPost (filai, "pers_ncorr")
email_upa=f_agrega.ObtenerValorPost (filai, "email")

lascondes=f_agrega.ObtenerValorPost (filai, "lascondes")
baquedano=f_agrega.ObtenerValorPost (filai, "baquedano")
lyon=f_agrega.ObtenerValorPost (filai, "lyon")
melipilla=f_agrega.ObtenerValorPost (filai, "melipilla")
'response.write("<br>"&blsi_ncorr)


actualizar="update sicologos set email_upa='"&email_upa&"' where sico_ncorr="&sico_ncorr&""
response.Write("<br>"&actualizar)
'response.End()
conectar.ejecutaS(actualizar)

existe_lacondes=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from  sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=1")
existe_baquedano=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from  sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=8")
existe_lyon=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from  sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=2")
existe_melipilla=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from  sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=4")
Respuesta_3 = conectar.ObtenerEstadoTransaccion()
		if Respuesta_3  then
			if lascondes="1" then
						
				if existe_lacondes="N" then
					side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
					i_lascondes="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",1,'"&usu&"',getdate())" 
					response.write("<br>"&i_lascondes)
					conectar.ejecutaS(i_lascondes)
				end if	
				
			else
				if existe_lacondes="S" then
					i_lascondes="delete from sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=1"
					response.write("<br>"&i_lascondes)
					conectar.ejecutaS(i_lascondes)
				end if	
					
			end if
			
			if baquedano="1" then
			
				if existe_baquedano="N" then 
					side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
					i_baquedano="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",8,'"&usu&"',getdate())"
					response.write("<br>"&i_baquedano)
					conectar.ejecutaS(i_baquedano)
				end if
			
			else
				if existe_baquedano="S" then 
					i_baquedano="delete from sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=8"
					response.write("<br>"&i_baquedano)
					conectar.ejecutaS(i_baquedano)
				end if
			end if
			
			if lyon="1" then
				if existe_lyon="N" then 
					side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
					i_lyon="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",2,'"&usu&"',getdate())"
					response.write("<br>"&i_lyon)
					conectar.ejecutaS(i_lyon)
				end if
			else
				if existe_lyon="S" then 
					i_lyon="delete from sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=2"
					response.write("<br>"&i_lyon)
					conectar.ejecutaS(i_lyon)
				end if	
			end if
			if melipilla="1" then
				if existe_melipilla="N" then
					side_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'sicologo_sede'")
					i_melipilla="insert into sicologos_sede (side_ncorr,sico_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion) values ("&side_ncorr&","&sico_ncorr&",4,'"&usu&"',getdate())"
					response.write("<br>"&i_melipilla)
					conectar.ejecutaS(i_melipilla)
				end if
			else
				if existe_melipilla="S" then
					i_melipilla="delete from sicologos_sede where sico_ncorr="&sico_ncorr&" and sede_ccod=4"
					response.write("<br>"&i_melipilla)
					conectar.ejecutaS(i_melipilla)
				end if
					
			end if
		end if

next

'response.End()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)

if Respuesta_3 then
session("mensajeerror")= "El sicólogo ha sido guardado"
else
 session("mensajeerror")= "El sicólogo NO ha sido guardado"
end if
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("editar_sicologo.asp?pers_ncorr="&pers_ncorr&"")
%>


