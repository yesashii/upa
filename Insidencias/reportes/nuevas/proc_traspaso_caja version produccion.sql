CREATE PROCEDURE TRASPASAR_CAJA_SOLFTLAND (
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
declare @v_anio_caja numeric
declare @v_sede_caja numeric    
--********* OBTIENE EL TIPO DE CAJA A TRASPASAR *************************************
select @v_sede_caja=sede_ccod, @v_anio_caja=datepart(year,mcaj_finicio),@v_tipo_caja=tcaj_ccod from movimientos_cajas  where mcaj_ncorr=@p_mcaj_ncorr
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
declare @v_monto_iva numeric
declare @v_proximo numeric
declare @v_peri_ccod numeric
declare @v_ano_academico varchar(4)
declare @v_calcula_iva numeric
declare @v_monto_temporal numeric
-------------------------------------------
-------VARIABLES DEL CURSOR C_INGRESOS ----
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
-------  VARIABLES DEL CURSOR C_HABER  -----
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
declare @rd_peri_ccod numeric
------------------------------------------

-------  VARIABLES DEL CURSOR C_DEBE  -----
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

-- variables cursor C_EFE_CURSOS (Efes para cursos)-----------
DECLARE @rc_monto NUMERIC
DECLARE @rc_tipo NUMERIC
DECLARE @rc_detalle varchar(150)
DECLARE @rc_tcom_ccod numeric
-------------------------------------------

-- Variable Cursos c_descuentos_becas ("Descuentos y Becas")-------------
declare @rbd_tipo_descuento numeric
declare @rbd_glosa_descuento varchar(100)
declare @rbd_descuento_matricula numeric
declare @rbd_descuento_arancel numeric
declare @rbd_descuento_total numeric
-------------------------------------------------------------------------

--Variable del cursor c_nota_credito_soft
declare @rnc_ndcr_ncorr numeric
declare @rnc_tdet_ccod numeric
declare @rnc_dncr_mdetalle numeric
declare @rnc_tcom_ccod numeric
declare @rnc_tipo_detalle varchar(100)
declare @rnc_tcom_ccod_origen numeric
declare @rnc_ting_tdesc varchar(100)

--control de errores, depurar con trasaccion
declare @v_salida_error varchar(100)

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
declare @v_vsof_ingreso_aticipado_proximo varchar(20)
declare @v_vsof_cuenta_caja varchar(20)
declare @v_vsof_cuenta_cuadre varchar(20)
declare @v_vsof_cuenta_tarjeta_3 varchar(20)
declare @v_vsof_cuenta_becas_descuentos varchar(20)
declare @v_vsof_cuenta_becas_descuentos_prox varchar(20)
declare @v_vsof_cuenta_becas_descuentos_presen varchar(20)
declare @v_soft_cuenta_cte_personal varchar(20)
declare @v_soft_cuenta_doc_varios varchar(20)
declare @v_soft_cuenta_iva varchar(20)
declare @v_soft_gasto_protesto varchar(20)
declare @v_soft_monto_cedente numeric
declare @v_cantidad_lineas numeric
declare @v_agrupador_cedentes numeric
declare @v_soft_monto_cedente_faltante numeric
declare @v_limite_linea_cedente numeric
declare @v_conteo_cedentes numeric
declare @v_mantiene_agrupador numeric
declare @v_cuadre_acumulado numeric
declare @v_soft_cuenta_editorial  varchar(20)
declare @v_soft_cuenta_editorial_pagar varchar(20)
declare @v_soft_cuenta_devolucion_pago varchar(20)
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
declare @v_ano_actual numeric
declare @v_ano_castigo numeric
declare @v_documento_asociado numeric
declare @v_auxiliar_mineduc numeric
declare @v_csof_ncorr numeric
declare @v_auxiliar_cobracar numeric
declare @v_auxiliar_socofin numeric
declare @v_auxiliar_biobio  numeric
declare @v_auxiliar_auxiliar numeric
declare @v_ofer_ncorr numeric
declare @v_espe_ccod numeric
declare @v_pago_oc numeric
declare @v_folio_contrato numeric
declare @v_devolver numeric
declare @v_medio_pago numeric
declare @v_es_anulacion numeric
declare @v_tdet_ccod numeric
declare @v_existe_curso numeric
declare @v_num_curso numeric
-----------------------------------------------------

-----------------------------------------------------
--variables temporales para debe- contrato
declare @debe_rd_abon_mabono        numeric
declare @debe_vsof_cod_auxiliar  numeric
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
declare @d_otros_rd_abon_mabono   numeric
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


--##############     INICIALIZACION DE VARIABLE ####################
select @v_ano_actual = datepart(year, getdate())

set @v_total_descuento_arancel =0
set @v_total_descuento_matricula =0


--Inicializa variables Cuentas Contables

set @v_vsof_ingreso_aticipado_presente          =   '2-10-140-04-120001'
set @v_vsof_cuenta_becas_descuentos_presen      =   '2-10-140-09-120001'

set @v_vsof_ingreso_aticipado_proximo           =   '2-10-140-03-120001'
set @v_vsof_cuenta_becas_descuentos_prox        =   '2-10-140-08-120001'

set @v_vsof_cuenta_efe                  =   '1-10-040-30'
set @v_vsof_cuenta_caja                 =   '1-10-010-10-000001'
set @v_vsof_cuenta_cuadre               =   '9-10-010-10-000001'
set @v_vsof_cuenta_tarjeta_3            =   '1-10-050-60'
set @v_soft_cuenta_cte_personal         =   '1-10-060-40-000001'
set @v_soft_cuenta_doc_varios           =   '1-10-050-05'
set @v_soft_cuenta_iva                  =   '2-10-120-10-000001'
set @v_soft_gasto_protesto              =   '6-40-010-10-000001'
set @v_soft_cuenta_editorial            =   '1-10-070-10-000002'
set @v_soft_cuenta_editorial_pagar      =   '2-10-100-10-000012'
set @v_soft_cuenta_devolucion_pago      =   '2-10-070-15-000100'
set @v_auxiliar_mineduc                 =   '60901000'
set @v_auxiliar_biobio                  =   '96516560'
set @v_auxiliar_auxiliar                =   '0'
set @v_auxiliar_cobracar                =   '0'
set @v_auxiliar_socofin                 =   '0'

set @v_agrupador    = 0
set @v_salida_error = null
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
set @v_cuadre_acumulado=0
set @v_es_anulacion=0


if @v_tipo_caja='1000'
begin



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
		  	where b.eing_ccod not in (2,3,6,7) -- pendientes,nulos, anulado, intereses repactacion
			and a.mcaj_ncorr = @p_mcaj_ncorr
			and b.ting_ccod not in (30,46,8,39,2) 
			--and b.ting_ccod in (7)
			--and b.ingr_nfolio_referencia in (180907)
			and b.ingr_nfolio_referencia not in (
			-- para igualmente procesar los comprobantes anulados en dias posteriores,
			 -- pero dejando fuera los anulados el mismo dia de apertur de la caja
                              select distinct ingr_nfolio_referencia from ingresos 
                                where protic.trunc(audi_fmodificacion) = convert(datetime,protic.trunc(a.mcaj_finicio),103) 
                                and mcaj_ncorr=a.mcaj_ncorr
                                and audi_tusuario like '%ANULA_INGRESO%'
                                and eing_ccod  in (2,3,6)
             	)
			 and b.ingr_nfolio_referencia not in ( 
			 -- quita la generacion de cheque protestado (es documento en caja, pero no quita los pago de cheques)
				 	select  ingr_nfolio_referencia from ingresos ing , detalle_ingresos ding 
	                where ing.ingr_ncorr=ding.ingr_ncorr
                    	and ing.ingr_nfolio_referencia = b.ingr_nfolio_referencia
	                and ing.ingr_ncorr=b.ingr_ncorr
	                and ing.ting_ccod=88
	                and ding.ting_ccod=38
            	)                
			 and b.ingr_nfolio_referencia not in (   
			 -- quita la documentacion (se ocupa para repactar)
				 	select  ingr_nfolio_referencia from ingresos ing , detalle_ingresos ding 
	                where ing.ingr_ncorr=ding.ingr_ncorr
                    and ing.ingr_nfolio_referencia = b.ingr_nfolio_referencia
	                and ing.ingr_ncorr=b.ingr_ncorr
	                and ing.ting_ccod=16
	                and ding.ting_ccod=53
            	)       
		  	group by a.mcaj_ncorr, a.caje_ccod, a.sede_ccod, b.ting_ccod, b.ingr_nfolio_referencia, 
		            b.pers_ncorr, c.pers_nrut, c.pers_xdv, d.ting_tdesc, a.mcaj_finicio,
		        c.pers_tnombre, c.pers_tape_paterno, c.pers_tape_materno, c.pers_tfono,
		        dir.dire_tcalle, dir.dire_tnro, ciu.CIUD_TDESC, ciu.CIUD_TCOMUNA,
		        pc.pers_tnombre, pc.pers_tape_paterno, pc.pers_tape_materno, pc.pers_tfono,
		        cdir.dire_tcalle, cdir.dire_tnro, cciu.CIUD_TDESC, cciu.CIUD_TCOMUNA,pc.pers_nrut,pc.pers_xdv
			order by b.ting_ccod desc,b.ingr_nfolio_referencia asc

-- (ting_ccod = 39,88) filtrado momentaneamente , se debe cambiar el asiento a Protesto contra Banco.

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
              set @vsof_plan_cuenta=null
              set @v_sede = null 
              set @v_jornada= null
              set @vsof_centro_costo=null
              set @vsof_centro_costo_simple = null


--****************************************************************************************
--**********   SUMATORIA DEL MOVIMIENTO DE LA CAJA para cedentes     *********************--

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
					        isnull(di.ding_ndocto,1) as ding_ndocto_2,
					        a.ingr_mtotal, di.banc_ccod,a.ingr_fpago ,di.ding_fdocto,isnull(f.ting_ccod,6)as ting_ccod,
					        a.ingr_ncorr, case c.tcom_ccod when 25 then (select tdet_tdesc from tipos_detalle where tdet_ccod=e.tdet_ccod) else c.tcom_tdesc end as tcom_tdesc,
                        b.comp_ndocto,b.abon_mabono, 
                        case f.ting_ccod when 52 then protic.obtener_numero_pagare_softland(a.ingr_ncorr) else isnull(di.ding_ndocto,1) end as ding_ndocto,
                        a.ingr_fpago,isnull(di.ting_ccod,6) as ting_ccod,isnull(protic.obtener_post_ncorr(a.pers_ncorr,b.comp_ndocto,null),0) as post_ncorr, e.tdet_ccod,
					     case f.ting_ccod when 52 then protic.obtener_numero_pagare_softland(a.ingr_ncorr) else isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto'),0) end as numero_docto,
					  (select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as banco,
					        (select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as vencimiento,
					        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as documento,c.tcom_ccod,
						    case f.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(a.ingr_ncorr,di.ding_ndocto) end as tipo_tarjeta,b.peri_ccod
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
                          Where a.eing_ccod not in (2,3,6)
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
						      @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta, @rd_peri_ccod
                    
                        While @@FETCH_STATUS = 0
	                            begin
                                     
								     set @vsof_plan_cuenta=''
									 set @v_espe_ccod=null
                                     
                                     select @v_ano_academico=anos_ccod from periodos_academicos where peri_ccod=@rd_peri_ccod
                                     	
                                     --------CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS-----
								      select @v_espe_ccod=c.espe_ccod,@v_ofer_ncorr=b.ofer_ncorr,@v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
									    From postulantes a ,ofertas_academicas b, especialidades c
									  where a.ofer_ncorr=b.ofer_ncorr
     						            and b.espe_ccod=c.espe_ccod
                                   	    and a.post_ncorr=@rd_post_ncorr
                
                             if @v_sede is null and @v_jornada is null and @rd_tcom_tdesc='EXAMEN ADMISION' 
        							    begin
        								    --print 'no estaba matriculado'
        								   select top 1 @v_espe_ccod=c.espe_ccod,@v_ofer_ncorr=b.ofer_ncorr,@v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
        									    From detalle_postulantes a ,ofertas_academicas b, especialidades c
        									    where a.ofer_ncorr=b.ofer_ncorr
       											and b.espe_ccod=c.espe_ccod
            							    	and a.post_ncorr=@rd_post_ncorr
        							    end
								    ----------------------------------------------------------------------------
            
								        --	print 'sede:'+cast(@v_sede as varchar)+' Carrera:'+cast(@v_carrera as varchar)+' Jornada:'+cast(@v_jornada as varchar)	
									 --------------------------------------------------
									    select @vsof_centro_costo=b.ccos_tcompuesto,@vsof_centro_costo_simple=b.ccos_tcodigo
										    from centros_costos_asignados a, centros_costo b 
										    where a.cenc_ccod_carrera=@v_carrera
											    and a.cenc_ccod_jornada=@v_jornada
											    and a.cenc_ccod_sede=@v_sede
                                                and a.ccos_ccod=b.ccos_ccod
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
									            set @vsof_plan_cuenta= @vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
											    set @v_glosa_softland= @rd_tcom_tdesc+' '+cast(@v_ano_academico as varchar)+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
                                            end
									    else
										    begin
											    set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
										    end   
									    -----------------------------------------------------------------------

                                        if @rd_ting_ccod=13 or @rd_ting_ccod=51
                                            begin
                                                set @rd_ding_ndocto         = cast(@rd_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                            end

   if @rd_documento=13 or @rd_documento=51
        begin
set @rd_numero_doc    = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
          end  
                                		
                                        if @rd_peri_ccod<214 and @rd_ting_ccod=52
                                            begin
                                                set @rd_ding_ndocto         = cast(@rd_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                            end
                                        	
                                        if @rd_peri_ccod<214 and @rd_documento=52
                                            begin
                                                set @rd_numero_doc         = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
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


    Select @v_csof_ncorr=count(*) From cuentas_softland Where cuenta=@vsof_plan_cuenta

    Select @v_usa_controla_doc=isnull(usa_controla_doc,'N'), @v_usa_centro_costo=isnull(usa_centro_costo,'N'),
      @v_usa_auxiliar=isnull(usa_auxiliar,'N'), @v_usa_detalle_gasto=isnull(usa_detalle_gasto,'N'),
      @v_usa_conciliacion=isnull(usa_conciliacion,'N'), @v_usa_pto_caja=isnull(usa_pto_caja,'N')
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
            set @debe_vsof_tipo_datos       = null
            set @debe_vsof_numero_doc       = null
            set @debe_vsof_fecha_pago       = null
            set @debe_vsof_fecha_inicio     = null
            set @debe_vsof_tipo_datos_ref   = null
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

    if @v_csof_ncorr=0
        begin
            set @debe_vsof_detalle_gasto    = null
            set @debe_vsof_cantidad_gasto   = null
            set @debe_vsof_cod_auxiliar     = null
            set @debe_vsof_centro_costo     = null
  			set @debe_vsof_cod_auxiliar     = null
            set @debe_vsof_tipo_datos       = null
            set @debe_vsof_numero_doc       = null
 			set @debe_vsof_fecha_pago       = null
            set @debe_vsof_fecha_inicio     = null
            set @debe_vsof_tipo_datos_ref   = null
            set @debe_vsof_numero_doc_ref   = null
 
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




    -- marca al proximo ejercicio
        if @rd_peri_ccod=218 and @v_anio_caja=2009
           begin
                set @v_proximo=1
            end
        else
     begin
                set @v_proximo=0
            end     


				       IF @@ERROR <> 0 
					    BEGIN
					   	    set @v_salida_error=' Error en asientos al debe'
					    END

				        FETCH NEXT FROM c_debe
                     INTO  @rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,@rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,
                              @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
                              @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr,@rd_tipo_detalle,@rd_numero_doc,@rd_banco_pacta,
                              @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta,@rd_peri_ccod
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



     if @v_proximo=1 -- cambia cuenta para el proximo ejercicio
        begin
            SET @v_vsof_cuenta_becas_descuentos=@v_vsof_cuenta_becas_descuentos_prox
        end
     else
        begin
            SET @v_vsof_cuenta_becas_descuentos=@v_vsof_cuenta_becas_descuentos_presen
   end
       
 set @v_total_descuento_matricula=@rbd_descuento_matricula+@v_total_descuento_matricula
    set @v_total_descuento_arancel  =@rbd_descuento_arancel+@v_total_descuento_arancel
                        select @vsof_detalle_gasto_descuento = protic.obtener_detalle_soft(@rbd_tipo_descuento,null) 
                        
                           
                    -----------------------------------------------------------------------------------------------------------------------------
                        IF @rbd_descuento_matricula > 0
                            BEGIN       
                            -- DESCUENTOS POR MATRICULA 
   set @v_nlinea = @v_nlinea+1
                                set @glosa_descuento_matricula    =   @rbd_glosa_descuento+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar) 

   -- VALOR AL DEBE DEL DESCUENTO
                                  insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
        tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto )
                    values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea, @r_ting_ccod, @p_audi_tusuario, getdate(),
                                         @v_vsof_cuenta_becas_descuentos,@rbd_descuento_matricula,@v_agrupador,@glosa_descuento_matricula,@vsof_detalle_gasto_descuento,@vsof_centro_costo,1 )

                  END

              IF @rbd_descuento_arancel > 0
                       BEGIN
                
                               -- DESCUENTOS POR ARANCEL 
                                set @v_nlinea = @v_nlinea+1
                                set @glosa_descuento_arancel    =   @rbd_glosa_descuento+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)  
                            
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
    if @v_proximo=1 
        begin
            SET @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_proximo
        end
    else
        begin
      SET @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_presente
     end

     --asientos
    if @vsof_monto_matricula >0 or @v_total_descuento_matricula>0
        begin
            set @vsof_detalle_gasto=   'AR-01-01'
 set @v_nlinea   =   @v_nlinea+1
            set @v_glosa_softland   =  'MATRICULA '+cast(@v_ano_academico as varchar)+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)    
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
        
                  insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod, trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
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
                 set @v_glosa_softland='ARANCEL '+cast(@v_ano_academico as varchar)+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar) 
            
          if @vsof_monto_arancel=0
            begin
                       set @vsof_monto_arancel_bruto=@v_total_descuento_arancel
            end
         else
            begin
   				set @vsof_monto_arancel_bruto = @v_total_descuento_arancel + @vsof_monto_arancel
            end

            set @v_total_descuento_arancel=0
            	

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
    -- 				#	    #	    #	    #
    --- 			####	###	    ####	##### 	
    -- 				#	    #	    #	        #
    -- 				####	#	    ####    #####
    --######################################################################    

          
    if @vsof_monto_matricula >0
            begin
    -- efes matricula
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
                set @v_nlinea           =   @v_nlinea+1
                set @v_glosa_softland  =   'MATRICULA '+cast(@v_ano_academico as varchar)+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)    
  
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

                set @vsof_plan_cuenta   = @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
                set @v_nlinea           =   @v_nlinea+1
                set @v_glosa_softland   =  'ARANCEL '+cast(@v_ano_academico as varchar)+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)    
                    
                    --efe debe
			          insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
			                                 caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
											      tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_glosa,tsof_cod_auxiliar)
			       values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod, null, null, null, @vsof_monto_matricula, @r_pers_nrut_c, @r_pers_xdv_c,
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

