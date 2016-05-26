<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
'response.Write("depurando.....<hr>")
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

v_colegio=request.Form("da[0][cole_ccod]")
v_otro_colegio=request.Form("da[0][pers_totro_colegio]")
v_ciud_ccod=request.Form("da[0][ciud_ccod_colegio]")
v_pers_nrut=request.Form("da[0][pers_nrut]")

v_even_ncorr = Request.QueryString("folio_envio")

formulario.carga_parametros "ficha_evento_alumno.xml", "actualizar_evento"
formulario.inicializar conectar

formulario.procesaForm

if isnull(v_colegio) or v_colegio="" then
	if v_otro_colegio<>"" then
		' obtener una secuencia para insertar un nuevo colegio:
		v_cole_ccod= conectar.ConsultaUno("execute obtenersecuencia 'COLE_CCOD'")
		sql_inserta ="insert into colegios (cole_ccod, ciud_ccod,tcol_ccod,cole_tdesc, audi_tusuario, audi_fmodificacion) values("&v_cole_ccod&","&v_ciud_ccod&",0,'"&v_otro_colegio&"','ingreso evento',getdate()) "
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta) 	
		formulario.agregacampopost "cole_ccod" , v_cole_ccod
	end if
end if

if v_pers_nrut="" or isnull(v_pers_nrut)  then
'response.Write("<hr>El rut es vacio<hr>")
formulario.agregacampopost "pers_xdv" , "N"

end if

formulario.mantienetablas false
'response.Write("<br><b> "&conectar.ObtenerEstadoTransaccion)
'conectar.estadoTransaccion false
'response.End()

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
  opener.location.href = "ingreso_alumnos_casa_abierta.asp?folio_envio=<%=v_even_ncorr%>";
  close(); 
</script>

