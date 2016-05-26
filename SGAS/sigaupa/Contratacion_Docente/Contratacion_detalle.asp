<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: CONTRATOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:25/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:108
'********************************************************************
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "Contratacion_Detalle.xml", "btn_det_plan"

pers_ncorr=request.QueryString("pers_ncorr")
carr_ccod=request.QueryString("carr_ccod")

'response.Write(pers_ncorr&"<br>")
'response.Write(carr_ccod&"<br>")
'response.End()

set conexion = new cConexion
set negocio = new cnegocio
set f_asig = new cFormulario
set profesores = new cFormulario
set formu_conectar = new cformulario

conexion.inicializar "upacifico"
negocio.inicializa conexion
'--------------------------------------agregar filtros para ver si se dividen en escuela las funcionalidades o no--------------------------
'------------------------------------------------------------------------21/01/2005--------------------------------------------------------
'usuario_iniciado = negocio.obtenerUsuario
'pers_ncorr_temporal=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_iniciado&"'")
'tipo_permiso=conexion.consultaUno("select isnull(b.srol_npermiso,0) from sis_roles_usuarios a, sis_roles b where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.srol_ncorr=b.srol_ncorr")
'------------------------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------------------------

f_asig.carga_parametros "Contratacion_Detalle.xml", "asignatura"
if tipo_permiso="0" then
	formu_conectar.carga_parametros "Contratacion_Detalle.xml", "bloque_muestra"
else
	formu_conectar.carga_parametros "Contratacion_Detalle.xml", "bloque"
end if
profesores.carga_parametros "Contratacion_Detalle.xml", "bloque1"

f_asig.inicializar conexion
formu_conectar.inicializar conexion
profesores.inicializar conexion


sede=negocio.obtenerSede

'asignatura="select cast(a.asig_ccod as varchar)+'-'+ cast(secc_tdesc as varchar) + ' ' + cast(a.asig_tdesc as varchar) as Asignatura from asignaturas a, secciones b, sub_secciones c where a.asig_ccod=b.asig_ccod and b.secc_ccod=c.secc_ccod and c.ssec_ncorr="&subseccion&""
'f_asig.consultar asignatura
'f_asig.siguiente

'consulta="select distinct a.bloq_ccod as c_bloq_ccod, a.bloq_ccod ,a.bloq_finicio_modulo as Inicio,a.bloq_ftermino_modulo as Termino, d.sala_ciso, " & vbCrLf & _ 
'"d.sala_tdesc as sala, " & vbCrLf & _
'"protic.profesores_bloque(a.bloq_ccod) as profesor, b.pers_ncorr, " & vbCrLf & _
'"cast(g.asig_ccod as varchar)+' '+cast(g.asig_tdesc as varchar) as asignatura, " & vbCrLf & _
'"e.hora_ccod as hora, " & vbCrLf & _
'"h.dias_tdesc as Dia, h.dias_ccod, " & vbCrLf & _
'" case when a.pers_ncorr is null then 1 else 2 end as asig_docente, " & vbCrLf & _
'" cast(g.asig_tdesc as varchar) as asignatura2, " & vbCrLf & _
'" i.NIVE_CCOD, F.SECC_TDESC, " & vbCrLf & _
'" J.MODA_TDESC " & vbCrLf & _
'"    from  " & vbCrLf & _
'"    bloques_horarios a, BLOQUES_PROFESORES AA, " & vbCrLf & _
'"    personas b,  salas d, horarios e, secciones f, sub_secciones f1, asignaturas g, dias_semana h, malla_curricular I, " & vbCrLf & _
'"    MODALIDADES j " & vbCrLf & _
'"    where  a.pers_ncorr *=b.pers_ncorr " & vbCrLf & _
'"    and a.sala_ccod=d.sala_ccod " & vbCrLf & _
'"    and e.hora_ccod=a.hora_ccod " & vbCrLf & _
'"    and f.asig_ccod=g.asig_ccod " & vbCrLf & _
'"    and f.secc_ccod=f1.secc_ccod " & vbCrLf & _
'"    and a.ssec_ncorr=f1.ssec_ncorr " & vbCrLf & _
'"    and a.dias_ccod=h.dias_ccod " & vbCrLf & _
'"    and a.BLOQ_CCOD = AA.BLOQ_CCOD " & vbCrLf & _
'"    AND AA.PERS_NCORR =" & PERS_NCORR & vbCrLf & _
'"    AND f.secc_ccod = a.SECC_CCOD " & vbCrLf & _
'"    AND f.CARR_CCOD =" & carr_ccod & vbCrLf & _
'"    and f.sede_ccod="&sede&" " & vbCrLf & _
'"    and I.asig_ccod = f.asig_ccod " & vbCrLf & _
'"    AND J.MODA_CCOD = F.MODA_CCOD " & vbCrLf & _
'"	 order by asig_docente, h.dias_ccod, e.hora_ccod "

