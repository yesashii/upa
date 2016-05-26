<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next


  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  pele_ccod = conexion.ConsultaUno("execute obtenersecuencia 'pago_electronico_letras'")  
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "archivo_pago_electronico.xml", "pago_electronico_letras"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  
  
  

for fila = 0 to formulario.CuentaPost - 1
   v_opcion		= formulario.ObtenerValorPost (fila, "opcion")
   v_pers_nrut	= formulario.ObtenerValorPost (fila, "pers_nrut")
   v_ding_ndocto= formulario.ObtenerValorPost (fila, "pele_nidentificacion")

	sql_pagada="select count(*) as total from detalle_ingresos where ding_ndocto="&v_ding_ndocto&" and ting_ccod=4 and edin_ccod in (6,11)"
	v_pagada = conexion.ConsultaUno(sql_pagada)

   
   	if v_opcion<>"" and v_pers_nrut <>""  then
		pers_nrut= left(v_pers_nrut,len(v_pers_nrut)-1) ' quita el ultimo digito al rut, ya que viene concatenado con el dv
		formulario.AgregaCampoFilaPost fila, "pele_ccod", pele_ccod
	 	formulario.AgregaCampoFilaPost fila, "pers_nrut", pers_nrut
		if  v_pagada=0 then
			formulario.AgregaCampoFilaPost fila, "pele_bpagada", "N"
		else
			formulario.AgregaCampoFilaPost fila, "pele_bpagada", "S"
		end if
   	end if

next   

	formulario.AgregaCampoPost  "epel_ccod", 1
  
  formulario.MantieneTablas false
  
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()  
  

response.Redirect("pagar_archivo_pago_electronico.asp?q_leng=3&pele_ccod="&pele_ccod)
%>