<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: NA 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 03/04/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *= , =*
'LINEA				          : 115, 116
'********************************************************************
on error resume next
set conexion = new cConexion
set formulario = new cFormulario
set negocio = new cnegocio
set vars = new cVariables

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

matr_ncorr = request.Form("matr_ncorr")
'response.Write("<pre><br>"&matr_ncorr&"</pre>")
conexion.inicializar "upacifico"
negocio.inicializar	conexion


'conexion.EstadoTransaccion false



etca_ccod = conexion.consultaUno ("select etca_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
if isnull(etca_ccod) or etca_ccod=1 then
	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 
	vars.procesaForm
	var = "TOMA_CARGA"
	nroVars = vars.nroFilas(var)
	
	actualiza = true
	eliminar_asignacion	=	"delete from cargas_academicas "& vbCrlf & _
							" where cast(matr_ncorr as varchar)='" & matr_ncorr & "'  "& vbCrlf & _
							" and sitf_ccod is null "& vbCrlf & _
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
							" where cast(carg.matr_ncorr as varchar)='" & matr_ncorr & "'  "& vbCrlf & _
							" and carg.sitf_ccod is null "& vbCrlf & _
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
   'response.Write("<pre>"&eliminar_asignacion&"</pre>")
	'response.End()
	conexion.ejecutaS eliminar_asignacion
	
	msj_topones = ""
	msj_cupos = ""
	'response.Write("<br>numero vars "&nroVars)
	for i = 0 to nroVars - 1
		secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
		asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
		'response.Write(secc_ccod)
		'response.End()
		homo_ccod = " NULL "
		asig_ccod_secc = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "'")
		if asig_ccod <> asig_ccod_secc then
			area_ccod = conexion.consultaUno("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "'")
			homo_ccod = "'" & conexion.consultaUno("select homo_ccod from homologacion a, homologacion_fuente b, homologacion_destino c where a.homo_ccod=b.homo_ccod and a.homo_ccod=c.homo_ccod and cast(a.area_ccod as varchar)='" & area_ccod & "' ") & "'"
		end if
        'response.Write("<br>area_ccod "&area_ccod&" homo_ccod "&homo_ccod)
		if secc_ccod <> "" and not isnull(homo_ccod) then
			topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & matr_ncorr & "'))"
		
		'	response.flush
			topones = conexion.consultaUno(topones_cons)
			'response.Write("<br>topones "&topones)
'			cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
'			                     & " FROM secciones a, cargas_academicas b, alumnos c " _
'								 & " WHERE a.secc_ccod *= b.secc_ccod  " _
'								 & " AND b.matr_ncorr  =* c.matr_ncorr " _
'								 & " AND c.emat_ccod   = 1 " _
'          						 & " AND cast(a.secc_ccod as varchar) = '" & secc_ccod & "' " _
'          						 & " group by secc_ncupo"
          						 
'----------------------------------------------------------------------------------nueva consulta 2008
cupo_disponible_cons = "select a.secc_ncupo - count(b.secc_ccod)        " _
& "from   secciones as a                                                " _
& "       left outer join (cargas_academicas as b                       " _
& "                        left outer join alumnos as c                " _
& "                                      on c.matr_ncorr = b.matr_ncorr " _
& "                                         and c.emat_ccod = 1 )       " _
& "                    on a.secc_ccod = b.secc_ccod                     " _
& "where  cast(a.secc_ccod as varchar) = '" & secc_ccod & "'            " _
& "group  by a.secc_ncupo                                               " 
'----------------------------------------------------------------------------------fin nueva consulta 2008
          						 
			'response.Write(cupo_disponible_cons)
		    'response.End()					 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			'response.Write("<br>cupo_disponible "&cupo_disponible)
			secc_sin_cupo_cons="select cast(asig_ccod as varchar) + '->' + cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "' " 
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
			'response.Write("<br>asig_sin_cupo "&asig_sin_cupo)
			'******************* usuario que puede tomar carga sin topones **************
			 negocio.inicializa conexion
			 usuario=negocio.obtenerusuario
			 pers_ncorr=conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"& usuario &"'")
			 'response.Write("<br>pers_ncorr "&pers_ncorr)
			 sin_topones = conexion.consultauno("select count(*) from funcionarios where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and func_bsintopones =1")
			'if cInt(topones) > 0 then
			'response.Write("<br>entre 1")
				'conexion.estadoTransaccion false
				'msj_topones = msj_topones & conexion.ConsultaUno("select protic.detalle_topones_alumno('" & secc_ccod & "','" & matr_ncorr & "')")
				'response.Write("select protic.detalle_topones_alumno('" & secc_ccod & "','" & matr_ncorr & "')")
			'else
			if cInt(cupo_disponible) < 1 then
			'response.Write("<br>entre 2")
				'asig_sin = asig_sin & asig_sin_cupo
				conexion.estadoTransaccion false
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
				'response.Write("msj "&msj_cupos)
				'session("mensajeError") = "Error\nNo existen cupos disponible en la sección, debe volver a asignar \n" &asig_sin 
			else
			    'response.Write("<br> entre al else")
				'inserta_carga_cons = "insert into cargas_academicas (matr_ncorr,secc_ccod,audi_tusuario,audi_fmodificacion) values ('" & matr_ncorr & "','" & secc_ccod &"','"&negocio.obtenerusuario&"',SYSDATE)"
				inserta_carga_cons = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                     "select '" & matr_ncorr & "','" & secc_ccod & "','" & negocio.obtenerusuario & "', getDate()  " & vbCrLf &_
									 "where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				'response.Write("<br><pre>"&inserta_carga_cons&"</pre>")
				conexion.ejecutaS inserta_carga_cons		
				actualiza_alumno_cons = "update alumnos set etca_ccod=2 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
				'response.Write("<pre>"&actualiza_alumno_cons&"</pre>")
				conexion.ejecutaS actualiza_alumno_cons
			end if
		end if
	next
end if
'response.End()

'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
msj_errores = ""

'if not EsVacio(msj_topones) then
	'msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
'end if

if not EsVacio(msj_cupos) then
	msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos	
end if

'------------------------------------------------------------------------------------------------------------------------
if not EsVacio(msj_errores) then	
	conexion.MensajeError "No se guardó la toma de carga porque se han producido los siguientes errores : \n\n" & msj_errores
end if

if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "Se ha guardado la carga."
end if
'response.End()
'response.Write("errores "&msj_topones)
'response.End()
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>