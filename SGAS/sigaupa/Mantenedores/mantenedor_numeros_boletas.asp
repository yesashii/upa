<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantiene Boletas por Sedes"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "numeros_boletas_venta.xml", "botonera"
'-----------------------------------------------------------------------

v_sede_ccod = request.querystring("busqueda[0][sede_ccod]")
v_tbol_ccod = request.querystring("busqueda[0][tbol_ccod]")
v_inst_ccod = request.querystring("busqueda[0][inst_ccod]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_boletas_venta.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_busqueda.AgregaCampoCons "tbol_ccod", v_tbol_ccod
 f_busqueda.AgregaCampoCons "inst_ccod", v_inst_ccod
'--------------------------------------------------------------------

set f_contrato = new CFormulario
f_contrato.Carga_Parametros "numeros_boletas_venta.xml", "f_boletas"
f_contrato.Inicializar conexion


if v_sede_ccod <> "" then
	filtro =" and  sede_ccod="&v_sede_ccod
end if

if v_tbol_ccod <> "" then
	filtro =filtro&" and  tbol_ccod="&v_tbol_ccod
end if

if v_inst_ccod <> "" then
	filtro =filtro&" and  inst_ccod="&v_inst_ccod 
end if

if v_tbol_ccod <> "" and  esVacio(v_sede_ccod) then
	'filtro =" where tbol_ccod="&v_tbol_ccod
end if



consulta	=	" Select a.rbol_ncorr,protic.cantidad_boletas_rango(a.sede_ccod,a.tbol_ccod,a.rbol_ncorr) as cantidad, " & vbCrLf &_
				" a.rbol_ncorr as c_rbol_ncorr,a.tbol_ccod, a.tbol_ccod as c_tbol_ccod,a.sede_ccod, a.rbol_ninicio," & vbCrLf &_
				" a.rbol_nfin,b.erbo_tdesc, a.erbo_ccod as c_erbo_ccod  " & vbCrLf &_
				" from RANGOS_BOLETAS_SEDES a, estados_rangos_boletas b " & vbCrLf &_
				" where  a.erbo_ccod in (1,4)" & vbCrLf &_
				" and a.erbo_ccod=b.erbo_ccod "& vbCrLf &_
				" "&filtro


'response.Write("<pre>"&consulta&"</pre>")		
if not Esvacio(Request.QueryString) then
 	  f_contrato.Consultar consulta
else
	 f_contrato.Consultar "select '' where 1=2"
	 f_contrato.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if


'=================================================================================
 cantidad=f_contrato.nroFilas
 if cantidad >0 then
 fila=0
	while f_contrato.siguiente
		
		  'response.Write("<br>Estado : "&f_contrato.ObtenerValor ("estado"))
		  v_estado=f_contrato.ObtenerValor("c_erbo_ccod")
		  if v_estado <> 1 and v_estado <> 4 then
		  	f_contrato.AgregaCampoFilaParam fila,"rbol_ninicio","permiso", "LECTURA"
			f_contrato.AgregaCampoFilaParam fila,"rbol_nfin","permiso", "LECTURA"
			f_contrato.AgregaCampoFilaParam fila,"rbol_ncorr","eliminar", "False"
		  end if
		  fila=fila+1
	wend	
 end if
 
 f_contrato.primero
'================================================================================= 


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
function Elimina_Rangos(form){
//alert ("no implementado aun");
//return false;
mensaje="Terminar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 

function Guardar_Rangos(form){
mensaje="Guardar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 


function apaga_check(){
   nro = document.edicion.elements.length;
 
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
	   
	     num += 1;
		 v_indice=extrae_indice(str);
		   
		 v_estado=document.edicion.elements["rango["+v_indice+"][c_erbo_ccod]"].value;
		// v_estado=2 (Terminada)
		 if (v_estado=="2"){
		 	document.edicion.elements["rango["+v_indice+"][rbol_ncorr]"].disabled=true;
		 }
	  }
   }
}

</script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_check();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de contratos para activar"), 1 %></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><div align="center">
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
							<td width="95">Tipo Boleta</td>
							<td width="113"><% f_busqueda.DibujaCampo ("tbol_ccod") %></td>
							<td width="145">&nbsp;</td>
							<td width="84">Empresa:</td>
							<td width="80"><% f_busqueda.DibujaCampo ("inst_ccod") %></td>
							<td width="84">Sedes:</td>
							<td width="80"><% f_busqueda.DibujaCampo ("sede_ccod") %></td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
				  <%pagina.DibujarSubtitulo "Correlativos de Boletas"%><br>
				  <form name="edicion">
					<% f_contrato.DibujaTabla() %>
				
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">
                        <%
					   'if estado = "" then
					   if	f_contrato.NroFilas = 0 then
							botonera.agregabotonparam "eliminar", "deshabilitado" ,"TRUE"							   
					   end if
						botonera.DibujaBoton ("eliminar")
					   %>
                      </td>
                      <td width="20%"> <div align="left">
                        <%
					   'if estado = "" then
					   if	f_contrato.NroFilas = 0 then
							botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"							   
					   end if
						botonera.DibujaBoton ("guardar")
					   %> 
                        </div></td>
                      <td width="31%"> <div align="left"> <%
					  botonera.agregabotonparam "nuevo_rango", "url", "nuevo_rango_boletas.asp?tbol_ccod="&v_tbol_ccod&"&sede_ccod="&v_sede_ccod&"&inst_ccod="&v_inst_ccod
					  botonera.DibujaBoton ("nuevo_rango")%></div></td>
                      <td width="49%"> <div align="left"> 
                          <%botonera.DibujaBoton ("salir")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="157" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
