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

usuario = negocio.obtenerUsuario

set t_cargas_academicas = new CFormulario
t_cargas_academicas.Carga_Parametros "paulo.xml", "tabla"
t_cargas_academicas.Inicializar conexion

'set exprRegular = new RegExp
'exprRegular.pattern = "secc_ccod"
'exprRegular.IgnoreCase = True
matr_ncorr = request.Form("matr_ncorr")
set formulario = new CFormulario
formulario.Carga_Parametros "eliminar_convalidacion.xml", "formu_carga"
formulario.Inicializar conexion
formulario.procesaForm

for fi=0 to formulario.cuentaPost - 1
    asig_ccod=formulario.obtenerValorPost(fi,"asig_ccod")
	acon_ncorr=formulario.obtenerValorPost(fi,"acon_ncorr")
	matr_ncorr=formulario.obtenerValorPost(fi,"matr_ncorr")
	conv_res_eliminacion=formulario.obtenerValorPost(fi,"conv_res_eliminacion")
	conv_obs_eliminacion=formulario.obtenerValorPost(fi,"conv_obs_eliminacion")
	'response.Write("<hr>secc_ccod "&secc_ccod&"<hr>")
		if asig_ccod <> "" and matr_ncorr <> "" and acon_ncorr <> ""then
				
			sentencia_insert = "insert into convalidaciones_eliminadas (matr_ncorr,asig_ccod,acon_ncorr,sitf_ccod,conv_nnota,conv_tdocente,audi_tusuario,audi_fmodificacion,conv_res_eliminacion,conv_obs_eliminacion) "&_
			                   "select matr_ncorr,asig_ccod,acon_ncorr,sitf_ccod,conv_nnota,conv_tdocente,'"&usuario&"' as audi_tusuario,getDate() as audi_fmodificacion, "&_
							   "'" & conv_res_eliminacion&"' as conv_res_eliminacion,'"&conv_obs_eliminacion&"' as conv_obs_eliminacion "&_
                               " from convalidaciones where cast(acon_ncorr as varchar)='"&acon_ncorr&"' and asig_ccod ='"&asig_ccod&"' and cast(matr_ncorr as varchar)='"&matr_ncorr&"'"
							
			
			sentencia_delete  = " delete from convalidaciones " & _				
   							    " where cast(acon_ncorr as varchar)='"&acon_ncorr&"' and asig_ccod ='"&asig_ccod&"' and cast(matr_ncorr as varchar)='"&matr_ncorr&"'"

			'response.Write(sentencia_insert)
			'response.Write("<br>"&sentencia_delete)
									
			conexion.EstadoTransaccion conexion.EjecutaS(sentencia_insert)
			conexion.EstadoTransaccion conexion.EjecutaS(sentencia_delete)
		end if	
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

