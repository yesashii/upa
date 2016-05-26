<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conexion = new cConexion
set formulario = new cFormulario

set vars = new cVariables

matr_ncorr = session("matr_ncorr")
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario_sesion = negocio.obtenerUsuario
'response.Write(negocio.obtenerUsuario&"<br>")

etca_ccod = conexion.consultaUno ("select etca_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
if isnull(etca_ccod) or etca_ccod=1 then
	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 
	vars.procesaForm
	var = "TOMA_CARGA"
	nroVars = vars.nroFilas(var)
	
	'------------debemos ver si la gente que inicia seción es de registro curricular o nop
	'----------si lo es puede eliminar carga normal y carga sin requisitos, sino lo es slo elimina carga normal, hay que tener cuidado con optativos deportivos
	'--------- y con las cargas extraordinarias qe no se eliminan por acá sino en la lengueta correspondiente.
	
	'response.Write("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
	sin_restriccion = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
    'response.Write(sin_restriccion)
	if sin_restriccion <> "0" then
		filtro_eliminacion = " and isnull(acse_ncorr,6) in (6,3)  " 'RC puede eliminar tanto carga normal como sin pre-requisitos 
	else
	    filtro_eliminacion = " and isnull(acse_ncorr,6) = 6 " 'solo elimina carga normal
	end if	
		
	'response.Write("<br>"&filtro_eliminacion)
	'response.End()
	actualiza = true
	eliminar_asignacion	=	"delete from cargas_academicas "& vbCrlf & _
							" where cast(matr_ncorr as varchar)='" & matr_ncorr & "' " & filtro_eliminacion& vbCrlf & _
							" and sitf_ccod is null and isnull(carg_afecta_promedio,'S') <> 'N' "& vbCrlf & _
							" and not exists (select 1 from calificaciones_alumnos c ,cargas_academicas a   "& vbCrlf & _
					 						 " where a.matr_ncorr=c.matr_ncorr "& vbCrlf & _
											 " and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' "& vbCrlf & _
									 		 " and a.secc_ccod=c.secc_ccod)  "& vbCrlf & _
							" and not exists (select 1 from equivalencias b ,cargas_academicas a  "& vbCrlf & _
											 " where a.matr_ncorr=b.matr_ncorr  "& vbCrlf & _
											 " and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' "& vbCrlf & _
											 " and a.secc_ccod=b.secc_ccod) "& vbCrlf & _
						    " and not exists (select 1 from calificaciones_alumnos c ,cargas_academicas a  "& vbCrlf & _
							 				 " where a.matr_ncorr=c.matr_ncorr  "& vbCrlf & _
											 " and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' "& vbCrlf & _
											 " and a.secc_ccod=c.secc_ccod) "& vbCrlf & _
							" and secc_ccod in (select a.secc_ccod "& vbCrlf & _
                 							   " from cargas_academicas a, secciones b "& vbCrlf & _
							 				   " where a.secc_ccod=b.secc_ccod "& vbCrlf & _
							 				   " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' "& vbCrlf & _
											   " and cast(b.peri_ccod as varchar)='"&negocio.obtenerPeriodoAcademico("TOMACARGA")&"')"
	
	consulta_eliminacion	=	"select carg.secc_ccod from cargas_academicas carg"& vbCrlf & _
							" where cast(carg.matr_ncorr as varchar)='" & matr_ncorr & "' "&filtro_eliminacion& vbCrlf & _
							" and carg.sitf_ccod is null and isnull(carg_afecta_promedio,'S') <> 'N'"& vbCrlf & _
							" and not exists (select 1 from calificaciones_alumnos c    "& vbCrlf & _
					 						 " where carg.matr_ncorr=c.matr_ncorr "& vbCrlf & _
											 " and carg.secc_ccod=c.secc_ccod)  "& vbCrlf & _
							" and not exists (select 1 from equivalencias b   "& vbCrlf & _
											 " where carg.matr_ncorr=b.matr_ncorr  "& vbCrlf & _
											 " and carg.secc_ccod=b.secc_ccod) "& vbCrlf & _
						    " and not exists (select 1 from calificaciones_alumnos c   "& vbCrlf & _
						 				 " where carg.matr_ncorr=c.matr_ncorr  "& vbCrlf & _
											 " and carg.secc_ccod=c.secc_ccod) "& vbCrlf & _
							" and secc_ccod in (select a.secc_ccod "& vbCrlf & _
                 							   " from cargas_academicas a, secciones b "& vbCrlf & _
							 				   " where a.secc_ccod=b.secc_ccod "& vbCrlf & _
							 				   " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' "& vbCrlf & _
											   " and cast(b.peri_ccod as varchar)='"&negocio.obtenerPeriodoAcademico("TOMACARGA")&"')"

    eliminar_asignacion = "delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and secc_ccod in ("&consulta_eliminacion&")"											   
	conexion.ejecutaS eliminar_asignacion
	
	msj_topones = ""
	msj_cupos = ""

	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    suma_creditos = 0.0 
	for i = 0 to nroVars - 1
		secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
		asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
		homo_ccod = " NULL "
		asig_ccod_secc = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "'")
		if asig_ccod <> asig_ccod_secc then
			area_ccod = conexion.consultaUno("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "'")
			homo_ccod = "'" & conexion.consultaUno("select homo_ccod from homologacion a, homologacion_fuente b, homologacion_destino c where a.homo_ccod=b.homo_ccod and a.homo_ccod=c.homo_ccod and cast(a.area_ccod as varchar)='" & area_ccod & "' ") & "'"
		end if
       
	    if tipo_plan <> "0" and asig_ccod_secc <> "" and not esVacio(asig_ccod_secc)  then
		   cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"'")
		   suma_creditos = suma_creditos + cdbl(cred_asignatura)
		end if
	   
		if secc_ccod <> "" and not isnull(homo_ccod) then
			topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & matr_ncorr & "'))"
			'response.Write(topones_cons)
			topones = conexion.consultaUno(topones_cons)
			cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
			                     & " FROM secciones a, cargas_academicas b, alumnos c " _
								 & " WHERE a.secc_ccod *= b.secc_ccod  " _
								 & " AND b.matr_ncorr  =* c.matr_ncorr " _
								 & " AND c.emat_ccod   = 1 " _
          						 & " AND cast(a.secc_ccod as varchar) = '" & secc_ccod & "' " _
          						 & " group by secc_ncupo"
				 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			secc_sin_cupo_cons="select cast(asig_ccod as varchar) + '->' + cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "' " 
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
			'******************* usuario que puede tomar carga sin topones **************
			 negocio.inicializa conexion
			 usuario=negocio.obtenerusuario
			 pers_ncorr=conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"& usuario &"'")
			 sin_topones = conexion.consultauno("select count(*) from funcionarios where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and func_bsintopones =1")
			 '****************** debemos revisar la suma de los creditos que tiene asignado el alumno mas los de la nueva asignatura
			 '********************en caso que el este en el plan de créditos, si pasa de 27 no debe dejar tomar la asignatura.
			 '**********************************agregado por msandoval 08-03-2006*********************************************
     		 'response.Write("<br>tipo_plan "&tipo_plan)
			 if tipo_plan <> "0"  and matr_ncorr <> "" then 
			 	cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"'")
             	cred_totales = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
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
			if cInt(topones) > 0 then
				'conexion.estadoTransaccion false
				msj_topones = msj_topones & conexion.ConsultaUno("select protic.detalle_topones_alumno('" & secc_ccod & "','" & matr_ncorr & "')")
			elseif cInt(cupo_disponible) < 1 then
				'conexion.estadoTransaccion false
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
			elseif tipo_plan <> "0" and msje_creditos <> "" then
				'conexion.estadoTransaccion false
				msj_creditos = " - " & msje_creditos
			else
			    '-----debemos ver si el alumno le estan asignado carga sin requisitos (sólo por gente de registro curricular)
				'-----de ser así debemos marcar la carga con acse_ncorr = 3 como carga sin pre-requisitos.
				mall_ccod_control=conexion.consultaUno("select mall_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
				pers_ncorr_control=conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
				completo_requisitos = conexion.consultaUno("select protic.completo_requisitos_asignatura ("&mall_ccod_control&", '" & pers_ncorr_control & "')")
			    'response.Write("<br> grabo")
				if completo_requisitos ="0" then
				  inserta_carga_cons = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                       "select '" & matr_ncorr & "','" & secc_ccod & "','" & negocio.obtenerusuario & "', getDate()  " & vbCrLf &_
									   "where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				else
				  inserta_carga_cons = " insert into cargas_academicas (matr_ncorr, secc_ccod,acse_ncorr, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                       " select '" & matr_ncorr & "','" & secc_ccod & "',3,'" & negocio.obtenerusuario & "', getDate()  " & vbCrLf &_
									   " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				end if					
				'response.Write(inserta_carga_cons) 
				conexion.ejecutaS inserta_carga_cons		
				actualiza_alumno_cons = "update alumnos set etca_ccod=2 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
				conexion.ejecutaS actualiza_alumno_cons
				'response.End()
			end if
		end if
	next
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
msj_errores = ""
'response.End()
if not EsVacio(msj_topones) then
	msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
end if

if not EsVacio(msj_cupos) then
	msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos	
end if

if msj_creditos <> "" then
	msj_errores = msj_errores & msj_creditos
end if

'------------------------------------------------------------------------------------------------------------------------
if not EsVacio(msj_errores) then	
	conexion.MensajeError "No se guardó la toma de carga por completo, ya que se han producido los siguientes errores : \n\n" & msj_errores
else
	conexion.MensajeError "Se ha guardado toda la carga."
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>