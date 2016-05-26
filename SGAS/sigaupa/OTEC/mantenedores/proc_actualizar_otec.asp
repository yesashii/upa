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

tipo = request.Form("tipo")
usuario = negocio.obtenerUsuario

if tipo = "p" then 
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
	dire_tcalle = request.Form("m[0][dire_tcalle]")
	dire_tnro = request.Form("m[0][dire_tnro]")
	dire_tpoblacion = request.Form("m[0][dire_tpoblacion]")
	dire_tblock = request.Form("m[0][dire_tblock]")
	ciud_ccod = request.Form("m[0][ciud_ccod]")
	pers_tempresa = request.Form("m[0][pers_tempresa]")
	pers_tcargo = request.Form("m[0][pers_tcargo]")
	
	esta_en_persona = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
		if esta_en_persona = "S" then 
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
		'response.Write("<br>"&c_persona)
		'response.Write("<br>"&c_direccion)
		'response.End()
		conectar.ejecutaS c_persona
		conectar.ejecutaS c_direccion
elseif tipo="e" then
		empr_trazon_social = request.form("e[0][empr_trazon_social]")
		empr_tdireccion = request.form("e[0][empr_tdireccion]")
		empr_nrut = request.Form("e[0][empr_nrut]")
		empr_xdv = request.Form("e[0][empr_xdv]")
		ciud_ccod= request.Form("e[0][ciud_ccod]")
		empr_tfono= request.Form("e[0][empr_tfono]")
		empr_tfax = request.Form("e[0][empr_tfax]")
		empr_tgiro= request.Form("e[0][empr_tgiro]")
		empr_tejecutivo = request.Form("e[0][empr_tejecutivo]")
		empr_temail_ejecutivo = request.Form("e[0][empr_temail_ejecutivo]")
		
		if empr_nrut <> "" and  empr_xdv <> "" then 
			esta_en_empresa = conectar.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&empr_nrut&"'")
			esta_en_personas = conectar.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&empr_nrut&"'")
			if esta_en_personas <> "0" then
				pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&empr_nrut&"'")
				c_persona = " update personas set pers_tnombre = '"&empr_trazon_social&"', audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(pers_nrut as varchar)='"&empr_nrut&"'"
			end if	
			if esta_en_empresa <> "0" then
				c_empresa = " update empresas set empr_trazon_social='"&empr_trazon_social&"',empr_tdireccion='"&empr_tdireccion&"',"&_
							" ciud_ccod="&ciud_ccod&",empr_tfono='"&empr_tfono&"',empr_tfax='"&empr_tfax&"',empr_tgiro='"&empr_tgiro&"',"&_
							" empr_tejecutivo='"&empr_tejecutivo&"',empr_temail_ejecutivo='"&empr_temail_ejecutivo&"', audi_tusuario='"&usuario&"', audi_fmodificacion=getDate() where cast(empr_nrut as varchar)='"&empr_nrut&"'"
			end if
		end if
		'response.Write("<br>"&c_persona)
		'response.Write("<br>"&c_empresa)
		'response.End()
conectar.ejecutaS c_persona
conectar.ejecutaS c_empresa
				
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
