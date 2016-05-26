<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'---------------------------------------------------------------------------------------------------

'Response.AddHeader "Content-Disposition", "attachment;filename=reporte_grl.txt"
'Response.ContentType = "text/plain;charset=UTF-8"
Server.ScriptTimeOut = 1500000
set conexion = new CConexion
conexion.Inicializar "upacifico"

  
c_delete = "delete FROM PROMEDIOS_ALUMNOS_CARRERA WHERE PERI_CCOD=226 "
conexion.ejecutaS c_delete

c_insert =  " insert into PROMEDIOS_ALUMNOS_CARRERA "& vbCrLf &_
			" select distinct a.pers_ncorr,c.carr_ccod,b.peri_ccod, "& vbCrLf &_
			" (select cast(avg(carg_nnota_final) as decimal(2,1))  "& vbCrLf &_
			" from cargas_academicas tt, secciones t2, asignaturas t3  "& vbCrLf &_
			" where tt.matr_ncorr=a.matr_ncorr and isnull(tt.carg_nnota_final,0.0) >= 1.0 "& vbCrLf &_
			" and tt.secc_ccod=t2.secc_ccod and t2.asig_ccod=t3.asig_ccod and t3.duas_ccod <> 3) as promedio,'automatico' as audi_tusuario, getDate() as audi_fmodificacion "& vbCrLf &_
			" from alumnos a, ofertas_academicas b, especialidades c "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			" and b.peri_ccod=226 and a.alum_nmatricula <> 7777 "& vbCrLf &_
			" and a.emat_ccod not in (9,6,11)  "& vbCrLf &_
			" and exists (select 1 from cargas_academicas tt, secciones t2, asignaturas t3  "& vbCrLf &_
			"   		where tt.matr_ncorr=a.matr_ncorr and isnull(tt.carg_nnota_final,0.0) >= 1.0 "& vbCrLf &_
			"			and tt.secc_ccod=t2.secc_ccod and t2.asig_ccod=t3.asig_ccod and t3.duas_ccod <> 3) "& vbCrLf &_
			" order by PROMEDIO DESC "
conexion.ejecutaS c_insert

if conexion.ObtenerEstadoTransaccion then
	response.Write("<table bgColor=green><tr><td width='100%'><strong>GRABADO EXITOSO</strong></td></tr></table>")
else
	response.Write("<table bgColor=red><tr><td width='100%'><strong>ERROR AL GRABAR</strong></td></tr></table>")
end if
					   
%>