<!-- #include file = "ver_asiento_generador.asp" -->
<%
set pagina = new CPagina


set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"

v_solicitud	= request.querystring("cod_solicitud")
v_tsol_ccod	= request.querystring("tsol_ccod")
v_boleta	= request.querystring("t_boleta")

select case v_tsol_ccod
	case 1:
		text="Pago Proveedor N° "&v_solicitud
	case 2:
		text="Rembolso de Gasto N° "&v_solicitud
	case 3:
		text="Fondo a Rendir N° "&v_solicitud
	case 4:
		text="Solicitud de Viatico N° "&v_solicitud
	case 5:
		text="Devolución de Alumno N° "&v_solicitud
	case 6:
		text="Fondo Fijo N° "&v_solicitud
	case 7:
		text="Rendición Fondo a Rendir N° "&v_solicitud
	case 8:
		text="Rendición Fondo Fijo N° "&v_solicitud
end select
pagina.Titulo = "Ver Asientos"
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set f_doctos = new CFormulario
f_doctos.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_doctos.Inicializar conectar

set f_efes_boleta = new CFormulario
f_efes_boleta.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_efes_boleta.Inicializar conectar

set f_efes = new CFormulario
f_efes.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_efes.Inicializar conectar

sql_doctos=generadorcosto(v_tsol_ccod,v_solicitud)
sql_efes_boleta = generadorpresupuesto(v_tsol_ccod,v_solicitud)
sql_efes = generadorpresupuestototal(v_tsol_ccod,v_solicitud)

'response.write "<pre>"&sql_doctos &"</pre>"
'response.write "<pre>"&sql_efes_boleta &"</pre>"
'response.write "<pre>"&sql_efes &"</pre>"

f_doctos.Consultar sql_doctos
f_efes_boleta.Consultar sql_efes_boleta
f_efes.Consultar sql_efes
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

