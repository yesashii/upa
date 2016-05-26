<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set CErrore= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new CPagina
pagina.Titulo = "Encuestas"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_satifaccion.xml", "botonera"


set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "encuesta_satifaccion.xml", "encuesta"
f_encuesta.Inicializar conexion

'  "select area_proc,nom_proy,res_peti, isnull(b.ensa_ncorr,0)as ensa_ncorr"& vbCrLf &_
'			"from registro_encuesta_satisfaccion a"& vbCrLf &_
'			"left outer join encuesta_satisfaccion b"& vbCrLf &_
'			"on a.ensa_ncorr=b.ensa_ncorr"& vbCrLf &_
'			"order by a.AUDI_FMODIFICACION desc"
			
			
	consulta ="select REES_NCORR,area_proc,nom_proy,res_peti, case when b.ensa_ncorr is null then "&CHR(039)&"<img src="&CHR(034)&"../encu_satisfaccion/Images/No.png"&CHR(034)&" height="&CHR(034)&"40"&CHR(034)&" width="&CHR(034)&"40"&CHR(034)&"/>"&CHR(039)&" else "&CHR(039)&" <img src="&CHR(034)&"../encu_satisfaccion/Images/Si.png"&CHR(034)&" height="&CHR(034)&"40"&CHR(034)&" width="&CHR(034)&"40"&CHR(034)&"/>"&CHR(039)&" end as ensa_ncorr"& vbCrLf &_
			"from registro_encuesta_satisfaccion a"& vbCrLf &_
			"left outer join encuesta_satisfaccion b"& vbCrLf &_
			"on a.ensa_ncorr=b.ensa_ncorr"& vbCrLf &_
			"order by a.AUDI_FMODIFICACION desc"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encuesta.Consultar consulta



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Validar_marcaje(){
//alert(dcur_ncorrM);


 nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		 //alert(num);
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ninguna encuesta');
	  return false;

   }
   else if( num > 1 )
   {
   alert('Puede seleccionar solo una encuesta');
   	return false;
   }
   else if( num == 1 )
   {
   //alert('se va')
   	return true;
   }	


}

</script>
</head>

<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Encuesta de Satisfación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
			  </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Encuestas Enviadas"%>
					
                      <table width="98%"  border="0" align="center">
					        <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_encuesta.accesopagina%>                             </td>
                            </tr>
                            <tr>						
                                <td align="center"><%f_encuesta.DibujaTabla()%></td>
						  
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
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton("reenviar")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	</td>
  </tr>
</table>
</body>

</html>
