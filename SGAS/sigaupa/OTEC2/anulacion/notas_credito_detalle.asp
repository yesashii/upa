<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next


q_uso_nota1=request.Form("uso_nota1")
q_uso_nota2=request.Form("uso_nota2")
q_uso_nota3=request.Form("uso_nota3")
q_pers_ncorr=request.Form("pers_ncorr")
q_institucion=request.Form("institucion")



if q_institucion="1" then
	v_variable="compromisos_por_pagar"
	tipo_empresa="Universidad del Pacifico"
else
	v_variable="compromisos_por_pagar_editorial"
	tipo_empresa="Editorial UPA"
end if
'response.end()
set pagina = new CPagina
pagina.Titulo = "Detalle compromisos a rebajar y/o devolver"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'response.end()
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_credito.xml", "botonera"

set errores = new CErrores


sede	=	negocio.obtenersede

set cajero = new ccajero
cajero.inicializar conexion,negocio.obtenerUsuario,sede
v_mcaj_ncorr 	= cajero.obtenerCajaAbierta

set formulario_tipo = new CFormulario
formulario_tipo.Carga_Parametros "notas_credito.xml", "tipos_anulaciones"
formulario_tipo.Inicializar conexion
formulario_tipo.Consultar "select ''"
'---------------------------------------------------------------------------------------------------

	sql_pers_ncorr= " select pers_ncorr " &_
					" from movimientos_cajas a, cajeros b" &_
					" where a.caje_ccod=b.caje_ccod " &_
					" and a.mcaj_ncorr="&v_mcaj_ncorr&" " 


	v_pers_ncorr=conexion.consultaUno(sql_pers_ncorr)

	sql_factura =	" Select isnull(rncc_nactual,rncc_ninicio) " & vbcrlf &_
					" From rangos_notas_credito_cajeros " & vbcrlf &_
					" Where pers_ncorr="&v_pers_ncorr&" " & vbcrlf &_
					"    and sede_ccod="&sede&" " & vbcrlf &_
					"    and inst_ccod="&q_institucion&" " & vbcrlf &_
					"    and ernc_ccod=1 "

'response.Write("<pre>"&sql_factura&"</pre>")					

	v_ndcr_nnota_credito=conexion.consultaUno(sql_factura)
'---------------------------------------------------------------------------------------------------
nombre 	= conexion.consultauno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno  from personas where cast(pers_ncorr as varchar) ='"&q_pers_ncorr&"'")
v_rut 	= conexion.consultauno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_ncorr as varchar) ='"&q_pers_ncorr&"'")
total_rebajar	=0
total_devolver	=0

	if v_ndcr_nnota_credito="" or EsVacio(v_ndcr_nnota_credito) then
		msg_alerta2="No puede emitir Nota de credito ya que no tiene documentos asociadas a "&tipo_empresa&" "				
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





<style type="text/css">
<!--
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
}
.Estilo2 {
	font-size: 12px;
	font-weight: bold;
	color: #009900;
}
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
	<table width="600"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td></td>
          </tr>
          <tr>
            <td height="2" background=""></td>
          </tr>
          <tr>
            <td>
            <form name="edicion">
			<input type="hidden" name="pers_ncorr" value="<%=q_pers_ncorr%>">	

				<br/>
				<div align="center">
              <%pagina.DibujarTituloPagina%><br>
                </div><br>
			<table width="96%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="27%"><strong>Rut</strong></td>
					<td width="2%"><strong>:</strong></td>
					<td width="71%"><%=v_rut%></td>
				</tr>
				<tr>
					<td><strong>Nombre o institucion</strong></td>
					<td><strong>:</strong></td>
					<td><%=nombre%></td>
				</tr>
			  </table>
			  <br>
			  <br>
			  									
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
	<td>
	<%pagina.DibujarSubtitulo "Usos Seleccionados para Nota de Credito"%>
	<table width='100%' border='0' cellpadding='0' cellspacing='0'>
		<tr>
			<td>
				<input type="checkbox" name="uso_nota1" value="1" onClick="ValidaUso(this,1);">
				<strong>Valor v&aacute;lido como medio de pago</strong><br/>
				<input type="checkbox" name="uso_nota2" value="2" onClick="ValidaUso(this,2);">
				<strong>Valor sujeto a devoluci&oacute;n del alumno</strong><br/>
				<input type="checkbox" name="uso_nota3" value="3" onClick="ValidaUso(this,3);">
				<strong>Valor correspondiente a anulaci&oacute;n de documentos</strong>
			</td>
		</tr>
	</table>
	
	</td>
