<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
'response.End()
	
audi_tusuario	=	request.form("audi_tusuario")
secc_ccod   	=	request.form("secc_ccod")
mes_recibido	=	request.form("mes2")


set conectar		=	new cconexion
conectar.inicializar		"upacifico"

pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&audi_tusuario&"'")
periodo = conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar) = '"&secc_ccod&"'")
anos_ccod = conectar.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar) = '"&periodo&"'")
sem1 = conectar.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar) = '"&anos_ccod&"' and plec_ccod = 1 ")


set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conectar

c_alumnos = " select a.matr_ncorr, pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as nombre "&_
            " from cargas_academicas a, alumnos b, personas c "&_
			" where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr and b.emat_ccod <> 9 "&_
			" and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "&_
			" order by nombre "

f_alumnos.Consultar c_alumnos

set f_cal = new CFormulario
f_cal.Carga_Parametros "tabla_vacia.xml", "tabla"
f_cal.Inicializar conectar

c_cal = " select distinct f.cale_fcalendario, "& vbCrLf &_
		" protic.trunc(f.cale_fcalendario) as fecha,protic.trunc(f.cale_fcalendario) as fecha2,h.dias_tdesc as dia,b.bloq_ccod "& vbCrLf &_
		" from secciones a, bloques_horarios b, bloques_profesores c,carreras d, "& vbCrLf &_
		"      asignaturas e, calendario f, dias_semana h,horarios i  "& vbCrLf &_
		" where a.secc_ccod=b.secc_ccod  "& vbCrLf &_
		"	and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
		"	and b.dias_ccod=h.dias_ccod "& vbCrLf &_
		" 	and b.hora_ccod=i.hora_ccod "& vbCrLf &_
		"	and a.carr_ccod=d.carr_ccod "& vbCrLf &_
		"	and a.asig_ccod=e.asig_ccod "& vbCrLf &_
		"	and convert(datetime,f.cale_fcalendario,103) between convert(datetime,b.bloq_finicio_modulo,103) and case when convert(datetime,b.bloq_ftermino_modulo,103) < convert(datetime,getDate(),103) then convert(datetime,b.bloq_ftermino_modulo,103) else convert(datetime,getDate(),103) end "& vbCrLf &_
		"	and datepart(weekday,f.cale_fcalendario) = b.dias_ccod "& vbCrLf &_
		" 	and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&sem1&"' else '"&periodo&"' end "& vbCrLf &_
		"	and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
		"	and datepart(year,f.cale_fcalendario)='"&anos_ccod&"' "& vbCrLf &_
		"	and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
		"	and cast(datepart(month,f.cale_fcalendario) as varchar)='"&mes_recibido&"' "& vbCrLf &_
		"   and (select count(*) from libros_clases tt, prestamos_libros t2 "& vbCrLf &_
 		"        where tt.pers_ncorr=c.pers_ncorr and tt.secc_ccod=a.secc_ccod  "& vbCrLf &_
		"        and tt.libr_ncorr=t2.libr_ncorr and t2.bloq_ccod=c.bloq_ccod "& vbCrLf &_
		"        and pres_estado_prestamo=6 and protic.trunc(f.cale_fcalendario) = protic.trunc(pres_fprestamo)) = 0  "& vbCrLf &_
		" union "& vbCrLf &_
		"  select distinct f.cale_fcalendario,  "& vbCrLf &_
		"  protic.trunc(f.cale_fcalendario) as fecha,protic.trunc(t3.fecha_recuperacion) as fecha2,  "& vbCrLf &_
		"  h.dias_tdesc as dia, b.bloq_ccod  "& vbCrLf &_
		"  from secciones a, bloques_horarios b, bloques_profesores c,carreras d,  "& vbCrLf &_
		"       asignaturas e, calendario f, dias_semana h,horarios i,libros_clases tt,  "& vbCrLf &_
		"       prestamos_libros t2, registro_recuperativas t3  "& vbCrLf &_
		"  where a.secc_ccod=b.secc_ccod  "& vbCrLf &_
		"  and b.bloq_ccod=c.bloq_ccod  "& vbCrLf &_
		"  and b.dias_ccod=h.dias_ccod  "& vbCrLf &_
		"  and b.hora_ccod=i.hora_ccod  "& vbCrLf &_
		"  and a.carr_ccod=d.carr_ccod 	 "& vbCrLf &_
		"  and a.asig_ccod=e.asig_ccod  "& vbCrLf &_
		"  and tt.pers_ncorr=c.pers_ncorr and tt.secc_ccod=a.secc_ccod  "& vbCrLf &_
		"  and tt.libr_ncorr=t2.libr_ncorr and t2.bloq_ccod=c.bloq_ccod  "& vbCrLf &_
		"  and t2.pres_estado_prestamo=6 and protic.trunc(f.cale_fcalendario) = protic.trunc(t2.pres_fprestamo)  "& vbCrLf &_
		"  and t2.pres_ncorr = t3.pres_ncorr  "& vbCrLf &_
		"  and convert(datetime,f.cale_fcalendario,103) between convert(datetime,b.bloq_finicio_modulo,103)  "& vbCrLf &_
		"  and case when convert(datetime,b.bloq_ftermino_modulo,103) < convert(datetime,getDate(),103)  "& vbCrLf &_
		"           then convert(datetime,b.bloq_ftermino_modulo,103) else convert(datetime,getDate(),103) end   "& vbCrLf &_
		"  and datepart(weekday,f.cale_fcalendario) = b.dias_ccod  "& vbCrLf &_		
		"  and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&sem1&"' else '"&periodo&"' end "& vbCrLf &_
		"  and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
		"  and datepart(year,f.cale_fcalendario)='"&anos_ccod&"' "& vbCrLf &_
		"  and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "&_
		"  and cast(datepart(month,f.cale_fcalendario) as varchar)='"&mes_recibido&"' "& vbCrLf &_
		" order by fecha  "

