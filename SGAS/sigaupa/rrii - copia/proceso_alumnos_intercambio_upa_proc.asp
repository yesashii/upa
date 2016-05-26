<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()
peri_ccod=request.form("peri_ccod")
ciex_ccod=request.form("ciex_ccod")
univ_ccod=request.form("univ_ccod")
pers_nrut=request.form("pers_nrut")
pers_xdv=request.form("pers_xdv")
pais_ccod=request.form("pais_ccod")

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

usu=negocio.obtenerUsuario


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "alumnos_intercambio_upa.xml", "muestra_proceso"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

 
				
				paiu_ncorr=f_agrega.ObtenerValorPost (filai,"paiu_ncorr")  
				pers_ncorr=f_agrega.ObtenerValorPost (filai,"paiu_ncorr")
				diau_fconsulta_esc=f_agrega.ObtenerValorPost (filai,"diau_fconsulta_esc")  
				diau_respuesta_esc=f_agrega.ObtenerValorPost (filai,"respuesta_cons_esc")
				diau_tcomentario_consulta_esc=f_agrega.ObtenerValorPost (filai,"comentario_cons_esc")
				diau_estado_ramos=f_agrega.ObtenerValorPost (filai,"diau_estado_ramos")
				auip_fenvio_carta_apoderado=f_agrega.ObtenerValorPost (filai,"diau_fenvio_carta_apoderado")
				diau_frecepcion_carta_apoderado=f_agrega.ObtenerValorPost (filai, "diau_frecepcion_carta_apoderado")
				diau_frecepcion_certi_alum_reg=f_agrega.ObtenerValorPost (filai, "diau_frecepcion_certi_alum_reg")
				diau_fpeticion_certi_alum_reg=f_agrega.ObtenerValorPost (filai,"diau_fpeticion_certi_alum_reg") 
				diau_frecepcion_certi_notas=f_agrega.ObtenerValorPost (filai,"diau_frecepcion_certi_notas") 
				diau_fpeticion_certi_notas=f_agrega.ObtenerValorPost (filai,"diau_fpeticion_certi_notas") 
				diau_fenvio_ramos_esc=f_agrega.ObtenerValorPost (filai,"diau_fenvio_ramos_esc") 
				diau_frecepcion_acuerdo_preconva=f_agrega.ObtenerValorPost (filai,"diau_frecepcion_acuerdo_preconva") 
				diau_fenvio_doctos_extranjero=f_agrega.ObtenerValorPost (filai,"diau_fenvio_doctos_extranjero") 
				diau_frecepcion_carta_acepta=f_agrega.ObtenerValorPost (filai, "diau_frecepcion_carta_acepta")
				diau_tcomentario_envio_doctos_entranjero=f_agrega.ObtenerValorPost (filai,"comentario_envio_docto") 
				diau_ffirma=f_agrega.ObtenerValorPost (filai,"diau_ffirma") 
				espi_ccod=f_agrega.ObtenerValorPost (filai,"espi_ccod") 
				diau_comen_envio_ramos_esc=f_agrega.ObtenerValorPost (filai,"diau_comen_envio_ramos_esc")  
				diau_durancion_intercambio=f_agrega.ObtenerValorPost (filai,"diau_durancion_intercambio")  
				diau_comen_recepcion_carta_apoderado=f_agrega.ObtenerValorPost (filai,"diau_comen_recepcion_carta_apoderado") 
				diau_comen_recepcion_certi_alum_reg=f_agrega.ObtenerValorPost (filai,"diau_comen_recepcion_certi_alum_reg") 
				diau_comen_recepcion_certi_notas=f_agrega.ObtenerValorPost (filai,"diau_comen_recepcion_certi_notas") 
				diau_comen_recepcion_acuerdo_preconva=f_agrega.ObtenerValorPost (filai,"diau_comen_recepcion_acuerdo_preconva") 
				diau_comen_recepcion_carta_acepta=f_agrega.ObtenerValorPost (filai,"diau_comen_recepcion_carta_acepta") 
				diau_comen_envio_doctos_extranjero=f_agrega.ObtenerValorPost (filai,"diau_comen_envio_doctos_extranjero") 
				diau_comen_firma=f_agrega.ObtenerValorPost (filai,"diau_comen_firma") 
				paiu_fvuelta_upa=f_agrega.ObtenerValorPost (filai,"paiu_fvuelta_upa") 
				
				 if diau_estado_ramos="" then
				 diau_estado_ramos="NULL"
				 else
				 diau_estado_ramos="'"&diau_estado_ramos&"'"
				 end if
				 
				 if diau_fconsulta_esc="" then
				diau_fconsulta_esc= "NULL"
				else
				diau_fconsulta_esc="'"&diau_fconsulta_esc&"'"
				end if
				
				 if auip_fenvio_carta_apoderado="" then
				auip_fenvio_carta_apoderado="NULL"
				else
				auip_fenvio_carta_apoderado="'"&auip_fenvio_carta_apoderado&"'"
				end if
				
				 if diau_frecepcion_carta_apoderado="" then
				diau_frecepcion_carta_apoderado="NULL"
				else
				diau_frecepcion_carta_apoderado="'"&diau_frecepcion_carta_apoderado&"'"
				end if
				
				 if diau_frecepcion_certi_alum_reg="" then
				diau_frecepcion_certi_alum_reg="NULL"
				else
				diau_frecepcion_certi_alum_reg="'"&diau_frecepcion_certi_alum_reg&"'"
				end if
				
				 if diau_fpeticion_certi_alum_reg="" then
				diau_fpeticion_certi_alum_reg= "NULL"
				else
				diau_fpeticion_certi_alum_reg="'"&diau_fpeticion_certi_alum_reg&"'"
				end if
				
				 if diau_frecepcion_certi_notas="" then
				diau_frecepcion_certi_notas="NULL"
				else
				diau_frecepcion_certi_notas="'"&diau_frecepcion_certi_notas&"'"
				end if
				
				 if diau_fpeticion_certi_notas="" then
				diau_fpeticion_certi_notas="NULL"
				else
				diau_fpeticion_certi_notas="'"&diau_fpeticion_certi_notas&"'"
				end if
				
				 if diau_fenvio_ramos_esc="" then
				diau_fenvio_ramos_esc="NULL"
				else
				diau_fenvio_ramos_esc="'"&diau_fenvio_ramos_esc&"'"
				end if
				
				 if diau_frecepcion_acuerdo_preconva="" then
				diau_frecepcion_acuerdo_preconva="NULL" 
				else
				diau_frecepcion_acuerdo_preconva="'"&diau_frecepcion_acuerdo_preconva&"'"
				end if
				
				 if diau_fenvio_doctos_extranjero="" then
				diau_fenvio_doctos_extranjero="NULL"
				else
				diau_fenvio_doctos_extranjero="'"&diau_fenvio_doctos_extranjero&"'"
				end if
				
				 if diau_frecepcion_carta_acepta="" then
				diau_frecepcion_carta_acepta="NULL"
				else
				diau_frecepcion_carta_acepta="'"&diau_frecepcion_carta_acepta&"'"
				end if
				
				 if diau_ffirma="" then
				diau_ffirma="NULL"
				else
				diau_ffirma="'"&diau_ffirma&"'"
				end if
				
				 if paiu_fvuelta_upa="" then
				paiu_fvuelta_upa="NULL"
				else
				paiu_fvuelta_upa="'"&paiu_fvuelta_upa&"'"
				end if
				 if diau_respuesta_esc="No" then
				bloque=bloque&"espi_ccod=2"
				else
				bloque=bloque&"espi_ccod = "&espi_ccod&""
				end if
				
			
			query_exc="exec GuardarDocumentacionIntercambioUpa "&paiu_ncorr&","&espi_ccod&","&diau_fconsulta_esc&",'"&diau_respuesta_esc&"','"&diau_tcomentario_consulta_esc&"', "&paiu_fvuelta_upa&", "&diau_estado_ramos&","&auip_fenvio_carta_apoderado&","&diau_frecepcion_carta_apoderado&","&diau_frecepcion_certi_alum_reg&","&diau_fpeticion_certi_alum_reg&","&diau_frecepcion_certi_notas&","&diau_fpeticion_certi_notas&","&diau_frecepcion_acuerdo_preconva&","&diau_fenvio_doctos_extranjero&","&diau_frecepcion_carta_acepta&","&diau_fenvio_ramos_esc&",'"&diau_comen_envio_doctos_extranjero&"','"&diau_comen_envio_ramos_esc&"','"&diau_comen_recepcion_carta_apoderado&"','"&diau_comen_recepcion_certi_alum_reg&"','"&diau_comen_recepcion_certi_notas&"','"&diau_comen_recepcion_acuerdo_preconva&"','"&diau_comen_recepcion_carta_acepta&"','"&diau_comen_firma&"',"&diau_ffirma&""
		'response.Write("<pre>"&query_exc)
		resul=conectar.consultaUno(query_exc)
Respuesta = conectar.ObtenerEstadoTransaccion()
next
'response.End()
'response.Write("<pre>"&query_exc)
'----------------------------------------------------
'response.Write("<br>resul "&resul)
'response.End()
if resul="1" then
  session("mensajeerror")= "La información ha sido Guardada"
 else
 session("mensajeerror")= "No se ha podido guardar la información"
 end if
  
  response.Redirect("proceso_alumnos_intercambio_upa.asp?paiu_ncorr="&paiu_ncorr&"&pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&"&pais_ccod="&pais_ccod&"&ciex_ccod="&ciex_ccod&"&univ_ccod="&univ_ccod&"&peri_ccod="&peri_ccod&"")










%>


