<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

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
		
		sentencia = "delete from calificaciones_seccion where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
				
	end if
next

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

'for j=0 to registros-1
'	v_cali_ncorr=formulario.obtenervalorpost(j,"CALI_NCORR")
'	if v_cali_ncorr<>"" then
'		sql="select cali_ncorr from calificaciones_alumnos where cali_ncorr='"&v_cali_ncorr&"'"
'		existe=conectar.consultauno(sql)
'		if existe <> "" then 
'			<script language="JavaScript">
'			alert('No puede eliminar. \nExisten notas asociadas. ');
'			self.opener.location.reload();
'			self.close();
'			<!--/script>

		
'		else
'			formulario.mantienetablas 	false
'			dir=request.ServerVariables("HTTP_REFERER")
'			response.Redirect(dir)	
'		end if
'		
'	end if
		
	
	
'next

%>

