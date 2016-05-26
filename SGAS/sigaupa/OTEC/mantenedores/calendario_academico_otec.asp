<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
horasTotales = 0
'*************************************************'
'* RESCATE DE VARIABLES GET DE ESTA MISMA PÁGINA *'
'*****************************************************************'
anio_admision = request.querystring("busqueda[0][anio_admision]")'año de admisión
dgso_ncorr = Request.QueryString("busqueda[0][dgso_ncorr]")' código de datosGeneralesSeccionOtec
mote_ccod = Request.QueryString("busqueda[0][mote_ccod]")' llave de modulos_otec
seot_ncorr = Request.QueryString("busqueda[0][seot_ncorr]")' llave de secciones otec
'response.Write("dgso_ncorr ="&dgso_ncorr)
'response.Write("<br/>seot_ncorr ="&seot_ncorr)
'*****************************************************************'
'* RESCATE DE VARIABLES GET DE ESTA MISMA PÁGINA *'
'*************************************************'
session("url_actual")="../mantenedores/calendario_academico_otec.asp?busqueda[0][dgso_ncorr]="&dgso_ncorr&"&busqueda[0][mote_ccod]="&mote_ccod&"&busqueda[0][seot_ncorr]="&seot_ncorr&"&busqueda[0][anio_admision]="&anio_admision
'*************************************************'
'* SE CREA EL SECTOR DE INGRESO DE CALIFICACIONES *'
'*****************************************************************'
set pagina = new CPagina
pagina.Titulo = "Calendario académico"
'*****************************************************************'
'* SE CREA EL SECTOR DE INGRESO DE CALIFICACIONES *'
'**************************************************'
'*************************'
'* SE CREA LA BOTONONERA *'
'*********************************************************'
set botonera =  new CFormulario
botonera.carga_parametros "calendario_academico_otec.xml", "botonera"
'*********************************************************'
'* SE CREA LA BOTONONERA *'
'*************************'
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'response.Write(carr_ccod)
'----------------------------------------------------------------------- 
'************************'
'* CÁLCULO HORAS TOTALES*'
'**************************************************************************'
if seot_ncorr <> "" then
	consultaConta = "" & vbCrLf & _
	"select a.pcot_ncorr                                   " & vbCrLf & _
	"from   programacion_calendario_otec as a              " & vbCrLf & _
	"       inner join secciones_otec as b                 " & vbCrLf & _
	"               on a.seot_ncorr = b.seot_ncorr         " & vbCrLf & _
	"                  and b.seot_ncorr = '"&seot_ncorr&"' " 	
	pcot_ncorr = conexion.consultauno(consultaConta)
	if pcot_ncorr <> "" then
		cuantosDias = 0
		horasAux = 0
		cuantosDias = conexion.consultauno("select COUNT(pcot_ncorr) from programacion_calendario_detalle_otec where pcot_ncorr = '"&pcot_ncorr&"'")
		horasAux = conexion.consultauno("select total_horas from programacion_calendario_detalle_otec where pcot_ncorr = '"&pcot_ncorr&"'")	
		if horasAux <> "" and cuantosDias <> "" then
			horasTotales = CInt(horasAux) * CInt(cuantosDias)
		end if
	end if	
end if
'**************************************************************************'
'* CÁLCULO HORAS TOTALES*'
'************************'
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "calendario_academico_otec.xml", "busqueda"
f_busqueda.Inicializar conexion 
consulta="Select '"&anio_admision&"' as anio_admision,'"&dgso_ncorr&"' as dgso_ncorr, '"&mote_ccod&"' as mote_ccod, '"&seot_ncorr&"' as seot_ncorr"
f_busqueda.consultar consulta
'***************************************************************'
'* CONSULTA QUE TRAE LOS DATOS PARA LOS COMBOS  LOS TRAE TODOS *'
'************************************************************************'
consulta = "" & vbCrLf & _
"select anio_admision,                                   " & vbCrLf & _
"       a.dgso_ncorr,                                    " & vbCrLf & _
"       sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc, " & vbCrLf & _
"       f.mote_ccod,                                     " & vbCrLf & _
"       f.mote_tdesc,                                    " & vbCrLf & _
"       seot_ncorr,                                      " & vbCrLf & _
"       seot_tdesc                                       " & vbCrLf & _
"from   datos_generales_secciones_otec as a              " & vbCrLf & _
"       inner join sedes as b                            " & vbCrLf & _
"               on a.sede_ccod = b.sede_ccod             " & vbCrLf & _
"       inner join diplomados_cursos as c                " & vbCrLf & _
"               on a.dcur_ncorr = c.dcur_ncorr           " & vbCrLf & _
"       inner join secciones_otec as d                   " & vbCrLf & _
"               on a.dgso_ncorr = d.dgso_ncorr           " & vbCrLf & _
"       inner join mallas_otec as e                      " & vbCrLf & _
"               on d.maot_ncorr = e.maot_ncorr           " & vbCrLf & _
"       inner join modulos_otec as f                     " & vbCrLf & _
"               on e.mote_ccod = f.mote_ccod             " & vbCrLf & _
"       inner join ofertas_otec as tt                    " & vbCrLf & _
"               on a.dgso_ncorr = tt.dgso_ncorr          " & vbCrLf & _
"where  esot_ccod = 1                                    " & vbCrLf & _
"order  by anio_admision desc,                           " & vbCrLf & _
"          dgso_tdesc asc,                               " & vbCrLf & _
"          mote_tdesc asc,                               " & vbCrLf & _
"          seot_tdesc asc                                " 
'response.write("<pre>"&consulta&"</pre>")

'************************************************************************'
'* CONSULTA QUE TRAE LOS DATOS PARA LOS COMBOS *'
'***********************************************'
f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.Siguiente 
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++inicio form = busqueda_2
set f_busqueda_2 = new CFormulario
f_busqueda_2.Carga_Parametros "calendario_academico_otec.xml", "busqueda_2"
f_busqueda_2.Inicializar conexion
'------------------------
if dgso_ncorr = "" then
dgso_ncorr = 0
mote_ccod = 0
visible = false
else
visible = true
end if
'************************************'
'* CONSULTA QUE LLENA EL COMBO DIAS *'
'************************************************************************'
if pcot_ncorr <> "" then
consultaDias = "" & vbCrLf & _
"select dias_ccod,                                               " & vbCrLf & _
"       dias_tdesc                                               " & vbCrLf & _
"from   dias_semana                                              " & vbCrLf & _
"where  dias_ccod not in                                         " & vbCrLf & _
"(                                                               " & vbCrLf & _
"select b.dias_ccod as dias_ccod                                 " & vbCrLf & _           
"from   dias_semana as a                                         " & vbCrLf & _
"inner join programacion_calendario_otec as b                    " & vbCrLf & _
"	on a.dias_ccod = b.dias_ccod                                 " & vbCrLf & _
"		and b.pcot_ncorr  in                                     " & vbCrLf & _
"							(                                    " & vbCrLf & _
"							select	pcot_ncorr                   " & vbCrLf & _
"                            from	programacion_calendario_otec " & vbCrLf & _
"                            where seot_ncorr = '"&seot_ncorr&"' " & vbCrLf & _
"                            )                                   " & vbCrLf & _
"union                                                           " & vbCrLf & _
"select 7 as dias_ccod                                           " & vbCrLf & _
")                                                               " 
else
	consultaDias = "" & vbCrLf & _
	"select dias_ccod,       " & vbCrLf & _
	"       dias_tdesc       " & vbCrLf & _
	"from   dias_semana      " & vbCrLf & _
	"where  dias_ccod != '7' " 
