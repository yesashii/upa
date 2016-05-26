<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:09/10/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Cheques en Cartera"

set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"

v_eche_ndocto	= request.querystring("busqueda[0][eche_ndocto]")
v_banc_tcodigo		= request.querystring("busqueda[0][banc_tcodigo]")

'RESPONSE.WRITE("1. v_eche_ndocto : "&v_eche_ndocto&"<br>")
'RESPONSE.WRITE("3. v_banc_tcodigo : "&v_banc_tcodigo&"<br>")

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

'set negocio = new cnegocio
'negocio.Inicializa conectar

'v_usuario=negocio.ObtenerUsuario()

' 8888888888888888888888888888888888888888888888888888888888888888888888888

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "entrega_cheques.xml", "buscador2"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "eche_ndocto", v_eche_ndocto
f_busqueda.AgregaCampoCons "banc_ccod", v_banc_ccod
f_busqueda.AgregaCampoCons "banc_tcodigo", v_banc_tcodigo


	if v_eche_ndocto <> "" then
		filtro2= " AND a.NumDocCb ='"&v_eche_ndocto&"' "
	end if

	if v_banc_tcodigo <> "" then
		filtro3= " AND c.pccodi ='"&v_banc_tcodigo&"' "
	end if

' 8888888888888888888888888888888888888888888888888888888888888888888888888

'****************************************************
set f_cheques_entregados = new CFormulario
f_cheques_entregados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_cheques_entregados.Inicializar conectar

	sql_cheques_entregados= " SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod <> 5 "& vbCrLf &_
														" UNION "& vbCrLf &_
														" SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 4 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fdocto,103),getdate()) BETWEEN 0 AND 60 "& vbCrLf &_
														" UNION "& vbCrLf &_
														" SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 2 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fentrega,103),getdate()) BETWEEN 0 AND 60 "
	
	'RESPONSE.WRITE("1. sql_cheques_entregados :"&sql_cheques_entregados&"<BR>")
	
f_cheques_entregados.Consultar sql_cheques_entregados
f_cheques_entregados.siguiente

if f_cheques_entregados.nrofilas>0 then
	for fila = 0 to f_cheques_entregados.nrofilas - 1
		inicio_filtro=" and a.NumDocCb not in ( "
		if fila=0 then
			filtro_sga= "'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
		else
			filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
		end if
		fin_filtro= ") "
		sql_filtro= inicio_filtro&" "&filtro_sga&" "&fin_filtro
		f_cheques_entregados.siguiente
	next
end if

'RESPONSE.WRITE("1. sql_filtro: "&sql_filtro&"<BR>")

'****************************************************
' 8888888888888888888888888888888888888888888888888888888888888888888888888

'****************************************************
set f_cheques_entregados_30 = new CFormulario
f_cheques_entregados_30.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_cheques_entregados_30.Inicializar conectar

	sql_cheques_entregados_30= " SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 4 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fdocto,103),getdate()) BETWEEN 0 AND 30 "& vbCrLf &_
														" UNION "& vbCrLf &_
														" SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 2 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fentrega,103),getdate()) BETWEEN 0 AND 30 "
	
	'RESPONSE.WRITE("1. sql_cheques_entregados_30 :"&sql_cheques_entregados_30&"<BR>")
	
f_cheques_entregados_30.Consultar sql_cheques_entregados_30
f_cheques_entregados_30.siguiente

if f_cheques_entregados_30.nrofilas>0 then
	for fila = 0 to f_cheques_entregados_30.nrofilas - 1
		inicio_filtro_30=" OR a.NumDocCb in ( "
		if fila=0 then
			filtro_sga_30= "'"&f_cheques_entregados_30.ObtenerValor("eche_ndocto")&"'"
		else
			filtro_sga_30= filtro_sga_30&",'"&f_cheques_entregados_30.ObtenerValor("eche_ndocto")&"'"
		end if
		fin_filtro_30= ") "
		sql_filtro_30= inicio_filtro_30&" "&filtro_sga_30&" "&fin_filtro_30
		f_cheques_entregados_30.siguiente
	next
end if

'RESPONSE.WRITE("1. sql_filtro_30: "&sql_filtro_30&"<BR>")

