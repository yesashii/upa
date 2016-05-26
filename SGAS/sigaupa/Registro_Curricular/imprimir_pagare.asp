<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->

<%
set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion


'------------------------------------------------------------------------------------------------
post_ncorr = Request.QueryString("post_ncorr")
'impresora  = request.querystring("impresora") 
impresora  = "\\protic-1\AppleLaser" 
'-------------------------------------------------------------
  function Ac(texto,ancho,alineado)
    largo =Len(Trim(texto))
	if isnull(largo) then largo=0
	if largo > ancho then largo=ancho
    if ucase(alineado) = "D" then 
	   Ac=space(ancho-largo)&Left(texto,largo)
	else
	   Ac=Left(texto,cint(largo))&space(ancho-largo)
	end if   
  end function
'-----------------------------------------------------------------


'------------------------------------------------------------------------------------------------------
set f_detalle = new CFormulario
		f_detalle.Carga_Parametros "genera_contrato_4.xml", "imprimir_pagare"
		f_detalle.Inicializar conexion
		
		
					
		consulta = " select pag.PAGA_NCORR nro_pagare,(nvl(bba.BENE_MMONTO_MATRICULA,0) + nvl(bba.BENE_MMONTO_COLEGIATURA,0)) as valor_pagar,  "&_
			" to_char(sysdate, 'DD') dd_hoy,  "&_
			 " to_char(sysdate, 'MONTH') mm_hoy,to_char(sysdate, 'YYYY') yy_hoy,   "&_
			 " pac.anos_ccod periodo_academico,  "&_
			 " (pac.anos_ccod  + 1) as inicio_vencimiento,  "&_
			 " (pac.anos_ccod  + 2) as final_vencimiento,  "&_
			 " pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post,  "&_
			"  pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno nombre_alumno,  "&_
			"  cc.carr_tdesc as carrera,  "&_
		
			 " ppc.PERS_NRUT ||'-'||ppc.PERS_XDV as rut_codeudor,   "&_
			 " ppc.pers_tnombre ||' '|| ppc.pers_tape_paterno || ' ' || ppc.pers_tape_materno  as nombre_codeudor,  "&_
			 " ddc.DIRE_TCALLE ||' ' || ddc.DIRE_TNRO as direccion_codeudor,  "&_
			"  c.CIUD_TDESC ciudad_codeudor,  "&_
			"  ddp.DIRE_TCALLE ||' ' || ddp.DIRE_TNRO as direccion_postulante,  "&_
			"  ccp.CIUD_TDESC ciudad_postulante  "&_
			"  from postulantes p,personas_postulante pp,  "&_
			"  personas_postulante ppc,ofertas_academicas oa,   "&_
			 " especialidades ee, carreras cc,   "&_
			 " codeudor_postulacion cp,  "&_

			 " direcciones_publica ddp, ciudades c,ciudades ccp,  "&_
			"  direcciones_publica ddc,periodos_academicos pac,  "&_
        
			 " beneficios bba,  "&_
			 " contratos con, pagares pag  "&_
			 " where p.pers_ncorr=pp.pers_ncorr   "&_
			 " and p.post_ncorr=   nvl('"& post_ncorr & "',0) "&_
		
			 " and con.post_ncorr=p.post_ncorr   "&_
			 " and con.CONT_NCORR=pag.CONT_NCORR   "&_
			 " and pag.PAGA_NCORR=bba.PAGA_NCORR   "&_
 		
 		
			"  and bba.EBEN_CCOD <>3   "&_
			 " and con.econ_ccod<>3   "&_
		
			"  and p.post_ncorr=cp.post_ncorr  "&_
			"  and cp.pers_ncorr =ppc.pers_ncorr   "&_
		
			 " and ppc.pers_ncorr = ddc.pers_ncorr  "&_
			 " and ddc.tdir_ccod=1  "&_
			"  and ddc.ciud_ccod=c.ciud_ccod (+)  "&_
		
		
			"  and pp.pers_ncorr = ddp.pers_ncorr  "&_
			"  and ddp.tdir_ccod=1  "&_
			"  and ddp.ciud_ccod=ccp.ciud_ccod (+)  "&_
		
			"  and p.ofer_ncorr=oa.ofer_ncorr   "&_
			"  and oa.peri_ccod=pac.peri_ccod   "&_
			"  and oa.espe_ccod=ee.espe_ccod   "&_
			"  and ee.carr_ccod=cc.carr_ccod "
				
		f_detalle.Consultar consulta
		'response.Write(contador_fila)
		f_detalle.siguiente


