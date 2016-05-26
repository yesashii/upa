<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Acta de Convalidación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
'--  RECEPCION DE VARIABLES GET
if Request.QueryString("reso_ncorr") <> "" then
	q_reso_ncorr = Request.QueryString("reso_ncorr")
else
	q_reso_ncorr = 0
end if

q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
'------------------------------------------------------------------------------------------------------------------

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "acta_convalidacion.xml", "consulta"

set impresora = new cformulario
impresora.carga_parametros "acta_convalidacion.xml","impresora"
impresora.inicializar conexion
sede=negocio.obtenerSede
'-------------------------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "acta_convalidacion.xml", "busqueda"
f_busqueda.Inicializar conexion

consulta = "SELECT '" & q_pers_nrut & "' AS pers_nrut, " &_
           "       '" & q_pers_xdv & "' AS pers_xdv " 
          
f_busqueda.Consultar consulta

f_busqueda.Siguiente

'-------------------------------------------------------------------------------------------------------------------
set f_resoluciones = new CFormulario
f_resoluciones.Carga_Parametros "acta_convalidacion.xml", "resoluciones-actas_convalidacion"
f_resoluciones.Inicializar conexion

consulta = "SELECT b.peri_ccod as peri_ccod, a.*, b.*, d.pers_nrut, d.pers_xdv " & vbCrLf &_
           "FROM resoluciones a, actas_convalidacion b, resoluciones_personas c, personas d " & vbCrLf &_
		   "WHERE a.reso_ncorr = b.reso_ncorr AND " & vbCrLf &_
		   "      a.reso_ncorr = c.reso_ncorr AND " & vbCrLf &_
		   "      c.pers_ncorr = d.pers_ncorr AND " & vbCrLf &_
		   "      cast(a.reso_ncorr as varchar)= '" & q_reso_ncorr & "'"
'response.Write(consulta)
f_resoluciones.Consultar consulta



if f_resoluciones.NroFilas > 0 then
	resolucion_existe = true
	
	f_resoluciones.Siguiente
		
	v_acon_ncorr = f_resoluciones.ObtenerValor("acon_ncorr")
	v_peri_ccod = f_resoluciones.ObtenerValor("peri_ccod")
	v_pers_nrut = f_resoluciones.ObtenerValor("pers_nrut")
	v_pers_xdv = f_resoluciones.ObtenerValor("pers_xdv")
	v_tres_ccod = f_resoluciones.ObtenerValor("tres_ccod")
	'response.Write(v_tres_ccod)
	
	v_eres_ccod = f_resoluciones.ObtenerValor("eres_ccod")
	if CInt(v_eres_ccod) = 2 then
		resolucion_abierta = true
	else
		resolucion_abierta = false
	end if
	
	'----------------------------------------------------------------------------------------------------
	if resolucion_abierta then
		f_resoluciones.AgregaCampoParam "pers_nrut", "soloLectura", "TRUE"
		f_resoluciones.AgregaCampoParam "pers_xdv", "soloLectura", "TRUE"	
	else	
		f_resoluciones.AgregaCampoParam "acon_nacta", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "acon_facta", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "reso_nresolucion", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "tres_ccod", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "reso_fresolucion", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "acon_tinstitucion", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "acon_tcarrera", "permiso", "LECTURA"
		
		f_resoluciones.AgregaCampoParam "pers_nrut", "permiso", "LECTURA"
		f_resoluciones.AgregaCampoParam "pers_xdv", "permiso", "LECTURA"
	end if
	
else
	resolucion_existe = false
	v_acon_ncorr = 0
	v_peri_ccod = 0
	v_pers_nrut = 0
	v_pers_xdv = ""
	
	
	reso_ncorr=conexion.consultaUno("execute obtenersecuencia 'reso_ncorr_seq'")
	acon_ncorr=conexion.consultaUno("execute obtenersecuencia 'acon_ncorr_seq'")		  
	fecha=conexion.consultaUno("Select getDate()") 
	f_resoluciones.Consultar "Select ''"
	f_resoluciones.Siguiente
	f_resoluciones.agregaCampoCons "acon_nacta" , acon_ncorr
	f_resoluciones.agregaCampoCons "acon_ncorr" , acon_ncorr
	f_resoluciones.agregaCampoCons "reso_ncorr" , reso_ncorr
	f_resoluciones.agregaCampoCons "reso_fresolucion" , fecha
	f_resoluciones.agregaCampoCons "acon_facta" , fecha
