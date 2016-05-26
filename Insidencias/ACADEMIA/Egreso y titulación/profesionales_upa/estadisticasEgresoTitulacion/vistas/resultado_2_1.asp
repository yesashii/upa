<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%
	Server.ScriptTimeOut = 300000
    set pagina = new CPagina
    '-------------------------------------------------------------------------------
    set conexion = new CConexion
    conexion.Inicializar "upacifico"
    
    set negocio = new CNegocio
    negocio.Inicializa conexion
    '------------------------------------------------------------------------------
    
    '***************************'
    '** CAPTURA VARIABLES GET **'
    '***************************'--------------------------	
    sede_ccod 	= request.QueryString("sede_ccod")
    tipo      	= request.QueryString("tipo")
    sexo_ccod 	= request.QueryString("sexo_ccod")
    institucion	= request.QueryString("institucion")
    facu_ccod	= request.QueryString("facu_ccod")
    carr_ccod   = request.QueryString("carr_ccod")
	
	selectAnioPromo = request.QueryString("selectAnioPromo")
	selectAnioTitu  = request.QueryString("selectAnioTitu")
	selectAnioEgre  = request.QueryString("selectAnioEgre")
    'sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
    carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
	'----------------------------------------
'---------------------------------------------->>>NuevasVariables
	upa_pregrado  	=  request.QueryString("upa_pregrado")
	upa_postgrado 	=  request.QueryString("upa_postgrado")
	instituto     	=  request.QueryString("instituto")
	egresados  	  	=  request.QueryString("egresados")
	titulados     	=  request.QueryString("titulados")
	graduados     	=  request.QueryString("graduados")
	salidas_int   	=  request.QueryString("salidas_int")
	femenino 	  	=  request.QueryString("femenino")
	masculino 	  	=  request.QueryString("masculino")
	selectAnioPromo =  request.QueryString("selectAnioPromo")
	selectAnioTitu  =  request.QueryString("selectAnioTitu")
	selectAnioEgre  =  request.QueryString("selectAnioEgre")
'---------------------------------------------->>>NuevasVariables	
'------------------------------------------------------------------>>>>>>>>>>>>>>>>Arreglo de sexo
if sexo_ccod = 1 then 
masculino 	= "1"
femenino 	= "0"
end if
if sexo_ccod = 2 then 
masculino 	= "0"
femenino 	= "1"
end if
'------------------------------------------------------------------<<<<<<<<<<<<<<<<Arreglo de sexo
SexTextMascu 	= "M"
SexTextFeme 	= "F"
	
    '***************************'--------------------------	
    '** CAPTURA VARIABLES GET **'
    '***************************'	
    'DEBUG---------------------------------->>	
'---------------------------------------------------oDebug>>
'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.end()
'---------------------------------------------------oDebug<<	
    '	response.write("sede_ccod = "&sede_ccod)        &response.write("<br>")
    '	response.write("tipo = "&tipo)                  &response.write("<br>")
    '	response.write("sexo_ccod = "&sexo_ccod)        &response.write("<br>")
    '	response.write("institucion = "&institucion)    &response.write("<br>")
    '	response.write("facu_ccod = "&facu_ccod)        &response.write("<br>")
    '	'response.write("sede_tdesc = "&sede_tdesc)      &response.write("<br>")
    '	response.write("carr_ccod = "&carr_ccod)        &response.write("<br>")
    '	response.write("carr_tdesc = "&carr_tdesc)      &response.write("<br>")
    'DEBUG----------------------------------<<
    'PARA EL ENVÍO---------------------------------------------------------------------->>
    E_sede_ccod 	= sede_ccod	
    E_tipo      	= tipo	
    E_sexo_ccod 	= sexo_ccod
    E_institucion	= institucion
    E_facu_ccod		= facu_ccod
    E_carr_ccod   	= carr_ccod
    E_sede_tdesc 	= sede_tdesc
    E_carr_tdesc 	= carr_tdesc
    'PARA EL ENVÍO----------------------------------------------------------------------<<
    
    set botonera = new CFormulario
    botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"
'---------------------------------------------------------------------------------filtro facultades y carreras
	if carr_ccod<>"0" then
		filtro_carreras = "and cast(c.carr_ccod as varchar)='"&carr_ccod&"'"
	else
		filtro_carreras=""
	end if	
	
	if facu_ccod<>"0" then
		filtro_facultad = "and cast(d.facu_ccod as varchar)='"&facu_ccod&"'"
	else
		filtro_facultad=""
	end if	
'---------------------------------------------------------------------------------filtro facultades y carreras
'--------------------------------------------------------------------------------->>filtro carreras
if institucion <> "I" then
	if tipo ="POG" then
		filtro_carreras = filtro_carreras&" and cast(c.tcar_ccod as varchar) ='2'"
	else
		filtro_facultad= filtro_facultad&" and cast(c.tcar_ccod as varchar) ='1'"
	end if	
