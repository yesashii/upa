<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: CONTROL INTERNO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 14/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 125, 126.
'NOTA EXTRA					: SE MODIFICA LINEA 230, LA EXPLICACIÓN ESTÁ EN DOCUMENDO DE OBSERVACIONES.(A LA ESPERA DE APROBACIÓN).
'********************************************************************

q_comp_ndocto = Request.QueryString("comp_ndocto")
q_inst_ccod = Request.QueryString("inst_ccod")
q_tcom_ccod = Request.QueryString("tcom_ccod")

'response.Write("comp_ndocto "&q_comp_ndocto&" inst_ccod "&q_inst_ccod&" tcom_ccod "&q_tcom_ccod)

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pactación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm
pers_ncorr_codeudor1 = variables.ObtenerValor("cargo", 0, "pers_ncorr_codeudor")
'response.Write("pers "&pers_ncorr_codeudor1)

v_inst_ccod = "1"

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_cargo_pactacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "agregar_cargo_pactacion.xml", "cargo_mostrar"
f_cargo.Inicializar conexion


if EsVacio(q_comp_ndocto) then
	pers_ncorr_codeudor = variables.ObtenerValor("cargo", 0, "pers_ncorr_codeudor")
	v_comp_mdocumento = variables.ObtenerValor("cargo", 0, "comp_mdocumento")
	v_tcom_ccod = conexion.ConsultaUno("select tcom_ccod from tipos_detalle where tdet_ccod = '" & variables.ObtenerValor("cargo", 0, "tdet_ccod")  &"'")
	
	f_cargo.Consultar "select ''"	
	
	f_cargo.AgregaCampoCons "c_tdet_ccod", variables.ObtenerValor("cargo", 0, "tdet_ccod")
	f_cargo.AgregaCampoCons "c_comp_mneto", variables.ObtenerValor("cargo", 0, "comp_mneto")
	f_cargo.AgregaCampoCons "c_comp_mdescuento", variables.ObtenerValor("cargo", 0, "comp_mdescuento")
	f_cargo.AgregaCampoCons "c_comp_mdocumento", variables.ObtenerValor("cargo", 0, "comp_mdocumento")
	f_cargo.AgregaCampoCons "tdet_ccod", variables.ObtenerValor("cargo", 0, "tdet_ccod")
	f_cargo.AgregaCampoCons "spac_mneto", variables.ObtenerValor("cargo", 0, "comp_mneto")
	f_cargo.AgregaCampoCons "spac_mdescuento", variables.ObtenerValor("cargo", 0, "comp_mdescuento")
	f_cargo.AgregaCampoCons "spac_mpactacion", variables.ObtenerValor("cargo", 0, "comp_mdocumento")
	f_cargo.AgregaCampoCons "pers_ncorr", variables.ObtenerValor("cargo", 0, "pers_ncorr")
	f_cargo.AgregaCampoCons "inst_ccod", v_inst_ccod
	'response.Write("inst_ccod "& v_inst_ccod&" tcom_ccod "&v_tcom_ccod)
	f_cargo.AgregaCampoCons "tcom_ccod", v_tcom_ccod
else
	pers_ncorr_codeudor = Request.QueryString("pers_ncorr_codeudor")
	consulta = "select tcom_ccod, inst_ccod, comp_ndocto, pers_ncorr, tdet_ccod as c_tdet_ccod, spac_mneto as c_comp_mneto, spac_mdescuento as c_comp_mdescuento, spac_mpactacion as c_comp_mdocumento, tdet_ccod, spac_mneto, spac_mdescuento, spac_mpactacion " & vbCrLf &_
	           "from sim_pactaciones where cast(comp_ndocto as varchar) = '" & q_comp_ndocto & "' and cast(inst_ccod as varchar)= '" & q_inst_ccod & "' and cast(tcom_ccod as varchar)= '" & q_tcom_ccod & "'"	
	'response.Write("<pre>" & consulta & "</pre>")		
	f_cargo.Consultar consulta
	
	v_comp_mdocumento = conexion.ConsultaUno("select spac_mpactacion from sim_pactaciones where cast(comp_ndocto as varchar)= '" & q_comp_ndocto & "'")   	