--#########################################################
--############ 		FIN CONTRATOS		###################
--#########################################################

    else --Fin contratos	
        begin
    

            if @r_ting_ccod <> 10 --si no es cedente incrementar
           	begin
   			set @v_agrupador=@v_agrupador+1 
        	end 
 
        --####################################################################################################
        --       		        ######  #######  ######    ######  ######
        --                      #    #     #     #    #    #    #  #
        --                      #    #     #     #  #      #    #  ######
        --                      #    #     #     #   #     #    #       #
        --                      ######     #     #    #    ######  ######
        --####################################################################################################



        -- ######   DEBE   ###### 
         
       DECLARE c_debe_soft CURSOR LOCAL FOR
        Select a.ingr_ncorr, 
            case isnull(a.ingr_mefectivo, 0) when 0 then c.ting_tdesc else 'EFECTIVO' end as ting_tdesc,
            case c.ting_ccod when 52 then protic.obtener_numero_pagare_softland(a.ingr_ncorr) else isnull(b.ding_ndocto ,1) end as ding_ndocto,
            d.abon_mabono, b.banc_ccod,a.ingr_fpago,b.ding_fdocto,isnull(c.ting_ccod,6)as ting_ccod,
            isnull(protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,null),0) as post_ncorr,
            case c.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(b.ingr_ncorr,b.ding_ndocto) end as tipo_tarjeta,
            d.comp_ndocto,d.tcom_ccod,d.inst_ccod,d.dcom_ncompromiso
        From 
        ingresos a 
        left outer join detalle_ingresos b
         on a.ingr_ncorr = b.ingr_ncorr
        	and b.ting_ccod not in (44,53) --(44=intereses_repactacion,53=DOCUMENTACION COMPROMISOS)
        left outer join tipos_ingresos c
            on b.ting_ccod = c.ting_ccod 
        join abonos d 
        on a.ingr_ncorr=d.ingr_ncorr    
        where a.eing_ccod not in (2,3,6)
       		and a.mcaj_ncorr = @p_mcaj_ncorr
            	and a.ting_ccod = @r_ting_ccod
            	and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
            	and a.pers_ncorr = @r_pers_ncorr
       		and d.abon_mabono > 0
		and a.ting_ccod not in (37)
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
            
             -------- CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS -----
			select @v_espe_ccod=c.espe_ccod,@v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
			From postulantes a ,ofertas_academicas b, especialidades c
			where a.ofer_ncorr=b.ofer_ncorr
			and b.espe_ccod=c.espe_ccod
			and a.post_ncorr=@rh_post_ncorr


                      if @v_sede is null and @v_jornada is null  
			begin
				-- print '------------- no estaba matriculado ----------------'
				select top 1 @v_espe_ccod=c.espe_ccod,@v_ofer_ncorr=b.ofer_ncorr,@v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
				From detalle_postulantes a ,ofertas_academicas b, especialidades c
				where a.ofer_ncorr=b.ofer_ncorr
				and b.espe_ccod=c.espe_ccod
				and a.post_ncorr=@rh_post_ncorr
			end

			-- obtiene centro de costo de forma normal
			select @vsof_centro_costo=b.ccos_tcompuesto,
			@vsof_centro_costo_simple=b.ccos_tcodigo
			from centros_costos_asignados a, centros_costo b 
			where a.cenc_ccod_carrera    = @v_carrera
			and a.cenc_ccod_jornada  = @v_jornada
			and a.cenc_ccod_sede     = @v_sede
			and a.ccos_ccod          = b.ccos_ccod
                                            
                            --------------------------------------------------
   
             
              ------------------------------------------------                  

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
                                            
            			if (@v_tipo_compromiso=7 or @v_tipo_compromiso=16 ) and @v_tipo_detalle is not null
            				begin
            					select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
            					from centros_costos_asignados a, centros_costo b 
            					where a.tdet_ccod=@v_tipo_detalle
            					and a.ccos_ccod=b.ccos_ccod
            				end

            			if @v_tipo_compromiso=9 and @v_tipo_detalle>100
            				begin
				
             					select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
            					from centros_costos_asignados a, centros_costo b 
            					where a.tdet_ccod=@v_tipo_detalle
            					and a.ccos_ccod=b.ccos_ccod
					
				end


            			if @v_tipo_compromiso=9 and @v_tipo_detalle =7
            				begin
				
            					select top 1 @v_tipo_compromiso=e.tcom_ccod,@v_tipo_detalle=e.tdet_ccod
        					    from ingresos a, abonos b, detalle_compromisos c, detalles e
      					        Where a.ingr_ncorr = b.ingr_ncorr
            					and b.comp_ndocto  = c.comp_ndocto
            					and b.comp_ndocto  = e.comp_ndocto
            					and b.tcom_ccod    = e.tcom_ccod
            					and b.inst_ccod    = e.inst_ccod
            					and a.ingr_nfolio_referencia   = @r_ingr_nfolio_referencia-1
            					and b.comp_ndocto   =e.comp_ndocto
            					and c.tcom_ccod=7
            					and e.deta_msubtotal>0
					
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

                        if @v_tipo_compromiso=5 and @v_tipo_detalle =13 and @rh_ting_ccod=87 -- Caso para cuando se protesta una letra de un curso de extension.
                        begin
                                    select @v_tdet_ccod=d.tdet_ccod
                                     from ingresos a, detalle_ingresos b, abonos c, detalles d
                                    where a.ingr_ncorr=b.ingr_ncorr
                                    and b.ingr_ncorr=c.ingr_ncorr
                                    and b.ding_ndocto=@rh_ding_ndocto
                                    and b.ting_ccod=4
                                    and b.ding_bpacta_cuota='S' 
                                    and c.comp_ndocto=d.comp_ndocto 
                                    and c.tcom_ccod=d.tcom_ccod

                                    select @vsof_centro_costo=b.ccos_tcompuesto, 
                                    @vsof_centro_costo_simple=b.ccos_tcodigo
                                    from centros_costos_asignados a, centros_costo b 
                                    where a.tdet_ccod=@v_tdet_ccod
                                    and a.ccos_ccod=b.ccos_ccod 
                        end


            		end -- Fin post_ncorr=0

		-----------------------------------------------------------------------------------
          
 

		-----------------------------------------------------------------------------------
                select @vsof_plan_cuenta       =  protic.obtener_cuenta_soft(@rh_ting_ccod,null)
                select @vsof_detalle_gasto     =   protic.obtener_detalle_soft(null,@rh_ting_ccod)
                select @vsof_tipo_datos        =   protic.obtener_tipo_soft(@rh_ting_ccod)
                select @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(@rh_ting_ccod)
                -----------------------------------------------------------------------------------
		 -- 101200 = centro costo universidad (para cuentas corrientes personal)
		if @rh_post_ncorr=0 and @vsof_centro_costo_simple='101200' 
			begin
				if @rh_ting_ccod <> 6
					begin
						set @vsof_plan_cuenta   = @v_soft_cuenta_doc_varios
					end
				else
					begin
						set @vsof_plan_cuenta = @v_vsof_cuenta_caja
					end
			end
		
		if @rh_tipo_tarjeta='T3'
			begin
				set @vsof_plan_cuenta       =   @v_vsof_cuenta_tarjeta_3
				set @vsof_tipo_datos        =   @rh_tipo_tarjeta
				set @vsof_tipo_datos_ref   = @rh_tipo_tarjeta
				set @v_plan_completo   =   1
			end 



		if @rh_ting_ccod=13 or @rh_ting_ccod=51 or @rh_ting_ccod=52
			begin
				set @rh_ding_ndocto         = cast(@rh_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
			end

                select @v_largo_plan        =   len(@vsof_plan_cuenta)

                if @v_largo_plan < 12
                    begin
                        set @v_plan_completo=0
                    end
		                  
		if @rh_ting_ccod <> 6 --si no es efectivo
			begin  
				-- print 'no es efectivo'
				IF @v_plan_completo=0 
				    BEGIN
				        set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
				    END
				ELSE
				    BEGIN
				        set @vsof_plan_cuenta=@vsof_plan_cuenta
				    END 
			                                    
				set @v_glosa_softland= @rh_ting_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
			end
		else
		        begin
		 		set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
		        end   
                   
	if @rh_ting_ccod = 10   --cedente de letras
		begin
		
			set @vsof_plan_cuenta       =   @v_vsof_cuenta_caja
			set @v_soft_monto_cedente   =   @v_soft_monto_cedente + @rh_ingr_mtotal
			set @v_cantidad_lineas   =   @v_cantidad_lineas + 1  
			set @v_conteo_cedentes     =   @v_conteo_cedentes + 1
			
			if @v_cantidad_lineas=1 and @v_mantiene_agrupador=0
			begin
				set @v_agrupador=@v_agrupador+1
				set @v_mantiene_agrupador=1
			end
		end 
                                             

	if @r_ting_ccod=9 or @rh_ting_ccod=9   --repactacion (abonos)
		begin
		    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
		end



	if @r_ting_ccod=17 and @rh_ting_ccod = 43 --ingresos por regularizaciones (castigo documentos)
		begin
		
		select top 1 @v_ano_castigo=datepart(year,comp_fdocto)
		from compromisos 
		where tcom_ccod=@rh_tcom_ccod
		and comp_ndocto=@rh_comp_ndocto
		and inst_ccod=@rh_inst_ccod
		
		-- si es un pago de un año anterior entonces asignar a cuenta segun documento que paga
		if @v_ano_castigo< @v_ano_actual
			begin
				select @v_documento_asociado   =   isnull(protic.documento_asociado_cuota(@rh_tcom_ccod, @rh_inst_ccod, @rh_comp_ndocto, @rh_dcom_ncompromiso, 'ting_ccod'),1)
				select @vsof_plan_cuenta       =   protic.obtener_cuenta_soft(@v_documento_asociado,null)
				set @vsof_plan_cuenta          =   @vsof_plan_cuenta+'-999999'
			end
	
	end

select @v_es_anulacion=count(*) from tipos_ingresos where ting_bregularizacion='S' and ting_ccod  in (@rh_ting_ccod)  

--	if @r_ting_ccod=17 and (@rh_ting_ccod = 25 or @rh_ting_ccod = 45 or @rh_ting_ccod = 54 or @rh_ting_ccod = 55)-- Anulaciones
if @r_ting_ccod=17 and @v_es_anulacion >= 1 -- Anulaciones
		begin
			if @rh_tcom_ccod=2 
				begin
					set @vsof_detalle_gasto = 'AR-01-02' -- Arancel
				end 
			else
				begin
					set @vsof_detalle_gasto = 'AR-01-01' -- Matricula
				end
				
			-- ingresos anticipados (anulaciones)
			select top 1  @v_peri_ccod=peri_ccod from compromisos where comp_ndocto=@rh_comp_ndocto 
			and inst_ccod=@rh_inst_ccod 
			and tcom_ccod=@rh_tcom_ccod
			
			if @v_peri_ccod=210 and @v_anio_caja=2007
				begin       
					set @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_proximo
				end
		
		end
	
	if @r_ting_ccod=12 -- Abonos por facturacion (creacion facturas)
		begin
		
			select @vsof_tipo_datos=case tfac_ccod when 1 then 'FV' else 'FA' end ,
				@vsof_tipo_datos_ref=case tfac_ccod when 1 then 'FV' else 'FA' end ,
				@rh_ding_ndocto=fact_nfactura,@rh_ingr_mtotal=fact_mtotal, 
				@rh_ingr_fpago=protic.trunc(fact_ffactura),
				@rh_ding_fdocto=protic.trunc(fact_ffactura) 
			from facturas 
			where folio_abono_factura=@r_ingr_nfolio_referencia
			and efac_ccod in (1,2)
			
	
		end

	-- Nota de credito por devolucion
	if @rh_ting_ccod=36 and @rh_tcom_ccod =36
		begin
			if @v_peri_ccod=210 and @v_anio_caja=2007
				begin       
					set @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_proximo
				end
			else
				begin
					set @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_presente
				end

		end


	Select @v_csof_ncorr=count(*) From cuentas_softland Where cuenta=@vsof_plan_cuenta

	Select @v_usa_controla_doc=isnull(usa_controla_doc,'N'), @v_usa_centro_costo=isnull(usa_centro_costo,'N'),
	@v_usa_auxiliar=isnull(usa_auxiliar,'N'), @v_usa_detalle_gasto=isnull(usa_detalle_gasto,'N'),
	@v_usa_conciliacion=isnull(usa_conciliacion,'N'), @v_usa_pto_caja=isnull(usa_pto_caja,'N')
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
	set @d_otros_vsof_cantidad_gasto    = null	


if @v_usa_controla_doc='S'
	begin
		set @d_otros_vsof_cod_auxiliar      	=   @r_pers_nrut
		set @d_otros_vsof_tipo_datos        	=   @vsof_tipo_datos
		set @d_otros_vsof_numero_doc        	=   @rh_ding_ndocto
		set @d_otros_vsof_fecha_emision    	=   @rh_ingr_fpago
		set @d_otros_vsof_fecha_pago      	=   @rh_ding_fdocto
		set @d_otros_vsof_tipo_datos_ref    	=   @vsof_tipo_datos_ref
		set @d_otros_vsof_numero_doc_ref    	=   @rh_ding_ndocto
	end 
if @v_usa_centro_costo='S'
	begin
		set @d_otros_vsof_centro_costo      	=   @vsof_centro_costo
	end

if @v_usa_auxiliar='S'
	begin
		set @d_otros_vsof_cod_auxiliar      	=   @r_pers_nrut
	end
if @v_usa_detalle_gasto='S'
	begin
		set @d_otros_vsof_detalle_gasto     	=   @vsof_detalle_gasto
		set @d_otros_vsof_cantidad_gasto    	=   1
	end
else
	begin
		set @d_otros_vsof_cantidad_gasto    	=   null
	end

	if @v_csof_ncorr=0
		begin

            set @v_salida_error= 'Cuenta '+ cast(@vsof_plan_cuenta as varchar)+ ' no registra atributos en SGA'

			set @d_otros_vsof_detalle_gasto     	= null
			set @d_otros_vsof_cantidad_gasto    	= null
			set @d_otros_vsof_cod_auxiliar      	= null
			set @d_otros_vsof_centro_costo      	= null
			set @d_otros_vsof_tipo_datos        	= null
			set @d_otros_vsof_numero_doc        	= null
			set @d_otros_vsof_fecha_emision     	= null
			set @d_otros_vsof_fecha_pago 		    = null
			set @d_otros_vsof_tipo_datos_ref    	= null
			set @d_otros_vsof_numero_doc_ref    	= null
		end

    
	if @rh_ting_ccod<>10 -- cualquier otro tipo de ingreso excepto cedentes
		begin
			set @v_nlinea = @v_nlinea+1
	
		if  @rh_ting_ccod=101
			begin
				set @d_otros_vsof_cod_auxiliar=@v_auxiliar_biobio
			end        
	
		select @v_pago_oc=protic.documento_paga_oc(@rh_ingr_ncorr,'S','R')
	



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
			
			
			select @v_calcula_iva=count(*) from detalles a, tipos_detalle b
			where a.tcom_ccod=@rh_tcom_ccod
			and a.comp_ndocto=@rh_comp_ndocto
			and a.inst_ccod=@rh_inst_ccod
			and a.tdet_ccod=b.tdet_ccod
			and b.tbol_ccod=1
		
		
		
			if @v_calcula_iva>=1 and @rh_ting_ccod<>5  --ingresos afectos editorial 
				begin         
					set @v_nlinea =   @v_nlinea+1 
					
					insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
					audi_tusuario, audi_fmodificacion,
					trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
					tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
					tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto, tsof_empresa)
					values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
					@p_audi_tusuario, getdate(),
					@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
					@v_soft_cuenta_editorial,@rh_ingr_mtotal,null,null,null,null,null,null,null,@v_agrupador,null,
					null,null,null,1)
				end-- fin ingreso afecto para empresa editorial               
	
         	end
          else -- si son cedentes de letras
          	begin 
                 
        	if  @v_cantidad_lineas = 49 --totaliza  como maximo 50 lineas
                        begin
                 
	                        set @v_cuadre_acumulado=@v_cuadre_acumulado+@v_soft_monto_cedente
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
		INTO @rh_ingr_ncorr,@rh_ting_tdesc,@rh_ding_ndocto,@rh_ingr_mtotal,@rh_banc_ccod,
		@rh_ingr_fpago,@rh_ding_fdocto,@rh_ting_ccod,@rh_post_ncorr,@rh_tipo_tarjeta,
		@rh_comp_ndocto,@rh_tcom_ccod,@rh_inst_ccod,@rh_dcom_ncompromiso
		end -- fin while c_debe_soft
		CLOSE c_debe_soft 
		DEALLOCATE c_debe_soft
 