end if	
'---------------------------------------------------------------------------------<<filtro carreras		
    %>
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
                                <td><%pagina.DibujarLenguetas Array( EncodeUTF8("Distribución por carreras") ), 1 %></td>
                            </tr>
                            <tr>
                                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="center"><br>
                                        <% EncodeUTF8(pagina.DibujarTituloPagina) %>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" height="30">&nbsp;</td>
                            </tr>
                            <form name="edicion" method="post">
                                <tr>
                                    <td align="center">
                                        <script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>	
                                        <%
                                            '------------------------------------------------------------------------------------------------------------variables>>>>>>>>>>>>>>>>>>>>>
                                            	varInstitucion 	= ""
                                            	varEstados 		= ""
                                            	varSexo			= ""
                                            	'*************************************************'
                                            	'**				INSTITUCIONES					**'
                                            	'*************************************************'---------------------------------------
                                            	'************************'
                                            	'* Universidad Pregrado	*'
                                            	'************************'--------------- 	
                                            	if (institucion = "U") and (tipo = "UEG" or tipo = "UTI" or tipo = "PRG" or tipo = "SIE" or tipo = "SIT") then
                                            		varInstitucion = "Universidad Pregrado"
                                            	end if
                                            	'************************'--------------- 
                                            	'* Universidad Pregrado	*'
                                            	'************************'
                                            	'****************************'
                                            	'* Universidad Postgrado	*'
                                            	'****************************'---------------
                                            	if (institucion = "U") and ( tipo = "POG" ) then
                                            		varInstitucion = "Universidad Postgrado"
                                            	end if
                                            	'****************************'---------------
                                            	'* Universidad Postgrado	*'
                                            	'****************************'
                                            	'****************'
                                            	'* 	Instituto	*'
                                            	'****************'---------------
                                            	if (institucion = "I") and ( tipo = "IEG" or tipo = "ITI" ) then
                                            		varInstitucion = "Instituto"
                                            	end if
                                            	'****************'---------------
                                            	'* 	Instituto	*'
                                            	'****************'
                                            	'*************************************************'---------------------------------------
                                            	'**				INSTITUCIONES					**'
                                            	'*************************************************'
                                            	'*********************************************************'
                                            	'**				ESTADOS DE TITULADOS					**'
                                            	'*********************************************************'---------------------------------------
                                            	'************************'
                                            	'* Universidad Pregrado	*'
                                            	'************************'--------------- 
                                            	if institucion = "U" then
                                            		if tipo = "UEG" then
                                            			varEstados = "Egresados"
                                            		end if
                                            		if tipo = "UTI" then
                                            			varEstados = "Titulados"
                                            		end if
                                            		if tipo = "PRG" then
                                            			varEstados = "Grados"
                                            		end if
                                            		if tipo = "SIE" then
                                            			varEstados = "S.I.E"
                                            		end if
                                            		if tipo = "SIT" then
                                            			varEstados = "S.I.T"
                                            		end if
                                            	end if
                                            	'************************'--------------- 
                                            	'* Universidad Pregrado	*'
                                            	'************************'
                                            	'****************************'
                                            	'* Universidad Postgrado	*'
                                            	'****************************'---------------
                                            	if institucion = "U" then
                                            		if tipo = "POG" then
                                            			varEstados = "Grados"
                                            		end if
                                            	end if	
                                            	'****************************'---------------
                                            	'* Universidad Postgrado	*'
                                            	'****************************'
                                            	'****************'
                                            	'* 	Instituto	*'
                                            	'****************'---------------
                                            	if institucion = "I" then
                                            		if tipo = "IEG" then
                                            			varEstados = "Egresados"
                                            		end if
                                            		if tipo = "ITI" then
                                            			varEstados = "Titulados"
                                            		end if
                                            	end if
                                            	'****************'---------------
                                            	'* 	Instituto	*'
                                            	'****************'
                                            	'*********************************************************'---------------------------------------
                                            	'**				ESTADOS DE TITULADOS					**'
                                            	'*********************************************************'	
                                            	'*****************************************'
                                            	'**				SEXOS					**'
                                            	'*****************************************'---------------------------------------
                                            	if sexo_ccod = "1" then
                                            		varSexo = "Masculino"
                                            	end if
                                            	if sexo_ccod = "2" then
                                            		varSexo = "Femenino"
                                            	end if
                                            	'*****************************************'---------------------------------------
                                            	'**				SEXOS					**'
                                            	'*****************************************'			
                                            '------------------------------------------------------------------------------------------------------------variables>>>>>>>>>>>>>>>>>>>>>
                                            %>
                                        <table width="100%" border="0">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" >
                                                        <tr>
                                                            <td align="center" width="100%" colspan="18">
                                                                <h3><%=varInstitucion&", "&varEstados&", "&varSexo%></h3>
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
                                                            <td>Carreras</td>
                                                            <td align="center" >Total</td>
															<td align="center" >%</td>
                                                        </tr>
                                                        <%
													
                                                            Dim i 
                                                            sede = 1
                                                            while sede < 10	
                                                            	sede_ccod = Cstr(sede)
                                                            	sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
                                                            '------------------------------------------------------------------------------------------------------->>>>>>>PARA EL TOTAL
                                                            set f_lista_2 = new CFormulario
                                                            f_lista_2.Carga_Parametros "tabla_vacia.xml", "tabla"
                                                            f_lista_2.Inicializar conexion
                                                           '---------------------------------------------------------------------------------------------oooooooooooooooooooooooooo
														    consulta =  "select distinct sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_egresados_U_hombres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_egresados_U_mujeres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_titulados_U_hombres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_titulados_U_mujeres   "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PR_hombres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PR_mujeres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIE_hombres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIE_mujeres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIT_hombres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIT_mujeres  "& vbCrLf &_
                                                            							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))	as suma_egresados_I_hombres  "& vbCrLf &_
                                                            							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))	as suma_egresados_I_mujeres  "& vbCrLf &_
                                                            							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))	as suma_titulados_I_hombres  "& vbCrLf &_
                                                            							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))	as suma_titulados_I_mujeres  "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PO_hombres "& vbCrLf &_
                                                            							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PO_mujeres "& vbCrLf &_
                                                                        "FROM  "& vbCrLf &_
                                                            			"( "& vbCrLf &_
                                                                        "select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  "& vbCrLf &_
                                                            			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
                                                            			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"            and a.ENTIDAD='U' and a.emat_ccod = 8  "& vbCrLf &_
                                                            			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
                                                            			"            and not exists (select 1   "& vbCrLf &_
                                                            			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
                                                            			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
                                                            			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
                                                            			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                            and t2.tsca_ccod in (1,2,5))     "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"                from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
                                                            			"                     areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            			"                where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            			"                and isnull(protic.trunc(a.fecha_egreso),'') <> ''  "& vbCrLf &_
                                                            			"                and (select top 1 t2.sede_ccod  "& vbCrLf &_
                                                            			"                     from alumnos tt (nolock),   "& vbCrLf &_
                                                            			"                     ofertas_academicas t2, especialidades t3  "& vbCrLf &_
                                                            			"                     where tt.ofer_ncorr=t2.ofer_ncorr   "& vbCrLf &_
                                                            			"                     and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
                                                            			"                     and tt.emat_ccod <> 9   "& vbCrLf &_
                                                            			"                     and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            			"                     and t3.carr_ccod=c.carr_ccod   "& vbCrLf &_
                                                            			"                     order by t2.peri_ccod desc) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            			"                and not exists (select 1 from salidas_carrera tt   "& vbCrLf &_
                                                            			"                                where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
                                                            			"                                and tt.saca_ncorr=a.plan_ccod   "& vbCrLf &_
                                                            			"                                and tt.tsca_ccod = 4)  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"                from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            			"                areas_academicas d, facultades e  "& vbCrLf &_
                                                            			"                where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
                                                            			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            			"                and not exists (select 1   "& vbCrLf &_
                                                            			"                                from detalles_titulacion_carrera tt(nolock)  "& vbCrLf &_
                                                            			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod   "& vbCrLf &_
                                                            			"                and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            			"                and b.tsca_ccod in (3) and c.tcar_ccod=1  "& vbCrLf &_
                                                            			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"                areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            			"                alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            			"                and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
                                                            			"                and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
                                                            			"                and g.saca_ncorr in (756,764,774)  "& vbCrLf &_
                                                            			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            			"            and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
                                                            			"            and g.emat_ccod in (4,8)  "& vbCrLf &_
                                                            			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
                                                            			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            			"            and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
                                                            			"            and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
                                                            			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
                                                            			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e  "& vbCrLf &_
                                                            			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.ENTIDAD='I' and a.emat_ccod in (4,8)  "& vbCrLf &_
                                                            			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            			"                and not exists (select 1   "& vbCrLf &_
                                                            			"                                from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
                                                            			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
                                                            			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"            and a.ENTIDAD='I' and a.emat_ccod = 8  "& vbCrLf &_
                                                            			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
                                                            			"            and not exists (select 1   "& vbCrLf &_
                                                            			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
                                                            			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
                                                            			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
                                                            			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                            and t2.tsca_ccod in (1,2,5))  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			"union  "& vbCrLf &_
                                                            			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            			"                and b.tsca_ccod in (3) and c.tcar_ccod=2  "& vbCrLf &_
                                                            			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            			" ) ttr "
														   '---------------------------------------------------------------------------------------------oooooooooooooooooooooooooo
														   
                                                            'response.write("<pre>"&consulta&"</pre>")	
                                                            f_lista_2.Consultar consulta 
                                                            f_lista_2.Siguiente
                                                            
                                                            suma_egresados_U_hombres	=  f_lista_2.ObtenerValor("suma_egresados_U_hombres")
                                                            suma_egresados_U_mujeres    =  f_lista_2.ObtenerValor("suma_egresados_U_mujeres")
                                                            suma_titulados_U_hombres    =  f_lista_2.ObtenerValor("suma_titulados_U_hombres")
                                                            suma_titulados_U_mujeres    =  f_lista_2.ObtenerValor("suma_titulados_U_mujeres")
                                                            suma_graduados_PR_hombres   =  f_lista_2.ObtenerValor("suma_graduados_PR_hombres")
                                                            suma_graduados_PR_mujeres   =  f_lista_2.ObtenerValor("suma_graduados_PR_mujeres")
                                                            suma_SIE_hombres            =  f_lista_2.ObtenerValor("suma_SIE_hombres")
                                                            suma_SIE_mujeres            =  f_lista_2.ObtenerValor("suma_SIE_mujeres")
                                                            suma_SIT_hombres            =  f_lista_2.ObtenerValor("suma_SIT_hombres")
                                                            suma_SIT_mujeres            =  f_lista_2.ObtenerValor("suma_SIT_mujeres")
                                                            suma_egresados_I_hombres    =  f_lista_2.ObtenerValor("suma_egresados_I_hombres")
                                                            suma_egresados_I_mujeres    =  f_lista_2.ObtenerValor("suma_egresados_I_mujeres")
                                                            suma_titulados_I_hombres    =  f_lista_2.ObtenerValor("suma_titulados_I_hombres")
                                                            suma_titulados_I_mujeres    =  f_lista_2.ObtenerValor("suma_titulados_I_mujeres")
                                                            suma_graduados_PO_hombres   =  f_lista_2.ObtenerValor("suma_graduados_PO_hombres")
                                                            suma_graduados_PO_mujeres   =  f_lista_2.ObtenerValor("suma_graduados_PO_mujeres")
                                                            '-------------------------------------------------------------------------------------------------------<<<<<<<PARA EL TOTAL
                                                            
                                                            
                                                            
                                                            	set f_lista = new CFormulario
                                                            	f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
                                                            	f_lista.Inicializar conexion	

																'----------------------------------------------------------------------ooooooooooooooooooooooo
                                                            consultaPrima =  "select distinct facu_ccod,carr_ccod, carr_tdesc  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_hombres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as egresados_U_mujeres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_hombres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as titulados_U_mujeres   "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_hombres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PR_mujeres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_hombres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIE_mujeres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_hombres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as SIT_mujeres  "& vbCrLf &_
                                                            				",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_hombres  "& vbCrLf &_
                                                            				",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as egresados_I_mujeres  "& vbCrLf &_
                                                            				",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_hombres  "& vbCrLf &_
                                                            				",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) as titulados_I_mujeres  "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_hombres "& vbCrLf &_
                                                            				",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') as graduados_PO_mujeres "& vbCrLf &_
                                                            				"FROM  "& vbCrLf &_
                                                            				"( "& vbCrLf &_
                                                            				"select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            				"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  "& vbCrLf &_
                                                            				"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
                                                            				"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            				"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"            and a.ENTIDAD='U' and a.emat_ccod = 8  "& vbCrLf &_
                                                            				"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
                                                            				"            and not exists (select 1   "& vbCrLf &_ 
                                                            				"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
                                                            				"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
                                                            				"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
                                                            				"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            				"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                            and t2.tsca_ccod in (1,2,5))     "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"                from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
                                                            				"                     areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            				"                where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            				"                and isnull(protic.trunc(a.fecha_egreso),'') <> ''  "& vbCrLf &_
                                                            				"                and (select top 1 t2.sede_ccod  "& vbCrLf &_
                                                            				"                     from alumnos tt (nolock),   "& vbCrLf &_
                                                            				"                     ofertas_academicas t2, especialidades t3  "& vbCrLf &_
                                                            				"                     where tt.ofer_ncorr=t2.ofer_ncorr   "& vbCrLf &_
                                                            				"                     and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
                                                            				"                     and tt.emat_ccod <> 9   "& vbCrLf &_
                                                            				"                     and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            				"                     and t3.carr_ccod=c.carr_ccod   "& vbCrLf &_
                                                            				"                     order by t2.peri_ccod desc) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            				"                and not exists (select 1 from salidas_carrera tt   "& vbCrLf &_
                                                            				"                                where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
                                                            				"                                and tt.saca_ncorr=a.plan_ccod   "& vbCrLf &_
                                                            				"                                and tt.tsca_ccod = 4)  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"                from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            				"                areas_academicas d, facultades e  "& vbCrLf &_
                                                            				"                where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS  "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
                                                            				"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            				"                and not exists (select 1   "& vbCrLf &_
                                                            				"                                from detalles_titulacion_carrera tt(nolock)  "& vbCrLf &_
                                                            				"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            				"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            				"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            				"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod   "& vbCrLf &_
                                                            				"                and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            				"                and b.tsca_ccod in (3) and c.tcar_ccod=1  "& vbCrLf &_
                                                            				"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
                                                            				"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"                areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            				"                alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            				"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            				"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            				"                and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
                                                            				"                and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
                                                            				"                and g.saca_ncorr in (756,764,774)  "& vbCrLf &_
                                                            				"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            				"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            				"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            				"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            				"            and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
                                                            				"            and g.emat_ccod in (4,8)  "& vbCrLf &_
                                                            				"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
                                                            				"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            				"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
                                                            				"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
                                                            				"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
                                                            				"            and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
                                                            				"            and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
                                                            				"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
                                                            				"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            				"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e  "& vbCrLf &_
                                                            				"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.ENTIDAD='I' and a.emat_ccod in (4,8)  "& vbCrLf &_
                                                            				"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
                                                            				"                and not exists (select 1   "& vbCrLf &_
                                                            				"                                from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
                                                            				"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            				"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            				"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
                                                            				"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
                                                            				"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
                                                            				"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"            and a.ENTIDAD='I' and a.emat_ccod = 8  "& vbCrLf &_
                                                            				"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
                                                            				"            and not exists (select 1   "& vbCrLf &_
                                                            				"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
                                                            				"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
                                                            				"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
                                                            				"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
                                                            				"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                            and t2.tsca_ccod in (1,2,5))  "&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				"union  "& vbCrLf &_
                                                            				"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
                                                            				"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
                                                            				"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
                                                            				"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
                                                            				"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
                                                            				"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
                                                            				"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
                                                            				"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
                                                            				"                and b.tsca_ccod in (3) and c.tcar_ccod=2  "& vbCrLf &_
                                                            				"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"&filtro_carreras&filtro_facultad& vbCrLf &_
                                                            				" ) ttr "& vbCrLf &_
                                                            				" ORDER BY carr_tdesc ASC "																
																'----------------------------------------------------------------------ooooooooooooooooooooooo
                                                            	'response.write("<pre>"&consultaPrima&"</pre>")	
                                                            	'response.end()	
                                                            						TEUH = 0
                                                            						TEUM = 0
                                                            						TTUH = 0
                                                            						TTUM = 0
                                                            						TGPH = 0
                                                            						TGPM = 0
                                                            						TESH = 0
                                                            						TESM = 0
                                                            						TTSH = 0
                                                            						TTSM = 0
                                                            						TEIH = 0
                                                            						TEIM = 0
                                                            						TTIH = 0
                                                            						TTIM = 0
                                                            						TGGH = 0
                                                            						TGGM = 0
                                                            						num=1
                                                            						f_lista.Consultar consultaPrima 
                                                            						'valorAux = f_lista.siguiente
                                                            						'response.Write(valorAux)
                                                            					while f_lista.siguiente
                                                            						carr_ccod = f_lista.obtenerValor("carr_ccod")'codigo carrera
                                                            						facu_ccod = f_lista.obtenerValor("facu_ccod")'codigo facultad
                                                            						carrera   = EncodeUTF8(f_lista.obtenerValor("carr_tdesc"))'nombre carrera 
                                                            						'************************'
                                                            						'* Universidad Pregrado	*'
                                                            						'************************'---------------
                                                            							'EGRESADOS----------->>
                                                            								EUH  = f_lista.obtenerValor("egresados_U_hombres")
                                                            								TEUH = TEUH + cint(EUH)
                                                            								EUM       = f_lista.obtenerValor("egresados_U_mujeres")
                                                            								TEUM = TEUM + cint(EUM)	
                                                            							'EGRESADOS-----------<<	
                                                            							'TITULADOS----------->>
                                                            								TUH       = f_lista.obtenerValor("titulados_U_hombres")
                                                            								TTUH = TTUH + cint(TUH)
                                                            								TUM       = f_lista.obtenerValor("titulados_U_mujeres")
                                                            								TTUM = TTUM + cint(TUM) 
                                                            							'TITULADOS-----------<<
                                                            							'GRADUADOS----------->>
                                                            								GPH       = f_lista.obtenerValor("graduados_PR_hombres")
                                                            								TGPH = TGPH + cint(GPH)								
                                                            								GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
                                                            								TGPM = TGPM + cint(GPM)
                                                            							'GRADUADOS-----------<<
                                                            							'S.I.E----------->>
                                                            								ESH       = f_lista.obtenerValor("SIE_hombres")
                                                            								TESH = TESH + cint(ESH)
                                                            								ESM       = f_lista.obtenerValor("SIE_mujeres")
                                                            								TESM = TESM + cint(ESM)
                                                            							'S.I.E-----------<<
                                                            							'S.I.T----------->>
                                                            								TSH       = f_lista.obtenerValor("SIT_hombres")
                                                            								TTSH = TTSH + cint(TSH)
                                                            								TSM       = f_lista.obtenerValor("SIT_mujeres")
                                                            								TTSM = TTSM + cint(TSM)
                                                            							'S.I.T-----------<<
                                                            						'************************'---------------		
                                                            						'* Universidad Pregrado	*'
                                                            						'************************'	
                                                            						'****************************'	
                                                            						'* Universidad Postgrado	*'
                                                            						'****************************'---------------	
                                                            							'Grados----------->>
                                                            								GGH       = f_lista.obtenerValor("graduados_PO_hombres")
                                                            								TGGH = TGGH + cint(GGH)
                                                            								GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
                                                            								TGGM = TGGM + cint(GGM)
                                                            							'Grados-----------<<
                                                            						'****************************'---------------		
                                                            						'* Universidad Postgrado	*'
                                                            						'****************************'
                                                            						'****************************'	
                                                            						'* 			Instituto		*'
                                                            						'****************************'---------------		
                                                            							'EGRESADOS----------->>
                                                            								EIH       = f_lista.obtenerValor("egresados_I_hombres")
                                                            								TEIH = TEIH + cint(EIH)
                                                            								EIM       = f_lista.obtenerValor("egresados_I_mujeres")
                                                            								TEIM = TEIM + cint(EIM)
                                                            							'EGRESADOS-----------<<	
                                                            							'TITULADOS----------->>
                                                            								TIH       = f_lista.obtenerValor("titulados_I_hombres")
                                                            								TTIH = TTIH + cint(TIH)
                                                            								TIM       = f_lista.obtenerValor("titulados_I_mujeres")
                                                            								TTIM = TTIM + cint(TIM)
                                                            							'TITULADOS-----------<<						
                                                            	
                                                            						'****************************'---------------			
                                                            						'* 			Instituto		*'
                                                            						'****************************'			
                                                            	%>
                                                        <tr bgcolor="#FFFFFF">
                                                            <input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
                                                            <input type="hidden" name="campo_<%=num%>_c1" value="<%=EUH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c2" value="<%=EUM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c3" value="<%=TUH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c4" value="<%=TUM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c5" value="<%=GPH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c6" value="<%=GPM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c7" value="<%=ESH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c8" value="<%=ESM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c9" value="<%=TSH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c10" value="<%=TSM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c11" value="<%=GGH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c12" value="<%=GGM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c13" value="<%=EIH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c14" value="<%=EIM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c15" value="<%=TIH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c16" value="<%=TIM%>">
                                                            <td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
                                                            <%
                                                                '************************'
                                                                '* Universidad Pregrado	*'
                                                                '************************'--------------- 
                                                                %>	
                                                            <%if institucion = "U" then%>
                                                            <%if tipo = "UEG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UEG_H%>'><%=EUH%></font></td>
                                                            <td class="porcent_1" ><%=persent(EUH,suma_egresados_u_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UEG_M%>'><%=EUM%></font></td>
                                                            <td class="porcent_1" ><%=persent(EUM,suma_egresados_u_mujeres)%></td>
                                                            <%end if%>	
                                                            <%end if%>	
                                                            <%if tipo = "UTI" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UTI_H%>'><%=TUH%></font></td>
                                                            <td class="porcent_1" ><%=persent(TUH,suma_titulados_u_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UTI_M%>'><%=TUM%></font></td>
                                                            <td class="porcent_1" ><%=persent(TUM,suma_titulados_u_mujeres)%></td>
                                                            <%end if%>		
                                                            <%end if%>	
                                                            <%if tipo = "PRG" then%>	
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=PRG_H%>'><%=GPH%></font></td>
                                                            <td class="porcent_1" ><%=persent(GPH,suma_graduados_pr_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=PRG_M%>'><%=GPM%></font></td>
                                                            <td class="porcent_1" ><%=persent(GPM,suma_graduados_pr_mujeres)%></td>
                                                            <%end if%>	
                                                            <%end if%>	
                                                            <%if tipo = "SIE" then%>		
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIE_H%>'><%=ESH%></font></td>
                                                            <td class="porcent_1" ><%=persent(ESH,suma_sie_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIE_M%>'><%=ESM%></font></td>
                                                            <td class="porcent_1" ><%=persent(ESM,suma_sie_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%if tipo = "SIT" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIT_H%>'><%=TSH%></font></td>
                                                            <td class="porcent_1" ><%=persent(TSH,suma_sit_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIT_M%>'><%=TSM%></font></td>
                                                            <td class="porcent_1" ><%=persent(TSM,suma_sit_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%
                                                                '************************'---------------
                                                                '* Universidad Pregrado	*'
                                                                '************************'
                                                                %>
                                                            <%
                                                                '****************************'
                                                                '* Universidad Postgrado	*'
                                                                '****************************'---------------
                                                                %>	
                                                            <%if institucion = "U" then%>
                                                            <%if tipo = "POG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=POG_H%>'><%=GGH%></font></td>
                                                            <td class="porcent_1" ><%=persent(GGH,suma_graduados_po_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=POG_M%>'><%=GGM%></font></td>
                                                            <td class="porcent_1" ><%=persent(GGM,suma_graduados_po_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%
                                                                '****************************'---------------
                                                                '* Universidad Postgrado	*'
                                                                '****************************'
                                                                %>	
                                                            <%
                                                                '****************'
                                                                '* 	Instituto	*'
                                                                '****************'---------------
                                                                %>	
                                                            <%if institucion = "I" then%>
                                                            <%if tipo = "IEG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=IEG_H%>'><%=EIH%></font></td>
                                                            <td class="porcent_1" ><%=persent(EIH,suma_egresados_i_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=IEG_M%>'><%=EIM%></font></td>
                                                            <td class="porcent_1" ><%=persent(EIM,suma_egresados_i_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%if tipo = "ITI" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=ITI_H%>'><%=TIH%></font></td>
                                                            <td class="porcent_1" ><%=persent(TIH,suma_titulados_i_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=ITI_M%>'><%=TIM%></font></td>
                                                            <td class="porcent_1" ><%=persent(TIM,suma_titulados_i_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%
                                                                '****************'---------------
                                                                '* 	Instituto	*'
                                                                '****************'
                                                                %>					
                                                        </tr>
                                                        <%num = num + 1
                                                            wend%>
                                                        <tr bgcolor="#FFFFFF">
                                                            <%
                                                                '*****************************************************************************************************************'
                                                                '**													TOTALES														**'
                                                                '*****************************************************************************************************************'---------
                                                                %>	
                                                            <input type="hidden" name="campo_<%=num%>_carrera" value="TOTALES">
                                                            <input type="hidden" name="campo_<%=num%>_c1" value="<%=TEUH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c2" value="<%=TEUM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c3" value="<%=TTUH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c4" value="<%=TTUM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c5" value="<%=TGPH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c6" value="<%=TGPM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c7" value="<%=TESH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c8" value="<%=TESM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c9" value="<%=TTSH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c10" value="<%=TTSM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c11" value="<%=TGGH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c12" value="<%=TGGM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c13" value="<%=TEIH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c14" value="<%=TEIM%>">
                                                            <input type="hidden" name="campo_<%=num%>_c15" value="<%=TTIH%>">
                                                            <input type="hidden" name="campo_<%=num%>_c16" value="<%=TTIM%>">
                                                            <td align="right" style="border-bottom:#000 solid; border-bottom-width:thin;"  bgcolor="#BCC0E0">TOTAL <%=sede_tdesc%></td>
                                                            <%
                                                                '************************'
                                                                '* Universidad Pregrado	*'
                                                                '************************'--------------- 
                                                                %>	
                                                            <%if institucion = "U" then%>
                                                            <%if tipo = "UEG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TEUH%></td>
                                                            <td class="porcent_2" ><%=persent(TEUH,suma_egresados_u_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TEUM%></td>
                                                            <td class="porcent_2" ><%=persent(TEUM,suma_egresados_u_mujeres)%></td>
                                                            <%end if%>	
                                                            <%end if%>	
                                                            <%if tipo = "UTI" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TTUH%></td>
                                                            <td class="porcent_2" ><%=persent(TTUH,suma_titulados_u_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TTUM%></td>
                                                            <td class="porcent_2" ><%=persent(TTUM,suma_titulados_u_mujeres)%></td>
                                                            <%end if%>		
                                                            <%end if%>	
                                                            <%if tipo = "PRG" then%>	
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TGPH%></td>
                                                            <td class="porcent_2" ><%=persent(TGPH,suma_graduados_pr_hombres)%></td>
                                                            <%end if%>	
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TGPM%></td>
                                                            <td class="porcent_2" ><%=persent(TGPM,suma_graduados_pr_mujeres)%></td>
                                                            <%end if%>	
                                                            <%end if%>	
                                                            <%if tipo = "SIE" then%>		
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TESH%></td>
                                                            <td class="porcent_2" ><%=persent(TESH,suma_sie_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TESM%></td>
                                                            <td class="porcent_2" ><%=persent(TESM,suma_sie_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%if tipo = "SIT" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TTSH%></td>
                                                            <td class="porcent_2" ><%=persent(TTSH,suma_sit_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TTSM%></td>
                                                            <td class="porcent_2" ><%=persent(TTSM,suma_sit_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%
                                                                '************************'--------------- 
                                                                '* Universidad Pregrado	*'
                                                                '************************'
                                                                %>	
                                                            <%
                                                                '****************************'
                                                                '* Universidad Postgrado	*'
                                                                '****************************'---------------
                                                                %>
                                                            <%if institucion = "U" then%>
                                                            <%if tipo = "POG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TGGH%></td>
                                                            <td class="porcent_2" ><%=persent(TGGH,suma_graduados_po_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TGGM%></td>
                                                            <td class="porcent_2" ><%=persent(TGGM,suma_graduados_po_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>	
                                                            <%
                                                                '****************************'---------------
                                                                '* Universidad Postgrado	*'
                                                                '****************************'
                                                                %>
                                                            <%
                                                                '****************'
                                                                '* 	Instituto	*'
                                                                '****************'---------------
                                                                %>
                                                            <%if institucion = "I" then%>
                                                            <%if tipo = "IEG" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TEIH%></td>
                                                            <td class="porcent_1" ><%=persent(TEIH,suma_egresados_i_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TEIM%></td>
                                                            <td class="porcent_1" ><%=persent(TEIM,suma_egresados_i_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%if tipo = "ITI" then%>
                                                            <%if sexo_ccod = "1" then%>
                                                            <td class="porcent_2"><%=TTIH%></td>
                                                            <td class="porcent_1" ><%=persent(TTIH,suma_titulados_i_hombres)%></td>
                                                            <%end if%>
                                                            <%if sexo_ccod = "2" then%>
                                                            <td class="porcent_2"><%=TTIM%></td>
                                                            <td class="porcent_1" ><%=persent(TTIM,suma_titulados_i_mujeres)%></td>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%end if%>
                                                            <%
                                                                '****************'---------------
                                                                '* 	Instituto	*'
                                                                '****************'
                                                                %>
                                                            <%
                                                                '*****************************************************************************************************************'---------
                                                                '**													TOTALES														**'
                                                                '*****************************************************************************************************************'
                                                                %>						
                                                        </tr>
                                                        <%
                                                            sede = sede + 1
                                                            wend
                                                            %> 
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <input type="hidden" name="sede" value="<%=sede_tdesc%>">
                                <input type="hidden" name="registros" value="<%=num%>">
                            </form>
                            <tr>
                                <td align="right"><font size="1">* Presione sobre el n&uacute;mero de inter&eacute;s para visualizar el dato a un detalle mayor.</font></td>
                            </tr>
                            <tr>
                                <td align="right" height="50">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width="7" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
                <tr>
                    <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                    <td height="28">
                        <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="18%" height="20">
                                    <div align="center">
                                        <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <div align="center"><%botonera.dibujaBoton "volver"%></div>
                                                </td>
                                                <td>
                                                    <div id="botonDoc" align="center">
                                                        <% 
                                                            url_2 = "estadisticasEgresoTitulacion/excels/estadisticas_egreso_titulacion_carreras_excel_todos.asp?selectAnioPromo="&selectAnioPromo&"&selectAnioTitu="&selectAnioTitu&"&selectAnioEgre="&selectAnioEgre&"&sede_ccod="&E_sede_ccod &"&tipo="&E_tipo&"&sexo_ccod="&E_sexo_ccod&"&institucion="&E_institucion&"&facu_ccod="&E_facu_ccod&"&carr_ccod="&E_carr_ccod
                                                             botonera.agregaBotonParam "excel_2","funcion","abreEcxel('"&url_2&"')"
                                                            botonera.dibujaBoton "excel_2"
                                                            %>
                                                    </div>
                                                </td>
												<td>
													<div id="botonReportePrincipal" align="center">
														<% 
															url_2 = "estadisticasEgresoTitulacion/excels/gran_detalle_2_1.asp?upa_pregrado="&upa_pregrado&"&upa_postgrado="&upa_postgrado&"&instituto="&instituto&"&egresados="&egresados&"&titulados="&titulados&"&graduados="&graduados&"&salidas_int="&salidas_int&"&femenino="&femenino&"&masculino="&masculino&"&facu_ccod="&E_facu_ccod&"&carr_ccod="&E_carr_ccod&"&selectAnioPromo="&selectAnioPromo&"&selectAnioEgre="&selectAnioEgre&"&selectAnioTitu="&selectAnioTitu
															'   'response.Write(url_2)
															botonera.agregaBotonParam "excel_general","funcion","abreEcxel('"&url_2&"')"
															botonera.dibujaBoton "excel_general"
														%>
													</div>
												</td>			
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                            </tr>
                            <tr>
                                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
                            </tr>
                        </table>
                    </td>
                    <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
            </table>
            <br>
            <br>
        </td>
    </tr>
</table>