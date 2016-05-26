<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod= negocio.obtenerSede

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

v_duplica=request.Form("duplica")

set formulario = new CFormulario
formulario.Carga_Parametros "boletas_venta.xml", "f_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_bole_ncorr		= formulario.ObtenerValorPost (fila, "bole_ncorr")
   v_bole_nboleta	= formulario.ObtenerValorPost (fila, "bole_nboleta")
   v_tbol_ccod		= formulario.ObtenerValorPost (fila, "c_tbol_ccod")
   v_ebol_ccod		= formulario.ObtenerValorPost (fila, "ebol_ccod")

   if v_bole_ncorr <> "" and v_bole_nboleta <> "" then
		
		formulario.AgregaCampoFilaPost fila, "ebol_ccod", "3"
		
		sql_consulta_rango 	=	"Select count(*) as pertenece "& vbCrLf &_ 
								" from rangos_boletas_sedes "& vbCrLf &_ 
								" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
								" and "&v_bole_nboleta&" between rbol_ninicio and rbol_nfin "& vbCrLf &_
								" order by pertenece "
	
		v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
		
v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros	
		if v_pertenece_rango = "1" then
			sql_boleta_existe=	"select count(bole_nboleta) from boletas where sede_ccod="&sede_ccod&" and tbol_ccod="&v_tbol_ccod&" and bole_nboleta="&v_bole_nboleta&" And bole_ncorr <> "&v_bole_ncorr
			v_boleta_existe	=	conexion.consultaUno(sql_boleta_existe)
			'response.Write("<hr>"&sql_boleta_existe&"<hr>")
			
			if v_boleta_existe >="1" then
					'response.Write("<hr>entre<hr>")
					conexion.EstadoTransaccion false
					session("mensajeError")="el numero ingresado para la boleta ya existe"
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if

			
			if v_ebol_ccod<>"4" and v_duplica = "SI" then
				
				v_nuevo_bole_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'boletas'")  

					  
'********************************************************************************************			
'  Obtiene el numero actual de la boleta, para asignarla al nuevo registro
						sql_nuevo_numero="  select isnull(rbca_nactual,rbca_ninicio) as num "& vbCrLf &_ 
										" from rangos_boletas_cajeros "& vbCrLf &_ 
										" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
										" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
										" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
										" and erbo_ccod=1"
					
						'response.Write("<pre>"&sql_nuevo_numero&"</pre>")
						v_nuevo_numero=conexion.ConsultaUno(sql_nuevo_numero)

						if Esvacio(v_nuevo_numero) then
							v_nuevo_numero="null"
						end if

'********************************************************************************************			
'  Inserta nuevo registro para una boleta 
					
					sql_inserta_boleta= "Insert into boletas  "& vbCrLf &_ 
							"select  "&v_nuevo_bole_ncorr&" as bole_ncorr,"&v_nuevo_numero&" as bole_nboleta,ebol_ccod,tbol_ccod,bole_mtotal,bole_fboleta, "& vbCrLf &_ 
							"ingr_nfolio_referencia,sede_ccod, pers_ncorr, pers_ncorr_aval,mcaj_ncorr,"& vbCrLf &_ 
							"audi_tusuario,audi_fmodificacion, inst_ccod from boletas where bole_ncorr="&v_bole_ncorr
			
					'response.Write("<pre>"&sql_inserta_boleta&"</pre>")
					conexion.EjecutaS(sql_inserta_boleta)

					' inserta detalle
					sql_inserta_detalle_boleta= "Insert into detalle_boletas  "& vbCrLf &_ 
												"select  "&v_nuevo_bole_ncorr&" as bole_ncorr,tdet_ccod,dbol_miva,dbol_mtotal,"& vbCrLf &_ 
												"audi_tusuario,audi_fmodificacion from detalle_boletas where bole_ncorr="&v_bole_ncorr
			
					'response.Write("<pre>"&sql_inserta_detalle_boleta&"</pre>")
					conexion.EjecutaS(sql_inserta_detalle_boleta)


'********************************************************************************************
				if v_nuevo_numero<>"null"  then
					' Actualiza el numero de boleta
					v_nuevo_numero=Clng(v_nuevo_numero) + 1
					sql_actualiza_numero=" Update rangos_boletas_cajeros set rbca_nactual="&v_nuevo_numero&"  "& vbCrLf &_ 
											" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
											" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
											" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
											" and erbo_ccod=1"
					'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
					conexion.EjecutaS(sql_actualiza_numero)
				end if							
			end if
'********************************************************************************************

		else
			conexion.EstadoTransaccion false
			session("mensajeError")="el numero de boleta ingresado, no esta dentro del rango permitido para su sede."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
											
   end if
next

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>