alter PROCEDURE TRASPASAR_CAJA_SOLFTLAND_ANULACION (
@p_mcaj_ncorr numeric,
@p_audi_tusuario varchar(50) 
) 
AS
BEGIN
    if @p_audi_tusuario=''
        begin
            set  @p_audi_tusuario= 'TRASPASAR_CAJA_SOLFTLAND'
        end


declare @v_tipo_caja varchar(10)  
   
--********* OBTIENE EL TIPO DE CAJA A TRASPASAR *************************************
select @v_tipo_caja=tcaj_ccod from movimientos_cajas  where mcaj_ncorr=@p_mcaj_ncorr
print 'tipo caja :'+cast(@v_tipo_caja as varchar)
-------------------------------------------------------------------------------------

--*****************************		encabezado		***************************


------  VARIABLE LOCALES ---------------------------
declare @v_nlinea numeric
declare @v_trca_mdebe numeric
declare @v_trca_mhaber numeric
declare @v_trca_tglosa varchar(100)
declare @v_carr_ccod varchar(3)
declare @v_sede numeric
declare @v_jornada numeric 
declare @v_carrera numeric
declare @v_jornada_text char(1)
declare @v_tipo_compromiso numeric
declare @v_tipo_detalle numeric
declare @v_hace_efe varchar(2)

-------------------------------------------
-------VARIABLES DEL CURSOR C_INGRESOS -----
declare @r_mcaj_ncorr int
declare @r_ting_ccod int
declare @r_ingr_nfolio_referencia numeric
declare @r_pers_ncorr int
declare @r_caje_ccod int 
declare @r_sede_ccod int
declare @r_pers_nrut varchar(10) 
declare @r_pers_xdv char(1)
declare @r_pers_nrut_c varchar(10) 
declare @r_pers_xdv_c char(1)  
declare @r_ting_tdesc varchar(100)
declare @r_monto numeric
declare @r_finicio datetime

------------   agregadas al cursor    ------
declare @r_nombre_a varchar(100)
declare @r_paterno_a varchar(100)
declare @r_materno_a varchar(100)
declare @r_fono_a varchar(100)
declare @r_direccion_a varchar(100)
declare @r_comuna_a varchar(100)
declare @r_ciudad_a varchar(100)
declare @r_nombre_c varchar(100)
declare @r_paterno_c varchar(100)
declare @r_materno_c varchar(100)
declare @r_fono_c varchar(100)
declare @r_direccion_c varchar(100)
declare @r_comuna_c varchar(100)
declare @r_ciudad_c varchar(100)
------------------------------------------



------------------------------------------
-------  VARIABLES DEL CURSOR C_DEBE  -----
declare @rd_ingr_ncorr int
declare @rd_tcom_tdesc varchar(100)
declare @rd_comp_ndocto varchar(100)
declare @rd_abon_mabono numeric
declare @rd_ding_ndocto numeric
declare @rd_ingr_fpago datetime
declare @rd_ting_ccod numeric
declare @rd_post_ncorr numeric
declare @rd_tipo_detalle numeric
declare @rd_numero_doc numeric
declare @rd_banco_pacta numeric
declare @rd_fecha_pacta datetime
declare @rd_documento numeric
declare @rd_tcom_ccod numeric
declare @rd_tipo_tarjeta varchar(2)
declare @rd_num_fox numeric
------------------------------------------

-------  VARIABLES DEL CURSOR C_HABER  -----
declare @rh_ingr_ncorr int 
declare @rh_ting_tdesc  varchar(100)
declare @rh_ding_ndocto  varchar(100)
declare @rh_ingr_mtotal  numeric
declare @rh_banc_ccod int
declare @rh_ingr_fpago datetime
declare @rh_ding_fdocto datetime
declare @rh_ting_ccod numeric
declare @rh_post_ncorr numeric
declare @rh_tipo_tarjeta varchar(2)
declare @rh_comp_ndocto numeric
declare @rh_tcom_ccod numeric
declare @rh_inst_ccod numeric
declare @rh_dcom_ncompromiso numeric
------------------------------------------

-- variables cursor C_EFE_HABER  (Efes para pagos por caja)-----------
DECLARE @rf_monto NUMERIC
DECLARE @rf_tipo NUMERIC
DECLARE @rf_detalle varchar(150)
declare @rf_tcom_ccod numeric
-------------------------------------------

-- Variable Cursos c_descuentos_becas ("Descuentos y Becas")-------------
declare @rbd_tipo_descuento numeric
declare @rbd_glosa_descuento varchar(100)
declare @rbd_descuento_matricula numeric
declare @rbd_descuento_arancel numeric
declare @rbd_descuento_total numeric
-------------------------------------------------------------------------




--control de errores, depurar con trasaccion
declare @v_salida_error int

-----------------------------------------------------
-------  VARIABLES DE TRADUCCION PARA SOFTLAND  -----
declare @vsof_plan_cuenta varchar(100)
declare @vsof_centro_costo varchar(100)
declare @vsof_centro_costo_simple varchar(100)
declare @vsof_detalle_gasto varchar(100)
declare @vsof_tipo_datos varchar(100)
declare @vsof_monto_matricula numeric
declare @vsof_monto_arancel numeric
declare @vsof_monto_matricula_bruto numeric
declare @vsof_monto_arancel_bruto numeric
declare @vsof_monto_generico numeric
declare @vsof_tipo_datos_ref varchar(100)
declare @v_agrupador numeric
declare @v_glosa_softland varchar(60)
declare @v_vsof_cuenta_efe varchar(15)
declare @v_vsof_ingreso_aticipado_presente varchar(20)
declare @v_vsof_cuenta_caja varchar(20)
declare @v_vsof_cuenta_cuadre varchar(20)
declare @v_vsof_cuenta_tarjeta_3 varchar(20)
declare @v_vsof_cuenta_becas_descuentos varchar(20)
declare @v_soft_monto_cedente numeric
declare @v_cantidad_lineas numeric
declare @v_agrupador_cedentes numeric
declare @v_soft_monto_cedente_faltante numeric
declare @v_limite_linea_cedente numeric
declare @v_conteo_cedentes numeric
declare @v_mantiene_agrupador numeric
declare @v_soft_cuenta_cte_personal varchar(20)
declare @v_soft_cuenta_doc_varios varchar(20)
declare @v_soft_cuenta_iva varchar(20)
declare @v_soft_gasto_protesto varchar(20)

-----------------------------------------------------

--Otras
declare @v_usa_controla_doc  varchar(1)
declare @v_usa_centro_costo varchar(1)
declare @v_usa_auxiliar varchar(1)
declare @v_usa_detalle_gasto varchar(1)
declare @v_usa_conciliacion varchar(1)
declare @v_usa_pto_caja varchar(1)
declare @v_plan_completo numeric
declare @v_largo_plan numeric
declare @v_monto_caja numeric
declare @v_folio_caja_anulada numeric
declare @v_ting_ccod_caja_anulada numeric
declare @v_anulacion_caja numeric
declare @v_folio_origen numeric
declare @v_detalle_auxiliar numeric
declare @v_cantidad_cedentes numeric
declare @v_auxiliar_mineduc numeric
-----------------------------------------------------

-----------------------------------------------------
--variables temporales para debe- contrato
declare @debe_rd_abon_mabono        numeric
declare @debe_vsof_cod_auxiliar     numeric
declare @debe_vsof_tipo_datos      varchar(2)
declare @debe_vsof_numero_doc       numeric
declare @debe_vsof_fecha_pago       datetime
declare @debe_vsof_fecha_inicio     datetime
declare @debe_vsof_tipo_datos_ref  varchar(2)
declare @debe_vsof_numero_doc_ref   numeric
declare @debe_vsof_glosa_softland   varchar(60)
declare @debe_vsof_detalle_gasto    varchar(60)
declare @debe_vsof_centro_costo     varchar(60)
declare @debe_vsof_cantidad_gasto  numeric
-------------------------------------------------------------
declare @d_otros_rd_abon_mabono        numeric
declare @d_otros_vsof_cod_auxiliar     numeric
declare @d_otros_vsof_tipo_datos      varchar(2)
declare @d_otros_vsof_numero_doc       numeric
declare @d_otros_vsof_fecha_pago       datetime
declare @d_otros_vsof_fecha_emision     datetime
declare @d_otros_vsof_tipo_datos_ref  varchar(2)
declare @d_otros_vsof_numero_doc_ref   numeric
declare @d_otros_vsof_glosa_softland   varchar(60)
declare @d_otros_vsof_detalle_gasto    varchar(60)
declare @d_otros_vsof_centro_costo     varchar(60)
declare @d_otros_vsof_cantidad_gasto  numeric

-------------------------------------------------------------
declare @h_otros_rd_abon_mabono        numeric
declare @h_otros_vsof_cod_auxiliar     numeric
declare @h_otros_vsof_tipo_datos      varchar(2)
declare @h_otros_vsof_numero_doc       numeric
declare @h_otros_vsof_fecha_pago       datetime
declare @h_otros_vsof_fecha_emision     datetime
declare @h_otros_vsof_tipo_datos_ref  varchar(2)
declare @h_otros_vsof_numero_doc_ref   varchar(100)
declare @h_otros_vsof_glosa_softland   varchar(60)
declare @h_otros_vsof_detalle_gasto    varchar(60)
declare @h_otros_vsof_centro_costo     varchar(60)
declare @h_otros_vsof_cantidad_gasto  numeric
--------------------------------------------------------------
declare @glosa_descuento_matricula varchar (60)
declare @glosa_descuento_arancel varchar (60)
declare @v_total_descuento_arancel numeric
declare @v_total_descuento_matricula numeric
declare @vsof_detalle_gasto_descuento varchar(60)
declare @vsof_centro_costo_descuento varchar(60)


