<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_fecha = conexion.consultaUno("select protic.trunc(getdate()) as fecha")
session("periodo_postulacion") = v_peri_ccod
'response.Write(v_peri_ccod)
'response.End()
v_usuario = Request.Form("usuario")
v_clave = Request.Form("clave")
v_pers_ncorr = Request.Form("pers_ncorr")

'response.Write("usuario "&v_usuario&" clave "&v_clave&" pers_ncorr "&v_pers_ncorr)
'response.End()

sql_usuario_valido =" select count(*) " & vbCrLf &_
	    	 	    " from usuarios " & vbCrLf &_
			        " where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			    " and upper(usua_tclave) is not null " 

usuario_valido = conexion.consultauno(sql_usuario_valido)

v_tpos_ccod = "1" ' Normal 
v_epos_ccod = "1" ' En Proceso

if usuario_valido=0 then
	session("mensajeError") = "Usuario no está registrado."
	Response.Redirect("inicio.asp")
end if

'---------IMPEDIR QUE ENTREN ALUMNOS ANTIGUOS -----------------

sql_nuevo_f  = "select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") "
v_post_bnuevo_institucion = conexion.ConsultaUno(sql_nuevo_f)

' veamos si esta matriculado en el sistema
consulta = "select count(*) as cuenta " & vbCrLf &_
           "from postulantes a, alumnos b, periodos_academicos c, " & vbCrLf &_
		   "     periodos_academicos d  " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
		   "  and c.anos_ccod = d.anos_ccod " & vbCrLf &_
		   "  and a.peri_ccod = d.peri_ccod " & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and c.plec_ccod = 1 " & vbCrLf &_
		   "  and cast(d.peri_ccod as varchar)= '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
	v_cuenta = CInt(conexion.ConsultaUno(consulta))
	if v_cuenta > 0 then
	    Session("ses_matriculado")=true
		Session("ses_estado_alumno")="1"
		Session("ses_act_ancedentes") ="S"
		str_url = "../matricula/postulacion_antiguo.asp"
	end if

'if v_post_bnuevo_institucion = "N" then
if v_post_bnuevo_institucion = "N" then' se creo pues es necesario solo para alumnos nuevos la siguiente validacion. ETORRES
'--------------------------------------------------------------------------------------------------------------------
consulta = "select count(*) as cuenta " & vbCrLf &_
           "from postulantes a, alumnos b, periodos_academicos c, " & vbCrLf &_
		   "     periodos_academicos d  " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
		   "  and c.anos_ccod = d.anos_ccod " & vbCrLf &_
		   "  and a.peri_ccod = d.peri_ccod " & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and c.plec_ccod = 1 " & vbCrLf &_
		   "  and cast(d.peri_ccod as varchar)= '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
	v_cuenta = CInt(conexion.ConsultaUno(consulta))
	if v_cuenta > 0 then
		conexion.EstadoTransaccion false
		conexion.MensajeError "Se ha detectado que el alumno ya se matriculó en el primer semestre."
		Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
	end if
		
end if
'--------------------------------------------------------------------------------------------------------------------


if EsVacio(v_pers_ncorr) then	
	Session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
	str_url = "inicio.asp"
else
	Session("pers_ncorr") = v_pers_ncorr
	v_post_bnuevo = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
	
	
	set fc_postulacion = new CFormulario
	fc_postulacion.Carga_Parametros "consulta.xml", "consulta"
	fc_postulacion.Inicializar conexion
	
	consulta = "select post_ncorr, ofer_ncorr, epos_ccod, tpos_ccod " & vbCrLf &_
	           "from postulantes " & vbCrLf &_
			   "where pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
			   "  and tpos_ccod = 1 " ' para indentificar la postulacion simple
	fc_postulacion.Consultar consulta

		
	if fc_postulacion.NroFilas > 0 then    'tiene postulacion para este periodo
	  fc_postulacion.Siguiente
	     if str_url = "" then
			if 	fc_postulacion.ObtenerValor("epos_ccod") = "2" and v_post_bnuevo="S" then ' se agrego para ver las doble matriculas de antiguos
				Session("post_ncorr") = fc_postulacion.ObtenerValor("post_ncorr")					
				str_url = "../matricula/postulacion_1.asp"
			elseif 	fc_postulacion.ObtenerValor("epos_ccod") <> "2" then
				'str_url = "principal.asp"
				str_url = "../postulacion/postulacion_1.asp"
			end if
		end if	
    end if
	
end if
'response.Write(str_url&" postulante nuevo ?->"&v_post_bnuevo)
'conexion.estadotransaccion false
if v_post_bnuevo = "N" then
	str_url = "../matricula/postulacion_antiguo.asp"
end if 
'---------------------------------------------------------------------------------------------------------------------

'response.Write(str_url)
'response.End()
Response.Redirect(str_url)
%>
