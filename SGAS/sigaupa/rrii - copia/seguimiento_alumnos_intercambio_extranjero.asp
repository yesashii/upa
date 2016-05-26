<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
espi_ccod =Request.QueryString("b[0][espi_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
peri_ccod =Request.QueryString("b[0][peri_ccod]")
pers_nrut =Request.QueryString("b[0][pers_nrut]")
pers_xdv =Request.QueryString("b[0][pers_xdv]")
pasaporte =Request.QueryString("b[0][pers_tpasaporte]")
tici_ccod =Request.QueryString("b[0][tici_ccod]")
buscar	=Request.QueryString("buscar")
con_doie_fenvio_memo_esc=Request.QueryString("_b[0][con_doie_fenvio_memo_esc]")
sin_doie_fenvio_memo_esc=Request.QueryString("_b[0][sin_doie_fenvio_memo_esc]")
con_doie_frespuesta_escuela=Request.QueryString("_b[0][con_doie_frespuesta_escuela]")
sin_doie_frespuesta_escuela=Request.QueryString("_b[0][sin_doie_frespuesta_escuela]")
con_doie_respuesta_escuela=Request.QueryString("_b[0][con_doie_respuesta_escuela]")
sin_doie_respuesta_escuela=Request.QueryString("_b[0][sin_doie_respuesta_escuela]")
con_doie_fenvio_ramos=Request.QueryString("_b[0][con_doie_fenvio_ramos]")
sin_doie_fenvio_ramos=Request.QueryString("_b[0][sin_doie_fenvio_ramos]")
con_doie_fenvio_carta_acep=Request.QueryString("_b[0][con_doie_fenvio_carta_acep]")
sin_doie_fenvio_carta_acep=Request.QueryString("_b[0][sin_doie_fenvio_carta_acep]")
con_doie_frecepcion_carga_acad=Request.QueryString("_b[0][con_doie_frecepcion_carga_acad]")
sin_doie_frecepcion_carga_acad=Request.QueryString("_b[0][sin_doie_frecepcion_carga_acad]")
con_doie_fbienvenida=Request.QueryString("_b[0][con_doie_fbienvenida]")
sin_doie_fbienvenida=Request.QueryString("_b[0][sin_doie_fbienvenida]")
tici_ccod1 =Request.QueryString("tici_ccod")
carrera = Request.QueryString("carrera")
con_doie_fdocument=Request.QueryString("_b[0][con_doie_fdocument]")
sin_doie_fdocument=Request.QueryString("_b[0][sin_doie_fdocument]")
con_doie_med_compania=Request.QueryString("_b[0][con_doie_med_compania]")
sin_doie_med_compania=Request.QueryString("_b[0][sin_doie_med_compania]")


if tici_ccod1 <>  "" then
	tici_ccod = tici_ccod1
end if 
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_intercambio_extranjero.xml", "botonera"



'------------------------------------PAISES---------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_intercambio_extranjero.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pais_ccod", pais_ccod
f_busqueda.AgregaCampoCons "espi_ccod", espi_ccod
f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod
f_busqueda.AgregaCampoCons "peri_ccod", peri_ccod
f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
f_busqueda.AgregaCampoCons "pers_tpasaporte", pasaporte
f_busqueda.AgregaCampoCons "tici_ccod", tici_ccod
f_busqueda.AgregaCampoCons "con_doie_fenvio_memo_esc", con_doie_fenvio_memo_esc
f_busqueda.AgregaCampoCons "sin_doie_fenvio_memo_esc", sin_doie_fenvio_memo_esc
f_busqueda.AgregaCampoCons "con_doie_frespuesta_escuela", con_doie_frespuesta_escuela
f_busqueda.AgregaCampoCons "sin_doie_frespuesta_escuela", sin_doie_frespuesta_escuela
f_busqueda.AgregaCampoCons "con_doie_respuesta_escuela", con_doie_respuesta_escuela
f_busqueda.AgregaCampoCons "sin_doie_respuesta_escuela", sin_doie_respuesta_escuela
f_busqueda.AgregaCampoCons "con_doie_fenvio_ramos", con_doie_fenvio_ramos
f_busqueda.AgregaCampoCons "sin_doie_fenvio_ramos", sin_doie_fenvio_ramos
f_busqueda.AgregaCampoCons "con_doie_fenvio_carta_acep", con_doie_fenvio_carta_acep
f_busqueda.AgregaCampoCons "sin_doie_fenvio_carta_acep", sin_doie_fenvio_carta_acep
f_busqueda.AgregaCampoCons "con_doie_frecepcion_carga_acad", con_doie_frecepcion_carga_acad
f_busqueda.AgregaCampoCons "sin_doie_frecepcion_carga_acad", sin_doie_frecepcion_carga_acad
f_busqueda.AgregaCampoCons "con_doie_fbienvenida", con_doie_fbienvenida
f_busqueda.AgregaCampoCons "sin_doie_fbienvenida", sin_doie_fbienvenida
f_busqueda.AgregaCampoCons "sin_doie_fdocument", sin_doie_fdocument
f_busqueda.AgregaCampoCons "con_doie_fdocument", con_doie_fdocument
f_busqueda.AgregaCampoCons "con_doie_med_compania", con_doie_med_compania
f_busqueda.AgregaCampoCons "sin_doie_med_compania", sin_doie_med_compania


'------------------------------------CIUDADES EXTRANJERAS---------------------------------------------------------------
set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "alumnos_intercambio_extranjero.xml", "ciudad_extranjera"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
 consulta_ciu="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where pais_ccod="&pais_ccod&""
else
 consulta_ciu="select ''"
end if
f_ciudades_extranjeras.Consultar consulta_ciu

if peri_ccod<>"" then
anos_ccod=conexion.consultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")
end if
'------------------------------------UNIVERSIDADES EXTRANJERAS---------------------------------------------------------------
set f_universidades_extranjeras = new CFormulario
f_universidades_extranjeras.Carga_Parametros "alumnos_intercambio_extranjero.xml", "universidades_extranjeras"
f_universidades_extranjeras.Inicializar conexion

if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b, datos_convenio c  where a.univ_ccod=b.univ_ccod and a.unci_ncorr=c.unci_ncorr and ciex_ccod="&ciex_ccod&" and c.anos_ccod="&anos_ccod&" group by b.univ_ccod,univ_tdesc"
else
 consulta_uni="select ''"
end if
f_universidades_extranjeras.Consultar consulta_uni

if  espi_ccod <>""  then
filtro0=filtro0&"and c.espi_ccod = '"&espi_ccod&"'"
end if

if  pais_ccod <>""  then
filtro2=filtro2&"and f.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and d.ciex_ccod="&ciex_ccod&""
end if

if univ_ccod<>"" then
filtro3=filtro3&"and d.univ_ccod="&univ_ccod&""
end if
  
if pers_nrut<>"" then
filtro4=filtro4&"and pers_nrut="&pers_nrut&""
end if

if pasaporte<>"" then
filtro5=filtro5&"and PERS_TPASAPORTE='"&pasaporte&"'"
end if

filtro_doc=""

if con_doie_fenvio_memo_esc<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_memo_esc) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_memo_esc<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_memo_esc) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_frespuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_frespuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_respuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)<>''"
end if
if sin_doie_respuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select doie_frespuesta_escuela from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=''"
end if
if con_doie_fenvio_ramos<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_ramos) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_ramos<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_ramos) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_fenvio_carta_acep<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_carta_acep) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_carta_acep<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_carta_acep) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_frecepcion_carga_acad<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frecepcion_carga_acad) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_frecepcion_carga_acad<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frecepcion_carga_acad) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_fbienvenida<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fbienvenida) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fbienvenida<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fbienvenida) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if

