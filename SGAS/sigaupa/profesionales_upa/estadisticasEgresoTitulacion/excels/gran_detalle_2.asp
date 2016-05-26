<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_personas.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 999999999
Response.Buffer = False
set conexion = new CConexion
conexion.Inicializar "upacifico"

'----------------------------------------------------------------->>>>>>>>Variables GET
sede_ccod		=  request.QueryString("sede_ccod")
upa_pregrado  	=  request.QueryString("upa_pregrado")
upa_postgrado 	=  request.QueryString("upa_postgrado")
instituto     	=  request.QueryString("instituto")
egresados  	  	=  request.QueryString("egresados")
titulados     	=  request.QueryString("titulados")
graduados     	=  request.QueryString("graduados")
salidas_int   	=  request.QueryString("salidas_int")
femenino 	  	=  request.QueryString("femenino")
masculino 	  	=  request.QueryString("masculino")
facu_ccod     	=  request.QueryString("facu_ccod")
carr_ccod     	=  request.QueryString("carr_ccod")
selectAnioPromo =  request.QueryString("selectAnioPromo")
selectAnioEgre 	=  request.QueryString("selectAnioEgre")
selectAnioTitu 	=  request.QueryString("selectAnioTitu")
contador 		= 1
num 			= Cstr(contador)
'-----------------------------------------------------------------<<<<<<<Variables

'----------------------------------------------------------------->>>>>>>>Variables SQL
v_facu_ccod 	= facu_ccod 'no cambia******	
v_carr_ccod 	= carr_ccod 'no cambia******
v_anio_promo 	= selectAnioPromo 'no cambia******
v_anio_egreso 	= selectAnioEgre 'no cambia******
v_anio_titula   = selectAnioTitu 'no cambia******
'-----------------------------------------------------------------<<<<<<<Variables SQL
'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.end()
'------------------------------------------------->>>>>Variables de compara filtro
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
'-------------------------------------------------<<<<<Variables de compara filtro

%>
<html>
<head>
<title>ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS 2</title>
<style type="text/css">
.cabecera
{
	text-align:center;
	background-color:#06F;
	color:#FFF;
	font-weight:bold;
}
</style>
</head>
<body>
<%
'*****************'
'** ENCABEZADO  **'
'*****************'--------------------------
fecha1	= conexion.consultaUno("select getDate()")
carr_tdescA 	= conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
if carr_ccod = 0 then carr_tdescA = "Todas" end if
facu_tdescA 	= conexion.consultaUno("select facu_tdesc from facultades where cast(facu_ccod as varchar)='"&facu_ccod&"'")
if facu_ccod = 0 then facu_tdescA = "Todas" end if
encabezado upa_pregrado, upa_postgrado, instituto, egresados, titulados, graduados, salidas_int, femenino, masculino, institucion 'sub para encabezado
'*****************'--------------------------
'** ENCABEZADO  **'
'*****************'
%>

<table border="1">
<%
'*******************'
'** PRIMERA fILA  **'
'*******************'--------------------------
PrimeraFila ' sub primera fila
'*******************'--------------------------
'** PRIMERA fILA  **'
'*******************'
v_sede_ccod 	= sede_ccod

