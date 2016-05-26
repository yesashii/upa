<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.form(x))
'next


set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_datos_antiguos = new CFormulario
f_datos_antiguos.Carga_Parametros "consulta.xml", "consulta"

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "encasillar_alumno.xml", "alumno"
f_alumno.Inicializar conexion
f_alumno.ProcesaForm

for fila = 0 to f_alumno.CuentaPost - 1
	v_matricula = f_alumno.ObtenerValorPost (fila, "matr_ncorr")
	v_plan_ccod = f_alumno.ObtenerValorPost (fila, "plan_ccod")
	v_espe_ccod = f_alumno.ObtenerValorPost (fila, "especialidad")
	v_sede_ccod = f_alumno.ObtenerValorPost (fila, "sede_ccod")
    v_jorn_ccod = f_alumno.ObtenerValorPost (fila, "jorn_ccod")
	v_peri_ccod = f_alumno.ObtenerValorPost (fila, "peri_ccod")
	
	especialidad_antigua = conexion.consultaUno("select espe_ccod from alumnos a, ofertas_academicas b where cast(matr_ncorr as varchar)='"&v_matricula&"' and a.ofer_ncorr=b.ofer_ncorr")
	plan_antiguo = conexion.consultaUno("select isnull(plan_ccod,0) from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'")
    'Si la especialidad se mantiene solo debemos cambiar el plan de estudios 
	if  cint(v_plan_ccod) <> cint(plan_antiguo) then
		insert_alumno = " update alumnos set plan_ccod="&v_plan_ccod&" where cast(matr_ncorr as varchar)='"&v_matricula&"'"
		conexion.ejecutaS(insert_alumno)
		'response.Write(insert_alumno &"<br>")
		
	end if
	'response.Write("---->v_espe_ccod "&v_espe_ccod&" especialidad_antigua "&especialidad_antigua&"<br>")
	if v_espe_ccod <> especialidad_antigua then 
	    'response.Write("entre <br>")
		ano_ingreso = conexion.consultaUno("select isnull(aran_nano_ingreso,0) from alumnos a join ofertas_academicas b on a.ofer_ncorr=b.ofer_ncorr left outer join aranceles c  on b.aran_ncorr=c.aran_ncorr  where  cast(matr_ncorr as varchar)='"&v_matricula&"'")
        if ano_ingreso = "0" then
		    pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'")
			carr_ccod = conexion.consultaUno("select carr_ccod from especialidades where cast(espe_ccod as varchar)='"&v_espe_ccod&"'")
			ano_ingreso = conexion.consultaUno("select isnull(isnull(protic.ano_ingreso_carrera("&pers_ncorr&","&carr_ccod&"),protic.ano_ingreso_universidad("&pers_ncorr&")),0)")
		end if
		'response.Write("Año "&ano_ingreso)
		if ano_ingreso="0" or ano_ingreso = "" then
			msj_error = "Imposible determinar el año de ingreso del alumno."
		else
			'ahora debemos buscar una oferta para la especialidad y además el año de ingreso del alumno, y su jornada.
			'response.Write("ahora estoy acá <br>")
			consulta_oferta= " select isnull(a.ofer_ncorr,0) as oferta from ofertas_Academicas a, aranceles b" & vbCrLf &_
			                 " where a.aran_ncorr=b.aran_ncorr and cast(b.aran_nano_ingreso as varchar)='"&ano_ingreso&"'" & vbCrLf &_
							 " and cast(a.espe_ccod as varchar)='"&v_espe_ccod&"' and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_
							 " and cast(a.sede_ccod as varchar)='"&v_sede_ccod&"' and cast(a.jorn_ccod as varchar)= '"&v_jorn_ccod&"'"
			'response.Write("<pre>"&consulta_oferta&"</pre>")
			v_nueva_oferta = conexion.consultaUno(consulta_oferta)
			'response.Write("<pre> esta "&v_nueva_oferta&"</pre>")
			if conexion.consultaUno("select count(*) from ("&consulta_oferta&")a")="0" then
			    'response.Write("ahora a crear la oferta")
				'debemos crear la oferta academica nueva para estos alumnos y con arancel iguala a cero.
				'sacamos el arancel
				aran_ncorr=conexion.consultaUno("execute obtenersecuencia 'aranceles'")
				insert_aranceles = "insert into aranceles (aran_ncorr,mone_ccod,ofer_ncorr,aran_tdesc,aran_mmatricula,aran_mcolegiatura, "& vbCrLf &_
                " aran_nano_ingreso,audi_tusuario,audi_fmodificacion,sede_ccod,espe_ccod,carr_ccod,peri_ccod,jorn_ccod,aran_cvigente_fup)"& vbCrLf &_
                " values ("&aran_ncorr&",1,null,'Aranceles de reubicación',0,0,"&ano_ingreso&",'Por regulacion de planes',getDate(), "& vbCrLf &_
				" "&v_sede_ccod&","&v_espe_ccod&",'"&carr_ccod&"',"&v_peri_ccod&","&v_jorn_ccod&",'N')"
				
				conexion.ejecutaS(insert_aranceles)
				'response.Write("<pre>"&insert_aranceles&"</pre>")
				'debemos crear la oferta 
				v_nueva_oferta = conexion.consultaUno("execute obtenersecuencia 'ofertas_academicas'")
				insert_oferta = " insert into ofertas_academicas (ofer_ncorr,sede_ccod,peri_ccod,espe_ccod,jorn_ccod,post_bnuevo,aran_ncorr,ofer_nvacantes, "& vbCrLf &_
	                            " ofer_nquorum,ofer_bpaga_examen,audi_tusuario,audi_fmodificacion,ofer_bpublica,ofer_bactiva)"& vbCrLf &_
								" values ("&v_nueva_oferta&","&v_sede_ccod&","&v_peri_ccod&","&v_espe_ccod&","&v_jorn_ccod&",'N',"& vbCrLf &_
								" "&aran_ncorr&",100,0,'N','Por regulacion de planes',getDate(),'N','N')"
				conexion.ejecutaS(insert_oferta)
				'ahora debemos actualizar el arancel con la oferta academica				
				'response.Write("<pre>"&insert_oferta&"</pre>")
				update_arancel = " update aranceles set ofer_ncorr="&v_nueva_oferta&" where cast(aran_ncorr as varchar)='"&aran_ncorr&"'"
				conexion.ejecutaS(update_arancel)
			end if
		end if
		if v_nueva_oferta<>"" then
			        'response.Write("select post_ncorr from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'")
			        v_pos_ncorr = conexion.consultaUno("select post_ncorr from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'")
					
					sql_actualiza_oferta	=	"update alumnos set ofer_ncorr="&v_nueva_oferta&" where matr_ncorr="&v_matricula
					sql_actualiza_det_pos	=	"update DETALLE_POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_pos		=	"update POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_sdes		=	"update SDESCUENTOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_sdet		=	"update SDETALLES_FORMA_PAGO set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_spag		=	"update SPAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_sdet_pag	=	"update SDETALLES_PAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_spase		=	"update PASE_MATRICULA set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
					sql_actualiza_scarg		=	"update CARGOS_CONVALIDACION set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
			'response.Write(sql_actualiza_oferta &"<br>")
			'response.Write(sql_actualiza_det_pos &"<br>")
			'response.Write(sql_actualiza_pos &"<br>")
			'		
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from alumnos where cast(plan_ccod as varchar)='"&v_plan_ccod&"' and cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(matr_ncorr as varchar)='"&v_matricula&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutas(sql_actualiza_oferta)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from detalle_postulantes where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_det_pos)
					end if	
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from postulantes where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
					conexion.ejecutaS(sql_actualiza_pos)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from SDESCUENTOS where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_sdes)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from SDETALLES_FORMA_PAGO where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_spag)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from CARGOS_CONVALIDACION where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_sdet_pag)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from PASE_MATRICULA where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_spase)
					end if
					cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from PASE_MATRICULA where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
					if cantidad_prueba = "0" then
						conexion.ejecutaS(sql_actualiza_scarg)
					end if
					
			end if

     end if

next
if conexion.obtenerEstadoTransaccion=true then
	session("mensaje_error")="Los cambios han sido realizados correctamente"
else
	session("mensaje_error") = msj_error
end if

'conexion.EstadoTransaccion false
'f_alumno.MantieneTablas false

'response.end()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
