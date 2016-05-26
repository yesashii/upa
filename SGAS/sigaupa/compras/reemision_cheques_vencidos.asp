<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:02/10/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:73
'*******************************************************************
OPCION		= request.QueryString("OPCION")

if OPCION="" then
OPCION=1
end if

set pagina = new CPagina
pagina.Titulo = "Reemisión Cheques Vencidos"

set botonera = new CFormulario
botonera.carga_parametros "reemitir_cheques_vencidos.xml", "botonera"

v_eche_ndocto	= request.querystring("busqueda[0][eche_ndocto]")
v_banc_ccod		= request.querystring("busqueda[0][banc_ccod]")
v_banc_tcodigo		= request.querystring("busqueda[0][banc_tcodigo]")

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "reemitir_cheques_vencidos.xml", "buscador"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "eche_ndocto", v_eche_ndocto
f_busqueda.AgregaCampoCons "banc_ccod", v_banc_ccod
f_busqueda.AgregaCampoCons "banc_tcodigo", v_banc_tcodigo

' 88888888888888888888888888888888888888888888888888888888888888888888888888888

 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "reemitir_cheques_vencidos.xml", "reemitir_cheques_vencidos"
 
 IF OPCION = 1 THEN
	f_cheques.Inicializar conectar
 ELSE
	f_cheques.Inicializar conexion
 END IF
 
' 88888888888888888888888888888888888888888888888888888888888888888888888888888

' 88888888888888888888888888888888888888888888888888888888888888888888888888888
' JP 20131007

	set f_cheques_entregados = new CFormulario
	f_cheques_entregados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_cheques_entregados.Inicializar conectar
	
	' ACA  PREGUNTA POR LOS CHEQUES ENTREGADOS
	' sql_cheques_entregados= "select cpbnum from ocag_entrega_cheques"
	sql_cheques_entregados= "select eche_ndocto from ocag_entrega_cheques"
	f_cheques_entregados.Consultar sql_cheques_entregados
	f_cheques_entregados.siguiente

	'ACA CONSTRUYE EL FILTRO PARA DEJAR FUERA LOS CHEQUES ENTREGADOS
	if f_cheques_entregados.nrofilas>0 then
		for fila = 0 to f_cheques_entregados.nrofilas - 1
			inicio_filtro=" where a.NumDoc not in ("
			if fila=0 then
				filtro_sga= "'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
			else
				filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
			end if
			fin_filtro= ") "
			sql_filtro= inicio_filtro&" "&filtro_sga&" "&fin_filtro
			f_cheques_entregados.siguiente
		next
	end if


' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

IF OPCION = 1 THEN
	if v_eche_ndocto <> "" then
		filtro= " and a.eche_ndocto='"&v_eche_ndocto&"' "
	end if

	if v_banc_ccod <> "" then
		filtro= filtro&" and c.banc_ccod='"&v_banc_ccod&"' "
	end if
ELSE
	if v_eche_ndocto <> "" then
		filtro2= " AND a.NumDoc ='"&v_eche_ndocto&"' "
	end if

	if v_banc_tcodigo <> "" then
		filtro3= " AND c.pccodi ='"&v_banc_tcodigo&"' "
	end if
END IF

