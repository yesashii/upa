<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_plan_ccod  = Request.QueryString("plan_ccod")
q_peri_ccod  = Request.QueryString("peri_ccod")
q_pers_nrut  = Request.QueryString("pers_nrut")
q_pers_xdv   = Request.QueryString("pers_xdv")
q_ctes_ncorr = Request.QueryString("ctes_ncorr")
solo_practica = Request.QueryString("solo_practica")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Datos de Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_egreso_titulacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "detalle_egreso_titulacion.xml", "datos_titulacion"
f_titulado.Inicializar conexion

'v_sede_ccod = negocio.ObtenerSede

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")


SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre"
SQL = SQL &  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"
SQL = SQL &  " where b.espe_ccod = c.espe_ccod"
SQL = SQL &  "   and c.carr_ccod = d.carr_ccod"
SQL = SQL &  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "'"
SQL = SQL &  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "'"
SQL = SQL &  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
SQL = SQL &  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

'SQL = " select top 1 d.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, c.peri_ccod, f.carr_tdesc, e.espe_tdesc, "& vbCrLf & _
	'  " h.peri_tdesc, d.sede_tdesc, g.plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, "& vbCrLf & _
'	  " protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "& vbCrLf & _
'	  " from personas a, alumnos b, ofertas_academicas c, sedes d, especialidades e, carreras f,"& vbCrLf & _
'	  " planes_estudio g, periodos_academicos h "& vbCrLf & _
'	  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr "& vbCrLf & _
'	  " and c.sede_ccod=d.sede_ccod and c.espe_ccod=e.espe_ccod "& vbCrLf & _
'	  " and e.carr_ccod=f.carr_ccod and c.peri_ccod=h.peri_ccod "& vbCrLf & _
'	  " and b.plan_ccod=g.plan_ccod  "& vbCrLf & _
'	  " and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "' "& vbCrLf & _
'	  " and cast(c.peri_ccod as varchar)= '" & q_peri_ccod & "' "
'response.Write("<pre>"&SQL&"</pre>")
'response.End()
f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' --and isnull(nombre_empresa,'0') <> '0' and case concepto_practica when null then 'N' when '' then 'N' else 'S' end  <> 'N' ")
c_tiene_folio = " select count(*) from salidas_alumnos a, salidas_plan b where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' "&_
				" and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' "
tiene_folio = conexion.consultaUno(c_tiene_folio)				
'response.Write(tiene_folio)
if tiene_folio <> "0" then 
	c_registro = " select salu_nregistro from salidas_alumnos a, salidas_plan b where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' "&_
			  " and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' "
	registro = conexion.consultaUno(c_registro)
	c_folio = " select salu_nfolio from salidas_alumnos a, salidas_plan b where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' "&_
			  " and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' "
	folio = conexion.consultaUno(c_folio)
else
	c_registro = " select max(salu_nregistro) + 1 from salidas_alumnos "
	registro = conexion.consultaUno(c_registro)
	c_registro2 = " select isnull(max(salu_nregistro),0) + 1 from detalles_titulacion "
	registro2 = conexion.consultaUno(c_registro2)
	if cdbl(registro) < cdbl(registro2) then
		registro = registro2
	end if
	folio_partida = "5500"
	if cdbl(registro) < cdbl(folio_partida) then
		registro = folio_partida
	end if
	carr_ccod = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&q_plan_ccod&"'")
	if carr_ccod = "51" or carr_ccod = "930" or carr_ccod = "810" or carr_ccod = "920" then 
		carr_ccod = "51"
	end if 
	if carr_ccod = "12" or carr_ccod = "910" or carr_ccod = "900" or carr_ccod = "890" then 
		carr_ccod="12"
	end if
	anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&q_peri_ccod&"'")
	folio = carr_ccod&"-"&registro&"-"&anos_ccod
end if
'response.Write(folio)
'response.Write("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"")
if tiene_grabado = "S" then
	 consulta = " select pers_ncorr,plan_ccod,nombre_empresa,ubicacion_empresa,telefono_empresa,email_empresa,nombre_encargado,salu_nregistro,salu_nfolio,protic.trunc(fecha_proceso) as fecha_proceso, "&_
				" cargo_encargado,protic.trunc(inicio_practica) as inicio_practica,protic.trunc(termino_practica) as termino_practica,observaciones, "&_
			    " descripcion_practica,horas_practica,replace(calificacion_practica,',','.') as calificacion_practica,b.sitf_ccod,protic.trunc(fecha_egreso) as fecha_egreso "&_
				" from detalles_titulacion a left outer join situaciones_finales b " &_
				" 		on a.concepto_practica = b.sitf_ccod " &_
				" where cast(plan_ccod as varchar)='"&q_plan_ccod&"' " &_
				" and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
