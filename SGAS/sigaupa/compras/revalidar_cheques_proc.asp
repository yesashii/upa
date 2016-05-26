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
'FECHA ACTUALIZACION 	:02/10/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:79
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
f_datos_cheques.carga_parametros "revalidar_cheques.xml", "revalidar_cheques"
f_datos_cheques.inicializar conectar
f_datos_cheques.procesaForm

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_datos_cheques.CuentaPost - 1
	eche_ncorr			= f_datos_cheques.ObtenerValorPost (fila, "eche_ncorr")
	cod_numero 			= f_datos_cheques.ObtenerValorPost (fila, "cod_numero")
	codaux 		= f_datos_cheques.ObtenerValorPost (fila, "codaux")
	fecha_anterior		= f_datos_cheques.ObtenerValorPost (fila, "eche_fdocto")
	eche_mmonto		= f_datos_cheques.ObtenerValorPost (fila, "eche_mmonto")
	cod_proveedor		= f_datos_cheques.ObtenerValorPost (fila, "cod_proveedor")
	rche_frevalidacion	= f_datos_cheques.ObtenerValorPost (fila, "rche_frevalidacion")
	rche_tobservacion	= f_datos_cheques.ObtenerValorPost (fila, "rche_tobservacion")	
	cpbnum				= f_datos_cheques.ObtenerValorPost (fila, "cpbnum")
	
	if 	eche_ncorr<>"" and eche_ncorr<>"S" then
	'CHEQUES ENTREGADOS
	'response.Write("<br> eche_ncorr "&eche_ncorr&"<br>")
	
		v_rche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_revalidacion_cheques'")
		
		'inserta datos del cheque y su revalidacion
		if v_rche_ncorr <>"" then
		
			sql_revalidacion	=	" insert into ocag_revalidacion_cheques(rche_ncorr,eche_ncorr,cpbnum,eche_ndocto,rche_nrevalidacion, "&_
									" rche_fanterior,rche_frevalidacion, rche_tobservacion,audi_tusuario,audi_fmodificacion) "&_
									" values("&v_rche_ncorr&",'"&eche_ncorr&"','"&cpbnum&"',"&cod_numero&",1,convert(datetime,'"&fecha_anterior&"',103), "&_
									" convert(datetime,'"&rche_frevalidacion&"',103),'"&rche_tobservacion&"','"&v_usuario&"', getdate() ) "

			conectar.estadotransaccion	conectar.ejecutas(sql_revalidacion)
			
			sql_actualiza="update ocag_entrega_cheques set eche_ccod=4,  eche_fdocto=convert(datetime,'"&rche_frevalidacion&"',103) where eche_ncorr="&eche_ncorr
			
			conectar.estadotransaccion	conectar.ejecutas(sql_actualiza)
			
			'response.Write("<br>"&sql_revalidacion&"<br>")
			'response.Write("<br>"&sql_actualiza&"<br>")
	
		end if

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888		
	END IF

	if 	eche_ncorr="S" then
	' CHEQUES NO ENTREGADOS
	
		v_eche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")

		'inserta datos del cheque y su observacion
		if v_eche_ncorr <>"" then
						  
				sql_banc_ccod="   select c.pccodi "& vbCrLf &_ 
						  " from softland.cwmovim a "& vbCrLf &_ 
						  " INNER JOIN softland.cwtauxi b "& vbCrLf &_ 
						  " ON a.codaux = b.codaux "& vbCrLf &_ 
						  " and a.ttdcod = 'CP'  "& vbCrLf &_ 
						  " and a.cpbano >= 2013 "& vbCrLf &_ 
						  " and a.movfv is not null "& vbCrLf &_ 
						  " and datediff(dd, a.movfv,getdate()) BETWEEN 61 AND 90 "& vbCrLf &_
						  " AND a.NumDoc ='"&cod_numero&"' "& vbCrLf &_
						  " AND a.cpbnum='"&cpbnum&"'"& vbCrLf &_
						  " and a.movdebe > 0 "& vbCrLf &_ 
						  " INNER JOIN softland.cwpctas c "& vbCrLf &_ 
						  " ON a.pctcod = c.pccodi "
			
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
			
			'CAMBIE LAS CONSULTAS PARA QUE ACTUALIZARA LA FECHA "GETDATE" DEL DOCUMENTO
								
			sql_cheques	=	" insert into ocag_entrega_cheques(eche_ncorr,cpbnum, eche_ndocto, eche_fdocto, eche_mmonto, banc_ccod "& vbCrLf &_
								" , pers_nrut, eche_ccod, eche_tanotacion_retiro "& vbCrLf &_
								" , audi_tusuario, audi_fmodificacion, eche_fentrega, rche_nentrega, CajCod, CcCod) "& vbCrLf &_
								" values("&v_eche_ncorr&", '"&cpbnum&"' ,"&cod_numero&" , getdate()  , "&eche_mmonto&" ,'"&banco_ccod&"', "& vbCrLf &_
								" "&cod_proveedor&" , 4,'"&rche_tobservacion&"', "& vbCrLf &_
								" '"&v_usuario&"',getdate(), getdate() , 1 , '"&v_cod_presupuesto&"', '"&v_cod_ccosto&"' ) "
								
			'RESPONSE.WRITE("sql_cheques : "&sql_cheques&"<BR>")
			
			conectar.estadotransaccion	conectar.ejecutas(sql_cheques)
			
			v_rche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_revalidacion_cheques'")
									
			sql_revalidacion	=	" insert into ocag_revalidacion_cheques(rche_ncorr, eche_ncorr, cpbnum, eche_ndocto, rche_nrevalidacion, "&_
									" rche_fanterior, rche_frevalidacion,  rche_tobservacion, audi_tusuario, audi_fmodificacion) "&_
									" values("&v_rche_ncorr&", "&v_eche_ncorr&" ,'"&cpbnum&"',"&cod_numero&", 1, getdate() , "&_
									" convert(datetime,'"&rche_frevalidacion&"',103),'"&rche_tobservacion&"','"&v_usuario&"', getdate() ) "

			conectar.estadotransaccion	conectar.ejecutas(sql_revalidacion)

			'RESPONSE.WRITE("2. sql_revalidacion : "&sql_revalidacion&"<BR>")

		end if

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	end if		

next

'conectar.estadotransaccion false
'response.End() 

v_estado_transaccion = conectar.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
'if conectar.ObtenerEstadoTransaccion  then
	session("mensaje_error")="No se pudo revalidar el o los cheques seleccionados.\nVuelva a intentarlo."
else	
	session("mensaje_error")="Los cheques seleccionados fueron revalidados correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>