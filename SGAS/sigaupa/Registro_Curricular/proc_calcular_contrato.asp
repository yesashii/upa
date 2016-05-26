<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.end

q_post_ncorr=request.QueryString("post_ncorr")

'response.Write("<hr>")

Function ObtenerFormaPago(f_forma_pago_matricula, f_forma_pago_colegiatura, p_conexion)
	Dim i_, consulta, s_from, s_where, s_where_2
	
	
	s_from = ""
	s_where = "where "
	s_where_2 = ""
	
	
	for i_ = 0 to f_forma_pago_matricula.CuentaPost - 1
		s_from = s_from & "stipos_pagos m" & i_ & ", "
		
		if i_ > 0 then
			if i_ > 1 then
				s_where = s_where & "  and m" & (i_ - 1) & ".stpa_ccod = m" & i_ & ".stpa_ccod" & vbCrLf			
			else
				s_where = s_where & "m" & (i_ - 1) & ".stpa_ccod = m" & i_ & ".stpa_ccod" & vbCrLf			
			end if
		end if
		If EsVacio(f_forma_pago_matricula.ObtenerValorPost(i_, "stpa_ncuotas")) then
			pp_valor = "NULL"
		else 
			pp_valor = f_forma_pago_matricula.ObtenerValorPost(i_, "stpa_ncuotas")
		end if
		s_where_2 = s_where_2 & "  and m" & i_ & ".tcom_ccod = '" & f_forma_pago_matricula.ObtenerValorPost(i_, "tcom_ccod") & "' and m" & i_ & ".ting_ccod = '" & f_forma_pago_matricula.ObtenerValorPost(i_, "ting_ccod") & "' and m" & i_ & ".stpa_ncuotas = isnull(" & pp_valor & ", 0) " & vbCrLf
	next
	

	for i_ = 0 to f_forma_pago_colegiatura.CuentaPost - 1					
		if i_ = f_forma_pago_colegiatura.CuentaPost - 1 then			
			s_from = s_from & "stipos_pagos c" & i_ & vbCrLf
		else
			s_from = s_from & "stipos_pagos c" & i_ & ", "
		end if
		
		if i_ > 0 then
			s_where = s_where & "  and c" & (i_ - 1) & ".stpa_ccod = c" & i_ & ".stpa_ccod" & vbCrLf
		else
			s_where = s_where & "  and m" & (f_forma_pago_matricula.CuentaPost - 1) & ".stpa_ccod = c" & i_ & ".stpa_ccod" & vbCrLf
		end if
		If EsVacio(f_forma_pago_colegiatura.ObtenerValorPost(i_, "stpa_ncuotas")) then
			p_valor = "NULL"
		else
			p_valor = f_forma_pago_colegiatura.ObtenerValorPost(i_, "stpa_ncuotas")
		end if
		s_where_2 = s_where_2 & "  and c" & i_ & ".tcom_ccod = '" & f_forma_pago_colegiatura.ObtenerValorPost(i_, "tcom_ccod") & "' and c" & i_ & ".ting_ccod = '" & f_forma_pago_colegiatura.ObtenerValorPost(i_, "ting_ccod") & "' and c" & i_ & ".stpa_ncuotas = isnull("& p_valor & ", 0) " & vbCrLf
	next
	
	consulta = "select m0.stpa_ccod from " & vbCrLf
	consulta = consulta & s_from 
	consulta = consulta & s_where
	consulta = consulta & s_where_2
	
	''response.Write("<pre>"&consulta&"</pre>")
	''response.end
	''response.Flush()
	ObtenerFormaPago = p_conexion.ConsultaUno(consulta)	
	
	response.Write("<pre>" & consulta & "</pre>")

End Function

'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.EstadoTransaccion false

'-------------------------------------------------------------------------------------------------------------------------
set f_forma_pago_matricula = new CFormulario
f_forma_pago_matricula.Carga_Parametros "genera_contrato_2.xml", "forma_pago"
f_forma_pago_matricula.Inicializar conexion
f_forma_pago_matricula.AgregaParam "variable", "fp_matricula"
f_forma_pago_matricula.ProcesaForm

set f_forma_pago_colegiatura = new CFormulario
f_forma_pago_colegiatura.Carga_Parametros "genera_contrato_2.xml", "forma_pago"
f_forma_pago_colegiatura.Inicializar conexion
f_forma_pago_colegiatura.AgregaParam "variable", "fp_colegiatura"
f_forma_pago_colegiatura.ProcesaForm

sql_borra_todo="delete from sdetalles_forma_pago where post_ncorr="&q_post_ncorr&" "
'response.write sql_borra_todo
'response.end
'conexion.ejecutaS(sql_borra_todo)	
'-------------------------------------------------------------------------------------------------------------------------
v_stpa_ccod = ObtenerFormaPago(f_forma_pago_matricula, f_forma_pago_colegiatura, conexion)
'response.End()


