<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_plan_ccod = Request.QueryString("plan_ccod")
q_peri_ccod = Request.QueryString("peri_ccod")
q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Datos de Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new cErrores


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_titulados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_titulados.xml", "datos_titulacion"
f_titulado.Inicializar conexion

v_sede_ccod = ""

'SQL = " select a.*, b.egre_ncorr, decode(b.egre_ncorr, null, 'S', b.egre_bingr_manual) as egre_bingr_manual, b.egre_ftitulacion, b.egre_fgrado, b.egre_nfolio_titulo, b.egre_nregistro_titulo, trim(to_char(b.egre_nnota_titulacion, '0.0')) as egre_nnota_titulacion "
'SQL = SQL &  " from (  select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, b.plan_ncorrelativo, obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre"
'SQL = SQL &  " 		from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"
'SQL = SQL &  " 		where b.espe_ccod = c.espe_ccod"
'SQL = SQL &  " 		  and c.carr_ccod = d.carr_ccod"
'SQL = SQL &  " 		  and f.sede_ccod = '" & v_sede_ccod & "'"
'SQL = SQL &  " 		  and e.peri_ccod = '" & q_peri_ccod & "'"
'SQL = SQL &  " 		  and a.pers_nrut = '" & q_pers_nrut & "'"
'SQL = SQL &  " 		  and b.plan_ccod = '" & q_plan_ccod & "'"
'SQL = SQL &  " 	 ) a, egresados b"
'SQL = SQL &  " where a.pers_ncorr = b.pers_ncorr (+)"
'SQL = SQL &  "   and a.sede_ccod = b.sede_ccod (+)"
'SQL = SQL &  "   and a.peri_ccod = b.peri_ccod (+)"
'SQL = SQL &  "   and a.plan_ccod = b.plan_ccod (+)"

total_sede_ccod = conexion.consultaUno("select count(*) from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr")

v_sede_ccod = conexion.consultaUno("select top 1 isnull(cast(sede_ccod as varchar),'') from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")

if total_sede_ccod= "0" then
	v_sede_ccod= negocio.ObtenerSede
end if

'response.Write("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")
SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, b.plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre"
SQL = SQL &  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"
SQL = SQL &  " where b.espe_ccod = c.espe_ccod"
SQL = SQL &  "   and c.carr_ccod = d.carr_ccod"
SQL = SQL &  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "'"
SQL = SQL &  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "'"
SQL = SQL &  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
SQL = SQL &  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

'SQL = " select top 1 d.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, c.peri_ccod, f.carr_tdesc, e.espe_tdesc, "& vbCrLf & _
'	  " h.peri_tdesc, d.sede_tdesc, g.plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, "& vbCrLf & _
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

'f_titulado.AgregaCampoCons "plan_ccod", q_plan_ccod
'f_titulado.AgregaCampoCons "peri_ccod", q_peri_ccod
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")
'---------------------------------------------------------------------------------------------------
set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_titulados.xml", "salidas_alumnos"
f_salidas.Inicializar conexion

SQL = " select a.*," & vbCrLf & _
      "        b.salu_ncorr, b.salu_fsalida, rtrim(ltrim(cast(b.salu_nnota as decimal(2,1)))) as salu_nnota, b.salu_nregistro, b.salu_nfolio, "& vbCrLf & _
      " 	   a.tspl_tdesc + ' : ' + a.sapl_tdesc as tipo, case b.salu_ncorr when null then 'N' else 'S' end as bguardar,"& vbCrLf & _
      "     case b.salu_ncorr when null then 'S' else b.salu_bingr_manual end as salu_bingr_manual "& vbCrLf & _
      " from ("& vbCrLf & _
      " 		select c.pers_ncorr, a.sapl_ncorr, a.sapl_tdesc, a.plan_ccod, a.peri_ccod, a.sede_ccod, a.tspl_ccod, b.tspl_tdesc		 "& vbCrLf & _
      " 		from salidas_plan a, tipos_salidas_plan b, personas c"& vbCrLf & _
      " 		where a.tspl_ccod = b.tspl_ccod"& vbCrLf & _
      " 		  and a.tspl_ccod in (2, 3, 4)"& vbCrLf & _
      " 		  and cast(a.peri_ccod as varchar)= '" & q_peri_ccod & "'"& vbCrLf & _
      " 		  and cast(a.sede_ccod as varchar)= '" & v_sede_ccod & "'"& vbCrLf & _
      " 		  and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "'"& vbCrLf & _
      " 		  and cast(c.pers_nrut as varchar)= '" & q_pers_nrut & "'"& vbCrLf & _
      " 	 ) a left outer join salidas_alumnos b"& vbCrLf & _
	  "         on a.sapl_ncorr = b.sapl_ncorr and a.pers_ncorr = b.pers_ncorr and '" & v_sede_ccod & "' = cast(b.sede_ccod as varchar)"& vbCrLf & _
      "  order by a.tspl_ccod asc "

