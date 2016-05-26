<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			:
'FECHA CREACIÓN			:
'CREADO POR 			:
'ENTRADA				:NA
'SALIDA					:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:05/02/2013
'ACTUALIZADO POR		:Luis Herrera G.
'MOTIVO					:Corregir código, eliminar sentencia *=
'LINEA					:168, 169, 170
'********************************************************************

'---------------------------------------------------------------------------------------------------
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")



'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Corrección de Cheques"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "corregir_cheque.xml", "botonera"




'---------------------------------------------------------------------------------------------------
'v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod= negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "corregir_cheque.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'------------------------------------------------------------------------------------------------
'-----------------------------------DATOS POSTULANTE--------------------------------------------
		
		set f_detalle_post = new CFormulario
		f_detalle_post.Carga_Parametros "corregir_cheque.xml", "f_detalle_post"
		f_detalle_post.Inicializar conexion
		
		 'consulta = "select pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno  as nombre_post, " & vbCrLf &_
		'"	   pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post, " & vbCrLf &_
		'"	   to_char(sysdate, 'DD/MM/YYYY') as fecha_hoy, " & vbCrLf &_
		'"	   cc.carr_tdesc as carrera " & vbCrLf &_
		'"from postulantes p,personas_postulante pp,ofertas_academicas oa, " & vbCrLf &_
		'"	 especialidades ee, carreras cc  " & vbCrLf &_
		'"where p.pers_ncorr=pp.pers_ncorr and " & vbCrLf &_
		'"	  p.post_ncorr= '" & post_ncorr &"' and " & vbCrLf &_
		'"	  p.ofer_ncorr=oa.ofer_ncorr and " & vbCrLf &_
		'"	  oa.espe_ccod=ee.espe_ccod and " & vbCrLf &_
		'"	  ee.carr_ccod=cc.carr_ccod "
		
		consulta = "select pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno  as nombre_post, " & vbCrLf &_
					"	   cast(pp.PERS_NRUT as varchar) + '-' + pp.PERS_XDV as rut_post, " & vbCrLf &_
					"	   convert(varchar,getdate(),103) as fecha_hoy " & vbCrLf &_
					"    from personas pp" & vbCrLf &_
					"    where cast(pp.pers_nrut as varchar)='"&q_pers_nrut&"'"

		
		'response.Write("<pre>"&consulta&"</pre>")
		f_detalle_post.Consultar consulta
		f_detalle_post.siguiente
		
		nombre_postulante=f_detalle_post.obtenerValor("nombre_post")
		rut_postulante=f_detalle_post.obtenerValor("rut_post")
	
'-----------------DETALLES CHEQUES------------------------------------
		set f_detalle_cheque_2 = new CFormulario
		f_detalle_cheque_2.Carga_Parametros "corregir_cheque.xml", "f_detalle_cheque_2"
		f_detalle_cheque_2.Inicializar conexion

	'response.Write("chaop2")