end if
f_busqueda_2.agregacampoparam "dias_ccod","destino","("&consultaDias &")a"
'************************************************************************'
'* CONSULTA QUE LLENA EL COMBO DIAS *'
'************************************'
'*************************************************'
'* CONSULTA QUE TRAE LOS DATOS PARA LA VENTANA 2 *'
'************************************************************************'
consulta = "" & vbCrLf & _
"select sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc2,   " & vbCrLf & _
"       sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc,    " & vbCrLf & _
"       f.mote_tdesc 					  as mote_tdesc2,   " & vbCrLf & _
"       d.seot_ncorr 					  as seot_ncorr,    " & vbCrLf & _
"       protic.trunc(d.seot_finicio)      as dgso_finicio,  " & vbCrLf & _
"       protic.trunc(d.seot_finicio)      as dgso_finicio2, " & vbCrLf & _
"       protic.trunc(d.seot_ftermino)     as dgso_ftermino, " & vbCrLf & _
"       protic.trunc(d.seot_ftermino)     as dgso_ftermino2," & vbCrLf & _
"       d.seot_tdesc  					  as seot_tdesc     " & vbCrLf & _
"from   datos_generales_secciones_otec as a                 " & vbCrLf & _
"       inner join sedes as b                               " & vbCrLf & _
"               on a.sede_ccod = b.sede_ccod                " & vbCrLf & _
"       inner join diplomados_cursos as c                   " & vbCrLf & _
"               on a.dcur_ncorr = c.dcur_ncorr              " & vbCrLf & _
"       inner join secciones_otec as d                      " & vbCrLf & _
"               on a.dgso_ncorr = d.dgso_ncorr              " & vbCrLf & _
"                  and d.dgso_ncorr = '"&dgso_ncorr&"'      " & vbCrLf & _
"       inner join mallas_otec as e                         " & vbCrLf & _
"               on d.maot_ncorr = e.maot_ncorr              " & vbCrLf & _
"       inner join modulos_otec as f                        " & vbCrLf & _
"               on e.mote_ccod = f.mote_ccod                " & vbCrLf & _
"               and f.mote_ccod = '"&mote_ccod&"'           " & vbCrLf & _
"       inner join ofertas_otec as tt                       " & vbCrLf & _
"               on a.dgso_ncorr = tt.dgso_ncorr             " 
'response.write("<pre>"&consulta&"</pre>")
'************************************************************************'
'* CONSULTA QUE TRAE LOS DATOS PARA LA VENTANA 2 *'
'*************************************************'
f_busqueda_2.consultar consulta
f_busqueda_2.Siguiente
fechaInicioCurso = f_busqueda_2.obtenerValor("dgso_finicio")
fechaTerminoCurso = f_busqueda_2.obtenerValor("dgso_ftermino")
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++fin form = busqueda_2

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++inicio form = busqueda_3
set f_busqueda_3 = new CFormulario
f_busqueda_3.Carga_Parametros "calendario_academico_otec.xml", "programa"
f_busqueda_3.Inicializar conexion
'*********************************'
'* CONSULTA PARA LLENAR LA TABLA *'
'**************************************************************************'
if seot_ncorr = "" then
	seot_ncorr = "0"
end if
consulta = "" & vbCrLf & _
"select distinct a.pcot_ncorr,                                               " & vbCrLf & _
"                d.mote_tdesc,                                               " & vbCrLf & _
"                b.seot_tdesc,                                               " & vbCrLf & _
"                f.dias_tdesc,                                               " & vbCrLf & _
"                e.total_horas as horas,                                     " & vbCrLf & _
"                e.total_horas * (select count(a.pcot_ncorr)) as total_horas " & vbCrLf & _
"from   programacion_calendario_otec as a                                    " & vbCrLf & _
"       inner join secciones_otec as b                                       " & vbCrLf & _
"               on a.seot_ncorr = b.seot_ncorr                               " & vbCrLf & _
"       inner join mallas_otec as c                                          " & vbCrLf & _
"               on b.maot_ncorr = c.maot_ncorr                               " & vbCrLf & _
"       inner join modulos_otec as d                                         " & vbCrLf & _
"               on c.mote_ccod = d.mote_ccod                                 " & vbCrLf & _
"       inner join programacion_calendario_detalle_otec as e                 " & vbCrLf & _
"               on a.pcot_ncorr = e.pcot_ncorr                               " & vbCrLf & _
"       inner join dias_semana as f                                          " & vbCrLf & _
"               on a.dias_ccod = f.dias_ccod                                 " & vbCrLf & _
"where	a.seot_ncorr = '"&seot_ncorr&"'  					 				 " & vbCrLf & _
"		and e.estado_programacion = '1' 					 				 " & vbCrLf & _
"group  by a.pcot_ncorr,                                                     " & vbCrLf & _
"          d.mote_tdesc,                                                     " & vbCrLf & _
"          b.seot_tdesc,                                                     " & vbCrLf & _
"          f.dias_tdesc,                                                     " & vbCrLf & _
"          total_horas                                                       "
'**************************************************************************'
'* CONSULTA PARA LLENAR LA TABLA *'
'*********************************'
f_busqueda_3.consultar consulta
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++fin form = busqueda_3

'------------------------------------------------------------------------------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "calendario_academico_otec.xml", "alumnos"
f_alumnos.Inicializar conexion
	
consulta =  " select a.seot_ncorr,a.pote_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, " & vbCrLf &_
			" c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' + c.pers_tnombre as alumno, " & vbCrLf &_
			" (select sitf_tdesc from situaciones_finales bb where bb.sitf_ccod=a.sitf_ccod) as estado,replace(caot_nnota_final,',','.') as caot_nnota_final,isnull(caot_nasistencia,100) as caot_nasistencia " & vbCrLf &_
			" from cargas_academicas_otec a, postulacion_otec b,personas c " & vbCrLf &_
			" where cast(a.seot_ncorr as varchar)='"&seot_ncorr&"'" & vbCrLf &_
			" and a.pote_ncorr=b.pote_ncorr and b.pers_ncorr=c.pers_ncorr order by alumno" 
	
f_alumnos.Consultar consulta

