<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_pers_tape_paterno = Request.QueryString("b[0][pers_tape_paterno]")
q_pers_tape_materno = Request.QueryString("b[0][pers_tape_materno]")
q_pers_tnombre = Request.QueryString("b[0][pers_tnombre]")

if EsVacio(Request.QueryString) then
	buscando = false
else
	buscando = true
end if

'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/m_personas.asp?b[0][pers_tape_paterno]="&q_pers_tape_paterno&"&b[0][q_pers_tape_materno]="&q_pers_tape_materno&"&b[0][pers_tnombre]="&q_pers_tnombre
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Administración de Personas"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "m_personas.xml", "botonera"


'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "m_personas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_tape_paterno", q_pers_tape_paterno
f_busqueda.AgregaCampoCons "pers_tape_materno", q_pers_tape_materno
f_busqueda.AgregaCampoCons "pers_tnombre", q_pers_tnombre


'---------------------------------------------------------------------------------------------------
set f_personas = new CFormulario
f_personas.Carga_Parametros "m_personas.xml", "personas"
f_personas.Inicializar conexion

if buscando then
	consulta = " select pers_ncorr, pers_nrut, pers_xdv, pers_tape_paterno, pers_tape_materno, pers_tnombre, protic.obtener_rut(pers_ncorr) as rut " & vbCrLf &_
			   " from personas" & vbCrLf &_
			   " where 1=1 "
	if q_pers_tape_paterno <> "" then 
	 	consulta = consulta & " and pers_tape_paterno like '%"&q_pers_tape_paterno&"%' "
	end if
	if q_pers_tape_materno <> "" then 
	 	consulta = consulta & " and pers_tape_materno like '%"&q_pers_tape_materno&"%' "
	end if
	if q_pers_tnombre <> "" then 
	 	consulta = consulta & " and pers_tnombre like '%"&q_pers_tnombre&"%' "
	end if
        consulta = consulta & " order by pers_tape_paterno asc, pers_tape_materno asc, pers_tnombre asc"
else
	consulta = "select ''as valor from personas where 1=2 "
end if
'response.Write("<pre>"&consulta&"</pre>")
f_personas.Consultar consulta

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
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=550,height=250,scrollbars=no, left=380, top=150");
	
 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=550,height=400,scrollbars=yes, left=380, top=100");
	
 // window.close();
}

function salir(){
window.close()
}
function validar_fechas()
{
	var fecha = document.edicion.elements["m[0][dgso_finicio]"].value;
    var v_fecha = document.edicion.elements["m[0][dgso_ftermino]"].value;
	var cupo = document.edicion.elements["m[0][dgso_ncupo]"].value;
    var quorum = document.edicion.elements["m[0][dgso_nquorum]"].value;
    
        array_inicio=fecha.split('/');     
        array_termino=v_fecha.split('/');

		dia_inicio = array_inicio[0];
		mes_inicio  = array_inicio[1];
		agno_inicio = array_inicio[2];
		dia_termino = array_termino[0];
		mes_termino  = array_termino[1];
		agno_termino = array_termino[2];
		
		// con formatos mm/dd/yyyy
		fecha_inicio=mes_inicio+'/'+dia_inicio+'/'+agno_inicio;
		fecha_termino=mes_termino+'/'+dia_termino+'/'+agno_termino;
		
		// convertir a milisegundos
		m_fecha_termino = Date.parse(fecha_termino);
		m_fecha_inicio= Date.parse(fecha_inicio);
		//alert("m_sysdate "+m_sysdate+" m_fecha_ingresada "+m_fecha_ingresada);
		
		diferencia=eval(m_fecha_inicio-m_fecha_termino);
		//alert ("diferencia "+diferencia);
		//return false;
    
	if (diferencia <= 0)
	{	//alert("cupo "+cupo+" quorum "+quorum);
		if (quorum <= cupo)
		{   //alert("cupo "+cupo+" quorum "+quorum);
			return true;
		}
		else
		{
				alert("El Quorum del programa es mayor que el cupo haga el favor de corregir el dato.");
				return false;
		}
	
	} 
	else
	{
		    alert("La fecha de término del programa es anterior a la de inicio, haga el favor de corregir el dato antes de grabar.");
			return false;
	}
	
	
return false;
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "m[0][dgso_finicio]","1","edicion","fecha_oculta_dgso_finicio"
	calendario.MuestraFecha "m[0][dgso_ftermino]","2","edicion","fecha_oculta_dgso_ftermino"
	calendario.FinFuncion
	
%>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="95%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Nombre</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.DibujaCampo("pers_tnombre")%></td>
                 </tr>
				  <tr>
                    <td width="20%"><div align="center"><strong>A.Paterno</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.DibujaCampo("pers_tape_paterno")%></td>
                 </tr>
				 <tr>
                    <td width="20%"><div align="center"><strong>A.Materno</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.DibujaCampo("pers_tape_materno")%></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center"><%'botonera.dibujaboton "crear_dcurso"%></td>
										<td width="50%" align="right"><%f_botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  
				  <%if q_pers_tape_paterno <> ""  or  q_pers_tape_materno <> "" or q_pers_tnombre <> "" then %>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%f_personas.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%f_personas.dibujatabla()%>
                    </div></td>
                  </tr>
				  <%end if%>
				 <br> 
				<tr><td align="right"><%f_botonera.DibujaBoton("agregar")%></td></tr>    
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
	</table>
	</td>
  </tr>
  
</table>
</td>
</tr>
</table>
</body>
</html>
