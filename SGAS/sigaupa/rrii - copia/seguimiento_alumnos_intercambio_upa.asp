<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
peri_ccod =Request.QueryString("b[0][peri_ccod]")
pers_nrut =Request.QueryString("b[0][pers_nrut]")
pers_xdv =Request.QueryString("b[0][pers_xdv]")
buscar	=Request.QueryString("buscar")
contar = Request.QueryString("z[0][contar]")

con_diau_fconsulta_esc=Request.QueryString("_b[0][con_diau_fconsulta_esc]")
sin_diau_fconsulta_esc=Request.QueryString("_b[0][sin_diau_fconsulta_esc]")
con_diau_respuesta_esc=Request.QueryString("_b[0][con_diau_respuesta_esc]")
sin_diau_respuesta_esc=Request.QueryString("_b[0][sin_diau_respuesta_esc]")
con_diau_fenvio_carta_apoderado=Request.QueryString("_b[0][con_diau_fenvio_carta_apoderado]")
sin_diau_fenvio_carta_apoderado=Request.QueryString("_b[0][sin_diau_fenvio_carta_apoderado]")
con_diau_fpeticion_certi_alum_reg=Request.QueryString("_b[0][con_diau_fpeticion_certi_alum_reg]")
sin_diau_fpeticion_certi_alum_reg=Request.QueryString("_b[0][sin_diau_fpeticion_certi_alum_reg]")
con_diau_frecepcion_certi_alum_reg=Request.QueryString("_b[0][con_diau_frecepcion_certi_alum_reg]")
sin_diau_frecepcion_certi_alum_reg=Request.QueryString("_b[0][sin_diau_frecepcion_certi_alum_reg]")
con_diau_fpeticion_certi_notas =Request.QueryString("_b[0][con_diau_fpeticion_certi_notas]")
sin_diau_fpeticion_certi_notas=Request.QueryString("_b[0][sin_diau_fpeticion_certi_notas]")
con_diau_frecepcion_certi_notas=Request.QueryString("_b[0][con_diau_frecepcion_certi_notas]")
sin_diau_frecepcion_certi_notas=Request.QueryString("_b[0][sin_diau_frecepcion_certi_notas]")
con_diau_estado_ramos=Request.QueryString("_b[0][con_diau_estado_ramos]")
sin_diau_estado_ramos=Request.QueryString("_b[0][sin_diau_estado_ramos]")
con_diau_fenvio_memo_es=Request.QueryString("_b[0][con_diau_fenvio_memo_es]")
sin_diau_fenvio_memo_es=Request.QueryString("_b[0][sin_diau_fenvio_memo_es]")
con_diau_fenvio_ramos_esc=Request.QueryString("_b[0][con_diau_fenvio_ramos_esc]")
sin_diau_fenvio_ramos_esc=Request.QueryString("_b[0][sin_diau_fenvio_ramos_esc]")
con_diau_frecepcion_acuerdo_preconva=Request.QueryString("_b[0][con_diau_frecepcion_acuerdo_preconva]")
sin_diau_frecepcion_acuerdo_preconva=Request.QueryString("_b[0][sin_diau_frecepcion_acuerdo_preconva]")
con_diau_fenvio_doctos_extranjero=Request.QueryString("_b[0][con_diau_fenvio_doctos_extranjero]")
sin_diau_fenvio_doctos_extranjero=Request.QueryString("_b[0][sin_diau_fenvio_doctos_extranjero]")
con_diau_frecepcion_carta_acepta=Request.QueryString("_b[0][con_diau_frecepcion_carta_acepta]")
sin_diau_frecepcion_carta_acepta=Request.QueryString("_b[0][sin_diau_frecepcion_carta_acepta]")
con_diau_ffirma=Request.QueryString("_b[0][con_diau_ffirma]")
sin_diau_ffirma=Request.QueryString("_b[0][sin_diau_ffirma]")

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
f_botonera.Carga_Parametros "alumnos_intercambio_upa.xml", "botonera"



'------------------------------------PAISES---------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_intercambio_upa.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pais_ccod", pais_ccod
f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod
f_busqueda.AgregaCampoCons "peri_ccod", peri_ccod
f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv

