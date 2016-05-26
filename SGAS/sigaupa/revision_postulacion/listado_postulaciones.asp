<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de Postulantes"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
session("rut_postulacion") = rut
digito = request.querystring("busqueda[0][pers_xdv]")
session("digito_postulacion") = digito
sede = request.querystring("busqueda[0][sede_ccod]")
session("sede_postulacion") = sede
selecciono_carrera = request.querystring("selecciono_carrera")
session("s_c_postulacion") = selecciono_carrera
ingreso_familia = request.querystring("ingreso_familia")
session("i_f_postulacion") = ingreso_familia
postulacion_enviada = request.querystring("postulacion_enviada")
session("p_e_postulacion") = postulacion_enviada
test_rendido = request.querystring("test_rendido")
session("t_r_postulacion") = test_rendido
matriculado = request.querystring("matriculado")
session("m_postulacion") = matriculado
revisar = request.querystring("revisar")
session("r_postulacion") = revisar
tipo_postulante = request.querystring("tipo_postulante")
session("r_tipo_postulante") = tipo_postulante

check_postulante1=""
check_postulante2=""
check_postulante3=""

if tipo_postulante = "1" or tipo_postulante="" then
	check_postulante1 = "checked"
elseif tipo_postulante = "2" then
	check_postulante2 = "checked"
elseif tipo_postulante = "3" then
	check_postulante3 = "checked"
end if
'--------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
consulta_sede = "(select distinct b.sede_ccod,b.sede_tdesc from ofertas_Academicas a, sedes b where a.sede_ccod = b.sede_ccod and cast(peri_ccod as varchar)='"&periodo&"')a"

'if periodo > "205" then'-----------------------------solo actualizará los estados cuando se busque inf. del 2007.
'	conexion.ejecutaS "execute calificar_test_ingreso"
'end if

anio = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_postulaciones.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.agregaCampoParam "sede_ccod" , "destino" , consulta_sede
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
 f_busqueda.AgregaCampoCons "sede_ccod", sede
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_postulaciones.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "listado_postulaciones.xml", "f_listado"
formulario.Inicializar conexion

consulta = " select distinct pers_ncorr,rut,alumno,con_carrera_seleccionada,postulacion_enviada,con_familia_ingresada,con_codeudor,examen_rendido, "& vbcrlf & _
		   " matriculado,fecha_modificacion1,protic.trunc(fecha_modificacion1) as fecha_modificacion "& vbcrlf & _
		   " from ( "& vbcrlf & _
		   " select a.pers_ncorr,cast(pers_nrut as varchar) + '-' + pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno +', '+pers_tnombre as alumno,  "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) as con_carrera_seleccionada, "& vbcrlf & _
		   " case b.epos_ccod when 2 then 'Sí' else 'No' end as postulacion_enviada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf where b.post_ncorr = gf.post_ncorr) as con_familia_ingresada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from codeudor_postulacion cp (nolock) where b.post_ncorr = cp.post_ncorr) as con_codeudor, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr and eepo_ccod not in (1,5)) as examen_rendido, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock),alumnos alu (nolock) where dp.post_ncorr=b.post_ncorr and alu.post_ncorr=dp.post_ncorr and alu.ofer_ncorr=dp.ofer_ncorr and emat_ccod=1) as matriculado, "& vbcrlf & _
		   " isnull(e.audi_fmodificacion,isnull(c.audi_fmodificacion,b.audi_fmodificacion)) as fecha_modificacion1 "& vbcrlf & _
		   " from personas_postulante a (nolock) join  postulantes b (nolock) "& vbcrlf & _
		   "    on a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
		   " left outer join detalle_postulantes c (nolock) "& vbcrlf & _
		   "    on  b.post_ncorr = c.post_ncorr "& vbcrlf & _
		   " left outer join observaciones_postulacion e (nolock) "& vbcrlf & _
		   "    on e.post_ncorr= c.post_ncorr and e.ofer_ncorr=c.ofer_ncorr "& vbcrlf & _
		   " left outer join ofertas_academicas d "& vbcrlf & _
		   "    on  c.ofer_ncorr = d.ofer_ncorr "& vbcrlf & _
		   " left outer join especialidades dd "& vbcrlf & _
		   "    on  d.espe_ccod = dd.espe_ccod "& vbcrlf & _
		   " where  cast(b.peri_ccod as varchar)='"&periodo&"' and b.post_bnuevo='S' "& vbCrLf &_
		   " and not exists (select 1 from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
		   "                 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
		   "  				 and t3.carr_ccod=dd.carr_ccod and tt.pers_ncorr=a.pers_ncorr and tt.emat_ccod=1 and t2.peri_ccod < '"&periodo&"') " 
		  