</tr>
  <tr>
	<td>
	<br>
	<%pagina.DibujarSubtitulo "Documentos a Rebajar"%>
		<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' >
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th width="9%"><font color='#333333'>Item</font></th>
				<th width="4%"><font color='#333333'>Cuota</font></th>
				<th width="12%"><font color='#333333'>Vencimiento</font></th>
				<th width="12%"><font color='#333333'>Documento</font></th>
				<th width="9%"><font color="#333333">N&deg; docto </font></th>
				<th width="10%"><font color="#333333">Monto docto </font></th>
				<th width="12%"><font color="#333333">Saldo deuda </font></th>
				<th width="12%"><font color="#333333">Monto Rebaje</font></th>
			</tr>
			<% 
			
				set f_compromiso = new CFormulario
				f_compromiso.Carga_Parametros "tabla_vacia.xml", "tabla"
						
				  set formulario = new CFormulario
				  formulario.Carga_Parametros "notas_credito.xml", v_variable
				  formulario.Inicializar conexion
				  formulario.ProcesaForm
					indice=0
					for fila = 0 to formulario.CuentaPost - 1
						v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
						v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
						v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
						v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
						
						if v_dcom_ncompromiso <> "" then
						
						consulta_detalle	 = " Select dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso, "& vbCrLf &_
											" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto'),0) as varchar) as numero_docto, "& vbCrLf &_    
											" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'monto'),cp.comp_mneto) as varchar) as monto_documento,  "& vbCrLf &_ 					
											" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') as varchar) as ting_ccod,  "& vbCrLf &_ 					
											" cast(protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso) as numeric)	as saldo, "& vbCrLf &_									
											" protic.trunc(dc.DCOM_FCOMPROMISO) fecha_vencimiento,e.tcom_tdesc as tipo_compromiso,upper(d.ting_tdesc) as tipo_ingreso  "& vbCrLf &_    
											" From compromisos cp "& vbCrLf &_ 
											" join detalle_compromisos dc "& vbCrLf &_ 
											" 	on cp.tcom_ccod = dc.tcom_ccod "& vbCrLf &_    
											" 	and cp.inst_ccod = dc.inst_ccod "& vbCrLf &_    
											" 	and cp.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
											" left outer join detalle_ingresos c "& vbCrLf &_ 
											" 	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod  "& vbCrLf &_  
											" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto "& vbCrLf &_  
											" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr "& vbCrLf &_    
											" left join tipos_ingresos d "& vbCrLf &_   
											" 	on c.ting_ccod = d.ting_ccod "& vbCrLf &_
											" left join tipos_compromisos e "& vbCrLf &_   
											" 	on cp.tcom_ccod = e.tcom_ccod "& vbCrLf &_
											" where dc.tcom_ccod ="&v_tcom_ccod&" "& vbCrLf &_    
											" and dc.inst_ccod   = "&v_inst_ccod&" "& vbCrLf &_
											" and dc.comp_ndocto = "&v_comp_ndocto&" "& vbCrLf &_
											" and dc.dcom_ncompromiso="&v_dcom_ncompromiso&" "
	
	
	
							f_compromiso.Inicializar conexion
							f_compromiso.Consultar consulta_detalle
							f_compromiso.siguienteF
												
							v_saldo=conexion.consultaUno("select protic.total_recepcionar_cuota("&v_tcom_ccod&","&v_inst_ccod&","&v_comp_ndocto&","&v_dcom_ncompromiso&")")
							'response.Write("<pre>"&v_saldo&"</pre>")
								if(f_compromiso.ObtenerValor("saldo")>"0") then
								total_rebajar=Clng(total_rebajar)+Clng(v_saldo)
								nfilas_rebajar=nfilas_rebajar+1
									%>
