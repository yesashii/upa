<!-- #include file = "../biblioteca/_conexion.asp" -->


<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next



set conectar = new cconexion
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false

pers_ncorr = request.Form("p[0][pers_ncorr_encuestado]")
peri_ccod = request.Form("p[0][peri_ccod]")




'response.Write("<pre>"&consulta&"</pre>")
'response.End()
set formulario = new cformulario
formulario.carga_parametros "contestar_encuesta_otec.xml", "guardar_evaluacion_docente"
formulario.inicializar conectar
formulario.procesaForm
evdo_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'evaluacion_docente' ") 
formulario.AgregaCampoPost "evdo_ncorr", evdo_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false

if (conectar.obtenerEstadoTransaccion) then
	c_actualiza = " update evaluacion_docente set " & vbCrLf  & _
				  " metodologicos = (cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_1) as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_2)as numeric) + " & vbCrLf  & _
			      " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_3)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_4)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_5)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_8)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_9)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_12)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_13)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_14)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_15)as numeric) + " & vbCrLf  & _ 
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_16)as numeric) + " & vbCrLf  & _ 
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_17)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_20)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_21)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_24)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_27)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_28)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_29)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_30)as numeric)  " & vbCrLf  & _
				  " ), " & vbCrLf  & _
				  " interaccion = (cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_6)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_7)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_10)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_11)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_18)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_19)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas where encu_ncorr='23' and resp_ncorr=preg_22)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_23)as numeric)  " & vbCrLf  & _
				  " ), " & vbCrLf  & _
				  " administrativos = ( " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_25)as numeric) + " & vbCrLf  & _
				  " cast((select resp_nnota from respuestas  where encu_ncorr='23' and resp_ncorr=preg_26)as numeric)  " & vbCrLf  & _
				  " ) where peri_ccod > 202 and cast(evdo_ncorr as varchar)='"&evdo_ncorr&"'" 

   conectar.ejecutaS c_actualiza
   
   
   c_actualiza2 = " update evaluacion_docente set " & vbCrLf  & _
				  " puntaje_total = cast(metodologicos as numeric) + " & vbCrLf  & _
                  "                 cast(interaccion as numeric) + " & vbCrLf  & _
                  "                 cast(administrativos as numeric) " & vbCrLf  & _
				  " where peri_ccod > 202 and cast(evdo_ncorr as varchar)='"&evdo_ncorr&"'" 

   conectar.ejecutaS c_actualiza2
   
 
   consulta = " select count(*) from cargas_academicas e,secciones f, asignaturas g  " & vbCrLf &_
		      " where e.matr_ncorr in (select matr_ncorr from alumnos aa, ofertas_academicas bb where cast(aa.pers_ncorr as varchar)='"&pers_ncorr&"' and aa.ofer_ncorr=bb.ofer_ncorr and cast(bb.peri_ccod as varchar)='"&peri_ccod&"' and aa.emat_ccod = 1) " & vbCrLf &_
		      " and e.secc_ccod=f.secc_ccod and f.asig_ccod = g.asig_ccod and g.duas_ccod <> 3  " & vbCrLf &_
              " and exists (select 1 from bloques_horarios bb,bloques_profesores cc where bb.secc_ccod=f.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and cc.tpro_ccod=1)  " & vbCrLf &_
              " and not exists (select 1 from evaluacion_docente ed where ed.secc_ccod=f.secc_ccod and cast(ed.pers_ncorr_encuestado as varchar) = '"&pers_ncorr&"')"

	cantidad = conectar.consultaUno(consulta)
	' cantidad de asignaturas pendientes por evaluar   
	if cantidad = "0" then 
		
		   cons_insercion = " insert into con_evaluacion_docente_terminada " & vbCrLf &_
							" select pers_ncorr, matr_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb where cast(aa.pers_ncorr as varchar)='"&pers_ncorr&"' and aa.ofer_ncorr=bb.ofer_ncorr and cast(bb.peri_ccod as varchar)='"&peri_ccod&"' and aa.emat_ccod = 1"
		   
		   url = "cierra_ev_doc.asp?pers_ncorr="&pers_ncorr&"&peri_ccod="&peri_ccod
		   response.Redirect(url)
	end if

	


end if

'response.End()
'----------------------------------------------------

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>


