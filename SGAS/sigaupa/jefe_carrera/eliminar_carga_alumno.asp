<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio			=	new cnegocio		
negocio.inicializa conexion

set t_cargas_academicas = new CFormulario
t_cargas_academicas.Carga_Parametros "paulo.xml", "tabla"
t_cargas_academicas.Inicializar conexion

'set exprRegular = new RegExp
'exprRegular.pattern = "secc_ccod"
'exprRegular.IgnoreCase = True
matr_ncorr = request.Form("matr_ncorr")
set formulario = new CFormulario
formulario.Carga_Parametros "elimina_carga_academica.xml", "tabla_carga"
formulario.Inicializar conexion
formulario.procesaForm

for fi=0 to formulario.cuentaPost - 1
    secc_ccod=formulario.obtenerValorPost(fi,"secc_ccod")
	matr_ncorr=formulario.obtenerValorPost(fi,"matr_ncorr")
	cael_nresolucion=formulario.obtenerValorPost(fi,"cael_nresolucion")
	cael_tobservacion=formulario.obtenerValorPost(fi,"cael_tobservacion")
	'response.Write("<hr>secc_ccod "&secc_ccod&"<hr>")
		if secc_ccod <> "" then
				sql_datos = " select sitf_ccod,cast(isnull(carg_nnota_presentacion,'0') as numeric) as nnota_presentacion,"&_
				            " cast(isnull(carg_nnota_examen,'0') as numeric) as nnota_examen,"&_
							" cast(isnull(carg_nnota_repeticion,'0') as numeric) as nnota_repeticion,"&_
				            " cast(isnull(carg_nnota_final,'0') as numeric) as nnota_final,"&_
							" cast(isnull(carg_nasistencia,'0') as numeric) as nasistencia,eexa_ccod,eexa_ccod_rep from cargas_academicas " & _
							" where cast(matr_ncorr as varchar)= '"&matr_ncorr&"' "& _
							" and cast(secc_ccod as varchar)= '"&secc_ccod&"'"
			  'response.Write("<pre>"&sql_datos&"</pre>")			
			  t_cargas_academicas.consultar sql_datos			
			  t_cargas_academicas.siguiente
			  
			  sitf_ccod = t_cargas_academicas.obtenervalor("sitf_ccod")
		      carg_nnota_presentacion = t_cargas_academicas.obtenervalor("nnota_presentacion")
			  carg_nnota_examen = t_cargas_academicas.obtenervalor("nnota_examen")
			  carg_nnota_repeticion = t_cargas_academicas.obtenervalor("nnota_repeticion")
			  carg_nnota_final = t_cargas_academicas.obtenervalor("nnota_final")
			  carg_nasistencia =t_cargas_academicas.obtenervalor("nasistencia")
			  eexa_ccod = t_cargas_academicas.obtenervalor("eexa_ccod")
			  eexa_ccod_rep = t_cargas_academicas.obtenervalor("eexa_ccod_rep")
			  
			  'response.Write("<br>nota presentación "&carg_nnota_presentacion&" nota examen "&carg_nnota_examen&" nota repeticion "&carg_nnota_repeticion)
				 
			  sql_existe_CA_log = " select count(*) from cargas_academicas_log " & _
									" where cast(matr_ncorr as varchar)= '"&matr_ncorr&"'" & _
									" and cast(secc_ccod as varchar)='"&secc_ccod&"' "
									
	      
			 
			 CA_log = conexion.consultauno(sql_existe_CA_log)
		     if (CA_log = 0) then
				sentencia_CALOG_insert = " insert into cargas_academicas_log " & _
										 " (matr_ncorr,secc_ccod," & _
										 " sitf_ccod,carg_nnota_presentacion,carg_nnota_examen, " & _
										 " carg_nnota_repeticion,carg_nnota_final,carg_nasistencia, " & _
										 " eexa_ccod,eexa_ccod_rep)" &_	
										 " values ( "&matr_ncorr&","&secc_ccod&"," &_
										 " '"&sitf_ccod&"',"&carg_nnota_presentacion&","&carg_nnota_examen&", " & _
										 " "&carg_nnota_repeticion&","&carg_nnota_final&","&carg_nasistencia&", " & _
										 " '"&eexa_ccod&"','"&eexa_ccod_rep&"')"
										 
			 'response.Write("<pre>"&sentencia_CALOG_insert&"</pre><br>") 
			 conexion.EstadoTransaccion conexion.EjecutaS(sentencia_CALOG_insert)
			 
			end if
			
			sentencia_CALumno_log = " insert into calificaciones_alumnos_log "& _
									" select MATR_NCORR ,SECC_CCOD,CALI_NCORR, " & _
									" CALA_NNOTA ,'"&negocio.obtenerusuario&"' ," & _
									" getdate(), CALI_NJUSTIFICACION  " & _
									" from calificaciones_alumnos "  & _
									" where matr_ncorr = '"&matr_ncorr&"'" & _
									" and secc_ccod = '"&secc_ccod&"'"
									
			'response.Write("<pre>"&sentencia_CALumno_log&"</pre>")						
			
			sentenciaCAlumnoDelete  =" delete calificaciones_alumnos " & _				
									 " where matr_ncorr = '"&matr_ncorr&"'"& _
									 " and secc_ccod = '"&secc_ccod&"'" 
									 
			'response.Write("<pre>"&sentenciaCAlumnoDelete&"</pre>")		
			
			SentenciaCAdelete = " delete cargas_academicas " & _ 
								" where matr_ncorr = '"&matr_ncorr&"'" & _
								" and secc_ccod ='"&secc_ccod&"' "
								
		    'response.Write("<pre>"&SentenciaCAdelete&"</pre>")
			
			'debemos insertar un registro en una tabla que guarde las asignaturas eliminadas de los alumnos
			'---------------------------------creada por MArcelo sandoval-----------------------------
			
            cael_ncorr = conexion.consultauno("execute obtenerSecuencia 'cargas_eliminadas'")
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
			                  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",'"&sitf_ccod&"',"&carg_nnota_final&",'"&negocio.obtenerUsuario&"',getDate(),'"&cael_nresolucion&"','"&cael_tobservacion&"')"
			'-----------------------------------------------------------------------------------------
			
			
			'response.Write(sentencia_CALumno_log&"<br>")
			'response.Write(sentenciaCAlumnoDelete &"<br>")
			'response.Write(SentenciaCAdelete &"<br>")
			'response.Write(consulta_insert &"<br>")
			
			'response.End()
			conexion.EstadoTransaccion conexion.EjecutaS(sentencia_CALumno_log)
			conexion.EstadoTransaccion conexion.EjecutaS(sentenciaCAlumnoDelete)
			conexion.EstadoTransaccion conexion.EjecutaS(SentenciaCAdelete)
			conexion.EstadoTransaccion conexion.EjecutaS(consulta_insert)
			
			'conexion.estadoTransaccion false
		end if	
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

