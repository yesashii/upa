<!--construido 02/06/2015 V1.0 -->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "cambio_oferta_academica2.xml", "btn_adm_ofertas"

'-----------------------------------------------------------------------------------------------------------------
sede_ccod = Request.QueryString("sede_ccod")
carr_ccod = Request.QueryString("carr_ccod")
peri_ccod = Request.QueryString("peri_ccod")
espe_ccod = Request.QueryString("espe_ccod")
post_ncorr = Request.QueryString("post_ncorr")
POST_BNUEVO = Request.QueryString("POST_BNUEVO")


if post_ncorr = "" then
post_ncorr = Request.QueryString("busqueda[0][post_ncorr]")
end if

if (sede_ccod = "") and (carr_ccod = "") and (peri_ccod = "") and (espe_ccod = "") then
sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")
espe_ccod = Request.QueryString("busqueda[0][espe_ccod]")
end if


if (sede_ccod = "") and (carr_ccod = "") and (peri_ccod = "") and (espe_ccod = "") then
	buscando = false
else
	buscando = true
end if

'-----------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cambio_oferta_academica2.xml", "f_busqueda"
f_busqueda.Inicializar conexion


set f_especialidades = new CFormulario
f_especialidades.Carga_Parametros "cambio_oferta_academica2.xml", "especialidades"
f_especialidades.Inicializar conexion


consulta2="select '"&request.QueryString("not[0][secc_tdesc]")&"' as secc_tdesc"
f_especialidades.consultar consulta2
f_especialidades.siguiente

if not buscando then
	sede_ccod = negocio.ObtenerSede
	peri_ccod = negocio.ObtenerPeriodoAcademico("planificacion")
end if

consulta = "SELECT " & sede_ccod & " AS sede_ccod, " &_
           "       " & peri_ccod & " AS peri_ccod, " &_
		   "       '" & carr_ccod & "' AS carr_ccod, " &_
		   "       '" & post_ncorr & "' AS post_ncorr, " &_
		   "       '" & POST_BNUEVO & "' AS POST_BNUEVO, " &_
		    "       '" & espe_ccod & "' AS espe_ccod "

f_busqueda.Consultar consulta

f_busqueda.AgregaCampoParam "a.peri_ccod", "filtro", "a.peri_ccod >= " & negocio.ObtenerPeriodoAcademico("planificacion")
f_busqueda.Siguiente

if buscando then
		  
consulta ="select a.ofer_ncorr, " & vbCrLf &_
		  "case post_bnuevo when 'S' then 'NUEVO' when 'N' then 'ANTIGUO' end as tipo_alumnos," & vbCrLf &_
		  "jorn_tdesc,ofer_nvacantes, c.ARAN_MMATRICULA, c.ARAN_MCOLEGIATURA, c.aran_nano_ingreso, " & vbCrLf &_ 
		  " case a.ofer_bpaga_examen when 'S' then 'PAGA' else 'EXENTO' end as ofer_bpaga_examen,   " & vbCrLf &_
  		  " case a.ofer_bpublica when 'S' then 'SI' else 'NO' end as ofer_bpublica,   " & vbCrLf &_
		  " case isnull(a.ofer_bactiva,'S') when 'S' then 'SI' else 'NO' end as ofer_bactiva   " & vbCrLf &_
		  "from ofertas_academicas a, jornadas b, aranceles c, especialidades e  " & vbCrLf &_
		  "where a.jorn_ccod = b.jorn_ccod and" & vbCrLf &_
		   "a.aran_NCORR = c.aran_NCORR and" & vbCrLf &_
		   "a.espe_ccod = e.espe_ccod and " & vbCrLf &_
		  "a.sede_ccod = " & sede_ccod & " and " & vbCrLf &_
		  "a.peri_ccod = " & peri_ccod & " AND " & vbCrLf &_
		  "e.carr_ccod = '" & carr_ccod & "'  and " & vbCrLf &_
		   "a.espe_ccod = '" & espe_ccod & "' "  & vbCrLf &_
           "union " & vbCrLf &_
		  "select a.ofer_ncorr,  " & vbCrLf &_
		  "case post_bnuevo when 'S' then 'NUEVO' when 'N' then 'ANTIGUO' end as tipo_alumnos," & vbCrLf &_
		  "jorn_tdesc,ofer_nvacantes, c.ARAN_MMATRICULA, c.ARAN_MCOLEGIATURA, c.aran_nano_ingreso,  " & vbCrLf &_
		  " case a.ofer_bpaga_examen when 'S' then 'PAGA' else 'EXENTO' end as ofer_bpaga_examen,   " & vbCrLf &_
  		  " case a.ofer_bpublica when 'S' then 'SI' else 'NO' end as ofer_bpublica,   " & vbCrLf &_
		  " case isnull(a.ofer_bactiva,'N') when 'S' then 'SI' else 'NO' end as ofer_bactiva   " & vbCrLf &_		  
		  "from ofertas_academicas a, jornadas b, aranceles c, especialidades e  " & vbCrLf &_
		  "where a.jorn_ccod = b.jorn_ccod and" & vbCrLf &_
		   "a.ofer_NCORR = c.ofer_NCORR and" & vbCrLf &_
		   "a.espe_ccod = e.espe_ccod and " & vbCrLf &_
		  "a.sede_ccod = " & sede_ccod & " and " & vbCrLf &_
		  "a.peri_ccod = " & peri_ccod & " AND " & vbCrLf &_
		  "e.carr_ccod = '" & carr_ccod & "'  and " & vbCrLf &_
		   "a.espe_ccod = '" & espe_ccod & "' and " & vbCrLf &_ 
          "post_bnuevo = 'N' " & vbCrLf &_ 
		  "order by aran_nano_ingreso desc, tipo_alumnos desc"

	'response.Write("<pre>"&consulta&"</pre>")

	set f_tabla = new CFormulario
	f_tabla.Carga_Parametros "cambio_oferta_academica2.xml", "f_tabla"
	f_tabla.Inicializar conexion
	f_tabla.Consultar consulta