if EsVacio(v_stpa_ccod) then
	'conexion.EstadoTransaccion false
	'conexion.MensajeError("No existe la forma de pago elegida.")
	' Como no existe se debe generar la forma de pago elegida
	
	tipo_pago=conexion.consultaUno("exec obtenersecuencia 'pactacion_contrato' ")
	for i_ = 0 to f_forma_pago_colegiatura.CuentaPost - 1
		v_tcom_ccod		=	f_forma_pago_colegiatura.ObtenerValorPost(i_, "tcom_ccod")
		v_ting_ccod		=	f_forma_pago_colegiatura.ObtenerValorPost(i_, "ting_ccod")
		v_stpa_ncuotas	=	f_forma_pago_colegiatura.ObtenerValorPost(i_, "stpa_ncuotas")
		
		if v_stpa_ncuotas="" then
			v_stpa_ncuotas=0
		end if
		
		inserta_forma_pago=	" Insert into stipos_pagos (stpa_ccod,tcom_ccod,ting_ccod,stpa_ncuotas,audi_tusuario,audi_fmodificacion) "&_ 
							" Values("&tipo_pago&","&v_tcom_ccod&","&v_ting_ccod&","&v_stpa_ncuotas&",'Simulacion', getdate())"
		conexion.EstadoTransaccion conexion.ejecutas(inserta_forma_pago)
		'response.Write("<br>"&inserta_forma_pago)
	next
	'response.Write("************************************************************")
	for i_ = 0 to f_forma_pago_matricula.CuentaPost - 1
		
		v_tcom_ccod		=	f_forma_pago_matricula.ObtenerValorPost(i_, "tcom_ccod")
		v_ting_ccod		=	f_forma_pago_matricula.ObtenerValorPost(i_, "ting_ccod")
		v_stpa_ncuotas	=	f_forma_pago_matricula.ObtenerValorPost(i_, "stpa_ncuotas")
		
		if v_stpa_ncuotas="" then
			v_stpa_ncuotas=0
		end if
		inserta_forma_pago= " Insert into stipos_pagos (stpa_ccod,tcom_ccod,ting_ccod,stpa_ncuotas,audi_tusuario,audi_fmodificacion) "&_
							" Values("&tipo_pago&","&v_tcom_ccod&","&v_ting_ccod&","&v_stpa_ncuotas&",'Simulacion', getdate())"
		conexion.EstadoTransaccion conexion.ejecutas(inserta_forma_pago)
		'response.Write("<br>"&inserta_forma_pago)
	next
	'response.End()
	if conexion.obtenerEstadoTransaccion =true then
		v_stpa_ccod = ObtenerFormaPago(f_forma_pago_matricula, f_forma_pago_colegiatura, conexion)
	else
		Response.Redirect("genera_contrato_2.asp?post_ncorr=" & Request.QueryString("post_ncorr") & "#a_forma_pago")	
	end if
	
