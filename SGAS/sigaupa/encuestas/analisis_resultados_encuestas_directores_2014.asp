<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%Server.ScriptTimeOut = 150000
set pagina = new CPagina
pagina.Titulo = "Estados de Evaluaciones Asignaturas"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "analisis_resultados_encuestas_directores_2014.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod  =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	=	request.querystring("busqueda[0][sede_ccod]")
 peri_ccod	=	request.querystring("busqueda[0][peri_ccod]")
 todas		=	request.querystring("busqueda[0][todas]")
 sedes		=	request.querystring("sedes")
 carreras	=	request.querystring("carreras")
 jornadas	=	request.querystring("jornadas")
 periodos	=	request.querystring("periodos")
 incluye_rut=	request.querystring("rut")
 pers_nrut	=	request.querystring("busqueda[0][pers_nrut]")
 
' response.Write("pers_nrut: "&pers_nrut)
' response.End()
 'response.Write("sedes: "&sedes&"<br />"&"carreras: "&carreras&"<br />"&"jornadas: "&jornadas)
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 peri_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar) ='"&peri_ccod&"'")
 
 
 
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	asig_tdesc = conexion.consultaUno("select asig_ccod + ' --> '+ asig_tdesc from asignaturas where cast(asig_ccod as varchar) ='"&asig_ccod&"'")
 else
    asig_tdesc = "<< Todas las Asignaturas >>"
 end if	
 codigo = asig_ccod

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "analisis_resultados_encuestas_2014.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 'sede = negocio.obtenerSede
 
 anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar) ='"&periodo&"'")

'response.Write("anos_ccod:"&anos_ccod&"<br>"&"periodo:"&periodo)
'response.End()

 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas "
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = "select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc,p.PERI_CCOD,p.PERI_TDESC " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es,PERIODOS_ACADEMICOS p " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod " & vbCrLf & _
		   " and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod" & vbCrLf &_
		   " and b.secc_tdesc <>'Poblamiento' and p.PERI_CCOD>=230 and p.PLEC_CCOD<=2 " & vbCrLf & _
		   " and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and cast(b.peri_ccod as varchar)='"&peri&"' order by f.sede_tdesc,a.carr_tdesc asc" 

'response.Write("consulta:-"&consulta&"-")	
 f_busqueda.inicializaListaDependiente "lBusqueda2", consulta

 f_busqueda.Siguiente
 
'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "analisis_resultados_encuestas_directores_2014.xml", "formu_carga"
f_asignaturas.Inicializar conexion

 if carr_ccod= "" then
    codigo = "  "
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if

if (todas = "" or todas="N") then
 	 filtro_asignaturas = ""
else
	 filtro_asignaturas = ""
end if	

if sedes = 1 then
	filtro_sede = ""
else
	filtro_sede = " and cast(b.sede_ccod as varchar)='"&sede_ccod&"'"	
end if

if carreras = 1 then
	filtro_carrera = ""
else
	filtro_carrera = " and cast(b.carr_ccod as varchar)='"&carr_ccod&"'"	
end if

if jornadas = 1 then
	filtro_jornada = ""
else
	filtro_jornada = " and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"'"	
end if

if periodos = 1 then
	filtro_periodos = " and f.peri_ccod >= 212"
else
	filtro_periodos = " and f.peri_ccod = "&peri_ccod&""	
end if

response.Write("incluye_rut: "&incluye_rut)
if incluye_rut = 1 then
pers_ncorr_buscado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	filtro_rut = " and d.PERS_NCORR = "&pers_ncorr_buscado
else
	filtro_rut = " "	
end if

