<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
v_post_ncorr = Request.QueryString("busqueda[0][post_ncorr]")
'*******************************************************************
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:11/12/2013
'ACTUALIZADO POR	:MICHAEL SHAW ROJAS
'MOTIVO			:AGREGAR DESCUENTOS POR PASE MATRICULA
'LINEA			:75 AL 194
'*******************************************************************

'response.Write(v_datos(0))

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Proponer Descuento/Beca/Crédito"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

if not EsVacio(v_post_ncorr)  then
	v_datos=split(v_post_ncorr,"&")
	v_post_ncorr_carrera=v_datos(0)
	v_oferta=v_datos(1)
	
	sql_update="Update postulantes set ofer_ncorr="&v_oferta&" where post_ncorr="&v_post_ncorr_carrera&" "
	'response.Write(sql_update)
	conexion.ejecutaS(sql_update)
end if
'---------------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_2.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "autorizacion_descuentos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "post_ncorr", v_post_ncorr

consulta_select = "(select cast(b.post_ncorr as varchar)+'&'+cast(bb.ofer_ncorr as varchar) as post_ncorr, e.carr_tdesc as carrera -- +'-'+ d.espe_tdesc as carrera " & vbcrlf & _ 
				 " from personas_postulante a, postulantes b, detalle_postulantes bb, ofertas_academicas c, " & vbcrlf & _  
                 " especialidades d, carreras e " & vbcrlf & _ 
				 " where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _  
				 "  and bb.ofer_ncorr = c.ofer_ncorr " & vbcrlf & _ 
				 "  --and b.ofer_ncorr =c.ofer_ncorr " & vbcrlf & _  
				 "  and b.post_ncorr = bb.post_ncorr " & vbcrlf & _  
				 "  and c.espe_ccod = d.espe_ccod " & vbcrlf & _  
				 "  and d.carr_ccod = e.carr_ccod " & vbcrlf & _  
				 "  and b.tpos_ccod in (1,2) " & vbcrlf & _  
				 "  and b.epos_ccod = 2  " & vbcrlf & _ 
				 "  and b.peri_ccod =  " & v_peri_ccod & " " & vbcrlf & _ 
				 "  and cast(a.pers_nrut as varchar)=  '" & q_pers_nrut & "') a "

'response.Write("<pre>"&consulta_select&"</pre>")
				 
f_busqueda.AgregaCampoParam "post_ncorr", "destino", consulta_select

v_cantidad_carrera=conexion.consultaUno("Select count(*) from "&consulta_select&" ")


'----------------------------------------------------------------------------------------------------------------
'-----------------------------AGREGAR DESCUENTOS POR PASE MATRICULA----------------------------------------------
if q_pers_nrut <> "" and  v_post_ncorr <> "" then  'INGRESO DE DATOS AL PRESIONAR BUSCAR

consulta_q_post_ncorr = "select cast(b.post_ncorr as varchar) from personas_postulante a, postulantes b, detalle_postulantes bb, ofertas_academicas c, especialidades d, carreras e " & vbcrlf & _ 
				 " where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _  
				 "  and bb.ofer_ncorr = c.ofer_ncorr " & vbcrlf & _ 
				 "  and b.post_ncorr = bb.post_ncorr " & vbcrlf & _  
				 "  and c.espe_ccod = d.espe_ccod " & vbcrlf & _  
				 "  and d.carr_ccod = e.carr_ccod " & vbcrlf & _  
				 "  and b.tpos_ccod in (1,2) " & vbcrlf & _  
				 "  and b.epos_ccod = 2  " & vbcrlf & _ 
				 "  and b.peri_ccod =  " & v_peri_ccod & " " & vbcrlf & _ 
				 "  and cast(a.pers_nrut as varchar)=  '" & q_pers_nrut &"'"

q_post_ncorr=conexion.consultaUno(consulta_q_post_ncorr)

