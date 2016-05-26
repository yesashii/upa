<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<%

'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x)&"<hr>")
'next
'response.end()

v_pers_nrut 	= request.Form("busca[0][pers_nrut]")
v_pers_xdv 		= request.Form("busca[0][pers_xdv]")
v_area_ccod 	= request.Form("busca[0][area_ccod]")
v_rut_origen 	= request.Form("rut_origen")
v_area_origen	= request.Form("area_origen")
v_opcion 		= request.Form("opcion")

if v_opcion="" then
	v_opcion 		= request.QueryString("opcion")
end if

if v_opcion =3 then
	v_rut_origen 	= request.QueryString("rut_origen")
	v_area_origen 	= request.QueryString("area_origen")
	v_opcion    	= request.QueryString("opcion")
end if

set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

if v_opcion=3 then 'DELETE
	'datos para eliminar una combinacion
	sql_elimina_area =	"delete from presupuesto_upa.protic.area_presupuesto_usuario "& vbCrLf &_
						" where area_ccod="&v_area_origen&" "& vbCrLf &_
						" and rut_usuario='"&v_rut_origen&"'"

	'response.Write("<pre>"&sql_elimina_area&"</pre>")				
	'response.End()
	conexion2.ejecutaS(sql_elimina_area) 
	msg_proceso="El registro asociado al rut "&v_rut_origen&" fue eliminado correctamente "	
	
else ' (UPDATE OR INSERT)

	 if v_opcion=2 then ' editar
		
			sql_elimina_area =	"delete from presupuesto_upa.protic.area_presupuesto_usuario "& vbCrLf &_
					" where area_ccod="&v_area_origen&" "& vbCrLf &_
					" and rut_usuario='"&v_rut_origen&"'"
			conexion2.ejecutaS(sql_elimina_area) 
		
			sql_agrega_area=" insert into presupuesto_upa.protic.area_presupuesto_usuario "& vbCrLf &_
						" (area_ccod,rut_usuario,audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						" Values ('"&v_area_ccod&"','"&v_pers_nrut&"','"&v_usuario&"', getdate()) "
						
			conexion2.ejecutaS(sql_agrega_area)

	 msg_proceso="Los datos fueron modificados correctamente."	
	 else ' agregar (nuevo)
	
		'datos para verificar previa existencia de una combinacion
		sql_existe="select count(*) from presupuesto_upa.protic.area_presupuesto_usuario "& vbCrLf &_
					" where area_ccod="&v_area_ccod&" "& vbCrLf &_
					" and rut_usuario="&v_pers_nrut&" "
					
		v_existe_asignacion= conexion2.consultaUno(sql_existe)

		'si la asignacion ya existe, se avisa que no puede agregarse el centro de costo a los parametros
		if v_existe_asignacion > 0 then
			msg_proceso="No se pudo agregar el area seleccionada al Rut ingresado.\nLos parametros elegidos ya registran una asignacion dentro del sistema."
		else
			sql_agrega_area=" insert into presupuesto_upa.protic.area_presupuesto_usuario "& vbCrLf &_
							" (area_ccod,rut_usuario,audi_tusuario, audi_fmodificacion) "& vbCrLf &_
							" Values ('"&v_area_ccod&"','"&v_pers_nrut&"','"&v_usuario&"', getdate()) "
			 conexion2.ejecutaS(sql_agrega_area) 
			 msg_proceso="Los datos fueron agregados correctamente."									
		
		end if			
	end if
		 
end if ' ---Fin if inicial

session("mensaje_error")=msg_proceso
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>