if rut <> "" then
	consulta = consulta & " and cast(a.pers_nrut as varchar)='"&rut&"' "
end if

if selecciono_carrera = "1" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) = 'Sí'"
elseif selecciono_carrera = "2" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) = 'No'"
end if
if ingreso_familia = "1" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf where b.post_ncorr = gf.post_ncorr) = 'Sí'"
elseif ingreso_familia = "2" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf where b.post_ncorr = gf.post_ncorr) = 'No'"
end if
if postulacion_enviada = "1" then
	consulta = consulta & " and case b.epos_ccod when 2 then 'Sí' else 'No' end = 'Sí'"
elseif postulacion_enviada = "2" then
	consulta = consulta & " and case b.epos_ccod when 2 then 'Sí' else 'No' end = 'No'"
end if	
if test_rendido = "1" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr  and eepo_ccod not in (1,5)) = 'Sí'"
elseif test_rendido = "2" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr and eepo_ccod not in (1,5)) = 'No'"
end if		   

if matriculado = "1" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock),alumnos alu (nolock) where dp.post_ncorr=b.post_ncorr and alu.post_ncorr=dp.post_ncorr and alu.ofer_ncorr=dp.ofer_ncorr and emat_ccod=1) = 'Sí'"
elseif matriculado = "2" then
	consulta = consulta & " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock),alumnos alu (nolock) where dp.post_ncorr=b.post_ncorr and alu.post_ncorr=dp.post_ncorr and alu.ofer_ncorr=dp.ofer_ncorr and emat_ccod=1) = 'No'"
end if		

if sede <> "" then
	consulta = consulta & " and cast(d.sede_ccod as varchar)='"&sede&"' "
end if
   
'response.Write("<pre>"&consulta&"</pre>")
	

if revisar ="" then
	consulta = "select * from (select '' as pers_ncorr,'' as fecha_modificacion1,'' as alumno from sexos where 1=2"
end if
'response.Write("<pre>"&consulta & " order by a order by fecha_modificacion1,alumno</pre>")
'cantidad_encontrados = conexion.consultaUno("select count(distinct pers_ncorr) from ("&consulta&")a)aa")	   

consulta = consulta & " ) a order by fecha_modificacion1,alumno"


if tipo_postulante = "2" then

	consulta =  " select d.pers_ncorr,cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, " & vbCrLf &_
				" d.pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno, " & vbCrLf &_
				" 'Sí' as con_carrera_seleccionada, " & vbCrLf &_
				" case a.epot_ccod when 1 then 'No' else 'Sí' end as postulacion_enviada, " & vbCrLf &_
				" 'No' as con_familia_ingresada, 'No' as con_codeudor, 'No' as examen_rendido,  " & vbCrLf &_
				" case a.epot_ccod when 4 then 'Sí' else 'No' end as matriculado, " & vbCrLf &_
				" a.AUDI_FMODIFICACION as fecha_modificacion1, protic.trunc(a.AUDI_FMODIFICACION) as fecha_modificacion " & vbCrLf &_
				" from postulacion_otec a, datos_generales_secciones_otec b, ofertas_otec c, personas d " & vbCrLf &_
				" where a.dgso_ncorr=b.dgso_ncorr and b.dgso_ncorr=c.dgso_ncorr and a.pers_ncorr=d.pers_ncorr " & vbCrLf &_
				" and cast(c.anio_admision as varchar)='"&anio&"' and a.epot_ccod <> 5 "
