<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
set errores 	= new cErrores
botonera.carga_parametros "toma_carga.xml", "BotoneraOptativosDeportivos"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

peri_ccod	=	request.querystring("peri_ccod")
sede_ccod	=	request.querystring("sede_ccod")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
secc_ccod	=	request.querystring("a[0][secc_ccod]")
pers_ncorr	=	request.QueryString("pers_ncorr")
matr_ncorr	=	request.QueryString("matr_ncorr")

set conectar		=	new cconexion
set negocio			=	new cnegocio
set seccion 		=	new cformulario
set asig_origen		=	new cformulario
set asignaturas		=	new cformulario

conectar.inicializar "upacifico"
negocio.inicializa conectar

'espe_ccod=conectar.consultaUno("Select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
'cadena_planes=conectar.consultaUno("select ltrim(rtrim(protic.obtener_planes('"&espe_ccod&"')))")
'response.Write("periodo "&peri_ccod &" sede "&sede_ccod)
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "toma_carga.xml", "buscador_optativos"
fbusqueda.inicializar conectar
peri = peri_ccod 'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = sede_ccod 'negocio.obtenerSede

consulta="Select '"&asig_ccod&"' as asig_ccod, '"&secc_ccod&"' as secc_ccod"

fbusqueda.consultar consulta

consulta = " select a.secc_ccod, a.secc_tdesc, b.asig_ccod, b.asig_tdesc + ' ('+ltrim(rtrim(b.asig_ccod))+')' as asig_tdesc " & vbCrLf & _
		   " from secciones a, asignaturas b,malla_curricular c " & vbCrLf & _
		   " where a.asig_ccod = b.asig_ccod " & vbCrLf & _
		   " and a.asig_ccod = c.asig_ccod and a.mall_ccod=c.mall_ccod " & vbCrLf & _
		   " and c.plan_ccod = '378' " & vbCrLf & _
		   " and a.carr_ccod = '820' " & vbCrLf & _
		   " and a.secc_ncupo > 0 " & vbCrLf & _
		   " and cast(a.peri_ccod as varchar)= '"&peri&"'" 
	

fbusqueda.inicializaListaDependiente "lBusqueda", consulta
fbusqueda.siguiente

'---------------------------buscamos ahora si al alumno le quedan optativos de plan por realizar-----------------------------
plan_alumno =conectar.consultaUno("select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(plan_alumno)
cantidad_optativos_plan = conectar.consultaUno("select isnull(count(*),0) from malla_curricular a, asignaturas b where a.asig_ccod = b.asig_ccod and b.clas_ccod=2 and asig_tdesc not like '%especialidad%' and cast(plan_ccod as varchar)='"&plan_alumno&"'")
'response.Write("num_optativos_malla "&cantidad_optativos_plan)
carrera = conectar.consultaUno("select c.carr_ccod from alumnos a, ofertas_Academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(carrera)
cantidad_optativos_alumno = " select isnull(count(*),0) from ( " & vbCrLf & _
							" select d.asig_ccod " & vbCrLf & _
							" from alumnos a, cargas_Academicas b, secciones c, asignaturas d " & vbCrLf & _
						    " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf & _
						    " and a.matr_ncorr=b.matr_ncorr and asig_tdesc not like '%especialidad%'" & vbCrLf & _
							" and b.secc_ccod=c.secc_ccod " & vbCrLf & _
							" and c.asig_ccod=d.asig_ccod " & vbCrLf & _
							" and d.clas_ccod=2  --2 significa que busca optativos " & vbCrLf &_ 
							" and c.carr_ccod='"&carrera&"' " & vbCrLf & _
							" union " & vbCrLf & _
						    " select b.asig_ccod --para ver si se le ingresaron optativos por equivalencias" & vbCrLf & _ 
							" from alumnos a, equivalencias b,asignaturas c,secciones d " & vbCrLf & _
							" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
							" and a.matr_ncorr=b.matr_ncorr  and asig_tdesc not like '%especialidad%'" & vbCrLf & _
							" and b.asig_ccod=c.asig_ccod " & vbCrLf & _
							" and b.secc_ccod=d.secc_ccod " & vbCrLf & _
							" and d.carr_ccod='"&carrera&"'" & vbCrLf & _
							"and c.clas_ccod=2) a"

cantidad_optativos_alumno = conectar.consultaUno(cantidad_optativos_alumno)
'response.Write(" num_optativos_alumno "&cantidad_optativos_alumno)
set f_afecta = new cFormulario
f_afecta.carga_parametros "toma_carga.xml", "afecta_promedio"
f_afecta.inicializar conectar
f_afecta.consultar "select ''"
f_afecta.siguiente

if cint(cantidad_optativos_alumno) >= cint(cantidad_optativos_plan) then
	afecta_promedio=false
	f_afecta.agregaCampoParam "carg_afecta_promedio","deshabilitado","TRUE"
	f_afecta.agregaCampoParam "carg_afecta_promedio","id","TO-S"
	activo="0"
else
	afecta_promedio=true	
    f_afecta.agregaCampoParam "carg_afecta_promedio","deshabilitado","FALSE"
	f_afecta.agregaCampoParam "carg_afecta_promedio","id","TO-N"
	f_afecta.agregaCampoCons "carg_afecta_promedio","N"
	activo="1"
end if
'response.Write(afecta_promedio)


'----------------------------------------------------------------------------------------------------------------------------

%>

<html>
<head>
<title>B&uacute;squeda de Secciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<!--   -->
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--


function guardar(formulario){
			formulario.method="post";
			formulario.action="guardar_optativo.asp";
			formulario.submit();
}

function salir(){
	//self.opener.location.reload();
	window.close();
}

function validar()
{ var formulario=document.edicion;
      activo = '<%=activo%>';
      asignatura = formulario.elements["a[0][ASIG_CCOD]"].value;
	  seccion = formulario.elements["a[0][SECC_CCOD]"].value;
  	  valor_retorno=false;
	  if (asignatura!="" && seccion!="")
	    valor_retorno=true;
	  else
	  {
	   alert("Debe seleccionar la asignatura y la sección que desea asignar al alumno");
	   valor_retorno=false;
	  }	
	
  return valor_retorno;
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
<% fbusqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="397" valign="top" bgcolor="#EAEAEA">
	<br>
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
                  <%pagina.DibujarLenguetas Array("Inscribir optativo deportivo"), 1 %>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion">
 						 <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="26%"> <div align="left"><strong>Asignatura&nbsp;</strong> 
                                </div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="72%"><% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="26%"> <div align="left"><strong>Secci&oacute;n</strong></div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="26%"> <div align="left"><strong>Afecta al Promedio</strong></div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><%f_afecta.dibujaCampo("carg_afecta_promedio")%> <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>"></td>
                              </tr>
							  <tr>
							     <td colspan="3" align="center">&nbsp;</font></td>	
							  </tr>
							  <%if afecta_promedio=False then%>
							  <tr>
							     <td colspan="3" align="center"><font color="#0000FF" size="2">El alumno ya tiene dictados todos los optativos de la carrera, cualquier otro optativo será complementario a su malla y no afectará al promedio final.</font></td>	
							  </tr>
							  <%end if%>
                            </table></td>
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
                      <td><div align="center"></div></td>
                      <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
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
		  </td>
        </tr>
      </table>	
    </td>
  </tr>  
</table>
</body>
</html>
