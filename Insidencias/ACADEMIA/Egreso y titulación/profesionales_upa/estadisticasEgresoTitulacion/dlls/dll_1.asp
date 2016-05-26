<%
'---------------------------------------------------------------------------------------------
'*************************************************************************************************************************************************************
'**																																							**
'**														FUNCIONES PARA LAS CONSULTAS																		**
'**																																							**
'*************************************************************************************************************************************************************---------------
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
'----------------------------------------------------------------Manejo fechas___>>	
' funcion que recibe la feca de egreso y la de titulación y si la 
' de titulación es menor las cambia de posición, Entrega verdadero o falso.
'ej: manejaFecha( 01/01/2000, 01/02/2000) = true
function manejaFecha( egreso, titulacion)
	if IsDate(egreso) then  
		if IsDate(titulacion) then  
			fechaEgreso	= cDate(egreso) 
			fechaTitulo	= cDate(titulacion)
			if (fechaEgreso > fechaTitulo) then
				manejaFecha = true
			end if
		end if
	end if	
	manejaFecha = false
end function
'----------------------------------------------------------------Manejo fechas___<<	
function insertarCampo(num,rut,nombre,sexo,nacimiento,institu,sede,facultad,carrera,gradoAcademico,especialidad,jornada,egresado,fecha_egreso,titulado,fecha_titulo,pregrado,postgrado,ano_ingreso,email,fono_p,celular,facebook,twitter,lindkedin,pais,region,ciudad,comuna,calle,nro,depto,condominio,villa,localidad,ciudad_ext,region_ext,empresa,rubro,depto_2,cargo,email_laboral,web,usuario,fecha_modificacion,tipo_contacto,recibir_info,est_defun)
	if nacimiento = " " then
		nacimiento = "No existee"
	end if
'----------------------------------------------------------------Manejo fechas___>>	
if manejaFecha( fecha_egreso, fecha_titulo) then
	aux_var = fecha_egreso
	fecha_egreso = fecha_titulo
	fecha_titulo = aux_var
end if
'----------------------------------------------------------------Manejo fechas___<<	
	%>
	<tr>
		<td><%=existeInfo(Cstr(	num					))%></td>
		<td><%=existeInfo(Cstr(	rut					))%></td>						
		<td><%=existeInfo(Cstr(	nombre				))%></td>		
		<td><%=existeInfo(Cstr(	sexo				))%></td> 		
		<td><%=existeInfo(Cstr(	nacimiento			))%></td> 	
		<td><%=existeInfo(Cstr(	sede				))%></td> 
		<%if instituto <> 1 then%>	
			<td><%=existeInfo(Cstr(	facultad			))%></td>
		<%end if%>		
		<td><%=existeInfo(Cstr(	carrera				))%></td>		
		<td><%=existeInfo(Cstr(	gradoAcademico		))%></td>
		<td><%=existeInfo(Cstr(	especialidad		))%></td>					
		<td><%=existeInfo(Cstr(	jornada				))%></td> 			
		<td><%=existeInfo(Cstr(	egresado			))%></td> 			
		<td><%=existeInfo(Cstr(	fecha_egreso		))%></td> 		
		<td><%=existeInfo(Cstr(	titulado			))%></td> 			
		<td><%=existeInfo(Cstr(	fecha_titulo		))%></td> 		
		<td><%=existeInfo(Cstr(	pregrado			))%></td>			
		<td><%=existeInfo(Cstr(	postgrado			))%></td>  			
		<td><%=existeInfo(Cstr(	ano_ingreso			))%></td> 		
		<td><%=existeInfo(Cstr(	email				))%></td> 				
		<td><%=existeInfo(Cstr(	fono_p				))%></td> 				
		<td><%=existeInfo(Cstr(	celular				))%></td> 			
		<td><%=existeInfo(Cstr(	facebook			))%></td>  			
		<td><%=existeInfo(Cstr(	twitter				))%></td>   			
		<td><%=existeInfo(Cstr(	lindkedin			))%></td> 			
		<td><%=existeInfo(Cstr(	pais				))%></td>	                 
		<td><%=existeInfo(Cstr(	region				))%></td>	               
		<td><%=existeInfo(Cstr(	ciudad				))%></td>	               
		<td><%=existeInfo(Cstr(	comuna				))%></td>	               
		<td><%=existeInfo(Cstr(	calle				))%></td>	                
		<td><%=existeInfo(Cstr(	nro					))%></td>	                  
		<td><%=existeInfo(Cstr(	depto				))%></td>	                
		<td><%=existeInfo(Cstr(	condominio			))%></td>          
		<td><%=existeInfo(Cstr(	villa				))%></td>               
		<td><%=existeInfo(Cstr(	localidad			))%></td>           
		<td><%=existeInfo(Cstr(	ciudad_ext			))%></td>          
		<td><%=existeInfo(Cstr(	region_ext			))%></td>          
		<td><%=existeInfo(Cstr(	empresa				))%></td>             
		<td><%=existeInfo(Cstr(	rubro				))%></td>               
		<td><%=existeInfo(Cstr(	depto_2				))%></td>               
		<td><%=existeInfo(Cstr(	cargo				))%></td>               
		<td><%=existeInfo(Cstr(	email_laboral		))%></td>       
		<td><%=existeInfo(Cstr(	web					))%></td>                 
		<td><%=existeInfo(Cstr(	usuario				))%></td>             
		<td><%=existeInfo(Cstr(	fecha_modificacion	))%></td> 	
		<td><%=existeInfo(Cstr( tipo_contacto		))%></td>       
		<td><%=existeInfo(Cstr(	recibir_info        ))%></td>        
		<td><%=existeInfo(Cstr(	est_defun        	))%></td> 
		</tr>
	<%
end function
'****************'--------------------------
'** FUNCIONES  **'
'****************'

'*****************'
'** ENCABEZADO  **'
'*****************'--------------------------
function encabezado(upa_pregrado, upa_postgrado, instituto, egresados, titulados, graduados, salidas_int, femenino, masculino, institucion)
%>

<table width="100%" border="0">  
<div id="fecha">
	<table>
		<tr>
			<td colspan="3" style="border-bottom:solid; border-bottom-color:#666;" width="77%" align="left"><strong><%RESPONSE.WRITE("REPORTE GENERAL")%></strong></td>
		</tr>
	</table>
</div>  
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0">
<%
estado =""
if upa_pregrado = 1 then 
 institucion = "UPA Pre-Grado"
end if 
if upa_postgrado = 1 then 
 institucion = "UPA Post-Grado"
end if 
if instituto = 1 then 
 institucion = "Instituto"
end if 
'-------------------------
if egresados = 1 then 
	if estado <> "" then
		estado = estado&", Egresados"
	else
		estado = "Egresados"	
	end if 
end if 
if titulados = 1 then 
	if estado <> "" then
		estado = estado&", Titulados"
	else
		estado = "Titulados"	
	end if 
end if 
if graduados = 1 then 
	if estado <> "" then
		estado = estado&", Graduados"
	else
		estado = "Graduados"	
	end if 
end if 
if salidas_int = 1 then 
	if estado <> "" then
		estado = estado&", Salidas intermedias"
	else
		estado = "Salidas intermedias"	
	end if 
end if 
sexos = ""
if femenino = 1 then 
	if sexos <> "" then
		sexos = sexos&", Femenino"
	else
		sexos = "Femenino"	
	end if 
end if 
if masculino = 1 then 
	if sexos <> "" then
		sexos = sexos&", masculino"
	else
		sexos = "masculino"	
	end if 
end if 
%>

   					<tr>
						<td width="3%"><strong>Institución</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=institucion%></td>
						<td width="77%" colspan="44" align="left">&nbsp;</td>
					</tr>
					
					<tr>
						<td width="3%"><strong>Estado</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=estado%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Sexo</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=sexos%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Carrera</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=carr_tdescA%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
<% if instituto <> 1 then	'Instituto no tiene facultades.  
%> 					
					<tr>
						<td width="3%"><strong>Facultad</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=facu_tdescA%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>	
<% end if %>					
					<tr>
						<td width="3%"><strong>Fecha</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=fecha1%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr><td colspan="46">&nbsp;</td></tr>
					<tr><td colspan="46">&nbsp;</td></tr>
</table>				
<%
end function
'*****************'--------------------------
'** ENCABEZADO  **'
'*****************'

'*******************'
'** PRIMERA fILA  **'
'*******************'--------------------------
sub PrimeraFila()
%>
	<tr >
		<td class="cabecera">N°</td>
		<td class="cabecera">RUT</td>
		<td class="cabecera">NOMBRE</td>
		<td class="cabecera">SEXO</td>
		<td class="cabecera">FECHA NAC.</td>
		<td class="cabecera">SEDE</td>
		<% if instituto <> 1 then%>
		<td class="cabecera">FACULTAD</td>
		<%end if%>
		<td class="cabecera">CARRERA</td>
		<td class="cabecera">GRADO</td>
		<td class="cabecera">ESPECIALIDAD</td>
		<td class="cabecera">JORNADA</td>
        <td class="cabecera">EGRESADO</td>		
        <td class="cabecera">FECHA EGRESO</td>
        <td class="cabecera">TITULADO</td>
		<td class="cabecera">FECHA TITULO</td>
        <td class="cabecera">PREGRADO</td>
		<td class="cabecera">POSTGRADO</td>
        <td class="cabecera">AÑO INGRESO</td>
		<td class="cabecera">EMAIL</td>
        <td class="cabecera">TELÉFONO PERSONAL</td>
        <td class="cabecera">CELULAR</td>	
		<td class="cabecera">FACEBOOK</td>
        <td class="cabecera">TWITTER</td>
        <td class="cabecera">LINDKEDIN</td>
		<td class="cabecera">PAIS</td>
        <td class="cabecera">REGION</td>
        <td class="cabecera">CIUDAD</td>
		<td class="cabecera">COMUNA</td>
        <td class="cabecera">CALLE</td>
        <td class="cabecera">NÚMERO</td>
		<td class="cabecera">DEPTO</td>
		<td class="cabecera">CONDOMINIO</td>
        <td class="cabecera">VILLA</td>
        <td class="cabecera">LOCALIDAD</td>
		<td class="cabecera">CIUDAD EXTRANJERO</td>
        <td class="cabecera">REGIÓN EXTRANJERO</td>
		<td class="cabecera">EMPRESA</td>
		<td class="cabecera">RUBRO</td>
		<td class="cabecera">DEPARTAMENTO</td>
		<td class="cabecera">CARGO</td>
		<td class="cabecera">EMAIL LABORAL</td>
		<td class="cabecera">WEB_EMPRESA</td>
		<td class="cabecera">QUIEN MODIFICA</td>
		<td class="cabecera">FECHA MOD.</td>
		<td class="cabecera">TIPO DE CONTACTO</td>
		<td class="cabecera">RECIBIR INFO.</td>
		<td class="cabecera">FECHA DEFUNCIÓN.</td>
	</tr>