if con_doie_fdocument<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fdocument) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr and len(doie_fdocument)>0 )>0"
end if
if sin_doie_fdocument<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fdocument) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_med_compania<>"" then
filtro_doc=filtro_doc&" and (select count(doie_med_compania) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr and len(doie_med_compania)>0 )>0"
end if
if sin_doie_med_compania<>"" then
filtro_doc=filtro_doc&" and (select count(doie_med_compania) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if


if request.QueryString.count > 0 and buscar<>"N" then

set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "alumnos_intercambio_extranjero.xml", "alumnos"
f_resumen_convenio.Inicializar conexion

if tici_ccod="" then
sql_descuentos="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tpasaporte,c.paie_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,a.pers_ncorr,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "univ_tdesc,"& vbCrLf &_
   "espi_tdesc,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod ,'"&univ_ccod&"' as univ_ccod,'"&peri_ccod&"' as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv,'"&pasaporte&"' as pasaporte,protic.imagenes_estado_documen(c.paie_ncorr) as estados_doc,"& vbCrLf &_
   "(select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email,"& vbCrLf &_
   "(select CARR_TDESC from carreras ca where c.carr_ccod = ca.CARR_CCOD)as carrera"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro0&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
""&filtro_doc&""& vbCrLf &_
"and espi_tdesc <> 'ELIMINADO'"& vbCrLf &_
"order by  pais_tdesc,ciex_tdesc"