function Enviar(){
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td background="../imagenes/top_r1_c2.gif"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos Solicitud</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>

              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font><br><% response.write text %></div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
						<td>
						<br/>
						<strong><font color="000000" size="1"> </font></strong>
							<form name="datos" method="post">
							  <table width="98%"  border="0" align="center">
                                <tr SIZE=2 bgcolor='#C4D7FF'>
                                  <th width="13%">Cod.<BR>Cuenta</th>
                                  <th width="25%">Nombre<BR>Cuenta</th>
                                  <th width="8%">Debe</th>
                                  <th width="8%">Haber</th>
                                  <th width="19%">Fecha<br>Pago</th>
                                  <th width="12%">Rut</th>
								  <th width="12%">C.Costo<BR>PPTO</th>
                                  <th width="5%">Tipo<BR>doc.</th>
                                </tr>
								<%
								while f_doctos.Siguiente 
									if clng(f_doctos.obtenerValor("TSOF_HABER")) > 0 then 
										response.write "<tr bgcolor='#CCFFFF'><td>" & f_doctos.obtenerValor("TSOF_PLAN_CUENTA") &"</td>"
									else
										response.write "<tr bgcolor='#FFFFFF'><td>" & f_doctos.obtenerValor("TSOF_PLAN_CUENTA") &"</td>"
									end if
									response.write "<td>" & nombre(f_doctos.obtenerValor("TSOF_PLAN_CUENTA")) &"</td>"
									response.write "<td>" & formatnumber(clng(f_doctos.obtenerValor("TSOF_DEBE")),0) &"</td>"
									if f_doctos.obtenerValor("boleta") = "2" then
										response.write "<td>" & formatnumber(clng(f_doctos.obtenerValor("TSOF_HABER"))*0.9,0) &"</td>"
									else
										response.write "<td>" & formatnumber(clng(f_doctos.obtenerValor("TSOF_HABER")),0) &"</td>"
									end if
									if muestravalor(f_doctos.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc") then 
										response.write "<td>" & f_doctos.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_doctos.obtenerValor("TSOF_PLAN_CUENTA"), "pcauxi") then 
										response.write "<td>" & f_doctos.obtenerValor("TSOF_COD_AUXILIAR") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_doctos.obtenerValor("TSOF_PLAN_CUENTA"), "pcccos") then 
										response.write "<td>" & f_doctos.obtenerValor("TSOF_COD_CENTRO_COSTO")& "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_doctos.obtenerValor("TSOF_PLAN_CUENTA"), "pcdetg") then
										response.write "<td>" & f_doctos.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& "," & f_doctos.obtenerValor("TSOF_NRO_DOC_REFERENCIA") &"</td></tr>"
									else
										response.write "<td></td></tr>"
									end if
									if f_doctos.obtenerValor("rete") = "1" AND f_doctos.obtenerValor("boleta") = "1" then
										response.write "<tr bgcolor='#FFFFFF'><td> 2-10-120-10-000003</td>"
										response.write "<td> "& nombre("2-10-120-10-000003") &"</td>"
										response.write "<td>0</td>"
										if f_doctos.obtenerValor("boleta") = "1" then
											response.write "<td>" & formatnumber(clng( f_doctos.obtenerValor("TSOF_DEBE"))*0.1,0) &"</td>"
										else
											response.write "<td>" & formatnumber(clng( f_doctos.obtenerValor("TSOF_DEBE"))*0.19,0) &"</td>"
										end if
										if muestravalor("2-10-120-10-000003", "pccdoc") then 
											response.write "<td>" & f_doctos.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & "</td>"
										else
										response.write "<td> </td>"
										end if
										if muestravalor("2-10-120-10-000003", "pcauxi") then 
											response.write "<td>" & f_doctos.obtenerValor("TSOF_COD_AUXILIAR") & "</td>"
										else
											response.write "<td> </td>"
										end if
										if muestravalor("2-10-120-10-000003", "pcccos") then 
											response.write "<td>" & f_doctos.obtenerValor("TSOF_COD_CENTRO_COSTO")& "</td>"
										else
											response.write "<td> </td>"
										end if
										if muestravalor(f_doctos.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc") then
											response.write "<td>" & f_doctos.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& "," & f_doctos.obtenerValor("TSOF_NRO_DOC_REFERENCIA") &"</td></tr>"
										else
											response.write "<td></td></tr>"
										end if
									end if
									ind=ind+1
								wend
								ind=0
								while f_efes_boleta.Siguiente
									response.write "<tr bgcolor='#FFFFCC'><td>" & f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA") &"</td>"
									response.write "<td>" & nombre(f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA")) &"</td>"
									response.write "<td>" & formatnumber(clng(f_efes_boleta.obtenerValor("TSOF_DEBE")),0) &"</td>"
									if f_efes_boleta.obtenerValor("boleta") = "1" AND v_tsol_ccod = 7 then
										response.write "<td>" & formatnumber(clng(f_efes_boleta.obtenerValor("TSOF_HABER"))*0.9,0) &"</td>"
									else
										response.write "<td>" & formatnumber(clng(f_efes_boleta.obtenerValor("TSOF_HABER")),0) &"</td>"
									end if
									if muestravalor(f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc") then 
										response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA"), "pcauxi") then 
										response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_COD_AUXILIAR") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA"), "pcprec") then 
										response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_COD_CENTRO_COSTO")& "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes_boleta.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc")then
										response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& "," & f_efes_boleta.obtenerValor("TSOF_NRO_DOC_REFERENCIA") &"</td></tr>"
									else
										response.write "<td></td></tr>"
									end if
									if f_efes_boleta.obtenerValor("rete") = "1" AND f_efes_boleta.obtenerValor("boleta") = "1" then
										response.write "<tr bgcolor='#FFFFCC'><td>2-10-120-10-000003</td>"
										response.write "<td>"& nombre("2-10-120-10-000003")&"</td>"
										response.write "<td>0</td>"
										if f_efes_boleta.obtenerValor("boleta") = "1" then
											response.write "<td>" & formatnumber(clng( f_efes_boleta.obtenerValor("TSOF_DEBE"))*0.1,0) &"</td>"
										else
											response.write "<td>" & formatnumber(clng( f_efes_boleta.obtenerValor("TSOF_DEBE"))*0.19,0) &"</td>"
										end if
										if muestravalor("2-10-120-10-000003", "pccdoc") then 
											response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & "</td>"
										else
										response.write "<td> </td>"
										end if
										if muestravalor("2-10-120-10-000003", "pcauxi") then 
											response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_COD_AUXILIAR") & "</td>"
										else
											response.write "<td> </td>"
										end if
										if muestravalor("2-10-120-10-000003", "pcccos") then 
											response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_COD_CENTRO_COSTO")& "</td>"
										else
											response.write "<td> </td>"
										end if
										if muestravalor("2-10-120-10-000003", "pccdoc") then
											response.write "<td>" & f_efes_boleta.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& "," & f_efes_boleta.obtenerValor("TSOF_NRO_DOC_REFERENCIA") &"</td></tr>"
										else
											response.write "<td></td></tr>"
										end if
									end if
									ind=ind+1
								wend
								ind = 0
								while f_efes.Siguiente
									if f_efes.obtenerValor("TSOF_PLAN_CUENTA") = "2-10-070-10-000002" then 
										response.write "<tr bgcolor='#CCFFCC'><td>" & f_efes.obtenerValor("TSOF_PLAN_CUENTA") &"</td>"
									else
										response.write "<tr bgcolor='#CCFFCC'><td>" & f_efes.obtenerValor("TSOF_PLAN_CUENTA") &"</td>"
									end if
									response.write "<td>" & nombre(f_efes.obtenerValor("TSOF_PLAN_CUENTA")) &"</td>"
									if f_efes.obtenerValor("boleta") = "1" then
										response.write "<td>" & formatnumber(f_efes.obtenerValor("TSOF_DEBE"),0) &"</td>"
									else
										response.write "<td>" & formatnumber(clng(f_efes.obtenerValor("TSOF_DEBE")),0) &"</td>"
									end if
									if f_efes.obtenerValor("boleta") = "1" then
										response.write "<td>" & formatnumber(clng(f_efes.obtenerValor("TSOF_HABER")),0) &"</td>"
									else
										response.write "<td>" & formatnumber(clng(f_efes.obtenerValor("TSOF_HABER")),0) &"</td>"
									end if
									if muestravalor(f_efes.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc") then 
										response.write "<td>" & f_efes.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes.obtenerValor("TSOF_PLAN_CUENTA"), "pcauxi") then 
										response.write "<td>" & f_efes.obtenerValor("TSOF_COD_AUXILIAR") & "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes.obtenerValor("TSOF_PLAN_CUENTA"), "pcprec") then 
										response.write "<td>" & f_efes.obtenerValor("TSOF_COD_CENTRO_COSTO")& "</td>"
									else
										response.write "<td> </td>"
									end if
									if muestravalor(f_efes.obtenerValor("TSOF_PLAN_CUENTA"), "pccdoc")then
										response.write "<td>" & f_efes.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& "," & f_efes.obtenerValor("TSOF_NRO_DOC_REFERENCIA") &"</td></tr>"
									else
										response.write "<td></td></tr>"
									end if
									ind=ind+1
								wend								
								%>

                              </table>
							</form>
							<br>
							</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"></td>
					  <td width="30%"><%botonera.dibujaboton "cerrar"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
