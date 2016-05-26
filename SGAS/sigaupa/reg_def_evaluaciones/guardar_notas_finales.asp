<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

registros	=	request.Form("registros")
seccion		=	request.form("not[0][secc_ccod]")	
	

set nf_alumnos			=	new cformulario
set conectar			=	new cconexion				
'set nf_alumnos_peec		=	new cformulario
set f_cali_seccion			= 	new cformulario
set f_cali_alumno			= 	new cformulario
set negocio			=	new cnegocio

conectar.inicializar			"upacifico"
nf_alumnos.inicializar			conectar
'nf_alumnos_peec.inicializar		conectar
negocio.inicializa	conectar


nf_alumnos.carga_parametros				"notas.xml","guardar_nota_finales"
nf_alumnos.procesaForm

'nf_alumnos_peec.carga_parametros		"notas.xml","guardar_nota_finales_peec"
'nf_alumnos_peec.procesaForm

f_cali_seccion.carga_parametros				"paulo.xml","tabla"
f_cali_seccion.inicializar conectar

f_cali_alumno.carga_parametros				"paulo.xml","tabla"
f_cali_alumno.inicializar conectar

nf_alumnos.agregacampopost		"secc_ccod",seccion
nf_alumnos.mantienetablas 		false

'nf_alumnos_peec.agregacampopost	"secc_ccod",seccion
'nf_alumnos_peec.mantienetablas 	false
'conectar.EstadoTransaccion	false
periodo= negocio.obtenerPeriodoAcademico("PLANIFICACION")
'response.Write(periodo)
if periodo < "202" then 
'response.Write("entre")
		SQL_Cali_seccion="select cali_ncorr from calificaciones_seccion where cast(secc_ccod as varchar)='"&seccion&"'"
		f_cali_seccion.consultar SQL_Cali_seccion
		
		sql_tasg_ccod="select isnull(b.tasg_ccod,a.tasg_ccod) from secciones a,asignaturas b" & _
					  " where a.asig_ccod=b.asig_ccod" & _	
					  " and cast(a.secc_ccod as varchar)='"&seccion&"'"
					  
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
						SQL_NExamen="select carg_nnota_examen from cargas_academicas where cast(matr_ncorr as varchar)='"&v_matr_ncorr&"' and cast(secc_ccod as varchar)='"&seccion&"'"
						'response.Write(SQL_NExamen&"<br>")
						v_carg_nnota_examen=conectar.consultauno(SQL_NExamen)
						
						sql_update_cali_alum=" UPDATE CALIFICACIONES_ALUMNOS SET CALA_NNOTA="&v_carg_nnota_examen&"" & _
											 " WHERE cast(MATR_NCORR as varchar)='"&v_matr_ncorr&"' and cast(cali_ncorr as varchar)='"&v_cali_ncorr&"' " 
						'response.Write(sql_update_cali_alum&"d<br>")
						conectar.EstadoTransaccion conectar.EjecutaS(sql_update_cali_alum)
				end if
			next 
		next
end if		
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>