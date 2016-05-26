<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
rut	=	request.querystring("rut")
dv	=	request.querystring("dv")

set pagina          = new cpagina
set	negocio			=	new cnegocio
set conectar		=	new cconexion
set tabla_desbloqueo	= new cformulario
set botonera        =  new CFormulario

conectar.inicializar	"upacifico"
negocio.inicializa		conectar

botonera.carga_parametros "f_desbloqueos.xml", "btn_f_desbloqueos"

tabla_desbloqueo.inicializar		conectar
tabla_desbloqueo.carga_parametros	"f_desbloqueos.xml","tabla_desbloqueos"



cons_tabla = "select d.sede_tdesc,b.bloq_ncorr,b.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv  as rut " & vbCrLf &_
				"    , a.pers_tape_paterno + ' ' +   a.PERS_TAPE_MATERNO + ' ' + a.pers_tnombre as nombre " & vbCrLf &_
				"    , case b.bloq_nresolucion" & vbCrLf &_
				"        when null then '-'" & vbCrLf &_
				"        else b.bloq_nresolucion" & vbCrLf &_
				"        end as bloq_nresolucion" & vbCrLf &_
				"    ,case convert(varchar,b.bloq_fresolucion,103)" & vbCrLf &_
				"        when null then '-'" & vbCrLf &_
				"        else convert(varchar,b.bloq_fresolucion,103)" & vbCrLf &_
				"        end as  bloq_fresolucion" & vbCrLf &_
				"    ,convert(varchar,b.bloq_fbloqueo,103) as bloq_fbloqueo,convert(varchar,b.bloq_fbloqueo,103) as fbloqueo" & vbCrLf &_
				"    ,c.tblo_tdesc,b.bloq_tobservacion,b.tblo_ccod,b.eblo_ccod " & vbCrLf &_
				" from personas a,bloqueos b,tipos_bloqueos c,sedes d" & vbCrLf &_
				" where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
				"    and b.tblo_ccod = c.tblo_ccod" & vbCrLf &_
				"    and b.sede_ccod = d.sede_ccod" & vbCrLf &_
				"    and b.eblo_ccod in (1) " & vbCrLf &_
				"    and cast(a.pers_nrut as varchar) ='"& rut &"' " & vbCrLf &_
				"    and a.pers_xdv='"& dv &"'"

'response.Write("<pre>"&cons_tabla&"</pre>")
'cons_tabla="select ''"
tabla_desbloqueo.consultar	cons_tabla
'response.end()

registros	=	conectar.consultauno("select count(*) ("&cons_tabla&")")

alumno	=	conectar.consultauno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno from personas where cast(pers_nrut as varchar) = '"& rut &"'")
'response.End()
 
%>

<html>
<head>
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<title>Activar Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--


function agregar(formulario){
	resultado=window.open("",'ventana1','width=750, height=200');
	formulario.target="ventana1";
	formulario.action="agregar_bloqueo.asp";
	formulario.submit();
}

function guardar(formulario){
	if (revisa_form(formulario)){
		formulario.action='actualizar_bloqueos.asp'
		formulario.submit();
	}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("reso_ncorr","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c<=0) {
		check = 0;
	}
	else {
		if (c > 1){
			check=2;
		}
		else{
			if (c==1){
				check=1;
			}
		}
	}
	return(check);
}
function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'desbloqueos.asp';
			formulario.submit();
		}
}

function activar(formulario){
	if (verifica_check(formulario)==1){
		formulario.action='activar_compromisos.asp';
		formulario.submit();
	}
	else {
		if (verifica_check(formulario)==2){
			alert('No puede seleccionar mas de un documento para activar.');
		}
		else {
			if ((verifica_check(formulario)==0)){
				alert('No ha seleccionado ningún documento para activar.');
			}
		}
	}
	
}

