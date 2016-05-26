<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de Letras Notaria"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "ingreso_letras_notaria.xml", "botonera"
'-------------------------------------------------------------------------------
set errores = new CErrores

 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_letra = request.querystring("busqueda[0][edin_ccod]")
 notaria  = request.querystring("busqueda[0][inen_ccod]")
 folio  = request.querystring("busqueda[0][envi_ncorr]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ingreso_letras_notaria.xml", "busqueda_letras"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 

 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_letra
 f_busqueda.AgregaCampoCons "inen_ccod", notaria
 f_busqueda.AgregaCampoCons "envi_ncorr", folio

'----------------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "ingreso_letras_notaria.xml", "f_letras"
 f_letras.Inicializar conexion

'consulta = "SELECT a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, a.ting_ccod ,a.ding_ndocto, a.ding_ndocto as c_ding_ndocto,  "& vbCrLf &_
'	   "			  b.ingr_ncorr, a1.edin_ccod, a1.edin_tdesc, x.inen_ccod, x.inen_tdesc, trunc(b.ingr_fpago) as ingr_fpago, d.pers_nrut, d.pers_xdv ,  "& vbCrLf &_
'		"   		  d.pers_nrut || '-' ||d.pers_xdv as rut_alumno, i.pers_nrut as code_nrut, i.pers_xdv as code_xdv, i.pers_nrut || '-' || i.pers_xdv as rut_apoderado, 	a.ding_mdocto  "& vbCrLf &_
'		"	FROM instituciones_envio x, envios t, detalle_envios u, detalle_ingresos a,  "& vbCrLf &_
'		"		 estados_detalle_ingresos a1, ingresos b, tipos_ingresos c, personas d, personas i  "& vbCrLf &_
'		"	WHERE a.DING_NCORRELATIVO = 1  "& vbCrLf &_
'		"	  and t.inen_ccod = x.inen_ccod  "& vbCrLf &_
'		"	  and t.envi_ncorr  = u.envi_ncorr  "& vbCrLf &_
'		"	  and u.ting_ccod  = a.ting_ccod  "& vbCrLf &_
'		"	  and u.ding_ndocto  = a.ding_ndocto  "& vbCrLf &_
'		"	  and u.ingr_ncorr  = a.ingr_ncorr  "& vbCrLf &_
'		"	  and a.edin_ccod = a1.edin_ccod  "& vbCrLf &_
'		"	  and a.ingr_ncorr = b.ingr_ncorr  "& vbCrLf &_
'		"	  and a.ting_ccod = c.ting_ccod  "& vbCrLf &_
'		"	  and b.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
'		"	  and a.PERS_NCORR_CODEUDOR = i.pers_ncorr (+) "& vbCrLf &_
'		"	  and c.ting_ccod = 4 "& vbCrLf &_ 
'		"	  and a1.fedi_ccod IN (2,3) "& vbCrLf
			  
consulta = "SELECT a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, a.ting_ccod ,a.ding_ndocto, a.ding_ndocto as c_ding_ndocto,  "& vbCrLf &_ 
		"			  b.ingr_ncorr, a1.edin_ccod, a1.edin_tdesc, x.inen_ccod, x.inen_tdesc,"& vbCrLf &_ 
		"              convert(varchar,b.ingr_fpago,103) as ingr_fpago, d.pers_nrut, d.pers_xdv ,  "& vbCrLf &_ 
		"   		      cast(d.pers_nrut as varchar) + '-' + d.pers_xdv as rut_alumno, i.pers_nrut as code_nrut,"& vbCrLf &_ 
		"              i.pers_xdv as code_xdv, cast(i.pers_nrut as varchar) + '-' + i.pers_xdv as rut_apoderado,a.ding_mdocto  "& vbCrLf &_ 
		"FROM "& vbCrLf &_
		" envios t join instituciones_envio x"& vbCrLf &_
		"    on  t.inen_ccod = x.inen_ccod "& vbCrLf &_
		" 	and t.inen_ccod in (5,19) "& vbCrLf &_
		" join detalle_envios u"& vbCrLf &_
		"    on  t.envi_ncorr  = u.envi_ncorr  "& vbCrLf &_
		" join detalle_ingresos a"& vbCrLf &_
		"    on u.ting_ccod  = a.ting_ccod and u.ding_ndocto  = a.ding_ndocto and u.ingr_ncorr  = a.ingr_ncorr    "& vbCrLf &_
		" join estados_detalle_ingresos a1"& vbCrLf &_
		"    on a.edin_ccod = a1.edin_ccod"& vbCrLf &_
		" join ingresos b"& vbCrLf &_
		"    on a.ingr_ncorr = b.ingr_ncorr  "& vbCrLf &_ 
		" join tipos_ingresos c"& vbCrLf &_
		"    on  a.ting_ccod = c.ting_ccod "& vbCrLf &_
		" join  personas d"& vbCrLf &_
		"     on  b.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
		" left outer join personas i  "& vbCrLf &_
		"    on  a.PERS_NCORR_CODEUDOR = i.pers_ncorr  "& vbCrLf &_
		" WHERE c.ting_ccod = 4 "& vbCrLf &_
		" and a.DING_NCORRELATIVO = 1	"& vbCrLf &_
		" and a1.edin_ccod IN (2) "
			  
			  if folio <> "" then
			    consulta =  consulta & "and a.envi_ncorr = '" & folio & "' "& vbCrLf
			  end if
			  if notaria <> "" then
			    consulta =  consulta & "and x.inen_ccod = '" & notaria & "' "& vbCrLf
			  end if
			  if num_doc <> "" then
                 consulta =  consulta &  "and a.ding_ndocto = '" & num_doc & "' "& vbCrLf
			  end if 
			  if estado_letra <> "" then
			    consulta =  consulta &  "and a1.fedi_ccod = '" & estado_letra & "' "& vbCrLf
			  end if 			  
			  if rut_alumno <> "" then
			     consulta =  consulta & "and d.pers_nrut = '" & rut_alumno & "' "& vbCrLf 
			  end if 			  
			  if rut_apoderado <> "" then
			    consulta =  consulta &   "and i.pers_nrut = '" & rut_apoderado & "' "& vbCrLf 			 
			  end if 
			  
 if Request.QueryString <> "" then
	 ' response.Write("<pre>" & consulta & "</pre>")	  
	 ' response.End()
	  f_letras.consultar consulta
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if					 
'response.Write("<pre>"&consulta&"</pre>")	
'response.End()
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




function procesar_tabla(form){

	nro = form.elements.length;

	for (i = 0; i < nro; i++) 
     {  	    
		comp = form.elements[i];
		str  = form.elements[i].name;
		if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){ 

			indice=extrae_indice(str);
          	estado = form.elements["letras[" + indice + "][edin_ccod]"].value;

			  if (estado == 54){
				  form.elements["_letras[" + indice + "][multa]"].disabled= false;
				}
	 		  
			  if (estado == 50){
                  form.elements["_letras[" + indice + "][multa]"].disabled= true;
			   }			
	     }
	}  

}

