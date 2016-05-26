<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Asignar información de práctica"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------



 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "calificar_practica.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "calificar_practica.xml", "botonera"
'--------------------------------------------------------------------------
set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
consulta_datos =  " select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, "& vbCrLf &_
				  " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
				  " b.sexo_tdesc as sexo,c.pais_tdesc as pais "& vbCrLf &_
				  " from personas_postulante a,sexos b,paises c "& vbCrLf &_
				  " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
				  " and a.sexo_ccod *=b.sexo_ccod "& vbCrLf &_
				  " and a.pais_ccod=c.pais_ccod"

datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo = datos_personales.obtenerValor("pers_ncorr")
rut_completo = datos_personales.obtenerValor("rut")
nombre = datos_personales.obtenerValor("nombre")
sexo = datos_personales.obtenerValor("sexo")
pais = datos_personales.obtenerValor("pais")

if not esvacio(codigo) then
es_moroso = conexion.consultaUno("select protic.es_moroso('"&codigo&"', getDate())")
	if es_moroso="N" then
		moroso = "No"
	else
		moroso = "Sí"		
    end if
end if

set asignaturas = new CFormulario
asignaturas.Carga_Parametros "calificar_practica.xml", "asignaturas"
asignaturas.Inicializar conexion
consulta_datos =  " select b.matr_ncorr,b.secc_ccod,c.mall_ccod, d.asig_ccod as cod_asignatura,d.asig_tdesc as asignatura, "& vbCrLf &_
				  " replace(b.carg_nnota_final,',','.') as nota,b.sitf_ccod as final  "& vbCrLf &_
				  " from alumnos a,cargas_academicas b,secciones c,asignaturas d "& vbCrLf &_
				  " where cast(pers_ncorr as varchar)= '"&codigo&"' and a.matr_ncorr = b.matr_ncorr"& vbCrLf &_
				  " and b.secc_ccod = c.secc_ccod and c.asig_ccod=d.asig_ccod "& vbCrLf &_
				  " and exists (select 1 from configuracion_planes cp where cp.mall_ccod= c.mall_ccod and cp.tasg_ccod = 4) "& vbCrLf &_
				  " --and not exists (select 1 from equivalencias cp where cp.matr_ncorr = b.matr_ncorr and cp.secc_ccod = b.secc_ccod) "& vbCrLf &_
				  " union all "& vbCrLf &_
				  " select b.matr_ncorr,b.secc_ccod,e.mall_ccod, d.asig_ccod as cod_asignatura,d.asig_tdesc as asignatura, "& vbCrLf &_
				  " replace(b.carg_nnota_final,',','.') as nota,b.sitf_ccod as final "& vbCrLf &_
				  " from alumnos a,cargas_academicas b,secciones c,asignaturas d,equivalencias e "& vbCrLf &_
				  " where cast(pers_ncorr as varchar)='"&codigo&"' and a.matr_ncorr = b.matr_ncorr "& vbCrLf &_
				  " and b.secc_ccod = c.secc_ccod and e.asig_ccod=d.asig_ccod "& vbCrLf &_
				  " and b.matr_ncorr = e.matr_ncorr and b.secc_ccod=e.secc_ccod "& vbCrLf &_
				  " and exists (select 1 from configuracion_planes cp where cp.mall_ccod= e.mall_ccod and cp.tasg_ccod = 4 ) "
'response.Write("<pre>"&consulta_datos&"</pre>")
asignaturas.Consultar consulta_datos
asignaturas.siguiente

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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<%if rut <> "" then%>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
                  <%if rut<>"" then%>
				  <table width="100%" border="0">
                    <tr><td colspan="3">&nbsp;</td></tr>
					<tr> 
                      <td align="left" width="15%"><strong>R.U.T.</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=rut_completo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Nombre</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=nombre%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Es Moroso</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=moroso%></td>
					</tr>
				  </table>
				  <%end if%>
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left">- Asignaturas que cursa el alumno</td>
                    </tr>
					<tr> 
                      <td align="left"><form name="edicion">
										<div align="center">
										  <% asignaturas.DibujaTabla %>
										</div>
									  </form></td>
                    </tr>
                  </table> 
                  <br>				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<%end if%>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
