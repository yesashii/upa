<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if
 
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Datos Personales"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_22.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_datos_personales = new CFormulario
f_datos_personales.Carga_Parametros "postulacion_22.xml", "datos_personales"
f_datos_personales.Inicializar conexion

set f_datos_carreras = new CFormulario
f_datos_carreras.Carga_Parametros "postulacion_22.xml", "carrera_postulante"
f_datos_carreras.Inicializar conexion


sql_carrera_postulante =   " SELECT  D.CARR_TDESC +' '+ C.ESPE_TDESC as carr_tdesc  " &vbcrlf & _
							" from detalle_postulantes a, ofertas_academicas b, " &vbcrlf & _
							" especialidades c,carreras d,sedes e,jornadas f, " &vbcrlf & _
							" ESTADO_EXAMEN_POSTULANTES G" & VBCRLF & _
							" where a.ofer_ncorr = b.ofer_ncorr " &vbcrlf & _
							" and b.espe_ccod = c.espe_ccod " &vbcrlf & _
							" and c.carr_ccod = d.carr_ccod " &vbcrlf & _
							" and b.sede_ccod =e.sede_ccod " &vbcrlf & _
							" and b.jorn_ccod = f.jorn_ccod " &vbcrlf & _
							" and A.EEPO_ccod = G.EEPO_ccod " &vbcrlf & _
                            " and d.ecar_ccod = 1 " &vbcrlf & _
                            "  and d.inst_ccod = 1 " &vbcrlf & _ 							
							" and cast(a.post_ncorr as varchar)='"&v_post_ncorr&"' " &vbcrlf & _
							" order by carr_tdesc"


f_datos_carreras.consultar sql_carrera_postulante

consulta = "  select   b.pers_nrut, b.pers_xdv, b.pers_tape_paterno, b.pers_tape_materno, b.pers_tnombre, b.pers_ncorr, b.ciud_ccod_nacimiento,  " & vbCrLf &_
			"   b.pers_fnacimiento, b.sexo_ccod, b.eciv_ccod, b.pers_temail, b.tvis_ccod, b.pais_ccod, b.pers_tpasaporte, " & vbCrLf &_
			"   b.pers_femision_pas, b.pers_fvencimiento_pas, b.pers_bdoble_nacionalidad, " & vbCrLf &_
			"   b.pers_nrut as pers_nrut_extranjero, b.pers_xdv as pers_xdv_extranjero ,b.pers_tfono, b.pers_tcelular,b.ciud_nacimiento,b.regi_particular,b.ciud_particular, " & vbCrLf &_
			"   (select dire_tblock from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as dire_tblock_particular, " & vbCrLf &_
			"   (select dire_tcalle from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as dire_tcalle_particular, " & vbCrLf &_
			"   (select dire_tnro from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as dire_tnro_particular, " & vbCrLf &_
			"   (select dire_tpoblacion from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as dire_tpoblacion_particular, " & vbCrLf &_
			"   (select ciud_ccod from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as ciud_ccod_particular , " & vbCrLf &_
			"   (select dire_tblock from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as dire_tblock_academico, " & vbCrLf &_
			"   (select dire_tcalle from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as dire_tcalle_academico, " & vbCrLf &_
			"   (select dire_tnro from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as dire_tnro_academico, " & vbCrLf &_
			"   (select dire_tpoblacion from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as dire_tpoblacion_academico, " & vbCrLf &_
			"   (select ciud_ccod from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as ciud_ccod_academico, " & vbCrLf &_
			"   (select dire_tfono from direcciones_publica f " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as dire_tfono_academico,  " & vbCrLf &_
			"   (select regi_ccod from direcciones_publica f, ciudades g " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.ciud_ccod = g.ciud_ccod " & vbCrLf &_
			"    and f.tdir_ccod  = 1 ) as regi_ccod_particular,     " & vbCrLf &_
			"   (select regi_ccod from direcciones_publica f, ciudades g " & vbCrLf &_
			"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"    and f.ciud_ccod = g.ciud_ccod " & vbCrLf &_
			"    and f.tdir_ccod  = 2 ) as regi_ccod_academico,         " & vbCrLf &_
			" CASE WHEN  B.pers_tcole_egreso IS NULL THEN 'N' " & vbCrLf &_
            " WHEN  B.pers_tcole_egreso ='' THEN 'N' " & vbCrLf &_
         	" ELSE 'S' " & vbCrLf &_
    		" END AS otro_colegio, " & vbCrLf &_
			" isnull(b.ciud_ccod_cole,0) as ciud_ccod_colegio,  " & vbCrLf &_
    		"   (select aa.regi_ccod " & vbCrLf &_
     		"   from regiones aa, ciudades bb " & vbCrLf &_
			"   where aa.regi_ccod = bb.regi_ccod " & vbCrLf &_
     		"   and bb.ciud_ccod = b.ciud_ccod_cole) as regi_ccod_colegio ,b.cole_ccod, c.ciud_ccod,b.tens_ccod,b.pers_ttipo_ensenanza,b.pers_nano_egr_media,B.pers_tcole_egreso " & vbCrLf &_        
 			" from  postulantes a join  personas_postulante b " & vbCrLf &_
        	"		on a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
       		" left outer join colegios c " & vbCrLf &_
        	"		on b.cole_ccod=c.cole_ccod " & vbCrLf &_
			"  where a.post_ncorr = '" & v_post_ncorr & "'"