<%
end sub
'*******************'--------------------------
'** PRIMERA fILA  **'
'*******************'
'Esta función hace el select de los reportes detallados.
'******************************'
'** 	 TROZO SELECT 1 	 **'
'******************************'--------------------------
function selectUnoInter(institucion, sede_tdesc, v_anio_egreso, v_anio_titula)
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
"                isnull((select sexo_tdesc                                                                                                                          "& vbCrLf &_
"                        from   sexos ttt                                                                                                                           "& vbCrLf &_
"                        where  ttt.sexo_ccod = isnull(f.sexo_ccod, g.sexo_ccod)), 'Sin info.')                                            as sexo,                 "& vbCrLf &_
"                isnull(protic.trunc(isnull(f.pers_fnacimiento, g.pers_fnacimiento)), 'Sin info.')                                         as nacimiento,           "& vbCrLf &_
"                '"&institucion&"'                                                                                                         as institu,              "& vbCrLf &_
"                '"&sede_tdesc&"'                                                                                                          as sede,                 "& vbCrLf &_
"                isnull(e.facu_tdesc, 'Sin info.')                                                                                         as facultad,             "& vbCrLf &_
"                isnull(b.saca_tdesc, 'Sin info.')                                                                                         as carrera,              "& vbCrLf &_
"				 'Profesional' 														   													   as gradoAcademico,		"& vbCrLf &_
"                ' '                                                                                                                       as especialidad,         "& vbCrLf &_
"                isnull((select top 1 t4.jorn_tdesc                                                                                                                 "& vbCrLf &_
"                        from   alumnos tt (nolock),                                                                                                                "& vbCrLf &_
"                               ofertas_academicas t2,                                                                                                              "& vbCrLf &_
"                               especialidades t3,                                                                                                                  "& vbCrLf &_
"                               jornadas t4                                                                                                                         "& vbCrLf &_
"                        where  tt.ofer_ncorr = t2.ofer_ncorr                                                                                                       "& vbCrLf &_
"                               and t2.espe_ccod = t3.espe_ccod                                                                                                     "& vbCrLf &_
"                               and tt.emat_ccod <> 9                                                                                                               "& vbCrLf &_
"                               and tt.pers_ncorr = a.pers_ncorr                                                                                                    "& vbCrLf &_
"                               and t3.carr_ccod = c.carr_ccod                                                                                                      "& vbCrLf &_
"                               and t2.jorn_ccod = t4.jorn_ccod                                                                                                     "& vbCrLf &_
"                        order  by t2.peri_ccod desc), 'Sin info.')                                                                        as jornada,              "& vbCrLf &_
"                isnull((select case count(*)                                                                                                                       "& vbCrLf &_
"                                 when 0 then 'NO'                                                                                                                  "& vbCrLf &_
"                                 else 'SI'                                                                                                                         "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   detalles_titulacion_carrera ttt (nolock)                                                                                            "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.carr_ccod = c.carr_ccod                                                                                                     "& vbCrLf &_
"                               and isnull(protic.trunc(ttt.fecha_egreso), '') <> ''), 'Sin info.')                                        as egresado,             "& vbCrLf &_
"                isnull((select top 1 protic.trunc(fecha_egreso)                                                                                                    "& vbCrLf &_
"                        from   detalles_titulacion_carrera ttt (nolock)                                                                                            "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.carr_ccod = c.carr_ccod                                                                                                     "& vbCrLf &_
"                               and datepart(year, ttt.fecha_egreso) = case "&v_anio_egreso&"                                                                       "& vbCrLf &_
"                                                                        when '0' then datepart(year, ttt.fecha_egreso)                                             "& vbCrLf &_
"                                                                        else "&v_anio_egreso&"                                                                     "& vbCrLf &_
"                                                                      end                                                                                          "& vbCrLf &_
"                               and isnull(protic.trunc(ttt.fecha_egreso), '') <> ''), 'Sin info.')                                        as fecha_egreso,         "& vbCrLf &_
"                isnull((select case count(*)                                                                                                                       "& vbCrLf &_
"                                 when 0 then 'NO'                                                                                                                  "& vbCrLf &_
"                                 else 'SI'                                                                                                                         "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   alumnos ttt (nolock)                                                                                            					"& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.emat_ccod = 8                                                                                                     			"& vbCrLf &_
"                               ), 'Sin info.')                                    														   as titulado,				"& vbCrLf &_ 
"isnull((select top 1 protic.trunc(bb.asca_fsalida) 																                                                "& vbCrLf &_
"from   detalles_titulacion_carrera aa                                                                                                                              "& vbCrLf &_
"       inner join alumnos_salidas_carrera as bb                                                                                                                    "& vbCrLf &_
"               on aa.pers_ncorr = bb.pers_ncorr                                                                                                                    "& vbCrLf &_
"                  and Cast(bb.pers_ncorr as varchar) = a.pers_ncorr                                                                                                "& vbCrLf &_
"       inner join salidas_carrera as cc                                                                                                                            "& vbCrLf &_
"               on aa.plan_ccod = cc.plan_ccod                                                                                                                      "& vbCrLf &_
"                  and bb.saca_ncorr = cc.saca_ncorr                                                                                                                "& vbCrLf &_
"				   and cc.TSCA_CCOD not in (5)																														"& vbCrLf &_	
"where  Cast(cc.plan_ccod as varchar) = r.plan_ccod                                                                                                                 "& vbCrLf &_
"       and aa.carr_ccod = c.carr_ccod ), 'Sin info.')                                                                                     as fecha_titulo,         "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                   "& vbCrLf &_
"                  when 1 then 'SI'                                                                                                                                 "& vbCrLf &_
"                  else ''                                                                                                                                          "& vbCrLf &_
"                end                                                                                                                       as pregrado,             "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                   "& vbCrLf &_
"                  when 2 then 'SI'                                                                                                                                 "& vbCrLf &_
"                  else ''                                                                                                                                          "& vbCrLf &_
"                end                                                                                                                       as postgrado,            "& vbCrLf &_
"                isnull(cast(protic.ano_ingreso_carrera_egresa2(isnull(f.pers_ncorr, g.pers_ncorr), c.carr_ccod) as varchar), 'Sin info.') as ano_ingreso,          "& vbCrLf &_
"                isnull(f.pers_temail, 'Sin info.')                                                                                        as email,                "& vbCrLf &_
"                isnull(f.pers_tfono, 'Sin info.')                                                                                         as fono_p,               "& vbCrLf &_
"                isnull(f.pers_tcelular, 'Sin info.')                                                                                      as celular,              "& vbCrLf &_
"                ' '                                                                                                                       as facebook,             "& vbCrLf &_
"                ' '                                                                                                                       as twitter,              "& vbCrLf &_
"                ' '                                                                                                                       as lindkedin,            "& vbCrLf &_
"                isnull((select pais_tdesc                                                                                                                          "& vbCrLf &_
"                        from   paises ttt                                                                                                                          "& vbCrLf &_
"                        where  ttt.pais_ccod = f.pais_ccod), 'Sin info.')                                                                 as pais,                 "& vbCrLf &_
"                isnull((select tt3.regi_tdesc                                                                                                                      "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2,                                                                                                                       "& vbCrLf &_
"                               regiones tt3                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod                                                                                                   "& vbCrLf &_
"                               and tt2.regi_ccod = tt3.regi_ccod), 'Sin info.')                                                           as region,               "& vbCrLf &_
"                isnull((select tt2.ciud_tcomuna                                                                                                                    "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod), 'Sin info.')                                                           as ciudad,               "& vbCrLf &_
"                isnull((select tt2.ciud_tdesc                                                                                                                      "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod), 'Sin info.')                                                           as comuna,               "& vbCrLf &_
"                isnull((select ttt.dire_tcalle                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as calle,                "& vbCrLf &_
"                isnull((select ttt.dire_tnro                                                                                                                       "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as nro,                  "& vbCrLf &_
"                isnull((select ttt.dire_tblock                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as depto,                "& vbCrLf &_
"                isnull((select ttt.dire_tpoblacion                                                                                                                 "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as condominio,           "& vbCrLf &_
"                isnull((select ttt.dire_tdepto                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as villa,                "& vbCrLf &_
"                isnull((select ttt.dire_tlocalidad                                                                                                                 "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as localidad,            "& vbCrLf &_
"                isnull(f.ciud_particular, 'Sin info.')                                                                                    as ciudad_ext,           "& vbCrLf &_
"                isnull(f.regi_particular, 'Sin info.')                                                                                    as region_ext,           "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_nombre_empresa                                                                                                       "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as empresa,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_rubro_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as rubro,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_depto_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as depto_2,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_cargo_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as cargo,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_email_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as email_laboral,        "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_web_empresa                                                                                                          "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as web,                  "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp(f.pers_ncorr, 2), 'Sin info.')                                                      as usuario,              "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp (f.pers_ncorr, 1), 'Sin info.')                                                     as fecha_modificacion,   "& vbCrLf &_
"                isnull((select case dae.tipo_contacto                                                                                                              "& vbCrLf &_
"                                 when 'P' then 'Particular'                                                                                                        "& vbCrLf &_
"                                 when 'C' then 'Comercial'                                                                                                         "& vbCrLf &_
"                                 else ''                                                                                                                           "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                              "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                               as tipo_contacto,        "& vbCrLf &_
"                isnull((select recibir_info                                                                                                                        "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                              "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                               as recibir_info,         "& vbCrLf &_
"                case (select isnull(PERS_FDEFUNCION, 0)                                                                                                            "& vbCrLf &_
"                        from   alumni_personas	dae						                                                                                            "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr)                                                                                                      "& vbCrLf &_
"                  when  0 then 'N/A'                                                                                                                          		"& vbCrLf &_
"				 else                                                                                                                                               "& vbCrLf &_
"					(select protic.trunc(PERS_FDEFUNCION)                                                                                                           "& vbCrLf &_
"                        from   alumni_personas	dae						                                                                                            "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr)                                                                                        				"& vbCrLf &_
"                end                                                                                                                       as estado_defun          "







