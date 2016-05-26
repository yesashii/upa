<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:19/08/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ENCUESTAS
'LINEA			:33 - 49 - 73
'*******************************************************************
 Session.Contents.RemoveAll()
'-----------------------------------------------------------
rut = request("datos[0][pers_nrut]")
dv = request("datos[0][pers_xdv]")

'response.Write(rut)
'response.Write("<br/>"&dv)

set conexion = new CConexion
conexion.Inicializar "upacifico"

slt_existe= " select case count(*) when 0 then 'N' else 'S' end from titulados_egresados_rrpp "&_
		 " where cast(pers_nrut as varchar)='"&rut&"' "
		 
'slt_contensto=" select case count(*) when 0 then 'N' else 'S' end from encuesta_rr_pp "&_
'		 " where cast(pers_nrut as varchar)='"&rut&"' "	
		 
slt_contensto=" select case count(*) when 0 then 'N' else 'S' end from encuesta_rr_pp_02 "&_
		 " where cast(pers_nrut as varchar)='"&rut&"' "	

'RESPONSE.WRITE("1. slt_existe : "&slt_existe&"<BR>")
'RESPONSE.WRITE("2. slt_contensto : "&slt_contensto&"<BR>")

contesto=conexion.consultaUno(slt_contensto)		  
existe = conexion.consultaUno(slt_existe)	

'pagina2=conexion.consultaUno("select case when preg_10 is null then 'N'else 'S' end from encuesta_rr_pp where pers_nrut="&rut&" ")
'pagina3=conexion.consultaUno("select case when preg_27 is null then 'N'else 'S' end from encuesta_rr_pp where pers_nrut="&rut&" ")
'pagina4=conexion.consultaUno("select case when preg_30 is null then 'N'else 'S' end from encuesta_rr_pp where pers_nrut="&rut&" ")

pagina1=conexion.consultaUno("select case when preg_1 is null then 'N'else 'S' end from encuesta_rr_pp_02 where pers_nrut="&rut&" ")
pagina2=conexion.consultaUno("select case when preg_10 is null then 'N'else 'S' end from encuesta_rr_pp_02 where pers_nrut="&rut&" ")
pagina3=conexion.consultaUno("select case when preg_27 is null then 'N'else 'S' end from encuesta_rr_pp_02 where pers_nrut="&rut&" ")
pagina4=conexion.consultaUno("select case when preg_30 is null then 'N'else 'S' end from encuesta_rr_pp_02 where pers_nrut="&rut&" ")

'response.Write(" pagina1="&pagina1&"<BR>")
'response.Write(" pagina2="&pagina2&"<BR>")
'response.Write(" pagina3="&pagina3&"<BR>")
'response.Write(" pagina4="&pagina4&"<BR>")
'response.end()

if existe <> "N" and rut <> "" then

		'############################################################################################
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)

			if contesto = "N"  then	
	   		session("rut_usuario") = RUT	
			'response.Write("<br/>"&"1")
	   		response.Redirect("encuesta.asp")
			
			else

				if pagina1="N" then
				session("rut_usuario") = RUT
				response.Redirect("encuesta2.asp") 
				end if

				if pagina2="N" then
				session("rut_usuario") = RUT
				 response.Redirect("encuesta_parte2.asp") 
				end if
				
				if pagina3="N" and pagina2="S" then
				session("rut_usuario") = RUT
				response.Redirect("encuesta_parte3.asp") 
				end if

				if pagina4="N" and pagina3="S" and pagina2="S" then
				session("rut_usuario") = RUT
				response.Redirect("encuesta_parte4.asp") 	 
				end if

				if pagina4="S" and pagina3="S" and pagina2="S" then
				session("mensajeerror")= "Tu Ya has respondido la encuesta"
				response.Redirect("portada_encuesta.asp") 
				'response.Write("<br/>"&"2")
				end if
			
			end if
else
	   		session("mensajeerror")= "El rut ingresado no pertenece a un egresado de Relaciones Publicas"
		    response.Redirect("portada_encuesta.asp")
			'response.Write("<br/>"&"3")
end if
 
 %>