'****************************************************
' 8888888888888888888888888888888888888888888888888888888888888888888888888

'****************************************************
set f_cheques_entregados_60 = new CFormulario
f_cheques_entregados_60.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_cheques_entregados_60.Inicializar conectar

	sql_cheques_entregados_60= " SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 4 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fdocto,103),getdate()) BETWEEN 31 AND 60 "& vbCrLf &_
														" UNION "& vbCrLf &_
														" SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod = 2 "& vbCrLf &_
														" AND datediff(day,convert(datetime,eche_fentrega,103),getdate()) BETWEEN 31 AND 60 "
	
	'RESPONSE.WRITE("1. sql_cheques_entregados_60 :"&sql_cheques_entregados_60&"<BR>")
	
f_cheques_entregados_60.Consultar sql_cheques_entregados_60
f_cheques_entregados_60.siguiente

if f_cheques_entregados_60.nrofilas>0 then
	for fila = 0 to f_cheques_entregados_60.nrofilas - 1
		inicio_filtro_60=" OR a.NumDocCb in ( "
		if fila=0 then
			filtro_sga_60= "'"&f_cheques_entregados_60.ObtenerValor("eche_ndocto")&"'"
		else
			filtro_sga_60= filtro_sga_60&",'"&f_cheques_entregados_60.ObtenerValor("eche_ndocto")&"'"
		end if
		fin_filtro_60= ") "
		sql_filtro_60= inicio_filtro_60&" "&filtro_sga_60&" "&fin_filtro_60
		f_cheques_entregados_60.siguiente
	next
end if

'RESPONSE.WRITE("1. sql_filtro_60: "&sql_filtro_60&"<BR>")

'****************************************************
' 8888888888888888888888888888888888888888888888888888888888888888888888888
' CARTERA - NULO - REEMITIDO
'****************************************************
set f_cheques_entregados_00 = new CFormulario
f_cheques_entregados_00.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_cheques_entregados_00.Inicializar conectar

	'sql_cheques_entregados_60= "select cpbnum from ocag_entrega_cheques"
	sql_cheques_entregados_00= " SELECT DISTINCT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod IN (1,3,6) "
	
	'RESPONSE.WRITE("1. sql_cheques_entregados_00 :"&sql_cheques_entregados_00&"<BR>")
	
f_cheques_entregados_00.Consultar sql_cheques_entregados_00
f_cheques_entregados_00.siguiente

if f_cheques_entregados_00.nrofilas>0 then
	for fila = 0 to f_cheques_entregados_00.nrofilas - 1
		inicio_filtro_00=" AND a.NumDocCb NOT in ( "
		if fila=0 then
			filtro_sga_00= "'"&f_cheques_entregados_00.ObtenerValor("eche_ndocto")&"'"
		else
			filtro_sga_00= filtro_sga_00&",'"&f_cheques_entregados_00.ObtenerValor("eche_ndocto")&"'"
		end if
		fin_filtro_00= ") "
		sql_filtro_00= inicio_filtro_00&" "&filtro_sga_00&" "&fin_filtro_00
		f_cheques_entregados_00.siguiente
	next
end if

'RESPONSE.WRITE("1. sql_filtro_60: "&sql_filtro_60&"<BR>")

'****************************************************

 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "entrega_cheques.xml", "cheques"
 f_cheques.Inicializar conexion

