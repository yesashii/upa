<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 

Response.AddHeader "Content-Disposition", "attachment;filename=detalle_ejecucion_presupuestaria.xls"
Response.ContentType = "application/vnd.ms-excel"


set pagina = new CPagina
pagina.Titulo = "Ejecucion Presupuestaria"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "ejecucion_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------
 

area_ccod= request.querystring("area_ccod")
codcaja= request.querystring("codcaja")
mes_venc= request.querystring("mes_venc")

if mes_venc <> "" then
	sql_mes= "and month(movfv)="&mes_venc
	sql_mes="and cast(substring(efcodi,1,2) as numeric)="&mes_venc	
	nombre_mes=conexion2.consultauno("select nombremes from softland.sw_mesce where indice="&mes_venc&"")
	
	if mes_venc=0 then
		nombre_mes= "TODOS LOS MESES"
		sql_mes=""
	end if

end if

	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "
	
	area_presupuesto = 	conexion2.consultaUno(sql_area_presu) 
'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
 f_presupuesto.Inicializar conexion2

   if  codcaja <> "" then
	  
'			consulta_prespuesto="select  b.nombremes as mes_venc,a.*,cast(movhaber as numeric) as monto "& vbCrLf &_
'								" from softland.cwmovim a, softland.sw_mesce b  "& vbCrLf &_  
'								"  where year(movfv)=year(getdate()) "& vbCrLf &_
'								"  and month(a.movfv)= b.indice "& vbCrLf &_  
'								"  and a.movhaber <> 0 "& vbCrLf &_   
'								"  and a.cpbnum>0 "& vbCrLf &_  
'								"  and a.pctcod like '2-10-070-10-000003' "& vbCrLf &_
'								" "&sql_mes&" "& vbCrLf &_
'								"  and a.cajcod='"&codcaja&"' "		
								
			consulta_prespuesto=" select  a.cpbnum,a.codaux as rut,c.nomaux as proveedor, convert(char(10),a.movfv,103) as fecha_pago," & vbCrLf &_
							 " MovTipDocRef as tipo_doc,MovNumDocRef as num_doc,a.movhaber as monto,a.movglosa as detalle" & vbCrLf &_
							 " from softland.cwmovim a, softland.cwmovef b, softland.cwtauxi c  " & vbCrLf &_
							 " where a.cpbnum=b.cpbnum" & vbCrLf &_
							 " and a.movhaber=b.efmontohaber "& vbCrLf &_ 
							 " and a.codaux=c.codaux" & vbCrLf &_
							 " and a.movnum=b.movnum" & vbCrLf &_
							 " and substring(efcodi,3,4)=2012   " & vbCrLf &_
							 " and a.movhaber <> 0    " & vbCrLf &_
							 " and a.cpbnum>0   " & vbCrLf &_
							 " "&sql_mes&" "& vbCrLf &_
							 " and a.cajcod='"&codcaja&"' "& vbCrLf &_
							 " and a.pctcod like '2-10-070-10-000004' "														
		
	else
		
			consulta_prespuesto=" select  a.cpbnum,a.codaux as rut,c.nomaux as proveedor, convert(char(10),a.movfv,103) as fecha_pago," & vbCrLf &_
						 " MovTipDocRef as tipo_doc,MovNumDocRef as num_doc,a.movhaber as monto,a.movglosa as detalle" & vbCrLf &_
						 " from softland.cwmovim a, softland.cwmovef b, softland.cwtauxi c  " & vbCrLf &_
						 " where a.cpbnum=b.cpbnum" & vbCrLf &_
						 " and a.movhaber=b.efmontohaber "& vbCrLf &_ 
						 " and a.codaux=c.codaux" & vbCrLf &_
						 " and a.movnum=b.movnum" & vbCrLf &_
						 " and a.pctcod like '2-10-070-10-000004' "& vbCrLf &_
						 " and substring(efcodi,3,4)=2012   " & vbCrLf &_
						 " and a.movhaber <> 0    " & vbCrLf &_
						 " and a.cpbnum>0   " & vbCrLf &_
						 " "&sql_mes&" "& vbCrLf &_
						 " and a.cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2012 where cod_area="&area_ccod&") "

					
			codcaja="TODOS"
	end if

f_presupuesto.consultar consulta_prespuesto		

%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<font color="#0000CC" size="2">Detalle presupuesto ejecutado para el mes: <b><%=nombre_mes%></b></font>
								<p><b>Código Presupuesto: &nbsp;<font color="#0000CC" size="2"><%=codcaja%></font></b></p>
								<p><b>Area Presupuestal:&nbsp;<font color="#0000CC" size="2"> <%=area_presupuesto%></font></b></p>
                                <table border="1" align="left" width="100%" >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>Comp.</th>
                                  <th>Rut</th>
                                  <th>Proveedor</th>
                                  <th>Fecha pago </th>
								  <th>Tipo Dcto</th>
								  <th>N&deg; Dcto </th>
								  <th>Monto </th>
								  <th>Detalle</th>
                                </tr>
								<%
								while f_presupuesto.Siguiente
								%>
								<tr bordercolor='#999999'>	
                                  <td align="right"><%=f_presupuesto.ObtenerValor("cpbnum")%></td>
                                  <td align="right"><%=f_presupuesto.ObtenerValor("rut")%></td>
                                  <td align="right"><%=f_presupuesto.ObtenerValor("proveedor")%></td>
								  <td align="right"><%=f_presupuesto.ObtenerValor("fecha_pago")%></td>
								  <td align="right"><%=f_presupuesto.ObtenerValor("tipo_doc")%></td>
								  <td align="right"><%=f_presupuesto.ObtenerValor("num_doc")%></td>
								  <td align="right"><%=f_presupuesto.ObtenerValor("monto")%></td>
								  <td align="left"><%=f_presupuesto.ObtenerValor("detalle")%></td>
                                </tr>
								 <%wend%>
                              </table>
							
</body>
</html>