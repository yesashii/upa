<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"


pers_ncorr_origen = request.Form("m[0][pers_ncorr_origen]")
pers_ncorr_destino = request.Form("m[0][pers_ncorr_destino]")
titulo = request.Form("m[0][titulo]")
contenido = request.Form("m[0][contenido]")
fecha_vencimiento = request.Form("m[0][fecha_vencimiento]")
mandar_copia = request.Form("m[0][mandar_copia]")
fecha_emision=conexion.ConsultaUno("select protic.trunc(getdate())")
tipo_origen = 2

secc_ccod = request.Form("m[0][SECC_CCOD]")
if secc_ccod <> "" then
	set f_alumnos = new CFormulario
	f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_alumnos.Inicializar conexion
	consulta =  "select distinct pers_ncorr from cargas_academicas a, alumnos b where cast(a.secc_ccod as varchar)='"&secc_ccod&"' and a.matr_ncorr=b.matr_ncorr"
    f_alumnos.Consultar consulta
	
	while f_alumnos.siguiente
		pers_ncorr_destino = f_alumnos.obtenerValor("pers_ncorr")
		mepe_ncorr = conexion.ConsultaUno("execute obtenerSecuencia 'mensajes_entre_personas' ") 
		c_insert = " insert into mensajes_entre_personas (mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision, fecha_vencimiento, "&_
				   " titulo,contenido,tipo_origen,audi_tusuario,audi_fmodificacion )"&_
				   " values ("&mepe_ncorr&","&pers_ncorr_origen&","&pers_ncorr_destino&",getDate(),'"&fecha_vencimiento&"','"&titulo&"',"&_
				   " '"&contenido&"',"&tipo_origen&",'profesor',getDate())"
		'response.write c_insert
	    conexion.ejecutaS c_insert
	wend
		'response.end

else
    mepe_ncorr = conexion.ConsultaUno("execute obtenerSecuencia 'mensajes_entre_personas' ") 
	c_insert = " insert into mensajes_entre_personas (mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision, fecha_vencimiento, "&_
			   " titulo,contenido,tipo_origen,audi_tusuario,audi_fmodificacion )"&_
			   " values ("&mepe_ncorr&","&pers_ncorr_origen&","&pers_ncorr_destino&",getDate(),'"&fecha_vencimiento&"','"&titulo&"',"&_
			   " '"&contenido&"',"&tipo_origen&",'profesor',getDate())"
    conexion.ejecutaS c_insert
end if

'response.Write(c_insert)
		   

if mandar_copia = "1" then 
	mepe_ncorr = conexion.ConsultaUno("execute obtenerSecuencia 'mensajes_entre_personas' ") 
	c_insert2 = " insert into mensajes_entre_personas (mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision, fecha_vencimiento, "&_
		   " titulo,contenido,tipo_origen,audi_tusuario,audi_fmodificacion )"&_
		   " values ("&mepe_ncorr&","&pers_ncorr_origen&","&pers_ncorr_origen&",getDate(),'"&fecha_vencimiento&"','"&titulo&"',"&_
		   " '"&contenido&"',4,'alumno',getDate())"
	conexion.ejecutaS c_insert2
end if

'response.Write(c_insert2)
'conexion.estadotransaccion false  'roolback  
'response.End()

if conexion.ObtenerEstadoTransaccion = true then
	conexion.MensajeError "el mensaje fue enviado exitosamente"
else
	conexion.MensajeError "Ocurrio un error al enviar el mensaje, Vuelva a intentarlo..."
end if
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript">
	opener.location.reload();
	close();
</script>