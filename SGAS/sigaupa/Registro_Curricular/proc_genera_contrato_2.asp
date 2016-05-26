<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
q_post_ncorr = Request.QueryString("post_ncorr")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_detalle_pagos = new CFormulario
f_detalle_pagos.Carga_Parametros "genera_contrato_2.xml", "detalle_pagos"
f_detalle_pagos.Inicializar conexion
f_detalle_pagos.ProcesaForm
salida_detalle= f_detalle_pagos.MantieneTablas(false)
if salida_detalle=false then
'	response.Write("algo fallo")
else
'response.Write("todo estuvo bien")	
end if
'conexion.estadoTransaccion false
'f_detalle_pagos.MantieneTablas(true)
'response.End()
Response.Redirect("genera_contrato_3.asp?post_ncorr=" & q_post_ncorr)
%>
