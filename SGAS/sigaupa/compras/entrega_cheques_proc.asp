<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:27/09/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 86
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

set f_datos_cheques = new cFormulario
f_datos_cheques.carga_parametros "entrega_cheques.xml", "cheques"
f_datos_cheques.inicializar conexion
f_datos_cheques.procesaForm


'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_datos_cheques.CuentaPost - 1

	codaux 		= f_datos_cheques.ObtenerValorPost (fila, "codaux")
	eche_mmonto		= f_datos_cheques.ObtenerValorPost (fila, "cod_monto")
	cod_numero 		= f_datos_cheques.ObtenerValorPost (fila, "cod_numero")
	cod_proveedor 	= f_datos_cheques.ObtenerValorPost (fila, "cod_proveedor")
	fecha 			= f_datos_cheques.ObtenerValorPost (fila, "fecha")
	eche_ccod		= f_datos_cheques.ObtenerValorPost (fila, "eche_ccod")
	obs_retiro		= f_datos_cheques.ObtenerValorPost (fila, "eche_tanotacion_retiro")	
	cpbnum			= f_datos_cheques.ObtenerValorPost (fila, "cpbnum")
	
	'response.write("1. eche_ccod : "&eche_ccod&"<br>")
	
	if 	eche_ccod="2" then
	
				'8888888888888888888888888888888888888888888888
					v_eche_ndocto=conectar.consultaUno("Select eche_ndocto from ocag_entrega_cheques where eche_ndocto="&cod_numero&" AND cpbnum="&cpbnum)
					
					'RESPONSE.WRITE("1. v_eche_ndocto : "&v_eche_ndocto&"<BR>")
	
				IF EsVAcio(v_eche_ndocto) OR v_eche_ndocto="" THEN
				'8888888888888888888888888888888888888888888888

					v_eche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")
					
					'inserta datos del cheque y su observacion
						if v_eche_ncorr <>"" then
						
							'BANCO
						
							sql_banc_ccod="select  pctcod from softland.cwmovim a  "& vbCrLf &_ 
									  "	join softland.cwpctas c  "& vbCrLf &_
									  "		on a.pctcod= c.pccodi   "& vbCrLf &_          
									  " where a.tipdoccb like 'CP'  "& vbCrLf &_      
									  " and a.cpbano>=2013  "& vbCrLf &_
									  " and cpbnum='"&cpbnum&"'"& vbCrLf &_
									  " and pctcod like '%1-10-010-30%'"
						
							'response.Write("<hr>"&sql_banc_ccod&"<hr>")
						
							banco_ccod=conexion.consultaUno(sql_banc_ccod)
							
							'CODIGO PRESUPUESTARIO
							
							cod_presupuesto="select max(a.CajCod) as cod_presupuesto "& vbCrLf &_ 
									  " 	from softland.cwmovim a "& vbCrLf &_ 
									  " 	where a.codaux = '"&codaux&"' "& vbCrLf &_ 
									  " 	and a.cpbnum = '"&cpbnum&"' "
						
							v_cod_presupuesto =conexion.consultaUno(cod_presupuesto)
							
							'CODIGO CENTRO DE COSTO
							
							cod_ccosto="select max(a.CcCod) as cod_ccosto "& vbCrLf &_ 
									  " 	from softland.cwmovim a "& vbCrLf &_ 
									  " 	where a.codaux = '"&codaux&"' "& vbCrLf &_ 
									  " 	and a.cpbnum = '"&cpbnum&"' "
						
							v_cod_ccosto=conexion.consultaUno(cod_ccosto)
						
							sql_cheques	=	" insert into ocag_entrega_cheques(eche_ncorr,cpbnum, eche_ndocto, eche_fdocto, eche_mmonto,banc_ccod, pers_nrut, "& vbCrLf &_
											"	eche_ccod,eche_tanotacion_retiro, audi_tusuario, audi_fmodificacion, eche_fentrega, rche_nentrega, CajCod, CcCod ) "& vbCrLf &_
											" values("&v_eche_ncorr&",'"&cpbnum&"','"&cod_numero&"',convert(datetime,'"&fecha&"',103),'"&eche_mmonto&"','"&banco_ccod&"','"&cod_proveedor&"', "& vbCrLf &_
											" "&eche_ccod&",'"&obs_retiro&"','"&v_usuario&"',getdate(), getdate() , 1, '"&v_cod_presupuesto&"', '"&v_cod_ccosto&"' ) "
											
							'RESPONSE.WRITE("3. sql_cheques : "&sql_cheques&"<BR>")

							conectar.estadotransaccion	conectar.ejecutas(sql_cheques)
							
							'response.Write("<br>"&sql_cheques&"<br>")
						end if
							
				ELSE					
											
					sql_cheques	=	" UPDATE [ocag_entrega_cheques] "& vbCrLf &_ 
											" SET [eche_ccod] = 2 "& vbCrLf &_ 
											" ,[eche_tanotacion_retiro] = '"&obs_retiro&"' "& vbCrLf &_ 
											" ,[audi_fmodificacion] = getdate() "& vbCrLf &_ 
											" ,[eche_fentrega] = getdate() "& vbCrLf &_ 
											" ,[rche_nentrega] = 2 "& vbCrLf &_ 
											" WHERE [cpbnum] = "&cpbnum&" AND [eche_ndocto] = "&cod_numero
											
					'RESPONSE.WRITE("2. sql_cheques : "&sql_cheques&"<BR>")
											
					conectar.estadotransaccion	conectar.ejecutas(sql_cheques)
						
				END IF
		
	end if

next

v_estado_transaccion = conectar.ObtenerEstadoTransaccion

'conectar.estadotransaccion false
'response.End()

if v_estado_transaccion=false  then
'if conectar.ObtenerEstadoTransaccion  then
	session("mensaje_error")="No se pudo ingresar la entrega de cheques correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="Los cheques seleccionados fueron ingresados con exito."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>