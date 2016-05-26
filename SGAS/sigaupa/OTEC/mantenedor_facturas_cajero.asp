<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Facturas por cajeros"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "numeros_facturas_cajeros.xml", "botonera"
'-----------------------------------------------------------------------

v_sede_ccod = request.querystring("busqueda[0][sede_ccod]")
v_tfac_ccod = request.querystring("busqueda[0][tfac_ccod]")
v_pers_ncorr = request.querystring("busqueda[0][pers_ncorr]")
v_erfa_ccod = request.querystring("busqueda[0][erfa_ccod]")
v_inst_ccod = request.querystring("busqueda[0][inst_ccod]") 

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_facturas_cajeros.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_busqueda.AgregaCampoCons "tfac_ccod", v_tfac_ccod
 f_busqueda.AgregaCampoCons "pers_ncorr", v_pers_ncorr
 f_busqueda.AgregaCampoCons "erfa_ccod", v_erfa_ccod
  f_busqueda.AgregaCampoCons "inst_ccod", v_inst_ccod
'--------------------------------------------------------------------

set f_contrato = new CFormulario
f_contrato.Carga_Parametros "numeros_facturas_cajeros.xml", "f_facturas_cajero"
f_contrato.Inicializar conexion


if v_sede_ccod <> "" then
	filtro =" and  a.sede_ccod="&v_sede_ccod
end if
if v_inst_ccod <> "" then
	filtro =filtro&" and  inst_ccod="&v_inst_ccod
end if
if v_tfac_ccod <> "" then
	filtro =filtro&" and  a.tfac_ccod="&v_tfac_ccod
end if

if v_pers_ncorr <> "" then
	filtro =filtro&" and  b.pers_ncorr="&v_pers_ncorr
end if

if v_erfa_ccod <> "" then
	filtro =filtro&" and  a.erfa_ccod ="&v_erfa_ccod&" "
else
	filtro =filtro&" and  a.erfa_ccod in (1,2,3,4)"
end if

consulta	=	" Select rfca_ncorr,rfca_ncorr as c_rfca_ncorr,tfac_ccod,tfac_ccod as c_tfac_ccod,a.sede_ccod,inst_ccod, " & vbCrLf &_
				" a.sede_ccod as c_sede_ccod,rfca_ninicio,rfca_nfin,rfca_nactual,erfa_ccod,erfa_ccod as c_erfa_ccod, " & vbCrLf &_
				" protic.obtener_nombre_completo(b.pers_ncorr,'n') as cajero " & vbCrLf &_
				" from rangos_facturas_cajeros a, personas b " & vbCrLf &_
				" where  a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
				" "&filtro


'response.Write("<pre>"&consulta&"</pre>")		
'response.End()
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
		  v_estado=f_contrato.ObtenerValor ("erfa_ccod")
		  if v_estado <> 1 and v_estado <> 4 then
		  	f_contrato.AgregaCampoFilaParam fila,"rfca_ninicio","permiso", "LECTURA"
			f_contrato.AgregaCampoFilaParam fila,"rfca_nfin","permiso", "LECTURA"
			f_contrato.AgregaCampoFilaParam fila,"rfca_ncorr","eliminar", "False"
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
   
		 v_estado=document.edicion.elements["rango["+v_indice+"][c_erfa_ccod]"].value;
		  //v_estado=2; (Terminada)
		 if (v_estado=="2"){
		 	document.edicion.elements["rango["+v_indice+"][rfca_ncorr]"].disabled=true;
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
							<td width="179">Tipo Factura:</td>
							<td width="135"><% f_busqueda.DibujaCampo ("tfac_ccod") %></td>
							<td width="59">Cajero:</td>
							<td width="144"><% f_busqueda.DibujaCampo ("pers_ncorr") %></td>
                          </tr>
						<tr>
								<td width="179">Sedes:</td>
								<td width="135"><% f_busqueda.DibujaCampo ("sede_ccod") %></td>
								<td>Estado:</td>
								<td width="144"><% f_busqueda.DibujaCampo ("erfa_ccod") %></td>
                        </tr>
						<tr>
								<td width="179">Institucion:</td>
								<td width="135"><% f_busqueda.DibujaCampo ("inst_ccod") %></td>
							
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
				  <%pagina.DibujarSubtitulo "Correlativos de Facturas"%><br>
				 <table width="100%" border="0">
                    <tr> 
                      <td width="122">&nbsp;</td>
                      <td width="489"><div align="right">P&aacute;ginas: &nbsp; 
                         <%f_contrato.AccesoPagina%>
                        </div></td>
                      <td width="34"> <div align="right"> </div></td>
                    </tr>
                  </table> 
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
                      <td width="31%"> <div align="left"> 
					  <%
					  botonera.agregabotonparam "nuevo_rango", "url", "nuevo_rango_facturas_cajeros.asp?tfac_ccod="&v_tfac_ccod&"&sede_ccod="&v_sede_ccod&"&pers_ncorr="&v_pers_ncorr&"&inst_ccod="&v_inst_ccod 
					  botonera.DibujaBoton ("nuevo_rango")
					  %></div></td>
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