set @v_total_descuento_arancel =0
set @v_total_descuento_matricula =0


--Inicializa variables
set @v_vsof_ingreso_aticipado_presente  =   '2-10-140-04-120001'
set @v_vsof_cuenta_efe                  =   '1-10-040-30'
set @v_vsof_cuenta_caja                 =   '1-10-010-10-000001'
set @v_vsof_cuenta_cuadre               =   '9-10-010-10-000001'
set @v_vsof_cuenta_tarjeta_3            =   '1-10-050-60'
set @v_vsof_cuenta_becas_descuentos     =   '2-10-140-09-120001'
set @v_soft_cuenta_cte_personal         =   '1-10-060-40-000001'
set @v_soft_cuenta_doc_varios           =   '1-10-050-05'
set @v_soft_cuenta_iva                  =   '2-10-120-10-000001'
set @v_soft_gasto_protesto              =   '6-40-010-10-000001'
set @v_auxiliar_mineduc                 =   '60901000'

set @v_agrupador    = 0
set @v_salida_error = 0
set @v_largo_plan   = 0
set @v_cantidad_lineas=0
set @v_soft_monto_cedente=0
set @v_agrupador_cedentes=1
set @v_monto_caja=0
set @v_limite_linea_cedente=0
set @v_anulacion_caja   =0
set @v_cantidad_cedentes=0
set @v_conteo_cedentes  =0
set @v_mantiene_agrupador=0

if @v_tipo_caja='1001'
begin

    
print 'es una caja de anulacion'



	DECLARE c_ingresos CURSOR LOCAL FOR
		Select a.mcaj_ncorr, a.caje_ccod, a.sede_ccod, b.ting_ccod, b.ingr_nfolio_referencia,b.pers_ncorr, c.pers_nrut, c.pers_xdv, d.ting_tdesc,
			    sum(b.ingr_mtotal) as monto, a.mcaj_finicio,
		        c.pers_tnombre, c.pers_tape_paterno, c.pers_tape_materno, c.pers_tfono,
		        dir.dire_tcalle +' '+ dir.dire_tnro as direccion_alumno, ciu.CIUD_TDESC, ciu.CIUD_TCOMUNA,
		        pc.pers_tnombre, pc.pers_tape_paterno, pc.pers_tape_materno, pc.pers_tfono,
		        cdir.dire_tcalle+' '+cdir.dire_tnro as direccion_codeudor, cciu.CIUD_TDESC as comuna, cciu.CIUD_TCOMUNA as ciudad
				,pc.pers_nrut,pc.pers_xdv
		    From movimientos_cajas a 
		    join ingresos b
		        on a.mcaj_ncorr = b.mcaj_ncorr
		    join personas c
		        on b.pers_ncorr = c.pers_ncorr
		    join tipos_ingresos d
		        on b.ting_ccod = d.ting_ccod
		    left outer join direcciones dir
		        on c.pers_ncorr=dir.pers_ncorr
		        and dir.tdir_ccod=1
		    left outer join ciudades ciu
		        on dir.ciud_ccod=ciu.ciud_ccod
		    left outer join postulantes pos
		        on pos.post_ncorr=(select max(post_ncorr) from postulantes where pers_ncorr=c.pers_ncorr)
		    left outer join codeudor_postulacion cp
		        on pos.post_ncorr=cp.post_ncorr
		    left outer join personas pc
		        on cp.pers_ncorr=pc.pers_ncorr
		    left outer join direcciones cdir
		        on pc.pers_ncorr=cdir.pers_ncorr
		        and cdir.tdir_ccod=1
		    left outer join ciudades cciu
		        on cdir.ciud_ccod=cciu.ciud_ccod
		    	where 
			     a.mcaj_ncorr = @p_mcaj_ncorr
                --and b.eing_ccod not in (2,3,6)
                and b.ting_ccod not in (46,8) -- CONCILIACION, abono por pago documento
                --and b.ting_ccod in (10)
                --and b.ingr_nfolio_referencia=15860
		  	group by a.mcaj_ncorr, a.caje_ccod, a.sede_ccod, b.ting_ccod, b.ingr_nfolio_referencia, 
		            b.pers_ncorr, c.pers_nrut, c.pers_xdv, d.ting_tdesc, a.mcaj_finicio,
		        c.pers_tnombre, c.pers_tape_paterno, c.pers_tape_materno, c.pers_tfono,
		        dir.dire_tcalle, dir.dire_tnro, ciu.CIUD_TDESC, ciu.CIUD_TCOMUNA,
		        pc.pers_tnombre, pc.pers_tape_paterno, pc.pers_tape_materno, pc.pers_tfono,
		        cdir.dire_tcalle, cdir.dire_tnro, cciu.CIUD_TDESC, cciu.CIUD_TCOMUNA,pc.pers_nrut,pc.pers_xdv
			order by b.ting_ccod,b.ingr_nfolio_referencia asc

--*****************************************************************************



    OPEN c_ingresos
    FETCH NEXT FROM c_ingresos
    INTO  @r_mcaj_ncorr,@r_caje_ccod,@r_sede_ccod,@r_ting_ccod,@r_ingr_nfolio_referencia,
	      @r_pers_ncorr,@r_pers_nrut,@r_pers_xdv,@r_ting_tdesc,@r_monto,@r_finicio,
          @r_nombre_a, @r_paterno_a, @r_materno_a, @r_fono_a,
          @r_direccion_a, @r_comuna_a, @r_ciudad_a,
          @r_nombre_c, @r_paterno_c, @r_materno_c, @r_fono_c,
          @r_direccion_c, @r_comuna_c, @r_ciudad_c,
	      @r_pers_nrut_c,@r_pers_xdv_c
        While @@FETCH_STATUS = 0
	        begin
             
	          set @v_nlinea = 0
              set @v_carr_ccod = protic.obtener_carrera_ingreso(@r_mcaj_ncorr, @r_ting_ccod,@r_ingr_nfolio_referencia,@r_pers_ncorr)
	          set @v_trca_tglosa = null
              set @vsof_monto_matricula=0
              set @vsof_monto_arancel=0
              set @vsof_monto_generico= null
              
  


--*****************************************************************************
--**********   SUMATORIA DEL MOVIMIENTO DE LA CAJA para cedentes   *********************--

		Select @v_monto_caja=sum(b.ingr_mtotal),@v_cantidad_cedentes=count(*)
		    From movimientos_cajas a 
		    join ingresos b
		        on a.mcaj_ncorr = b.mcaj_ncorr
		    join personas c
		        on b.pers_ncorr = c.pers_ncorr
		    join tipos_ingresos d
		        on b.ting_ccod = d.ting_ccod
		    left outer join direcciones dir
		        on c.pers_ncorr=dir.pers_ncorr
		        and dir.tdir_ccod=1
		    left outer join ciudades ciu
		        on dir.ciud_ccod=ciu.ciud_ccod
		    left outer join postulantes pos
		        on pos.post_ncorr=(select max(post_ncorr) from postulantes where pers_ncorr=c.pers_ncorr)
		    left outer join codeudor_postulacion cp
		        on pos.post_ncorr=cp.post_ncorr
		    left outer join personas pc
		        on cp.pers_ncorr=pc.pers_ncorr
		    left outer join direcciones cdir
		        on pc.pers_ncorr=cdir.pers_ncorr
		        and cdir.tdir_ccod=1
		    left outer join ciudades cciu
		        on cdir.ciud_ccod=cciu.ciud_ccod
		    	where b.eing_ccod not in (2,3,6)
			    and a.mcaj_ncorr = @r_mcaj_ncorr
                and b.ting_ccod in (10)
		  	group by a.mcaj_ncorr
--**********************************************************************************   
   
   
   
    --set @v_agrupador=@r_ingr_nfolio_referencia


						