select case (OPCION)
	case 1:
	' CHEQUES ENTREGADOS 

		if request.QueryString()<>"" then

			sql_cheques	=	" select protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor  "& vbCrLf &_
									" , protic.trunc(a.eche_fdocto) as eche_fdocto, "& vbCrLf &_
									" a.eche_mmonto, a.eche_ndocto, a.cpbnum, a.pers_nrut, a.eche_ncorr "& vbCrLf &_
									" from ocag_entrega_cheques a "& vbCrLf &_
									" INNER JOIN personas b "& vbCrLf &_
									" ON a.pers_nrut = b.pers_nrut "& vbCrLf &_
									" LEFT OUTER JOIN ocag_bancos_softland c "& vbCrLf &_
									" ON a.banc_ccod = c.banc_tcodigo "& vbCrLf &_
									" where a.eche_ccod = 5 "& vbCrLf &_
									" "&filtro&" "

		else
			sql_cheques	=	"select '' where 1=2"												
		end if

	case 2:
	' CHEQUES NO ENTREGADOS

		if request.QueryString()<>"" then

			sql_cheques	=	" select b.nomaux as proveedor, convert(char(10), a.movfv,103) as eche_fdocto, cast(a.MovHaber as integer) as eche_mmonto "& vbCrLf &_
									" , cast(a.NumDoc as integer) as eche_ndocto, a.cpbnum, a.codaux AS pers_nrut, 'S' AS eche_ncorr "& vbCrLf &_
									" from softland.cwmovim a "& vbCrLf &_
									" INNER JOIN softland.cwtauxi b "& vbCrLf &_
									" ON a.codaux = b.codaux "& vbCrLf &_
									" AND a.ttdcod LIKE 'CV' "& vbCrLf &_
									" AND a.cpbano >= 2013 and a.movfv is not null "& vbCrLf &_
									" AND datediff(dd, a.movfv,getdate()) >= 120 "& vbCrLf &_
									"  "&filtro2&" "& vbCrLf &_
									" AND MovHaber > 0 "& vbCrLf &_
									" INNER JOIN softland.cwpctas c "& vbCrLf &_
									" ON a.pctcod = c.pccodi "& vbCrLf &_
									"  "&filtro3&" "& vbCrLf &_
									" AND a.cpbnum not in ( '00000000' ) "& vbCrLf &_ 
									" "&sql_filtro&" "& vbCrLf &_ 
									" order by year(a.movfv) desc, month(a.movfv) desc, day(a.movfv) desc, eche_ndocto desc "


		else
			sql_cheques	=	"select '' where 4=5"												
		end if

		
	End Select

'response.Write("<pre>"&sql_cheques&"</pre>")
'response.End()

f_cheques.Consultar sql_cheques

v_fecha_actual=conectar.consultaUno("select protic.trunc(getdate()) as fecha")
 
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

function Mensaje()
{
	<% 
		if session("mensaje_error")<>"" then
	%>
		alert("<%=session("mensaje_error")%>");
	<%
		session("mensaje_error")=""
		end if
	%>
}

function Enviar(){
	return true;
}

//88888888888888888888888888888888888

