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

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "crea_modulos_sicologos.xml", "actualiza_estado_bloque"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm


contador=0

for filai = 0 to f_agrega.CuentaPost - 1

contador=contador+1

blsi_ncorr = f_agrega.ObtenerValorPost (filai, "blsi_ncorr")
'response.write("<br>"&blsi_ncorr)

actualizar="update bloques_sicologos set ebsi_ccod=1 where blsi_ncorr="&blsi_ncorr&""

'response.write("<br>"&actualizar)

conectar.ejecutaS(actualizar)


if contador=1 then
s_sede="select sede_tdesc "& vbcrlf & _
" from bloques_sicologos a,"& vbcrlf & _
" sicologos_sede b,"& vbcrlf & _
" sedes c"& vbcrlf & _
" where a.side_ncorr=b.side_ncorr"& vbcrlf & _
" and b.sede_ccod=c.SEDE_CCOD"& vbcrlf & _
" and  blsi_ncorr="&blsi_ncorr&""

sede=conectar.consultaUno(s_sede)
end if

next

'response.End()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


'if Respuesta = true then
'session("mensajeerror")= " El Taller fue Actualizado con Éxito"
'else
 session("mensajeerror")= "EL Horario para la sede "&sede&" esta disponible para los alumnos"
'end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("crear_modulos_sicologos.asp")
%>