'----------------------------------------------------**********************
function esEstadoCero(fecha)
	set f_linkeable = new CFormulario
	f_linkeable.carga_Parametros "tabla_vacia.xml", "tabla"
	f_linkeable.Inicializar conexion
	consulta_fecha = "" & vbCrLf & _
	"select estado_programacion                                                       " & vbCrLf & _
	"from   programacion_calendario_detalle_otec                                      " & vbCrLf & _
	"where  protic.trunc(fecha_calendario) = '"&fecha&"'                              " & vbCrLf & _
	"       and pcot_ncorr = (select a.pcot_ncorr                                     " & vbCrLf & _
	"                         from   programacion_calendario_otec as a                " & vbCrLf & _
	"                                inner join programacion_calendario_detalle_otec  " & vbCrLf & _
	"                                           as b                                  " & vbCrLf & _
	"                                        on a.pcot_ncorr = b.pcot_ncorr           " & vbCrLf & _
	"                                           and a.seot_ncorr = '"&seot_ncorr&"'   " & vbCrLf & _
	"                                           and protic.trunc(b.fecha_calendario) = '"&fecha&"') " 
	f_linkeable.consultar consulta_fecha	
	f_linkeable.siguiente
	conteo = f_linkeable.ObtenerValor("estado_programacion")
	
		if conteo <> "0" then
			esEstadoCero = true
		else
			esEstadoCero = false
		end if	
end function

function esLinkeable(fecha)
	set f_linkeable = new CFormulario
	f_linkeable.carga_Parametros "calendario_academico_otec.xml", "f_linkeables_1" 
	f_linkeable.Inicializar conexion
	consulta_fecha = "" & vbCrLf & _
	"select count(protic.trunc(b.fecha_calendario)) as conteo    " & vbCrLf & _
	"from   programacion_calendario_otec as a                    " & vbCrLf & _
	"       inner join programacion_calendario_detalle_otec as b " & vbCrLf & _
	"               on a.pcot_ncorr = b.pcot_ncorr               " & vbCrLf & _
	"where  a.seot_ncorr = '"&seot_ncorr&"'                      " & vbCrLf & _
	"       and protic.trunc(b.fecha_calendario) = '"&fecha&"'   " 
	f_linkeable.consultar consulta_fecha	
	f_linkeable.siguiente
	conteo = f_linkeable.ObtenerValor("conteo")
	
		if conteo > 0 then
			esLinkeable = true
		else
			esLinkeable = false
		end if	
end function
'----------------------------------------------------**********************
'****************************************'
'** FUNCIÓN QUE DIBUJA LOS CALENDARIOS **'
'**********************************************************'
function calendario() 
set anioMeses = new CFormulario
anioMeses.carga_Parametros "calendario_academico_otec.xml", "calendariosM" 
anioMeses.Inicializar conexion
'-----------------------------------------------------------------------------
consulta_meses = "" & vbCrLf & _
"select distinct datepart(month, cale_fcalendario)as mes,      " & vbCrLf & _
"            datepart(year, cale_fcalendario) as anio          " & vbCrLf & _
"from   calendario                                             " & vbCrLf & _
"where  cale_fcalendario between '"&fechaInicioCurso&"' and '"&fechaTerminoCurso&"' " & vbCrLf & _
"order  by anio asc                                            " 
'-----------------------------------------------------------------------------
anioMeses.consultar consulta_meses

%>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<%
contaFila = 0
%>
<tr>
<%
while anioMeses.siguiente
	
	anio = anioMeses.obtenerValor("anio")
	mesnum =  anioMeses.obtenerValor("mes")
	mes = conexion.consultauno("select mes_tdesc from MESES where MES_CCOD = '"&mesnum&"'")
	anioCom = anio
	mesCom = mesnum
	dia_vaci_1 = false
	
	'------------------------------------------------------------primera pos 
	consulta_primerDia = "" & vbCrLf & _      
	"select datepart(weekday, cale_fcalendario) as primeraPos " & vbCrLf & _
	"from   calendario                                        " & vbCrLf & _
	"where  datepart(month, cale_fcalendario) = '"&mesnum&"'  " & vbCrLf & _
	"       and datepart(year, cale_fcalendario) = '"&anio&"' " & vbCrLf & _
	"       and datepart(day, cale_fcalendario) = '1'         " 
	primerDia = conexion.consultauno(consulta_primerDia)'primer día del mes
	'------------------------------------------------------------primera pos  
	'------------------------------------------------------------ultimoDia
	consulta_ultimoDia = "" & vbCrLf & _  
	"select MAX(datepart(day, cale_fcalendario)) as ultimodia " & vbCrLf & _     
	"       from   calendario                                 " & vbCrLf & _   
	"where  datepart(month, cale_fcalendario) = '"&mesnum&"'  " & vbCrLf & _
	"       and datepart(year, cale_fcalendario) = '"&anio&"' " 
	ultimoDia = conexion.consultauno(consulta_ultimoDia)
	'------------------------------------------------------------ultimoDia	
	'Response.Write("contaFila = " & contaFila)
	%>		
	<td > 
	<table cellspacing="0" cellpadding="0" border="0"> 
		<col width="28" span="7" />
		<tr>
			<td class="mesAnio" colspan="7" width="196"><% response.Write(mes & " - "& anio) %></td>
		</tr>
		<tr>
			<td class="cabezaDia">L</td>
			<td class="cabezaDia">M</td>
			<td class="cabezaDia">X</td>
			<td class="cabezaDia">J</td>
			<td class="cabezaDia">V</td>
			<td class="cabezaDia">S</td>
			<td class="cabezaDia">D</td>
		</tr>
		<%
		set f_dias = new CFormulario
		f_dias.carga_Parametros "calendario_academico_otec.xml", "calendariosD" 
		f_dias.Inicializar conexion
		'-----------------------------------------------------------------------------
		consulta_dias = "" & vbCrLf & _
		"select datepart(day, cale_fcalendario)    as numdia,    " & vbCrLf & _
		"       datepart(weekday, cale_fcalendario)as posSemana    " & vbCrLf & _
		"from   calendario                                    " & vbCrLf & _
		"where  datepart(month, cale_fcalendario) = '"&mesnum&"'       " & vbCrLf & _
		"       and datepart(year, cale_fcalendario) = '"&anio&"' " 
		'-----------------------------------------------------------------------------
		'response.write("<pre>"&consulta_dias&"</pre>")
		f_dias.consultar consulta_dias
		ReDim miArreglo(42)
		'--------------------------------------Limpia arreglo
		for i=0 to Ubound(miArreglo)
			miArreglo(i) = ""
		next 
		'--------------------------------------Limpia arreglo
		if primerDia > 1 then
			for i=0 to (primerDia - 1)
				miArreglo(i) = ""	
			next 
		end if
		for i=primerDia to (ultimoDia + (primerDia - 1))
			miArreglo(i - 1) = (i + 1) - primerDia 
		next 
		while f_dias.siguiente
			
		wend
		for j = 0 to 5
		%>
		<tr >
		<%
		
			for i = 0 to 6
		
			if j = 0 then
			posVector = (i + (6 * j))
			else
			posVector = ((i + j) + (6 * j))
			end if
			dia_aux = miArreglo(posVector)
			diaCom = dia_aux
			mes_aux = mesnum
			dia_vaci_1 = false
			'---------------------------------------*********0x
				if len(mesnum) < 2 and dia_aux <> "" then
					mes_aux = "0"&mesnum
				end if
				if len(dia_aux) < 2 and dia_aux <> "" then
					dia_aux = "0"&dia_aux
				end if
				if dia_aux = "" then
					dia_aux = "&nbsp;"
					dia_vaci_1 = true
				end if
			'---------------------------------------*********0x
				if dia_aux <> "" then
					diaFuncion = dia_aux
				else
					diaFuncion = "00"
				end if	
				fechaALaFuncion = diaFuncion&"/"&mes_aux&"/"&anio
				if diaCom = ""   then
				diaCom = "01"
				end if
				fechaALaFuncionCom = diaCom&"/"&mes_aux&"/"&anio
				fecha_com = conexion.consultauno("select protic.trunc(getdate())")
				Diferencia = DateDiff("D", fechaALaFuncionCom, fecha_com)
				diferencia_2 = DateDiff("D", fechaALaFuncionCom, fechaInicioCurso)
				diferencia_3 = DateDiff("D", fechaALaFuncionCom, fechaTerminoCurso)