<input type="hidden" name="cc_compromisos_rebaje[<%=indice%>][tcom_ccod]" value="<%f_compromiso.dibujaCampo("tcom_ccod")%>" />
<input type="hidden" name="cc_compromisos_rebaje[<%=indice%>][comp_ndocto]" value="<%f_compromiso.dibujaCampo("comp_ndocto")%>"/>
<input type="hidden" name="cc_compromisos_rebaje[<%=indice%>][inst_ccod]" value="<%f_compromiso.dibujaCampo("inst_ccod")%>" />
<input type="hidden" name="cc_compromisos_rebaje[<%=indice%>][dcom_ncompromiso]" value="<%f_compromiso.dibujaCampo("dcom_ncompromiso")%>" />
										<tr bgcolor="#FFFFFF">
											<td><%f_compromiso.dibujaCampo("tipo_compromiso")%></td>
											<td><%f_compromiso.dibujaCampo("dcom_ncompromiso")%></td>
											<td><%f_compromiso.dibujaCampo("fecha_vencimiento")%></td>
											<td><%f_compromiso.dibujaCampo("tipo_ingreso")%></td>
											<td><%f_compromiso.dibujaCampo("numero_docto")%></td>
											<td><%=formatcurrency(f_compromiso.ObtenerValor("monto_documento"),0)%></td>
											<td><%=formatcurrency(f_compromiso.ObtenerValor("saldo"),0)%></td>
											<td>
											<input type="hidden" value="<%=f_compromiso.ObtenerValor("saldo")%>" name="cc_compromisos_rebaje[<%=indice%>][saldo]">
											<input type="text" value="<%=f_compromiso.ObtenerValor("saldo")%>" name="cc_compromisos_rebaje[<%=indice%>][rebaje]" size="9" onBlur="ValidaNumero(this,<%=indice%>);" ></td>
										</tr>
	
									<%
								indice=indice+1	
								end if
					end if
			next%>
	  		<tr>
				<td colspan="7" align="right"><strong>Total a rebajar:&nbsp;&nbsp;</strong></td>
				<td><input type="text" name="total_rebajar_real" value="<%=total_rebajar%>" readonly="" size="8" style="background-color:#ADADAD;border: 1px #ADADAD solid;"> </td>
			</tr>			
	  </table>

	  <br/>
	 <div><font color="#0000FF"><strong>Elija Opcion de anulacion:</strong></font> <%formulario_tipo.DibujaCampo("ting_ccod")%></div>
	  </td>
  </tr>
  <tr>
	  <td>
	  <br>
		<%pagina.DibujarSubtitulo "Documentos a Devolver"%>
		<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' >
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th width="9%"><font color='#333333'>Item</font></th>
				<th width="4%"><font color='#333333'>Cuota</font></th>
				<th width="12%"><font color='#333333'>Vencimiento</font></th>
				<th width="12%"><font color='#333333'>Documento</font></th>
				<th width="9%"><font color="#333333">N&deg; docto </font></th>
				<th width="10%"><font color="#333333">Monto docto </font></th>
				<th width="12%"><font color="#333333">Devolver</font></th>
			</tr>
			<% 
			
			set f_compromiso_d = new CFormulario
			f_compromiso_d.Carga_Parametros "tabla_vacia.xml", "tabla"
						
			set formulario_d = new CFormulario
			  formulario_d.Carga_Parametros "notas_credito.xml", v_variable
			  formulario_d.Inicializar conexion
			  formulario_d.ProcesaForm
		indice=0
				for fila = 0 to formulario_d.CuentaPost - 1
					v_comp_ndocto		= formulario_d.ObtenerValorPost (fila, "comp_ndocto")
					v_tcom_ccod			= formulario_d.ObtenerValorPost (fila, "tcom_ccod")
					v_inst_ccod			= formulario_d.ObtenerValorPost (fila, "inst_ccod")
					v_dcom_ncompromiso	= formulario_d.ObtenerValorPost (fila, "dcom_ncompromiso")
					
					if v_dcom_ncompromiso <> "" then
					
					consulta_detalle	 = " Select dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso, "& vbCrLf &_
										" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto'),0) as varchar) as numero_docto, "& vbCrLf &_    
										" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'monto'),dc.dcom_mcompromiso) as varchar) as monto_documento,  "& vbCrLf &_ 					
										" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') as varchar) as ting_ccod,  "& vbCrLf &_ 					
										" cast(protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso) as numeric)	as saldo, "& vbCrLf &_									
										" protic.trunc(dc.DCOM_FCOMPROMISO) fecha_vencimiento,e.tcom_tdesc as tipo_compromiso,upper(d.ting_tdesc) as tipo_ingreso  "& vbCrLf &_    
										" From compromisos cp "& vbCrLf &_ 
										" join detalle_compromisos dc "& vbCrLf &_ 
										" 	on cp.tcom_ccod = dc.tcom_ccod "& vbCrLf &_    
										" 	and cp.inst_ccod = dc.inst_ccod "& vbCrLf &_    
										" 	and cp.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
										" left outer join detalle_ingresos c "& vbCrLf &_ 
										" 	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod  "& vbCrLf &_  
										" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto "& vbCrLf &_  
										" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr "& vbCrLf &_    
										" left join tipos_ingresos d "& vbCrLf &_   
										" 	on c.ting_ccod = d.ting_ccod "& vbCrLf &_
										" left join tipos_compromisos e "& vbCrLf &_   
										" 	on cp.tcom_ccod = e.tcom_ccod "& vbCrLf &_
										" where dc.tcom_ccod ="&v_tcom_ccod&" "& vbCrLf &_    
										" and dc.inst_ccod   = "&v_inst_ccod&" "& vbCrLf &_
										" and dc.comp_ndocto = "&v_comp_ndocto&" "& vbCrLf &_
										" and dc.dcom_ncompromiso="&v_dcom_ncompromiso&" "

