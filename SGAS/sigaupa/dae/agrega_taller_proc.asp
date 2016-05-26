<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next


set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "agrega_becas_mantencion_externas.xml", "formu"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

tasi_ncorr = f_agrega.ObtenerValorPost (filai, "tasi_ncorr")
peri_ccod = f_agrega.ObtenerValorPost (filai, "peri_ccod")
sede_ccod = f_agrega.ObtenerValorPost (filai, "sede_ccod")
carr_ccod = f_agrega.ObtenerValorPost (filai, "carr_ccod")
fecha = f_agrega.ObtenerValorPost (filai, "fecha")


s_existe="SELECT case when count(*)=0 then 'N' else 'S' end as existe FROM talleres_dictados_sicologia where tasi_ncorr="&tasi_ncorr&" and sede_ccod="&sede_ccod&" and  peri_ccod="&peri_ccod&" and convert(datetime,fecha,103)=convert(datetime,'"&fecha&"',103)"
existe=conectar.ConsultaUno(s_existe)

if existe="N" then
 tdsi_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'talleres_dictados_sicologia'")
 'acre_ncorr=10000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into talleres_dictados_sicologia(tdsi_ncorr,tasi_ncorr,peri_ccod,sede_ccod,fecha,audi_tusuario,audi_fmodificacion) values("&tdsi_ncorr&","&tasi_ncorr&",'"&peri_ccod&"','"&sede_ccod&"','"&fecha&"','"&usu&"',getDate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
end if

next
'response.Write(existe)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------

if existe="S" then
session("mensajeerror")= "Este Cuso ya fue creado para esta fecha, si necesita modificar algo valla a la opción Editar Curso"
response.Redirect("agrega_taller.asp")
else

	response.Write("respuesta "&Respuesta)
	
	
	if Respuesta = true then
	session("mensajeerror")= " Ahora debe ingresar lo alumnos"
	else
	  session("mensajeerror")= "Error al guardar "
	end if
	'response.End()
	
	
	if Respuesta = true then
	'response.Redirect(request.ServerVariables("HTTP_REFERER"))
	response.Redirect("agrega_alumnos_taller.asp?tdsi_ncorr="&tdsi_ncorr&"")
	else
	response.Redirect("crear_taller.asp")
	end if
end if





%>


