 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

minr_ncorr= request.QueryString("minr_ncorr")


carrera=carr_ccod
especialidad=espe_ccod
plan=plan_ccod

'carrera22=carr_ccod
'especialidad22=espe_ccod
'planes22=plan_ccod

set pagina = new CPagina
pagina.Titulo = "Asignaturas Minors"

set botonera =  new CFormulario
botonera.carga_parametros "agrega_asignaturas.xml", "btn_busca_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set tabla = new cformulario

tabla.carga_parametros	"agrega_asignaturas.xml",	"tabla_conv"
tabla.inicializar		conectar



sede_ccod = negocio.ObtenerSede
sede = negocio.ObtenerSede
'response.End()
tablas=" select c.asig_ccod,c.asig_tdesc, f.carr_tdesc,e.espe_tdesc,d.plan_tdesc, a.minr_ncorr,a.mall_ccod " & vbCrLf & _
	   " from asignaturas_minor a, malla_curricular b, asignaturas c, planes_estudio d, especialidades e, carreras f " & vbCrLf & _
	   " where a.mall_ccod=b.mall_ccod and b.asig_ccod=c.asig_ccod " & vbCrLf & _
	   " and b.plan_ccod=d.plan_ccod and d.espe_ccod=e.espe_ccod and e.carr_ccod = f.carr_ccod " & vbCrLf & _
	   " and cast(minr_ncorr as varchar)='"&minr_ncorr&"' order by asig_tdesc" 

set fo 		= 		new cFormulario
fo.carga_parametros	"agrega_asignaturas.xml",	"tabla_conv"
fo.inicializar		conectar
fo.consultar 		tablas


minr_tdesc = conectar.consultauno("SELECT minr_tdesc FROM minors WHERE cast(minr_ncorr as varchar)= '" & minr_ncorr & "'")
carr_ccod = conectar.consultauno("SELECT carr_ccod FROM minors WHERE cast(minr_ncorr as varchar)= '" & minr_ncorr & "'")

pagina.Titulo = "Asignaturas Minors<br>"&minr_tdesc

'----------------------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "agrega_asignaturas.xml", "buscador"
 f_busqueda.inicializar conectar

 peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 sede = negocio.obtenerSede

 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&espe_ccod&"' as espe_ccod, '"&plan_ccod&"' as plan_ccod, '"&mall_ccod&"' as mall_ccod"
 f_busqueda.consultar consulta

'response.Write(consulta)

consulta =  "  select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc, " & vbCrLf & _
		 	"  mall_ccod,ltrim(rtrim(f.asig_ccod))+'--'+f.asig_tdesc as asig_tdesc " & vbCrLf & _
		    "  from carreras a, especialidades b, planes_estudio c, ofertas_Academicas d,malla_curricular e, asignaturas f " & vbCrLf & _
			"  where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		    "  and b.espe_ccod=c.espe_ccod " & vbCrLf & _
		    "  and b.espe_ccod=d.espe_ccod  " & vbCrLf & _
			"  and cast(d.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		    "  and c.plan_ccod = e.plan_ccod " & vbCrLf & _
			"  and e.asig_ccod = f.asig_ccod and a.tcar_ccod = 1 " & vbCrLf & _
			"  --and cast(d.peri_ccod as varchar)='"&peri&"'  " & vbCrLf & _
			"  union  " & vbCrLf & _
			"  select  distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc, " & vbCrLf & _
			"  mall_ccod,ltrim(rtrim(f.asig_ccod))+'--'+f.asig_tdesc as asig_tdesc   " & vbCrLf & _
			"  from carreras a, especialidades b, planes_estudio c,malla_curricular e, asignaturas f   " & vbCrLf & _
			"  where a.carr_ccod=b.carr_ccod  " & vbCrLf & _
			"  and b.espe_ccod=c.espe_ccod " & vbCrLf & _
			"  and b.espe_nplanificable='2' " & vbCrLf & _
			" and c.plan_ccod = e.plan_ccod " & vbCrLf & _
			" and e.asig_ccod = f.asig_ccod and a.tcar_ccod = 1" & vbCrLf & _
			" order by a.carr_tdesc,b.espe_tdesc,c.plan_tdesc,asig_tdesc asc" 
			
'response.Write("<pre>"&consulta&"</pre>")	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta

f_busqueda.siguiente






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
function elim_asig(formulario){
	mensaje="eliminar Asignaturas";
	if (verifica_check(formulario,mensaje)) {
		formulario.method="post"
		formulario.action = 'eliminar_asig_plan.asp';
		formulario.submit();
	}
}

function enviar(formulario){
formulario.submit();
}
function agrega_asig(formulario){
    var indice = document.buscador.elements["a[0][MALL_CCOD]"].value;
	var minr_tdesc ='<%=minr_tdesc%>';
	var mensaje = "Está seguro que desea agregar la asignatura "+formulario.elements["a[0][MALL_CCOD]"].options[formulario.elements["a[0][MALL_CCOD]"].selectedIndex].text + " para el MINOR "+minr_tdesc;
	if (confirm(mensaje))    
	{ direccion="proc_agrega_asignaturas.asp?minr_ncorr="+formulario.elements["minr_ncorr"].value+"&mall_ccod="+formulario.elements["a[0][MALL_CCOD]"].value;
	  //resultado=window.open(direccion, "ventana1","width=700,height=550,scrollbars=yes, left=0, top=0");
	  formulario.action = direccion;
	  formulario.submit();
	}
}

function volver()
{
   location.href ="m_minors.asp";
}


</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
            <td><%pagina.DibujarLenguetas Array("Seleccione la asignatura a Agregar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="get">
              <br>
                <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td><div align="left"><strong>Carrera</strong></div></td>
                                <td><div align="center"><strong>:</strong></div></td>
                                <td>
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod" %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left"><strong>Especialidad</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%">
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "espe_ccod" %>
                                </td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Planes</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_busqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Asignaturas</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_busqueda.dibujaCampoLista "lBusqueda", "mall_ccod"%></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "AGREGAR"%>
				                  <input type="hidden" name="minr_ncorr" value="<%=minr_ncorr%>"></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Asignaturas Minor"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <br>
                      <table width="100%" border="0">
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <% 
	fo.dibujatabla()
%>
                          </div></td>
                        </tr>
     
                      </table>
					 </td>
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
                    <%botonera.dibujaboton "SALIR"%>
                  </div></td>
				  <td width="30%"><% botonera.dibujaBoton "eliminar" %> </td>
                  <td width="42%"><% botonera.dibujaBoton "Volver" %></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
