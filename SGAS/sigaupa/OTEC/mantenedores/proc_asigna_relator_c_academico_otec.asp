<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new Cnegocio
negocio.Inicializa conexion
'for each k in request.form
' response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
'*************************************'
'* CAPTURA DE LAS VARIABLES DEL POST *'
'****************************************************'		
motivo=request.form("m[0][motivo]")
pers_ncorr = request.form("com[0][pers_ncorr]")
seot_ncorr = request.form("com[0][seot_ncorr]")
fecha_calendario = request.form("com[0][fecha_calendario]")
'****************************************************'
'* CAPTURA DE LAS VARIABLES DEL POST *'
'*************************************'
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
consulta_update = "" & vbCrLf & _
"update programacion_calendario_detalle_otec                             " & vbCrLf & _
"set    pers_ncorr = '"&pers_ncorr&"'                                    " & vbCrLf & _
"where  pcot_ncorr = '"&pcot_ncorr&"'                                    " & vbCrLf & _
"       and protic.trunc(fecha_calendario) = '"&fecha_calendario&"' 		 "
'response.Write("<pre>"&consulta_update&"</pre>")
'response.end()
conexion.ejecutaS(consulta_update)
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type = text/javascript >
	CerrarActualizar();
</script>