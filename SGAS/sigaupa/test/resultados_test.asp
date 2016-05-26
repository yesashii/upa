<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_carr_ccod =Request.QueryString("b[0][carr_ccod]")
q_sede_ccod =Request.QueryString("b[0][sede_ccod]")
q_peri_ccod =Request.QueryString("b[0][peri_ccod]")
q_anos_ccod =Request.QueryString("b[0][anos_ccod]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "resultados_test.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "resultados_test.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "resultados_test.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "resultados_test.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "carr_ccod",q_carr_ccod
f_busqueda.AgregaCampoCons "sede_ccod",q_sede_ccod
f_busqueda.AgregaCampoCons "peri_ccod",q_peri_ccod
f_busqueda.AgregaCampoCons "anos_ccod",q_anos_ccod




if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and et.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_carr_ccod <> "" then
	

  	filtro2=filtro2&"and esp.carr_ccod='" &q_carr_ccod&"'"
  					
end if
		
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and oa.sede_ccod='" &q_sede_ccod&"'"
  					
end if

if q_anos_ccod <>"" then


sql_= "select nombre,ec,o_r,ca,ea,ca_ec,ea_or,rut,carrera,Paa_verbal,paa_mate,fecha,"& vbCrLf &_
"case when ea_or > 0 and ca_ec >0  then 'DIVERGENTE' when ea_or < 0 and ca_ec >0  then 'ACOMODADOR' when ea_or > 0 and ca_ec < 0  then 'ASIMILADOR' when ea_or < 0 and ca_ec <0  then 'CONVERGENTE' when ea_or = 0 and ca_ec >0  then 'ACOMODADOR/DIVERGENTE' when ea_or > 0 and ca_ec =0  then 'DIVERGENTE/ASIMILADOR' when ea_or = 0 and ca_ec < 0  then 'ASIMILADOR/CONVERGENTE' when ea_or < 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE' when ea_or = 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE/ASIMILADOR/DIVERGENTE'  end as tipo"& vbCrLf &_

"from (select distinct cast(p.pers_nrut as varchar) + '-' + p.pers_xdv as rut, p.pers_tape_paterno + ' ' + p.pers_tape_materno + ' ' + p.pers_tnombre as 						               	nombre,carr_tdesc as carrera, post_npaa_verbal as Paa_verbal,post_npaa_matematicas as paa_mate,protic.trunc(et.fecha)as fecha,"& vbCrLf &_
"preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a as ec,"& vbCrLf &_
"preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b  as o_r,"& vbCrLf &_
"preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c as ca,"& vbCrLf &_
"preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d as ea,"& vbCrLf &_
"((((preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d)-(preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b))*-1)+3)as ea_or,"& vbCrLf &_
"((((preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c)-(preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a))*-1)+2)as ca_ec"& vbCrLf &_

 
"from encuesta_test et,personas p,alumnos a,postulantes po,ofertas_academicas oa, especialidades esp,carreras car"& vbCrLf &_
"where et.pers_ncorr=p.pers_ncorr"& vbCrLf &_
"and et.pers_ncorr=a.pers_ncorr"& vbCrLf &_
"and a.ofer_ncorr=oa.ofer_ncorr"& vbCrLf &_
"and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
"and oa.post_bnuevo='S'"& vbCrLf &_
"and oa.espe_ccod=esp.espe_ccod"& vbCrLf &_
"and esp.carr_ccod=car.carr_ccod"& vbCrLf &_
"and a.post_ncorr=po.post_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro1&" "& vbCrLf &_
" " &filtro3&" )asa"& vbCrLf &_ 
"order by nombre"
else
sql_="select ''"
q_anos_ccod=0
end if				
				
				
'response.Write("<pre>"&sql_&"</pre>")
'response.Write("<pre>"&q_pers_xdv&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.Write("<pre>"&q_peri_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_


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


function dibujar(){
formulario = document.buscador;
formulario.submit();
}


function validar_select_peri_ccod(){


valor=document.buscador.elements["b[0][peri_ccod]"].value;

	if (valor!=''){
	return true;
	}
	else
	{
	alert('Debe selecionar un periodo Académico')
	document.buscador.elements["b[0][peri_ccod]"].focus()
	document.buscador.elements["b[0][peri_ccod]"].select();
	return false;	
	}
}


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
              <table width="95%"  border="0" align="center">
                <tr>
					
					<td width="24%"><strong>Rut  :</strong></td>
					<td width="13%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="2%">-</td>
					<td width="3%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="13%"></div></td>
					<td width="38%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					<table width="67%"  border="0" align="center">
					
              </table>
					 <table width="95%"  border="0" align="center">
					<tr>
					
				  	<td width="24%"><strong>Funcion:</strong></td>
				  	<td width="76%"><div align="left"><%f_busqueda.DibujaCampo("carr_ccod")%></div>
					
                </tr>
				<tr>
					
				  	<td width="24%"><strong>Sede:</strong></td>
				  	<td width="76%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>
					
                </tr>
				<tr>
					
				  	<td width="24%"><strong>Año Académico:</strong></td>
				  	<td width="76%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div>
					
                </tr>
				<tr>
					
				  	<td width="24%"><strong>*Periodo Académico:</strong></td>
				  	<td width="76%"><div align="left"><%f_busqueda.DibujaCampo("peri_ccod")%></div>
									  
				  	</tr>
					<tr><td colspan="2">* Se Utiliza solo para el Excel con las Asignaturas </td></tr>
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
		  <td><div align="center">
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
                    <td><%pagina.DibujarSubtitulo "Datos Descuentos"%>
					
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
				<%if q_anos_ccod > 1 then%>
                  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "resultados_test_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&carr_ccod="&q_carr_ccod&"&sede_ccod="&q_sede_ccod&"&anos_ccod="&q_anos_ccod
				   f_botonera.DibujaBoton"excel"  %></div></td>
				   
				  
					<td><div align="center">
                    
					<%f_botonera.DibujaBoton"listado"  %></div></td>
				   	<%end if%>	 
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