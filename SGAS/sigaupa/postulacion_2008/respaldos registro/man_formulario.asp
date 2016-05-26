 <!--#include file="../biblioteca/_conexion.asp" -->
<%
  ' response.write "<br>"
  ' for each v_entrada in request.form
  '   for indice=1 to request.form(v_entrada).count
  '       response.write v_entrada&"="&request.form(v_entrada)(indice)&"<br>"
  '    next
  ' next
  ' response.Flush()
   
   'Verificamos si la sesion ya ha terminado
   correlativo = session("ses_corr_persona")
   if correlativo = "" then
     response.Redirect("denegado.asp")
   end if
   
    set conectar = new cconexion
	conectar.inicializar "upacifico"
	
   '============================================================================================
   '  Enviamos los datos a la tabla PERSONAS
	
   set formulario2 = new cformulario
   formulario2.carga_parametros "registrarse.xml", "mantiene_personas" 
   formulario2.inicializar conectar
   formulario2.procesaForm
   'exitoso2 = formulario2.mantienetablas (false)
   '============================================================================================
   
   '============================================================================================
   ' Enviamos los datos a la tabla PERSONAS_POSTULANTE
   set formulario = new cformulario
   formulario.carga_parametros "registrarse.xml", "edicion_ficha_postulante"
   formulario.inicializar conectar
   formulario.procesaForm
   exitoso1 = formulario.mantienetablas (false)
   '============================================================================================
   	
      
   if ((exitoso1 = true)) then
      session("mensajeError") = " Sus datos se han grabado exitosamente. Por lo tanto, \n ya puede ingresar al sistema de postulación, \n ingresando su numero de rut y contraseña."
   else
      session("mensajeError") = "Sus datos no han podido grabarse.\nPor favor, inténtelo de nuevo."
   end if
   direccion = "inicio.asp"
   response.Redirect(direccion)		
%>