v_post_nuevo=conexion.consultaUno("Select post_bnuevo from postulantes where post_ncorr="&q_post_ncorr&" ")


	if(v_post_nuevo<>"S") then
			sql_cantidad_pases="Select count(*) from postulantes a, pase_matricula b "& vbCrLf &_ 
								" where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"' "& vbCrLf &_
								" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
								" and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_ 
								" and a.post_ncorr=b.post_ncorr "
			'response.Write("<pre>"&sql_cantidad_pases&"</pre>")					
			
			cantidad_pases=conexion.consultaUno(sql_cantidad_pases)
	
			carrera=conexion.consultaUno("Select c.carr_ccod from postulantes a, ofertas_academicas b,especialidades c,detalle_postulantes d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"' and a.post_ncorr=d.post_ncorr and d.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod")
			tipo_carrera= conexion.consultaUno("Select tcar_ccod from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
	
	'---------------------busca si existe un pase_matricula para esa carrera y ese usuario en el periodo dado
			consulta=" Select 1 from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
				  " where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
				  " and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
				  " and a.post_ncorr=b.post_ncorr "& vbCrLf &_ 
				  " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
				  " and b.ofer_ncorr=c.ofer_ncorr "& vbCrLf &_ 
				  " and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
				  " and cast(d.carr_ccod as varchar)='"&carrera&"'"
	'response.Write("<pre>"&consulta&"</pre>")	
	'response.End()		  
			encontrado=conexion.consultaUno(consulta) 
			ofer_ncorr=conexion.consultaUno("Select ofer_ncorr from postulantes  where cast(post_ncorr as varchar)='"&q_post_ncorr&"'")
		'response.Write(cantidad_pases)  
		if cantidad_pases > "0"  and encontrado="1" then
			  
			 
			  porc_matricula_01=" Select pama_nporc_matricula from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
									 " where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
									 " and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
									 " and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
									 " and cast(d.carr_ccod as varchar)='"&carrera&"'"
									 
			  porc_colegiatura_01=" Select pama_nporc_colegiatura from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
									 " where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
									 " and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
									 " and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
									 " and cast(d.carr_ccod as varchar)='"&carrera&"'"
			  
			  p_matricula=clng(conexion.consultaUno(porc_matricula_01))/100
			  p_colegiatura=clng(conexion.consultaUno(porc_colegiatura_01))/100
			  
			  valor_real_matricula=conexion.consultaUno("select isnull(aran_mmatricula,0) from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr")
			  valor_real_colegiatura=conexion.consultaUno("select aran_mcolegiatura from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr")
			  sql_matr="select isnull(aran_mmatricula,0) from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr"
			  'response.Write("<br>ofer_ncorr "&sql_matr)
			  descuento_matricula=clng(valor_real_matricula)* p_matricula
			  descuento_colegiatura=clng(valor_real_colegiatura)* p_colegiatura
			  
			  'response.Write("p_matricula "&p_matricula&" p_colegiatura "&p_colegiatura)
			  'response.Write("<br>d_matricula "&descuento_matricula&" d_colegiatura "&descuento_colegiatura)
			  'response.Write("select count(*) from sdescuentos where cast(post_ncorr as varchar)='"&q_post_ncorr&"' and stde_ccod=1262")
			  buscar_descuento_pase=conexion.consultaUno("select count(*) from sdescuentos where cast(post_ncorr as varchar)='"&q_post_ncorr&"' and cast(stde_ccod as varchar)='1262'")    	 
			  
			  if buscar_descuento_pase = "0" then
			  
					'se debe ingresar un nuevo registro en la tabla sdescuentos con el contenido de ese pase matricula		  
					'response.Write("<br>buscar_descuento_pase "&buscar_descuento_pase)
					tipo_descuento=1262
					consulta_insercion="INSERT INTO sdescuentos(stde_ccod,post_ncorr,ofer_ncorr,esde_ccod,sdes_mmatricula,sdes_mcolegiatura,sdes_nporc_matricula,sdes_nporc_colegiatura,sdes_tobservaciones, audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
								 " Select "&tipo_descuento&","&q_post_ncorr&","&ofer_ncorr&",1,"&descuento_matricula&","&descuento_colegiatura&",pama_nporc_matricula,pama_nporc_colegiatura,pama_tobservaciones,'traspaso-pactacion',getDate() "& vbCrLf  &_  
								 " from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
								 " and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
								 " and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and a.post_ncorr=b.post_ncorr "& vbCrLf &_    
								 " and cast(d.carr_ccod as varchar)='"&carrera&"'"
					'response.Write("<br><pre>"&consulta_insercion&"</pre>")	
					'response.End()				 
					conexion.EstadoTransaccion conexion.EjecutaS(consulta_insercion)	
			  else
				 'se debe modificar el registro de sdescuentos con la nueva información del pase matricula
	 
					descripcion_01=" Select pama_tobservaciones from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
									 " and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
									 " and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
									 " and cast(d.carr_ccod as varchar)='"&carrera&"'"					 
									 
					consulta_actualizacion=" UPDATE sdescuentos "& vbCrLf  &_ 
										" SET sdes_mmatricula = "&descuento_matricula&", "& vbCrLf  &_ 
										"	  sdes_nporc_matricula = "&conexion.consultaUno(porc_matricula_01)&", "& vbCrLf  &_
										"	  sdes_mcolegiatura = "&descuento_colegiatura&", "& vbCrLf  &_ 					
										"	  sdes_nporc_colegiatura = "&conexion.consultaUno(porc_colegiatura_01)&", "& vbCrLf  &_
										"	  sdes_tobservaciones = '"&conexion.consultaUno(descripcion_01)&"', "& vbCrLf  &_
										"     audi_tusuario = 'traspaso-pactacion', "& vbCrLf  &_ 
										"     audi_fmodificacion = getdate() "& vbCrLf  &_ 
										" WHERE cast(post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf  &_ 
										"  and stde_ccod = '1262'"
					'response.Write("<br><pre>"&consulta_actualizacion&"</pre>")					 						
					conexion.EstadoTransaccion conexion.EjecutaS(consulta_actualizacion)							
			  end if
		
		end if
		
	end if ' Fin condicion que evalua si es alumno nuevo	

end if 
'-------------------------------FIN DEL AGREGA DESCUENTOS PASE MATRICULA-------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------

'v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_sede_ccod = negocio.ObtenerSede

consulta = "select max(b.post_ncorr) as post_ncorr " & vbCrLf &_
           "from personas_postulante a, postulantes b, ofertas_academicas c " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
'v_post_ncorr = conexion.ConsultaUno(consulta)

'---------------------------------------------------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, v_post_ncorr_carrera
		

'---------------------------------------------------------------------------------------------------------
set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "autorizacion_descuentos.xml", "descuentos"
f_descuentos.Inicializar conexion

			
consulta = "select " & vbCrLf &_
			"	'<input type=""hidden"" name=""descuentos[' + cast((a.rownum - 1) as varchar) + '][oculto]""><a href=""javascript:mostrar_informe(' +  cast(a.post_ncorr as varchar) + ',' +  cast(a.ofer_ncorr as varchar) + ',' + cast(a.stde_ccod as varchar) + ')""><center>Ver...</center></a>' as informe, a.* " & vbCrLf &_
			"from" & vbCrLf &_
			"(select (select count(stde_ccod) " & vbCrLf &_
			"        from sdescuentos aa,postulantes cc" & vbCrLf &_
			"        where  cc.post_ncorr= c.post_ncorr " & vbCrLf &_
			"        and aa.stde_ccod >= a.stde_ccod " & vbCrLf &_
			"        and cc.ofer_ncorr >=c.ofer_ncorr " & vbCrLf &_
			"        and  cc.post_ncorr >= c.post_ncorr and cast(c.post_ncorr as varchar) = '" & v_post_ncorr_carrera & "') as rownum, " & vbCrLf &_
			"			    a.stde_ccod, a.post_ncorr, a.ofer_ncorr, " & vbCrLf &_
			"			    isnull(a.sdes_nporc_matricula,0) as sdes_nporc_matricula, " & vbCrLf &_
			"			    isnull(a.sdes_nporc_colegiatura,0) as sdes_nporc_colegiatura, a.esde_ccod, " & vbCrLf &_
			"			    b.stde_tdesc, cast(isnull(a.sdes_mmatricula,0) as numeric) as sdes_mmatricula, " & vbCrLf &_
			"			    cast(isnull(a.sdes_mcolegiatura,0) as numeric) as sdes_mcolegiatura, " & vbCrLf &_
			"			    isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as subtotal " & vbCrLf &_
			"			    from sdescuentos a,stipos_descuentos b,postulantes c " & vbCrLf &_
			"			    where a.stde_ccod = b.stde_ccod " & vbCrLf &_
			"			        and a.post_ncorr = c.post_ncorr " & vbCrLf &_
			"			        and a.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			"			        and cast(c.post_ncorr as varchar) = '" & v_post_ncorr_carrera & "') a " & vbCrLf &_
			"			 order by rownum"
			
'response.Write("<pre>"&consulta&"</pre>")  			
f_descuentos.Consultar consulta
f_descuentos.AgregaCampoParam "esde_ccod", "permiso", "LECTURA"
'---------------------------------------------------------------------------------------------------
consulta = "select count(*) " & vbCrLf &_
           "from contratos " & vbCrLf &_
		   "where econ_ccod <> 3 " & vbCrLf &_
		   "  and cast(post_ncorr as varchar) = '" & v_post_ncorr_carrera & "'"
'response.Write("<pre>"&consulta&"</pre>")  
if CInt(conexion.ConsultaUno(consulta)) > 0 then
	b_contrato_generado = true
else
	b_contrato_generado = false
end if


if b_contrato_generado then
	f_descuentos.AgregaCampoParam "esde_ccod", "permiso", "LECTURA"
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

if f_descuentos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if
f_botonera.AgregaBotonParam "agregar_descuento", "url", "agregar_descuento.asp?post_ncorr=" & v_post_ncorr_carrera




if v_post_ncorr_carrera="" and q_pers_nrut <>"" and v_cantidad_carrera=0 then
	mensaje_no_postula="Alumno no presenta postulación asociada al periodo académico seleccionado"
end if

if v_peri_ccod <= "209" then
	mensaje_no_postula= mensaje_no_postula&"<br> El periodo de postulacion seleccionado es inferior al periodo de admision 2008"
end if

'response.End()
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:left;
}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;	
}