else
     consulta = " select '"&q_plan_ccod&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr, '"&registro&"' as salu_nregistro, '"&folio&"' as salu_nfolio"
end if
'response.Write(consulta)
set f_practica = new CFormulario
f_practica.Carga_Parametros "detalle_egreso_titulacion.xml", "datos_egreso"
f_practica.Inicializar conexion

f_practica.Consultar consulta
f_practica.Siguiente


if q_ctes_ncorr <> "" then
	 consulta_comision = " select '"&q_peri_ccod&"' as peri_ccod,ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente, "&_
				" replace(calificacion_asignada,',','.') as calificacion_asignada " &_
				" from comision_tesis a, personas b "&_
				" where a.pers_ncorr=b.pers_ncorr "&_
				" and cast(a.ctes_ncorr as varchar)='"&q_ctes_ncorr&"'"
else
     consulta_comision = " select '"&q_plan_ccod&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if
'--------------------para insertar docente de la comisión
set f_comision = new CFormulario
f_comision.Carga_Parametros "detalle_egreso_titulacion.xml", "comision_tesis"
f_comision.Inicializar conexion

consulta_lista_comision = " select '"&q_peri_ccod&"' as peri_ccod,ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente, "&_
				" replace(isnull(calificacion_asignada,1.0),',','.') as calificacion_asignada, cast(isnull(calificacion_asignada,1.0) as decimal(2,1)) as nota " &_
				" from comision_tesis a, personas b "&_
				" where a.pers_ncorr=b.pers_ncorr "&_
				" and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(a.plan_ccod as varchar)='"&q_plan_ccod&"' "			

f_comision.Consultar consulta_comision
f_comision.Siguiente

'response.Write(consulta_lista_comision)
'-----------------------para mostrar listado de docentes de la comisión evaluadora

set f_lista_comision = new CFormulario
f_lista_comision.Carga_Parametros "detalle_egreso_titulacion.xml", "lista_comision_tesis"
f_lista_comision.Inicializar conexion

f_lista_comision.Consultar consulta_lista_comision

contador_total = 0
nota_promedio =  cdbl("0,0")

while f_lista_comision.siguiente
  nota_promedio = cdbl(nota_promedio) + cdbl(f_lista_comision.obtenerValor("nota"))
  contador_total= contador_total + 1
wend
f_lista_comision.primero

'response.End()
if contador_total <> 0 then
	promedio_tesis = formatnumber((cdbl(nota_promedio) / cdbl(contador_total)),1,-1,0,0)
else
	promedio_tesis = 1.0
end if		

promedio_tesis = conexion.consultaUno("select replace('"&promedio_tesis&"',',','.')")

'response.Write("promedio tesis "&promedio_tesis)
'----------------------datos adicionales tesis
if tiene_grabado = "S" then
	 consulta_tesis = " select pers_ncorr,plan_ccod,tema_tesis,"&_
				" protic.trunc(inicio_tesis) as inicio_tesis,protic.trunc(fecha_ceremonia) as fecha_ceremonia,protic.trunc(termino_tesis) as termino_tesis, "&_
			    " replace(calificacion_tesis,',','.') as calificacion_tesis,protic.trunc(fecha_titulacion) as fecha_titulacion "&_
				" from detalles_titulacion a "&_
				" where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
else
     consulta_tesis = " select '"&q_plan_ccod&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if
'response.Write(consulta)
set f_tesis = new CFormulario
f_tesis.Carga_Parametros "detalle_egreso_titulacion.xml", "datos_tesis"
f_tesis.Inicializar conexion

consulta_fecha =  " select protic.trunc(b.salu_fsalida) from salidas_plan a, salidas_alumnos b " &_
			" where cast(a.plan_Ccod as varchar)='"&q_plan_ccod&"'  and cast(a.peri_ccod as varchar)='"&q_peri_ccod&"' and a.sapl_ncorr=b.sapl_ncorr "&_
		    " and cast(b.pers_ncorr as varchar)='"&q_pers_ncorr&"'"

