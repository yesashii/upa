<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: EVENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 07/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 97, 134, 186, 239
'********************************************************************
set pagina = new CPagina
pagina.Titulo = "Perfiles Colegios"


v_fecha_inicio 		= request.querystring("busqueda[0][even_fevento]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_tiop_ccod	 		= request.querystring("busqueda[0][tiop_ccod]")
v_pcol_ccod 		= request.querystring("busqueda[0][pcol_ccod]")


set botonera = new CFormulario
botonera.carga_parametros "perfiles_colegios.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario
set formulario2 = new cformulario
set formulario3 = new cformulario

conectar.inicializar "upacifico"


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "perfiles_colegios.xml", "busqueda_perfiles"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


 f_busqueda.AgregaCampoCons "even_fevento", v_fecha_inicio
 f_busqueda.AgregaCampoCons "fecha_termino", v_fecha_termino
 f_busqueda.AgregaCampoCons "tiop_ccod", v_tiop_ccod
 f_busqueda.AgregaCampoCons "pcol_ccod", v_pcol_ccod

if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  convert(datetime,a.even_fevento,103) >= convert(datetime,'"&v_fecha_inicio&"',103)"& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_pcol_ccod <> "" then
	sql_adicional= sql_adicional + " and a.pcol_ccod ="&v_pcol_ccod& vbCrLf 
else
	sql_adicional= sql_adicional + " and a.pcol_ccod in (1,2) "& vbCrLf 
end if


if v_tiop_ccod ="1" then
	formulario.carga_parametros "perfiles_colegios.xml", "datos_colegios"
	formulario.inicializar conectar
end if

if v_tiop_ccod ="2" then
	formulario.carga_parametros "perfiles_colegios.xml", "primera_preferencia"
	formulario.inicializar conectar

	formulario2.carga_parametros "perfiles_colegios.xml", "segunda_preferencia"
	formulario2.inicializar conectar

	formulario3.carga_parametros "perfiles_colegios.xml", "tercera_preferencia"
	formulario3.inicializar conectar
end if


'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then

	if v_tiop_ccod ="1" then
'		sql_datos_eventos= "select even_ncorr,protic.trunc(a.even_fevento) as Fecha,e.pcol_tdesc as Perfil_Colegio, "& vbCrLf &_
'						" c.cole_tdesc as Colegio,isnull(b.ciud_tcomuna,d.ciud_tcomuna) as Ciudad ,isnull(b.ciud_tdesc,d.ciud_tdesc) as Comuna "& vbCrLf &_
'						" from eventos_upa a, ciudades b, colegios c, ciudades d,perfil_colegio e "& vbCrLf &_
'						" where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'						" and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'						" and c.ciud_ccod=d.ciud_ccod "& vbCrLf &_
'						" and a.pcol_ccod=e.pcol_ccod "& vbCrLf &_
'						" and a.teve_ccod not in (8)  "& vbCrLf &_
'						" and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'						" "&sql_adicional&"  "& vbCrLf &_
'						" order by convert(datetime,a.even_fevento,103) asc "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos = "select even_ncorr,  "& vbCrLf &_
"       protic.trunc(a.even_fevento)           as fecha,  "& vbCrLf &_
"       e.pcol_tdesc                           as perfil_colegio,  "& vbCrLf &_
"       c.cole_tdesc                           as colegio,  "& vbCrLf &_
"       isnull(b.ciud_tcomuna, d.ciud_tcomuna) as ciudad,  "& vbCrLf &_
"       isnull(b.ciud_tdesc, d.ciud_tdesc)     as comuna  "& vbCrLf &_
"from   eventos_upa as a  "& vbCrLf &_
"       left outer join ciudades as b  "& vbCrLf &_
"                    on a.ciud_ccod_origen = b.ciud_ccod  "& vbCrLf &_   
"       join colegios as c  "& vbCrLf &_
"         on a.cole_ccod = c.cole_ccod  "& vbCrLf &_   
"       join ciudades as d  "& vbCrLf &_
"         on c.ciud_ccod = d.ciud_ccod  "& vbCrLf &_   
"       join perfil_colegio as e  "& vbCrLf &_
"         on a.pcol_ccod = e.pcol_ccod  "& vbCrLf &_   
"where  a.teve_ccod not in ( 8 )  "& vbCrLf &_
"      -- and datepart(year, a.even_fevento) = datepart(year, getdate())  "& vbCrLf &_
""&sql_adicional&"  "& vbCrLf &_ 
"order  by convert(datetime, a.even_fevento, 103) asc "
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)
	end if

	if v_tiop_ccod ="2" then
'		sql_datos_eventos= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d , carreras_eventos e "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_									
'							" and carre_ccod_1= e.carre_ccod "& vbCrLf &_
'							" --and carrera_1 not in ('') "& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc  "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos = " select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_1 = e.carre_ccod "& vbCrLf &_   
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                        where  1=1 --datepart(year, a.even_fevento) =datepart(year, getdate()) "& vbCrLf &_
"                       "&sql_adicional&" "& vbCrLf &_
"                       ) "& vbCrLf &_
"--and carrera_1 not in ('') "& vbCrLf &_
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "	  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)

