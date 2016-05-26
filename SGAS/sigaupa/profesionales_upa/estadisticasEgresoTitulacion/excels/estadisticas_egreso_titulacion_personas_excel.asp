<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_personas.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------oDebug>>
'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.end()
'---------------------------------------------------oDebug<<
'***************************'
'** CAPTURA VARIABLES GET **'
'***************************'--------------------------	
sede_ccod 	= request.QueryString("sede_ccod")
tipo      	= request.QueryString("tipo")
sexo_ccod 	= request.QueryString("sexo_ccod")
institucion	= request.QueryString("institucion")
facu_ccod	= request.QueryString("facu_ccod")
carr_ccod   = request.QueryString("carr_ccod")
numero		= 1
'----------------------------------------000000Nuevas variables
upa_pregrado	= request.QueryString("upa_pregrado")
upa_postgrado 	= request.QueryString("upa_postgrado")
instituto		= request.QueryString("instituto")
masculino 		= request.QueryString("masculino")
egresados 		= request.QueryString("egresados")
titulados 		= request.QueryString("titulados")
graduados 		= request.QueryString("graduados")
salidas_int 	= request.QueryString("salidas_int")
femenino 		= request.QueryString("femenino")
selectAnioPromo = request.QueryString("selectAnioPromo")
selectAnioTitu  = request.QueryString("selectAnioTitu")
selectAnioEgre  = request.QueryString("selectAnioEgre")
'----------------------------------------xxxxxxNuevas variables
'***************************'--------------------------	
'** CAPTURA VARIABLES GET **'
'***************************'
'*******************************'
'** TRATAMIENTOS DE VARIABLES **'
'*******************************'--------------------------	
'--------->>>>>>>>Variables SQL
v_facu_ccod 	= facu_ccod 'no cambia******	
v_carr_ccod 	= carr_ccod 'no cambia******
v_anio_promo 	= selectAnioPromo 'no cambia******
v_anio_egreso 	= selectAnioEgre 'no cambia******
v_anio_titula   = selectAnioTitu 'no cambia******
'----------<<<<<<<Variables SQL
'------------->>>>>>>>>>>>>>>>Arreglo de sexo
if sexo_ccod = 1 then 
masculino 	= "1"
femenino 	= "0"
end if
if sexo_ccod = 2 then 
masculino 	= "0"
femenino 	= "1"
end if
'-------------<<<<<<<<<<<<<<<<Arreglo de sexo
'------------>>>>>Variables de compara filtro
tipoPromo	= "NOAPLICA"
tipoEgre 	= "NOAPLICA"
tipoTitu 	= "NOAPLICA"

if v_anio_promo <> "0" then
	tipoPromo = "PROMOCION"
end if

if v_anio_egreso <> "0" then
	tipoEgre = "EGRESO"
end	if 
   
if v_anio_titula <> "0" then
	tipoTitu = "TITULACION"
end	if	  
'------------<<<<<Variables de compara filtro
sede_tdesc 	= conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carr_tdesc 	= conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
facu_tdesc 	= conexion.consultaUno("select facu_tdesc from facultades where cast(facu_ccod as varchar)='"&facu_ccod&"'")
sexo_tdesc 	= conexion.consultaUno("select sexo_tdesc from sexos where cast(sexo_ccod as varchar)='"&sexo_ccod&"'")
fecha1	   	= conexion.consultaUno("select getDate()")
estado		= ""
categoria 	= "PREGRADO"
institucion = "UNIVERSIDAD"
insti		= "U"
'----------------------------Estados>>>>>>>
if tipo = "UEG" then
	estado = "EGRESADOS DE LA UNIVERSIDAD"
end if
if tipo = "UTI" then
	estado = "TITULADOS DE LA UNIVERSIDAD"
end if
if tipo = "PRG" then
	estado = "GRADUADOS DE LA UNIVERSIDAD"
end if
if tipo = "SIE" then
	estado = "EGRESADOS DE SALIDAS INTERMEDIAS"
end if
if tipo = "SIT" then
	estado = "TITULADOS DE SALIDAS INTERMEDIAS"
end if
if tipo = "IEG" then
	estado = "EGRESADOS DE INSTITUTO"
	institucion = "INSTITUTO"
end if
if tipo = "ITI" then
	estado = "TITULADOS DE INSTITUTO"
	institucion = "INSTITUTO"
end if
if tipo = "POG" then
	estado = "GRADUADOS DE LA UNIVERSIDAD"
