<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Nueva repactación"
rut_unido=request.Form("rut")
if rut_unido ="" then
	rut_unido=request.QueryString("rut")
end if
v_rut_final=split(rut_unido,"-")
v_rut_alumno=v_rut_final(0)
v_rut_xdv=v_rut_final(1)

'response.Write("<br>rut="&v_rut_alumno&"-->"&v_rut_xdv&"<br>")
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


v_ingreso=request.QueryString("ingreso")
'response.Write("ingreso "&v_ingreso)
if not esVacio(v_ingreso) then
    pers_ncorr_01=conexion.consultaUno("Select pers_ncorr from ingresos where cast(ingr_ncorr as varchar)='"&v_ingreso&"'")
	v_pers_nrut_01=conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_01&"'")
	v_pers_xdv_01=conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_01&"'")
else
	v_ingreso=0
end if



set negocio = new CNegocio
negocio.Inicializa conexion
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
v_caja_ncorr = cajero.ObtenerCajaAbierta
'---------------------------------------------------------------------------------------------------
'response.Write("<center><strong><HR>PAGINA EN CONSTRUCCION<HR></strong></center>")
set variable = new cVariables
variable.procesaForm
contador=0
if esVacio(v_ingreso) or v_ingreso=0 then
suma=0

if  variable.nrofilas("CC_COMPROMISOS_PENDIENTES") <> 0 then
	for i=0 to variable.nrofilas("CC_COMPROMISOS_PENDIENTES")-1
			if variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"DCOM_NCOMPROMISO") <> "" then
				tcom_ccod = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"tcom_ccod")
				inst_ccod = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"inst_ccod")
				comp_ndocto = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"comp_ndocto")
				dcom_ncompromiso = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"dcom_ncompromiso")
				dcom_mcompromiso = conexion.consultauno("select dcom_mcompromiso from detalle_compromisos where tcom_ccod = '"&tcom_ccod&"' and inst_ccod = '"&inst_ccod&"' and comp_ndocto = '"&comp_ndocto&"' and dcom_ncompromiso = '"&dcom_ncompromiso&"'")
				'response.Write("<br>tcom_ccod="&tcom_ccod&" inst_ccod="&inst_ccod&" comp_ndocto="&comp_ndocto&" dcom_ncompromiso="&dcom_ncompromiso&" dcom_mcompromiso="&dcom_mcompromiso)
				suma = suma + conexion.ConsultaUno("select cast(protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") as varchar)")
				'response.Write("<br>Total Acumulado "&suma)
				ingr_ncorr=conexion.consultaUno("Select ingr_ncorr from abonos where cast(comp_ndocto as varchar)='"&comp_ndocto&"' and cast(tcom_ccod as varchar)='"&tcom_ccod&"' and cast(dcom_ncompromiso as varchar)='"&dcom_ncompromiso&"'")
'				response.Write("Select ingr_ncorr from abonos where cast(comp_ndocto as varchar)='"&comp_ndocto&"' and cast(tcom_ccod as varchar)='"&tcom_ccod&"' and cast(dcom_ncompromiso as varchar)='"&dcom_ncompromiso&"'")
                if esVacio(ingr_ncorr) then
				    contador= contador + 1
'				    response.Write("===><font color='#FF0000'>Se deben crear registros en Ingresos, abonos y Detalle_ingresos</font> ")
                    'response.Write("Select pers_ncorr from compromisos where cast(comp_ndocto as varchar)='"&comp_ndocto&"' and cast(tcom_ccod as varchar)='"&tcom_ccod&"' and cast(dcom_ncompromiso as varchar)='"&dcom_ncompromiso&"'")
					v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from compromisos where cast(comp_ndocto as varchar)='"&comp_ndocto&"' and cast(tcom_ccod as varchar)='"&tcom_ccod&"'")
					'response.Write(" pers_ncorr= "&v_pers_ncorr)
					'response.End()
					v_pers_nrut_01=conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
					v_pers_xdv_01=conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
