<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Creditos"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "creditos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "creditos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "creditos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "creditos.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tdet_ccod",q_tdet_ccod
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod





if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
  filtro5=filtro5&"and e.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  	filtro6=filtro6&"and f.sede_ccod='" &q_sede_ccod&"'"			
end if

 if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  	filtro7=filtro7&"and f.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
					
end if
 
if q_tdet_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos="select stde_ccod as tdet_ccod,isnull(acre_ncorr,0)acre_ncorr, a.post_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=f.sede_ccod)sede,"& vbCrLf &_
"isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion "& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=f.peri_ccod)as perio"& vbCrLf &_
"from  sdescuentos a  left outer join alumno_credito b "& vbCrLf &_
"on a.post_ncorr=b.post_ncorr"& vbCrLf &_
"join alumnos d "& vbCrLf &_
"on a.post_ncorr=d.post_ncorr"& vbCrLf &_
"join personas e"& vbCrLf &_
"on d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"join ofertas_academicas f"& vbCrLf &_
"on d.ofer_ncorr=f.ofer_ncorr"& vbCrLf &_
"join especialidades g"& vbCrLf &_
"on f.espe_ccod=g.espe_ccod"& vbCrLf &_
"join carreras h"& vbCrLf &_
"on g.carr_ccod=h.carr_ccod"& vbCrLf &_

"where a.post_ncorr in (select post_ncorr from postulantes where peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")) "& vbCrLf &_
"and stde_ccod='" &q_tdet_ccod&"' and a.esde_ccod=1"& vbCrLf &_
"and a.post_ncorr not in (select a.post_ncorr from alumno_credito a , postulantes b where a.post_ncorr=b.post_ncorr and peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&"))"& vbCrLf &_
			" " &filtro5&" "& vbCrLf &_
			" " &filtro6&" "& vbCrLf &_
			" " &filtro7&" "& vbCrLf &_

"union"& vbCrLf &_
"select distinct tdet_ccod,acre_ncorr, a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion"& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
"and emat_ccod <>9"& vbCrLf &_
" and a.tdet_ccod='" &q_tdet_ccod&"'"& vbCrLf &_
		
			" " &filtro2&" "& vbCrLf &_
			" " &filtro1&" "& vbCrLf &_
			" " &filtro3&" "& vbCrLf &_
			" " &filtro4&" "& vbCrLf &_
 

"order by carrera,perio,nombre"





'"select acre_ncorr, post_ncorr,nombre, rut, carrera,sede,monto_bene,observacion,perio"& vbCrLf &_
'"from (select distinct acre_ncorr, a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,monto_bene,observacion"& vbCrLf &_
'",(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
'"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
'"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
'"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
'"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
'"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
'"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
'"and emat_ccod <>9"& vbCrLf &_
'"and a.tdet_ccod='1402'"& vbCrLf &_
'
'  
'  
'			" " &filtro2&" "& vbCrLf &_
'			" " &filtro1&" "& vbCrLf &_
'			" " &filtro3&" "& vbCrLf &_
'			" " &filtro4&" "& vbCrLf &_
'")asasd"& vbCrLf &_
'
'"where post_ncorr not in("& vbCrLf &_
'
'
'
'"select distinct a.post_ncorr"& vbCrLf &_
'"from alumno_credito a"& vbCrLf &_
'"join alumnos b"& vbCrLf &_
'"on a.post_ncorr=b.post_ncorr"& vbCrLf &_
'"and emat_ccod <>9"& vbCrLf &_
'"and a.tdet_ccod='1402'"& vbCrLf &_
'"join personas c"& vbCrLf &_
'"on b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
'"join ofertas_academicas d"& vbCrLf &_
'"on b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
'"join especialidades e"& vbCrLf &_
'"on d.espe_ccod=e.espe_ccod"& vbCrLf &_
'"join carreras f"& vbCrLf &_
'"on e.carr_ccod=f.carr_ccod"& vbCrLf &_
'"right outer join sdescuentos g"& vbCrLf &_
'"on a.post_ncorr=g.post_ncorr"& vbCrLf &_
'"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod=2008) )"& vbCrLf &_
'
'"union"& vbCrLf &_
'
'
'"select distinct acre_ncorr, a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,monto_bene,observacion"& vbCrLf &_
'",(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
'"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
'
'"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
'"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
'"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
'"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
'"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
'"and emat_ccod <>9"& vbCrLf &_
'
'			" " &filtro2&" "& vbCrLf &_
'			" " &filtro1&" "& vbCrLf &_
'			" " &filtro3&" "& vbCrLf &_
'			" " &filtro4&" "& vbCrLf &_
'			
'"order by carrera,perio,nombre"




 '"select acre_ncorr, a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,monto_bene,observacion,(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
