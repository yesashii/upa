<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "c&aacute;lculo porcentaje de beca"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "calculo_beca.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "calculo_beca.xml", "botonera"


pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut&"'")
nombre_alumno = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr=conexion.consultaUno("select post_ncorr from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")

tiene_postulacion = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")
if tiene_postulacion="S" then
	nro_folio = conexion.consultaUno("select pobe_nfolio from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")
	carrera = conexion.consultaUno("select protic.initcap(carr_tdesc) from postulacion_becas a, carreras b where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and a.carr_ccod=b.carr_ccod")
	pobe_ncorr = conexion.consultaUno("select pobe_ncorr from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")
else
    botonera.agregabotonparam "guardar", "deshabilitado", "TRUE"
end if  

'-------------------debemos sacar el total de ingreso liquido del grupo familiar------------------------------------------------------
Sql_parientes = "  Select pp.pers_ncorr, protic.initcap(pp.pers_tnombre)+' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
			    "  protic.initCap(pa.pare_tdesc) as Parentesco, isnull(ing_liquido,0) as ing_liquido,isnull(ret_judicial,0) as ret_judicial,isnull(aportes,0) as aportes,isnull(act_varias,0) as act_varias,isnull(arr_bienes,0) as arr_bienes,isnull(arr_vehiculos,0) as arr_vehiculos,isnull(intereses,0) as intereses, isnull(dividendos,0) as dividendos " & VBCRLF  	& _
				"  from postulantes pos join  grupo_familiar gf  " & VBCRLF  	& _
			    "    on pos.post_ncorr = gf.post_ncorr  " & VBCRLF  	& _
			    "  join  personas_postulante pp  " & VBCRLF  	& _
			    "    on gf.pers_ncorr = pp.pers_ncorr  " & VBCRLF  	& _
			    " left outer join antecedentes_personas ap  " & VBCRLF  	& _
			    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
			    " join parentescos pa " & VBCRLF  	& _
			    "    on gf.pare_ccod = pa.pare_ccod" & VBCRLF  	& _
				" Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
				" and gf.grup_nindependiente is null " & VBCRLF  	& _
				" and gf.pare_ccod not in (0) " & VBCRLF  	& _
				" union all " & VBCRLF  	& _
				" select pp.pers_ncorr, protic.initcap(pp.pers_tnombre) +' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
				" 'Alumno' as Parentesco, isnull(ing_liquido,0) as ing_liquido,isnull(ret_judicial,0) as ret_judicial,isnull(aportes,0) as aportes,isnull(act_varias,0) as act_varias,isnull(arr_bienes,0) as arr_bienes,isnull(arr_vehiculos,0) as arr_vehiculos,isnull(intereses,0) as intereses, isnull(dividendos,0) as dividendos " & VBCRLF  	& _
			    " from personas_postulante pp left outer join antecedentes_personas ap " & VBCRLF  	& _
			    "    on pp.pers_ncorr = ap.pers_ncorr " & VBCRLF  	& _
			    " where cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"'"

'response.Write("<pre>"&Sql_parientes&"</pre>")
set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "tabla_vacia.xml", "tabla"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.Consultar Sql_parientes

fila = 0
total_general = 0
while f_grupo_familiar.siguiente 
total = 0
ing_liquido = clng(f_grupo_familiar.obtenerValor("ing_liquido"))
ret_judicial = clng(f_grupo_familiar.obtenerValor("ret_judicial"))
aportes = clng(f_grupo_familiar.obtenerValor("aportes"))
act_varias = clng(f_grupo_familiar.obtenerValor("act_varias"))
arr_bienes = clng(f_grupo_familiar.obtenerValor("arr_bienes"))
arr_vehiculos = clng(f_grupo_familiar.obtenerValor("arr_vehiculos"))
intereses = clng(f_grupo_familiar.obtenerValor("intereses"))
dividendos = clng(f_grupo_familiar.obtenerValor("dividendos"))
total = ing_liquido + ret_judicial + aportes + act_varias + arr_bienes + arr_vehiculos + intereses + dividendos 
'response.Write("<br>"&total)
f_grupo_familiar.agregaCampoFilaCons fila, "sub_total", "<center><b>" & cstr(total) & "</b></center>"
fila = fila + 1
total_general = clng(total_general) + total
wend 

