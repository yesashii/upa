<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new Cnegocio
negocio.Inicializa conexion
'for each k in request.QueryString
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.End()

'----------------------------------------------*********captura de get
fecha_calendario = request.QueryString("fecha")
pcot_ncorr = request.QueryString("pcot_ncorr")
seot_ncorr = request.QueryString("seot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
'----------------------------------------------*********captura de get
'****************************'
'* CAPTURA DE LAS VARIABLES *'
'****************************************************'		
usuario = negocio.obtenerUsuario()
'---------------------------------****************************
consulta_pcot_ncorr = "" & vbCrLf & _
"select a.pcot_ncorr                                                 " & vbCrLf & _
"from   programacion_calendario_otec as a                            " & vbCrLf & _
"       inner join programacion_calendario_detalle_otec              " & vbCrLf & _
"                  as b                                              " & vbCrLf & _
"               on a.pcot_ncorr = b.pcot_ncorr                       " & vbCrLf & _
"                  and a.seot_ncorr = '"& seot_ncorr &"'             " & vbCrLf & _  
"                  and b.fecha_calendario = '"&fecha_calendario&"'   " 
pcot_ncorr = conexion.ConsultaUno(consulta_pcot_ncorr)
'response.Write("pcot_ncorr =" & pcot_ncorr)

'---------------------------------****************************
'****************************************************'
'* CAPTURA DE LAS VARIABLES *'
'****************************'

consulta_update = "" & vbCrLf & _
"update programacion_calendario_detalle_otec     	" & vbCrLf & _
"set    estado_programacion = '1',               	" & vbCrLf & _
"       audi_tusuario = '"&usuario&"',           	" & vbCrLf & _
"       audi_fmodificacion = getdate(),          	" & vbCrLf & _
"       motivo = ''  			                  	" & vbCrLf & _
"where  fecha_calendario = '"&fecha_calendario&"'	" & vbCrLf & _
"       and pcot_ncorr = '"&pcot_ncorr&"'			"
'response.Write("<pre>"&consulta_update&"</pre>")
conexion.ejecutaS(consulta_update)
response.redirect(request.ServerVariables("HTTP_REFERER"))
%>
