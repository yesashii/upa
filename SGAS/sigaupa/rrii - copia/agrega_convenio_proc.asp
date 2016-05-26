<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

usu=negocio.obtenerUsuario


ciex_ccod=request.Form("b[0][ciex]")
unci_ncorr=request.Form("b[0][unci]")
pais_ccod=request.Form("b[0][pais]")
univ_ccod=request.Form("b[0][univ]")
daco_ncorr=request.Form("b[0][daco_ncorr]")

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_contacto"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

 
				daco_tweb= f_agrega.ObtenerValorPost (filai, "web")
				daco_flimite_pos_sem1_upa= f_agrega.ObtenerValorPost (filai, "flimite_post_sem1_upa")
				daco_flimite_pos_sem1= f_agrega.ObtenerValorPost (filai, "flimite_post_sem1")
				daco_fini_clase_sem1= f_agrega.ObtenerValorPost (filai, "fini_clase_sem1")
				daco_ffin_clase_sem1= f_agrega.ObtenerValorPost (filai, "ffin_clase_sem1")
				daco_flimite_pos_sem2_upa= f_agrega.ObtenerValorPost (filai, "flimite_post_sem2_upa")
				daco_flimite_pos_sem2= f_agrega.ObtenerValorPost (filai, "flimite_post_sem2")
				daco_fini_clase_sem2= f_agrega.ObtenerValorPost (filai, "fini_clase_sem2")
				daco_ffin_clase_sem2= f_agrega.ObtenerValorPost (filai, "ffin_clase_sem2")
				idio_ccod= f_agrega.ObtenerValorPost (filai, "idio_ccod")
				daco_ttest_idioma= f_agrega.ObtenerValorPost (filai, "test_idioma")
				daco_tescala_avalu= f_agrega.ObtenerValorPost (filai, "escala")
				daco_ncupo= f_agrega.ObtenerValorPost (filai, "cupo")
				daco_tcomentario_cupo= f_agrega.ObtenerValorPost (filai, "comentario_cupo")
				daco_tramos_cursar= f_agrega.ObtenerValorPost (filai, "asig")
				anos_ccod= f_agrega.ObtenerValorPost (filai, "anos_ccod")
				daco_alojamiento= f_agrega.ObtenerValorPost (filai, "daco_alojamiento")
				daco_alojamiento_comentario= f_agrega.ObtenerValorPost (filai, "daco_alojamiento_comentario")
				daco_fconvenio_ini= f_agrega.ObtenerValorPost (filai, "daco_fconvenio_ini")
				daco_fconvenio_fin= f_agrega.ObtenerValorPost (filai, "daco_fconvenio_fin")
				daco_tcomentario_gral= f_agrega.ObtenerValorPost (filai, "daco_tcomentario_gral")
				

			if daco_ncorr="" then
				universidad_insertada=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_convenio where unci_ncorr="&unci_ncorr&" and anos_ccod="&anos_ccod&"")
					if universidad_insertada="N" then
						daco_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'datos_convenio'")
							p_insert="insert into datos_convenio(daco_ncorr,unci_ncorr,daco_tweb,daco_flimite_pos_sem1_upa,daco_flimite_pos_sem1,daco_fini_clase_sem1,daco_ffin_clase_sem1,daco_flimite_pos_sem2_upa,daco_flimite_pos_sem2,daco_fini_clase_sem2,daco_ffin_clase_sem2,idio_ccod,daco_ttest_idioma,daco_tescala_avalu,daco_ncupo,daco_tcomentario_cupo,daco_tramos_cursar,anos_ccod,audi_tusuario,audi_fmodificacion,daco_alojamiento,daco_alojamiento_comentario,daco_fconvenio_ini,daco_fconvenio_fin,daco_tcomentario_gral)"& vbCrLf &_
							" values("&daco_ncorr&","&unci_ncorr&",'"&daco_tweb&"','"&daco_flimite_pos_sem1_upa&"','"&daco_flimite_pos_sem1&"','"&daco_fini_clase_sem1&"','"&daco_ffin_clase_sem1&"','"&daco_flimite_pos_sem2_upa&"','"&daco_flimite_pos_sem2&"','"&daco_fini_clase_sem2&"','"&daco_ffin_clase_sem2&"',"&idio_ccod&",'"&daco_ttest_idioma&"','"&daco_tescala_avalu&"',"&daco_ncupo&",'"&daco_tcomentario_cupo&"','"&daco_tramos_cursar&"',"&anos_ccod&",'"&usu&"',getDate(),'"&daco_alojamiento&"','"&daco_alojamiento_comentario&"','"&daco_fconvenio_ini&"','"&daco_fconvenio_fin&"','"&daco_tcomentario_gral&"')"		  
							'response.Write("<pre>"&p_insert&"</pre>")
					else

						session("mensajeerror")= "Esta universidad ya tiene registrado un convenio para el año seleccionado"
					  response.Redirect("agrega_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bunci_ncorr%5D="&unci_ncorr&"")
					end if		
			else
					p_insert="update datos_convenio set daco_tweb='"&daco_tweb&"',daco_flimite_pos_sem1_upa='"&daco_flimite_pos_sem1_upa&"',daco_flimite_pos_sem1='"&daco_flimite_pos_sem1&"',daco_fini_clase_sem1='"&daco_fini_clase_sem1&"',daco_ffin_clase_sem1='"&daco_ffin_clase_sem1&"',daco_flimite_pos_sem2_upa='"&daco_flimite_pos_sem2_upa&"',daco_flimite_pos_sem2='"&daco_flimite_pos_sem2&"',daco_fini_clase_sem2='"&daco_fini_clase_sem2&"',daco_ffin_clase_sem2='"&daco_ffin_clase_sem2&"',idio_ccod="&idio_ccod&",daco_ttest_idioma='"&daco_ttest_idioma&"',daco_tescala_avalu='"&daco_tescala_avalu&"',daco_ncupo="&daco_ncupo&",daco_tcomentario_cupo='"&daco_tcomentario_cupo&"',daco_tramos_cursar='"&daco_tramos_cursar&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate(),daco_alojamiento='"&daco_alojamiento&"',daco_alojamiento_comentario='"&daco_alojamiento_comentario&"'"& vbCrLf &_
