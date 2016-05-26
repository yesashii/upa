<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x)&"<hr>")
'next

v_sede_ccod = request.Form("busqueda[0][sede_ccod]")
v_carr_ccod = request.Form("busqueda[0][carr_ccod]")
v_jorn_ccod = request.Form("busqueda[0][jorn_ccod]")
v_tdet_ccod = request.Form("busqueda[0][tdet_ccod]")
v_ccos_ccod = request.Form("busqueda_cc[0][ccos_ccod]")
v_opcion    = request.Form("opcion")
v_edita     = request.Form("v_edita")

set conexion = new CConexion
conexion.Inicializar "upacifico"


'datos para editar una combinacion
if v_edita="1" then

		'Si selecciono una escuela
		if v_opcion=1 then

if v_jorn_ccod<1 then
	session("mensaje_error")="Debe seleccionar una jornada valida"
	response.Redirect(request.ServerVariables("HTTP_REFERER"))  
end if				
			sql_actualiza="update centros_costos_asignados set ccos_ccod='"&v_ccos_ccod&"' "& vbCrLf &_
						" where cast(cenc_ccod_carrera as varchar)='"&v_carr_ccod& "'"& vbCrLf &_
						" and cast(cenc_ccod_sede as varchar)='"&v_sede_ccod&"'"& vbCrLf &_
						" and cast(cenc_ccod_jornada  as varchar)='"&v_jorn_ccod&"'"		
					
		else
		' si selecciono un tipo de detalle
			sql_actualiza="update centros_costos_asignados set ccos_ccod='"&v_ccos_ccod&"' "& vbCrLf &_
							" where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'"
		
		end if
		
		conexion.estadoTransaccion conexion.ejecutaS(sql_actualiza)
		msg_proceso="Los datos fueron actualizados correctamente."
		
else ' datos para ingresar un nuevo centro de costo
	if v_opcion=1 then
		if v_jorn_ccod<1 then
			session("mensaje_error")="Debe seleccionar una jornada valida"
			response.Redirect(request.ServerVariables("HTTP_REFERER"))  
		end if		
		
		sql_existe="select count(*) from centros_costos_asignados "& vbCrLf &_
					" where cast(cenc_ccod_carrera as varchar)='"&v_carr_ccod& "'"& vbCrLf &_
					" and cast(cenc_ccod_sede as varchar)='"&v_sede_ccod&"'"& vbCrLf &_
					" and cast(cenc_ccod_jornada  as varchar)='"&v_jorn_ccod&"'"
				 
	else
		sql_existe="select count(*) from centros_costos_asignados "& vbCrLf &_
				" where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'"
	
	end if
	
	'response.Write("<pre>"&sql_existe&"</pre>")
	v_existe_cc= conexion.consultaUno(sql_existe)
	
	'si la asignacion ya existe, se avisa que no puede agregarse el centro de costo a los parametros
	if v_existe_cc > 0 then
		msg_proceso="No se pudo agregar el centro de costo seleccionado a los parametros elegidos.\nLos parametros elegidos ya registran un centro de costo.\nbusque dicho centro y edite los datos."
	else
		 if v_opcion=1 then
				sql_agrega_cc=" insert into centros_costos_asignados "& vbCrLf &_
							" (ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod) "& vbCrLf &_
							" Values ('"&v_ccos_ccod&"','"&v_sede_ccod&"','"&v_carr_ccod&"','"&v_jorn_ccod&"',Null) "
		 else
				sql_agrega_cc=" insert into centros_costos_asignados "& vbCrLf &_
							" (ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)"& vbCrLf &_
							" Values ('"&v_ccos_ccod&"',null,null,null,'"&v_tdet_ccod&"') "	
		 end if
		 
		conexion.estadoTransaccion conexion.ejecutaS(sql_agrega_cc) 
		 msg_proceso="Los datos fueron agregados correctamente."
	end if
	
end if ' ---Fin if edicion

if conexion.ObtenerEstadoTransaccion= true then
	session("mensaje_error")=msg_proceso
end if
'conexion.EstadoTransaccion false
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))   
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
