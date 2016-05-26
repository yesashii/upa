<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: EGRESO Y TITULACION 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:28/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:154
'********************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

v_pers_ncorr = request.QueryString("pers_ncorr")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
dlpr_ncorr = request.QueryString("dlpr_ncorr")
letra = request.QueryString("letra")
recortar = request.QueryString("recortar")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Editar Datos Laborales del Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "m_profesionales_upa.xml", "botonera_datos_laborales"

'---------------------------------------------------------------------------------------------------
set f_datos_laborales = new CFormulario
f_datos_laborales.Carga_Parametros "m_profesionales_upa.xml", "datos_laborales"
f_datos_laborales.Inicializar conexion


carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
jornada = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from alumni_personas (nolock) where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'") 
nombre_alumno = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from alumni_personas (nolock) where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'") 

consulta =  "   select dlpr_ncorr,pers_ncorr,pais_ccod,ciud_ccod,dlpr_cpostal,dlpr_tcalle,dlpr_tnro,dlpr_tpoblacion,dlpr_tblock, " & vbCrLf &_
			"       dlpr_tfono,dire_tfax,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_depto_empresa, " & vbCrLf &_
			"       dlpr_email_empresa,dlpr_web_empresa,dlpr_tobservacion,dlpr_regi_particular,dlpr_ciud_particular " & vbCrLf &_
			" from alumni_direccion_laboral_profesionales  " & vbCrLf &_     
			" where cast(dlpr_ncorr as varchar)='"&dlpr_ncorr&"' " 


'response.Write("<pre>"&consulta&"</pre>")
f_datos_laborales.Consultar consulta

if f_datos_laborales.nroFilas = "0" then
	f_datos_laborales.Consultar "select ''"
end if
f_datos_laborales.Siguiente


lenguetas_egresados = Array(Array("Editar datos personales", "editar_datos_personales.asp?pers_ncorr="&v_pers_ncorr&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&letra="&letra&"&recortar="&recortar), Array("Editar datos Laborales", "editar_datos_laborales.asp?pers_ncorr="&v_pers_ncorr&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&letra="&letra&"&recortar="&recortar))


'--------Debemos ver si el alumno tiene estado de egreso o titulación en la universidad---------------------------------
consulta_egreso= "select count(*) from alumnos ba (nolock), ofertas_academicas ca, especialidades da "& vbCrLf &_
				 "                where cast(ba.pers_ncorr as varchar)='"&v_pers_ncorr&"'  "& vbCrLf &_
			     "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
			     "                and da.carr_ccod = '"&carr_ccod&"' and ba.emat_ccod in (4,8)"
'response.Write("<pre>"&consulta_egreso&"</pre>")
existe_en_sistema = conexion.consultaUno(consulta_egreso)
'response.Write(existe_en_sistema)

if existe_en_sistema > "0" then

	c_anio_egreso = "select max(anos_ccod) from alumnos ba (nolock), ofertas_academicas ca, especialidades da,periodos_academicos ea "& vbCrLf &_
				 "                where cast(ba.pers_ncorr as varchar)='"&v_pers_ncorr&"'  "& vbCrLf &_
			     "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod and ca.peri_ccod=ea.peri_ccod "& vbCrLf &_
			     "                and da.carr_ccod = '"&carr_ccod&"' and ba.emat_ccod in (4,8)"
    anio_egreso = conexion.consultaUno(c_anio_egreso)
		
	c_anio_promocion = "select protic.ano_ingreso_carrera ('"&v_pers_ncorr&"','"&carr_ccod&"')"
	anio_promocion =conexion.consultaUno(c_anio_promocion)
	
	c_egreso = "select count(*) from alumnos ba (nolock), ofertas_academicas ca, especialidades da,periodos_academicos ea "& vbCrLf &_
				 "                where cast(ba.pers_ncorr as varchar)='"&v_pers_ncorr&"'  "& vbCrLf &_
			     "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod and ca.peri_ccod=ea.peri_ccod "& vbCrLf &_
			     "                and da.carr_ccod = '"&carr_ccod&"' and ba.emat_ccod in (4)"
    con_egreso = conexion.consultaUno(c_egreso)
	
	c_titulado = "select count(*) from alumnos ba (nolock), ofertas_academicas ca, especialidades da,periodos_academicos ea "& vbCrLf &_
				 "                where cast(ba.pers_ncorr as varchar)='"&v_pers_ncorr&"'  "& vbCrLf &_
			     "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod and ca.peri_ccod=ea.peri_ccod "& vbCrLf &_
			     "                and da.carr_ccod = '"&carr_ccod&"' and ba.emat_ccod in (8)"
    con_titulo = conexion.consultaUno(c_titulado)
	
	if con_egreso <>"0" then
	   condicion = "Egresado"
	   if con_titulo <> "0" then
	     condicion = condicion & " y Titulado"
	   end if 
	elseif con_egreso = "0" and con_titulo <> "0" then
	      condicion = "Titulado"   
	end if
