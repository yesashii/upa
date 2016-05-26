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
'response.Write(matr_ncorr)
'response.End()

conexion.inicializar "upacifico"
negocio.inicializar	conexion

'conexion.EstadoTransaccion false

etca_ccod = conexion.consultaUno ("select etca_ccod from  alumnos where cast(matr_ncorr as varchar) ='" & matr_ncorr & "'")
'response.Write(etca_ccod)
if isnull(etca_ccod) or isEmpty(etca_ccod) or etca_ccod=1 then
	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar) ='" & matr_ncorr & "'") 
	vars.procesaForm
	var = "TOMA_CARGA"
	nroVars = vars.nroFilas(var)
	
	actualiza = true
	eliminar_asignacion	=	"delete from cargas_academicas   " & vbCrlf & _
							" where matr_ncorr='" & matr_ncorr & "'  " & vbCrlf & _
							" and sitf_ccod is null " & vbCrlf & _
							" and not exists (select 1 from cargas_academicas a,calificaciones_alumnos c  " & vbCrlf & _
					 						 " where a.matr_ncorr=c.matr_ncorr " & vbCrlf & _
									 		 " and a.secc_ccod=c.secc_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"') " & vbCrlf & _
							" and not exists (select 1 from cargas_academicas a,equivalencias b " & vbCrlf & _
											 " where a.matr_ncorr=b.matr_ncorr  " & vbCrlf & _
											 " and a.secc_ccod=b.secc_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"') " & vbCrlf & _
											 " and not exists (select 1 from cargas_academicas a,calificaciones_alumnos c " & vbCrlf & _
											 				 " where a.matr_ncorr=c.matr_ncorr  " & vbCrlf & _
															 " and a.secc_ccod=c.secc_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"') " & vbCrlf & _
							" and secc_ccod in (select a.secc_ccod " & vbCrlf & _
                 							   " from cargas_academicas a, secciones b " & vbCrlf & _
							 				   " where a.secc_ccod=b.secc_ccod " & vbCrlf & _
							 				   " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrlf & _
											   " and cast(b.peri_ccod as varchar)='"&negocio.obtenerPeriodoAcademico("TOMACARGA")&"')"
	
	'Response.Write("<pre>"  & eliminar_asignacion & "</pre>")
	'response.End()
	conexion.ejecutaS eliminar_asignacion
	'response.End()
	for i = 0 to nroVars - 1
		secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
		asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
		homo_ccod = " NULL "
		asig_ccod_secc = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar)= '" & secc_ccod & "'")
		if asig_ccod <> asig_ccod_secc then
			area_ccod = conexion.consultaUno("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar) ='" & matr_ncorr & "'")
			homo_ccod = "'" & conexion.consultaUno("select homo_ccod from homologacion a, homologacion_fuente b, homologacion_destino c where a.homo_ccod=b.homo_ccod and a.homo_ccod=c.homo_ccod and cast(a.area_ccod as varchar) ='" & area_ccod & "' ") & "'"
		end if

		if secc_ccod <> "" and not isnull(homo_ccod) then
			topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & matr_ncorr & "'))"
			'response.write (topones_cons&"<br>")
		'	response.flush
			topones = conexion.consultaUno(topones_cons)
			
			cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
			                     & " FROM secciones a, cargas_academicas b, alumnos c " _
								 & " WHERE a.secc_ccod *= b.secc_ccod  " _
								 & " AND b.matr_ncorr  =* c.matr_ncorr " _
								 & " AND c.emat_ccod   = 1 " _
          						 & " AND cast(a.secc_ccod as varchar) = '" & secc_ccod & "' " _
          						 & " group by secc_ncupo"
			'response.Write("<pre>"&cupo_disponible_cons&"</pre>")
			'response.End()					 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			secc_sin_cupo_cons="select asig_ccod + '->' + secc_tdesc from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "' " 
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
			'******************* usuario que puede tomar carga sin topones **************
			 negocio.inicializa conexion
			 usuario=negocio.obtenerusuario
			 pers_ncorr=conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar) ='"& usuario &"'")
			 sin_topones = conexion.consultauno("select count(*) from funcionarios where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and func_bsintopones =1")
			 'response.Write(topones&"<br>")
			
					
				inserta_carga_cons = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                     "select '" & matr_ncorr & "','" & secc_ccod & "','" & negocio.obtenerusuario & "', getdate() " & vbCrLf &_
									 "where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar) = '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				
				'Response.Write("<pre>" & inserta_carga_cons & "</pre>")
				conexion.ejecutaS inserta_carga_cons		
				actualiza_alumno_cons = "update alumnos set etca_ccod=2 where cast(matr_ncorr as varchar) ='" & matr_ncorr & "'"		
				conexion.ejecutaS actualiza_alumno_cons
	
		end if
	next
	
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>