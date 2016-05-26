<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

homo_ccod = request.querystring("homo_ccod")
homo_nresolucion = request.querystring("homo_nresolucion")
plan_destino = request.querystring("plan_destino")
plan_origen = request.querystring("plan_origen")

pagina.Titulo = "Mallas y Asignaturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_homologaciones_malla.xml", "botonera"
'----------------------------------------------------------------
set f_homo = new CFormulario
f_homo.Carga_Parametros "consulta.xml", "consulta"
f_homo.Inicializar conexion	
SQL = " Select homo_fresolucion,esho_tdesc,thom_tdesc,homo_nresolucion " & vbcrlf & _
    " from homologacion a, tipos_homologaciones b, estados_homologacion c " & vbcrlf & _
    " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "' and a.thom_ccod=b.thom_ccod " & vbcrlf & _
	" and a.esho_ccod=c.esho_ccod group by homo_nresolucion,homo_fresolucion,esho_tdesc,thom_tdesc "
f_homo.Consultar SQL
f_homo.Siguiente


'----------------------------------------------------------------
 set f_homo_fuente = new CFormulario
 f_homo_fuente.Carga_Parametros "m_homologaciones_malla.xml", "f_homologacion_fuente"
 f_homo_fuente.Inicializar conexion
 sql_fuente = " select rtrim(ltrim(a.asig_ccod)) as asig_ccod,rtrim(ltrim(a.asig_ccod)) as asig_ccod_fuente,a.asig_tdesc,b.mall_ccod,'" & homo_nresolucion & "' as homo_nresolucion from asignaturas a,malla_curricular b " & vbcrlf & _
			  "	where a.asig_ccod=b.asig_ccod and b.plan_ccod=" & plan_origen & " order by asig_tdesc "
'response.Write("<pre>"&consulta&"</pre>")
 f_homo_fuente.Consultar sql_fuente
		 
'---------------------------------------------------------------------------------------------------
 set f_homo_destino = new CFormulario
 f_homo_destino.Carga_Parametros "m_homologaciones_malla.xml", "f_homologacion_destino"
 f_homo_destino.Inicializar conexion
 sql_destino = " select rtrim(ltrim(a.asig_ccod)) as asig_ccod,rtrim(ltrim(a.asig_ccod)) as asig_ccod_destino,a.asig_tdesc,b.mall_ccod,'" & homo_nresolucion & "' as homo_nresolucion from asignaturas a,malla_curricular b " & vbcrlf & _
			  "	where a.asig_ccod=b.asig_ccod and b.plan_ccod=" & plan_destino & " order by asig_tdesc "
'response.Write("<pre>"&consulta&"</pre>")
 f_homo_destino.Consultar sql_destino

set f_asig_resolucion = new CFormulario
f_asig_resolucion.Carga_Parametros "m_homologaciones_malla.xml", "f_asig_resolucion"
f_asig_resolucion.Inicializar conexion
'SQL_asig_resolucion = " select a.homo_ccod,c.asig_ccod as asig_ccod_origen,b.asig_ccod as asig_ccod_destino, " & vbcrlf & _
'					  " (Select asig_tdesc from asignaturas where asig_ccod=c.asig_ccod) as asig_origen, " & vbcrlf & _
'		    		  " (Select asig_tdesc from asignaturas where asig_ccod=b.asig_ccod) as asig_destino " & vbcrlf & _
'					  "    from homologacion a, homologacion_destino b, homologacion_fuente c " & vbcrlf & _
'					  "    where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "' and a.homo_ccod=b.homo_ccod " & vbcrlf & _
'					  "    and a.homo_ccod=c.homo_ccod and b.homo_ccod=c.homo_ccod"
SQL_asig_resolucion = " select a.homo_ccod,c.asig_ccod as asig_ccod_origen,b.asig_ccod as asig_ccod_destino,c.asig_ccod, " & vbcrlf & _
					  " (Select asig_tdesc from asignaturas where asig_ccod=c.asig_ccod) as asig_origen, " & vbcrlf & _
		    		  " (Select asig_tdesc from asignaturas where asig_ccod=b.asig_ccod) as asig_destino " & vbcrlf & _
					  "    from homologacion a, homologacion_destino b, homologacion_fuente c " & vbcrlf & _
					  "    where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "' and a.homo_ccod=b.homo_ccod " & vbcrlf & _
					  "    and a.homo_ccod=c.homo_ccod and b.homo_ccod=c.homo_ccod"