function ImprimirOC(){
	url="imprimir_oc.asp?ordc_ncorr=<%=ordc_ncorr%>";
	window.open(url,'ImpresionOC', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
	
	ocation.href="buscar_orden_compra.asp?ordc_ncorr=<%=ordc_ncorr%>&busqueda[0][area_ccod]="+v_area+"&v_boleta="+v_valor+"&pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}

//88888888888888888888888888888888888

function CambiaFechaGeneral(valor){
	formulario = document.datos;
	filas=<%=f_cheques.Nrofilas%>;
	for(i=0;i<filas;i++){
		formulario.elements["datos["+i+"][rche_frevalidacion]"].value=valor;
	}
}

function ActivaObservacion(objeto){
	formulario = document.datos;
	v_indice=extrae_indice(objeto.name);
	if(objeto.checked){
		formulario.elements["datos["+v_indice+"][rche_tobservacion]"].value="";
		formulario.elements["datos["+v_indice+"][rche_tobservacion]"].disabled=false;
	}else{
		formulario.elements["datos["+v_indice+"][rche_tobservacion]"].value="seleccione el cheque a revalidar";
		formulario.elements["datos["+v_indice+"][rche_tobservacion]"].disabled=true;
	}
}

function BuscarDocumentos()
{
	formulario = document.buscador;
	opcion	=	<%=OPCION%>;
	v_eche_ndocto	=	formulario.elements["busqueda[0][eche_ndocto]"].value;
	<% IF OPCION = 1 THEN %>
		v_banc_ccod	=	formulario.elements["busqueda[0][banc_ccod]"].value;
	<% ELSE %>
		v_banc_tcodigo	=	formulario.elements["busqueda[0][banc_tcodigo]"].value;
	<% END IF %>

	formulario.submit();
	
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Reemisón de Cheques Vencidos</font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
								<div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
								<BR>
					  
					  
<!-- AQUI ESTA EL INICIO DEL FORM DE BUSQUEDA -

								<br>
								<TABLE BORDER="0">
									<TR>
										<TD align="left">
											<%
											'pagina.DibujarLenguetasFClaro Array(array("Cheques Entregados","reemision_cheques_vencidos.asp?OPCION=1"),array("Cheques No Entregados","reemision_cheques_vencidos.asp?OPCION=2")), OPCION 
											%>
											
										<TD>
									</TR>
								</TABLE>
								<div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
								<br>
								
 AQUI ESTA EL FIN FORM DE BUSQUEDA -->					  
					  
					  
					  
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
					<form name="buscador">
					<input type="hidden" name="OPCION" value="<%=OPCION%>" />
						<td align="center">
							<table width="90%" border='1' bordercolor='#999999'>
							<th colspan="5">Busqueda de cheques</th>
							</tr>
								<tr> 
									<td width="9%"><strong>N&deg; Cheque</strong> </td>
									<td width="25%"><%f_busqueda.dibujaCampo("eche_ndocto")%></td>
								    <td width="6%"><strong>Banco</strong></td>
								    <td width="35%">
									<%
									IF OPCION = 1 THEN
										f_busqueda.dibujaCampo("banc_ccod")
									ELSE
										f_busqueda.dibujaCampo("banc_tcodigo")
									END IF
									%>
									</td>
								  	<td width="25%">
									<%
									'botonera.DibujaBoton "buscar" 
									botonera.DibujaBoton "buscar_2" 
									%></td>
								</tr>
							</table>
						</td>
					</form>
					</tr>
                  <tr> 
						<td>
						<br/>

							<form name="datos" method="post">
							<table align="right" width="100%"><tr>
									<td width="85%" align="right"><strong>Fecha revalidacion</strong></td>
								  	<td width="15%" align="left"><input type="text" name="fecha_revalidacion" value="<%=v_fecha_actual%>" onChange="CambiaFechaGeneral(this.value);"/></td>
							</tr></table>
							<p>&nbsp;</p>
								<table width="98%"  border="0" align="center">
								  <tr bgcolor='#C4D7FF'>
								    <th width="2%"></th>
									<th width="20%">Proveedor</th>
									<th width="13%">Monto</th>
                                    <th width="13%">N° Cheque</th>
									<th width="15%">Fecha Original </th>
									<th width="20%">Fecha Revalidacion </th>
									<th width="20%">Observacion</th>
								  </tr>
								  <%
								  ind=0
								  while f_cheques.Siguiente 
								  %>
								  <input type="hidden" name="datos[<%=ind%>][cpbnum]" value="<%=f_cheques.obtenerValor("cpbnum")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_numero]" value="<%=f_cheques.obtenerValor("eche_ndocto")%>" />
								  <input type="hidden" name="datos[<%=ind%>][eche_fdocto]" value="<%=f_cheques.obtenerValor("eche_fdocto")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_proveedor]" value="<%=f_cheques.obtenerValor("pers_nrut")%>" />
								  <input type="hidden" name="datos[<%=ind%>][eche_mmonto]" value="<%=f_cheques.obtenerValor("eche_mmonto")%>" />
								  <tr bgcolor='#FFFFFF'>
								   <td><div align="right"><input type="checkbox" name="datos[<%=ind%>][eche_ncorr]" value="<%=f_cheques.obtenerValor("eche_ncorr")%>" onClick="ActivaObservacion(this);"/></div></td>
									<td><div align="right"><%=UCase(f_cheques.obtenerValor("proveedor"))%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("eche_mmonto")%></div></td>
                                    <td><div align="right"><%=f_cheques.obtenerValor("eche_ndocto")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("eche_fdocto")%></div></td>
									<td><div align="center"><input type="text" name="datos[<%=ind%>][rche_frevalidacion]" value="<%=v_fecha_actual%>" size="12" id="FE-N"/></div></td>
									<td><div align="right"><input type="text" name="datos[<%=ind%>][rche_tobservacion]" value="seleccione el cheque a revalidar" disabled="disabled" size="40" id="TO-N"/></div></td>
								  </tr>
								  <%
								  ind=ind+1
								  wend%>
								</table>
							</form>
							<br>
							<table width="98%"  border="0" align="center">
							  <tr>
								<td  width="85%" >
									<div align="right">
										<%
											'botonera.DibujaBoton "guardar_2"
										%>
									</div>
								</td>
								<td  width="15%" >
									<div align="right">
										<%
											botonera.DibujaBoton "guardar"
										%>
									</div>
								</td>
							  </tr>
							</table>							
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
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
