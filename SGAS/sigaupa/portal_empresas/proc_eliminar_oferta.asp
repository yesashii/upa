<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


'-----------------------------------------------------------

	for each k in request.form'
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_elimina = new CFormulario
f_elimina.Carga_Parametros "empresa.xml", "elimina_oferta"
f_elimina.Inicializar conectar
f_elimina.ProcesaForm

for filai = 0 to f_elimina.CuentaPost - 1


ofta_ncorr=f_elimina.ObtenerValorPost (filai, "ofta_ncorr")

consulta="update  ofertas_laborales set ofta_estado=3 where ofta_ncorr="&ofta_ncorr&""
conectar.ejecutaS (consulta)
'response.Write("<br/>"&consulta)

next

'existe=conexion.ConsultaUno(consulta)

'response.Write("<br/>existe="&consulta)
'response.End()
'if existe="S" then
'session("rut_usuario") = login	
response.Redirect("ofertas.asp")
'
'elseif existe="N" then
'session("mensajeerror") = "El Usuario o Clave son incorrectos"
'response.Redirect("portada_empresa.asp")
'response.Write("<br/>aqui se devuelve")
'end if
 %>