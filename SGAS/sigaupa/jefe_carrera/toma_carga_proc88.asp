<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
on error resume next
set conexion = new cConexion
set formulario = new cFormulario
set negocio = new cnegocio
set vars = new cVariables

matr_ncorr = request.Form("matr_ncorr")

conexion.inicializar "upacifico"
negocio.inicializar	conexion

etca_ccod = conexion.consultaUno ("select etca_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
if isnull(etca_ccod) or etca_ccod=1 then


	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 

    vars.procesaForm
	var = "TOMA_CARGA"
	nroVars = vars.nroFilas(var)
	
	actualiza = true
	eliminar_asignacion	=	"delete from cargas_academicas  a where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and sitf_ccod is null and not exists (select 1 from equivalencias b where a.matr_ncorr=b.matr_ncorr and a.secc_ccod=b.secc_ccod) and not exists (select 1 from calificaciones_alumnos c where a.matr_ncorr=c.matr_ncorr and a.secc_ccod=c.secc_ccod) and secc_ccod in (select a.secc_ccod " & _
                  " from cargas_academicas a, secciones b " & _
				  " where a.secc_ccod=b.secc_ccod " & _
				  " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & _
				  "	and cast(b.peri_ccod as varchar)='"&negocio.obtenerPeriodoAcademico("TOMACARGA")&"')"
	
	
	'eliminar_asignacion = "delete from cargas_academicas where matr_ncorr='" & matr_ncorr & "' and sitf_ccod is null"
	conexion.ejecutaS eliminar_asignacion
	for i = 0 to nroVars - 1
		secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
		asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
		homo_ccod = " NULL "
		asig_ccod_secc = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "'")
		
	   if asig_ccod <> asig_ccod_secc then
			area_ccod = conexion.consultaUno("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "'")
			homo_ccod = "'" & conexion.consultaUno("select homo_ccod from homologacion a, homologacion_fuente b, homologacion_destino c where a.homo_ccod=b.homo_ccod and a.homo_ccod=c.homo_ccod and cast(a.area_ccod as varchar)='" & area_ccod & "' ") & "'"
		end if

		if secc_ccod <> "" and not isnull(homo_ccod) then
			'topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & pers_ncorr & "',dias_ccod,hora_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)) from bloques_horarios where cast(secc_ccod as varchar)='" & secc_ccod & "'"
            topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & pers_ncorr & "'))"
			'response.write(" secc_ccod "&secc_ccod&" homo_ccod "&homo_ccod &" topones "& topones_cons)
		'	response.flush
			topones = conexion.consultaUno(topones_cons)
			
			cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) "& vbCrLf & _
			                       " FROM secciones a, cargas_academicas b, alumnos c "& vbCrLf & _
								   " WHERE a.secc_ccod *= b.secc_ccod "& vbCrLf & _
								   " AND b.matr_ncorr  =* c.matr_ncorr "& vbCrLf & _
								   " AND c.emat_ccod   = 1 "& vbCrLf & _
          						   " AND cast(a.secc_ccod as varchar)   = '" & secc_ccod & "' "& vbCrLf & _
          						   " group by secc_ncupo"
								 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			secc_sin_cupo_cons="select cast(asig_ccod as varchar)+ '->' +cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "' " 
			
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
			'******************* usuario que puede tomar carga sin topones **************
			 negocio.inicializa conexion
			 usuario=negocio.obtenerusuario
			 pers_ncorr=conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"& usuario &"'")
			 
			 sin_topones = conexion.consultauno("select count(*) from funcionarios where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and func_bsintopones =1")
			 response.Write("<pre>"&sin_topones&"</pre>")
	         response.End()
				if sin_topones > 0 then 
					if cupo_disponible > 0 then 
						inserta_carga_cons = "insert into cargas_academicas (matr_ncorr,secc_ccod,audi_fmodificacion) values ('" & matr_ncorr & "','" & secc_ccod &"',getDate())"
						conexion.ejecutaS inserta_carga_cons		
						actualiza_alumno_cons = "update alumnos set etca_ccod=1 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
						conexion.ejecutaS actualiza_alumno_cons
					end if
				else
					if topones > 0 then
						conexion.estadoTransaccion false
						session("mensajeError") = "Error\nExisten topones entre secciones, debe volver a asignar"
					elseif cupo_disponible < 1 then
						asig_sin=asig_sin & asig_sin_cupo
						conexion.estadoTransaccion false
						session("mensajeError") = "Error\nNo existen cupos disponible en la sección, debe volver a asignar \n" &asig_sin 
					else
						inserta_carga_cons = "insert into cargas_academicas (matr_ncorr,secc_ccod,audi_fmodificacion) values ('" & matr_ncorr & "','" & secc_ccod &"',getDate())"
						conexion.ejecutaS inserta_carga_cons		
						actualiza_alumno_cons = "update alumnos set etca_ccod=1 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
						conexion.ejecutaS actualiza_alumno_cons
					end if
				end if
		end if
	next
	horas_tomadas = conexion.consultaUno("select sum(asig_nhoras) from cargas_academicas a, secciones b, asignaturas c where a.secc_ccod=b.secc_ccod and a.sitf_ccod is null and b.asig_ccod=c.asig_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
	response.End()
	carr_ccod=conexion.consultaUno("select rtrim(ltrim(carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "'")

	if horas_tomadas > 733 and carr_ccod = "A9" then
		session("mensajeError") = "Error\nCarga horaria excede limite de 733 horas. " 
		conexion.estadoTransaccion false
	end if
	if horas_tomadas > 733 and carr_ccod = "36" then
		session("mensajeError") = "Error\nCarga horaria excede limite de 733 horas. " 
		conexion.estadoTransaccion false
	end if
	if horas_tomadas > 733 and carr_ccod = "A4" then
		session("mensajeError") = "Error\nCarga horaria excede limite de 733 horas. " 
		conexion.estadoTransaccion false
	end if
	if horas_tomadas > 733 and carr_ccod = "10" then
		session("mensajeError") = "Error\nCarga horaria excede limite de 733 horas. " 
		conexion.estadoTransaccion false
	end if
	
	'if horas_tomadas > 650 and carr_ccod <> "A9" then
	'	session("mensajeError") = "Error\nCarga horaria excede limite de 650 horas. " 
	'	conexion.estadoTransaccion false
	'end if	
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>