--****************************************************************************************************************************************************************************************************************************************************
--                   ########################   FIN CURSOR DEBE   ###########################     
--****************************************************************************************************************************************************************************************************************************************************




--#############################################################################
--##############	CURSOR ADICIONAL PARA NOTAS DE CREDITO	###############
--#############################################################################
IF @r_ting_ccod=37
begin
 Select @rh_ding_ndocto=max(b.ding_ndocto),@rh_post_ncorr=max(isnull(protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,null),0))
   From 
        ingresos a 
        left outer join detalle_ingresos b
         on a.ingr_ncorr = b.ingr_ncorr
        	and b.ting_ccod not in (44,53) 
        join abonos d 
            on a.ingr_ncorr=d.ingr_ncorr    
        where a.eing_ccod not in (2,3,6)
        and a.mcaj_ncorr = @p_mcaj_ncorr
        and a.ting_ccod = @r_ting_ccod
        and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
        and a.pers_ncorr = @r_pers_ncorr
        and d.abon_mabono > 0

		DECLARE c_nota_credito_soft CURSOR LOCAL FOR
		select a.ndcr_ncorr,c.tdet_ccod,dncr_mdetalle,c.tcom_ccod,d.tdet_tdesc, d.tcom_ccod,
					( Select isnull(ti.ting_tdesc,6)as ting_tdesc
					 From 
					  ingresos ing 
					        left outer join detalle_ingresos di
					            on ing.ingr_ncorr = di.ingr_ncorr
					        	and di.ting_ccod not in (44,53) 
					        left outer join tipos_ingresos ti
					            on di.ting_ccod = ti.ting_ccod 
					        join abonos ab 
					            on ing.ingr_ncorr=ab.ingr_ncorr    
					        where ing.eing_ccod not in (2,3,6)
					        and ing.mcaj_ncorr = @p_mcaj_ncorr
					        and ing.ting_ccod = @r_ting_ccod
					        and ing.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
					        and ing.pers_ncorr = @r_pers_ncorr
					        and ab.comp_ndocto=a.comp_ndocto
					        and ab.tcom_ccod=a.tcom_ccod
					        and ab.dcom_ncompromiso=a.dcom_ncompromiso
					       and ab.abon_mabono > 0
					        ) 
		from detalle_notas_de_credito a, notas_de_credito b, detalles c, tipos_detalle d
		where a.ndcr_ncorr=b.ndcr_ncorr
		and b.ndcr_nnota_credito=@rh_ding_ndocto
		and b.mcaj_ncorr=@p_mcaj_ncorr
		and a.comp_ndocto=c.comp_ndocto
		and a.tcom_ccod=c.tcom_ccod
		and a.inst_ccod=c.inst_ccod
		and c.deta_ncantidad>=0
		and c.tdet_ccod=d.tdet_ccod

		OPEN c_nota_credito_soft
		FETCH NEXT FROM c_nota_credito_soft
		INTO  @rnc_ndcr_ncorr,@rnc_tdet_ccod,@rnc_dncr_mdetalle,@rnc_tcom_ccod, @rnc_tipo_detalle,@rnc_tcom_ccod_origen, @rnc_ting_tdesc
		While @@FETCH_STATUS = 0
			begin

				if @rnc_tdet_ccod=1 or @rnc_tdet_ccod=2
					begin
			
						if @v_peri_ccod=210 and @v_anio_caja=2007
							begin       
								set @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_proximo
							end
						else
							begin
								set @vsof_plan_cuenta=@v_vsof_ingreso_aticipado_presente
							end
			
						if @rnc_tdet_ccod=2
							begin
								set @vsof_detalle_gasto = 'AR-01-02' -- Arancel
							end 
						else
							begin
								set @vsof_detalle_gasto = 'AR-01-01' -- Matricula
							end
					end
				else
					begin
						if @rnc_tcom_ccod_origen=7 or @rnc_tcom_ccod_origen=16
							begin
								
								select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
								from centros_costos_asignados a, centros_costo b 
								where a.tdet_ccod=@rnc_tdet_ccod
								and a.ccos_ccod=b.ccos_ccod

								
							end
						--else					begin		end
						select @vsof_detalle_gasto     =   protic.obtener_detalle_soft(@rnc_tdet_ccod,null)
						select @vsof_plan_cuenta       =   protic.obtener_cuenta_soft(null,@rnc_tdet_ccod)
					end
				if @rnc_ting_tdesc is null
					begin
						set @v_glosa_softland= @rnc_tipo_detalle+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
					end
				else
					begin
						set @v_glosa_softland= @rnc_ting_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
					end

			select @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod
			From postulantes a ,ofertas_academicas b, especialidades c
			where a.ofer_ncorr=b.ofer_ncorr
			and b.espe_ccod=c.espe_ccod
			and a.post_ncorr=@rh_post_ncorr


                      	if @v_sede is null and @v_jornada is null 
				begin
					-- print '------------- no estaba matriculado ----------------'
					select top 1 @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod
					From detalle_postulantes a ,ofertas_academicas b, especialidades c
					where a.ofer_ncorr=b.ofer_ncorr
					and b.espe_ccod=c.espe_ccod
					and a.post_ncorr=@rh_post_ncorr
			
				end

			if @vsof_centro_costo is null
				begin
					-- obtiene centro de costo de forma normal
					select @vsof_centro_costo=b.ccos_tcompuesto,
					@vsof_centro_costo_simple=b.ccos_tcodigo
					from centros_costos_asignados a, centros_costo b 
					where a.cenc_ccod_carrera    = @v_carrera
					and a.cenc_ccod_jornada  = @v_jornada
					and a.cenc_ccod_sede     = @v_sede
					and a.ccos_ccod          = b.ccos_ccod
				end