selectUnoInter = select_1
end function
function selectUno(institucion, sede_tdesc, v_anio_egreso, v_anio_titula)

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
"                isnull((select sexo_tdesc                                                                                                                          "& vbCrLf &_
"                        from   sexos ttt                                                                                                                           "& vbCrLf &_
"                        where  ttt.sexo_ccod = isnull(f.sexo_ccod, g.sexo_ccod)), 'Sin info.')                                            as sexo,                 "& vbCrLf &_
"                isnull(protic.trunc(isnull(f.pers_fnacimiento, g.pers_fnacimiento)), 'Sin info.')                                         as nacimiento,           "& vbCrLf &_
"                '"&institucion&"'                                                                                                         as institu,              "& vbCrLf &_
"                '"&sede_tdesc&"'                                                                                                          as sede,                 "& vbCrLf &_
"                isnull(e.facu_tdesc, 'Sin info.')                                                                                         as facultad,             "& vbCrLf &_
"                isnull(c.carr_tdesc, 'Sin info.')                                                                                         as carrera,              "& vbCrLf &_
"				 'Profesional' 														   													   as gradoAcademico,		"& vbCrLf &_
"                ' '                                                                                                                       as especialidad,         "& vbCrLf &_
"                isnull((select top 1 t4.jorn_tdesc                                                                                                                 "& vbCrLf &_
"                        from   alumnos tt (nolock),                                                                                                                "& vbCrLf &_
"                               ofertas_academicas t2,                                                                                                              "& vbCrLf &_
"                               especialidades t3,                                                                                                                  "& vbCrLf &_
"                               jornadas t4                                                                                                                         "& vbCrLf &_
"                        where  tt.ofer_ncorr = t2.ofer_ncorr                                                                                                       "& vbCrLf &_
"                               and t2.espe_ccod = t3.espe_ccod                                                                                                     "& vbCrLf &_
"                               and tt.emat_ccod <> 9                                                                                                               "& vbCrLf &_
"                               and tt.pers_ncorr = a.pers_ncorr                                                                                                    "& vbCrLf &_
"                               and t3.carr_ccod = c.carr_ccod                                                                                                      "& vbCrLf &_
"                               and t2.jorn_ccod = t4.jorn_ccod                                                                                                     "& vbCrLf &_
"                        order  by t2.peri_ccod desc), 'Sin info.')                                                                        as jornada,              "& vbCrLf &_
"                isnull((select case count(*)                                                                                                                       "& vbCrLf &_
"                                 when 0 then 'NO'                                                                                                                  "& vbCrLf &_
"                                 else 'SI'                                                                                                                         "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   detalles_titulacion_carrera ttt (nolock)                                                                                            "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.carr_ccod = c.carr_ccod                                                                                                     "& vbCrLf &_
"                               and isnull(protic.trunc(ttt.fecha_egreso), '') <> ''), 'Sin info.')                                        as egresado,             "& vbCrLf &_
"                isnull((select top 1 protic.trunc(fecha_egreso)                                                                                                    "& vbCrLf &_
"                        from   detalles_titulacion_carrera ttt (nolock)                                                                                            "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.carr_ccod = c.carr_ccod                                                                                                     "& vbCrLf &_
"                               and datepart(year, ttt.fecha_egreso) = case "&v_anio_egreso&"                                                                       "& vbCrLf &_
"                                                                        when '0' then datepart(year, ttt.fecha_egreso)                                             "& vbCrLf &_
"                                                                        else "&v_anio_egreso&"                                                                     "& vbCrLf &_
"                                                                      end                                                                                          "& vbCrLf &_
"                               and isnull(protic.trunc(ttt.fecha_egreso), '') <> ''), 'Sin info.')                                        as fecha_egreso,         "& vbCrLf &_
"                isnull((select case count(*)                                                                                                                       "& vbCrLf &_
"                                 when 0 then 'NO'                                                                                                                  "& vbCrLf &_
"                                 else 'SI'                                                                                                                         "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   alumnos ttt (nolock)                                                                                            					"& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr                                                                                                       "& vbCrLf &_
"                               and ttt.emat_ccod = 8                                                                                                     			"& vbCrLf &_
"                               ), 'Sin info.')                                    														   as titulado,				"& vbCrLf &_ 
"isnull((select top 1 protic.trunc(bb.asca_fsalida) 																                                                "& vbCrLf &_
"from   detalles_titulacion_carrera aa                                                                                                                              "& vbCrLf &_
"       inner join alumnos_salidas_carrera as bb                                                                                                                    "& vbCrLf &_
"               on aa.pers_ncorr = bb.pers_ncorr                                                                                                                    "& vbCrLf &_
"                  and Cast(bb.pers_ncorr as varchar) = a.pers_ncorr                                                                                                "& vbCrLf &_
"       inner join salidas_carrera as cc                                                                                                                            "& vbCrLf &_
"               on aa.plan_ccod = cc.plan_ccod                                                                                                                      "& vbCrLf &_
"                  and bb.saca_ncorr = cc.saca_ncorr                                                                                                                "& vbCrLf &_
"				   and cc.TSCA_CCOD not in (5)																														"& vbCrLf &_	
"where  Cast(cc.plan_ccod as varchar) = a.plan_ccod                                                                                                                 "& vbCrLf &_
"       and aa.carr_ccod = c.carr_ccod ), 'Sin info.')                                                                                     as fecha_titulo,         "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                   "& vbCrLf &_
"                  when 1 then 'SI'                                                                                                                                 "& vbCrLf &_
"                  else ''                                                                                                                                          "& vbCrLf &_
"                end                                                                                                                       as pregrado,             "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                   "& vbCrLf &_
"                  when 2 then 'SI'                                                                                                                                 "& vbCrLf &_
"                  else ''                                                                                                                                          "& vbCrLf &_
"                end                                                                                                                       as postgrado,            "& vbCrLf &_
"                isnull(cast(protic.ano_ingreso_carrera_egresa2(isnull(f.pers_ncorr, g.pers_ncorr), c.carr_ccod) as varchar), 'Sin info.') as ano_ingreso,          "& vbCrLf &_
"                isnull(f.pers_temail, 'Sin info.')                                                                                        as email,                "& vbCrLf &_
"                isnull(f.pers_tfono, 'Sin info.')                                                                                         as fono_p,               "& vbCrLf &_
"                isnull(f.pers_tcelular, 'Sin info.')                                                                                      as celular,              "& vbCrLf &_
"                ' '                                                                                                                       as facebook,             "& vbCrLf &_
"                ' '                                                                                                                       as twitter,              "& vbCrLf &_
"                ' '                                                                                                                       as lindkedin,            "& vbCrLf &_
"                isnull((select pais_tdesc                                                                                                                          "& vbCrLf &_
"                        from   paises ttt                                                                                                                          "& vbCrLf &_
"                        where  ttt.pais_ccod = f.pais_ccod), 'Sin info.')                                                                 as pais,                 "& vbCrLf &_
"                isnull((select tt3.regi_tdesc                                                                                                                      "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2,                                                                                                                       "& vbCrLf &_
"                               regiones tt3                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod                                                                                                   "& vbCrLf &_
"                               and tt2.regi_ccod = tt3.regi_ccod), 'Sin info.')                                                           as region,               "& vbCrLf &_
"                isnull((select tt2.ciud_tcomuna                                                                                                                    "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod), 'Sin info.')                                                           as ciudad,               "& vbCrLf &_
"                isnull((select tt2.ciud_tdesc                                                                                                                      "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                             "& vbCrLf &_
"                               ciudades tt2                                                                                                                        "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr                                                                                                   "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod), 'Sin info.')                                                           as comuna,               "& vbCrLf &_
"                isnull((select ttt.dire_tcalle                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as calle,                "& vbCrLf &_
"                isnull((select ttt.dire_tnro                                                                                                                       "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as nro,                  "& vbCrLf &_
"                isnull((select ttt.dire_tblock                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as depto,                "& vbCrLf &_
"                isnull((select ttt.dire_tpoblacion                                                                                                                 "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as condominio,           "& vbCrLf &_
"                isnull((select ttt.dire_tdepto                                                                                                                     "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as villa,                "& vbCrLf &_
"                isnull((select ttt.dire_tlocalidad                                                                                                                 "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                              "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                   "& vbCrLf &_
"                               and ttt.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                           as localidad,            "& vbCrLf &_
"                isnull(f.ciud_particular, 'Sin info.')                                                                                    as ciudad_ext,           "& vbCrLf &_
"                isnull(f.regi_particular, 'Sin info.')                                                                                    as region_ext,           "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_nombre_empresa                                                                                                       "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as empresa,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_rubro_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as rubro,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_depto_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as depto_2,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_cargo_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as cargo,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_email_empresa                                                                                                        "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as email_laboral,        "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_web_empresa                                                                                                          "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                 "& vbCrLf &_
"                        where  dlp.pers_ncorr = f.pers_ncorr                                                                                                       "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                              as web,                  "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp(f.pers_ncorr, 2), 'Sin info.')                                                      as usuario,              "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp (f.pers_ncorr, 1), 'Sin info.')                                                     as fecha_modificacion,   "& vbCrLf &_
"                isnull((select case dae.tipo_contacto                                                                                                              "& vbCrLf &_
"                                 when 'P' then 'Particular'                                                                                                        "& vbCrLf &_
"                                 when 'C' then 'Comercial'                                                                                                         "& vbCrLf &_
"                                 else ''                                                                                                                           "& vbCrLf &_
"                               end                                                                                                                                 "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                              "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                               as tipo_contacto,        "& vbCrLf &_
"                isnull((select recibir_info                                                                                                                        "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                              "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr), 'Sin info.')                                                               as recibir_info,         "& vbCrLf &_
"                case (select isnull(PERS_FDEFUNCION, 0)                                                                                                            "& vbCrLf &_
"                        from   alumni_personas	dae						                                                                                            "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr)                                                                                                      "& vbCrLf &_
"                  when  0 then 'N/A'                                                                                                                          		"& vbCrLf &_
"				 else                                                                                                                                               "& vbCrLf &_
"					(select protic.trunc(PERS_FDEFUNCION)                                                                                                           "& vbCrLf &_
"                        from   alumni_personas	dae						                                                                                            "& vbCrLf &_
"                        where  dae.pers_ncorr = f.pers_ncorr)                                                                                        				"& vbCrLf &_
"                end                                                                                                                       as estado_defun          "




