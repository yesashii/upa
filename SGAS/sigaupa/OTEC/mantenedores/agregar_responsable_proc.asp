<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

pers_nrut=request.form("a[0][pers_nrut]")
pers_xdv=request.form("a[0][pers_xdv]")
email=request.form("a[0][email]")
UDPO_ccod=request.form("a[0][UDPO_ccod]")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set conexion2 = new CConexion
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion

pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&pers_nrut&")")

existe=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end from responsable_unidad where pers_ncorr="&pers_ncorr&" and udpo_ccod="&UDPO_ccod&"")

if existe="N" then
		
		reun_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'responsable_unidad'")
		Sinsert=" insert into responsable_unidad (reun_ncorr,pers_ncorr,udpo_ccod,esre_ccod,audi_tusuario,audi_fmodificacion) "& vbCrlf & _
		"values ("&reun_ncorr&","&pers_ncorr&","&UDPO_ccod&",'1','"&usu&"',getdate())"
						'response.Write("<br>"&Sinsert)
						conexion.ejecutaS(Sinsert)
		
		resultado=conexion.ObtenerEstadoTransaccion
		
		Sinsert2="insert into correo_responsables_otec (pers_ncorr,email_upa) values("&pers_ncorr&",'"&email&"')"
		conexion2.ejecutaS(Sinsert2)	
		
		'response.Write("<br>"&resultado)
		'response.End()
		
		if conexion.ObtenerEstadoTransaccion  then
			session("mensajeError")="El responsable se ha Agregado"
		else
			session("mensajeError")="El responsable no se ha Guardado."
		end if
'response.End()
else
session("mensajeError")="La personas ya fue ingresada para la unidad selecionada."
end if
response.Redirect("responsable_unidad.asp")				
'%>


