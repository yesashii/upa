<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: PACTACIÓN OTEC
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:03/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:96
'*******************************************************************
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
q_tipo_persona = Request.QueryString("busqueda[0][tipo_persona]")

set pagina = new CPagina
pagina.Titulo = "Contratacion Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'response.end()
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "datos_otec.xml", "botonera"
'response.Write(negocio.ObtenerSede)
set errores = new CErrores

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "datos_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tipo_persona", q_tipo_persona


'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "datos_otec.xml", "cargo"
f_cargo.Inicializar conexion

if q_pers_nrut<>"" then

nombre = conexion.consultauno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno  from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")


	select case q_tipo_persona
		case "1"
	'Persona
'			sql_datos_postulante= 	" Select (select case when count(*)=0 then cast(1 as numeric) else count(*) end  from postulacion_otec where dgso_ncorr=b.dgso_ncorr and empr_ncorr_empresa=a.empr_ncorr_empresa and nord_compra=isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0)) as alumnos, "&vbcrlf&_
'									" 1 as tipo,a.pote_ncorr,a.dgso_ncorr,a.pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,c.ofot_nmatricula,c.ofot_narancel, "&vbcrlf&_
'									" isnull(c.ofot_nmatricula,0) as monto_matricula,isnull(c.ofot_narancel,0) as monto_arancel,a.fpot_ccod,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc, "&vbcrlf&_
'									" isnull(c.ofot_nmatricula,0)+isnull(c.ofot_narancel,0) as monto_total, isnull(d.tdet_ccod,1281) as tdet_ccod,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc_2,"&vbcrlf&_
'									" ocot_monto_empresa as financia_empresa,ocot_monto_otic as financia_otic, "&vbcrlf&_
'									" '<b>Factura no disponible</b>' as ventana "&vbcrlf&_
'									" from postulacion_otec a, datos_generales_secciones_otec b,   "&vbcrlf&_
'									" ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f "&vbcrlf&_
'									" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
'									" and a.pers_ncorr=e.pers_ncorr "&vbcrlf&_
'									" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
'									" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
'									" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
'									" and a.epot_ccod=2 "&vbcrlf&_
'								    " and a.dgso_ncorr*=f.dgso_ncorr "&vbcrlf&_
'									" and a.fpot_ccod*=f.fpot_ccod "&vbcrlf&_
'									" and case a.fpot_ccod when 4 then norc_otic else norc_empresa end *=nord_compra "

			sql_datos_postulante= 	" Select (select case when count(*)=0 then cast(1 as numeric) else count(*) end  from postulacion_otec where dgso_ncorr=b.dgso_ncorr and empr_ncorr_empresa=a.empr_ncorr_empresa and nord_compra=isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0)) as alumnos, "&vbcrlf&_
									" 1 as tipo,a.pote_ncorr,a.dgso_ncorr,a.pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,c.ofot_nmatricula,c.ofot_narancel, "&vbcrlf&_
									" isnull(c.ofot_nmatricula,0) as monto_matricula,isnull(c.ofot_narancel,0) as monto_arancel,a.fpot_ccod,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc, "&vbcrlf&_
									" isnull(c.ofot_nmatricula,0)+isnull(c.ofot_narancel,0) as monto_total, isnull(d.tdet_ccod,1281) as tdet_ccod,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc_2,"&vbcrlf&_
									" ocot_monto_empresa as financia_empresa,ocot_monto_otic as financia_otic, "&vbcrlf&_
									" '<b>Factura no disponible</b>' as ventana "&vbcrlf&_
									" from postulacion_otec a "&vbcrlf&_
									" INNER JOIN personas e "&vbcrlf&_
									" ON a.pers_ncorr = e.pers_ncorr and a.epot_ccod = 2 AND cast(e.pers_nrut as varchar) = '"&q_pers_nrut&"' "&vbcrlf&_
									" INNER JOIN datos_generales_secciones_otec b "&vbcrlf&_
									" ON a.dgso_ncorr = b.dgso_ncorr "&vbcrlf&_
									" INNER JOIN ofertas_otec c "&vbcrlf&_
									" ON b.dgso_ncorr = c.dgso_ncorr "&vbcrlf&_
									" INNER JOIN diplomados_cursos d "&vbcrlf&_
									" ON c.dcur_ncorr = d.dcur_ncorr "&vbcrlf&_
									" LEFT OUTER JOIN ordenes_compras_otec f "&vbcrlf&_
									" ON a.dgso_ncorr = f.dgso_ncorr "&vbcrlf&_
									" and a.fpot_ccod = f.fpot_ccod "&vbcrlf&_
									" and case a.fpot_ccod when 4 then norc_otic else norc_empresa end = f.nord_compra "
										 
		case "2"
	'Empresa
			sql_datos_postulante= 	" Select 2 as tipo,a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_empresa as pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,sum(c.ofot_nmatricula) as ofot_nmatricula, "&vbcrlf&_
								" sum(c.ofot_narancel) as ofot_narancel,a.fpot_ccod,sum(isnull(c.ofot_nmatricula,0)) as monto_matricula,sum(isnull(c.ofot_narancel,0)) as monto_arancel, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
								" sum(isnull(c.ofot_nmatricula,0))+sum(isnull(c.ofot_narancel,0)) as monto_total,ocot_monto_empresa as financia_empresa,ocot_monto_otic as financia_otic,nord_compra as num_oc,nord_compra as num_oc_2, "&vbcrlf&_
								" '<a href=""javascript:ventana_modificar(1,2,' + cast(a.dgso_ncorr as varchar)+ ','+cast("&q_pers_nrut&" as varchar)+')"">Prefacturar</a>' as ventana "&vbcrlf&_
								" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
								" ofertas_otec c , diplomados_cursos d, personas e, ordenes_compras_otec f "&vbcrlf&_
								" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
								" and a.empr_ncorr_empresa=e.pers_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
								" and case when a.fpot_ccod=4 then norc_otic else a.norc_empresa end=f.nord_compra "&vbcrlf&_
								" and a.epot_ccod in (2,3) "&vbcrlf&_
								" and a.empr_ncorr_empresa=case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end "&vbcrlf&_
								" and not exists (select 1 from postulantes_cargos_otec pc where pc.pote_ncorr=a.pote_ncorr and tipo_institucion=2) "&vbcrlf&_ 
								" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_empresa,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "&vbcrlf&_ 
								" UNION "&vbcrlf&_ 
								" Select 2 as tipo,a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_empresa as pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,sum(c.ofot_nmatricula) as ofot_nmatricula, "&vbcrlf&_
								" sum(c.ofot_narancel) as ofot_narancel,a.fpot_ccod,sum(isnull(c.ofot_nmatricula,0)) as monto_matricula,sum(isnull(c.ofot_narancel,0)) as monto_arancel, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
								" sum(isnull(c.ofot_nmatricula,0))+sum(isnull(c.ofot_narancel,0)) as monto_total,ocot_monto_empresa as financia_empresa,ocot_monto_otic as financia_otic,nord_compra as num_oc,nord_compra as num_oc_2, "&vbcrlf&_
								" '<a href=""javascript:ventana_modificar(1,2,' + cast(a.dgso_ncorr as varchar)+ ','+cast("&q_pers_nrut&" as varchar)+')"">Prefacturar</a>' as ventana "&vbcrlf&_
								" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
								" ofertas_otec c , diplomados_cursos d, personas e, ordenes_compras_otec f "&vbcrlf&_
								" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
								" and a.empr_ncorr_empresa=e.pers_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
								" and case when a.fpot_ccod=5 then a.norc_empresa end=f.nord_compra "&vbcrlf&_
								" and a.epot_ccod in (2,3) "&vbcrlf&_
								" and a.empr_ncorr_empresa=case when a.fpot_ccod=5 then f.empr_ncorr end "&vbcrlf&_
								" and not exists (select 1 from postulantes_cargos_otec pc where pc.pote_ncorr=a.pote_ncorr and tipo_institucion=2) "&vbcrlf&_ 
								" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_empresa,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "
		case "3"
	'Otic

			sql_datos_postulante= 	" Select 3 as tipo,a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_otic as pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,sum(c.ofot_nmatricula) as ofot_nmatricula, "&vbcrlf&_
								" sum(c.ofot_narancel) as ofot_narancel,a.fpot_ccod,sum(isnull(c.ofot_nmatricula,0)) as monto_matricula,sum(isnull(c.ofot_narancel,0)) as monto_arancel, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
								" sum(isnull(c.ofot_nmatricula,0))+sum(isnull(c.ofot_narancel,0)) as monto_total,ocot_monto_empresa as financia_empresa,ocot_monto_otic as financia_otic,nord_compra as num_oc,nord_compra as num_oc_2, "&vbcrlf&_
								" '<a href=""javascript:ventana_modificar(1,3,' + cast(a.dgso_ncorr as varchar)+ ','+cast("&q_pers_nrut&" as varchar)+')"">Prefacturar</a>' as ventana "&vbcrlf&_
								" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
								" ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f "&vbcrlf&_
								" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
								" and a.empr_ncorr_otic=e.pers_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
								" and a.norc_otic=f.nord_compra "&vbcrlf&_
								" and a.epot_ccod in (2,3) "&vbcrlf&_
								" and a.empr_ncorr_empresa=case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end "&vbcrlf&_
								" and not exists (select 1 from postulantes_cargos_otec pc where pc.pote_ncorr=a.pote_ncorr and tipo_institucion=3) "&vbcrlf&_ 
								" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_otic,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "
		end select
