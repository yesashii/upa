<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Agregar Requisitos"

'---------------------------------------------------------------------------------------------------
set botonera = new cFormulario
botonera.carga_parametros "agregar_requisito.xml", "btn_agregar_requisito"

'----------------------------------------------------------------------------------------------------------------------

nive_ccod = request.QueryString("nive_ccod")
plan_ccod=request.QueryString("plan")
espe_ccod=request.QueryString("esp")
carr_ccod=request.QueryString("carr_ccod")
mall_ccod=request.QueryString("mall_ccod")

'----------------------------------------------------------------------------------------------------------------------
set conectar   = new cconexion
set framos     = new cformulario
set fnegocio    = new cnegocio
'----------------------------------------------------------------------------------------------------------------------
conectar.inicializar "desauas"
'----------------------------------------------------------------------------------------------------------------------
fnegocio.inicializa conectar
'----------------------------------------------------------------------------------------------------------------------
framos.carga_parametros "agregar_requisito.xml", "agregar"
framos.inicializar conectar
'----------------------------------------------------------------------------------------------------------------------
consulta_ramos=" select  b.nive_ccod as nive_ccod, b.nive_ccod as nive_ccod_2, b.mall_ccod,b.plan_ccod as plan_ccod, " & vbCrLf &_
        	   " c.espe_ccod as espe_ccod ,a.asig_ccod as asig_ccod, " & vbCrLf &_
		       " a.asig_tdesc as asig_tdesc ,a.asig_nhoras as asig_nhoras , 0 as treq_ccod" & vbCrLf &_
               " from asignaturas a , malla_curricular b , planes_estudio c " & vbCrLf &_
               " where a.asig_ccod = b.asig_ccod" & vbCrLf &_
               " and b.plan_ccod=c.plan_ccod" & vbCrLf &_
               " and b.plan_ccod = '"&plan_ccod&"'" & vbCrLf &_ 
               " and c.espe_ccod = '"&espe_ccod&"' " & vbCrLf &_
               " and b.NIVE_CCOD <'"&nive_ccod&"'" & vbCrLf &_
			   " and b.mall_ccod not in (select mall_crequisito from requisitos " & vbCrLf &_
			   "                         where mall_crequisito = b.mall_ccod and mall_ccod='"& mall_ccod &"' ) " & vbCrLf &_
			   " order by nive_ccod"

framos.consultar consulta_ramos

'response.Write("<pre>"&framos.nrofilas&"</pre>")			   


'framos.siguiente
'----------------------------------------------------------------------------------------------------------------------
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
function enviar(formulario){
           /*window.opener.document.forms[0].action = 'actualizar_requisitos.asp';
		   window.opener.document.forms[0].submit();
		   window.close();*/
	  formulario.method="post";
	  formulario.action="actualizar_requisitos.asp";
	  formulario.submit();
	 	
	
}
function cerrar() {
	self.opener.location.reload()
	self.close();
}

function valida(boton) {
	formulario = document.buscador;
	nroElementos = formulario.elements.length;
	j=1;
	flag = true;
	for(i=0; i < nroElementos ; i++ ) {
		var expresion = new RegExp('(bloq_finicio_modulo|bloq_ftermino_modulo)','gi');
		if (expresion.test(formulario.elements[i].name) ) {
			switch(j%2) {
				case 1 :
					fechaInicio = formulario.elements[i].value;
					break;
				case 0 :
					fechaTermino = formulario.elements[i].value;
					if(!comparaFechas(fechaTermino,fechaInicio)) {
						flag=false;
					}
					break;
			}
			j++;
		}
	}
	if(!flag) {
		alert('Complete correctamente las fechas del formulario');
	}
	return(flag);
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

</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="731" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Agregar Requisitos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                        </div>
              <form name="buscador">
                    <table width="98%" align="center">
                      <tr> 
                        <td height="51" valign="top"> 
                          <%framos.dibujatabla%>
                        </td>
                      </tr>
                    </table>
                    <input name="nive_ccod" type="hidden" value="<%=nive_ccod%>">
                    <input name="plan_ccod" type="hidden" value="<%=plan_ccod%>">
                    <input name="carr_ccod" type="hidden" value="<%=carr_ccod%>">
                    <input name="espe_ccod" type="hidden" value="<%=espe_ccod%>">
                    <input name="mall_ccod" type="hidden" value="<%=mall_ccod%>">
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
                    <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><div align="center"></div></td>
                        <td><div align="center"> 
                            <%if (framos.nrofilas > 0) then
							 botonera.DibujaBoton "guardar"
							 end if%>
                          </div></td>
                        <td><div align="center"> 
                            <%botonera.DibujaBoton "salir"%>
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
