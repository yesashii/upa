<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Desconciliar Documentos"

'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'--------------------------------------------------------------------------------
set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'if not cajero.tienecajaabierta then
'  session("mensajeerror")= "No puede desconciliar documentos sin tener una caja abierta"
'  response.Redirect("../lanzadera/lanzadera.asp") 
' end if
'-------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "desconciliacion.xml", "botonera"
'-------------------------------------------------------------------------------

 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 num_cuenta = request.querystring("busqueda[0][ding_tcuenta_corriente]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "desconciliacion.xml", "busqueda_cheques"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "ding_tcuenta_corriente", num_cuenta

'----------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "desconciliacion.xml", "f_cheques"
f_cheques.Inicializar conexion

consulta = " select a.ding_ndocto as c_ding_ndocto, a.ding_ndocto, a.ting_ccod, a.ting_ccod as c_ting_ccod, " & vbCrLf &_ 
        " a.ding_ncorrelativo, a.banc_ccod, a.ding_fdocto as vencimiento, a.ding_tcuenta_corriente, " & vbCrLf &_ 
        " sum(a.ding_mdocto) as ding_mdocto, " & vbCrLf &_ 
        " protic.saldo_cheque(a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, a.ting_ccod) as saldo, " & vbCrLf &_ 
        " d.edin_tdesc, a.ding_tcuenta_corriente as c_ding_tcuenta_corriente, " & vbCrLf &_ 
	    " b.banc_tdesc, protic.obtener_nombre_completo(max(c.pers_ncorr),'n') as alumno, " & vbCrLf &_ 
        " protic.obtener_rut(max(a.pers_ncorr_codeudor)) as rut_apoderado " & vbCrLf &_ 
		" from ingresos c, detalle_ingresos a, bancos b,estados_detalle_ingresos d " & vbCrLf &_ 
    	" where  a.ting_ccod in ('3','14','38','88') " & vbCrLf &_ 
    	" and a.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_ 
    	" and a.banc_ccod *= b.banc_ccod " & vbCrLf &_ 
    	" and a.edin_ccod = '6'  " & vbCrLf &_ 
    	" and c.eing_ccod not in (3, 6) " & vbCrLf &_ 
    	" and cast(a.ding_ndocto as varchar) = '" & num_doc & "' " & vbCrLf &_
		" --and not exists (select 1 from detalle_ingresos where ding_ndocto=a.ding_ndocto and ding_fdocto=a.ding_fdocto and ting_ccod=38) "& vbCrLf &_
    	" and a.edin_ccod = d.edin_ccod " & vbCrLf 
  		   
		    if num_cuenta <> "" then
			     consulta = consulta & " and isnull(a.ding_tcuenta_corriente, ' ') = isnull(isnull('" & num_cuenta & "',a.ding_tcuenta_corriente), ' ') "& vbCrLf 
              end if		   

consulta = consulta & "group by a.ding_ndocto, a.ting_ccod, a.ding_ncorrelativo, a.banc_ccod, a.ding_fdocto, a.ding_tcuenta_corriente, " & vbcrlf & _
        	" b.banc_tdesc, d.edin_tdesc " & vbcrlf & _
			" having a.ding_ncorrelativo = 1 " & vbcrlf
'consulta = consulta & "group by a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, a.ting_ccod" & vbcrlf & _
'		" having a.ding_ncorrelativo = 1 " & vbcrlf
				
  if Request.QueryString <> "" then
      'response.Write("<PRE>" & consulta & "</PRE>")
	  'response.End()
	  f_cheques.consultar consulta
  else
	f_cheques.consultar "select '' where 1 = 2"
	f_cheques.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
cantidad=f_cheques.nroFilas
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
end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                      <td width="84%"><div align="center">
                              <table width="57%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td>Nro. Cheque</td>
                                  <td> :
<% f_busqueda.DibujaCampo ("ding_ndocto")%>
                                  </td>
                                </tr>
                                <tr> 
                                  <td width="38%"><div align="left">Cuenta Corriente<br>
                                    </div></td>
                                  <td width="62%">: 
                                    <% f_busqueda.DibujaCampo ("ding_tcuenta_corriente")%>
                                  </td>
                                </tr>
                              </table>
                        </div></td>
                      <td width="16%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
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
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->              
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1%></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <BR>
                  </div>
                  <table width="100%" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_cheques.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table>
                  <br> 					
				    <form name="edicion">
                    <div align="center"> <BR>
                      <%f_cheques.DibujaTabla()%>
                      <br>
                    </div>
                    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="60" bgcolor="#D8D8DE"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="16%"> <div align="left">
                          <% if cint(cantidad)=0 then
						        botonera.agregabotonparam "desconciliar", "deshabilitado" ,"TRUE"
						     end if
						     botonera.DibujaBoton ("desconciliar") %>
                        </div></td>
                      <td width="84%"> <div align="left">
                          <% botonera.DibujaBoton ("cancelar")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="296" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