consulta = "select distinct a.secc_ccod,c.CARR_CCOD,c.CARR_TDESC,d.ASIG_TDESC, "& vbCrLf &_
"a.pers_ncorr,b.secc_tdesc,a.pers_ncorr_profesor,e.PERS_TNOMBRE + ' ' + "& vbCrLf &_ 
"e.PERS_TAPE_PATERNO + ' ' + e.PERS_TAPE_MATERNO as docente,a.estado_cuestionario,"& vbCrLf &_ 
"'<a href=""detalle_dimension_1.asp?promedio='+cast(isnull(a.promedio_dimension_1,0) as varchar)+'"" target= ""_blank"">'+isnull(cast(a.promedio_dimension_1 as varchar),0)+'</a>' as promedio_dimension_1,"& vbCrLf &_
"'<a href=""detalle_dimension_1.asp?promedio='+cast(isnull(a.promedio_dimension_2,0) as varchar)+'"" target= ""_blank"">'+isnull(cast(a.promedio_dimension_2 as varchar),0)+'</a>' as promedio_dimension_2, "& vbCrLf &_
"'<a href=""detalle_dimension_1.asp?promedio='+cast(isnull(a.promedio_dimension_3,0) as varchar)+'"" target= ""_blank"">'+isnull(cast(a.promedio_dimension_3 as varchar),0)+'</a>' as promedio_dimension_3, "& vbCrLf &_ 
"a.promedio_dimension_4,a.promedio_dimension_5,b.ASIG_CCOD,a.puntaje_total,"& vbCrLf &_
"f.peri_ccod,f.peri_tdesc,"& vbCrLf &_
"(select count(*) from cargas_Academicas aa where a.secc_ccod = aa.secc_ccod) "& vbCrLf &_
"as cantidad_alumnos from cuestionario_opinion_alumnos as a inner join secciones as b "& vbCrLf &_
"on a.secc_ccod = b.SECC_CCOD" & filtro_rut & vbCrLf &_
"and isnull(a.estado_cuestionario,0)=2 inner join CARRERAS as c "& vbCrLf &_
"on c.CARR_CCOD = b.CARR_CCOD inner join ASIGNATURAS as d on b.ASIG_CCOD = d.ASIG_CCOD "& vbCrLf &_
"inner join PERSONAS as e on a.pers_ncorr_profesor = e.PERS_NCORR "& vbCrLf &_
"inner join periodos_Academicos as f on b.peri_ccod = f.peri_ccod "& filtro_periodos & vbCrLf &_
"where f.ANOS_CCOD='2013' "& filtro_sede & filtro_carrera & filtro_jornada 

'response.Write("filtro: -"&filtro_asignaturas&"-")
response.Write("<pre>"&consulta &"</pre>")			   
'response.End()
  if Request.QueryString <> "" then
     f_asignaturas.consultar consulta & " ORDER BY asig_tdesc, secc_tdesc "  
	 botonera.agregabotonparam "encuestas_escuela_excel", "deshabilitado", "FALSE"
	 botonera.agregabotonparam "observaciones_excel", "deshabilitado", "FALSE"
  else
	f_asignaturas.consultar "select * from secciones where 1=2 "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

'f_asignaturas.siguiente

'asig_ccod	=	f_asignaturas.obtenerValor("asig_ccod")

'response.End()
consulta_carreras = " select cast(avg(puntaje_total) as decimal(5,4)) from cuestionario_opinion_alumnos a, secciones b, periodos_academicos c "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and carr_ccod='"&carr_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
				    " and b.peri_ccod=c.peri_ccod "& vbCrLf &_
					" and cast(anos_ccod as varchar)='"&anos_ccod&"'"
promedio_carrera = conexion.consultaUno(consulta_carreras)				
'response.Write("<->"&consulta_carreras&"<br/>")
consulta_facultad = " select cast(avg(puntaje_total) as decimal(5,4)) from cuestionario_opinion_alumnos a, secciones b, periodos_academicos c "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod "& vbCrLf &_
					" and carr_ccod in ( "& vbCrLf &_
					" select distinct b.carr_ccod from areas_academicas a, carreras b"& vbCrLf &_
					" where a.area_ccod=b.area_ccod "& vbCrLf &_
					" and a.facu_ccod in (select facu_ccod from carreras a, areas_academicas b where a.carr_ccod= '"&carr_ccod&"' and a.area_ccod=b.area_ccod) "& vbCrLf &_
					" ) "& vbCrLf &_
					" and b.peri_ccod=c.peri_ccod "& vbCrLf &_
					" and cast(anos_ccod as varchar)='"&anos_ccod&"'"
