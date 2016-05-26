<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "plan_academica_laboratorio.xml", "btn_plan_acedemica_seccion"

secc_ccod=request.QueryString("secc_ccod")

set conexion = new cConexion
set negocio = new cnegocio

set errores = new CErrores

conexion.inicializar "upacifico"
negocio.inicializa conexion

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr in (72,143) and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
if ((actividad = "6") and (autorizada > "0")) then
	periodo = session("_periodo")
else
	periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
end if

sede = negocio.obtenerSede

consulta = "select (select count(secc_ccod) from sub_secciones aa where aa.ssec_ncorr=a.ssec_ncorr and aa.secc_ccod<="&secc_ccod&") as posicion, a.* from sub_secciones a where a.secc_ccod=" & secc_ccod &" order by posicion"

consulta=" select posicion=count(*),s1.ssec_ncorr, s1.secc_ccod,s1.sede_ccod,s1.carr_ccod,s1.peri_ccod,s1.asig_ccod,s1.jorn_ccod,s1.moda_ccod"& vbCrLf &_
		 " ,s1.ssec_tdesc,s1.ssec_nquorum, s1.ssec_ncupo,s1.ssec_finicio_sec,s1.ssec_ftermino_sec,s1.audi_tusuario,s1.audi_fmodificacion,s1.tsse_ccod "& vbCrLf &_
		 " from ("& vbCrLf &_
		 "	 select  c.ssec_ncorr, c.secc_ccod,c.sede_ccod ,c.carr_ccod,c.peri_ccod,c.asig_ccod,c.jorn_ccod,c.moda_ccod,"& vbCrLf &_
		 "	 c.ssec_tdesc,c.ssec_nquorum, c.ssec_ncupo,c.ssec_finicio_sec,c.ssec_ftermino_sec,c.audi_tusuario,c.audi_fmodificacion,c.tsse_ccod "& vbCrLf &_
		 "	 from asignaturas a,secciones b, sub_secciones c "& vbCrLf &_
		 "	 where a.asig_ccod=b.asig_ccod "& vbCrLf &_
		 "	 and b.secc_ccod=c.secc_ccod"& vbCrLf &_
		 "	 and c.tsse_ccod=2"& vbCrLf &_
		 "	 and b.secc_ccod="&secc_ccod&")  s1,"& vbCrLf &_
		 "	 ("& vbCrLf &_
		 "	 select  c.ssec_ncorr, c.secc_ccod,c.sede_ccod,c.carr_ccod,c.peri_ccod,c.asig_ccod,c.jorn_ccod,c.moda_ccod,"& vbCrLf &_
		 "	 c.ssec_tdesc,c.ssec_nquorum, c.ssec_ncupo,c.ssec_finicio_sec,c.ssec_ftermino_sec,c.audi_tusuario,c.audi_fmodificacion,c.tsse_ccod "& vbCrLf &_
		 "	 from asignaturas a,secciones b, sub_secciones c "& vbCrLf &_
		 "	 where a.asig_ccod=b.asig_ccod "& vbCrLf &_
		 "	 and b.secc_ccod=c.secc_ccod"& vbCrLf &_
		 "	 and c.tsse_ccod=2"& vbCrLf &_
		 "	 and b.secc_ccod="&secc_ccod&")  s2"& vbCrLf &_
		 " where s1.ssec_ncorr>=s2.ssec_ncorr"& vbCrLf &_
		 " group by s1.ssec_ncorr, s1.secc_ccod,s1.sede_ccod,s1.carr_ccod,s1.peri_ccod,s1.asig_ccod,s1.jorn_ccod,s1.moda_ccod"& vbCrLf &_
		 " ,s1.ssec_tdesc,s1.ssec_nquorum, s1.ssec_ncupo,s1.ssec_finicio_sec,s1.ssec_ftermino_sec,s1.audi_tusuario,s1.audi_fmodificacion,s1.tsse_ccod "& vbCrLf &_
		 " order by posicion"
'response.Write(consulta)
set f_tabla= new cformulario
f_tabla.carga_parametros "plan_academica_laboratorio.xml", "pl_academica_seccion"
f_tabla.agregaCampoParam "Asignatura_Seccion","consulta", filtro
f_tabla.inicializar conexion
f_tabla.consultar consulta


'-----------------------------------agregamos listado de carreras para seleccionar las que son del plan común entre carreras.

