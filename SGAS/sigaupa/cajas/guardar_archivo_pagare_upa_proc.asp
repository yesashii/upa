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
  pepu_ccod = conexion.ConsultaUno("execute obtenersecuencia 'pago_electronico_pagare_upa'")  
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "archivo_pagare_upa_electronico.xml", "pago_electronico_pagare_upa"
  formulario.Inicializar conexion
  formulario.ProcesaForm
   

for fila = 0 to formulario.CuentaPost - 1
   v_opcion		= formulario.ObtenerValorPost (fila, "opcion")
   v_pers_nrut	= formulario.ObtenerValorPost (fila, "pers_nrut")
   v_ding_ndocto= formulario.ObtenerValorPost (fila, "pepu_nidentificacion")
   v_fecha_vencimiento= formulario.ObtenerValorPost (fila, "pepu_fvencimiento")
   ' agregar fecha vencimiento

	sql_pagada="select count(*) as total from detalle_ingresos where ding_ndocto= LEFT("&v_ding_ndocto&",LEN("&v_ding_ndocto&")-2) and ding_fdocto=convert(datetime,'"&v_fecha_vencimiento&"',103) and ting_ccod= 66 and edin_ccod in (6,11)"
	'response.Write(sql_pagada)
	'response.End()
	v_pagada = conexion.ConsultaUno(sql_pagada)

   
   	if v_opcion<>"" and v_pers_nrut <>""  then
		pers_nrut= left(v_pers_nrut,len(v_pers_nrut)-1) ' quita el ultimo digito al rut, ya que viene concatenado con el dv
		formulario.AgregaCampoFilaPost fila, "pepu_ccod", pepu_ccod
	 	formulario.AgregaCampoFilaPost fila, "pers_nrut", pers_nrut
		if  v_pagada=0 then
			formulario.AgregaCampoFilaPost fila, "pepu_bpagada", "N"
		else
			formulario.AgregaCampoFilaPost fila, "pepu_bpagada", "S"
		end if
   	end if

next   

	formulario.AgregaCampoPost  "epel_ccod", 1
  
  formulario.MantieneTablas false
  
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()  
  

response.Redirect("pagar_archivo_pagare_upa_electronico.asp?q_leng=3&pepu_ccod="&pepu_ccod)
%>