f_asig_resolucion.Consultar SQL_asig_resolucion
mensaje_homo = "&nbsp;"
'response.Write(mensaje_homo)
session.timeout = 30
'response.Write(" tiempo de session" & session.timeout)
%>
<html>
<head>
<STYLE TYPE="text/css">
    .mensaje { position: absolute; top: 200px; left: 125px; width:250px; height:200px; visibility: visible;}
</STYLE>
<DIV ID="mensaje1" CLASS="mensaje">P&aacute;gina gener&aacute;ndose, espere un momento por favor... </DIV>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
var tabla_origen;
var tabla_destino;
function inicio()
{
   tabla_origen = new CTabla("homo");
   tabla_destino = new CTabla("homo_destino");
   //if	(mensaje1.style.visibility == "hidden")
   //		mensaje1.style.visibility = "visible";
}
function seleccionar()
{
var formulario = document.forms["origen_destino"];
//nro = formulario.elements.length;
for	(i = 0; i < tabla_origen.filas.length; i++) 
    {
	num_fuente = formulario.elements["homo[" + i + "][num_fuente]"].value;	     
	if	(num_fuente!="")
		formulario.elements["homo[" + i + "][asig_ccod]"].checked=true;	       	    
	else
		formulario.elements["homo[" + i + "][asig_ccod]"].checked=false;	       	    
	}
for	(i = 0; i < tabla_destino.filas.length; i++) 
    {
	num_destino = formulario.elements["homo_destino[" + i + "][num_destino]"].value;	     
	if	(num_destino!="")
		formulario.elements["homo_destino[" + i + "][asig_ccod]"].checked=true;	       	    
	else
		formulario.elements["homo_destino[" + i + "][asig_ccod]"].checked=false;	       	    
	}
	  
}
function verificar_seleccion()
{
var formulario = document.forms["origen_destino"];
nro = formulario.elements.length;
num_origen = 0;
num_destino = 0;
centinela = false;
if	(preValidaFormulario(formulario)==true) 
{
// Verifica que los numeros Origen posean pareja en Destino
for	 (i = 0; i < tabla_origen.filas.length; i++) 
     {
	 valor = formulario.elements["homo[" + i + "][asig_ccod]"].checked;	       	    
	 if	(valor == true) 
	  	{
		num_fuente = formulario.elements["homo[" + i + "][num_fuente]"].value;	     
		//}
	 	for	(x = 0; x < tabla_destino.filas.length; x++) 
     		{
			valor_d = formulario.elements["homo_destino[" + x + "][asig_ccod]"].checked;	       	    
			if	(valor_d == true) 
		  		{
				num_destino = formulario.elements["homo_destino[" + x + "][num_destino]"].value;
				//alert("destino:"+num_destino);
				if	(num_destino == num_fuente)     
					{
					centinela = true;
					}
				}
	 		}
		//}
	 	if (centinela==false) 
	 		{
			alert("Número o Números de Origen no poseen pareja en Destino.["+num_fuente+"]");
	 		return false		
			}
		}
	 centinela = false;
	 }
// Verifica que los numeros Destino posean pareja en Origen
for	 (x = 0; x < tabla_destino.filas.length; x++)
     {
	 valor = formulario.elements["homo_destino[" + x + "][asig_ccod]"].checked;	       	    
	 if	(valor == true) 
	  	{
		num_destino = formulario.elements["homo_destino[" + x + "][num_destino]"].value;	     
		//}
	 	for	(i = 0; i < tabla_origen.filas.length; i++) 
     		{
			valor_d = formulario.elements["homo[" + i + "][asig_ccod]"].checked;	       	    
			if	(valor_d == true) 
		  		{
				num_fuente = formulario.elements["homo[" + i + "][num_fuente]"].value;	
				if	(num_destino == num_fuente)
					{
					centinela = true;
					}
				}
	 		}
		//}
	 	if	(centinela==false) 
	 		{
			alert("Número o Números de Destino no poseen pareja en Origen. ["+num_destino+"]");
	 		return false;		
			}
	 	centinela = false;
		}
	 }
for	(x = 0; x < tabla_destino.filas.length; x++)
    {
	contador = 0;
	valor_d = formulario.elements["homo_destino[" + x + "][asig_ccod]"].checked;
	if	(valor_d == true) 
		{
		num_destino1 = formulario.elements["homo_destino[" + x + "][num_destino]"].value;
		//alert("destino:"+num_destino);
		for	(i = 0; i < tabla_destino.filas.length; i++)
    		{
			valor_d = formulario.elements["homo_destino[" + i + "][asig_ccod]"].checked;
			if	(valor_d == true) 
				{
				num_destino2 = formulario.elements["homo_destino[" + i + "][num_destino]"].value;
				if	(num_destino2 == num_destino1)
					{
					contador++; 
					}
				}
			}
		//alert(num_destino1 +"->["+contador+"]");
		if	(contador > 1)
			{
			alert("Número o números destino se encuentran repetidos.");
			return false;
			}
		}
	}
formulario.submit();
}	
//alert ("fin");
}
function verificar_seleccion2()
{
var formulario = document.forms["origen_destino"];
//alert("hola");
 nro = formulario.elements.length;
 num_origen = 0;
 num_destino = 0;


filas_origen = tabla_origen.filas.length;
filas_destino = tabla_destino.filas.length;
//alert("Origen:"+filas_origen+" Destino:"+filas_destino);
	 for (i = 0; i < tabla_origen.filas.length; i++) 
     {  	    
	  	valor = formulario.elements["homo[" + i + "][asig_ccod]"].checked;	     
		if	(valor == true) 
		  	{
			num_origen +=1;
			}
	 }
	 for (x = 0; x < tabla_destino.filas.length; x++) 
     {  	    
	  	valor = formulario.elements["homo_destino[" + x + "][asig_ccod]"].checked;	     
		if	(valor == true) 
		  	{
			num_destino +=1;
			}
	 }
	 if	((num_destino == 1) && (num_origen >= 1))	  	  
	 	{
		//alert("Origen :"+num_origen+" Destino :"+num_destino);
		formulario.submit();
		}
	 else
	 	{
		alert("Debe seleccionar una y solo una asignatura Destino. Y asignaturas origen pueden ser más de una.");
		//alert("Origen :"+num_origen+" Destino :"+num_destino);
		}
//formulario.submit();
}
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');inicio();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> 
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
            <td><%pagina.DibujarLenguetas Array("Detalle Homologación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="21%"><div align="left">N&ordm; Resoluci&oacute;n</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="75%" colspan="2"><strong><%=f_homo.ObtenerValor("homo_nresolucion") %></strong></td>
                              </tr>
							  <tr>
							  	<td><div align="left">Fecha Resoluci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td colspan="2"><strong><%=f_homo.ObtenerValor("homo_fresolucion")%></strong></td>
							  </tr>
							  <tr>
							  	<td><div align="left">Tipo Homologaci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td colspan="2"><strong><%=f_homo.ObtenerValor("thom_tdesc")%></strong></td>
							  </tr>
							  <tr>
							  	<td><div align="left">Estado Homologaci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td><strong><%=f_homo.ObtenerValor("esho_tdesc")%></strong></td>
								<td align="right"><%  botonera.agregabotonparam "cancelar", "accion", "JAVASCRIPT"
													  botonera.agregabotonparam "cancelar", "funcion", "CerrarActualizar()"	
						      botonera.DibujaBoton "cancelar"  %></td>
							  </tr>
                            </table>
                          </div></td>
                  <!--<td width="19%"><div align="center"><%'botonera.DibujaBoton "buscar"%></div></td>-->
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
	
	<br><!-- origen-->
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
            <td><%pagina.DibujarLenguetas Array("Origen y Destino"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">

                    <br>
                  </div>
              <form name="origen_destino" method="post" action="Proc_homologaciones_mallas_asignaturas_agregar.asp">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><input type="hidden" name="homo_nresolucion" value="<%=homo_nresolucion%>"><div align="center"> 
                            <%'pagina.DibujarTituloPagina%>
                            <br>
                                                 
							<table>
							<tr>
								<td><% pagina.Titulo = "Origen" 
								pagina.DibujarTituloPagina %></td>
								<td><% pagina.Titulo = "Destino" 
								pagina.DibujarTituloPagina %></td>								
							</tr>
							<tr>
								<td><div align="right">P&aacute;ginas:&nbsp;<%f_homo_fuente.AccesoPagina%></div></td>
								<td><div align="right">P&aacute;ginas:&nbsp;<%f_homo_destino.AccesoPagina%></div></td>
							</tr>
							<tr>
	                            <td><% f_homo_fuente.DibujaTabla()%></td>
								<td><% f_homo_destino.DibujaTabla()%></td>
							</tr>	
							</table>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% botonera.agregaBotonParam "guardar_nueva", "accion", "JAVASCRIPT"
							   botonera.agregaBotonParam "guardar_nueva", "funcion", "verificar_seleccion()"
							   botonera.agregaBotonParam "guardar_nueva", "formulario", "origen_destino"
							   botonera.agregaBotonParam "guardar_nueva", "url", "Proc_homologaciones_malla_orig_dest_agregar.asp"
							   botonera.dibujaBoton "guardar_nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if area_ccod <> "" then
							      botonera.AgregaBotonParam "eliminar_fuente" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar_fuente" , "deshabilitado", "TRUE"
							   end if
							   'botonera.AgregaBotonParam "eliminar", "url", "proc_homologacion_fuente_eliminar.asp" 
							   'botonera.DibujaBoton "eliminar_fuente"%>				  
                          </div></td>
                  <td><div align="center"><%'botonera.DibujaBoton "lanzadera"%></div></td>
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
      <br><br>	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Asignaturas Homologadas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">

                    <br>
                  </div>
              <form name="edicion_destino">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%'pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_asig_resolucion.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_asig_resolucion.DibujaTabla()%>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if	f_asig_resolucion.NroFilas() > 0 then 
								    botonera.AgregaBotonParam "eliminar_destino" , "deshabilitado", "FALSE"
							   else
							     	botonera.AgregaBotonParam "eliminar_destino" , "deshabilitado", "TRUE"
							   end if
							   botonera.agregaBotonParam "eliminar_destino", "url", "Proc_homologaciones_mallas_asignaturas_eliminar.asp"
							   botonera.agregaBotonParam "eliminar_destino", "formulario", "edicion_destino"
							   botonera.DibujaBoton "eliminar_destino"%>
                          </div></td>
                  <td><div align="center"><%'botonera.DibujaBoton "lanzadera"%></div></td>
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
    </table> </td>
  </tr>
</table>
<script language="JavaScript">
<!--
function ocultar_capa()
{
//alert("valor: "+mesaje1.style.visibility);
//if	(mensaje1.style.visibility == "visible")
	mensaje1.style.visibility = "hidden";
}
   var remainingseconds = <%response.Write(session.Timeout)%>*60;
   var url = "aviso_session.htm";
   var tid;
   var hWnd;
   var warn=0;

   function timeoutcheck () {
      remainingseconds=remainingseconds-1;
      if (remainingseconds>0) {
         tid=setTimeout("timeoutcheck()", 1*1000);
         if (remainingseconds<125) {
            if (remainingseconds>120) {
               window.defaultStatus="tiempo sesión : "+ (remainingseconds-5) +" segundos";
            } else if (remainingseconds>=5) {
               window.defaultStatus="tiempo sesión : "+ (remainingseconds-5) +" segundos";
            }
            if (!warn) {
               warn=1;
               
               hWnd = window.open(url,"_timeoutwarning","width=250,height=80,resizable=no,scrollbars=no");
               hWnd.focus();
            }
         }
      } else {
         window.defaultStatus="tiempo de sesión terminado";
         clearTimeout(tid);
      }
   }

   function sessioncheck () {
      if (remainingseconds>0) {
         return true;
      } else {
         alert("Sorry, your session is timeouted, please login again.");
         return false;
      }
   }

timeoutcheck();	
ocultar_capa();	
//-->
</script>
</body>
</html>