<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

activa_programa=request.Form("mot[0][b_activa_programa]")
if activa_programa="on" then
act_pro="1"
else
act_pro="0"
end if
'esponse.End()
set formulario = new CFormulario
formulario.Carga_Parametros "administra_encuesta.xml", "f_programas"
formulario.Inicializar conexion
formulario.ProcesaForm		
for fila = 0 to formulario.CuentaPost - 1	

dcur_ncorr =formulario.ObtenerValorPost (fila,"dcur_ncorr")
mote_ccod = formulario.ObtenerValorPost (fila,"mote_ccod")
activa=formulario.ObtenerValorPost (fila,"b_activa")
'Response.Write("<br> dcur_ncorr :"&dcur_ncorr)
'Response.Write("<br> mote_ccod :"&mote_ccod)
'Response.Write("<br> activa :"&activa)

	if activa="1" then
	
		    existe=conexion.ConsultaUno("select count(*) from autoriza_encuesta_otec where dcur_ncorr="&dcur_ncorr&" and mote_ccod='"&mote_ccod&"'")
		 	
			 if existe="0" then
			 	aeot_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'aeot_ncorr'")
				
			 	Sinsert="insert into autoriza_encuesta_otec (aeot_ncorr,dcur_ncorr,mote_ccod,audi_tusuario,audi_fmodificacion) values ("&aeot_ncorr&","&dcur_ncorr&",'"&mote_ccod&"','"&usuario&"',getdate())"
				'response.Write("<br>"&Sinsert)
				conexion.ejecutaS(Sinsert)
			 end if
	else 
			
			existe=conexion.ConsultaUno("select count(*) from autoriza_encuesta_otec where dcur_ncorr="&dcur_ncorr&" and mote_ccod='"&mote_ccod&"'")
				
			  if existe<>"0" then
					Supdate="delete from autoriza_encuesta_otec where dcur_ncorr="&dcur_ncorr&" and mote_ccod='"&mote_ccod&"'"
					
					'response.Write("<br>"&Supdate)
					conexion.ejecutaS(Supdate)
			  end if	
	end if
	
'conexion.ejecutas(Sinsert)
		

next

	if act_pro="1" then
	
		    existeT=conexion.ConsultaUno("select count(*) from activa_encuesta_infra_progra where dcur_ncorr="&dcur_ncorr&"")
		 	
			 if existeT="0" then
				
			 	Sinsert_t="insert into activa_encuesta_infra_progra (dcur_ncorr,audi_tusuario,audi_fmodificacion) values ("&dcur_ncorr&",'"&usuario&"',getdate())"
				'response.Write("<br>"&Sinsert_t)
				conexion.ejecutaS(Sinsert_t)
			 end if
	else 
			
			existeT=conexion.ConsultaUno("select count(*) from activa_encuesta_infra_progra where dcur_ncorr="&dcur_ncorr&"")
				
			  if existeT<>"0" then
					Supdatet="delete from activa_encuesta_infra_progra where dcur_ncorr="&dcur_ncorr&""
					
					'response.Write("<br>"&Supdatet)
					conexion.ejecutaS(Supdatet)
			  end if	
	end if

resultado=conexion.ObtenerEstadoTransaccion
'response.Write("<br>"&resultado)
'response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Cambios han sido guardados correctamente"
else
	'session("mensajeError")="Ocurrio un error al intentar anular uno o mas anexos para este contrato."
end if
'response.End()
response.Redirect("habilita.asp?dcur_ncorr="&dcur_ncorr&"")
%>