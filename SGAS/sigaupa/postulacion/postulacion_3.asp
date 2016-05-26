<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:14/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:110,112 - 195 - 224
'********************************************************************
formatolocal=setlocale(1033)
q_regi_ccod_colegio = Request.QueryString("antecedentes[0][regi_ccod_colegio]")
q_ciud_ccod_colegio = Request.QueryString("antecedentes[0][ciud_ccod_colegio]")

v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Antecedentes Académicos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_3.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_antecedentes = new CFormulario
f_antecedentes.Carga_Parametros "postulacion_3.xml", "antecedentes"
f_antecedentes.Inicializar conexion

'consulta ="  select c.anos_ccod - 1 as ano_actividades,  " & vbCrLf &_
'"       a.post_ncorr, a.tpad_ccod, a.post_npaa_verbal, a.post_npaa_matematicas, post_nano_paa, a.post_breconocimiento_estudios,  " & vbCrLf &_
'"       a.post_totras_actividades, a.iesu_ccod, a.post_tinstitucion_anterior, a.ties_ccod, a.post_ttipo_institucion_ant, " & vbCrLf &_	
'"	   a.post_tcarrera_anterior, a.post_nano_inicio_est_ant, a.post_nano_termino_est_ant, a.post_btitulado,  " & vbCrLf &_
'"       a.post_ttitulo_obtenido, a.post_nsem_aprobados,  " & vbCrLf &_
'"       a.post_btrabaja, " & vbCrLf &_
'"       CASE " & vbCrLf &_
'"        WHEN  A.post_tinstitucion_anterior IS NULL THEN 'N' " & vbCrLf &_
'"        WHEN post_tinstitucion_anterior ='' THEN 'N' " & vbCrLf &_
'"        ELSE 'S' " & vbCrLf &_
'"        END AS otra_institucion, " & vbCrLf &_
'"       b.pers_ncorr, b.cole_ccod, b.tens_ccod, b.pers_nano_egr_media, b.pers_tcole_egreso, b.pers_ttipo_ensenanza, " & vbCrLf &_
'"       b.pers_nnota_ens_media, " & vbCrLf &_
'"       b.isap_ccod, b.pers_tenfermedades, b.pers_tmedicamentos_alergia, b.pers_tempresa, b.pers_tcargo, b.alab_ccod, b.ffaa_ccod,  " & vbCrLf &_
'"       CASE " & vbCrLf &_
'"        WHEN  B.pers_tcole_egreso IS NULL THEN 'N' " & vbCrLf &_
'"        WHEN  B.pers_tcole_egreso ='' THEN 'N' " & vbCrLf &_
'"        ELSE 'S' " & vbCrLf &_
'"        END AS otro_colegio, " & vbCrLf &_
'"	    isnull(b.ciud_ccod_cole,0) as ciud_ccod_colegio,   " & vbCrLf &_
'"       (select aa.regi_ccod " & vbCrLf &_
'"       from regiones aa, ciudades bb " & vbCrLf &_
'"       where aa.regi_ccod = bb.regi_ccod" & vbCrLf &_
'"       and bb.ciud_ccod = b.ciud_ccod_cole) as regi_ccod_colegio , " & vbCrLf &_
'"e.dire_tcalle, e.dire_tnro, e.dire_tfono, e.ciud_ccod as ciud_ccod_empresa , " & vbCrLf &_
'"       (SELECT BB.REGI_CCOD  " & vbCrLf &_
'"        FROM  direcciones_publica AA, CIUDADES BB " & vbCrLf &_
'"        WHERE AA.CIUD_CCOD = BB.CIUD_CCOD " & vbCrLf &_
'"        AND AA.CIUD_CCOD = e.ciud_ccod   " & vbCrLf &_
'"		 and aa.pers_ncorr =b.pers_ncorr and tdir_ccod =3	) as regi_ccod_empresa        " & vbCrLf &_
'"  from postulantes a, personas_postulante b, " & vbCrLf &_
'"  periodos_academicos  c, colegios d,direcciones_publica e " & vbCrLf &_
'"  where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'"  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
'"  and b.cole_ccod *= d.cole_ccod " & vbCrLf &_
'"  and b.pers_ncorr *= e.pers_ncorr " & vbCrLf &_
'"  and e.tdir_ccod = 3 " & vbCrLf &_
'"  and a.post_ncorr = '" & v_post_ncorr & "'"

