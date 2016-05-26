<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if




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


existe=conexion.ConsultaUno("select case count(pers_ncorr)when 0 then 's'else 'n' end from personas where pers_nrut="&pers_nrut&"")

if existe ="s"then
pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas_postulante where pers_nrut="&pers_nrut&"")

	update_persona	="update personas_postulante set pers_tape_paterno='"&pers_tape_paterno&"',pers_tape_materno='"&pers_tape_materno&"',pers_tnombre='"&pers_tnombre&"',eciv_ccod="&eciv_ccod&" where pers_nrut="&pers_nrut&"" 
	conexion.ejecutaS (update_persona)
	
	insert_grupo="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
	conexion.ejecutaS (insert_grupo)

insert_coudeudor="insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod)values ("&post_ncorr&","&pers_ncorr&","&pare_ccod&")"
conexion.ejecutaS (insert_coudeudor)
else
pers_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'personas'")

insert_personas="insert into personas (pers_ncorr,pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_fnacimiento,eciv_ccod)"& vbCrLf &_
				"values ("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&pers_tnombre&"',"&eciv_ccod&")"
	 conexion.ejecutaS (insert_personas)			

insert_grupo="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values ("&post_ncorr&","&v_pers_ncorr&","&pare_ccod&")"
conexion.ejecutaS (insert_grupo)
insert_coudeudor="insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod)values ("&post_ncorr&","&v_pers_ncorr&","&pare_ccod&")"
conexion.ejecutaS (insert_coudeudor)
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

				
							

if existe ="s" then 
update_dire="update direcciones_publica set ciud_ccod="&ciud_ccod&",dire_tcalle='"&dire_tcalle&"',dire_tnro='"&dire_tnro&"' where pers_ncorr="&pers_ncorr&""
conexion.ejecutaS (update_dire)
else
insert_dire="insert into direcciones_publica (tdir,pers_ncorr,ciud_ccod,dire_tcalle,dire_tnro)values (1,"&pers_ncorr&","&ciud_ccod&",'"&dire_tcalle&"','"&dire_tnro&"')"	
conexion.ejecutaS (insert_dire)			
end if
next





response.Write("<pre>"&insert_personas&"</pre>")
response.Write("<pre>"&insert_grupo&"</pre>")
response.Write("<pre>"&update_persona&"</pre>")
response.Write("<pre>"&insert_coudeudor&"</pre>")
response.Write("<pre>"&insert_dire&"</pre>")
response.Write("<pre>"&update_dire&"</pre>")
'-------------------------------------------------------------------------------------------------
'Function ObtenerPersNCorr(p_pers_nrut, conexion)
'	dim consulta, v_pers_ncorr
'	consulta = "select pers_ncorr from personas_postulante where pers_nrut = '" & p_pers_nrut & "'"	
'	v_pers_ncorr = conexion.ConsultaUno(consulta)	
'	
'	if EsVacio(v_pers_ncorr) then
'		consulta = "select pers_ncorr from personas where pers_nrut = '" & p_pers_nrut & "'"	
'		v_pers_ncorr = conexion.ConsultaUno(consulta)
'	end if
'	
'	if EsVacio(v_pers_ncorr) then
'		consulta = "Exec ObtenerSecuencia 'personas'"
'		v_pers_ncorr = conexion.ConsultaUno(consulta)
'	end if
'	
'	ObtenerPersNCorr = v_pers_ncorr	
'End Function
'
'
'set conexion = new CConexion
'conexion.Inicializar "upacifico"
'
''conexion.EstadoTransaccion false
'
''-------------------------------------------------------------------------------------------------
'set f_codeudor = new CFormulario
'f_codeudor.Carga_Parametros "postulacion_5.xml", "codeudor"
'f_codeudor.Inicializar conexion
'f_codeudor.ProcesaForm
'
'
'set f_direcciones = new CFormulario
'f_direcciones.Carga_Parametros "postulacion_5.xml", "direcciones"
'f_direcciones.Inicializar conexion
'f_direcciones.ProcesaForm
'
'
''-------------------------------------------------------------------------------------------------	
'v_pers_ncorr = ObtenerPersNCorr(f_codeudor.ObtenerValorPost(0, "pers_nrut"), conexion)	
'
'f_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr
'f_codeudor.AgregaCampoPost "tdir_ccod", "1"
'f_codeudor.AgregaCampoPost "pers_tfono", f_codeudor.ObtenerValorPost(0, "dire_tfono")
'
'f_codeudor.MantieneTablas False
'
'
'
'f_direcciones.AgregaCampoPost "pers_ncorr", v_pers_ncorr
'f_direcciones.AgregaCampoPost "tdir_ccod", "3"
'f_direcciones.AgregaCampoPost "dire_tcalle", f_direcciones.ObtenerValorPost (0, "dire_tcalle_empresa")
'f_direcciones.AgregaCampoPost "dire_tnro", f_direcciones.ObtenerValorPost (0, "dire_tnro_empresa")
'f_direcciones.AgregaCampoPost "dire_tpoblacion", f_direcciones.ObtenerValorPost (0, "dire_tpoblacion_empresa")
'f_direcciones.AgregaCampoPost "dire_tfono", f_direcciones.ObtenerValorPost (0, "dire_tfono_empresa")
'f_direcciones.AgregaCampoPost "ciud_ccod", f_direcciones.ObtenerValorPost (0, "ciud_ccod_empresa")
'
'f_direcciones.MantieneTablas False


'---------------------------------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	url = "post_cerrada.asp"
else
	url = "postulacion_6.asp"
end if
'---------------------------------------------------------------------------------------------------------------
Response.Redirect(url)
%>