'-------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "plan_academica_laboratorio.xml", "carreras_comunes"
formulario.Inicializar conexion
if secc_ccod <> "" then
  consulta = " select distinct '"&secc_ccod&"' as secc_ccod,b.sede_ccod,b.sede_tdesc as sede, " & vbcrlf & _ 
			 " d.carr_ccod,d.carr_tdesc as carrera,e.jorn_ccod,e.jorn_tdesc as jornada,  " & vbcrlf & _ 
			 " (select case count(*) when 0 then 0 else 1 end from SECCION_CARRERA_PLAN_COMUN sc where sc.sede_ccod=b.sede_ccod  " & vbcrlf & _ 
			 " and sc.carr_ccod=d.carr_ccod and sc.jorn_ccod=e.jorn_ccod and cast(sc.secc_ccod as varchar)='"&secc_ccod&"') as asignado  " & vbcrlf & _ 
			 " from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e  " & vbcrlf & _ 
			 " where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod  " & vbcrlf & _ 
		     " and c.carr_ccod=d.carr_ccod and a.jorn_ccod=e.jorn_ccod  " & vbcrlf & _ 
			 " and cast(a.peri_ccod as varchar)='"&periodo&"'  " & vbcrlf & _ 
			 " and not exists (select 1 from secciones ss where cast(ss.secc_Ccod as varchar)='"&secc_ccod&"' and ss.sede_ccod = b.sede_ccod  " & vbcrlf & _ 
			 " and ss.carr_ccod=d.carr_ccod and ss.jorn_ccod=e.jorn_ccod)  " & vbcrlf & _ 
			 " order by sede,carrera,jornada " 
  formulario.Consultar consulta
end if

sql_seccion_completa="select isnull(seccion_completa,'N') from secciones  where secc_ccod="&secc_ccod
v_seccion_completa=conexion.consultaUno(sql_seccion_completa)


%>


<html>
<head>
<title>Ingreso de Planificaci&oacute;n Acad&eacute;mica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function abrir() {
	direccion = "edicion_plan_acad.asp";
	window.open(direccion, "ventana1","width=600,height=400,scrollbars=YES, resizable=yes, left=0, top=0");
}


function enviar(formulario){
	formulario.action = 'plan_academica.asp';
  	formulario.submit();
 }

function enviar2(formulario){
   formulario.action = 'borrar_bloque.asp';
   formulario.submit();
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<form name="hola" method="post" action="">
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
                      <td width="10" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="445" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> <b><font color="#FFFFFF">INGRESO
                        PLANIFICACI&Oacute;N ACAD&Eacute;MICA (Subsecciones)</font></b></font></div></td>
                      <td width="215" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
				    &nbsp;
 
                      <table width="98%" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td><div align="center"><strong>PLANIFICACION DE SECCI&Oacute;N</strong></div></td>
                        </tr>
                        <tr> 
                          <td align="right"><strong> P&aacute;ginas</strong> <%f_tabla.accesoPagina%> </td>
                        </tr>
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="right"> 
						 
                              <div align="center"> 
                                <%f_tabla.dibujaTabla()%>
                                <br>
                              </div>
                              <table width="21%" height="19" border="0" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                                <tr> 
                                  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                  <td width="10%">&nbsp;</td>
                                  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                </tr>
                            </table>
                            </td>
                        </tr>
						<%if v_seccion_completa="N" then%>
						<tr> 
                          <td><font color="#FF0000" size="2">La seccion no tiene todos sus bloques asignados,requisito necesario para contratación docente.</font><br></td>
                        </tr>
						<%end if%>
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
						<tr> 
                          <td>&nbsp;</td>
                        </tr>
						<%if autorizada <> "0" then %>
						<tr> 
                          <td><hr></td>
                        </tr>
						<tr> 
                          <td>Seleccione la carrera con la cual se comparte esta planificación de la asignatura.</td>
                        </tr>
						<tr> 
                          <td align="right"><strong> P&aacute;ginas</strong> <%formulario.accesoPagina%> </td>
                        </tr>
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="center"> 
						      <div align="center"> 
									<%formulario.dibujaTabla()%>
									<br>
                              </div>
						  </td>
						</tr>    
						<tr> 
                          <td align="right"><%botonera.dibujaboton "actualizar"%></td>
                        </tr>
						<tr> 
                          <td>&nbsp;</td>
                        </tr>
						<%end if%>
                      </table>				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center">
                        <%botonera.dibujaboton "volver"%>
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
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
    <p></form></p></td>
  </tr>  
</table>
</body>
</html>
