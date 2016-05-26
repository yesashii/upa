<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%
Server.ScriptTimeOut = 300000
set pagina = new CPagina
pagina.Titulo = EncodeUTF8("Estadísticas egresados, titulados y graduados")
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'set negocio = new CNegocio
'negocio.Inicializa conexion
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
if sexo_ccod = 3 then 
masculino 	= "1"
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
institucion = "INSTITUTO"
if instituto <> 1 then 
institucion = "UNIVERSIDAD"
end if
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
end if
if tipo = "ITI" then
	estado = "TITULADOS DE INSTITUTO"
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
		retorno = "No existe info. en BD."
	else
		retorno = Cstr(dato)
	end if
	existeInfo = Cstr(retorno)
end function
function insertarCampo(rut,nombre,ano_ingreso)
	%>
	<tr>
		<td width="25%" style="background-color:#FFF" align="center" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=existeInfo( Cstr( rut ) )%></td>
		<td width="50%" style="background-color:#FFF" class="nombre" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=EncodeUTF8( existeInfo( Cstr(	nombre ) ) )%></td>
		<td width="25%" style="background-color:#FFF"  align="center" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=existeInfo( Cstr(	ano_ingreso ) )%></td>	
	</tr>
	<%
end function
'****************'--------------------------
'** FUNCIONES  **'
'****************'




%>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array( EncodeUTF8("Distribución de personas") ), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <% EncodeUTF8( pagina.DibujarTituloPagina )%>
			  </div>
            </td>
		  </tr>
		  <form name="edicion" method="post">
		  <tr>
		  	<td align="center"> &nbsp;
				<table width="100%" cellpadding="0" cellspacing="0">
<% if instituto <> 1 then %>				
					<tr>
						<td width="20%"><strong>Categor&iacute;a</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%= EncodeUTF8(categoria) %></td>
					</tr>
					<tr>
						<td width="20%"><strong>Sede</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8( sede_tdesc )%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Facultad</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8( facu_tdesc )%></td>
					</tr>
<% end if %>
					<tr>
						<td width="20%"><strong>Instituci&oacute;n</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8( institucion )%></td>
					</tr>		
					<tr>
						<td width="20%"><strong>Carrera</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8( carr_tdesc )%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Estado</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8(estado)%></td>
					</tr>
					<tr>
						<td width="20%"><strong>G&eacute;nero</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=EncodeUTF8(sexo_tdesc)%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Fecha</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=fecha1%></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
                    	<td colspan="3">
                        <table width="100%" border="0" >
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<td align="center">RUT</td>
								<td align="center">Nombre</td>
								<td align="center">Ingreso</td>
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
			</td>
		  </tr>
		  </form>
		  <tr>
            <td align="right" height="50">&nbsp;</td>
		  </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
		
                        <td><div align="center"><%url_1 = "estadisticas_egreso_titulacion_carreras.asp?sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
						                          botonera.agregaBotonParam "volver","url",url_1
												  botonera.dibujaBoton "volver"
												 %>
							</div>
						</td>
					  <td><div id="botonDoc" align="center">
						    <% 
							   url_2 = "estadisticasEgresoTitulacion/excels/estadisticas_egreso_titulacion_personas_excel.asp?femenino="&femenino&"&salidas_int="&salidas_int&"&graduados="&graduados&"&titulados="&titulados&"&egresados="&egresados&"&masculino="&masculino&"&instituto="&instituto&"&upa_postgrado="&upa_postgrado&"&upa_pregrado="&upa_pregrado&"&selectAnioPromo="&selectAnioPromo&"&selectAnioTitu="&selectAnioTitu&"&selectAnioEgre="&selectAnioEgre&"&sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
 							   botonera.agregaBotonParam "excel_2","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_2"
							%>
							</div>
						</td>							
					  <td><div id="botonDoc" align="center">
						    <% 
							   url_2 = "estadisticasEgresoTitulacion/excels/estadisticas_egreso_titulacion__detalle_personas_excel.asp?femenino="&femenino&"&salidas_int="&salidas_int&"&graduados="&graduados&"&titulados="&titulados&"&egresados="&egresados&"&masculino="&masculino&"&instituto="&instituto&"&upa_postgrado="&upa_postgrado&"&upa_pregrado="&upa_pregrado&"&selectAnioPromo="&selectAnioPromo&"&selectAnioTitu="&selectAnioTitu&"&selectAnioEgre="&selectAnioEgre&"&sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
 							   botonera.agregaBotonParam "excel_3","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_3"
							%>
							</div>
						</td>	
						
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