'response.Write("<pre>"&sql&"</pre>")

f_salidas.Consultar SQL
'response.end()
'response.End()
q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if f_salidas.NroFilas > 0 then
	f_salidas.AgregaCampoCons "sede_ccod", v_sede_ccod
	contador = 1
	while f_salidas.siguiente 
		folio = f_salidas.obtenerValor("salu_nfolio")
		if folio= "" or esVacio(folio) then 
			carrera = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where cast(a.plan_ccod as varchar)='"&q_plan_ccod&"' and a.espe_ccod=b.espe_ccod")
			
		    'if carrera <> "51" and carrera <> "930" and carrera <> "810" and carrera <> "920" and carrera <> "12" and carrera <> "910" and carrera <> "900" and carrera <> "890" then 
			'	c_folio = " select isnull(valor,0) from ( "&_
			'			  " select max(cast(salu_nregistro as numeric)) as valor from salidas_alumnos a, salidas_plan b "&_
			'			  " where a.sapl_ncorr=b.sapl_ncorr and b.plan_ccod in (select plan_ccod from planes_estudio a, especialidades b "&_
			'			  "                                                    where a.espe_ccod=b.espe_ccod and carr_ccod='"&carrera&"'))a"
			'elseif carrera = "51" or carrera = "930" or carrera = "810" or carrera = "920" then 
			'	c_folio = " select isnull(valor,0) from ( "&_
			'			  " select max(cast(salu_nregistro as numeric)) as valor from salidas_alumnos a, salidas_plan b "&_
			'			  " where a.sapl_ncorr=b.sapl_ncorr and b.plan_ccod in (select plan_ccod from planes_estudio a, especialidades b "&_
			'			  "                                                    where a.espe_ccod=b.espe_ccod and carr_ccod in ('51','930','810','920')))a"		
			'elseif carrera = "12" or carrera = "910" or carrera = "900" or carrera = "890" then 
			'	c_folio = " select isnull(valor,0) from ( "&_
			'			  " select max(cast(salu_nregistro as numeric)) as valor from salidas_alumnos a, salidas_plan b "&_
			'			  " where a.sapl_ncorr=b.sapl_ncorr and b.plan_ccod in (select plan_ccod from planes_estudio a, especialidades b "&_
			'			  "                                                    where a.espe_ccod=b.espe_ccod and carr_ccod in ('12','910','900','890')))a"					  	
			'end if
			'response.Write(c_folio)
			c_folio = "select isnull(max(cast(salu_nregistro as numeric)),0) from detalles_titulacion where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"'"
			folio   = conexion.consultaUno(c_folio)
			if folio = "0" then
				c_folio = "select isnull(max(cast(salu_nregistro as numeric)),0) from salidas_alumnos "
				folio = conexion.consultaUno(c_folio)
				c_folio2 = "select isnull(max(cast(salu_nregistro as numeric)),0) from detalles_titulacion "
				folio2 = conexion.consultaUno(c_folio2)
				folio_partida = "5500"
				if cdbl(folio) < cdbl(folio2) then
					folio = folio2
				end if 
				if cdbl(folio) < cdbl(folio_partida) then
					folio = folio_partida
				end if
				folio = cint(folio) + contador
			end if		  
			contador = contador + 1
			'f_salidas.agregaCampoCons "salu_nfolio",folio
			f_salidas.agregaCampoCons "salu_nregistro",folio
		end if
	
	wend 
end if
f_salidas.primero

'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod


if f_salidas.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar_nuevo", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "aceptar", "deshabilitado", "TRUE"
end if