f_busqueda.AgregaCampoCons "con_diau_fconsulta_esc",con_diau_fconsulta_esc
f_busqueda.AgregaCampoCons "sin_diau_fconsulta_esc",sin_diau_fconsulta_esc
f_busqueda.AgregaCampoCons "con_diau_respuesta_esc",con_diau_respuesta_esc
f_busqueda.AgregaCampoCons "sin_diau_respuesta_esc",sin_diau_respuesta_esc
f_busqueda.AgregaCampoCons "con_diau_fenvio_carta_apoderado",con_diau_fenvio_carta_apoderado
f_busqueda.AgregaCampoCons "sin_diau_fenvio_carta_apoderado",sin_diau_fenvio_carta_apoderado
f_busqueda.AgregaCampoCons "con_diau_fpeticion_certi_alum_reg",con_diau_fpeticion_certi_alum_reg
f_busqueda.AgregaCampoCons "sin_diau_fpeticion_certi_alum_reg",sin_diau_fpeticion_certi_alum_reg
f_busqueda.AgregaCampoCons "con_diau_frecepcion_certi_alum_reg",con_diau_frecepcion_certi_alum_reg
f_busqueda.AgregaCampoCons "sin_diau_frecepcion_certi_alum_reg",sin_diau_frecepcion_certi_alum_reg
f_busqueda.AgregaCampoCons "con_diau_fpeticion_certi_notas",con_diau_fpeticion_certi_notas
f_busqueda.AgregaCampoCons "sin_diau_fpeticion_certi_notas",sin_diau_fpeticion_certi_notas
f_busqueda.AgregaCampoCons "con_diau_frecepcion_certi_notas",con_diau_frecepcion_certi_notas
f_busqueda.AgregaCampoCons "sin_diau_frecepcion_certi_notas",sin_diau_frecepcion_certi_notas
f_busqueda.AgregaCampoCons "con_diau_estado_ramos",con_diau_estado_ramos
f_busqueda.AgregaCampoCons "sin_diau_estado_ramos",sin_diau_estado_ramos
f_busqueda.AgregaCampoCons "con_diau_fenvio_memo_es",con_diau_fenvio_memo_es
f_busqueda.AgregaCampoCons "sin_diau_fenvio_memo_es",sin_diau_fenvio_memo_es
f_busqueda.AgregaCampoCons "con_diau_fenvio_ramos_esc",con_diau_fenvio_ramos_esc
f_busqueda.AgregaCampoCons "sin_diau_fenvio_ramos_esc",sin_diau_fenvio_ramos_esc
f_busqueda.AgregaCampoCons "con_diau_frecepcion_acuerdo_preconva",con_diau_frecepcion_acuerdo_preconva
f_busqueda.AgregaCampoCons "sin_diau_frecepcion_acuerdo_preconva",sin_diau_frecepcion_acuerdo_preconva
f_busqueda.AgregaCampoCons "con_diau_fenvio_doctos_extranjero",con_diau_fenvio_doctos_extranjero
f_busqueda.AgregaCampoCons "sin_diau_fenvio_doctos_extranjero",sin_diau_fenvio_doctos_extranjero
f_busqueda.AgregaCampoCons "con_diau_frecepcion_carta_acepta",con_diau_frecepcion_carta_acepta
f_busqueda.AgregaCampoCons "sin_diau_frecepcion_carta_acepta",sin_diau_frecepcion_carta_acepta
f_busqueda.AgregaCampoCons "con_diau_ffirma",con_diau_ffirma
f_busqueda.AgregaCampoCons "sin_diau_ffirma",sin_diau_ffirma

'------------------------------------CIUDADES EXTRANJERAS---------------------------------------------------------------
set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "alumnos_intercambio_upa.xml", "ciudad_extranjera"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
 consulta_ciu="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where pais_ccod="&pais_ccod&""
else
 consulta_ciu="select ''"
end if
f_ciudades_extranjeras.Consultar consulta_ciu

if peri_ccod <>"" then
anos_ccod=conexion.consultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")
end if
'------------------------------------UNIVERSIDADES EXTRANJERAS---------------------------------------------------------------
set f_universidades_extranjeras = new CFormulario
f_universidades_extranjeras.Carga_Parametros "alumnos_intercambio_upa.xml", "universidades_extranjeras"
f_universidades_extranjeras.Inicializar conexion

if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b, datos_convenio c  where a.univ_ccod=b.univ_ccod and a.unci_ncorr=c.unci_ncorr and ciex_ccod="&ciex_ccod&" and c.anos_ccod="&anos_ccod&" group by b.univ_ccod,univ_tdesc"
else
 consulta_uni="select ''"
end if
f_universidades_extranjeras.Consultar consulta_uni


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