end if

set errores = new CErrores

consulta = "SELECT * FROM especialidades"
conexion.Ejecuta consulta
set rec_especialidades = conexion.ObtenerRS

%>


<html>
<head>
<title>Administrador de Ofertas Académicas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
arr_especialidades = new Array();

<%
rec_especialidades.MoveFirst
i = 0
while not rec_especialidades.Eof
%>
arr_especialidades[<%=i%>] = new Array();
arr_especialidades[<%=i%>]["espe_ccod"] = '<%=rec_especialidades("espe_ccod")%>';
arr_especialidades[<%=i%>]["espe_tdesc"] = '<%=rec_especialidades("espe_tdesc")%>';
arr_especialidades[<%=i%>]["carr_ccod"] = '<%=rec_especialidades("carr_ccod")%>';

<%	
	rec_especialidades.MoveNext
	i = i + 1
wend
%>

function Salir()
{
	window.close();
}

function Agregar(formulario)
{	
var  carrera_ccod =formulario.elements["busqueda[0][carr_ccod]"].value;
var especialidad_ccod =formulario.elements["busqueda[0][espe_ccod]"].value;

	//alert(formulario.elements["busqueda[0][carr_ccod]"]);
	if (carrera_ccod == "") {
		alert('Debe seleccionar una carrera para crear una nueva oferta.\nSi no existe la carrera buscada, debe crearla.');
		formulario.elements["busqueda[0][carr_ccod]"].focus();
		return false;
	}else if (especialidad_ccod == -1) {
		alert('Debe Seleccionar una especialidad de carrera para crear una nueva oferta.\nSi la carrera no tiene especialidad, debe crear una especialidad sin mencion');
		formulario.elements["busqueda[0][carr_ccod]"].focus();
		return false;
	}else{
		resultado = open("adm_ofertas_agregar.asp?espe_ccod="+especialidad_ccod+"&carr_ccod="+carrera_ccod+"&sede_ccod=<%=sede_ccod%>&peri_ccod=<%=peri_ccod%>", "", "width=710; height=310");
	}
}

function Eliminar()
{
	formulario = document.busqueda;
	mensaje="eliminar";
	if (verifica_check(formulario,mensaje)) {
	
		formulario.method = "post";
		formulario.action = "adm_ofertas_eliminar.asp";
		formulario.submit();
	}
}

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "-- Seleccione especialidad --";
	formulario.elements["busqueda[0][espe_ccod]"].add(op)

	for (i = 0; i < arr_especialidades.length; i++) {
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod) {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod]"].add(op)			
		}
	}	
}

function InicioPagina(formulario)
{
espe_ccod="<%=espe_ccod%>"
carr_ccod="<%=carr_ccod%>"

if (espe_ccod !="")
{
CargarEspecialidades(formulario,carr_ccod)
formulario.elements["busqueda[0][espe_ccod]"].value = "<%=espe_ccod%>";
}
}

function ValidarBusqueda(formulario)
{
	if (formulario.elements["busqueda[0][carr_ccod]"].value == "") {
		alert('Seleccione una carrera.');
		formulario.elements["busqueda[0][carr_ccod]"].focus();
		return false;
	}
	
	if (formulario.elements["busqueda[0][espe_ccod]"].value == "-1") {
		alert('Seleccione una especialidad.');
		formulario.elements["busqueda[0][espe_ccod]"].focus();
		return false;
	}
	
	return true;
}