end if

if esVacio (v_tres_ccod) then
	v_tres_ccod= 0
else
    v_tres_ccod = cint(v_tres_ccod)	
	if v_tres_ccod = 3 or v_tres_ccod = 6 then
		 f_resoluciones.agregaCampoParam "acon_tinstitucion", "id" , "TO-S"
         f_resoluciones.agregaCampoParam "reso_nresolucion", "id" , "TO-S"
         f_resoluciones.agregaCampoParam "acon_tcarrera" , "id" , "TO-S"
	end if 
end if

carr_ccod = conexion.consultaUno("select carr_ccod from convalidaciones a, alumnos b, ofertas_academicas c, especialidades d where a.matr_ncorr=b.matr_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and cast(acon_ncorr as varchar)='"&v_acon_ncorr&"'")
filtro_carrera = ""
if carr_ccod <> "" then
	filtro_carrera = " and f.carr_ccod='"&carr_ccod&"'"
end if
'----------------------------------------------------------------------------------------------------------------------
set f_convalidaciones = new CFormulario
f_convalidaciones.Carga_Parametros "acta_convalidacion.xml", "convalidaciones"
f_convalidaciones.Inicializar conexion
	
consulta = "SELECT a.matr_ncorr, a.asig_ccod, a.acon_ncorr, b.asig_tdesc, a.sitf_ccod, case a.conv_nnota when null then '&nbsp;' else replace(cast(a.conv_nnota as decimal(3,1)),',','.') end AS html_conv_nnota,conv_tdocente " &_
           "FROM convalidaciones a, asignaturas b " &_
		   "WHERE a.asig_ccod = b.asig_ccod AND " &_
		   "      cast(acon_ncorr as varchar)= '" & v_acon_ncorr & "' " &_
		   "ORDER BY a.asig_ccod ASC"
'response.Write("<pre>"&consulta&"</pre>")			   
f_convalidaciones.Consultar consulta


if not resolucion_abierta then
	f_convalidaciones.AgregaParam "eliminar", "FALSE"
	f_convalidaciones.AgregaParam "editar", "FALSE"
end if

'-------------------------------------------------------------------------
actividad = session("_actividad")
'response.Write("a "&actividad)
'if (actividad = "5")  then
if v_peri_ccod = "0" then
	peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	peri_ccod = v_peri_ccod
end if	
'else
'	peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
'end if
peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'---------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "acta_convalidacion.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion


consulta = "SELECT a.pers_nrut, " & vbCrLf &_
           "       a.pers_xdv, " & vbCrLf &_
		   "       a.pers_tape_paterno, " & vbCrLf &_
		   "       a.pers_tape_materno, " & vbCrLf &_
		   "       a.pers_tnombre, " & vbCrLf &_
		   "       a.pers_tape_paterno + ' ' + a.pers_tape_materno + ' ' + a.pers_tnombre AS nombre_alumno, " & vbCrLf &_
		   "       f.carr_tdesc, " & vbCrLf &_
		   "       e.espe_tdesc, " & vbCrLf &_
		   "       d.plan_ncorrelativo, " & vbCrLf &_
		   "       d.plan_tdesc, " & vbCrLf &_
		   "       d.plan_ccod, " & vbCrLf &_
		   "       b.matr_ncorr, "  & vbCrLf &_
		   "       a.pers_ncorr "  & vbCrLf &_
		   "FROM personas a, alumnos b, ofertas_academicas c, planes_estudio d, especialidades e, carreras f " & vbCrLf &_
		   "WHERE a.pers_ncorr = b.pers_ncorr AND " & vbCrLf &_
		   "      b.ofer_ncorr = c.ofer_ncorr AND " & vbCrLf &_
		   "      b.plan_ccod = d.plan_ccod AND " & vbCrLf &_
		   "      d.espe_ccod = e.espe_ccod AND " & vbCrLf &_
		   "      e.carr_ccod = f.carr_ccod AND " & vbCrLf &_
		   "      b.emat_ccod = 1 AND " & vbCrLf &_
		   "      cast(a.pers_nrut as varchar)= '" & v_pers_nrut & "' AND " & vbCrLf &_
		   "      cast(a.pers_xdv as varchar)= '" & v_pers_xdv & "' AND " & vbCrLf &_
		   "      cast(c.peri_ccod as varchar)= '" & v_peri_ccod & "' "&filtro_carrera