'response.Write("<pre>"&sql_descuentos&"</pre>")

sql_contar="select count(*) as contar"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro0&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
""&filtro_doc&""& vbCrLf &_
"and espi_tdesc <> 'ELIMINADO'"
	contar =  conexion.ConsultaUno(sql_contar)

else

sql_descuentos="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tpasaporte,c.paie_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,a.pers_ncorr,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "sa.univ_ccod as univ_tdesc,"& vbCrLf &_
   "espi_tdesc,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod,'"&peri_ccod&"' as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv,'"&pasaporte&"' as pasaporte,'"&tici_ccod&"' as tici_ccod ,protic.imagenes_estado_documen(c.paie_ncorr) as estados_doc,"& vbCrLf &_
   "(select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email,"& vbCrLf &_
   "(select CARR_TDESC from carreras ca where c.carr_ccod = ca.CARR_CCOD)as carrera"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h,rrii_documentacion_intercambio_extranjero i,rrii_datos_study_abroad sa"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and sa.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and c.paie_ncorr=i.paie_ncorr"& vbCrLf &_
"and i.paie_ncorr = sa.paie_ncorr"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro0&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
""&filtro_doc&""& vbCrLf &_
"and espi_tdesc <> 'ELIMINADO'"& vbCrLf &_
"order by  pais_tdesc,ciex_tdesc"

sql_contar="select count(*) as contar"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h,rrii_documentacion_intercambio_extranjero i,rrii_datos_study_abroad sa"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and sa.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and c.paie_ncorr=i.paie_ncorr"& vbCrLf &_
"and i.paie_ncorr = sa.paie_ncorr"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro0&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
""&filtro_doc&""& vbCrLf &_
"and espi_tdesc <> 'ELIMINADO'"
	contar =  conexion.ConsultaUno(sql_contar)

end if


'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
f_resumen_convenio.Consultar sql_descuentos

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
<script language="JavaScript">