function Enviar(formulario)
{
	var cont=0;
	var inputs = document.getElementsByTagName("input");
	for(var i = 0; i < inputs.length; i++) {
		 if(inputs[i].type == "checkbox") {
			if(inputs[i].checked)
			{
				cont=cont+1;
			}
		}
	}
	if(cont == 1 )
	{
		return true;
	}
	else
	{
		alert("Debe seleccionar una oferta");
		return false;
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

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}


function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina(document.buscador);Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
    <td valign="top" bgcolor="#EAEAEA">
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
                <td> 
                  <%pagina.DibujarLenguetas Array("Buscador de Ofertas Académicas"), 1%>
                </td>
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
                <input type="hidden" name="post_ncorr" value="<%=post_ncorr%>"/>
                      <table width="100%"  border="0">
                        <tr> 
                          <td width="88%"><table cellspacing=0 cellpadding=0 width="100%" 
border=0>
                              <tbody>
                                <tr valign="middle"> 
                                  <td width="53%" height=40 align=middle> <div align="left">Sede<br>
                                      <% f_busqueda.DibujaCampo("sede_ccod") %>
                                      <br>
                                    </div></td>
                                  <td width="37%" align=middle> <div align="left">Periodo<br>
                                      <% f_busqueda.DibujaCampo("peri_ccod") %>
                                      <br>
                                    </div></td>
                                  <td width="10%" rowspan="3" align=middle> <%botonera.dibujaboton "buscar"%> </td>
                                </tr>
                                <tr valign="middle"> 
                                  <td height="46" colspan="2" align=middle> 
                                    <div align="left">Carrera 
                                      <br>
                                      <% f_busqueda.DibujaCampo("carr_ccod") %>
                                    </div></td>
                                </tr>
                                <tr valign="middle"> 
                                  <td colspan="2" align=middle> <div align="left"> 
                                      Especialidad <br>
                                      <% f_busqueda.DibujaCampo("espe_ccod") %>
                                      <% f_especialidades.DibujaCampo("espe_ccod") %>
                                      <% f_especialidades.DibujaCampo("post_ncorr") %>
                                      <br>
                                    </div>
                                    <div align="left"> </div></td>
                                </tr>
                              </tbody>
                            </table></td>
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
            </table>			
          </td>
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
                      <td background="../imagenes/fondo1.gif"> 
                        <%pagina.DibujarLenguetas Array("Administrador de ofertas académicas"), 1%>
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
                  <form name="busqueda" id="busqueda" method="post">
                  <input type="hidden" name="post_ncorr" value="<%=post_ncorr%>"/>
			  <%
			  if buscando then
			  %>
			  <br>
			  <br>
              <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td>Sede: <strong><%=conexion.ConsultaUno("SELECT sede_tdesc FROM sedes WHERE cast(sede_ccod as varchar) = " & sede_ccod) %></strong> </td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Periodo:<strong><%=conexion.ConsultaUno("SELECT peri_tdesc + ' ' + cast(anos_ccod as varchar) FROM periodos_academicos WHERE cast(peri_ccod as varchar) = " & peri_ccod) %></strong></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Carrera:<strong><%=conexion.ConsultaUno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar) = '" & carr_ccod & "'") %></strong></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Especialidad:<strong><%=conexion.ConsultaUno("SELECT espe_tdesc FROM especialidades WHERE cast(espe_ccod as varchar) = '" & espe_ccod & "'") %></strong></td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			        <p>
                      <%
			  else
			  %>
                      <br>
                      <br>
                      &nbsp;&nbsp;&nbsp;* Debe seleccionar par&aacute;metros de 
                      b&uacute;squeda. 
                      <%
			  end if
			  %>
                    </p>
                    <table width="665" border="0">
                      <tr> 
                        <td width="117">&nbsp;</td>
                        <td width="510"><div align="right">P&aacute;ginas: &nbsp; 
                         <%  if buscando then
						f_tabla.AccesoPagina
					end if %>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                    <table width="98%" align="center">
                      <tr> 
                  <td align="left"><div align="center"><br>
                            <%
					if buscando then
						f_tabla.DibujaTabla
					end if
					%>
                            <br>
                          </div></td>
                </tr>
              </table>
					  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
					  <% if buscando then 
                         'botonera.dibujaboton "guardar"
						 botonera.dibujaboton "guardar"
						 end if %>
                        </div></td>
                      
                      <td><div align="center"> 
                          <%botonera.dibujaboton "salir"%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
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
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
