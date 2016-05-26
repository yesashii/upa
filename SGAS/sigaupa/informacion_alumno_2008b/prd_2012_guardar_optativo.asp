<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
matr_ncorr	=	request.FORM("matr_ncorr")
seccion		=	request.FORM("a[0][secc_ccod]")
asignatura	=	request.FORM("a[0][asig_ccod]")
'afecta_promedio = request.FORM("d[0][carg_afecta_promedio]")


set conectar 	= new cconexion
set carga		= new cformulario
conectar.inicializar "upacifico"


'####################################################
'campos de auditoria (mriffo)
set negocio	=	new cnegocio
negocio.Inicializa conectar
v_usuario	=	negocio.ObtenerUsuario
'####################################################
'response.Write("Usuario :"&v_usuario)
'response.End()
'debemos revisar si el alumno presenta topones como para tomar esta asignatura
topones_cons = "select sum(protic.topones_alumno_nuevo_2('" & seccion & "','" & matr_ncorr & "'))"
'response.Write(topones_cons)
'response.End()
topones = conectar.consultaUno(topones_cons)
'debemos ver si la asignatura optativa tiene cupos disponibles 
cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
                     & " FROM secciones a, cargas_academicas b, alumnos c " _
					 & " WHERE a.secc_ccod *= b.secc_ccod  " _
					 & " AND b.matr_ncorr  =* c.matr_ncorr " _
					 & " AND c.emat_ccod   = 1 " _
					 & " AND cast(a.secc_ccod as varchar) = '" & seccion & "' " _
					 & " group by secc_ncupo"
cupo_disponible = conectar.consultaUno(cupo_disponible_cons)
secc_sin_cupo_cons="select cast(asig_ccod as varchar) + '->' + cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & seccion & "' " 
asig_sin_cupo=conectar.consultaUno(secc_sin_cupo_cons)

tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
'****************** debemos revisar la suma de los creditos que tiene asignado el alumno mas los de la nueva asignatura
			 '********************en caso que el este en el plan de créditos, si pasa de 27 no debe dejar tomar la asignatura.
			 '**********************************agregado por msandoval 08-03-2006*********************************************
     		 'response.Write("<br>tipo_plan "&tipo_plan)
			 if tipo_plan <> "0"  and matr_ncorr <> "" then 
			 	cred_asignatura = 3.0
             	cred_totales = conectar.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
			    'response.Write("<br>cred_asignatura "&cred_asignatura&" cred_totales "&cred_totales)
				total_a_asignar = cdbl(cred_asignatura) + cdbl(cred_totales)
				'response.Write("<br>total a asignar "&total_a_asignar)
				if cint(total_a_asignar) > 27 then
				    'response.Write("asigna mensaje")
					msje_creditos = "Imposible realizar la toma de carga solicitada, con ello se excedería el límite de 27 créditos."
				end if
				'response.Write("total "&total_a_asignar&" "&msje_creditos)
			end if
'----------------*******************----------------***********************--------------------*************************


if cInt(topones) > 0  or cInt(cupo_disponible) < 1 then
	' debemos para la inserción del optativo pues tiene topones o ya se completaron todos los cupos
	if cInt(topones) > 0 then
		msj_topones = conectar.ConsultaUno("select protic.detalle_topones_alumno_nuevo_2('" & seccion & "','" & matr_ncorr & "')")
		'response.Write("select protic.detalle_topones_alumno_nuevo_2('" & seccion & "','" & matr_ncorr & "')")
		'response.End()
		msj_errores = "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
	end if
	if tipo_plan <> "0" and msje_creditos <> "" then
	    msj_creditos = " - " & msje_creditos
		msj_errores =  msj_creditos
	end if
	if cInt(cupo_disponible) < 1 then
		msj_cupos = "   - " & asig_sin_cupo & "\n"
	    msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos
	end if
	session("mensajeError") = "No se pudo guardar el optativo porque se han producido los siguientes errores : \n\n" & msj_errores
else
	if afecta_promedio="" or afecta_promedio="N" then
		' se debe grabar la asignatura diractamente en la tabla cargas_Academicas  y como no afecta el promedio se lo debemos indicar en el campo correspondiente
		consulta_insercion = " insert into cargas_Academicas (matr_ncorr,secc_ccod,carg_afecta_promedio, audi_tusuario, audi_fmodificacion,fecha_ingreso_carga,usuario,tipo_carga)"&_
							 " values ("&matr_ncorr&","&seccion&",'N','"&v_usuario&" (Online)',getdate(),getDate(),'Alumno','Deportivo')"
		conectar.ejecutas consulta_insercion
		session("mensajeError") = "Optativo deportivo asignado exitosamente"
	
	end if
end if ' fin del if por que el alumno no tiene topones y la sección aún tiene cupos

response.Redirect("ingreso_optativos.asp")

%>
