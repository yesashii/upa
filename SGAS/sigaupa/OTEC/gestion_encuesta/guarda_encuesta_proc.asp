<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()


'response.End()
set formulario = new CFormulario
formulario.Carga_Parametros "administra_encuesta.xml", "f_conculusiones"
formulario.Inicializar conexion
formulario.ProcesaForm		
for fila = 0 to formulario.CuentaPost - 1	

preliminares =formulario.ObtenerValorPost (fila,"preliminares")
finales = formulario.ObtenerValorPost (fila,"finales")
acciones=formulario.ObtenerValorPost (fila,"acciones")
dcur_ncorr=formulario.ObtenerValorPost (fila,"dcur_ncorr")
'Response.Write("<br> dcur_ncorr :"&dcur_ncorr)
'Response.Write("<br> mote_ccod :"&mote_ccod)
'Response.Write("<br> activa :"&activa)


	
		    existe=conexion.ConsultaUno("select count(*) from informe_conclusione_encuesta_otec where dcur_ncorr="&dcur_ncorr&"")
		 	
			 if existe=0 then
			 	iceo_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'iceo_ncorr'")
				
			 	Sinsert="insert into informe_conclusione_encuesta_otec (iceo_ncorr,dcur_ncorr,iceo_preliminares,iceo_acciones,iceo_finales,AUDI_TUSUARIO,AUDI_FMODIFICACION) values ("&iceo_ncorr&","&dcur_ncorr&",'"&preliminares&"','"&acciones&"','"&finales&"','"&usuario&"',getdate())"
				response.Write("<br>"&Sinsert)
				conexion.ejecutaS(Sinsert)
			 else 
			 
			    Supdate="update informe_conclusione_encuesta_otec set iceo_preliminares='"&preliminares&"',iceo_finales='"&finales&"',iceo_acciones='"&acciones&"', audi_tusuario='"&usuario&"',audi_fmodificacion=getdate() where dcur_ncorr="&dcur_ncorr&""
			   response.Write("<br>"&Supdate)
				conexion.ejecutaS(Supdate)
			 end if
		
		'conexion.ejecutas(Sinsert)
		

next

resultado=conexion.ObtenerEstadoTransaccion
'response.Write("<br>"&resultado)
'response.End()

'if conexion.ObtenerEstadoTransaccion  then
'	session("mensajeError")="Los Anexos selecionados fueron anulados correctamente "
'else
'	session("mensajeError")="Ocurrio un error al intentar anular uno o mas anexos para este contrato."
'end if
'response.End()
response.Redirect("informe.asp?dcur_ncorr="&dcur_ncorr&"")
%>