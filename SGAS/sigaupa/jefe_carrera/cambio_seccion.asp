<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: TOMA DE CARGA ACADEMICA 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:22/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			: ORDER BY
'LINEA			: 63
'*******************************************************************
set pagina = new CPagina
set botonera = new CFormulario
set errores 	= new cErrores
botonera.carga_parametros "cambio_seccion.xml", "BotoneraSeccionesEQ"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
secc_ccod	=	request.querystring("a[0][secc_ccod]")
jorn_ccod	=	request.querystring("a[0][jorn_ccod]")

set conectar		=	new cconexion
set negocio			=	new cnegocio

conectar.inicializar "upacifico"
negocio.inicializa conectar

'espe_ccod=conectar.consultaUno("Select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
'cadena_planes=conectar.consultaUno("select ltrim(rtrim(protic.obtener_planes('"&espe_ccod&"')))")
'response.Write("cadena planes "&cadena_planes)
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "cambio_seccion.xml", "buscador"
fbusqueda.inicializar conectar
peri_antiguo = negocio.obtenerPeriodoAcademico ("CLASES18")
peri = negocio.obtenerPeriodoAcademico ("planificacion") 
sede = negocio.obtenerSede

consulta="Select '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&secc_ccod&"' as secc_ccod"

fbusqueda.consultar consulta

'consulta = "select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,ltrim(rtrim(d.asig_ccod))as asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc,b.secc_ccod,b.secc_tdesc,e.jorn_ccod,e.jorn_tdesc " & vbCrLf & _
'		   " from carreras a,secciones b, asignaturas d,jornadas e--, bloques_horarios c " & vbCrLf & _
'		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
'		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
'		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
'		   " and b.jorn_ccod=e.jorn_ccod " & vbCrLf &_
'		   " and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
'		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
'		   " and cast(b.peri_ccod as varchar)=  '"&peri&"' order by a.carr_tdesc,d.asig_tdesc,b.secc_tdesc asc" 

consulta = "select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,ltrim(rtrim(d.asig_ccod))as asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc,b.secc_ccod,b.secc_tdesc,e.jorn_ccod,e.jorn_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d,jornadas e--, bloques_horarios c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
		   " and b.jorn_ccod=e.jorn_ccod " & vbCrLf &_
		   " and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
		   " and cast(b.peri_ccod as varchar)=  '"&peri&"' order by a.carr_tdesc, asig_tdesc,b.secc_tdesc asc" 

'response.Write("<pre>"&consulta&"</pre>")	
fbusqueda.inicializaListaDependiente "lBusqueda", consulta

fbusqueda.siguiente
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "cambio_seccion.xml", "f_alumnos"
f_alumnos.inicializar conectar

set f_nueva_seccion = new CFormulario
f_nueva_seccion.Carga_Parametros "cambio_seccion.xml", "nueva_seccion"
f_nueva_seccion.inicializar conectar

if asig_ccod<>"" and secc_ccod<>"" then
	  sql = "select distinct protic.format_rut(c.pers_nrut) as rut,a.secc_ccod, b.matr_ncorr, b.alum_nmatricula, c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO + ',' + c.PERS_TNOMBRE as nombre, f.carr_ccod,  f.CARR_TDESC, e.ESPE_TDESC  "& vbCrLf &_
			"from cargas_academicas a, alumnos b, personas c, ofertas_academicas d, especialidades e, carreras f "& vbCrLf &_
			"where a.matr_ncorr = b.matr_ncorr "& vbCrLf &_
			"  and b.emat_ccod = 1 "& vbCrLf &_
			"  and b.pers_ncorr = c.pers_ncorr "& vbCrLf &_
			"  and b.ofer_ncorr = d.ofer_ncorr "& vbCrLf &_
			"  and d.espe_ccod = e.espe_ccod "& vbCrLf &_
			"  and e.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and cast(a.secc_ccod as varchar)= '" & secc_ccod & "'  "& vbCrLf &_ 
			"  --and cast(d.jorn_ccod as varchar)= '" & jorn_ccod & "'  "& vbCrLf &_ 
			"ORDER BY nombre,rut,a.secc_ccod,b.matr_ncorr,b.alum_nmatricula,f.carr_ccod,f.carr_tdesc,e.espe_tdesc "
			'response.Write("<pre>"&sql&"</pre>")
			
	  consulta = "(select distinct b.secc_ccod,b.secc_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d--, bloques_horarios c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
		   " and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and cast(b.secc_ccod as varchar)<>'"&secc_ccod&"' " & vbCrLf & _
		   " and cast(b.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf & _
		   " and cast(b.asig_ccod as varchar)='"&asig_ccod&"' " & vbCrLf & _
		   " and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' " & vbCrLf & _
		   " and cast(b.peri_ccod as varchar)='"&peri&"')a " 
		   
		   carrera=conectar.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")	
		   asignatura=conectar.consultaUno("Select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")		
		   seccion=conectar.consultaUno("Select secc_tdesc from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")		
		   'response.Write("<pre>"&consulta&"</pre>")
		   'response.Write("<pre>"&peri&"</pre>")