selectUno = select_1
end function
'******************************'--------------------------
'** 	 TROZO SELECT 1 	 **'
'******************************'
'******************************'
'** 	 TROZO SELECT 2 	 **'
'******************************'--------------------------
function selectDos(institucion, sede_tdesc, v_anio_egreso, v_anio_titula)
select_2 = ""& vbCrLf &_
"select distinct cast(a.pers_ncorr as varchar) + '-' 																														"& vbCrLf &_
"                + ltrim(rtrim(c.carr_ccod))                                                                                                       as pers_ncorr_carr_ccod,	"& vbCrLf &_
"                cast(isnull(g.pers_nrut, a.pers_nrut) as varchar)                                                                                                          "& vbCrLf &_
"                + '-'                                                                                                                                                      "& vbCrLf &_
"                + isnull(g.pers_xdv, a.pers_xdv collate sql_latin1_general_cp1_ci_as)                                                             as rut,                  "& vbCrLf &_
"                isnull(( g.pers_tape_paterno + ' '                                                                                                                         "& vbCrLf &_
"                         + g.pers_tape_materno + ', ' + g.pers_tnombre ), ( a.apellidos + ' ' + a.nombres collate sql_latin1_general_cp1_ci_as )) as nombre,               "& vbCrLf &_
"                isnull((select tttt.sexo_tdesc                                                                                                                             "& vbCrLf &_
"                        from   alumni_personas ttt,                                                                                                                        "& vbCrLf &_
"                               sexos tttt                                                                                                                                  "& vbCrLf &_
"                        where  ttt.pers_ncorr = isnull(g.pers_ncorr, a.pers_ncorr)                                                                                         "& vbCrLf &_
"                               and ttt.sexo_ccod = tttt.sexo_ccod), '')                                                                           as sexo,                 "& vbCrLf &_
"                isnull((select protic.trunc(a_per.pers_fnacimiento)                                                                                                        "& vbCrLf &_
"                        from   alumni_personas as a_per                                                                                                                    "& vbCrLf &_
"                        where  a_per.pers_ncorr = isnull(g.pers_ncorr, a.pers_ncorr)), '')                                                        as nacimiento,           "& vbCrLf &_
"                '"&institucion&"'                                                                                                                 as institu,              "& vbCrLf &_
"                '"&sede_tdesc&"'                                                                                                                  as sede,                 "& vbCrLf &_
"                isnull(e.facu_tdesc, 'Sin info.')                                                                                                 as facultad,             "& vbCrLf &_
"                isnull(c.carr_tdesc, 'Sin info.')                                                                                                 as carrera,              "& vbCrLf &_
"				isnull( (a.nivel_carrera), 'Sin info.') 														   		   						   as gradoAcademico,		"& vbCrLf &_
"                ''                                                                                                                                as especialidad,         "& vbCrLf &_
"                isnull((select top 1 t4.jorn_tdesc                                                                                                                         "& vbCrLf &_
"                        from   alumnos tt (nolock),                                                                                                                        "& vbCrLf &_
"                               ofertas_academicas t2,                                                                                                                      "& vbCrLf &_
"                               especialidades t3,                                                                                                                          "& vbCrLf &_
"                               jornadas t4                                                                                                                                 "& vbCrLf &_
"                        where  tt.ofer_ncorr = t2.ofer_ncorr                                                                                                               "& vbCrLf &_
"                               and t2.espe_ccod = t3.espe_ccod                                                                                                             "& vbCrLf &_
"                               and tt.emat_ccod <> 9                                                                                                                       "& vbCrLf &_
"                               and tt.pers_ncorr = isnull(g.pers_ncorr, a.pers_ncorr)                                                                                      "& vbCrLf &_
"                               and t3.carr_ccod = c.carr_ccod                                                                                                              "& vbCrLf &_
"                               and t2.jorn_ccod = t4.jorn_ccod                                                                                                             "& vbCrLf &_
"                        order  by t2.peri_ccod desc), 'Sin info.')                                                                                as jornada,              "& vbCrLf &_ 
"                 case  a.fecha_egreso				                                                                                                                    	"& vbCrLf &_
"                                 when null then 'NO'                                                                                                                       "& vbCrLf &_   
"                                 else case  a.fecha_egreso				                                                                                                	"& vbCrLf &_                
"                                 when '' then 'NO'                                                                                                                         "& vbCrLf &_
"                                 else 'SI' end                                                                                                                             "& vbCrLf &_
"                                 end																											   as egresado,             "& vbCrLf &_
"                isnull(protic.trunc(a.fecha_egreso), 'Sin info.')                                                                                 as fecha_egreso,         "& vbCrLf &_
"                 case  a.fecha_titulacion				                                                                                                                    "& vbCrLf &_
"                                 when null then 'NO'                                                                                                                       "& vbCrLf &_   
"                                 else case  a.fecha_titulacion				                                                                                                "& vbCrLf &_                
"                                 when '' then 'NO'                                                                                                                         "& vbCrLf &_
"                                 else 'SI' end                                                                                                                             "& vbCrLf &_
"                                 end																											   as titulado,             "& vbCrLf &_
"                isnull(protic.trunc(a.fecha_titulacion), 'Sin info.')                                                                             as fecha_titulo,         "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                           "& vbCrLf &_
"                  when 1 then 'SI'                                                                                                                                         "& vbCrLf &_
"                  else ''                                                                                                                                                  "& vbCrLf &_
"                end                                                                                                                               as pregrado,             "& vbCrLf &_
"                case c.tcar_ccod                                                                                                                                           "& vbCrLf &_
"                  when 2 then 'SI'                                                                                                                                         "& vbCrLf &_
"                  else ''                                                                                                                                                  "& vbCrLf &_
"                end                                                                                                                               as postgrado,            "& vbCrLf &_
"                isnull(cast(a.promocion as varchar), 'Sin info.')                                                                                 as ano_ingreso,          "& vbCrLf &_
"                isnull((g.pers_temail), 'Sin info.')                                                                       					   as email,                "& vbCrLf &_
"                isnull(g.pers_tfono, 'Sin info.')                                                              								   as fono_p,               "& vbCrLf &_
"                isnull(g.pers_tcelular, 'Sin info.')                                                               							   as celular,              "& vbCrLf &_
"                ''                                                                                                                                as facebook,             "& vbCrLf &_
"                ''                                                                                                                                as twitter,              "& vbCrLf &_
"                ''                                                                                                                                as lindkedin,            "& vbCrLf &_
"                isnull((select pais_tdesc                                                                                                                                  "& vbCrLf &_
"                        from   paises ttt                                                                                                                                  "& vbCrLf &_
"                        where  ttt.pais_ccod = a.pais_ccod), 'Sin info.')                                                                         as pais,                 "& vbCrLf &_
"                isnull((select tt3.regi_tdesc                                                                                                                              "& vbCrLf &_
"                        from   alumni_direcciones ttt,                                                                                                                     "& vbCrLf &_
"                               ciudades tt2,                                                                                                                               "& vbCrLf &_
"                               regiones tt3                                                                                                                                "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr                                                                                                           "& vbCrLf &_
"                               and ttt.ciud_ccod = tt2.ciud_ccod                                                                                                           "& vbCrLf &_
"                               and tt2.regi_ccod = tt3.regi_ccod), 'Sin info.')                                                                   as region,               "& vbCrLf &_
"                isnull(a.ciudad collate sql_latin1_general_cp1_ci_as, 'Sin info.')                                                                as ciudad,               "& vbCrLf &_
"                isnull(a.comuna collate sql_latin1_general_cp1_ci_as, 'Sin info.')                                                                as comuna,               "& vbCrLf &_
"                isnull((select ttt.dire_tcalle                                                                                                                             "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as calle,                "& vbCrLf &_
"                isnull((select ttt.dire_tnro                                                                                                                               "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as nro,                  "& vbCrLf &_
"                isnull((select ttt.dire_tblock                                                                                                                             "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as depto,                "& vbCrLf &_
"                isnull((select ttt.dire_tpoblacion                                                                                                                         "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as condominio,           "& vbCrLf &_
"                isnull((select ttt.dire_tdepto                                                                                                                             "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as villa,                "& vbCrLf &_
"                isnull((select ttt.dire_tlocalidad                                                                                                                         "& vbCrLf &_
"                        from   alumni_direcciones ttt                                                                                                                      "& vbCrLf &_
"                        where  ttt.tdir_ccod = 2                                                                                                                           "& vbCrLf &_
"                               and ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                   as localidad,            "& vbCrLf &_
"                isnull((select ttt.ciud_particular                                                                                                                         "& vbCrLf &_
"                        from   alumni_personas ttt                                                                                                                         "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                       as ciudad_ext,           "& vbCrLf &_
"                isnull((select ttt.regi_particular                                                                                                                         "& vbCrLf &_
"                        from   alumni_personas ttt                                                                                                                         "& vbCrLf &_
"                        where  ttt.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                       as region_ext,           "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_nombre_empresa                                                                                                               "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as empresa,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_rubro_empresa                                                                                                                "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as rubro,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_depto_empresa                                                                                                                "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as depto_2,              "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_cargo_empresa                                                                                                                "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as cargo,                "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_email_empresa                                                                                                                "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as email_laboral,        "& vbCrLf &_
"                isnull((select top 1 dlp.dlpr_web_empresa                                                                                                                  "& vbCrLf &_
"                        from   alumni_direccion_laboral_profesionales dlp (nolock)                                                                                         "& vbCrLf &_
"                        where  dlp.pers_ncorr = a.pers_ncorr                                                                                                               "& vbCrLf &_
"                        order  by dlp.audi_fmodificacion desc), 'Sin info.')                                                                      as web,                  "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp(a.pers_ncorr, 2), 'Sin info.')                                                              as usuario,              "& vbCrLf &_
"                isnull(protic.ultima_modificacion_cpp (a.pers_ncorr, 1), 'Sin info.')                                                             as fecha_modificacion,   "& vbCrLf &_
"                isnull((select case dae.tipo_contacto                                                                                                                      "& vbCrLf &_
"                                 when 'P' then 'Particular'                                                                                                                "& vbCrLf &_
"                                 when 'C' then 'Comercial'                                                                                                                 "& vbCrLf &_
"                                 else ''                                                                                                                                   "& vbCrLf &_
"                               end                                                                                                                                         "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                                      "& vbCrLf &_
"                        where  dae.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                       as tipo_contacto,        "& vbCrLf &_
"                isnull((select recibir_info                                                                                                                                "& vbCrLf &_
"                        from   alumni_datos_adicionales_egresados dae                                                                                                      "& vbCrLf &_
"                        where  dae.pers_ncorr = a.pers_ncorr), 'Sin info.')                                                                       as recibir_info,         "& vbCrLf &_
"                case isnull(g.PERS_FDEFUNCION, 0)  																														"& vbCrLf &_
"                  when 0 then 'N/A'                                                                                                                               			"& vbCrLf &_
"                  else protic.trunc(g.PERS_FDEFUNCION)                                                                                                                     "& vbCrLf &_
"                end                                                                                                                       		   as estado_defun          "