consulta ="  select c.anos_ccod - 1 as ano_actividades,  " & vbCrLf &_
"       a.post_ncorr, a.tpad_ccod, a.post_npaa_verbal, a.post_npaa_matematicas, post_nano_paa, a.post_breconocimiento_estudios,  " & vbCrLf &_
"       a.post_totras_actividades, a.iesu_ccod, a.post_tinstitucion_anterior, a.ties_ccod, a.post_ttipo_institucion_ant, " & vbCrLf &_	
"	   a.post_tcarrera_anterior, a.post_nano_inicio_est_ant, a.post_nano_termino_est_ant, a.post_btitulado,  " & vbCrLf &_
"       a.post_ttitulo_obtenido, a.post_nsem_aprobados,  " & vbCrLf &_
"       a.post_btrabaja, " & vbCrLf &_
"       CASE " & vbCrLf &_
"        WHEN  A.post_tinstitucion_anterior IS NULL THEN 'N' " & vbCrLf &_
"        WHEN post_tinstitucion_anterior ='' THEN 'N' " & vbCrLf &_
"        ELSE 'S' " & vbCrLf &_
"        END AS otra_institucion, " & vbCrLf &_
"       b.pers_ncorr, b.cole_ccod, b.tens_ccod, b.pers_nano_egr_media, b.pers_tcole_egreso, b.pers_ttipo_ensenanza, " & vbCrLf &_
"       b.pers_nnota_ens_media, " & vbCrLf &_
"       b.isap_ccod, b.pers_tenfermedades, b.pers_tmedicamentos_alergia, b.pers_tempresa, b.pers_tcargo, b.alab_ccod, b.ffaa_ccod,  " & vbCrLf &_
"       CASE " & vbCrLf &_
"        WHEN  B.pers_tcole_egreso IS NULL THEN 'N' " & vbCrLf &_
"        WHEN  B.pers_tcole_egreso ='' THEN 'N' " & vbCrLf &_
"        ELSE 'S' " & vbCrLf &_
"        END AS otro_colegio, " & vbCrLf &_
"	    isnull(b.ciud_ccod_cole,0) as ciud_ccod_colegio,   " & vbCrLf &_
"       (select aa.regi_ccod " & vbCrLf &_
"       from regiones aa, ciudades bb " & vbCrLf &_
"       where aa.regi_ccod = bb.regi_ccod" & vbCrLf &_
"       and bb.ciud_ccod = b.ciud_ccod_cole) as regi_ccod_colegio , " & vbCrLf &_
"e.dire_tcalle, e.dire_tnro, e.dire_tfono, e.ciud_ccod as ciud_ccod_empresa , " & vbCrLf &_
"       (SELECT BB.REGI_CCOD  " & vbCrLf &_
"        FROM  direcciones_publica AA, CIUDADES BB " & vbCrLf &_
"        WHERE AA.CIUD_CCOD = BB.CIUD_CCOD " & vbCrLf &_
"        AND AA.CIUD_CCOD = e.ciud_ccod   " & vbCrLf &_
"		 and aa.pers_ncorr =b.pers_ncorr and tdir_ccod =3	) as regi_ccod_empresa        " & vbCrLf &_
"  from postulantes a INNER JOIN personas_postulante b " & vbCrLf &_
"  ON a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"  INNER JOIN periodos_academicos  c " & vbCrLf &_
"  ON a.peri_ccod = c.peri_ccod " & vbCrLf &_
"  LEFT OUTER JOIN colegios d " & vbCrLf &_
"  ON b.cole_ccod = d.cole_ccod " & vbCrLf &_
"  LEFT OUTER JOIN direcciones_publica e " & vbCrLf &_
"  ON b.pers_ncorr = e.pers_ncorr and e.tdir_ccod = 3" & vbCrLf &_
"  WHERE a.post_ncorr = '" & v_post_ncorr & "' " 

