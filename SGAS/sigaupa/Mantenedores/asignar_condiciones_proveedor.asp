
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
'FECHA ACTUALIZACION 	:30/07/2013
'ACTUALIZADO POR	:MICHAEL SHAW
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:267
'*******************************************************************
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")

set pagina = new CPagina
pagina.Titulo = "Asignar Condiciones Proveedores"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conectar = new Cconexion2
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asignar_condiciones_proveedor.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "asignar_condiciones_proveedor.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

'v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
'pers_ncorr = v_pers_ncorr


if  not EsVacio(q_pers_nrut)  then
	'nombre_persona = conexion.ConsultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='" & q_pers_nrut & "'")
	nombre_persona = conectar.ConsultaUno("select NomAux from softland.cwtauxi where cast(CodAux as varchar)='" & q_pers_nrut & "'")
	
	'RESPONSE.WRITE("select NomAux from softland.cwtauxi where cast(CodAux as varchar)='" & q_pers_nrut & "'"&"<BR>") 
	'RESPONSE.WRITE("nombre_persona: "&nombre_persona&"<BR>")
	
	if  EsVacio(nombre_persona)  then
	
		session("mensaje_error")="No se encuentra el Rut"
		response.Redirect("perfiles_areas_usuarios.asp")
	
	end if
	
end if


if q_pers_nrut <> "" then
'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "asignar_condiciones_proveedor.xml", "datos_empresa"
'formulario.Inicializar conexion
formulario.Inicializar conectar

'sql_comentarios ="Select pers_nrut,pers_xdv,pers_tnombre from personas where pers_nrut="&q_pers_nrut
sql_comentarios ="select TOP 1 CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre from softland.cwtauxi where cast(CodAux as varchar)='"&q_pers_nrut&"'"

'RESPONSE.WRITE("sql_comentarios: "&sql_comentarios&"<BR>")

formulario.Consultar sql_comentarios
formulario.Siguiente
'--------------------------------------------------------------------------------------------------

set asginacion = new CFormulario
asginacion.Carga_Parametros "asignar_condiciones_proveedor.xml", "asig_empresa"
asginacion.Inicializar conexion
sql_asginacion ="select copr_ncorr,cpag_tdesc,case cpag_estado when 1 then 'Activo' else 'Inactivo' end  as cpag_estado from ocag_condiciones_proveedores p, ocag_condiciones_de_pago c where p.cpag_ccod = c.cpag_ccod and pers_nrut ="&q_pers_nrut

'RESPONSE.WRITE("sql_asginacion: "&sql_asginacion&"<BR>")
	
asginacion.Consultar sql_asginacion

v_pers_nrut = formulario.ObtenerValor("pers_nrut")
v_pers_xdv = formulario.ObtenerValor("pers_xdv")

sql_contar="select count(*) as contar from ocag_condiciones_proveedores p, ocag_condiciones_de_pago c where p.cpag_ccod = c.cpag_ccod and pers_nrut ="&q_pers_nrut

'RESPONSE.WRITE("sql_contar: "&sql_contar&"<BR>")

contar =  conexion.ConsultaUno(sql_contar)
'response.Write(contar)
else


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

<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function asignar_condicion(){
	 var contar = '<%=contar%>'
	 if (contar<3){
	window.open("crea_asignacion_proveedores.asp?pers_nrut=<%=v_pers_nrut%>&pers_xdv=<%=v_pers_xdv%>&estado=<%=contar%>","nuevo_comentario"," width=750, height=400,scrollbars,  toolbar=false, resizable");
	 }else{
		 alert("No puede Asignar más de 3 condiciones por Proveedor")
	 }
	 
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
                        <td width="32%"><div align="right"><strong>R.U.T</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
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
</div>		
	<%if q_pers_nrut <> "" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td width="15%"><strong>Rut</strong></td>
                    <td width="85%"><%formulario.dibujaCampo("pers_nrut")%>-<%formulario.dibujaCampo("pers_xdv")%></td>
                </tr>
				<tr>
                    <td><strong>Empresa</strong></td>
                    <td><%formulario.dibujaCampo("pers_tnombre")%></td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr><td colspan="2">&nbsp;</td></tr>
               

              </table> 
              <table width="46%" border="0" align="center">
                      <tr>
						<td><%asginacion.DibujaTabla()%></td>
						</tr>
                    </table>
              <table>
               <tr><td><%f_botonera.DibujaBoton("nueva_condicion")%></td><td><%f_botonera.DibujaBoton("eliminar")%></td></tr>
              </table>
              
            </form>  
            <%end if%>          
            </td></tr>            
      </table>
		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%"> 
                          
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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