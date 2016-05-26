<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_empresa.asp" -->
<%


	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()
'Session.Contents.RemoveAll()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "empresa.xml", "publica_2"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

ofta_ncorr= f_agrega.ObtenerValorPost (filai, "ofta_ncorr")
LISTADOCARRERA= f_agrega.ObtenerValorPost (filai, "LISTADOCARRERA")
anos_experiencia= f_agrega.ObtenerValorPost (filai, "anos_experiencia")
operador_experiencia= f_agrega.ObtenerValorPost (filai, "operador_experiencia")
estudio_minimo= f_agrega.ObtenerValorPost (filai, "estudio_minimo")
situacion_estudio= f_agrega.ObtenerValorPost (filai, "situacion_estudio")
requisitos_minimos= f_agrega.ObtenerValorPost (filai, "requisitos_minimos")
LISTADOIDIOMAS= f_agrega.ObtenerValorPost (filai, "LISTADOIDIOMAS")
LISTADOPROGRAMAS= f_agrega.ObtenerValorPost (filai, "LISTADOPROGRAMAS")
conocimiento_comp= f_agrega.ObtenerValorPost (filai, "conocimiento_comp")
pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")

sql_update="update ofertas_laborales" & vbCrLf &_
"set ofta_nexperiencia="&anos_experiencia&" ,ofta_operador_nexperiencia="&operador_experiencia&" ,ofta_grado_educacional="&estudio_minimo&" ,ofta_situacion_estudio="&situacion_estudio&" ,ofta_requisitos_minimos='"&requisitos_minimos&"' ,ofta_conoci_comp="&conocimiento_comp&" ,audi_fmodificacion= getdate(),ofta_estado='2' "& vbCrLf &_
"where ofta_ncorr="&ofta_ncorr&" "

response.write("<br>"&sql_update)
conectar.ejecutaS (sql_update)

empr_ncorr=conectar.ConsultaUno("select empr_ncorr from ofertas_laborales where ofta_ncorr="&ofta_ncorr&"")
'-------------------------------obtiene la o las carreras selecionadas-----------------------------------------------------
arr_carera = split(LISTADOCARRERA,"|")
for i = 0 to ubound(arr_carera)
carr_ccod =arr_carera(i)

caof_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'carreras_ofertas_laborales'")

insert_carrera="insert into carreras_ofertas_laborales(ofta_ncorr,empr_ncorr,caof_ncorr,carr_ccod,audi_fmodificacion,audi_tusuario)"& vbCrLf &_
"values("&ofta_ncorr&","&empr_ncorr&","&caof_ncorr&","&carr_ccod&",getdate(),'"&pers_nrut&"')"
 conectar.ejecutaS (insert_carrera)
response.write("<br>"&insert_carrera&"<br>")
next

'---------------------------------obtiene el o los  idiomas selecionados y el nivel y si lee, escribe o habla ------------------------------------------------------
'---obtengo el arreglo separando los idiomas 
arr_idiomas=split(LISTADOIDIOMAS,"|")

for i = 0 to ubound(arr_idiomas)

' una ves separado los idiomas separo las opciones selecionadas para cada idioma
idioma_otros =arr_idiomas(i)

idiomas_mas_detalles=split(idioma_otros,",")

for ii = 0 to ubound(idiomas_mas_detalles)
resultado =idiomas_mas_detalles(ii)
if ii=0 then
idio_ccod=resultado
'response.write("<br>idioma selecionado="&idio_ccod&"<br>")
elseif ii=1 then
nive_ccod=resultado
'response.write("<br>nivel selecionado="&nive_ccod&"<br>")
elseif ii=2 then
h=resultado
'response.write("<br>habla="&habla&"<br>")
elseif ii=3 then
lee=resultado
'response.write("<br>lee="&lee&"<br>")
elseif ii=4 then
escribe=resultado
'response.write("<br>escribe="&escribe&"<br>")
end if

next
idof_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'idiomas_ofertas_laborales'")

insert_cidioma="insert into idiomas_ofertas_laborales (ofta_ncorr,empr_ncorr,idof_ncorr,idio_ccod,nive_ccod,habla,lee,escribe,audi_fmodificacion,audi_tusuario)"& vbCrLf &_
"values("&ofta_ncorr&","&empr_ncorr&","&idof_ncorr&","&idio_ccod&","&nive_ccod&","&h&","&lee&","&escribe&",getdate(),'"&pers_nrut&"')"

response.write("<br>"&insert_cidioma&"<br>")
conectar.ejecutaS (insert_cidioma)

next

'---------------------------------obtiene el o los  programas selecionados y el nivel ------------------------------------------------------
'---obtengo el arreglo separando los idiomas 
arr_programas=split(LISTADOPROGRAMAS,"|")

for ss = 0 to ubound(arr_programas)

' una ves separado los idiomas separo las opciones selecionadas para cada idioma
programas_otros =arr_programas(ss)

programas_mas_detalles=split(programas_otros,",")

for sss = 0 to ubound(programas_mas_detalles)
resultado =programas_mas_detalles(sss)

if sss=0 then
soft_ccod=resultado
'response.write("<br>idioma selecionado="&idio_ccod&"<br>")
elseif sss=1 then
nive_ccod=resultado
'response.write("<br>nivel selecionado="&nive_ccod&"<br>")
end if
next
soof_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'software_ofertas_laborales'")

insert_cprograma="insert into software_ofertas_laborales (ofta_ncorr,empr_ncorr,soof_ncorr,soft_ccod,nive_ccod,audi_fmodificacion,audi_tusuario)"& vbCrLf &_
"values("&ofta_ncorr&","&empr_ncorr&","&soof_ncorr&","&soft_ccod&","&nive_ccod&",getdate(),'"&pers_nrut&"')"

response.write("<br>"&insert_cprograma&"<br>")
conectar.ejecutaS (insert_cprograma)


next
'---------------------------------------------------------------------------------------

next



'response.End()
'Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'sresponse.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect("salida_oferta_laboral.asp")
 %>