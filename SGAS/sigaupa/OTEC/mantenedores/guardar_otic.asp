<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

'response.End()

usuario = negocio.obtenerUsuario
pote_ncorr = request.form("e[0][pote_ncorr]")
empr_trazon_social = request.form("o[0][empr_trazon_social]")
empr_tdireccion = request.form("o[0][empr_tdireccion]")
empr_nrut = request.Form("o[0][empr_nrut]")
empr_xdv = request.Form("o[0][empr_xdv]")
ciud_ccod= request.Form("o[0][ciud_ccod]")
empr_tfono= request.Form("o[0][empr_tfono]")
empr_tfax = request.Form("o[0][empr_tfax]")
empr_tgiro= request.Form("o[0][empr_tgiro]")
empr_tejecutivo = request.Form("o[0][empr_tejecutivo]")
empr_temail_ejecutivo = request.Form("o[0][empr_temail_ejecutivo]")
forma_pago = request.Form("e[0][forma_pago]")
norc_otic = request.Form("o[0][norc_otic]")


if pote_ncorr <> "" then 
	esta_en_empresa = conectar.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&empr_nrut&"'")
	esta_en_personas = conectar.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&empr_nrut&"'")
	'response.Write("select count(*) from personas where cast(pers_nrut as varchar)='"&empr_nrut&"'")
	if esta_en_personas = "0" then
		pers_ncorr = conectar.consultaUno("exec obtenerSecuencia 'personas'")
		'----------agregamos datos básicos a tabla persona para que busque pers_ncorr en funciones de morosidad, ingresos y cta. Cte.
		c_persona = " insert into personas (pers_ncorr,pais_ccod, pers_nrut,pers_xdv, pers_tape_paterno, pers_tape_materno, pers_tnombre, audi_tusuario, audi_fmodificacion)"&_
		            " values ("&pers_ncorr&",1,"&empr_nrut&",'"&empr_xdv&"','','','"&empr_trazon_social&"','"&usuario&"',getDate())"  
	else
		pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&empr_nrut&"'")
		c_persona = " update personas set pers_tnombre = '"&empr_trazon_social&"', audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(pers_nrut as varchar)='"&empr_nrut&"'"
	end if	
	
	if esta_en_empresa = "0" then
	    c_empresa = " insert into empresas (empr_ncorr,empr_tnombre,empr_trazon_social,empr_nrut,empr_xdv,empr_tdireccion,ciud_ccod, "&_
		            " empr_tfono,empr_tfax,empr_tgiro,empr_tejecutivo,empr_temail_ejecutivo,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
		            " values ("&pers_ncorr&",'"&empr_trazon_social&"','"&empr_trazon_social&"',"&empr_nrut&",'"&empr_xdv&"','"&empr_tdireccion&"',"&ciud_ccod&","&_
					" '"&empr_tfono&"','"&empr_tfax&"','"&empr_tgiro&"','"&empr_tejecutivo&"','"&empr_temail_ejecutivo&"','"&usuario&"',getDate())"
	else
	    c_empresa = " update empresas set empr_trazon_social='"&empr_trazon_social&"',empr_tdireccion='"&empr_tdireccion&"',"&_
		            " ciud_ccod="&ciud_ccod&",empr_tfono='"&empr_tfono&"',empr_tfax='"&empr_tfax&"',empr_tgiro='"&empr_tgiro&"',"&_
					" empr_tejecutivo='"&empr_tejecutivo&"',empr_temail_ejecutivo='"&empr_temail_ejecutivo&"', audi_tusuario='"&usuario&"', audi_fmodificacion=getDate() where cast(empr_nrut as varchar)='"&empr_nrut&"'"
	end if
	empresa_igual_otic = conectar.consultaUno("select count(*) from postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"' and empr_ncorr_empresa='"&pers_ncorr&"'")
	if empresa_igual_otic = "0" then 	    
		c_postulacion = "update postulacion_otec set empr_ncorr_otic="&pers_ncorr&", audi_tusuario='"&usuario&"',audi_fmodificacion=getDate(),norc_otic='"&norc_otic&"',norc_empresa=null where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"
    else
		conexion.MensajeError "Imposible guardar esta Otic a la postulación por que esta registrada como empresa."
	end if
end if




'response.Write("<br>"&c_persona)
'response.Write("<br>"&c_empresa)
'response.Write("<br>"&c_postulacion)
'response.End()
'response.End()
conectar.ejecutaS c_persona
conectar.ejecutaS c_empresa
conectar.ejecutaS c_postulacion
'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
response.Redirect(request.ServerVariables("HTTP_REFERER"))

'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