'		sql_datos_eventos2= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d, carreras_eventos e  "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_											
'							" and carre_ccod_2= e.carre_ccod"& vbCrLf &_
'							" --and carrera_2 not in ('') "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc  "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos2= "select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_2 = e.carre_ccod--se agregó a. "& vbCrLf &_   
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_ 
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                                   -- and datepart(year, a.even_fevento) = datepart(year, getdate()) "& vbCrLf &_
"                       "&sql_adicional&" "& vbCrLf &_
"                       ) "& vbCrLf &_
"--and carrera_2 not in ('') "& vbCrLf &_  
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "		  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)

'		sql_datos_eventos3= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d, carreras_eventos e  "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_											
'							" and carre_ccod_3= e.carre_ccod "& vbCrLf &_
'							" --and carrera_3 not in ('') "& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc  "

'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos3= "select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_ 
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_   
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_    
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_     
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_3 = e.carre_ccod--se agrega a. "& vbCrLf &_   
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                        where  1=1 --datepart(year, a.even_fevento) =  datepart(year, getdate()) "& vbCrLf &_
"                       "&sql_adicional&" "& vbCrLf &_ 
"                       ) "& vbCrLf &_
"--and carrera_3 not in ('') "& vbCrLf &_  
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "		  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)

	formulario2.consultar sql_datos_eventos2
	formulario3.consultar sql_datos_eventos3
	end if

else
	formulario.carga_parametros "perfiles_colegios.xml", "datos_colegios"
	formulario.inicializar conectar
	sql_datos_eventos="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&sql_datos_eventos&"</pre>")
'response.Write("<hr><pre>"&sql_datos_eventos2&"</pre>")
'response.Write("<hr><pre>"&sql_datos_eventos3&"</pre>")
'response.End()				 


formulario.consultar sql_datos_eventos


%>


<html>
<head>
<title>Reporte Eventos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">



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
			<table cellspacing="0"  cellpadding="0" >
			<form name="buscador">
				<tr>
					<td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
					<td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
					<td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              	</tr>
				<tr>
					<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
								<td width="209" valign="middle" background="../imagenes/fondo1.gif"><div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Filtro de busqueda</font></div></td>
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
				<tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
				  <td bgcolor="#D8D8DE">				  
<table width="100%" >
                    <tr>
                      <td width="17%"><strong>Opcion Reporte</strong></td>
                      <td width="2%"><strong>:</strong></td>
                      <td width="20%">
                        <%f_busqueda.dibujaCampo("tiop_ccod")%></td>
                      <td width="12%"><strong> Con perfil </strong></td>
                      <td width="2%"><strong>:</strong></td>
                      <td width="30%"><%f_busqueda.dibujaCampo("pcol_ccod")%></td>
                      <td width="17%" rowspan="4" align="right"><%botonera.DibujaBoton "buscar_perfiles"%></td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><strong> Desde </strong></td>
                      <td><strong>:</strong></td>
                      <td>
                        <%f_busqueda.dibujaCampo("even_fevento")%>
                        (dd/mm/aaaa)</td>
                      <td><strong> Hasta</strong></td>
                      <td><strong>:</strong></td>
                      <td><%f_busqueda.dibujaCampo("fecha_termino")%>
                        (dd/mm/aaaa)</td>
                      </tr>
                  </table></td>
				  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				<tr>
                	<td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                  	<td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                	<td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              	</tr> 
			  </form>
			</table>

			</td>
		</tr>
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">R</font><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">eporte
                          de alumnos por eventos </font></div></td>
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
                      </font>
                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
                      <table width="100%" border="0">
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="right"><strong><font color="000000" size="1"> 
                            <% formulario.pagina%></font></strong>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                            <% formulario.accesoPagina%>
                            </td>
                        </tr>
                        <tr> 
                          <td align="center"><strong><font color="000000" size="1"> 
							<%	if v_tiop_ccod ="1" then
							 		formulario.dibujaTabla
								end if
								if v_tiop_ccod ="2" then%>
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr height="10">
									<td bgcolor="#FF0000"><b>Primera Opcion</b></td>
									<td bgcolor="#FFCC00"><b>Segunda Opcion</b></td>
									<td bgcolor="#00FF00"><b>Tercera Opcion</b></td>
								</tr>
								<tr valign="top">
									<td> <% formulario.dibujaTabla%></td>
									<td> <% formulario2.dibujaTabla%></td>
									<td> <% formulario3.dibujaTabla%></td>
								</tr>
							</table>
                           
							<%end if%>
                            </font></strong></td>
                        </tr>
                        <tr>
                              <td align="right">&nbsp; </td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="100%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td>
<%
if v_tiop_ccod ="1" then
	botonera.AgregaBotonParam "excel", "url", "reporte_colegios_excel.asp"
end if
if v_tiop_ccod ="2" then
	botonera.AgregaBotonParam "excel", "url", "reporte_preferencia_excel.asp"
end if
%>

<%botonera.dibujaboton "excel"%></td>
                    </tr>
                  </table>                    
                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