Select @v_csof_ncorr=count(*) From cuentas_softland Where cuenta=@vsof_plan_cuenta

Select @v_usa_controla_doc=isnull(usa_controla_doc,'N'), @v_usa_centro_costo=isnull(usa_centro_costo,'N'),
@v_usa_auxiliar=isnull(usa_auxiliar,'N'), @v_usa_detalle_gasto=isnull(usa_detalle_gasto,'N'),
@v_usa_conciliacion=isnull(usa_conciliacion,'N'), @v_usa_pto_caja=isnull(usa_pto_caja,'N')
From cuentas_softland Where cuenta=@vsof_plan_cuenta


set @d_otros_vsof_glosa_softland    =   @v_glosa_softland


set @d_otros_vsof_cod_auxiliar      = null
set @d_otros_vsof_tipo_datos        = null
set @d_otros_vsof_numero_doc        = null
set @d_otros_vsof_fecha_pago        = null
set @d_otros_vsof_fecha_emision     = null
set @d_otros_vsof_tipo_datos_ref    = null
set @d_otros_vsof_numero_doc_ref    = null
set @d_otros_vsof_centro_costo  = null
set @d_otros_vsof_detalle_gasto     = null


if @v_usa_controla_doc='S'
begin
	set @d_otros_vsof_cod_auxiliar      	=   @r_pers_nrut
	set @d_otros_vsof_tipo_datos        	=   @vsof_tipo_datos
	set @d_otros_vsof_numero_doc        	=   @rh_ding_ndocto
	set @d_otros_vsof_fecha_emision    	=   @rh_ingr_fpago
	set @d_otros_vsof_fecha_pago        	=   @rh_ding_fdocto
	set @d_otros_vsof_tipo_datos_ref    	=   @vsof_tipo_datos_ref
	set @d_otros_vsof_numero_doc_ref    	=   @rh_ding_ndocto
