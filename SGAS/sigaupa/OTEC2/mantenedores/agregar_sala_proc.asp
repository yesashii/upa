<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

set negocio = new CNegocio
negocio.Inicializa conectar

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

sala_ccod = request.Form("m[0][sala_ccod]")
sala_tdesc = request.Form("m[0][sala_tdesc]")
sala_ncupo = request.Form("m[0][sala_ncupo]")
sala_ciso = request.Form("m[0][sala_ciso]")
modifica = request.Form("modifica")
sede_ccod = request.Form("m[0][sede_ccod]")
tsal_ccod = request.Form("m[0][tsal_ccod]")

'response.Write(usuario)
if  modifica = "0" then
'response.Write("Entre a 1")
	sala_ccod = conectar.consultaUno("exec obtenerSecuencia 'salas'")
	
	consulta = " insert into salas (sala_ccod,esal_ccod,tsal_ccod,sede_ccod,sala_tdesc,sala_ncupo,sala_ciso,audi_tusuario,audi_fmodificacion)"&_
			 " values ("&sala_ccod&",1,"&tsal_ccod&","&sede_ccod&",'"&sala_tdesc&"',"&sala_ncupo&",'"&sala_ciso&"','"&negocio.obtenerUsuario&"',getDate())"
	
else
'response.Write("Entre a 2")
	consulta = "update salas set tsal_ccod ="&tsal_ccod&",sede_ccod="&sede_ccod&", sala_tdesc='"&sala_tdesc&"',sala_ciso='"&sala_ciso&"',"&_
	         " sala_ncupo="&sala_ncupo&",audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate()"&_
			 " where cast(sala_ccod as varchar)='"&sala_ccod&"'"
end if 	

'response.Write(consulta)
'response.End()
conectar.ejecutaS consulta

if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Procesamiento de sala logrado exitosamente"
end if

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">

	CerrarActualizar();

</script>