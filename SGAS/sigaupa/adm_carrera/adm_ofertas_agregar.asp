<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "adm_ofertas_agregar.xml", "btn_adm_ofertas_agregar"

'-----------------------------------------------------------------------------------------------------------------
sede_ccod = Request.QueryString("sede_ccod")
carr_ccod = Request.QueryString("carr_ccod")
peri_ccod = Request.QueryString("peri_ccod")
if Request.QueryString("espe_ccod")="-1" then
	espe_ccod = 1
else
	espe_ccod = Request.QueryString("espe_ccod")
end if

'-----------------------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

set t_ofertas_academicas = new CFormulario
t_ofertas_academicas.Carga_Parametros "adm_ofertas_agregar.xml", "t_ofertas_academicas"
t_ofertas_academicas.Inicializar conexion


ofer_ncorr = conexion.ConsultaUno("exec obtenersecuencia 'ofertas_academicas'")
aran_ncorr = conexion.ConsultaUno("exec obtenersecuencia 'aranceles'")


consulta = "SELECT " & sede_ccod & " AS sede_ccod, " &_
           "       " & peri_ccod & " AS peri_ccod, " &_
		   "       '" & carr_ccod & "' AS carr_ccod, " &_
		   "       '" & espe_ccod & "' AS espe_ccod, " &_
		   "       " & sede_ccod & " AS c_sede_ccod, " &_
		   "       " & peri_ccod & " AS c_peri_ccod, " &_
		   "       '" & espe_ccod & "' AS c_espe_ccod, " &_
		   "       " & ofer_ncorr & " AS ofer_ncorr, " &_
		   "       " & aran_ncorr & " AS aran_ncorr, " &_
		   "       0 AS ofer_nvacantes, " &_
		   "       0 AS ofer_nquorum, " &_
		   "       0 AS ofer_bpublica, " &_
		   "       0 AS ofer_bpaga_examen, "&_
		   "       0 AS ofer_bactiva "

'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
		   
t_ofertas_academicas.Consultar consulta
t_ofertas_academicas.Siguiente


		   
consulta = "SELECT case isnull(a.aran_nano_ingreso,0) when 0 then '1' else '0' end AS c_tipo_alumnos, " & vbCrLf &_
			"       case isnull(a.aran_nano_ingreso,0) when 0 then 'ALUMNOS ANTIGUOS' else 'ALUMNOS NUEVOS' end AS tipo_alumnos, " & vbCrLf &_
			"       " & ofer_ncorr & " AS t_ofer_ncorr, " & vbCrLf &_
			"       a.* " & vbCrLf &_
			"FROM aranceles a " & vbCrLf &_
			"WHERE sede_ccod = " & sede_ccod & "" & vbCrLf &_
			"      AND espe_ccod = '" & espe_ccod & "'" & vbCrLf &_
			"      AND carr_ccod = '" & carr_ccod & " '" & vbCrLf &_
			"      AND peri_ccod = " & peri_ccod & "" & vbCrLf &_
			"      AND ofer_ncorr is null " & vbCrLf &_
			"ORDER BY tipo_alumnos DESC		   "
			
conexion.Ejecuta consulta
set rec_aranceles_encontrados = conexion.ObtenerRS
if rec_aranceles_encontrados.RecordCount > 0 then
	encontrados = true
end if
rec_aranceles_encontrados.Close
set rec_aranceles_encontrados = Nothing

conexion.Ejecuta consulta
set rec_aranceles_encontrados = conexion.ObtenerRS



	
consulta ="SELECT anos_ccod, " & vbCrLf &_
			"       cast(anos_ccod as varchar) + '-' + case plec_ccod when 1 then 'P' when 2 then 'S' else '' end AS aran_tdesc " & vbCrLf &_
			"FROM periodos_academicos " & vbCrLf &_
			"WHERE peri_ccod = " & peri_ccod
			
conexion.Ejecuta consulta
set rec = conexion.ObtenerRS

if rec.RecordCount < 0 then
	rec.MoveFirst
	anos_ccod = rec("anos_ccod")
	aran_tdesc = rec("aran_tdesc")
end if

set t_aranceles = new CFormulario
t_aranceles.Carga_Parametros "adm_ofertas_agregar.xml", "t_aranceles"
t_aranceles.Inicializar conexion