'	sql_cheques	=	"  select max(banco) as Banco,max(pccodi) as pccodi,sum(isnull(monto,0)) as total_banco, "& vbCrLf &_
'					" sum(isnull(rango_tres,0)) as rango_tres,sum(isnull(rango_dos,0)) as rango_dos, "& vbCrLf &_
'					"  sum(isnull(rango_uno,0)) as rango_uno, sum(isnull(rango_cero,0)) as rango_cero "& vbCrLf &_
'					" from ( "& vbCrLf &_
'					"  Select datediff(day,convert(datetime,a.movfv,103),getdate()) as dias,c.pccodi, "& vbCrLf &_
'					"  pcdesc as banco,a.cpbnum,a.CpbAno,convert(datetime,a.movfv,103) as fecha, "& vbCrLf &_      
'					"   cast(a.movHaber as numeric) as monto,cast(a.NumDocCb as numeric) as numero, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())>60 then cast(a.movHaber as numeric) end  as rango_tres, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())>30 and datediff(day,convert(datetime,a.movfv,103),getdate())<=60  then cast(a.movHaber as numeric) end as rango_dos, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())<=30 and datediff(day,convert(datetime,a.movfv,103),getdate())>=0 then cast(a.movHaber as numeric) end as rango_uno, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())<0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_
'					"   from softland.cwmovim a  "& vbCrLf &_
'					"	join softland.cwpctas c "& vbCrLf &_
'					"		on a.pctcod= c.pccodi   "& vbCrLf &_         
'					"   where a.tipdoccb like 'CP'   "& vbCrLf &_    
'					"  and a.cpbano>=2013 "& vbCrLf &_
'					" "&sql_filtro&" "& vbCrLf &_
'					"   and  a.movfv is not null    "& vbCrLf &_
'					" ) as tabla "& vbCrLf &_
'					" Group by banco,pccodi "
					
'	sql_cheques	=	"  select max(banco) as Banco, max(pccodi) as pccodi, sum(isnull(monto,0)) as total_banco, "& vbCrLf &_
'					" sum(isnull(rango_tres,0)) as rango_tres, sum(isnull(rango_dos,0)) as rango_dos, "& vbCrLf &_
'					" sum(isnull(rango_uno,0)) as rango_uno, sum(isnull(rango_cero,0)) as rango_cero "& vbCrLf &_
'					" from ( "& vbCrLf &_
'					"Select "& vbCrLf &_
'					"  datediff(day,convert(datetime,a.movfv,103),getdate()) as dias "& vbCrLf &_
'					", c.pccodi, c.pcdesc as banco, a.cpbnum, a.CpbAno "& vbCrLf &_
'					", convert(datetime,a.movfv,103) as fecha "& vbCrLf &_
'					", cast(a.movHaber as numeric) as monto "& vbCrLf &_
'					", cast(a.NumDocCb as numeric) as numero "& vbCrLf &_
'					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 60 then cast(a.movHaber as numeric) end as rango_tres "& vbCrLf &_
'					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 30 and datediff(day,convert(datetime,a.movfv,103),getdate()) <= 60 then cast(a.movHaber as numeric) end as rango_dos "& vbCrLf &_
'					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) <=30 and datediff(day,convert(datetime,a.movfv,103),getdate()) >=  0 then cast(a.movHaber as numeric) end as rango_uno "& vbCrLf &_
'					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) < 0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_
'					"from softland.cwmovim a "& vbCrLf &_
'					"INNER JOIN softland.cwpctas c on a.pctcod= c.pccodi "& vbCrLf &_
'					"where a.tipdoccb like 'CP' and a.cpbano>=2013 "& vbCrLf &_
'					"  "&filtro2&" "& vbCrLf &_
'					" "&sql_filtro&" "& vbCrLf &_
'					"and a.movfv is not null "& vbCrLf &_
'					"  "&filtro3&" "& vbCrLf &_
'					" ) as tabla "& vbCrLf &_
'					" Group by banco,pccodi "
					
	sql_cheques	=	"  select max(banco) as Banco, max(pccodi) as pccodi, sum(isnull(monto,0)) as total_banco, "& vbCrLf &_
					" sum(isnull(rango_tres,0)) as rango_tres, sum(isnull(rango_dos,0)) as rango_dos, "& vbCrLf &_
					" sum(isnull(rango_uno,0)) as rango_uno, sum(isnull(rango_cero,0)) as rango_cero "& vbCrLf &_
					" from ( "& vbCrLf &_
					"Select "& vbCrLf &_
					"  datediff(day,convert(datetime,a.movfv,103),getdate()) as dias "& vbCrLf &_
					", c.pccodi, c.pcdesc as banco, a.cpbnum, a.CpbAno "& vbCrLf &_
					", convert(datetime,a.movfv,103) as fecha "& vbCrLf &_
					", cast(a.movHaber as numeric) as monto "& vbCrLf &_
					", cast(a.NumDocCb as numeric) as numero "& vbCrLf &_
					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 60 "&sql_filtro&"  then cast(a.movHaber as numeric) end as rango_tres "& vbCrLf &_
					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 30 and datediff(day,convert(datetime,a.movfv,103),getdate()) <= 60 "&sql_filtro_60&" then cast(a.movHaber as numeric) end as rango_dos "& vbCrLf &_
					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) <=30 and datediff(day,convert(datetime,a.movfv,103),getdate()) >=  0 "&sql_filtro_30&" then cast(a.movHaber as numeric) end as rango_uno "& vbCrLf &_
					", case when datediff(day,convert(datetime,a.movfv,103),getdate()) < 0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_
					"from softland.cwmovim a "& vbCrLf &_
					"INNER JOIN softland.cwpctas c on a.pctcod= c.pccodi "& vbCrLf &_
					"where a.tipdoccb like 'CP' and a.cpbano>=2013 "& vbCrLf &_
					"  "&filtro2&" "& vbCrLf &_
					" "&sql_filtro_00&" "& vbCrLf &_
					"and a.movfv is not null "& vbCrLf &_
					"  "&filtro3&" "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" Group by banco,pccodi "
					