'response.Write("<pre>"&consulta&"</pre>")

'"select c.anos_ccod - 1 as ano_actividades, " & vbCrLf &_
           '"       a.post_ncorr, a.tpad_ccod, a.post_npaa_verbal, a.post_npaa_matematicas, post_nano_paa, a.post_breconocimiento_estudios, " & vbCrLf &_
		   '"       a.post_totras_actividades, a.iesu_ccod, a.post_tinstitucion_anterior, a.ties_ccod, a.post_ttipo_institucion_ant,	" & vbCrLf &_
		   '"	   a.post_tcarrera_anterior, a.post_nano_inicio_est_ant, a.post_nano_termino_est_ant, a.post_btitulado, a.post_ttitulo_obtenido, a.post_nsem_aprobados, " & vbCrLf &_
		   '"       a.post_btrabaja, " & vbCrLf &_
		   '"       decode(a.post_tinstitucion_anterior, null, 'N', 'S') as otra_institucion,  " & vbCrLf &_
		   '"       b.pers_ncorr, b.cole_ccod, b.tens_ccod, b.pers_nano_egr_media, b.pers_tcole_egreso, b.pers_ttipo_ensenanza, trim(to_char(b.pers_nnota_ens_media, '0.9')) as pers_nnota_ens_media, " & vbCrLf &_
		   '"	   b.isap_ccod, b.pers_tenfermedades, b.pers_tmedicamentos_alergia, b.pers_tempresa, b.pers_tcargo, b.alab_ccod, b.ffaa_ccod, " & vbCrLf &_
		   '"	   decode(b.pers_tcole_egreso, null, 'N', 'S') as otro_colegio,   " & vbCrLf &_
		   '"	   d.ciud_ccod as ciud_ccod_colegio,  " & vbCrLf &_
		   '"	   e.regi_ccod as regi_ccod_colegio, " & vbCrLf &_
		   '"	   f.dire_tcalle, f.dire_tnro, f.dire_tfono, f.ciud_ccod as ciud_ccod_empresa, " & vbCrLf &_
		   '"	   g.regi_ccod as regi_ccod_empresa " & vbCrLf &_
		   '"from postulantes a, personas_postulante b, periodos_academicos c, colegios d, ciudades e, " & vbCrLf &_
		   '"     direcciones_publica f, ciudades g  " & vbCrLf &_
		   '"where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
		   '"  and a.peri_ccod = c.peri_ccod  " & vbCrLf &_
		   '"  and b.cole_ccod = d.cole_ccod (+)  " & vbCrLf &_
		   '"  and d.ciud_ccod = e.ciud_ccod (+)  " & vbCrLf &_
		   '"  and b.pers_ncorr = f.pers_ncorr (+) " & vbCrLf &_
		   '"  and f.ciud_ccod = g.ciud_ccod (+) " & vbCrLf &_
		   '"  and f.tdir_ccod (+) = 3 " & vbCrLf &_
		   '"  and a.post_ncorr = '" & v_post_ncorr & "'"

	

f_antecedentes.Consultar consulta
f_antecedentes.Siguiente

if not EsVacio(q_regi_ccod_colegio) then
'RESPONSE.Write(q_regi_ccod_colegio)
'RESPONSE.End() 
	f_antecedentes.AgregaCampoCons "regi_ccod_colegio", q_regi_ccod_colegio
	f_antecedentes.AgregaCampoCons "ciud_ccod_colegio", q_ciud_ccod_colegio
	f_antecedentes.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '" & q_ciud_ccod_colegio & "'"
else
'response.Write(f_antecedentes.ObtenerValor("ciud_ccod_colegio"))
	f_antecedentes.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '" & f_antecedentes.ObtenerValor("ciud_ccod_colegio") & "'"
end if


'------------------------------------------------------------------------------------------
set f_actividades_realizadas = new CFormulario
f_actividades_realizadas.Carga_Parametros "postulacion_3.xml", "actividades_realizadas"
f_actividades_realizadas.Inicializar conexion