'response.Write("<pre>"&consulta_detalle&"</pre>")

						f_compromiso_d.Inicializar conexion
						f_compromiso_d.Consultar consulta_detalle
						f_compromiso_d.siguienteF
											
							if(f_compromiso_d.ObtenerValor("saldo")="0") then
							total_devolver=Clng(total_devolver)+Clng(f_compromiso_d.ObtenerValor("monto_documento"))
							nfilas_devolver=nfilas_devolver+1
								%>
<input type="hidden" name="cc_compromisos_devuelve[<%=indice%>][tcom_ccod]" value="<%f_compromiso_d.dibujaCampo("tcom_ccod")%>" />
<input type="hidden" name="cc_compromisos_devuelve[<%=indice%>][comp_ndocto]" value="<%f_compromiso_d.dibujaCampo("comp_ndocto")%>"/>
<input type="hidden" name="cc_compromisos_devuelve[<%=indice%>][inst_ccod]" value="<%f_compromiso_d.dibujaCampo("inst_ccod")%>" />
<input type="hidden" name="cc_compromisos_devuelve[<%=indice%>][dcom_ncompromiso]" value="<%f_compromiso_d.dibujaCampo("dcom_ncompromiso")%>" />								
									<tr bgcolor="#FFFFFF">
										<td><%f_compromiso_d.dibujaCampo("tipo_compromiso")%></td>
										<td><%f_compromiso_d.dibujaCampo("dcom_ncompromiso")%></td>
										<td><%f_compromiso_d.dibujaCampo("fecha_vencimiento")%></td>
										<td><%f_compromiso_d.dibujaCampo("tipo_ingreso")%></td>
										<td><%f_compromiso_d.dibujaCampo("numero_docto")%></td>
										<td><%=formatcurrency(f_compromiso_d.ObtenerValor("monto_documento"),0)%></td>
										<td>
										<input type="hidden" value="<%=f_compromiso_d.ObtenerValor("monto_documento")%>" name="cc_compromisos_devuelve[<%=indice%>][monto_documento]">
										<input type="text" value="<%=f_compromiso_d.ObtenerValor("monto_documento")%>" name="cc_compromisos_devuelve[<%=indice%>][devuelve]" size="9" onBlur="ValidaDevolucion(this,<%=indice%>);" >
										</td>
									</tr>

								<%
								indice=indice+1									
							end if
					end if
			next%>
			<tr>
				<td colspan="6" align="right"><strong>Total a devolver:&nbsp;&nbsp;</strong></td>
				<td><input type="text" name="total_devolver_real" value="<%=total_devolver%>" readonly="" size="8" style="background-color:#ADADAD;border: 1px #ADADAD solid;"> </td>
			</tr>
	  </table>

	</td>
  </tr>
</table>
<table>
	<tr>
		<td><strong>Como medio de pago:</strong> </td><td><input type="text" name="monto_pago" value="0" size="8" disabled="disabled" onBlur="ValidaMontoPago(this);"></td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td><strong>Sujeto a devolución:</strong></td><td><input type="text" name="monto_devolucion" value="0" disabled="disabled" size="8" onBlur="ValidaMontoDevolucion(this);"></td>
	</tr>