f_datos_personales.Consultar consulta
f_datos_personales.Siguiente

'response.Write("<pre>" & consulta & "</pre>")

'-------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"

'-------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")


if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1_breve.asp"), Array("Datos Personales", "postulacion_2_breve.asp"), Array("Apoderado Sostenedor", "postulacion_5_breve.asp"))	
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
end if

pais=f_datos_personales.Obtenervalor("pais_ccod")
'response.Write("Pais "&f_datos_personales.Obtenervalor("pais_ccod"))

'-------------------------Creamos arreglo con colegios para seleccionar el del alumno postulante-------------------------
'---------------------------Marcelo Sandoval 26-10-2007------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------
 set f_colegios = new CFormulario
 f_colegios.Carga_Parametros "postulacion_22.xml", "buscador_colegios"
 f_colegios.inicializar conexion

 cole_ccod = f_datos_personales.obtenerValor("cole_ccod")
 if cole_ccod <> "" then
 	ciud_ccod = f_datos_personales.obtenerValor("ciud_ccod")
	regi_ccod = conexion.consultaUno("select regi_ccod from ciudades where cast(ciud_ccod as varchar)='"&ciud_ccod&"'")
 else
 	ciud_ccod= f_datos_personales.obtenerValor("ciud_ccod_colegio")	
	regi_ccod= f_datos_personales.obtenerValor("regi_ccod_colegio")	
 end if
 consulta="Select '"&regi_ccod&"' as regi_ccod, '"&ciud_ccod&"' as ciud_ccod, '"&cole_ccod&"' as cole_ccod"
 f_colegios.consultar consulta

 consulta = " select c.regi_ccod,c.regi_tdesc,b.ciud_ccod,b.ciud_tdesc,a.cole_ccod,replace(a.cole_tdesc,'''',' ')  as cole_tdesc " & vbCrLf & _
			" from colegios a, ciudades b, regiones c " & vbCrLf & _
			" where a.ciud_ccod=b.ciud_ccod and b.regi_ccod=c.regi_ccod  and isnull(a.cole_trbd,'') <> '' " & vbCrLf & _
			" order by c.regi_ccod, ciud_tdesc, cole_tdesc "  
'response.Write("<pre>"&consulta&"</pre>")	
f_colegios.inicializaListaDependiente "Busqueda_Colegios", consulta
f_colegios.siguiente
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
var b_extranjero;

function BuscarSeleccionadoRadio(p_radio) {	
	for (i = 0; i < p_radio.length; i++) {
		if (p_radio[i].checked) {			
			return i + 1;
		}
	}	
	
	return 0;
}


function Validar()
{
	formulario = document.edicion;	
	
	/************************************************************************************************/	
	o_sexo_ccod = formulario.elements["dp[0][sexo_ccod]"];		
	
	if (BuscarSeleccionadoRadio(o_sexo_ccod) < 1) {
		alert('Seleccione sexo.');
		return false;
	}
	
	
	/************************************************************************************************/		
	if (b_extranjero) {
		if (!isEmpty(formulario.elements["dp[0][pers_nrut_extranjero]"].value)) {
			if (!valida_rut(formulario.elements["dp[0][pers_nrut_extranjero]"].value + '-' + formulario.elements["dp[0][pers_xdv_extranjero]"].value)) {
				alert('Ingrese un RUT válido.');				
				formulario.elements["dp[0][pers_xdv_extranjero]"].focus();
				formulario.elements["dp[0][pers_xdv_extranjero]"].select();				
				return false;
			}
		}
		
		if ( (isEmpty(formulario.elements["dp[0][pers_nrut_extranjero]"].value)) && (isEmpty(formulario.elements["dp[0][pers_tpasaporte]"].value)) ) {
			alert('Si extranjero, debe ingresar Cédula de Identidad o Número de Pasaporte.');
			return false;
		}
		
		
		if (BuscarSeleccionadoRadio(formulario.elements["dp[0][pers_bdoble_nacionalidad]"]) < 1) {
			alert("Si es extranjero, debe especificar si tiene doble nacionalidad.");
			return false;
		}
	}	
	
	/************************************************************************************************/		
	return true;	
}


