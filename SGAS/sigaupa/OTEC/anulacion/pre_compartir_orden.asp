<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

nombre 			= Request.Form("nombre")
rut				= Request.Form("rut")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Facturas para cambio de pago"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set errores = new CErrores

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()


set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "anulacion_facturas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
		session("mensajeError")="No puede anular la Orden de Compra seleccionada si no tiene una caja abierta."
		ini_ocultar="<!--"
		fin_ocultar="-->"
		response.Redirect(Request.ServerVariables("HTTP_REFERER"))
else
	msg_alert=""
end if


'--------------------------------------------------------------------------------------


set formulario = new CFormulario
formulario.Carga_Parametros "anulacion_facturas.xml", "f_ordenes"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
	v_ingr_ncorr		= formulario.ObtenerValorPost (fila, "ingr_ncorr")

	if v_ingr_ncorr <> "" then
			v_ingreso				= formulario.ObtenerValorPost (fila, "ingr_ncorr")
			v_monto_orden			= formulario.ObtenerValorPost (fila, "monto_orden")
			v_num_orden				= formulario.ObtenerValorPost (fila, "num_orden")
			v_pers_ncorr_otic		= formulario.ObtenerValorPost (fila, "pers_ncorr")
			v_pers_ncorr_empresa	= formulario.ObtenerValorPost (fila, "pers_ncorr_empresa")
	end if
next

'response.End()


v_comp_ndocto=conexion.consultaUno("select comp_ndocto from abonos where ingr_ncorr="&v_ingreso&" ")



set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "consulta.xml", "consulta"
f_alumnos.Inicializar conexion


sql_alumnos="select b.pote_ncorr,a.comp_ndocto,b.comp_ndocto,protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			" protic.obtener_nombre_completo(b.pers_ncorr,'n') as alumno " & vbCrLf &_
			"from postulantes_cargos_otec a, postulacion_otec b " & vbCrLf &_
			"where a.comp_ndocto="&v_comp_ndocto&" " & vbCrLf &_
			"and a.pote_ncorr=b.pote_ncorr "

f_alumnos.Consultar sql_alumnos
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

function IsNumeric(sText)

{
   var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char;

 
   for (i = 0; i < sText.length && IsNumber == true; i++) 
      { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) 
         {
         IsNumber = false;
         }
      }
   return IsNumber;
   
}


function ValidarNumero(campo){
	if (!IsNumeric(campo.value)){
		alert("Debe ingresar un valor numérico");
		campo.value="";
		campo.focus();
		return false;
	}
	return true;	
}

function valida_pagos(form) {
	
	new_numero_orden=	edicion.elements["oc[0][new_numero_orden]"].value;
	new_monto_otic	=	edicion.elements["oc[0][new_monto_otic]"].value;
	new_monto_empre	=	edicion.elements["oc[0][new_monto_empre]"].value;
	v_monto_orden	=	parseInt(edicion.elements["oc[0][monto_orden]"].value);
	num_alumnos		=	edicion.ind_alumnos.value;
	ind=0;
	if((new_numero_orden!="")&&(new_monto_otic!="")&&(new_monto_empre!="")){
		v_suma= eval(parseInt(new_monto_otic)+parseInt(new_monto_empre));
		if (v_suma!=v_monto_orden){
			alert("La suma debe ser igual al valor inicial de la parte asociada a la Otic: $"+v_monto_orden);
			return false;
		}
		
	}else{
		alert("Debe completar los datos necesarios para distribuir la nueva Orden de Compra");
		return false;
	}
	
	// Valida el ingreso de almenos un alumno.
	for (i=0;i < num_alumnos;i++){
		nombre 	= edicion.elements["oc2["+i+"][empresa]"].name;
		valor 	= edicion.elements["oc2["+i+"][empresa]"].value;
		estado 	= edicion.elements["oc2["+i+"][empresa]"].checked;
		if(estado){
			ind++;
		}
	}
	if(ind==0){
		alert("Debe seleccionar al menos un Alumno para asignar a la Empresa");
		return false;
	}
	return true;
		
}

var t_busqueda;
function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}