consulta="select distinct a.bloq_ccod as c_bloq_ccod, a.bloq_ccod ,a.bloq_finicio_modulo as Inicio,a.bloq_ftermino_modulo as Termino, d.sala_ciso, " & vbCrLf & _ 
"d.sala_tdesc as sala, " & vbCrLf & _
"protic.profesores_bloque(a.bloq_ccod) as profesor, b.pers_ncorr, " & vbCrLf & _
"cast(g.asig_ccod as varchar)+' '+cast(g.asig_tdesc as varchar) as asignatura, " & vbCrLf & _
"e.hora_ccod as hora, " & vbCrLf & _
"h.dias_tdesc as Dia, h.dias_ccod, " & vbCrLf & _
" case when a.pers_ncorr is null then 1 else 2 end as asig_docente, " & vbCrLf & _
" cast(g.asig_tdesc as varchar) as asignatura2, " & vbCrLf & _
" i.NIVE_CCOD, F.SECC_TDESC, " & vbCrLf & _
" J.MODA_TDESC " & vbCrLf & _
"    from " & vbCrLf & _
"    bloques_horarios a LEFT OUTER JOIN personas b " & vbCrLf & _
"    ON  a.pers_ncorr = b.pers_ncorr " & vbCrLf & _
"    INNER JOIN salas d " & vbCrLf & _
"    ON a.sala_ccod = d.sala_ccod " & vbCrLf & _
"    INNER JOIN horarios e " & vbCrLf & _
"    ON e.hora_ccod = a.hora_ccod " & vbCrLf & _
"    INNER JOIN secciones f " & vbCrLf & _
"    ON f.secc_ccod = a.SECC_CCOD AND f.CARR_CCOD =" & carr_ccod & " and f.sede_ccod ="&sede&" " & vbCrLf & _
"    INNER JOIN asignaturas g " & vbCrLf & _
"    ON f.asig_ccod = g.asig_ccod " & vbCrLf & _
"    INNER JOIN sub_secciones f1 " & vbCrLf & _
"    ON f.secc_ccod = f1.secc_ccod and a.ssec_ncorr = f1.ssec_ncorr " & vbCrLf & _
"    INNER JOIN dias_semana h " & vbCrLf & _
"    ON a.dias_ccod = h.dias_ccod " & vbCrLf & _
"    INNER JOIN BLOQUES_PROFESORES AA " & vbCrLf & _
"    ON a.BLOQ_CCOD = AA.BLOQ_CCOD AND AA.PERS_NCORR =" & PERS_NCORR & vbCrLf & _
"    INNER JOIN malla_curricular I " & vbCrLf & _
"    ON I.asig_ccod = f.asig_ccod " & vbCrLf & _
"    INNER JOIN MODALIDADES j " & vbCrLf & _
"    ON J.MODA_CCOD = F.MODA_CCOD  " & vbCrLf & _
"	 order by asig_docente, h.dias_ccod, e.hora_ccod "