filtro5=""
if con_diau_fconsulta_esc <>"" then
filtro5=filtro5&" and (select count(diau_fconsulta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fconsulta_esc <>"" then
filtro5=filtro5&" and (select count(diau_fconsulta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_respuesta_esc <>"" then
filtro5=filtro5&" and (select count(diau_respuesta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_respuesta_esc <>"" then
filtro5=filtro5&" and (select count(diau_respuesta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_carta_apoderado <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_carta_apoderado) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_carta_apoderado <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_carta_apoderado) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fpeticion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fpeticion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fpeticion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fpeticion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_estado_ramos <>"" then
filtro5=filtro5&" and (select count(diau_estado_ramos) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_estado_ramos <>"" then
filtro5=filtro5&" and (select count(diau_estado_ramos) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_memo_es <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_memo_es) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_memo_es <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_memo_es) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_ramos_esc <>"" then
filtro5=filtro5&"and (select count(diau_fenvio_ramos_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_ramos_esc <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_ramos_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_acuerdo_preconva <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_acuerdo_preconva) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_acuerdo_preconva <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_acuerdo_preconva) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_doctos_extranjero <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_doctos_extranjero) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_doctos_extranjero <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_doctos_extranjero) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_carta_acepta <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_carta_acepta) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_carta_acepta <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_carta_acepta) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_ffirma <>"" then
filtro5=filtro5&" and (select count(diau_ffirma) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_ffirma <>"" then
filtro5=filtro5&" and (select count(diau_ffirma) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if

if request.QueryString.count > 0 and buscar<>"N" then
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "alumnos_intercambio_upa.xml", "alumnos"
f_resumen_convenio.Inicializar conexion


sql_descuentos="select paiu_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "univ_tdesc,"& vbCrLf &_
  "espi_tdesc,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod ,'"&univ_ccod&"' as univ_ccod,'"&peri_ccod&"' as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv, protic.imagenes_estado_documen_alumno_upa(c.paiu_ncorr)as estados_docs"& vbCrLf &_
"from personas a,rrii_postulacion_alumnos_intercambio_upa c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
"order by  nombre"

'response.Write("<pre>"&sql_descuentos&"</pre>")
f_resumen_convenio.Consultar sql_descuentos

sql_contar="select count(*) as contar"& vbCrLf &_
"from personas a,rrii_postulacion_alumnos_intercambio_upa c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""
	contar =  conexion.ConsultaUno(sql_contar)

end if

