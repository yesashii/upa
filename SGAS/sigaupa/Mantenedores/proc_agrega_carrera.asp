<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

v_area_ccod		=request.Form("em[0][area_ccod]")
v_inst_ccod		=request.Form("em[0][inst_ccod]")
v_carr_tdesc	=request.Form("em[0][carr_tdesc]")
v_ini_vigencia	=request.Form("em[0][CARR_FINI_VIGENCIA]")
v_fin_vigencia	=request.Form("em[0][CARR_FFIN_VIGENCIA]")
v_carr_tsigla	=request.Form("em[0][carr_tsigla]")
v_carr_ccod		=request.Form("em[0][carr_ccod]")
v_tcar_ccod		=request.Form("em[0][TCAR_CCOD]")
v_ecar_ccod		=request.Form("em[0][ECAR_CCOD]")
v_tgra_ccod		=request.Form("em[0][tgra_ccod]")
v_carr_bloce	=request.Form("em[0][carr_bloce]")
v_inserta		=request.Form("inserta")

if v_carr_bloce=1 then
	carr_bloce="S"
else
	carr_bloce="N"
end if

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_carreras.xml", "mantiene_carreras"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

f_mantiene_carreras.AgregaCampoPost "carr_bloce", carr_bloce

'if v_inserta ="1" then
'	sql_carrera= " insert into CARRERAS (AREA_CCOD, CARR_CCOD, CARR_FFIN_VIGENCIA, CARR_FINI_VIGENCIA, CARR_TDESC, CARR_TSIGLA, ECAR_CCOD, INST_CCOD, TCAR_CCOD, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
'				" Values ("&v_area_ccod&", "&v_carr_ccod&",'"&v_fin_vigencia&"','"&v_ini_vigencia&"','"&v_carr_tdesc&"','"&v_carr_tsigla&"',"&v_ecar_ccod&","&v_inst_ccod&", "&v_tcar_ccod&",getdate(), '13373873')"
'else
'	sql_carrera= " Update CARRERAS set AREA_CCOD="&v_area_ccod&",CARR_FFIN_VIGENCIA='"&v_fin_vigencia&"',CARR_FINI_VIGENCIA='"&v_ini_vigencia&"', "&_
'				" CARR_TDESC='"&v_carr_tdesc&"',CARR_TSIGLA='"&v_carr_tsigla&"',ECAR_CCOD="&v_ecar_ccod&",INST_CCOD="&v_ecar_ccod&"," &_
'				" TCAR_CCOD="&v_tcar_ccod& ",AUDI_FMODIFICACION=getdate(),AUDI_TUSUARIO='1' "&_
'				" where CARR_CCOD="&v_carr_ccod
'end if
'response.End()
	'response.Write("<br>"&sql_carrera&"<br>")

'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
v_estado_transaccion=f_mantiene_carreras.MantieneTablas (false)
'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)


if v_estado_transaccion=false  then
	session("mensaje_error")="La carrera no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La carrera fue ingresada correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))



%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	//self.opener.location.reload();
	//window.close();
</script>
