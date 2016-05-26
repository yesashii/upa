<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_empresa.asp" -->
<%


'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()
'Session.Contents.RemoveAll()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "empresa.xml", "publica_1"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

ofta_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'ofertas_laborales'")
empre_ncorr= f_agrega.ObtenerValorPost (filai, "empre_ncorr")
pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")
cargo= f_agrega.ObtenerValorPost (filai, "cargo")
vacantes= f_agrega.ObtenerValorPost (filai, "vacantes")
tipo_cargo= f_agrega.ObtenerValorPost (filai, "tipo_cargo")
area= f_agrega.ObtenerValorPost (filai, "area")
desc_oferta= f_agrega.ObtenerValorPost (filai, "desc_oferta")
jornada= f_agrega.ObtenerValorPost (filai, "jornada")
duracion_contrato= f_agrega.ObtenerValorPost (filai, "duracion_contrato")
salario= f_agrega.ObtenerValorPost (filai, "salario")
cometario_salario= f_agrega.ObtenerValorPost (filai, "cometario_salario")
fcaducidad_oferta= f_agrega.ObtenerValorPost (filai, "fcaducidad_oferta")
vigencia_oferta="NULL"
regi_ccod= f_agrega.ObtenerValorPost (filai, "regi_ccod")
ciud_ccod= f_agrega.ObtenerValorPost (filai, "ciud_ccod")
lugar_trabajo= f_agrega.ObtenerValorPost (filai, "lugar_trabajo")

if  salario="" then
salario=0
end if

insert="insert into ofertas_laborales"& vbCrLf &_
"(ofta_ncorr,empr_ncorr,ofta_cargo,ofta_nvacante,ofta_tipo_cargo,ofta_area,ofta_desc_oferta,ofta_jorn_laboral,ofta_duracion_contrato,ofta_salario,ofta_comentario_salario,ofta_fcaducidad_oferta,ofta_dias_vigencias,ofta_region,ofta_ciudad,ofta_lugar_trabajo,ofta_fcreacion,audi_tusuario,audi_fmodificacion,ofta_estado)"& vbCrLf &_
"values ("&ofta_ncorr&","&empre_ncorr&",'"&cargo&"','"&vacantes&"',"&tipo_cargo&",'"&area&"','"&desc_oferta&"',"&jornada&",'"&duracion_contrato&"',"&salario&",'"&cometario_salario&"','"&fcaducidad_oferta&"',"&vigencia_oferta&","&regi_ccod&","&ciud_ccod&",'"&lugar_trabajo&"',getdate(),'"&pers_nrut&"',getdate(),'1')"
next
response.Write("<br>"&insert)
conectar.ejecutaS (insert)
'Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("publica_2.asp?ofta_ncorr="&ofta_ncorr&"")
 %>