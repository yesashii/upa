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
dgso_tdesc=request.form("b[0][dgso_tdesc]")
dgso_ftermino=request.form("b[0][dgso_ftermino2]")
dgso_finicio=request.form("b[0][dgso_finicio2]")
horas=request.form("b[0][horas]")
dias_ccod=request.form("b[0][dias_ccod]")
seot_ncorr=request.form("b[0][seot_ncorr]")
'****************************************************'
'* CAPTURA DE LAS VARIABLES DEL POST *'
'*************************************'


'********************'
'** FUNCIÓN ESTADO **'
'*****************************************************'
function fHorasTotales(fFecha)
'	valretorno = CStr("1")
	valretorno = "1"
	fechaAuxActual = conexion.ConsultaUno("select GETDATE()")
	diferencia = DateDiff("D", fechaAuxActual, fFecha)
	
	if diferencia < 0 then
		valretorno = "0"
	end if	
	fHorasTotales = valretorno
end function
'*****************************************************'
'** FUNCIÓN ESTADO **'
'********************'

'****************************************************'
'* TRAE LOS DÍAS COMPRENDIDOS EN EL RANGO DE FECHAS *'
'******************************************************************'
set f_calen = new CFormulario
f_calen.Carga_Parametros "tabla_vacia.xml", "tabla"
f_calen.Inicializar conexion
'-------------
pcot_ncorr = conexion.consultauno("EXEC ObtenerSecuencia 'programacion_calendario_otec'")
usuario = negocio.obtenerUsuario()
set f_calen_2 = new CFormulario
f_calen_2.Carga_Parametros "tabla_vacia.xml", "tabla"
f_calen_2.Inicializar conexion
consulta_2 = "" & vbCrLf & _
"select protic.trunc(cale_fcalendario) as fecha,                            " & vbCrLf & _
"       cale_bdia_habil,                                                    " & vbCrLf & _
"       cale_bferiado                                                       " & vbCrLf & _
"from   calendario                                                          " & vbCrLf & _
"where  cale_fcalendario between '"&dgso_finicio&"' and '"&dgso_ftermino&"' " & vbCrLf & _
"       and cale_bdia_habil = '1'                                           " & vbCrLf & _
"       and isnull(cale_bferiado, 0) != '1'                                 " & vbCrLf & _
"and DATEPART(WEEKDAY,cale_fcalendario) = '"&dias_ccod&"'					"
'response.Write("<pre>"&consulta_2&"</pre>")
'response.end()
''******************************************************************'
''* TRAE LOS DÍAS COMPRENDIDOS EN EL RANGO DE FECHAS *'
''****************************************************'
verificadorInsert = true
f_calen_2.Consultar consulta_2
while f_calen_2.Siguiente
if verificadorInsert then
	'***********************************************************> inserta un elemento en T = programacion_calendario_otec
	consulta_1 = "" & vbCrLf & _
	"insert into programacion_calendario_otec " & vbCrLf & _
	"values      ( '"&pcot_ncorr&"',          " & vbCrLf & _
	"              '"&seot_ncorr&"',          " & vbCrLf & _
	"              '"&dias_ccod&"',           " & vbCrLf & _
	"              '"&usuario&"',             " & vbCrLf & _
	"              getdate() )                " 
'response.Write("<pre>"&consulta_1&"</pre>")	
'response.end()
	conexion.ejecutaS(consulta_1)
	'***********************************************************< inserta un elemento en T = programacion_calendario_otec
	verificadorInsert = false
end if	
fechaAux = f_calen_2.ObtenerValor ("fecha")
consulta_3 = "" & vbCrLf & _
"insert into programacion_calendario_detalle_otec 	" & vbCrLf & _
"values      ( '"&pcot_ncorr&"',                  	" & vbCrLf & _
"              '"&fechaAux&"',						" & vbCrLf & _
"              null,									" & vbCrLf & _
"              '1', 								" & vbCrLf & _
"              '',                   				" & vbCrLf & _
"              '"&horas&"',                       	" & vbCrLf & _
"              '"&usuario&"',                     	" & vbCrLf & _
"              getdate() )                        	" 
'response.Write("<pre>"&consulta_3 & "</pre><br/>")
conexion.ejecutaS(consulta_3)			  
wend
'---------------------------------------------------------prueba
'response.Write("<pre>"&consulta_2 & "</pre><br/><pre>"&consulta_1 & "</pre><br/><pre>"&consulta_3 & "</pre><br/>")
'response.end()
'---------------------------------------------------------prueba
response.redirect(request.ServerVariables("HTTP_REFERER"))
%>