'response.End()
		
	
		'consulta_c = "select p.post_ncorr,  "&_
	 '				"dii.TING_CCOD,   "&_
	 '				"dii.ding_ndocto ,  "&_
	 '				"dii.ingr_ncorr , dii.ding_tcuenta_corriente,  "&_
	 '				"dii.ding_ndocto  nro_doc,  "&_
	 '				"tii.ting_tdesc tipo_doc,   "&_
	 '				"bn.BANC_TDESC banco,   "&_
	 '				"pl.plaz_tdesc plaza,  "&_
	 '				"to_char(cps.COMP_FDOCTO,'DD/MM/YYYY') f_emision,   "&_
	 '				"to_char(dii.DING_FDOCTO,'DD/MM/YYYY') f_vencimiento,  "&_
	 '				"dii.DING_MDETALLE monto  "&_
 '				"from postulantes p,   "&_
	  '				"contratos cc, compromisos cps , detalle_compromisos dc,   "&_
	  '				"abonos bb, ingresos ii, detalle_ingresos dii,   "&_
	 '				" tipos_ingresos tii,bancos bn, tipos_compromisos tcps, plazas pl  "&_
  '				"where p.post_ncorr='"& post_ncorr &"' and  "&_
	  '					"cc.post_ncorr=p.post_ncorr and   "&_
			'			"cc.cont_ncorr=cps.comp_ndocto and "&_
	 '					"cps.ecom_ccod <> 3 and   "&_
			'			"cc.econ_ccod <> 3 and    "&_
	  '					"cps.comp_ndocto=dc.comp_ndocto and   "&_
				'		"cps.tcom_ccod=dc.tcom_ccod and   "&_
					'	"cps.tcom_ccod=tcps.tcom_ccod and   "&_
	  
						'"bb.comp_ndocto=dc.comp_ndocto and   "&_ 
						'"bb.tcom_ccod=dc.tcom_ccod and    "&_
						'"bb.dcom_ncompromiso=dc.dcom_ncompromiso and    "&_
	  
						'"bb.ingr_ncorr=ii.ingr_ncorr and    "&_
						'"ii.eing_ccod <> 3 and    "&_
						'"dii.ingr_ncorr (+)= ii.ingr_ncorr and    "&_
						'"dii.ting_ccod =3 and   "&_
						'"dii.ting_ccod =tii.ting_ccod (+) and    "&_
						'"dii.banc_ccod = bn.banc_ccod (+) and    "&_
						'"dii.plaz_ccod=pl.plaz_ccod   "
		
		'consulta_c= "select p.pers_ncorr,  " & vbCrLf &_
		'			 "				dii.TING_CCOD,    " & vbCrLf &_
		'			 "				dii.ding_ndocto ,   " & vbCrLf &_
		'			 "				dii.ingr_ncorr , dii.ding_tcuenta_corriente,   " & vbCrLf &_
		'			 "				dii.ding_ndocto  nro_doc,   " & vbCrLf &_
		'			 "				tii.ting_tdesc tipo_doc,   " & vbCrLf &_
		'			 "				bn.BANC_TDESC banco,    " & vbCrLf &_
		'			 "				pl.plaz_tdesc plaza,   " & vbCrLf &_
		'			 "				to_char(dii.DING_FDOCTO,'DD/MM/YYYY') f_vencimiento,   " & vbCrLf &_
		'			 "				dii.DING_MDETALLE monto_cuota,   " & vbCrLf &_
		'			 "				dii.DING_MDOCTO monto   " & vbCrLf &_
		'			 "				from personas p,    " & vbCrLf &_
		'			 " 				 ingresos ii, detalle_ingresos dii,    " & vbCrLf &_
		'			 "				 tipos_ingresos tii,bancos bn,  plazas pl  " & vbCrLf &_
		'			 "				where p.pers_nrut = '"&q_pers_nrut&"' and   " & vbCrLf &_
		'			  "					p.pers_ncorr=ii.pers_ncorr and    " & vbCrLf &_
		'				"				ii.eing_ccod <> 3 and    " & vbCrLf &_
		'				"				dii.ingr_ncorr (+)= ii.ingr_ncorr and     " & vbCrLf &_
		'				"				dii.ting_ccod =3 and  " & vbCrLf &_
		'				"				dii.DING_NCORRELATIVO >=1 and   " & vbCrLf &_
		'				"				dii.ting_ccod =tii.ting_ccod (+) and   " & vbCrLf &_
		'				"				dii.banc_ccod = bn.banc_ccod (+) and    " & vbCrLf &_
		'				"				dii.plaz_ccod=pl.plaz_ccod"
						