'response.Write("<pre>"&consulta&"</pre>")
f_datos_alumno.Consultar consulta
f_datos_alumno.Siguiente
'-------------------------------------------------------------------------------------------------------------------------
impresora.carga_parametros "acta_convalidacion.xml","impresora"
impresora.inicializar conexion

impres="select impr_truta from impresoras where cast(impr_truta as varchar)='" & session("impresora") & "'"

impresora.consultar impres
impresora.siguientef
impresora.agregacampoparam "impr_truta","filtro"," cast(sede_ccod as varchar)= '" & sede & "' "

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "acta_convalidacion.xml", "botonera"
'-----------------------------------------------------------------------

consulta_creditos_convalidados  =  " SELECT sum( isnull(cred_valor,0) ) " &_
								   " FROM convalidaciones a, asignaturas b,creditos_asignatura c " &_
								   " WHERE a.asig_ccod = b.asig_ccod AND b.cred_ccod=c.cred_ccod and " &_
								   "      cast(acon_ncorr as varchar)= '" & v_acon_ncorr & "' " 
plan_cursado = f_datos_alumno.obtenerValor("plan_ccod")
'total_asignaturas_plan = conexion.consultaUno("select count(*) from malla_curricular where cast(plan_ccod as varchar)='"&plan_cursado&"'")
'total_convalidadas = f_convalidaciones.nroFilas
total_asignaturas_plan = conexion.consultaUno("select sum( isnull(cred_valor,0) ) from malla_curricular a,asignaturas b, creditos_asignatura c where a.asig_ccod=b.asig_ccod and b.cred_ccod=c.cred_ccod and cast(plan_ccod as varchar)='"&plan_cursado&"'")
total_convalidadas = conexion.consultaUno(consulta_creditos_convalidados)
'response.Write(total_convalidadas)

if total_asignaturas_plan <> "0" and total_convalidadas <> "" then
	porcentaje_convalidadas  = formatnumber(cdbl( (cdbl(total_convalidadas) * 100) / cdbl(total_asignaturas_plan)),0,-1,0,0)
	porcentaje_restantes = 100 - porcentaje_convalidadas
	creditos_faltantes = cdbl(total_asignaturas_plan) - cdbl(total_convalidadas)
end if
'response.Write(porcentaje_convalidadas&"  "&porcentaje_restantes)

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
<!--
function corregir(nombre,valor)
{var indice;
     indice= extrae_indice(nombre)
	 var formulario=document.edicion;
	 if ((valor==3)||(valor==6)){
		//alert("nombre "+nombre + " valor "+ valor );
		formulario.elements["reso_acon[0][acon_tinstitucion]"].id='TO-S'
		formulario.elements["reso_acon[0][reso_nresolucion]"].id='TO-S'
		formulario.elements["reso_acon[0][acon_tcarrera]"].id='TO-S'
		//document.edicion.elements["profesor["+indice+"][blpr_nhoras_ayudante]"].disabled=false;
		//document.edicion.elements["profesor["+indice+"][niay_ccod]"].disabled=false;
	}
	else {
	//alert ("habilito bloqueo");
	formulario.elements["reso_acon[0][reso_nresolucion]"].id='TO-N'
		//document.edicion.elements["profesor["+indice+"][blpr_nhoras_ayudante]"].disabled=true;
		//document.edicion.elements["profesor["+indice+"][niay_ccod]"].disabled=true;
	}
	
}

function Salir()
{
	window.close();
}

function imprimir(formulario){
	
    formulario.action ='imprimir_acta.asp';
	formulario.method="post";
	formulario.submit();

	
}
function ValidaFormBusqueda(formulario)
{
	if (!valida_rut(formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_nrut]"].focus();
		formulario.elements["busqueda[0][pers_nrut]"].select();
		return false;
	}
	
	return true;
}


function Buscar(formulario)
{
	if (preValidaFormulario(formulario)) {
		if (ValidaFormBusqueda(formulario)) {
			str_url = "busqueda_resoluciones_actas.asp?pers_nrut=" + formulario.elements["busqueda[0][pers_nrut]"].value + "&pers_xdv=" + formulario.elements["busqueda[0][pers_xdv]"].value;
		
		resultado = open(str_url, "", "height=500, width=750, top=100, left=100");
		}
	}
}



