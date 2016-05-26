<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

f_nrut = Request.Form("rut")
f_nombre = Request.Form("nombre")
v_nro_docto = Request.Form("nro_docto")
v_sint_ccod = Request.Form("v_sint_ccod")
v_simu_ccod = Request.Form("v_simu_ccod")


pers_nrut=left(trim(f_nrut),len(trim(f_nrut))-2)


set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "tabla_vacia.xml", "tabla"


'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.end()

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Calculo de intereses"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

Sede= negocio.obtenerSede

Usuario = negocio.ObtenerUsuario()

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "calcular_intereses.xml", "botonera"

'v_pers_ncorr=conexion.consultaUno("Select top 1 pers_ncorr from personas where cast(cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as varchar)=cast("&f_nrut&" as varchar) ")
'response.Write("pers_ncorr - >"&v_pers_ncorr)
v_pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar) ='" & pers_nrut & "'")

'---------------------------------------------------------------------------------------------------

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
function ValidaNumero(elemento){
	if(isNumber(elemento.value)){
		return true;
	}else{
		alert("Ingrese un numero valido");
		elemento.value="";
		elemento.focus();
	}
}
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="revisaVentana();" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
<form name="edicion" action="proc_calcular_intereses.asp" method="post" >
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Forma de Pago"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
                         <table width="96%"  border="0" cellspacing="0" cellpadding="0">
							 <tr>
							 	<th width="16%" align="left">Nombre Alumno : </th>
								<td width="84%" ><%=f_nombre%></td>
							 </tr>
							 <tr>
							 	<th align="left">Rut Alumno :</th>
								<td><%=f_nrut%></td>
							 </tr>
						 </table>
              <br>
			  </div>
            
			<input type="hidden" name="nro_docto" value="<%=v_nro_docto%>" />
			<input type="hidden" name="rut" value="<%=f_nrut%>" />
			<input type="hidden" name="nombre" value="<%=f_nombre%>" />
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalle a Pagar"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
								<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' >
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th width="9%"><font color='#333333'>Item</font></th>
									<th width="4%"><font color='#333333'>Cuota</font></th>
									<th width="12%"><font color='#333333'>Vencimiento</font></th>
									<th width="12%"><font color='#333333'>Documento</font></th>
									<th width="9%"><font color="#333333">N&deg; docto </font></th>
									<th width="10%"><font color="#333333">Monto docto </font></th>
									<th width="12%"><font color="#333333">Saldo deuda </font></th>
									<th width="8%"><font color="#333333">Interes </font></th>
									<th width="10%"><font color="#333333">Total </font></th>
									<th width="6%"><font color="#333333">Factor</font></th>
									<th width="8%"><font color="#333333">Dias Mora</font></th>
								</tr>
<%

