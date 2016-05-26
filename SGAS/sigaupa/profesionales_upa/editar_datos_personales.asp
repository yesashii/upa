<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

v_pers_ncorr = request.QueryString("pers_ncorr")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
letra = request.QueryString("letra")
recortar = request.QueryString("recortar")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Editar Datos Personales Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
'*************************************'
'**		CONTROL ESTADO DEFUNCION	**'
'*************************************'---------------------------
function chequearEDefun(estado, opcion)
	if estado = 0 then
		if opcion = 1 then
			chequearEDefun="checked"
		end if
		if opcion = 2 then
			chequearEDefun=""
		end if		
	end if
	if estado = 1 then
		if opcion = 1 then
			chequearEDefun=""
		end if
		if opcion = 2 then
			chequearEDefun="checked"
		end if		
	end if	
end function
query = "" & vbCrLf &_
"select case isnull(cast(pers_fdefuncion as integer), 0) " & vbCrLf &_
"         when 0 then 0                                  " & vbCrLf &_
"         else 1                                         " & vbCrLf &_
"       end                                              " & vbCrLf &_
"from   alumni_personas 								 " & vbCrLf &_
"where  pers_ncorr = '"&v_pers_ncorr&"' " 
estadoDefuncion = conexion.consultaUno(query)
'*************************************'---------------------------
'**		CONTROL ESTADO DEFUNCION	**'
'*************************************'
f_botonera.Carga_Parametros "m_profesionales_upa.xml", "botonera_datos_alumno"
'---------------------------------------------------------------------------------------------------
set f_datos_personales = new CFormulario
f_datos_personales.Carga_Parametros "m_profesionales_upa.xml", "datos_personales"
f_datos_personales.Inicializar conexion


carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
jornada = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")

consulta =  "" & vbCrLf &_
"select b.pers_nrut,                                                       				" & vbCrLf &_
"       b.pers_xdv,                                                        				" & vbCrLf &_
"       b.pais_ccod,                                                       				" & vbCrLf &_
"       b.pers_tape_paterno,                                               				" & vbCrLf &_
"       b.pers_tape_materno,                                               				" & vbCrLf &_
"       b.pers_tnombre,                                                    				" & vbCrLf &_
"       b.pers_ncorr,                                                      				" & vbCrLf &_
"       b.sexo_ccod,                                                       				" & vbCrLf &_
"       isnull(pers_temail, '')                    as pers_temail,         				" & vbCrLf &_
"       b.pers_tfono,                                                      				" & vbCrLf &_
"       b.pers_tcelular,                                                   				" & vbCrLf &_
"       b.pers_fnacimiento,                                                				" & vbCrLf &_
"       pers_tfax,                                                         				" & vbCrLf &_
"       b.eciv_ccod,                                                       				" & vbCrLf &_
"       c.dire_tcalle,                                                     				" & vbCrLf &_
"       c.dire_tnro,                                                       				" & vbCrLf &_
"       c.dire_tpoblacion,                                                 				" & vbCrLf &_
"       c.ciud_ccod,                                                       				" & vbCrLf &_
"       c.dire_tblock,                                                     				" & vbCrLf &_
"       regi_particular,                                                   				" & vbCrLf &_
"       ciud_particular,                                                   				" & vbCrLf &_
"       d.cod_postal,                                                      				" & vbCrLf &_
"       d.num_hijos,                                                       				" & vbCrLf &_
"       d.tsoc_ccod,                                                       				" & vbCrLf &_
"       convert(varchar, fecha_incorporacion, 103) as fecha_incorporacion, 				" & vbCrLf &_
"       convert(varchar, fecha_vencimiento, 103)   as fecha_vencimiento,   				" & vbCrLf &_
"       isnull(convert(varchar, pers_fdefuncion, 103), '')   as pers_fdefuncion,       	" & vbCrLf &_
"       observaciones                                                      				" & vbCrLf &_
"from   alumni_personas b (nolock)                                         				" & vbCrLf &_
"       left outer join alumni_direcciones c                               				" & vbCrLf &_
"                    on b.pers_ncorr = c.pers_ncorr                        				" & vbCrLf &_
"                       and 2 = c.tdir_ccod                                				" & vbCrLf &_
"       left outer join alumni_datos_adicionales_egresados d               				" & vbCrLf &_
"                    on b.pers_ncorr = d.pers_ncorr                        				" & vbCrLf &_
"where  cast(b.pers_ncorr as varchar) = '" & v_pers_ncorr & "'             				" 