'response.write("<pre>"&consulta&"</pre>")
'response.End()

formu_conectar.consultar consulta




'profesor="select protic.profesor_subseccion("&subseccion&") as docente"
'profesores.consultar profesor
'profesores.agregaCampoParam "docente", "filtro", "sede_ccod=" & negocio.obtenerSede
'profesores.siguiente

if tipo_permiso<>"1" then
	botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
	botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
end if

if formu_conectar.NroFilas = 0 then
	botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
end if

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

function persona(){
	var objExprRegular = new RegExp("docente","gi");
	nroElementos = document.persona.elements.length;
	profesor = "";
	for(i=0; i < nroElementos; i++) {
		if(objExprRegular.test(document.persona.elements[i].name)) {
			profesor = document.persona.elements[i].value;
		}
	}
	return(profesor);
}


function abrir(formulario) {
//subseccion = <%=subseccion%>;
//sede = <%=sede%>;
	docente = persona(formulario);
//	direccion="edicion_plan_acad.asp?ssec_ncorr="+subseccion+"&pers_ncorr=" + docente+"&sede_ccod="+sede + "&accion=A";
//	resultado=window.open(direccion, 'ventana1', "width=600 height=380, left=100, top=50, resizable,scrollbars=yes");
	//formulario.submit();
}


function enviar(formulario){
	formulario.action = 'plan_academica.asp';
  	formulario.submit();
 }

function enviar2(formulario) {
	if (confirm('¿Está seguro que desea eliminar los bloques seleccionados?')) {
	   formulario.action = 'borrar_bloque.asp';
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif','../images/eliminar2_f2_p.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr> 
                <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr> 
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
                <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td> 
                  <%pagina.DibujarLenguetas Array("Planificación Académica (Bloques Horarios) del Docente para esta Carrera"), 1%>
                </td>
                <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr> 
                <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <table width="98%" cellspacing="0" cellpadding="0">
                      <tr>
                        
                      <td width="100%" align="center"><div align="left"><strong> 
                          <%pagina.DibujarSubtitulo "Bloques Horarios Creados"%>
                          </strong><BR>
                        </div></td>
                      </tr>
                      <tr>
                        <td align="left">
                          <form name="persona" method="post" action="">
                            <table width="100%" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>&nbsp;</td>
                                <td align="left">&nbsp;</td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                                <td align="right"><input type="hidden" name="Carrera_ocul"  value="<%=request.QueryString("Carrera_ocul")%>"><!--Docente:-->
                                  <%'profesores.dibujaCampo("docente")%>
</td>
                              </tr>
                            </table>
                          </form>
                        </td>
                      </tr>
                      <tr align="left">
                        <td align="right"><strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp;
                            <%formu_conectar.accesoPagina%>
                            <strong> </strong></td>
                      </tr>
                      <tr>
                        <td align="left">
                          <form name="editar" method="post">
                            <%formu_conectar.dibujaTabla()%>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="javascript:enviar2(document.editar);" target="_top" onClick="MM_nbGroup('down','group1','eliminar2_p','',1)" onMouseOver="MM_nbGroup('over','eliminar2_p','../images/eliminar2_f2_p.gif','',1)" onMouseOut="MM_nbGroup('out')"><br>
                            </a></font>
                            <table width="7%" align="right" cellpadding="0" cellspacing="0">
                              <tr>
                                <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                  <%'botonera.dibujaboton "eliminar"%>
                                </font></td>
                                <td><%'botonera.dibujaboton "agregar"%>
                                </td>
                              </tr>
                            </table>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif"></font> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            <input type="hidden" name="seccion" value="<%=seccion%>">
                            <input type="hidden" name="sede" value="<%=sede%>">
                            </font><br>
                            <br>
                          </form>
                        </td>
                      </tr>
                    </table>
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
   </td>
  </tr>  
</table>
</body>
</html>
