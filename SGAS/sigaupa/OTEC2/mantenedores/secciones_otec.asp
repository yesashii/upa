<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
detalle = request.querystring("detalle")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
sede_ccod = request.querystring("b[0][sede_ccod]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/secciones_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2"
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Administrador de Secciones para Diplomados y Cursos"

set botonera =  new CFormulario
botonera.carga_parametros "secciones_otec.xml", "botonera"
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
 f_busqueda.Carga_Parametros "secciones_otec.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as dcur_ncorr, '' as sede_ccod"

 f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 f_busqueda.AgregaCampoCons "SEDE_CCOD", SEDE_CCOD
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

tiene_datos_generalesI = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' ")

'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_malla = new cformulario
formulario_malla.carga_parametros "secciones_otec.xml", "f_secciones"
formulario_malla.inicializar conexion

if tiene_datos_generales = "S" then
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

consulta =" select '"&dgso_ncorr&"' as dgso_ncorr,maot_ncorr,b.mote_ccod as codigo,b.mote_ccod, b.mote_tdesc, a.maot_norden, " & vbCrlf & _
          " (select count(*) from secciones_otec aa where aa.maot_ncorr=a.maot_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"') as num_secciones " & vbCrlf & _
		  " from mallas_otec a, modulos_otec b " & vbCrlf & _
		  " where a.mote_ccod=b.mote_ccod " & vbCrlf & _
		  " and cast(a.dcur_ncorr as varchar ) ='"&DCUR_NCORR&"' " & vbCrlf & _
		  " order by maot_norden asc " 
else
consulta = "select '' as maot_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
formulario_malla.consultar consulta 

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")


'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "secciones_otec.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select dgso_ncorr,dcur_ncorr,sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,esot_ccod  " & vbCrlf & _
		  " from datos_generales_secciones_otec  " & vbCrlf & _
		  " where cast(dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(sede_ccod as varchar)='"&sede_ccod&"' " 
'tiene_datos_generales="S"
if tiene_datos_generalesI = "N" then
	consulta = "select '' as dgso_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_generales.consultar consulta 
if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
end if
datos_generales.siguiente
esot_ccod=datos_generales.ObtenerValor("esot_ccod")
'response.write("<pre>yyy= "&esot_ccod&"</pre>")

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")


es_curso = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and tdcu_ccod=1")
seot_ncorr_comun="0"
if es_curso = "S" and dgso_ncorr <> "" then
	mote_ccod = conexion.consultaUno("select top 1 mote_ccod from mallas_otec where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
    'response.Write(mote_ccod)
	f_inicio = conexion.consultaUno("select dgso_finicio from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
	f_fin    = conexion.consultaUno("select dgso_ftermino from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
    'response.Write(f_inicio)
	'response.Write("<br>"&f_fin)
	c_anteriores = " select count(*) from secciones_otec a, mallas_otec b,diplomados_cursos c " & vbCrlf & _
				   " where a.maot_ncorr=b.maot_ncorr and b.dcur_ncorr=c.dcur_ncorr " & vbCrlf & _
				   " and b.mote_ccod ='"&mote_ccod&"' and c.tdcu_ccod = 2 " & vbCrlf & _
				   " and a.seot_finicio = convert(datetime,'"&f_inicio&"',103) and a.seot_ftermino = convert(datetime,'"&f_fin&"',103)"      
	equivalentes = conexion.consultaUno(c_anteriores)
	'response.Write(c_anteriores)
	if equivalentes <> "0" then
		mensaje_equi = "Se ha detectado que este curso lo imparte uno de los módulos de un diplomado,<br>¿desea asociar el horario?"
    	seot_ncorr_comun = conexion.consultaUno("select isnull(seot_ncorr_comun,0) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

		set arreglo_secciones = new cformulario
		arreglo_secciones.carga_parametros "secciones_otec.xml", "arreglo_secciones"
		arreglo_secciones.inicializar conexion
		c_arreglo_secciones = " (select a.seot_ncorr,d.mote_tdesc +' ('+protic.horario_otec_con_sala(a.seot_ncorr)+')' as muestra " & vbCrlf & _
							  " from secciones_otec a, mallas_otec b,diplomados_cursos c,modulos_otec d  " & vbCrlf & _
							  " where a.maot_ncorr=b.maot_ncorr and b.dcur_ncorr=c.dcur_ncorr  " & vbCrlf & _
							  " and b.mote_ccod=d.mote_ccod and b.mote_ccod ='"&mote_ccod&"'  " & vbCrlf & _
							  " and c.tdcu_ccod = 2 and a.seot_finicio = convert(datetime,'"&f_inicio&"',103)  " & vbCrlf & _
							  " and a.seot_ftermino = convert(datetime,'"&f_fin&"',103))a "
	    arreglo_secciones.consultar "select '' as seot_ncorr, '' as muestra"
		arreglo_secciones.siguiente
		if seot_ncorr_comun <> "0" then
			arreglo_secciones.agregaCampoCons "seot_ncorr", seot_ncorr_comun
		end if
		arreglo_secciones.agregaCampoParam "seot_ncorr", "destino",c_arreglo_secciones
	   
	end if
	
	
	
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


function bloqueos()
{
var var_esot_ccod;
var_esot_ccod='<%=esot_ccod%>';
//alert('entra');
if (var_esot_ccod =='3'  )
	{
		
		document.edicion.elements["m[0][dgso_finicio]"].disabled=true;
		document.edicion.elements["m[0][dgso_ftermino]"].disabled=true;
		document.edicion.elements["m[0][esot_ccod]"].disabled=true;
		document.edicion.elements["m[0][dgso_ncupo]"].disabled=true;
		document.edicion.elements["m[0][dgso_nquorum]"].disabled=true;
		//alert('aaaa');
	}
	else
	{
			
		document.edicion.elements["m[0][dgso_finicio]"].disabled=false;
		document.edicion.elements["m[0][dgso_ftermino]"].disabled=false;
		document.edicion.elements["m[0][esot_ccod]"].disabled=false;
		document.edicion.elements["m[0][dgso_ncupo]"].disabled=false;
		document.edicion.elements["m[0][dgso_nquorum]"].disabled=false;
		//alert('bbbb');
	}
	
	
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
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); bloqueos();"  onBlur="revisaVentana();">
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
                    <td width="20%"><div align="center"><strong>Módulo</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
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
				  <%if detalle="2" then%>
				  <tr>
				  	<td align="center">
						<table width="100%">
						<tr>
							<td width="15%"><strong>Fecha Inicio </strong></td>
							<td width="30%" nowrap>: <%=datos_generales.dibujaCampo("dgso_finicio")%> <% if esot_ccod <> "3" then calendario.DibujaImagen "fecha_oculta_dgso_finicio","1","edicion" end if %>
							  (dd/mm/yyyy) </td>
							<td width="20%" align="right"><strong>Fecha Término </strong></td>
							<td width="35%" nowrap>: <%=datos_generales.dibujaCampo("dgso_ftermino")%> <%if esot_ccod <> "3" then calendario.DibujaImagen "fecha_oculta_dgso_ftermino","2","edicion"end if %>
                          (dd/mm/yyyy) </td>  
						</tr>
						<tr>
							<td width="15%"><strong>Estado </strong></td>
							<td width="30%" nowrap>: <%=datos_generales.dibujaCampo("esot_ccod")%>&nbsp;<input type="hidden" name="m[0][dcur_ncorr]" value="<%=dcur_ncorr%>"></td>
							<td width="20%" align="right"><strong>Cupo</strong></td>
							<td width="35%">: <%=datos_generales.dibujaCampo("dgso_ncupo")%>&nbsp;<input type="hidden" name="m[0][sede_ccod]" value="<%=sede_ccod%>"></td>
						</tr>
						<tr>
							<td width="15%"><strong>Quorum</strong></td>
							<td width="30%" nowrap>: <%=datos_generales.dibujaCampo("dgso_nquorum")%>&nbsp;<input type="hidden" name="m[0][dgso_ncorr]" value="<%=dgso_ncorr%>"></td>
							<td width="20%" align="right">&nbsp;</td>
							<td width="35%" nowrap><%
							if esot_ccod="3" then
							botonera.agregaBotonParam "guardar_datos_generales","deshabilitado","TRUE"
							end if
							botonera.dibujaboton "guardar_datos_generales"
							%></td>
						</tr>
						</table>
					</td>
				  </tr>
    			  <%end if%>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if mensaje_equi<> "" and tiene_datos_generales = "S" then%>
				  <tr>
                    <td align="center" width="95%">
						<table border="0" width="100%">
							<tr>
								<td align="center" bgcolor="#c4d7ff" bordercolor="#999966">
									<strong><%=mensaje_equi%></strong>
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="#FFFFFF"><%arreglo_secciones.dibujaCampo "seot_ncorr"%></td>
							</tr>
							<tr>
								<td align="right" bgcolor="#FFFFFF"><%botonera.dibujaboton "asignar_horario"
								
								%></td>
							</tr>
						</table>
					</td>   				  
				  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%end if%>
				  <%if seot_ncorr_comun = "0" then
					  if (dcur_ncorr <> "" ) and detalle = "2"  and tiene_datos_generales = "S" then %>
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
				  <%end if%>
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