'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

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
		document.buscador.action ='seguimiento_alumnos_intercambio_upa.asp';
		document.buscador.method = "get";
		document.buscador.submit();

	
}
function cambiar_pais()
{
		document.buscador.elements["b[0][ciex_ccod]"].value=''
		document.buscador.elements["b[0][univ_ccod]"].value=''
		
		
		document.buscador.elements["buscar"].value='N'
		document.buscador.action ='seguimiento_alumnos_intercambio_upa.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}
function cambiar_ciud()
{
		document.buscador.elements["buscar"].value='N'
		
		document.buscador.action ='seguimiento_alumnos_intercambio_upa.asp';
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
 con_diau_fconsulta_esc='<%=con_diau_fconsulta_esc%>'
 sin_diau_fconsulta_esc='<%=sin_diau_fconsulta_esc%>'
 con_diau_respuesta_esc='<%=con_diau_respuesta_esc%>'
 sin_diau_respuesta_esc='<%=sin_diau_respuesta_esc%>'
 con_diau_fenvio_carta_apoderado='<%=con_diau_fenvio_carta_apoderado%>'
 sin_diau_fenvio_carta_apoderado='<%=sin_diau_fenvio_carta_apoderado%>'
 con_diau_fpeticion_certi_alum_reg='<%=con_diau_fpeticion_certi_alum_reg%>'
 sin_diau_fpeticion_certi_alum_reg='<%=sin_diau_fpeticion_certi_alum_reg%>'
 con_diau_frecepcion_certi_alum_reg='<%=con_diau_frecepcion_certi_alum_reg%>'
 sin_diau_frecepcion_certi_alum_reg='<%=sin_diau_frecepcion_certi_alum_reg%>'
 con_diau_fpeticion_certi_notas='<%=con_diau_fpeticion_certi_notas%>'
 sin_diau_fpeticion_certi_notas='<%=sin_diau_fpeticion_certi_notas%>'
 con_diau_frecepcion_certi_notas='<%=con_diau_frecepcion_certi_notas%>'
 sin_diau_frecepcion_certi_notas='<%=sin_diau_frecepcion_certi_notas%>'
 con_diau_estado_ramos='<%=con_diau_estado_ramos%>'
 sin_diau_estado_ramos='<%=sin_diau_estado_ramos%>'
 con_diau_fenvio_memo_es='<%=con_diau_fenvio_memo_es%>'
 sin_diau_fenvio_memo_es='<%=sin_diau_fenvio_memo_es%>'
 con_diau_fenvio_ramos_esc='<%=con_diau_fenvio_ramos_esc%>'
 sin_diau_fenvio_ramos_esc='<%=sin_diau_fenvio_ramos_esc%>'
 con_diau_frecepcion_acuerdo_preconva='<%=con_diau_frecepcion_acuerdo_preconva%>'
 sin_diau_frecepcion_acuerdo_preconva='<%=sin_diau_frecepcion_acuerdo_preconva%>'
 con_diau_fenvio_doctos_extranjero='<%=con_diau_fenvio_doctos_extranjero%>'
 sin_diau_fenvio_doctos_extranjero='<%=sin_diau_fenvio_doctos_extranjero%>'
 con_diau_frecepcion_carta_acepta='<%=con_diau_frecepcion_carta_acepta%>'
 sin_diau_frecepcion_carta_acepta='<%=sin_diau_frecepcion_carta_acepta%>'
 con_diau_ffirma='<%=con_diau_ffirma%>'
 sin_diau_ffirma='<%=sin_diau_ffirma%>'
 
 
 if (con_diau_fconsulta_esc!=''){
document.buscador.elements['_b[0][sin_diau_fconsulta_esc]'].disabled=true
}
 if (sin_diau_fconsulta_esc!=''){
document.buscador.elements['_b[0][con_diau_fconsulta_esc]'].disabled=true
}
 if (con_diau_respuesta_esc!=''){
document.buscador.elements['_b[0][sin_diau_respuesta_esc]'].disabled=true
}
 if (sin_diau_respuesta_esc!=''){
document.buscador.elements['_b[0][con_diau_respuesta_esc]'].disabled=true
}
 if (con_diau_fenvio_carta_apoderado!=''){
document.buscador.elements['_b[0][sin_diau_fenvio_carta_apoderado]'].disabled=true
}
 if (sin_diau_fenvio_carta_apoderado!=''){
document.buscador.elements['_b[0][con_diau_fenvio_carta_apoderado]'].disabled=true
}
 if (con_diau_fpeticion_certi_alum_reg!=''){
document.buscador.elements['_b[0][sin_diau_fpeticion_certi_alum_reg]'].disabled=true
}
 if (sin_diau_fpeticion_certi_alum_reg!=''){
document.buscador.elements['_b[0][con_diau_fpeticion_certi_alum_reg]'].disabled=true
}
 if (con_diau_frecepcion_certi_alum_reg!=''){
document.buscador.elements['_b[0][sin_diau_frecepcion_certi_alum_reg]'].disabled=true
}
 if (sin_diau_frecepcion_certi_alum_reg!=''){
document.buscador.elements['_b[0][con_diau_frecepcion_certi_alum_reg]'].disabled=true
}
 if (con_diau_fpeticion_certi_notas!=''){
document.buscador.elements['_b[0][sin_diau_fpeticion_certi_notas]'].disabled=true
}
 if (sin_diau_fpeticion_certi_notas!=''){
document.buscador.elements['_b[0][con_diau_fpeticion_certi_notas]'].disabled=true
}
 if (con_diau_frecepcion_certi_notas!=''){
document.buscador.elements['_b[0][sin_diau_frecepcion_certi_notas]'].disabled=true
}
 if (sin_diau_frecepcion_certi_notas!=''){
document.buscador.elements['_b[0][con_diau_frecepcion_certi_notas]'].disabled=true
}
 if (sin_diau_estado_ramos!=''){
document.buscador.elements['_b[0][con_diau_estado_ramos]'].disabled=true
}
 if (con_diau_estado_ramos!=''){
document.buscador.elements['_b[0][sin_diau_estado_ramos]'].disabled=true
}

 if (con_diau_fenvio_memo_es!=''){
document.buscador.elements['_b[0][sin_diau_fenvio_memo_es]'].disabled=true
}
 if (sin_diau_fenvio_memo_es!=''){
document.buscador.elements['_b[0][con_diau_fenvio_memo_es]'].disabled=true
}
 if (con_diau_fenvio_ramos_esc!=''){
document.buscador.elements['_b[0][sin_diau_fenvio_ramos_esc]'].disabled=true
}
 if (sin_diau_fenvio_ramos_esc!=''){
document.buscador.elements['_b[0][con_diau_fenvio_ramos_esc]'].disabled=true
}
 if (con_diau_frecepcion_acuerdo_preconva!=''){
document.buscador.elements['_b[0][sin_diau_frecepcion_acuerdo_preconva]'].disabled=true
}
 if (sin_diau_frecepcion_acuerdo_preconva!=''){
document.buscador.elements['_b[0][con_diau_frecepcion_acuerdo_preconva]'].disabled=true
}
 if (con_diau_fenvio_doctos_extranjero!=''){
document.buscador.elements['_b[0][sin_diau_fenvio_doctos_extranjero]'].disabled=true
}
 if (sin_diau_fenvio_doctos_extranjero!=''){
document.buscador.elements['_b[0][con_diau_fenvio_doctos_extranjero]'].disabled=true
}
 if (con_diau_frecepcion_carta_acepta!=''){
document.buscador.elements['_b[0][sin_diau_frecepcion_carta_acepta]'].disabled=true
}
 if (sin_diau_frecepcion_carta_acepta!=''){
document.buscador.elements['_b[0][con_diau_frecepcion_carta_acepta]'].disabled=true
}
 if (con_diau_ffirma!=''){
document.buscador.elements['_b[0][sin_diau_ffirma]'].disabled=true
}
 if (sin_diau_ffirma!=''){
document.buscador.elements['_b[0][con_diau_ffirma]'].disabled=true
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
							<td width="17%">Periodo Acad&eacute;mico</td>
							<td width="83%"><%f_busqueda.DibujaCampo("peri_ccod")%> *</td>
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
							<td>
								<font size="-2">* Periodo Acádemico en el cual estará en intercambio</font>
							</td>
						</tr>
												<tr>
							<td>
								<table width="100%">
									<tr>
										<td colspan="3">
											<font size="2"><strong>Filtros por Documentacion</strong></font></td>
									</tr>
									<tr>
										<td width="47%">
											<strong>Fecha envio Consulta Escuela:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fconsulta_esc")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fconsulta_esc")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Respuesta Escuela:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_respuesta_esc")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_respuesta_esc")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Recepcion Carta Apoderado:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fenvio_carta_apoderado")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fenvio_carta_apoderado")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Peticion de Certificado de Alumno Regular:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fpeticion_certi_alum_reg")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fpeticion_certi_alum_reg")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Recepcion de Certificado de Alumno Regular:</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_frecepcion_certi_alum_reg")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_frecepcion_certi_alum_reg")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Peticion Certificado de Notas</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fpeticion_certi_notas")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fpeticion_certi_notas")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Recepcion Certificado de Notas</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_frecepcion_certi_notas")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_frecepcion_certi_notas")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Estado de Ramos</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_estado_ramos")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_estado_ramos")%>
								      </td>
									</tr>
									
									<tr>
										<td width="47%">
										<strong>Fecha Envio Ramo Escuela</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fenvio_ramos_esc")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fenvio_ramos_esc")%>
								      </td>
									</tr>
										<tr>
										<td width="47%">
										<strong>Fecha Recepcion Acuerdo de Preconvalidacion</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_frecepcion_acuerdo_preconva")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_frecepcion_acuerdo_preconva")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Envio Documentos al Extranjero</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_fenvio_doctos_extranjero")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_fenvio_doctos_extranjero")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Recepcion Carta Aceptacion</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_frecepcion_carta_acepta")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_frecepcion_carta_acepta")%>
								      </td>
									</tr>
									<tr>
										<td width="47%">
										<strong>Fecha Firma</strong>										</td>
										<td width="14%">
											<font size="1"><strong>Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("con_diau_ffirma")%>
								      </td>
										 <td width="39%">
											<font size="1"><strong>No Ingresada</strong></font>
											<%f_busqueda.DibujaCampo("sin_diau_ffirma")%>
								      </td>
									</tr>
								</table>
							</td>
						</tr>

						<tr valign="bottom">
							<td><%f_botonera.DibujaBoton("buscar")%></td>
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

			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulaciones Intercambio"%>
					
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
				  <td><div align="center"><%f_botonera.AgregaBotonParam "excel", "url", "proceso_alumnos_intercambio_upa_excel.asp"
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