'consulta =" select a.acre_ccod, a.acre_tdesc,  " & vbCrLf &_
'" case " & vbCrLf &_
'"    when b.post_ncorr is null then 'N' " & vbCrLf &_
'"    else 'S' " & vbCrLf &_
'" end as     actividad_realizada " & vbCrLf &_
'" from actividades_realizadas a, actividades_postulantes b  " & vbCrLf &_
'" where a.acre_ccod *= b.acre_ccod   " & vbCrLf &_
'"  and b.post_ncorr = '" & v_post_ncorr & "'  " & vbCrLf &_
'" order by a.acre_ccod asc "

consulta =" select a.acre_ccod, a.acre_tdesc,  " & vbCrLf &_
" case " & vbCrLf &_
"    when b.post_ncorr is null then 'N' " & vbCrLf &_
"    else 'S' " & vbCrLf &_
" end as     actividad_realizada " & vbCrLf &_
" from actividades_realizadas a LEFT OUTER JOIN actividades_postulantes b  " & vbCrLf &_
"  ON a.acre_ccod = b.acre_ccod   " & vbCrLf &_
"  and b.post_ncorr = '" & v_post_ncorr & "'  " & vbCrLf &_
"  order by a.acre_ccod asc "

f_actividades_realizadas.Consultar consulta
f_actividades_realizadas.AgregaCampoCons "post_ncorr", v_post_ncorr


'---------------------------------------------------------------------------------------------------------------
set f_actividades_participar = new CFormulario
f_actividades_participar.Carga_Parametros "postulacion_3.xml", "actividades_participar"
f_actividades_participar.Inicializar conexion

'consulta =" select a.tacp_ccod, a.tacp_tdesc,   " & vbCrLf &_
'			" case  " & vbCrLf &_
'			"     when b.post_ncorr is null then 'N'  " & vbCrLf &_
'			"     else 'S'  " & vbCrLf &_
'			" end as    bparticipar   " & vbCrLf &_
'			" from tipos_actividades_participar a, actividades_participar_post b   " & vbCrLf &_
'			" where a.tacp_ccod *= b.tacp_ccod    " & vbCrLf &_
'			"   and b.post_ncorr  = '" & v_post_ncorr & "'   " & vbCrLf &_
'			" order by a.tacp_ccod " 

consulta =" select a.tacp_ccod, a.tacp_tdesc,   " & vbCrLf &_
			" case  " & vbCrLf &_
			"     when b.post_ncorr is null then 'N'  " & vbCrLf &_
			"     else 'S'  " & vbCrLf &_
			" end as    bparticipar   " & vbCrLf &_
			" from tipos_actividades_participar a LEFT OUTER JOIN actividades_participar_post b   " & vbCrLf &_
			"   ON a.tacp_ccod = b.tacp_ccod    " & vbCrLf &_
			"   and b.post_ncorr  = '" & v_post_ncorr & "'   " & vbCrLf &_
			"   order by a.tacp_ccod " 
'RESPONSE.Write("<PRE>"&CONSULTA&"</PRE>")
f_actividades_participar.Consultar consulta
f_actividades_participar.AgregaCampoCons "post_ncorr", v_post_ncorr


'-------------------------------------------------------------------------------------------------
consulta_instituciones = "select ties_ccod, iesu_ccod, iesu_tdesc from instituciones_educ_superior order by iesu_tdesc asc"

'-------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>


<%pagina.GeneraDiccionarioJS consulta_instituciones, conexion, "d_instituciones"%>