'------------------------------------------------------------------------------------->condiciones	
if 	((diferencia_2 < 1) and (diferencia_3 > -1)) then 
	if fesFeriado(fechaALaFuncion) = false then
		if esEstadoCero(fechaALaFuncion) then ' SI EL ESTADO NO ES ELIMINADO
			if esLinkeable(fechaALaFuncion) then
				if Diferencia < 1 then 
					if tieneRelator(fechaALaFuncion) = "0" then 
						%>	
							<td class="sinRelator"> <a id="id_fechas" title="Presione acá para modificar el día" href="#" onclick="modifDia('<% response.Write(fechaALaFuncion) %>','<% response.Write(pcot_ncorr)%>','<% response.Write(seot_ncorr) %>','<% response.Write(dgso_ncorr) %>','<% response.Write("nopasado") %>');return false;"><% Response.Write(dia_aux) %></a> </td>
						<%
					else
						%>	
							<td class="linkeable"> <a id="id_fechas" title="Presione acá para modificar el día" href="#" onclick="modifDia('<% response.Write(fechaALaFuncion) %>','<% response.Write(pcot_ncorr)%>','<% response.Write(seot_ncorr) %>','<% response.Write(dgso_ncorr) %>','<% response.Write("nopasado") %>');return false;"><% Response.Write(dia_aux) %></a> </td>
						<%
					end if								
				else ' SI YA PASÓ LA FECHA
					%>	
							<td class="estadoCero"> <a id="id_fechas" title="Presione acá para modificar el día" href="#" onclick="modifDia('<% response.Write(fechaALaFuncion) %>','<% response.Write(pcot_ncorr)%>','<% response.Write(seot_ncorr) %>','<% response.Write(dgso_ncorr) %>','<% response.Write("pasado") %>');return false;"><% Response.Write(dia_aux) %></a> </td>
					<%								
				end if						
			else ' SI ES UN DÍA NORMAL
				%>	
				<td class="noLinkeable"><% Response.Write(dia_aux)%></td>
				<%
			end if
		else ' SI EL ESTADO ES ELIMINADO 
			%>					
				<td class="l_eliminado"> <a id="id_fechas" title="Presione acá para habilitar el día" href="#" onclick="habilitaDia('<% response.write("proc_habilita_dia_c_academico_otec.asp?fecha="&fechaALaFuncion&"&seot_ncorr="&seot_ncorr&"&dgso_ncorr="&dgso_ncorr) %>');return false;"><% Response.Write(dia_aux)%></a> </td>
			<% 	
		end if
		else ' si es feriado
			%>	
				<td class="l_feriado"><% Response.Write(dia_aux)%></td>
			<% 	
	end if	
else
	if  ( (dia_vaci_1 = false) ) then			
		%>	
		<td class="fueraRango"><% Response.Write(dia_aux)%></td>
		<% 
	else
		%>	
			<td class="noLinkeable"><% Response.Write(dia_aux)%></td>
		<%
	end if	
end if	
'-------------------------------------------------------------------------------------<condiciones	
			next
		%>
		</tr> 
		<%
		next 
		
		%>  	
	</table>
	</td>	
	<td WIDTH="5"></td>
	<% if contaFila = 2 then %>
	</tr>
	<% contaFila = -1 %>
	<% end if %>
	<% contaFila = contaFila + 1 %>
<% wend %>
</tr>
</table>
<%
end function
'**********************************************************'
'** FUNCIÓN QUE DIBUJA LOS CALENDARIOS **'
'****************************************'
'*************************************************************************************'
'** 								HORAS>   										**'
'*************************************************************************************'
'*********************************'
'** FUNCIÓN HORAS TRANSCURRIDAS **'
'*****************************************************'
function horasTrans(valor,anio)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas),'0') as suma         " & vbCrLf & _
	"from   programacion_calendario_detalle_otec as a    " & vbCrLf & _
	"       inner join programacion_calendario_otec as b " & vbCrLf & _
	"               on a.pcot_ncorr = b.pcot_ncorr       " & vbCrLf & _
	"                  and b.seot_ncorr = '"&valor&"'    " & vbCrLf & _
	"where  a.fecha_calendario < protic.trunc(getdate()) " & vbCrLf & _
	"and datepart(year,a.fecha_calendario) = '"&anio&"'	 " & vbCrLf & _
	"and a.estado_programacion != '0'					 "	
	valor_aux = conexion.consultauno(consulta_2)	
	horasTrans = valor_aux	
else
	horasTrans = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TRANSCURRIDAS **'
'*********************************'

'***************************'
'** FUNCIÓN HORAS TOTALES **'
'*****************************************************'
function fHorasTotales(valorSeot_ncorr,anio)
if valorSeot_ncorr <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas),'0') as suma         		" & vbCrLf & _
	"from   programacion_calendario_detalle_otec as a    		" & vbCrLf & _
	"       inner join programacion_calendario_otec as b 		" & vbCrLf & _
	"               on a.pcot_ncorr = b.pcot_ncorr       		" & vbCrLf & _
	"                  and b.seot_ncorr = '"&valorSeot_ncorr&"' " & vbCrLf & _
	" where a.estado_programacion != '0'						" & vbCrLf & _
	"and datepart(year,a.fecha_calendario) = '"&anio&"'	 		" 
	valor_aux = conexion.consultauno(consulta_2)	
	fHorasTotales = valor_aux	
else
	fHorasTotales = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TOTALES **'

'======================================================================================programa>

'** FUNCIÓN HORAS TOTALES **'
'*****************************************************'
function horasTotP(valor,anio)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas), '0') as suma                			" & vbCrLf & _
	"from   datos_generales_secciones_otec as a                  			" & vbCrLf & _
	"       inner join secciones_otec as b                       			" & vbCrLf & _
	"               on a.dgso_ncorr = b.dgso_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_otec as c         			" & vbCrLf & _
	"               on b.seot_ncorr = c.seot_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_detalle_otec as d 			" & vbCrLf & _
	"               on c.pcot_ncorr = d.pcot_ncorr               			" & vbCrLf & _
	"                  and d.estado_programacion != '0'          			" & vbCrLf & _
	"				   and datepart(year,d.fecha_calendario) = '"&anio&"'	" & vbCrLf & _
	"where  a.dgso_ncorr = '"&valor&"' 					 	     			" 
	valor_aux = conexion.consultauno(consulta_2)	
	horasTotP = valor_aux	
else
	horasTotP = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TOTALES **'