else
sql="Select * from personas where 1=7"
consulta="(Select '' as secc_ccod, '' as secc_tdesc from secciones where 1=7)a"
end if

f_alumnos.consultar sql
cantidad_alumnos=f_alumnos.nroFilas
'f_alumnos.siguiente
'response.Write("<pre>"&sql&"</pre>")
f_nueva_Seccion.consultar "Select ''"
f_nueva_seccion.agregaCampoParam "secc_ccod","destino", consulta
cantidad_nuevas_secciones=f_nueva_seccion.nroFilas
f_nueva_seccion.siguiente
'response.Write("cantidad_alumnos "&cantidad_alumnos&" cantidad_nuevas_secciones "&cantidad_nuevas_secciones)
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


function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="cambio_seccion.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
function guardar(formulario){
     var formulario= document.edicion;
	 var seccion_origen =formulario.elements["seccion_origen"].value;
	 var seccion_destino =formulario.elements["d[0][secc_ccod]"].value;
	 nro = formulario.elements.length;
     num =0;
     for( i = 0; i < nro; i++ ) {
	   comp = formulario.elements[i];
	   str  = formulario.elements[i].name;
	   if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	      num += 1;
	   }
     }
    
	if (seccion_destino=="")
	 {
	 	alert("Debe seleccionar una sección de destino para los alumnos seleccionados")
	 }
	 else
	 {
	 	if( num == 0 ) {
   			alert("Debe seleccionar los alumnos que desea cambiar de sección");
   		}
		else
		{  mensaje="";
		   	if (num==1) {mensaje="¿Está seguro de querer cambiar a este Alumno de sección ?"}
		    else {mensaje="¿Está seguro de querer cambiar a estos "+ num +" Alumnos de sección ?"}
			if(confirm(mensaje)){
			    formulario.elements["cantidad_transferible"].value=num;
			    formulario.method="post";
				formulario.action="proc_cambio_seccion.asp";
				formulario.submit(); 
			}
		    
		}
	 }
	
}
function abrir(){
	self.opener.location.reload();
	window.close();
}
function salir(){
	self.opener.location.reload();
	window.close();
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
<table width="701" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td height="397" valign="top" bgcolor="#EAEAEA">
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
                  <%pagina.DibujarLenguetas Array("Seleccione una sección para mostrar los alumnos"), 1 %>
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
                <td width="670" bgcolor="#D8D8DE">
				  <div align="left">
				    <table width="100%" cellpadding="0" cellspacing="0">
				      <tr>
				        <td>&nbsp;</td>
			          </tr>
			        </table>
			      </div>				  
<form action="" method="get" name="buscador">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Carrera &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Asignatura &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Secci&oacute;n &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                              </tr>
							   <tr> 
                                <td width="5%"> <div align="left">Jornada &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; left: 401px; top: 217px; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                      </tr>
                    </table>
				  </form></td><td width="10" align="right" background="../imagenes/der.gif">&nbsp;</td>
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
          <td>
		     <form name="edicion">
			 <input type="hidden" name="seccion_origen" value="<%=secc_ccod%>">
			 <input type="hidden" name="cantidad_transferible" value="">
		     <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="599" height="1" border="0" alt=""></td>
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
                  <%pagina.DibujarLenguetas Array("Seleccione a los alumnos que desea cambiar de sección"), 1 %>
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
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  		<table width="50%" cellspacing="0" cellpadding="0">
                      			<tr align="left">
                       				 <td colspan="2" nowrap>&nbsp;</td>
                      			</tr>
                      			<tr>
                        			 <td width="29%" align="right" nowrap>Carrera :</td>
                        			 <td width="71%" nowrap> <strong><%=carrera%></strong> </td>
                        		</tr>
                      			<tr>
                        			 <td align="right" nowrap>Asignatura :</td>
                        			 <td nowrap> <strong><%=asignatura%></strong> </td>
                                </tr>
					  			<tr>
                        			 <td align="right" nowrap>Secci&oacute;n :</td>
                        			 <td nowrap> <strong><%=seccion%></strong> </td>
		                        </tr>
                             </table>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>	
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  		<center><br><%f_alumnos.dibujaTabla()%></center>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<%if secc_ccod <> "" then%>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  <br>Seleccione la secci&oacute;n que desee asignar para hacer el cambio : <%f_nueva_seccion.dibujaCampo("secc_ccod")%> <br></center>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<%end if%>
					<tr>
                  		<td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  		<td width="232" bgcolor="#D8D8DE">
				  		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    		<tr>
                      			<td><div align="center"></div></td>
                      			<td><div align="center"><%if cantidad_nuevas_secciones >0 and cantidad_alumnos >0 then
					            		                    botonera.dibujaboton "guardar"
													      end if%></div></td>
                      			<td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                    		</tr>
                  		</table>                    
                  		</td>
                  		<td width="135" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                 		<td rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif" colspan="2" ><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                	</tr>
                	<tr>
                  		<td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                	</tr>
                </table>
				</form>
		         </td>
                </tr>
			   </table>
			   
           </td>
  </tr>  
</table>
</body>
</html>