promedio_facultad = conexion.consultaUno(consulta_facultad)		
'response.Write("<->"&consulta_facultad&"</br />")
consulta_universidad = " select cast(avg(puntaje_total) as decimal(5,4)) from cuestionario_opinion_alumnos a, secciones b, periodos_academicos c "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod "& vbCrLf &_
				    " and b.peri_ccod=c.peri_ccod "& vbCrLf &_
					" and cast(anos_ccod as varchar)='"&anos_ccod&"'"
promedio_universidad = conexion.consultaUno(consulta_universidad)	
'response.Write("<->"&consulta_universidad&"<br />")
	
'response.Write(promedio_carrera)
url_leng_1 = "analisis_resultados_encuestas_2014.asp"
url_leng_2 = "encuesta_directores_docentes_2014.asp"
url_leng_3 = "encuesta_autoevaluacion_docentes_2014.asp"
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
function enviar(formulario){
	
if ((document.buscador.elements("incluir_rut").checked) || (document.buscador.elements("busqueda[0][pers_nrut]").disabled==false)) {
	//alert("checkeado");
	//alert(document.buscador.elements("busqueda[0][pers_nrut]").value);
	document.buscador.elements("rut").value=1;	
	if (document.buscador.elements("busqueda[0][pers_nrut]").value==""){
		alert("Debe ingresar un rut");
		return false;
	}
	else {
		document.getElementById("texto_alerta").style.visibility="visible";
		formulario.action ="analisis_resultados_encuestas_directores_2014.asp";
		valida_check();
		formulario.submit();
	}
}
else {
	document.buscador.elements("rut").value=0;	
	document.getElementById("texto_alerta").style.visibility="visible";
	formulario.action ="analisis_resultados_encuestas_directores_2014.asp";
	valida_check();
	formulario.submit();
          
}
}