'---------------------------------------------------------------


   'nro_letras= Traduce_numero(f_detalle.obtenerValor("monto"),2)
   'nro_letras= "DOCE MILLONES TRECIENTOS TREINTA Y TRES MIL DOCIENTOS NOVENTA Y NUEVE" 
   
   largoNombre = Len(f_detalle.obtenerValor("nombre_alumno")) + 2
   'largoNroLetras = Len(nro_letras)
   'if (largoNroLetras >=60) then 
    '   SegundoLargo = largoNroLetras - 60
    '   ver_nro_letras =  Ac(nro_letras,60,"I") & chr(13) & chr(10) & Ac(Right(nro_letras,SegundoLargo),SegundoLargo,"D")
	'else 
	'    ver_nro_letras = Ac(nro_letras,largoNroLetras,"I")   
	'end if   
   archivo = archivo & chr(13) 
   archivo = archivo & chr(13) 
   archivo = archivo & chr(13) 
   	
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)  
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)  
   archivo = archivo & chr(13) & chr(10) 
    archivo = archivo & chr(13) & chr(10) 
   
   archivo = archivo & chr(13) & chr(10) &  space(18) & Ac(f_detalle.obtenerValor("dd_hoy"),3,"D") &  space(8) & Ac(f_detalle.obtenerValor("mm_hoy"),10,"D") &  space(15) & Ac(f_detalle.obtenerValor("yy_hoy"),4,"D") 
  archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) &  space(14) & Ac(f_detalle.obtenerValor("nombre_alumno"),40,"I")
   archivo = archivo & space(18) & Ac(f_detalle.obtenerValor("rut_post"),12,"I")
   archivo = archivo & chr(13) & chr(10) 
   
   archivo = archivo  & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & space(28) & Ac(f_detalle.obtenerValor("valor_pagar"),12,"I")
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & space(48) & Ac(f_detalle.obtenerValor("carrera"),50,"I")
   archivo = archivo & space(51) & Ac(f_detalle.obtenerValor("periodo_academico"),4,"I")
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) & space(76) & Ac("30 de Marzo de " & f_detalle.obtenerValor("inicio_vencimiento"),30,"I")
   archivo = archivo & chr(13) & chr(10) & space(22) & Ac("28 de Febrero de " & f_detalle.obtenerValor("final_vencimiento"),22,"D")
   archivo = archivo & chr(13) & chr(10) 
      archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
      archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("nombre_alumno"),40,"I")
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   
   
  
   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("direccion_postulante"),40,"I")  & space(12) & Ac(f_detalle.obtenerValor("rut_post"),20,"I") 
   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("ciudad_postulante"),40,"I")		
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)

   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("nombre_codeudor"),40,"I")
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10) 
   archivo = archivo & chr(13) & chr(10)

  
   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("direccion_codeudor"),40,"I")& space(12) & Ac(f_detalle.obtenerValor("rut_codeudor"),20,"I") 
   archivo = archivo & chr(13) & chr(10) & space(10) & Ac(f_detalle.obtenerValor("ciudad_codeudor"),40,"I")	
'----------------------------------------------------------------------				

   response.Write("<pre>"& archivo & "</pre>")
   response.End()
   Set oFile      = CreateObject("Scripting.FileSystemObject")
   Set oPrinter   = oFile.CreateTextFile(impresora) 
   
   oPrinter.write(archivo)
 
   Set oWshnet    = Nothing
   Set oFile      = Nothing
   set oPrinter   = Nothing
   set iPrinter   = Nothing 
 
   'response.Redirect(request.ServerVariables("HTTP_REFERER"))

   
'---------------------------------------------------------------------------------				
%>