consulta = "SELECT  " & aran_ncorr & " AS aran_ncorr, " & vbCrLf &_
		   "	   1 AS mone_ccod, " & vbCrLf &_
		   "	   " & ofer_ncorr & " AS ofer_ncorr, " & vbCrLf &_
		   "	   '" & aran_tdesc & " ' AS aran_tdesc, " & vbCrLf &_
		   "       0 AS aran_mmatricula, " & vbCrLf &_
		   "	   0 AS aran_mcolegiatura, " & vbCrLf &_
		   "	   '" & anos_ccod & "' as aran_nano_ingreso, " & vbCrLf &_
		   "	   " & sede_ccod & " AS sede_ccod, " & vbCrLf &_
		   "	   '" & espe_ccod & "' AS espe_ccod, " & vbCrLf &_
		   "	   '" & carr_ccod & "' AS carr_ccod, " & vbCrLf &_
		   "	   " & peri_ccod & " AS peri_ccod, " & vbCrLf &_
		   "	   null AS jorn_ccod " & vbCrLf

'response.Write("<pre>"&consulta&"</pre>")
'response.End()		   
t_aranceles.Consultar consulta

%>


<html>
<head>
<title>Administrador de Ofertas Acad&eacute;micas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--

function Salir()
{
	window.close();
}

function ValidaFormulario(formulario)
{
	
	
	if (formulario.elements["ofertas[0][jorn_ccod]"].value == "") {
		alert('Seleccione jornada.');
		formulario.elements["ofertas[0][jorn_ccod]"].focus();
		return false;
	}
	if (formulario.elements["ofertas[0][post_bnuevo]"].value == "") {
		alert('Seleccione tipo de alumno.');
		formulario.elements["ofertas[0][post_bnuevo]"].focus();
		return false;
	}	
	if (!isInteger(formulario.elements["ofertas[0][ofer_nvacantes]"].value)) {
		alert('Vacantes debe ser un número.');
		formulario.elements["ofertas[0][ofer_nvacantes]"].focus();
		formulario.elements["ofertas[0][ofer_nvacantes]"].select();		
		return false;
	}
	
	if (eval(formulario.elements["ofertas[0][ofer_nvacantes]"].value) <= 0) {
		alert('Vacantes debe ser mayor que 0.');
		formulario.elements["ofertas[0][ofer_nvacantes]"].focus();
		formulario.elements["ofertas[0][ofer_nvacantes]"].select();		
		return false;		
	}
	
	if (!isInteger(formulario.elements["ofertas[0][ofer_nquorum]"].value)) {
		alert('Quórum debe ser un número.');
		formulario.elements["ofertas[0][ofer_nquorum]"].focus();
		formulario.elements["ofertas[0][ofer_nquorum]"].select();		
		return false;
	}
	
	if (eval(formulario.elements["ofertas[0][ofer_nquorum]"].value) <= 0) {
		alert('Quórum debe ser mayor que 0.');
		formulario.elements["ofertas[0][ofer_nquorum]"].focus();
		formulario.elements["ofertas[0][ofer_nquorum]"].select();		
		return false;		
	}
	
	if (eval(formulario.elements["ofertas[0][ofer_nquorum]"].value) > eval(formulario.elements["ofertas[0][ofer_nvacantes]"].value)) {
		alert ('Quórum debe ser menor o igual que número de vacantes.');
		formulario.elements["ofertas[0][ofer_nquorum]"].focus();
		formulario.elements["ofertas[0][ofer_nquorum]"].select();		
		return false;		
	}
	if(!isInteger(formulario.elements["aranceles[0][aran_nano_ingreso]"].value))
	{
		alert('Ingrese Año.');
		formulario.elements["aranceles[0][aran_nano_ingreso]"].focus();
		return false;
	}
	
	/*nJornadas = formulario.elements["ofertas[0][jorn_ccod]"].length - 1;*/
	nJornadas  = 1;
	for (i = 0; i < nJornadas; i++) {
		elemento = "aranceles[" + i + "][aran_mmatricula]";
		if (!isInteger(formulario.elements[elemento].value)) {
			alert ('Arancel de matrícula debe ser un número.');
			formulario.elements[elemento].focus();
			formulario.elements[elemento].select();
			return false;
		}
		
		if (eval(formulario.elements[elemento].value) <= 0 ) {
			alert ('Arancel de matrícula debe ser mayor que 0.');
			formulario.elements[elemento].focus();
			formulario.elements[elemento].select();
			return false;
		}	
		
	}
	for (i = 0; i < nJornadas; i++) {
		elemento = "aranceles[" + i + "][aran_mcolegiatura]";
		if (!isInteger(formulario.elements[elemento].value)) {
			alert ('Arancel de colegiatura debe ser un número.');
			formulario.elements[elemento].focus();
			formulario.elements[elemento].select();
			return false;
		}
		
		if (eval(formulario.elements[elemento].value) <= 0) {
			alert ('Arancel de colegiatura debe ser mayor que 0.');
			formulario.elements[elemento].focus();
			formulario.elements[elemento].select();
			return false;
		}
	}
		
	return true;
}
	
