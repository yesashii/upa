<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pobe_ncorr=request.QueryString("pobe_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Asignar porcetaje de Beneficio"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



pers_ncorr = conexion.consultaUno("select pers_ncorr from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
nombre_alumno = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
ingresos = conexion.consultaUno("select pobe_ningreso_revisado from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
capacidad = conexion.consultaUno("select pobe_ncapacidad_pago from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "listado_postulaciones_becas.xml", "botonera"


'--------------Se debe buscar las propiedades que tenga la persona y mostrarlas en una lista----------------
if pobe_ncorr <> "" then
	consulta_postulaciones = "Select pobe_ncorr,pobe_nresolucion,protic.trunc(pobe_fobtencion) as pobe_fobtencion,pobe_nporcentaje_asignado,pobe_tsistesis" &_
                       " from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'"     

else
	consulta_postulaciones = "select ''"
end if
'response.Write(consulta_postulaciones)
set f_postulacion = new CFormulario
f_postulacion.Carga_Parametros "listado_postulaciones_becas.xml", "datos_asignacion"
f_postulacion.Inicializar conexion
f_postulacion.Consultar consulta_postulaciones
f_postulacion.siguiente

lenguetas_postulacion = Array("Asignación de porcentajes becas")

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function validar(formulario)
{ var valor_retorno=false;
 if ((formulario.elements["rol_propiedad"].value != "") && (formulario.elements["avaluo_propiedad"].value != ""))
  	valor_retorno= true;
 else if (formulario.elements["rol_propiedad"].value == "")
    { alert("no puede dejar el Rol de la propiedad sin ingresar");
	  formulario.elements["rol_propiedad"].focus();
	}
 else if (formulario.elements["avaluo_propiedad"].value == "")
    { alert("no puede dejar el Avalúo de la propiedad sin ingresar");
	  formulario.elements["avaluo_propiedad"].focus();
	}	

return valor_retorno;
}

function validaValor(valor)
{//alert("Entre "+valor);
if ((valor <=0)||(valor >100))
	{
	 alert("el valor ingresado no corresponde a un porcentaje válido(1-100)");	
	 document.edicion.elements["beca[0][pobe_nporcentaje_asignado]"].value="";
	}
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "beca[0][pobe_fobtencion]","1","edicion","fecha_oculta_inicio"
	calendario.FinFuncion
%>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="550"  border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 1
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "Asignación porcentaje Beneficio" %>
             </div>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                     
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                       	<tr>
                          <td width="20%"><strong>Rut</strong></td>
                          <td><strong>: </strong><%=rut%></td>
                        </tr>
						<tr>
                          <td width="20%"><strong>Nombre</strong></td>
                          <td><strong>: </strong><%=nombre_alumno%></td>
                        </tr>
						<tr>
                          <td width="20%"><strong>Ingreso L&iacute;quido</strong></td>
                          <td><strong>: </strong>$<%=ingresos%></td>
                        </tr>
						<tr>
                          <td width="20%"><strong>Capacidad</strong></td>
                          <td><strong>: </strong>$<%=capacidad%></td>
                        </tr>
						<tr>
                          <td colspan="2" align="center"><hr></td>
						</tr>
						<tr>
                          <td colspan="2"><strong><br></strong></td>
                       </tr>
                      </table>
                     </td>
                  </tr>
				  <br><br>
				  <tr>
                    <td>                     
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <form name="edicion">
						<tr>
                          <td width="23%"><strong>Resoluci&oacute;n</strong></td>
                          <td width="77%"><%f_postulacion.dibujacampo("pobe_nresolucion")%></td>
                        </tr>
						<tr>
                          <td width="23%"><strong>Porcentaje Asignado</strong></td>
                          <td width="77%"><%f_postulacion.dibujacampo("pobe_nporcentaje_asignado")%> <strong>(Ej 75)</strong></td>
                        </tr>
						<tr>
                          <td width="23%"><strong>Fecha</strong></td>
                          <td width="77%"><%f_postulacion.dibujacampo("pobe_fobtencion")%><%calendario.DibujaImagen "fecha_oculta_inicio","1","edicion" %>
                            (dd/mm/aaaa) </td>
                        </tr>
						<tr>
                          <td width="23%"><strong>S&iacute;ntesis Situaci&oacute;n Espec&iacute;fica</strong></td>
                          <td width="77%"><%f_postulacion.dibujacampo("pobe_tsistesis")%> <input type="hidden" name="pobe_ncorr" value="<%=pobe_ncorr%>"></td>
                        </tr>
						</form>
						<tr>
                          <td colspan="2"><strong>&nbsp;</strong></td>
                        </tr>
                      </table>
                     </td>
                  </tr>
                </table>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="27%" height="20"><div align="center">
              <table width="66%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cerrar")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="73%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
