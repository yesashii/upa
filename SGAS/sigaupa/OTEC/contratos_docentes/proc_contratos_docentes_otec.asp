<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

'response.write(FormatCurrency(20000,2))
'numero=FormatCurrency(20000,2)
'response.Write(numero)
'response.End()
cont=0

set formulario = new CFormulario
formulario.Carga_Parametros "contratos_docentes_otec.xml", "generar_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm		
contador1=0	
contador2=0
conta_nom=0

contador_gra=0
conta_con_contr=0
relator_creado=""
cont=0
for fila = 0 to formulario.CuentaPost - 1
   v_persona 	= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_sede 		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_dcur_ncorr 	= formulario.ObtenerValorPost (fila, "dcur_ncorr")
 v_tcdo_ccod= formulario.ObtenerValorPost (fila, "tcdo_ccod")
z_tcdo_ccod= formulario.ObtenerValorPost (fila, "z_tcdo_ccod")	
anos_ccod=	formulario.ObtenerValorPost (fila, "anos_ccod")		
guarda=0

if v_tcdo_ccod="" then
v_tcdo_ccod=z_tcdo_ccod
end if

if v_persona <> ""  then
cont=cont+1	
	sql_genera="Exec GENERA_CONTRATO_DOCENTE_OTEC_NUEVO  "&v_persona&", "&v_sede&" ,"&v_dcur_ncorr&", "&v_tcdo_ccod&","&anos_ccod&", '"&usuario&"' "
		response.write("<br> sql_genera= "&sql_genera)
		'response.end()
		v_salida= conexion.ConsultaUno(sql_genera)
		
		if v_salida="2" then
		v_nombre=conexion.consultaUno("select protic.obtener_nombre("&v_persona&",'an')")
			msg_error=msg_error + "\n-Contrato para "&v_nombre&" que no genero anexos"
		end if
		

		
end if
next

if conexion.ObtenerEstadoTransaccion  then
	if cont =0 then
		session("mensajeError")="No se realizo ningun calculo"
	else
		if msg_error <> "" then
			msg_error="\nExcepto :"&msg_error&"\nRevise la integridad de los datos personales, si corresponde la escuela seleccionada, \nsi tiene asociado una categoria para el tipo de bloque, etc... "
		end if
		session("mensajeError")="Los Contratos para los docentes seleccionados fueron creados correctamente."&msg_error
	end if
else
	session("mensajeError")="Ocurrio un error al intentar crear uno o mas contratos para los docentes.\nAsegurece de haber ingresado los datos necesarios y vuelva a intentarlo."
end if		
'response.End()
'response.End()
'conexion.estadotransaccion false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>