'** FUNCIÓN HORAS TRANSCURRIDAS **'
'*****************************************************'
function horasTransP(valor, anio)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas), '0') as suma                			" & vbCrLf & _
	"from   datos_generales_secciones_otec as a                  			" & vbCrLf & _
	"       inner join secciones_otec as b                       			" & vbCrLf & _
	"               on a.dgso_ncorr = b.dgso_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_otec as c         			" & vbCrLf & _
	"               on b.seot_ncorr = c.seot_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_detalle_otec as d 			" & vbCrLf & _
	"               on c.pcot_ncorr = d.pcot_ncorr               			" & vbCrLf & _
	"                  and d.estado_programacion != '0'          			" & vbCrLf & _
	"				   and d.fecha_calendario < protic.trunc(getdate()) 	" & vbCrLf & _
	"				   and datepart(year,d.fecha_calendario) = '"&anio&"'	" & vbCrLf & _	 
	"where  a.dgso_ncorr = '"&valor&"' 					 	     			" 
	valor_aux = conexion.consultauno(consulta_2)	
	horasTransP = valor_aux	
else
	horasTransP = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TRANSCURRIDAS **'

'======================================================================================<programa

'======================================================================================>Totales
'** FUNCIÓN HORAS TOTALES PROGRAMA **'
'*****************************************************'
function f_horasTotPro(valor)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas), '0') as suma                			" & vbCrLf & _
	"from   datos_generales_secciones_otec as a                  			" & vbCrLf & _
	"       inner join secciones_otec as b                       			" & vbCrLf & _
	"               on a.dgso_ncorr = b.dgso_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_otec as c         			" & vbCrLf & _
	"               on b.seot_ncorr = c.seot_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_detalle_otec as d 			" & vbCrLf & _
	"               on c.pcot_ncorr = d.pcot_ncorr               			" & vbCrLf & _
	"                  and d.estado_programacion != '0'          			" & vbCrLf & _
	"where  a.dgso_ncorr = '"&valor&"' 					 	     			" 
	valor_aux = conexion.consultauno(consulta_2)	
	f_horasTotPro = valor_aux	
else
	f_horasTotPro = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TOTALES PROGRAMA **'

'** FUNCIÓN HORAS TOTALES MODULO **'
'*****************************************************'
function f_HorasTotMod(valorSeot_ncorr)
if valorSeot_ncorr <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas),'0') as suma         		" & vbCrLf & _
	"from   programacion_calendario_detalle_otec as a    		" & vbCrLf & _
	"       inner join programacion_calendario_otec as b 		" & vbCrLf & _
	"               on a.pcot_ncorr = b.pcot_ncorr       		" & vbCrLf & _
	"                  and b.seot_ncorr = '"&valorSeot_ncorr&"' " & vbCrLf & _
	" where a.estado_programacion != '0'						" 
	valor_aux = conexion.consultauno(consulta_2)	
	f_HorasTotMod = valor_aux		
else
	f_HorasTotMod = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TOTALES MODULO **'
'======================================================================================<Totales

'======================================================================================>porMalla

'** FUNCIÓN HORAS TOTALES PROGRAMA POR MAYA **'
'*****************************************************'
function f_HorasPorMalla(valor)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(maot_nhoras_programa), '0') as suma " & vbCrLf & _
	"from   datos_generales_secciones_otec as a            " & vbCrLf & _
	"	inner join mallas_otec as b                        " & vbCrLf & _
	"			on a.dcur_ncorr = b.dcur_ncorr             " & vbCrLf & _
	"where  dgso_ncorr = '" & valor & "'                   " 
	valor_aux = conexion.consultauno(consulta_2)	
	f_HorasPorMalla = valor_aux		
else
	f_HorasPorMalla = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TOTALES PROGRAMA POR MAYA **'

'======================================================================================<porMalla
'*************************************************************************************'
'** 								<HORAS   										**'
'*************************************************************************************'

'***************************'
'** FUNCIÓN TIENE RELATOR **'
'*****************************************************'
function tieneRelator(varFecha)
	valorSeot_ncorr = seot_ncorr
	if valorSeot_ncorr <> "" then
		consulta_2 = "" & vbCrLf & _
		"select b.pers_ncorr as pers_ncorr                           " & vbCrLf & _
		"from   programacion_calendario_otec as a                    " & vbCrLf & _
		"		inner join programacion_calendario_detalle_otec as b " & vbCrLf & _
		"			on a.pcot_ncorr = b.pcot_ncorr                   " & vbCrLf & _
		"where  a.seot_ncorr = '"&valorSeot_ncorr&"'                 " & vbCrLf & _     
		"   and protic.trunc(b.fecha_calendario) = '"&varFecha&"'    " 
		valor_aux = conexion.consultauno(consulta_2)	
		pers_ncorr = valor_aux		
		if pers_ncorr <> "0" then
			verRetorno = "1"
		else 
			verRetorno = "0"
		end if
	else
		verRetorno = "2"
	end if
	tieneRelator = verRetorno	
end function
'*****************************************************'
'** FUNCIÓN TIENE RELATOR **'
'***************************'

'***************************'
'** FUNCIÓN DÍAS FERIADOS **'
'*****************************************************'
function fesFeriado(varFecha)
	respuesta = false
	esHabil = conexion.ConsultaUno("select CALE_BDIA_HABIL from CALENDARIO where protic.trunc(CALE_FCALENDARIO) = '"& varFecha &"'")
	esFeriado = conexion.ConsultaUno("select isnull(CALE_BFERIADO,'0') from CALENDARIO where protic.trunc(CALE_FCALENDARIO) = '"& varFecha &"'")
	if 	( esFeriado = "1" or esHabil= "0" )  then
	respuesta = true
	end if	
	fesFeriado = respuesta
end function
'*****************************************************'
'** FUNCIÓN DÍAS FERIADOS **'
'***************************'

'-------------------------------------------------******************
function generaContadores()
consulta_ini = "" & vbCrLf & _
"select datepart(year, dgso_finicio)   " & vbCrLf & _
"from   datos_generales_secciones_otec " & vbCrLf & _
"where  dgso_ncorr = '"&dgso_ncorr&"'  " 
consulta_fin = "" & vbCrLf & _
"select datepart(year, dgso_ftermino)   " & vbCrLf & _
"from   datos_generales_secciones_otec  " & vbCrLf & _
"where  dgso_ncorr = '"&dgso_ncorr&"'   " 
f_inicio = conexion.ConsultaUno(consulta_ini)
f_termino = conexion.ConsultaUno(consulta_fin)
contador = cInt(f_termino) - cInt(f_inicio)
fecha_aux = cInt(f_inicio)
	for i=0 to contador
		%>