'******************************'
'** 	 TROZO SELECT 1 	 **'
'******************************'--------------------------
select_1 = Cstr(selectUno(institucion, sede_tdesc, v_anio_egreso, v_anio_titula))
'******************************'--------------------------
'** 	 TROZO SELECT 1 	 **'
'******************************'
'******************************'
'** 	 TROZO SELECT 2 	 **'
'******************************'--------------------------
select_2 = Cstr(selectDos(institucion, sede_tdesc, v_anio_egreso, v_anio_titula))
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
		sexo				= f_personas.obtenerValor("sexo" ) 					
		nacimiento			= f_personas.obtenerValor("nacimiento" ) 				
		institu				= f_personas.obtenerValor("institu" ) 				
		sede				= f_personas.obtenerValor("sede" ) 					
		facultad			= f_personas.obtenerValor("facultad" )				
		carrera				= f_personas.obtenerValor("carrera" )	
		gradoAcademico		= f_personas.obtenerValor("gradoAcademico" )		
		especialidad		= f_personas.obtenerValor("especialidad" )			
		jornada				= f_personas.obtenerValor("jornada" ) 				
		egresado			= f_personas.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas.obtenerValor("pregrado" )				
		postgrado			= f_personas.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas.obtenerValor("ano_ingreso" ) 			
		email				= f_personas.obtenerValor("email" ) 					
		fono_p				= f_personas.obtenerValor("fono_p" ) 					
		celular				= f_personas.obtenerValor("celular" ) 				
		facebook			= f_personas.obtenerValor("facebook" )  				
		twitter				= f_personas.obtenerValor("twitter" )   				
		lindkedin			= f_personas.obtenerValor("lindkedin" ) 				
		pais				= f_personas.obtenerValor("pais" )                     
		region 				= f_personas.obtenerValor("region" )                  
		ciudad				= f_personas.obtenerValor("ciudad" )                   
		comuna 				= f_personas.obtenerValor("comuna" )                  
		calle  				= f_personas.obtenerValor("calle" )                  
		nro 				= f_personas.obtenerValor("nro" )                     
		depto				= f_personas.obtenerValor("depto" )                    
		condominio			= f_personas.obtenerValor("condominio" )              
		villa				= f_personas.obtenerValor("villa" )                   
		localidad			= f_personas.obtenerValor("localidad" )               
		ciudad_ext			= f_personas.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas.obtenerValor("region_ext" )              
		empresa				= f_personas.obtenerValor("empresa" )                 
		rubro				= f_personas.obtenerValor("rubro" )                   
		depto_2				= f_personas.obtenerValor("depto_2" )                 
		cargo				= f_personas.obtenerValor("cargo" )                   
		email_laboral		= f_personas.obtenerValor("email_laboral" )           
		web					= f_personas.obtenerValor("web" )                     
		usuario				= f_personas.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas.obtenerValor("recibir_info" )  
		estado_defun        = f_personas.obtenerValor("estado_defun" ) 	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		sexo				= f_personas_UEM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_UEM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_UEM.obtenerValor("institu" ) 				
		sede				= f_personas_UEM.obtenerValor("sede" ) 					
		facultad			= f_personas_UEM.obtenerValor("facultad" )				
		carrera				= f_personas_UEM.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_UEM.obtenerValor("gradoAcademico" )		
		especialidad		= f_personas_UEM.obtenerValor("especialidad" )			
		jornada				= f_personas_UEM.obtenerValor("jornada" ) 				
		egresado			= f_personas_UEM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_UEM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_UEM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_UEM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_UEM.obtenerValor("pregrado" )				
		postgrado			= f_personas_UEM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_UEM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_UEM.obtenerValor("email" ) 					
		fono_p				= f_personas_UEM.obtenerValor("fono_p" ) 					
		celular				= f_personas_UEM.obtenerValor("celular" ) 				
		facebook			= f_personas_UEM.obtenerValor("facebook" )  				
		twitter				= f_personas_UEM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_UEM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_UEM.obtenerValor("pais" )                     
		region 				= f_personas_UEM.obtenerValor("region" )                  
		ciudad				= f_personas_UEM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_UEM.obtenerValor("comuna" )                  
		calle  				= f_personas_UEM.obtenerValor("calle" )                  
		nro 				= f_personas_UEM.obtenerValor("nro" )                     
		depto				= f_personas_UEM.obtenerValor("depto" )                    
		condominio			= f_personas_UEM.obtenerValor("condominio" )              
		villa				= f_personas_UEM.obtenerValor("villa" )                   
		localidad			= f_personas_UEM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_UEM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_UEM.obtenerValor("region_ext" )              
		empresa				= f_personas_UEM.obtenerValor("empresa" )                 
		rubro				= f_personas_UEM.obtenerValor("rubro" )                   
		depto_2				= f_personas_UEM.obtenerValor("depto_2" )                 
		cargo				= f_personas_UEM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_UEM.obtenerValor("email_laboral" )           
		web					= f_personas_UEM.obtenerValor("web" )                     
		usuario				= f_personas_UEM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_UEM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_UEM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_UEM.obtenerValor("recibir_info" )  
		estado_defun        = f_personas_UEM.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		sexo				= f_personas.obtenerValor("sexo" ) 					
		nacimiento			= f_personas.obtenerValor("nacimiento" ) 				
		institu				= f_personas.obtenerValor("institu" ) 				
		sede				= f_personas.obtenerValor("sede" ) 					
		facultad			= f_personas.obtenerValor("facultad" )				
		carrera				= f_personas.obtenerValor("carrera" )	
		gradoAcademico		= f_personas.obtenerValor("gradoAcademico" )		
		especialidad		= f_personas.obtenerValor("especialidad" )			
		jornada				= f_personas.obtenerValor("jornada" ) 				
		egresado			= f_personas.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas.obtenerValor("pregrado" )				
		postgrado			= f_personas.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas.obtenerValor("ano_ingreso" ) 			
		email				= f_personas.obtenerValor("email" ) 					
		fono_p				= f_personas.obtenerValor("fono_p" ) 					
		celular				= f_personas.obtenerValor("celular" ) 				
		facebook			= f_personas.obtenerValor("facebook" )  				
		twitter				= f_personas.obtenerValor("twitter" )   				
		lindkedin			= f_personas.obtenerValor("lindkedin" ) 				
		pais				= f_personas.obtenerValor("pais" )                     
		region 				= f_personas.obtenerValor("region" )                  
		ciudad				= f_personas.obtenerValor("ciudad" )                   
		comuna 				= f_personas.obtenerValor("comuna" )                  
		calle  				= f_personas.obtenerValor("calle" )                  
		nro 				= f_personas.obtenerValor("nro" )                     
		depto				= f_personas.obtenerValor("depto" )                    
		condominio			= f_personas.obtenerValor("condominio" )              
		villa				= f_personas.obtenerValor("villa" )                   
		localidad			= f_personas.obtenerValor("localidad" )               
		ciudad_ext			= f_personas.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas.obtenerValor("region_ext" )              
		empresa				= f_personas.obtenerValor("empresa" )                 
		rubro				= f_personas.obtenerValor("rubro" )                   
		depto_2				= f_personas.obtenerValor("depto_2" )                 
		cargo				= f_personas.obtenerValor("cargo" )                   
		email_laboral		= f_personas.obtenerValor("email_laboral" )           
		web					= f_personas.obtenerValor("web" )                     
		usuario				= f_personas.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas.obtenerValor("recibir_info" ) 
		estado_defun        = f_personas.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