suma=0
suma_total=0
suma_intereses=0
indice=0
v_cantidad_atrasados=0
monto_interes_propuesto=0
v_controla_interes=0

  set formulario = new CFormulario
  formulario.Carga_Parametros "calcular_intereses.xml", "detalle_pagos"
  formulario.Inicializar conexion
  formulario.ProcesaForm

  	for fila = 0 to formulario.CuentaPost - 1
		v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")

		if v_dcom_ncompromiso <> "" then

				suma = suma + conexion.ConsultaUno("select cast(protic.total_recepcionar_cuota("&v_tcom_ccod&","&v_inst_ccod&","&v_comp_ndocto&","&v_dcom_ncompromiso&") as varchar)")


				consulta_detalle	 = " Select g.esin_ccod,dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso, "& vbCrLf &_
										" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto'),0) as varchar) as numero_docto, "& vbCrLf &_    
										" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'monto'),cp.comp_mneto) as varchar) as monto_documento,  "& vbCrLf &_ 					
										" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') as varchar) as ting_ccod,  "& vbCrLf &_ 					
										" cast(protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso) as numeric)	as saldo, "& vbCrLf &_									
										" protic.trunc(dc.DCOM_FCOMPROMISO) fecha_vencimiento,e.tcom_tdesc as tipo_compromiso,upper(d.ting_tdesc) as tipo_ingreso,  "& vbCrLf &_    
										" replace(isnull(g.sint_nfactor,cast(isnull(f.fint_nfactor_anual/(12*100),0) as decimal(5,4) )),',','.') as factor_interes, case when datediff(day,dc.dcom_fcompromiso, getdate())>5 then datediff(day,dc.dcom_fcompromiso, getdate()) else 0 end as dias_mora, "& vbCrLf &_    
										" isnull(g.sint_minteres,ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso)*case when datediff(day,dc.dcom_fcompromiso, getdate())>5 then datediff(day,dc.dcom_fcompromiso, getdate())else 0 end)/30,0)) as interes, "& vbCrLf &_										
										" protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso)+ isnull(g.sint_minteres,round(((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso))*case when datediff(day,dc.dcom_fcompromiso, getdate())>5 then datediff(day,dc.dcom_fcompromiso, getdate())else 0 end)/30,0)) as total "& vbCrLf &_										
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
										" left outer join rango_factor_interes h "& vbCrLf &_
										" 	on datediff(day,dc.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo "& vbCrLf &_
										" 	and floor(dc.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max "& vbCrLf &_
										" left outer join factor_interes f "& vbCrLf &_
										" 	on f.rafi_ccod=h.rafi_ccod "& vbCrLf &_
										" 	and f.anos_ccod=datepart(year, getdate()) "& vbCrLf &_
										" 	and f.efin_ccod=1 "& vbCrLf &_
										" left outer join simulacion_interes g "& vbCrLf &_
										"	on dc.tcom_ccod = g.tcom_ccod    "& vbCrLf &_   
										"	and dc.inst_ccod = g.inst_ccod   "& vbCrLf &_    
										"	and dc.comp_ndocto = g.comp_ndocto "& vbCrLf &_
										"	and dc.dcom_ncompromiso=g.dcom_ncompromiso "& vbCrLf &_
										"	--and g.esin_ccod=2 "& vbCrLf &_
										" 	and cast(g.sint_ccod as varchar)= '"&v_sint_ccod&"' "& vbCrLf &_											
										" where dc.tcom_ccod ="&v_tcom_ccod&" "& vbCrLf &_    
										" and dc.inst_ccod   = "&v_inst_ccod&" "& vbCrLf &_
										" and dc.comp_ndocto = "&v_comp_ndocto&" "& vbCrLf &_
										" and dc.dcom_ncompromiso="&v_dcom_ncompromiso&" "

'response.Write("<pre>"&consulta_detalle&"</pre><br>")				


						f_compromiso.Inicializar conexion
						f_compromiso.Consultar consulta_detalle
						f_compromiso.siguienteF

					if Clng(f_compromiso.ObtenerValor("dias_mora"))=0 or f_compromiso.ObtenerValor("numero_docto")=0 then
						v_disabled="disabled"
					else
						v_activo=f_compromiso.ObtenerValor("esin_ccod")
						v_disabled="enabled"
						v_cantidad_atrasados=v_cantidad_atrasados+1
						if v_simu_ccod="" then
							if v_sint_ccod = "" then
								v_sint_ccod 		= conexion.consultauno("exec ObtenerSecuencia 'intereses'")
							end if
							sql_inserta_simulacion=" insert into simulacion_interes "&_
												" (sint_ccod,esin_ccod,pers_ncorr,sint_minteres,sint_nfactor,comp_ndocto_referencia,"&_
												" comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso,audi_tusuario,audi_fmodificacion ) "&_
												"Values "&_
												" ("&v_sint_ccod&",1,"&v_pers_ncorr&","&f_compromiso.ObtenerValor("interes")&","&f_compromiso.ObtenerValor("factor_interes")&",null, "&_
												" "&v_comp_ndocto&","&v_tcom_ccod&","&v_inst_ccod&","&v_dcom_ncompromiso&",'"&Usuario&"',getdate() ) "
					'response.Write("<pre>"&sql_inserta_simulacion&"</pre>")
							conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_simulacion)
						end if
					end if
%>				
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][tcom_ccod]" value="<%f_compromiso.dibujaCampo("tcom_ccod")%>" />
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][comp_ndocto]" value="<%f_compromiso.dibujaCampo("comp_ndocto")%>"/>
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][inst_ccod]" value="<%f_compromiso.dibujaCampo("inst_ccod")%>" />
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][dcom_ncompromiso]" value="<%f_compromiso.dibujaCampo("dcom_ncompromiso")%>" />
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][saldo]" value="<%f_compromiso.dibujaCampo("saldo")%>" />
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][dias_mora]" value="<%f_compromiso.dibujaCampo("dias_mora")%>" />