<script language="JavaScript">
function Validar()
{
	formulario = document.edicion;
	
	if ( (formulario.elements["antecedentes[0][cole_ccod]"].value == "") && (formulario.elements["antecedentes[0][otro_colegio]"].value == "N") ) {
		 	alert('Debe especificar colegio de egreso.');
			return false;
	}
	
	
	var nota_minima = parseInt('<%=negocio.ObtenerParametroSistema("NOTA_MINIMA")%>');
	var nota_maxima = parseInt('<%=negocio.ObtenerParametroSistema("NOTA_MAXIMA")%>');

	if (!isEmpty(formulario.elements["antecedentes[0][pers_nnota_ens_media]"].value)) {	
		/*if (isNota(formulario.elements["antecedentes[0][pers_nnota_ens_media]"].value)== false){
				alert('Nota de egreso de enseñanza media debe ser entre ' + nota_minima + ' y ' + nota_maxima + '.')
				formulario.elements["antecedentes[0][pers_nnota_ens_media]"].focus();
				formulario.elements["antecedentes[0][pers_nnota_ens_media]"].select();
				return false;		
		}*/		
		if ( (formulario.elements["antecedentes[0][pers_nnota_ens_media]"].value < nota_minima) || (formulario.elements["antecedentes[0][pers_nnota_ens_media]"].value > nota_maxima) ) {		
				alert('Nota de egreso de enseñanza media debe ser entre ' + nota_minima + ' y ' + nota_maxima + '.')
				formulario.elements["antecedentes[0][pers_nnota_ens_media]"].focus();
				formulario.elements["antecedentes[0][pers_nnota_ens_media]"].select();
				return false;
		}
	}
	
	var ano_inicio = parseInt(formulario.elements["antecedentes[0][post_nano_inicio_est_ant]"].value);
	var ano_termino = parseInt(formulario.elements["antecedentes[0][post_nano_termino_est_ant]"].value);
	
	if (ano_inicio > ano_termino) {
		alert('El año de inicio de los estudios anteriores no debe ser mayor que el año de término.');
		formulario.elements["antecedentes[0][post_nano_inicio_est_ant]"].select();
		return false;
	}
	
	return true;
}


function LimpiarComboColegios()
{
	o_cole_ccod = document.edicion.elements["antecedentes[0][cole_ccod]"];
	
	o_cole_ccod.length = 0;
	o_cole_ccod.add (new Option("Seleccionar colegio", ""));
}

function RecargarColegios()
{	
	/*formulario = document.edicion;	
	formulario.action = "";	
	formulario.method = "get";		
	formulario.submit();		*/
	
	navigate("postulacion_3.asp?antecedentes[0][regi_ccod_colegio]=" + formulario["antecedentes[0][regi_ccod_colegio]"].value + "&antecedentes[0][ciud_ccod_colegio]=" + formulario["antecedentes[0][ciud_ccod_colegio]"].value);
	
}


function HabilitarTextbox(p_textbox, p_habilitado)
{
	p_textbox.setAttribute("disabled", !p_habilitado);
}



function HabilitarTextboxTipoEnsenanza()
{
	formulario = document.edicion;	
	
	o_tens_ccod = formulario.elements["antecedentes[0][tens_ccod]"];
	
	
	HabilitarTextbox(formulario.elements["antecedentes[0][pers_ttipo_ensenanza]"], ValorRadioButton(o_tens_ccod) == "4");	
	
	if (ValorRadioButton(o_tens_ccod) == "4") {
		formulario.elements["antecedentes[0][pers_ttipo_ensenanza]"].focus();
	}
		
}


function ties_ccod_Click()
{
	formulario = document.edicion;
	o_ties_ccod = formulario.elements["antecedentes[0][ties_ccod]"];
	o_post_ttipo_institucion_ant = formulario.elements["antecedentes[0][post_ttipo_institucion_ant]"];
	
	v_ties_ccod = ValorRadioButton(o_ties_ccod);
	
	
	if (v_ties_ccod == "0") {
		HabilitarTextbox(o_post_ttipo_institucion_ant, true);
		o_post_ttipo_institucion_ant.focus();
	}
	else {
		HabilitarTextbox(o_post_ttipo_institucion_ant, false);
	}
	
	
	_FiltrarCombobox(formulario.elements['antecedentes[0][iesu_ccod]'],
	                 v_ties_ccod,
					 d_instituciones,
					 'ties_ccod',
					 'iesu_ccod',
					 'iesu_tdesc',
					 '',
					 'Seleccionar institución')
}

function otra_institucion_click()
{
	var formulario = document.edicion;
	var o_otra_institucion = formulario.elements["antecedentes[0][otra_institucion]"];
	
	HabilitarTextbox(formulario.elements["antecedentes[0][post_tinstitucion_anterior]"], o_otra_institucion.value == 'S');
	
	if (o_otra_institucion.value == 'S') {
		formulario.elements["antecedentes[0][post_tinstitucion_anterior]"].focus();
	}
}