end 
if @v_usa_centro_costo='S'
begin
	set @d_otros_vsof_centro_costo      	=   @vsof_centro_costo
end

if @v_usa_auxiliar='S'
begin
	set @d_otros_vsof_cod_auxiliar      	=   @r_pers_nrut
end
if @v_usa_detalle_gasto='S'
begin
	set @d_otros_vsof_detalle_gasto     	=   @vsof_detalle_gasto
	set @d_otros_vsof_cantidad_gasto    	=   1
end
else
begin
	set @d_otros_vsof_cantidad_gasto    	=   null
end

if @v_csof_ncorr =0
begin
	set @d_otros_vsof_detalle_gasto     	= null
	set @d_otros_vsof_cantidad_gasto   	= null
	set @d_otros_vsof_cod_auxiliar   	= null
	set @d_otros_vsof_centro_costo      	= null
	set @d_otros_vsof_tipo_datos        	= null
	set @d_otros_vsof_numero_doc        	= null
	set @d_otros_vsof_fecha_emision     	= null
	set @d_otros_vsof_fecha_pago 		= null
	set @d_otros_vsof_tipo_datos_ref    	= null
	set @d_otros_vsof_numero_doc_ref    	= null
end

			set @v_nlinea =   @v_nlinea+1
			insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,    
			audi_tusuario, audi_fmodificacion,
			trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
			tsof_plan_cuenta,tsof_debe,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
			tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
			values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,   
			@p_audi_tusuario, getdate(),
			@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
			@vsof_plan_cuenta,@rnc_dncr_mdetalle,@d_otros_vsof_cod_auxiliar,@d_otros_vsof_tipo_datos,@d_otros_vsof_numero_doc,@d_otros_vsof_fecha_emision,@d_otros_vsof_fecha_pago,@d_otros_vsof_tipo_datos_ref,@d_otros_vsof_numero_doc_ref,@v_agrupador,@d_otros_vsof_glosa_softland,
			@d_otros_vsof_detalle_gasto,@d_otros_vsof_centro_costo,@d_otros_vsof_cantidad_gasto)


				FETCH NEXT FROM c_nota_credito_soft
				INTO   @rnc_ndcr_ncorr,@rnc_tdet_ccod,@rnc_dncr_mdetalle,@rnc_tcom_ccod, @rnc_tipo_detalle,@rnc_tcom_ccod_origen,@rnc_ting_tdesc
			end -- fin while c_nota_credito_soft
		CLOSE c_nota_credito_soft 
		DEALLOCATE c_nota_credito_soft

end
--####################################################
        
set @vsof_monto_generico=null        
        
