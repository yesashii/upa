<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_secc_ccod = Request.QueryString("secc_ccod")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Editar sección"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "actualizacion_secciones.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_seccion = new CFormulario
f_seccion.Carga_Parametros "actualizacion_secciones.xml", "editar_seccion"
f_seccion.Inicializar conexion

consulta = "select a.secc_ccod, a.carr_ccod, a.asig_ccod, a.secc_tdesc, b.carr_tdesc, rtrim(ltrim(cast(c.asig_ccod as varchar))) + ' - ' + c.asig_tdesc as asignatura, " & vbCrLf &_
           "       a.secc_con_examen, replace(cast(a.secc_nota_presentacion as decimal(2,1)),',','.') as secc_nota_presentacion, " & vbCrLf &_
		   "	   a.secc_porcentaje_presentacion,  " & vbCrLf &_
		   "	   a.secc_eval_mini,  " & vbCrLf &_
		   "	   a.secc_porce_asiste,  " & vbCrLf &_
		   "	   replace(cast(a.secc_nota_ex as decimal(2,1)),',','.') as secc_nota_ex,  " & vbCrLf &_
		   "	   replace(cast(a.secc_min_examen as decimal(2,1)),',','.') as secc_min_examen,  " & vbCrLf &_
		   "	   a.secc_eximision " & vbCrLf &_
		   "from secciones a, carreras b, asignaturas c  " & vbCrLf &_
		   "where a.carr_ccod = b.carr_ccod " & vbCrLf &_
		   "  and a.asig_ccod = c.asig_ccod " & vbCrLf &_
		   "  and cast(a.secc_ccod as varchar)= '" & q_secc_ccod & "'"
'response.Write("<pre>"&consulta&"</pre>")
f_seccion.Consultar consulta

con_examen = conexion.consultaUno("select secc_con_examen from secciones where cast(secc_ccod as varchar)='"&q_secc_ccod&"'")

if con_examen = "N" then
	f_seccion.agregaCampoParam "secc_nota_presentacion", "deshabilitado", "TRUE"
	f_seccion.agregaCampoParam "secc_nota_presentacion", "id", "NT-S"
	f_seccion.agregaCampoParam "secc_porcentaje_presentacion", "deshabilitado", "TRUE"
	f_seccion.agregaCampoParam "secc_porcentaje_presentacion", "id" , "NU-S"
    f_seccion.agregaCampoParam "secc_eval_mini", "deshabilitado", "TRUE"
	f_seccion.agregaCampoParam "secc_eval_mini", "id", "NU-S"
	'f_seccion.agregaCampoParam "secc_porce_asiste", "deshabilitado", "TRUE"
	'f_seccion.agregaCampoParam "secc_porce_asiste", "id", "NU-S"
	f_seccion.agregaCampoParam "secc_min_examen", "deshabilitado", "TRUE"
	f_seccion.agregaCampoParam "secc_min_examen", "id","NT-S"
	f_seccion.agregaCampoParam "secc_nota_ex", "deshabilitado", "TRUE"
	f_seccion.agregaCampoParam "secc_nota_ex", "id", "NT-S"
end if

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
function ValidarFormulario()
{
	var v_secc_porcentaje_presentacion = parseFloat(t_seccion.ObtenerValor(0, "secc_porcentaje_presentacion"));
	var v_secc_porce_asiste = parseFloat(t_seccion.ObtenerValor(0, "secc_porce_asiste"));
		
	if ((v_secc_porcentaje_presentacion < 0) || (v_secc_porcentaje_presentacion > 100)) {
		t_seccion.filas[0].campos["secc_porcentaje_presentacion"].objeto.select();
		alert('Ingrese un porcentaje de presentación entre 0 y 100.');		
		return false;
	}
		
	if ((v_secc_porce_asiste < 0) || (v_secc_porce_asiste > 100)) {
		t_seccion.filas[0].campos["secc_porce_asiste"].objeto.select();
		alert('Ingrese un porcentaje de asistencia entre 0 y 100.');		
		return false;
	}
		
	return true;
}


var t_seccion;
function Inicio()
{
	t_seccion = new CTabla("secciones");
}

function deshabilitar(valor)
{   var formulario= document.edicion;
    if (valor=='N')
	{
		formulario.elements["secciones[0][secc_nota_presentacion]"].disabled = true;
		formulario.elements["secciones[0][secc_nota_presentacion]"].value="";
		formulario.elements["secciones[0][secc_nota_presentacion]"].id = "NT-S";
		formulario.elements["secciones[0][secc_porcentaje_presentacion]"].disabled = true;
		formulario.elements["secciones[0][secc_porcentaje_presentacion]"].value="";
		formulario.elements["secciones[0][secc_porcentaje_presentacion]"].id = "NU-S";
        formulario.elements["secciones[0][secc_eval_mini]"].disabled = true;
        formulario.elements["secciones[0][secc_eval_mini]"].value="";
		formulario.elements["secciones[0][secc_eval_mini]"].id = "NU-S";
		formulario.elements["secciones[0][secc_min_examen]"].disabled = true;
		formulario.elements["secciones[0][secc_min_examen]"].value="";
		formulario.elements["secciones[0][secc_min_examen]"].id = "NT-S";
		formulario.elements["secciones[0][secc_eximision]"].disabled = true;
		formulario.elements["secciones[0][secc_nota_ex]"].disabled = true;
		formulario.elements["secciones[0][secc_nota_ex]"].value="";
		formulario.elements["secciones[0][secc_nota_ex]"].id = "NT-S";
		
	}
	else
	{
		formulario.elements["secciones[0][secc_nota_presentacion]"].disabled = false;
		formulario.elements["secciones[0][secc_nota_presentacion]"].id = "NT-N";
		formulario.elements["secciones[0][secc_porcentaje_presentacion]"].disabled = false;
		formulario.elements["secciones[0][secc_porcentaje_presentacion]"].id = "NU-N";
        formulario.elements["secciones[0][secc_eval_mini]"].disabled = false;
		formulario.elements["secciones[0][secc_eval_mini]"].id = "NU-N";
		formulario.elements["secciones[0][secc_min_examen]"].disabled = false;
		formulario.elements["secciones[0][secc_min_examen]"].id = "NT-N";
		formulario.elements["secciones[0][secc_eximision]"].disabled = false;
		formulario.elements["secciones[0][secc_nota_ex]"].disabled = false;
		formulario.elements["secciones[0][secc_nota_ex]"].id = "NT-N";
	}
	//alert("presionaoooooooo? "+valor);
}

function deshabilitar_01(valor)
{   var formulario= document.edicion;
    if (valor=='N')
	{
		formulario.elements["secciones[0][secc_nota_ex]"].disabled = true;
		formulario.elements["secciones[0][secc_nota_ex]"].id = "NT-S";
		
	}
	else
	{
		formulario.elements["secciones[0][secc_nota_ex]"].disabled = false;
		formulario.elements["secciones[0][secc_nota_ex]"].id = "NT-N";
	}
	//alert("presionaoooooooo? "+valor);
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Editar sección"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Sección"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <th scope="col"><%f_seccion.DibujaRegistro%></th>
                        </tr>
                      </table></td>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
