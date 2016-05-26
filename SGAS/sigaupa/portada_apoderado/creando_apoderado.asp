<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")

set pagina = new CPagina
pagina.Titulo = "Cambiando Estado a Apoderado"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "creando_apoderado.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "creando_apoderado.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "PERS_TEMAIL",q_pers_temail
f_busqueda.AgregaCampoCons "PERS_NCORR",q_PERS_NCORR
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

verifica_rut = conexion.ConsultaUno("select count(*) from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

existe_correo = conexion.ConsultaUno("select PERS_TEMAIL from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

'response.Write(existe_correo)

if q_pers_nrut <> ""  then
'---------------------------------------------------------------------------------------------------

if verifica_rut=0 then
session("mensaje_error") = "El Rut no esta registrado."
end if

set formulario = new CFormulario
formulario.Carga_Parametros "creando_apoderado.xml", "datos_alumno"
formulario.Inicializar conexion
sql_comentarios ="Select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where pers_nrut="&q_pers_nrut
'response.write sql_comentarios
formulario.Consultar sql_comentarios
formulario.Siguiente
'response.End()
'---------------------------------------------------------------------------------------------------
set datos = new CFormulario
datos.Carga_Parametros "creando_apoderado.xml", "detalle_ingreso"
datos.Inicializar conexion

consulta_usuario="select PERS_NCORR, protic.obtener_rut(pers_ncorr) AS RUT, PERS_TEMAIL " & vbCrLf &_
"from personas " & vbCrLf &_
"where PERS_NRUT = " & q_pers_nrut 
'response.write consulta_usuario
datos.Consultar consulta_usuario
datos.siguiente
q_pers_ncorr = datos.obtenerValor("pers_ncorr")
q_pers_temail = datos.obtenerValor("PERS_TEMAIL")

'response.Write(PERS_NCORR)
'response.End()
'--------------------------------------------------------------------------------------------------


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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function validaCheckbox()
{
	
	if (document.getElementById("cambioEmail").checked)
	
  {
	  document.getElementById("HOLA").style.display='';
	  document.edicion.elements['buscador[0][PERS_TEMAIL]'].value = ""
	 
	  
	  
  }
  else
  {
	  document.getElementById("HOLA").style.display='none';
	  
  }
  return true;
 }

function enviaproc()
{
PERS_TEMAIL='<%=q_pers_temail%>';
//alert(PERS_TEMAIL);

PERS_TEMAIL2 = document.getElementsByName('buscador[0][PERS_TEMAIL]')[0].value;
//alert(PERS_TEMAIL2);
if (PERS_TEMAIL2 != ""){
	PERS_TEMAIL = PERS_TEMAIL2;
}




pers_nrut='<%=q_pers_nrut%>';
pers_xdv='<%=q_pers_xdv%>';
PERS_NCORR='<%=q_PERS_NCORR%>';

pagina="proc_creando_apoderado.asp?pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&pers_temail="+PERS_TEMAIL+"&PERS_NCORR="+PERS_NCORR+"";


window.open(pagina, "ventana1" , "width=1024,height=850,scrollbars=YES,resizable =YES,location=0,left=300,top=200");


window.opener.location.reload();
}

function validarEmail(email) {
    expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if (!expr.test(email))
        alert("Error: La dirección de correo " + email + " es incorrecta.");
	}

function ValidaValoresIngreso()
{
	
sumaValorModificado = 0
sumavalorBaseDatos = 0
contador_fila = '<%=contador_fila%>'	
//alert(contador_fila)	
for(x=0;x<contador_fila ;x++)
{
	
		valorModificado=parseInt(document.edicion.elements['datos_ingreso['+x+'][monto_cambio]'].value)
		valorBaseDatos=parseInt(document.edicion.elements['datos_ingreso['+x+'][dcom_mcompromiso2]'].value)
		sumaValorModificado = valorModificado+sumaValorModificado
		sumavalorBaseDatos = valorBaseDatos+sumavalorBaseDatos	
}
	if(sumaValorModificado==sumavalorBaseDatos)
			{
			return true;
			//alert("datos OK")
			}else
				{alert("Error...Las sumas de los valores entre el Monto y Monto Cambiado son distintos.")
				return false;
				}


}//fin funcion ValidaValoresIngreso
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td width="32%"><div align="right"><strong>R.U.T</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
                      </tr>
                    </table>
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>	
              <br>
			  Debe tener habilitado las paginas emergentes
</div>		
	<%if q_pers_nrut <> "" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
			  <tr></tr>
              <tr>
                <td width="29%"><strong>Rut</strong></td>
                <td width="71%"><%formulario.dibujaCampo("rut")%></td>
              </tr>
              <tr>
                <td><strong>Nombre</strong></td>
                <td><%formulario.dibujaCampo("nombre")%></td>
              </tr>
              <tr>
                <% if existe_correo <> "" then %>
                <td><strong>Correo</strong></td>
                <td><%=existe_correo%></td>
              </tr>
              <tr>
                <td><strong>Desea Cambiar Email</strong></td>
                <td><input type="checkbox" name="cambioEmail" value="cambioEmail" id="cambioEmail" onClick="validaCheckbox(this.value)"></td>
                <%'end if%>
              </tr>
              <tr id="HOLA" style="display:none">
                <td><strong>Ingresar Correo</strong></td>
                <td><%f_busqueda.DibujaCampo("PERS_TEMAIL")%>
                 </td>
              </tr>
              <tr><%else%>
                <td><strong>Ingresar Correo</strong></td>
                <td><%f_busqueda.DibujaCampo("PERS_TEMAIL") %></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <%end if%>
              </table>
			</form>  
            <%end if%>          
            </td></tr>            
      </table>
		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%">  
						
						<%f_botonera.DibujaBoton("guardar")%>
                          
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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