-------------------------------------------------------------------------------------------------------
    --##########################################################################################################

    --#######################		        datos matricula y arancel			      ##########################

    --##########################################################################################################
    if @r_ting_ccod=7 --  CONTRATO ( MATRICULA Y ARANCEL )
	    begin

	  set @v_agrupador=@v_agrupador+1 	
      
      -------------------------------------------------------------------------------------------------------
	                  DECLARE c_debe CURSOR LOCAL FOR
                          select case isnull(a.ingr_mefectivo, 0) 
					        when 0 then f.ting_tdesc else 'EFECTIVO' end as ting_tdesc,
					        case f.ting_ccod when 52 then protic.obtener_numero_pagare_pagado(a.ingr_ncorr) else isnull(di.ding_ndocto,1) end as ding_ndocto_2,
					        a.ingr_mtotal, di.banc_ccod,a.ingr_fpago ,di.ding_fdocto,isnull(f.ting_ccod,6)as ting_ccod,
					        a.ingr_ncorr, case c.tcom_ccod when 25 then (select tdet_tdesc from tipos_detalle where tdet_ccod=e.tdet_ccod) else c.tcom_tdesc end as tcom_tdesc,
                            b.comp_ndocto,b.abon_mabono, isnull(di.ding_ndocto,1) as ding_ndocto,a.ingr_fpago,isnull(di.ting_ccod,6) as ting_ccod,
					        isnull(protic.obtener_post_ncorr(a.pers_ncorr,b.comp_ndocto,null),0) as post_ncorr, e.tdet_ccod,
					        isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto'),0) as numero_docto,
					        (select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as banco,
					        (select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as vencimiento,
					        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as documento,c.tcom_ccod,
						    case f.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(a.ingr_ncorr,di.ding_ndocto) end as tipo_tarjeta
                            From ingresos a
						     join  abonos b
						        on a.ingr_ncorr = b.ingr_ncorr
						     join tipos_compromisos c
						        on b.tcom_ccod     = c.tcom_ccod
						     left outer join detalle_ingresos di 
						        on a.ingr_ncorr 	= di.ingr_ncorr
						     join detalles e
						        on b.comp_ndocto  = e.comp_ndocto
						        and b.tcom_ccod   = e.tcom_ccod
						        and b.inst_ccod   = e.inst_ccod
                                and e.tdet_ccod not in(3,4)
                                and e.tcom_ccod in (1,2)
						     left outer join tipos_ingresos f
						        on di.ting_ccod = f.ting_ccod  
                          Where a.eing_ccod not in (2)
                              and a.mcaj_ncorr = @p_mcaj_ncorr
                              and a.ting_ccod  = @r_ting_ccod
                              and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
						      and a.pers_ncorr = @r_pers_ncorr
						      and e.deta_ncantidad>0
  				    order by a.ingr_ncorr asc       
                   ---------------------------------------------------------------------------------------------------------           

                      OPEN c_debe
                        FETCH NEXT FROM c_debe
                        INTO  @rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,@rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,
						      @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
						      @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr, @rd_tipo_detalle,@rd_numero_doc,@rd_banco_pacta,
						      @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta
                            While @@FETCH_STATUS = 0
	                            begin
                                     
								     set @vsof_plan_cuenta=''
								
                                     --------CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS-----
								      select @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
									    From postulantes a ,ofertas_academicas b, especialidades c
									    where a.ofer_ncorr=b.ofer_ncorr
                                        and b.espe_ccod=c.espe_ccod
                                   	    and a.post_ncorr=@rd_post_ncorr
                                   
                                   if @v_sede is null and @v_jornada is null and @rd_tcom_tdesc='EXAMEN ADMISION' 
										    begin
											    --print 'no estaba matriculado'
											     select top 1 @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
												    From detalle_postulantes a ,ofertas_academicas b, especialidades c
												    where a.ofer_ncorr=b.ofer_ncorr
			                                        and b.espe_ccod=c.espe_ccod
			           							    and a.post_ncorr=@rd_post_ncorr
										    end
								    ----------------------------------------------------------------------------
                                     
								    --	print 'sede:'+cast(@v_sede as varchar)+' Carrera:'+cast(@v_carrera as varchar)+' Jornada:'+cast(@v_jornada as varchar)	
									    --------------------------------------------------
									    select @vsof_centro_costo=cenc_ccod_softland,@vsof_centro_costo_simple=cenc_ccod_softland_simple
										    from centros_de_costos_softland 
										    where cenc_ccod_carrera=@v_carrera
											    and cenc_ccod_jornada=@v_jornada
											    and cenc_ccod_sede=@v_sede
									    --------------------------------------------------
									     
									
									    -----------------------------------------------------------------------
									    select @vsof_plan_cuenta       =   protic.obtener_cuenta_soft(@rd_ting_ccod,null)
                                        select @vsof_detalle_gasto     =   protic.obtener_detalle_soft(@rd_tipo_detalle,null)
                                   	    select @vsof_tipo_datos        =   protic.obtener_tipo_soft(@rd_ting_ccod)
									    select @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(@rd_documento)
									    -----------------------------------------------------------------------
                                         if @rd_tipo_tarjeta='T3'
                                        begin
                                            set @vsof_plan_cuenta       = @v_vsof_cuenta_tarjeta_3
                                            set @vsof_tipo_datos        = @rd_tipo_tarjeta
                                            set @vsof_tipo_datos_ref    = @rd_tipo_tarjeta
                                        end
                                    
                                        if @rd_ting_ccod <> 6 --si no es efectivo
                                            begin     
									            set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
											    set @v_glosa_softland= @rd_tcom_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                            end
									    else
										    begin
											    set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
										    end   
									    -----------------------------------------------------------------------

							      if @rd_ting_ccod=13 or @rd_ting_ccod=51 or @rd_ting_ccod=52
                                    begin
                                        set @rd_ding_ndocto         = cast(@rd_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                    end
                                
                                   if @rd_documento=13 or @rd_documento=51 or @rd_documento=52
                                        begin
                                            set @rd_numero_doc          = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                        end        
                                			

          
                            -- calculo de totales para los distintos conceptos de ingresos
                            if @r_ting_ccod=7 
	                            begin
                                    --print 'entro a los montos'
	                                 if @rd_tcom_ccod=1
		                                set @vsof_monto_matricula = @rd_abon_mabono + @vsof_monto_matricula
	                                 if @rd_tcom_ccod=2
		                                set @vsof_monto_arancel = @rd_abon_mabono + @vsof_monto_arancel
	                            end 



    Select @v_usa_controla_doc=usa_controla_doc, @v_usa_centro_costo=usa_centro_costo,
      @v_usa_auxiliar=usa_auxiliar, @v_usa_detalle_gasto=usa_detalle_gasto,
      @v_usa_conciliacion=usa_conciliacion, @v_usa_pto_caja=usa_pto_caja
    From cuentas_softland Where cuenta=@vsof_plan_cuenta


    set @debe_rd_abon_mabono       =   @rd_abon_mabono
    set @debe_vsof_cod_auxiliar    =   @r_pers_nrut
    set @debe_vsof_tipo_datos      =   @vsof_tipo_datos
    set @debe_vsof_numero_doc      =   @rd_ding_ndocto
    set @debe_vsof_fecha_inicio    =   @rh_ingr_fpago
    set @debe_vsof_fecha_pago      =   @rd_fecha_pacta
    set @debe_vsof_tipo_datos_ref  =   @vsof_tipo_datos_ref
    set @debe_vsof_numero_doc_ref  =   @rd_numero_doc
    set @debe_vsof_glosa_softland  =   @v_glosa_softland
    set @debe_vsof_detalle_gasto   =   @vsof_detalle_gasto
    set @debe_vsof_centro_costo    =   @vsof_centro_costo


    if @v_usa_controla_doc<>'S'
        begin
            set @debe_vsof_cod_auxiliar     = null
            set @debe_vsof_tipo_datos      = null
            set @debe_vsof_numero_doc       = null
            set @debe_vsof_fecha_pago       = null
            set @debe_vsof_fecha_inicio     = null
            set @debe_vsof_tipo_datos_ref  = null
            set @debe_vsof_numero_doc_ref   = null
        end
    if @v_usa_centro_costo<>'S'
        begin
           set @debe_vsof_centro_costo = null
        end
    if @v_usa_auxiliar<>'S'
        begin
            set @debe_vsof_cod_auxiliar = null
        end
    if @v_usa_detalle_gasto<>'S'
        begin
            set @debe_vsof_detalle_gasto = null
            set @debe_vsof_cantidad_gasto= null
        end




    set @v_nlinea = @v_nlinea + 1
			                  insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
                                              audi_tusuario, audi_fmodificacion,
										      trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
										      tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
                                              tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
				                  values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
				   						      @p_audi_tusuario, getdate(),
										      @r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
										      @vsof_plan_cuenta,@debe_rd_abon_mabono,@debe_vsof_cod_auxiliar,@debe_vsof_tipo_datos,@debe_vsof_numero_doc,@debe_vsof_fecha_inicio,@debe_vsof_fecha_pago,@debe_vsof_tipo_datos_ref,@debe_vsof_numero_doc_ref,@v_agrupador,@debe_vsof_glosa_softland,
                                              @debe_vsof_detalle_gasto,@debe_vsof_centro_costo,@debe_vsof_cantidad_gasto)


							       IF @@ERROR <> 0 
								    BEGIN
								   	    set @v_salida_error=1
								    END

							        FETCH NEXT FROM c_debe
                                    INTO  @rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,@rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,
                                          @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
                                          @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr,@rd_tipo_detalle,@rd_numero_doc,@rd_banco_pacta,
                                          @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta
			        end --fin while c_debe

               		        CLOSE c_debe 
						    DEALLOCATE c_debe


    --######################################################################################
    --***************   CURSOR PARA DESCUENTOS Y BECAS  ************************************

    set @v_total_descuento_arancel=0
    set @v_total_descuento_matricula=0
    DECLARE c_becas_descuentos CURSOR LOCAL FOR
    Select  a.stde_ccod, substring(b.stde_tdesc,1,25) as descripcion, 
            a.sdes_mcolegiatura  as sdes_mcolegiatura , a.sdes_mmatricula  as sdes_mmatricula,
            isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as subtotal 
		        From sdescuentos a, stipos_descuentos b, postulantes c    
		        where a.stde_ccod = b.stde_ccod    
		          and a.post_ncorr = c.post_ncorr    
		          and a.ofer_ncorr = c.ofer_ncorr    
		          and c.post_ncorr = @rd_post_ncorr
                  and a.esde_ccod=1 

                OPEN c_becas_descuentos
                        FETCH NEXT FROM c_becas_descuentos
                        INTO @rbd_tipo_descuento,@rbd_glosa_descuento,@rbd_descuento_arancel,
                        @rbd_descuento_matricula,@rbd_descuento_total
                    
                       
                         While @@FETCH_STATUS = 0
	                        begin
                        
                            set @v_total_descuento_matricula=@rbd_descuento_matricula+@v_total_descuento_matricula
                            set @v_total_descuento_arancel  =@rbd_descuento_arancel+@v_total_descuento_arancel
                        
                            --print 'post_ncorr:'+cast(@rd_post_ncorr as varchar)
                        
                            select @vsof_detalle_gasto_descuento  =   protic.obtener_detalle_soft(@rbd_tipo_descuento,null) 
                        
                           
                            -----------------------------------------------------------------------------------------------------------------------------
                             IF @rbd_descuento_matricula > 0
                                   BEGIN       
                                       -- DESCUENTOS POR MATRICULA 
                                        set @v_nlinea = @v_nlinea+1
                                        set @glosa_descuento_matricula    =   @rbd_glosa_descuento+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar) 
       
                                         -- VALOR AL DEBE DEL DESCUENTO
                                          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
								                tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto )
			                              values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea, @r_ting_ccod, @p_audi_tusuario, getdate(),
						                         @v_vsof_cuenta_becas_descuentos,@rbd_descuento_matricula,@v_agrupador,@glosa_descuento_matricula,@vsof_detalle_gasto_descuento,@vsof_centro_costo,1 )
                                       
                                
                                    END
                           -----------------------------------------------------------------------------------------------------------------------------  
                            IF @rbd_descuento_arancel > 0
                                BEGIN
                                
                                   -- DESCUENTOS POR ARANCEL 
                                    set @v_nlinea = @v_nlinea+1
                                    set @glosa_descuento_arancel    =   @rbd_glosa_descuento+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)  
                                
                                     -- VALOR AL DEBE DEL DESCUENTO EN ARANCEL
                                      insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
								            tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto )
			                          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						                     @v_vsof_cuenta_becas_descuentos,@rbd_descuento_arancel,@v_agrupador,@glosa_descuento_arancel,@vsof_detalle_gasto_descuento,@vsof_centro_costo,1 )
                                     
                            
                                END
                           -----------------------------------------------------------------------------------------------------------------------------  
                                FETCH NEXT FROM c_becas_descuentos
                                INTO @rbd_tipo_descuento,@rbd_glosa_descuento,@rbd_descuento_arancel,
                                @rbd_descuento_matricula,@rbd_descuento_total
                            end --fin while c_becas_descuentos
                        
               		    CLOSE c_becas_descuentos 
					    DEALLOCATE c_becas_descuentos
    --######################################################################################


    --TOTALIZADORES
    SET @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_presente
     --asientos
    if @vsof_monto_matricula >0 or @v_total_descuento_matricula>0
            begin
                set @vsof_detalle_gasto=   'AR-01-01'
                set @v_nlinea           =   @v_nlinea+1
                set @v_glosa_softland   =  'MATRICULA-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)    
					    --matricula
			
                if @vsof_monto_matricula=0
                    begin
                       set @vsof_monto_matricula_bruto=@v_total_descuento_matricula
                    end
                else
                    begin
                        set @vsof_monto_matricula_bruto=@v_total_descuento_matricula + @vsof_monto_matricula
                    end
            
                set @v_total_descuento_matricula=0
            
                      insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      trca_nombre_c, trca_paterno_c, trca_materno_c, trca_fono_c,trca_direccion_c, trca_comuna_c, trca_ciudad_c,
											      tsof_plan_cuenta,tsof_haber,tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto,tsof_nro_agrupador,tsof_glosa,
											      TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO)
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @r_nombre_c, @r_paterno_c, @r_materno_c, @r_fono_c,@r_direccion_c, @r_comuna_c, @r_ciudad_c,
						     @vsof_plan_cuenta,@vsof_monto_matricula_bruto,@vsof_detalle_gasto,@vsof_centro_costo,1,@v_agrupador,@v_glosa_softland,
						     'S','S','N','N','N','N','N')
                             
	        end

        if @vsof_monto_arancel >0 or @v_total_descuento_arancel>0
            begin
            
                 set @vsof_monto_arancel_bruto=0
			     set @v_nlinea=@v_nlinea+1
                 set @vsof_detalle_gasto='AR-01-02'
                 set @v_glosa_softland='ARANCEL-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)    
            
                if @vsof_monto_arancel=0
                    begin
                       set @vsof_monto_arancel_bruto=@v_total_descuento_arancel
                    end
                else
                    begin
                        set @vsof_monto_arancel_bruto = @v_total_descuento_arancel + @vsof_monto_arancel
                    end
                
                set @v_total_descuento_arancel=0
            	
                -- print 'Suma :'+cast(@vsof_monto_arancel_bruto as varchar)
    --arancel
			          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      trca_nombre_c, trca_paterno_c, trca_materno_c, trca_fono_c,trca_direccion_c, trca_comuna_c, trca_ciudad_c,
											      tsof_plan_cuenta,tsof_haber,tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto,tsof_nro_agrupador,tsof_glosa,
											      TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO)
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_arancel, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @r_nombre_c, @r_paterno_c, @r_materno_c, @r_fono_c,@r_direccion_c, @r_comuna_c, @r_ciudad_c,
						     @vsof_plan_cuenta,@vsof_monto_arancel_bruto,@vsof_detalle_gasto,@vsof_centro_costo,1,@v_agrupador,@v_glosa_softland,
						     'S','S','N','N','N','N','N')
                             
        
        
            end






        
    --######################################################################  
    --				####  	####	####	#####
    -- 				#		#		#		#
    --- 			####	###		####	##### 	
    -- 				#		#		#			#
    -- 				####	#		####    #####
    --######################################################################    

          
    if @vsof_monto_matricula >0
            begin
    -- efes matricula
                set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
                set @v_nlinea           =   @v_nlinea+1
                set @v_glosa_softland  =   'MATRICULA-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)    
                
                    --efe debe				
			          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_auxiliar )
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @vsof_plan_cuenta,@vsof_monto_matricula,@v_agrupador,@v_glosa_softland,@r_pers_nrut )
		
                    set @v_nlinea = @v_nlinea+1
                    --efe haber			    
                      insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa,tsof_cod_auxiliar )
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @vsof_plan_cuenta,@vsof_monto_matricula,@v_agrupador,@v_glosa_softland,@r_pers_nrut )
        
        				
	        end
        
    if @vsof_monto_arancel >0
            begin
    -- efes arancel

                set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
                set @v_nlinea           =   @v_nlinea+1
                set @v_glosa_softland   =  'ARANCEL-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)    
                    
                    --efe debe
			          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_auxiliar)
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @vsof_plan_cuenta,@vsof_monto_arancel,@v_agrupador,@v_glosa_softland,@r_pers_nrut)
			
                
                    set @v_nlinea =   @v_nlinea+1
                    --efe haber
                
                      insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                      caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa,tsof_cod_auxiliar)
			          values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
			                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						     @vsof_plan_cuenta,@vsof_monto_arancel,@v_agrupador,@v_glosa_softland,@r_pers_nrut)
                		
	        end
        
	    end
    else --Fin contratos	
        begin
    
        set @v_hace_efe='SI'

            if @r_ting_ccod <> 10 --si no es cedente incrementar
                begin
                    set @v_agrupador=@v_agrupador+1 
                end 
 
        --####################################################################################################
        --                          ######  #######  ######    ######  ######
        --                          #    #     #     #    #    #    #  #
        --                          #    #     #     #  #      #    #  ######
        --                          #    #     #     #   #     #    #       #
        --                          ######     #     #    #    ######  ######
        --####################################################################################################



        -- ######   DEBE   ###### 
         
            DECLARE c_debe_soft CURSOR LOCAL FOR
            select a.ingr_ncorr, 
	            case isnull(a.ingr_mefectivo, 0) when 0 then c.ting_tdesc else 'EFECTIVO' end as ting_tdesc,
	            case c.ting_ccod when 52 then protic.obtener_numero_pagare_softland(a.ingr_ncorr) else isnull(b.ding_ndocto ,1) end as ding_ndocto,
	            --a.ingr_mtotal,
                d.abon_mabono, b.banc_ccod,a.ingr_fpago,b.ding_fdocto,isnull(c.ting_ccod,6)as ting_ccod,
                isnull(protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,null),0) as post_ncorr,
                case c.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(b.ingr_ncorr,b.ding_ndocto) end as tipo_tarjeta,
                d.comp_ndocto,d.tcom_ccod,d.inst_ccod,d.dcom_ncompromiso
            from 
             ingresos a 
                left outer join detalle_ingresos b
                    on a.ingr_ncorr = b.ingr_ncorr
                left outer join tipos_ingresos c
                    on b.ting_ccod = c.ting_ccod 
                join abonos d 
                    on a.ingr_ncorr=d.ingr_ncorr    
                where a.eing_ccod not in (2)
              and a.mcaj_ncorr = @p_mcaj_ncorr
                  and a.ting_ccod = @r_ting_ccod
                  and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
                  and a.pers_ncorr = @r_pers_ncorr
                  and b.ting_ccod not in (44,53) --(44=intereses_repactacion,53=DOCUMENTACION COMPROMISOS)
                  and d.abon_mabono > 0
            order by a.ingr_ncorr asc            
                        
				          OPEN c_debe_soft
                          FETCH NEXT FROM c_debe_soft
                          INTO @rh_ingr_ncorr,@rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,
                               @rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,@rh_post_ncorr,@rh_tipo_tarjeta, 
                                @rh_comp_ndocto,@rh_tcom_ccod,@rh_inst_ccod,@rh_dcom_ncompromiso 
                                
                                WHILE @@FETCH_STATUS = 0
	                                begin

                                            --set @v_nlinea=@v_nlinea+1
                                            set @vsof_plan_cuenta=''
                                            set @v_sede     =   null
                                            set @v_jornada  =   null
                                            set @v_carrera  =   null
                                            SET @v_plan_completo=NULL
                                            SET @v_largo_plan   =NULL
								
                                        --------CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS-----
								          select @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
									        From postulantes a ,ofertas_academicas b, especialidades c
									        where a.ofer_ncorr=b.ofer_ncorr
                                            and b.espe_ccod=c.espe_ccod
                                   	        and a.post_ncorr=@rh_post_ncorr
                                    
                                            if @v_sede is null and @v_jornada is null  
										        begin
											        --print 'no estaba matriculado'
											         select top 1 @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
												        From detalle_postulantes a ,ofertas_academicas b, especialidades c
												        where a.ofer_ncorr=b.ofer_ncorr
			                                            and b.espe_ccod=c.espe_ccod
			           							        and a.post_ncorr=@rh_post_ncorr
										        end
																	
                                        
								
								            select @vsof_centro_costo=cenc_ccod_softland,
                                                @vsof_centro_costo_simple=cenc_ccod_softland_simple
									            from centros_de_costos_softland 
									            where cenc_ccod_carrera     = @v_carrera
										            and cenc_ccod_jornada   = @v_jornada
										            and cenc_ccod_sede      = @v_sede
                                            
                                
                                        if  @rh_post_ncorr=0 --obtiene el centro de costo a partir del ingreso ke esta pagando
                                            begin
                                                select top 1 @v_tipo_compromiso=e.tcom_ccod,@v_tipo_detalle=e.tdet_ccod
                                                    from ingresos a, abonos b, detalle_compromisos c, detalles e
                                                        Where a.ingr_ncorr = b.ingr_ncorr
                                                        and b.comp_ndocto  = c.comp_ndocto
                                                        and b.comp_ndocto  = e.comp_ndocto
                                                        and b.tcom_ccod    = e.tcom_ccod
                                                        and b.inst_ccod    = e.inst_ccod
                                                        and a.ingr_ncorr   = @rh_ingr_ncorr
                                                        and b.comp_ndocto   =@rh_comp_ndocto
                                                        and e.deta_msubtotal>0
                                            
                                                if @v_tipo_compromiso=7 and @v_tipo_detalle is not null
                                                    begin
                                            
                                                       select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
									                        from centros_costos_asignados a, centros_costo b 
									                            where a.tdet_ccod=@v_tipo_detalle
                                                                and a.ccos_ccod=b.ccos_ccod
										            
                                                    end
                                                if @v_tipo_compromiso=25 and @v_tipo_detalle is not null
                                                    begin
                                            
                                                        select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
									                        from centros_costos_asignados a, centros_costo b 
									                            where a.tdet_ccod=@v_tipo_detalle
                                                                and a.ccos_ccod=b.ccos_ccod
										            
                                                    end    
                                            end
                                                                                  
								        -----------------------------------------------------------------------------------
                                    
                                    
                                    
								        -----------------------------------------------------------------------------------
								        select @vsof_plan_cuenta       =   protic.obtener_cuenta_soft(@rh_ting_ccod,null)
                                        select @vsof_detalle_gasto     =   NULL --protic.obtener_detalle_soft(@rd_tipo_detalle)
                                        select @vsof_tipo_datos        =   protic.obtener_tipo_soft(@rh_ting_ccod)
								        select @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(@rh_ting_ccod)
								        -----------------------------------------------------------------------------------
   --  print 'plan antes:'+cast(@vsof_plan_cuenta as varchar)  
       
                                      if @rh_post_ncorr=0 and @vsof_centro_costo_simple='101200' 
										    begin
                                                if @rh_ting_ccod <> 6
                                                    begin
										  		        set @vsof_plan_cuenta   = @v_soft_cuenta_doc_varios
                                                    end
                                                else
                                                    begin
                                                        set @vsof_plan_cuenta   = @v_vsof_cuenta_caja
                                                    end
											end
       
       
                                          if @rh_tipo_tarjeta='T3'
                                            begin
                                                set @vsof_plan_cuenta       = @v_vsof_cuenta_tarjeta_3
                                                set @vsof_tipo_datos        = @rh_tipo_tarjeta
                                                set @vsof_tipo_datos_ref    = @rh_tipo_tarjeta
                                                set @v_plan_completo=1
                                            end    
                                    
                                            
                                    
                                            if @rh_ting_ccod=13 or @rh_ting_ccod=51 or @rh_ting_ccod=52
                                                begin
                                                    set @rh_ding_ndocto         = cast(@rh_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                                end
                                
                                           
                                                
                                            if @rh_ting_ccod <> 6 --si no es efectivo
                                                begin     
                                                   -- print 'no es efectivo'
									                set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
											        set @v_glosa_softland= @rh_ting_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                                end
									        else
										        begin
                                                    --print 'efectivo es'
											        set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
										        end   
                                           
                                           if @rh_ting_ccod = 10   --cedente de letras
                                            begin
                                                
                                                set @vsof_plan_cuenta       =   @v_vsof_cuenta_caja
                                                set @v_soft_monto_cedente   =   @v_soft_monto_cedente + @rh_ingr_mtotal
                                                set @v_cantidad_lineas      =   @v_cantidad_lineas + 1  
                                                set @v_conteo_cedentes      =   @v_conteo_cedentes + 1
                                                if @v_cantidad_lineas=1 and @v_mantiene_agrupador=0
                                                    begin
                                                        set @v_agrupador=@v_agrupador+1
                                                        set @v_mantiene_agrupador=1
                                                    end
                                               -- print 'linea: '+cast(@v_cantidad_lineas as varchar)+' -> Valor: '+cast(@v_soft_monto_cedente as varchar)
                                            end 
                                             
--print 'plan despues:'+cast(@vsof_plan_cuenta as varchar)

if @r_ting_ccod=9 or @rh_ting_ccod=9 --repactacion (abonos por repactacion)
begin
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
    set @v_hace_efe='NO'
end

if @r_ting_ccod=17 --ingresos por regularizaciones (cuenta ingresos anticipados)
begin
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
    set @v_hace_efe='NO'
end

        Select @v_usa_controla_doc=usa_controla_doc, @v_usa_centro_costo=usa_centro_costo,
          @v_usa_auxiliar=usa_auxiliar, @v_usa_detalle_gasto=usa_detalle_gasto,
          @v_usa_conciliacion=usa_conciliacion, @v_usa_pto_caja=usa_pto_caja
        From cuentas_softland Where cuenta=@vsof_plan_cuenta





        set @d_otros_vsof_glosa_softland    =   @v_glosa_softland

        
        set @d_otros_vsof_cod_auxiliar      = null
        set @d_otros_vsof_tipo_datos        = null
        set @d_otros_vsof_numero_doc        = null
        set @d_otros_vsof_fecha_pago        = null
        set @d_otros_vsof_fecha_emision     = null
        set @d_otros_vsof_tipo_datos_ref    = null
        set @d_otros_vsof_numero_doc_ref    = null
        set @d_otros_vsof_centro_costo      = null
        set @d_otros_vsof_detalle_gasto     = null


        if @v_usa_controla_doc='S'
            begin
                set @d_otros_vsof_cod_auxiliar      =   @r_pers_nrut
                set @d_otros_vsof_tipo_datos        =   @vsof_tipo_datos
                set @d_otros_vsof_numero_doc        =   @rh_ding_ndocto
                set @d_otros_vsof_fecha_emision     =   @rh_ingr_fpago
                set @d_otros_vsof_fecha_pago        =   @rh_ding_fdocto
                set @d_otros_vsof_tipo_datos_ref    =   @vsof_tipo_datos_ref
                set @d_otros_vsof_numero_doc_ref    =   @rh_ding_ndocto
            end 
        if @v_usa_centro_costo='S'
            begin
                set @d_otros_vsof_centro_costo      =   @vsof_centro_costo
            end
    
        if @v_usa_auxiliar='S'
            begin
                set @d_otros_vsof_cod_auxiliar      =   @r_pers_nrut
            end
        if @v_usa_detalle_gasto='S'
            begin
                set @d_otros_vsof_detalle_gasto     =   @vsof_detalle_gasto
                set @d_otros_vsof_cantidad_gasto    =   1
            end
           



           
           if @rh_ting_ccod<>10 -- cualquier otro tipo de ingreso excepto cedentes
               begin
                        set @v_nlinea =   @v_nlinea+1

                            begin
                                  insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
                                              audi_tusuario, audi_fmodificacion,
									          trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
									          tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
                                              tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
				                  values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
				   					          @p_audi_tusuario, getdate(),
									          @r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
									          @vsof_plan_cuenta,@rh_ingr_mtotal,@d_otros_vsof_cod_auxiliar,@d_otros_vsof_tipo_datos,@d_otros_vsof_numero_doc,@d_otros_vsof_fecha_emision,@d_otros_vsof_fecha_pago,@d_otros_vsof_tipo_datos_ref,@d_otros_vsof_numero_doc_ref,@v_agrupador,@d_otros_vsof_glosa_softland,
                                              @d_otros_vsof_detalle_gasto,@d_otros_vsof_centro_costo,@d_otros_vsof_cantidad_gasto)
                            end 
                end
          else -- si son cedentes de letras
              begin 
                 
                  if  @v_cantidad_lineas = 49 --totaliza  como maximo 50 lineas
                        begin
                       -- print 'cedente a los 49 registros'+cast(@v_soft_monto_cedente as varchar)
                        
                        set @v_nlinea =   @v_nlinea+1
                                          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
                                                      audi_tusuario, audi_fmodificacion,
										              trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
										              tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
                                                      tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
				                          values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
				   						              @p_audi_tusuario, getdate(),
										              @r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
										              @v_vsof_cuenta_cuadre,@v_soft_monto_cedente,@d_otros_vsof_cod_auxiliar,@d_otros_vsof_tipo_datos,@d_otros_vsof_numero_doc,@d_otros_vsof_fecha_emision,@d_otros_vsof_fecha_pago,@d_otros_vsof_tipo_datos_ref,@d_otros_vsof_numero_doc_ref,@v_agrupador,@d_otros_vsof_glosa_softland,
                                                      @d_otros_vsof_detalle_gasto,@d_otros_vsof_centro_costo,@d_otros_vsof_cantidad_gasto)
                           
                           
                           set @v_limite_linea_cedente=1
                           set @v_cantidad_lineas    = 0
                           
                           --set @v_agrupador_cedentes = @v_agrupador_cedentes + 1
        
                        end          
              end                      

                                           

                                        FETCH NEXT FROM c_debe_soft
                                        INTO   @rh_ingr_ncorr,@rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,
                                               @rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,@rh_post_ncorr,@rh_tipo_tarjeta,
                                               @rh_comp_ndocto,@rh_tcom_ccod,@rh_inst_ccod,@rh_dcom_ncompromiso 
			                        end -- fin while c_debe_soft
			            CLOSE c_debe_soft 
				        DEALLOCATE c_debe_soft
           
