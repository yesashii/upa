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
fecha_calendario=request.form("m[0][fecha_calendario]")
'pcot_ncorr = request.form("m[0][pcot_ncorr]")
seot_ncorr = request.form("m[0][seot_ncorr]")
'pcot_ncorr = "76"
usuario = negocio.obtenerUsuario()
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
"update programacion_calendario_detalle_otec     	" & vbCrLf & _
"set    estado_programacion = '0',               	" & vbCrLf & _
"       audi_tusuario = '"&usuario&"',           	" & vbCrLf & _
"       audi_fmodificacion = getdate(),          	" & vbCrLf & _
"       motivo = '"&motivo&"'                    	" & vbCrLf & _
"where  fecha_calendario = '"&fecha_calendario&"'	" & vbCrLf & _
"       and pcot_ncorr = '"&pcot_ncorr&"'			"
'response.Write("<pre>"&consulta_update&"</pre>")
conexion.ejecutaS(consulta_update)
'**************************'
'* COMPRUEBA SI HAY HIJOS *'
'****************************************************'	
consultaHijos = "" & vbCrLf & _
"select	count(a.pcot_ncorr)                                   " & vbCrLf & _
"from	programacion_calendario_otec  as a                    " & vbCrLf & _
"		inner join  programacion_calendario_detalle_otec as b " & vbCrLf & _
"		    on a.pcot_ncorr = b.pcot_ncorr                    " & vbCrLf & _
"		    and b.estado_programacion = '1'                   " & vbCrLf & _
"		    and seot_ncorr = '"& seot_ncorr &"'               " & vbCrLf & _
"		    and a.pcot_ncorr = '"&pcot_ncorr&"'               "
numHijos = conexion.ConsultaUno(consultaHijos)

if numHijos = 0 then
consulta_delete1 = "" & vbCrLf & _
"delete programacion_calendario_detalle_otec 	" & vbCrLf & _
"where pcot_ncorr =  '"&pcot_ncorr&"'    		" 
conexion.ejecutaS(consulta_delete1)
consulta_delete2 = "" & vbCrLf & _
"delete programacion_calendario_otec 	" & vbCrLf & _
"where pcot_ncorr = '"&pcot_ncorr&"'	"
conexion.ejecutaS(consulta_delete2)
'response.Write("<pre>"&consulta_delete1&"</pre>")
'response.Write("<pre>"&consulta_delete2&"</pre>")
'response.End()

end if
'response.Write("<br/>"&numHijos)
'response.Write("<pre>"&consulta_delete1&"</pre>")
'response.Write("<pre>"&consulta_delete2&"</pre>")
'response.End()
'****************************************************'	
'* COMPRUEBA SI HAY HIJOS *'
'**************************'
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type = text/javascript >
	CerrarActualizar();
</script>
