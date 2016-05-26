<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
inicio = request.querystring("inicio")
termino = request.querystring("termino")
tipo = request.querystring("tipo")
tipo_2 = request.querystring("tipo_2")
'Response.Write("El tipo 1 es: "&tipo&"<hr />")
'Response.Write("El tipo 2 es: "&tipo_2&"<hr />")
'------------------control del radio tipo_2
chequeoRadio1 = ""
chequeoRadio2 = ""
if tipo_2 = "" or tipo_2 = "1" then
	chequeoRadio1 = "checked"
	ElseIf tipo_2 = "2" then
	chequeoRadio2 = "checked"
end if
'------------------control del radio tipo_2
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Alumnos con Contratos por Día"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------------------------------------------------------
set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "reportes_x_dias.xml", "botonera"

set lista = new CFormulario
lista.carga_parametros "reportes_x_dias.xml", "list_alumnos"
'----------------------------------------------------------------------------------------------------

if tipo_2 = "1" or tipo_2 = "" then

	if tipo = "3" then 
	'-----------------------------------------------'
	'	Si el radio está en Matriculados cae acá    '
	'-----------------------------------------------'
		pagina.Titulo = "Alumnos con Contratos realizados en fecha consultada"
		consulta = " select d.sede_tdesc as sede,c.cont_ncorr as n_contrato,e.econ_tdesc as estado,protic.trunc(c.cont_fcontrato) as fecha,c.cont_fcontrato as fecha2, " & vbCrLf &_
				" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut,f.pers_tnombre + ' ' + f.pers_tape_paterno + ' ' + pers_tape_materno as nombre, " & vbCrLf &_
				" h.carr_tdesc as carrera, i.jorn_tdesc as jornada,protic.ano_ingreso_carrera(a.pers_ncorr,h.carr_ccod) as promocion " & vbCrLf &_
				" from alumnos a, ofertas_Academicas b, contratos c,sedes d,estados_contrato e,personas f, " & vbCrLf &_
				" especialidades g, carreras h, jornadas i " & vbCrLf &_
				" where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				" and a.matr_ncorr=c.matr_ncorr " & vbCrLf &_
				" and b.sede_ccod=d.sede_ccod " & vbCrLf &_
				" and c.econ_ccod=e.econ_ccod " & vbCrLf &_
				" and a.pers_ncorr=f.pers_ncorr " & vbCrLf &_
				" and b.espe_ccod=g.espe_ccod and cast(b.peri_ccod as varchar)='"&periodo&"'" & vbCrLf &_
				" and g.carr_ccod=h.carr_ccod " & vbCrLf &_
				" and b.jorn_ccod=i.jorn_ccod and b.post_bnuevo = 'S' " & vbCrLf &_
				" and protic.ano_ingreso_carrera(a.pers_ncorr,h.carr_ccod) = '"&anos_ccod&"' "& vbCrLf &_
				" and not exists (select 1 from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
				"                 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				"  				 and t3.carr_ccod=h.carr_ccod and tt.pers_ncorr=a.pers_ncorr and tt.emat_ccod=1 and t2.peri_ccod < '"&periodo&"') " & vbCrLf &_
				" and c.audi_tusuario not in ('contrato -CREAR_MATRICULA_SEG_SEMESTRE') "
		if esVacio(termino) then
			consulta = consulta & " and datepart(day, c.cont_fcontrato)=datepart(day, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
						" and datepart(month, c.cont_fcontrato)=datepart(month, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
						" and datepart(year, c.cont_fcontrato)=datepart(year, convert(datetime,'"&inicio&"',103)) "			  
		else
			consulta = consulta & " and convert(datetime,protic.trunc(c.cont_fcontrato),103) >= convert(datetime,'"&inicio&"',103)  " & vbCrLf &_
									" and convert(datetime,protic.trunc(c.cont_fcontrato),103) <= convert(datetime,'"&termino&"',103)"
		end if
	elseif tipo = "2" then
	'----------------------------------------------'
	'	Si el radio está en Entrevistas cae acá    '
	'----------------------------------------------'
		pagina.Titulo = "Postulantes con test o entrevista realizada en fecha consultada"
		consulta = " select cast(h.pers_nrut as varchar)+'-'+h.pers_xdv as rut,protic.initcap(h.pers_tnombre + ' ' + h.pers_tape_paterno + ' ' + h.pers_tape_materno) as nombre,sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, " & vbCrLf &_
				" protic.trunc(dpos_fexamen) as fecha,dpos_fexamen as fecha2 " & vbCrLf &_
				" from postulantes a, detalle_postulantes b, ofertas_academicas c, sedes d, especialidades e, carreras f, " & vbCrLf &_
				" jornadas g, personas_postulante h " & vbCrLf &_
				" where a.post_ncorr=b.post_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.sede_ccod=d.sede_ccod  " & vbCrLf &_
				" and c.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  " & vbCrLf &_
				" and c.jorn_ccod=g.jorn_ccod and a.pers_ncorr=h.pers_ncorr  " & vbCrLf &_
				" and not exists (select 1 from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
				"                 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				"  				 and t3.carr_ccod=f.carr_ccod and tt.pers_ncorr=a.pers_ncorr and tt.emat_ccod=1 and t2.peri_ccod < '"&periodo&"') " & vbCrLf &_
				" and cast(a.peri_ccod as varchar)='"&periodo&"' and a.post_bnuevo = 'S' " 
		if esVacio(termino) then
			consulta = consulta & " and datepart(day, dpos_fexamen)=datepart(day, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
								" and datepart(month, dpos_fexamen)=datepart(month, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
								" and datepart(year, dpos_fexamen)=datepart(year, convert(datetime,'"&inicio&"',103)) "		  
		else
			consulta = consulta & " and convert(datetime,protic.trunc(dpos_fexamen),103) >= convert(datetime,'"&inicio&"',103)  " & vbCrLf &_
								" and convert(datetime,protic.trunc(dpos_fexamen),103) <= convert(datetime,'"&termino&"',103)"
		end if
	else
	'---------------------------------------'
	'	Si no hay ningún radio activo o 	'
	'	está matriculado cae acá    		'	
	'---------------------------------------'
		pagina.Titulo = "Postulaciones realizadas en fecha consultada"
		consulta = " select cast(h.pers_nrut as varchar)+'-'+h.pers_xdv as rut,protic.initcap(h.pers_tnombre + ' ' + h.pers_tape_paterno + ' ' + h.pers_tape_materno) as nombre,sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, " & vbCrLf &_
				" protic.trunc(fecha_asignacion_carrera) as fecha,fecha_asignacion_carrera as fecha2 " & vbCrLf &_
				" from postulantes a, detalle_postulantes b, ofertas_academicas c, sedes d, especialidades e, carreras f, " & vbCrLf &_
				" jornadas g, personas_postulante h " & vbCrLf &_
				" where a.post_ncorr=b.post_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.sede_ccod=d.sede_ccod  " & vbCrLf &_
				" and c.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  " & vbCrLf &_
				" and c.jorn_ccod=g.jorn_ccod and a.pers_ncorr=h.pers_ncorr  " & vbCrLf &_
				" and not exists (select 1 from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
				"                 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				"  				 and t3.carr_ccod=f.carr_ccod and tt.pers_ncorr=a.pers_ncorr and tt.emat_ccod=1 and t2.peri_ccod < '"&periodo&"') " & vbCrLf &_
				" and cast(a.peri_ccod as varchar)='"&periodo&"' and a.post_bnuevo = 'S' " 
		if esVacio(termino) then
				consulta = consulta & " and datepart(day, fecha_asignacion_carrera)=datepart(day, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
									" and datepart(month, fecha_asignacion_carrera)=datepart(month, convert(datetime,'"&inicio&"',103))  " & vbCrLf &_
									" and datepart(year, fecha_asignacion_carrera)=datepart(year, convert(datetime,'"&inicio&"',103)) "		  
		else
			consulta = consulta & " and convert(datetime,protic.trunc(fecha_asignacion_carrera),103) >= convert(datetime,'"&inicio&"',103)  " & vbCrLf &_
									" and convert(datetime,protic.trunc(fecha_asignacion_carrera),103) <= convert(datetime,'"&termino&"',103)"
				
		end if	
	end if	
	'response.Write("<pre>"&consulta&"<hr />Tipo = "& tipo &": </pre>")
	'response.Write("<pre>"&consulta&" order by fecha2 asc</pre>")
	lista.inicializar conexion 
	lista.consultar consulta & " order by fecha2 asc"
	if lista.nroFilas > 0 then
		cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
	else
		cantidad_encontrados=0
	end if