function revisa_form(formulario){
	elementos=formulario.elements.length;
	for (i=0;i<elementos;i++){
		nombre =  formulario.elements[i].name;
		var campos=new RegExp ("bloq_ncorr","gi");
		if (campos.test(nombre)){
			if (formulario.elements[i].checked==true ){
						if (formulario.elements[i+1].value==''){
							alert('No puede dejar este campo vacío.');
							formulario.elements[i+1].focus();
							return (false);
						}
						else {
							if (!isInteger(formulario.elements[i+1].value)){
								alert('Ingrese un número entero válido.');
								formulario.elements[i+1].focus();
								return (false);
							}
							else{
								if (formulario.elements[i+2].value=='' ){
									alert('No puede dejar este campo vacío.');
									formulario.elements[i+2].focus();
									return (false);
								}
								else {
									if (!isFecha(formulario.elements[i+2].value)){
										alert('Ingrese un formato de fecha válido (dd/mm/aaaa) .');
										formulario.elements[i+2].focus();
										return (false);
									}
									else {
										if(!comparaFechas(formulario.elements[i+2].value,formulario.elements[i+3].value)){
											alert('Las fecha de resolución debe ser mayor a la fecha de bloqueo.');
											formulario.elements[i+2].focus();
											return (false);
										}
									}
								}
							}
						}
			  }
			
		}//if
	}//for
	return(true);
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
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="6" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="152" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador de Alumnos</font></div></td>
                    <td width="46" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="466" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
		   <form action="" method="get" name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp;<strong> 
                                <input type="text" name="rut" size="10" maxlength="8" id="rut" value="<%=rut%>">
                                - 
                                <input type="text" name="dv" size="2" maxlength="1" value="<%=dv%>" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();">
                                </strong><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><strong> 
                                </strong></font></div>
                              <div align="center"></div></td>
                          </tr>
                        </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.dibujaboton "buscar"%>
                      </div></td>
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
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="122" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          de Bloqueos</font></div></td>
                      <td width="535" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  
                <td bgcolor="#D8D8DE"> &nbsp; <form name="editar" method="post">
                    <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
                      <tr> 
                        <td align="left"> 
                          <%if rut <> "" then%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td colspan="3">Resultado de la b&uacute;squeda:</td>
                            </tr>
                            <tr> 
                              <td width="9%">&nbsp;</td>
                              <td width="1%">&nbsp;</td>
                              <td width="90%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td nowrap><strong>RUT</strong></td>
                              <td nowrap><strong>:</strong></td>
                              <td nowrap><strong><%=rut%>-<%=dv%></strong></td>
                            </tr>
                            <tr> 
                              <td nowrap><strong>NOMBRE</strong></td>
                              <td nowrap><strong>:</strong></td>
                              <td nowrap><strong><%=alumno%></strong></td>
                            </tr>
                          </table>
                          <%
					  else
							response.Write("Ingrese el Rut del alumno que desea consultar.")
					  end if
					  %>
                          <br> <br> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td align="center"><strong>LISTADO DE BLOQUEOS ACTIVOS 
                                </strong></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <%if tabla_desbloqueo.nrofilas > 0 then%>
                                <strong>Páginas: 
                                <%tabla_desbloqueo.accesoPagina()%>
                                </strong> 
                                <% end if %>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td align="center"> 
                                <%tabla_desbloqueo.dibujatabla()%>
                                <input type="hidden" name="registros" value="<%=registros%>"> 
                                <input type="hidden" name="rut2" value="<%=rut%>">	
                              </td>
                            </tr>
                          </table>
                          * Debe seleccionar el o los bloqueos, completar el o 
                          los Nros. y Fechas de Resoluci&oacute;n y presionar 
                          el bot&oacute;n <em>&quot;Guardar&quot;</em> para debloquear.<br>
                         
                          <table width="1%" align="right" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td>&nbsp;</td>
                              <td width="5%"> 
                                <%botonera.dibujaboton "guardar"%>
                              </td>
                            </tr>
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
                  <td width="104" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center"></div></td>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="258" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