end if

'----------------------------------------------------------------------------------------------------
set f_forma_pactacion = new CFormulario
f_forma_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "forma_pactacion"
f_forma_pactacion.Inicializar conexion

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


'consulta = "select a.tcom_ccod, a.ting_ccod, a.ting_ccod as c_ting_ccod, b.comp_ndocto, b.sfpa_mmonto, b.sfpa_ncuotas, b.sfpa_ndocto_inicial, b.sfpa_nfrecuencia, b.sfpa_finicio_pago, b.banc_ccod, b.plaz_ccod, b.sfpa_tctacte, " & vbCrLf &_
'           "       decode(b.ting_ccod, null, 'N', 'S') as butiliza, nvl(b.pers_ncorr_codeudor, '" & variables.ObtenerValor("cargo", 0, "pers_ncorr_codeudor") & "') as pers_ncorr_codeudor, " & vbCrLf &_
'		   "	   trim(to_char(nvl(b.sfpa_mtasa_interes, nvl(c.tint_mtasa, 0)), '990.00')) as sfpa_mtasa_interes   " & vbCrLf &_
'		   "from (select distinct tcom_ccod, ting_ccod   " & vbCrLf &_
'		   "      from stipos_pagos a   " & vbCrLf &_
'		   "	  where tcom_ccod = '1') a, sim_forma_pactaciones b, tasas_interes c   " & vbCrLf &_
'		   "where a.ting_ccod = b.ting_ccod (+)  " & vbCrLf &_
'		   "  and a.ting_ccod = c.ting_ccod (+)  " & vbCrLf &_
'		   "  and c.ttin_ccod (+) = 1 " & vbCrLf &_
'		   "  and c.peri_ccod (+) = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "'  " & vbCrLf &_
'		   "  and b.comp_ndocto (+) = '" & q_comp_ndocto & "'  " & vbCrLf &_
'		   "order by a.ting_ccod desc"
		
