<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Listado de Preguntas" 


encu_ncorr = request.querystring("encu_ncorr")
crit_ncorr = request.QueryString("crit_ncorr")
preg_ncorr = request.QueryString("preg_ncorr")
'--------------------------------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

nombre_encuesta=conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
nombre_criterio=conectar.consultaUno("Select crit_tdesc from criterios where cast(crit_ncorr as varchar)='"&crit_ncorr&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")


set negocio = new CNegocio
negocio.Inicializa conectar

set botonera = new CFormulario
botonera.Carga_Parametros "m_preguntas2.xml", "botonera"
'-------------------------------------------------------------------------------

set f_preguntas = new CFormulario
f_preguntas.Carga_Parametros "m_preguntas2.xml", "f_preguntas"
f_preguntas.Inicializar conectar

  sql = "SELECT '"&crit_ncorr&"' as crit_ncorr ,'<a href=""javascript:editar('+cast(a.preg_ncorr as varchar)+')"">'+ cast(a.preg_ccod as varchar)+ '</a>' as preg_ccod,a.preg_ncorr,a.preg_tdesc,a.preg_norden "& vbcrlf & _		
		"FROM preguntas a "& vbcrlf & _
		"WHERE cast(a.crit_ncorr as varchar)= '"&crit_ncorr&"' ORDER BY a.preg_norden ASC" 
        if crit_ncorr <> "" then
		 f_preguntas.Consultar sql		 
	    else
		 f_preguntas.consultar "select '' from sexos where 1 = 2"
	    end if


set f_nueva = new cformulario
f_nueva.carga_parametros "m_preguntas2.xml", "f_nueva"
f_nueva.inicializar conectar
 if preg_ncorr <> "" then
   sql2 ="Select a.preg_ncorr, a.preg_ccod, a.preg_tdesc, a.preg_norden from preguntas a where cast(preg_ncorr as varchar)= '" & preg_ncorr & "' and cast(crit_ncorr as varchar)='"&crit_ncorr&"'"
 else
   sql2 = "select '' as preg_ccod "
 end if
f_nueva.consultar sql2
f_nueva.Siguiente
%>
<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
function Salir()
{ 
  window.close();
}

var tabla;

function inicio()
{
   var cantidad;
   tabla = new CTabla("solicitudes");  
   if (tabla.filas.length == 1 )
   {
     document.edicion.elements["solicitudes[0][soli_ncorr]"].checked=true;
	 seleccionar(document.edicion.elements["solicitudes[0][soli_ncorr]"]);	
   }   
}


function editar(valor){
    var crit;
	var encu;
	var url;
	crit=<%=crit_ncorr%>;
	encu=<%=encu_ncorr%>;

	url="m_preguntas2.asp?preg_ncorr="+valor+"&crit_ncorr="+crit+"&encu_ncorr="+encu;
	//alert("destino "+ url);
	location.href =url;
}

function agregar(){
    var crit;
	var encu;
	crit=<%=crit_ncorr%>;
	encu=<%=encu_ncorr%>;
    //irA("edita_preguntas.asp?preg_ncorr="+ valor +"&crit_ncorr="+crit, "1", 700, 420)
	location.href ="m_preguntas2.asp?crit_ncorr="+crit+"&encu_ncorr="&encu;
	document.edicion.elements["preg_ccod"].focus();
}

function validar()
{
  if (document.edicion.elements["preg_ccod"].value != "")
   {
      if (document.edicion.elements["preg_tdesc"].value != "")
       {
	      if (document.edicion.elements["preg_norden"].value != "")
     	   {
            		  codigo= document.edicion.elements["preg_ccod"].value;
					  texto = document.edicion.elements["preg_tdesc"].value;
					  orden = document.edicion.elements["preg_norden"].value;
					  encu_ncorr = '<%=encu_ncorr%>';
					  preg_ncorr = '<%=preg_ncorr%>';
					  crit_ncorr = '<%=crit_ncorr%>';
					
					  url = "Proc_Editar_preguntas2.asp?preg_ccod=" + codigo + "&preg_tdesc=" + texto + "&preg_norden=" + orden +"&encu_ncorr=" + encu_ncorr + "&preg_ncorr=" + preg_ncorr+ "&crit_ncorr=" + crit_ncorr;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();
         }
   		else
  	   { alert("Ingrese un número de orden correcto"); document.edicion.elements["preg_norden"].focus();}
	 }
   	else
    { alert("Ingrese el un texto descriptivo de la Pregunta"); document.edicion.elements["preg_tdesc"].focus();}
  }
  else
  { alert("Ingrese el código de la pregunta"); document.edicion.elements["preg_ccod"].focus();}
}
</script>

<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> 
	 <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="530" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
         </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
                <form action="JAVASCRIPT:Enviar();" method="post" enctype="multipart/form-data" name="edicion" id="edicion">
                      <table width="100%" border="0">
					  <div align="center"><font size="2" face="Arial, Helvetica, sans-serif"><strong>CREACIÓN Y MODIFICACIÓN</strong></font></div>
                      <BR>
                        <tr> 
                          <td width="18%"><div align="right">C&oacute;digo<strong><font color="#FF0000"> 
                              </font></strong></div></td>
                          <td width="3%"><div align="center">:</div></td>
                          <td width="79%" colspan="2"><input name="preg_ccod" type="text" value='<%=f_nueva.obtenerValor("preg_ccod")%>' size="15" maxlength="10"> 
                          </td>
                        </tr>
                        <tr> 
                          <td height="44"><div align="right">Texto</div></td>
                          <td><div align="center">:</div></td>
                          <td colspan="2"><textarea name="preg_tdesc" cols="70" rows="2" id="preg_tdesc"><%=f_nueva.obtenerValor("preg_tdesc")%></textarea> 
                          </td>
                        </tr>
                        <tr> 
                          <td height="21"><div align="right">Orden</div></td>
                          <td><div align="center">:</div></td>
                          <td> <input name="preg_norden" type="text" id="preg_norden" size="4" maxlength="3" value='<%=f_nueva.obtenerValor("preg_norden")%>'> 
                          </td>
						  <td><%botonera.DibujaBoton "grabar"%>
                          <%botonera.DibujaBoton "cerrar_actualizar"%>	</td>
                        </tr>
                      </table>
                </form>
            </div>
           </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="530" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
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
              
           </table>
			
              <div align="center"> <%pagina.DibujarTituloPagina%></div>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td width="75%"> <table width="100%" border="0" align="center">
                               <tr> 
                                <td width="32%"><strong><%=nombre_encuesta%>/<%=nombre_criterio%>/
								Preguntas</strong></td>
                              </tr>
                              
                            </table></td>
                          <td width="25%"> 
                          </td>
                        </tr>
                      </table>
                   
					
                    <form name="f_preguntas">
                      <table width="98%" border="0">
                        <tr> 
                          <td> <div align="right">Página 
                              <%f_preguntas.AccesoPagina%>
                            </div></td>
                        </tr>
                      </table>
                      <div align="center"> 
                        <% f_preguntas.dibujatabla  %>
                        <table width="98%" border="0">
                          <tr> 
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                      </div>
                    </form>
					
            </div>
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <% botonera.dibujaBoton "eliminar"  %>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "cerrar_actualizar"%>
                          </div></td>
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
      <br> </td>
  </tr>
</table>
</body>
</html>
