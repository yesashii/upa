<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_ding_ndocto = Request.QueryString("b[0][ding_ndocto]")
rut_alumno = request.querystring("b[0][pers_nrut]")
rut_alumno_digito = request.querystring("b[0][pers_xdv]")
rut_apoderado = request.querystring("b[0][code_nrut]")
rut_apoderado_digito = request.querystring("b[0][code_xdv]")

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Recepción de letras protestadas en banco"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "recepcion_letras_protestadas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "recepcion_letras_protestadas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "ding_ndocto", q_ding_ndocto
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

'---------------------------------------------------------------------------------------------------
set f_letras = new CFormulario
f_letras.Carga_Parametros "recepcion_letras_protestadas.xml", "letras"
f_letras.Inicializar conexion


consulta="select distinct a.ding_ndocto, a.ting_ccod, a.ingr_ncorr, a.ding_ndocto as c_ding_ndocto, a.edin_ccod, " & vbCrLf &_ 
		 " b.ingr_fpago, a.ding_fdocto, protic.obtener_rut(b.pers_ncorr) as rut_alumno, " & vbCrLf &_
         " protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, a.ding_mdocto, f.inen_tdesc, " & vbCrLf &_ 
		 " g.edin_tdesc, 0 as reca_mmonto,isnull(h.reca_mmonto,0) as c_reca_mmonto, b.pers_ncorr " & vbCrLf &_ 
         " from detalle_ingresos a " & vbCrLf &_
         " join ingresos b  " & vbCrLf &_
		 "		on a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
         " left outer join personas c  " & vbCrLf &_
		 "		on a.pers_ncorr_codeudor = c.pers_ncorr " & vbCrLf &_
         " join  personas d  " & vbCrLf &_
		 "		on b.pers_ncorr = d.pers_ncorr " & vbCrLf &_
         " left outer join envios e  " & vbCrLf &_
		 "		on a.envi_ncorr = e.envi_ncorr" & vbCrLf &_
         " left outer join instituciones_envio f  " & vbCrLf &_
		 "		on e.inen_ccod = f.inen_ccod" & vbCrLf &_ 
		 " join estados_detalle_ingresos g  " & vbCrLf &_
		 "		on a.edin_ccod = g.edin_ccod " & vbCrLf &_
		 " left outer join referencias_cargos h  " & vbCrLf &_
		 "		on a.ingr_ncorr=h.ingr_ncorr " & vbCrLf &_
		 "		and h.audi_tusuario not like '%prorroga%' " & vbCrLf &_
		 " 		and h.edin_ccod not in (18,20) " & vbCrLf &_
         " where a.ding_ncorrelativo > 0 " & vbCrLf &_
         " and b.eing_ccod <> 3 " & vbCrLf &_
         " and a.ting_ccod = 4 " & vbCrLf &_
         " and a.edin_ccod in (19)  "  
         
        
'( a.edin_ccod in (19) or g.fedi_ccod in (4, 20) )
if  q_ding_ndocto <> "" then
	consulta = consulta & " and cast(a.ding_ndocto as varchar) = '" & q_ding_ndocto & "'" & vbCrLf
end if

if  rut_alumno <> "" then
	'" and cast(d.pers_nrut as varchar) = isnull('" & rut_alumno & "', cast(d.pers_nrut as varchar))" 
	consulta = consulta & "  and cast(d.pers_nrut as varchar) = '" & rut_alumno & "' " & vbCrLf
end if

		 
if  rut_apoderado <> "" then
	consulta = consulta & "  and cast(c.pers_nrut as varchar) = '" & rut_apoderado & "' " & vbCrLf
end if

consulta = consulta & "order by a.ding_ndocto asc"

if EsVacio(Request.QueryString) then
	consulta = "select '' from sexos where 1 = 2"
end if

'response.Write("<pre>"&consulta&"</pre>")
		   
f_letras.Consultar consulta		   

cantidad=f_letras.nroFilas

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
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["b[0][pers_xdv]"].focus();
		formulario.elements["b[0][pers_xdv]"].select();
		return false;
	  }
	
	rut_apoderado = formulario.elements["b[0][code_nrut]"].value + "-" + formulario.elements["b[0][code_xdv]"].value;	
    if (formulario.elements["b[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["b[0][code_xdv]"].focus();
		formulario.elements["b[0][code_xdv]"].select();
		return false;
	   }
	return true;
}

function ValidarEdicion()
{
	if (t_letras.CuentaSeleccionados("ding_ndocto") == 0) {
		alert('No ha seleccionado letras para recepcionar.');
		return false;
	}
	
	return true;
}


var t_letras;
function InicioPagina()
{
	t_letras = new CTabla("letras");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr> 
                                <td width="86">Rut Alumno</td>
                                <td width="17">:</td>
                                <td width="151"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.DibujaCampo("pers_nrut") %>
                                  - 
                                  <%f_busqueda.DibujaCampo("pers_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                <td width="93">Rut Apoderado</td>
                                <td width="12">:</td>
                                <td width="139"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.DibujaCampo("code_nrut")%>
                                  - 
                                  <%f_busqueda.DibujaCampo("code_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                </tr>
				<tr>
                  <td width="86">N° Letra</td>
                                <td width="17">:</td>
                                <td width="151"><%f_busqueda.DibujaCampo("ding_ndocto") %></td>
				  <td width="93">&nbsp;</td>
				  <td width="12">&nbsp;</td>				
                  <td width="139"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
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
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Letras protestadas en banco"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : 
                            <%f_letras.AccesoPagina%>
                          </div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center">
                                <%f_letras.DibujaTabla%>
                          </div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center">
                            <%f_letras.Pagina%>
                          </div></td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if cint(cantidad)=0 then
						        				f_botonera.agregabotonparam "recepcionar", "deshabilitado" ,"TRUE"
						     				 end if
				                             f_botonera.DibujaBoton "recepcionar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cancelar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
