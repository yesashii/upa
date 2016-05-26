
 <!-- #include file="../biblioteca/_conexion.asp" -->
 <!-- #include file = "../biblioteca/_negocio.asp" -->
 
<%
'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: TOMA CARGA ACADÉMICA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 18/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 53, 54
'********************************************************************

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
seccion		=	request.form("busqueda[0][SECC_CCOD]")
matricula	=	request.form("matr_ncorr")

set conectar 	= new cconexion
set formulario 	= new cformulario
set carga		= new cformulario
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


'conectar.estadoTransaccion false
'response.Write("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'<br>")
existe_ca	=clng(conectar.consultauno("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'"))

if existe_ca > 0 then
	conectar.EstadoTransaccion false
end if  
'--------------debemos buscar para ver si el alumno tiene topones horarios 
topones_cons = "select isnull(sum(protic.topones_alumno_nuevo_2('" & seccion & "','" & matricula & "')),0)"
topones = conectar.consultaUno(topones_cons)

'-----------------debemos ver si la asignatura tiene cupos---------------------------
'cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
'			                     & " FROM secciones a, cargas_academicas b, alumnos c " _
'								 & " WHERE a.secc_ccod *= b.secc_ccod  " _
'								 & " AND b.matr_ncorr  =* c.matr_ncorr " _
'								 & " AND c.emat_ccod   = 1 " _
'         						 & " AND cast(a.secc_ccod as varchar) = '" & seccion & "' " _
'          						 & " group by secc_ncupo"
cupo_disponible_cons = "select  secc_ncupo - count(b.secc_ccod) " _
			& "from secciones a " _
			& "left outer join cargas_academicas b " _
			& "	on a.secc_ccod = b.secc_ccod " _
			& "left outer join alumnos c " _ 
			& "	on b.matr_ncorr = c.matr_ncorr " _
			& "	and c.emat_ccod = 1 " _	
			& "where cast(a.secc_ccod as varchar) = '" & seccion & "' " _
			& "group by secc_ncupo "								 
'response.Write(cupo_disponible_cons)				 
'response.End()
cupo_disponible = conectar.consultaUno(cupo_disponible_cons)
secc_sin_cupo_cons = " select cast(asig_ccod as varchar) + '->' + cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & seccion & "' " 
asig_sin_cupo=conectar.consultaUno(secc_sin_cupo_cons)

'-------------------------debemos ver si completo los requisits de la asignatura a tomar--------
pers_ncorr = conectar.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matricula&"'")

tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matricula&"'")
asig_ccod_secc = conectar.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar) = '" & seccion & "'")

if tipo_plan <> "0"  and matricula <> "" then 
 	cred_asignatura = conectar.consultaUno("select isnull(cred_valor,0.0) from asignaturas a left outer join creditos_Asignatura b on a.cred_ccod=b.cred_ccod  where asig_ccod = '"&asig_ccod_secc&"'")
   	cred_totales = conectar.consultaUno("select isnull(protic.obtener_creditos_asignados("&matricula&"),0.0)")
	'response.Write("select isnull(cred_valor,0.0) from (select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"')table1")
	'response.Write("<br>cdbl("&cred_asignatura&") + cdbl("&cred_totales&")")
	total_a_asignar = cdbl(cred_asignatura) + cdbl(cred_totales)
	if cint(total_a_asignar) > 27 then
		msje_creditos = "Imposible realizar la toma de carga solicitada, con ello se excedería el límite de 27 créditos."
	end if
end if



if cInt(topones) > 0 then
	'conectar.estadoTransaccion false
	msj_topones = msj_topones & conectar.ConsultaUno("select protic.detalle_topones_alumno_nuevo_2('" & seccion & "','" & matricula & "')")
elseif cInt(cupo_disponible) < 1 then
	conectar.estadoTransaccion false
    msj_cupos = msj_cupos & asig_sin_cupo & "\n"
elseif tipo_plan <> "0" and msje_creditos <> "" then
	msj_creditos = " - " & msje_creditos
end if	

if cInt(cupo_disponible) >= 1 and conectar.obtenerEstadoTransaccion then
 c_inserta = " insert into cargas_academicas (matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_presentacion,carg_nnota_final,acse_ncorr,audi_tusuario,audi_fmodificacion,fecha_ingreso_carga,usuario) "&_
             " values ("&matricula&","&seccion&",NULL,NULL,NULL,3,'Agrega "&negocio.obtenerUsuario&"',getDate(),getDate(),'Directivo') "
 conectar.ejecutaS c_inserta
end if

'response.Write(c_inserta)
'response.End()
msj_errores = ""
if msj_topones <> "" then
	msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
end if

if msj_cupos <> "" then
	msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos	
end if

if msj_creditos <> "" then
	msj_errores = msj_errores & "\n" & msj_creditos
end if
'response.End()

if  msj_cupos <> "" then	
	session("mensajeError") = "No se ha podido registrar la carga, se han producido los siguientes errores : \n\n" & msj_errores
else
    if conectar.obtenerEstadoTransaccion then
		session("mensajeError") = "Carga asignada correctamente, \n"&msj_errores
	else
		session("mensajeError") = "Imposible realizar la carga, ya existe o hay problemas en la instrucción de inserción."
	end if	
end if	
'response.End()	
response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
%>