<tr >
    <td width="100%">
		<table cellspacing="0" cellpadding="0" >
			<col width="80" />
			<col width="11" />
			<col width="308" />
			<col width="128" />
			<col width="88" />
            <col width="88" />
			<tr>
			<td width="75"><strong><% response.Write(fecha_aux) %></strong></td>
			<td width="9">&nbsp;</td>
			<td width="212">Nombre</td>
			<td width="162" align="center">Horas    Trasncurridas</td>
			<td width="75" align="center">Horas totales</td>
			</tr>
			<tr>
			<td >&nbsp;</td>	 
			<td colspan="4"><hr /><br /></td>
			</tr>
			<tr>
			<td>Programa</td>
			<td>:</td>
			<td class="nombres_2"><% f_busqueda_2.dibujaCampo "dgso_tdesc2" 
	f_busqueda_2.dibujaCampo "dgso_tdesc"%></td>
			<td align="center"><% Response.Write(horasTransP(dgso_ncorr, fecha_aux)) %></td>
			<td align="center"><% Response.Write(horasTotP(dgso_ncorr, fecha_aux)) %></td>
			</tr>
			<tr>
			<td colspan="5"><hr /><br /></td>
			</tr>
			<tr>
			<td>M&oacute;dulo</td>
			<td>:</td>
			<td><% f_busqueda_2.dibujaCampo "seot_ncorr" 
	f_busqueda_2.dibujaCampo "mote_tdesc2" %>, secci&oacute;n  <% f_busqueda_2.dibujaCampo "seot_tdesc" %></td>
			<td align="center"><% Response.Write(horasTrans(seot_ncorr,fecha_aux)) %></td>
			<td align="center"><% Response.Write(fHorasTotales(seot_ncorr,fecha_aux)) %></td>
			</tr>
			<tr>
			<td colspan="5"><hr /><br /></td>
			</tr>
		</table>
    </td>
</tr>		
		<%
	fecha_aux = fecha_aux + 1	
	next
end function
'-------------------------------------------------******************
%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>


<script language="JavaScript">


function valida_carga()
{	
	cargando();
	return true;
}

function cargando()
{	
	cargar=document.getElementById('esperar');
	//cargar es mi id del div que esta oculto con la imagen y lo pongo visible hasta el final.
	tem=document.getElementById('tiempo');
	//tiempo es mi "id" de la imagen gif que hace del loader. que es cargar3.gif
	cargar.style.visibility='visible';	
	setTimeout('tem.src = "../biblioteca/imagenes/2u95w85.gif"', 200); //recarga la imagen despues de pulsar el boton submit
}

function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();		
	}
}
function cambiaFormatoGringo(fechaLocal)
{	
	var fechaNormal = fechaLocal;
	var cadenaDDMMYYYY = fechaNormal.split("/");
	var dia = cadenaDDMMYYYY[0];
	var mes = cadenaDDMMYYYY[1];
	var anio = cadenaDDMMYYYY[2];	
	var cadenaMMDDYYYY = mes + "/" + dia + "/" + anio;		
	return cadenaMMDDYYYY;
}
function cambiaFormatoGringo2(fechaLocal)
{
	
	var fechaNormal = fechaLocal;
	var cadenaDDMMYYYY = fechaNormal.split("/");
	//var dia = cadenaDDMMYYYY[0];
	//var mes = cadenaDDMMYYYY[1];
	//var anio = cadenaDDMMYYYY[2];	
	//var cadenaMMDDYYYY = anio + "," + mes + "," + dia;		
	//return cadenaMMDDYYYY;
	return cadenaDDMMYYYY;
}
function setearDia()
{
	//alert("En la funcion");
	var formulario = document.forms["proceso"];
	fecha_aux_1 = formulario.elements["b[0][dgso_finicio2]"].value;//ini_usuario
	fecha_aux_2 =cambiaFormatoGringo2(fecha_aux_1);	
	fecha_aux_3 = formulario.elements["b[0][dgso_ftermino2]"].value;//fin_usuario	
	fecha_aux_4 =cambiaFormatoGringo2(fecha_aux_3);
	//alert("valorPrueba = ");
	//var valorPrueba = formulario.elements["b[0][dias_ccod]"].options['6'].value;
	//alert("valorPrueba = " + valorPrueba);
	//var valorPrueba = document.getElementById('dias').options["6"].text
	//var valorPrueba = document.getElementById('dias').options.selectedIndex; //posicion
	//alert(document.getElementById('dias').options[valorPrueba].text); //valor
	//alert("valorPrueba = " + valorPrueba);
	//var numDiaSis = formulario.elements["b[0][dias_ccod]"].value;
	var fecha_user_1 = new Date(Date.UTC(fecha_aux_2[2],fecha_aux_2[1] - 1,fecha_aux_2[0]));
	var fecha_user_2 = new Date(Date.UTC(fecha_aux_4[2],fecha_aux_4[1] - 1,fecha_aux_4[0]));	
	if (fecha_aux_1 == fecha_aux_3)
	{
		formulario.elements["b[0][dias_ccod]"].value = fecha_user_1.getUTCDay();			
	}	
}
function chequearRangoFecha() 
{	
	var formulario = document.forms["proceso"];
	var fecha_user_1 = formulario.elements["b[0][dgso_finicio2]"].value;//ini_usuario
	fecha_user_1 = cambiaFormatoGringo(fecha_user_1);
	var fecha_user_2 = formulario.elements["b[0][dgso_ftermino2]"].value;//fin_usuario
	fecha_user_2 = cambiaFormatoGringo(fecha_user_2);
	var fecha_sis_1 = formulario.elements["b[0][dgso_finicio]"].value;//ini_sistema
	fecha_sis_1 = cambiaFormatoGringo(fecha_sis_1);
	var fecha_sis_2 = formulario.elements["b[0][dgso_ftermino]"].value;//fin_sistema
	fecha_sis_2 = cambiaFormatoGringo(fecha_sis_2);	

   var fechaInicio = Date.parse(fecha_sis_1)
   var fechaFin = Date.parse(fecha_sis_2);	
   var startDate = Date.parse(fecha_user_1);
   var endDate = Date.parse(fecha_user_2);
   if (isNaN(startDate)) 
	{
      alert("La fecha de inicio no es correcta, por favor ingrese una fecha válida DD/MM/AAAA.");	  
	  formulario.elements["b[0][dgso_finicio2]"].focus();
	  formulario.elements["b[0][dgso_finicio2]"].select();	  
      return false;
    }
   if (isNaN(endDate)) 
   {
       alert("La fecha de final no es correcta, por favor ingrese una fecha válida DD/MM/AAAA..");
	   formulario.elements["b[0][dgso_ftermino2]"].focus();
	   formulario.elements["b[0][dgso_ftermino2]"].select();
       return false;
   }
   var difference = (endDate - startDate) / (86400000 * 7);
   if (difference < 0) 
   {
       alert("Por favor ingrese un rango correcto.");
	   formulario.elements["b[0][dgso_finicio2]"].focus();
	   formulario.elements["b[0][dgso_finicio2]"].select();
       return false;
   }   
   var diferenciaBaja = (startDate - fechaInicio) / (86400000 * 7);
   var diferenciaAlta = (fechaFin - endDate) / (86400000 * 7);
   if (diferenciaBaja < 0) 
   {
       alert("Fecha de inicio es menor a la fecha de inicio del curso.");
	   formulario.elements["b[0][dgso_finicio2]"].focus();
	   formulario.elements["b[0][dgso_finicio2]"].select();
       return false;
   }   
   if (diferenciaAlta < 0) 
   {
       alert("Fecha final ingresada supera a la fecha de término del curso.");
	   formulario.elements["b[0][dgso_ftermino2]"].focus();
	   formulario.elements["b[0][dgso_ftermino2]"].select();
       return false;
   }  
   if (!validarListaDia()) 
   {
       alert("Debe seleccionar un día.");
	   formulario.elements["b[0][dias_ccod]"].focus();
       return false;
   }  
   if (!validarHorasClase()) 
   {
	   formulario.elements["b[0][horas]"].focus();	
       return false;
   }  
   cargando();
   formulario.submit();
}

