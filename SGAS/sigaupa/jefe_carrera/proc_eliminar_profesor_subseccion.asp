<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_profesor = new CFormulario
f_profesor.Carga_Parametros "edicion_plan_acad.xml", "profesores"
f_profesor.Inicializar conexion
f_profesor.ProcesaForm

'---------------------------------------agregado para bloquear checkbox de profesores cuando estos tengan no nulo el campo bloque anexo
'--------------------------------------------Agregado por M. Sandoval 03-03-05---------------------------------------------------------
for i=0 to f_profesor.cuentaPost - 1
	anexo=f_profesor.obtenerValorPost(i,"bloq_anexo")
	bloq_ccod = f_profesor.obtenerValorPost(i,"bloq_ccod")
	pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")	
	if pers_ncorr<> "" then ' solo para el docente/ayudante seleccionado
		cupo = conexion.consultaUno("Select secc_ncupo from secciones a, bloques_horarios b where a.secc_ccod=b.secc_ccod and cast(b.bloq_ccod as varchar)='"&bloq_ccod&"'")
		if esVacio(anexo) and cupo="0" then
		   pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")	
		   consulta_delete="Delete from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
		   conexion.ejecutaS consulta_delete
		elseif cupo<>"0" and esVacio(anexo) then
		   pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")	
		   consulta_delete="Delete from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
		   conexion.ejecutaS consulta_delete
		elseif cupo="0" and not esVacio(anexo) then
		   pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")	
		   consulta_delete="Delete from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
		   conexion.ejecutaS consulta_delete
		else
			conexion.estadotransaccion false	
			conexion.MensajeError "No se pudo eliminar por que ya es parte de un contrato "
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		'###############################################################################
		'Habilita o Deshabilita la contratacion docnete si la seccion esta completamente llena de docentes
		v_seccion=conexion.consultaUno("select top 1 a.secc_ccod from secciones a, bloques_horarios b where a.secc_ccod=b.secc_ccod and cast(bloq_ccod as varchar)='"&bloq_ccod&"'")
		sql_bloques_vacios="SELECT (SELECT COUNT (*) FROM BLOQUES_HORARIOS AA WHERE AA.SECC_CCOD=A.SECC_CCOD)- "& _
								" (SELECT COUNT (*) FROM BLOQUES_HORARIOS AA, BLOQUES_PROFESORES BB "& _
								"  WHERE AA.SECC_CCOD=A.SECC_CCOD AND AA.BLOQ_CCOD=BB.BLOQ_CCOD and niay_ccod is null) AS VACIOS "& _
								" FROM SECCIONES A "& _
								" WHERE SECC_CCOD="&v_seccion&" "
								
		'response.Write("<pre>"&sql_bloques_vacios&"</pre>")		
						
		v_bloques_vacios=conexion.ConsultaUno(sql_bloques_vacios)
		if v_bloques_vacios="0" then
			sql_update_seccion="Update secciones set seccion_completa='S' where secc_ccod="&v_seccion&" "
		else
			sql_update_seccion="Update secciones set seccion_completa='N' where secc_ccod="&v_seccion&" "
		end if
		
		conexion.ejecutaS(sql_update_seccion)	

	end if			
next
'--------------------------------------------------------------------------------------------------------------------------------------
'f_profesor.MantieneTablas false
'response.End()
'conexion.estadotransaccion false	
'response.End()
'-----------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>