'RESPONSE.WRITE("1. sql_cheques : "&sql_cheques&"<BR>")
'response.End()

f_cheques.Consultar sql_cheques
 
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

function Enviar(){
	return true;
}

// ESTA FUNCION ES PARA LA GRILLA
/////////////////////////////////////////////////////////////////
function VerDetalleRangoBanco1(cod_rango, banc){

	formulario = document.buscador;
	ndoc	=	formulario.elements["busqueda[0][eche_ndocto]"].value;
	
	<% IF v_banc_tcodigo <> "" THEN %>
	banc	=	formulario.elements["busqueda[0][banc_tcodigo]"].value;
	<% END IF %>

	url="ver_detalle_banco.asp?cod_rango="+cod_rango+"&totales=2&banc_tcodigo="+banc+"&eche_ndocto="+ndoc+" ";
	window.open(url,"DatosRangoBanco","scrollbars=yes, menubar=no, resizable=yes, width=740,height=400");

}

// ESTA FUNCION ES PARA LOS TOTALES
/////////////////////////////////////////////////////////////////////////
function VerDetalleRangoBanco(cod_rango){

	formulario = document.buscador;
	ndoc	=	formulario.elements["busqueda[0][eche_ndocto]"].value;
	banc	=	formulario.elements["busqueda[0][banc_tcodigo]"].value;
	
	url="ver_detalle_banco.asp?cod_rango="+cod_rango+"&totales=1&banc_tcodigo="+banc+"&eche_ndocto="+ndoc+" ";
	window.open(url,"DatosRangoBanco","scrollbars=yes, menubar=no, resizable=yes, width=740,height=400");
}

