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


pers_nrut = request.Form("m[0][pers_nrut]")
pers_xdv = request.Form("m[0][pers_xdv]")
pers_tnombre = request.Form("m[0][pers_tnombre]")
pers_tape_paterno = request.Form("m[0][pers_tape_paterno]")
pers_tape_materno = request.Form("m[0][pers_tape_materno]")
pers_fnacimiento = request.Form("m[0][pers_fnacimiento]")
pers_tprofesion = request.Form("m[0][pers_tprofesion]")
pers_temail = request.Form("m[0][pers_temail]")
pers_tfono = request.Form("m[0][pers_tfono]")
pers_tcelular = request.Form("m[0][pers_tcelular]")
nied_ccod = request.Form("m[0][nied_ccod]")
dire_tcalle = request.Form("m[0][dire_tcalle]")
dire_tnro = request.Form("m[0][dire_tnro]")
dire_tpoblacion = request.Form("m[0][dire_tpoblacion]")
dire_tblock = request.Form("m[0][dire_tblock]")
ciud_ccod = request.Form("m[0][ciud_ccod]")
utiliza_sence = request.Form("m[0][utiliza_sence]")
forma_pago = request.Form("m[0][fpot_ccod]")
dcur_ncorr = session("dcur_ncorr_postulacion")
sede_ccod = session("sede_ccod_postulacion")
pers_tempresa = request.Form("m[0][pers_tempresa]")
pers_tcargo = request.Form("m[0][pers_tcargo]")

usuario = negocio.obtenerUsuario

esta_en_persona = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
if esta_en_persona = "N" then 
	'-----------se debe agregar un nuevo registro en tabla personas
	pers_ncorr = conectar.consultaUno("exec obtenerSecuencia 'personas'")

	c_persona = " insert into personas (PERS_NCORR,PAIS_CCOD,PERS_NRUT,PERS_XDV,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,PERS_TNOMBRE,PERS_FNACIMIENTO,"&_
			    " PERS_TPROFESION,PERS_TFONO,PERS_TCELULAR,PERS_TEMAIL,AUDI_TUSUARIO,AUDI_FMODIFICACION, pers_tempresa,pers_tcargo) "&_
				" values ("&pers_ncorr&",1,"&pers_nrut&",'"&pers_xdv&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&pers_tnombre&"','"&pers_fnacimiento&"',"&_
				" '"&pers_tprofesion&"','"&pers_tfono&"','"&pers_tcelular&"','"&pers_temail&"','"&usuario&"',getDate(),'"&pers_tempresa&"','"&pers_tcargo&"')"
	
else
	'----------debemos actualizar el registro existente de la persona con la nueva información
	pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	c_persona = " update personas set pers_tape_paterno ='"&pers_tape_paterno&"', pers_tape_materno ='"&pers_tape_materno&"',"&_
	            " pers_tnombre ='"&pers_tnombre&"',pers_fnacimiento ='"&pers_fnacimiento&"',pers_tprofesion ='"&pers_tprofesion&"',"&_
				" pers_tfono ='"&pers_tfono&"',pers_tcelular ='"&pers_tcelular&"',pers_temail ='"&pers_temail&"',"&_
				" audi_tusuario ='"&usuario&"',audi_fmodificacion = getDate()," &_
				" pers_tempresa ='"&pers_tempresa&"',pers_tcargo = '"&pers_tcargo&"'" &_
				" where cast(pers_ncorr as varchar)='"&pers_ncorr&"'"   

end if

esta_en_direcciones = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from direcciones where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tdir_ccod=1")
if esta_en_direcciones = "N" then 
	'-----------se debe agregar un nuevo registro en tabla direcciones
	c_direccion = " insert into direcciones (PERS_NCORR,TDIR_CCOD,CIUD_CCOD,DIRE_TCALLE,DIRE_TNRO,DIRE_TPOBLACION,DIRE_TBLOCK, "&_
	            " DIRE_TFONO,DIRE_TCELULAR,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
				" values ("&pers_ncorr&",1,"&ciud_ccod&",'"&dire_tcalle&"','"&dire_tnro&"','"&dire_tpoblacion&"','"&dire_tblock&"','"&pers_tfono&"','"&pers_tcelular&"','"&usuario&"',getDate())"
	
else
	'----------debemos actualizar el registro existente de la persona con la nueva información
	c_direccion = " update direcciones set ciud_ccod ="&ciud_ccod&", dire_tcalle ='"&dire_tcalle&"',"&_
	            " dire_tnro ='"&dire_tnro&"',dire_tpoblacion ='"&dire_tpoblacion&"',dire_tblock ='"&dire_tblock&"',"&_
				" dire_tfono ='"&pers_tfono&"',dire_tcelular ='"&pers_tcelular&"',"&_
				" audi_tusuario ='"&usuario&"',audi_fmodificacion = getDate()" &_
				" where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tdir_ccod = 1"   

end if

dgso_ncorr = conectar.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&dcur_ncorr&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
esta_en_postulacion = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from postulacion_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  and epot_ccod not in (4,5)")
if esta_en_postulacion = "N" then 
	'-----------se debe agregar un nuevo registro en tabla direcciones
	pote_ncorr = conectar.consultaUno("exec obtenerSecuencia 'postulacion_otec'")
	c_postulacion = " insert into postulacion_otec (pote_ncorr,pers_ncorr,epot_ccod,fecha_postulacion,dgso_ncorr,utiliza_sence,fpot_ccod,audi_tusuario,audi_fmodificacion,nied_ccod) "&_
				    " values ("&pote_ncorr&","&pers_ncorr&",1,getDate(),"&dgso_ncorr&","&utiliza_sence&","&forma_pago&",'"&usuario&"',getDate(),"&nied_ccod&")"
	
else
	'----------debemos actualizar el registro existente de la persona con la nueva información
	pote_ncorr = conectar.consultaUno("select pote_ncorr from postulacion_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
	c_postulacion = "   update postulacion_otec set utiliza_sence ="&utiliza_sence&", fpot_ccod ="&forma_pago&","&_
	                "   audi_tusuario ='"&usuario&"', audi_fmodificacion = getDate(), nied_ccod="&nied_ccod&"" &_
				    "   where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"   

end if




'response.Write("<br>"&c_persona)
'response.Write("<br>"&c_direccion)
'response.Write("<br>"&c_postulacion)
'response.End()
'response.End()
conectar.ejecutaS c_persona
conectar.ejecutaS c_direccion
conectar.ejecutaS c_postulacion
'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
 response.Redirect(request.ServerVariables("HTTP_REFERER"))

'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
