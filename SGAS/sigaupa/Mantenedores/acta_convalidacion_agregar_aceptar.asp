<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set pagina = new CPagina
pagina.Titulo = "Título de la página"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------------------------------------------------------------------
'response.End()
set t_resoluciones = new CFormulario
		t_resoluciones.Carga_Parametros "acta_convalidacion_agregar.xml", "resoluciones"
		t_resoluciones.Inicializar conexion
		t_resoluciones.ProcesaForm
		
set t_resoluciones_personas = new CFormulario
		t_resoluciones_personas.Carga_Parametros "acta_convalidacion_agregar.xml", "resoluciones_personas"
		t_resoluciones_personas.Inicializar conexion
		t_resoluciones_personas.ProcesaForm
		
set t_actas_convalidacion = new CFormulario
		t_actas_convalidacion.Carga_Parametros "acta_convalidacion_agregar.xml", "actas_convalidacion"
		t_actas_convalidacion.Inicializar conexion
		t_actas_convalidacion.ProcesaForm
		
set t_convalidaciones = new CFormulario
		t_convalidaciones.Carga_Parametros "acta_convalidacion_agregar.xml", "convalidaciones"
		t_convalidaciones.Inicializar conexion
		t_convalidaciones.ProcesaForm

for i_ = 0 to t_convalidaciones.CuentaPost - 1 
				
	matr_ncorr    = t_convalidaciones.ObtenerValorPost(i_, "matr_ncorr")
	asig_ccod     = t_convalidaciones.ObtenerValorPost(i_, "asig_ccod")
	acon_ncorr    = t_convalidaciones.ObtenerValorPost(i_, "acon_ncorr")
	sitf_ccod     = t_convalidaciones.ObtenerValorPost(i_, "sitf_ccod")
    a_grabar      = t_convalidaciones.ObtenerValorPost(i_, "a_grabar")
    conv_nnota    = t_convalidaciones.ObtenerValorPost(i_, "conv_nnota") 
	conv_tdocente = t_convalidaciones.ObtenerValorPost(i_, "conv_tdocente") 
	
	if a_grabar = "1" then
		pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
		carr_ccod = conexion.consultaUno("select c.carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
		
		'consulta_busqueda = " select case count(*) when 0 then 'N' else 'S' end  from alumnos a, ofertas_academicas b, especialidades c, convalidaciones d "& vbCrLf &_
		'					" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod= c.espe_ccod "& vbCrLf &_
		'					" and a.matr_ncorr= d.matr_ncorr "& vbCrLf &_
		'					" and c.carr_ccod='"&carr_ccod&"' and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"'"& vbCrLf &_
		'					" and d.asig_ccod = '"&asig_ccod&"'"
		
		'encontrada = conexion.consultaUno(consulta_busqueda)

			if IsNumeric(conv_nnota) then
			  'response.Write(conv_nnota)
			  if conv_nnota < 4.0 then
			  'response.Write("entre2</br>")
				if (t_resoluciones.ObtenerValorPost(0, "tres_ccod") = "7") then
					sitf_ccod = "RC"
				end if
				if (t_resoluciones.ObtenerValorPost(0, "tres_ccod") = "3") then
					sitf_ccod = "RC"
				end if
				if (t_resoluciones.ObtenerValorPost(0, "tres_ccod") = "6") then
					sitf_ccod = "RS"
				end if
			  elseif conv_nnota >= 4.0 then
  			    'response.Write("entre3</br> "+t_resoluciones.ObtenerValorPost(i_, "tres_ccod"))
			    if (t_resoluciones.ObtenerValorPost(0, "tres_ccod") = "3") then
					sitf_ccod = "CR"
				end if
			  end if
			else
			    'response.Write("entre3</br>")
				if (t_resoluciones.ObtenerValorPost(0, "tres_ccod") = "3") then
					sitf_ccod = "CR"
				end if
			end if
			conv_nnota = Replace(conv_nnota ,",",".")
			if conv_nnota = "" then 
				c_insert = " insert into convalidaciones (MATR_NCORR,ASIG_CCOD,ACON_NCORR,SITF_CCOD,CONV_NNOTA,AUDI_TUSUARIO,AUDI_FMODIFICACION,CONV_TDOCENTE) "&_
			    	       " values ("&matr_ncorr&",'"&asig_ccod&"',"&acon_ncorr&",'"&sitf_ccod&"',NULL,'"&negocio.obtenerUsuario&"', getDate(),'"&conv_tdocente&"') "
			else
				c_insert = " insert into convalidaciones (MATR_NCORR,ASIG_CCOD,ACON_NCORR,SITF_CCOD,CONV_NNOTA,AUDI_TUSUARIO,AUDI_FMODIFICACION,CONV_TDOCENTE) "&_
			    	       " values ("&matr_ncorr&",'"&asig_ccod&"',"&acon_ncorr&",'"&sitf_ccod&"',"&conv_nnota&",'"&negocio.obtenerUsuario&"', getDate(),'"&conv_tdocente&"') "
			end if
			conexion.ejecutaS c_insert
			'response.Write(c_insert)
			
	end if	
	
next
'response.End()
		
		'-------------------------------------------------------------------------------------------------------------------
		t_resoluciones.MantieneTablas false
		t_resoluciones_personas.MantieneTablas false
		t_actas_convalidacion.MantieneTablas false
		
		't_convalidaciones.MantieneTablas false
		'conexion.estadotransaccion false  'roolback 
		'response.End()
		
		if conexion.ObtenerEstadoTransaccion then
			conexion.MensajeError "Asignaturas guardadas correctamente."
		else
			conexion.MensajeError "Se ha presentado un error al momento de grabar, inténtelo nuevamente"
		end if
		

str_url = "acta_convalidacion.asp?reso_ncorr=" & t_resoluciones.ObtenerValorPost(0, "reso_ncorr")

%>

<script language="JavaScript">
opener.navigate("<%=str_url%>");
close();
</script>