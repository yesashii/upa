<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

set conexion = new cConexion
conexion.Inicializar "desauas"

set negocio = new cnegocio
negocio.Inicializa conexion

'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

'set formulario_b = new cformulario
'formulario_b.carga_parametros "mant_requisito.xml","f_requisitos_b"
'formulario_b.inicializar conexion
'formulario_b.procesaform
'formulario_b.mantienetablas false

'conexion.estadotransaccion false
'response.End()
'response.Redirect(request.ServerVariables("HTTP_REFERER"))

'*************************
'para saber si borro o no '*** no ocupar con lo anterior *****
'*************************
 for i=0 to request.Form("nrofilas")-1
 	repl_ncorr=request.form("reqplan["&i&"][repl_ncorr]")
	
	if repl_ncorr<>"" then 
			consulta = " select count (*) from requisitos_titulacion  " & _
					   " where repl_ncorr= '"&repl_ncorr&"' " 
			consulta2 = " select treq_ccod from requisitos_plan  " & _
					   " where repl_ncorr= '"&repl_ncorr&"' "
					   
			existe=conexion.consultauno(consulta)		   
			egreso=conexion.consultauno(consulta2)
			
			if cint(existe)=0 then 
				if cint(egreso)<>1  then
					sentencia="delete requisitos_plan where repl_ncorr='"&repl_ncorr&"'"
					conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
					'response.Write(sentencia&"<br>")
				else
					 session("mensajeError")="Imposible eliminar el requisito PROMEDIO DE ASIGNATURAS."	
				end if	
			else
				sql      =  " SELECT b.TREQ_TDESC " & _
							" FROM REQUISITOS_PLAN A, TIPOS_REQUISITOS_TITULO B,TIPOS_EVALUACION_REQUISITOS C " & _
							" WHERE A.TREQ_CCOD=B.TREQ_CCOD AND B.TEVA_CCOD=C.TEVA_CCOD " & _
							" and a.repl_ncorr='"&repl_ncorr&"'"
				 session("mensajeError")="No se puede eliminar el requisito " & conexion.consultauno(sql)&", \nporque existen alumnos con ese requisito."
			end if
	end if
 next


response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>