function post_btitulado_click()
{
	var formulario = document.edicion;
	var o_post_btitulado = formulario.elements["antecedentes[0][post_btitulado]"];
	var o_post_ttitulo_obtenido = formulario.elements["antecedentes[0][post_ttitulo_obtenido]"];
	
	
	HabilitarTextbox(o_post_ttitulo_obtenido, getRadioValue(o_post_btitulado) == 'S');
	
	if (getRadioValue(o_post_btitulado) == 'S') {
		o_post_ttitulo_obtenido.focus();
	}
}


function post_btrabaja_click()
{
	var formulario = document.edicion;
	var o_post_btrabaja = formulario.elements["antecedentes[0][post_btrabaja]"];
	var arr_objetos = new Array("antecedentes[0][pers_tempresa]",
	                            "antecedentes[0][pers_tcargo]",
								"antecedentes[0][regi_ccod_empresa]",
								"antecedentes[0][ciud_ccod_empresa]",
								"antecedentes[0][dire_tcalle]",
								"antecedentes[0][dire_tnro]",
								"antecedentes[0][dire_tpoblacion]",
								"antecedentes[0][dire_tfono]",
								"antecedentes[0][alab_ccod]");
				
		
	var btrabaja = getRadioValue(o_post_btrabaja) == 'S';
	
	for (i in arr_objetos) {
		formulario.elements[arr_objetos[i]].setAttribute("disabled", !btrabaja);
	}
	
	
}


function Comprueba_ties_ccod()
{
	formulario = document.edicion;
	
	if ('<%=f_antecedentes.ObtenerValor("ties_ccod")%>' == "0")		
		setRadioValue(formulario.elements["antecedentes[0][ties_ccod]"], "0");
}