--****************************************************************************************************************************************************************************************************************************************************        
--   ########################  INICIO CURSOR HABER   ###########################
--****************************************************************************************************************************************************************************************************************************************************        
        
	        DECLARE c_haber_sof CURSOR LOCAL FOR

		select isnull(di.ding_fdocto,a.ingr_fpago) as ding_fdocto,isnull(f.ting_ccod,6)as ting_ccod,
			a.ingr_ncorr, case c.tcom_ccod when 25 then (select top 1 tdet_tdesc from tipos_detalle where tdet_ccod=e.tdet_ccod) else c.tcom_tdesc end as tcom_tdesc,
			b.comp_ndocto,b.abon_mabono, case f.ting_ccod  
			when 52 then protic.obtener_numero_pagare_softland(a.ingr_ncorr) 
			else isnull(di.ding_ndocto ,1) end as ding_ndocto_2,
			a.ingr_fpago,isnull(di.ting_ccod,6) as ting_ccod,
			isnull(protic.obtener_post_ncorr(a.pers_ncorr,b.comp_ndocto,null),0) as post_ncorr, e.tdet_ccod,
			case isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'),1) 
			when 52 then protic.obtener_numero_pagare_softland_haber(b.comp_ndocto, b.dcom_ncompromiso)
			when 1 then isnull(di.ding_ndocto ,1)
			else protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') end as numero_docto,
			(select top 1 ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')) as vencimiento,
			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as documento,c.tcom_ccod,
			case f.ting_ccod when 13 then PROTIC.obtiene_tipo_tarjeta(di.ingr_ncorr,di.ding_ndocto) end as tipo_tarjeta,protic.obtener_numero_documento_fox(a.ingr_ncorr,b.comp_ndocto,b.dcom_ncompromiso) as numero_fox
		From ingresos a
		join  abonos b
			on a.ingr_ncorr = b.ingr_ncorr
		join tipos_compromisos c
			on b.tcom_ccod     = c.tcom_ccod
		left outer join detalle_ingresos di 
			on a.ingr_ncorr 	= di.ingr_ncorr
			and di.ting_ccod not in (44,53)  
		join detalles e
			on  b.comp_ndocto  = e.comp_ndocto
			and b.tcom_ccod   = e.tcom_ccod
			and b.inst_ccod   = e.inst_ccod
		left outer join tipos_ingresos f
			on di.ting_ccod = f.ting_ccod  
		Where a.eing_ccod not in (2,3,6)
			and a.mcaj_ncorr = @p_mcaj_ncorr
			and a.ting_ccod  = @r_ting_ccod
			and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
			and a.pers_ncorr = @r_pers_ncorr
			and e.deta_ncantidad>0
			and e.tdet_ccod not in (5,909,4)
			and b.abon_mabono > 0   
			order by a.ingr_ncorr asc 

--liberacion de valores en variables
set @vsof_centro_costo= null
set @vsof_centro_costo_simple=null

--||----> DATOS GENERADOS POR LA REPACTACION (ABONOS DOCUMENTADOS E INTERESES) Y DESCUENTO CURSOS
-- and di.ting_ccod not in (44,53)  --(44=intereses_repactacion,53=DOCUMENTACION COMPROMISOS)
-- and e.tdet_ccod not in (5,909,4)   --(5=intereses,909=descuentos,4=INTERESES ARANCEL COLEG.)
--||----> DATOS GENERADOS POR LA REPACTACION (ABONOS DOCUMENTADOS E INTERESES)Y DESCUENTO CURSOS

			OPEN c_haber_sof
			FETCH NEXT FROM c_haber_sof
			INTO  @rh_ding_fdocto,@rh_ting_ccod,
			@rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
			@rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr, @rd_tipo_detalle,@rd_numero_doc,
			@rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta,@rd_num_fox
			While @@FETCH_STATUS = 0
				begin
				
					-- otros calculos                            
					set @v_detalle_auxiliar=null
					set @vsof_plan_cuenta=''
					set @v_sede     =   null
					set @v_jornada  =   null
					set @v_carrera  =   null
									
					--------CODIGO COMPUESTO PARA LOS CENTROS DE COSTOS-----
					select @v_espe_ccod=c.espe_ccod,@v_ofer_ncorr=b.ofer_ncorr, @v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
					From postulantes a ,ofertas_academicas b, especialidades c
					where a.ofer_ncorr=b.ofer_ncorr
					and b.espe_ccod=c.espe_ccod
					and a.post_ncorr=@rd_post_ncorr

					
					if @v_sede is null and @v_jornada is null --and @rd_tcom_tdesc='EXAMEN ADMISION' 
						begin
							-- 'no estaba matriculado'
							select top 1 @v_espe_ccod=c.espe_ccod,@v_ofer_ncorr=b.ofer_ncorr,@v_sede=b.sede_ccod, @v_jornada=b.jorn_ccod, @v_carrera=c.carr_ccod, @v_jornada_text=case b.jorn_ccod  when 1 then 'D' else 'V' end
							From detalle_postulantes a ,ofertas_academicas b, especialidades c
							where a.ofer_ncorr=b.ofer_ncorr
							and b.espe_ccod=c.espe_ccod
							and a.post_ncorr=@rd_post_ncorr
						end	
					
					-- reemplaza carreras que estaban asociadas a sedes talagante y san bernardo
					if  @v_sede=6 or @v_sede=5
						begin
							set @v_sede=2		
						end


					select @vsof_centro_costo=b.ccos_tcompuesto,
					@vsof_centro_costo_simple=b.ccos_tcodigo
					from centros_costos_asignados a, centros_costo b 
					where a.cenc_ccod_carrera   = @v_carrera
					and a.cenc_ccod_jornada  = @v_jornada
					and a.cenc_ccod_sede     = @v_sede
					and a.ccos_ccod          = b.ccos_ccod
               
   
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
								select @vsof_centro_costo=b.ccos_tcompuesto,@vsof_centro_costo_simple=b.ccos_tcodigo
								from centros_costos_asignados a, centros_costo b 
								where a.cenc_ccod_carrera=@v_carrera
								and a.cenc_ccod_jornada=@v_jornada
								and a.cenc_ccod_sede=@v_sede
								and a.ccos_ccod=b.ccos_ccod
								--print 'tiene carrera asociada'
							end   
					
						if @v_detalle_auxiliar is null and @v_sede is null and @v_jornada is null and @v_carrera is null  
							begin 
								select @vsof_centro_costo=b.ccos_tcompuesto, 
								@vsof_centro_costo_simple=b.ccos_tcodigo
								from centros_costos_asignados a, centros_costo b 
								where a.tdet_ccod=@rd_tipo_detalle
								and a.ccos_ccod=b.ccos_ccod   
							end


                    if @rd_tcom_ccod=5 and @rd_tipo_detalle =13 and @rd_documento=87 -- Caso para cuando se protesta una letra de un curso de extension.
                        begin
                                    select @v_tdet_ccod=d.tdet_ccod
                                     from ingresos a, detalle_ingresos b, abonos c, detalles d
                                    where a.ingr_ncorr=b.ingr_ncorr
                                    and b.ingr_ncorr=c.ingr_ncorr
                                    and b.ding_ndocto=@rd_ding_ndocto
                                    and b.ting_ccod=4
                                    and b.ding_bpacta_cuota='S' 
                                    and c.comp_ndocto=d.comp_ndocto 
                                    and c.tcom_ccod=d.tcom_ccod

                                    select @vsof_centro_costo=b.ccos_tcompuesto, 
                                    @vsof_centro_costo_simple=b.ccos_tcodigo
                                    from centros_costos_asignados a, centros_costo b 
                                    where a.tdet_ccod=@v_tdet_ccod
                                    and a.ccos_ccod=b.ccos_ccod 
                        end




                        if @rd_tcom_ccod=6 -- Obtener centro de costo de un curso para asignarlo al interes que paga
            				begin
				
                                select @v_existe_curso=count(*) from abonos where ingr_ncorr=@rd_ingr_ncorr and tcom_ccod=7

                                if @v_existe_curso>0
                                begin
                                    select @v_num_curso=max(comp_ndocto) from abonos where ingr_ncorr=@rd_ingr_ncorr and tcom_ccod=7

                                    select @v_tipo_detalle=max(tdet_ccod) from abonos a, detalles b 
                                    where a.ingr_ncorr=@rd_ingr_ncorr
                                    and a.tcom_ccod=b.tcom_ccod
                                    and a.comp_ndocto=b.comp_ndocto
                                    and a.inst_ccod=b.inst_ccod 
                                    and a.tcom_ccod=7


                                end
             					select @vsof_centro_costo=b.ccos_tcompuesto, @vsof_centro_costo_simple=b.ccos_tcodigo
            					from centros_costos_asignados a, centros_costo b 
            					where a.tdet_ccod=@v_tipo_detalle
            					and a.ccos_ccod=b.ccos_ccod
                                
					
			            end



					end -- fin post_ncorr=0 
					

				if @v_detalle_auxiliar is not null -- si se encontro un diplomado o un curso antiguo (son los que llevan detalle)
					begin
						--print 'auxiliar encontrado: '+cast(@v_detalle_auxiliar as varchar)
						select @vsof_centro_costo=b.ccos_tcompuesto, 
						@vsof_centro_costo_simple=b.ccos_tcodigo
						from centros_costos_asignados a, centros_costo b 
						where a.tdet_ccod=@v_detalle_auxiliar
						and a.ccos_ccod=b.ccos_ccod
						--print 'centro costo: '+cast(@vsof_centro_costo_simple as varchar)
					end
                                                
                                            
				if  @rd_post_ncorr=0 and @rd_tcom_ccod=7  --curso
					begin
						select @vsof_centro_costo=b.ccos_tcompuesto, 
						@vsof_centro_costo_simple=b.ccos_tcodigo
						from centros_costos_asignados a, centros_costo b 
						where a.tdet_ccod=@rd_tipo_detalle
						and a.ccos_ccod=b.ccos_ccod
					end
                                              
         
                                                
        -- PARA EL CASO DE LAS REPACTACIONES (QUE EN REALIDAD SON FACTURAS)  
  if @rd_tcom_ccod=3 and @rd_tipo_detalle <> 6
            begin
		select @vsof_centro_costo=b.ccos_tcompuesto, 
		@vsof_centro_costo_simple=b.ccos_tcodigo
		from centros_costos_asignados a, centros_costo b 
		where a.tdet_ccod=@rd_tipo_detalle
		and a.ccos_ccod=b.ccos_ccod
            end  
        ------------------------------------------------------------------------------------------
                                            
               --========================================================================================================= --para obtener la cuenta contable asociada al haber 
       -- verificar si corresponde a otros compromisos para asociar el detalle relacionado
            -- o no tiene un documento asociado

		if (@rd_tcom_ccod=25 or @rd_documento is null) and @rd_tipo_detalle<> 1250
			begin
			
				--plan de cuenta segun el compromiso que  esta pagando
				select @vsof_plan_cuenta    =   protic.obtener_cuenta_soft(null,@rd_tipo_detalle)
				select @v_largo_plan  =   len(@vsof_plan_cuenta)
			       
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
				if @rd_tcom_ccod=31 or (@rd_tcom_ccod=5  and @rd_tipo_detalle=1250)
				-- si paga un pagare se asigna el tipo ingreso pagare que esta ingresado como :(ajuste historico o multa migracion) al migrar
				begin
					set @rd_documento   =26 -- codigo de pagare 
				end

         			select @vsof_plan_cuenta   =   protic.obtener_cuenta_soft(@rd_documento,null)

				if @rd_tcom_ccod=7 and @r_ting_ccod=33 -- cursos
					begin
						select @vsof_plan_cuenta =   protic.obtener_cuenta_soft(null,@rd_tipo_detalle)
					end
				
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
  
			if @rd_tipo_detalle=13 and @rd_tcom_ccod=5 and @rd_ting_ccod=87 
				begin
					--registro gasto protesto contra caja (descuento del banco) no era asi.. hay que reconocerlo como ingreso segun herman
					select @vsof_plan_cuenta    =  @v_soft_gasto_protesto -- @v_vsof_cuenta_caja --cuenta caja
					set @v_plan_completo = 1
				end 
   		--=========================================================================================================
                             
			-----------------------------------------------------------------------------------
			select @vsof_detalle_gasto     	=   protic.obtener_detalle_soft(@rd_tipo_detalle,null)
			select @vsof_tipo_datos  	=  protic.obtener_tipo_soft(@rd_ting_ccod)
			select @vsof_tipo_datos_ref    	=   protic.obtener_tipo_soft(@rd_documento)
			-----------------------------------------------------------------------------------
                                            
                                          
	                   -- validacion extra para facturas pos cobrar (ingresadas como cargo por caja)
			if @rd_tipo_detalle=1214 and @rd_documento is null
				begin
					set @vsof_tipo_datos_ref    = 'FE'
					set @rd_numero_doc          = @rd_num_fox
				end    
			--validacion extra para pagares sin detalle (mal migrados)  
			if @rd_tcom_ccod=31 or (@rd_tcom_ccod=2 and @rd_tipo_detalle=1248) or (@rd_tcom_ccod=5  and @rd_tipo_detalle=1250)
				begin
					set @rd_tcom_tdesc        = 'Pagare mig.'+@rd_tcom_tdesc
					set @vsof_tipo_datos_ref  = 'PG'
					set @rd_numero_doc        = cast(@rd_num_fox as varchar)
				end    
			-- validacion extra para tarjetas T3 
			if @rd_tipo_tarjeta='T3' and @rd_documento is not null
				begin
					set @vsof_tipo_datos     = @rd_tipo_tarjeta
				end  

			if @rd_ting_ccod=13 or @rd_ting_ccod=51 or @rd_ting_ccod=52
				begin
					set @rd_ding_ndocto         = cast(@rd_ding_ndocto as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
				end
    
			
            
            if @rd_documento=13 or @rd_documento=51 
				begin
					set @rd_numero_doc      = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
				end   


             if @rd_documento=52
                begin
                    select top 1 @v_folio_contrato=ingr_nfolio_referencia 
                    from abonos a, ingresos b
                    where a.ingr_ncorr=b.ingr_ncorr
                    and a.comp_ndocto=@rd_comp_ndocto
                    and ting_ccod=7

			        select top 1  @v_peri_ccod=peri_ccod from compromisos where comp_ndocto=@rd_comp_ndocto and tcom_ccod=@rd_tcom_ccod
                    
                    if @v_peri_ccod<214
                    begin
                        set @rd_numero_doc   = cast(@rd_numero_doc as varchar)+''+cast(@v_folio_contrato as varchar)
                    end
        else
                    begin 
                        set @rd_numero_doc   = @rd_numero_doc
                    end

                end


                                            -- validacion extra para la cuenta Devolucion Alumno (especifica)
				if @rd_tipo_detalle=1284 and @rd_ting_ccod<>36
				begin
					select @vsof_tipo_datos =  'DA'
					select @vsof_tipo_datos_ref  =  'DA'
					if @rd_documento is null
						begin
							set @rd_numero_doc=@rd_ding_ndocto
						end
				end 
				
				if @rd_tipo_detalle=1284 and @rd_ting_ccod=36
				begin
					select @vsof_plan_cuenta    =   protic.obtener_cuenta_soft(null,@rd_tipo_detalle)
					select @vsof_tipo_datos =  'NC'
					select @vsof_tipo_datos_ref  =  'NC'


					-- obtiene la division de las devoluciones
					select @v_devolver=max(devuelve),@v_medio_pago=max(medio_pago) from 
					(select case a.uncr_ccod when 1 then dunc_mmonto_asociado end as medio_pago,
					case a.uncr_ccod when 2 then dunc_mmonto_asociado end as devuelve 
					from detalle_uso_nota_credito a, notas_de_credito b
					where a.ndcr_ncorr=b.ndcr_ncorr
					and b.ndcr_nnota_credito=@rd_numero_doc
					and b.mcaj_ncorr=@p_mcaj_ncorr
					and a.uncr_ccod in (1,2)) as tabla
	
				end        


                                            --@rd_ting_ccod <> 6 and
     if  @v_plan_completo <> 1  --(0=incompleto ,1= completo) => cuenta+centro_costo=plan_completo
         begin  
            
       select @v_largo_plan=len(@vsof_plan_cuenta)--validacion adicional para obtener el largo del plan
              
         if @rd_ting_ccod = 6 and @rd_tcom_ccod=22 --si es efectivo pero para una letra
       begin
              set @v_glosa_softland     =  substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                               set @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(4)
                  
        --validacion para que no repita centro de costo cada vez
	                                          if @v_largo_plan < 12
	 											begin
	            					set @vsof_plan_cuenta       =   @vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
	      									end
     
											  if @rd_documento is null
											     begin
						    	set @rd_numero_doc        =   @rd_num_fox
						             				set @vsof_tipo_datos_ref   =   protic.obtener_tipo_soft(4)
						        end
			                            end
          
                           if @rd_ting_ccod = 6 and (@rd_documento is null or @rd_documento=6) --si es efectivo y no paga un documento
             begin
		set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
		select @v_largo_plan=len(@vsof_plan_cuenta)
	
		if @v_largo_plan < 12
			begin
				set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
		      	end
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
    											            set @v_glosa_softland= @rd_tcom_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
                                            
                                    end 
                                                
					if @rd_documento is null and @rd_tcom_ccod=3                                                       
						begin
							set @rd_numero_doc      =   @rd_num_fox
						        set @vsof_tipo_datos_ref  =   protic.obtener_tipo_soft(49)--factura exenta (o no afecta)
						                                                        
						                  --validacion para que no repita centro de costo cada vez
						       	select @v_largo_plan=len(@vsof_plan_cuenta)
							if @v_largo_plan < 12
						                 begin
						            		set @vsof_plan_cuenta=@vsof_plan_cuenta+'-'+@vsof_centro_costo_simple						
						             	end    
						end 
                                    end
									        else
										  begin
											        set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)
										     end   

------------------------------------------------------------------------------------------                                    
--repactaciones               
if @r_ting_ccod=15
begin
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
end


--Pago de documento (Documento por Pagar)
if @r_ting_ccod=88
	begin
		set @vsof_plan_cuenta = protic.obtener_cuenta_soft(3,null)--simula cuenta de un cheque
		set @vsof_plan_cuenta       =   @vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
		set @vsof_tipo_datos_ref    =   'CH' --(Cheque original pagado)
	end
------------------------------------------------------------------------------------------

									
								

	        set @vsof_monto_generico = @rd_abon_mabono + @vsof_monto_generico


      
if @rd_documento=5 and @rd_ting_ccod=12  --(si esta abonando una factura se buscan las facturas asociadas)
	begin
		select @rd_ding_ndocto=fact_nfactura,
		@vsof_tipo_datos=case tfac_ccod when 1 then 'FV' else 'FE' end
		from facturas
		where folio_abono_factura=@r_ingr_nfolio_referencia
		and efac_ccod in (1,2)	
	end


if @rd_tcom_ccod=5 and @rd_ting_ccod<>12  --(si esta abonando una factura se buscan las facturas asociadas)
	begin
		select @rd_ding_ndocto=fact_nfactura,
		@vsof_tipo_datos=case tfac_ccod when 1 then 'FV' else 'FE' end
		from facturas
		where fact_nfactura=@rd_ding_ndocto
		and efac_ccod in (1,2)	
	end

if @vsof_tipo_datos is not null and @r_ting_ccod=37
begin
	select @vsof_tipo_datos =  'NC'
end

    Select @v_csof_ncorr=count(*) From cuentas_softland Where cuenta=@vsof_plan_cuenta

	Select @v_usa_controla_doc=isnull(usa_controla_doc,'N'), @v_usa_centro_costo=isnull(usa_centro_costo,'N'),
	@v_usa_auxiliar=isnull(usa_auxiliar,'N'), @v_usa_detalle_gasto=isnull(usa_detalle_gasto,'N'),
	@v_usa_conciliacion=isnull(usa_conciliacion,'N'), @v_usa_pto_caja=isnull(usa_pto_caja,'N')
	From cuentas_softland Where cuenta=@vsof_plan_cuenta

    	set @h_otros_vsof_glosa_softland    =   @v_glosa_softland

	set @h_otros_vsof_cod_auxiliar  	=   null
	set @h_otros_vsof_tipo_datos      	=  null
	set @h_otros_vsof_numero_doc  		=   null
	set @h_otros_vsof_fecha_emision     	=   null
	set @h_otros_vsof_fecha_pago        	=   null
	set @h_otros_vsof_tipo_datos_ref    	=   null
	set @h_otros_vsof_numero_doc_ref    	=   null
	set @h_otros_vsof_detalle_gasto     	=   null
	set @h_otros_vsof_centro_costo      	=   null
	set @h_otros_vsof_cantidad_gasto    	=   null

	if @v_usa_controla_doc='S'
		begin
			set @h_otros_vsof_cod_auxiliar     = @r_pers_nrut
			set @h_otros_vsof_tipo_datos       = @vsof_tipo_datos
			set @h_otros_vsof_numero_doc       = @rd_ding_ndocto -- con que numero de doc lo paga
			set @h_otros_vsof_fecha_emision    = @rd_ingr_fpago  
			set @h_otros_vsof_fecha_pago       = @rh_ding_fdocto
			set @h_otros_vsof_tipo_datos_ref   = @vsof_tipo_datos_ref
			set @h_otros_vsof_numero_doc_ref   = @rd_numero_doc -- numero de doc de que paga
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
	else
		begin
			set @h_otros_vsof_cantidad_gasto= null
		end
        
	if @v_csof_ncorr=0 
		begin
        
            set @v_salida_error= 'Cuenta '+ cast(@vsof_plan_cuenta as varchar)+ ' no tiene registro'

			set @h_otros_vsof_detalle_gasto     	= null
			set @h_otros_vsof_cantidad_gasto    	= null
			set @h_otros_vsof_cod_auxiliar      	= null
			set @h_otros_vsof_centro_costo      	= null
			set @h_otros_vsof_tipo_datos     	    = null
			set @h_otros_vsof_numero_doc    	    = null
			set @h_otros_vsof_fecha_emision         = null
			set @h_otros_vsof_fecha_pago     	    = null
			set @h_otros_vsof_tipo_datos_ref   	    = null
			set @h_otros_vsof_numero_doc_ref    	= null
		end
       
           
     --- fin otros calculos

	select @v_calcula_iva=count(*) from tipos_detalle where tbol_ccod=1 and tdet_ccod=@rd_tipo_detalle


	if @v_calcula_iva>=1 and @rd_ting_ccod<>5 --para compromisos distintos de ordenes de compra (estas aun no son deudas)
		-- cuenta del iva para items especificos (libro, impresiones,multas audio,muol.videos, imrepsiones b/n, poleras psicologia )
		begin

			set @v_nlinea = @v_nlinea + 1
			set @v_monto_temporal=0                 
			set @v_monto_iva=CEILING(CEILING(@rd_abon_mabono/1.19) * 0.19 )
                     
			insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
			tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa, tsof_empresa  )
			values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,@p_audi_tusuario, getdate(),
			@v_soft_cuenta_iva,@v_monto_iva,@v_agrupador,@h_otros_vsof_glosa_softland,1)
 
	            	--*****************************************************************************
			-- se introduce estas lineas para separar por empresas.
			set @v_monto_temporal=@rd_abon_mabono
			set @rd_abon_mabono = @rd_abon_mabono - @v_monto_iva
			set @v_monto_iva =0
	         
			                   
	                set @v_nlinea = @v_nlinea + 1
				
			 -- haber del concepto afecto que fue pagado EDITORIAL
                	if @rd_documento=5 -- si es orden de compra se envia contra cta corriente alumno(ingresos x cobrar)
				begin
					insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
					audi_tusuario, audi_fmodificacion,
					trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
					tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
					tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto,tsof_empresa)
					values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
					@p_audi_tusuario, getdate(),
					@r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
					@v_vsof_ingreso_aticipado_presente,@rd_abon_mabono,null,null,null,null,null,null,null,@v_agrupador,@h_otros_vsof_glosa_softland,
					@vsof_detalle_gasto,@vsof_centro_costo,1,1)
					
					set @v_nlinea = @v_nlinea + 1 
					-- haber totalizado UPA 
					insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
					audi_tusuario, audi_fmodificacion,
					trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
					tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
					tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
					values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
					@p_audi_tusuario, getdate(),
					@r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
					@vsof_plan_cuenta,@v_monto_temporal,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
					@h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto)
				end
			else
				begin
					if @rd_ting_ccod=5
						begin
							insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
							audi_tusuario, audi_fmodificacion,
							trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
							tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
							tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto,tsof_empresa)
							values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @v_monto_temporal,null, 
							@p_audi_tusuario, getdate(),
							@r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
							@v_soft_cuenta_editorial_pagar,@v_monto_temporal,null,null,null,null,null,null,null,@v_agrupador,@h_otros_vsof_glosa_softland,
							null,null,null,1)
						end
					else
						begin
							insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
							audi_tusuario, audi_fmodificacion,
							trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
							tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
							tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto,tsof_empresa)
							values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
							@p_audi_tusuario, getdate(),
							@r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
							@vsof_plan_cuenta,@rd_abon_mabono,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
							@h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto,1)
						end

						
						-- haber totalizado UPA 
						set @v_nlinea = @v_nlinea + 1 
						insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
						audi_tusuario, audi_fmodificacion,
						trca_nombre_a, trca_paterno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
						tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
						tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
						values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @v_monto_temporal,null, 
						@p_audi_tusuario, getdate(),
						@r_nombre_a, @r_paterno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
						@v_soft_cuenta_editorial_pagar,@v_monto_temporal,null,null,null,null,null,null,null,@v_agrupador,@h_otros_vsof_glosa_softland,
						null,null,null)
				end
                
                
	                set @rd_abon_mabono=@v_monto_temporal
                	--*****************************************************************************

		end 



	set @v_nlinea = @v_nlinea + 1
	if  @vsof_plan_cuenta='2-10-090-20-000001'
		begin
			set @h_otros_vsof_cod_auxiliar=@v_auxiliar_mineduc
		end
                
            
