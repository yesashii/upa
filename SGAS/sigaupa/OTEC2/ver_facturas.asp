<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Maneja Facturas"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()
v_sede=negocio.ObtenerSede
'response.Write("<pre>"&v_usuario&"</pre>")

	set cajero = new CCajero
	cajero.Inicializar conexion, v_usuario, v_sede
	'response.End()	
	v_mcaj_ncorr=cajero.ObtenerCajaAbierta()
	

if not cajero.tienecajaabierta then
	msg_alert="No existen facturas para manejar, ya que no registra caja abierta"
	ini_ocultar="<!--"
	fin_ocultar="-->"
else
	msg_alert=""
end if
'response.End()

'set errores = new CErrores


set botonera = new CFormulario
botonera.Carga_Parametros "factura.xml", "botonera"
'-----------------------------------------------------------------------


 rut_alumno 		= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 	= request.querystring("busqueda[0][pers_xdv]")
 v_folio 			= request.querystring("busqueda[0][folio]")
 v_numero_factura	= request.querystring("busqueda[0][fact_nfactura]")
 v_tfac_ccod		= request.querystring("busqueda[0][tfac_ccod]")
'-----------------------------------------------------------------------
 v_sede=conexion.consultaUno("Select sede_ccod from movimientos_cajas where cast(mcaj_ncorr as varchar)='"&v_mcaj_ncorr&"'")
 v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from movimientos_cajas a, cajeros b where a.caje_ccod=b.caje_ccod and cast(a.mcaj_ncorr as varchar)='"&v_mcaj_ncorr&"'")



 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "factura.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "folio", v_folio
 f_busqueda.AgregaCampoCons "fact_nfactura", v_numero_factura
 f_busqueda.AgregaCampoCons "tfac_ccod", v_tfac_ccod

if v_tfac_ccod="1" then
	tipo_factura="Afecta"
elseif v_tfac_ccod="2" then
	tipo_factura="Exenta"
end if
'--------------------------------------------------------------------


'--------------------------------------------------------------------
set f_facturas = new CFormulario
f_facturas.Carga_Parametros "factura.xml", "f_facturas"
f_facturas.Inicializar conexion


if v_folio <> "" then
	filtro =" and cast(a.ingr_nfolio_referencia as varchar)='"&v_folio&"'"
end if

if rut_alumno<> "" then
	filtro =filtro + " and cast(b.pers_nrut as varchar)='"&rut_alumno&"'"
end if

if v_numero_factura<> "" then
	filtro =filtro + " and cast(a.fact_nfactura as varchar)='"&v_numero_factura&"'"
end if

if v_tfac_ccod <> ""  then
	filtro=filtro + " and cast(tfac_ccod as varchar)='"&v_tfac_ccod&"'"
	
	sql_proxima_factura="select isnull(rfca_nactual, rfca_ninicio) from rangos_facturas_cajeros where erfa_ccod=1 and cast(sede_ccod as varchar)='"&v_sede&"' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(tfac_ccod as varchar)='"&v_tfac_ccod&"'"
	v_proxima_factura=conexion.ConsultaUno(sql_proxima_factura)
	
	sql_codigo_rango="select rfca_ncorr from rangos_facturas_cajeros where erfa_ccod=1 and cast(sede_ccod as varchar)='"&v_sede&"' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(tfac_ccod as varchar)='"&v_tfac_ccod&"'"
	v_codigo_rango=conexion.ConsultaUno(sql_codigo_rango)

end if

if v_mcaj_ncorr <> "" and v_usuario<> "13373873" then
	filtro=filtro + " and mcaj_ncorr='"&v_mcaj_ncorr&"'"
end if


