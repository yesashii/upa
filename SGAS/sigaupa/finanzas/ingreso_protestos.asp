<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de protestos (UPA)"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Protestos.xml", "botonera"
'-----------------------------------------------------------------------

 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_doc = request.querystring("busqueda[0][edin_ccod]")
 vencimiento = request.querystring("busqueda[0][ding_fdocto]")
 tipo_doc = request.querystring("busqueda[0][ting_ccod]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Protestos.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoParam "edin_ccod", "filtro","edin_ccod<21 and edin_ccod not in (9,19)"
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_doc
 f_busqueda.AgregaCampoCons "ding_fdocto", vencimiento
 f_busqueda.AgregaCampoCons "ting_ccod", tipo_doc
'-----------------------------------------------------------------------

' set f_datos = new CFormulario
' f_datos.Carga_Parametros "Ingreso_Protestos.xml", "f_documentos"
' f_datos.Inicializar conexion

 set f_documentos = new CFormulario
 f_documentos.Carga_Parametros "Ingreso_Protestos.xml", "f_documentos"
 f_documentos.Inicializar conexion


		sql = "SELECT isnull(a.ding_bpacta_cuota, 'N') as ding_bpacta_cuota, b.inst_ccod, a.ding_ndocto,"& vbCrLf &_
			"        a.ding_ndocto as c_ding_ndocto, a.ting_ccod, a.edin_ccod, a.edin_ccod as c_edin_ccod, a.ingr_ncorr,   "& vbCrLf &_
			"		a.ding_ncorrelativo, a.plaz_ccod, a.banc_ccod, a.ding_fdocto as c_ding_fdocto,"& vbCrLf &_
			"        a.ding_mdetalle, a.ding_mdocto as c_ding_mdocto, a.ding_mdocto, a.ding_nsecuencia,     "& vbCrLf &_
			"	    a.ding_tcuenta_corriente, a.envi_ncorr, a.repa_ncorr, c.pers_ncorr, "& vbCrLf &_
			"        cast(c.pers_nrut as varchar) + '-' + c.pers_xdv as rut_alumno, cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  "& vbCrLf &_
			"		convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto,     "& vbCrLf &_
			"		i.ting_tdesc, j.edin_tdesc,'' as multa,       "& vbCrLf &_
			"		protic.total_cargos_documento(a.ting_ccod,a.ding_ndocto,a.ingr_ncorr) as reca_mmonto         	  "& vbCrLf &_
			" FROM "& vbCrLf &_
			" detalle_ingresos a join ingresos b"& vbCrLf &_
			"    on a.ingr_ncorr = b.ingr_ncorr   "& vbCrLf &_
			" join tipos_ingresos i"& vbCrLf &_
			"    on a.ting_ccod = i.ting_ccod     "& vbCrLf &_
			" join estados_detalle_ingresos j"& vbCrLf &_
			"    on a.edin_ccod = j.edin_ccod"& vbCrLf &_
			" join personas c"& vbCrLf &_
			"    on b.pers_ncorr = c.pers_ncorr   "& vbCrLf &_
			" left outer join personas f "& vbCrLf &_
			"    on a.PERS_NCORR_CODEUDOR = f.pers_ncorr   "& vbCrLf &_
			" WHERE a.ding_ncorrelativo = 1     "& vbCrLf &_
			"      and b.eing_ccod = 4 "& vbCrLf &_
			"      and a.edin_ccod not in (6,9,17,18,19,51) " 
	

if tipo_doc	<> "4" then
	sql=sql +  	" and a.audi_tusuario not like '%Protesto_Cheque%' "& vbCrLf &_
				" and a.envi_ncorr is not null "& vbCrLf
end if

  if rut_apoderado <> "" then
    sql = sql +  " and f.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
  end if  
  
  if rut_alumno <> "" then
   	sql = sql + "and c.pers_nrut = '" & rut_alumno & "' "& vbCrLf
  end if
  
  if vencimiento <> "" then
    sql = sql + " and convert(datetime,a.ding_fdocto,103) = '" & vencimiento & "' "& vbCrLf
  end if  
  
  if num_doc <> "" then
    sql = sql + " and a.ding_ndocto = '" & num_doc & "' "& vbCrLf
  end if
  
  if tipo_doc <> "" then	  
    sql = sql + " and a.ting_ccod = '" & tipo_doc & "' "& vbCrLf
  else
    sql = sql + " and a.ting_ccod IN (3,4,14,38,88) "& vbCrLf
  end if 
  
  if estado_doc <> "" then
    sql = sql + " and a.edin_ccod = '" & estado_doc & "' "& vbCrLf
  end if  
  
  'sql = sql + " ORDER BY a.ding_ndocto "
  
  fila = 0
  if Request.QueryString <> "" then
  'response.Write("<PRE>" & sql & "</PRE>")
		
	f_documentos.Consultar sql
 
  else
	f_documentos.consultar "select '' where 1 = 2"
	f_documentos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
  
  
  if f_documentos.NroFilas = 0 then
  	botonera.AgregaBotonParam "protestar", "deshabilitado", "TRUE"
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

function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
	}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][ding_fdocto]","1","buscador","fecha_oculta_ding_fdocto"
	calendario.FinFuncion
%>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de documentos"), 1%></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                      <table width="98%"  border="0">
                        <tr> 
                          <td width="100%"><table width="660" border="0" align="left">
                              <tr> 
                                <td width="93"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">* N&ordm; 
                                    Documento</font></div></td>
                                <td width="10">:</td>
                                <td width="134"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                                  </font></td>
                                <td width="20"><div align="center"></div></td>
                                <td width="86">* Tipo</td>
                                <td width="13">:</td>
                                <td width="166"><% f_busqueda.DibujaCampo ("ting_ccod")%></td>
                                <td width="104" rowspan="6"><div align="center"></div>
                                  <div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                              <tr> 
                                <td><div align="left"><strong>*</strong>&nbsp;<font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                    Alumno </font></div></td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                  - 
                                  <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font></td>
                                <td>&nbsp;</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                  Apoderado</font></td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("code_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("code_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                              </tr>
                              <tr> 
                                <td>F. Vencimiento</td>
                                <td>:</td>
                                <td><% f_busqueda.DibujaCampo ("ding_fdocto")%>
								<%calendario.DibujaImagen "fecha_oculta_ding_fdocto","1","buscador" %>(dd/mm/aaaa)</td>
                                <td>&nbsp;</td>
                                <td>Estado</td>
                                <td>:</td>
                                <td> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
                              </tr>
                          
                            </table></td>
                        </tr>
                      </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<BR>
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
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_documentos.AccesoPagina %>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                        <td> <div align="center"><br>
                            <% f_documentos.DibujaTabla()%>
                          </div></td>
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
            <td width="19%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% botonera.DibujaBoton ("protestar") %>
                          </div></td>
                  <td><div align="center">
                            <% botonera.DibujaBoton ("lanzadera")%>
                          </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	
	<BR>
    </td>
  </tr>  
</table>
</body>
</html>