-- si esta pagando una orden de compra (que no sea por otec)
	if @rd_documento=5 and @r_ting_ccod <> 12
		begin
			select @v_auxiliar_auxiliar=case when CHARINDEX('-',ding_tcuenta_corriente)=0 then cast(@r_pers_nrut as varchar) else SUBSTRING(ding_tcuenta_corriente, 0, CHARINDEX('-',ding_tcuenta_corriente)) end
			from detalle_ingresos 
			where ding_ndocto=@rd_numero_doc 
			and ding_fdocto=@rd_fecha_pacta 
			and ting_ccod=5
			
			set @h_otros_vsof_cod_auxiliar=@v_auxiliar_auxiliar
		end

	if @v_calcula_iva<1 or @rh_ting_ccod=5
		begin


			if @v_calcula_iva>=1 and @rh_ting_ccod=5 and @r_ting_ccod<>12
				begin
					insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
					audi_tusuario, audi_fmodificacion,
					trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
					tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
					tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
					values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @v_monto_temporal,null, 
					@p_audi_tusuario, getdate(),
					@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
					@v_soft_cuenta_editorial_pagar,@rd_abon_mabono,null,null,null,null,null,null,null,@v_agrupador,@h_otros_vsof_glosa_softland,
					null,null,null)
				end
			else
				begin


					if @rh_ting_ccod=36 
						begin
							if @v_medio_pago >0 
								begin
									insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
									audi_tusuario, audi_fmodificacion,
									trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
									tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
									tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
									values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
									@p_audi_tusuario, getdate(),
									@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
									@v_soft_cuenta_devolucion_pago,@v_medio_pago,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
									@h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto)
									
									set @v_nlinea = @v_nlinea + 1
								end	
							if @v_devolver >0 
								begin
									insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
									audi_tusuario, audi_fmodificacion,
									trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
									tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
									tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
									values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
									@p_audi_tusuario, getdate(),
									@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
									@vsof_plan_cuenta,@v_devolver,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
									@h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto)
									
									set @v_nlinea = @v_nlinea + 1
								end
						end 
					else
						begin
		
							insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, 
							audi_tusuario, audi_fmodificacion,
							trca_nombre_a, trca_paterno_a,trca_materno_a,pers_nrut, pers_xdv,TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,
							tsof_plan_cuenta,tsof_haber,tsof_cod_auxiliar,tsof_tipo_documento,tsof_nro_documento,tsof_fecha_emision,tsof_fecha_vencimiento,tsof_tipo_doc_referencia,tsof_nro_doc_referencia,tsof_nro_agrupador,tsof_glosa,
							tsof_cod_detalle_gasto,tsof_cod_centro_costo,tsof_cant_concepto_gasto)
							values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,null, 
							@p_audi_tusuario, getdate(),
							@r_nombre_a, @r_paterno_a,@r_materno_a,@r_pers_nrut, @r_pers_xdv,'S','S','N','N','N','N','N',
							@vsof_plan_cuenta,@rd_abon_mabono,@h_otros_vsof_cod_auxiliar,@h_otros_vsof_tipo_datos,@h_otros_vsof_numero_doc,@h_otros_vsof_fecha_emision,@h_otros_vsof_fecha_pago,@h_otros_vsof_tipo_datos_ref,@h_otros_vsof_numero_doc_ref,@v_agrupador,@h_otros_vsof_glosa_softland,
							@h_otros_vsof_detalle_gasto,@h_otros_vsof_centro_costo,@h_otros_vsof_cantidad_gasto)end
						end
		end            

            
	if @h_otros_vsof_cod_auxiliar is not null and @vsof_plan_cuenta='2-10-090-20-000001'
		begin
			set @h_otros_vsof_cod_auxiliar= @r_pers_nrut
		end
           

