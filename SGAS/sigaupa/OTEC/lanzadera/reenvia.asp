<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conectar = new cConexion
conectar.Inicializar "upacifico"

smod_ccod = request.QueryString("smod_ccod")
sfun_ccod = request.QueryString("sfun_ccod")
sede_ccod = request.QueryString("sede_ccod")
peri_ccod = request.QueryString("peri_ccod")
tape_ccod =  request.QueryString("tape_ccod")

nombre_actividad = conectar.consultauno("select tape_tactividad from tipos_actividades_periodos where tape_ccod = '"&tape_ccod&"'")
Session("sede") = sede_ccod
Session("_periodo_"&nombre_actividad) = peri_ccod

Session("_actividad") = tape_ccod
Session("_periodo") = peri_ccod
Session("_nombreActividad") = nombre_actividad
Session("_nombrePeriodo") = conectar.consultauno("select peri_tdesc from periodos_academicos where peri_ccod='"&peri_ccod&"'")

link = conectar.ConsultaUno("select sfun_link from sis_funciones_modulos where smod_ccod ='" & smod_ccod & "' and sfun_ccod = '" & sfun_ccod & "' ")  

response.redirect(link)


%>