<tr bgcolor="#FFFFFF">
	<td><%f_compromiso.dibujaCampo("tipo_compromiso")%></td>
	<td><%f_compromiso.dibujaCampo("dcom_ncompromiso")%></td>
	<td><%f_compromiso.dibujaCampo("fecha_vencimiento")%></td>
	<td><%f_compromiso.dibujaCampo("tipo_ingreso")%></td>
	<td><%f_compromiso.dibujaCampo("numero_docto")%></td>
	<td><%=formatcurrency(f_compromiso.ObtenerValor("monto_documento"),0)%></td>
	<td><%=formatcurrency(f_compromiso.ObtenerValor("saldo"),0)%></td>
	<td><%=formatcurrency(f_compromiso.ObtenerValor("interes"),0)%></td>
	<td><%=formatcurrency(f_compromiso.ObtenerValor("total"),0)%></td>
	<td><input type="text" value="<%=f_compromiso.ObtenerValor("factor_interes")%>" name="cc_compromisos_pendientes[<%=indice%>][factor]" size="6" <%=v_disabled%> onBlur="ValidaNumero(this);" ></td>
	<td><%f_compromiso.dibujaCampo("dias_mora")%></td>
</tr>
				
<%
		suma_total=suma_total + Clng(f_compromiso.ObtenerValor("total"))
		suma_intereses=suma_intereses + Clng(f_compromiso.ObtenerValor("interes"))
		indice=indice+1
		end if	' fin si fue checkeado
	next
%>
<tr>
<td colspan="8" align="right"><font color="#0033CC" size="2"><b> Total a Pagar :</b></font></td>
<td><b><%=formatcurrency(suma_total,0)%></b></td>
<td><input type="hidden" name="v_sint_ccod" value="<%=v_sint_ccod%>" /></td>
<td></td>
</tr>
<%

'**********************************
response.Write("<font color='#FF0033' size='2'><b>Monto deuda original</b></font> : <font size='2'><b>"&formatcurrency(suma,0)&"</b></font>")
'response.Write("<br> Estado Transaccion 1 : "&conexion.obtenerEstadoTransaccion)

'--------------------------------------------------------------
if suma_intereses >= 0 then

	' si no a presionado calcular
	if v_simu_ccod="" then
'response.Write("<hr>***********<hr>")
		' crear compromiso pendiente por concepto de interes
		secuencia 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
		tipo_compromiso = 6
		periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
		
		sql_compromiso_interes = " INSERT INTO compromisos (tcom_ccod, ecom_ccod, inst_ccod, comp_ndocto,  pers_ncorr, comp_fdocto, "&_ 
												 "comp_ncuotas, comp_mneto, comp_mdescuento, comp_mintereses, comp_miva, "&_ 
												 "comp_mexento, comp_mdocumento, sede_ccod, audi_tusuario, audi_fmodificacion) "&_ 
								 " VALUES (" & tipo_compromiso & ",2,1," & secuencia & "," & v_pers_ncorr & ",getdate(),"&_
										   "1," & suma_intereses & ",null,null,null,"&_ 
										   "null," & suma_intereses & "," & Sede & ",'" & Usuario & "',getdate())" 
		'response.Write(sql_compromiso_interes)
		sql_detalles_compromiso_interes = " INSERT INTO detalle_compromisos (tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,dcom_fcompromiso,dcom_mneto,"&_ 
													"dcom_mintereses,dcom_mcompromiso,ecom_ccod,pers_ncorr,peri_ccod,audi_tusuario,audi_fmodificacion) "&_ 
										  " VALUES (" & tipo_compromiso & ",'1'," & secuencia & ",'1',getdate()," & suma_intereses & ","&_
													 "null," & suma_intereses & ",'1'," & v_pers_ncorr & "," & periodo & ",'" & Usuario & "',getdate())"
	
		sql_detalles_interes =  " INSERT INTO detalles (tcom_ccod,inst_ccod,comp_ndocto,tdet_ccod,deta_ncantidad,deta_mvalor_unitario,"&_ 
								" deta_mvalor_detalle,deta_msubtotal,audi_tusuario, audi_fmodificacion )"&_
								" VALUES (" & tipo_compromiso & ",1," & secuencia & ",1439,1,"&suma_intereses&","&_
								" "&suma_intereses&", "&suma_intereses&",'" & Usuario & "',getdate())"
	
		sql_actualiza_simulacion=" Update simulacion_interes set comp_ndocto_referencia="&secuencia&",sint_minteres_calculado="&suma_intereses&" where cast(sint_ccod as varchar)='"&v_sint_ccod&"'"
	
		conexion.EstadoTransaccion conexion.EjecutaS(sql_compromiso_interes)
	'response.Write("<br> Estado Transaccion 2: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_detalles_compromiso_interes)
	'response.Write("<br> Estado Transaccion 3: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_detalles_interes)
	'response.Write("<br> Estado Transaccion 4: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_simulacion)
	'response.Write("<br> Estado Transaccion 5: "&conexion.obtenerEstadoTransaccion)
	'response.Write("<br> Estado Transaccion 5: "&sql_actualiza_simulacion)
