<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'**************************************************'
'**		CAPTURA DE LAS VARIABLES DE BÚSQUEDA	 **'
'**************************************************'------------------------
'-----------------------------------------------------------------------
upa_pregrado  =  request.QueryString("upa_pregrado")
upa_postgrado =  request.QueryString("upa_postgrado")
instituto     =  request.QueryString("instituto")

egresados  	  =  request.QueryString("egresados")
titulados     =  request.QueryString("titulados")
graduados     =  request.QueryString("graduados")
salidas_int   =  request.QueryString("salidas_int")

femenino      =  request.QueryString("femenino")
masculino     =  request.QueryString("masculino")

facu_ccod     =  request.QueryString("facu_ccod")
carr_ccod     =  request.QueryString("carr_ccod")

selectAnioPromo =  request.QueryString("selectAnioPromo")
selectAnioEgre 	=  request.QueryString("selectAnioEgre")
selectAnioTitu 	=  request.QueryString("selectAnioTitu")
'-----------------------------------------------------------------------<<<<<<<<<<<<<<<<<
if(upa_pregrado <> "") then upa_pregrado = upa_pregrado	else upa_pregrado = "0" end if
if(upa_postgrado <> "") then upa_postgrado = upa_postgrado	else upa_postgrado = "0" end if
if(instituto 	<> "") then instituto = instituto	else instituto = "0" end if
if(egresados 	<> "") then egresados   = egresados   	else egresados   = "0" end if
if(titulados 	<> "") then titulados 	= titulados 	else titulados   = "0" end if
if(graduados 	<> "") then graduados 	= graduados 	else graduados   = "0" end if 
if(salidas_int 	<> "") then salidas_int = salidas_int	else salidas_int = "0" end if
if(femenino  	<> "") then femenino 	= femenino 		else femenino 	 = "0" end if
if(masculino	<> "") then masculino 	= masculino 	else masculino 	 = "0" end if
if(facu_ccod 	<> "") then facu_ccod 	= facu_ccod 	else facu_ccod 	 = "0" end if
if(carr_ccod 	<> "") then carr_ccod 	= carr_ccod 	else carr_ccod 	 = "0" end if
'-----------------------------------------------------------------------<<<<<<<<<<<<<<<<<

fecha_modificacion =  request.QueryString("fecha_modificacion")

consultaFecha = "select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha"
fecha_a_mostrar=conexion.consultaUno(consultaFecha)

'------------------------------------------------------------------------------------
'for each k in request.QueryString
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'---------------------------------------------------------------------->>>>>>>>>>>>DEBUG
'Response.write("upa_pregrado="&upa_pregrado&"<br/>")
'Response.write("upa_postgrado="&upa_postgrado&"<br/>")
'Response.write("instituto="&instituto&"<br/>")
'Response.write("egresados="&egresados&"<br/>")
'Response.write("titulados="&titulados&"<br/>")
'Response.write("graduados="&graduados&"<br/>")
'Response.write("salidas_int="&salidas_int&"<br/>")
'Response.write("femenino="&femenino&"<br/>")
'Response.write("masculino="&masculino&"<br/>")
'Response.write("facu_ccod="&masculino&"<br/>")
'Response.write("masculino="&masculino&"<br/>")
'---------------------------------------------------------------------->>>>>>>>>>>>DEBUG
'carr_ccod     =  request.Form("selectCarrera")
'Response.write("carr_ccod="&carr_ccod&"<br/>")
'Response.write("facu_ccod="&facu_ccod&"<br/>")
'**************************************************'------------------------
'**		CAPTURA DE LAS VARIABLES DE BÚSQUEDA	 **'
'**************************************************'
'*****************************************************************************************************************'
'**																												**'
'**								INICIO DEL CÓDIGO DE LA LÓGICA DEL SISTEMA										**'
'**																												**'
'*****************************************************************************************************************'
'**************************************'
'**		INICIALIZANDO VARIABLES		 **'
'**************************************'------------------------
	if facu_ccod = "" then
		facu_ccod = 0
	end if
	if carr_ccod = "" then
		carr_ccod = "0"
	end if
	
	check_pregrado  = ""
	check_postgrado = ""
	check_instituto = ""
	
	check_egresados  = ""
	check_titulados  = ""
	check_graduados  = ""
	check_salidas_int= ""
	
	check_femenino  = ""
	check_masculino = ""
'**************************************'------------------------
'**		INICIALIZANDO VARIABLES		 **'
'**************************************'

'**************************'
'**		BOTONERA 		 **'
'**************************'------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