' 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
'				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
'				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
'				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
'				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
'				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
'				"and emat_ccod <>9"& vbCrLf &_
'				" " &filtro2&" "& vbCrLf &_
'				" " &filtro1&" "& vbCrLf &_
'				" " &filtro3&" "& vbCrLf &_
'				" " &filtro4&" "& vbCrLf &_
'				"order by carrera,perio,nombre"
				
				'conexion.ConsultaUno(
				numero_total=conexion.ConsultaUno("select count(post_ncorr) from(select stde_ccod as tdet_ccod,isnull(acre_ncorr,0)acre_ncorr, a.post_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=f.sede_ccod)sede,"& vbCrLf &_
"isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion "& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=f.peri_ccod)as perio"& vbCrLf &_
"from  sdescuentos a  left outer join alumno_credito b "& vbCrLf &_
"on a.post_ncorr=b.post_ncorr"& vbCrLf &_
"join alumnos d "& vbCrLf &_
"on a.post_ncorr=d.post_ncorr"& vbCrLf &_
"join personas e"& vbCrLf &_
"on d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"join ofertas_academicas f"& vbCrLf &_
"on d.ofer_ncorr=f.ofer_ncorr"& vbCrLf &_
"join especialidades g"& vbCrLf &_
"on f.espe_ccod=g.espe_ccod"& vbCrLf &_
"join carreras h"& vbCrLf &_
"on g.carr_ccod=h.carr_ccod"& vbCrLf &_

"where a.post_ncorr in (select post_ncorr from postulantes where peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")) "& vbCrLf &_
"and stde_ccod='" &q_tdet_ccod&"' and a.esde_ccod=1"& vbCrLf &_
"and a.post_ncorr not in (select a.post_ncorr from alumno_credito a , postulantes b where a.post_ncorr=b.post_ncorr and peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&"))"& vbCrLf &_
			" " &filtro5&" "& vbCrLf &_
			" " &filtro6&" "& vbCrLf &_
			" " &filtro7&" "& vbCrLf &_

"union"& vbCrLf &_
"select distinct tdet_ccod,acre_ncorr, a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre ,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede,isnull(cast(monto_bene as varchar),'') as monto_bene,isnull(observacion,'')as observacion"& vbCrLf &_
",(select peri_tdesc from periodos_academicos where peri_ccod=d.peri_ccod)as perio"& vbCrLf &_
"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
"and emat_ccod <>9"& vbCrLf &_
" and a.tdet_ccod='" &q_tdet_ccod&"'"& vbCrLf &_
		
			" " &filtro2&" "& vbCrLf &_
			" " &filtro1&" "& vbCrLf &_
			" " &filtro3&" "& vbCrLf &_
			" " &filtro4&" "& vbCrLf &_
 

")aaa")
				
 'response.write(numero_total)
total=numero_total			
end if


					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos

usu=negocio.obtenerUsuario
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
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="17%"><strong>Rut  :</strong></td>
					
					<td width="11%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					
					 <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><p><strong>Creditos</strong>
				  	 </td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("tdet_ccod")%></div>
					
                </tr>
              </table>
			   <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Sedes:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>
					
                </tr>
              </table>
			  <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Periodos Academico:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div>
					
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
                    <td><%pagina.DibujarSubtitulo "Datos Créditos"%>
					
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
				 <% if usu <>"12284733" then%>
				 <td><div align="center">
                   
					<%f_botonera.AgregaBotonParam "crear", "url", "agrega_alumno.asp"
				   f_botonera.DibujaBoton"crear"  %></div>
				   </td><% end if%>
                  <td><div align="center">
				  
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "creditos_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&tdet_ccod="&q_tdet_ccod&"&sede_ccod="&q_sede_ccod&"&anos_ccod="&q_anos_ccod
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