'response.Write("-")
'response.Flush()
'response.End()
	else
	' si ya ha sido calculado se actualizan los valores
		secuencia= conexion.consultaUno("select comp_ndocto_referencia from simulacion_interes where sint_ccod="&v_sint_ccod)
		monto_interes_propuesto= conexion.consultaUno("select top 1 sint_minteres_calculado from simulacion_interes where sint_ccod="&v_sint_ccod)
		
		if clng(monto_interes_propuesto)=clng(suma_intereses) then
			v_controla_interes=1
		end if

		sql_actualiza_compromiso= 	" Update compromisos set comp_mneto="&suma_intereses&" , comp_mdocumento="&suma_intereses&" "& vbCrLf &_ 
									" Where comp_ndocto="&secuencia&" and tcom_ccod=6 and inst_ccod=1 " 
		'response.Write("<pre>"&sql_actualiza_compromiso&"</pre>")	

		sql_actualiza_detalle_compromiso= 	" Update detalle_compromisos set dcom_mneto="&suma_intereses&" , dcom_mcompromiso="&suma_intereses&" "& vbCrLf &_ 
											" Where comp_ndocto="&secuencia&"  and tcom_ccod=6 and inst_ccod=1 and dcom_ncompromiso=1 " 
		'response.Write("<pre>"&sql_actualiza_detalle_compromiso&"</pre>")
	
		sql_actualiza_detalles= 	" Update detalles set deta_mvalor_unitario="&suma_intereses&" , deta_mvalor_detalle="&suma_intereses&", deta_msubtotal="&suma_intereses&" "& vbCrLf &_ 
									" Where  comp_ndocto="&secuencia&"  and tcom_ccod=6 and inst_ccod=1  " 
		'response.Write("<pre>"&sql_actualiza_detalles&"</pre>")
	
	
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_compromiso)
		'response.Write("<br> Estado Transaccion 6: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalle_compromiso)
		'response.Write("<br> Estado Transaccion 7: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalles)
		'response.Write("<br> Estado Transaccion 8: "&conexion.obtenerEstadoTransaccion)
	end if
else
	f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "false"
end if
'--------------------------------------------------------------
'response.Write("<hr>Caculado :"&monto_interes_propuesto&" ¿ = ?"&suma_intereses&" <hr>")
' si esta activo o no existen morosidades se habilita el boton siguiente


if v_activo="3" or v_cantidad_atrasados=0  then
	disabled="disabled"
	f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "false"
	v_controla_interes=0
end if
%>
								</table>
							</td>
                        </tr>
						<tr>
							<td align="right"><input type="submit" value="Calcular" <%=disabled%> ></td>
						</tr>                
                      </table>
                      </td>
                  </tr>
                </table>
				 <br>
</td></tr>
        </table>
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
		<tr bgcolor='#C4D7FF' bordercolor='#999999'>
			<th width="8%"><font color='#333333'>Inluir en Pago</font></th>
			<th width="12%"><font color='#333333'>N° compromiso</font></th>
			<th width="20%"><font color='#333333'>Item</font></th>
			<th width="7%"><font color='#333333'>Cuota</font></th>
			<th width="13%"><font color='#333333'>Fecha Inicio</font></th>
			<th width="12%"><font color='#333333'>Vencimiento</font></th>
			<th width="13%"><font color="#333333">Monto Interes </font></th>
			<th width="15%"><font color="#333333">Estado</font></th>
		</tr>

