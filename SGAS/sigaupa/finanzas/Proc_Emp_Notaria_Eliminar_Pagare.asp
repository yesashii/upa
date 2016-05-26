<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "envios_notaria_pagare.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm


'formulario.ListarPost
'tengo que buscar si tienen detalles, si tienen no los elimino
for fila = 0 to formulario.CuentaPost - 1
    'num_folio = formulario.ObtenerValorPost (fila, "envi_ncorr")
   num_folio = formulario.ObtenerValorPost (fila, "enpa_ncorr")

  if num_folio <> "" then
     SQL = "select count(enpa_ncorr) as total from detalle_envios_pagares where enpa_ncorr=" & num_folio
	 f_consulta.consultar SQL
	 f_consulta.siguiente
	 documentos = f_consulta.ObtenerValor ("total")
	 if documentos = 0 then
        SQL = "delete from envios_pagares where enpa_ncorr=" & num_folio 
		conexion.EstadoTransaccion conexion.EjecutaS(SQL) 
	 else
	    cont =cont + 1

		cad = cad & num_folio & "  "	
	 end if	 
  end if
next 

if cont > 0 then
  mensage = " Los siguientes Envios Pagares a Notaria no se eliminaron porque contenían Documentos..." & "\nFolios: " & cad 
  session("mensajeError")= mensage
end if
'formulario.MantieneTablas false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