function InicioPagina()
{
	_FiltrarCombobox(document.edicion.elements["antecedentes[0][ciud_ccod_colegio]"], 
	                 document.edicion.elements["antecedentes[0][regi_ccod_colegio]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_antecedentes.ObtenerValor("ciud_ccod_colegio")%>',
					 'Seleccionar ciudad');					 
							 
	HabilitarTextbox(document.edicion.elements['antecedentes[0][pers_tcole_egreso]'], document.edicion.elements['_antecedentes[0][otro_colegio]'].checked);	
	HabilitarTextboxTipoEnsenanza();
	
	Comprueba_ties_ccod();	
	ties_ccod_Click();
	otra_institucion_click();
	
	_FiltrarCombobox(document.edicion.elements["antecedentes[0][ciud_ccod_empresa]"], 
	                 document.edicion.elements["antecedentes[0][regi_ccod_empresa]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_antecedentes.ObtenerValor("ciud_ccod_empresa")%>',
					 'Seleccionar ciudad'); 
					 
	_FiltrarCombobox(document.edicion.elements["antecedentes[0][iesu_ccod]"], 
	                 getRadioValue(document.edicion.elements["antecedentes[0][ties_ccod]"]),
					 d_instituciones,
					 'ties_ccod',
					 'iesu_ccod',
					 'iesu_tdesc',
					 '<%=f_antecedentes.ObtenerValor("iesu_ccod")%>',
					 'Seleccionar institución');
					 
					 
	post_btitulado_click();
	post_btrabaja_click();
}
</script>

<style type="text/css">
<!--
.style3 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3" valign="top" bgcolor="#FFFFFF" width="750" align="center">
    <img src="../imagenes/vineta2_r1_c1_2016.jpg" width="750" height="100"/>
    </td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 3
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "FICHA DE POSTULACION ANTECEDENTES ACADÉMICOS" %>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td colspan="3"><br>
                            <span class="style3">(*)</span><strong> ESTABLECIMIENTO DONDE EGRES&Oacute; DE ENSE&Ntilde;ANZA MEDIA </strong> </td>
                          </tr>
                        <tr>
                          <td width="30%"><%f_antecedentes.DibujaCampo("regi_ccod_colegio")%></td>
                          <td width="20%"><%f_antecedentes.DibujaCampo("ciud_ccod_colegio")%></td>
                          <td width="50%"><%f_antecedentes.DibujaCampo("cole_ccod")%></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="50%"><%f_antecedentes.DibujaCampo("otro_colegio")%>
OTRO COLEGIO </td>
                              <td width="50%"><div align="left"></div>
                                
                                    <div align="left">
                                        <%f_antecedentes.DibujaCampo("pers_tcole_egreso")%>
                                    </div></td>
                            </tr>
                          </table></td>
                        </tr>
                      </table>
                      <br>                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="75%"><%f_antecedentes.DibujaCampo("tens_ccod")%></td>
                          <td><%f_antecedentes.DibujaCampo("pers_ttipo_ensenanza")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="75%"><span class="style3">(*)</span><strong> A&Ntilde;O DE EGRESO</strong>                            <%f_antecedentes.DibujaCampo("pers_nano_egr_media")%></td>
                          </tr>
                      </table>                      
                      <br>                      <br>                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Actividades realizadas en el a&ntilde;o " & f_antecedentes.ObtenerValor("ano_actividades"))%>
                          </p></td>
                        </tr>
                      </table>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                              <td> 
                                <%f_actividades_realizadas.DibujaLista%>
                              </td>
                        </tr>
                      </table>                      <br>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Régimen de estudios")%>
                          </p></td>
                        </tr>
                      </table>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>PRUEBA RENDIDA</strong><br>
                            <%f_antecedentes.DibujaCampo("tpad_ccod")%>
                          </p></td>
                          <td><strong>A&Ntilde;O</strong><br>
                            <%f_antecedentes.DibujaCampo("post_nano_paa")%></td>
                          <td><strong>PROMEDIO N.E.M.</strong><br>
                            <%f_antecedentes.DibujaCampo("pers_nnota_ens_media")%></td>
                        </tr>
                      </table>                      
                      <br>                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>PUNTAJE OBTENIDO EN LENGUAJE (VERBAL)</strong> 
                                  <br>
                                  <%f_antecedentes.DibujaCampo("post_npaa_verbal")%>
                          </p></td>
                          <td><strong>PUNTAJE OBTENIDO EN MATEM&Aacute;TICAS </strong><br>
                              <%f_antecedentes.DibujaCampo("post_npaa_matematicas")%></td>
                          </tr>
                      </table>                      
                      <br>                      <br>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Estudios superiores anteriores")%>
                          </p></td>
                        </tr>
                      </table>                                            
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
                              <strong>TIPO DE INSTITUCI&Oacute;N</strong><br>
                              <%f_antecedentes.DibujaCampo("ties_ccod")%>                              
                            <table width="100%">
                              <tr>
                                <td width="13%"></td>
                                <td width="87%"><%'f_antecedentes.DibujaCampo("post_ttipo_institucion_ant")%></td>
                              </tr>
                            </table>
                            </td>
                        </tr>
                      </table>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr valign="top">
                          <td><p><strong>NOMBRE DE LA CASA DE ESTUDIOS </strong><br>
                                  <%f_antecedentes.DibujaCampo("iesu_ccod")%>
                                  <br>
                                  <%f_antecedentes.DibujaCampo("otra_institucion")%>
OTRA :
<%f_antecedentes.DibujaCampo("post_tinstitucion_anterior")%>
                                  <br>
                          </p></td>
                          <td><strong>&Uacute;LTIMA CARRERA ESTUDIADA</strong><br>
                            <%f_antecedentes.DibujaCampo("post_tcarrera_anterior")%>                            <br>
                            <br></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="33%"><p><strong>DESDE</strong><br>
                                  <%f_antecedentes.DibujaCampo("post_nano_inicio_est_ant")%>                                  
                          </p></td>
                          <td width="33%"><strong>HASTA</strong><br>
                            <%f_antecedentes.DibujaCampo("post_nano_termino_est_ant")%></td>
                          <td width="33%"><strong>N&ordm; DE SEMESTRES APROBADOS </strong><br>
                            <%f_antecedentes.DibujaCampo("post_nsem_aprobados")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>&iquest;SE TITUL&Oacute;?</strong><br>
                                  <%f_antecedentes.DibujaCampo("post_btitulado")%>
                                  <br>
                          </p></td>
                          <td><strong>SI SE TITUL&Oacute;: T&Iacute;TULO OBTENIDO </strong><br>
                            <%f_antecedentes.DibujaCampo("post_ttitulo_obtenido")%></td>
                        </tr>
                      </table>
                      <br>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>&iquest;SOLICITA RECONOCIMIENTO DE ESTUDIOS?</strong><br>
                            <%f_antecedentes.DibujaCampo("post_breconocimiento_estudios")%>
                            <br> 
                            </p></td>
                        </tr>
                      </table>                      <br>
                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Actividades en las que le agradaría participar")%>
                          </p></td>
                        </tr>
                      </table>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%f_actividades_participar.DibujaLista%>
                          </p></td>
                        </tr>
                      </table>                      
                      <br>                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="20"><p>&nbsp;                          </p></td>
                          <td width="60">OTRAS : </td>
                          <td width="553"><%f_antecedentes.DibujaCampo("post_totras_actividades")%></td>
                        </tr>
                      </table>                      <br>                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Antecedentes Previsionales")%>
                          </p></td>
                        </tr>
                      </table>
                          <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>INSTITUCION DE SALUD</strong><br>
                                  <%f_antecedentes.DibujaCampo("isap_ccod")%>
                                  <br>
                          </p></td>
                           </tr>
                      </table>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>- &iquest;Padece de alguna enfermedad que requiere cuidado personal? (Indicar) <br>
                          </p></td>
                          <td><%f_antecedentes.DibujaCampo("pers_tenfermedades")%></td>
                        </tr>
                        <tr>
                          <td>- &iquest;Es al&eacute;rgico a alg&uacute;n medicamento? (Indicar) </td>
                          <td><%f_antecedentes.DibujaCampo("pers_tmedicamentos_alergia")%></td>
                        </tr>
                      </table>
                      <br>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p>
                              <%pagina.DibujarSubtitulo("Antecedentes laborales del alumno (Sólo si trabaja)")%>
                          </p></td>
                        </tr>
                      </table>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>&iquest;TRABAJA?</strong><br>
                            <%f_antecedentes.DibujaCampo("post_btrabaja")%>
                          </p>
                            </td>
                          <td><strong>EMPRESA</strong><br>
                            <%f_antecedentes.DibujaCampo("pers_tempresa")%></td>
                          <td><strong>CARGO O ACTIVIDAD </strong><br>
                            <%f_antecedentes.DibujaCampo("pers_tcargo")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>REGI&Oacute;N</strong><br>
                                  <%f_antecedentes.DibujaCampo("regi_ccod_empresa")%>
                          </p></td>
                          <td><strong>CIUDAD O LOCALIDAD </strong><br>
                              <%f_antecedentes.DibujaCampo("ciud_ccod_empresa")%></td>
                          </tr>
                      </table>                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>CALLE</strong><br>
                                  <%f_antecedentes.DibujaCampo("dire_tcalle")%>
                          </p></td>
                          <td><strong>N&Uacute;MERO</strong><br>
                              <%f_antecedentes.DibujaCampo("dire_tnro")%></td>
                          <td><b>CONJUNTO/CONDOMINIO</b><br>
                            <%f_antecedentes.DibujaCampo("dire_tpoblacion")%></td>
                          <td><strong>TEL&Eacute;FONO</strong><br>
                            <%f_antecedentes.DibujaCampo("dire_tfono")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p><strong>ANTIG&Uuml;EDAD LABORAL </strong><br>
                                  <%f_antecedentes.DibujaCampo("alab_ccod")%>
                          </p></td>
                          </tr>
                      </table>
                      <br></td>
                  </tr>
                </table>
                          <%f_antecedentes.DibujaCampo("pers_ncorr")%>
                          <%f_antecedentes.DibujaCampo("post_ncorr")%>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</td>
</tr>
</table>
</body>
</html>