'consulta = "select a.tcom_ccod, a.ting_ccod, a.ting_ccod as c_ting_ccod, b.comp_ndocto," & vbCrLf &_
'			"        b.sfpa_mmonto, b.sfpa_ncuotas, b.sfpa_ndocto_inicial, b.sfpa_nfrecuencia," & vbCrLf &_
'			"        b.sfpa_finicio_pago, b.banc_ccod, b.plaz_ccod, b.sfpa_tctacte," & vbCrLf &_
'			"        isnull(b.pers_ncorr_codeudor, '" & pers_ncorr_codeudor & "') as pers_ncorr_codeudor," & vbCrLf &_
'			"        ltrim(rtrim(" & vbCrLf &_
'			"                    isnull(b.sfpa_mtasa_interes, isnull(c.tint_mtasa, 0))" & vbCrLf &_
'			"            )) as sfpa_mtasa_interes," & vbCrLf &_
'			"       case isnull(b.ting_ccod,0) " & vbCrLf &_
'			"                when 0 then 'N'" & vbCrLf &_
'			"                else 'S'" & vbCrLf &_
'			"                end as butiliza" & vbCrLf &_
'			"    from (select distinct tcom_ccod, ting_ccod   " & vbCrLf &_
'			"      from stipos_pagos a   " & vbCrLf &_
'			"	  where tcom_ccod = '1') a,sim_forma_pactaciones b,tasas_interes c" & vbCrLf &_
'			"        where a.ting_ccod *= b.ting_ccod" & vbCrLf &_
'			"            and a.ting_ccod *= c.ting_ccod" & vbCrLf &_
'			"            and c.ttin_ccod = 1" & vbCrLf &_
'			"            and c.peri_ccod = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "'" & vbCrLf &_
'			"            and cast(b.comp_ndocto as varchar) = '" & q_comp_ndocto & "'"
consulta = 	"select a.tcom_ccod, "& vbCrLf &_
			"	a.ting_ccod, "& vbCrLf &_
			"	a.ting_ccod as c_ting_ccod, "& vbCrLf &_ 
			"	b.comp_ndocto, "& vbCrLf &_
			"	b.sfpa_mmonto, "& vbCrLf &_
			"	b.sfpa_ncuotas, "& vbCrLf &_
			"	b.sfpa_ndocto_inicial, "& vbCrLf &_
			"	b.sfpa_nfrecuencia, "& vbCrLf &_
			"	b.sfpa_finicio_pago, "& vbCrLf &_
			"	b.banc_ccod, "& vbCrLf &_
			"	b.plaz_ccod, "& vbCrLf &_
			"	b.sfpa_tctacte, "& vbCrLf &_
			"	isnull(b.pers_ncorr_codeudor, '" & pers_ncorr_codeudor & "') as pers_ncorr_codeudor, "& vbCrLf &_
			"	ltrim(rtrim(isnull(b.sfpa_mtasa_interes, isnull(c.tint_mtasa, 0)))) as sfpa_mtasa_interes, "& vbCrLf &_
			"   case isnull(b.ting_ccod,0) "& vbCrLf &_
			"    when 0 then 'N' "& vbCrLf &_
			"   else 'S' "& vbCrLf &_
			"   end as butiliza "& vbCrLf &_
			"	from (	"& vbCrLf &_
			"			select distinct tcom_ccod, ting_ccod "& vbCrLf &_  
			"			from stipos_pagos a "& vbCrLf &_  
			"			where tcom_ccod = '1' "& vbCrLf &_
			"		) a "& vbCrLf &_	  
			"left outer join sim_forma_pactaciones b "& vbCrLf &_	  
			"	on a.ting_ccod = b.ting_ccod "& vbCrLf &_
			"	and cast(b.comp_ndocto as varchar) = '" & q_comp_ndocto & "'"& vbCrLf &_
			"left outer join tasas_interes c "& vbCrLf &_
			"	on a.ting_ccod = c.ting_ccod "& vbCrLf &_
			"	and c.ttin_ccod = 1 "& vbCrLf &_
			"	and c.peri_ccod = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "'"			
'response.Write("<pre>" & consulta & "</pre>")
'response.End()		   
	   
f_forma_pactacion.Consultar consulta 
f_consulta.Consultar consulta

i_ = 0
while f_consulta.Siguiente	
	if f_consulta.ObtenerValor("ting_ccod") <> "3" then
		f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_tctacte", "permiso", "LECTURA"
	end if
	
	if f_consulta.ObtenerValor("ting_ccod") = "6" then
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_nfrecuencia", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_finicio_pago", "soloLectura", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mtasa_interes", "permiso", "LECTURA"
	end if
	
	if f_consulta.ObtenerValor("butiliza") = f_forma_pactacion.ObtenerDescriptor("butiliza", "valorFalso") then
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ncuotas", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mmonto", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_finicio_pago", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_nfrecuencia", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mmonto", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mtasa_interes", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_tctacte", "deshabilitado", "TRUE"
	end if	
	
	f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ncuotas", "filtro", "tcom_ccod = '2' and ting_ccod = '" & f_consulta.ObtenerValor("ting_ccod") & "' and stpa_ncuotas > 0"
	i_ = i_ + 1
wend


'---------------------------------------------------------------------------------------------------------------------
set f_suma = new CFormulario
f_suma.Carga_Parametros "agregar_cargo_pactacion.xml", "suma"
f_suma.Inicializar conexion