else
    c_anio_egreso = "select top 1 año from egresados_upa2 where pers_nrut = (select pers_nrut from alumni_personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"') and carr_ccod='"&carr_ccod&"'"
    c_anio_promocion = "select top 1 promocion from egresados_upa2 where pers_nrut = (select pers_nrut from alumni_personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"') and carr_ccod='"&carr_ccod&"'"
	
	anio_egreso = conexion.consultaUno(c_anio_egreso)
	anio_promocion = conexion.consultaUno(c_anio_promocion)
	condicion = "Egresado"
	
end if 

if letra= "I" then 
	entidad = "Instituto"
elseif letra="U" then
	entidad = "Universidad"
end if	

'--------------------------debemos generar la lista de las empresas en las que trabaja el alumno egresado
set f_empresas = new CFormulario
f_empresas.Carga_Parametros "m_profesionales_upa.xml", "listado_empresas"
f_empresas.Inicializar conexion

'  sql = "SELECT a.dlpr_ncorr,'<a href=""javascript:editar('+cast(a.dlpr_ncorr as varchar)+')""> Ver/Editar </a>' as ver, "& vbcrlf & _		
'		" pais_tdesc,case a.ciud_ccod when null then dlpr_regi_particular + ' - ' + dlpr_ciud_particular "& vbcrlf & _
'		" else c.ciud_tdesc + ' - ' + c.ciud_tcomuna end as ciudad, "& vbcrlf & _
'		" dlpr_nombre_empresa as empresa,dlpr_cargo_empresa as cargo  "& vbcrlf & _
'		" from alumni_direccion_laboral_profesionales a, paises b, ciudades c "& vbcrlf & _
'		" where a.pais_ccod=b.pais_ccod "& vbcrlf & _
'		" and a.ciud_ccod *= c.ciud_ccod "& vbcrlf & _
'		" and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' "

  sql = "SELECT a.dlpr_ncorr,'<a href=""javascript:editar('+cast(a.dlpr_ncorr as varchar)+')""> Ver/Editar </a>' as ver, "& vbcrlf & _		
		" pais_tdesc,case a.ciud_ccod when null then dlpr_regi_particular + ' - ' + dlpr_ciud_particular "& vbcrlf & _
		" else c.ciud_tdesc + ' - ' + c.ciud_tcomuna end as ciudad, "& vbcrlf & _
		" dlpr_nombre_empresa as empresa,dlpr_cargo_empresa as cargo  "& vbcrlf & _
		" from alumni_direccion_laboral_profesionales a INNER JOIN paises b "& vbcrlf & _
		" ON a.pais_ccod = b.pais_ccod "& vbcrlf & _
		" LEFT OUTER JOIN ciudades c "& vbcrlf & _
		" ON a.ciud_ccod = c.ciud_ccod "& vbcrlf & _
		" WHERE cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' "

        if v_pers_ncorr <> "" then
		 f_empresas.Consultar sql		 
	    else
		 f_empresas.consultar "select '' from sexos where 1 = 2"
	    end if
		
modificado_por = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno from alumni_personas a, alumni_direccion_laboral_profesionales b where cast(a.pers_nrut as varchar) = b.audi_tusuario and cast(dlpr_ncorr as varchar)='"&dlpr_ncorr&"'")
el_dia = conexion.consultaUno("select protic.trunc(audi_fmodificacion) from  alumni_direccion_laboral_profesionales where cast(dlpr_ncorr as varchar)='"&dlpr_ncorr&"'")
hora = conexion.consultaUno("select datepart(hour,audi_fmodificacion) from  alumni_direccion_laboral_profesionales where cast(dlpr_ncorr as varchar)='"&dlpr_ncorr&"'")
minutos = conexion.consultaUno("select datepart(minute,audi_fmodificacion) from  alumni_direccion_laboral_profesionales where cast(dlpr_ncorr as varchar)='"&dlpr_ncorr&"'")
	
if minutos < "0" then
	minutos = "0" & minutos
end if

mensaje = "La última modificación que presentan estos datos fue realizada por "&modificado_por&" el día "&el_dia&" a las "&hora&":"&minutos&" hrs"

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

<script language="JavaScript">
function cambiar_ciudad(valor)
{var formulario;
     formulario = document.edicion;
	 //alert("valor "+valor);
	 if ((valor != "") &&(valor != "1"))
	 {
	 	formulario.elements["dp[0][dlpr_regi_particular]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].disabled = false;
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tcalle]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tnro]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tblock]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tpoblacion]"].disabled = true;
		formulario.elements["dp[0][dlpr_regi_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][ciud_ccod]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tcalle]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tnro]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tpoblacion]"].id = "TO-S";
	 }
	 else
	 {
	 	formulario.elements["dp[0][dlpr_regi_particular]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].disabled = true;
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tcalle]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tnro]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tblock]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tpoblacion]"].disabled = false;
		formulario.elements["dp[0][dlpr_regi_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][ciud_ccod]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tcalle]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tnro]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tpoblacion]"].id = "TO-S";
	 }
}