--****************************************************************************************************************************************************************************************************************************************************
--                              ########################   FIN CURSOR DEBE   ###########################               
--****************************************************************************************************************************************************************************************************************************************************
        
set @vsof_monto_generico=null        
        
--****************************************************************************************************************************************************************************************************************************************************        
--                              ########################  INICIO CURSOR HABER   ###########################
--****************************************************************************************************************************************************************************************************************************************************        
        
	        DECLARE c_haber_sof CURSOR LOCAL FOR
             
			                    select 
					            isnull(di.ding_fdocto,a.ingr_fpago) as ding_fdocto,isnull(f.ting_ccod,6)as ting_ccod,
					            a.ingr_ncorr, case c.tcom_ccod when 25 then (select tdet_tdesc from tipos_detalle where tdet_ccod=e.tdet_ccod) else c.tcom_tdesc end as tcom_tdesc,
                                b.comp_ndocto,b.abon_mabono, case f.ting_ccod  
                                                                when 52 then protic.obtener_numero_pagare_pagado(a.ingr_ncorr) 
                                                                else isnull(di.ding_ndocto ,1) end as ding_ndocto_2,
                                a.ingr_fpago,isnull(di.ting_ccod,6) as ting_ccod,
					            isnull(protic.obtener_post_ncorr(a.pers_ncorr,b.comp_ndocto,null),0) as post_ncorr, e.tdet_ccod,
			                    isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') , case f.ting_ccod 
                                                                                                                                        when 52 then protic.obtener_numero_pagare_pagado(a.ingr_ncorr) 
                                                                                                                                        else isnull(di.ding_ndocto,1) end ) as numero_docto,
                                (select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as vencimiento,
					            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as documento,c.tcom_ccod,
						        case f.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(di.ingr_ncorr,di.ding_ndocto) end as tipo_tarjeta,protic.obtener_numero_documento_fox(a.ingr_ncorr,b.comp_ndocto,b.dcom_ncompromiso) as numero_fox
                                From ingresos a
						         join  abonos b
						            on a.ingr_ncorr = b.ingr_ncorr
						         join tipos_compromisos c
						            on b.tcom_ccod     = c.tcom_ccod
						         left outer join detalle_ingresos di 
						            on a.ingr_ncorr 	= di.ingr_ncorr
						         join detalles e
						            on  b.comp_ndocto  = e.comp_ndocto
						            and b.tcom_ccod   = e.tcom_ccod
						            and b.inst_ccod   = e.inst_ccod
						        left outer join tipos_ingresos f
						            on di.ting_ccod = f.ting_ccod  
                                  Where a.mcaj_ncorr = @p_mcaj_ncorr
                                  and a.ting_ccod  = @r_ting_ccod
                                  and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
						          and a.pers_ncorr = @r_pers_ncorr
						          and e.deta_ncantidad>0
                                  and di.ting_ccod not in (53)
  				        order by a.ingr_ncorr asc 

                            OPEN c_haber_sof
                            FETCH NEXT FROM c_haber_sof
                            INTO  @rh_ding_fdocto,@rh_ting_ccod,
						          @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
						          @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr, @rd_tipo_detalle,@rd_numero_doc,
						          @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta,@rd_num_fox
                                While @@FETCH_STATUS = 0
	                                begin
                          --  print '_____________________________'
                            
                                    -- otros calculos                            
                                     set @v_detalle_auxiliar=null
							         set @vsof_plan_cuenta=''
								
                                         --------CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS-----
								          select @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
									        From postulantes a ,ofertas_academicas b, especialidades c
									        where a.ofer_ncorr=b.ofer_ncorr
                                            and b.espe_ccod=c.espe_ccod
                                   	        and a.post_ncorr=@rd_post_ncorr
                                         
                                                                                  
									        if @v_sede is null and @v_jornada is null and @rd_tcom_tdesc='EXAMEN ADMISION' 
										        begin
											        -- 'no estaba matriculado'
											         select top 1 @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
												        From detalle_postulantes a ,ofertas_academicas b, especialidades c
												        where a.ofer_ncorr=b.ofer_ncorr
			                                            and b.espe_ccod=c.espe_ccod
			           							        and a.post_ncorr=@rd_post_ncorr
                                                    -- print 'no matriculado'
										        end	
                                                
                                            --- si no tiene postulacion
                                            if  @rd_post_ncorr=0
                                                begin
                                                
                                                    select top 1 @v_sede=b.sede, @v_jornada=b.jornada, @v_carrera=b.carrera
                                                        From usuarios_carreras_fox b
                                                            where b.rut=@r_pers_nrut

                                                     -- si el rut no tiene asociada una carrera       
                                                     if @v_sede is null and @v_jornada is null and @v_carrera is null
                                                        begin
                                                            select top 1 @v_detalle_auxiliar=b.tipo_detalle
                                                                From usuarios_carreras_fox b
                                                                    where b.rut=@r_pers_nrut   
                                                            -- print 'centro costo emergencia : '+cast(@v_detalle_auxiliar as varchar) 
                                                        end    
                                                     else
                                                        begin
                                                                select @vsof_centro_costo=cenc_ccod_softland,@vsof_centro_costo_simple=cenc_ccod_softland_simple
										                        from centros_de_costos_softland 
										                        where cenc_ccod_carrera=@v_carrera
											                        and cenc_ccod_jornada=@v_jornada
											                        and cenc_ccod_sede=@v_sede
                                                              --print 'tiene carrera asociada'
                                                        end     
                                                end  
                                             

                                            if @v_detalle_auxiliar is not null -- si se encontro un diplomado o un curso (son los que llevan detalle)
                                                begin
                                                    --print 'auxiliar encontrado: '+cast(@v_detalle_auxiliar as varchar)
                                                     select @vsof_centro_costo=cenc_ccod_softland, 
                                                        @vsof_centro_costo_simple=cenc_ccod_softland_simple
									                    from centros_de_costos_softland 
									                        where tdet_ccod=@v_detalle_auxiliar
                                                     --print 'centro costo: '+cast(@vsof_centro_costo_simple as varchar)
                                                end
                                                
                                            
                                              if  @rd_post_ncorr=0 and @rd_tcom_ccod=7
                                                begin
                                                
                                                    select @vsof_centro_costo=cenc_ccod_softland, 
                                                        @vsof_centro_costo_simple=cenc_ccod_softland_simple
									                    from centros_de_costos_softland 
									                        where tdet_ccod=@rd_tipo_detalle
                                                end
                                              
                                              -- PARA EL CASO DE LAS REPACTACIONES (QUE EN REALIDAD SON FACTURAS)  
                                              if @rd_tcom_ccod=3 and @rd_tipo_detalle <> 6
                                                  begin
                                                     select @vsof_centro_costo=cenc_ccod_softland, 
                                                        @vsof_centro_costo_simple=cenc_ccod_softland_simple
									                    from centros_de_costos_softland 
									                        where tdet_ccod=@rd_tipo_detalle
                                                  end  
									        ------------------------------------------------------------------------------------------
                                            
                                           -- print 'centro costo'+cast(@vsof_centro_costo_simple as varchar)
                                        --=========================================================================================================                                            --para obtener la cuenta contable asociada al haber 
                                            -- verificar si corresponde a otros compromisos para asociar el detalle relacionado
                                            -- o no tiene un documento asociado
									        if @rd_tcom_ccod=25 or @rd_documento is null
                                                begin
                                                    --plan de cuenta segun el compromiso que  esta pagando
                                                    select @vsof_plan_cuenta    =   protic.obtener_cuenta_soft(null,@rd_tipo_detalle)
                                                    select @v_largo_plan        =   len(@vsof_plan_cuenta)
                                            
                                                    if @v_largo_plan < 12
                                                        begin
                                                            set @v_plan_completo=0
                                                        end
                                                    else
                                                        begin     
                                                            set @v_plan_completo =1
                                                        end
                                                end
                                            else
                                                begin
                                                --plan de cuenta segun el documento que esta pagando
                                                    if @rd_tcom_ccod=31 -- si paga un pagare se asigna el tipo ingreso pagare que esta ingresado como ajuste historico por migracion
                                                        begin
                                                            set @rd_documento   =26 -- codigo de pagare 
                                                        end
                                                        
                                                    select @vsof_plan_cuenta       =   protic.obtener_cuenta_soft(@rd_documento,null)
                                                    
                                                    set @v_plan_completo =0
                                                    
                                                end    
                                                
                                                -- validacion extra para el pago de titulaciones (especifica)
                                                if @rd_tipo_detalle=1230
                                                    begin
                                                        select @vsof_plan_cuenta    =   protic.obtener_cuenta_soft(null,@rd_tipo_detalle)
                                                        set @v_plan_completo =1
                                                    end
                                               
                                                if @rd_tipo_detalle=1247 and @rd_tcom_ccod=10 --para el caso en que se pago un concepto (Cargos migrados)
                                                    begin
                                                        select @vsof_plan_cuenta    =   protic.obtener_cuenta_soft(null,1226) --(derivado a intereses por moro)
                                                        set @v_plan_completo = 1
                                                    end 
                                                    
                                     --=========================================================================================================
                 /*                           if @rd_tcom_ccod=22 and @rd_ting_ccod=10
                                                begin
                                                    set @v_agrupador = @v_agrupador_cedentes
                                                    
                                                end*/
                                                
									        -----------------------------------------------------------------------------------
                                            select @vsof_detalle_gasto     =   protic.obtener_detalle_soft(@rd_tipo_detalle,null)
                                   	        select @vsof_tipo_datos        =   protic.obtener_tipo_soft(@rd_ting_ccod)
									        select @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(@rd_documento)
									        -----------------------------------------------------------------------------------
                                            
                                          
                                            -- validacion extra para facturas pos cobrar (ingresadas como cargo por caja)
                                            if @rd_tipo_detalle=1214 and @rd_documento is null
                                                begin
                                                    set @vsof_tipo_datos_ref    = 'FE'
                                                    set @rd_numero_doc          = null
                                                end    
                                            --validacion extra para pagares sin detalle (mal migrados)    
                                            if @rd_tcom_ccod=31
                                            begin
                                                set @vsof_tipo_datos_ref    = 'PT'
                                                set @rd_numero_doc          = cast(@rd_num_fox as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                            end    
                                            -- validacion extra para tarjetas T3 
                                            if @rd_tipo_tarjeta='T3' and @rd_documento is not null
                                                begin
                                                    set @vsof_plan_cuenta       = @v_vsof_cuenta_tarjeta_3
                                                    set @vsof_tipo_datos        = @rd_tipo_tarjeta
                                                    set @vsof_tipo_datos_ref    = @rd_tipo_tarjeta
                                                    set @v_plan_completo=0
                                                end  

                                            if @rd_ting_ccod=13 or @rd_ting_ccod=51 or @rd_ting_ccod=52
                                                begin
                                                    set @rd_ding_ndocto         = cast(@rd_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                                end
                                
                                           if @rd_documento=13 or @rd_documento=51 or @rd_documento=52
                                                begin
                                                    set @rd_numero_doc          = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                                end   


                                            -- validacion extra para la cuenta Devolucion Alumno (especifica)
                                            if @rd_tipo_detalle=1284
                                                begin
                                                    select @vsof_tipo_datos      =  'DA'
                                                    select @vsof_tipo_datos_ref  =  'DA'
                                                    if @rd_documento is null
                                                        begin
                                                            set @rd_numero_doc=@rd_ding_ndocto
                                                        end
                                                end     

                                            --@rd_ting_ccod <> 6 and
                                            if  @v_plan_completo <> 1  --(0=incompleto ,1= completo) => cuenta+centro_costo=plan_completo
                                                begin  
                                                
                                                    select @v_largo_plan=len(@vsof_plan_cuenta)--validacion adicional para obtener el largo del plan
                                                    
                                                    if @rd_ting_ccod = 6 and @rd_tcom_ccod=22 --si es efectivo pero para una letra
                                                        begin
                                                            set @v_glosa_softland       =   substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                                            set @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(4)
                                                            
                                                            --validacion para que no repita centro de costo cada vez
                                                            if @v_largo_plan < 12
                                                                begin
                                                                    set @vsof_plan_cuenta       =   @vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
                                                                end
                                                            
                                                            if @rd_documento is null
                                                                begin
                                                                    set @rd_numero_doc=null
                                                                end
                                                        end
                                                    
                                                    if @rd_ting_ccod = 6 and (@rd_documento is null or @rd_documento=6) --si es efectivo y no paga un documento
                                                        begin
                                                            set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                                        end
                                                    else -- si no es efectivo o no tiene documento asociado
                                                        begin
                                                               --validacion para que no repita centro de costo cada vez
                                                               select @v_largo_plan=len(@vsof_plan_cuenta)
                                                               if @v_largo_plan < 12
                                                                begin
                                                                    set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
                                                                end
                                                               
                                                               if @rd_documento is null and @rd_tcom_ccod=22
                                                                    begin
                                                                        set @rd_numero_doc          =   @rd_num_fox
                                                                        set @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(4)
                                                                       
                                                                    end  
    											            set @v_glosa_softland= @rd_tcom_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                                            
                                                        end 
                                                        
                                                        if @rd_documento is null and @rd_tcom_ccod=3                                                                
                                                            begin
                                                                set @rd_numero_doc          =   @rd_num_fox
                                                                set @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(49)--factura exenta (o no afecta)
                                                                
                                                                --validacion para que no repita centro de costo cada vez
                                                                select @v_largo_plan=len(@vsof_plan_cuenta)
                                                                if @v_largo_plan < 12
                                                                    begin
                                                                        set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
                                                                    end    
                                                               --print 'entra en factura 2 vesion'
                                                            end 
                                                end
									        else
										        begin
											        set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
										        end   
									--print 'centro costo: '+cast(@vsof_centro_costo_simple as varchar)

------------------------------------------------------------------------------------------                                    
--repactaciones                                     
if @r_ting_ccod=15
begin
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
    set @v_hace_efe='NO'
end

--ingreso por regularizacion
if @r_ting_ccod=15
begin
--    set @rd_numero_doc          =   @rd_num_fox
    set @vsof_tipo_datos_ref    =   'BD' --(becas y descuentos)
end
------------------------------------------------------------------------------------------
											
								

	        set @vsof_monto_generico = @rd_abon_mabono + @vsof_monto_generico


        Select  @v_usa_controla_doc=usa_controla_doc, @v_usa_centro_costo=usa_centro_costo,
                @v_usa_auxiliar=usa_auxiliar, @v_usa_detalle_gasto=usa_detalle_gasto,
                @v_usa_conciliacion=usa_conciliacion, @v_usa_pto_caja=usa_pto_caja
        From cuentas_softland Where cuenta=@vsof_plan_cuenta



        set @h_otros_vsof_glosa_softland    =   @v_glosa_softland

        set @h_otros_vsof_cod_auxiliar      =   null
        set @h_otros_vsof_tipo_datos        =   null
        set @h_otros_vsof_numero_doc        =   null
        set @h_otros_vsof_fecha_emision     =   null
        set @h_otros_vsof_fecha_pago        =   null
        set @h_otros_vsof_tipo_datos_ref    =   null
        set @h_otros_vsof_numero_doc_ref    =   null
        set @h_otros_vsof_detalle_gasto     =   null
        set @h_otros_vsof_centro_costo      =   null
        set @h_otros_vsof_cantidad_gasto    =   null

        if @v_usa_controla_doc='S'
            begin
                set @h_otros_vsof_cod_auxiliar     = @r_pers_nrut
                set @h_otros_vsof_tipo_datos       = @vsof_tipo_datos
                set @h_otros_vsof_numero_doc       = @rd_ding_ndocto
                set @h_otros_vsof_fecha_emision    = @rd_ingr_fpago  
                set @h_otros_vsof_fecha_pago       = @rh_ding_fdocto
                set @h_otros_vsof_tipo_datos_ref   = @vsof_tipo_datos_ref
                set @h_otros_vsof_numero_doc_ref   = @rd_numero_doc
            end
    
        if @v_usa_centro_costo='S'
            begin
                set @h_otros_vsof_centro_costo = @vsof_centro_costo
               
            end
        if @v_usa_auxiliar='S'
            begin
                set @h_otros_vsof_cod_auxiliar = @r_pers_nrut
            end
        if @v_usa_detalle_gasto='S'
            begin
                set @h_otros_vsof_detalle_gasto = @vsof_detalle_gasto
                set @h_otros_vsof_cantidad_gasto= 1
            end
        set @v_nlinea = @v_nlinea + 1
        --- fin otros calculos


                                insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
                                                  audi_tusuario, audi_fmodificacion,
										          trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
										          tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
                                                  tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
				                    values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
				   						          @p_audi_tusuario, getdate(),
										          @r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
										          @vsof_plan_cuenta,@rd_abon_mabono,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
                                                  @h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto)
                           -- end
            if  @v_limite_linea_cedente = 1 --cuando llego a 50 cedentes
                begin
                    set @v_agrupador=   @v_agrupador+   1
                    set @v_nlinea   =   @v_nlinea   +   1
                    
                              insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
										  tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa)
				              values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,@p_audi_tusuario, getdate(),   
									@v_vsof_cuenta_cuadre,@v_soft_monto_cedente,@v_agrupador,@d_otros_vsof_glosa_softland)
                    
                    set @v_mantiene_agrupador   =   1
                    set @v_limite_linea_cedente =   0
                    set @v_soft_monto_cedente   =   0
                end 
                                  --  print '_____________________________'                                                                                                  
                                    FETCH NEXT FROM c_haber_sof
                                        INTO  @rh_ding_fdocto,@rh_ting_ccod,
						                      @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
						                      @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr, @rd_tipo_detalle,@rd_numero_doc,
						                      @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta,@rd_num_fox
			                        end --fin while c_haber_sof

               		            CLOSE c_haber_sof 
						        DEALLOCATE c_haber_sof	 

                            
        --######################################################################
        --				####  	####	####	#####
        -- 				#		#		#		#
        --- 			####	###		####	##### 	
        -- 				#		#		#			#
        -- 				####	#		####    #####
        --######################################################################

