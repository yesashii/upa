<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_post_ncorr = Session("post_ncorr")

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if
 
'-------------------------------------------------------------------------------------------------



set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

'-------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "postulacion_5.xml", "codeudor"
f_codeudor.Inicializar conexion
f_codeudor.ProcesaForm
for fila = 0 to f_codeudor.CuentaPost - 1

pare_ccod = f_codeudor.ObtenerValorPost (fila, "pare_ccod")
pers_nrut = f_codeudor.ObtenerValorPost (fila, "pers_nrut")
pers_xdv = f_codeudor.ObtenerValorPost (fila, "pers_xdv")
pers_tape_paterno = f_codeudor.ObtenerValorPost (fila, "pers_tape_paterno")
pers_tape_materno = f_codeudor.ObtenerValorPost (fila, "pers_tape_materno")
pers_tnombre = f_codeudor.ObtenerValorPost (fila, "pers_tnombre")
pers_tmail = f_codeudor.ObtenerValorPost (fila, "pers_tmail")
eciv_ccod = f_codeudor.ObtenerValorPost (fila, "eciv_ccod")
post_ncorr = f_codeudor.ObtenerValorPost (fila, "post_ncorr")
pers_fnacimiento = f_codeudor.ObtenerValorPost (fila, "pers_fnacimiento")

existe=conexion.ConsultaUno("select case count(pers_ncorr) when 0 then 'n' else 's' end from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
existe_pp=conexion.ConsultaUno("select case count(pers_ncorr) when 0 then 'n' else 's' end from personas_postulante where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	if existe ="s" or existe_pp = "s" then
		pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&pers_nrut&"'")
		existe_gf =conexion.ConsultaUno("select case count(pers_ncorr) when 0 then 'n' else 's' end from grupo_familiar where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(post_ncorr as varchar)='"&post_ncorr&"'")
  		existe_cp =conexion.ConsultaUno("select case count(pers_ncorr) when 0 then 'n' else 's' end from codeudor_postulacion where cast(post_ncorr as varchar)='"&post_ncorr&"'")
	
		update_persona 	 = "update personas_postulante set pers_tape_paterno='"&pers_tape_paterno&"', pers_tape_materno='"&pers_tape_materno&"', pers_tnombre='"&pers_tnombre&"', eciv_ccod="&eciv_ccod&", pers_fnacimiento=convert(datetime,'"&pers_fnacimiento&"',103) where cast(pers_nrut as varchar)='"&pers_nrut&"'" 
		conexion.ejecutaS (update_persona)
		if existe_gf = "n" and pare_ccod <> "0" then
			insert_grupo = "insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
			conexion.ejecutaS (insert_grupo)
		end if
		if existe_cp = "n" then
			insert_coudeudor="insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod) values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
			conexion.ejecutaS (insert_coudeudor)
		else
			insert_coudeudor="update codeudor_postulacion set pers_ncorr ="&pers_ncorr&",pare_ccod= "&pare_ccod&" where cast(post_ncorr as varchar)='"&post_ncorr&"'"
			conexion.ejecutaS (insert_coudeudor)
		end if
			
	else
		pers_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'personas'")
  		existe_cp =conexion.ConsultaUno("select case count(pers_ncorr) when 0 then 'n' else 's' end from codeudor_postulacion where cast(post_ncorr as varchar)='"&post_ncorr&"'")

	
		insert_personas="insert into personas_postulante (pers_ncorr,pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_fnacimiento,eciv_ccod)"& vbCrLf &_
						"values ("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&pers_tnombre&"',convert(datetime,'"&pers_fnacimiento&"',103),"&eciv_ccod&")"
		conexion.ejecutaS (insert_personas)			
		
		insert_grupo="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
		conexion.ejecutaS (insert_grupo)
		if existe_cp = "n" then
			insert_coudeudor="insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod)values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
			conexion.ejecutaS (insert_coudeudor)
		else
			insert_coudeudor="update codeudor_postulacion set pers_ncorr ="&pers_ncorr&",pare_ccod= "&pare_ccod&" where cast(post_ncorr as varchar)='"&post_ncorr&"'"
			conexion.ejecutaS (insert_coudeudor)
		end if
	end if
next

set f_direcciones = new CFormulario
f_direcciones.Carga_Parametros "postulacion_5.xml", "direcciones"
f_direcciones.Inicializar conexion
f_direcciones.ProcesaForm
for filai = 0 to f_direcciones.CuentaPost - 1
	regi_ccod = f_direcciones.ObtenerValorPost (filai, "regi_ccod")
	ciud_ccod = f_direcciones.ObtenerValorPost (filai, "ciud_ccod")
	dire_tcalle = f_direcciones.ObtenerValorPost (filai, "dire_tcalle")
	dire_tnro = f_direcciones.ObtenerValorPost (filai, "dire_tnro")
	dire_tblock = f_direcciones.ObtenerValorPost (filai, "dire_tblock")
	dire_tpoblacion = f_direcciones.ObtenerValorPost (filai, "dire_tpoblacion")

	if existe ="s" or existe_pp="s" then 
		update_dire="update direcciones_publica set ciud_ccod="&ciud_ccod&",dire_tcalle='"&dire_tcalle&"',dire_tnro='"&dire_tnro&"' where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tdir_ccod=1 "
		conexion.ejecutaS (update_dire)
	else
		insert_dire="insert into direcciones_publica (tdir_ccod,pers_ncorr,ciud_ccod,dire_tcalle,dire_tnro) values (1,"&pers_ncorr&","&ciud_ccod&",'"&dire_tcalle&"','"&dire_tnro&"')"	
		conexion.ejecutaS (insert_dire)			
	end if
next

response.Write("<pre>"&insert_personas&"</pre>")
response.Write("<pre>"&insert_grupo&"</pre>")
response.Write("<pre>"&update_persona&"</pre>")
response.Write("<pre>"&insert_coudeudor&"</pre>")
response.Write("<pre>"&insert_dire&"</pre>")
response.Write("<pre>"&update_dire&"</pre>")
'response.End()
'response.End()
'-------------------------------------------------------------------------------------------------	
'---------------------------------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where cast(post_ncorr as varchar)= '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	url = "post_cerrada.asp"
else
	url = "postulacion_6_breve.asp"
end if
'---------------------------------------------------------------------------------------------------------------
Response.Redirect(url)
%>