'					response.Write("<br>-Insertamos en Ingresos")
					'obtener la secuencia de ingresos, pues debe ser un ingreso nuevo

' ############################################################################################
' ##############################			INGRESOS		##################################

					v_ingr_ncorr=conexion.consultaUno("execute obtenerSecuencia 'ingresos'")
					'obtener la secuencia del folio de referencia
					v_ingr_nfolio_referencia=conexion.consultaUno("execute obtenerSecuencia 'ingresos_referencia'")
					'se debe obtener la caja abierta para hacer el ingreso
					'el estado ingreso debe ser documentado vale decir cone eing_ccod=4
					v_eing_ccod=4
					'los campos  ingr_mefectivo, ingr_mdocto deben llevar cero pues no se ha hecho ningún ingreso o pago antes
					'ingr_mtotal debe contener el valor del compromiso vale decir lo que almacena la variable dcom_mcompromiso
					' el tipo de ingreso debe representar a un comprobante de ingreso por ende el ting_ccod=16
					v_ting_ccod=16
					v_audi_tusuario="INGRESO_A_REPACTAR"
					ingresos=" INSERT INTO INGRESOS (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal,"&_
					         " ting_ccod, ingr_nfolio_referencia, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr)"&_
		                     " VALUES ("&v_ingr_ncorr&", "&v_caja_ncorr&","&v_eing_ccod&", getdate(),0,0,"&dcom_mcompromiso&","&v_ting_ccod&","&v_ingr_nfolio_referencia&"," &_
							 "'"&v_audi_tusuario&"', getdate(), "&inst_ccod&","&v_pers_ncorr&")"

					conexion.EstadoTransaccion conexion.EjecutaS(ingresos)
'					response.Write("<br>Ingresos:- <pre>"&ingresos&"</pre>")
'					response.Write(conexion.ObtenerEstadoTransaccion)	

' ############################################################################################
' ##############################			ABONOS			##################################
					
					'creamos ahora el registro en la tabla abonos
'					response.Write("<br>- Insertamos Abonos")
					'el tcom_ccod debe ser el mismo que trae de la pantalla anterior pa mantener la verasidad de los cambios
					'debemos sacar el dcom_ncompromiso de la tabla detalle_compromisos puede deben coincidir
					v_dcom_ncompromiso=conexion.consultaUno("Select dcom_ncompromiso from detalle_compromisos where cast(comp_ndocto as varchar)='"&comp_ndocto&"'")
					'abon_mabono vale decir lo que se va a abonar debe ser cero para no alterar la información del compromiso
					'el peri_ccod debe ser el del periodo actulmente vigente por tanto
					v_peri_ccod=negocio.obtenerPeriodoAcademico("CLASES18")
					v_peri_ccod_postulacion=negocio.obtenerPeriodoAcademico("Postulacion")
					abonos=" INSERT INTO ABONOS (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod)"&_
		                   "VALUES ("&v_ingr_ncorr&","&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&v_dcom_ncompromiso&", getdate(),"&dcom_mcompromiso&","&_
						   "'"&v_audi_tusuario&"', getdate(),"&v_pers_ncorr&","&v_peri_ccod&")"

					conexion.EstadoTransaccion conexion.EjecutaS(abonos)
'					response.Write("<br>Abonos:-   <pre>"&abonos&"</pre>")
'					response.Write(conexion.ObtenerEstadoTransaccion)					

' ############################################################################################
' ##############################		DETALLE_INGRESOS	##################################
					'EL NUMERO DE SECUENCIA ES EL MISMO NUMERO DEL DOCTO
					v_ding_ndocto = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					'el tipo de ingreso en esta tabla corresponde al detalle que en este caso lo dejaremos como DOCUMENTACION COMPROMISOS ting_ccod=53

					v_ting_ccod=53
					v_pers_ncorr_codeudor=conexion.consultaUno("Select b.pers_ncorr from postulantes a, codeudor_postulacion b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(a.peri_ccod as varchar)='"&v_peri_ccod_postulacion&"' and a.post_ncorr=b.post_ncorr")
					if Esvacio(v_pers_ncorr_codeudor) or v_pers_ncorr_codeudor="" then
					v_pers_ncorr_codeudor="null"
					end if
