<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "planificacion_gral_reporte.xml", "carreras_comunes"
formulario.Inicializar conexion
formulario.ProcesaForm

v_plan_comun=0
fecha = date()

for fila = 0 to formulario.CuentaPost - 1
   seccion 	= formulario.ObtenerValorPost(fila, "secc_ccod")	
   carrera 	= formulario.ObtenerValorPost(fila, "carr_ccod")
   jornada 	= formulario.ObtenerValorPost(fila, "jorn_ccod")
   sede 	= formulario.ObtenerValorPost(fila, "sede_ccod")
   asignar 	= formulario.ObtenerValorPost(fila, "asignado")
 
sql_existe_contrato="select count(*) from anexos a, detalle_anexos b " & vbcrlf & _
					" where a.anex_ncorr=b.anex_ncorr " & vbcrlf & _
					" and eane_ccod not in (3) " & vbcrlf & _
					" and b.secc_ccod="&seccion
v_existe_contrato=conexion.ConsultaUno(sql_existe_contrato) 
v_existe_contrato=0 ' solo para evitar el filtro de validacion
if v_existe_contrato>0 then
	session("mensajeError")="                                            	      ¡¡ERROR!! \nNo se puede asignar plan comun ya que la seccion presenta un contrato docente asociado."
	conexion.EstadoTransaccion false
	response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

   consulta = "DELETE FROM SECCION_CARRERA_PLAN_COMUN where cast(secc_ccod as varchar)='"&seccion&"' and cast(sede_ccod as varchar)='"&sede&"'"&_
              " and carr_ccod='"&carrera&"' and cast(jorn_ccod as varchar)='"&jornada&"'"
   
   conexion.EstadoTransaccion conexion.EjecutaS(consulta)

   if asignar = "1" then
   v_plan_comun=1
	  consulta = "INSERT INTO SECCION_CARRERA_PLAN_COMUN (secc_ccod,sede_ccod,carr_ccod,jorn_ccod,audi_fmodificacion) values ( " & seccion & "," & sede & ",'" & carrera & "',"&jornada&", getdate() )"	
      'response.Write("<hr>"&consulta)       
      conexion.EstadoTransaccion conexion.EjecutaS(consulta)
  end if
next

if seccion <> ""  then

	set f_datos_seccion = new CFormulario
	f_datos_seccion.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_datos_seccion.Inicializar conexion
	
	sql_seccion="select secc_ccod,sede_ccod,carr_ccod,jorn_ccod from secciones where secc_ccod="&seccion
	f_datos_seccion.Consultar sql_seccion
	f_datos_seccion.Siguiente
			v_seccion	=	f_datos_seccion.ObtenerValor("secc_ccod")
			v_sede		=	f_datos_seccion.ObtenerValor("sede_ccod")
			v_carrera	=	f_datos_seccion.ObtenerValor("carr_ccod")
			v_jornada	=	f_datos_seccion.ObtenerValor("jorn_ccod")

	consulta_elimina = "DELETE FROM SECCION_CARRERA_PLAN_COMUN where cast(secc_ccod as varchar)='"&seccion&"' and cast(sede_ccod as varchar)='"&v_sede&"'"&_
              " and carr_ccod='"&v_carrera&"' and cast(jorn_ccod as varchar)='"&v_jornada&"'"
	conexion.EstadoTransaccion conexion.EjecutaS(consulta_elimina)
	
	if v_plan_comun=1 then
		consulta_base = "INSERT INTO SECCION_CARRERA_PLAN_COMUN (secc_ccod,sede_ccod,carr_ccod,jorn_ccod, audi_fmodificacion) values ( " & seccion & "," & v_sede & ",'" & v_carrera & "',"&v_jornada&", getdate() )"	
		'response.Write(consulta_base)
		conexion.EstadoTransaccion conexion.EjecutaS(consulta_base)
	end if
end if
'formulario.ListarPost
'formulario.MantieneTablas false
'conexion.estadotransaccion false  'este es como un rollback cuando es false
sql_cantidad_plan="select count(*) from SECCION_CARRERA_PLAN_COMUN where secc_ccod="&v_seccion
v_cantidad_plan=conexion.consultaUno(sql_cantidad_plan)

if v_cantidad_plan>0 then
	session("mensajeError")="La carrera fue asignada correctamente ( "&v_cantidad_plan-1&" carreras en plan comun )"
else
	session("mensajeError")="Se han eliminado todas las carreras de plan comun."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