'response.Write("<pre>"&consulta&"</pre>")
f_datos_personales.Consultar consulta
f_datos_personales.agregaCampoParam "eciv_ccod", "destino", "(select eciv_ccod,eciv_tdesc from estados_civiles where eciv_ccod <> 0 )a"
f_datos_personales.Siguiente


pais_temporal = f_datos_personales.obtenerValor("pais_ccod")
pers_fdefuncion = f_datos_personales.obtenerValor("pers_fdefuncion")
'response.Write("pers_fdefuncion= '"&pers_fdefuncion&"'")
'response.Write(pais_temporal)
'------------------en el casod e ser un pais distinto a chile entonces debemos habilitar los campos especiales y deshabilar los otros.
if pais_temporal <> "1" and pais_temporal <> "" then
 f_datos_personales.agregaCampoParam "regi_particular","deshabilitado","false"
 f_datos_personales.agregaCampoParam "ciud_particular","deshabilitado","false"
 f_datos_personales.agregaCampoParam "ciud_ccod","deshabilitado","true"
 f_datos_personales.agregaCampoParam "dire_tcalle","deshabilitado","true"
 f_datos_personales.agregaCampoParam "dire_tnro","deshabilitado","true"
 f_datos_personales.agregaCampoParam "dire_tblock","deshabilitado","true"
 f_datos_personales.agregaCampoParam "dire_tpoblacion","deshabilitado","true"
 f_datos_personales.agregaCampoParam "regi_particular", "id" , "TO-N"
 f_datos_personales.agregaCampoParam "ciud_particular", "id" , "TO-N"
 f_datos_personales.agregaCampoParam "ciud_ccod", "id" , "TO-S"
 f_datos_personales.agregaCampoParam "dire_tcalle" , "id", "TO-S"
 f_datos_personales.agregaCampoParam "dire_tnro" , "id" , "TO-S"
 f_datos_personales.agregaCampoParam "dire_tblock" ,"id" , "TO-S"
 f_datos_personales.agregaCampoParam "dire_tpoblacion","id", "TO-S"
else
 f_datos_personales.agregaCampoParam "regi_particular","deshabilitado","true"
 f_datos_personales.agregaCampoParam "ciud_particular","deshabilitado","true"
 f_datos_personales.agregaCampoParam "ciud_ccod","deshabilitado","false"
 f_datos_personales.agregaCampoParam "dire_tcalle","deshabilitado","false"
 f_datos_personales.agregaCampoParam "dire_tnro","deshabilitado","false"
 f_datos_personales.agregaCampoParam "dire_tblock","deshabilitado","false"
 f_datos_personales.agregaCampoParam "dire_tpoblacion","deshabilitado","false"
 f_datos_personales.agregaCampoParam "regi_particular", "id" , "TO-S"
 f_datos_personales.agregaCampoParam "ciud_particular", "id" , "TO-S"
 f_datos_personales.agregaCampoParam "ciud_ccod", "id" , "TO-N"
 f_datos_personales.agregaCampoParam "dire_tcalle" , "id", "TO-N"
 f_datos_personales.agregaCampoParam "dire_tnro" , "id" , "TO-N"
 f_datos_personales.agregaCampoParam "dire_tblock" ,"id" , "TO-S"
 f_datos_personales.agregaCampoParam "dire_tpoblacion","id", "TO-S" 
end if




lenguetas_egresados = Array(Array("Editar datos personales", "editar_datos_personales.asp?pers_ncorr="&v_pers_ncorr&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&letra="&letra&"&recortar="&recortar), Array("Editar datos Laborales", "editar_datos_laborales.asp?pers_ncorr="&v_pers_ncorr&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&letra="&letra&"&recortar="&recortar))


pais=f_datos_personales.Obtenervalor("pais_ccod")