if  @v_limite_linea_cedente = 1 --cuando llego a 50 cedentes
                begin

                    set @v_agrupador=@v_agrupador+1
     
     set @v_mantiene_agrupador=1
                    set @v_limite_linea_cedente=0
set @v_soft_monto_cedente = 0
end 
set @v_devolver=0
set @v_medio_pago=0
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
        -- 				#	    #	    #	    #
        --- 			####	###	    ####	##### 	
        -- 				#	    #	    #	        #
      -- 				####	#       ####   #####
        --######################################################################

if @r_ting_ccod <> 9 and @r_ting_ccod <>15 and @r_ting_ccod <>33 
    begin
    
        DECLARE c_efes_haber CURSOR LOCAL FOR
        select g.tcom_ccod,sum(b.abon_mabono) as total, e.tdet_ccod,max(g.tdet_tdesc) as detalle
		        From ingresos a
		         join  abonos b
			   on a.ingr_ncorr = b.ingr_ncorr
		         join detalles e
			        on b.comp_ndocto  = e.comp_ndocto
			        and b.tcom_ccod  = e.tcom_ccod
			        and b.inst_ccod   = e.inst_ccod
		         join tipos_detalle g
		            on e.tdet_ccod=g.tdet_ccod                    
		         join tipos_compromisos c
			       on b.tcom_ccod     = c.tcom_ccod 
		   left outer join detalle_ingresos di 
			        on a.ingr_ncorr 	= di.ingr_ncorr
		 left outer join tipos_ingresos f
			        on di.ting_ccod = f.ting_ccod
					and di.ting_ccod not in (53)   
		          Where a.eing_ccod not in (2,3,6)
		          and a.mcaj_ncorr = @p_mcaj_ncorr
		          and a.ting_ccod  = @r_ting_ccod
		          and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
		          and a.pers_ncorr = @r_pers_ncorr
		          and e.tdet_ccod not in (5,909,4)
		     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') is null
		      GROUP BY e.tdet_ccod,g.tcom_ccod
		        order by e.tdet_ccod asc
                
                
                            OPEN c_efes_haber
                            FETCH NEXT FROM c_efes_haber
 INTO  @rf_tcom_ccod,@rf_monto,@rf_tipo,@rf_detalle

           While @@FETCH_STATUS = 0
	                                begin
      
if  (@rf_tipo <> 1219 and @rf_tipo <> 1214) and @rf_tcom_ccod <> 7  --nueva validacion (1219=fondos a rendir,1214=factura a cobrar(provisoria),cursos, no llevan efe)
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
       
 end  -- Fin EFES tipos <> 9 y 15 ( Repactaciones )
  
--*********************************************
--************ EFES PARA CURSOS	***************

	if @r_ting_ccod =33 or @r_ting_ccod =12
	    begin

		        DECLARE c_efes_cursos CURSOR LOCAL FOR
		    select g.tcom_ccod,sum(b.abon_mabono) as total, e.tdet_ccod,max(g.tdet_tdesc) as detalle
		        From ingresos a
		  join  abonos b
			        on a.ingr_ncorr = b.ingr_ncorr
		         join detalles e
			        on b.comp_ndocto  = e.comp_ndocto
			        and b.tcom_ccod   = e.tcom_ccod
			   and b.inst_ccod   = e.inst_ccod
		         join tipos_detalle g
		  on e.tdet_ccod=g.tdet_ccod                    
		         join tipos_compromisos c
			        on b.tcom_ccod     = c.tcom_ccod  
		         left outer join detalle_ingresos di 
			    on a.ingr_ncorr 	= di.ingr_ncorr
		        left outer join tipos_ingresos f
			        on di.ting_ccod = f.ting_ccod
					and di.ting_ccod not in (53)  
		     Where a.eing_ccod not in (2,3,6)
		      and a.mcaj_ncorr = @p_mcaj_ncorr
		          and a.ting_ccod  = @r_ting_ccod
		         and a.ingr_nfolio_referencia = @r_ingr_nfolio_referencia
		       and a.pers_ncorr = @r_pers_ncorr
		     	  and e.tdet_ccod not in (5,909,4)
		  and b.tcom_ccod=7
		  GROUP BY  e.tdet_ccod,g.tcom_ccod
		       order by e.tdet_ccod asc

                  OPEN c_efes_cursos
                    FETCH NEXT FROM c_efes_cursos
  INTO @rc_tcom_ccod,@rc_monto,@rc_tipo,@rc_detalle

                  While @@FETCH_STATUS = 0
							begin


                                set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
     set @v_nlinea           =   @v_nlinea+1
     set @rc_detalle         =   @rc_detalle+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)+'-S'+cast(@v_sede_caja as varchar)

print cast(@rc_detalle as varchar(300)) 
                  				--DEBE EFE    
 	                 			insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
	      								caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
									        tsof_plan_cuenta,tsof_debe,tsof_nro_agrupador,tsof_cod_auxiliar,tsof_glosa)
  	values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_arancel, @r_pers_nrut_c, @r_pers_xdv_c,
										 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
		       @vsof_plan_cuenta,@rc_monto,@v_agrupador,@r_pers_nrut,@rc_detalle)

								 
								 set @v_nlinea           =   @v_nlinea+1      
                    

    --HABER EFE
    insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,  trca_ttipo, trca_ndocto_compromiso, trca_mdebe, trca_mhaber, pers_nrut, pers_xdv,
caje_ccod, sede_ccod, banc_ccod, carr_ccod, trca_ncomprobante_caja, ting_tdesc, trca_tglosa, trca_finicio,trca_numero_doc, audi_tusuario, audi_fmodificacion,
						 tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_cod_auxiliar,tsof_glosa)
                                values(@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,  null, null, null, @vsof_monto_arancel, @r_pers_nrut_c, @r_pers_xdv_c,
                                 @r_caje_ccod, @r_sede_ccod, null, @v_carr_ccod, null, @r_ting_tdesc, @v_trca_tglosa,@r_finicio,null, @p_audi_tusuario, getdate(),
	  @vsof_plan_cuenta,@rc_monto,@v_agrupador,@r_pers_nrut,@rc_detalle)
                        

  
                         	FETCH NEXT FROM c_efes_cursos
INTO @rc_tcom_ccod,@rc_monto,@rc_tipo,@rc_detalle
     end
        
                    CLOSE c_efes_cursos 
			        DEALLOCATE c_efes_cursos	 
             
		end  -- FIN EFES CURSOS

--*********************************************                     
    --#####################################################################################
    -- total al debe  para el pago de cedentes de letras

	      if  @v_conteo_cedentes=@v_cantidad_cedentes and @v_conteo_cedentes > 0
            begin
       
                 
      if @v_cuadre_acumulado > 0
 begin
       
           set @v_nlinea =   @v_nlinea+1
             insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
										  tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa)
				 values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,@p_audi_tusuario, getdate(),   
									@v_vsof_cuenta_cuadre,@v_cuadre_acumulado,@v_agrupador,@d_otros_vsof_glosa_softland)
             
                    end
         
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

		 -------------------------------------------------------------------------------------------------------
-- se marca como traspasada por el sistema de traspasos y por tesoreria 

		 update movimientos_cajas
		    set MCAJ_BTRASPASADA_SOFTLAND = 'S',eren_ccod=4
		    where mcaj_ncorr = @p_mcaj_ncorr		 

	select isnull(@v_salida_error,'OK') as valor
end
else
    begin
        print 'la caja es de anulacion o cedentes'
  end
END