'**************************'------------------------
'**		BOTONERA 		 **'
'**************************'
'*********************************************************'
'**														**'
'**				CONSULTA PARA LOS TOTALES				**'
'**														**'
'*********************************************************'-------------------------
set f_lista_2 = new CFormulario
f_lista_2.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista_2.Inicializar conexion
'-------------------------------------------------------->>>>>>>>>>Primera parte
consulta = "select ''"
'******************************'
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'--------------------------
if upa_pregrado = "1" then
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>EGRESADOS
	if egresados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(egresados_u_hombres) as suma_egresados_u_hombres "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(egresados_u_mujeres) as suma_egresados_u_mujeres "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<EGRESADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>TITULADOS
	if titulados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(titulados_u_hombres) as suma_titulados_u_hombres "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(titulados_u_mujeres) as suma_titulados_u_mujeres "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<TITULADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>GRADUADOS
	if graduados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(graduados_pr_hombres) as suma_graduados_pr_hombres "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(graduados_pr_mujeres) as suma_graduados_pr_mujeres "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<GRADUADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>SALIDAS
	if salidas_int = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(sie_hombres) as suma_sie_hombres "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(sie_mujeres) as suma_sie_mujeres "
		end if
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(sit_hombres) as suma_sit_hombres "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",sum(sit_mujeres) as suma_sit_mujeres "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<SALIDAS
end if
'******************************'--------------------------
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'
'*******************************'
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'--------------------------	
			if instituto = "1" then
				if egresados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(egresados_i_hombres) as suma_egresados_i_hombres "						
					end if'if masculino = "1" then
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(egresados_i_mujeres) as suma_egresados_i_mujeres "
					end if'if femenino = "1" then
				end if'if egresados = "1" then
				if titulados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(titulados_i_hombres) as suma_titulados_i_hombres "
					end if'if masculino = "1" then
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(titulados_i_mujeres) as suma_titulados_i_mujeres "
					end if'if femenino = "1" then
				end if'if titulados = "1" then
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'	
'*******************************'
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'--------------------------						
			if upa_postgrado = "1" then
				if graduados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(graduados_po_hombres) as suma_graduados_po_hombres "
					end if
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",sum(graduados_po_mujeres) as suma_graduados_po_mujeres "
					end if
				end if	
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'	
'--------------------------------------------------------<<<<<<<<<<Primera parte
consulta = consulta & ""& vbCrLf &_
						"from ( select a.sede_ccod as dummy_2"
'-------------------------------------------------------->>>>>>>>>>Segunda parte						
'******************************'
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'--------------------------
if upa_pregrado = "1" then
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>EGRESADOS
	if egresados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','UEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_hombres  "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','UEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<EGRESADOS
	
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>TITULADOS
	if titulados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','UTI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_hombres  "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','UTI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_mujeres   "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<TITULADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>GRADUADOS
	if graduados = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','PRG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_hombres  "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','PRG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<GRADUADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>SALIDAS
	if salidas_int = "1" then
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','SIE',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_hombres  "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','SIE',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_mujeres  "
		end if
		if masculino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','SIT',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_hombres  "
		end if
		if femenino = "1" then
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','SIT',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<SALIDAS
end if
'******************************'--------------------------
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'

'*******************************'
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'--------------------------	
			if instituto = "1" then
				if egresados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,1,'I','IEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_hombres  "						
					end if'if masculino = "1" then
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,2,'I','IEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_mujeres  "
					end if'if femenino = "1" then
				end if'if egresados = "1" then
				if titulados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,1,'I','ITI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_hombres  "
					end if'if masculino = "1" then
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,2,'I','ITI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_mujeres  "
					end if'if femenino = "1" then
				end if'if titulados = "1" then
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'

'*******************************'
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'--------------------------						
			if upa_postgrado = "1" then
				if graduados = "1" then
					if masculino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','POG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_hombres "
					end if
					if femenino = "1" then
						consulta = consulta & ""& vbCrLf &_
						",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','POG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_mujeres "
					end if
				end if	
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'
consulta = consulta & ""& vbCrLf &_
					"	from sedes a  "	& vbCrLf &_
					"	) as tabla "
