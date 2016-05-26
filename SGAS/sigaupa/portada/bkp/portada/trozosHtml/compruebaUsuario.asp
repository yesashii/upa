<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<%
set conexion    = new CConexion
conexion.Inicializar "upacifico"
'set negocio     = new CNegocio
'negocio.Inicializa conexion



usuario	        = request.querystring("usuario")

esUsuario       = 0

'**************************'
'**		BUSQUEDA		 **'
'**************************'------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_busqueda.inicializar conexion

consulta = "" & vbCrLf & _
"SELECT count(su.susu_tlogin) as conteo                                 " & vbCrLf & _
"FROM   sis_roles sr                                                    " & vbCrLf & _
"       INNER JOIN sis_roles_usuarios sru                               " & vbCrLf & _
"               ON sr.srol_ncorr = sru.srol_ncorr	                      " & vbCrLf & _
"       INNER JOIN personas p 						                              " & vbCrLf & _
"               ON sru.pers_ncorr = p.pers_ncorr                        " & vbCrLf & _
"       INNER JOIN sis_usuarios su                                      " & vbCrLf & _
"               ON p.pers_ncorr = su.pers_ncorr                         " & vbCrLf & _
"							 and su.susu_tlogin = '"&usuario&"'                       " & vbCrLf & _
"WHERE  sr.srol_tdesc = 'Desarrollador' or  sr.srol_tdesc = 'Docente'   "
f_busqueda.consultar consulta
while f_busqueda.Siguiente
  esUsuario 	= f_busqueda.ObtenerValor("conteo")
wend

response.write(esUsuario)
%>