fecha_examen = conexion.consultaUno(consulta_fecha)

f_tesis.Consultar consulta_tesis

f_tesis.agregaCampoCons "fecha_titulacion",fecha_examen
f_tesis.Siguiente
'response.Write(promedio_tesis)
'---------------------------------------------------------------------------------------------------
'----------------------------------------------Datos a mostrar en la concentración-----------------
if tiene_grabado = "S" then
	 consulta_concentracion = " select pers_ncorr,plan_ccod,replace(calificacion_notas,',','.') as calificacion_notas, "&_
					  " porcentaje_notas,porcentaje_practica,porcentaje_tesis,isnull(mostrar_concentracion,'N') as mostrar_concentracion,"&_
					  " replace(promedio_final,',','.') as promedio_final,replace(nota_tesis,',','.') as nota_tesis,porcentaje_nota_tesis "&_
					  " from detalles_titulacion"&_
				      " where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
else
     consulta_concentracion = " select '"&q_plan_ccod&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if
'response.Write(consulta_concentracion)
set f_concentracion = new CFormulario
f_concentracion.Carga_Parametros "detalle_egreso_titulacion.xml", "concentracion"
f_concentracion.Inicializar conexion

f_concentracion.Consultar consulta_concentracion
f_concentracion.Siguiente
'response.Write(promedio_tesis)
'---------------------------------------------------------------------------------------------------

f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

'---------------------------------------------------------------------------------------------------
url_leng1 = "adm_titulados_agregar.asp?dp[0][plan_ccod]=" & q_plan_ccod & "&dp[0][peri_ccod]=" & q_peri_ccod & "&dp[0][pers_nrut]=" & q_pers_nrut & "&dp[0][pers_xdv]=" & q_pers_xdv
lengueta_detalle = "adm_titulados_agregar_2.asp?plan_ccod=" & q_plan_ccod & "&peri_ccod=" & q_peri_ccod & "&pers_nrut=" & q_pers_nrut & "&pers_xdv=" & q_pers_xdv
url_cert = "cert_emitidos.asp?plan_ccod=" & q_plan_ccod & "&peri_ccod=" & q_peri_ccod & "&pers_nrut=" & q_pers_nrut & "&pers_xdv=" & q_pers_xdv

'promedio= conexion.consultaUno("select replace(cast(2.28 as decimal(2,1)),',','.')")
'response.Write(promedio)