</table>
<br>
<%pagina.DibujarSubtitulo "Datos Nota Credito"%>
<table>
<tr>
	<td><strong>N° Nota cr&eacute;dito</strong></td>
	<td><input type="text" name="nota_credito" value="<%=v_ndcr_nnota_credito%>" size="7" maxlength="6" readonly=""></td>
	<td colspan="5"><font color="#FF0000" size="1"><%=msg_alerta2%></font></td>
</tr>
</table>
<input type="hidden" name="institucion" value="<%=q_institucion%>">
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
					  <div align="center">
						    <%f_botonera.DibujaBoton "volver"%>
					  </div>
				  </td>
				  <td>
					  <div align="center">
						<%
						  	if v_ndcr_nnota_credito="" or EsVacio(v_ndcr_nnota_credito) then
								f_botonera.agregabotonparam "emitir", "deshabilitado" ,"TRUE"							   
						   	end if 
						f_botonera.DibujaBoton "emitir"%>
					  </div>
				  </td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
<script language="JavaScript">

function ValidaMontoDevolucion(elemento)
{
formu=document.edicion;
var monto_devolucion;
var total_devolver;

monto_devolucion=	parseInt(elemento.value);
monto_pago		=	parseInt(formu.monto_pago.value);
total_devolver	=	parseInt(formu.total_devolver_real.value);

suma_montos=parseInt(monto_pago)+parseInt(monto_devolucion);
	if(monto_devolucion>total_devolver){
		alert("El monto 'Sujeto a devolucion' "+monto_devolucion+" excede al total a devolver: "+total_devolver);
		elemento.value=0;
		elemento.focus();
	}else if(suma_montos>total_devolver){
		alert("la suma de los montos excede al total devuelto");
		elemento.value=0;
		elemento.focus();
	}else{
		monto_pago=total_devolver-monto_devolucion;
		formu.monto_pago.value=monto_pago;
	}
}

function ValidaMontoPago(elemento)
{
formu=document.edicion;
var monto_pago;
var total_devolver;

monto_pago		=	parseInt(elemento.value);
monto_devolucion=	parseInt(formu.monto_devolucion.value);
total_devolver	=	parseInt(formu.total_devolver_real.value);

suma_montos=parseInt(monto_pago)+parseInt(monto_devolucion);
	if(monto_pago>total_devolver){
		alert("El monto 'Medio de pago' "+monto_pago+" excede al total a devolver: "+total_devolver);
		elemento.value=0;
		elemento.focus();
	}else if(suma_montos>total_devolver){
		alert("la suma de los montos excede al total devuelto");
		elemento.value=0;
		elemento.focus();
	}else{
		monto_devolucion=total_devolver-monto_pago;
		formu.monto_devolucion.value=monto_devolucion;
	}
}

function ValidaNumero(elemento, indice){
formu=document.edicion;
var suma = 0;
var nfilas_frebajar = parseInt('<%=nfilas_rebajar%>');
valor_real=formu.elements["cc_compromisos_rebaje["+indice+"][saldo]"];

	if(isNumber(elemento.value)){
		if( parseInt(valor_real.value) < parseInt(elemento.value) ){
		//alert(elemento.value);
			alert("El monto ingresado excede al saldo real del documento");
			elemento.value=valor_real.value;
			elemento.focus();
		}else{
			for (var i = 0; i < nfilas_frebajar; i++) {
				suma = parseInt(suma) + parseInt(formu.elements["cc_compromisos_rebaje[" + i + "][rebaje]"].value);
			}
			formu.total_rebajar_real.value=suma;
			return true;
		}
	}else{
		alert("Ingrese un numero valido");
		elemento.value="";
		elemento.focus();
	}
}