'---------------------------------------------------------------------------------------------fin ifs de consulta
	else
	
'---------------------------------------------------------------variables necesarias
	lista.inicializar conexion 
	periodo = negocio.obtenerPeriodoAcademico("Postulacion")
	anio = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'---------------------------------------------------------------variables necesarias	
		if tipo = "3" then 
		'-------------------------------------------------------------tipo_matriculado_tipo3
			pagina.Titulo = "Alumnos matriculados en la fecha consultada"
			consulta = " select cast(d.pers_nrut as varchar) + '-' " & vbCrlf & _
			"       + d.pers_xdv                       as rut,     " & vbCrlf & _
			"       d.pers_tape_paterno + ' ' + pers_tape_materno  " & vbCrlf & _
			"       + ', ' + pers_tnombre              as nombre,  " & vbCrlf & _
			"       f.sede_tdesc                       as sede,    " & vbCrlf & _
			"       e.dcur_tdesc                       as carrera, " & vbCrlf & _
			"       'DIURNO'                           as jornada, " & vbCrlf & _
			"       protic.trunc(a.audi_fmodificacion) as fecha,   " & vbCrlf & _
			"       a.audi_fmodificacion               as fecha2   " & vbCrlf & _
			"from   postulacion_otec as a                          " & vbCrlf & _
			"       inner join datos_generales_secciones_otec as b " & vbCrlf & _
			"               on a.dgso_ncorr = b.dgso_ncorr         " & vbCrlf & _
			"       inner join ofertas_otec as c                   " & vbCrlf & _
			"               on b.dgso_ncorr = c.dgso_ncorr         " & vbCrlf & _
			"       inner join personas as d                       " & vbCrlf & _
			"               on a.pers_ncorr = d.pers_ncorr         " & vbCrlf & _
			"       inner join diplomados_cursos as e              " & vbCrlf & _
			"               on b.dcur_ncorr = e.dcur_ncorr         " & vbCrlf & _
			"       inner join sedes as f                          " & vbCrlf & _
			"               on b.sede_ccod = f.sede_ccod           " & vbCrlf & _
			"where  a.epot_ccod = '4'--estado matriculado          " & vbCrlf & _
			"       and protic.trunc(a.audi_fmodificacion) between " & vbCrlf & _
			"           convert(datetime, '"&inicio&"', 103) and   " & vbCrlf & _
			"           convert(datetime, '"&termino&"', 103) 	   " 
		'-------------------------------------------------------------tipo_matriculado
		end if
		if tipo = "2" then 
		'-------------------------------------------------------------tipo_en entrevista tipo 2
			pagina.Titulo = "Postulantes con entrevista realizada en fecha consultada"
			consulta = " select distinct cast(d.pers_nrut as varchar) + '-' " & vbCrlf & _
			"                + d.pers_xdv                       as rut,     " & vbCrlf & _
			"                d.pers_tape_paterno + ' ' + pers_tape_materno  " & vbCrlf & _
			"                + ', ' + pers_tnombre              as nombre,  " & vbCrlf & _
			"                f.sede_tdesc                       as sede,    " & vbCrlf & _
			"                e.dcur_tdesc                       as carrera, " & vbCrlf & _
			"                'DIURNO'                           as jornada, " & vbCrlf & _
			"                protic.trunc(g.audi_fmodificacion) as fecha,   " & vbCrlf & _
			"                g.audi_fmodificacion               as fecha2   " & vbCrlf & _
			"from   postulacion_otec as a                                   " & vbCrlf & _
			"       inner join datos_generales_secciones_otec as b          " & vbCrlf & _
			"               on a.dgso_ncorr = b.dgso_ncorr                  " & vbCrlf & _
			"       inner join ofertas_otec as c                            " & vbCrlf & _
			"               on b.dgso_ncorr = c.dgso_ncorr                  " & vbCrlf & _
			"       inner join personas as d                                " & vbCrlf & _
			"               on a.pers_ncorr = d.pers_ncorr                  " & vbCrlf & _
			"       inner join diplomados_cursos as e                       " & vbCrlf & _
			"               on b.dcur_ncorr = e.dcur_ncorr                  " & vbCrlf & _
			"       inner join sedes as f                                   " & vbCrlf & _
			"               on b.sede_ccod = f.sede_ccod                    " & vbCrlf & _
			"       inner join detalle_postulacion_otec as g                " & vbCrlf & _
			"               on g.eepo_ccod = '8'                            " & vbCrlf & _
			"where  d.pers_nrut is not null   and a.epot_ccod <> 5          " & vbCrlf & _
			"       and protic.trunc(a.audi_fmodificacion) between          " & vbCrlf & _
			"           convert(datetime, '"&inicio&"', 103) and            " & vbCrlf & _
			"           convert(datetime, '"&termino&"', 103)                "
		'-------------------------------------------------------------tipo_en entrevista tipo 3
		end if
		if tipo = "1" then 
		'-------------------------------------------------------------tipo_1
			pagina.Titulo = "Postulaciones realizadas en fecha consultada"
			consulta = " select cast(d.pers_nrut as varchar) + '-' " & vbCrlf & _
			"       + d.pers_xdv                      as rut,      " & vbCrlf & _
			"       d.pers_tape_paterno + ' ' + pers_tape_materno  " & vbCrlf & _
			"       + ', ' + pers_tnombre             as nombre,   " & vbCrlf & _
			"       f.sede_tdesc                      as sede,     " & vbCrlf & _
			"       e.dcur_tdesc                      as carrera,  " & vbCrlf & _
			"       'DIURNO'                          as jornada,  " & vbCrlf & _
			"       protic.trunc(a.fecha_postulacion) as fecha,    " & vbCrlf & _
			"       a.fecha_postulacion               as fecha2    " & vbCrlf & _
			"from   postulacion_otec as a                          " & vbCrlf & _
			"       inner join datos_generales_secciones_otec as b " & vbCrlf & _
			"               on a.dgso_ncorr = b.dgso_ncorr         " & vbCrlf & _
			"       inner join ofertas_otec as c                   " & vbCrlf & _
			"               on b.dgso_ncorr = c.dgso_ncorr         " & vbCrlf & _
			"       inner join personas as d                       " & vbCrlf & _
			"               on a.pers_ncorr = d.pers_ncorr         " & vbCrlf & _
			"       inner join diplomados_cursos as e              " & vbCrlf & _
			"               on b.dcur_ncorr = e.dcur_ncorr         " & vbCrlf & _
			"       inner join sedes as f                          " & vbCrlf & _
			"               on b.sede_ccod = f.sede_ccod           " & vbCrlf & _
			"where  a.epot_ccod <> 5 and protic.trunc(a.fecha_postulacion) between      " & vbCrlf & _
			"       convert(datetime, '"&inicio&"', 103) and       " & vbCrlf & _
			"       convert(datetime, '"&termino&"', 103) 	       "
		'-------------------------------------------------------------tipo_1
		end if
		if tipo = "" then 
		'-------------------------------------------------------------tipo_vacio
			pagina.Titulo = "Postulaciones realizadas en fecha consultada"
			consulta = " select cast(d.pers_nrut as varchar) + '-' " & vbCrlf & _
			"       + d.pers_xdv                      as rut,      " & vbCrlf & _
			"       d.pers_tape_paterno + ' ' + pers_tape_materno  " & vbCrlf & _
			"       + ', ' + pers_tnombre             as nombre,   " & vbCrlf & _
			"       f.sede_tdesc                      as sede,     " & vbCrlf & _
			"       e.dcur_tdesc                      as carrera,  " & vbCrlf & _
			"       'DIURNO'                          as jornada,  " & vbCrlf & _
			"       protic.trunc(a.fecha_postulacion) as fecha,    " & vbCrlf & _
			"       a.fecha_postulacion               as fecha2    " & vbCrlf & _
			"from   postulacion_otec as a                          " & vbCrlf & _
			"       inner join datos_generales_secciones_otec as b " & vbCrlf & _
			"               on a.dgso_ncorr = b.dgso_ncorr         " & vbCrlf & _
			"       inner join ofertas_otec as c                   " & vbCrlf & _
			"               on b.dgso_ncorr = c.dgso_ncorr         " & vbCrlf & _
			"       inner join personas as d                       " & vbCrlf & _
			"               on a.pers_ncorr = d.pers_ncorr         " & vbCrlf & _
			"       inner join diplomados_cursos as e              " & vbCrlf & _
			"               on b.dcur_ncorr = e.dcur_ncorr         " & vbCrlf & _
			"       inner join sedes as f                          " & vbCrlf & _
			"               on b.sede_ccod = f.sede_ccod           " & vbCrlf & _
			"where  a.epot_ccod <> 5 and protic.trunc(a.fecha_postulacion) between      " & vbCrlf & _
			"       convert(datetime, '"&inicio&"', 103) and       " & vbCrlf & _
			"       convert(datetime, '"&termino&"', 103) 	       "
		'-------------------------------------------------------------tipo_vacio	
		end if	
	lista.consultar consulta & " order by fecha2 asc"	
	if lista.nroFilas > 0 then
		cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
	else
		cantidad_encontrados=0
	end if
		