'--------Debemos ver si el alumno tiene estado de egreso o titulación en la universidad---------------------------------
consulta_egreso= "select count(*) from alumnos ba (nolock), ofertas_academicas ca, especialidades da "& vbCrLf &_
				 "                where cast(ba.pers_ncorr as varchar)='"&v_pers_ncorr&"'  "& vbCrLf &_
			     "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
			     "                and da.carr_ccod = '"&carr_ccod&"' and ba.emat_ccod in (4,8)"

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
    c_anio_egreso = "select top 1 año from egresados_upa2 where pers_nrut = (select pers_nrut from alumni_personas (nolock) where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"') and carr_ccod='"&carr_ccod&"'"
    c_anio_promocion = "select top 1 promocion from egresados_upa2 where pers_nrut = (select pers_nrut from alumni_personas (nolock) where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"') and carr_ccod='"&carr_ccod&"'"
	
	anio_egreso = conexion.consultaUno(c_anio_egreso)
	anio_promocion = conexion.consultaUno(c_anio_promocion)
	condicion = "Egresado"
end if 

if letra= "I" then 
	entidad = "Instituto"
elseif letra="U" then
	entidad = "Universidad"
end if	

modificado_por = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno from alumni_personas a (nolock), alumni_datos_adicionales_egresados b where cast(a.pers_nrut as varchar) = b.audi_tusuario and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'")