<%

set f_compromiso_interes = new CFormulario
f_compromiso_interes.Carga_Parametros "tabla_vacia.xml", "tabla"

		sql_compromiso_generado= "select b.comp_ndocto,b.dcom_ncompromiso,b.tcom_ccod,b.inst_ccod,e.tdet_tdesc as tipo_compromiso, protic.trunc(a.comp_fdocto) as fecha_inicio, "& vbCrLf &_
								" protic.trunc(b.dcom_fcompromiso) as fecha_vencimiento,isnull(a.comp_mneto,0) as monto_compromiso, "& vbCrLf &_
								" protic.trunc(a.comp_fdocto) as fecha_inicio,d.ecom_tdesc as estado_compromiso "& vbCrLf &_
								" from compromisos a, detalle_compromisos b, detalles c , estados_compromisos d, tipos_detalle e "& vbCrLf &_ 
								" where a.comp_ndocto=b.comp_ndocto "& vbCrLf &_ 
								" and a.tcom_ccod=b.tcom_ccod "& vbCrLf &_
								" and a.inst_ccod=b.inst_ccod "& vbCrLf &_
								" and a.ecom_ccod=d.ecom_ccod "& vbCrLf &_
								" and b.tcom_ccod=c.tcom_ccod "& vbCrLf &_
								" and b.comp_ndocto=c.comp_ndocto "& vbCrLf &_
								" and b.inst_ccod=c.inst_ccod "& vbCrLf &_
								" and c.tdet_ccod=e.tdet_ccod "& vbCrLf &_
								" and a.tcom_ccod=6 "& vbCrLf &_
								" and cast(a.comp_ndocto as varchar)='"&secuencia&"'"

'response.Write("<pre>"&sql_compromiso_generado&"</pre>")
'response.Flush()

	f_compromiso_interes.Inicializar conexion
	f_compromiso_interes.Consultar sql_compromiso_generado
	f_compromiso_interes.siguienteF

'response.Write("Filas"&f_compromiso_interes.nrofilas)
if v_simu_ccod <> "" and f_compromiso_interes.nrofilas > 0 then
%>
		<tr bgcolor="#FFFFFF">
			<td align="center"><input type="checkbox" name="cc_compromisos_pendientes[<%=indice%>][dcom_ncompromiso]" value="<%f_compromiso_interes.dibujaCampo("dcom_ncompromiso")%>" ></td>
			<td><%f_compromiso_interes.dibujaCampo("comp_ndocto")%></td>
			<td><%f_compromiso_interes.dibujaCampo("tipo_compromiso")%></td>
			<td><%f_compromiso_interes.dibujaCampo("dcom_ncompromiso")%></td>
			<td><%f_compromiso_interes.dibujaCampo("fecha_inicio")%></td>
			<td><%f_compromiso_interes.dibujaCampo("fecha_vencimiento")%></td>
			<td><font color="#009933"><b><%=formatcurrency(f_compromiso_interes.ObtenerValor("monto_compromiso"),0)%></b></font></td>
			<td><font color="#FF0000"><b><%f_compromiso_interes.dibujaCampo("estado_compromiso")%></b></font></td>
		</tr>
<%else%>
		<tr bgcolor="#FFFFFF">
			<td colspan="8" align="center">presione el boton calcular para generar un compromiso por concepto de intereses</td>
		</tr>
<%end if%>
	</table>
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][tcom_ccod]" value="<%f_compromiso_interes.dibujaCampo("tcom_ccod")%>" />
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][comp_ndocto]" value="<%f_compromiso_interes.dibujaCampo("comp_ndocto")%>"/>
<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][inst_ccod]" value="<%f_compromiso_interes.dibujaCampo("inst_ccod")%>" />

<br/>
</form>
</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
							<%
							'response.Write("monto interes:  "&monto_interes_propuesto&"   suma interes   "&suma_intereses&"   con in"&v_controla_interes)
								if clng(monto_interes_propuesto)=clng(suma_intereses) and v_controla_interes=1  then
									f_botonera.DibujaBoton("siguiente2")
								else
									f_botonera.DibujaBoton("siguiente")
								end if
							%>
					</div>
				</td>
				  <td><% 
						f_botonera.DibujaBoton("cerrar")
					 %></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>
