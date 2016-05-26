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
pagina.Titulo = "Datos cheques por rango"

set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"

v_cod_rango	= request.querystring("cod_rango")
v_eche_ndocto	= request.querystring("eche_ndocto")
v_banc_tcodigo	= request.querystring("banc_tcodigo")
v_totales	= request.querystring("totales")

'RESPONSE.WRITE("1. v_cod_rango: "&v_cod_rango&"<BR>")
'RESPONSE.WRITE("2. v_eche_ndocto: "&v_eche_ndocto&"<BR>")
'RESPONSE.WRITE("3. v_banc_tcodigo: "&v_banc_tcodigo&"<BR>")
'RESPONSE.WRITE("4. v_totales: "&v_totales&"<BR>")

'set conectar = new cconexion
'conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

'set negocio = new cnegocio
'negocio.Inicializa conectar

'v_usuario=negocio.ObtenerUsuario()

'response.end()

'****************************************************
'set f_cheques_entregados = new CFormulario
'f_cheques_entregados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
'f_cheques_entregados.Inicializar conectar
'sql_cheques_entregados= "select cpbnum from ocag_entrega_cheques"
'f_cheques_entregados.Consultar sql_cheques_entregados
'f_cheques_entregados.siguiente

'if f_cheques_entregados.nrofilas>0 then
'	for fila = 0 to f_cheques_entregados.nrofilas - 1
'		inicio_filtro=" and a.cpbnum not in ( "
'		if fila=0 then
'			filtro_sga= "'"&f_cheques_entregados.ObtenerValor("cpbnum")&"'"
'		else
'			filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("cpbnum")&"'"
'		end if
'		fin_filtro= ") "
'		sql_filtro= inicio_filtro&" "&filtro_sga&" "&fin_filtro
'		f_cheques_entregados.siguiente
'	next
'end if
'****************************************************

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 
	' NUMERO DE DOCUMENTO
	if v_eche_ndocto <> "" then
		filtro2= " AND a.NumDocCb  ='"&v_eche_ndocto&"' "
	end if

	'CODIGO DE BANCO
	if v_banc_tcodigo <> "" then
		filtro3= " AND REPLACE(c.pccodi,'-','')  ='"&Replace(v_banc_tcodigo,"-","")&"' "
	end if

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	 
 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
 f_cheques.Inicializar conexion

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

if v_cod_rango <> "" then

'RESPONSE.WRITE("v_totales 1 : "&v_totales&"<BR>")
	
IF v_totales=1 THEN 

	'DETALLE TOTAL
	'RESPONSE.WRITE("ACA 1 : "&v_cod_rango&"<BR>")

	Select Case v_cod_rango
	case 0:
		filtro="where rango_cero >0"
	case 1:
		filtro="where rango_uno >0"
	case 2:
		filtro="where rango_dos >0"
	case 3:
		filtro="where rango_tres >0"
	case 4:
		filtro="where monto >0"
	end select 
	
'	sql_cheques	=	"select * from ( "& vbCrLf &_
'					" Select paguesea,pcdesc as banco,a.cpbnum,a.CpbAno,convert(char(10),a.movfv,103) as fecha,   "& vbCrLf &_    
'					"   cast(a.movHaber as numeric) as monto,cast(a.NumDocCb as integer) as numero, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())>60 then cast(a.movHaber as numeric) end  as rango_tres, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())>30 and datediff(day,convert(datetime,a.movfv,103),getdate())<=60  then cast(a.movHaber as numeric) end as rango_dos, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())<=30 and datediff(day,convert(datetime,a.movfv,103),getdate())>=0 then cast(a.movHaber as numeric) end as rango_uno, "& vbCrLf &_
'					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())<0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_
'					"   from softland.cwmovim a  "& vbCrLf &_
'					"	join softland.cwpctas c "& vbCrLf &_
'					"		on a.pctcod= c.pccodi   "& vbCrLf &_         
'					"  where a.tipdoccb like 'CP'  "& vbCrLf &_     
'					"  and a.cpbano>=2013 "& vbCrLf &_
'					"  and  a.movfv is not null    "& vbCrLf &_
'					" ) as tabla  "& vbCrLf &_
'					" "&filtro&" "
					
	sql_cheques	=	"select * from ( "& vbCrLf &_
					" Select a.paguesea, c.pcdesc as banco, a.cpbnum, a.CpbAno, convert(char(10), a.movfv,103) as fecha,   "& vbCrLf &_    
					"   cast(a.movHaber as numeric) as monto,cast(a.NumDocCb as integer) as numero, "& vbCrLf &_
					"   case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 60 then cast(a.movHaber as numeric) end  as rango_tres, "& vbCrLf &_
					"   case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 30 and datediff(day,convert(datetime,a.movfv,103),getdate()) <= 60 then cast(a.movHaber as numeric) end as rango_dos, "& vbCrLf &_
					"   case when datediff(day,convert(datetime,a.movfv,103),getdate())<=30 and datediff(day,convert(datetime,a.movfv,103),getdate()) >=   0 then cast(a.movHaber as numeric) end as rango_uno, "& vbCrLf &_
					"   case when datediff(day,convert(datetime,a.movfv,103),getdate()) <   0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_
					"   from softland.cwmovim a  "& vbCrLf &_
					"	INNER JOIN softland.cwpctas c "& vbCrLf &_
					"		on a.pctcod= c.pccodi   "& vbCrLf &_         
					"  where a.tipdoccb like 'CP' "& vbCrLf &_     
					"  and a.cpbano>=2013 "& vbCrLf &_
					"  "&filtro2&" "& vbCrLf &_
					" "&sql_filtro&" "& vbCrLf &_
					"  and  a.movfv is not null    "& vbCrLf &_
					"  "&filtro3&" "& vbCrLf &_
					" ) as tabla  "& vbCrLf &_
					" "&filtro&" "
					
