<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../../../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../funciones/funciones.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------Debug>>
'for each k in request.form
' response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.end()
'-----------------------------------------------------Debug<< 
'-----------------------------------------------------captura de variables post>>
cod_pre			= request.Form("busqueda[0][codcaja]") 
detalle			= request.Form("selCombo6") 
area_ccod		= request.Form("busqueda[0][area_ccod]")
eje_ccod		= request.Form("selCombo")
foco_ccod		= request.Form("selCombo2")
prog_ccod		= request.Form("selCombo3")
proye_ccod		= request.Form("selCombo4")
obje_ccod		= request.Form("selCombo5")
tipo_gasto		= request.Form("busqueda[0][tpre_ccod]")
ene 			= request.Form("_test[0][solicitado]")
feb 			= request.Form("_test[1][solicitado]")
mar 			= request.Form("_test[2][solicitado]")
abr 			= request.Form("_test[3][solicitado]")
may 			= request.Form("_test[4][solicitado]")
jun 			= request.Form("_test[5][solicitado]")
jul 			= request.Form("_test[6][solicitado]")
ago 			= request.Form("_test[7][solicitado]")
sep 			= request.Form("_test[8][solicitado]")
octu	 		= request.Form("_test[9][solicitado]")
nov		 		= request.Form("_test[10][solicitado]")
dic		 		= request.Form("_test[11][solicitado]")
total			= request.Form("total_solicitud") 
cpre_ncorr		= detalle

'-----------------------------
set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
f_busqueda2.inicializar conexion2	
con_1 = "select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cpre_ncorr = '"&detalle&"'"
'response.write(con_1)
'response.end()
f_busqueda2.consultar con_1	
f_busqueda2.siguiente
detalle     = f_busqueda2.ObtenerValor("detalle_pre")

if tipo_gasto = 1 then
tipo_gasto_aux = "Primario"
else
tipo_gasto_aux = "Secundario"
end if


'response.Write(detalle)
'response.end()
'-----------------------------------------------------captura de variables post<<
if isNull(cod_pre) 		or cod_pre 		= ""	then cod_pre 	= "0" end if
if isNull(area_ccod) 	or area_ccod 	= "" 	then area_ccod 	= "0" end if
if isNull(eje_ccod) 	or eje_ccod 	= ""	then eje_ccod 	= "0" end if
if isNull(foco_ccod) 	or foco_ccod 	= ""	then foco_ccod 	= "0" end if
if isNull(prog_ccod) 	or prog_ccod 	= ""	then prog_ccod 	= "0" end if
if isNull(proye_ccod) 	or proye_ccod 	= ""	then proye_ccod = "0" end if
if isNull(obje_ccod) 	or obje_ccod 	= ""	then obje_ccod 	= "0" end if
'-----------------------------------------------------variables de uso>>
anio		= "2016"

consulta ="" & vbCrLf & _
"select count(*)					  " & vbCrLf & _
"from   presupuesto_directo_area_desa " & vbCrLf & _
"where cod_pre = '"&cod_pre&"'        " & vbCrLf & _
"and area_ccod 	= '"&area_ccod&"'     " & vbCrLf & _
"and eje_ccod 	= '"&eje_ccod&"'      " & vbCrLf & _
"and prog_ccod 	= '"&prog_ccod&"'     " & vbCrLf & _
"and proye_ccod = '"&proye_ccod&"'	  " & vbCrLf & _
"and obje_ccod 	= '"&obje_ccod&"'     " & vbCrLf & _
"and anio 	= '"&anio&"'     		  " & vbCrLf & _
"and cpre_ncorr = '"&cpre_ncorr&"'    " '-------------------
'response.write("<pre>"&consulta&"</pre>")
'response.end()
contador = conexion.consultaUno(consulta)