'response.Write("<pre>"&consulta&"</pre>")				
	if postulacion_enviada = "1" then
		consulta = consulta & " and a.epot_ccod <> 1 "
	elseif postulacion_enviada = "2" then
		consulta = consulta & " and a.epot_ccod = 1 "
	end if
	
	if rut <> "" then
		consulta = consulta & " and cast(d.pers_nrut as varchar)='"&rut&"' "
	end if
	
	if matriculado = "1" then
		consulta = consulta & " and a.epot_ccod = 4"
	elseif matriculado = "2" then
		consulta = consulta & " and a.epot_ccod <> 4 "
	end if		
	
	if sede <> "" then
		consulta = consulta & " and cast(b.sede_ccod as varchar)='"&sede&"' "
	end if
				
	consulta = consulta & " order by fecha_modificacion1,alumno"

end if


if tipo_postulante = "3" then


	consulta =  " select id as pers_ncorr, replace(cast(rut as varchar),'.','') as rut, cast(apellido as varchar) + ' ' + cast(nombre as varchar) as alumno, " & vbCrLf &_
				" 'No' as con_carrera_seleccionada, " & vbCrLf &_
				" 'No' as postulacion_enviada, " & vbCrLf &_
				" 'No' as con_familia_ingresada, 'No' as con_codeudor, 'No' as examen_rendido,   " & vbCrLf &_
				" 'No' as matriculado,  " & vbCrLf &_
				" a.Fecha_ingreso as fecha_modificacion1, protic.trunc(a.Fecha_ingreso) as fecha_modificacion " & vbCrLf &_
				" from [ASPT].[dbo].[PROSPECTOS] a " & vbCrLf &_
				" where cast(datepart(year,a.Fecha_ingreso) as varchar) = '"&anio&"'  " & vbCrLf &_
				" and len(cast(apellido as varchar) + ' ' + cast(nombre as varchar)) > 5 " & vbCrLf &_
				" and cast(rut as varchar) not like '%http%' "
				
	
	consulta = consulta & " order by fecha_modificacion1,alumno"

end if

formulario.Consultar consulta 

'response.Write("<pre>"&consulta&") a order by fecha_modificacion1,alumno</pre>")


'--------buscamos los casos urgentes de la sede, vale decir postulaciones enviadas y sin test rendido que ya llevan una semana en espera

'set formulario_urgencias = new CFormulario
'formulario_urgencias.Carga_Parametros "listado_postulaciones.xml", "f_listado"
'formulario_urgencias.Inicializar conexion
'if sede <> "" then
'	sede_a_buscar = sede
'else	
'	sede_a_buscar= negocio.obtenerSede
'end if	

