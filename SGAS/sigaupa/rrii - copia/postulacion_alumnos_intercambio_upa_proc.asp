<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next

'response.End()
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

usu=negocio.ObtenerUsuario()




set f_agrega = new CFormulario
f_agrega.Carga_Parametros "alumnos_intercambio_upa.xml", "postulacion_proc"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1


pers_ncorr= f_agrega.ObtenerValorPost (filai, "pers_ncorr")
tdin_ccod= f_agrega.ObtenerValorPost (filai, "tdin_ccod")
'response.Write(tdin_ccod&"<br>")



idio_ccod= f_agrega.ObtenerValorPost (filai, "idio_ccod")
nidi_ccod= f_agrega.ObtenerValorPost (filai, "nidi_ccod")
peri_ccod= f_agrega.ObtenerValorPost (filai, "peri_ccod")
paiu_ncorr= f_agrega.ObtenerValorPost (filai, "paiu_ncorr")
paiu_fvuelta_upa= f_agrega.ObtenerValorPost (filai, "paiu_fvuelta_upa")
PAIS_CCOD= f_agrega.ObtenerValorPost (filai, "PAIS_CCOD")
CIEX_CCOD= f_agrega.ObtenerValorPost (filai, "CIEX_CCOD")
UNIV_CCOD= f_agrega.ObtenerValorPost (filai, "UNIV_CCOD")
cpiu_tnombre= f_agrega.ObtenerValorPost (filai, "cpiu_tnombre")
pare_ccod= f_agrega.ObtenerValorPost (filai, "pare_ccod")
cpiu_tdireccion= f_agrega.ObtenerValorPost (filai, "cpiu_tdireccion")
cpiu_tfono= f_agrega.ObtenerValorPost (filai, "cpiu_tfono")
cpiu_tfax= f_agrega.ObtenerValorPost (filai, "cpiu_tfax")
cpiu_temail= f_agrega.ObtenerValorPost (filai, "cpiu_temail")
paiu_temail=f_agrega.ObtenerValorPost (filai, "paiu_temail")
'response.write("<br>"&blsi_ncorr)
if cint(tdin_ccod)<3 then
peri_ccod_fin=peri_ccod
else
peri_ccod_fin= f_agrega.ObtenerValorPost (filai, "peri_ccod_fin")
end if
if EsVacio(paiu_ncorr) then
paiu_ncorr="NULL"
end if

if EsVacio(nidi_ccod) or nidi_ccod="" then
nidi_ccod=0
end if

query_exec="exec PostularAlumnoIntercambioUPa "&pers_ncorr&","&paiu_ncorr&" ,"&idio_ccod&","&nidi_ccod&" ,'"&paiu_fvuelta_upa&"' ,"&PAIS_CCOD&" ,"&CIEX_CCOD&" ,"&UNIV_CCOD&" ,'"&cpiu_tnombre&"' ,"&pare_ccod&" ,'"&cpiu_tdireccion&"','"&cpiu_tfono&"' ,'"&cpiu_tfax&"','"&cpiu_temail&"' ,"&tdin_ccod&" ,1 ,"&peri_ccod&","&peri_ccod_fin&",'"&paiu_temail&"' "
'response.write("<br>"&query_exec)
resul=conectar.ConsultaUno(query_exec)

'response.write("<br>"&resul)
'response.End()

		
next

'response.End()
'----------------------------------------------------
'response.Write("respuesta "&resul)

if resul="1" then
session("mensajeerror")= "La postulacion se ha guardado Correctamente"
else
 session("mensajeerror")= "Hubo un error al guardar"
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("postulacion_alumnos_intercambio_upa.asp")
 %>