'--------------------------------------------------------<<<<<<<<<Segunda parte	
'-------------------------------------------------DEBUG
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
'-------------------------------------------------DEBUG
f_lista_2.Consultar consulta 
f_lista_2.Siguiente
'-------------------------------------------------------->>>>>>>>>Tercera parte (Captura de variables)						
'******************************'
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'--------------------------
if upa_pregrado = "1" then
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>EGRESADOS
	if egresados = "1" then
		if masculino = "1" then
			suma_egresados_u_hombres = f_lista_2.obtenerValor("suma_egresados_u_hombres")
		end if
		if femenino = "1" then
			suma_egresados_u_mujeres = f_lista_2.obtenerValor("suma_egresados_u_mujeres")
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<EGRESADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>TITULADOS
	if titulados = "1" then
		if masculino = "1" then
			suma_titulados_u_hombres = f_lista_2.obtenerValor("suma_titulados_u_hombres")
		end if
		if femenino = "1" then
			suma_titulados_u_mujeres = f_lista_2.obtenerValor("suma_titulados_u_mujeres") 
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<TITULADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>GRADUADOS
	if graduados = "1" then
		if masculino = "1" then
			suma_graduados_pr_hombres = f_lista_2.obtenerValor("suma_graduados_pr_hombres")
		end if
		if femenino = "1" then
			suma_graduados_pr_mujeres = f_lista_2.obtenerValor("suma_graduados_pr_mujeres")
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<GRADUADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>SALIDAS
	if salidas_int = "1" then
		if masculino = "1" then
			suma_sie_hombres = f_lista_2.obtenerValor("suma_sie_hombres")
		end if
		if femenino = "1" then
			suma_sie_mujeres = f_lista_2.obtenerValor("suma_sie_mujeres")
		end if
		if masculino = "1" then
			suma_sit_hombres = f_lista_2.obtenerValor("suma_sit_hombres")
		end if
		if femenino = "1" then
			suma_sit_mujeres = f_lista_2.obtenerValor("suma_sit_mujeres") 
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<SALIDAS
end if
'******************************'--------------------------
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'
	
'*******************************'
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'--------------------------	
			if instituto = "1" then
				if egresados = "1" then
					if masculino = "1" then
						suma_egresados_i_hombres = f_lista_2.obtenerValor("suma_egresados_i_hombres")					
					end if'if masculino = "1" then
					if femenino = "1" then
						suma_egresados_i_mujeres = f_lista_2.obtenerValor("suma_egresados_i_mujeres")
					end if'if femenino = "1" then
				end if'if egresados = "1" then
				if titulados = "1" then
					if masculino = "1" then
						suma_titulados_i_hombres = f_lista_2.obtenerValor("suma_titulados_i_hombres") 
					end if'if masculino = "1" then
					if femenino = "1" then
						suma_titulados_i_mujeres = f_lista_2.obtenerValor("suma_titulados_i_mujeres") 
					end if'if femenino = "1" then
				end if'if titulados = "1" then
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'	
'*******************************'
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'--------------------------						
			if upa_postgrado = "1" then
				if graduados = "1" then
					if masculino = "1" then
						suma_graduados_po_hombres = f_lista_2.obtenerValor("suma_graduados_po_hombres")
					end if
					if femenino = "1" then
						suma_graduados_po_mujeres = f_lista_2.obtenerValor("suma_graduados_po_mujeres") 
					end if
				end if	
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'
'--------------------------------------------------------<<<<<<<<<Tercera parte (Captura de variables)
'*********************************************************'-------------------------
'**														**'
'**				CONSULTA PARA LOS TOTALES				**'
'**														**'
'*********************************************************'




'*********************************************************'
'**														**'
'**		CONSTRUCCIÓN DE LA CONSULTA QUE LLENA LA TABLA	**'
'**														**'
'*********************************************************'-------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
consulta =  "select a.sede_ccod, " & vbCrLf & _
			"a.sede_tdesc as sede " 
'******************************'
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'--------------------------
if upa_pregrado = "1" then
	check_pregrado  = "checked"
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>EGRESADOS
	if egresados = "1" then
	    check_egresados  = "checked"
		if masculino = "1" then
		    check_masculino = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','UEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_hombres  "
		end if
		if femenino = "1" then
		    check_femenino  = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','UEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<EGRESADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>TITULADOS
	if titulados = "1" then
	    check_titulados  = "checked"
		if masculino = "1" then
		    check_masculino = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','UTI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_hombres  "
		end if
		if femenino = "1" then
		    check_femenino  = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','UTI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_mujeres   "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<TITULADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>GRADUADOS
	if graduados = "1" then
	    check_graduados  = "checked"
		if masculino = "1" then
		    check_masculino = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','PRG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_hombres  "
		end if
		if femenino = "1" then
		    check_femenino  = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','PRG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<GRADUADOS
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*>>SALIDAS
	if salidas_int = "1" then
	    check_salidas_int  = "checked"
		if masculino = "1" then
		    check_masculino = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','SIE',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_hombres  "
		end if
		if femenino = "1" then
		    check_femenino  = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','SIE',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_mujeres  "
		end if
		if masculino = "1" then
		    check_masculino = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','SIT',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_hombres  "
		end if
		if femenino = "1" then
		    check_femenino  = "checked"
			consulta = consulta & ""& vbCrLf &_
			",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','SIT',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_mujeres  "
		end if
	end if
	'*-*-*-*-*-*-*-*-*-**-*-*-*-*-*<<SALIDAS