end if	
seleccionado1=""
seleccionado2=""
seleccionado3=""
if tipo = "1" then 
	seleccionado1="checked"
end if
if tipo = "2" then 
	seleccionado2="checked"
end if
if tipo = "3" then 
	seleccionado3="checked"
end if

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

function enviar(formulario)
{
document.buscador.method="get";
document.buscador.action="reportes_x_dias.asp";
document.buscador.submit();
}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "termino","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="27%"><strong>Fecha(desde)</strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>"><%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa) </td>
                        </tr>
						<tr> 
                                <td width="27%"><strong>Fecha Hasta (Opcional)</strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>"><%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                            (dd/mm/aaaa) </td>
                        </tr>
						<tr>
							<td colspan="3" align="center">
								<table width="95%" cellpadding="0" cellspacing="0">                                	
									<tr>
										<td width="33%" align="right">
											<strong>Postulaciones </strong><input type="radio" name="tipo" value="1" <%=seleccionado1%>>
										</td>
										<td width="34%" align="right">
											<strong>Entrevistas </strong><input type="radio" name="tipo" value="2" <%=seleccionado2%>>
										</td>
										<td width="33%" align="right">
											<strong>Matriculados </strong><input type="radio" name="tipo" value="3" <%=seleccionado3%>>
										</td>
									</tr>                                  
                                    <tr valign="middle" bordercolor="#CCCCCC"  style=" -webkit-border-radius: 10px; border-radius: 10px; background:#09C; color:#FFF; border-right:double;">
                                    
                                    	<td width="33%" align="right">
											<strong>Pregrado y Postgrado </strong><input type="radio" name="tipo_2" value="1" <%=chequeoRadio1%>>
										</td>
										<td width="34%" align="right">
											<strong>Extensi&oacuten </strong><input type="radio" name="tipo_2" value="2" <%=chequeoRadio2%>>
										</td>  
                                    </tr>
								</table>
							</td>
						</tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumno(s) &nbsp;
					   <%if not Esvacio(inicio) then%>
					      para el <%=inicio%> - <%=termino%>
					   <%end if%>,<br>correspondiente a admisión <%=periodo_tdesc%>. 
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr>
								 <td align="right">&nbsp;
								 </td>
                             </tr>
							 <tr>
								 <td align="right">P&aacute;gina:
									 <%lista.accesopagina%>
								 </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%lista.dibujaTabla()%>
                                  </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
							</table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                <div>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center"><%  if cantidad_encontrados = 0 then
				                                                f_botonera.agregabotonparam "excel","deshabilitado","TRUE"    
														   end if																             
														   f_botonera.agregabotonparam "excel", "url", "reportes_x_dias_excel.asp?inicio="&inicio&"&termino="&termino&"&tipo="&tipo&"&tipo_2="&tipo_2
														   f_botonera.dibujaboton "excel"
										               %>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</html>
