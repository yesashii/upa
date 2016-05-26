<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
detalle = request.querystring("detalle")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
sede_ccod = request.querystring("b[0][sede_ccod]")
anos_ccod = request.querystring("b[0][anio_admision]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/asignar_relator_programa.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2&b[0][anio_admision]="&anos_ccod
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Asignar Relator a Programa"

set botonera =  new CFormulario
botonera.carga_parametros "asignar_relator_programa.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "asignar_relator_programa.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 
 consulta = "Select '"&anos_ccod&"' as anio_admision, '"&sede_ccod&"' as sede_ccod, '"&dcur_ncorr&"' as dcur_ncorr "
 f_busqueda.consultar consulta

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr and esot_ccod not in (4) " & vbCrlf & _
			" and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
			
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2,3)")

'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_malla = new cformulario
formulario_malla.carga_parametros "asignar_relator_programa.xml", "f_secciones"
formulario_malla.inicializar conexion

if tiene_datos_generales = "S" then
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2,3)")

consulta ="  select '"&dgso_ncorr&"' as dgso_ncorr,'"&anos_ccod&"' as anos_ccod,cast(c.seot_tdesc as varchar)+'--'+cast(b.mote_ccod as varchar) as codigo, " & vbCrlf & _
          "  b.mote_tdesc,c.seot_ncorr,maot_nhoras_programa as horas,protic.trunc(c.seot_finicio) as f_inicio, protic.trunc(c.seot_ftermino) as f_termino, " & vbCrlf & _
          "  protic.horario_otec_con_sala(c.seot_ncorr) as horario" &vbCrlf &_
		  "  from mallas_otec a, modulos_otec b, secciones_otec c,ofertas_otec d " & vbCrlf & _
          "  where a.mote_ccod=b.mote_ccod " & vbCrlf & _
          "  and a.maot_ncorr=c.maot_ncorr " & vbCrlf & _
		  "  and c.dgso_ncorr=d.dgso_ncorr" & vbCrlf & _
          "  and c.dgso_ncorr='"&dgso_ncorr&"' " & vbCrlf & _
          "  and cast(a.dcur_ncorr as varchar ) ='"&dcur_ncorr&"' " & vbCrlf & _
		  "  and cast(d.anio_admision as varchar)='"&anos_ccod&"' " & vbCrlf & _
          "  order by maot_norden asc  " 

else
consulta = "select '' as maot_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
formulario_malla.consultar consulta 

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")


tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2,3)")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2,3)")


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
<% f_busqueda.generaJS %>
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
                    <td width="20%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                 </tr>
				 <tr>
                    <td width="20%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                 </tr>
				  <tr>
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr" %></td>
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
				  <tr>
                    <td><%if detalle="2" then
					        response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")
						  end if%></td>
                  </tr>
				  <tr>
                    <td><%if detalle="2" then
					        response.Write("<strong>SEDE: "&sede_tdesc&"</strong>")
						  end if%></td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if (dcur_ncorr <> "" ) and detalle = "2"  and tiene_datos_generales = "S" then %>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario_malla.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario_malla.dibujatabla()%>
                    </div></td>
                  </tr>
				  <%end if%>
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
