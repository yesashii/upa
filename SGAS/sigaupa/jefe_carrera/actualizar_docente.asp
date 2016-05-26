<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			: ACTUALIZA LOS DATOS PERSONALES Y DE CURRICULUM DOCENTE
'FECHA CREACIÓN			:
'CREADO POR				:
'ENTRADA				: NA
'SALIDA				    : NA
'MODULO ASOCIADO		: Recursos Humanos
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 18/07/2013
'ACTUALIZADO POR			: MARIO RIFFO.
'MOTIVO				        : Agregar nuevo campo (Tipo Jornada) 
'********************************************************************

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

pagina = request.Form("pag")
pers_ncorr = request.Form("pers_ncorr")
pers_nrut = request.Form("pers_nrut")
nombre =request.form("m[0][pers_tnombre]")
v_usuario = mid(nombre,1,1)&request.Form("m[0][pers_tape_paterno]")
v_clave = request.Form("m[0][pers_nrut]")
v_tipo_profesor=request.Form("m[0][tpro_ccod]")
v_jdoc_ccod=request.Form("m[0][jdoc_ccod]")
v_anio_ingreso=request.Form("m[0][prof_ingreso_uas]")
tido_ccod=request.Form("m[0][tido_ccod]")
cargo_directivo=request.Form("m[0][cargo_directivo]")
facu_ccod=request.Form("m[0][facu_ccod]")
vire_ccod=request.Form("m[0][vire_ccod]")
v_tjdo_ccod=request.Form("m[0][tjdo_ccod]")
'v_prof_nporcentaje_colacion=request.Form("m[0][prof_nporcentaje_colacion]")
'v_mcol_ncorr=request.Form("m[0][mcol_ncorr]")


'response.Write("USUARIO : "&v_usuario&"<----<BR>")
'RESPONSE.Write("CLAVE : "&v_clave&"<br>")

'response.Write("vire_ccod : "&vire_ccod&"<----<BR>")

if esVacio(v_tipo_profesor) then
v_tipo_profesor=1
end if

set conectar = new CConexion
set negocio = new cNegocio
set formulario = new CFormulario
set formulario_sedes = new CFormulario

conectar.Inicializar "upacifico"
negocio.inicializa conectar
if isnull(pers_ncorr) or isempty(pers_ncorr) or pers_ncorr="" then
	pers_ncorr =conectar.consultauno("execute obtenersecuencia 'personas'")
end if
'response.Write("Pers_ncorr :" &pers_ncorr)
'response.End()


formulario.Carga_Parametros "editar_docente.xml", "edicion_docente"
formulario.Inicializar conectar

formulario_sedes.Carga_Parametros "editar_docente.xml", "sedes_profesor"
formulario_sedes.Inicializar conectar
'response.Write("<br> 1 estado:"&conectar.ObtenerEstadoTransaccion)
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
formulario.AgregaCampoFilaPost 0, "dire_tblock", formulario.ObtenerValorPost(0, "dire_tblock")
'formulario.AgregaCampoFilaPost 0, "tido_ccod", formulario.ObtenerValorPost(0, "tido_ccod")
'tido_ccod= = formulario.ObtenerValorPost (0, "tido_ccod")
'
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
'response.Write("<br> 2 estado:"&conectar.ObtenerEstadoTransaccion)
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
formulario_sedes.agregacampopost "tpro_ccod",v_tipo_profesor
'end if		
'response.Write("<hr>")
'formulario_sedes.listarpost
'response.Write("<hr>")

sql = "select count(*) from sis_usuarios  where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' "
'RESPONSE.Write(sql)
v_existe = conectar.consultauno(sql)
if v_existe = 0 then
'response.Write("entre a este if")
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
	formulario.AgregaCampoPost "SROL_NCORR" , 3
	formulario.AgregaCampoPost "SRUS_FMODIFICACION" , conectar.consultaUno("select convert(varchar,getDate(),103)")
end if 	
formulario.AgregaCampoPost "SROL_NCORR" , 3
formulario.MantieneTablas false
formulario_sedes.MantieneTablas false
'response.Write("<br> 3 estado:"&conectar.ObtenerEstadoTransaccion)

'--------------------------Agregado para generar registros en las tablas profesores y sis_sedes_usuarios para cada una de las secciones del sistema
'--------------------------------------------------------------Agregado por M. Sandoval 03-03-2005-------------------------------------------------

consulta_insert_profesores = "INSERT INTO profesores(SEDE_CCOD, PERS_NCORR, TPRO_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION) "&_
                             " select distinct a.sede_ccod,"& pers_ncorr&","&v_tipo_profesor&", '"&negocio.obtenerUsuario&"', getdate()  from sedes a "&_
							 " where not exists (select 1 from profesores b where "&_
							 " cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and b.sede_ccod=a.sede_ccod)"

