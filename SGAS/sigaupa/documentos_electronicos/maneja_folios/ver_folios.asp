<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/_negocio_MVC.asp" -->
<%
set pagina = new CPagina
pagina.Titulo = "Maneja Folios"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set botonera = new CFormulario
botonera.Carga_Parametros "folios.xml", "botonera"

set f_folios = new CFormulario
f_folios.Carga_Parametros "folios.xml", "f_folios"
f_folios.Inicializar conexion

sql_folios = "select * from folios_electronicos"

f_folios.Consultar sql_folios
f_folios.primero

'while f_folios.siguiente
'	foel_tname = f_folios.obtenervalor("foel_tname")
'	response.Write("f: "&foel_tname)
'wend
%>

<html>
<head>
<title>Ingresar Receptor Electronico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>
    
<script language="JavaScript">
function actualiza_folio(){
var form = document.forms["folios"];

//	alert(document.edicion.elements("doc_pend[4][ding_ndocto]").checked);
var conta = 0;
var tcom_tdesc;
msg_accion="actualizar";

//888888888888888888888888888888888888888888888888888888888888888888888888888

var check=document.folios.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
//var tabla = document.getElementById('tb_busqueda_detalle');

var Count = 0
for (y=0;y<check.length;y++){
	if (check[y].type=="checkbox"){
		checkbox[cantidadCheck++]=check[y];
	}
}
for (x=0;x<cantidadCheck;x++){
	if (checkbox[x].checked) {
	//alert(x)
		Count++;  
	}
}
//alert(Count);	 
if (Count==1)
	{
	
//888888888888888888888888888888888888888888888888888888888888888888888888888
	for (i=0;document.folios.elements[i];i++){
		if (document.folios.elements[i].type == "checkbox"){
			conta = conta + 1;
		}
	}	
//	alert(conta);
	for (i=0;i<conta;i++){
		//alert(i);
		if (document.folios.elements("folio["+i+"][foel_ccod]").checked){
				//alert("pasa if "+i);
				foel_ccod = document.folios.elements("folio["+i+"][foel_ccod]").value;
				foel_nini = document.folios.elements("folio["+i+"][foel_nini]").value;
				//document.folios.submit();
				//page = 'folios_proc.asp?foel_ccod='+foel_ccod+'&foel_nini='+foel_nini;
				//resultado = window.open(page,'ventana','resizable=yes; menubar = no; width=700; height=600; top = 0; left = 0');
				document.folios.method = "post";
				document.folios.action = "folios_proc.asp";
				document.folios.submit();
				//return true;
		}
	}
}
else if (Count==0){
	alert('Ud. no ha seleccionado ningún registro para '+ msg_accion +' ');
	return false;
}
else if (Count>1){
	alert('Atención: Solo puede elegir un registro a actualizar.');
	return false;
}

}
</script>
</head>

<body bgcolor="#EAEAEA" leftmargin="0" topmargin="5px" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../imagenes/botones/buscar_f2.gif','../../images/bot_deshabilitar_f2.gif','../../images/agregar2_f2_p.gif','../../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../../imagenes/botones/cargar_f2.gif','../../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	  <p><br>
	  </p>
	  <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td><img src="../../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td bgcolor="#D8D8DE"><%pagina.DibujarLenguetas Array("Resultados de la b&uacute;squeda"), 1 %></td>
              <td><img name="top_r2_c3" src="../../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">&nbsp;
                  <div align="center">
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <%pagina.DibujarSubtitulo "Folios Electronicos"%>
                  <br>
                  <form name="folios" method="post" action="folios_proc.asp" target="_blank">
                    <% f_folios.DibujaTabla() %>
                  </form>
                  <br></td>
                <td width="7" align="right" background="../../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="239" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="10%">&nbsp;</td>
                    <td width="8%"></td>
                    <td width="17%"></td>
                    <td width="26%">&nbsp;</td>
                    <td width="26%"></td>
                    <td width="27%"><div align="left">
                      <%botonera.DibujaBoton_MVC ("guardar")%>
                    </div></td>
                    <td width="12%"><div align="left">
                      <%botonera.DibujaBoton_MVC ("salir")%></td>
                  </tr>
                </table></td>
                <td width="417" rowspan="2" background="../../imagenes/abajo_r1_c4.gif"><p><img src="../../imagenes/abajo_r1_c3.gif" width="12" height="28"></p></td>
                <td width="10" rowspan="2" align="right" background="../../imagenes/abajo_r1_c4.gif"><img src="../../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table></td>
        </tr>
      </table>
	  <p>&nbsp;</p></td>
  </tr>
</table>
</body>
</html>
