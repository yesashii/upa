<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")
q_facu_ccod=request.QueryString("b[0][facu_ccod]")
q_ano_adjudicacion=request.QueryString("b[0][ano_adjudicacion]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Becas Mineduc"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "becas_mineduc.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "becas_mineduc.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas_mineduc.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "becas_mineduc.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tdet_ccod",q_tdet_ccod
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod
f_busqueda.AgregaCampoCons "facu_ccod",q_facu_ccod
f_busqueda.AgregaCampoCons "ano_adjudicacion",q_ano_adjudicacion

consulta_carrera=	"(select distinct d.carr_ccod,d.carr_tdesc " & vbCrlf & _ 
				  	"from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e " & vbCrlf & _ 
				  	"where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrlf & _ 
				  	"and b.peri_ccod=e.peri_ccod and a.emat_ccod = 1 and a.alum_nmatricula <> 7777 " & vbCrlf & _ 
				  	"and e.anos_ccod >= 2008 and d.tcar_ccod = 1 ) a" 
					
f_busqueda.agregacampoparam "carr_ccod", "destino", consulta_carrera


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
else

	filtro2=filtro2&"and a.tdet_ccod in (910,1390,1446,1537,1538,1539,1912)"  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  					
end if

 if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  					
end if
 
  if q_facu_ccod<> "" then
	

  	filtro5=filtro5&"and i.facu_ccod ="&q_facu_ccod&""
  					
end if

if q_carr_ccod<> "" then
	

  	filtro6=filtro6&"and f.carr_ccod ="&q_carr_ccod&""
  					
end if

if q_ano_adjudicacion<> "" then
	

  	filtro7=filtro7&"and ano_adjudicacion="&q_ano_adjudicacion&""
  					
end if
 
if q_anos_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				",ano_adjudicacion,monto_bene,tdet_tdesc,facu_tdesc,(select cast(max(espe_nduracion)as varchar)+' semestres' from especialidades aa, ofertas_academicas bb,alumnos cc where aa.ESPE_CCOD=bb.ESPE_CCOD and bb.OFER_NCORR=cc.OFER_NCORR  and cc.post_ncorr=a.post_ncorr group by espe_nduracion)as duracion,protic.ANO_INGRESO_CARRERA_EGRESA2(c.pers_ncorr,f.CARR_CCOD)as ano_ingreso_carrera,protic.obtener_ano_caducacion_beca_mineduc (f.carr_ccod,d.sede_ccod,d.jorn_ccod,"&q_anos_ccod&",c.pers_ncorr)as ano_caducacion,(("&q_anos_ccod&" - ano_adjudicacion)+1) as ano_encurso_beca"& vbCrLf &_
				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f,tipos_detalle g,areas_academicas h,facultades i"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
				"and a.tdet_ccod=g.tdet_ccod"& vbCrLf &_
				"and f.area_ccod=h.area_ccod"& vbCrLf &_
				"and h.facu_ccod=i.facu_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" " &filtro5&" "& vbCrLf &_
				" " &filtro6&" "& vbCrLf &_
				" " &filtro7&" "& vbCrLf &_
				"group by a.post_ncorr, c.pers_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,carr_tdesc,d.sede_ccod,ano_adjudicacion,monto_bene,tdet_tdesc,i.facu_tdesc,f.CARR_CCOD,d.jorn_ccod"& vbCrLf &_
				"order by carrera,nombre"
				
				'
				numero_total=conexion.ConsultaUno("select count(post_ncorr) from(select a.post_ncorr"& vbCrLf &_
 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f,tipos_detalle g,areas_academicas h,facultades i"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and a.tdet_ccod=g.tdet_ccod"& vbCrLf &_
				"and f.area_ccod=h.area_ccod"& vbCrLf &_
				"and h.facu_ccod=i.facu_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" " &filtro5&" "& vbCrLf &_
				" " &filtro6&" "& vbCrLf &_
				" " &filtro7&" "& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod group by a.post_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,carr_tdesc,d.sede_ccod,ano_adjudicacion,monto_bene,tdet_tdesc,i.facu_tdesc,f.CARR_CCOD)as bb")

total=numero_total			

end if
					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos


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
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
	
        <td ><table width="100%"  border="0" cellspacing="0" cellpadding="0">

          <tr>
		  
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
			
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="90%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					
					 <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="18%"><p><strong>Becas/</strong>
				  	  <strong>Descuentos:</strong></p></td>
				  	<td width="82%"><div align="left"><%f_busqueda.DibujaCampo("tdet_ccod")%></div></td>
					
                </tr>
              </table>
			  			   <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="18%"><strong>Facultad:</strong></td>
				  	<td width="82%"><div align="left"><%f_busqueda.DibujaCampo("facu_ccod")%></div></td>
					
                </tr>
              </table>
			   <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="18%"><strong>Carrera:</strong></td>
				  	<td width="82%"><div align="left"><%f_busqueda.DibujaCampo("carr_ccod")%></div></td>
					
                </tr>
              </table>

			   <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="18%"><strong>Sedes:</strong></td>
				  	<td width="82%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div></td>
					
                </tr>
              </table>
			  <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="18%"><strong>Periodos Academico:</strong></td>
				  	<td width="82%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div></td>
					
                </tr>
              </table>
			  <table width="90%"  border="0" align="center">
					<tr>
					
				  	<td width="19%"><strong>Año adjudicacion:</strong></td>
				  	<td width="81%"><div align="left"><%f_busqueda.DibujaCampo("ano_adjudicacion")%></div></td>
					
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
		  <td>
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos Becas Mineduc"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_cheques.accesopagina%>
                             </td>
						</tr>
						<tr>						
                                <td align="center">
						       <%f_cheques.DibujaTabla()%>
							   </td>
                        </tr>
                      </table>
					   <table align="right">
					   <td >Numero Total de Alumnos: <strong><%=total%></strong></td>
					    </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
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

                  <td><div align="center">
					<%f_botonera.AgregaBotonParam "excel", "url", "becas_mineduc_excel.asp"
				   f_botonera.DibujaBoton"excel"  %></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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