else
	sql_datos_postulante="select '' where 1=2"
end if

'response.write("<pre>"&sql_datos_postulante&"</pre>")

f_cargo.Consultar sql_datos_postulante

'response.Flush()
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

function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  v_indice=extrae_indice(str);
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
			document.edicion.indice.value=v_indice;
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


function ventana_modificar(origen,tipo,dgso_ncorr,pers_nrut){

	pagina = "../facturacion/prefacturar.asp?origen="+origen+"&tipo="+tipo+"&dgso_ncorr="+dgso_ncorr+"&pers_nrut="+pers_nrut;
	window.open(pagina,"prefactura","width=805px, height=700px, scrollbars=yes, resizable=yes");
	//resultado = open(pagina,"wAgregar","width=805px, height=600px, scrollbars=yes, resizable=yes");
	//resultado.focus();

}	

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  
	<table width="70%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
		<table border="0" cellpadding="0" cellspacing="0" width="70%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="400" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td>
			  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="230" valign="bottom" background="../imagenes/fondo1.gif" align="left">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Alumnos</font></div></td>
                    <td width="6" bgcolor="#D8D8DE" align="left"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="149" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">&nbsp;</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="320" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
<form name="buscador">
              <br>
              <table width="400"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="152"><div align="left"><strong>R.U.T. Alumno</strong></div></td>
                        <td width="14"><div align="left">:</div></td>
                        <td width="146"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")
						pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						</tr>
						<tr>
						<td width="152"><div align="left"><strong>Persona o institucion que Financia</strong></div></td>
						<td width="14">:</td>
						<td width="146"><%f_busqueda.DibujaCampo("tipo_persona")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="400" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
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
            <td></td>
          </tr>
          <tr>
            <td height="2" background=""></td>
          </tr>
          <tr>
            <td><div align="center">
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td>
						<table width="96%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="27%"><strong>Rut</strong></td>
								<td width="2%"><strong>:</strong></td>
								<td width="71%"><%=q_pers_nrut&"-"&q_pers_xdv%></td>
							</tr>
							<tr>
								<td><strong>Nombre o institucion</strong></td>
								<td><strong>:</strong></td>
								<td><%=nombre%></td>
							</tr>
			
						  </table>
				</td>
                </tr>
              </table>
              </div>
              <form name="edicion">
				<input type="hidden" name="pers_nrut" value="<%=q_pers_nrut%>" >
				<input type="hidden" name="pers_xdv" value="<%=q_pers_xdv%>" >
				<input type="hidden" name="tipo_persona" value="<%=q_tipo_persona%>" >
				<input type="hidden" name="indice" value="<%=v_indice%>" >
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulaciones a Cursos/Diplomados "%>

                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><%f_cargo.DibujaTabla%></td>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "siguiente"%></div></td>
                  <td><div align="center">
                    <%'f_botonera.DibujaBoton "salir"%>
                  </div></td>
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