'consulta = "select nvl(sum(sfpa_mmonto), 0) as total_actual, nvl('" & v_comp_mdocumento & "', 0) as total_pactar, nvl(sum(sfpa_mmonto), 0) - nvl('" & v_comp_mdocumento & "', 0) as diferencia, to_char(sysdate, 'dd/mm/yyyy') as fecha_actual " & vbCrLf &_
'		   "from sim_forma_pactaciones a " & vbCrLf &_
'		   "where comp_ndocto = '" & q_comp_ndocto & "'"
		   
consulta = "select isnull(sum(sfpa_mmonto), 0) as total_actual, isnull('" & v_comp_mdocumento & "', 0) as total_pactar," & vbCrLf &_
			"    isnull(sum(sfpa_mmonto), 0) - isnull('" & v_comp_mdocumento & "', 0) as diferencia," & vbCrLf &_
			"    convert(varchar,getdate(),103) as fecha_actual " & vbCrLf &_
			"from sim_forma_pactaciones a " & vbCrLf &_
			"where cast(comp_ndocto as varchar) = '" & q_comp_ndocto & "'"
'response.Write("<pre>" & consulta & "</pre>")			
f_suma.Consultar consulta


'---------------------------------------------------------------------------------------------------------------------
set f_detalles_pactacion = new CFormulario
f_detalles_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "detalles_pactacion"
f_detalles_pactacion.Inicializar conexion


'consulta = "select comp_ndocto, sdpc_ncuota, sdpc_ncuota as c_sdpc_ncuota, ting_ccod, ting_ccod as c_ting_ccod, sdpc_ndocumento, banc_ccod, plaz_ccod, sdpc_tctacte, sdpc_femision, sdpc_fvencimiento, to_number(sdpc_mmonto) as sdpc_mmonto " & vbCrLf &_
'           "from sim_detalles_pactacion " & vbCrLf &_
'		   "where comp_ndocto = '" & q_comp_ndocto & "'" & vbCrLf &_
'		   "order by sdpc_fvencimiento asc"
		   
consulta =  "select  comp_ndocto, sdpc_ncuota, sdpc_ncuota as c_sdpc_ncuota, ting_ccod," & vbCrLf &_
			"    ting_ccod as c_ting_ccod, sdpc_ndocumento, banc_ccod, plaz_ccod, sdpc_tctacte," & vbCrLf &_
			"    sdpc_femision, sdpc_fvencimiento, cast(sdpc_mmonto as numeric) as sdpc_mmonto_cuota" & vbCrLf &_
			"    from sim_detalles_pactacion" & vbCrLf &_
			"    where cast(comp_ndocto as varchar) = '" & q_comp_ndocto & "'" & vbCrLf &_
			"order by sdpc_fvencimiento asc"
'response.Write("<pre>"&consulta&"</pre>")			
f_detalles_pactacion.Consultar consulta
'response.write(f_detalles_pactacion.nroFilas)

f_consulta.Inicializar conexion
f_consulta.Consultar consulta

i_ = 0
while f_consulta.Siguiente
	if f_consulta.ObtenerValor("ting_ccod") <> "3" then
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_ndocumento", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_tctacte", "permiso", "LECTURA"
	end if
	
	i_ = i_ + 1
wend

'-------------------------------------------------------------------------------------
if f_detalles_pactacion.NroFilas = 0 then
	f_botonera.AgregaBotonParam "aceptar_pactacion", "deshabilitado", "TRUE"
end if
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
var t_forma_pactacion;
var t_alt_forma_pactacion;
var t_suma;
var t_alt_suma;



