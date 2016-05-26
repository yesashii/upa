<%
inici = Timer
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
CI = Timer
Temps1 = CI - inici
Server.ScriptTimeout = 150000 
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Contratos por día y caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_timer			= Request.QueryString("timer")
inicio			= request.querystring("busqueda[0][inicio]")
termino 		= request.querystring("busqueda[0][termino]")
v_sede_ccod  	= request.querystring("busqueda[0][sede_ccod]")
v_pers_ncorr 	= request.querystring("busqueda[0][pers_ncorr]")
v_periodo 		= request.querystring("busqueda[0][periodo]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "contratos_x_cajas.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_busqueda.AgregaCampoCons "pers_ncorr", v_pers_ncorr
 f_busqueda.AgregaCampoCons "periodo", v_periodo
 f_busqueda.AgregaCampoCons "inicio", inicio
 f_busqueda.AgregaCampoCons "termino", termino



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "contratos_x_cajas.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "contratos_x_cajas.xml", "lista_contratos"


if v_sede_ccod <> "" then
	filtro =" and  f.sede_ccod="&v_sede_ccod
end if


if v_pers_ncorr <> "" then
	filtro =filtro&" and  k.pers_ncorr="&v_pers_ncorr
end if
 
if inicio <> "" then
	if termino <> "" then
	filtro =filtro&" and  convert(datetime,j.mcaj_finicio,103)BETWEEN convert(datetime,'"&inicio&"',103) AND convert(datetime,'"&termino&"',103)"	
	else
	filtro =filtro&" and  protic.trunc(convert(datetime,j.mcaj_finicio,103))=protic.trunc(convert(datetime,'"&inicio&"',103)) "
	end if
end if

if v_periodo <> "0" then
	filtro =filtro&" and cast(d.peri_ccod as varchar)='"&v_peri_ccod&"' "
end if


' Ocupando las tablas sdescuentos como pase de matricula, (porque no estaba bien definido el pase matricula)
consulta = " Select isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.contrato as n_contrato,g.sede_tdesc, "& vbCrLf &_
			" protic.obtener_nombre_carrera(f.ofer_ncorr,'C') as carrera,h.jorn_tdesc,i.econ_tdesc, "& vbCrLf &_
			" protic.obtener_nombre_completo(e.pers_ncorr,'n') as alumno, protic.trunc(d.cont_fcontrato) as fecha, "& vbCrLf &_
			" protic.obtener_nombre(k.pers_ncorr,'c') as cajero, "& vbCrLf &_
			" Case e.post_bnuevo when 'S' then 'Nuevo' when 'N' then 'Antiguo' end as tipo_alumno, "& vbCrLf &_
		    " case cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)   "& vbCrLf &_
		    " when 0 then 'Completo' "& vbCrLf &_
		    " when 50 then 'Medio' "& vbCrLf &_
		    " when 100 then 'Matricula'  "& vbCrLf &_
		    " when 999 then 'Completo'  "& vbCrLf &_
		    " end as tipo_contrato "& vbCrLf &_
			" From  "& vbCrLf &_
			" ingresos a  "& vbCrLf &_
			" join abonos b  "& vbCrLf &_
			"     on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
			" join compromisos c "& vbCrLf &_
			"     on b.comp_ndocto=c.comp_ndocto "& vbCrLf &_
			"     and b.tcom_ccod=c.tcom_ccod "& vbCrLf &_
			"     and b.inst_ccod=c.inst_ccod "& vbCrLf &_
			" 	  and c.tcom_ccod in (1,2) "& vbCrLf &_
			" join contratos d "& vbCrLf &_
			"     on c.comp_ndocto=d.cont_ncorr "& vbCrLf &_
			" join postulantes e "& vbCrLf &_
			"     on d.post_ncorr=e.post_ncorr "& vbCrLf &_
			" join ofertas_academicas f "& vbCrLf &_
			"     on e.ofer_ncorr=f.ofer_ncorr    "& vbCrLf &_
			" join sedes g "& vbCrLf &_
			"     on f.sede_ccod=g.sede_ccod    "& vbCrLf &_     
			" join jornadas h "& vbCrLf &_
			"     on f.jorn_ccod=h.jorn_ccod   "& vbCrLf &_
			" join estados_contrato i "& vbCrLf &_
			"     on d.econ_ccod=i.econ_ccod   "& vbCrLf &_
			" join movimientos_cajas j "& vbCrLf &_
			"    on a.mcaj_ncorr=j.mcaj_ncorr "& vbCrLf &_
			" join cajeros k "& vbCrLf &_
			"    on j.caje_ccod=k.caje_ccod "& vbCrLf &_
			"  left outer join sdescuentos m "& vbCrLf &_
			"	on e.post_ncorr=m.post_ncorr "& vbCrLf &_
			"	and e.ofer_ncorr=m.ofer_ncorr "& vbCrLf &_
			"   and m.stde_ccod=1262 "& vbCrLf &_
			" where a.ting_ccod=7 "& vbCrLf &_
			" and d.econ_ccod not in (2,3) "& vbCrLf &_
			" " &filtro&" "& vbCrLf &_
			" group by m.sdes_nporc_colegiatura,e.post_bnuevo,k.pers_ncorr,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.cont_ncorr,d.contrato,g.sede_tdesc,h.jorn_tdesc,protic.obtener_nombre_carrera(f.ofer_ncorr,'C'),protic.obtener_nombre_completo(e.pers_ncorr,'n')"



lista.inicializar conexion 


'response.Write("<pre>"&consulta&"</pre>")		
'response.Flush()
'response.End()	 
if not Esvacio(Request.QueryString) then
	lista.Consultar consulta

	if lista.nroFilas > 0 then
		cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
	else
		cantidad_encontrados=0
	end if
	
else
	 lista.Consultar "select '' where 1=2"
	 lista.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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

function enviar(formulario)
{
document.buscador.method="get";
document.buscador.action="contratos_x_dias.asp";
document.buscador.submit();
}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][inicio]","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "busqueda[0][termino]","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="27%" height="23"><strong>Fecha de caja </strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><% f_busqueda.DibujaCampo ("inicio")%>
						  <%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa) </td>
                        </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td><% f_busqueda.DibujaCampo ("termino") %>
                        <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                            (dd/mm/aaaa)</td>
                      </tr>
                      <tr>
                        <td><strong>Cajero</strong></td>
                        <td>:</td>
                        <td><% f_busqueda.DibujaCampo ("pers_ncorr") %></td>
                      </tr>
                      <tr>
                        <td><strong>Sede</strong></td>
                        <td>:</td>
                        <td><% f_busqueda.DibujaCampo ("sede_ccod") %></td>
                      </tr>
                      <tr>
                        <td><strong>Periodo Actual </strong></td>
                        <td>:</td>
                        <td><% f_busqueda.DibujaCampo ("periodo") %></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Contrato(s) &nbsp;
					   <%if not Esvacio(inicio) then%>
					      para el <%=inicio%>
					   <%end if%>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%lista.accesopagina%>
                             </td>
                            </tr>
                               <tr>
                                 <td align="center">
                                    <%lista.dibujaTabla()%>
                                 </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
						  </table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <% if cantidad_encontrados = 0 then
				                                                f_botonera.agregabotonparam "excel","deshabilitado","TRUE"    
															end if																             
										   f_botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
<%
Fi = Timer
Temps = fi - inici
if v_timer="1" then
	response.write("<br>Tiempo Includes: "&Temps1&" seg.")
	response.write("<br>Tiempo Total: "&Temps&" seg.")
end if 
%>