end if'if upa_pregrado = "1" then
'******************************'--------------------------
'** SI SE MARCÓ UPA PREGRADO **'
'******************************'		
'*******************************'
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'--------------------------	
			if instituto = "1" then
				check_instituto  = "checked"
				if egresados = "1" then
				    check_egresados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,1,'I','IEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_hombres  "						
					end if'if masculino = "1" then
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,2,'I','IEG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_mujeres  "
					end if'if femenino = "1" then
				end if'if egresados = "1" then
				if titulados = "1" then
				    check_titulados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,1,'I','ITI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_hombres  "
					end if'if masculino = "1" then
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ""& vbCrLf &_
						",isnull(protic.estadistica_titulados_v2013(a.sede_ccod,2,'I','ITI',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_mujeres  "
					end if'if femenino = "1" then
				end if'if titulados = "1" then
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA INSTITUTO **'
'*******************************'

'*******************************'
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'--------------------------						
			if upa_postgrado = "1" then
				check_postgrado  = "checked"
				if graduados = "1" then
				    check_graduados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ""& vbCrLf &_
						",protic.estadistica_titulados_v2013(a.sede_ccod,1,'U','POG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_hombres "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ""& vbCrLf &_
						",protic.estadistica_titulados_v2013(a.sede_ccod,2,'U','POG',"&facu_ccod&",'"&carr_ccod&"','"&selectAnioPromo &"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_mujeres "
					end if
				end if	
			end if
'*******************************'--------------------------			
'** SI SE MARCÓ UPA POSTGRADO **'
'*******************************'	
			consulta = consulta & ""& vbCrLf &_
								  "	from sedes a  "& vbCrLf &_
								  " order by sede_tdesc asc "

'consulta = " select * from sexos"
'-------------------------------------------------DEBUG
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
'-------------------------------------------------DEBUG
f_lista.Consultar consulta 
'*********************************************************'-------------------------
'**														**'
'**		CONSTRUCCIÓN DE LA CONSULTA QUE LLENA LA TABLA	**'
'**														**'
'*********************************************************'
%>

<html>
<head>
<title>egreso y titulacion excel</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
	
div#tResutados1{
	width:100%;
	alignment-adjust:auto;
}
div#contieneCarga{
	width:100%;
	height:40px;
	text-align:center;
}
div#contieneCarga#cargando{
	width:300px;
	height:40px;
	text-align:center;
	background:url(../img/ajax-loader.gif) no-repeat;	
	background-position: center;
}
div#titulo{
	color:#666;
}
td.nombre
{
	padding-left:30px;
}
td.total_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}
th.total_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}
td.porcent_1
{
	color:#000;
	text-align:center;
	font-weight:bold; 
}
th.porcent_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}

td.porcent_2
{
	color:#000;
	text-align:center;
	font-weight:bold; 
	background-color:#BCC0E0;
}
</style>
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div>
<%	fecha1	= conexion.consultaUno("select getDate()")	%>
<div id="fecha">
	<table>
		<tr>
			<td style="border-bottom:solid; border-bottom-color:#666;" width="77%" align="left"><strong><%response.Write("Fecha y hora: "&fecha1)%></strong></td>
		</tr>
	</table>
</div>  
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p>
<tr>
		  	<td align="center">
				<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
				<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
<%
'*************************************'
'**			NOMBRE INSTITUCION		**'
'*****************************************'
totalPG 	= 0
totalPOG 	= 0
totalI 		= 0
if Femenino = "1" and Masculino = "1" then 
'------------------------------
	if egresados  = "1" then
		totalPG = totalPG + 1
		totalI = totalI + 1
	end if
	if titulados = "1" then
		totalPG = totalPG + 1
		totalI = totalI + 1
	end if
	if graduados = "1" then
		totalPG = totalPG + 1
		totalPOG = totalPOG + 1
	end if
	if salidas_int = "1" then
		totalPG = totalPG + 2
	end if
	
	if Masculino = "1" and Femenino = "1" then
		totalPG 	= totalPG*4 
		totalPOG 	= totalPOG*4 
		totalI 		= totalI*4 
	end if