consulta_emergencias = " select distinct pers_ncorr,'<font color=''#0033FF''>' + rut + '</font>' as rut,'<font color=''#0033FF''>' +alumno+ '</font>' as alumno,con_carrera_seleccionada,postulacion_enviada,con_familia_ingresada,con_codeudor,examen_rendido, "& vbcrlf & _
		   " matriculado,fecha_modificacion1,protic.trunc(fecha_modificacion1) as fecha_modificacion "& vbcrlf & _
		   " from ( "& vbcrlf & _
		   " select a.pers_ncorr,cast(pers_nrut as varchar) + '-' + pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno +', '+pers_tnombre as alumno,  "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) as con_carrera_seleccionada, "& vbcrlf & _
		   " case b.epos_ccod when 2 then 'Sí' else 'No' end as postulacion_enviada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf (nolock) where b.post_ncorr = gf.post_ncorr) as con_familia_ingresada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from codeudor_postulacion cp (nolock) where b.post_ncorr = cp.post_ncorr) as con_codeudor, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr and eepo_ccod not in (1,5)) as examen_rendido, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock),alumnos alu (nolock) where dp.post_ncorr=b.post_ncorr and alu.post_ncorr=dp.post_ncorr and alu.ofer_ncorr=dp.ofer_ncorr and emat_ccod=1) as matriculado, "& vbcrlf & _
		   " isnull(tt.audi_fmodificacion,isnull(c.audi_fmodificacion,b.audi_fmodificacion)) as fecha_modificacion1 "& vbcrlf & _
		   " from personas_postulante a (nolock) join  postulantes b (nolock) "& vbcrlf & _
		   "    on a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
		   " left outer join detalle_postulantes c (nolock) "& vbcrlf & _
		   "    on  b.post_ncorr = c.post_ncorr "& vbcrlf & _
		   " left outer join observaciones_postulacion tt (nolock) "& vbcrlf & _
		   "    on tt.post_ncorr= c.post_ncorr and tt.ofer_ncorr=c.ofer_ncorr "& vbcrlf & _
		   " left outer join ofertas_academicas d "& vbcrlf & _
		   "    on  c.ofer_ncorr = d.ofer_ncorr "& vbcrlf & _
		   " join observaciones_postulacion e (nolock) "& vbcrlf & _
		   "    on c.post_ncorr= e.post_ncorr and c.ofer_ncorr = e.ofer_ncorr "& vbcrlf & _
		   " where  cast(b.peri_ccod as varchar)='"&periodo&"' and cast(d.sede_ccod as varchar)='"&sede_a_buscar&"' and b.post_bnuevo='S' "& vbcrlf & _
		   " and protic.trunc(getDate()) = protic.trunc(e.fecha_llamado))a"& vbcrlf & _
           " UNION ALL"& vbcrlf & _
		   " select distinct pers_ncorr,rut,alumno,con_carrera_seleccionada,postulacion_enviada,con_familia_ingresada,con_codeudor,examen_rendido, "& vbcrlf & _
		   " matriculado,fecha_modificacion1,protic.trunc(fecha_modificacion1) as fecha_modificacion "& vbcrlf & _
		   " from ( "& vbcrlf & _
		   " select a.pers_ncorr,cast(pers_nrut as varchar) + '-' + pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno +', '+pers_tnombre as alumno,  "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) as con_carrera_seleccionada, "& vbcrlf & _
		   " case b.epos_ccod when 2 then 'Sí' else 'No' end as postulacion_enviada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf (nolock) where b.post_ncorr = gf.post_ncorr) as con_familia_ingresada, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from codeudor_postulacion cp (nolock) where b.post_ncorr = cp.post_ncorr) as con_codeudor, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr and eepo_ccod not in (1,5)) as examen_rendido, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock),alumnos alu (nolock) where dp.post_ncorr=b.post_ncorr and alu.post_ncorr=dp.post_ncorr and alu.ofer_ncorr=dp.ofer_ncorr and emat_ccod=1) as matriculado, "& vbcrlf & _
		   " (select isnull(max(dp.audi_fmodificacion),isnull(b.post_fpostulacion,b.audi_fmodificacion)) from observaciones_postulacion dp (nolock) where dp.post_ncorr=b.post_ncorr) as fecha_modificacion1 "& vbcrlf & _
		   " from personas_postulante a (nolock) join  postulantes b (nolock) "& vbcrlf & _
		   "    on a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
		   " left outer join detalle_postulantes c (nolock) "& vbcrlf & _
		   "    on  b.post_ncorr = c.post_ncorr "& vbcrlf & _
		   " left outer join ofertas_academicas d (nolock) "& vbcrlf & _
		   "    on  c.ofer_ncorr = d.ofer_ncorr "& vbcrlf & _
		   " where  cast(b.peri_ccod as varchar)='"&periodo&"' and cast(d.sede_ccod as varchar)='"&sede_a_buscar&"' and b.post_bnuevo='S' "& vbcrlf & _
		   " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr) = 'Sí'"& vbcrlf & _
		   " and (select case count(*) when 0 then 'No' else 'Sí' end from grupo_familiar gf (nolock) where b.post_ncorr = gf.post_ncorr) = 'Sí'"	& vbcrlf & _
 		   " and case b.epos_ccod when 2 then 'Sí' else 'No' end = 'Sí'"& vbcrlf & _
		   " and (select case count(*) when 0 then 'No' else 'Sí' end  from detalle_postulantes dp (nolock) where dp.post_ncorr=b.post_ncorr and dp.ofer_ncorr = c.ofer_ncorr and eepo_ccod not in (1,5)) = 'No'"& vbcrlf & _
		   " and b.audi_fmodificacion <= getDate()-7"