end if

'----------------------------Estados<<<<<<<

'*******************************'--------------------------	
'** TRATAMIENTOS DE VARIABLES **'
'*******************************'
set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"
'****************'
'** FUNCIONES  **'
'****************'--------------------------
function existeInfo( dato )
	retorno = ""
	if dato = "" or dato = "Sin info." then
		retorno = "No existe."
	else
		retorno = Cstr(dato)
	end if
	existeInfo = Cstr(retorno)
end function
function insertarCampo(rut,nombre,ano_ingreso)
	%>
	<tr>
		<td width="25%" style="background-color:#FFF" align="center" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=Cstr( numero )%></td>
		<td width="25%" style="background-color:#FFF" align="center" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=existeInfo( Cstr( rut ) )%></td>
		<td width="50%" style="background-color:#FFF" class="nombre" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=existeInfo( Cstr(	nombre ) ) %></td>
		<td width="25%" style="background-color:#FFF"  align="center" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=existeInfo( Cstr(	ano_ingreso ) )%></td>	
	</tr>
	<%
	numero = numero + 1
end function
'****************'--------------------------
'** FUNCIONES  **'
'****************'

%>
<html>
<head>
<title>egreso y titulacion personas excel</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="0">
   					<tr>
						<td width="20%"><strong>Categoría</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=categoria%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Institución</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=institucion%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Sede</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=sede_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Carrera</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=carr_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<%if instituto <> 1 then%>
					<tr>
						<td width="20%"><strong>Facultad</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=facu_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<% end if %>
					<tr>
						<td width="20%"><strong>Estado</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=estado%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Género</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=sexo_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Fecha</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=conexion.consultaUno("select getDate()") %></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td colspan="3" align="center">
							<table width="90%" cellpadding="0" cellspacing="1" border="1" bordercolor="#333333">
								<tr>
									<td align="center" bgcolor="#FF9900"><strong>FILA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>RUT</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>NOMBRE</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>AÑO INGRESO</strong></td>
								</tr>
<%' ACÁ VA EL CÓDIGO QUE INSERTA LAS FILAS
v_sede_ccod 	= sede_ccod

'******************************'
'** 	 TROZO SELECT 1 	 **'
'******************************'--------------------------
select_1 = ""& vbCrLf &_
"select distinct cast(a.pers_ncorr as varchar) + '-' 																												"& vbCrLf &_
"                + ltrim(rtrim(c.carr_ccod))                                                                                               as pers_ncorr_carr_ccod,	"& vbCrLf &_
"                cast(isnull(f.pers_nrut, g.pers_nrut) as varchar)                                                                                                  "& vbCrLf &_
"                + '-' + isnull(f.pers_xdv, g.pers_xdv )                                                                                   as rut,                  "& vbCrLf &_
"                isnull(f.pers_tape_paterno, g.pers_tape_paterno)                                                                                                   "& vbCrLf &_
"                + ' '                                                                                                                                              "& vbCrLf &_
"                + isnull(f.pers_tape_materno, g.pers_tape_materno)                                                                                                 "& vbCrLf &_
"                + ', '                                                                                                                                             "& vbCrLf &_
"                + isnull(f.pers_tnombre, g.pers_tnombre)                                                                                  as nombre,               "& vbCrLf &_
"                isnull(cast(protic.ano_ingreso_carrera_egresa2(isnull(f.pers_ncorr, g.pers_ncorr), c.carr_ccod) as varchar), 'Sin info.') as ano_ingreso           "
'******************************'--------------------------
'** 	 TROZO SELECT 1 	 **'
'******************************'
'******************************'
'** 	 TROZO SELECT 2 	 **'
'******************************'--------------------------
select_2 = ""& vbCrLf &_
"select distinct cast(a.pers_ncorr as varchar) + '-' 																														"& vbCrLf &_
"                + ltrim(rtrim(c.carr_ccod))                                                                                                       as pers_ncorr_carr_ccod,	"& vbCrLf &_
"                cast(isnull(g.pers_nrut, a.pers_nrut) as varchar)                                                                                                          "& vbCrLf &_
"                + '-'                                                                                                                                                      "& vbCrLf &_
"                + isnull(g.pers_xdv, a.pers_xdv collate sql_latin1_general_cp1_ci_as)                                                             as rut,                  "& vbCrLf &_
"                isnull(( g.pers_tape_paterno + ' '                                                                                                                         "& vbCrLf &_
"                         + g.pers_tape_materno + ', ' + g.pers_tnombre ), ( a.apellidos + ' ' + a.nombres collate sql_latin1_general_cp1_ci_as )) as nombre,               "& vbCrLf &_
"                isnull(cast(a.promocion as varchar), 'Sin info.')                                                                                 as ano_ingreso           "
'******************************'--------------------------
'** 	 TROZO SELECT 2 	 **'
'******************************'