function MostrarCamposAlumnosExtranjeros()
{
	formulario = document.edicion;
	
	campos = new Array("dp[0][pers_nrut_extranjero]", "dp[0][pers_xdv_extranjero]",
	                   "dp[0][tvis_ccod]", "dp[0][pers_tpasaporte]", "dp[0][pers_femision_pas]", "dp[0][pers_fvencimiento_pas]",
					   "dp[0][pers_bdoble_nacionalidad]");
					   
	b_extranjero = (formulario.elements["dp[0][pais_ccod]"].value == "1") ? false : true;
	//if(formulario.elements["dp[0][pais_ccod]"].value == "1"){
	//	formulario.elements["dp[0][pais_ccod]"].disabled=true;
	//}
	for (i in campos) {
		elemento = formulario.elements[campos[i]];
		
		if (campos[i] == "dp[0][pers_bdoble_nacionalidad]") {			
			for (j = 0; j < elemento.length; j++) {
				elemento[j].setAttribute("disabled", !b_extranjero);
			}
		}
		else {
			elemento.setAttribute("disabled", !b_extranjero);
		}
	}
}





var t_datos_personales;

function InicioPagina()
{  var pais;
	t_datos_personales = new CTabla("dp");
    pais=<%=cint(pais)%>
	//alert("pais "+pais);
	if (pais == 1){
	_FiltrarCombobox(document.edicion.elements["dp[0][ciud_ccod_particular]"], 
	                 document.edicion.elements["dp[0][regi_ccod_particular]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_datos_personales.ObtenerValor("ciud_ccod_particular")%>');
	}				

	MostrarCamposAlumnosExtranjeros();	 

}

function HabilitarTextbox(p_textbox, p_habilitado)
{
	//alert(p_habilitado);
	p_textbox.setAttribute("disabled", !p_habilitado);
	if (p_habilitado)
	{
		p_textbox.setAttribute("id", "TO-N");
	}
	else
	{
		p_textbox.setAttribute("id", "TO-S");
	}
}

function HabilitarTextboxTipoEnsenanza()
{
	formulario = document.edicion;	
	
	o_tens_ccod = formulario.elements["dp[0][tens_ccod]"];
	
	
	HabilitarTextbox(formulario.elements["dp[0][pers_ttipo_ensenanza]"], ValorRadioButton(o_tens_ccod) == "4");	
	
	if (ValorRadioButton(o_tens_ccod) == "4") {
		formulario.elements["dp[0][pers_ttipo_ensenanza]"].focus();
		formulario.elements["dp[0][pers_ttipo_ensenanza]"].id="TO-N";
	}
	else
	{
		formulario.elements["dp[0][pers_ttipo_ensenanza]"].id="TO-S";
	}
		
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "dp[0][pers_fnacimiento]","1","edicion","fecha_oculta_fnacimiento"
	calendario.FinFuncion
%>
<style type="text/css">
<!--
.style3 {color: #FF0000; font-weight: bold; }
-->
</style>
<% f_colegios.generaJS %>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 2
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "FICHA DE POSTULACION DATOS PERSONALES" %>
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
                    <td><%pagina.DibujarSubtitulo "Postulaciones"%><br>
                      <strong><%f_datos_carreras.dibujatabla%></strong>                                           
                      <br>
					  <%f_datos_personales.DibujaCampo("pers_ncorr")%>
                      <br>
                      <%pagina.DibujarSubtitulo("1. Identificación del alumno")%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%"><strong>R.U.T.</strong><br>                              
                              <%f_datos_personales.DibujaCampo("pers_nrut")%> - <%f_datos_personales.DibujaCampo("pers_xdv")%></td>
                              <td width="50%"><br>
                              </td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style3">(*)</span> <strong>APELLIDO PATERNO </strong><br>                              
                              <%f_datos_personales.DibujaCampo("pers_tape_paterno")%>                              </td>
                          <td><span class="style3">(*)</span><strong> APELLIDO MATERNO </strong><br>
                              <strong>
                              <%f_datos_personales.DibujaCampo("pers_tape_materno")%>
                              </strong></td>
                          <td><span class="style3">(*)</span><strong> NOMBRES</strong><br>
                              <strong>
                              <%f_datos_personales.DibujaCampo("pers_tnombre")%>
                              </strong></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><span class="style3">(*)</span> <strong>FECHA 
                                DE NACIMIENTO </strong><br> <strong> 
                                <%f_datos_personales.DibujaCampo("pers_fnacimiento")%>
                                <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                </a> 
                                <%calendario.DibujaImagen "fecha_oculta_fnacimiento","1","edicion" %>
                                </strong></td>
                              <td><span class="style3">(*)</span> <strong>CIUDAD 
                                DE NACIMIENTO </strong><br> <strong> 
                                <%if cint(pais)=1 then
								   		f_datos_personales.AgregaCampoParam "ciud_ccod_nacimiento","id","TO-N"
										f_datos_personales.AgregaCampoParam "ciud_nacimiento", "permiso", "OCULTO"
										f_datos_personales.DibujaCampo("ciud_ccod_nacimiento")
								  else
								   		f_datos_personales.AgregaCampoParam "ciud_ccod_nacimiento", "permiso", "OCULTO"
								   		f_datos_personales.AgregaCampoParam "ciud_nacimiento","id","TO-N"
    						   	   		f_datos_personales.DibujaCampo("ciud_nacimiento")%>
								 <%end if%>
                                </strong> </td>
                            </tr>
                            <tr> 
                              <td><br> <span class="style3">(*)</span><strong> 
                                SEXO</strong><br> <strong> 
                                <%f_datos_personales.DibujaCampo("sexo_ccod")%>
                                </strong> </td>
                              <td><br> <span class="style3">(*)</span><strong> 
                                ESTADO CIVIL</strong> <br> <strong> 
                                <%f_datos_personales.DibujaCampo("eciv_ccod")%>
                                </strong> </td>
                            </tr>
                          </table>
                      <br>
                      <br>
                      <%pagina.DibujarSubtitulo("2. Residencia de origen del alumno")%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%"><span class="style3">(*)</span><strong> REGI&Oacute;N</strong><br>
                              <strong>
                              <% if cint(pais)=1 then
							      f_datos_personales.AgregaCampoParam "regi_particular", "permiso", "OCULTO"
								  f_datos_personales.AgregaCampoParam "regi_ccod_particular", "id", "TO-N"
							      f_datos_personales.DibujaCampo("regi_ccod_particular")
							  else
  							      f_datos_personales.AgregaCampoParam "regi_ccod_particular", "permiso", "OCULTO"
								  f_datos_personales.AgregaCampoParam "regi_particular", "id", "TO-N"
  							      f_datos_personales.DibujaCampo("regi_particular")
							  end if%>
</strong>                          </td>
                              <td width="50%"><span class="style3">(*)</span><strong> 
                                CIUDAD DE PROCEDENCIA</strong><br>
                              <strong>
                              <% 
							  if cint(pais)=1 then
							      f_datos_personales.AgregaCampoParam "ciud_particular", "permiso", "OCULTO"
								  f_datos_personales.AgregaCampoParam "ciud_ccod_particular", "id", "TO-N"
							      f_datos_personales.DibujaCampo("ciud_ccod_particular")
							  else
  							      f_datos_personales.AgregaCampoParam "ciud_ccod_particular", "permiso", "OCULTO"
								  f_datos_personales.AgregaCampoParam "ciud_particular", "id", "TO-N"
  							      f_datos_personales.DibujaCampo("ciud_particular")
							  end if%>
                              </strong></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="24%"><span class="style3">(*)</span><strong> CALLE</strong><br> 
                                <strong> 
                                <%f_datos_personales.DibujaCampo("dire_tcalle_particular")%>
                                </strong> </td>
                              <td width="17%"><span class="style3">(*)</span><strong> N&Uacute;MERO</strong><br> 
                                <strong> 
                                <%f_datos_personales.DibujaCampo("dire_tnro_particular")%>
                                </strong></td>
                              <td width="15%">&nbsp;<strong>DEPTO<br>                                <strong> 
                                <%f_datos_personales.DibujaCampo("dire_tblock_particular")%>
                                </strong></strong></td>
                              <td width="22%"><strong> CONDOMINIO/CONJUNTO</strong><br> <strong> 
                                <%f_datos_personales.DibujaCampo("dire_tpoblacion_particular")%>
                                </strong></td>
                              <td width="22%"><span class="style3">(*)</span><strong> TEL&Eacute;FONO</strong><br> 
                                <strong> 
                                <%f_datos_personales.DibujaCampo("pers_tfono")%>
                                </strong></td>
                            </tr>
                          </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%"><strong>CORREO ELECTR&Oacute;NICO </strong><br>
                              <strong>
                              <%f_datos_personales.DibujaCampo("pers_temail")%>
                            </strong> </td>
                          <td width="50%"><strong>                            </strong></td>
                        </tr>
                      </table>
					  <br>
                      <br>
                      <%pagina.DibujarSubtitulo("3. Establecimiento donde egreso de enseñanza media.")%>
                      <br>
					  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style3">(*)</span> <strong>REGION</strong><br>                              
                              <%f_colegios.dibujaCampoLista "Busqueda_Colegios", "regi_ccod" %>                             </td>
                          <td><span class="style3">(*)</span><strong>CIUDAD</strong><br>
                              <strong>
                              <%f_colegios.dibujaCampoLista "Busqueda_Colegios", "ciud_ccod" %>
                              </strong></td>
                          <td><strong>ESTABLECIMIENTO</strong><br>
                              <strong>
                              <%f_colegios.dibujaCampoLista "Busqueda_Colegios", "cole_ccod" %>
                              </strong></td>
                        </tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<!--<tr>
                          <td>&nbsp;</td>
                          <td><span class="style3"></span><strong>OTRO COLEGIO</strong><br>
                              <strong>
                              	<%f_datos_personales.DibujaCampo("otro_colegio")%>
                              </strong></td>
                          <td><strong>ESTABLECIMIENTO</strong><br>
                              <strong>
                                <%f_datos_personales.DibujaCampo("pers_tcole_egreso")%>
                              </strong></td>
                        </tr>-->
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
                          <td colspan="2" align="left"><%f_datos_personales.DibujaCampo("tens_ccod")%></td>
                          <td><%f_datos_personales.DibujaCampo("pers_ttipo_ensenanza")%></td>
                        </tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
                          <td><span class="style3">(*)</span><strong>AÑO DE EGRESO</strong><br>
                              <strong>
                              	<%f_datos_personales.DibujaCampo("pers_nano_egr_media")%>
                              </strong></td>
						  <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                      </table>
					  <br>
					  <%pagina.DibujarSubtitulo("4. Información de alumnos extranjeros")%>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="31%"><span class="style3">(*)</span><strong>PA&Iacute;S DE ORIGEN </strong><br>
                            <strong>
                            <%f_datos_personales.DibujaCampo("pais_ccod")%>
                            </strong>                          </td>
                          <td width="30%"><span class="style3">(*)</span><strong>CEDULA DE IDENTIDAD</strong> <br>
                              <strong>
                              <%f_datos_personales.DibujaCampo("pers_nrut_extranjero")%>
                              </strong>      -
                              <strong>
                              <%f_datos_personales.DibujaCampo("pers_xdv_extranjero")%>
                              </strong>                          </td>
                          <td width="39%"><span class="style3">(*)</span><strong>TIPO VISA </strong><br>
                              <strong>
                              <%f_datos_personales.DibujaCampo("tvis_ccod")%>
</strong></td>
                        </tr>
                        <tr>
                          <td><br>
                                <span class="style3">(*)</span><strong>N&ordm; 
                                PASAPORTE O D.N.I. </strong><br>
                          <strong>
                          <%f_datos_personales.DibujaCampo("pers_tpasaporte")%>
                          </strong> </td>
                          <td><br>
                            <span class="style3">(*)</span><strong>FECHA DE EMISI&Oacute;N </strong><br>
                            <%f_datos_personales.DibujaCampo("pers_femision_pas")%>
	                        <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                            </a>
							 <%calendario.DibujaImagen "fecha_oculta_femision","2","edicion" %>                       
						  </td>
                          <td><br>
                            <span class="style3">(*)</span><strong>FECHA DE VENCIMIENTO </strong><br>
                            <%f_datos_personales.DibujaCampo("pers_fvencimiento_pas")%>
	                        <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(3)", "11");'> 
                            </a> 
							 <%calendario.DibujaImagen "fecha_oculta_fvencimiento","3","edicion" %>
                          </td>
                        </tr>
                        <tr>
                              <td height="42"><br>
                            <span class="style3">(*)</span><strong>&iquest;DOBLE NACIONALIDAD?</strong><br>      
      <%f_datos_personales.DibujaCampo("pers_bdoble_nacionalidad")%>
      </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                      </table>
					  <br>
                
                      </td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%
				  f_botonera.AgregaBotonParam "anterior", "url", "postulacion_1_breve.asp"
				  f_botonera.DibujaBoton("anterior")
				  %></div></td>
                  <td><div align="center">
                    <%
					f_botonera.AgregaBotonParam "siguiente", "url", "proc_postulacion_2_breve.asp"
					f_botonera.DibujaBoton("siguiente")%>
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