function ValidaDevolucion(elemento, indice){
formu=document.edicion;
var suma = 0;
var nfilas_fdevolver = parseInt(<%=nfilas_devolver%>);
//alert(nfilas_fdevolver);
valor_real=formu.elements["cc_compromisos_devuelve["+indice+"][monto_documento]"];
//alert(nfilas_fdevolver);
	if(isNumber(elemento.value)||(parseInt(elemento.value)<=0)){
		if( parseInt(valor_real.value) < parseInt(elemento.value) ){
		//alert(elemento.value);
			alert("El monto ingresado excede al monto real pagado");
			elemento.value=valor_real.value;
			elemento.focus();
		}else{
			for (var i = 0; i < nfilas_fdevolver; i++) {
				suma = parseInt(suma) + parseInt(formu.elements["cc_compromisos_devuelve[" + i + "][devuelve]"].value);
			}
			formu.total_devolver_real.value=suma;
			formu.monto_pago.value=0;
			formu.monto_devolucion.value=0;
			return true;
		}
	}else{
		alert("Ingrese un numero valido");
		elemento.value="";
		elemento.focus();
	}
}
function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
 }

function Validar(formulario)
{
	valor = uno_seleccionado(formulario);
	if	(valor == 1)// se selecciono uno
	{
		return true;
	}else{
		alert("Debe seleccionar una opcion a la vez");
	}
}



function ValidaBusqueda()
{
	n_rut=document.buscador.elements["busqueda[0][pers_nrut]"].value;
	n_dv=document.buscador.elements["busqueda[0][pers_xdv]"].value;
	rut=n_rut+ '-' +n_dv;
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.buscador.elements["busqueda[0][pers_nrut]"].focus();
		return false;
	}
	
	return true;	
}


function ValidaUso(elemento,uso){
v_uso=uso;
formu=document.edicion;
	switch (v_uso){
		case 1: 
			if((elemento.checked)&&(formu.total_devolver_real.value<=0)){
				alert("No puede seleccionar este uso ya que no registra monto a devolver");
				elemento.checked=false;
			} else if(elemento.checked== false){
				formu.monto_pago.value=0;
				formu.monto_devolucion.value=0;
			}else{
				formu.monto_pago.disabled=false;
				formu.monto_devolucion.disabled=false;
			}
		break;
		
		case 2:
			if((elemento.checked)&&(formu.total_devolver_real.value<=0)){
				alert("No puede seleccionar este uso ya que no registra monto a devolver");
				elemento.checked=false;
			}else if(elemento.checked== false){
				formu.monto_pago.value=0;
				formu.monto_devolucion.value=0;
			}else{
				formu.monto_pago.disabled=false;
				formu.monto_devolucion.disabled=false;
			}
		break;
		case 3:
			if((elemento.checked)&&(formu.total_rebajar_real.value<=0)){
				alert("No puede seleccionar este uso ya que no registra monto para anular");
				elemento.checked=false;
			}
		break;
	}
}

function ValidaFormulario(){
formu=document.edicion;
	if((formu.uso_nota1.checked)||(formu.uso_nota2.checked)||(formu.total_devolver_real.value>0)){
	//valida que almenos ingrese valores para distribuir la devolucion
		if((formu.monto_pago.value==0)&&(formu.monto_devolucion.value==0)){
			alert("No puede dejar el monto a devolver sin distribuir en la nota de crédito");
			return false;
		}else{
			if((formu.uso_nota1.checked)&&(formu.monto_pago.value==0)){
				alert("No puede dejar el monto 'Medio de pago' en cero si ha seleccionado esta opción");	
				return false;
			}
			if((formu.uso_nota2.checked)&&(formu.monto_devolucion.value==0)){
				alert("No puede dejar el monto 'Sujeto a devolución' en cero si ha seleccionado esta opción");	
				return false;
			}
			if((!formu.uso_nota1.checked)&&(formu.monto_pago.value>0)){
				alert("No puede asignar un monto 'Medio de pago' mayor a cero si NO ha seleccionado esta opción");	
				return false;
			}
			if((!formu.uso_nota2.checked)&&(formu.monto_devolucion.value>0)){
				alert("No puede asignar un monto 'Sujeto a devolución'  mayor a cero si NO ha seleccionado esta opción");	
				return false;
			}
			return true;
		}
	}
	
	if((!formu.uso_nota1.checked)&&(!formu.uso_nota2.checked)&&(!formu.uso_nota3.checked)){
		alert("No ha seleccionado un uso válido para la Nota de Crédito. \nSeleccione almenos uno segun corresponda y vuelva a intentarlo");
		return false;
	}
	
	if(formu.nota_credito.value>0){
		return true;
	}else{
		alert("No existe el número para la Nota de Crédito, ingrese un N° válido y vuelva a intentarlo");
		return false;
	}
return true;
}
</script>