function validarListaDia()
{
	var formulario = document.forms["proceso"];
	var dia = formulario.elements["b[0][dias_ccod]"].value;	
	if(dia != 1 && dia != 2 && dia != 3 && dia != 4 && dia != 5 && dia != 6)
	{		
		return false;
	}
	return true;
}
function validarHorasClase()
{
	var formulario = document.forms["proceso"];
	var horas = formulario.elements["b[0][horas]"].value;	
	if(horas > 24 || horas < 1 || isNaN(horas) || horas == "")
	{
		alert("Error en el ingreso de horas.\n"+
				"Si ingresa un decimal, recuerde que\n"+
				"la separación es con un punto Ej: 2.5");
		return false;
	}
	return true;
}

function aplicarEstilosTabla()
{
	var celdas = document.getElementsByClassName("linkeable")
}
function modifDia(var_1,var_2,var_3,var_4,var_tipo)
{
	if(var_tipo == "nopasado")
	{
		var direccion = "asigna_relator_c_academico_otec.asp?fecha="+ var_1 + "&pcot_ncorr=" + var_2 + "&seot_ncorr=" + var_3 + "&dgso_ncorr=" + var_4+ "&tipo=" + var_tipo;
		var resultado = window.open(direccion, "ventana_1","width=400px,height=200px,scrollbars=yes, left=0, top=0");
	}
	if(var_tipo == "pasado")
	{
		var direccion = "asigna_relator_c_academico_otec.asp?fecha="+ var_1 + "&pcot_ncorr=" + var_2 + "&seot_ncorr=" + var_3 + "&dgso_ncorr=" + var_4+ "&tipo=" + var_tipo;
		var resultado = window.open(direccion, "ventana_1","width=400px,height=200px,scrollbars=yes, left=0, top=0");
	}
	
}
function habilitaDia(url)
{
	var confirmacion = confirm("ALERTA!! va a proceder a habilitar este registro, si desea habilitarlo de click en ACEPTAR\n de lo contrario de click en CANCELAR.")
	if (confirmacion == true) 
	{
		//alert("habilitado");
		document.location = url;
		cargando();
		return true;
	}
	else 
	{		
		//alert("no hizo nada");
		return false;
	}
}
</script>
<style type="text/css">
.gradient {
       filter: none;
    }