function ValidarPactacion()
{
	var suma_actual = t_forma_pactacion.SumarColumna("sfpa_mmonto");
	
	if (suma_actual != t_suma.ObtenerValor(0, "total_pactar")) {
		alert('El monto a pactar debe ser igual a ' + t_alt_suma.ObtenerValor(0, "total_pactar"));
		t_alt_suma.filas[0].campos["total_actual"].objeto.focus();
		return false;
	}
	
	
	for (var i = 0; i < t_forma_pactacion.filas.length; i++) {
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "sfpa_mmonto") <= 0) ) {
			alert('Si va a utilizar esta forma de pago, monto debe ser mayor que $0.')
			t_alt_forma_pactacion.filas[i].campos["sfpa_mmonto"].objeto.focus();
			return false;
		}
	}
	
	
	for (var i = 0; i < t_forma_pactacion.filas.length; i++) {
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "sfpa_mtasa_interes") < 0) ) {
			alert('Porcentaje de interés no puede ser negativo.');
			t_forma_pactacion.filas[i].campos["sfpa_mtasa_interes"].objeto.select();
			return false;
		}
	}
	
	
	return true;
}


function HabilitarFila(p_fila, p_habilitado)
{
	
	t_forma_pactacion.filas[p_fila].Habilitar(p_habilitado);
	t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.setAttribute("disabled", !p_habilitado);	
	
	if (p_habilitado) {
		t_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.value = t_suma.ObtenerValor(0, "diferencia") * -1;
		t_forma_pactacion.filas[p_fila].campos["sfpa_finicio_pago"].objeto.value = t_suma.ObtenerValor(0, "fecha_actual");
		t_forma_pactacion.AsignarValor(p_fila, "sfpa_nfrecuencia", '1');
	}
	else {		
		t_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.value = '0';
		t_forma_pactacion.filas[p_fila].campos["sfpa_finicio_pago"].objeto.value = '';		
		t_forma_pactacion.AsignarValor(p_fila, "sfpa_nfrecuencia", '');
	}
	enMascara(t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto, "MONEDA", 0);		
	sfpa_mmonto_blur(t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto);	
}



function sfpa_mmonto_blur(objeto)
{
	t_suma.AsignarValor(0, "total_actual", t_forma_pactacion.SumarColumna("sfpa_mmonto"));
	t_suma.AsignarValor(0, "diferencia", t_forma_pactacion.SumarColumna("sfpa_mmonto") - t_suma.ObtenerValor(0, "total_pactar"));
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.focus(); t_alt_suma.filas[0].campos["total_actual"].objeto.blur();
	t_alt_suma.filas[0].campos["diferencia"].objeto.focus(); t_alt_suma.filas[0].campos["diferencia"].objeto.blur();
}



function butiliza_click(objeto)
{
	HabilitarFila(_FilaCampo(objeto), objeto.checked);
}




function InicioPagina()
{
	t_forma_pactacion = new CTabla("forma_pactacion");
	t_alt_forma_pactacion = new CTabla("_forma_pactacion");	

	t_suma = new CTabla("suma");
	t_alt_suma = new CTabla("_suma");
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["total_pactar"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["diferencia"].objeto.className = 'suma';
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Ingresar codeudor", "Seleccionar curso", "Pactaci&oacute;n"), 3 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					
					<form name="pactacion">
					<%pagina.DibujarSubtitulo "Ítem"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_cargo.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>                      <br>
                      <%pagina.DibujarSubtitulo "Forma de pago"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                              <%f_forma_pactacion.DibujaTabla%>
                          </div></td>
                        </tr>
                        <tr>
                          <td><br>
                            <%f_suma.DibujaRegistro%></td></tr>
                        <tr>
                          <td><div align="right"><%f_botonera.DibujaBoton("calcular")%></div></td>
                        </tr>
                      </table>
	              </form>
                      <form name="detalle_pactacion">
                        <%pagina.DibujarSubtitulo "Detalle de pago"%>
                        <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td><div align="center">
                                <%f_detalles_pactacion.DibujaTabla%>
                            </div></td>
                          </tr>
                        </table>                
                        
                      </form>                      <br>
					  
					  
					  
					  </td>
                  </tr>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <%f_botonera.DibujaBoton("aceptar_pactacion")%>
                          </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
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
