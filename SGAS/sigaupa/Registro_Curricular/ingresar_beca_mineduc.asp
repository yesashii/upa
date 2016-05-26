<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
v_post_ncorr = Request.QueryString("busqueda[0][post_ncorr]")


'response.Write(v_datos(0))

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Ingresar Beca Mineduc"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

if not EsVacio(v_post_ncorr)  then
	v_datos=split(v_post_ncorr,"&")
	v_post_ncorr_carrera=v_datos(0)
	v_oferta=v_datos(1)
	
	sql_update="Update postulantes set ofer_ncorr="&v_oferta&" where post_ncorr="&v_post_ncorr_carrera&" "
	'response.Write(sql_update)
	conexion.ejecutaS(sql_update)
end if

'---------------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_2.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "ingresar_beca_mineduc.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "post_ncorr", v_post_ncorr

consulta_select = "(select cast(b.post_ncorr as varchar)+'&'+cast(bb.ofer_ncorr as varchar) as post_ncorr, e.carr_tdesc as carrera -- +'-'+ d.espe_tdesc as carrera " & vbcrlf & _ 
				 " from personas_postulante a, postulantes b, detalle_postulantes bb, ofertas_academicas c, " & vbcrlf & _  
                 " especialidades d, carreras e " & vbcrlf & _ 
				 " where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _  
				 "  and bb.ofer_ncorr = c.ofer_ncorr " & vbcrlf & _ 
				 "  --and b.ofer_ncorr =c.ofer_ncorr " & vbcrlf & _  
				 "  and b.post_ncorr = bb.post_ncorr " & vbcrlf & _  
				 "  and c.espe_ccod = d.espe_ccod " & vbcrlf & _  
				 "  and d.carr_ccod = e.carr_ccod " & vbcrlf & _  
				 "  and b.tpos_ccod in (1,2) " & vbcrlf & _  
				 "  and b.epos_ccod = 2  " & vbcrlf & _ 
				 "  and b.peri_ccod =  " & v_peri_ccod & " " & vbcrlf & _ 
				 "  and cast(a.pers_nrut as varchar)=  '" & q_pers_nrut & "') a "

'response.Write("<pre>"&consulta_select&"</pre>")
				 
f_busqueda.AgregaCampoParam "post_ncorr", "destino", consulta_select

v_cantidad_carrera=conexion.consultaUno("Select count(*) from "&consulta_select&" ")

'-------------------------------------------------------------------------------------------------------------------------
'v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_sede_ccod = negocio.ObtenerSede

consulta = "select max(b.post_ncorr) as post_ncorr " & vbCrLf &_
           "from personas_postulante a, postulantes b, ofertas_academicas c " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
'v_post_ncorr = conexion.ConsultaUno(consulta)

'---------------------------------------------------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, v_post_ncorr_carrera
		

'---------------------------------------------------------------------------------------------------------

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "ingresar_beca_mineduc.xml", "descuentos"
f_descuentos.Inicializar conexion

			
if v_post_ncorr_carrera <> "" then
consulta = "select * from alumno_credito a, sdescuentos b,stipos_descuentos c " & vbCrLf &_
			" where a.tdet_ccod=b.stde_ccod " & vbCrLf &_
			" and a.post_ncorr=b.post_ncorr " & vbCrLf &_
			" and b.stde_ccod = c.stde_ccod " & vbCrLf &_ 
			" and a.tdet_ccod in (2513,2353,910,1390,1446,1537,1538,1912) " & vbCrLf &_
			" and cast(a.post_ncorr as varchar)='" & v_post_ncorr_carrera & "' "
else
	consulta = " select '' "
end if
			
'response.Write("<pre>"&consulta&"</pre>")  			
f_descuentos.Consultar consulta
f_descuentos.AgregaCampoParam "esde_ccod", "permiso", "LECTURA"
'---------------------------------------------------------------------------------------------------
consulta = "select count(*) " & vbCrLf &_
           "from contratos " & vbCrLf &_
		   "where econ_ccod <> 3 " & vbCrLf &_
		   "  and cast(post_ncorr as varchar) = '" & v_post_ncorr_carrera & "'"
'response.Write("<pre>"&consulta&"</pre>")  
if CInt(conexion.ConsultaUno(consulta)) > 0 then
	b_contrato_generado = true
else
	b_contrato_generado = false
end if


if b_contrato_generado then
	f_descuentos.AgregaCampoParam "esde_ccod", "permiso", "LECTURA"
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

if f_descuentos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

f_botonera.AgregaBotonParam "agregar_descuento", "url", "agregar_beca_mineduc.asp?post_ncorr="&v_post_ncorr_carrera&"&ofer_ncorr="&v_oferta




if v_post_ncorr_carrera="" and q_pers_nrut <>"" and v_cantidad_carrera=0 then
	mensaje_no_postula="Alumno no presenta postulación asociada al periodo académico seleccionado"
end if

if v_peri_ccod <= "209" then
	mensaje_no_postula= mensaje_no_postula&"<br> El periodo de postulacion seleccionado es inferior al periodo de admision 2008"
end if

'response.End()
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:left;
}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;	
}

function InicioPagina()
{
}


function mostrar_informe(post_ncorr,ofer_ncorr,stde_ccod)
{
  resultado = open("info_descuentos.asp?post_ncorr=" + post_ncorr + "&amp;ofer_ncorr=" + ofer_ncorr + "&amp;stde_ccod=" + stde_ccod,  "", "top=100, left=100, width=480, height=215, scrollbars=yes");	
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
                      <td width="81%"><div align="center">
                        <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td><div align="right">R.U.T. Postulante </div></td>
                            <td width="7%"><div align="center">:</div></td>
                            <td><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                          </tr>
						  <tr>
                            <td><div align="right">Carreras Postulante </div></td>
                            <td width="7%"><div align="center">:</div></td>
                            <td><%f_busqueda.DibujaCampo("post_ncorr")%>
						  </tr>
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
			  <font color="#FF0000" size="2"><b><%=mensaje_no_postula%></b></font>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%postulante.DibujaDatos%></td>
                </tr>
                <tr>
                  <td><br>
                    <%
					if not EsVacio(v_post_ncorr_carrera) then
						postulante.DibujaTablaValores
					end if
					%></td>
                </tr>
              </table>
              <div align="left"><br>
                  <br>
				  <%pagina.DibujarSubtitulo("Becas Mineduc ingresadas")%>
                </div>
            </div>              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><form name="edicion">
					<div align="center"><%f_descuentos.DibujaTabla%></div>	
                      </form>
					  </td></tr>
                </table>
                          <br>
</td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="30%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%
					if (v_post_ncorr_carrera="" and q_pers_nrut <>"") or (v_peri_ccod<="209") then
						variable=""
					else
						f_botonera.DibujaBoton("agregar_descuento")
					end if
					%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
