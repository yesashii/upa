<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pagina = request.Form("pag")
pers_ncorr = request.Form("pers_ncorr")
pers_nrut = request.Form("pers_nrut")
nombre =request.form("m[0][pers_tnombre]")
v_usuario = mid(nombre,1,1)&request.Form("m[0][pers_tape_paterno]")
v_clave = request.Form("m[0][pers_nrut]")
'response.Write("USUARIO : "&v_usuario&"<----<BR>")
'RESPONSE.Write("CLAVE : "&v_clave&"<br>")
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conectar = new CConexion
set negocio = new cNegocio
set formulario = new CFormulario
set formulario_sedes = new CFormulario

conectar.Inicializar "upacifico"
negocio.inicializa conectar
if isnull(pers_ncorr) or isempty(pers_ncorr) or pers_ncorr="" then
	pers_ncorr =conectar.consultauno("execute obtenersecuencia 'profesores'")
end if

'conectar.estadotransaccion false

formulario.Carga_Parametros "editar_docente.xml", "edicion_docente"
formulario.Inicializar conectar

formulario_sedes.Carga_Parametros "editar_docente.xml", "sedes_profesor"
formulario_sedes.Inicializar conectar

formulario_sedes.ProcesaForm
formulario.ProcesaForm
formulario.agregacampopost "pers_ncorr",pers_ncorr
formulario.ClonaFilaPost 0
formulario.AgregaCampoFilaPost 0, "tdir_ccod", "1"
formulario.AgregaCampoFilaPost 0, "ciud_ccod", formulario.ObtenerValorPost(0, "ciud_ccod")
formulario.AgregaCampoFilaPost 0, "dire_tcalle", formulario.ObtenerValorPost(0, "dire_tcalle")
formulario.AgregaCampoFilaPost 0, "dire_tnro", formulario.ObtenerValorPost(0, "dire_tnro")
formulario.AgregaCampoFilaPost 0, "dire_tpoblacion", formulario.ObtenerValorPost(0, "dire_tpoblacion")
formulario.AgregaCampoFilaPost 0, "dire_tfono", formulario.ObtenerValorPost(0, "pers_tfono")
formulario.AgregaCampoFilaPost 0, "dire_tblock", formulario.ObtenerValorPost(0, "dire_tblock")

formulario.AgregaCampoFilaPost 1, "tdir_ccod", "3"
formulario.AgregaCampoFilaPost 1, "ciud_ccod", formulario.ObtenerValorPost(0, "ciud_ccod_laboral")
formulario.AgregaCampoFilaPost 1, "dire_tcalle", formulario.ObtenerValorPost(0, "dire_tcalle_laboral")
formulario.AgregaCampoFilaPost 1, "dire_tnro", formulario.ObtenerValorPost(0, "dire_tnro_laboral")
formulario.AgregaCampoFilaPost 1, "dire_tpoblacion", formulario.ObtenerValorPost(0, "dire_tpoblacion_laboral")
formulario.AgregaCampoFilaPost 1, "dire_tfono", formulario.ObtenerValorPost(0, "dire_tfono_laboral")
formulario.AgregaCampoFilaPost 1, "dire_tblock", formulario.ObtenerValorPost(0, "dire_tblock_laboral")

set f_tabla = new CFormulario
f_tabla.Carga_Parametros "paulo.xml", "tabla"
f_tabla.Inicializar conectar
'response.Write("<hr>")
'formulario_sedes.listarpost
'response.Write("<hr>")

sql_sede_profesor = "select sede_ccod from profesores where cast(pers_ncorr as varchar) = '"&pers_ncorr&"'"
f_tabla.consultar sql_sede_profesor
nro_sedes_profesor = f_tabla.nrofilas
'if nro_sedes_profesor>0 then
'		formulario_sedes.ClonaFilaPost 0
'		response.Write("<h1> nro sedes :"&nro_sedes_profesor&"</h1>")
'		for i_=0 to nro_sedes_profesor -1
'		
'			f_tabla.siguiente
'			V_SEDE=f_tabla.ObtenerValor("sede_ccod")
'			response.Write("<h1> i"&i_&":"&V_SEDE&"</h1><br>")
'			formulario_sedes.AgregaCampoFilaPost i_, "sede_ccod", CINT(V_SEDE)
'		next
'else
formulario_sedes.agregacampopost "pers_ncorr",pers_ncorr
formulario_sedes.agregacampopost "sede_ccod" ,  negocio.obtenerSede
'end if		
'response.Write("<hr>")
'formulario_sedes.listarpost
'response.Write("<hr>")

sql = "select count(*) from sis_usuarios  where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' "
'RESPONSE.Write(sql)
v_existe = conectar.consultauno(sql)
if v_existe = 0 then
	contador=0
	sql_ver_usuario = "select count(*) from sis_usuarios where cast(susu_tlogin as varchar) = '"&v_usuario&"'"
	ver_usuario = conectar.consultauno(sql_ver_usuario)
	while ver_usuario >0
		contador = contador+1	
		v_usuario_paso = v_usuario&"0"&contador
		sql_ver_usuario = "select count(*) from sis_usuarios where cast(susu_tlogin as varchar) = '"&v_usuario_paso&"'"
		ver_usuario = conectar.consultauno(sql_ver_usuario)
		'RESPONSE.Write("v_usuario :"& v_usuario&"<BR>")
		'RESPONSE.Write("sql_ver_usuario : "&sql_ver_usuario&"<BR>")		
	wend
	if contador = 0 then
		formulario.AgregaCampoPost "susu_tlogin" , v_usuario
	else
		formulario.AgregaCampoPost "susu_tlogin" , v_usuario&"0"&contador
	end if 
	formulario.AgregaCampoPost "susu_tclave" , v_clave
	formulario.AgregaCampoPost "SROL_NCORR" , "3"
end if 	

formulario.MantieneTablas false
formulario_sedes.MantieneTablas false


url="paso.asp?pers_nrut=" & pers_nrut&"&pagina=" & pagina
'response.Write(url)
response.Redirect(url)
%>