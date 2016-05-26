<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
nueva_secc_ccod=request.Form("d[0][secc_ccod]")
cantidad_transferible=request.Form("cantidad_transferible")
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
msj_errores=""
cupos_nueva_seccion=conectar.consultaUno("select secc_ncupo - (select count(*) from cargas_academicas b  where b.secc_ccod=a.secc_ccod) from secciones a where cast(a.secc_ccod as varchar)='"&nueva_secc_ccod&"'")
'response.Write("<hr><center>cantidad_transferible= "&cantidad_transferible&" cupos_nueva_seccion ="&cupos_nueva_seccion&"</center><hr>")
if (cint(cupos_nueva_seccion) < cint(cantidad_transferible)) then
	msj_errores = "- La Cantidad de alumnos( "&cantidad_transferible&" ) es mayor que los cupos disponibles de la nueva sección ( " & cupos_nueva_seccion & " )"
end if

if msj_errores<>"" then
    conectar.estadotransaccion false	
	conectar.MensajeError "No se realizó el cambio de sección porque se han producido los siguientes errores : \n\n" & msj_errores
	response.Redirect(request.ServerVariables("HTTP_REFERER"))

else
formulario.carga_parametros "cambio_seccion.xml", "f_alumnos"
formulario.inicializar conectar
msj_topones=""
cantidad_traspasados=0
cantidad_evaluados=0
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	matr_ncorr=formulario.obtenerValorPost(i,"matr_ncorr")
	secc_ccod=formulario.obtenerValorPost(i,"secc_ccod")
	if not EsVacio(matr_ncorr) and not EsVacio(secc_ccod) and not EsVacio(nueva_secc_ccod) then
	
	    horario_original = conectar.consultaUno("select protic.horario('"&secc_ccod&"')")
		horario_nuevo = conectar.consultaUno("select protic.horario('"&nueva_secc_ccod&"')")
		'response.Write("original "&horario_original&" nuevo "&horario_nuevo)
		'response.End()
		if cstr(horario_original) <> cstr(horario_nuevo) then
			topones_cons = "select isnull(sum(protic.topones_alumno_nuevo_2('" & nueva_secc_ccod & "','" & matr_ncorr & "')),0)"
			topones = conectar.consultaUno(topones_cons)
		else
		    topones = "0"	
		end if
		'response.Write("select sum(protic.topones_alumno('" & nueva_secc_ccod & "','" & matr_ncorr & "'))")
		'debemos ver si el alumno ya tiene una evaluación realizada de ser así no podemos hacer el cambio de sección.
		evaluado = "select isnull(count(*),0) from calificaciones_alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		canti_evaluado = conectar.consultaUno(evaluado)	
	
		consulta_update = " Update cargas_academicas set secc_ccod= "&nueva_secc_ccod&" where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
		                  " and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		'en el caso en que la alumno ya tenga evaluaciones para esta sección se debe traspasar la evaluación a la nueva seccion
		if cInt(canti_evaluado)=0 then
			if cInt(topones) = 0 then	
				'response.Write("<br>"&consulta_update)  
				conectar.ejecutaS consulta_update
				cantidad_traspasados = cantidad_traspasados + 1		
			else
							  
			end if
			
		else
			cantidad_evaluados=cantidad_evaluados + 1
		end if 	

	end if 
next 
if cint(topones)=0 and cantidad_evaluados="0" then
	conectar.MensajeError "El Cambio de Sección se ha realizado exitosamente"
else
	if cint(topones) > 0  then
		conectar.MensajeError " No se pudo realizar el cambio de sección porque existen alumnos que presentan topones de horario"
	end if
	
	if cantidad_traspasados > 0  then
		conectar.MensajeError "Se cambiaron "&cantidad_traspasados&" alumnos  de sección, pero existen alumnos que presentaron topones de horario"
	end if
	if cantidad_evaluados > 0  then
		conectar.MensajeError "Se cambiaron "&cantidad_traspasados&" alumnos  de sección, pero existen alumnos que ya fueron evaluados en esta sección"
	end if
end if
'formulario.mantienetablas true
'conectar.estadotransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if
%>
