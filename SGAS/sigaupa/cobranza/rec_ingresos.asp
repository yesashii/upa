<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Recepción de Ingresos (Cobranza)"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'nombre del alumno
nombre = conexion.consultauno("select pers_tnombre + ' ' + pers_tape_paterno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"' and cast(pers_xdv as varchar)= '"&q_pers_xdv&"'")

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rec_ingresos.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No puede recibir pagos si no tiene una caja abierta."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "rec_ingresos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------
set cuenta_corriente = new CCuentaCorriente
cuenta_corriente.Inicializar conexion, q_pers_nrut, null


'----------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno
alumno.Inicializar conexion, persona.ObtenerMatrNCorr(negocio.ObtenerPeriodoAcademico("CLASES18"))

'--------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "agregar", "pers_ncorr", persona.ObtenerPersNCorr
f_botonera.AgregaBotonUrlParam "agregar_pactacion", "pers_nrut", q_pers_nrut

if EsVacio(persona.ObtenerPersNCorr) then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
end if

if EsVacio(q_pers_nrut) then
	f_botonera.AgregaBotonParam "agregar_pactacion", "deshabilitado", "TRUE"
end if


if EsVacio(persona.ObtenerMatrNCorr(negocio.ObtenerPeriodoAcademico("CLASES18"))) then
	set f_datos = persona
else
	set f_datos = alumno
end if

'--------------------------------------------------------------------------------------


'******************************* ARREGLAR QUERY ***************************** -->
inst = 1
campos="select count(*) from ("& vbCrLf &_
"SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & vbCrLf &_
"      (b.dcom_mcompromiso - isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end),0)) AS dcom_mcompromiso_oculto, " & vbCrLf &_
"       isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end),0) AS abono, b.dcom_fcompromiso, " & vbCrLf &_
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & vbCrLf &_
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & vbCrLf &_
"       (b.dcom_mcompromiso - isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end),0)) AS saldo " & vbCrLf &_
"  FROM compromisos a, " & vbCrLf &_
"       detalle_compromisos b, " & vbCrLf &_
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje " & vbCrLf &_
"        from ingresos a, abonos b, personas c, tipos_ingresos d " & vbCrLf &_      
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & vbCrLf &_
"          AND c.pers_ncorr = b.pers_ncorr and cast(c.pers_nrut as varchar)= '"& q_pers_nrut & "' " & vbCrLf &_
"          AND a.eing_ccod = 1 and cast(b.inst_ccod as varchar)= '"& inst & "') c, " & vbCrLf &_
"       tipos_compromisos d, " & vbCrLf &_
"      personas e " & vbCrLf &_
" WHERE a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
"   AND a.inst_ccod = b.inst_ccod " & vbCrLf &_
"   AND a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
"   AND b.tcom_ccod *= c.tcom_ccod " & vbCrLf &_
"   AND b.inst_ccod *= c.inst_ccod " & vbCrLf &_
"   AND b.comp_ndocto *= c.comp_ndocto " & vbCrLf &_
"   AND b.dcom_ncompromiso *= c.dcom_ncompromiso " & vbCrLf &_
"   AND b.tcom_ccod = d.tcom_ccod  " & vbCrLf &_
"   AND a.ecom_ccod not in (2,3)  " & vbCrLf &_
"	and B.ecom_ccod not in (2,3,5) " & vbCrLf &_
"   AND a.pers_ncorr = e.pers_ncorr " & vbCrLf &_
"   AND cast(e.pers_nrut as varchar)= '"& q_pers_nrut &"' " & vbCrLf &_
"   AND cast(a.inst_ccod as varchar)= '"& inst &"'" & vbCrLf &_
" HAVING isnull((b.dcom_mcompromiso - isnull(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)),0) > 0 " & vbCrLf &_
 " GROUP BY a.tcom_ccod, " & vbCrLf &_
 "         a.inst_ccod, " & vbCrLf &_
 "         a.comp_ndocto, " & vbCrLf &_
 "         b.dcom_ncompromiso, " & vbCrLf &_
 "         b.dcom_fcompromiso, " & vbCrLf &_
 "         b.dcom_mcompromiso, " & vbCrLf &_
 "         e.pers_ncorr, " & vbCrLf &_
 "         d.tcom_tdesc " & vbCrLf &_
 " ORDER BY b.dcom_fcompromiso asc,a.tcom_ccod,nro) "
'nro_campos=cint(conexion.consultaUno(campos))
'******************************* FIN   ***************************** -->

'*************************************** inicio arreglar esta query tambien ***********************************
campos2="select count(*) from (SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & vbCrLf &_
"      (b.dcom_mcompromiso - isnull(SUM (case c.ting_brebaje when  'S' then c.abon_mabono *(-1) else c.abon_mabono end),0)) AS dcom_mcompromiso_oculto, " & vbCrLf &_
"       isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end ),0) AS abono, b.dcom_fcompromiso, " & vbCrLf &_
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & vbCrLf &_
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & vbCrLf &_
"       (b.dcom_mcompromiso - isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end),0)) AS saldo " & vbCrLf &_
"  FROM compromisos a, " & vbCrLf &_
"       detalle_compromisos b, " & vbCrLf &_
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono, a.ting_ccod, d.ting_brebaje "& vbCrLf &_
"        from ingresos a, abonos b, personas c, tipos_ingresos d "& vbCrLf &_
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & vbCrLf &_
"          AND c.pers_ncorr = b.pers_ncorr and cast(c.pers_nrut as varchar)= '"& q_pers_nrut & "' " & vbCrLf &_ 
"          AND a.eing_ccod = 1 and cast(b.inst_ccod as varchar)= '"& inst & "') c, "& vbCrLf &_
"       tipos_compromisos d, " & vbCrLf &_
"      personas e " & vbCrLf &_
" WHERE a.tcom_ccod = b.tcom_ccod "& vbCrLf &_
"   AND a.inst_ccod = b.inst_ccod "& vbCrLf &_
"   AND a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
"   AND b.tcom_ccod *= c.tcom_ccod  "& vbCrLf &_
"   AND b.inst_ccod *= c.inst_ccod  "& vbCrLf &_
"   AND b.comp_ndocto *= c.comp_ndocto  "& vbCrLf &_
"   AND b.dcom_ncompromiso *= c.dcom_ncompromiso "& vbCrLf &_
"   AND b.tcom_ccod = d.tcom_ccod  "& vbCrLf &_
"   AND a.ecom_ccod not in (2,3)  "& vbCrLf &_
"	and B.ecom_ccod = 5  "& vbCrLf &_
"   AND a.pers_ncorr = e.pers_ncorr "& vbCrLf &_
"   AND cast(e.pers_nrut as varchar)= '"& q_pers_nrut &"' "& vbCrLf &_
"   AND cast(a.inst_ccod as varchar)= '"& inst &"'"& vbCrLf &_
" HAVING isnull((b.dcom_mcompromiso - isnull(SUM (case c.ting_brebaje when 'S' then c.abon_mabono *(-1) else c.abon_mabono end ),0)),0) > 0 "& vbCrLf &_
 " GROUP BY a.tcom_ccod, "& vbCrLf &_
 "         a.inst_ccod, "& vbCrLf &_
 "         a.comp_ndocto, "& vbCrLf &_
 "         b.dcom_ncompromiso, "& vbCrLf &_
 "         b.dcom_fcompromiso, "& vbCrLf &_
 "         b.dcom_mcompromiso, "& vbCrLf &_
 "         e.pers_ncorr, "& vbCrLf &_
 "         d.tcom_tdesc "& vbCrLf &_
 " ORDER BY b.dcom_fcompromiso,a.tcom_ccod,nro)"
'nro_campos2=cint(conexion.consultaUno(campos2))
'*************************************** termino nuevo***********************************


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
/*function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv").toUpperCase();
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}*/


function ValidaBusqueda()
{
	rut=document.buscador.elements['busqueda[0][pers_nrut]'].value+'-'+document.buscador.elements['busqueda[0][pers_xdv]'].value

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['b[0][pers_nrut]'].focus()
		document.buscador.elements['b[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}


nrofilasdibujadas=0

function existe(arreglo,valor){
	for (x=0;x<arreglo.length;x++){
		if (arreglo[x] == valor){
			return true
		}
	}
	return false
}

/*function valida_pagos(miformulario) {
	
	tabla_c = new CTabla("cc_compromisos_pendientes")

	miformulario = document.edicion
	ar = new Array()
	nreg=0
	
	if ( tabla_c.CuentaSeleccionados('dcom_ncompromiso') > 0 ){
		for (i=0;i<nrofilasdibujadas;i++){
			if (miformulario.elements["cc_compromisos_pendientes["+i+"][dcom_ncompromiso]"].checked){
				if (!existe(ar,miformulario.elements["cc_compromisos_pendientes["+i+"][tcom_ccod]"].value)){
					ar[nreg] = miformulario.elements["cc_compromisos_pendientes["+i+"][tcom_ccod]"].value
					nreg++
				}		
			}
		}
		lineas_detalle = nreg + 1 + parseInt(miformulario.elements["nro_docto"].value)
		if (lineas_detalle >= 14){
			alert('Error: No podra imprimir Comprobante de Ingresos.\nEl detalle a generar es mas grande que el comprobante.')
			return false
		}
		resultado = window.open('','ventana','menubar = no; width=820;height=500; top = 0; left = 0; scrollbars= yes')
		return true
	}
	alert('Debe seleccionar al menos un compromiso.')
	return false
		
}*/

function valida_pagos(miformulario) {
   form = document.edicion
	
   nro = form.elements.length;
   num =0;
   msg_accion="pagar";
   for( i = 0; i < nro; i++ ) {
	//alert("en el FOR"+i);
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	     num += 1;
	  }
   }
   if( num > 0 ) {
	   	if (num >= 15){
			alert('Error: No podrá imprimir Comprobante de Ingresos.\nEl detalle a generar es mas grande que el comprobante.')
			return false;
		}
		if(confirm('Ud. ha seleccionado '+ num +' registros para '+ msg_accion +'. ¿Desea continuar?')){
			resultado = window.open('','ventana','menubar = no; width=820;height=500; top = 0; left = 0; scrollbars= yes')
			return true;
		}
		else{
			return false;
		}
	
   }else{
      alert('Ud. no ha seleccionado ningún registro para '+ msg_accion +' ');
	  return false;
   }	
   
   	alert('Debe seleccionar al menos un compromiso.')
	return false
		
}

function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%f_datos.DibujaDatos%></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <input type="hidden" name="rut" value="<%=q_pers_nrut&"-"&q_pers_xdv%>">
				<input type="hidden" name="nombre" value="<%=nombre%>">
                    <input type="hidden" name="nro_campos" value="<%=nro_campos%>">
					<input type="hidden" name="nro_campos2" value="<%=nro_campos2%>">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Compromisos pendientes"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%'cuenta_corriente.DibujaCompromisosPorPagar%>
						  <% cuenta_corriente.DibujaCompromisosEnNotaria%>
						  <script language="javascript">
						  nrofilasdibujadas=<%= cuenta_corriente.nrofilasdibujadas%>
						  </script>
						  </div></td>
                        </tr>
                        <tr>
                          <td><div align="right">
                                  <% if cuenta_corriente.nrofilasdibujadas = 0 then 
								  	f_botonera.agregabotonparam "pagar","deshabilitado","true"
								  end if
								  %>
								  <table width="100%" border="0">
                                    <tr>
                                      <td><%'f_botonera.DibujaBoton("agregar")%></td>
                                      <td><%'f_botonera.DibujaBoton("agregar_pactacion")%></td>
                                      <td><div align="right">Nro de 
                                          Documentos&nbsp; 
                                          <select name="nro_docto" id="NU-N">
                                            <option value="0" selected>0</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                          </select>
                                        </div></td>
                                      <td width="20%">
                                        <%f_botonera.DibujaBoton("pagar_normal")%>
                                      </td>
                                    </tr>
                                  </table>
								  
                                  
                                </div></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <%'pagina.DibujarSubtitulo "Otros Compromisos pendientes"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                                <%'cuenta_corriente.DibujaCompromisosPendientes%>
                          </div></td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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
	  <p>&nbsp;</p>
      <p><br>
        <br>
      </p></td>
  </tr>  
</table>
</body>
</html>
