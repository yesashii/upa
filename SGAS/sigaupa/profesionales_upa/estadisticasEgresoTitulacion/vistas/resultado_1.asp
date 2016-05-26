<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->

<%
set pagina = new CPagina
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'letra = estadistica_titulados_vASP(1,1,"I","ITI", 1, 0, 0, 0, 0)
'EUHx       = conexion.consultaUno(letra)	
'response.write("letra="&EUHx)
'RESPONSE.END()
'------------------------------------------------------------------------------
'**************************************************'
'**		CAPTURA DE LAS VARIABLES DE BÚSQUEDA	 **'
'**************************************************'------------------------
upa_pregrado  	=  request.Form("upa_pregrado")
upa_postgrado 	=  request.Form("upa_postgrado")
instituto     	=  request.Form("instituto")
egresados  	  	=  request.Form("egresados")
titulados     	=  request.Form("titulados")
graduados     	=  request.Form("graduados")
salidas_int   	=  request.Form("salidas_int")
femenino 	  	=  request.Form("femenino")
masculino 	  	=  request.Form("masculino")
facu_ccod     	=  request.Form("selectFacultad")
carr_ccod     	=  request.Form("selectCarrera")
selectAnioPromo =  request.Form("selectAnioPromo")
selectAnioEgre 	=  request.Form("selectAnioEgre")
selectAnioTitu 	=  request.Form("selectAnioTitu")
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
SexTextMascu 	= "M"
SexTextFeme 	= "F"
'---------------------------------------------------------------------->>>>>>>>>>>>DEBUG
'for each k in request.form
' response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.end()
'---------------------------------------------------------------------->>>>>>>>>>>>DEBUG
carr_ccod     =  request.Form("selectCarrera")
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
'**************************'------------------------
'**		BOTONERA 		 **'
'**************************'
'*********************************************************'
'**						TOTALES							**'
'*********************************************************'-------------------------
'TOTALES>>>>>>
suma_egresados_u_hombres	=	0
suma_egresados_u_mujeres	=	0
suma_titulados_u_hombres	=	0
suma_titulados_u_mujeres	=	0
suma_sie_hombres			=	0
suma_sie_mujeres			=	0
suma_sit_hombres			=	0
suma_sit_mujeres			=	0
suma_graduados_po_hombres	=	0
suma_graduados_po_mujeres	=	0
suma_egresados_i_hombres	=	0
suma_egresados_i_mujeres	=	0
suma_titulados_i_hombres	=	0
suma_titulados_i_mujeres	=	0					
'TOTALES<<<<<<
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
'-----------------------------------------------------------------------------/////////////
EUH	= 0
EUM	= 0
TUH	= 0
TUM	= 0
ESH	= 0
ESM	= 0
TSH	= 0
TSM	= 0
EIM = 0
TIH	= 0
TIM	= 0
GGH	= 0
GGM	= 0
set f_lista2 = new CFormulario
f_lista2.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista2.Inicializar conexion
consulta = "" & vbCrLf & _
"select sede_ccod, 					" & vbCrLf & _
			"sede_tdesc as sede 		" & vbCrLf & _ 
			"from sedes   				"& vbCrLf &_
			" order by sede_tdesc asc 	"