selectDos = select_2
end function
'******************************'--------------------------
'** 	 TROZO SELECT 2 	 **'
'******************************'

'***********************'
'****	TITULADOS	****'
'***********************'----------------

'*****************************
'**		uniTituladosP1		**
'*****************************----------------
function uniTituladosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
						"from   detalles_titulacion_carrera as a (nolock)                                                                   	"& vbCrLf &_
						"       inner join carreras as c                                                                                    	"& vbCrLf &_
						"               on a.carr_ccod = c.carr_ccod                                                                        	"& vbCrLf &_
						"                  and c.tcar_ccod = 1                                                                              	"& vbCrLf &_
						"                  and c.carr_ccod = case                                                                           	"& vbCrLf &_
						"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                	"& vbCrLf &_
						"                                      else '"&v_carr_ccod&"'                                                       	"& vbCrLf &_
						"                                    end                                                                            	"& vbCrLf &_
						"                  and (select top 1 t2.sede_ccod                                                                   	"& vbCrLf &_
						"                       from   alumnos tt (nolock),                                                                 	"& vbCrLf &_
						"                              ofertas_academicas t2,                                                               	"& vbCrLf &_
						"                              especialidades t3                                                                    	"& vbCrLf &_
						"                       where  tt.ofer_ncorr = t2.ofer_ncorr                                                        	"& vbCrLf &_
						"                              and t2.espe_ccod = t3.espe_ccod                                                      	"& vbCrLf &_
						"                              and tt.emat_ccod <> 9                                                                	"& vbCrLf &_
						"                              and tt.pers_ncorr = a.pers_ncorr                                                     	"& vbCrLf &_
						"                              and t3.carr_ccod = c.carr_ccod                                                       	"& vbCrLf &_
						"                       order  by t2.peri_ccod desc) = '"&v_sede_ccod&"'                                            	"& vbCrLf &_
						"       inner join areas_academicas as d                                                                            	"& vbCrLf &_
						"               on c.area_ccod = d.area_ccod                                                                        	"& vbCrLf &_
						"       inner join facultades as e                                                                                  	"& vbCrLf &_
						"               on d.facu_ccod = e.facu_ccod                                                                        	"& vbCrLf &_
						"                  and e.facu_ccod = case                                                                           	"& vbCrLf &_
						"                                      when '"&v_facu_ccod&"' = '0' then e.facu_ccod                                	"& vbCrLf &_
						"                                      else '"&v_facu_ccod&"'                                                       	"& vbCrLf &_
						"                                    end                                                                            	"& vbCrLf &_
						"       inner join alumni_personas as f (nolock)                                                                    	"& vbCrLf &_
						"               on a.pers_ncorr = f.pers_ncorr                                                                      	"& vbCrLf &_
						"                  and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                  	"& vbCrLf &_
						"       left outer join personas as g                                                                               	"& vbCrLf &_
						"                    on g.pers_ncorr = f.pers_ncorr                                                                 	"& vbCrLf &_
						"where  isnull(protic.trunc(a.fecha_egreso), '') <> ''                                                              	"& vbCrLf &_
						"       and not exists (select 1                                                                                    	"& vbCrLf &_
						"                       from   salidas_carrera tt                                                                   	"& vbCrLf &_
						"                       where  tt.carr_ccod = a.carr_ccod                                                           	"& vbCrLf &_
						"                              and tt.saca_ncorr = a.plan_ccod                                                      	"& vbCrLf &_
						"                              and tt.tsca_ccod = 4)                                                                	"& vbCrLf &_
						"and 'SI' = (select case count(*)                                                                                       "& vbCrLf &_
						"                                 when 0 then 'NO'                                                                      "& vbCrLf &_
						"                                 else 'SI'                                                                             "& vbCrLf &_
						"                               end                                                                                     "& vbCrLf &_
						"                        from   alumnos_salidas_carrera ttt (nolock),                                                   "& vbCrLf &_
						"                               salidas_carrera tt2                                                                     "& vbCrLf &_
						"                        where  ttt.pers_ncorr = a.pers_ncorr                                                           "& vbCrLf &_
						"                               and ttt.saca_ncorr = tt2.saca_ncorr                                                     "& vbCrLf &_
						"                               and tt2.carr_ccod = c.carr_ccod)														"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"'))		"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) 	"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"'))		"& vbCrLf &_					
						"		and (select count(*) from alumnos xxx																			"& vbCrLf &_	
						"			where xxx.PERS_NCORR = a.pers_ncorr                                                                     	"& vbCrLf &_
						"			and xxx.EMAT_CCOD = 8) > 0                                                                   				"	
'response.write("<pre>"&TEXTO&"</pre>")						
			uniTituladosP1 = TEXTO
end function
'*****************************----------------
'**		uniTituladosP1		**
'*****************************

'*****************************
'**		uniTituladosP2		**
'*****************************----------------
function uniTituladosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
						"from   egresados_upa2 as a (nolock)                                                                                "& vbCrLf &_
						"       left outer join alumni_personas as g                                                                        "& vbCrLf &_
						"                    on a.pers_ncorr = g.pers_ncorr                                                                 "& vbCrLf &_
						"       inner join carreras c (nolock)                                                                              "& vbCrLf &_
						"               on a.carr_ccod = c.carr_ccod collate sql_latin1_general_cp1_ci_as                                   "& vbCrLf &_
						"                  and c.tcar_ccod = 1                                                                              "& vbCrLf &_
						"                  and c.carr_ccod = case                                                                           "& vbCrLf &_
						"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                "& vbCrLf &_
						"                                      else '"&v_carr_ccod&"'                                                       "& vbCrLf &_
						"                                    end                                                                            "& vbCrLf &_
						"                  and not exists (select 1                                                                         "& vbCrLf &_
						"                                  from   detalles_titulacion_carrera tt (nolock)                                   "& vbCrLf &_
						"                                  where  tt.pers_ncorr = a.pers_ncorr                                              "& vbCrLf &_
						"                                         and tt.carr_ccod = c.carr_ccod                                            "& vbCrLf &_
						"                                         and isnull(protic.trunc(tt.fecha_egreso), '') <> '')                      "& vbCrLf &_
						"       inner join areas_academicas d                                                                               "& vbCrLf &_
						"               on c.area_ccod = d.area_ccod                                                                        "& vbCrLf &_
						"       inner join facultades e                                                                                     "& vbCrLf &_
						"               on d.facu_ccod = e.facu_ccod                                                                        "& vbCrLf &_
						"                  and e.facu_ccod = case                                                                           "& vbCrLf &_
						"                                      when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                  "& vbCrLf &_
						"                                      else '"&v_facu_ccod&"'                                                       "& vbCrLf &_
						"                                    end                                                                            "& vbCrLf &_
						"where  a.entidad = 'U'                                                                                             "& vbCrLf &_
						"       and a.emat_ccod = 8			                                                                                "& vbCrLf &_
						"       and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                                        "& vbCrLf &_

						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"'))	"& vbCrLf &_
						"       and cast(isnull(a.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                             "& vbCrLf &_
						"		and (select count(*) from alumnos xxx																			"& vbCrLf &_	
						"			where xxx.PERS_NCORR = a.pers_ncorr                                                                     	"& vbCrLf &_
						"			and xxx.EMAT_CCOD = 8) > 0                                                                   				"						
	uniTituladosP2 = TEXTO
end function
'*****************************----------------
'**		uniTituladosP2		**
'*****************************
'***********************'----------------
'****	TITULADOS	****'
'***********************'
'***********************'
'****	EGRESADOS	****'
'***********************'----------------