Sql_desc_salud = " select sum(enfp_ncosto) from ( " & VBCRLF  	& _
				 " Select enfp_ncorr,gf.pers_ncorr,enfp_ncosto " & VBCRLF  	& _
				 "  from postulantes pos join  grupo_familiar gf  " & VBCRLF  	& _
				 "    on pos.post_ncorr = gf.post_ncorr   " & VBCRLF  	& _
				 "  join  personas_postulante pp   " & VBCRLF  	& _
				 "    on gf.pers_ncorr = pp.pers_ncorr  " & VBCRLF  	& _
				 "  join enfermedades_persona pr  " & VBCRLF  	& _
				 "	 on pp.pers_ncorr = pr.pers_ncorr  " & VBCRLF  	& _
				 " join parentescos pa " & VBCRLF  	& _
				 "    on gf.pare_ccod = pa.pare_ccod " & VBCRLF  	& _
				 " Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"'  " & VBCRLF  	& _
				 " and gf.grup_nindependiente is null " & VBCRLF  	& _
				 " and gf.pare_ccod not in (0) " & VBCRLF  	& _
				 " union all  " & VBCRLF  	& _
				 " select enfp_ncorr,pp.pers_ncorr, enfp_ncosto " & VBCRLF  	& _
				 " from personas_postulante pp join enfermedades_persona pr  " & VBCRLF  	& _
				 "	 on pp.pers_ncorr = pr.pers_ncorr " & VBCRLF  	& _
				 " where cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"')a"

desc_salud = conexion.consultaUno(Sql_desc_salud)
'response.Write(pers_ncorr)
num_integrantes = conexion.consultaUno(" select count(distinct pers_ncorr) from ("&Sql_parientes&")aa")
'response.Write(num_integrantes)
if desc_salud <> "0" then
descuento_mostrar = "<font color='#cc3300'> <center><b>(" &cstr(desc_salud)&")</center></b></font>"
else
descuento_mostrar = "<center><b>0</center></b>"
end if 

'response.Write(descuento_mostrar)
'response.Write(desc_salud)
set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "calculo_beca.xml", "grilla_familiares"
f_ingresos.Inicializar conexion
f_ingresos.Consultar "select sum(ing_liquido) as ing_liquido,sum(ret_judicial) as ret_judicial,sum(aportes) as aportes,sum(act_varias) as act_varias,sum(arr_bienes) as arr_bienes,sum(arr_vehiculos) as arr_vehiculos,sum(intereses) as intereses, sum(dividendos) as dividendos from ("&Sql_parientes&")a"

fila = 0
if rut <> "" then
		while f_ingresos.siguiente 
		total = 0
		ing_liquido = clng(f_ingresos.obtenerValor("ing_liquido"))
		ret_judicial = clng(f_ingresos.obtenerValor("ret_judicial"))
		aportes = clng(f_ingresos.obtenerValor("aportes"))
		act_varias = clng(f_ingresos.obtenerValor("act_varias"))
		arr_bienes = clng(f_ingresos.obtenerValor("arr_bienes"))
		arr_vehiculos = clng(f_ingresos.obtenerValor("arr_vehiculos"))
		intereses = clng(f_ingresos.obtenerValor("intereses"))
		dividendos = clng(f_ingresos.obtenerValor("dividendos"))
		total = ing_liquido + ret_judicial + aportes + act_varias + arr_bienes + arr_vehiculos + intereses + dividendos 
		'response.Write("<br>"&total)
		f_ingresos.agregaCampoFilaCons fila, "sub_total", "<center><b>" & cstr(total) & "</b></center>"
		f_ingresos.agregaCampoFilaCons fila, "desc_salud", descuento_mostrar
		fila = fila + 1
		wend 
end if
f_ingresos.primero

set f_calculo = new CFormulario
f_calculo.Carga_Parametros "calculo_beca.xml", "datos_calculo"
f_calculo.Inicializar conexion
f_calculo.Consultar "select '' "
f_calculo.Siguiente
 