function valida_check(){
//alert(objeto.checked);
//alert(document.buscador.elements("todas_sede").checked);
if (document.buscador.elements("todas_sede").checked) {
	document.buscador.elements("busqueda[0][SEDE_CCOD]").disabled=true;	
	document.buscador.elements("sedes").value=1;
	
}
else{
	document.buscador.elements("busqueda[0][SEDE_CCOD]").disabled=false;
	document.buscador.elements("sedes").value=0;	
	
}
if (document.buscador.elements("todas_carrera").checked) {
	document.buscador.elements("busqueda[0][CARR_CCOD]").disabled=true;	
	document.buscador.elements("carreras").value=1;
}
else{
	document.buscador.elements("busqueda[0][CARR_CCOD]").disabled=false;
	document.buscador.elements("carreras").value=0;	
}
if (document.buscador.elements("todas_jornada").checked) {
	document.buscador.elements("busqueda[0][JORN_CCOD]").disabled=true;
	document.buscador.elements("jornadas").value=1;	
}
else{
	document.buscador.elements("busqueda[0][JORN_CCOD]").disabled=false;	
	document.buscador.elements("jornadas").value=0;
}
if (document.buscador.elements("todos_periodos").checked) {
	document.buscador.elements("busqueda[0][PERI_CCOD]").disabled=true;
	document.buscador.elements("periodos").value=1;	
}
else{
	document.buscador.elements("busqueda[0][PERI_CCOD]").disabled=false;	
	document.buscador.elements("periodos").value=0;
}
}
function incluye_rut(){
	
if (document.buscador.elements("incluir_rut").checked) {
	//alert(document.buscador.elements("incluir_rut").value);
	document.buscador.elements("busqueda[0][pers_nrut]").disabled=false;
	document.buscador.elements("busqueda[0][pers_xdv]").disabled=false;
	//document.buscador.elements("rut").value=1;	
}
else{
	//alert(document.buscador.elements("incluir_rut").value);
	document.buscador.elements("busqueda[0][pers_nrut]").disabled=true;
	document.buscador.elements("busqueda[0][pers_xdv]").disabled=true;
	document.buscador.elements("busqueda[0][pers_nrut]").value="";
	document.buscador.elements("busqueda[0][pers_xdv]").disabled=true;
	//document.buscador.elements("rut").value=0;
}
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %>
			<%'pagina.DibujarLenguetasFClaro Array(Array("Alumnos", url_leng_1),Array("Director", url_leng_2), Array("Autoevaluación", url_leng_3)), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="13%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="4%"><% f_busqueda.dibujaCampoLista "lBusqueda2", "sede_ccod"%></td>
								<td width="50%">Todas <input type="checkbox" name="todas_sede" id="todas_sede" onChange="valida_check()">
                                <input type="hidden" name="sedes"></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda2", "carr_ccod"%></td>
								<td>Todas
                                <input type="checkbox" name="todas_carrera" id="todas_carrera" onChange="valida_check()"> 
                                <input type="hidden" name="carreras"></td>
								<td>&nbsp;</td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda2", "jorn_ccod"%></td>
								<td>Todas
                                <input type="checkbox" name="todas_jornada" id="todas_jornada" onChange="valida_check()">
                                <input type="hidden" name="jornadas"></td>
								<td>&nbsp;</td>
                              </tr>
							  <tr>
							    <td> <div align="left">Periodo</div></td>
							    <td><div align="center">:</div></td>
							    <td><% f_busqueda.dibujaCampoLista "lBusqueda2", "peri_ccod"%></td>
							    <td>Todas
                                  <input type="checkbox" name="todos_periodos" id="todos_periodos" onChange="valida_check()">
                                <input type="hidden" name="periodos"></td>
							    <td>&nbsp;</td>
                                
					        </tr>
							  <tr> 
                                <td colspan="5"> <!--<div align="left">Sólo encuestadas</div> --> <!--<div align="center">:</div> --> <%'f_busqueda.dibujaCampo("todas")%><hr></td>
							  </tr>
							  <tr>
							    <td><div align="right"><input type="checkbox" name="incluir_rut" id="incluir_rut" onChange="incluye_rut()">
                                <input type="hidden" name="rut"></div></td>
							    <td>&nbsp;</td>
							    <td colspan="3">Incluir el Rut en la busqueda</td>
						    </tr>
							  <tr>
							    <td>Rut</td>
							    <td><div align="center">:</div></td>
							    <td colspan="3"> <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                <a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
						    </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="3"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if Request.QueryString <> "" then%>
					  <tr> 
                        <td width="9%">Sede</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=peri_tdesc%> (Seleccionado de la actividad Toma de Carga)</td>
                      </tr>
					  <!--<tr>
					  	<td colspan="3" align="left"><strong>Puntaje Promedio Carrera </strong>: <%=promedio_carrera%></td>
					  </tr>
					  <tr>
					  	<td colspan="3" align="left"><strong>Puntaje Promedio Facultad </strong>: <%=promedio_facultad%></td>
					  </tr>
					  <tr>
					  	<td colspan="3" align="left"><strong>Puntaje Promedio Universidad </strong>: <%=promedio_universidad%></td>
					  </tr>-->
					  <%end if%>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                        <td><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div></td>
                  </tr>
				  <tr>
                    <td>
                      <br>
					  <%f_asignaturas.dibujaTabla()%>
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
            <td width="12%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div align="center"><%
						botonera.agregaBotonParam "observaciones_excel","url","encuestas_docentes_totales_2014_excel.asp?carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod&"&anos_ccod="&anos_ccod
														botonera.dibujaBoton "observaciones_excel"								%></div></td>
						<td><% botonera.agregaBotonParam "encuestas_escuela_excel","url","analisis_resultados_encuestas_2014_excel.asp?carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod&"&peri_ccod="&periodo
														botonera.dibujaBoton "encuestas_escuela_excel"							%></td>
						<td><div align="center"></div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="88%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