'---------------------------------------------------------------------------------------------------
url_leng1 = "adm_titulados_agregar.asp?dp[0][plan_ccod]=" & q_plan_ccod & "&dp[0][peri_ccod]=" & q_peri_ccod & "&dp[0][pers_nrut]=" & q_pers_nrut & "&dp[0][pers_xdv]=" & q_pers_xdv

consulta_grabado =  " select case count(*) when 0 then 'N' else 'S' end "&_
					" from salidas_plan a, salidas_alumnos b  "&_
					" where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(peri_ccod as varchar)='"&q_peri_ccod&"' and a.sapl_ncorr=b.sapl_ncorr"&_
					" and b.pers_ncorr = (select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"') "

ya_grabado= conexion.consultaUno(consulta_grabado)

if ya_grabado="S" then
    lengueta_detalle = "Detalle_egreso_titulacion.asp?plan_ccod=" & q_plan_ccod & "&peri_ccod=" & q_peri_ccod & "&pers_nrut=" & q_pers_nrut & "&pers_xdv=" & q_pers_xdv
end if

v_carr_ccod_1 = conexion.consultaUno("select b.carr_ccod from planes_estudio a, especialidades b where cast(a.plan_ccod as varchar)='"&q_plan_ccod&"' and a.espe_ccod = b.espe_ccod")

url_cert = "cert_emitidos.asp?plan_ccod=" & q_plan_ccod & "&peri_ccod=" & q_peri_ccod & "&pers_nrut=" & q_pers_nrut & "&pers_xdv=" & q_pers_xdv


'///////////////////////////////////////agregamos consulta para ver las licenciaturas de la carrera //////////////////////////
'/////////////////////////////////////////////// Msandoval 12-06-2007/////////////////////////////////////////////////////////
set licenciaturas	=	new cformulario
licenciaturas.inicializar		conexion
licenciaturas.carga_parametros	"adm_titulados.xml","licenciaturas"
c_licenciaturas	=	"select '' as cod_registro,'N' as tiene_licenciatura "
licenciaturas.consultar	c_licenciaturas

carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&q_plan_ccod&"'")
if carr_ccod = "51" or carr_ccod = "930" or carr_ccod = "810" or carr_ccod = "920" then 
	carr_ccod="51"
end if

if carr_ccod = "12" or carr_ccod = "910" or carr_ccod = "900" or carr_ccod = "890" then 
	carr_ccod="12"
end if

consulta_licenciaturas= "select cod_registro,grado_academico from licenciaturas_carrera where cod_carrera='"&carr_ccod&"' and isnull(grado_academico,'S') <> 'S' "