se_titulo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from salidas_alumnos a, salidas_plan b where a.sapl_ncorr = b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"'")
'response.End()
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
function certificado_titulo(){
   var formulario=document.edicion
   var peri=<%=q_peri_ccod%>;
   var plan=<%=q_plan_ccod%>;
   var rut=<%=q_pers_nrut%>;
   var sede=<%=v_sede_ccod%>;
   self.open('certificado_titulo.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function calcular()
{
	var notas = document.concentracion.elements["concentracion[0][calificacion_notas]"].value;
	var practica = document.concentracion.elements["concentracion[0][calificacion_practica]"].value;
	var tesis = document.concentracion.elements["concentracion[0][calificacion_tesis]"].value;
	var nota_tesis = document.concentracion.elements["concentracion[0][nota_tesis]"].value;
	var porc_notas = document.concentracion.elements["concentracion[0][porcentaje_notas]"].value;
	var porc_practica = document.concentracion.elements["concentracion[0][porcentaje_practica]"].value;
	var porc_tesis = document.concentracion.elements["concentracion[0][porcentaje_tesis]"].value;
	var porc_nota_tesis = document.concentracion.elements["concentracion[0][porcentaje_nota_tesis]"].value;
	var valor1=0.0;
	var valor2=0.0;
	var valor3=0.0;
	var valor4=0.0;
	var suma = (porc_notas * 1) + (porc_practica * 1) + (porc_tesis * 1) + (porc_nota_tesis * 1);
	//alert(suma);
	var promedio_final=0.0;
	if (suma == 100 )
	 { valor1 = notas * ( porc_notas / 100 );
	   valor2 = practica * ( porc_practica / 100 );
	   valor3 = tesis * ( porc_tesis / 100 );
	   valor4 = nota_tesis * ( porc_nota_tesis / 100 );
	   promedio_final = valor1 + valor2 + valor3 + valor4;
	   promedio_final2 = promedio_final;
	   promedio_final2 = roundFun(promedio_final,10);//se rempleaza 10 por 2
	   promedio_final2 = roundFun(promedio_final2,1);
	   //alert("promedio " + promedio_final);
	   document.concentracion.elements["promedio_final"].value=promedio_final2;
	   document.concentracion.elements["promedio_final"].value=document.concentracion.elements["promedio_final"].value.substring(0,3);
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=promedio_final2;
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=document.concentracion.elements["concentracion[0][promedio_final]"].value.substring(0,3);
	   if (confirm("¿Está Seguro que desea grabar los datos para la concentracón de notas?"))
	   {
	   		return true;
	   }
	   else
	   {
	  	 	return false;
	   }
	 }
	 else
	 {
	 	alert("El porcentaje ingresado no corresponde al 100% necesario para cálculos de promedio final");
	 }  
	//alert("promedio " + promedio_final);
	return false;
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array(Array("Datos Personales", url_leng1),Array("Datos de Titulación", lengueta_detalle),"Datos adicionales Egreso y Titulación",Array("Cert. Emitidos", url_cert)), 3 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Estudio"%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Práctica Profesional y Egreso de estudios."%>
                      <br>
					  <form name="practica">
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td align="center">
						  		<table border="0" width="98%">
								<tr valign="bottom">
								    <td width="14%" align="left">&nbsp;</td>
									<td width="1%" align="left">&nbsp;</td>
									<td width="35%" align="left">&nbsp;</td>
									<td width="14%" align="left"><font color="#990000"><strong>N°Expediente</strong></font></td>
									<td width="1%" align="left"><font color="#990000"><strong>:</strong></font></td>
									<td width="35%" align="left"><font size="3"><strong><%=folio%></strong></font></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Empresa</strong><input type="hidden" name="egreso[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("nombre_empresa")%><input type="hidden" name="egreso[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
									<td width="14%" align="left"><strong>Ubicación</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("ubicacion_empresa")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Teléfono</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("telefono_empresa")%></td>
									<td width="14%" align="left"><strong>E-mail</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("email_empresa")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Encargado</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("nombre_encargado")%></td>
									<td width="14%" align="left"><strong>Cargo</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("cargo_encargado")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Inicio</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("inicio_practica")%></td>
									<td width="14%" align="left"><strong>Término</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("termino_practica")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Des. Trabajo</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="14%" align="left"><%f_practica.dibujaCampo("descripcion_practica")%></td>
									<td width="14%" align="left"><strong>N° Horas</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("horas_practica")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Calificación</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("calificacion_practica")%></td>
									<td width="14%" align="left"><strong>Concepto</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("sitf_ccod")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Observaciones</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("observaciones")%></td>
									<td width="14%" align="left"><strong>Fecha de Proceso</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_practica.dibujaCampo("fecha_proceso")%>
									                             <%f_practica.dibujaCampo("salu_nregistro")%>
																 <%f_practica.dibujaCampo("salu_nfolio")%>
								    </td>
								</tr>
								<%if solo_practica <> "S" and se_titulo <> "N" then%>
								<tr>
								    <td colspan="6" align="center" bgcolor="#666666"><strong><font color="#FF0000">*</font><font color="#FFFFFF"> Fecha de Egreso <%f_practica.dibujaCampo("fecha_egreso")%></font></strong></td>
    							</tr>
								<%else%>
								<tr>
								    <td colspan="6" align="center" bgcolor="#666666"><strong><font color="#FFFFFF"> Fecha de Egreso <% f_practica.agregaCampoParam "fecha_egreso","id","FE-S"
									                                                                                                   f_practica.dibujaCampo("fecha_egreso")%></font></strong></td>
    							</tr>
								<%end if%>
								<tr>
								    <td colspan="6" align="right"><%f_botonera.DibujaBoton "guardar_practica"%></td>
    							</tr>
								</table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <%if solo_practica <> "S" and se_titulo <> "N" then%>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Comisión Tesis de estudios."%>
                      <br>
					  <form name="comision">
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td align="center">
						  		<table border="0" width="98%">
								<tr>
								    		<td width="14%" align="left"><strong>Profesor</strong><input type="hidden" name="comision[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
											<td width="1%" align="left"><strong>:</strong></td>
											<td width="35%" align="left"><%f_comision.dibujaCampo("docente")%></td>
											<td width="14%" align="left"><strong>Calificación</strong><input type="hidden" name="comision[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
											<td width="1%" align="left"><strong>:</strong></td>
											<td width="25%" align="left"><%f_comision.dibujaCampo("calificacion_asignada")%><input type="hidden" name="comision[0][ctes_ncorr]" value="<%=q_ctes_ncorr%>"></td>
											<td width="10%" align="center"><%f_botonera.DibujaBoton "agregar_docente"%><input type="hidden" name="comision[0][peri_ccod]" value="<%=q_peri_ccod%>"></td>
     							</tr>
							    </table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Tesis."%>
                      <br>
					  <form name="tesis">
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td align="center">
						  		<table border="0" width="98%">
								<tr>
								    <td width="14%" align="left"><strong>Tema Tesis</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td colspan="5" align="left"><%f_tesis.dibujaCampo("tema_tesis")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Inicio</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_tesis.dibujaCampo("inicio_tesis")%><input type="hidden" name="tesis[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
									<td width="14%" align="left"><strong>Término</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td colspan="2" align="left"><%f_tesis.dibujaCampo("termino_tesis")%><input type="hidden" name="tesis[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Fecha Ceremonia</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left" colspan="4"><%f_tesis.dibujaCampo("fecha_ceremonia")%></td>
								</tr>
								<tr>
								    <td colspan="7" align="left"><strong>Docentes Comisión Evaluadora</strong></td>
    							</tr>
								<tr>
								    <td colspan="7" align="center"><%f_lista_comision.dibujaTabla()%></td>
    							</tr>
								<tr>
								    <td colspan="2">&nbsp;</td>
									<td colspan="3" align="center"><strong>Promedio Tesis : <%=promedio_tesis%> </strong><input type="hidden" name="tesis[0][calificacion_tesis]" value="<%=promedio_tesis%>" maxlength="3"></td>
    							    <td  colspan="2">&nbsp;</td>
								</tr>
								<tr>
								    <td colspan="7" align="center" bgcolor="#666666"><strong><font color="#FF0000">*</font><font color="#FFFFFF"> Fecha Examen de Títulos <%f_tesis.dibujaCampo("fecha_titulacion")%></font></strong></td>
    							</tr>
								<tr>
								    <td colspan="7" align="right"><%f_botonera.DibujaBoton "guardar_tesis"%></td>
    							</tr>
								</table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos para Certificado de Concentración de Notas."%>
                      <br>
					  <form name="concentracion">
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td align="center">
						  		<table border="1" width="60%">
								<tr>
								    <td width="20%" align="center"><strong>Concepto</strong><input type="hidden" name="concentracion[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
									<td width="20%" align="center"><strong>Nota</strong><input type="hidden" name="concentracion[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
									<td width="20%" align="center"><strong>Porcentaje</strong></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Promedio Notas</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("calificacion_notas")%></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_notas")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Práctica Profesional</strong></td>
									<td width="20%" align="center"><%=f_practica.obtenerValor("calificacion_practica")%><input type="hidden" name="concentracion[0][calificacion_practica]" maxlength="3" size="10" id="NO-N" value="<%=f_practica.obtenerValor("calificacion_practica")%>"></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_practica")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Examen de Título</strong></td>
									<td width="20%" align="center"><%=promedio_tesis%><input type="hidden" name="concentracion[0][calificacion_tesis]" maxlength="3" size="10" id="NO-N" value="<%=promedio_tesis%>"></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_tesis")%><%f_concentracion.dibujaCampo("promedio_final")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Nota de Tesis</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("nota_tesis")%></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_nota_tesis")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right" colspan="2"><strong>Promedio Final</strong></td>
									<td width="20%" align="center"><input type="text" name="promedio_final" maxlength="3" size="10" value="<%=f_concentracion.obtenerValor("promedio_final")%>" disabled></td>
								</tr>
								<tr>
								    <td width="20%" align="right" colspan="2"><strong>Mostrar en Concentración</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("mostrar_concentracion")%></td>
								</tr>
								<tr>
								    <td colspan="7" align="right"><%f_botonera.DibujaBoton "guardar_concentracion"%></td>
    							</tr>
								</table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <%end if%>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%'f_botonera.DibujaBoton "guardar_nuevo"%></div></td>
                  <td><div align="center"><%'f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
				  <td><div align="center"><%'f_botonera.DibujaBoton "certificado_titulo"%></div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