'cantidad_emergencias = conexion.consultaUno("select count(distinct pers_ncorr) from ("&consulta_emergencias&")a)aa")	   
'formulario_urgencias.Consultar consulta_emergencias & " ) a order by fecha_modificacion1,alumno"
''response.Write("<pre>"&consulta_emergencias & " ) a order by fecha_modificacion1,alumno</pre>")
		   
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

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="23%">Rut Usuario</td>
                                      <td width="2%">:</td>
                                      <td width="26%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                      <td width="24%" align="right">Seleccione sede</td>
                                      <td width="2%">:</td>
                                      <td width="23%"><%f_busqueda.DibujaCampo("sede_ccod")%></td>
								    </tr>
									<tr> 
                                      <td width="23%">Seleccion&oacute; Carrera?</td>
                                      <td width="2%">:</td>
                                      <td width="26%"><select name='selecciono_carrera'>
														<%if selecciono_carrera="" then%>
														<option value='' selected>Todos</option>
														<%else%>
														<option value=''>Todos</option>
														<%end if%>
														<%if selecciono_carrera="1" then%>
														<option value='1' selected>Sí</option>
														<%else%>
														<option value='1' >Sí</option>
														<%end if%>
														<%if selecciono_carrera="2" then%>
														<option value='2' selected>No</option>
														<%else%>
														<option value='2' >No</option>
														<%end if%>
													  </select> 
									  </td>
										<td width="24%" align="right">Ingres&oacute; Familiares?</td>
                                      	<td width="2%">:</td>
                                      	<td width="23%"><select name='ingreso_familia'>
														<%if ingreso_familia="" then%>
														<option value='' selected>Todos</option>
														<%else%>
														<option value=''>Todos</option>
														<%end if%>
														<%if ingreso_familia="1" then%>
														<option value='1' selected>Sí</option>
														<%else%>
														<option value='1' >Sí</option>
														<%end if%>
														<%if ingreso_familia="2" then%>
														<option value='2' selected>No</option>
														<%else%>
														<option value='2' >No</option>
														<%end if%>
													  </select> </td>
                                    </tr>
									<tr> 
                                      <td width="23%">Postulaci&oacute;n Enviada?</td>
                                      <td width="2%">:</td>
                                      <td width="26%"><select name='postulacion_enviada'>
														<%if postulacion_enviada="" then%>
														<option value='' selected>Todos</option>
														<%else%>
														<option value=''>Todos</option>
														<%end if%>
														<%if postulacion_enviada="1" then%>
														<option value='1' selected>Sí</option>
														<%else%>
														<option value='1' >Sí</option>
														<%end if%>
														<%if postulacion_enviada="2" then%>
														<option value='2' selected>No</option>
														<%else%>
														<option value='2' >No</option>
														<%end if%>
													  </select> 
									  </td>
										<td width="24%" align="right">Test Rendido?</td>
                                      	<td width="2%">:</td>
                                      	<td width="23%"><select name='test_rendido'>
														<%if test_rendido="" then%>
														<option value='' selected>Todos</option>
														<%else%>
														<option value=''>Todos</option>
														<%end if%>
														<%if test_rendido="1" then%>
														<option value='1' selected>Sí</option>
														<%else%>
														<option value='1' >Sí</option>
														<%end if%>
														<%if test_rendido="2" then%>
														<option value='2' selected>No</option>
														<%else%>
														<option value='2' >No</option>
														<%end if%>
													  </select> </td>
                                    </tr>
									<tr> 
                                      <td width="23%">Matriculado?</td>
                                      <td width="2%">:</td>
                                      <td width="26%"><select name='matriculado'>
														<%if matriculado = "" then%>
														<option value='' selected>Todos</option>
														<%else%>
														<option value=''>Todos</option>
														<%end if%>
														<%if matriculado = "1" then%>
														<option value='1' selected>Sí</option>
														<%else%>
														<option value='1' >Sí</option>
														<%end if%>
														<%if matriculado="2" then%>
														<option value='2' selected>No</option>
														<%else%>
														<option value='2' >No</option>
														<%end if%>
													  </select> 
									  </td>
										<td width="24%" align="right">&nbsp;</td>
                                      	<td width="2%">&nbsp;</td>
                                      	<td width="23%">&nbsp;<input type="hidden" name="revisar" value="1"></td>
                                    </tr>
                                    <tr>
                                      <td colspan="6" align="center">
                                          <table width="90%" cellpadding="0" cellspacing="0" bgcolor="#66CCFF">
                                            <tr>
                                              <td width="5%" align="center">
                                                <input type="radio" name="tipo_postulante" value="1" <%=check_postulante1%>>
                                              </td>
                                              <td width="29%" align="left">Pregrado y Postgrado</td>
                                               <td width="5%" align="center">
                                                <input type="radio" name="tipo_postulante" value="2" <%=check_postulante2%>>
                                              </td>
                                              <td width="28%" align="left">Extensión</td>
                                               <td width="5%" align="center">
                                                <input type="radio" name="tipo_postulante" value="3" <%=check_postulante3%>>
                                              </td>
                                              <td width="28%" align="left">Prospecto extensión</td>
                                            </tr>
                                          </table>
                                      </td> 
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE">
				  <table width="98%" border="0">
                    <tr> 
                       <td width="100%">&nbsp;</td>
					</tr>
					<tr> 
                       <td width="100%"><div align="center"><%pagina.DibujarTituloPagina%>
                        </div></td>
					</tr>
					<!--<tr> 
                       <td width="100%">&nbsp;</td>
					</tr>
					<tr> 
                       <td width="100%"><%'pagina.DibujarSubTitulo("Comunicarse Urgentemente con...")%></td>
					</tr>
					<tr> 
                       <td width="100%">&nbsp;</td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left">Total encontrado : <%'=cantidad_emergencias%> postulante(s)</div>
						<div align="right">P&aacute;ginas: &nbsp; 
                          <%'formulario_urgencias.AccesoPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="center"><form name="edicion2">
														<div align="center">
														  <% 'formulario_urgencias.DibujaTabla %>
														</div>
													  </form>
													
				        </td>
					</tr>
					<tr>
						<td width="100%" align="right">Las Personas cuyo nombre esté en azul deben ser llamadas hoy.</td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>-->
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%"><%pagina.DibujarSubTitulo("Resultado búsqueda")%></td>
					</tr>
					<tr> 
                       <td width="100%"><!--<div align="left">Total encontrado : <%'=cantidad_encontrados%> postulante(s)</div>-->
                        <div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario.AccesoPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="center"><form name="edicion"> 
														<div align="center">
														  <% formulario.DibujaTabla %>
														</div>
													  </form>
													  <br>
				        </td>
					</tr>
                  </table> 
                  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					   <td><div align="center">  
				        <%
						  'botonera.agregabotonparam "excel", "url", "http://sbd03.upacifico.cl/sigaupa/revision_postulacion/listado_postulaciones_excel.asp?rut="&rut&"&sede="&sede&"&selecciono_carrera="&selecciono_carrera&"&ingreso_familia="&ingreso_familia&"&postulacion_enviada="&postulacion_enviada&"&test_rendido="&test_rendido&"&matriculado="&matriculado&"&periodo="&periodo
						  botonera.agregabotonparam "excel", "url", "listado_postulaciones_excel.asp?rut="&rut&"&sede="&sede&"&selecciono_carrera="&selecciono_carrera&"&ingreso_familia="&ingreso_familia&"&postulacion_enviada="&postulacion_enviada&"&test_rendido="&test_rendido&"&matriculado="&matriculado&"&periodo="&periodo&"&tipo_postulante="&tipo_postulante
					      botonera.dibujaboton "excel"%>
				  </div></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