f_lista2.Consultar consulta 
while f_lista2.siguiente
	sede_ccod = f_lista2.obtenerValor("sede_ccod")
	if upa_pregrado = "1" then
	    if egresados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,1,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EUH       					= conexion.consultaUno(letra)
				TEUH 						= TEUH + cint(EUH)
				suma_egresados_u_hombres	= TEUH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,2,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EUM       					= conexion.consultaUno(letra)
				TEUM 						= TEUM + cint(EUM)
				suma_egresados_u_mujeres	= TEUM
				'response.write(suma_egresados_u_mujeres&"-")
			end if
		end if
		if titulados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,1,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)	
				TUH     					= conexion.consultaUno(letra)							
				TTUH 						= TTUH + cint(TUH)
				suma_titulados_u_hombres	= TTUH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,2,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TUM     					= conexion.consultaUno(letra)
				TTUM 						= TTUM + cint(TUM) 
				suma_titulados_u_mujeres	= TTUM
			end if
		end if
		if salidas_int = "1" then
			'EGRESADOS>>
		    if masculino = "1" then	
				letra 				= estadistica_titulados_vASP(sede_ccod,1,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				ESH     			= conexion.consultaUno(letra)
				TESH 				= TESH + cint(ESH)
				suma_sie_hombres	= TESH
			end if
			if femenino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccod,2,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				ESM     			= conexion.consultaUno(letra)
				TESM 				= TESM + cint(ESM)
				suma_sie_mujeres	= TESM
			end if
			'EGRESADOS<<
			'TITULADOS>>
			if masculino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccod,1,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TSH     			= conexion.consultaUno(letra)
				TTSH 				= TTSH + cint(TSH)
				suma_sit_hombres	= TTSH
			end if
			if femenino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccod,2,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TSM     			= conexion.consultaUno(letra)
				TTSM 				= TTSM + cint(TSM)
				suma_sit_mujeres	= TTSM
			'TITULADOS<<
			end if
		end if
	end if
	if instituto = "1" then
	    if egresados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,1,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EIH     					= conexion.consultaUno(letra)
				TEIH 						= TEIH + cint(EIH)
				suma_egresados_i_hombres	= TEIH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,2,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EIM     					= conexion.consultaUno(letra)
				TEIM 						= TEIM + cint(EIM)
				suma_egresados_i_mujeres	= TEIM
			end if
		end if
		if titulados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,1,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TIH     					= conexion.consultaUno(letra)
				TTIH 						= TTIH + cint(TIH)
				suma_titulados_i_hombres	= TTIH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,2,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TIM     					= conexion.consultaUno(letra)
				TTIM 						= TTIM + cint(TIM)
				suma_titulados_i_mujeres	= TTIM
			end if
		end if
	end if
	if upa_postgrado = "1" then				
	    if graduados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,1,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				GGH     					= conexion.consultaUno(letra)
				TGGH 						= TGGH + cint(GGH)
				suma_graduados_po_hombres	= TGGH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccod,2,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				GGM     					= conexion.consultaUno(letra)
				TGGM 						= TGGM + cint(GGM)
				suma_graduados_po_mujeres	= TGGM
			end if
		end if
	end if	
wend	
'*********************************************************'-------------------------
'**						TOTALES							**'
'*********************************************************'

'*********************************************************'
'**														**'
'**		CONSTRUCCIÓN DE LA CONSULTA QUE LLENA LA TABLA	**'
'**														**'
'*********************************************************'-------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
consulta = "" & vbCrLf & _
"select a.sede_ccod, 					" & vbCrLf & _
			"a.sede_tdesc as sede 		" & vbCrLf & _ 
			"from sedes a  				"& vbCrLf &_
			" order by sede_tdesc asc 	"
f_lista.Consultar consulta 
'*********************************************************'-------------------------
'**														**'
'**		CONSTRUCCIÓN DE LA CONSULTA QUE LLENA LA TABLA	**'
'**														**'
'*********************************************************'
%>

<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array( EncodeUTF8("Resultados de la búsqueda") ), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div id="titulo" align="center"><br>
              <h3>ESTAD&Iacute;STICAS EGRESADOS, TITULADOS Y GRADUADOS </h3>
			  </div>
<%	fecha1	= conexion.consultaUno("select getDate()")	%>
<div id="fecha">
	<table>
		<tr>
			<td style="border-bottom:solid; border-bottom-color:#666;" width="77%" align="left"><strong><%response.Write("Fecha y hora: "&fecha1)%></strong></td>
		</tr>
	</table>
</div>              
            </td>
		  </tr>
		  <tr>
            <td align="right" height="30">&nbsp;</td>
		  </tr>
		  <form name="edicion">
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>	
							<%if Femenino = "1" then%>	
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>
							<%if Femenino = "1" then%>	
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
							<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
						<%end if%>	
						<%if Femenino = "1" then%>		
							<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>								
							<%if Femenino = "1" then%>		
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
								<th><font color='#333333'><%Response.write(SexTextMascu)%></font></th>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<th><font color='#333333'><%Response.write(SexTextFeme)%></font></th>
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
					'-----------------------------------------------------------------------------/////////////
					EUH	= 0
					EUM	= 0
					TUH	= 0
					TUM	= 0
					ESH	= 0
					ESM	= 0
					TSH	= 0
					TSM	= 0
					EIM = 0
					TIH	= 0
					TIM	= 0
					GGH	= 0
					GGM	= 0
				  while f_lista.siguiente
				    sede_ccod = f_lista.obtenerValor("sede_ccod")
					sede      = f_lista.obtenerValor("sede")
					if upa_pregrado = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								letra 						= estadistica_titulados_vASP(sede_ccod,1,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								EUH       					= conexion.consultaUno(letra)
								TEUH 						= TEUH + cint(EUH)
							end if
							if femenino = "1" then
								letra 						= estadistica_titulados_vASP(sede_ccod,2,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								EUM       					= conexion.consultaUno(letra)
								TEUM 						= TEUM + cint(EUM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								letra 						= estadistica_titulados_vASP(sede_ccod,1,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)	
								TUH     					= conexion.consultaUno(letra)							
								TTUH 						= TTUH + cint(TUH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								TUM     = conexion.consultaUno(letra)
								TTUM 	= TTUM + cint(TUM) 
							end if
						end if
						if salidas_int = "1" then
							'EGRESADOS>>
						    if masculino = "1" then	
								letra 	= estadistica_titulados_vASP(sede_ccod,1,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								ESH     = conexion.consultaUno(letra)
								TESH 	= TESH + cint(ESH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								ESM     = conexion.consultaUno(letra)
								TESM 	= TESM + cint(ESM)
							end if
							'EGRESADOS<<
							'TITULADOS>>
							if masculino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,1,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								TSH     = conexion.consultaUno(letra)
								TTSH 	= TTSH + cint(TSH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								TSM     = conexion.consultaUno(letra)
								TTSM 	= TTSM + cint(TSM)
							'TITULADOS<<
							end if
						end if
					end if
					if instituto = "1" then'INSTITUTO>>
					    if egresados = "1" then
						    if masculino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,1,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)									
								EIH     = conexion.consultaUno(letra)
								TEIH 	= TEIH + cint(EIH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								EIM     = conexion.consultaUno(letra)
								TEIM 	= TEIM + cint(EIM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,1,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)								
								TIH     = conexion.consultaUno(letra)
								TTIH = TTIH + cint(TIH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								TIM     = conexion.consultaUno(letra)
								TTIM 	= TTIM + cint(TIM)
							end if
						end if
					end if'INSTITUTO<<
					if upa_postgrado = "1" then				
					    if graduados = "1" then
						    if masculino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,1,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								GGH     = conexion.consultaUno(letra)
								TGGH 	= TGGH + cint(GGH)
							end if
							if femenino = "1" then
								letra 	= estadistica_titulados_vASP(sede_ccod,2,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
								GGM     = conexion.consultaUno(letra)
								TGGM 	= TGGM + cint(GGM)
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%>	<!-- ambos sexos -->
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(EUH,EUM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(EUH,EUM)%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUH%></td>
			<%end if%>		
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUM%></td>
			<%end if%>	
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(TUH,TUM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(TUH,TUM)%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->	
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(GPH,GPM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(GPH,GPM)%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESM%></td>
			<%end if%>	
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(ESH,ESM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(ESH,ESM)%></td>
				<td class="porcent_1" ><%=persent( suma(ESH,ESM),suma(suma_sie_hombres,suma_sie_mujeres) )%></td>
			<%end if%>	
            <%if Femenino = "0" and Masculino = "1" then%><!-- solo masculinos -->	
				<td class="porcent_1" ><%=persent(ESH,suma_sie_hombres)%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "0" then%><!-- solo femeninos -->	
				<td class="porcent_1" ><%=persent(ESM,suma_sie_mujeres)%></td>
			<%end if%>	                  						
			<%if Masculino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSH%></td>
			<%end if%>	
			<%if Femenino = "1" then%>		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSM%></td>
			<%end if%>
            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(TSH,TSM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(TSH,TSM)%></td>
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
							<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGH%></td>
						<%end if%>	
						<%if Femenino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGM%></td>
						<%end if%>	
                        <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
							<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(GGH,GGM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(GGH,GGM)%></td>							
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
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIH%></td>
							<%end if%>	
							<%if Femenino  = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIM%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=3&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(EIH,EIM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(EIH,EIM)%></td>								
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
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIH%></td>
							<%end if%>
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIM%></td>
							<%end if%>
                            <%if Femenino = "1" and Masculino = "1" then%><!-- ambos sexos -->		
								<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_2.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=3&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=suma(TIH,TIM)%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=suma(TIH,TIM)%></td>
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
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEUH%></td>
							<%end if%>	
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEUM%></td>
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
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTUH%></td>								
							<%end if%>		
							<%if Femenino = "1" then%>		
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TUM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTUM%></td>							
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
								<td align='CENTER' class='click onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGPH%></td>					
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GPM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGPM%></td>							
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
				  <td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TESH%></td>
							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=ESM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TESM%></td>							
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
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTSH%></td>							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TSM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTSM%></td>							
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
							<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGGH%></td>							
						<%end if%>	
						<%if Femenino = "1" then%>	
							<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=GGM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TGGM%></td>						
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
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEIH%></td>							
							<%end if%>	
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=EIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TEIM%></td>								
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
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIH%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTIH%></td>								
							<%end if%>
							<%if Femenino = "1" then%>	
								<td align='CENTER' class='click' onClick='irA2_1("estadisticasEgresoTitulacion/vistas/resultado_2_1.asp?upa_pregrado=<%=upa_pregrado%>&upa_postgrado=<%=upa_postgrado%>&instituto=<%=instituto%>&egresados=<%=egresados%>&titulados=<%=titulados%>&graduados=<%=graduados%>&salidas_int=<%=salidas_int%>&femenino=<%=femenino%>&masculino=<%=masculino%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>","<%=TIM%>")' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TTIM%></td>								
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
		  </form>
		  <tr>
            <td align="right">* Presione sobre el n&uacute;mero de inter&eacute;s para visualizar el dato a un detalle mayor.</td>
		  </tr>
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
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div id="botonDoc" align="center">
						    <% 
							   url_2 = "estadisticasEgresoTitulacion/excels/estadisticas_egreso_titulacion_excel.asp?upa_pregrado="&upa_pregrado&"&upa_postgrado="&upa_postgrado&"&instituto="&instituto&"&egresados="&egresados&"&titulados="&titulados&"&graduados="&graduados&"&salidas_int="&salidas_int&"&femenino="&femenino&"&masculino="&masculino&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&"&selectAnioPromo="&selectAnioPromo&"&selectAnioEgre="&selectAnioEgre&"&selectAnioTitu="&selectAnioTitu
 							'   'response.Write(url_2)
							   botonera.agregaBotonParam "excel_2","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_2"
							%>
							</div>
						</td>
						<td><div id="botonDocGeneral" align="center">
						    <% 
							  url_2 = "estadisticasEgresoTitulacion/excels/gran_detalle_1.asp?upa_pregrado="&upa_pregrado&"&upa_postgrado="&upa_postgrado&"&instituto="&instituto&"&egresados="&egresados&"&titulados="&titulados&"&graduados="&graduados&"&salidas_int="&salidas_int&"&femenino="&femenino&"&masculino="&masculino&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&"&selectAnioPromo="&selectAnioPromo&"&selectAnioEgre="&selectAnioEgre&"&selectAnioTitu="&selectAnioTitu
 							'   'response.Write(url_2)
							   botonera.agregaBotonParam "excel_general","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_general"
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