'					response.Write("Select b.pers_ncorr from postulantes a, codeudor_postulacion b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(a.peri_ccod as varchar)='"&v_peri_ccod_postulacion&"' and a.post_ncorr=b.post_ncorr")
					detalle_ingresos=" INSERT INTO DETALLE_INGRESOS(ting_ccod, ding_ndocto, ingr_ncorr, ding_nsecuencia, ding_ncorrelativo, plaz_ccod, banc_ccod,"&_
					                 " ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, audi_tusuario, audi_fmodificacion, edin_ccod,"&_
									 " ding_bpacta_cuota, pers_ncorr_codeudor)"&_
			                         " VALUES ("&v_ting_ccod&","&v_ding_ndocto&","&v_ingr_ncorr&","&v_ding_ndocto&", 1,null,null,"&_
									 " getDate(),"&dcom_mcompromiso&", "&dcom_mcompromiso&",null, '"&v_audi_tusuario&"', getdate(), 1, 'S',"&v_pers_ncorr_codeudor&")"
					conexion.EstadoTransaccion conexion.EjecutaS(detalle_ingresos)
                   'response.Write("<br>Detalle:-  <pre>"&detalle_ingresos&"</pre>")
					'response.Write(conexion.ObtenerEstadoTransaccion)

				  else
'				    response.Write(" ingr_ncorr="&ingr_ncorr)
				  end if		
		    end if
			
	next
end if
else

'response.Write("Debemos borrar el registro repetido")
borrar_detalle_ingresos="Delete from detalle_ingresos where cast(ingr_ncorr as varchar)='"&v_ingreso&"'"
borrar_abonos="Delete from abonos where cast(ingr_ncorr as varchar)='"&v_ingreso&"'"
borrar_ingresos="Delete from ingresos where cast(ingr_ncorr as varchar)='"&v_ingreso&"'"
'response.Write(borrar_detalle_ingresos)
conexion.EstadoTransaccion conexion.EjecutaS(borrar_detalle_ingresos)
'response.Write(borrar_abonos)
conexion.EstadoTransaccion conexion.EjecutaS(borrar_abonos)
'response.Write(borrar_ingresos)
conexion.EstadoTransaccion conexion.EjecutaS(borrar_ingresos)
end if

'response.Write("contador= "&contador)
if esVacio(v_ingr_ncorr)then
	v_ingr_ncorr=0
end if
if esVacio(v_pers_nrut_01) and esVacio(v_pers_xdv_01) then
'	response.Write("entre acá")
	v_pers_nrut_01=0
	v_pers_xdv_01=0
end if
'response.Write(conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
var ingr=<%=v_ingreso%>;
var rut;
var xdv;
var ingreso;
rut=<%=v_rut_alumno%>;
xdv=<%=v_rut_xdv%>;
contador=<%=contador%>;
rut_completo=rut+"-"+xdv;

//alert("ingreso "+ingr+"Contador: "+contador);
if (((ingr==null)||(ingr==0))&&(contador > 0))
{	if (confirm("Desea realizar una repactación para este cargo?")) {
		window.close();
		opener.location="../FINANZAS/REPACTACIONES.ASP?buscador[0][pers_nrut]="+rut+"&buscador[0][pers_xdv]="+xdv;
	}
	else {
		ingreso=<%=v_ingr_ncorr%>;
		window.location="agregar_repactacion.asp?ingreso="+ingreso+"&rut="+rut_completo
	} 
}
else
{ 
	alert("Este compromiso no puede ser pagado por repactación ya que posee ingresos realizados");
  	window.close();
 }
</script>