f_personas_UEM.Consultar consulta
nombre = ""
while f_personas_UEM.siguiente
	'-------------------->>CapturaVariablea
		rut					= f_personas_UEM.obtenerValor("rut" )						
		nombre				= f_personas_UEM.obtenerValor("nombre" )			
		sexo				= f_personas_UEM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_UEM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_UEM.obtenerValor("institu" ) 				
		sede				= f_personas_UEM.obtenerValor("sede" ) 					
		facultad			= f_personas_UEM.obtenerValor("facultad" )				
		carrera				= f_personas_UEM.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_UEM.obtenerValor("gradoAcademico" )		
		especialidad		= f_personas_UEM.obtenerValor("especialidad" )			
		jornada				= f_personas_UEM.obtenerValor("jornada" ) 				
		egresado			= f_personas_UEM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_UEM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_UEM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_UEM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_UEM.obtenerValor("pregrado" )				
		postgrado			= f_personas_UEM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_UEM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_UEM.obtenerValor("email" ) 					
		fono_p				= f_personas_UEM.obtenerValor("fono_p" ) 					
		celular				= f_personas_UEM.obtenerValor("celular" ) 				
		facebook			= f_personas_UEM.obtenerValor("facebook" )  				
		twitter				= f_personas_UEM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_UEM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_UEM.obtenerValor("pais" )                     
		region 				= f_personas_UEM.obtenerValor("region" )                  
		ciudad				= f_personas_UEM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_UEM.obtenerValor("comuna" )                  
		calle  				= f_personas_UEM.obtenerValor("calle" )                  
		nro 				= f_personas_UEM.obtenerValor("nro" )                     
		depto				= f_personas_UEM.obtenerValor("depto" )                    
		condominio			= f_personas_UEM.obtenerValor("condominio" )              
		villa				= f_personas_UEM.obtenerValor("villa" )                   
		localidad			= f_personas_UEM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_UEM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_UEM.obtenerValor("region_ext" )              
		empresa				= f_personas_UEM.obtenerValor("empresa" )                 
		rubro				= f_personas_UEM.obtenerValor("rubro" )                   
		depto_2				= f_personas_UEM.obtenerValor("depto_2" )                 
		cargo				= f_personas_UEM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_UEM.obtenerValor("email_laboral" )           
		web					= f_personas_UEM.obtenerValor("web" )                     
		usuario				= f_personas_UEM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_UEM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_UEM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_UEM.obtenerValor("recibir_info" )  
		estado_defun        = f_personas_UEM.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
				rut					= f_personas_USIEH.obtenerValor("rut" )						
				nombre				= f_personas_USIEH.obtenerValor("nombre" )			
				sexo				= f_personas_USIEH.obtenerValor("sexo" ) 					
				nacimiento			= f_personas_USIEH.obtenerValor("nacimiento" ) 				
				institu				= f_personas_USIEH.obtenerValor("institu" ) 				
				sede				= f_personas_USIEH.obtenerValor("sede" ) 					
				facultad			= f_personas_USIEH.obtenerValor("facultad" )				
				carrera				= f_personas_USIEH.obtenerValor("carrera" )	
				gradoAcademico		= f_personas_USIEH.obtenerValor("gradoAcademico" )	
				especialidad		= f_personas_USIEH.obtenerValor("especialidad" )			
				jornada				= f_personas_USIEH.obtenerValor("jornada" ) 				
				egresado			= f_personas_USIEH.obtenerValor("egresado" ) 				
				fecha_egreso		= f_personas_USIEH.obtenerValor("fecha_egreso" ) 			
				titulado			= f_personas_USIEH.obtenerValor("titulado" ) 				
				fecha_titulo		= f_personas_USIEH.obtenerValor("fecha_titulo" ) 			
				pregrado			= f_personas_USIEH.obtenerValor("pregrado" )				
				postgrado			= f_personas_USIEH.obtenerValor("postgrado" )  				
				ano_ingreso			= f_personas_USIEH.obtenerValor("ano_ingreso" ) 			
				email				= f_personas_USIEH.obtenerValor("email" ) 					
				fono_p				= f_personas_USIEH.obtenerValor("fono_p" ) 					
				celular				= f_personas_USIEH.obtenerValor("celular" ) 				
				facebook			= f_personas_USIEH.obtenerValor("facebook" )  				
				twitter				= f_personas_USIEH.obtenerValor("twitter" )   				
				lindkedin			= f_personas_USIEH.obtenerValor("lindkedin" ) 				
				pais				= f_personas_USIEH.obtenerValor("pais" )                     
				region 				= f_personas_USIEH.obtenerValor("region" )                  
				ciudad				= f_personas_USIEH.obtenerValor("ciudad" )                   
				comuna 				= f_personas_USIEH.obtenerValor("comuna" )                  
				calle  				= f_personas_USIEH.obtenerValor("calle" )                  
				nro 				= f_personas_USIEH.obtenerValor("nro" )                     
				depto				= f_personas_USIEH.obtenerValor("depto" )                    
				condominio			= f_personas_USIEH.obtenerValor("condominio" )              
				villa				= f_personas_USIEH.obtenerValor("villa" )                   
				localidad			= f_personas_USIEH.obtenerValor("localidad" )               
				ciudad_ext			= f_personas_USIEH.obtenerValor("ciudad_ext" )              
				region_ext			= f_personas_USIEH.obtenerValor("region_ext" )              
				empresa				= f_personas_USIEH.obtenerValor("empresa" )                 
				rubro				= f_personas_USIEH.obtenerValor("rubro" )                   
				depto_2				= f_personas_USIEH.obtenerValor("depto_2" )                 
				cargo				= f_personas_USIEH.obtenerValor("cargo" )                   
				email_laboral		= f_personas_USIEH.obtenerValor("email_laboral" )           
				web					= f_personas_USIEH.obtenerValor("web" )                     
				usuario				= f_personas_USIEH.obtenerValor("usuario" )                 
				fecha_modificacion	= f_personas_USIEH.obtenerValor("fecha_modificacion" ) 		
				tipo_contacto		= f_personas_USIEH.obtenerValor("tipo_contacto" )           
				recibir_info        = f_personas_USIEH.obtenerValor("recibir_info" ) 
				estado_defun        = f_personas_USIEH.obtenerValor("estado_defun" )	
				'--------------------<<CapturaVariablea
				insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_USIEM.obtenerValor("rut" )						
		nombre				= f_personas_USIEM.obtenerValor("nombre" )			
		sexo				= f_personas_USIEM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_USIEM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_USIEM.obtenerValor("institu" ) 				
		sede				= f_personas_USIEM.obtenerValor("sede" ) 					
		facultad			= f_personas_USIEM.obtenerValor("facultad" )				
		carrera				= f_personas_USIEM.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_USIEM.obtenerValor("gradoAcademico" )		
		especialidad		= f_personas_USIEM.obtenerValor("especialidad" )			
		jornada				= f_personas_USIEM.obtenerValor("jornada" ) 				
		egresado			= f_personas_USIEM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_USIEM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_USIEM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_USIEM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_USIEM.obtenerValor("pregrado" )				
		postgrado			= f_personas_USIEM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_USIEM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_USIEM.obtenerValor("email" ) 					
		fono_p				= f_personas_USIEM.obtenerValor("fono_p" ) 					
		celular				= f_personas_USIEM.obtenerValor("celular" ) 				
		facebook			= f_personas_USIEM.obtenerValor("facebook" )  				
		twitter				= f_personas_USIEM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_USIEM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_USIEM.obtenerValor("pais" )                     
		region 				= f_personas_USIEM.obtenerValor("region" )                  
		ciudad				= f_personas_USIEM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_USIEM.obtenerValor("comuna" )                  
		calle  				= f_personas_USIEM.obtenerValor("calle" )                  
		nro 				= f_personas_USIEM.obtenerValor("nro" )                     
		depto				= f_personas_USIEM.obtenerValor("depto" )                    
		condominio			= f_personas_USIEM.obtenerValor("condominio" )              
		villa				= f_personas_USIEM.obtenerValor("villa" )                   
		localidad			= f_personas_USIEM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_USIEM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_USIEM.obtenerValor("region_ext" )              
		empresa				= f_personas_USIEM.obtenerValor("empresa" )                 
		rubro				= f_personas_USIEM.obtenerValor("rubro" )                   
		depto_2				= f_personas_USIEM.obtenerValor("depto_2" )                 
		cargo				= f_personas_USIEM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_USIEM.obtenerValor("email_laboral" )           
		web					= f_personas_USIEM.obtenerValor("web" )                     
		usuario				= f_personas_USIEM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_USIEM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_USIEM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_USIEM.obtenerValor("recibir_info" )  	
		estado_defun        = f_personas_USIEM.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_UPGH.obtenerValor("rut" )						
		nombre				= f_personas_UPGH.obtenerValor("nombre" )			
		sexo				= f_personas_UPGH.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_UPGH.obtenerValor("nacimiento" ) 				
		institu				= f_personas_UPGH.obtenerValor("institu" ) 				
		sede				= f_personas_UPGH.obtenerValor("sede" ) 					
		facultad			= f_personas_UPGH.obtenerValor("facultad" )				
		carrera				= f_personas_UPGH.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_UPGH.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_UPGH.obtenerValor("especialidad" )			
		jornada				= f_personas_UPGH.obtenerValor("jornada" ) 				
		egresado			= f_personas_UPGH.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_UPGH.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_UPGH.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_UPGH.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_UPGH.obtenerValor("pregrado" )				
		postgrado			= f_personas_UPGH.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_UPGH.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_UPGH.obtenerValor("email" ) 					
		fono_p				= f_personas_UPGH.obtenerValor("fono_p" ) 					
		celular				= f_personas_UPGH.obtenerValor("celular" ) 				
		facebook			= f_personas_UPGH.obtenerValor("facebook" )  				
		twitter				= f_personas_UPGH.obtenerValor("twitter" )   				
		lindkedin			= f_personas_UPGH.obtenerValor("lindkedin" ) 				
		pais				= f_personas_UPGH.obtenerValor("pais" )                     
		region 				= f_personas_UPGH.obtenerValor("region" )                  
		ciudad				= f_personas_UPGH.obtenerValor("ciudad" )                   
		comuna 				= f_personas_UPGH.obtenerValor("comuna" )                  
		calle  				= f_personas_UPGH.obtenerValor("calle" )                  
		nro 				= f_personas_UPGH.obtenerValor("nro" )                     
		depto				= f_personas_UPGH.obtenerValor("depto" )                    
		condominio			= f_personas_UPGH.obtenerValor("condominio" )              
		villa				= f_personas_UPGH.obtenerValor("villa" )                   
		localidad			= f_personas_UPGH.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_UPGH.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_UPGH.obtenerValor("region_ext" )              
		empresa				= f_personas_UPGH.obtenerValor("empresa" )                 
		rubro				= f_personas_UPGH.obtenerValor("rubro" )                   
		depto_2				= f_personas_UPGH.obtenerValor("depto_2" )                 
		cargo				= f_personas_UPGH.obtenerValor("cargo" )                   
		email_laboral		= f_personas_UPGH.obtenerValor("email_laboral" )           
		web					= f_personas_UPGH.obtenerValor("web" )                     
		usuario				= f_personas_UPGH.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_UPGH.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_UPGH.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_UPGH.obtenerValor("recibir_info" )  
		estado_defun        = f_personas_UPGH.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_UPGM.obtenerValor("rut" )						
		nombre				= f_personas_UPGM.obtenerValor("nombre" )			
		sexo				= f_personas_UPGM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_UPGM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_UPGM.obtenerValor("institu" ) 				
		sede				= f_personas_UPGM.obtenerValor("sede" ) 					
		facultad			= f_personas_UPGM.obtenerValor("facultad" )				
		carrera				= f_personas_UPGM.obtenerValor("carrera" )			
		gradoAcademico		= f_personas_UPGM.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_UPGM.obtenerValor("especialidad" )			
		jornada				= f_personas_UPGM.obtenerValor("jornada" ) 				
		egresado			= f_personas_UPGM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_UPGM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_UPGM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_UPGM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_UPGM.obtenerValor("pregrado" )				
		postgrado			= f_personas_UPGM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_UPGM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_UPGM.obtenerValor("email" ) 					
		fono_p				= f_personas_UPGM.obtenerValor("fono_p" ) 					
		celular				= f_personas_UPGM.obtenerValor("celular" ) 				
		facebook			= f_personas_UPGM.obtenerValor("facebook" )  				
		twitter				= f_personas_UPGM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_UPGM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_UPGM.obtenerValor("pais" )                     
		region 				= f_personas_UPGM.obtenerValor("region" )                  
		ciudad				= f_personas_UPGM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_UPGM.obtenerValor("comuna" )                  
		calle  				= f_personas_UPGM.obtenerValor("calle" )                  
		nro 				= f_personas_UPGM.obtenerValor("nro" )                     
		depto				= f_personas_UPGM.obtenerValor("depto" )                    
		condominio			= f_personas_UPGM.obtenerValor("condominio" )              
		villa				= f_personas_UPGM.obtenerValor("villa" )                   
		localidad			= f_personas_UPGM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_UPGM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_UPGM.obtenerValor("region_ext" )              
		empresa				= f_personas_UPGM.obtenerValor("empresa" )                 
		rubro				= f_personas_UPGM.obtenerValor("rubro" )                   
		depto_2				= f_personas_UPGM.obtenerValor("depto_2" )                 
		cargo				= f_personas_UPGM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_UPGM.obtenerValor("email_laboral" )           
		web					= f_personas_UPGM.obtenerValor("web" )                     
		usuario				= f_personas_UPGM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_UPGM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_UPGM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_UPGM.obtenerValor("recibir_info" )  
		estado_defun        = f_personas_UPGM.obtenerValor("estado_defun" )		
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_IEH.obtenerValor("rut" )						
		nombre				= f_personas_IEH.obtenerValor("nombre" )			
		sexo				= f_personas_IEH.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_IEH.obtenerValor("nacimiento" ) 				
		institu				= f_personas_IEH.obtenerValor("institu" ) 				
		sede				= f_personas_IEH.obtenerValor("sede" ) 					
		facultad			= f_personas_IEH.obtenerValor("facultad" )				
		carrera				= f_personas_IEH.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_IEH.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_IEH.obtenerValor("especialidad" )			
		jornada				= f_personas_IEH.obtenerValor("jornada" ) 				
		egresado			= f_personas_IEH.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_IEH.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_IEH.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_IEH.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_IEH.obtenerValor("pregrado" )				
		postgrado			= f_personas_IEH.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_IEH.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_IEH.obtenerValor("email" ) 					
		fono_p				= f_personas_IEH.obtenerValor("fono_p" ) 					
		celular				= f_personas_IEH.obtenerValor("celular" ) 				
		facebook			= f_personas_IEH.obtenerValor("facebook" )  				
		twitter				= f_personas_IEH.obtenerValor("twitter" )   				
		lindkedin			= f_personas_IEH.obtenerValor("lindkedin" ) 				
		pais				= f_personas_IEH.obtenerValor("pais" )                     
		region 				= f_personas_IEH.obtenerValor("region" )                  
		ciudad				= f_personas_IEH.obtenerValor("ciudad" )                   
		comuna 				= f_personas_IEH.obtenerValor("comuna" )                  
		calle  				= f_personas_IEH.obtenerValor("calle" )                  
		nro 				= f_personas_IEH.obtenerValor("nro" )                     
		depto				= f_personas_IEH.obtenerValor("depto" )                    
		condominio			= f_personas_IEH.obtenerValor("condominio" )              
		villa				= f_personas_IEH.obtenerValor("villa" )                   
		localidad			= f_personas_IEH.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_IEH.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_IEH.obtenerValor("region_ext" )              
		empresa				= f_personas_IEH.obtenerValor("empresa" )                 
		rubro				= f_personas_IEH.obtenerValor("rubro" )                   
		depto_2				= f_personas_IEH.obtenerValor("depto_2" )                 
		cargo				= f_personas_IEH.obtenerValor("cargo" )                   
		email_laboral		= f_personas_IEH.obtenerValor("email_laboral" )           
		web					= f_personas_IEH.obtenerValor("web" )                     
		usuario				= f_personas_IEH.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_IEH.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_IEH.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_IEH.obtenerValor("recibir_info" ) 
		estado_defun        = f_personas_IEH.obtenerValor("estado_defun" )		
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_IEM.obtenerValor("rut" )						
		nombre				= f_personas_IEM.obtenerValor("nombre" )			
		sexo				= f_personas_IEM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_IEM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_IEM.obtenerValor("institu" ) 				
		sede				= f_personas_IEM.obtenerValor("sede" ) 					
		facultad			= f_personas_IEM.obtenerValor("facultad" )				
		carrera				= f_personas_IEM.obtenerValor("carrera" )
		gradoAcademico		= f_personas_IEM.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_IEM.obtenerValor("especialidad" )			
		jornada				= f_personas_IEM.obtenerValor("jornada" ) 				
		egresado			= f_personas_IEM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_IEM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_IEM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_IEM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_IEM.obtenerValor("pregrado" )				
		postgrado			= f_personas_IEM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_IEM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_IEM.obtenerValor("email" ) 					
		fono_p				= f_personas_IEM.obtenerValor("fono_p" ) 					
		celular				= f_personas_IEM.obtenerValor("celular" ) 				
		facebook			= f_personas_IEM.obtenerValor("facebook" )  				
		twitter				= f_personas_IEM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_IEM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_IEM.obtenerValor("pais" )                     
		region 				= f_personas_IEM.obtenerValor("region" )                  
		ciudad				= f_personas_IEM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_IEM.obtenerValor("comuna" )                  
		calle  				= f_personas_IEM.obtenerValor("calle" )                  
		nro 				= f_personas_IEM.obtenerValor("nro" )                     
		depto				= f_personas_IEM.obtenerValor("depto" )                    
		condominio			= f_personas_IEM.obtenerValor("condominio" )              
		villa				= f_personas_IEM.obtenerValor("villa" )                   
		localidad			= f_personas_IEM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_IEM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_IEM.obtenerValor("region_ext" )              
		empresa				= f_personas_IEM.obtenerValor("empresa" )                 
		rubro				= f_personas_IEM.obtenerValor("rubro" )                   
		depto_2				= f_personas_IEM.obtenerValor("depto_2" )                 
		cargo				= f_personas_IEM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_IEM.obtenerValor("email_laboral" )           
		web					= f_personas_IEM.obtenerValor("web" )                     
		usuario				= f_personas_IEM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_IEM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_IEM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_IEM.obtenerValor("recibir_info" ) 
		estado_defun        = f_personas_IEM.obtenerValor("estado_defun" )		
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_ITH.obtenerValor("rut" )						
		nombre				= f_personas_ITH.obtenerValor("nombre" )			
		sexo				= f_personas_ITH.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_ITH.obtenerValor("nacimiento" ) 				
		institu				= f_personas_ITH.obtenerValor("institu" ) 				
		sede				= f_personas_ITH.obtenerValor("sede" ) 					
		facultad			= f_personas_ITH.obtenerValor("facultad" )				
		carrera				= f_personas_ITH.obtenerValor("carrera" )	
		gradoAcademico		= f_personas_ITH.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_ITH.obtenerValor("especialidad" )			
		jornada				= f_personas_ITH.obtenerValor("jornada" ) 				
		egresado			= f_personas_ITH.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_ITH.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_ITH.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_ITH.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_ITH.obtenerValor("pregrado" )				
		postgrado			= f_personas_ITH.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_ITH.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_ITH.obtenerValor("email" ) 					
		fono_p				= f_personas_ITH.obtenerValor("fono_p" ) 					
		celular				= f_personas_ITH.obtenerValor("celular" ) 				
		facebook			= f_personas_ITH.obtenerValor("facebook" )  				
		twitter				= f_personas_ITH.obtenerValor("twitter" )   				
		lindkedin			= f_personas_ITH.obtenerValor("lindkedin" ) 				
		pais				= f_personas_ITH.obtenerValor("pais" )                     
		region 				= f_personas_ITH.obtenerValor("region" )                  
		ciudad				= f_personas_ITH.obtenerValor("ciudad" )                   
		comuna 				= f_personas_ITH.obtenerValor("comuna" )                  
		calle  				= f_personas_ITH.obtenerValor("calle" )                  
		nro 				= f_personas_ITH.obtenerValor("nro" )                     
		depto				= f_personas_ITH.obtenerValor("depto" )                    
		condominio			= f_personas_ITH.obtenerValor("condominio" )              
		villa				= f_personas_ITH.obtenerValor("villa" )                   
		localidad			= f_personas_ITH.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_ITH.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_ITH.obtenerValor("region_ext" )              
		empresa				= f_personas_ITH.obtenerValor("empresa" )                 
		rubro				= f_personas_ITH.obtenerValor("rubro" )                   
		depto_2				= f_personas_ITH.obtenerValor("depto_2" )                 
		cargo				= f_personas_ITH.obtenerValor("cargo" )                   
		email_laboral		= f_personas_ITH.obtenerValor("email_laboral" )           
		web					= f_personas_ITH.obtenerValor("web" )                     
		usuario				= f_personas_ITH.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_ITH.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_ITH.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_ITH.obtenerValor("recibir_info" )  
		estado_defun        = f_personas_ITH.obtenerValor("estado_defun" )		
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
		rut					= f_personas_ITM.obtenerValor("rut" )						
		nombre				= f_personas_ITM.obtenerValor("nombre" )			
		sexo				= f_personas_ITM.obtenerValor("sexo" ) 					
		nacimiento			= f_personas_ITM.obtenerValor("nacimiento" ) 				
		institu				= f_personas_ITM.obtenerValor("institu" ) 				
		sede				= f_personas_ITM.obtenerValor("sede" ) 					
		facultad			= f_personas_ITM.obtenerValor("facultad" )				
		carrera				= f_personas_ITM.obtenerValor("carrera" )
		gradoAcademico		= f_personas_ITM.obtenerValor("gradoAcademico" )	
		especialidad		= f_personas_ITM.obtenerValor("especialidad" )			
		jornada				= f_personas_ITM.obtenerValor("jornada" ) 				
		egresado			= f_personas_ITM.obtenerValor("egresado" ) 				
		fecha_egreso		= f_personas_ITM.obtenerValor("fecha_egreso" ) 			
		titulado			= f_personas_ITM.obtenerValor("titulado" ) 				
		fecha_titulo		= f_personas_ITM.obtenerValor("fecha_titulo" ) 			
		pregrado			= f_personas_ITM.obtenerValor("pregrado" )				
		postgrado			= f_personas_ITM.obtenerValor("postgrado" )  				
		ano_ingreso			= f_personas_ITM.obtenerValor("ano_ingreso" ) 			
		email				= f_personas_ITM.obtenerValor("email" ) 					
		fono_p				= f_personas_ITM.obtenerValor("fono_p" ) 					
		celular				= f_personas_ITM.obtenerValor("celular" ) 				
		facebook			= f_personas_ITM.obtenerValor("facebook" )  				
		twitter				= f_personas_ITM.obtenerValor("twitter" )   				
		lindkedin			= f_personas_ITM.obtenerValor("lindkedin" ) 				
		pais				= f_personas_ITM.obtenerValor("pais" )                     
		region 				= f_personas_ITM.obtenerValor("region" )                  
		ciudad				= f_personas_ITM.obtenerValor("ciudad" )                   
		comuna 				= f_personas_ITM.obtenerValor("comuna" )                  
		calle  				= f_personas_ITM.obtenerValor("calle" )                  
		nro 				= f_personas_ITM.obtenerValor("nro" )                     
		depto				= f_personas_ITM.obtenerValor("depto" )                    
		condominio			= f_personas_ITM.obtenerValor("condominio" )              
		villa				= f_personas_ITM.obtenerValor("villa" )                   
		localidad			= f_personas_ITM.obtenerValor("localidad" )               
		ciudad_ext			= f_personas_ITM.obtenerValor("ciudad_ext" )              
		region_ext			= f_personas_ITM.obtenerValor("region_ext" )              
		empresa				= f_personas_ITM.obtenerValor("empresa" )                 
		rubro				= f_personas_ITM.obtenerValor("rubro" )                   
		depto_2				= f_personas_ITM.obtenerValor("depto_2" )                 
		cargo				= f_personas_ITM.obtenerValor("cargo" )                   
		email_laboral		= f_personas_ITM.obtenerValor("email_laboral" )           
		web					= f_personas_ITM.obtenerValor("web" )                     
		usuario				= f_personas_ITM.obtenerValor("usuario" )                 
		fecha_modificacion	= f_personas_ITM.obtenerValor("fecha_modificacion" ) 		
		tipo_contacto		= f_personas_ITM.obtenerValor("tipo_contacto" )           
		recibir_info        = f_personas_ITM.obtenerValor("recibir_info" ) 
		estado_defun        = f_personas_ITM.obtenerValor("estado_defun" )	
	'--------------------<<CapturaVariablea
	insertarCampo num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,estado_defun
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
</body>
</html>