'		consulta_c = "select a.pers_ncorr,c.TING_CCOD,c.ding_ndocto ,c.ingr_ncorr ,c.ding_tcuenta_corriente,   " & vbCrLf &_
'				"				c.ding_ndocto  as nro_doc,d.ting_tdesc as tipo_doc,e.BANC_TDESC as banco,f.plaz_tdesc as plaza," & vbCrLf &_
'				"				convert(varchar,c.DING_FDOCTO,103) as f_vencimiento,c.DING_MDETALLE as monto_cuota,   " & vbCrLf &_
'				"				c.DING_MDOCTO as monto" & vbCrLf &_
'				"    from personas a,ingresos b,detalle_ingresos c," & vbCrLf &_
'				"        tipos_ingresos d,bancos e,plazas f" & vbCrLf &_
'				"    where a.pers_ncorr = b.pers_ncorr        " & vbCrLf &_
'				"        and b.ingr_ncorr = c.ingr_ncorr" & vbCrLf &_
'				"        and c.ting_ccod *= d.ting_ccod" & vbCrLf &_
'				"        and c.banc_ccod *= e.banc_ccod" & vbCrLf &_
'				"        and c.plaz_ccod *= f.plaz_ccod" & vbCrLf &_
'				"        and b.eing_ccod <> 3" & vbCrLf &_
'				"        and c.ting_ccod = 3" & vbCrLf &_
'				"        and c.ding_ncorrelativo >= 1" & vbCrLf &_
'				"        and cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"' "
		consulta_c = "select a.pers_ncorr, "& vbCrLf &_
				"			c.TING_CCOD, "& vbCrLf &_
				"			c.ding_ndocto, "& vbCrLf &_
				"			c.ingr_ncorr, "& vbCrLf &_
				"			c.ding_tcuenta_corriente, "& vbCrLf &_
				"			c.ding_ndocto  as nro_doc, "& vbCrLf &_
				"			d.ting_tdesc as tipo_doc, "& vbCrLf &_
				"			e.BANC_TDESC as banco, "& vbCrLf &_
				"			f.plaz_tdesc as plaza, "& vbCrLf &_
				"			convert(varchar,c.DING_FDOCTO,103) as f_vencimiento, "& vbCrLf &_
				"			c.DING_MDETALLE as monto_cuota, "& vbCrLf &_
				"			c.DING_MDOCTO as monto "& vbCrLf &_
				"		from personas a "& vbCrLf &_
				"		join ingresos b "& vbCrLf &_
				"			on a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
				"		join detalle_ingresos c "& vbCrLf &_
				"			on b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
				"		left outer join tipos_ingresos d "& vbCrLf &_
				"			on c.ting_ccod = d.ting_ccod "& vbCrLf &_
				"		left outer join bancos e "& vbCrLf &_
				"			on c.banc_ccod = e.banc_ccod "& vbCrLf &_
				"		left outer join plazas f "& vbCrLf &_
				"			on c.plaz_ccod = f.plaz_ccod "& vbCrLf &_
				"		where b.eing_ccod <> 3 "& vbCrLf &_
				"			and c.ting_ccod = 3 "& vbCrLf &_
				"			and c.ding_ncorrelativo >= 1 "& vbCrLf &_
				"			and cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"' "
					
		'response.Write("<pre>"&consulta_c&"</pre>")
		'response.End()		
		f_detalle_cheque_2.Consultar consulta_c
		'response.Write(consulta_c)
		
						 
'set postulante = new CAlumno
'postulante.Inicializar conexion, post_ncorr

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
var t_busqueda;

function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}


function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}
</script>

</head>
<body onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
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
            <td><%pagina.DibujarLenguetas Array("Búsqueda de postulantes"), 1 %></td>
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
                                <td width="32%"><div align="right">R.U.T.</div></td>
                                <td width="7%"><div align="center">:</div></td>
                                <td width="61%"> <%f_busqueda.DibujaCampo("pers_nrut")%>
                                  - 
                                  <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]" %></td>
                              </tr>
                            </table>
                  </div></td>
                  <td width="19%"><div align="center">
                            <%f_botonera.DibujaBoton("buscar")%>
                          </div></td>
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
                    <table width="75%" border="0">
                      <tr> 
                        <td width="21%">Nombre</td>
                        <td width="3%">:</td>
                        <td width="76%">
                          <%=nombre_postulante%>
                        </td>
                      </tr>
                      <tr> 
                        <td>R.U.T</td>
                        <td>:</td>
                        <td> <%=rut_postulante%></td>
                      </tr>
                 
                    </table>
                    <br>
                </div>
              <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td align="center"> <br>
                          <table width="665" border="0">
                            <tr> 
                              <td width="116">&nbsp;</td>
                              <td width="511"><div align="right">P&aacute;ginas: 
                                  &nbsp; 
                                  <%f_detalle_cheque_2.AccesoPagina%>
                                </div></td>
                              <td width="24"> <div align="right"> </div></td>
                            </tr>
                          </table> 
                          <br>
                        </td>
                      </tr>
                      <tr> 
                        <td> <div align="center">
                            <%f_detalle_cheque_2.DibujaTabla%>
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
            <td width="15%" height="20"><div align="center">
                    <table width="50%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"> 
						 
                            <% f_botonera.dibujaboton "salir" %>
											 
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