function BuscarDocumentos()
{
	formulario = document.buscador;

	v_eche_ndocto	=	formulario.elements["busqueda[0][eche_ndocto]"].value;
	v_banc_tcodigo	=	formulario.elements["busqueda[0][banc_tcodigo]"].value;

	formulario.submit();
}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Cheques en Cartera</font>  </div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  <br>
					  <div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
					  <br>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
					<tr>
						
					<!-- 8888888888888888888888888888888888888888888888888888-->

					<form name="buscador">
					<input type="hidden" name="OPCION" value="<%=OPCION%>" />
						<td align="center">
							<table width="90%" border='1' bordercolor='#999999'>
							<th colspan="5">Busqueda de cheques</th>
							</tr>
								<tr> 
									<td width="9%"><strong>N&deg; Cheque</strong> </td>
									<td width="25%"><%f_busqueda.dibujaCampo("eche_ndocto")%></td>
								    <td width="6%"><strong>Banco</strong></td>
								    <td width="35%">
									<%
									'IF OPCION = 1 THEN
									'	f_busqueda.dibujaCampo("banc_ccod")
									'ELSE
										f_busqueda.dibujaCampo("banc_tcodigo")
									'END IF
									%>
									</td>
								  	<td width="25%">
									<%
									'botonera.DibujaBoton "buscar" 
									botonera.DibujaBoton "buscar_2" 
									%></td>
								</tr>
							</table>
						</td>
					</form>
					
					<!-- 8888888888888888888888888888888888888888888888888888-->

					</tr>
					
					<tr>
						<td>
						<br/>
						<strong><font color="000000" size="1"> </font></strong>
							<form name="datos" method="post">
								<table width="98%"  border="0" align="center">
								  <tr bgcolor='#C4D7FF'>
									<th width="20%">Banco Girador </th>
									<th width="20%">Monto Total </th>
									<th width="20%">A fecha </th>
									<th width="20%">0 a 30 dias </th>
									<th width="20%">31 a 60 dias </th>
									<th width="20%">Ch Vencidos </th>
								  </tr>
								  <%
								  ind=0
								  v_total_banco	=	0
								  v_rango_uno	=	0
								  v_rango_dos	=	0
								  v_rango_tres	=	0
								  while f_cheques.Siguiente 
								  %>
								  <input type="hidden" name="datos[<%=ind%>][fecha]" value="<%=f_cheques.obtenerValor("fecha")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_numero]" value="<%=f_cheques.obtenerValor("cod_numero")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_monto]" value="<%=f_cheques.obtenerValor("cod_monto")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_proveedor]" value="<%=f_cheques.obtenerValor("cod_proveedor")%>" />
								  <input type="hidden" name="datos[<%=ind%>][pccodi]" value="<%=f_cheques.obtenerValor("pccodi")%>" />
								  
								  <%
								  valor=f_cheques.obtenerValor("pccodi")
								  valor=Replace(valor,"-","")
								  %>
								  
								  <tr bgcolor='#FFFFFF'>
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(11,<%=valor%>);"><%=f_cheques.obtenerValor("Banco")%>       </a></div></td>
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(22,<%=valor%>);"><%=f_cheques.obtenerValor("total_banco")%></a></div></td>
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(33,<%=valor%>);"><%=f_cheques.obtenerValor("rango_cero")%> </a></div></td>									
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(44,<%=valor%>);"><%=f_cheques.obtenerValor("rango_uno")%>  </a></div></td>
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(55,<%=valor%>);"><%=f_cheques.obtenerValor("rango_dos")%>  </a></div></td>
									<td><div align="right"><a href="javascript:VerDetalleRangoBanco1(66,<%=valor%>);"><%=f_cheques.obtenerValor("rango_tres")%>  </a></div></td>
								  </tr>
								  <%
								  	v_total_banco	=	CDbl(v_total_banco) +	CDbl(f_cheques.obtenerValor("total_banco"))
									v_rango_cero		=	CDbl(v_rango_cero)  +	CDbl(f_cheques.obtenerValor("rango_cero"))
								  	v_rango_uno		=	CDbl(v_rango_uno)   +	CDbl(f_cheques.obtenerValor("rango_uno"))
								  	v_rango_dos		=	CDbl(v_rango_dos)   +	CDbl(f_cheques.obtenerValor("rango_dos"))
								  	v_rango_tres		=	CDbl(v_rango_tres)	  +	CDbl(f_cheques.obtenerValor("rango_tres"))
								  	ind=ind+1
								  wend%>
								  <tr bgcolor='#FFFFFF'>
										<td bgcolor="#D8D8DE"><div align="right"><strong>Total Cheques en cartera</strong></div></td>
										<td><div align="right"><a href="javascript:VerDetalleRangoBanco(4);"><%=formatcurrency(v_total_banco,0)%></a></div></td>
										<td><div align="right"><a href="javascript:VerDetalleRangoBanco(0);"><%=formatcurrency(v_rango_cero,0)%> </a></div></td>
										<td><div align="right"><a href="javascript:VerDetalleRangoBanco(1);"><%=formatcurrency(v_rango_uno,0)%>  </a></div></td>
										<td><div align="right"><a href="javascript:VerDetalleRangoBanco(2);"><%=formatcurrency(v_rango_dos,0)%>  </a></div></td>
										<td><div align="right"><a href="javascript:VerDetalleRangoBanco(3);"><%=formatcurrency(v_rango_tres,0)%>  </a></div></td>
								  </tr>
								</table>
							</form>
							<br>
						</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
