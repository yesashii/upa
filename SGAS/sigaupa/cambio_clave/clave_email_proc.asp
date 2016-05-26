<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "clave_email.xml", "f_recibe"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

pers_ncorr = f_agrega.ObtenerValorPost (filai, "pers_ncorr")
clave_antigua = f_agrega.ObtenerValorPost (filai, "clave_anterior")
clave_nueva = f_agrega.ObtenerValorPost (filai, "susu_tnuclave")



response.Write("<pre>pers_ncorr= "&pers_ncorr&"</pre>")
response.Write("<pre>clave_antigua= "&clave_antigua&"</pre>")
response.Write("<pre>susu_tnuclave= "&clave_nueva&"</pre>")

TCLD_NCORR=conectar.consultaUno("exec ObtenerSecuencia 'temporales_claves_docente'")
 usu=negocio.obtenerUsuario
 
 usu=negocio.obtenerUsuario
	p_insert="insert into  TEMPORALES_CLAVES_DOCENTE (TCLD_NCORR,PERS_NCORR,TCLD_CLANT,TCLD_CLNUE,AUDI_TUSUARIO,AUDI_FMODIFICACION) values ("&TCLD_NCORR&",'"&pers_ncorr&"','"&clave_antigua&"','"&clave_nueva&"','"&usu&"',getdate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)


next

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