function activa_pais(valor)
{
		document.buscador.elements["b[0][univ_ccod]"].value=''
		document.buscador.elements["b[0][pais_ccod]"].value=''
		document.buscador.elements["b[0][ciex_ccod]"].value=''
		document.buscador.elements["b[0][pais_ccod]"].disabled=false
		document.buscador.elements["buscar"].value='N'
		document.buscador.action ='seguimiento_alumnos_intercambio_extranjero.asp';
		document.buscador.method = "get";
		document.buscador.submit();
			

	
	

	
}
function cambiar_pais()
{
		document.buscador.elements["b[0][ciex_ccod]"].value=''
		document.buscador.elements["b[0][univ_ccod]"].value=''
		
		
		document.buscador.elements["buscar"].value='N'
		document.buscador.action ='seguimiento_alumnos_intercambio_extranjero.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}
function cambiar_ciud()
{
		document.buscador.elements["buscar"].value='N'
		
		document.buscador.action ='seguimiento_alumnos_intercambio_extranjero.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}

function alcargar()
{
ciex_ccod='<%=ciex_ccod%>'
univ_ccod='<%=univ_ccod%>'
pais_ccod='<%=pais_ccod%>'


	if (pais_ccod!="")
	{
		document.buscador.elements["b[0][pais_ccod]"].disabled=false
		document.buscador.elements["b[0][ciex_ccod]"].disabled=false
	}

	if (ciex_ccod!="")
	{
		
		document.buscador.elements["b[0][ciex_ccod]"].value=ciex_ccod
		document.buscador.elements["b[0][univ_ccod]"].disabled=false
	}
		
	if (univ_ccod!="")
	{
		document.buscador.elements["b[0][univ_ccod]"].value=univ_ccod
		
	}	

}

function deshabilitaCon(nombre){

//alert(nombre)
nomarray=nombre.split("sin_")
nomcon='_b[0][con_'+nomarray[1]
//alert(nomcon)

	if(document.buscador.elements[nombre].checked)
	{
		document.buscador.elements[nomcon].disabled=true
	}
	else
	{
		document.buscador.elements[nomcon].disabled=false
	}

}

function deshabilitaSin(nombre)
{
//alert(nombre)
nomarray=nombre.split("con_")
nomsin='_b[0][sin_'+nomarray[1]
//alert(nomsin)

	if(document.buscador.elements[nombre].checked)
	{
		document.buscador.elements[nomsin].disabled=true
	}
	else
	{
		document.buscador.elements[nomsin].disabled=false
	}


}


function deshabilitador()
{

con_doie_fenvio_memo_esc='<%=con_doie_fenvio_memo_esc%>'
sin_doie_fenvio_memo_esc='<%=sin_doie_fenvio_memo_esc%>'
con_doie_frespuesta_escuela='<%=con_doie_frespuesta_escuela%>'
sin_doie_frespuesta_escuela='<%=sin_doie_frespuesta_escuela%>'
con_doie_respuesta_escuela='<%=con_doie_respuesta_escuela%>'
sin_doie_respuesta_escuela='<%=sin_doie_respuesta_escuela%>'
con_doie_fenvio_ramos='<%=con_doie_fenvio_ramos%>'
sin_doie_fenvio_ramos='<%=sin_doie_fenvio_ramos%>'
con_doie_fenvio_carta_acep='<%=con_doie_fenvio_carta_acep%>'
sin_doie_fenvio_carta_acep='<%=sin_doie_fenvio_carta_acep%>'
con_doie_frecepcion_carga_acad='<%=con_doie_frecepcion_carga_acad%>'
sin_doie_frecepcion_carga_acad='<%=sin_doie_frecepcion_carga_acad%>'
con_doie_fbienvenida='<%=con_doie_fbienvenida%>'
sin_doie_fbienvenida='<%=sin_doie_fbienvenida%>'
con_doie_fdocument='<%=con_doie_fdocument%>'
sin_doie_fdocument='<%=sin_doie_fdocument%>'
con_doie_med_compania='<%=con_doie_med_compania%>'
sin_doie_med_compania='<%=sin_doie_med_compania%>'


if (con_doie_fenvio_memo_esc!=''){
document.buscador.elements['_b[0][sin_doie_fenvio_memo_esc]'].disabled=true
}
if (sin_doie_fenvio_memo_esc!=''){
document.buscador.elements['_b[0][con_doie_fenvio_memo_esc]'].disabled=true
}
if (con_doie_frespuesta_escuela!=''){
document.buscador.elements['_b[0][sin_doie_frespuesta_escuela]'].disabled=true
}
if (sin_doie_frespuesta_escuela!=''){
document.buscador.elements['_b[0][con_doie_frespuesta_escuela]'].disabled=true
}
if (con_doie_respuesta_escuela!=''){
document.buscador.elements['_b[0][sin_doie_respuesta_escuela]'].disabled=true
}
if (sin_doie_respuesta_escuela!=''){
document.buscador.elements['_b[0][con_doie_respuesta_escuela]'].disabled=true
}
if (con_doie_fenvio_ramos!=''){
document.buscador.elements['_b[0][sin_doie_fenvio_ramos]'].disabled=true
}
if (sin_doie_fenvio_ramos!=''){
document.buscador.elements['_b[0][con_doie_fenvio_ramos]'].disabled=true
}
if (con_doie_fenvio_carta_acep!=''){
document.buscador.elements['_b[0][sin_doie_fenvio_carta_acep]'].disabled=true
}
if (sin_doie_fenvio_carta_acep!=''){
document.buscador.elements['_b[0][con_doie_fenvio_carta_acep]'].disabled=true
}
if (con_doie_frecepcion_carga_acad!=''){
document.buscador.elements['_b[0][sin_doie_frecepcion_carga_acad]'].disabled=true
}
if (sin_doie_frecepcion_carga_acad!=''){
document.buscador.elements['_b[0][con_doie_frecepcion_carga_acad]'].disabled=true
}
if (con_doie_fbienvenida!=''){
document.buscador.elements['_b[0][sin_doie_fbienvenida]'].disabled=true
}
if (sin_doie_fbienvenida!=''){
document.buscador.elements['_b[0][con_doie_fbienvenida]'].disabled=true
}
if (con_doie_fdocument!=''){
document.buscador.elements['_b[0][sin_doie_fdocument]'].disabled=true
}
if (sin_doie_fdocument!=''){
document.buscador.elements['_b[0][con_doie_fdocument]'].disabled=true
}
if (con_doie_med_compania!=''){
document.buscador.elements['_b[0][sin_doie_med_compania]'].disabled=true
}
if (sin_doie_med_compania!=''){
document.buscador.elements['_b[0][con_doie_med_compania]'].disabled=true
}


}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); alcargar();deshabilitador();" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
		  <%pagina.DibujarTitulo("ALUMNOS INTERCAMBIO EXTRANJERO")%>
            <td>
				 <form name="buscador">
				 <input type="hidden" name="buscar">
				 	<table align="center" width="100%">
						<tr>
							<td width="6%">Rut</td>
						    <td width="94%"><%f_busqueda.DibujaCampo("pers_nrut")%>- <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
					  </tr>
				    </table>
					  <table align="center" width="100%">
					  <tr>
							<td width="12%">N° Pasaporte</td>
					    <td width="88%"><%f_busqueda.DibujaCampo("pers_tpasaporte")%></td>
					  </tr>
					</table>
						<table align="center" width="100%">
							<tr>
							  <td>Periodo Acad&eacute;mico</td>
							  <td><%f_busqueda.DibujaCampo("peri_ccod")%>
*</td>
						  </tr>
							<tr>
							<td width="17%">Study Abroad</td>
							<td width="83%"><input type="checkbox" name="b[0][tici_ccod]" value="1" /></td>
							</tr>
					</table>
					<table align="center" width="100%">
							<tr>
							<td width="17%">Estado Postulaci&oacute;n</td>
							<td width="83%"><%f_busqueda.DibujaCampo("espi_ccod")%></td>
							</tr>
					</table>
					<table>
						<tr>
							<td width="5%">Pais</td>
						  	<td width="17%"><%f_busqueda.DibujaCampo("pais_ccod")%> </td>
							<td width="11%" align="right">Ciudad</td>
							<td width="17%">
								<select name="b[0][ciex_ccod]" OnChange="cambiar_ciud();" disabled="disabled">
								<option value="">Todas</option>
						   <% if pais_ccod<>"" then
						  	while f_ciudades_extranjeras.siguiente%>
						  	<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						   </td>
							<td width="11%">Universidad</td>
							<td width="39%">
								<select name="b[0][univ_ccod]" disabled="disabled">
							<option value="">Todas</option>
							<% if pais_ccod<>"" and ciex_ccod<>"" then
						  	while f_universidades_extranjeras.siguiente%>
						  	<option value="<%=f_universidades_extranjeras.ObtenerValor("univ_ccod")%>"><%=f_universidades_extranjeras.ObtenerValor("univ_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						  </td>
						</tr>
					</table>
				
					
					<table align="left" width="100%">
						<tr>
							<td colspan="2">
								<font size="-2">* Periodo Acádemico en el cual estará en intercambio</font>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								
								<table width="100%">
								  <tr>
										<td colspan="3">
											<font size="2"><strong>Filtros por Documentacion</strong></font></td>
									</tr>
									<tr>
									  <td><strong>Recepci&oacute;n de Documentos:</strong></td>
									  <td><font size="1"><strong>Ingresada</strong></font>
                                      <%f_busqueda.DibujaCampo("con_doie_fdocument")%></td>
									  <td><font size="1"><strong>No Ingresada</strong></font>
                                      <%f_busqueda.DibujaCampo("sin_doie_fdocument")%></td>
								  </tr>
									<tr>
									  <td><strong>Recepci&oacute;n Info del Seguro:</strong></td>
									  <td><font size="1"><strong>Ingresada</strong></font>
                                      <%f_busqueda.DibujaCampo("con_doie_med_compania")%></td>
									  <td><font size="1"><strong>No Ingresada</strong></font>
                                      <%f_busqueda.DibujaCampo("sin_doie_med_compania")%></td>
								  </tr>
									<tr>
										<td width="25%">
											<strong>Fecha envio Memo Escuela:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_fenvio_memo_esc")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_fenvio_memo_esc")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Fecha Respuesta Escuela:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_frespuesta_escuela")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_frespuesta_escuela")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Respuesta Escuela:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_respuesta_escuela")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_respuesta_escuela")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Fecha Envio Ramos:</strong>										</td>
										<td width="14%">
								   <font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_fenvio_ramos")%>
								   </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_fenvio_ramos")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Fecha Env&iacute;o de Carta Aceptaci&oacute;n Extranjero:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_fenvio_carta_acep")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_fenvio_carta_acep")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Fecha Recepci&oacute;n Carga Acad&eacute;mica</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_frecepcion_carga_acad")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_frecepcion_carga_acad")%>
								      </td>
									</tr>
									<tr>
										<td width="25%">
										<strong>Fecha Bienvenida</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_doie_fbienvenida")%>
								      </td>
										 <td width="61%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_doie_fbienvenida")%>
								      </td>
									</tr>
								</table>
							</td>
						</tr>
						<tr valign="bottom">
							<td width="12%"><%f_botonera.AgregaBotonParam "buscar", "url", "seguimiento_alumnos_intercambio_extranjero.asp"
								  f_botonera.DibujaBoton("salir")%></td>
							<td width="88%"><% f_botonera.DibujaBoton("buscar")%></td>
						</tr>
					</table>
                 </form>
			</td>
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
	<%if request.QueryString.count > 0 and buscar<>"N" then%> 
	<br>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td>
                    <br>
                    <table width="100%" border="0">                     
                    </table>
			  </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
             <form name="edicion">
				 <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
						  <input type="hidden" name="pais_ccod" value="<%=pais_ccod%>">
						 <input type="hidden" name="ciex_ccod" value="<%=ciex_ccod%>">
						 <input type="hidden" name="univ_ccod" value="<%=univ_ccod%>">
						 <input type="hidden" name="pers_nrut" value="<%=pers_nrut%>">
						 <input type="hidden" name="pers_xdv" value="<%=pers_xdv%>">
						 <input type="hidden" name="pers_tpasaporte" value="<%=pers_tpasaporte%>">
			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulaciones Intercambio Extranjero"%>
				
                      <table width="98%"  border="0" align="center">
					   <tr>
					     <td align="right">	<strong>Alumnos:</strong> <%=contar%>
                             </td>
					     </tr>
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_resumen_convenio.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%f_resumen_convenio.Dibujatabla()%>
							   </td>
						  
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td><div align="center"><%f_botonera.AgregaBotonParam "excel", "url", "seguimiento_alumnos_intercambio_extranjero_excel.asp"
				  							f_botonera.AgregaBotonParam "excel", "accion","GUARDAR"
											f_botonera.AgregaBotonParam "excel", "formulario","buscador"
											f_botonera.DibujaBoton("excel")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%end if%><br>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>