if @r_ting_ccod <> 9 and @r_ting_ccod <>15
    begin
    
        DECLARE c_efes_haber CURSOR LOCAL FOR
        select g.tcom_ccod,sum(b.abon_mabono) as total, e.tdet_ccod,max(g.tdet_tdesc) as detalle
        From ingresos a
         join  abonos b
	        on a.ingr_ncorr = b.ingr_ncorr
         join tipos_compromisos c
	        on b.tcom_ccod     = c.tcom_ccod
         left outer join detalle_ingresos di 
	        on a.ingr_ncorr 	= di.ingr_ncorr
         join detalles e
	        on b.comp_ndocto  = e.comp_ndocto
	        and b.tcom_ccod   = e.tcom_ccod
	        and b.inst_ccod   = e.inst_ccod
        left outer join tipos_ingresos f
	        on di.ting_ccod = f.ting_ccod
         join tipos_detalle g
            on e.tdet_ccod=g.tdet_ccod        
          Where a.mcaj_ncorr = @p_mcaj_ncorr
          and a.ting_ccod  = @r_ting_ccod
          and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
          and a.pers_ncorr = @r_pers_ncorr
          and di.ting_ccod not in (53)
          and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') is null
        GROUP BY  e.tdet_ccod,g.tcom_ccod
        order by e.tdet_ccod asc

                            OPEN c_efes_haber
                            FETCH NEXT FROM c_efes_haber
                            INTO  @rf_tcom_ccod,@rf_monto,@rf_tipo,@rf_detalle

                                While @@FETCH_STATUS = 0
	                                begin
                                   
                                   if  (@rf_tipo <> 1219 and @rf_tipo <> 1214) and @rf_tcom_ccod <> 7  --nueva validacion (1219=fondos a rendir,1214=factura a cobrar(provisoria), no lleva efe)
                                        BEGIN
                                            set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
                                            set @v_nlinea           =   @v_nlinea+1
                                            set @rf_detalle         =   @rf_detalle+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                            
                                                    --DEBE EFE                       
		 	                                        insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                                              caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											                              tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_cod_auxiliar,tsof_glosa)
			                                        values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_arancel, @r_pers_nrut_c, @r_pers_xdv_c,
			                                         @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						                             @vsof_plan_cuenta,@rf_monto,@v_agrupador,@r_pers_nrut,@rf_detalle)

                                             set @v_nlinea           =   @v_nlinea+1      
                                                  
                                                   --HABER EFE
                                                    insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                                              caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											                              tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_cod_auxiliar,tsof_glosa)
			                                        values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_arancel, @r_pers_nrut_c, @r_pers_xdv_c,
			                                                @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
						                                    @vsof_plan_cuenta,@rf_monto,@v_agrupador,@r_pers_nrut,@rf_detalle)
                                       
                                        END --fin fondos a rendir
                                        
                                    FETCH NEXT FROM c_efes_haber
                                        INTO  @rf_tcom_ccod,@rf_monto,@rf_tipo,@rf_detalle
                                    end
                                    
                            CLOSE c_efes_haber 
					        DEALLOCATE c_efes_haber	   
                              
                     end  -- EFES  Fin tipos <> 9 y 15 ( Repactaciones )
                     
                     
    --#####################################################################################
    -- total al debe  para el pago de cedentes de letras
	      if @v_soft_monto_cedente >0 and @v_cantidad_lineas > 0 and @v_conteo_cedentes=@v_cantidad_cedentes
            begin
                 
                --print 'monto total cdente: '+cast(@v_soft_monto_cedente as varchar)              
                  set @v_nlinea = @v_nlinea+1
                  set @vsof_plan_cuenta       =   @v_vsof_cuenta_caja

                  insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
                              caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa,trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion
					          ,trca_fecha_ingreso,trca_fecha_vence,trca_tipo_ingreso,trca_sede_carrera,trca_jornada_carrera,trca_carrera_asociada,
					          trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
					          tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
                              tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
		          values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
				   	          @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, @rd_ingr_ncorr, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,@rd_ding_ndocto, @p_audi_tusuario, getdate(),
					          @rh_ingr_fpago,null, @rh_ting_ccod,@v_sede, @v_jornada,@v_carrera,
					          @r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
					          @vsof_plan_cuenta,@v_monto_caja,@d_otros_vsof_cod_auxiliar,@d_otros_vsof_tipo_datos,@d_otros_vsof_numero_doc,@d_otros_vsof_fecha_emision,@d_otros_vsof_fecha_pago,@d_otros_vsof_tipo_datos_ref,@d_otros_vsof_numero_doc_ref,@v_agrupador,@d_otros_vsof_glosa_softland,
                              @d_otros_vsof_detalle_gasto,@d_otros_vsof_centro_costo,@d_otros_vsof_cantidad_gasto)
                  
                  set @v_soft_monto_cedente =0
                  set @v_conteo_cedentes    =0
                  set @v_cantidad_lineas    =0
                           
            end            
    --#####################################################################################        
                     
                     