end if



	'-------------------------------------------------------------------------------------------------------------------------
	'response.Write("<hr>"&v_stpa_ccod&"<hr>")
	'response.End()
	
	set f_spagos = new CFormulario
	f_spagos.Carga_Parametros "genera_contrato_2.xml", "spagos"
	f_spagos.Inicializar conexion
	f_spagos.ProcesaForm
	f_spagos.AgregaCampoPost "stpa_ccod", v_stpa_ccod	
	

	sql_borra_todo="delete from sdetalles_forma_pago where post_ncorr="&q_post_ncorr&" "
	conexion.ejecutaS(sql_borra_todo)	

	for i_ = 0 to f_forma_pago_matricula.CuentaPost - 1
		if f_forma_pago_matricula.ObtenerValorPost(i_, "butiliza") = f_forma_pago_matricula.ObtenerDescriptor("butiliza", "valorFalso") then
			f_forma_pago_matricula.EliminaFilaPost i_
		else
			'f_elimina_fp_matricula.EliminaFilaPost i_
			p_ofer_ncorr			=	f_forma_pago_matricula.ObtenerValorPost(i_,"OFER_NCORR")
			p_ting_ccod				=	f_forma_pago_matricula.ObtenerValorPost(i_,"TING_CCOD")
			p_tcom_ccod				=	f_forma_pago_matricula.ObtenerValorPost(i_,"TCOM_CCOD")
			p_sdfp_mmonto			=	f_forma_pago_matricula.ObtenerValorPost(i_,"SDFP_MMONTO")
			p_sdfp_finicio_pago		=	f_forma_pago_matricula.ObtenerValorPost(i_,"SDFP_FINICIO_PAGO")
			p_sdfp_nfrecuencia		=	f_forma_pago_matricula.ObtenerValorPost(i_,"SDFP_NFRECUENCIA")
			p_sdfp_tctacte			=	f_forma_pago_matricula.ObtenerValorPost(i_,"SDFP_TCTACTE")
			p_sdfp_ndocto_inicial	=	f_forma_pago_matricula.ObtenerValorPost(i_,"SDFP_NDOCTO_INICIAL")
			p_plaz_ccod				=	f_forma_pago_matricula.ObtenerValorPost(i_,"PLAZ_CCOD")
			p_banc_ccod				=	f_forma_pago_matricula.ObtenerValorPost(i_,"BANC_CCOD")
			
			if EsVacio(p_sdfp_mmonto)then p_sdfp_mmonto=0 end if
			if EsVacio(p_sdfp_nfrecuencia)then p_sdfp_nfrecuencia=0 end if
			if EsVacio(p_sdfp_ndocto_inicial)then p_sdfp_ndocto_inicial=0 end if
			if EsVacio(p_plaz_ccod)then p_plaz_ccod="null" end if
			if EsVacio(p_banc_ccod)then p_banc_ccod="null" end if
			
		sql_inserta_m= " Insert into sdetalles_forma_pago (POST_NCORR,OFER_NCORR,TING_CCOD,TCOM_CCOD,SDFP_MMONTO,SDFP_FINICIO_PAGO,SDFP_NFRECUENCIA,SDFP_TCTACTE,SDFP_NDOCTO_INICIAL,PLAZ_CCOD, BANC_CCOD) "&_
			 " values("&q_post_ncorr&","&p_ofer_ncorr&","&p_ting_ccod&","&p_tcom_ccod&","&p_sdfp_mmonto&",'"&p_sdfp_finicio_pago&"',"&p_sdfp_nfrecuencia&",'"&p_sdfp_tctacte&"',"&p_sdfp_ndocto_inicial&","&p_plaz_ccod&","&p_banc_ccod&") "
			conexion.ejecutaS(sql_inserta_m)
		end if
	next
	

	for i_ = 0 to f_forma_pago_colegiatura.CuentaPost - 1

		if f_forma_pago_colegiatura.ObtenerValorPost(i_, "butiliza") = f_forma_pago_colegiatura.ObtenerDescriptor("butiliza", "valorFalso") then

			f_forma_pago_colegiatura.EliminaFilaPost i_
		else
			'f_elimina_fp_colegiatura.EliminaFilaPost i_
			p_ofer_ncorr			=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"OFER_NCORR")
			p_ting_ccod				=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"TING_CCOD")
			p_tcom_ccod				=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"TCOM_CCOD")
			p_sdfp_mmonto			=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"SDFP_MMONTO")
			p_sdfp_finicio_pago		=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"SDFP_FINICIO_PAGO")
			p_sdfp_nfrecuencia		=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"SDFP_NFRECUENCIA")
			p_sdfp_tctacte			=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"SDFP_TCTACTE")
			p_sdfp_ndocto_inicial	=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"SDFP_NDOCTO_INICIAL")
			p_plaz_ccod				=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"PLAZ_CCOD")
			p_banc_ccod				=	f_forma_pago_colegiatura.ObtenerValorPost(i_,"BANC_CCOD")
			
			if EsVacio(p_sdfp_mmonto)then p_sdfp_mmonto=0 end if
			if EsVacio(p_sdfp_nfrecuencia)then p_sdfp_nfrecuencia=0 end if
			if EsVacio(p_sdfp_ndocto_inicial)then p_sdfp_ndocto_inicial=0 end if
			if EsVacio(p_plaz_ccod)then p_plaz_ccod="null" end if
			if EsVacio(p_banc_ccod)then p_banc_ccod="null" end if
			
		sql_inserta_a= " Insert into sdetalles_forma_pago (POST_NCORR,OFER_NCORR,TING_CCOD,TCOM_CCOD,SDFP_MMONTO,SDFP_FINICIO_PAGO,SDFP_NFRECUENCIA,SDFP_TCTACTE,SDFP_NDOCTO_INICIAL,PLAZ_CCOD, BANC_CCOD) "&_
			 " values("&q_post_ncorr&","&p_ofer_ncorr&","&p_ting_ccod&","&p_tcom_ccod&","&p_sdfp_mmonto&",'"&p_sdfp_finicio_pago&"',"&p_sdfp_nfrecuencia&",'"&p_sdfp_tctacte&"',"&p_sdfp_ndocto_inicial&","&p_plaz_ccod&","&p_banc_ccod&") "
		response.write sql_inserta_a
		conexion.ejecutaS(sql_inserta_a)
		end if
	next

	'response.Write("<br>"&conexion.obtenerEstadoTransaccion&"<br>")
	f_spagos.MantieneTablas false

	'--------------------------------------------------------------------------------------------------------------------------
	response.write "<br>ACA<br>"
	sentencia = "exec genera_sdetalle_pagos " & f_spagos.ObtenerValorPost(0, "post_ncorr") & ", " & f_spagos.ObtenerValorPost(0, "ofer_ncorr")
'response.Write(sentencia)
	v_salida = conexion.consultaUno(sentencia)

'response.End()
	'-----------------------------------------------------------------------------------------------------
Response.Redirect("genera_contrato_2.asp?post_ncorr=" & Request.QueryString("post_ncorr") & "&#a_forma_pago")


%>
