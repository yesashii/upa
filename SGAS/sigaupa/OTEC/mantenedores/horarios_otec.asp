<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sede_ccod = request.querystring("b[0][sede_ccod]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/horarios_otec.asp?b[0][sede_ccod]="&sede_ccod
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Administrador de Horarios por Sede"

set botonera =  new CFormulario
botonera.carga_parametros "horarios_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "horarios_otec.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as sede_ccod"

 f_busqueda.AgregaCampoCons "SEDE_CCOD", SEDE_CCOD
 f_busqueda.Siguiente

set formulario_salas = new cformulario
formulario_salas.carga_parametros "horarios_otec.xml", "lista_horarios"
formulario_salas.inicializar conexion


consulta =    " select a.hora_ccod,b.hora_tdesc, a.sede_ccod,"&vbCrlf & _
			  " case when datepart(hour,a.hora_hinicio) < 10 then '0' + cast(datepart(hour,a.hora_hinicio) as varchar) else cast(datepart(hour,a.hora_hinicio) as varchar) end "&vbCrlf & _
			  "               +':'+case when datepart(minute,a.hora_hinicio) < 10 then '0' + cast(datepart(minute,a.hora_hinicio) as varchar) else cast(datepart(minute,a.hora_hinicio) as varchar) end as hora_hinicio,"&vbCrlf & _
			  "case when datepart(hour,a.hora_htermino) < 10 then '0' + cast(datepart(hour,a.hora_htermino) as varchar) else cast(datepart(hour,a.hora_htermino) as varchar) end "&vbCrlf & _
			  "               +':'+case when datepart(minute,a.hora_htermino) < 10 then '0' + cast(datepart(minute,a.hora_htermino) as varchar) else cast(datepart(minute,a.hora_htermino) as varchar) end as hora_htermino"&vbCrlf & _
		      " from"&vbCrlf & _ 
			  "	horarios_sedes_otec a, horarios b"&vbCrlf & _
			  " where a.hora_ccod=b.hora_ccod"&vbCrlf & _
			  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"&vbCrlf & _
			  " order by a.hora_ccod"

'response.write("<pre>"&consulta&"</pre>")
formulario_salas.consultar consulta 

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")

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
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "agregar_sala.asp";
	resultado=window.open(direccion, "ventana1","width=400,height=230,scrollbars=no, left=380, top=150");
	
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
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

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
                    <td width="20%"><div align="center"><strong>Sede</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("sede_ccod") %></td>
                  </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center"><%'botonera.dibujaboton "crear_dcurso"%></td>
										<td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
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
	<table width="85%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
				  <tr>
                    <td><%if sede_ccod<>"" then
					        response.Write("<strong>SEDE: "&sede_tdesc&"</strong>")
						  end if%></td>
                  </tr>
                  <tr>
                    <td>&nbsp;<input type="hidden" name="sede_borrar" value="<%=sede_ccod%>"></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario_salas.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario_salas.dibujatabla()%>
                    </div></td>
                  </tr>
				  <tr>
                    <td align="center"><table width="60%" border="0">
										<tr valign="top">
										    <td width="33%" align="right"><%if formulario_salas.nroFilas > 0  then 
																			botonera.dibujaBoton "eliminar"
																		 end if%>
											</td>
											<td width="33%" align="right"><%if sede_ccod <> "" then 
											                                botonera.agregaBotonParam "agregar","url","editar_horario_otec.asp?sede_ccod="&sede_ccod
																			botonera.dibujaBoton "agregar"
																		 end if%>
											</td>
											<td width="34%" align="right"><%'botonera.dibujaBoton "salir"%>
											</td>
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