function seleccionar(elemento){
form=document.edicion;
	if (elemento.checked){
		str=elemento.name;
		v_indice=extrae_indice(str);
		form.elements["letras["+v_indice+"][edin_ccod]"].disabled=false;
		procesar_tabla(form);
	}else{
		str=elemento.name;
		v_indice=extrae_indice(str);
		form.elements["letras["+v_indice+"][edin_ccod]"].disabled=true;
		form.elements["_letras[" + indice + "][multa]"].disabled= true;
	}
}

</script>



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<BR>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="159" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          de Letras</font></div></td>
                      <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="487" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador"><BR>
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="524" border="0">
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
                                <td>N&ordm; Letra</td>
                                <td>:</td>
                                <td><% f_busqueda.DibujaCampo ("ding_ndocto")%></td>
                                <td>N&ordm; Folio</td>
                                <td>:</td>
                                <td> 
                                  <% f_busqueda.dibujaCampo ("envi_ncorr") %>
                                </td>
                              </tr>
                              <tr> 
                                <td>Notaria</td>
                                <td>:</td>
                                <td> <% f_busqueda.dibujaCampo ("inen_ccod") %> </td>
                                <td>&nbsp; </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
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
            </table>			
          </td>
      </tr>
    </table>	
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
                    <td width="156" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultado
                        de la B&uacute;squeda</font></div>
                    </td>
                    <td width="501" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
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
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR> 
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_letras.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% f_letras.DibujaTabla() %>
                    </div>
                    </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="72" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="19%">
                        <div align="left">
                          <% if cint(cantidad)=0 then
						        botonera.agregabotonparam "ingresar_letras", "deshabilitado" ,"TRUE"
						     end if 
						  botonera.DibujaBoton ("ingresar_letras") %>
                          </div></td>
                      <td width="81%">
                        <div align="left">
                          <% botonera.DibujaBoton ("cancelar") %>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="290" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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