.dosPuntos{
	text-align:center;
}
.nombres_1{
	text-align:left;
	font-weight:bold;
	font-size:12px;
}
.nombres_2{
	text-align: left;
	color: #900;
	font-size: 10px;
	font-style: normal;
}
.mesAnio
{
	background: #3b679e; 
	background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzNiNjc5ZSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUwJSIgc3RvcC1jb2xvcj0iIzJiODhkOSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUxJSIgc3RvcC1jb2xvcj0iIzIwN2NjYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM3ZGI5ZTgiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	background: -moz-linear-gradient(top,  #3b679e 0%, #2b88d9 50%, #207cca 51%, #7db9e8 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#3b679e), color-stop(50%,#2b88d9), color-stop(51%,#207cca), color-stop(100%,#7db9e8)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #3b679e 0%,#2b88d9 50%,#207cca 51%,#7db9e8 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #3b679e 0%,#2b88d9 50%,#207cca 51%,#7db9e8 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #3b679e 0%,#2b88d9 50%,#207cca 51%,#7db9e8 100%); /* IE10+ */
	background: linear-gradient(to bottom,  #3b679e 0%,#2b88d9 50%,#207cca 51%,#7db9e8 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#3b679e', endColorstr='#7db9e8',GradientType=0 ); /* IE6-8 */
	-webkit-border-radius: 10px 10px 0px 0px;
        border-radius: 10px 10px 0px 0px;
	color:#FFF;
	text-align:center;
	font-weight:bold;
}
.cabezaDia
{
	color:#FFF;
	background-color:#036;
	text-align:center;
}
.linkeable
{
	background: #a4b357; 
	background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2E0YjM1NyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM3NTg5MGMiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	background: -moz-linear-gradient(top,  #a4b357 0%, #75890c 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#a4b357), color-stop(100%,#75890c)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #a4b357 0%,#75890c 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #a4b357 0%,#75890c 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #a4b357 0%,#75890c 100%); /* IE10+ */
	background: linear-gradient(to bottom,  #a4b357 0%,#75890c 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a4b357', endColorstr='#75890c',GradientType=0 ); /* IE6-8 */	
	-webkit-border-radius: 30px;
	border-radius: 30px;
	background-color:#3CF;
	color:#FFF;
	text-align:center;	
}
.sinRelator
{	
	background: #b0d4e3; 
	background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2IwZDRlMyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM4OGJhY2YiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	background: -moz-linear-gradient(top,  #b0d4e3 0%, #88bacf 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#b0d4e3), color-stop(100%,#88bacf)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #b0d4e3 0%,#88bacf 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #b0d4e3 0%,#88bacf 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #b0d4e3 0%,#88bacf 100%); /* IE10+ */
	background: linear-gradient(to bottom,  #b0d4e3 0%,#88bacf 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b0d4e3', endColorstr='#88bacf',GradientType=0 ); /* IE6-8 */
	-webkit-border-radius: 30px;
	border-radius: 30px;
	background-color:#6FC;
	color:#FFF;
	text-align:center;	
}
.messtyle
{	
	-webkit-border-radius: 30px;
	border-radius: 30px;		
}
.noLinkeable
{

	text-align:center;
	background-color:#FFF;
}
.l_feriado
{
	color:#F00;
	text-align:center;	
	background-color:#FFF;	
}
.l_eliminado
{
	background: #f2825b; 
	background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2YyODI1YiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijg2JSIgc3RvcC1jb2xvcj0iI2U1NWIyYiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmMDcxNDYiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	background: -moz-linear-gradient(top,  #f2825b 0%, #e55b2b 86%, #f07146 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f2825b), color-stop(86%,#e55b2b), color-stop(100%,#f07146)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #f2825b 0%,#e55b2b 86%,#f07146 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #f2825b 0%,#e55b2b 86%,#f07146 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #f2825b 0%,#e55b2b 86%,#f07146 100%); /* IE10+ */
	background: linear-gradient(to bottom,  #f2825b 0%,#e55b2b 86%,#f07146 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f2825b', endColorstr='#f07146',GradientType=0 ); /* IE6-8 */
	-webkit-border-radius: 30px;
	border-radius: 30px;
	color:#FFF;
	text-align:center;		
}
.estadoCero
{
	background: #606c88;
	background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzYwNmM4OCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMzZjRjNmIiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	background: -moz-linear-gradient(top,  #606c88 0%, #3f4c6b 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#606c88), color-stop(100%,#3f4c6b)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #606c88 0%,#3f4c6b 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #606c88 0%,#3f4c6b 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #606c88 0%,#3f4c6b 100%); /* IE10+ */
	background: linear-gradient(to bottom,  #606c88 0%,#3f4c6b 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#606c88', endColorstr='#3f4c6b',GradientType=0 ); /* IE6-8 */
	-webkit-border-radius: 30px;
	border-radius: 30px;
	text-align:center;
	color:#FFF;
}
.fueraRango
{
	background-color:#FFF;
	color:#CCC;
	text-align:center;
}
a {color:#FFF;} 
a:visited {color:#FF34B3;} 
a:active {color:#FFF;} 
a:hover {color:#666;} 
</style>
<% f_busqueda.generaJS %>
</head>
<body onload ="aplicarEstilosTabla()" bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&aacute;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&aacute;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&aacute;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&aacute;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<div id="esperar" style="position: absolute; left: 300; top: 300; visibility: hidden; width: 50px; height: 50px;">
	<img src="../biblioteca/imagenes/2u95w85.gif" id="tiempo" align="middle" width="50" height="50" style="vertical-align:middle"/>
</div> 
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Año</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Programa</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "dgso_ncorr"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">M&oacute;dulo</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "mote_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Sección</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "seot_ncorr"%></td>
                              </tr>
							  <tr>
							  	<td colspan="3" align="center"><%botonera.dibujaboton "buscar"%></td>
							  </tr>
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
							</table></td>
                      </tr>
                    </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
	</tr>
	</table>
	</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
 <% 
 '***************************************'
 '* OCULTA PARTE DEL HTML SI NO HAY GET *'
 '***********************************************'
 if visible then 
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
            <td><%pagina.DibujarLenguetas Array("Ingreso de calificaciones"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><% pagina.DibujarTituloPagina %> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>
                    
<table width="99%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
 <tr>
     
        <td>
		
				<table cellspacing="0" cellpadding="0">  
					<% generaContadores() %>
				</table>
			
		<form name="proceso" action="proc_calendario_academico_otec.asp" method="post">
       <table cellspacing="0" cellpadding="0">  
			<tr >
    <td height="0" width="0" >
		<table  cellspacing="0" cellpadding="0" >
			<tr>			
			<td style="font-size:0px; visibility:hidden;"><% f_busqueda_2.dibujaCampo "dgso_tdesc2" 
	f_busqueda_2.dibujaCampo "dgso_tdesc"%></td>			
			</tr>			
			<tr>			
			<td style="font-size:0px; visibility:hidden;"><% f_busqueda_2.dibujaCampo "seot_ncorr" 
	f_busqueda_2.dibujaCampo "mote_tdesc2" %>, secci&oacute;n  <% f_busqueda_2.dibujaCampo "seot_tdesc" %></td>
			</tr>			
		</table>
    </td>
</tr>	
		</table>
		<table cellspacing="0" cellpadding="0">
          <col width="80">
          <col width="11">
          <col width="123">
          <col width="80">
          <col width="126">
          <col width="11">
          <col width="98">
          <tr>
            <td width="146">&nbsp;</td>
            <td width="14">&nbsp;</td>
            <td width="113">&nbsp;</td>
            <td width="16">&nbsp;</td>
            <td width="109">&nbsp;</td>
            <td width="10">&nbsp;</td>
            <td width="127">&nbsp;</td>
          </tr>          
          <tr>
            <td class="nombres_1">Fecha de inicio</td>
            <td class="dosPuntos">:</td>
            <td><% f_busqueda_2.dibujaCampo "dgso_finicio"
			f_busqueda_2.dibujaCampo "dgso_finicio2"%></td>
            <td>&nbsp;</td>
            <td class="nombres_1">D&iacute;a clases</td>
            <td class="dosPuntos">:</td>
            <td> <% f_busqueda_2.dibujaCampo "dias_ccod" %> 
			</td>
          </tr>
           <tr>
            <td colspan="7">&nbsp;</td>
          </tr>
          <tr>
            <td class="nombres_1">Fecha t&eacute;rmino</td>
            <td class="dosPuntos">:</td>
            <td><% f_busqueda_2.dibujaCampo "dgso_ftermino" 
			f_busqueda_2.dibujaCampo "dgso_ftermino2" %></td>
            <td>&nbsp;</td>
            <td class="nombres_1">Total horas d&iacute;a</td>
            <td class="dosPuntos">:</td>
            <td><% f_busqueda_2.dibujaCampo "horas" %></td>
          </tr>
           <tr>
            <td colspan="7" style="color:#06F;"><br/>            
            <% response.Write( "El programa tiene asignado, un total de " ) %>
			<strong>
			<% response.write( f_horasTotPro(dgso_ncorr) ) %>
			</strong>
			<% response.write( " horas y el módulo tiene un total de " ) %>
			<strong>
			<% response.write( f_HorasTotMod(seot_ncorr) )  %>
			</strong>
			<% response.write(" horas." ) %>
			<br /><br />
			<% response.Write( "(El programa tiene un total de " ) %>
			<strong>
			<% response.write( f_HorasPorMalla(dgso_ncorr) ) %>
			</strong>
			<% response.write( " horas por malla.) " ) %>	
            </td>
          </tr>          
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right"><% botonera.dibujaBoton "guardar" %></td>
          </tr>
          <tr>
            <td colspan="7">
              <table width="100%" border="0">
                <tr><br/><hr/>
                  <td width="100%"><% f_busqueda_3.DibujaTabla() %></td>
                </tr>
				<tr>
                  <td align="right" width="100%"><% botonera.dibujaBoton "eliminar" %></td>
                </tr>
                <tr width="100%">
					 <td><hr/></td>
				</tr>
                <tr width="100%">
					 <td><div width="50"><% calendario() %></div></td>
				</tr>
                <tr width="100%">
					 <td>
                     	<table width="100%" border="0">
                     	  <tr>
                     	    <td width="142">Leyenda<hr/></td>
                     	    <td width="377">&nbsp;</td>
                   	    </tr>
                     	  <tr>
                     	    <td><table width="139" border="0">
                     	      <tr>
                     	        <td class="linkeable" width="12"></td>
                     	        <td width="104">- Clase asignada</td>
                   	        </tr>
                     	      <tr>
                     	        <td class="sinRelator"></td>
                     	        <td>- Clase sin relator</td>
                   	        </tr>
                     	      <tr>
                     	        <td class="estadoCero"></td>
                     	        <td>- Clase realizada</td>
                   	        </tr>
                     	      <tr>
                     	        <td class="l_eliminado"></td>
                     	        <td>- Clase eliminada</td>
                   	        </tr>
                   	      </table></td>
                     	    <td>&nbsp;</td>                     	    
                   	    </tr>                     	 
                   	  </table>
                     </td>
				</tr>
              </table>
			 </td>			 
          </tr>
        </table>
		</form>
		</td>       
      </tr>
      
</table>                   
 <%
 end if
 '**********************************************'
 '* OCULTA PARTE DEL HTML SI NO HAY GET *'
 '***************************************'
 %>                      
                    
                    </td>
                  </tr>
				  <tr>
				  	<td align="center">
                    	
                    </td>
				  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
