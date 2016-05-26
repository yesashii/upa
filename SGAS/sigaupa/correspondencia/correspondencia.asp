<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_correlativo = Request.QueryString("corr_ncorr")

set pagina = new CPagina
pagina.Titulo = "Control de Correspondencia"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set botonera = new CFormulario
botonera.Carga_Parametros "correspondencia.xml", "botonera"
'---------------------------------------------------------------------------------------------------

v_registro	=conexion.consultaUno("select count(*) from correspondencia")+1
v_fecha		=conexion.consultauno("select protic.trunc(getdate())")

set formulario = new CFormulario
formulario.Carga_Parametros "correspondencia.xml", "f_nuevo"
formulario.Inicializar conexion

if v_correlativo <> "" then
	consulta = "select datediff(day,protic.trunc(corr_frecepcion),protic.trunc(getdate())) as dias_diferencia,corr_ncorr, " & vbCrLf &_
				" protic.trunc(corr_frecepcion) as corr_frecepcion,corr_desde,corr_para,corr_departamento,corr_contenido " & vbCrLf &_
				"  from correspondencia where corr_ncorr="&v_correlativo&" "

'	consulta = "select datediff(day,corr_frecepcion,getdate()) as dias_diferencia,corr_ncorr, " & vbCrLf &_
'				" protic.trunc(corr_frecepcion) as corr_frecepcion,corr_desde,corr_para,corr_departamento,corr_contenido " & vbCrLf &_
'				"  from correspondencia where corr_ncorr="&v_correlativo&" "

else  
	consulta = "select '' "
end if


formulario.Consultar consulta
formulario.Siguiente


if v_correlativo = "" then
	formulario.AgregaCampoCons "corr_frecepcion", v_fecha
end if



if v_correlativo <> "" then
	v_anterior= conexion.consultaUno ("select max(corr_ncorr) from correspondencia where corr_ncorr < "&v_correlativo&" ")
	v_siguiente= conexion.consultaUno ("select min(corr_ncorr) from correspondencia where corr_ncorr > "&v_correlativo&" ")
	v_registro=conexion.consultaUno("select count(*) from correspondencia where corr_ncorr <= "&v_correlativo&"")
'response.Write("<br> Anterior : <b>"&v_anterior&"</b>")
'response.Write("<br> Siguiente : <b>"&v_siguiente&"</b>")
'response.Write("<br> N° Registro : <b>"&v_registro&"</b>")
v_dias_diferencia=formulario.ObtenerValor("dias_diferencia")

	if v_dias_diferencia > 0 then
		formulario.AgregaCampoParam "corr_frecepcion","permiso", "Lectura"
		formulario.AgregaCampoParam "corr_desde","permiso", "Lectura"
		formulario.AgregaCampoParam "corr_para","permiso", "Lectura"
		formulario.AgregaCampoParam "corr_departamento","permiso", "Lectura"
		formulario.AgregaCampoParam "corr_contenido","permiso", "Lectura"
	end if

else
	v_anterior= conexion.consultaUno ("select max(corr_ncorr) from correspondencia ")
end if

%>


<html>
<head>
<title>Ingreso Correspondencia</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir_correspondencia()
{
  window.open("imprimir_correspondencia.asp","correspondencia");
}
</script>
</head>
<body  bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
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
    <td width="100%" valign="top" bgcolor="#EAEAEA">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td background="../imagenes/top_r1_c2.gif"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Ingreso correspondencia </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td ><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
					<td bgcolor="#D8D8DE" align="center"><%pagina.DibujarTituloPagina%></td>
					<td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				</tr>
				<tr>
				<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
				<td bgcolor="#D8D8DE" align="right">
					<table>
						<tr>
							<th>N° Registro :</th>
							<td><b><%=v_registro%></b></td>
						</tr>
					</table>
				</td>
				<td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				</tr>
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bordercolor="#FFFFFF" bgcolor="#D8D8DE">				    <br>					
					<form name="edicion">
					<%formulario.DibujaCampo("corr_ncorr")%>
					  <table width="100%" border="0" >
					  	<tr>
							<td><strong><font color="#FF0000">*</font> Fecha</strong></td>
							<td><div align="left"><strong>:</strong></div></td>
							<td><% formulario.DibujaCampo("corr_frecepcion")%>
						    (dd/mm/aaaa) </td>
                      	</tr>

					 	<tr>
							<td><strong><font color="#FF0000">*</font> Desde</strong></td>
							<td><div align="left"><strong>:</strong></div></td>
							<td><% formulario.DibujaCampo("corr_desde")%></td>
                      	</tr>
					  	<tr>
                          <td width="216"><strong><font color="#FF0000">*</font> A Sr (a) </strong></td>
                          <td width="10"><strong>:</strong></td>
                          <td width="555"><% formulario.DibujaCampo("corr_para")%></td>
                        </tr>
					  <tr> 
                        <td><strong><font color="#FF0000">*</font> Departamento</strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td><% formulario.DibujaCampo("corr_departamento")%></td>
                      </tr>
                      <tr> 
                        <td><strong><font color="#FF0000">* </font>Contenido</strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td> 
                          <% formulario.DibujaCampo("corr_contenido")%>  </td>
                      </tr>
                    </table>
			        </form>
				  <p align="right"><font color="#FF0000">*</font><font color="#0066FF">Campos obligatorios</font> </p>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>

              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="200" bgcolor="#D8D8DE"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
						  <td>
								<% 
								if v_anterior<>"" then
									botonera.AgregaBotonParam "anterior","url", "correspondencia.asp?corr_ncorr="&v_anterior&" "
								end if
								botonera.dibujaboton "anterior"%>
						  </td>
						  <td><%botonera.dibujaboton "guardar_correspondencia"%></td>
						  <td><%
								if v_siguiente<>"" then
									botonera.AgregaBotonParam "siguiente","url", "correspondencia.asp?corr_ncorr="&v_siguiente&" "
								end if
								botonera.dibujaboton "siguiente"%></td>
						  <td><%botonera.dibujaboton "imprimir"%></td>
						  <td><%botonera.dibujaboton "lanzadera"%></td>
                      </tr>
                    </table>
				  </td>
                  	<td  rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  	<td  rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"></td>
					<td  width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c5.gif"></td>                
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
<br/>
   </td>
  </tr>  
</table>
    </body>
</html>