consulta= "select fact_ncorr,protic.trunc(fact_ffactura) as fecha_factura,isnull(protic.obtener_rut(empr_ncorr),'sin rut') as rut_empresa,isnull(empr_ncorr,0) as empr_ncorr, " & vbCrLf &_
			" isnull(protic.obtener_nombre(empr_ncorr,'n'),'n/n') as nombre_empresa, efac_ccod as c_efac_ccod,efac_ccod,isnull(b.pers_ncorr,0) as pers_ncorr, " & vbCrLf &_
			" isnull(ingr_nfolio_referencia,0) as ingr_nfolio_referencia,tfac_ccod,tfac_ccod as c_tfac_ccod,fact_nfactura " & vbCrLf &_
			" from facturas a "& vbCrLf &_
			" left outer join personas b " & vbCrLf &_
				" 	on a.pers_ncorr_alumno=b.pers_ncorr "& vbCrLf &_
				" where 1=1 "&filtro&" "& vbCrLf &_
				" order by a.fact_nfactura desc"
 
'consulta	=	" Select bole_ncorr,isnull(protic.obtener_rut(b.pers_ncorr),'sin rut') as rut_alumno,protic.trunc(a.bole_fboleta) as bole_fboleta," & vbCrLf &_
'				" isnull(protic.obtener_nombre_completo(b.pers_ncorr,'n'),'n/n') as nombre_alumno,a.bole_ncorr as c_bole_ncorr, ebol_ccod, "& vbCrLf &_
'				" ebol_ccod as c_ebol_ccod,tbol_ccod, tbol_ccod as c_tbol_ccod,isnull(b.pers_ncorr,0) as pers_ncorr ,isnull(pers_ncorr_aval,isnull(b.pers_ncorr,0)) as pers_ncorr_aval,isnull(ingr_nfolio_referencia,0) as ingr_nfolio_referencia ,bole_nboleta " & vbCrLf &_
'				" from boletas a " & vbCrLf &_
'				" left outer join personas b " & vbCrLf &_
'				" 	on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'				" where 1=1 "&filtro&" "& vbCrLf &_
'				" order by a.bole_nboleta desc"

'response.Write("<pre>"&consulta&"</pre>")

if not Esvacio(Request.QueryString) then
 	  f_facturas.Consultar consulta
else
	 f_facturas.Consultar "select '' where 1=2"
	 f_facturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

'#####################################################################
'############	SUPRIME LA EDICION DEL N° DE Factura ##################
 cantidad=f_facturas.nroFilas
 if cantidad >0 then
 fila=0
	while f_facturas.siguiente
		
		  v_estado=f_facturas.ObtenerValor ("efac_ccod")
		  'si no esta pendiente o vacia, no puede ser editada
		if v_estado <> "1" and v_estado <> "4" then
		  	f_facturas.AgregaCampoFilaParam fila,"fact_nfactura","permiso", "LECTURA"
		end if
		fila=fila+1
	wend	
 end if

 f_facturas.primero
'#####################################################################

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
function Guardar_Facturas(form){
mensaje="Guardar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 

function Anular_Facturas(form){
mensaje="Anular";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			confirmacion=confirm("Al anular una factura el registro se duplicara tomando el correlativo siguiente para volver a imprimirlo.\nSi desea que NO se duplique elija CANCELAR, pero no podra volver a generar la factura anulada\n\t\t ¿Desea duplicar la Factura?");
			if (confirmacion){
				form.duplica.value="SI";
			}else{
				form.duplica.value="NO";
			}				
			return true;
		}
	}	
	return false;
} 

function Crear_Factura_Sola(form){
mensaje_aviso="Esta opcion es para crear facturas que no tienen un Ingreso Asociado, \nutil para errores de impresion y deterioro de facturas fisicas. \n\n¿Esta seguro de crear una Factura vacia?"
//alert(form.name);	
	if (confirm(mensaje_aviso)){
		tipo_factura="Si la factura es AFECTA presione Aceptar, si es EXENTA presione Cancelar."	
		if (confirm(tipo_factura)){
			v_tfac_ccod=1;
		}else{
			v_tfac_ccod=2;
		}
		
		document.edicion.tipo_factura.value=v_tfac_ccod;
		document.edicion.action = "proc_crear_factura_vacia.asp";
		document.edicion.method="Post";
		document.edicion.submit()			

	}	

} 


function seleccionar(elemento){
	if (elemento.checked){
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.edicion.elements["factura["+v_indice+"][fact_nfactura]"].disabled=false;
	}else{
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.edicion.elements["factura["+v_indice+"][fact_nfactura]"].disabled=true;
	}
}