'******************************'
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'--------------------------
if upa_pregrado = "1" then 
institucion = "UNIVERSIDAD"		
	if egresados = "1" then'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>EGRESADOS->>	
		if masculino = "1" then'egresados hombres>>
			v_sexo_ccod = "1"
			'--------------------------------------------------------------------consulta>>
set f_personas = new cformulario
f_personas.carga_parametros "tabla_vacia.xml","tabla"
f_personas.inicializar conexion	
			conAux_1 = CStr(uniEgresadosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			conAux_2 = CStr(uniEgresadosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			consulta = select_1& vbCrLf &_
						conAux_1& vbCrLf &_
						"union"& vbCrLf &_
						select_2& vbCrLf &_
						conAux_2
'Response.write("Egresados_Hombres_______<br/><pre> "&consulta&"</pre>")	
'response.end()			
f_personas.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas.siguiente
	'-------------------->>CapturaVariablea
		rut					= f_personas.obtenerValor("rut" )						
		nombre				= f_personas.obtenerValor("nombre" )		
		ano_ingreso			= f_personas.obtenerValor("ano_ingreso" ) 		
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend				
				'--------------------------------------------------------------------consulta>>
				
		end if'egresados hombres<<
		if femenino = "1" then'UEM = universidad egresados mujeres>>
			v_sexo_ccod = "2"
			'--------------------------------------------------------------------consulta>>			
set f_personas_UEM = new cformulario
f_personas_UEM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_UEM.inicializar conexion		
			conAux_1 = CStr(uniEgresadosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			conAux_2 = CStr(uniEgresadosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			consulta = select_1& vbCrLf &_
						conAux_1& vbCrLf &_
						"union"& vbCrLf &_
						select_2& vbCrLf &_
						conAux_2
'Response.write("Egresados_Mujeres_______<br/><pre> "&consulta&"</pre>")	
'response.end()			
f_personas_UEM.Consultar consulta
nombre = ""
while f_personas_UEM.siguiente
	'-------------------->>CapturaVariablea					
		rut					= f_personas_UEM.obtenerValor("rut" )						
		nombre				= f_personas_UEM.obtenerValor("nombre" )		
		ano_ingreso			= f_personas_UEM.obtenerValor("ano_ingreso" ) 		
	'--------------------<<CapturaVariablea
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)
wend				
				'--------------------------------------------------------------------consulta>>
				'Response.write("Egresados_Mujeres_______<br/><pre> "&consulta&"</pre>")
		end if'UEM = universidad egresados mujeres<<
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<EGRESADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>TITULADOS
	if titulados = "1" then
		if masculino = "1" then'Titulados hombres>>
			v_sexo_ccod = "1"
			'--------------------------------------------------------------------consulta>>
set f_personas = new cformulario
f_personas.carga_parametros "tabla_vacia.xml","tabla"
f_personas.inicializar conexion	
			conAux_1 = CStr(uniTituladosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			conAux_2 = CStr(uniTituladosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			consulta = select_1& vbCrLf &_
						conAux_1& vbCrLf &_
						"union"& vbCrLf &_
						select_2& vbCrLf &_
						conAux_2		
f_personas.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas.siguiente
	'-------------------->>CapturaVariablea					
		rut					= f_personas.obtenerValor("rut" )						
		nombre				= f_personas.obtenerValor("nombre" )		
		ano_ingreso			= f_personas.obtenerValor("ano_ingreso" ) 		
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend				
				'--------------------------------------------------------------------consulta>>
				
		end if'Titulados hombres<<
		if femenino = "1" then'UEM = universidad Titulados mujeres>>
			v_sexo_ccod = "2"
			'--------------------------------------------------------------------consulta>>			
set f_personas_UEM = new cformulario
f_personas_UEM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_UEM.inicializar conexion			
			conAux_1 = CStr(uniTituladosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			conAux_2 = CStr(uniTituladosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))
			consulta = select_1& vbCrLf &_
						conAux_1& vbCrLf &_
						"union"& vbCrLf &_
						select_2& vbCrLf &_
						conAux_2
'response.write("<pre>"&consulta&"</pre>")
'response.end()						
f_personas_UEM.Consultar consulta
nombre = ""
while f_personas_UEM.siguiente
	'-------------------->>CapturaVariablea						
		rut					= f_personas_UEM.obtenerValor("rut" )						
		nombre				= f_personas_UEM.obtenerValor("nombre" )		
		ano_ingreso			= f_personas_UEM.obtenerValor("ano_ingreso" ) 
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)
wend	
		end if'UEM = universidad titulados mujeres<<
	end if	
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<TITULADOS
'*********************************************************************************************************************************************************************'
'**																																									**'
'**													UNIVERSIDAD - > SALIDAS INTERMEDIAS																				**'
'**																																									**'
'********************************************************************************************************************************************************************'---------------------------------------
if salidas_int = "1" then
'UNIVERSIDAD - > SALIDAS INTERMEDIAS -> EGRESADOS Y TITULADOS>>
if masculino = "1" then  	
			v_sexo_ccod = "1"
			set f_personas_USIEH = new cformulario
			f_personas_USIEH.carga_parametros "tabla_vacia.xml","tabla"
			f_personas_USIEH.inicializar conexion			
			conAux_1 = CStr(sITYE(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_1& vbCrLf &_
						conAux_1
			f_personas_USIEH.Consultar consulta
			nombre = ""
			while f_personas_USIEH.siguiente
				'-------------------->>CapturaVariablea					
				rut			= f_personas_USIEH.obtenerValor("rut" )						
				nombre		= f_personas_USIEH.obtenerValor("nombre" )		
				ano_ingreso	= f_personas_USIEH.obtenerValor("ano_ingreso" ) 
				'--------------------<<CapturaVariablea
				insertarCampo rut,nombre,ano_ingreso
				contador = contador + 1
				num = Cstr(contador)	
			wend
		end if
		if femenino = "1" then
			v_sexo_ccod = "2"
'USIEM = universidad salidas intermedias Mujeres

set f_personas_USIEM = new cformulario
f_personas_USIEM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_USIEM.inicializar conexion			
			conAux_1 = CStr(sITYE(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_1& vbCrLf &_
						conAux_1
f_personas_USIEM.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas_USIEM.siguiente
	'-------------------->>CapturaVariablea						
		rut			= f_personas_USIEM.obtenerValor("rut" )						
		nombre		= f_personas_USIEM.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_USIEM.obtenerValor("ano_ingreso" ) 
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend
		end if	
	'UNIVERSIDAD - > SALIDAS INTERMEDIAS -> EGRESADOS Y TITULADOS<<
end if
'*********************************************************************************************************************************************************************'---------------------------------------
'**																																									**'
'**													UNIVERSIDAD - > SALIDAS INTERMEDIAS																				**'
'**																																									**'
'*********************************************************************************************************************************************************************'
end if
'******************************'--------------------------
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'

'*******************************'
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'--------------------------					
if upa_postgrado = "1" then 
institucion = "UNIVERSIDAD"		
	if graduados = "1" then
		if masculino = "1" then
			v_sexo_ccod = "1"		
			'--------------------------------------------------------------------consulta>>	
'UPGH = UPA Postgrado graduados hombres

set f_personas_UPGH = new cformulario
f_personas_UPGH.carga_parametros "tabla_vacia.xml","tabla"
f_personas_UPGH.inicializar conexion	
conAux_1 = CStr(UPAPostgradoGraduadosp1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_1& vbCrLf &_	
			conAux_1
'[test: imprime la consulta en el caso post grado hombres]---------------------->>			
'Response.write("Postgrado graduado Hombres_____<br/><pre>"&consulta&"</pre>")  
'response.end()
'[test: imprime la consulta en el caso post grado hombres]<<----------------------	
f_personas_UPGH.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas_UPGH.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_UPGH.obtenerValor("rut" )						
		nombre		= f_personas_UPGH.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_UPGH.obtenerValor("ano_ingreso" ) 
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend							
			'--------------------------------------------------------------------consulta<<
			
		end if
		if femenino = "1" then
			v_sexo_ccod = "2"		
			'--------------------------------------------------------------------consulta>>
'UPGM = UPA Postgrado graduados mujeres

set f_personas_UPGM = new cformulario
f_personas_UPGM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_UPGM.inicializar conexion			
conAux_1 = CStr(UPAPostgradoGraduadosp1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_1& vbCrLf &_	
			conAux_1     
f_personas_UPGM.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas_UPGM.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_UPGM.obtenerValor("rut" )						
		nombre		= f_personas_UPGM.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_UPGM.obtenerValor("ano_ingreso" ) 	
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend							
			'--------------------------------------------------------------------consulta<<
'			Response.write("Postgrado graduado Mujeres___<br/><pre>"&consulta&"</pre>")
		end if
	end if	
end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'
'*******************************'
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'--------------------------	
if instituto = "1" then 
institucion = "UNIVERSIDAD"		
	if egresados = "1" then
		if masculino = "1" then
			v_sexo_ccod = "1"		
			'--------------------------------------------------------------------consulta>>
'IEH = instituto egresado hombres
set f_personas_IEH = new cformulario
f_personas_IEH.carga_parametros "tabla_vacia.xml","tabla"
f_personas_IEH.inicializar conexion			
conAux_1 = CStr(insEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_2& vbCrLf &_	
			conAux_1 
'response.write("<pre>"&consulta&"</pre>")	
'response.write("<hr/>")		
f_personas_IEH.Consultar consulta
while f_personas_IEH.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_IEH.obtenerValor("rut" )						
		nombre		= f_personas_IEH.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_IEH.obtenerValor("ano_ingreso" ) 		
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend							
			'--------------------------------------------------------------------consulta<<
			'Response.write("Instituto graduado Hombres_____<br/><pre>"&consulta&"</pre>")
		end if'if masculino = "1" then
		if femenino = "1" then
			v_sexo_ccod = "2"		
			'--------------------------------------------------------------------consulta>>
'IEM = instituto egresado mujeres

set f_personas_IEM = new cformulario
f_personas_IEM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_IEM.inicializar conexion			
conAux_1 = CStr(insEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_2& vbCrLf &_	
			conAux_1 
f_personas_IEM.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas_IEM.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_IEM.obtenerValor("rut" )						
		nombre		= f_personas_IEM.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_IEM.obtenerValor("ano_ingreso" ) 		
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend							
			'--------------------------------------------------------------------consulta<<
			'Response.write("Instituto graduado Mujeres_____<br/><pre>"&consulta&"</pre>")
		end if'if femenino = "1" then
	end if'if egresados = "1" then
	if titulados = "1" then
		if masculino = "1" then
			v_sexo_ccod = "1"		
			'--------------------------------------------------------------------consulta>>
'ITH = instituto titulado hombres

set f_personas_ITH = new cformulario
f_personas_ITH.carga_parametros "tabla_vacia.xml","tabla"
f_personas_ITH.inicializar conexion	
conAux_1 = CStr(insTItulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_2& vbCrLf &_	
			conAux_1     
f_personas_ITH.Consultar consulta
nombre = ""
while f_personas_ITH.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_ITH.obtenerValor("rut" )						
		nombre		= f_personas_ITH.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_ITH.obtenerValor("ano_ingreso" )	
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend								
			'--------------------------------------------------------------------consulta<<
			'Response.write("Instituto Titulados Hombres_____<br/><pre>"&consulta&"</pre>")
		end if'if masculino = "1" then
		if femenino = "1" then
			v_sexo_ccod = "2"		
			'--------------------------------------------------------------------consulta>>
'ITM = instituto titulado mujeres

set f_personas_ITM = new cformulario
f_personas_ITM.carga_parametros "tabla_vacia.xml","tabla"
f_personas_ITM.inicializar conexion			
conAux_1 = CStr(insTItulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula))			
			consulta = select_2& vbCrLf &_	
			conAux_1  
f_personas_ITM.Consultar consulta
nombre = ""
'response.buffer = false
while f_personas_ITM.siguiente
	'-------------------->>CapturaVariablea
		rut			= f_personas_ITM.obtenerValor("rut" )						
		nombre		= f_personas_ITM.obtenerValor("nombre" )		
		ano_ingreso	= f_personas_ITM.obtenerValor("ano_ingreso" )
	'--------------------<<CapturaVariablea
	insertarCampo rut,nombre,ano_ingreso
	contador = contador + 1
	num = Cstr(contador)	
wend								
			'--------------------------------------------------------------------consulta<<
			'Response.write("Instituto Titulados Mujeres_____<br/><pre>"&consulta&"</pre>")
		end if'if femenino = "1" then
	end if'if titulados = "1" then
end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'								
							 %>			
							</table>
						</td>
					</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>