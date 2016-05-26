<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Crea matriculas anticipadas"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "matricula_anticipada.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 accion = request.querystring("accion")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "matricula_anticipada.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'--------------------------------------------------------------------
v_pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut_alumno&"'")

if isnull(v_pers_ncorr)	or EsVacio(v_pers_ncorr) or v_pers_ncorr="" then
	v_pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut_alumno&"'")
end if

'--------------------------------------------------------------------
set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "matricula_anticipada.xml", "tabla_valores"
f_compromiso.Inicializar conexion

consulta = "select a.pers_ncorr, c.ofer_ncorr,b.post_ncorr, cast(a.pers_nrut as varchar(10)) + ' - ' + a.pers_xdv as rut, a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
                 "       e.carr_tdesc +' '+ d.espe_tdesc as carrera ,e.carr_tdesc, d.espe_tdesc, convert(datetime,getdate(), 103) as fecha_actual, g.sede_tdesc, " & vbCrLf &_
				 "	   f.aran_mmatricula, f.aran_mcolegiatura, isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) as total " & vbCrLf &_
				 "from personas_postulante a, postulantes b, detalle_postulantes bb, ofertas_academicas c, especialidades d, carreras e, aranceles f, sedes g " & vbCrLf &_
				 "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				 "  and bb.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
				 "  and b.post_ncorr = bb.post_ncorr " & _
				 "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
				 "  and d.carr_ccod = e.carr_ccod " & vbCrLf &_
				 "  and c.aran_ncorr = f.aran_ncorr " & vbCrLf &_
				 "  and c.sede_ccod = g.sede_ccod " & vbCrLf &_
				 "  and b.tpos_ccod in (1,2) " & vbCrLf &_
				 "  and b.epos_ccod = 2 " & vbCrLf &_
				 "  and b.peri_ccod = " & v_peri_ccod & " " & vbCrLf &_
				 "  and a.pers_ncorr = " & v_pers_ncorr & " " & vbCrLf '&_




'response.Write("<pre>"&consulta&"</pre>")		
'if Request.QueryString <> "" then
if not Esvacio(Request.QueryString) then
 	  f_compromiso.Consultar consulta
else
	 f_compromiso.Consultar "select '' where 1=2"
	 f_compromiso.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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

function Anular(){
formulario = document.edicion;
mensaje="Crear Matricula";
   nro = document.edicion.elements.length;
   num =0;
  for( i = 0; i < nro; i++ ) {
  v_cont=0;
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if((comp.type == 'checkbox' )&&(comp.checked == true )){
		    v_cont=v_cont+1;
	  }
   }
	if (v_cont < 1){
		if (verifica_check(formulario,mensaje)){
				return true;
		}
	}else{
		alert("debe seleccionar solo una carrera");
	}
}

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
		
	return true;
}

</script>



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
              <td><%pagina.DibujarLenguetas Array("Búsqueda de contratos para activar"), 1 %></td>
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
                      <td width="81%"><div align="center">
                        <table width="50%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="37%">R.U.T. Alumno : </td>
                                  <td width="57%"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - <% f_busqueda.DibujaCampo ("pers_xdv") %>
									<a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
									</td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
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
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
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
                  <td bgcolor="#D8D8DE">
				&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
<form name="edicion">
					<%pagina.DibujarSubtitulo "Postulaciones"%><br>
					<div align="right">P&aacute;ginas: &nbsp; <%f_compromiso.AccesoPagina%> </div>
					<div align="center"><% f_compromiso.DibujaTabla() %></div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">&nbsp; </td>
                      <td width="20%"> <div align="left"> 
                          <%
					   'if estado = "1" or estado = "" then
					   if	f_compromiso.NroFilas = 0 then
							   botonera.agregabotonparam "agregar", "deshabilitado" ,"TRUE"			   
					   end if
					    botonera.DibujaBoton ("agregar")
					   %>
                        </div></td>
                      <td width="31%"> <div align="left"> 
                          
                        </div></td>
                      <td width="49%"> <div align="left"> 
                          <%botonera.DibujaBoton ("salir")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="157" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
   <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>