'------------------------------
else
'------------------------------si es un solo sexo
	if egresados  = "1" then
		totalPG = totalPG + 2
		totalI = totalI + 2
	end if
	if titulados = "1" then
		totalPG = totalPG + 2
		totalI = totalI + 2
	end if
	if graduados = "1" then
		totalPG = totalPG + 2
		totalPOG = totalPOG + 2
	end if
	if salidas_int = "1" then
		totalPG = totalPG + 4
	end if
'------------------------------
end if

%>					
					<%if upa_pregrado = "1" then%>
						<th colspan="<%=totalPG%>"><font color='#333333'>Universidad Pregrado</font></th>
					<%end if%>
					<%if upa_postgrado = "1" and graduados = "1"then%>
						<th colspan="<%=totalPOG%>"><font color='#333333'>Universidad Postgrado</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th colspan="<%=totalI%>"><font color='#333333'>Instituto</font></th>
					<%end if%>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>Sede</font></th>
<%
'****************************************'
'**			NOMBRE INSTITUCION		**'
'*************************************'
%>						
<%
'*********************'
'**		ESTADOS		**'
'************************'
anchoT = 0
if Masculino = "1" then
	anchoT = anchoT + 2
end if 
if Femenino = "1" then
	anchoT = anchoT + 2
end if 
if Femenino = "1" and Masculino = "1" then
	'anchoT = anchoT + 2
end if 
%>	
<%
	'* SECCION PREGRADO *'
%>				
					<%if upa_pregrado = "1" then%>
						<%if egresados = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>Egresados</font></th>
						<%end if%>	
						<%if titulados = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>Titulados</font></th>
						<%end if%>		
						<%if graduados = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>Grados</font></th>
						<%end if%>		
						<%if salidas_int  = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>S.I.E</font></th>
						<%end if%>		
						<%if salidas_int  = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>S.I.T</font></th>
						<%end if%>		
					<%end if%>
<%
	'* SECCION PREGRADO *'
%>	
<%
	'* SECCION POST GRADO>> *'
%>					
				
					<%if upa_postgrado = "1" and graduados = "1" then%>
						<th colspan="<%=anchoT%>"><font color='#333333'>Grados</font></th>
					<%end if%>
<%
	'* SECCION POST GRADO<< *'
%>	
<%
	'* SECCION INSTITUTO>> *'
%>
					
					<%if instituto = "1" then%>
						<%if egresados = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>Egresados</font></th>
						<%end if%>	
						<%if titulados = "1" then%>
							<th colspan="<%=anchoT%>"><font color='#333333'>Titulados</font></th>
						<%end if%>
					<%end if%>					
<%
	'* SECCION INSTITUTO<< *'
%>					
<%
'************************'
'**		ESTADOS		**'
'*********************'
%>						
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
<%
'*********************'
'**		SEXOS		**'
'************************'
%>					
					<%if upa_pregrado = "1" then%>
						<%if egresados = "1" then%>
							<%if Masculino = "1" then%>
								<th><font color='#333333'>H</font></th>
							<%end if%>	
							<%if Femenino = "1" then%>	
								<th><font color='#333333'>M</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>								
						<%end if%>	
						<%if titulados = "1" then%>
							<%if Masculino = "1" then%>	
								<th><font color='#333333'>H</font></th>
							<%end if%>
							<%if Femenino = "1" then%>	
								<th><font color='#333333'>M</font></th>
							<%end if%>
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
						<%end if%>	
						<%if graduados = "1" then%>
							<%if Masculino = "1" then%>	
								<th><font color='#333333'>H</font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'>M</font></th>
							<%end if%>	
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
						<%end if%>	
						<%if salidas_int = "1" then%>
							<%if Masculino = "1" then%>	
								<th><font color='#333333'>H</font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'>M</font></th>
							<%end if%>
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
							<%if Masculino = "1" then%>		
								<th><font color='#333333'>H</font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'>M</font></th>
							<%end if%>	
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
						<%end if%>	
					<%end if%>
					
					<%if upa_postgrado = "1" and graduados = "1" then%>
						<%if Masculino = "1" then%>	
							<th><font color='#333333'>H</font></th>
						<%end if%>	
						<%if Femenino = "1" then%>		
							<th><font color='#333333'>M</font></th>
						<%end if%>
                         <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>	
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
					<%end if%>
					
					<%if instituto = "1" then%>
						<%if egresados = "1" then%>	
							<%if Masculino = "1" then%>	
								<th><font color='#333333'>H</font></th>
							<%end if%>								
							<%if Femenino = "1" then%>		
								<th><font color='#333333'>M</font></th>
							<%end if%>	
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
                                <th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
						<%end if%>	
						<%if titulados = "1" then%>		
							<%if Masculino = "1" then%>		
								<th><font color='#333333'>H</font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'>M</font></th>
							<%end if%>	
                             <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
								<th class="total_1" >T</th>
								<th class="porcent_1" >%</th>
							<%end if%>
                           <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<th align='CENTER'><font color='#333333'>%</font></th>
							<%end if%>															
						<%end if%>	
					<%end if%>