if contador > 0 then
sql_update ="" & vbCrLf & _
"update presupuesto_directo_area_desa set " & vbCrLf & _
"       cod_pre    = '"&cod_pre&"'        ," & vbCrLf & _
"       detalle    = '"&detalle&"'        ," & vbCrLf & _
"       area_ccod  =  "&area_ccod&"       ," & vbCrLf & _
"       eje_ccod   =  "&eje_ccod&"        ," & vbCrLf & _
"       foco_ccod  =  "&foco_ccod&"       ," & vbCrLf & _
"       prog_ccod  =  "&prog_ccod&"       ," & vbCrLf & _
"       proye_ccod =  "&proye_ccod&"      ," & vbCrLf & _
"       obje_ccod  =  "&obje_ccod &"      ," & vbCrLf & _
"       tipo_gasto =  '"&tipo_gasto_aux&"'," & vbCrLf & _
"       anio       =  "&anio&"            ," & vbCrLf & _
"       ene        =  "&ene&"             ," & vbCrLf & _
"       feb        =  "&feb&"             ," & vbCrLf & _
"       mar        =  "&mar&"             ," & vbCrLf & _
"       abr        =  "&abr&"             ," & vbCrLf & _
"       may        =  "&may&"             ," & vbCrLf & _
"       jun        =  "&jun&"             ," & vbCrLf & _
"       jul        =  "&jul&"             ," & vbCrLf & _
"       ago        =  "&ago&"             ," & vbCrLf & _
"       sep        =  "&sep&"             ," & vbCrLf & _
"       octu       =  "&octu&"            ," & vbCrLf & _
"       nov        =  "&nov&"             ," & vbCrLf & _
"       dic        =  "&dic&"             ," & vbCrLf & _
"       total      =  "&total&"           " & vbCrLf & _
"where cod_pre = '"&cod_pre&"'        	  " & vbCrLf & _
"and area_ccod 	= '"&area_ccod&"'     	  " & vbCrLf & _
"and eje_ccod 	= '"&eje_ccod&"'      	  " & vbCrLf & _
"and prog_ccod 	= '"&prog_ccod&"'     	  " & vbCrLf & _
"and proye_ccod = '"&proye_ccod&"'	  	  " & vbCrLf & _
"and obje_ccod 	= '"&obje_ccod&"'     	  " & vbCrLf & _
"and anio 	= '"&anio&"'     		  " & vbCrLf & _
"and cpre_ncorr = '"&cpre_ncorr&"'    	  " 
'response.write("<pre>"&sql_update&"</pre>")
'response.end()
estadoTransac = conexion.EjecutaS(sql_update)
else
sql_insert ="" & vbCrLf & _
"insert into presupuesto_directo_area_desa " & vbCrLf & _
"(                                    " & vbCrLf & _
"    cod_pre,                         " & vbCrLf & _
"    detalle,						  " & vbCrLf & _
"	area_ccod,                        " & vbCrLf & _
"	eje_ccod,                         " & vbCrLf & _
"	foco_ccod,                        " & vbCrLf & _
"	prog_ccod,                        " & vbCrLf & _
"	proye_ccod,                       " & vbCrLf & _
"	obje_ccod,                        " & vbCrLf & _
"	tipo_gasto,                       " & vbCrLf & _
"	anio,                             " & vbCrLf & _
"	ene,                              " & vbCrLf & _
"	feb,                              " & vbCrLf & _
"	mar,                              " & vbCrLf & _
"	abr,                              " & vbCrLf & _
"	may,                              " & vbCrLf & _
"	jun,                              " & vbCrLf & _
"	jul,                              " & vbCrLf & _
"	ago,                              " & vbCrLf & _
"	sep,                              " & vbCrLf & _
"	octu,                             " & vbCrLf & _
"	nov,                              " & vbCrLf & _
"	dic,                              " & vbCrLf & _
"	total,   	                      " & vbCrLf & _ 
"	cpre_ncorr 	                      " & vbCrLf & _
")                                    " & vbCrLf & _
"values                               " & vbCrLf & _
"(                                    " & vbCrLf & _
"	'"&cod_pre&"',                    " & vbCrLf & _
"	'"&detalle&"',                    " & vbCrLf & _
"	'"&area_ccod&"',                  " & vbCrLf & _
"	"&eje_ccod&",                     " & vbCrLf & _
"	"&foco_ccod&",                    " & vbCrLf & _
"	"&prog_ccod&",                    " & vbCrLf & _
"	"&proye_ccod&",                   " & vbCrLf & _
"	"&obje_ccod&",                    " & vbCrLf & _
"	'"&tipo_gasto_aux&"',               " & vbCrLf & _
"	"&anio&",                         " & vbCrLf & _
"	"&ene&",                          " & vbCrLf & _
"	"&feb&",                          " & vbCrLf & _
"	"&mar&",                          " & vbCrLf & _
"	"&abr&",                          " & vbCrLf & _
"	"&may&",                          " & vbCrLf & _
"	"&jun&",                          " & vbCrLf & _
"	"&jul&",                          " & vbCrLf & _
"	"&ago&",                          " & vbCrLf & _
"	"&sep&",                          " & vbCrLf & _
"	"&octu&",                         " & vbCrLf & _
"	"&nov&",                          " & vbCrLf & _
"	"&dic&",                          " & vbCrLf & _
"	"&total&",                         " & vbCrLf & _
"	"&cpre_ncorr&"                    " & vbCrLf & _
")                                    " 
'response.write("<pre>"&sql_insert&"</pre>")
'response.end()
'--------------------------------------------------->>Debug
estadoTransac = conexion.EjecutaS(sql_insert)
end if



'-----------------------------------------------------variables de uso<<

if estadoTransac = true then
response.write("<font color='#339966'><strong>REGISTRO GUARDADO CORRECTAMENTE</strong></font>")
end if
if estadoTransac = false then
response.write("<font color='#FF0000'><strong>PROBLEMAS AL GUARDAR EL REGISTRO</strong></font>")
end if

%>