function ValidaFormEdicion(formulario)
{
	if (!valida_rut(formulario.elements["reso_acon[0][pers_nrut]"].value + "-" + formulario.elements["reso_acon[0][pers_xdv]"].value)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["reso_acon[0][pers_nrut]"].focus();
		formulario.elements["reso_acon[0][pers_nrut]"].select();
		return false;
	}
	
	return true;
}

function Agregar(formulario)
{
	if (preValidaFormulario(formulario)) {		
		if (ValidaFormEdicion(formulario)) {
		
			str_url  = "acta_convalidacion_agregar.asp?";
						
			for (i=0; i<formulario.elements.length; i++) {
				if (formulario.elements[i].name.search(/reso_acon/) >= 0) {
					str_url += formulario.elements[i].name + "=" + formulario.elements[i].value + "&";
				}
			}				
			
			resultado = open(str_url, "", "width=780, height=450, scrollbars=yes");
		}		
	}
}


function Eliminar(formulario)
{
	if (confirm('¿Está seguro que desea eliminar las convalidaciones seleccionadas?')) {
		str_url = "acta_convalidacion_eliminar.asp?reso_ncorr=<%=q_reso_ncorr%>";
		
		formulario.action = str_url;
		formulario.method = "post";
		formulario.target = "_self"
		formulario.submit();		
	}
}


function CerrarResolucion()
{
	if (confirm('¿Está seguro que desea cerrar esta resolución?')) {
		str_url = "acta_convalidacion_cerrar_resolucion.asp?reso_ncorr=<%=q_reso_ncorr%>"
		navigate(str_url);
	}
}

function AbrirResolucion()
{
	if (confirm('¿Está seguro que desea abrir esta resolución?')) {
		str_url = "acta_convalidacion_abrir_resolucion.asp?reso_ncorr=<%=q_reso_ncorr%>"
		navigate(str_url);
	}
}