<%
'************************'
'**		SEXOS		**'
'*********************'
%>						
				</tr>
				<%  	
'*************************************************'
'**			 CONSTRUCCION DE LA TABLA			**'
'*************************************************'-----------------------
				
					TEUH = 0 'total/egresados/universidad pre-grado/hombre
					TEUM = 0 'total/egresados/universidad pre-grado/mujer
					TEIH = 0 'total/egresados/instituto/hombre
					TEIM = 0 'total/egresados/instituto/mujer					
					TTUH = 0 'total/titulados/universidad pre-grado/hombre
					TTUM = 0 'total/titulados/universidad pre-grado/mujer
					TTIH = 0 'total/titulados/instituto/hombre
					TTIM = 0 'total/titulados/instituto/mujer					
					TGPH = 0 'total/grados/universidad pre-grado/hombre
					TGPM = 0 'total/grados/universidad pre-grado/mujer
					TGGH = 0 'total/grados/universidad_post_grado/hombre
					TGGM = 0 'total/grados/universidad_post_grado/mujer					
					TESH = 0 'total/s.i.e/universidad_pre_grado/hombre
					TESM = 0 'total/s.i.e/universidad_pre_grado/mujer
					TTSH = 0 'total/s.i.t/universidad_pre_grado/hombre
					TTSM = 0 'total/s.i.t/universidad_pre_grado/mujer



				  while f_lista.siguiente
				    sede_ccod = f_lista.obtenerValor("sede_ccod")
					sede      = f_lista.obtenerValor("sede")
					if upa_pregrado = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EUH       = f_lista.obtenerValor("egresados_U_hombres")
								TEUH = TEUH + cint(EUH)
							end if
							if femenino = "1" then
								EUM       = f_lista.obtenerValor("egresados_U_mujeres")
								TEUM = TEUM + cint(EUM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TUH       = f_lista.obtenerValor("titulados_U_hombres")
								TTUH = TTUH + cint(TUH)
							end if
							if femenino = "1" then
								TUM       = f_lista.obtenerValor("titulados_U_mujeres")
								TTUM = TTUM + cint(TUM) 
							end if
						end if
						if graduados = "1" then
						    if masculino = "1" then
								GPH       = f_lista.obtenerValor("graduados_PR_hombres")
								TGPH = TGPH + cint(GPH)
							end if
							if femenino = "1" then
								GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
								TGPM = TGPM + cint(GPM)
							end if
						end if
						if salidas_int = "1" then
						    if masculino = "1" then	
								ESH       = f_lista.obtenerValor("SIE_hombres")
								TESH = TESH + cint(ESH)
							end if
							if femenino = "1" then
								ESM       = f_lista.obtenerValor("SIE_mujeres")
								TESM = TESM + cint(ESM)
							end if
							if masculino = "1" then
								TSH       = f_lista.obtenerValor("SIT_hombres")
								TTSH = TTSH + cint(TSH)
							end if
							if femenino = "1" then
								TSM       = f_lista.obtenerValor("SIT_mujeres")
								TTSM = TTSM + cint(TSM)



							end if
						end if
					end if
					if instituto = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EIH       = f_lista.obtenerValor("egresados_I_hombres")
								TEIH = TEIH + cint(EIH)
							end if
							if femenino = "1" then
								EIM       = f_lista.obtenerValor("egresados_I_mujeres")
								TEIM = TEIM + cint(EIM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TIH       = f_lista.obtenerValor("titulados_I_hombres")
								TTIH = TTIH + cint(TIH)
							end if
							if femenino = "1" then
								TIM       = f_lista.obtenerValor("titulados_I_mujeres")
								TTIM = TTIM + cint(TIM)
							end if
						end if
					end if
					if upa_postgrado = "1" then
					    if graduados = "1" then
						    if masculino = "1" then
								GGH       = f_lista.obtenerValor("graduados_PO_hombres")
								TGGH = TGGH + cint(GGH)
							end if
							if femenino = "1" then
								GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
								TGGM = TGGM + cint(GGM)
							end if
						end if
					end if					
%>
				<tr bgcolor="#FFFFFF">
					<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=sede%></td>
<%
'*********************************'
'**		VALORES DE LA TABLA 	**'
'************************************'
'response.Write("estadisticasEgresoTitulacion/vistas/resultado_2.asp?sede_ccod="&sede_ccod&"&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod)
%>
<%
'upa_pregrado>>
%>
	
	<%if upa_pregrado = "1" then%>
		<%if egresados = "1" then%>
			<%if Masculino = "1" then%>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
				<td class="total_1" ><%=suma(EUH,EUM)%></td>
				<td class="porcent_1" ><%=persent( suma(EUH,EUM),suma(suma_egresados_u_hombres,suma_egresados_u_mujeres) )%></td>
			<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(EUH,suma_egresados_u_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(EUM,suma_egresados_u_mujeres)%></td>
							<%end if%>	                  			
		<%end if%>	
		<%if titulados = "1" then%>
			<%if Masculino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUH%></td>
			<%end if%>		
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUM%></td>
			<%end if%>	
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
				<td class="total_1" ><%=suma(TUH,TUM)%></td>
				<td class="porcent_1" ><%=persent( suma(TUH,TUM),suma(suma_titulados_u_hombres,suma_titulados_u_mujeres) )%></td>
			<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(TUH,suma_titulados_u_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(TUM,suma_titulados_u_mujeres)%></td>
							<%end if%>			
		<%end if%>	
		<%if graduados = "1" then%>
			<%if Masculino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
				<td class="total_1"><%=suma(GPH,GPM)%></td>
				<td class="porcent_1" ><%=persent( suma(GPH,GPM),suma(suma_graduados_pr_hombres,suma_graduados_pr_mujeres) )%></td>
			<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(GPH,suma_graduados_pr_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(GPM,suma_graduados_pr_mujeres)%></td>
							<%end if%>			
		<%end if%>	
		<%if salidas_int = "1" then%>
			<%if Masculino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESM%></td>
			<%end if%>	
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
				<td class="total_1"><%=suma(ESH,ESM)%></td>
				<td class="porcent_1" ><%=persent( suma(ESH,ESM),suma(suma_sie_hombres,suma_sie_mujeres) )%></td>
			<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(ESH,suma_sie_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(ESM,suma_sie_mujeres)%></td>
							<%end if%>	                  						
			<%if Masculino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
				<td class="total_1"><%=suma(TSH,TSM)%></td>
				<td class="porcent_1" ><%=persent( suma(TSH,TSM),suma(suma_sit_hombres,suma_sit_mujeres) )%></td>
			<%end if%>
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(TSH,suma_sit_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(TSM,suma_sit_mujeres)%></td>
							<%end if%>				
		<%end if%>	
	<%end if%>
<%
'upa_pregrado<<
%>
<%
'upa_postgrado>>
%>				
				
					
					<%if upa_postgrado = "1" and graduados = "1" then%>
						<%if Masculino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGH%></td>
						<%end if%>	
						<%if Femenino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGM%></td>
						<%end if%>	
                        <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
							<td class="total_1"><%=suma(GGH,GGM)%></td>							
							<td class="porcent_1" ><%=persent( suma(GGH,GGM),suma(suma_graduados_po_hombres,suma_graduados_po_mujeres) )%></td>
						<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(GGH,suma_graduados_po_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(GGM,suma_graduados_po_mujeres)%></td>
							<%end if%>						
					<%end if%>
<%
'upa_postgrado<<
%>	
<%
'instituto>>
%>						
					<%if instituto = "1" then%>
						
						<%if egresados = "1" then%>
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIH%></td>
							<%end if%>	
							<%if Femenino  = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIM%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td class="total_1"><%=suma(EIH,EIM)%></td>								
								<td class="porcent_1" ><%=persent( suma(EIH,EIM),suma(suma_egresados_i_hombres,suma_egresados_i_mujeres) )%></td>
							<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(EIH,suma_egresados_i_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(EIM,suma_egresados_i_mujeres)%></td>
							<%end if%>								
						<%end if%>
						
						<%if titulados = "1" then%>
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIH%></td>
							<%end if%>
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIM%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td class="total_1"><%=suma(TIH,TIM)%></td>
								<td class="porcent_1" ><%=persent( suma(TIH,TIM),suma(suma_titulados_i_hombres,suma_titulados_i_mujeres) )%></td>
							<%end if%>	
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent(TIH,suma_titulados_i_hombres)%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent(TIM,suma_titulados_i_mujeres)%></td>
							<%end if%>								
						<%end if%>
						
					<%end if%>
<%
'instituto>>
%>						
				</tr>
<%
'************************************'
'**		VALORES DE LA TABLA 	**'
'*********************************'
%>					
				<%wend
				
'*************************************************'
'**			 CONSTRUCCION DE LA TABLA			**'TOTALES
'*************************************************'-----------------------	
%>			
				<tr bgcolor="#FFFFFF">
					<td align='right' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >TOTALES</td>

				<%if upa_pregrado = "1" then%>
						<%if egresados = "1" then%>
							<%if Masculino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEUH%></td>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEUM%></td>
							<%end if%>	
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td class="total_1"><%=suma(TEUH,TEUM)%></td>
								<td class="porcent_1" ><%=persent( suma(TEUH,TEUM),suma(TEUH,TEUM) )%></td>
							<%end if%> 
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TEUH,TEUH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TEUM,TEUM )%></td>
							<%end if%>								
						<%end if%>	
						<%if titulados = "1" then%>
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTUH%></td>								
							<%end if%>		
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTUM%></td>							
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
								<td class="total_1"><%=suma(TTUH,TTUM)%></td>
								<td class="porcent_1" ><%=persent( suma(TTUH,TTUM),suma(TTUH,TTUM) )%></td>
							<%end if%> 
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TTUH,TTUH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TTUM,TTUM )%></td>
							<%end if%>		                           	
						<%end if%>	
						<%if graduados = "1" then%>
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGPH%></td>					
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGPM%></td>							
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
								<td class="total_1"><%=suma(TGPH,TGPM)%></td>
								<td class="porcent_1" ><%=persent( suma(TGPH,TGPM),suma(TGPH,TGPM) )%></td>
							<%end if%> 
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TGPH,TGPH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TGPM,TGPM )%></td>
							<%end if%>	                  			                           	
						<%end if%>	
						<%if salidas_int = "1" then%>
							<%if Masculino = "1" then%>	
				  <td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TESH%></td>
							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TESM%></td>							
							<%end if%>	
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td class="total_1"><%=suma(TESH,TESM)%></td>
								<td class="porcent_1" ><%=persent( suma(TESH,TESM), suma(TESH,TESM) )%></td>
							<%end if%>
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TESH, TESH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TESM, TESM )%></td>
							<%end if%>		                            
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTSH%></td>							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTSM%></td>							
							<%end if%>	
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
								<td class="total_1"><%=suma(TTSH,TTSM)%></td>
								<td class="porcent_1" ><%=persent( suma(TTSH,TTSM), suma(TTSH,TTSM) )%></td>
							<%end if%> 							
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TTSH, TTSH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TTSM, TTSM )%></td>
							<%end if%>									
						<%end if%>	
					<%end if%>
				

					<%if upa_postgrado = "1" and graduados = "1" then%>
						<%if Masculino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGGH%></td>							
						<%end if%>	
						<%if Femenino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGGM%></td>						
						<%end if%>	
                        <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
							<td class="total_1"><%=suma(TGGH,TGGM)%></td>
							<td class="porcent_1" ><%=persent( suma(TGGH,TGGM), suma(TGGH,TGGM) )%></td>
						<%end if%>  
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TGGH, TGGH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TGGM, TGGM )%></td>
							<%end if%>								
					<%end if%>
					
					<%if instituto = "1" then%>
						<%if egresados = "1" then%>	
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEIH%></td>							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEIM%></td>								
							<%end if%>	
                            <%if Femenino = "1" and Masculino = "1" then%><!-- solo masculinos -->		
								<td class="total_1"><%=suma(TEIH,TEIM)%></td>
                                <td class="porcent_1" ><%=persent( suma(TEIH,TEIM), suma(TEIH,TEIM) )%></td>
							<%end if%> 
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TEIH, TEIH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TEIM, TEIM )%></td>
							<%end if%>	                  										
						<%end if%>	
						<%if titulados = "1" then%>	
							<%if Masculino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTIH%></td>								
							<%end if%>
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTIM%></td>								
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="total_1"><%=suma(TTIH,TTIM)%></td>
								<td class="porcent_1" ><%=persent( suma(TTIH,TTIM), suma(TTIH,TTIM) )%></td>
							<%end if%>   
                            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
								<td class="porcent_1" ><%=persent( TTIH, TTIH )%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
								<td class="porcent_1" ><%=persent( TTIM, TTIM )%></td>
							<%end if%>								
						<%end if%>	
					<%end if%>
				</tr>
			   </table>
			</td>
		  </tr>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>