function apaga_check(){
<%if msg_alert = "" then%>
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
	     num += 1;
		 v_indice=extrae_indice(str);
		 v_estado=document.edicion.elements["factura["+v_indice+"][efac_ccod]"].value;
		 if ((v_estado!="1")&&(v_estado!="4")){
		 	document.edicion.elements["factura["+v_indice+"][fact_ncorr]"].disabled=true;
		 }
	  }
   }
<%end if%>   
}

function mensaje(){
<%if msg_alert <> "" then%>
alert('<%=msg_alert%>');
<%end if%>
}

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
		
	return true;
}

function ValidarNumero (valor){
	if((!valor)||(!isEnteroPositivo(valor))){
		alert("Debe ingresar un numero valido de factura");
		return false;
	}else{
		if(!confirm("Va a modificar el correlativo de sus facturas, es decir, la ultima factura sin imprimir. \n¿Esta seguro que el número ingresado pertenece a la actual factura en su impresora?")){
			return false;
		}
	}
	return true;
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje();apaga_check();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
              <td><%pagina.DibujarLenguetas Array("Búsqueda de facturas"), 1 %></td>
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
                            <td width="148" ><div align="right">R.U.T. Alumno : </div></td>
                                  <td width="152" > 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - <% f_busqueda.DibujaCampo ("pers_xdv") %>
									<a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
								  </td>
								  <td width="68"><div align="right">Tipo: </div></td>
								 <td width="149"><% f_busqueda.DibujaCampo ("tfac_ccod") %></td>

								</tr>
								<tr>
									<td width="148"><div align="right">N° Factura: </div></td>
									<td width="152"><% f_busqueda.DibujaCampo ("fact_nfactura") %></td>
									<td width="68"><div align="right">Nº Folio: </div></td>
									<td width="149"><%f_busqueda.DibujaCampo ("folio") %></td>

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
	<%=ini_ocultar%>	
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
				  <%pagina.DibujarSubtitulo "Facturas"%><br>
				     <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_facturas.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>

				  <form name="edicion">
					  	<input type="hidden" name="num_caja" value="<%=v_mcaj_ncorr%>" />
				  			<% f_facturas.DibujaTabla() %>
						<input type="hidden" name="tipo_factura" value="" />
						<input type="hidden" name="duplica" value="" />
                  </form>

				  <br>
				  
				  <%if v_tfac_ccod <>"" and v_codigo_rango<>"" then%>
				  <form action="proc_actualiza_proxima_factura.asp" method="post" name="actualiza" onSubmit="return ValidarNumero(actualiza.ultima_factura.value);">
				  <input type="hidden" name="rfca_ncorr" value="<%=v_codigo_rango%>" >
				  <input type="hidden" name="tipo_factura" value="<%=v_tfac_ccod%>" >
				  	<table width="" border="0">
                      <tr> 
                        <td width=""><b>Proxima Factura (<%=tipo_factura%>): </b></td>
                        <td width=""><div align="right"><input type="text" value="<%=v_proxima_factura%>" name="ultima_factura" size="5"></div></td>
                        <td width=""> <div align="right"><input type="submit" value="Cambiar">  </div></td>
                      </tr>
                    </table>
				</form>			
				<%end if%>		
				   </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp; </td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="239" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="10%">
                        <%
					   'if estado = "" then
					   if	f_facturas.NroFilas = 0 then
							botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"							   
					   end if
						botonera.DibujaBoton ("guardar")
					   %>
                      </td>
                      <td width="8%"> <div align="left"> </div></td>
                      <td width="17%"> <div align="left"> <%botonera.DibujaBoton ("anular")%></div></td>
                      <td width="26%"> <div align="left"> <%botonera.DibujaBoton ("crear_copia")%></div></td>
					  <td width="27%"> <div align="left"> <%botonera.DibujaBoton ("excel")%></div></td>
					  <td width="12%"><div align="left"> <%botonera.DibujaBoton ("salir")%></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="116" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
	  	<%=fin_ocultar%>
   		<br/>
   </td>
  </tr>  
</table>
</body>
</html>