",daco_fconvenio_ini='"&daco_fconvenio_ini&"'"& vbCrLf &_
",daco_fconvenio_fin='"&daco_fconvenio_fin&"'"& vbCrLf &_
",daco_tcomentario_gral='"&daco_tcomentario_gral&"'"& vbCrLf &_
					" where daco_ncorr="&daco_ncorr&""		  
			'		response.Write("<pre>"&p_insert&"</pre>")			
			'response.End()
			end if	
			'response.Write("daco_ncorr="&daco_ncorr)
			'response.End()
					conectar.ejecutaS (p_insert)
					Respuesta_3 = conectar.ObtenerEstadoTransaccion()
					
					if Respuesta_3 = true then
						session("mensajeerror")= " El Datos fueron Guardados"
						response.Redirect("agrega_datos_contacto.asp?b%5B0%5D%5Bdaco_ncorr%5D="&daco_ncorr&"")
					else
						'borrado="delete from universidades where cast(univ_ccod as varchar)='"&univ_ccod&"'"
'						conectar.ejecutaS (borrado)
'						
'						borrado2="delete from universidad_ciudad where cast(unci_ncorr as varchar)='"&unci_ncorr&"'"
'						conectar.ejecutaS (borrado2)
						
						'borrado3="delete from datos_convenio where cast(daco_ncorr as varchar)='"&daco_ncorr&"'"
'						conectar.ejecutaS (borrado3)
						
					  session("mensajeerror")= "Error al Guardar "
					  'response.Write("borrado 3")
					  response.Redirect("agrega_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bunci_ncorr%5D="&unci_ncorr&"")
					end if
					
next
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()

%>