function mensaje(){
<%if msg_alert <> "" then%>
alert('<%=msg_alert%>');
<%end if%>
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje(); InicioPagina();" >
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" align="left" bgcolor="#EAEAEA">
	<br>
	<%=ini_ocultar%>
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
                  	<td width="10%"><strong>Rut</strong></td>
					<td width="2%"><strong>:</strong></td>
					<td width="88%"><%=rut%></td>
                </tr>
                <tr>
                  	<td><strong>Nombre</strong></td>
					<td><strong>:</strong></td>
					<td><%=nombre%></td>
                </tr>

              </table>
			  <br/>
					<center><div class="MsgError" > 
				   <table border="0"  cellspacing="2"  cellpadding="5"  align="center"> 
				   <tr> 
				   <td> El actual monto asociado al pago de la Otic, debe ser dividido según la segunda orden de compra ingresada </td>
				   </tr>
				   </table>
	   			   </div></center> 
				   
              <form name="edicion">

                <input type="hidden" name="oc[0][ingr_ncorr]" value="<%=v_ingreso%>">
				<input type="hidden" name="oc[0][monto_orden]" value="<%=v_monto_orden%>">
				<input type="hidden" name="oc[0][pers_ncorr_otic]" value="<%=v_pers_ncorr_otic%>">
				<input type="hidden" name="oc[0][pers_ncorr_empresa]" value="<%=v_pers_ncorr_empresa%>">
				<input type="hidden" name="nombre" value="<%=nombre%>">
 
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Facturas asociadas para anular"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
						  <div align="center">
						  
						<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_oc'>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<th><font color='#333333'>N° Orden</font> Actual </th>
								<td><b><%=v_num_orden%></b></td>
								<th><font color='#333333'>Monto Otic</font></th>
								<td><b><%=formatcurrency(v_monto_orden,0)%></b></td>
							</tr>
							<tr>
							<th colspan="4"><center>División de ingresos por concepto de nuevos pagos</center></th>
							</tr>
							<tr bgcolor="#FFFFFF">
								<th align="left"><font color='#333333'>Nuevo N° Orden</font></th>
								<td class='noclick'align='CENTER' width='' ><input type="text" name="oc[0][new_numero_orden]" value="0" onBlur="ValidarNumero(this);"/></td>
								<th colspan="2" align="left">&nbsp;</th>
							</tr>
							<tr bgcolor="#FFFFFF">
								<th align="left"><font color='#333333'>Nuevo monto Otic</font></th>
								<td class='noclick'align='CENTER' width='' ><input type="text" name="oc[0][new_monto_otic]" value="0" onBlur="ValidarNumero(this);"/></td>
								<th align="left"><font color='#333333'>Nuevo monto Empresa</font></th>
								<td class='noclick'align='CENTER' width='' ><input type="text" name="oc[0][new_monto_empre]" value="0" onBlur="ValidarNumero(this);"/></td>
							</tr>
							<tr><th colspan="4"><center>Asignacion de alumnos a la Empresa</center></th></tr>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<td><strong><font color='#333333'>Asignar a Empresa</font></strong></td>
								<td><strong><font color='#333333'>N° Rut</font></strong></td>
								<td colspan="2"><strong><font color='#333333'>Nombre Alumno</font></strong></td>
							</tr>
							<%
								for k=0 to f_alumnos.nroFilas-1
									f_alumnos.siguiente
									rut_alumno		= 	f_alumnos.obtenerValor("rut")
									nombre_alumno	= 	f_alumnos.obtenerValor("alumno")
									v_pote_ncorr	= 	f_alumnos.obtenerValor("pote_ncorr")
							%>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<td><input type="hidden" name="oc2[<%=k%>][pote_ncorr]" value="<%=v_pote_ncorr%>">
									<input type="checkbox" name="oc2[<%=k%>][empresa]" value="2"></td>
								<td><font color='#333333'><%=rut_alumno%></font></td>
								<td colspan="2"><font color='#333333'><%=nombre_alumno%></font></td>
							</tr>
							<%		
								next
							%>
							<input type="hidden" name="ind_alumnos" value="<%=k%>">
							
						</table>
						  
						  
						   </div></td>
                        </tr>
                        <tr>
                          <td>
						  <br/>
			  
						  <div align="right">
                                  <% 'if v_filas = 0 then 
								  	'f_botonera.agregabotonparam "continuar_oc","deshabilitado","true"
								  'end if
								  %>
								  <table width="100%" border="0">
                                    <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td></td>
                                      <td width="20%"><%f_botonera.DibujaBoton("continuar_oc")%></td>
                                    </tr>
                                  </table>
                                </div></td>
                        </tr>
                      </table>
					</td>
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
	<%=fin_ocultar%>
	<br>
	<br>
</td>
  </tr>  
</table>
</body>
</html>