f_cal.Consultar c_cal
nro_cal = f_cal.nroFilas
'response.Write("<pre>"&c_cal&"</pre>")

acciones = 0
while f_alumnos.siguiente
	matr_ncorr = f_alumnos.obtenerValor("matr_ncorr")
	
	f_cal.primero
	while f_cal.siguiente
	   fechita = f_cal.obtenerValor("fecha2")
	   fechitaHora = f_cal.obtenerValor("cale_fcalendario")
	   bloque = f_cal.obtenerValor("bloq_ccod")
	   asistencia_ingresada = request.Form("m["&matr_ncorr&"]["&bloque&"_"&fechita&"]") 
	   if asistencia_ingresada = "" then
	      asistencia_ingresada = "0"
	   end if
	   asistencia_registrada = request.Form("o["&matr_ncorr&"]["&bloque&"_"&fechita&"]") 

	   if asistencia_registrada ="2" then
		c_consulta = " insert into ADA_ASISTENCIAS_DIARIAS_ALUMNOS (MATR_NCORR,SECC_CCOD,BLOQ_CCOD,FECHA_CLASE,ASISTE,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
					 " values ("&matr_ncorr&","&secc_ccod&","&bloque&",convert(datetime,'"&fechita&"',103),'"&asistencia_ingresada&"','"&audi_tusuario&"',getDate())"
		conectar.ejecutaS c_consulta
		if asistencia_ingresada = "1" then 
		acciones = acciones + 1
	    end if
		
	   elseif asistencia_registrada <> "2" and asistencia_ingresada <> asistencia_registrada then
	   	c_consulta = " update ADA_ASISTENCIAS_DIARIAS_ALUMNOS  set ASISTE='"&asistencia_ingresada&"', AUDI_TUSUARIO='"&audi_tusuario&"',AUDI_FMODIFICACION=getDate()"&_
		             " where cast(MATR_NCORR as varchar) = '"&matr_ncorr&"' and cast(SECC_CCOD as varchar)='"&secc_ccod&"' and cast(BLOQ_CCOD as varchar)='"&bloque&"' and convert(datetime,FECHA_CLASE,103) = convert(datetime,'"&fechita&"',103) "				
	    conectar.ejecutaS c_consulta
		acciones = acciones + 1
	   end if
	   'response.Write(c_consulta)
	wend
wend

	

'response.End()

if conectar.ObtenerEstadoTransaccion = true and acciones > 0  then
	conectar.MensajeError "Se han realizado "&acciones&" accion(es) referida(s) a ingresos de asistencia de alumnos."
elseif conectar.ObtenerEstadoTransaccion = false then
	conectar.MensajeError "Ocurrio un error al grabar las asistencias diarias, favor vuelva a intentarlo..."
end if


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>