function editar(valor){
    var carr;
	var jorn;
	var pers;
	
	var url;
	carr='<%=carr_ccod%>';
	jorn=<%=jorn_ccod%>;
	pers=<%=v_pers_ncorr%>;
	letra='<%=letra%>';

	url="editar_datos_laborales.asp?dlpr_ncorr="+valor+"&carr_ccod="+carr+"&jorn_ccod="+jorn+"&pers_ncorr="+pers+"&letra="+letra;
	//alert("destino "+ url);
	location.href =url;
}


</script>
<style type="text/css">
<!--
.style3 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <%if recortar <> "S" then%>
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <%end if%>
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_egresados, 2				  
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "2.- ANTECEDENTES LABORALES DEL ALUMNO" %>
              <br>
              </div>
              <form name="edicion">
			   <input type="hidden" name="dp[0][pers_ncorr]" value="<%=v_pers_ncorr%>">
			   <input type="hidden" name="dp[0][dlpr_ncorr]" value="<%=dlpr_ncorr%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                   <tr>
                    <td width="15%" align="left"><strong>Carrera</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><font color="#993300"><strong><%=carrera%></strong></font></td>
                  </tr>
				   <tr>
                    <td width="15%" align="left"><strong>Horario</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><font color="#993300"><strong><%=jornada%></strong></font></td>
					<td width="15%" align="right"><strong>Entidad</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><font color="#993300"><strong><%=entidad%></strong></font></td>
                  </tr>
				   <tr>
                    <td width="15%" align="left"><strong>Promoción</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><font color="#993300"><strong><%=anio_promocion%></strong></font></td>
					<td width="15%" align="right"><strong>Año Egreso</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><font color="#993300"><strong><%=anio_egreso%></strong></font></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Condición</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><font color="#993300"><strong><%=condicion%></strong></font></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>R.U.T.</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><font color="#993300"><strong><%=rut%></strong></font></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Nombre</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><font color="#993300"><strong><%=nombre_alumno%></strong></font></td>
                  </tr>
				  <tr>
                    <td colspan="6"><hr></td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left"><strong>Listado de Antecedentes Laborales, seleccione el que desea Ver o modificar.</strong></td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left">&nbsp;</td>
                  </tr>
				  <tr>
                    <td colspan="6" align="center"><% f_empresas.dibujatabla  %></td>
                  </tr>
				  <tr>
                    <td colspan="6"><hr></td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left">&nbsp;</td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left"><% if dlpr_ncorr <> "" then 
						                                 pagina.DibujarSubtitulo "Modificar antecedente Laboral"
													else
													     pagina.DibujarSubtitulo "Agregar nuevo antecedente Laboral"
												    end if	 %></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Empresa</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_nombre_empresa")%></strong></td>
					<td width="15%" align="right"><strong>Rubro</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_rubro_empresa")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Cargo</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_cargo_empresa")%></strong></td>
					<td width="15%" align="right"><strong>Depto.</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_depto_empresa")%></strong></td>
                  </tr>
				   <tr>
                    <td width="15%" align="left"><strong>Email</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_email_empresa")%></strong></td>
					<td width="15%" align="right"><strong>Web</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_web_empresa")%></strong></td>
                  </tr>
				  <tr>
                    <td colspan="6">&nbsp;</td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>País</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><strong><%f_datos_laborales.dibujaCampo("pais_ccod")%></strong></td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left"><strong>Ubicación en el Extrangero</strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Ciudad</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_ciud_particular")%></strong></td>
					<td width="15%" align="right"><strong>Ubicación</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_regi_particular")%></strong></td>
                  </tr>
				   <tr>
                    <td colspan="6" align="left"><strong>Ubicación dentro de Chile</strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Ciudad</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_laborales.dibujaCampo("ciud_ccod")%></strong></td>
				  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Calle</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_tcalle")%></strong></td>
					<td width="15%" align="right"><strong>N°</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_tnro")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Departamento</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_tblock")%></strong></td>
					<td width="15%" align="right"><strong>Condominio</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_tpoblacion")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Tel&eacute;fono</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_laborales.dibujaCampo("dlpr_tfono")%></strong></td>
					<td width="15%" align="right"><strong>Fax</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_laborales.dibujaCampo("dire_tfax")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Cód. Postal</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_laborales.dibujaCampo("dlpr_cpostal")%></strong></td>
				  </tr>
				  <tr>
                    <td colspan="6">&nbsp;</td>
				  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Observaciones</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_laborales.dibujaCampo("dlpr_tobservacion")%></strong></td>
				  </tr>
				  <tr>
                    <td colspan="6">&nbsp;</td>
				  </tr>
				  <%if dlpr_ncorr <> "" then%>
				  <tr>
                    <td colspan="6"><font color="#993300"><strong><%=mensaje%></strong></font></td>
				  </tr>
				  <%end if%>
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
				  f_botonera.agregabotonparam "anterior", "url", "editar_datos_personales.asp?pers_ncorr="&v_pers_ncorr&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&letra="&letra&"&recortar="&recortar 
				  f_botonera.DibujaBoton "anterior"
				  %>
				  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
                  <td><div align="center">
					<%if recortar <> "S" then
					  f_botonera.DibujaBoton("salir")
					  end if%>
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
</body>
</html>