function NuevaResolucion()
{
	navigate("acta_convalidacion.asp");
}



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
function certificado_1(){
   self.open('certificado_1.asp?acon_ncorr='+<%=v_acon_ncorr%>,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
//-->
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"> <strong>Rut Alumno :</strong>
                            <%f_busqueda.DibujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%>
                            <a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a> 
                          </div></td>
                  <td width="19%"><div align="center">
                            <%botonera.dibujaBoton "buscar"%>
                          </div></td>
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
              <%pagina.Titulo = "Acta de Convalidación <br>" & peri_tdesc
 			    pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                        <td> 
						<table width="95%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                          <td align="left"> 
						  <br>
						  <br>
						  <%
						  f_resoluciones.DibujaCampo("reso_ncorr")
						  f_resoluciones.DibujaCampo("acon_ncorr")
						  %>
						  <table width="97%" align="center" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td width="20%">N&ordm; Acta</td>
                                    <td width="5%"><div align="center">:</div></td>
                                    <td width="22%"><b> 
                                      <%f_resoluciones.DibujaCampo("acon_nacta")%>
                                      </b></td>
                                    <td width="53%"><b> </b></td>
                                  </tr>
                                  <tr> 
                                    <td>Fecha Acta</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"> <b> 
                                      <%f_resoluciones.DibujaCampo("acon_facta")%>
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td>N&ordm; Resoluci&oacute;n</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"><b> 
                                      <%f_resoluciones.DibujaCampo("reso_nresolucion")%>
                                      </b></td>
                                  </tr>
                                  <tr> 
                                    <td>Tipo de Resoluci&oacute;n</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"> <b> 
                                      <%f_resoluciones.DibujaCampo("tres_ccod")%>
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td>Fecha Resoluci&oacute;n</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"><b> 
                                      <%f_resoluciones.DibujaCampo("reso_fresolucion")%>
                                      </b></td>
                                  </tr>
                                  <tr> 
                                    <td>Instituci&oacute;n Origen</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"><b> 
                                      <%f_resoluciones.DibujaCampo("acon_tinstitucion")%>
                                      </b></td>
                                  </tr>
                                  <tr> 
                                    <td>Carrera Origen</td>
                                    <td><div align="center">:</div></td>
                                    <td colspan="2"><b> 
                                      <%f_resoluciones.DibujaCampo("acon_tcarrera")%>
                                      </b></td>
                                  </tr>
                                  <tr> 
                                    <td>RUT Alumno</td>
                                    <td><div align="center">:</div></td>
                                    <td><b> 
                                      <%f_resoluciones.DibujaCampo("pers_nrut")%>
                                      - 
                                      <%f_resoluciones.DibujaCampo("pers_xdv")%>
                                      </b> </td>
                                    <td><div align="right"> 
                                        <% if resolucion_existe and not resolucion_abierta then 
                                    '<input type="button" name="Button" value="Nueva Resoluci&oacute;n" onClick="NuevaResolucion();">-->
									  botonera.dibujaBoton "nueva_resolucion"
                                     end if %>
                                        <% if resolucion_existe and resolucion_abierta then 
                                    '<input type="button" name="Button" value="Cerrar Resoluci&oacute;n" onClick="CerrarResolucion();">
									botonera.dibujaBoton "cerrar_resolucion"
                                     end if %>
                                      </div></td>
                                  </tr>
                                </table>
							<br>
							<%
							if resolucion_existe then
							%>
                            <table width="97%" align="center" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td>Alumno </td>
                                    <td><div align="center">:</div></td>
                                    <td> <b> 
                                      <%f_datos_alumno.DibujaCampo("nombre_alumno")%>
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td width="20%">Carrera </td>
                                    <td width="5%"><div align="center">:</div></td>
                                    <td width="75%"><b> 
                                      <%f_datos_alumno.DibujaCampo("carr_tdesc")%>
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td>Especialidad </td>
                                    <td><div align="center">:</div></td>
                                    <td><b> 
                                      <%f_datos_alumno.DibujaCampo("espe_tdesc")%>
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td>Plan </td>
                                    <td><div align="center">:</div></td>
                                    <td><b> 
                                      <%f_datos_alumno.DibujaCampo("plan_tdesc")%>
                                      </b> </td>
                                  </tr>
								  <tr>
								  	<td>Total Créditos</td>
									<td><div align="center">:</div></td>
									<td><b><%=total_asignaturas_plan%> Créditos</b></td>
								  </tr>
								  <tr><td colspan="3">&nbsp;</td></tr>
								  <tr><td colspan="3">&nbsp;</td></tr>
								  <%if f_convalidaciones.nroFilas > 0 then %>
								  <tr>
								     <td colspan="3" align="center">
									  	<table width="400" border="1" cellpadding="0" cellspacing="0">
											<tr>
												<td height="30" width="<%=porcentaje_convalidadas*4%>" bgcolor="#FF9933" align="center"><b><%=porcentaje_convalidadas%>%</b> CONVALIDADO<br>(<%=total_convalidadas%> créd.)</td>
												<td height="30" width="<%=porcentaje_restantes*4%>" bgcolor="#99FF99" align="center"><%=porcentaje_restantes%>%<b></b> SIN CONVALIDAR<br>(<%=creditos_faltantes%> créd.)</td>
											</tr>
										</table>		
									 </td>
								  </tr>
								  <%end if%>
                                </table>
							<br>
							<br>
							<br>
							<%
							end if
							%>                            
                            <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr>
                                <td><div align="center"><font size="3">
                                        <%pagina.DibujarSubtitulo "Convalidaciones"%>
                                        </font></div></td>
                              </tr>
                              <tr> 
                                <td width="100%"><div align="center">
								    <br>
                                    <% f_convalidaciones.DibujaTabla %>
                                  </div></td>
                              </tr>
                            </table>
                                <div align="right"><br>
                                  <!--Imprimir en: <%=impresora.dibujacampo("impr_truta")%> -->
								  </div></td>
                        </tr>
                      </table>
						
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
            <td width="19%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if (not resolucion_existe) or (resolucion_existe and resolucion_abierta) then 
				     botonera.dibujaBoton "agregar"
				  end if %>
                          </div></td>
                  <td><div align="center">
                  <% if (not resolucion_existe) or (resolucion_existe and resolucion_abierta) then
				      botonera.agregaBotonParam "eliminar", "deshabilitado", "false"					  
				       botonera.dibujaBoton "eliminar" 
				   else 
				     botonera.agregaBotonParam "eliminar", "deshabilitado", "true"
				  end if
				  %>
                          </div></td>
				  <td><div align="center"><%if resolucion_existe and not resolucion_abierta then
				                             	botonera.dibujaBoton "abrir_resolucion"
											end if%></div></td>
				  <td><div align="center"><%if f_convalidaciones.nroFilas > 0 then
				                            	botonera.dibujaBoton "certificado_1"
											end if%></div></td>
                  <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