consulta_insert_sis_roles_usuarios=" INSERT INTO sis_sedes_usuarios(PERS_NCORR,SEDE_CCOD,AUDI_TUSUARIO, AUDI_FMODIFICACION) "&_
								   " select distinct "&pers_ncorr&",a.sede_ccod,'"&negocio.obtenerUsuario&"', getdate()  from sedes a "&_ 
								   " where not exists (select 1 from sis_sedes_usuarios b where "&_
								   " cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and b.sede_ccod=a.sede_ccod) "
'response.Write("<br>"&consulta_insert_profesores)
'response.Write("<br> 5 estado:"&conectar.ObtenerEstadoTransaccion)
conectar.ejecutaS consulta_insert_profesores
'response.Write("<br>"&consulta_insert_sis_roles_usuarios)
conectar.ejecutaS consulta_insert_sis_roles_usuarios
'--------------------------------------------------------------------------------------------------------------------------------------------------
'conectar.estadotransaccion false
'response.End()

anos_ccod=conectar.consultaUno("select datepart(yyyy,getdate())")
existe =conectar.consultaUno("select case count(pers_ncorr) when 0 then 'N'else 'S'end from anos_tipo_docente where pers_ncorr="&pers_ncorr&"")
modificacion=conectar.consultaUno("select getdate()")
usu=negocio.obtenerUsuario
'response.Write(existe)
if existe="N" then
	atid_ncorr=conectar.consultaUno("exec ObtenerSecuencia 'anos_tipo_docente'")
	if cstr(facu_ccod)="" then
		facu_ccod="NULL"
	end if
	if cstr(vire_ccod)="" then
		vire_ccod="NULL"
	end if
	inse_ano_tipo_docente="insert into anos_tipo_docente (atid_ncorr,tido_ccod,pers_ncorr,cargo_directivo,vire_ccod,facu_ccod,audi_fmodificacion,audi_tusuario) values ("&atid_ncorr&","&tido_ccod&","&pers_ncorr&",'"&cargo_directivo&"',"&vire_ccod&","&facu_ccod&",getdate(),'"&usu&"')"
		'response.Write(inse_ano_tipo_docente)
	conectar.ejecutaS inse_ano_tipo_docente
else
	if cstr(facu_ccod)="" or cstr(tido_ccod)="1" then
		facu_ccod="NULL"
	end if
	if cstr(vire_ccod)="" or cstr(tido_ccod)="1" then
		vire_ccod="NULL"
	end if
	atid_ncorr =conectar.consultaUno("select atid_ncorr from anos_tipo_docente where pers_ncorr="&pers_ncorr&"")
	
	upt_ano_tipo_docente="update anos_tipo_docente  set tido_ccod="&tido_ccod&",cargo_directivo='"&cargo_directivo&"',vire_ccod="&vire_ccod&",facu_ccod="&facu_ccod&",audi_fmodificacion=getdate(),audi_tusuario='"&usu&"' where atid_ncorr="&atid_ncorr&" "
		response.Write(upt_ano_tipo_docente)
	conectar.ejecutaS upt_ano_tipo_docente
end if 
'response.Write("<br> 6 estado:"&conectar.ObtenerEstadoTransaccion)
'response.end()
'---------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------
'########## AGREGAR JERARQUIA A TODAS LAS SEDES ##############
if v_jdoc_ccod<>"" then
	sql_actualiza_jerarquia="Update profesores set jdoc_ccod="&v_jdoc_ccod&" , prof_ingreso_uas= case '"&v_anio_ingreso&"' when '' then null else "&v_anio_ingreso&" end where pers_ncorr="&pers_ncorr
	'response.Write("<hr>"&sql_actualiza_jerarquia&"<hr>")
	conectar.ejecutaS sql_actualiza_jerarquia
end if

'########## AGREGAR TIPO DOCENTE A TODAS LAS SEDES ##############
if v_tjdo_ccod<>"" then
	sql_actualiza_jornada="Update profesores set tjdo_ccod="&v_tjdo_ccod&" where pers_ncorr="&pers_ncorr
	'response.Write("<hr>"&sql_actualiza_jornada&"<hr>")
	conectar.ejecutaS sql_actualiza_jornada
end if

'response.Write("<br> 7 estado:"&conectar.ObtenerEstadoTransaccion)
'conectar.estadotransaccion false
'response.End()

'response.End()
url="paso.asp?pers_nrut=" & pers_nrut&"&pagina=" & pagina
'response.Write(url)
'response.End()
response.Redirect(url)
%>