end	-- Fin tipo arancel
	

			    FETCH NEXT FROM c_ingresos
			    INTO  @r_mcaj_ncorr,@r_caje_ccod,@r_sede_ccod,@r_ting_ccod,@r_ingr_nfolio_referencia,
				      @r_pers_ncorr,@r_pers_nrut,@r_pers_xdv,@r_ting_tdesc,@r_monto,@r_finicio,
			          @r_nombre_a, @r_paterno_a, @r_materno_a, @r_fono_a,
			          @r_direccion_a, @r_comuna_a, @r_ciudad_a,
			          @r_nombre_c, @r_paterno_c, @r_materno_c, @r_fono_c,
			          @r_direccion_c, @r_comuna_c, @r_ciudad_c
				      ,@r_pers_nrut_c,@r_pers_xdv_c
		     end --fin While  c_ingresos
	     
	 	    CLOSE c_ingresos 
		    DEALLOCATE c_ingresos	      

--     --#####################################################################################
--     -- total al debe  para el pago de cedentes de letras
-- 	      if @v_soft_monto_cedente >0 and @v_cantidad_lineas > 0
--             begin
--                  
--                 --print 'monto total cdente: '+cast(@v_soft_monto_cedente as varchar)              
--                   set @v_nlinea = @v_nlinea+1
--                   set @vsof_plan_cuenta       =   @v_vsof_cuenta_caja
--                   
--                   insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
--                               caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa,trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion
-- 					          ,trca_fecha_ingreso,trca_fecha_vence,trca_tipo_ingreso,trca_sede_carrera,trca_jornada_carrera,trca_carrera_asociada,
-- 					          trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
-- 					          tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
--                               tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
-- 		          values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
-- 				   	          @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, @rd_ingr_ncorr, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,@rd_ding_ndocto, @p_audi_tusuario, getdate(),
-- 					          @rh_ingr_fpago,null, @rh_ting_ccod,@v_sede, @v_jornada,@v_carrera,
-- 					          @r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
-- 					          @vsof_plan_cuenta,@v_monto_caja,@d_otros_vsof_cod_auxiliar,@d_otros_vsof_tipo_datos,@d_otros_vsof_numero_doc,@d_otros_vsof_fecha_emision,@d_otros_vsof_fecha_pago,@d_otros_vsof_tipo_datos_ref,@d_otros_vsof_numero_doc_ref,@v_agrupador_cedentes,@d_otros_vsof_glosa_softland,
--                               @d_otros_vsof_detalle_gasto,@d_otros_vsof_centro_costo,@d_otros_vsof_cantidad_gasto)
--                               
--             end            
--     --#####################################################################################        
		 -------------------------------------------------------------------------------------------------------
		 update movimientos_cajas
		    set MCAJ_BTRASPASADA_SOFTLAND = 'S'
		    where mcaj_ncorr = @p_mcaj_ncorr		 

	select @v_salida_error as valor
end
else
    begin
        print 'la caja es de anulacion o cedentes'
    end
END