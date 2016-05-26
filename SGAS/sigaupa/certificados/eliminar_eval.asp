<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
registros	=	request.form("registros")


set conectar 	= new cconexion
set formulario 	= new cformulario
set errores = new cErrores

conectar.inicializar "upacifico"
'conectar.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conectar

formulario.carga_parametros "eval_asignaturas.xml", "tabla"
formulario.inicializar conectar
formulario.procesaForm

'formulario.ListarPost

for j = 0 to formulario.CuentaPost - 1
	v_cali_ncorr = formulario.ObtenerValorPost (j, "cali_ncorr")
	
	if not EsVacio(v_cali_ncorr) then
		
		sentencia = "insert into calificaciones_alumnos_log (matr_ncorr, secc_ccod, cali_ncorr, cala_nnota, audi_tusuario, audi_fmodificacion, cali_njustificacion) " & vbCrLf &_
		            "select matr_ncorr, secc_ccod, cali_ncorr, cala_nnota, '" & negocio.ObtenerUsuario & "', getDate(), cali_njustificacion " & vbCrLf &_
					"from calificaciones_alumnos " & vbCrLf &_
					"where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"					
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
		
		sentencia = "delete from calificaciones_alumnos where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
		
		'------------------Debemos guardar la información de la evaluación antes de borrarla para tener un respaldo-----------
		'--------------------------agregado por msandoval---------------------------------------------------------------------
	    c_insertar = " insert into calificaciones_seccion_cambio (CALI_NCORR,SECC_CCOD,TEVA_CCOD,CALI_NEVALUACION,CALI_NPONDERACION,CALI_FEVALUACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,CALI_NRESOLUCION,CALI_TOBSERVACION,CALI_TCONCEPTO) "&_
		             " select cali_ncorr,secc_ccod,teva_ccod,cali_nevaluacion,cali_nponderacion,cali_fevaluacion,'"&negocio.obtenerUsuario&"' as audi_tusuario,getDate() as audi_fmodificacion,null,null,'ELIMINADO' as concepto "&_
					 " from calificaciones_seccion where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"
		
		'response.Write(c_insertar)
		conectar.EstadoTransaccion conectar.EjecutaS(c_insertar)
		
		'---------------------------------------------------------------------------------------------------------------------
		sentencia = "delete from calificaciones_seccion where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
        
		'conectar.EstadoTransaccion false
				
	end if
next
'response.End()
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