function Aceptar()
{
	formulario = document.formu;
	if (ValidaFormulario(formulario)) {	
		formulario.action = "adm_ofertas_insertar.asp";
		formulario.submit();		
	}
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
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
//-->
</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="714" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"><br> <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                      <td background="../imagenes/fondo1.gif"> 
                        <%pagina.DibujarLenguetas Array("Agregar Ofertas Académicas"), 1%>
                      </td>
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
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> 
                  <form action="" method="post" name="formu" id="formu" onSubmit="if (!ValidarBusqueda(this)) return false">
                    <br>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td>Sede: <b>
                          <% t_ofertas_academicas.DibujaCampo("c_sede_ccod")%>
                          </b> </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>Periodo:<b> 
                          <% t_ofertas_academicas.DibujaCampo("c_peri_ccod")%>
                          </b></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>Carrera:<b> 
                          <% t_ofertas_academicas.DibujaCampo("carr_ccod")%>
                          </b></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>Especialidad:<b> 
                          <% t_ofertas_academicas.DibujaCampo("c_espe_ccod")%>
                          </b></td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                    <b> 
                    <%
			  t_ofertas_academicas.DibujaCampo("ofer_ncorr")
			  t_ofertas_academicas.DibujaCampo("aran_ncorr")
			  t_ofertas_academicas.DibujaCampo("espe_ccod")
			  t_ofertas_academicas.DibujaCampo("sede_ccod")
			  t_ofertas_academicas.DibujaCampo("peri_ccod")
			  %>
                    </b><br>
                    <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" >
                      <tr> 
                        <td align="left"><table width="98%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="16%">Tipo de Alumno <b> </b></td>
                              <td width="39%">:<b> 
                                <% t_ofertas_academicas.DibujaCampo("post_bnuevo")%>
                                </b></td>
                              <td width="15%">Jornada</td>
                              <td width="30%">:<b> 
                                <% t_ofertas_academicas.DibujaCampo("jorn_ccod")%>
                                </b></td>
                            </tr>
                            <tr> 
                              <td>Vacantes</td>
                              <td>:<b> 
                                <% t_ofertas_academicas.DibujaCampo("ofer_nvacantes")%>
                                </b></td>
                              <td>Qu&oacute;rum<b> </b></td>
                              <td>:<b> 
                                <% t_ofertas_academicas.DibujaCampo("ofer_nquorum")%>
                                </b></td>
                            </tr>
                            <tr> 
                              <td>Rinde Test </td>
                              <td>: <%t_ofertas_academicas.DibujaCampo("ofer_bpaga_examen")%></td>
                              <td>Oferta P&uacute;blica (web)</td>
                              <td>: <%t_ofertas_academicas.DibujaCampo("ofer_bpublica")%></td>
                            </tr>
                            <tr>
                              <td>Oferta activa Periodo</td>
                              <td>: 
                                <%t_ofertas_academicas.DibujaCampo("ofer_bactiva")%>
                              </td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                          <div align="center"><b>
                            <%t_aranceles.DibujaTabla %>
                            </b> <br>
                          </div></td>
                      </tr>
                    </table>
                  </form>
                  <br> </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center">
                          <%botonera.DibujaBoton "aceptar"%>
                        </div></td>
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir" %>
                        </div></td>
                    </tr>
                  </table></td>
                <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr> 
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
            <br>
          </td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