'*****************************
'**		uniEgresadosP1		**
'*****************************----------------
function uniEgresadosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
						"from   detalles_titulacion_carrera as a (nolock)                                                                   	"& vbCrLf &_
						"       inner join carreras as c                                                                                    	"& vbCrLf &_
						"               on a.carr_ccod = c.carr_ccod                                                                        	"& vbCrLf &_
						"                  and c.tcar_ccod = 1                                                                              	"& vbCrLf &_
						"                  and c.carr_ccod = case                                                                           	"& vbCrLf &_
						"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                	"& vbCrLf &_
						"                                      else '"&v_carr_ccod&"'                                                       	"& vbCrLf &_
						"                                    end                                                                            	"& vbCrLf &_
						"                  and (select top 1 t2.sede_ccod                                                                   	"& vbCrLf &_
						"                       from   alumnos tt (nolock),                                                                 	"& vbCrLf &_
						"                              ofertas_academicas t2,                                                               	"& vbCrLf &_
						"                              especialidades t3                                                                    	"& vbCrLf &_
						"                       where  tt.ofer_ncorr = t2.ofer_ncorr                                                        	"& vbCrLf &_
						"                              and t2.espe_ccod = t3.espe_ccod                                                      	"& vbCrLf &_
						"                              and tt.emat_ccod <> 9                                                                	"& vbCrLf &_
						"                              and tt.pers_ncorr = a.pers_ncorr                                                     	"& vbCrLf &_
						"                              and t3.carr_ccod = c.carr_ccod                                                       	"& vbCrLf &_
						"                       order  by t2.peri_ccod desc) = '"&v_sede_ccod&"'                                            	"& vbCrLf &_
						"       inner join areas_academicas as d                                                                            	"& vbCrLf &_
						"               on c.area_ccod = d.area_ccod                                                                        	"& vbCrLf &_
						"       inner join facultades as e                                                                                  	"& vbCrLf &_
						"               on d.facu_ccod = e.facu_ccod                                                                        	"& vbCrLf &_
						"                  and e.facu_ccod = case                                                                           	"& vbCrLf &_
						"                                      when '"&v_facu_ccod&"' = '0' then e.facu_ccod                                	"& vbCrLf &_
						"                                      else '"&v_facu_ccod&"'                                                       	"& vbCrLf &_
						"                                    end                                                                            	"& vbCrLf &_
						"       inner join alumni_personas as f (nolock)                                                                    	"& vbCrLf &_
						"               on a.pers_ncorr = f.pers_ncorr                                                                      	"& vbCrLf &_
						"                  and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                  	"& vbCrLf &_
						"       left outer join personas as g                                                                               	"& vbCrLf &_
						"                    on g.pers_ncorr = f.pers_ncorr                                                                 	"& vbCrLf &_
						"where  isnull(protic.trunc(a.fecha_egreso), '') <> ''                                                              	"& vbCrLf &_
						"       and not exists (select 1                                                                                    	"& vbCrLf &_
						"                       from   salidas_carrera tt                                                                   	"& vbCrLf &_
						"                       where  tt.carr_ccod = a.carr_ccod                                                           	"& vbCrLf &_
						"                              and tt.saca_ncorr = a.plan_ccod                                                      	"& vbCrLf &_
						"                              and tt.tsca_ccod = 4)                                                                	"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"'))		"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) 	"& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"'))		"                                                        			
			uniEgresadosP1 = TEXTO
end function
'*****************************----------------
'**		uniEgresadosP1		**
'*****************************

'*****************************
'**		uniEgresadosP2		**
'*****************************----------------
function uniEgresadosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
						"from   egresados_upa2 as a (nolock)                                                                                "& vbCrLf &_
						"       left outer join alumni_personas as g                                                                        "& vbCrLf &_
						"                    on a.pers_ncorr = g.pers_ncorr                                                                 "& vbCrLf &_
						"       inner join carreras c (nolock)                                                                              "& vbCrLf &_
						"               on a.carr_ccod = c.carr_ccod collate sql_latin1_general_cp1_ci_as                                   "& vbCrLf &_
						"                  and c.tcar_ccod = 1                                                                              "& vbCrLf &_
						"                  and c.carr_ccod = case                                                                           "& vbCrLf &_
						"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                "& vbCrLf &_
						"                                      else '"&v_carr_ccod&"'                                                       "& vbCrLf &_
						"                                    end                                                                            "& vbCrLf &_
						"                  and not exists (select 1                                                                         "& vbCrLf &_
						"                                  from   detalles_titulacion_carrera tt (nolock)                                   "& vbCrLf &_
						"                                  where  tt.pers_ncorr = a.pers_ncorr                                              "& vbCrLf &_
						"                                         and tt.carr_ccod = c.carr_ccod                                            "& vbCrLf &_
						"                                         and isnull(protic.trunc(tt.fecha_egreso), '') <> '')                      "& vbCrLf &_
						"       inner join areas_academicas d                                                                               "& vbCrLf &_
						"               on c.area_ccod = d.area_ccod                                                                        "& vbCrLf &_
						"       inner join facultades e                                                                                     "& vbCrLf &_
						"               on d.facu_ccod = e.facu_ccod                                                                        "& vbCrLf &_
						"                  and e.facu_ccod = case                                                                           "& vbCrLf &_
						"                                      when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                  "& vbCrLf &_
						"                                      else '"&v_facu_ccod&"'                                                       "& vbCrLf &_
						"                                    end                                                                            "& vbCrLf &_
						"where  a.entidad = 'U'                                                                                             "& vbCrLf &_
						"       and a.emat_ccod = 4			                                                                                "& vbCrLf &_
						"       and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                                        "& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
						"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"'))	"& vbCrLf &_
						"       and cast(isnull(a.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                             "																			
	uniEgresadosP2 = TEXTO
end function
'*****************************----------------
'**		uniEgresadosP2		**
'*****************************
'***********************'----------------
'****	EGRESADOS	****'
'***********************'

'***********************************'
'****	SALIDAS INTERMEDIAS 	****'
'***********************************'----------------
'*************************
'**		sITitulados		**
'*************************----------------
function sITitulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
									"from   alumnos_salidas_carrera a (nolock), 																		"& vbCrLf &_
									"       salidas_carrera b (nolock),                                                         						"& vbCrLf &_
									"       carreras c (nolock),                                                                						"& vbCrLf &_
									"       areas_academicas d,                                                                 						"& vbCrLf &_
									"       facultades e,                                                                       						"& vbCrLf &_
									"       personas g (nolock),                                                                						"& vbCrLf &_
									"       alumni_personas f (nolock),                                                                					"& vbCrLf &_
									"       alumnos_salidas_intermedias h (nolock),                                              						"& vbCrLf &_
									"       detalles_titulacion_carrera r		                                                						"& vbCrLf &_
									"where  a.saca_ncorr = b.saca_ncorr                                                         						"& vbCrLf &_
									"       and b.carr_ccod = c.carr_ccod                                                       						"& vbCrLf &_
									"       and f.pers_ncorr = g.pers_ncorr                                                                     		"& vbCrLf &_
									"       and c.area_ccod = d.area_ccod                                                       						"& vbCrLf &_
									"       and d.facu_ccod = e.facu_ccod                                                       						"& vbCrLf &_
									"       and a.pers_ncorr = f.pers_ncorr                                                     						"& vbCrLf &_
									"       and b.tsca_ccod  = 4 	                                                            						"& vbCrLf &_
									"       and a.saca_ncorr = h.saca_ncorr                                                     						"& vbCrLf &_
									"       and a.pers_ncorr = h.pers_ncorr                                                     						"& vbCrLf &_
									"       and h.emat_ccod  = 8 	                                                            						"& vbCrLf &_
									"	    and a.pers_ncorr = r.pers_ncorr 																			"& vbCrLf &_
									"	    and b.carr_ccod  = r.carr_ccod																				"& vbCrLf &_
									"	    and (r.fecha_egreso is not null or r.fecha_titulacion is not null)											"& vbCrLf &_
									"	    and saca_tdesc not like '%Licenci%'                                                  						"& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
									"                   and h.saca_ncorr not in ( 756, 764, 774 )                                                       "& vbCrLf &_
									"                   and e.facu_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                 "& vbCrLf &_
									"                                       else '"&v_facu_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and c.carr_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_carr_ccod&"' = '0' then c.carr_ccod                               "& vbCrLf &_
									"                                       else '"&v_carr_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                            "& vbCrLf &_
									"                   and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'						            "
'response.write("<pre>"&TEXTO&"</pre>")									
	sITitulados = TEXTO
end function
'*************************----------------
'**		sITitulados		**
'*************************

'*************************
'**		sIEgresados		**
'*************************----------------
function sIEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
									"from   alumnos_salidas_carrera a (nolock), 																		"& vbCrLf &_
									"       salidas_carrera b (nolock),                                                         						"& vbCrLf &_
									"       carreras c (nolock),                                                                						"& vbCrLf &_
									"       areas_academicas d,                                                                 						"& vbCrLf &_
									"       facultades e,                                                                       						"& vbCrLf &_
									"       personas g (nolock),                                                                						"& vbCrLf &_
									"       alumni_personas f (nolock),                                                                					"& vbCrLf &_
									"       alumnos_salidas_intermedias h (nolock),                                              						"& vbCrLf &_
									"       detalles_titulacion_carrera r		                                                						"& vbCrLf &_
									"where  a.saca_ncorr = b.saca_ncorr                                                         						"& vbCrLf &_
									"       and b.carr_ccod = c.carr_ccod                                                       						"& vbCrLf &_
									"       and f.pers_ncorr = g.pers_ncorr                                                                     		"& vbCrLf &_
									"       and c.area_ccod = d.area_ccod                                                       						"& vbCrLf &_
									"       and d.facu_ccod = e.facu_ccod                                                       						"& vbCrLf &_
									"       and a.pers_ncorr = f.pers_ncorr                                                     						"& vbCrLf &_
									"       and b.tsca_ccod in ( 4 )                                                            						"& vbCrLf &_
									"       and a.saca_ncorr = h.saca_ncorr                                                     						"& vbCrLf &_
									"       and a.pers_ncorr = h.pers_ncorr                                                     						"& vbCrLf &_
									"       and h.emat_ccod  = 4 	                                                            						"& vbCrLf &_
									"	    and a.pers_ncorr = r.pers_ncorr 																			"& vbCrLf &_
									"	    and b.carr_ccod  = r.carr_ccod																				"& vbCrLf &_
									"	    and (r.fecha_egreso is not null or r.fecha_titulacion is not null)											"& vbCrLf &_
									"	    and saca_tdesc not like '%Licenci%'                                                  						"& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
									"                   and h.saca_ncorr not in ( 756, 764, 774 )                                                       "& vbCrLf &_
									"                   and e.facu_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                 "& vbCrLf &_
									"                                       else '"&v_facu_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and c.carr_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_carr_ccod&"' = '0' then c.carr_ccod                               "& vbCrLf &_
									"                                       else '"&v_carr_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                            "& vbCrLf &_
									"                   and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'						            "
			sIEgresados = TEXTO