'response.End()
el_dia = conexion.consultaUno("select protic.trunc(audi_fmodificacion) from alumni_datos_adicionales_egresados where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
hora = conexion.consultaUno("select datepart(hour,audi_fmodificacion) from alumni_datos_adicionales_egresados where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
minutos = conexion.consultaUno("select datepart(minute,audi_fmodificacion) from alumni_datos_adicionales_egresados where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")	
if minutos < "0" then
	minutos = "0" & minutos
end if

mensaje = "La última modificación que presentan estos datos fue realizada por "&modificado_por&" el día "&el_dia&" a las "&hora&":"&minutos&" hrs"


'--------------------------------Buscamos la información base de direcciones de egresados que tenemos de orígen.
direccion_antigua = conexion.consultaUno("select 'Chile' + ' : ' + direccion_nacional + ' (' + ciudad_nacional + ') ' from tabla_respaldo_direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")
telefono_antiguo = conexion.consultaUno("select case pers_tfono when null then '' when '' then '' else '<strong>Teléfono : </strong>' + pers_tfono end from tabla_respaldo_direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")
celular_antiguo = conexion.consultaUno("select  case pers_tcelular when null then '' when '' then '' else '<strong>Celular : </strong>' + pers_tcelular end from tabla_respaldo_direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")
email_antiguo = conexion.consultaUno("select  case pers_temail when null then '' when '' then '' else '<strong>Email : </strong>' + pers_temail end  from tabla_respaldo_direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")
contacto_antiguo = telefono_antiguo & "   " & celular_antiguo & "   " & email_antiguo
direccion_antigua_exterior = conexion.consultaUno("select b.pais_tdesc + ' : ' + regi_particular + ' (' + ciud_particular + ') ' from tabla_respaldo_direcciones a,paises b where  a.pais_ccod=b.pais_ccod and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")

'response.Write("select case pers_tfono when null then '' else '<strong>Teléfono : </strong>' + pers_tfono end + '  '  + case pers_tcelular when null then '' else '<strong>Celular : </strong>' + pers_tcelular end + '  ' + case pers_temail when null then '' else '<strong>Email : </strong>' + pers_temail end  from tabla_respaldo_direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' ")	
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
function cambiar_ciudad(valor)
{
	 var formulario;
     formulario = document.edicion;
	 //alert("valor "+valor);
	 formulario.elements["dp[0][regi_particular]"].value = "";//agregado para resetear campos 
	 formulario.elements["dp[0][ciud_particular]"].value = "";//agregado para resetear campos 
	 if ((valor != "") &&(valor != "1"))
	 {
		formulario.elements["dp[0][regi_particular]"].disabled = false;
	 	formulario.elements["dp[0][ciud_particular]"].disabled = false;
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = true;
	 	formulario.elements["dp[0][dire_tcalle]"].disabled = true;
	 	formulario.elements["dp[0][dire_tnro]"].disabled = true;
	 	formulario.elements["dp[0][dire_tblock]"].disabled = true;
	 	formulario.elements["dp[0][dire_tpoblacion]"].disabled = true;
		formulario.elements["dp[0][regi_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][ciud_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][ciud_ccod]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tcalle]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tnro]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tpoblacion]"].id = "TO-S";
	 }
	 else
	 {
	 	formulario.elements["dp[0][regi_particular]"].disabled = true;
	 	formulario.elements["dp[0][ciud_particular]"].disabled = true;
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = false;
	 	formulario.elements["dp[0][dire_tcalle]"].disabled = false;
	 	formulario.elements["dp[0][dire_tnro]"].disabled = false;
	 	formulario.elements["dp[0][dire_tblock]"].disabled = false;
	 	formulario.elements["dp[0][dire_tpoblacion]"].disabled = false;
		formulario.elements["dp[0][regi_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][ciud_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][ciud_ccod]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tcalle]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tnro]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tpoblacion]"].id = "TO-S";
	 }
}

function mostrar_ano_carrera(valor)
{ var ano = valor.split('/');

  document.edicion.elements["ano_ingr_carrera"].value = ano[1];
  document.edicion.elements["carrera_beca"].value = ano[0];
  
}
function insertarFechaDefuncion()
{
	
	var f = new Date();
	var dia = f.getDate();
	if(dia < 10){dia = '0'+dia}
	var mes = f.getMonth() +1;
	if(mes < 10){mes = '0'+mes}
	var anio = f.getFullYear();
	var fecha = dia+ "/" + mes + "/" + anio;
	var checkeo_difunto = document.getElementById('checkDifunto').checked;
	var cajonDifunto =  document.getElementById('fdefuncion');
	if(checkeo_difunto)
	{
		cajonDifunto.value=fecha;
		cajonDifunto.disabled=false;
	
	}else{
		cajonDifunto.disabled=true;
		cajonDifunto.value="";
	}
}
function enviarFormulario2()
{
	edicion.action="editar_datos_personales_proc.asp";
	edicion.method="POST";
	edicion.submit();

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
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" >
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <%if recortar <> "S" then %>
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <%end if%>
  <tr>
    <td bgcolor="#EAEAEA">
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
            <td><%pagina.DibujarLenguetas lenguetas_egresados, 1%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "1.- ANTECEDENTES DEL ALUMNO" %>
              <br>
              </div>
              <form name="edicion">
			   <input type="hidden" name="dp[0][pers_ncorr]" value="<%=v_pers_ncorr%>">
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
                    <td colspan="6"><hr></td>
				  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>R.U.T.</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><font color="#993300"><strong><%f_datos_personales.dibujaCampo("pers_nrut")%>-<%f_datos_personales.dibujaCampo("pers_xdv")%></strong></font></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Ap. Paterno</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tape_paterno")%></strong></td>
					<td width="15%" align="right"><strong>Ap. Materno</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tape_materno")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Nombres</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tnombre")%></strong></td>
					<td width="15%" align="right"><strong>Fecha Nacimiento</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_fnacimiento")%></strong>
					                              <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                                  </a></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Sexo</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("sexo_ccod")%></strong></td>
					<td width="15%" align="right"><strong>Est.Civil</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("eciv_ccod")%></strong></td>
                  </tr>
				  <tr>
                    <td colspan="6"><hr></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>País</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left" colspan="4"><strong><%f_datos_personales.dibujaCampo("pais_ccod")%></strong></td>
                  </tr>
				  <tr>
                    <td colspan="6" align="left"><strong>Ubicación en el Extrangero</strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Ciudad</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("ciud_particular")%></strong></td>
					<td width="15%" align="right"><strong>Dirección</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("regi_particular")%></strong></td>
                  </tr>
				   <tr>
                    <td colspan="6" align="left"><strong>Ubicación dentro de Chile</strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Ciudad</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_personales.dibujaCampo("ciud_ccod")%></strong></td>
				  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Calle</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("dire_tcalle")%></strong></td>
					<td width="15%" align="right"><strong>N°</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("dire_tnro")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Departamento</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("dire_tblock")%></strong></td>
					<td width="15%" align="right"><strong>Condominio</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("dire_tpoblacion")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Tel&eacute;fono</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tfono")%></strong></td>
					<td width="15%" align="right"><strong>Celular</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tcelular")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Fax</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_tfax")%></strong></td>
					<td width="15%" align="right"><strong>Email</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("pers_temail")%></strong></td>
                  </tr>
				  <tr>
                    <td colspan="6"><hr></td>
				  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Cód. Postal</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("cod_postal")%></strong></td>
					<td width="15%" align="right"><strong>Num. Hijos</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("num_hijos")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Tipo Socio</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_personales.dibujaCampo("tsoc_ccod")%></strong></td>
			      </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Fecha Incorporación</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="33%" align="left"><strong><%f_datos_personales.dibujaCampo("fecha_incorporacion")%></strong></td>
					<td width="15%" align="right"><strong>Fecha Vencimiento</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td width="35%" align="left"><strong><%f_datos_personales.dibujaCampo("fecha_vencimiento")%></strong></td>
                  </tr>
				  <tr>
                    <td width="15%" align="left"><strong>Observaciones</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><strong><%f_datos_personales.dibujaCampo("observaciones")%></strong></td>
				  </tr>
                
				  <tr>
                    <td colspan="6">&nbsp;</td>
				  </tr>
                  <tr>
					<td width="15%" align="right"><strong>Difunto</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
                    <%if pers_fdefuncion = "" then%>
					<td width="35%" align="left"><input type="checkbox" name="checkDifunto" onclick='insertarFechaDefuncion();' ></td>                  
                    <%else%>
                    <td width="35%" align="left"><input type="checkbox" name="checkDifunto" onclick='insertarFechaDefuncion();' checked></td>
                    <%end if%>
                    <td width="15%" align="left">&nbsp;</td>
					<td width="2%" align="center">&nbsp;</td>
					<td width="33%" align="left">&nbsp;</td>
                  </tr> 
				  <tr>
					<td width="15%" align="right"><strong>Fecha de defunción</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
                    <%if pers_fdefuncion="" then%>
					<td width="35%" align="left"><input type="text" disabled name="fdefuncion" id="fdefuncion" value=""/> </td>                  
                    <%else%>
                    <td width="35%" align="left"><input type="text" name="fdefuncion" id="fdefuncion" value="<%response.write(pers_fdefuncion)%>"/> </td>
                    <%end if%>						                  
                    <td width="15%" align="left">&nbsp;</td>
					<td width="2%" align="center">&nbsp;</td>
					<td width="33%" align="left">&nbsp;</td>
                  </tr> 				  
                  <tr>
                    <td colspan="6">&nbsp;</td>
				  </tr>
                  
				  <%if v_pers_ncorr <> "" then%>
				  <tr>
                    <td colspan="6"><font color="#993300"><strong><%=mensaje%></strong></font></td>
				  </tr>
				  <%end if%>
				   <tr>
                    <td colspan="6"><hr></td>
				  </tr>
				  <%if direccion_antigua <> "" then%>
				  <tr>
                    <td with="15%"><font color="#993300"><strong>Dirección Nacional</strong></font></td>
					<td with="2%"><font color="#993300"><strong>:</strong></font></td>
					<td colspan="4"><%=direccion_antigua%></td>
				  </tr>
				  <%end if%>
				  <%if contacto_antiguo <> "" then%>
				  <tr>
					<td with="15%"><font color="#993300"><strong>Datos Contacto</strong></font></td>
					<td with="2%"><font color="#993300"><strong>:</strong></font></td>
					<td colspan="4"><%=contacto_antiguo%></td>
				  </tr>
				  <%end if%>
				  <%if direccion_antigua_exterior <> "" then %>
				  <tr>
					<td with="15%"><font color="#993300"><strong>Dirección Extranjero</strong></font></td>
					<td with="2%"><font color="#993300"><strong>:</strong></font></td>
					<td colspan="4"><%=direccion_antigua_exterior%></td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td colspan="6">&nbsp;</td>
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
                  <td><div align="center"><%if recortar <> "S" then
											  f_botonera.agregabotonparam "anterior", "url", "m_profesionales_upa.asp" 
											  f_botonera.DibujaBoton "anterior"
											end if
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