q_grabado = conexion.consultaUno("select count(*) from salidas_alumnos a,salidas_plan b where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"'")

if q_grabado <> "0" then
	q_tiene_licenciatura = conexion.consultaUno("select isnull(tiene_licenciatura,'N') from salidas_alumnos a,salidas_plan b where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"'")
	q_cod_registro = conexion.consultaUno("select cod_registro from salidas_alumnos a,salidas_plan b where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.sapl_ncorr=b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"'")
else
	q_tiene_licenciatura="N"
	q_cod_registro=null
end if
cantidad = conexion.consultaUno("select count(*) from ("&consulta_licenciaturas&")aa")

licenciaturas.agregacampoparam	"cod_registro",	"destino", "("& consulta_licenciaturas &")m"
licenciaturas.agregacampocons	"tiene_licenciatura",	q_tiene_licenciatura
licenciaturas.agregacampocons	"cod_registro",	q_cod_registro

licenciaturas.siguiente
'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

consulta_cantidad = " select count(*) from salidas_alumnos a, salidas_plan b "&_
					" where a.sapl_ncorr=b.sapl_ncorr and tiene_licenciatura ='S' "&_
				    " and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"'"

accede_licenciatura = conexion.consultaUno(consulta_cantidad)					
'response.Write(accede_licenciatura)

'debemos mostrar botones para licenciaturas y otros grados
tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where carr_ccod='"&carr_ccod&"'")
if tcar_ccod="2" then
	muestra_boton = true
else
	muestra_boton = false
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

<script language="JavaScript">

function HabilitarFila(p_fila, p_habilitado)
{
	t_salidas.filas[p_fila].HabilitarPorCampo(p_habilitado, "bguardar");
}


function bguardar_click(p_objeto)
{
	HabilitarFila(_FilaCampo(p_objeto), p_objeto.checked);
}



var t_salidas;

function Inicio()
{
	var b_habilitado;
	
	t_salidas = new CTabla("salidas");
	
	for (var i = 0; i < t_salidas.filas.length; i++) {
		b_habilitado = (t_salidas.ObtenerValor(i, "bguardar") == "S") ? true : false;
		HabilitarFila(i, b_habilitado);
	}
}

function certificado_titulo(){
   var formulario=document.edicion
   var peri=<%=q_peri_ccod%>;
   var plan=<%=q_plan_ccod%>;
   var rut=<%=q_pers_nrut%>;
   var sede=<%=v_sede_ccod%>;
   //if (confirm("¿Qué desea hacer?\n-Presione Aceptar para editar el formulario en Word.\n-Presione Cancelar para ver el formulario en forma Web"))
   //{
   //		self.open('certificado_titulo_word.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
   //}
   //else
   //{
   		self.open('certificado_titulo.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado_word','width=750px, height=550px, scrollbars=yes, resizable=yes')
  // }
}

function guarda_titulo()
{
  	//alert("listo");
	window.open('guarda_certificado.asp?carr_ccod='+ <%=v_carr_ccod_1%> + '&tipo=3&pers_nrut='+<%=q_pers_nrut%>,'guardar','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function activar(valor)
{  var formulario=document.edicion;
	//alert(valor);
	if (valor)
	{
		formulario.elements["salidas[0][cod_registro]"].id= "TO-N";
	}
	else
	{
		formulario.elements["salidas[0][cod_registro]"].id= "TO-S";
	}
}

function certificado_grado(){
   var formulario=document.edicion
   var peri=<%=q_peri_ccod%>;
   var plan=<%=q_plan_ccod%>;
   var rut=<%=q_pers_nrut%>;
   var sede=<%=v_sede_ccod%>;
   self.open('certificado_grado.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado_word','width=750px, height=550px, scrollbars=yes, resizable=yes')
}

function guarda_grado()
{
  	//alert("listo");
	window.open('guarda_certificado.asp?carr_ccod='+ <%=v_carr_ccod_1%> + '&tipo=4&pers_nrut='+<%=q_pers_nrut%>,'guardar','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
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
            <td><%if lengueta_detalle = "" then
			      pagina.DibujarLenguetas Array(Array("Datos Personales", url_leng1), "Datos de Titulación",Array("Cert. Emitidos", url_cert)), 2 
				  else
				  pagina.DibujarLenguetas Array(Array("Datos Personales", url_leng1), "Datos de Titulación",Array("Datos adicionales Egreso y Titulación", lengueta_detalle),Array("Cert. Emitidos", url_cert)), 2 
				  end if
				  %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Titulación"%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><br>
                            <%f_salidas.DibujaTabla%></div></td>
                        </tr>
						<tr>
                          <td>&nbsp;</td>
                        </tr>
						<%if cantidad<>"0" then%>
						<tr>
                          <td align="center"><table width="70%" border="1" bordercolor="#666666">
						      <tr>
							  	  <td width="25%" align="left"><strong>Accede a Licenciatura</strong></td>
								  <td align="left"><strong>: </strong><%licenciaturas.DibujaCampo("tiene_licenciatura")%></td>
							  </tr>
							  <tr>
							  	  <td width="25%" align="left"><strong>Licenciatura Otorgada</strong></td>
								  <td align="left"><strong>: </strong><%licenciaturas.DibujaCampo("cod_registro")%></td>
							  </tr>
							  </table>
						  </td>
                        </tr>
						<%end if%>
						<tr>
                          <td align="center"><table width="70%" border="0" bordercolor="#666666">
							  <tr>
							  	  <td width="50%" align="center"><%f_botonera.DibujaBoton "certificado_titulo"%></td>
								  <td width="50%" align="center"><%f_botonera.DibujaBoton "guardar_titulo"%></td>
							  </tr>
							  <%if accede_licenciatura <> "0" then%>
							  <tr>
							  	  <td width="50%" align="center"><%f_botonera.DibujaBoton "certificado_grado"%></td>
								  <td width="50%" align="center"><%f_botonera.DibujaBoton "guardar_grado"%></td>
							  </tr>
							  <%end if%>
							  </table>
						  </td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton "guardar_nuevo"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton "eliminar_registro"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