function InicioPagina()
{
}


function mostrar_informe(post_ncorr,ofer_ncorr,stde_ccod)
{
  resultado = open("info_descuentos.asp?post_ncorr=" + post_ncorr + "&amp;ofer_ncorr=" + ofer_ncorr + "&amp;stde_ccod=" + stde_ccod,  "", "top=100, left=100, width=480, height=215, scrollbars=yes");	
}

</script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
                        <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td><div align="right">R.U.T. Postulante </div></td>
                            <td width="7%"><div align="center">:</div></td>
                            <td><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                          </tr>
						  <tr>
                            <td><div align="right">Carreras Postulante </div></td>
                            <td width="7%"><div align="center">:</div></td>
                            <td><%f_busqueda.DibujaCampo("post_ncorr")%>
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
			  <font color="#FF0000" size="2"><b><%=mensaje_no_postula%></b></font>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%postulante.DibujaDatos%></td>
                </tr>
                <tr>
                  <td><br>
                    <%
					if not EsVacio(v_post_ncorr_carrera) then
						postulante.DibujaTablaValores
					end if
					%></td>
                </tr>
              </table>
              <div align="left"><br>
                  <br>
				  <%pagina.DibujarSubtitulo("Descuentos asignados")%>
                </div>
            </div>              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><form name="edicion">
					<div align="center"><%f_descuentos.DibujaTabla%></div>	
                      </form>
					  </td></tr>
                </table>
                          <br>
</td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="30%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%
					if (v_post_ncorr_carrera="" and q_pers_nrut <>"") or (v_peri_ccod<="209") then
						variable=""
					else
						f_botonera.DibujaBoton("agregar_descuento")
					end if
					%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
