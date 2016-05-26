<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%
secc_ccod=request.form("not[0][secc_ccod]")
registros=request.Form("regAlumnos")

set nf_alumnos			=	new cformulario
set conectar		=	new cconexion
conectar.inicializar	"upacifico"

set f_cali_seccion			= 	new cformulario
set f_cali_alumno			= 	new cformulario

nf_alumnos.inicializar			conectar
nf_alumnos.carga_parametros				"notas.xml","guardar_nota_finales"
nf_alumnos.procesaForm


set negocio			=	new cnegocio
negocio.inicializa	conectar

f_cali_seccion.carga_parametros				"paulo.xml","tabla"
f_cali_seccion.inicializar conectar

f_cali_alumno.carga_parametros				"paulo.xml","tabla"
f_cali_alumno.inicializar conectar

nf_alumnos.agregacampopost		"secc_ccod",secc_ccod
nf_alumnos.mantienetablas 		false



periodo= negocio.obtenerPeriodoAcademico("PLANIFICACION")
'response.Write(periodo)
if periodo < "202" then 
'response.Write("entre al menor")
		set var = new cvariables
		set var_peec = new cvariables
		set fcerrar_alumnos = new cformulario
		
		fcerrar_alumnos.inicializar conectar
		fcerrar_alumnos.carga_parametros		"paulo.xml","tabla"
		
		asig="select asig_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'"
		asig_ccod=conectar.consultauno(asig)
		
		sql = 			"select c.sitf_ccod " & vbCrlf & _
						"	from  " & vbCrlf & _
						"		personas a, " & vbCrlf & _
						"		alumnos b, " & vbCrlf & _
						"		cargas_academicas c, " & vbCrlf & _
						"		secciones f " & vbCrlf & _
						"	where  " & vbCrlf & _
						"		a.pers_ncorr        =   b.pers_ncorr  " & vbCrlf & _
						"		and b.matr_ncorr    =   c.matr_ncorr  " & vbCrlf & _
						"		and b.emat_ccod    in  (1,2)  " & vbCrlf & _
						"		and c.secc_ccod     =   f.secc_ccod " & vbCrlf & _
						"		and c.sitf_ccod     is not null " & vbCrlf & _				
						"		and c.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='"&secc_ccod&"') " & vbCrlf & _
						"		and c.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and cast(asig_ccod as varchar)='"&asig_ccod&"') " & vbCrlf & _
						" 		and (c.sitf_ccod<>'EE' or c.sitf_ccod is null) " & vbCrlf & _
						"		and cast(c.secc_ccod as varchar) = '"& secc_ccod &"' " 
		
		fcerrar_alumnos.consultar sql
		NumSitf_ccod=fcerrar_alumnos.nrofilas
		
		if(cint(NumSitf_ccod)=cint(registros)) then
					
					var.procesaform
					var_peec.procesaform
					
					num=var.nrofilas("NOT")
					num_peec=var_peec.nrofilas("NP")
					
					
					sql_secciones="UPDATE SECCIONES SET ESTADO_CIERRE_CCOD=2 WHERE cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
					SQL_CARGAS_ACADEMICAS=" UPDATE CARGAS_ACADEMICAS SET ESTADO_CIERRE_CCOD=2 WHERE cast(SECC_CCOD as varchar)='"&SECC_CCOD&"'"
					
					conectar.EstadoTransaccion conectar.EjecutaS(sql_secciones)
					conectar.EstadoTransaccion conectar.EjecutaS(SQL_CARGAS_ACADEMICAS)
					
		else			
				session("mensajeerror")="Debe Guardar Las Notas Finales y Luego Cerrar "
		end if
		
		'----------------------------------agregamos código antiguos para guardar notas parciales
		SQL_Cali_seccion="select cali_ncorr from calificaciones_seccion where cast(secc_ccod as varchar)='"&secc_ccod&"'"
		f_cali_seccion.consultar SQL_Cali_seccion
		
		sql_tasg_ccod="select isnull(b.tasg_ccod,a.tasg_ccod) from secciones a,asignaturas b" & _
					  " where a.asig_ccod=b.asig_ccod" & _	
					  " and cast(a.secc_ccod as varchar)='"&secc_ccod&"'"
					  
		tasg_ccod=conectar.consultauno(sql_tasg_ccod)
		for i_=0 to f_cali_seccion.nrofilas-1 
		
			'response.Write("<hr>")
		
			f_cali_seccion.siguiente
			cali_ncorr=f_cali_seccion.obtenervalor("cali_ncorr")
			'response.Write("cali_ncorr "& i_&":" &cali_ncorr&"<br>")
			sql_cali_alum="select * from calificaciones_alumnos where cast(cali_ncorr as varchar)='"&cali_ncorr&"'"
			'response.Write(sql_cali_alum&"<br>")
			
			f_cali_alumno.Inicializar conectar
			f_cali_alumno.consultar sql_cali_alum
			for j=0 to f_cali_alumno.nrofilas-1
				f_cali_alumno.siguiente
				v_matr_ncorr=f_cali_alumno.obtenervalor("matr_ncorr")
				v_cali_ncorr=f_cali_alumno.obtenervalor("cali_ncorr")
				v_cala_nnota=f_cali_alumno.obtenervalor("cala_nnota")
				v_cali_njustificacion=f_cali_alumno.obtenervalor("cali_njustificacion")
				
				'response.Write("v_matr_ncorr"&j&":"&v_matr_ncorr&"<br>")
				'response.Write("v_cali_ncorr"&j&":"&v_cali_ncorr&"<br>")
				'response.Write("v_cala_nnota"&j&":"&v_cala_nnota&"<br>")						
				'response.Write("v_cali_njustificacion"&j&":"&v_cali_njustificacion&"<br>")
				if v_cali_njustificacion=1 and cint(tasg_ccod)=1 then 
						SQL_NExamen="select carg_nnota_examen from cargas_academicas where cast(matr_ncorr as varchar)='"&v_matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
						'response.Write(SQL_NExamen&"<br>")
						v_carg_nnota_examen=conectar.consultauno(SQL_NExamen)
						
						sql_update_cali_alum=" UPDATE CALIFICACIONES_ALUMNOS SET CALA_NNOTA="&v_carg_nnota_examen&"" & _
											 " WHERE cast(MATR_NCORR as varchar)='"&v_matr_ncorr&"' and cast(cali_ncorr as varchar)='"&v_cali_ncorr&"' " 
						'response.Write(sql_update_cali_alum&"d<br>")
						conectar.EstadoTransaccion conectar.EjecutaS(sql_update_cali_alum)
				end if
			next 
		next
		
else

		sql_secciones="UPDATE SECCIONES SET ESTADO_CIERRE_CCOD=2 WHERE cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
		SQL_CARGAS_ACADEMICAS=" UPDATE CARGAS_ACADEMICAS SET ESTADO_CIERRE_CCOD=2 WHERE cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(sql_secciones)
		conectar.EstadoTransaccion conectar.EjecutaS(SQL_CARGAS_ACADEMICAS)
'response.End()
end if	
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>