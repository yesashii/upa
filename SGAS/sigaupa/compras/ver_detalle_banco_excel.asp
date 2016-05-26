<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=ver_detalle_banco_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conectar = new Cconexion2
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()

'----------------------------------------------------------------------------
set f_tipo_gasto = new CFormulario
f_tipo_gasto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.Inicializar conectar 

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

v_cod_rango	= request.querystring("v_cod_rango")
v_eche_ndocto	= request.querystring("v_eche_ndocto")
v_banc_tcodigo	= request.querystring("v_banc_tcodigo")
v_totales	= request.querystring("v_totales")

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

if v_cod_rango <> "" then


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
 
 


'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'sql_tipo_gasto= "select tgas_ccod,tgas_tdesc,tgas_cod_cuenta,tgas_nombre_cuenta  from ocag_tipo_gasto where isnull(etga_ccod,1) not in (3) order by tgas_tdesc"

'sql_tipo_gasto= "select tdev_ccod, tdev_tdesc, tgas_ccod, tgas_cod_cuenta "&_
'				" from ocag_tipo_devolucion "&_
'				" ORDER BY tdev_ccod "

'RESPONSE.WRITE("1. sql_tipo_gasto : "&sql_tipo_gasto&"<BR>")
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
				
'f_tipo_gasto.Consultar sql_tipo_gasto
f_tipo_gasto.Consultar sql_cheques


%>
<html>
<head>
<title>TIPOS DE DEVOLUCIONES</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >

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
								  while f_tipo_gasto.Siguiente 
								  %>
                                <tr bgcolor='#FFFFFF'>
                                  <td><div align="right"><%=f_tipo_gasto.obtenerValor("paguesea")%></div></td>
                                  <td><div align="right"><%=f_tipo_gasto.obtenerValor("banco")%></div></td>
                                  <td><div align="right"><%=f_tipo_gasto.obtenerValor("fecha")%></div></td>
                                  <td><div align="right"><%=f_tipo_gasto.obtenerValor("numero")%></div></td>
                                  <td><div align="right"><%=f_tipo_gasto.obtenerValor("monto")%></div></td>
                                </tr>
                                <%
								  v_total=v_total+Clng(f_tipo_gasto.obtenerValor("monto"))
								  ind=ind+1
								  wend%>
                                <tr bgcolor='#FFFFFF'>
                                  <td bgcolor="#D8D8DE" colspan="4"><div align="right"><strong>Total Monto</strong></div></td>
                                  <td><div align="center"><%=formatcurrency(v_total,0)%></div></td>
                                </tr>
                              </table>


<!-- 8888888888888888888888888888888888888888888888888888888888888888888 -->

<!-- 8888888888888888888888888888888888888888888888888888888888888888888 -->


<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>