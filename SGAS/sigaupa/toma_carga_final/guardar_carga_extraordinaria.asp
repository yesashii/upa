
 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
mall_ccod	=	request.Form("d[0][asignatura]")
seccion		=	request.form("d[0][secc_ccod]")
matricula	=	request.form("d[0][matr_ncorr]")

set conectar 	= new cconexion
set formulario 	= new cformulario
set carga		= new cformulario
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false
'response.Write("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'<br>")
existe_ca	=clng(conectar.consultauno("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"' and sitf_ccod=null and carg_nnota_final=null"))
existe_eq	=clng(conectar.consultauno("select count(*) from equivalencias where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'"))

'conectar.EstadoTransaccion false

if existe_ca > 0  or existe_eq > 0 then
	conectar.EstadoTransaccion false
end if  
'response.Write("<hr>existe_ca "&existe_ca&" existe_eq "&existe_eq&"<hr>")
formulario.carga_parametros "toma_carga_extraordinaria.xml", "equivalencias"
formulario.inicializar conectar

carga.carga_parametros "toma_carga_extraordinaria.xml", "cargas"
carga.inicializar conectar

asignatura=conectar.consultauno("select asig_ccod from malla_curricular where cast(mall_ccod as varchar)='"& mall_ccod &"'")


carga.procesaForm
carga.agregacampopost	"acse_ncorr" , 1

'formulario.listarpost

formulario.procesaForm


formulario.agregacampopost	"mall_ccod" , mall_ccod
formulario.agregacampopost	"asig_ccod"	, asignatura
formulario.agregacampopost	"acse_ncorr" , 1
'formulario.listarpost

msj_topones = ""
msj_cupos = ""
msj_requisitos = ""	
'--------------debemos buscar para ver si el alumno tiene topones horarios 
topones_cons = "select sum(protic.topones_alumno('" & seccion & "','" & matricula & "'))"
topones = conectar.consultaUno(topones_cons)

'-----------------debemos ver si la asignatura tiene cupos---------------------------
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

tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matricula&"'")
asig_ccod_secc = asignatura

'****************** debemos revisar la suma de los creditos que tiene asignado el alumno mas los de la nueva asignatura
			 '********************en caso que el este en el plan de créditos, si pasa de 27 no debe dejar tomar la asignatura.
			 '**********************************agregado por msandoval 08-03-2006*********************************************
     		 'response.Write("<br>tipo_plan "&tipo_plan)
			 if tipo_plan <> "0"  and matricula <> "" then 
			 	cred_asignatura = conectar.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"'")
             	cred_totales = conectar.consultaUno("select protic.obtener_creditos_asignados("&matricula&")")
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




'-------------------------debemos ver si completo los requisits de la asignatura a tomar--------
pers_ncorr = session("pers_ncorr_alumno")
requisitos = conectar.consultaUno("select protic.completo_requisitos_asignatura ('"&mall_ccod&"', '" & pers_ncorr & "')")

if cInt(topones) > 0 then
	conectar.estadoTransaccion false
	msj_topones = msj_topones & conectar.ConsultaUno("select protic.detalle_topones_alumno('" & seccion & "','" & matricula & "')")
elseif cInt(cupo_disponible) < 1 then
	conectar.estadoTransaccion false
    msj_cupos = msj_cupos & asig_sin_cupo & "\n"
elseif cInt(requisitos) <> "0" then
	conectar.estadoTransaccion false
    msj_requisitos = msj_requisitos & "  El alumno no ha completado los requisitos de la asignatura que desea ser equivalente con la de su plan "
elseif tipo_plan <> "0" and msje_creditos <> "" then
	msj_creditos = " - " & msje_creditos
else
	carga.mantienetablas false
	formulario.mantienetablas false
end if	
'response.End()
msj_errores = ""
'response.End()
if msj_topones <> "" then
	msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
end if

if msj_cupos <> "" then
	msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos	
end if

if msj_requisitos <> "" then
	msj_errores = msj_errores & msj_requisitos	
end if

if msj_creditos <> "" then
	msj_errores = msj_errores & msj_creditos
end if

if msj_errores <> "" then	
	session("mensajeError") = "No se ha podido realizar la equivalencia, ya que se han producido los siguientes errores : \n\n" & msj_errores
else
	session("mensajeError") = "Carga Extraordinaria Guardada correctamente"
end if	
'response.End()	
response.Redirect("toma_carga_extraordinaria.asp")
'response.End()
%>