ELSE

	'DETALLE POR BANCO
	'RESPONSE.WRITE("ACA 2 :"&v_cod_rango&"<BR>")

	Select Case v_cod_rango
	case 33:
		filtro="where rango_cero >0"
	case 44:
		filtro="where rango_uno >0"
	case 55:
		filtro="where rango_dos >0"
	case 66:
		filtro="where rango_tres >0"
	case 22:
		filtro="where monto >0"
	end select 
					
	sql_cheques	=	"select paguesea, banco, cpbnum, CpbAno, fecha, monto, numero, rango_tres, rango_dos, rango_uno, rango_cero  from ( "& vbCrLf &_     
					" Select a.paguesea, c.pcdesc as banco, a.cpbnum, a.CpbAno "& vbCrLf &_     
					" , convert(char(10), a.movfv,103) as fecha "& vbCrLf &_     
					" , cast(a.movHaber as numeric) as monto "& vbCrLf &_     
					" , cast(a.NumDocCb as integer) as numero "& vbCrLf &_     
					" , case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 60 then cast(a.movHaber as numeric) end as rango_tres "& vbCrLf &_     
					" , case when datediff(day,convert(datetime,a.movfv,103),getdate()) > 30 and datediff(day,convert(datetime,a.movfv,103),getdate()) <= 60 then cast(a.movHaber as numeric) end as rango_dos "& vbCrLf &_     
					" , case when datediff(day,convert(datetime,a.movfv,103),getdate())<= 30 and datediff(day,convert(datetime,a.movfv,103),getdate()) >=  0 then cast(a.movHaber as numeric) end as rango_uno "& vbCrLf &_     
					" , case when datediff(day,convert(datetime,a.movfv,103),getdate()) <  0 then cast(a.movHaber as numeric) end as rango_cero "& vbCrLf &_     
					" from softland.cwmovim a "& vbCrLf &_     
					" INNER JOIN softland.cwpctas c "& vbCrLf &_     
					" on a.pctcod = c.pccodi "& vbCrLf &_     
					" where a.tipdoccb like 'CP' and a.cpbano>=2013 "& vbCrLf &_     
					"  "&filtro2&" "& vbCrLf &_
					" "&sql_filtro&" "& vbCrLf &_
					" and a.movfv is not null "& vbCrLf &_     
					"  "&filtro3&" "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" "&filtro&" "

END IF

 ' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
else
	sql_cheques	=	"select '' where 1=2"												
end if
 ' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 
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

//function Enviar(){
//	return true;
//}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos cheques por rango</font>  </div></td>
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

                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
						<td>
						<br/>
						<strong><font color="000000" size="1"> </font></strong>
						
<!-- 88888888888888888888888 INICIO DEL FORM 888888888888888888888888888888 -->
						
							<form name="datos" method="post">
							
							<INPUT TYPE="HIDDEN" NAME="v_cod_rango" VALUE=<%=v_cod_rango%> >
							<INPUT TYPE="HIDDEN" NAME="v_banc_tcodigo" VALUE=<%=v_banc_tcodigo%> >
							<INPUT TYPE="HIDDEN" NAME="v_totales" VALUE=<%=v_totales%> >
							<INPUT TYPE="HIDDEN" NAME="v_eche_ndocto" VALUE=<%=v_eche_ndocto%> >
							
							  <table width="98%"  border="0" align="center">
                                <tr bgcolor='#C4D7FF'>
                                  <th width="15%">Nombre </th>
                                  <th width="9%">Banco</th>
                                  <th width="8%">Fecha</th>
                                  <th width="6%">N° Doc</th>
                                  <th width="12%">Monto</th>
                                </tr>
                                <%
								  ind=0
								  v_total=0
								  while f_cheques.Siguiente 
								  %>
                                <tr bgcolor='#FFFFFF'>
                                  <td><div align="right"><%=f_cheques.obtenerValor("paguesea")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("banco")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("fecha")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("numero")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("monto")%></div></td>
                                </tr>
                                <%
								  v_total=v_total+Clng(f_cheques.obtenerValor("monto"))
								  ind=ind+1
								  wend%>
                                <tr bgcolor='#FFFFFF'>
                                  <td bgcolor="#D8D8DE" colspan="4"><div align="right"><strong>Total Monto</strong></div></td>
                                  <td><div align="center"><%=formatcurrency(v_total,0)%></div></td>
                                </tr>
                              </table>
							</form>

<!-- 88888888888888888888888 FIN DEL FORM 888888888888888888888888888888 -->

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
						<td><%botonera.DibujaBoton "excel_area" %></td>
						<td><%botonera.dibujaboton "cerrar"%></td>
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
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