end function
'*************************----------------
'**		sIEgresados		**
'*************************

'*********************************
'**		sITitulados	Y EGRESADOS	**
'*********************************----------------
function sITYE(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
									"from   alumnos_salidas_carrera a (nolock), 																		"& vbCrLf &_
									"       salidas_carrera b (nolock),                                                         						"& vbCrLf &_
									"       carreras c (nolock),                                                                						"& vbCrLf &_
									"       areas_academicas d,                                                                 						"& vbCrLf &_
									"       facultades e,                                                                       						"& vbCrLf &_
									"       personas g (nolock),                                                                						"& vbCrLf &_
									"       alumni_personas f (nolock),                                                                					"& vbCrLf &_
									"       alumnos_salidas_intermedias h (nolock),                                              						"& vbCrLf &_
									"       detalles_titulacion_carrera r		                                                						"& vbCrLf &_
									"where  a.saca_ncorr = b.saca_ncorr                                                         						"& vbCrLf &_
									"       and b.carr_ccod = c.carr_ccod                                                       						"& vbCrLf &_
									"       and f.pers_ncorr = g.pers_ncorr                                                                     		"& vbCrLf &_
									"       and c.area_ccod = d.area_ccod                                                       						"& vbCrLf &_
									"       and d.facu_ccod = e.facu_ccod                                                       						"& vbCrLf &_
									"       and a.pers_ncorr = f.pers_ncorr                                                     						"& vbCrLf &_
									"       and b.tsca_ccod  = 4 	                                                            						"& vbCrLf &_
									"       and a.saca_ncorr = h.saca_ncorr                                                     						"& vbCrLf &_
									"       and a.pers_ncorr = h.pers_ncorr                                                     						"& vbCrLf &_
									"       and h.emat_ccod  in (4,8) 	                                                            					"& vbCrLf &_
									"	    and a.pers_ncorr = r.pers_ncorr 																			"& vbCrLf &_
									"	    and b.carr_ccod  = r.carr_ccod																				"& vbCrLf &_
									"	    and (r.fecha_egreso is not null or r.fecha_titulacion is not null)											"& vbCrLf &_
									"	    and saca_tdesc not like '%Licenci%'                                                  						"& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
									"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
									"                   and h.saca_ncorr not in ( 756, 764, 774 )                                                       "& vbCrLf &_
									"and (select top 1 protic.trunc(bb.asca_fsalida)                                                                    "& vbCrLf &_
									"                        from   detalles_titulacion_carrera aa                                                      "& vbCrLf &_
									"                               inner join alumnos_salidas_carrera as bb                                            "& vbCrLf &_
									"                                       on aa.pers_ncorr = bb.pers_ncorr                                            "& vbCrLf &_
									"                                          and Cast(bb.pers_ncorr as varchar) = a.pers_ncorr                        "& vbCrLf &_
									"                               inner join salidas_carrera as cc                                                    "& vbCrLf &_
									"                                       on aa.plan_ccod = cc.plan_ccod                                              "& vbCrLf &_
									"                                          and bb.saca_ncorr = cc.saca_ncorr                                        "& vbCrLf &_
									"                        where  Cast(cc.plan_ccod as varchar) = r.plan_ccod                                         "& vbCrLf &_
									"						       and bb.asca_fsalida is not null                                                      "& vbCrLf &_
									"                               and aa.carr_ccod = c.carr_ccod) is not null									        "& vbCrLf &_
									"                   and e.facu_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                 "& vbCrLf &_
									"                                       else '"&v_facu_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and c.carr_ccod = case                                                                          "& vbCrLf &_
									"                                       when '"&v_carr_ccod&"' = '0' then c.carr_ccod                               "& vbCrLf &_
									"                                       else '"&v_carr_ccod&"'                                                      "& vbCrLf &_
									"                                     end                                                                           "& vbCrLf &_
									"                   and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                            "& vbCrLf &_
									"                   and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'						            "			
	sITYE = TEXTO
end function
'*********************************----------------
'**		sITitulados	Y EGRESADOS	**
'*********************************

'*********************************'----------------
'****	SALIDAS INTERMEDIAS   ****'
'*********************************'

'***********************'
'****	GRADUADOS	****'
'***********************'----------------

'*************************************
'**		UPAPostgradoGraduadosp1		**
'*************************************----------------
function UPAPostgradoGraduadosp1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
"from   alumnos_salidas_carrera as a (nolock)                                                                       "& vbCrLf &_
"       inner join salidas_carrera as b (nolock)                                                                    "& vbCrLf &_
"               on a.saca_ncorr = b.saca_ncorr                                                                      "& vbCrLf &_
"                  and b.tsca_ccod in ( 3 )                                                                         "& vbCrLf &_
"       inner join carreras as c (nolock)                                                                           "& vbCrLf &_
"               on b.carr_ccod = c.carr_ccod                                                                        "& vbCrLf &_
"                  and c.tcar_ccod = 2                                                                              "& vbCrLf &_
"                  and c.carr_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                "& vbCrLf &_
"                                      else '"&v_carr_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"       inner join areas_academicas as d                                                                            "& vbCrLf &_
"               on c.area_ccod = d.area_ccod                                                                        "& vbCrLf &_
"       inner join facultades as e                                                                                  "& vbCrLf &_
"               on d.facu_ccod = e.facu_ccod                                                                        "& vbCrLf &_
"                  and e.facu_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                  "& vbCrLf &_
"                                      else '"&v_facu_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"       inner join alumni_personas as f (nolock)                                                                    "& vbCrLf &_
"               on a.pers_ncorr = f.pers_ncorr                                                                      "& vbCrLf &_
"                  and cast(isnull(f.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                  "& vbCrLf &_
"       left outer join personas as g                                                                               "& vbCrLf &_
"                    on g.pers_ncorr = f.pers_ncorr                                                                 "& vbCrLf &_
"	   left outer join detalles_titulacion_carrera as r																"& vbCrLf &_
"					on g.pers_ncorr = r.pers_ncorr																	"& vbCrLf &_
"where  cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                                            "& vbCrLf &_
"-- CONDICION DE AÑOS-->>                                                                                           "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
"-- CONDICION DE AÑOS--<<        																					"
                   
			UPAPostgradoGraduadosp1 = TEXTO
end function
'*************************************----------------
'**		UPAPostgradoGraduadosp1		**
'*************************************
'***********************'----------------
'****	GRADUADOS	****'
'***********************'

'***********************'
'****	INSTITUTO	****'
'***********************'----------------

'*****************************
'**		insTItulados		**
'*****************************----------------
function insTItulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
"from   egresados_upa2 a (nolock)                                                                                   "& vbCrLf &_
"       inner join carreras as c (nolock)                                                                           "& vbCrLf &_
"               on a.carr_ccod = c.carr_ccod collate sql_latin1_general_cp1_ci_as                                   "& vbCrLf &_
"                  and c.carr_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                "& vbCrLf &_
"                                      else '"&v_carr_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"       left outer join alumni_personas as g                                                                        "& vbCrLf &_
"                    on a.pers_ncorr = g.pers_ncorr                                                                 "& vbCrLf &_
"       inner join areas_academicas as d                                                                            "& vbCrLf &_
"               on c.area_ccod = d.area_ccod                                                                        "& vbCrLf &_
"       inner join facultades as e                                                                                  "& vbCrLf &_
"               on d.facu_ccod = e.facu_ccod                                                                        "& vbCrLf &_
"                  and a.entidad = 'I'                                                                              "& vbCrLf &_
"                  and e.facu_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                  "& vbCrLf &_
"                                      else '"&v_facu_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"where  a.emat_ccod = 8 		                                                                                    "& vbCrLf &_
"       and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                                        "& vbCrLf &_
"       and cast(isnull(a.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                             "& vbCrLf &_
"       and not exists (select 1                                                                                    "& vbCrLf &_
"                       from   detalles_titulacion_carrera tt (nolock)                                              "& vbCrLf &_
"                       where  tt.pers_ncorr = a.pers_ncorr                                                         "& vbCrLf &_
"                              and tt.carr_ccod = c.carr_ccod                                                       "& vbCrLf &_
"                              and isnull(protic.trunc(tt.fecha_egreso), '') <> '')                                 "& vbCrLf &_
"-- CONDICION DE AÑOS-->>                                                                                           "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
"-- CONDICION DE AÑOS--<<    																						"
	
	insTItulados = TEXTO
end function
'*****************************----------------
'**		insTItulados		**
'*****************************

'*****************************
'**		insEgresados		**
'*****************************----------------
function insEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	'**CONDICIONES INICIALES----------------->>>>>>>>>>>>>>
		TEXTO 	= ""
		tipoPromo	= "NOAPLICA"
		tipoEgre 	= "NOAPLICA"
		tipoTitu 	= "NOAPLICA"
		if v_anio_promo 	<> 0 then tipoPromo = "PROMOCION" end if	
		if v_anio_egreso 	<> 0 then tipoEgre = "EGRESO" end if
		if v_anio_titula 	<> 0 then tipoTitu = "TITULACION" end if
	'**CONDICIONES INICIALES-----------------<<<<<<<<<<<<<<
	TEXTO = ""& vbCrLf &_
"from   egresados_upa2 a (nolock)                                                                                   "& vbCrLf &_
"       inner join carreras as c (nolock)                                                                           "& vbCrLf &_
"               on a.carr_ccod = c.carr_ccod collate sql_latin1_general_cp1_ci_as                                   "& vbCrLf &_
"                  and c.carr_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_carr_ccod&"' = '0' then c.carr_ccod                                "& vbCrLf &_
"                                      else '"&v_carr_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"       left outer join alumni_personas as g                                                                        "& vbCrLf &_
"                    on a.pers_ncorr = g.pers_ncorr                                                                 "& vbCrLf &_
"       inner join areas_academicas as d                                                                            "& vbCrLf &_
"               on c.area_ccod = d.area_ccod                                                                        "& vbCrLf &_
"       inner join facultades as e                                                                                  "& vbCrLf &_
"               on d.facu_ccod = e.facu_ccod                                                                        "& vbCrLf &_
"                  and a.entidad = 'I'                                                                              "& vbCrLf &_
"                  and e.facu_ccod = case                                                                           "& vbCrLf &_
"                                      when '"&v_facu_ccod&"' = 0 then e.facu_ccod                                  "& vbCrLf &_
"                                      else '"&v_facu_ccod&"'                                                       "& vbCrLf &_
"                                    end                                                                            "& vbCrLf &_
"where  a.emat_ccod = 4 		                                                                                    "& vbCrLf &_
"       and cast(a.sede_ccod as varchar) = '"&v_sede_ccod&"'                                                        "& vbCrLf &_
"       and cast(isnull(a.sexo_ccod, 1) as varchar) = '"&v_sexo_ccod&"'                                             "& vbCrLf &_
"       and not exists (select 1                                                                                    "& vbCrLf &_
"                       from   detalles_titulacion_carrera tt (nolock)                                              "& vbCrLf &_
"                       where  tt.pers_ncorr = a.pers_ncorr                                                         "& vbCrLf &_
"                              and tt.carr_ccod = c.carr_ccod                                                       "& vbCrLf &_
"                              and isnull(protic.trunc(tt.fecha_egreso), '') <> '')                                 "& vbCrLf &_
"-- CONDICION DE AÑOS-->>                                                                                           "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoPromo&"', c.carr_ccod, '"&v_anio_promo&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoEgre&"', c.carr_ccod, '"&v_anio_egreso&"')) "& vbCrLf &_
"       and 1 = (select protic.compara_filtro_anio(a.pers_ncorr, '"&tipoTitu&"', c.carr_ccod, '"&v_anio_titula&"')) "& vbCrLf &_
"-- CONDICION DE AÑOS--<<    																						"
	insEgresados = TEXTO
end function
'*****************************----------------
'**		insEgresados		**
'*****************************
'***********************'----------------
'****	INSTITUTO	****'
'***********************'
'*************************************************************************************************************************************************************---------------
'**																																							**
'**														FUNCIONES PARA LAS CONSULTAS																		**
'**																																							**
'*************************************************************************************************************************************************************
'*************************************************************************************************************************************************************
'**																																							**
'**														FUNCION NÚMEROS POR SEDE																			**
'**																																							**
'*************************************************************************************************************************************************************---------------
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
'La función "estadistica_titulados_vASP" recibe 9 parámetros (código de la sede, código del sexo, entidad, tipo, código de facultad, código de la carrera, año de promoción, año de egreso y año de titulación.
'es función trae la matriz con los datos de conteo según se seleccionen
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
function estadistica_titulados_vASP(v_sede_ccod, v_sexo_ccod, entidad, tipo, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula)
	textoSelect = "select count(distinct cast(a.pers_ncorr as varchar) + '-' + ltrim(rtrim(c.carr_ccod))) as total   "
	'selectUnoInter(institucion, sede_tdesc, v_anio_egreso, v_anio_titula)
	select_1 = Cstr(selectUno("", "", 0, 0))
	select_2 = Cstr(selectDos("", "", 0, 0))
	'*****************************************************************
	'**						SI ES UNIVERSIDAD						**
	'*****************************************************************----------------	
	if entidad = "U" then
		'**TITULADOS--->
		if tipo = "UTI" then
					consulta = "select sum (total) as total from ("																				& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						uniTituladosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
						"union  "																										& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						uniTituladosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
						") as x"		
'			consulta =  "select sum (total) as total from ("																			& vbCrLf &_
'						"select count(*) as total from("																				& vbCrLf &_
'						select_1 																									    & vbCrLf &_						
'						uniTituladosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
'						"union  "																										& vbCrLf &_						
'						select_2																								        & vbCrLf &_						
'						uniTituladosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
'						") as y"																										& vbCrLf &_
'						") as x"
		end if
		'**TITULADOS---<
		'**EGRESADOS--->
		if tipo = "UEG" then
			consulta = "select sum (total) as total from ("																				& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						uniEgresadosP1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
						"union  "																										& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						uniEgresadosP2(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
						") as x"
		end if
		'**EGRESADOS---<
		'**SALIDAS INTERMEDIAS TITULADOS--->
		if tipo = "SIT" then
			consulta = "select sum (total) as total from ("																				& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						sITitulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 		& vbCrLf &_						
						") as x"
		end if
		'**SALIDAS INTERMEDIAS TITULADOS---<
		'**SALIDAS INTERMEDIAS TITULADOS--->
		if tipo = "SIE" then
			consulta = "select sum (total) as total from ("																				& vbCrLf &_
						textoSelect 																									& vbCrLf &_
						sIEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 		& vbCrLf &_						
						") as x"
		end if
		'**SALIDAS INTERMEDIAS TITULADOS---<
		'**UPA Postgrado--->
		if tipo = "POG" then
			consulta = "select sum (total) as total from ("																						& vbCrLf &_
						textoSelect 																											& vbCrLf &_
						UPAPostgradoGraduadosp1(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) 	& vbCrLf &_
						") as x"
		end if
		'**UPA Postgrado---<		
	end if'entidad = "U" then
	'*****************************************************************----------------
	'**						SI ES UNIVERSIDAD						**
	'*****************************************************************
	'*****************************************************************
	'**						SI ES INSTITUTO							**
	'*****************************************************************----------------
	if entidad = "I" then
		'**INSTITUTOS TITULADOS--->
		if tipo = "ITI" then
			consulta = "select sum (total) as total from ("																			& vbCrLf &_
						textoSelect 																								& vbCrLf &_
						insTItulados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) & vbCrLf &_
						") as x"
		end if
		'**INSTITUTOS TITULADOS---<
		'**INSTITUTOS EGRESADOS--->
		if tipo = "IEG" then
			consulta = "select sum (total) as total from ("																			& vbCrLf &_
						textoSelect 																								& vbCrLf &_
						insEgresados(v_sede_ccod, v_sexo_ccod, v_facu_ccod, v_carr_ccod, v_anio_promo, v_anio_egreso,v_anio_titula) & vbCrLf &_
						") as x"
		end if
		'**INSTITUTOS EGRESADOS---<
	end if'entidad = "I" then
	'*****************************************************************----------------
	'**						SI ES INSTITUTO							**
	'*****************************************************************
	estadistica_titulados_vASP = consulta
	'estadistica_titulados_vASP = "<pre>"&consulta&"</pre>"
end function
'*************************************************************************************************************************************************************---------------
'**																																							**
'**														FUNCION NÚMEROS POR SEDE																			**
'**																																							**
'*************************************************************************************************************************************************************

' Simple functions to convert the first 256 characters 
' of the Windows character set from and to UTF-8.

' Written by Hans Kalle for Fisz
' http://www.fisz.nl

'IsValidUTF8
'  Tells if the string is valid UTF-8 encoded
'Returns:
'  true (valid UTF-8)
'  false (invalid UTF-8 or not UTF-8 encoded string)
function IsValidUTF8(s)
  dim i
  dim c
  dim n

  IsValidUTF8 = false
  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c and &H80 then
      n = 1
      do while i + n < len(s)
        if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
          exit do
        end if
        n = n + 1
      loop
      select case n
      case 1
        exit function
      case 2
        if (c and &HE0) <> &HC0 then
          exit function
        end if
      case 3
        if (c and &HF0) <> &HE0 then
          exit function
        end if
      case 4
        if (c and &HF8) <> &HF0 then
          exit function
        end if
      case else
        exit function
      end select
      i = i + n
    else
      i = i + 1
    end if
  loop
  IsValidUTF8 = true 
end function

'DecodeUTF8
'  Decodes a UTF-8 string to the Windows character set
'  Non-convertable characters are replace by an upside
'  down question mark.
'Returns:
'  A Windows string
function DecodeUTF8(s)
  dim i
  dim c
  dim n

  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c and &H80 then
      n = 1
      do while i + n < len(s)
        if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
          exit do
        end if
        n = n + 1
      loop
      if n = 2 and ((c and &HE0) = &HC0) then
        c = asc(mid(s,i+1,1)) + &H40 * (c and &H01)
      else
        c = 191 
      end if
      s = left(s,i-1) + chr(c) + mid(s,i+n)
    end if
    i = i + 1
  loop
  DecodeUTF8 = s 
end function

'EncodeUTF8
'  Encodes a Windows string in UTF-8
'Returns:
'  A UTF-8 encoded string
function EncodeUTF8(s)
  dim i
  dim c

  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c >= &H80 then
      s = left(s,i-1) + chr(&HC2 + ((c and &H40) / &H40)) + chr(c and &HBF) + mid(s,i+1)
      i = i + 1
    end if
    i = i + 1
  loop
  EncodeUTF8 = s 
end function
'---------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------->>>>>>>>>>>>>funciones
function esDesimal(numero)
	sNumero = Cstr(numero)
	numDummy = instr(sNumero, ",")
	if numDummy <> 0 then
       esDesimal = true
	else
       esDesimal = false
	end if
end function

function suma( var_1, var_2)
	varF_1 = CInt(var_1)
	varF_2 = CInt(var_2)
	tot = varF_1 + varF_2
	suma = CStr(tot)
end function

function persent(f_total, f_granTotal)
	
	if f_granTotal <> "0" then
		x_1 = Cint(f_granTotal)
		x_2 = Cint(f_total)
		if x_1 <> 0 then
			x_3 = Cdbl(x_2)/Cdbl(x_1)
		else
			x_3 = 0
		end if	
		x_4 = x_3*100		
		if esDesimal(x_4) then
			persent = FormatNumber(x_4,2,-1,0,-2)
		else
			persent =FormatNumber(x_4,0)
		end if		
	else
		persent = "0"
	end if
	
	
end function

'---------------------------------------------------------------------------------------<<<<<<<<<<<<<funciones
















































%>