region = conexion.consultaUno("select b.regi_ccod from direcciones_publica a, ciudades b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ciud_ccod = b.ciud_ccod and a.tdir_ccod=1")

f_calculo.AgregaCampoCons "ingr_liquido_familiar", total_general
f_calculo.AgregaCampoCons "gasto_total", desc_salud
f_calculo.AgregaCampoCons "num_integrantes", num_integrantes
f_calculo.AgregaCampoCons "regi_ccod", region
 
if pobe_ncorr <> "" then
	pobe_ningreso_revisado = conexion.consultaUno("select pobe_ningreso_revisado from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
	if pobe_ningreso_revisado <> "" then
		f_calculo.AgregaCampoCons "ingr_liquido_familiar", pobe_ningreso_revisado
	else
		f_calculo.AgregaCampoCons "ingr_liquido_familiar", total_general
	end if
	pobe_ncosto_revisado = conexion.consultaUno("select pobe_ncosto_revisado from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
	if pobe_ncosto_revisado <> "" then
		f_calculo.AgregaCampoCons "gasto_total", pobe_ncosto_revisado
	else
		f_calculo.AgregaCampoCons "gasto_total", desc_salud
	end if
	pobe_nintegrantes_revisado = conexion.consultaUno("select pobe_nintegrantes_revisado from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
	if pobe_nintegrantes_revisado <> "" then
		f_calculo.AgregaCampoCons "num_integrantes", pobe_nintegrantes_revisado
	else
		f_calculo.AgregaCampoCons "num_integrantes", num_integrantes
	end if
	pobe_nregion_revisado = conexion.consultaUno("select pobe_nregion_revisado from postulacion_becas where cast(pobe_ncorr as varchar)='"&pobe_ncorr&"'")
	if pobe_nregion_revisado <> "" then
		f_calculo.AgregaCampoCons "regi_ccod", pobe_nregion_revisado
	else
		f_calculo.AgregaCampoCons "regi_ccod", region
	end if
end if

f_calculo.AgregaCampoCons "gasto_minimo", 0
f_calculo.AgregaCampoCons "capacidad_pago",0

if rut <> "" and v_post_ncorr <> "" then 
valor_temporal = clng(total_general) - clng(desc_salud)
else
valor_temporal=0
end if
'-----------------se debe generar un arreglo con los gastos de las regiones ----------------------
consulta = "select regi_ccod,gasto_t_01 as a1,gasto_t_02 as a2,gasto_t_03 as a3,gasto_t_04 as a4,gasto_t_05 as an  from gastos_minimos_region"
conexion.Ejecuta consulta
set rec_gastos = conexion.ObtenerRS

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

arr_gastos = new Array();

<%
rec_gastos.MoveFirst
i = 0
while not rec_gastos.Eof
%>
arr_gastos[<%=i%>] = new Array();
arr_gastos[<%=i%>]["regi_ccod"] = '<%=rec_gastos("regi_ccod")%>';
arr_gastos[<%=i%>]["a1"] = '<%=rec_gastos("a1")%>';
arr_gastos[<%=i%>]["a2"] = '<%=rec_gastos("a2")%>';
arr_gastos[<%=i%>]["a3"] = '<%=rec_gastos("a3")%>';
arr_gastos[<%=i%>]["a4"] = '<%=rec_gastos("a4")%>';
arr_gastos[<%=i%>]["an"] = '<%=rec_gastos("an")%>';
<%	
	rec_gastos.MoveNext
	i = i + 1
wend
%>

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

function recalcular_valores()
{ var formulario = document.edicion;
  var ingreso_liquido = formulario.elements["calculo[0][ingr_liquido_familiar]"].value;
  var gasto_total = formulario.elements["calculo[0][gasto_total]"].value;
	
  formulario.elements["ingreso_mensual"].value =  ingreso_liquido - gasto_total;
  formulario.elements["ingreso_mensual2"].value =  ingreso_liquido - gasto_total; 
  formulario.elements["gasto_minimo"].value = busca_gasto(formulario.elements["calculo[0][regi_ccod]"].value,formulario.elements["calculo[0][num_integrantes]"].value);
  formulario.elements["calculo[0][gasto_minimo]"].value=formulario.elements["gasto_minimo"].value;
  formulario.elements["capacidad_familiar_total"].value = formulario.elements["ingreso_mensual2"].value - formulario.elements["gasto_minimo"].value;
  formulario.elements["num_integrantes2"].value = formulario.elements["calculo[0][num_integrantes]"].value;	
  formulario.elements["capacidad_familiar_total2"].value = formulario.elements["capacidad_familiar_total"].value;
  
  if ((formulario.elements["calculo[0][num_integrantes]"].value != "") && (formulario.elements["calculo[0][num_integrantes]"].value != 0))
  {
  	formulario.elements["capacidad_familiar_final"].value = Math.round(formulario.elements["capacidad_familiar_total2"].value / formulario.elements["num_integrantes2"].value);
    formulario.elements["calculo[0][capacidad_pago]"].value= formulario.elements["capacidad_familiar_final"].value;  
  }
  else
  { alert ("La cantidad de integrantes del grupo familiar no puede ser vacio y tampoco cero");
    formulario.elements["calculo[0][num_integrantes]"].focus();
  }
}

function busca_gasto(region,cantidad)
{ var valor_retorno = 0;
  for (i = 0; i < arr_gastos.length; i++)
	  { 
		if (arr_gastos[i]["regi_ccod"] == region)
		 {
			 if (cantidad == 1)
			    { valor_retorno = arr_gastos[i]["a1"]; }
			 if (cantidad == 2)
			    { valor_retorno = arr_gastos[i]["a2"]; }	
			 if (cantidad == 3)
			    { valor_retorno = arr_gastos[i]["a3"]; }
			 if (cantidad == 4)
			    { valor_retorno = arr_gastos[i]["a4"]; }	
			 if ((cantidad == 5)|| (cantidad > 5))
			    { valor_retorno = arr_gastos[i]["an"] * cantidad; }	
		 }
	}	
return valor_retorno;
}

function inicio()
{
  <%if rut <> "" then%>
    recalcular_valores(); 
  <%end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad=" inicio(); MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>
	<%if rut <> "" then%>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"><table width="100%" >
					<tr>
						<td colspan="2"><br><br></td>
					</tr>
					<tr>
						<td width="25%"><strong>Alumno</strong></td>
						<td width="75%" align="left"><strong>:</strong> <%=nombre_alumno%></td>
					</tr>
					<tr>
						<td width="25%"><strong>R.U.T.</strong></td>
						<td align="left"><strong>:</strong> <%=rut_alumno%></td>
					</tr>
					<%if tiene_postulacion = "N" and not esVacio(rut) then%>
					<tr>
						<td colspan="2" align="center"><font color="#0000FF"><strong>Esta persona no presenta una postulación a beca para el periodo seleccionado.</strong></font></td>
					</tr>
					<%else%>
					<tr>
						<td width="25%"><strong>Nro. Folio</strong></td>
						<td align="left"><strong>:</strong> <%=nro_folio%></td>
					</tr>
					<tr>
						<td width="25%"><strong>Carrera</strong></td>
						<td align="left"><strong>:</strong> <%=carrera%></td>
					</tr>
					<%end if%>
					<tr>
						<td colspan="2"><br><hr><br></td>
					</tr>
					<form name="edicion">
					<tr>
						<td colspan="2"><%pagina.dibujarSubtitulo("Ingresos totales grupo familiar")%></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><%f_ingresos.DibujaTabla%></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><%pagina.dibujarSubTitulo("Paso 1:")%></td>
					</tr>
					<tr>
						<td colspan="2">
						   <table width="100%" border="1" cellspacing="0" cellpadding="0" aling="center">
                             <tr>	
							 		<td width="30%" align="center"><strong>Ingreso Liquido Familiar</strong></td>
									<td width="5%" align="center"><strong>-</strong></td>
									<td width="30%" align="center"><strong>Gasto Total Situaciones Extraordinarias</strong></td>
									<td width="5%" align="center"><strong>=</strong></td>
									<td width="30%" align="center"><strong>Ingreso Familiar Mensual</strong></td>
							 </tr>
							 <tr>	
							 		<td align="center"><%f_calculo.DibujaCampo("ingr_liquido_familiar") %></td>
									<td align="center"><strong>-</strong></td>
									<td align="center"><%f_calculo.DibujaCampo("gasto_total") %></td>
									<td align="center"><strong>=</strong></td>
									<td align="center"><input type="text" name="ingreso_mensual" size="20" maxlength="10" value="<%=valor_temporal%>" style="font-size:12px" disabled></td>
							 </tr>
							</table> 
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><%pagina.dibujarSubTitulo("Paso 2:")%></td>
					</tr>
					<tr>
						<td colspan="2">
						   <table width="100%" border="1" cellspacing="0" cellpadding="0" aling="center">
                             <tr>	
							 		<td width="20%" align="center"><strong>Ingreso Familiar Mensual</strong></td>
									<td width="5%" align="center"><strong>-</strong></td>
									<td width="50%" align="center"><strong>Gasto M&iacute;nimo</strong> <br>(seg&uacute;n Nº Integrantes y regi&oacute; de origen)</td>
									<td width="5%" align="center"><strong>=</strong></td>
									<td width="20%" align="center"><strong>Capacidad Pago Familiar</strong></td>
							 </tr>
							 <tr>	
							 		<td align="center"><input type="text" name="ingreso_mensual2" size="20" maxlength="10" value="<%=valor_temporal%>" style="font-size:12px"  disabled></td>
									<td align="center"><strong>-</strong></td>
									<td align="center">Nº:<%f_calculo.DibujaCampo("num_integrantes")%> Regi&oacute;n:<%f_calculo.DibujaCampo("regi_ccod")%> ==> $ <input type="text" name="gasto_minimo" size="10" maxlength="10" style="font-size:12px" disabled  ><%f_calculo.DibujaCampo("gasto_minimo") %></td>
									<td align="center"><strong>=</strong></td>
									<td align="center"><input type="text" name="capacidad_familiar_total" size="20" maxlength="10" style="font-size:12px" disabled></td>
							 </tr>
							</table> 
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><%pagina.dibujarSubTitulo("Paso 3:")%></td>
					</tr>
					<tr>
						<td colspan="2">
						   <table width="100%" border="1" cellspacing="0" cellpadding="0" aling="center">
                             <tr>	
							 		<td width="20%" align="center"><strong>Capacidad Pago Familiar</strong></td>
									<td width="5%" align="center"><strong>/</strong></td>
									<td width="50%" align="center"><strong>Nº de integrantes del grupo familiar</strong></td>
									<td width="5%" align="center"><strong>=</strong></td>
									<td width="20%" align="center"><font color="#0000FF"><strong>CAPACIDAD DE PAGO FINAL</strong></font></td>
							 </tr>
							 <tr>	
							 		<td align="center"><input type="text" name="capacidad_familiar_total2" size="20" maxlength="10" style="font-size:12px" disabled></td>
									<td align="center"><strong>/</strong></td>
									<td align="center"><input type="text" name="num_integrantes2" size="4" maxlength="4" value="<%=num_integrantes%>" style="font-size:12px"  disabled></td>
									<td align="center"><strong>=</strong></td>
									<td align="center"><input type="text" name="capacidad_familiar_final" size="20" maxlength="10" style="font-size:12px" disabled><%f_calculo.DibujaCampo("capacidad_pago") %></td>
							 </tr>
							</table> 
						</td>
					</tr>
					<tr>
						<td colspan="2"><br><hr><br>
						<input type="hidden" name="ing_liquido_original" value="<%=total_general%>">
						<input type="hidden" name="gasto_general_original" value="<%=desc_salud%>">
						<input type="hidden" name="num_integrantes_original" value="<%=num_integrantes%>">
						<input type="hidden" name="region_original" value="<%=region%>">
						<input type="hidden" name="pobe_ncorr" value="<%=pobe_ncorr%>">
						</td>
					</tr>
					</form>
					</table></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <% if tiene_postulacion="N" then
						      botonera.agregaBotonParam "guardar","deshabilitado","true"
						   end if 
						   botonera.dibujaboton "guardar"
						%>
                      </td>
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
	  <%end if%>
   </td>
  </tr>  
</table>
</body>
</html>
