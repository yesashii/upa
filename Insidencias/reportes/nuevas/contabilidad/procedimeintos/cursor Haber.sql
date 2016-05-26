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
                                            where a.cenc_ccod_carrera    = @v_carrera
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
                                            
                     --=========================================================================================================                                            --para obtener la cuenta contable asociada al haber 
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
                                            select @vsof_detalle_gasto     =   protic.obtener_detalle_soft(@rd_tipo_detalle,null)
                                   	        select @vsof_tipo_datos        =   protic.obtener_tipo_soft(@rd_ting_ccod)
									        select @vsof_tipo_datos_ref    =   protic.obtener_tipo_soft(@rd_documento)
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
 set @rd_tcom_tdesc          = 'Pagare mig.'+@rd_tcom_tdesc
   set @vsof_tipo_datos_ref  = 'PG'
   -- set @rd_numero_doc        = cast(@rd_num_fox as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
 set @rd_numero_doc          = cast(@rd_num_fox as varchar)
                                                
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
                                                    set @rd_numero_doc          = cast(@rd_numero_doc as varchar)+''+cast(@r_ingr_nfolio_referencia as varchar)
                                                end   


                                         if @rd_documento=52
                                            begin
                                                select top 1 @v_folio_contrato=ingr_nfolio_referencia 
                                                from abonos a, ingresos b
                                                where a.ingr_ncorr=b.ingr_ncorr
                                                and a.comp_ndocto=@rd_comp_ndocto
                                                and ting_ccod=7

                                                set @rd_numero_doc   = cast(@rd_numero_doc as varchar)+''+cast(@v_folio_contrato as varchar)


                                            end


                                            -- validacion extra para la cuenta Devolucion Alumno (especifica)
  if @rd_tipo_detalle=1284
     begin
  select @vsof_tipo_datos =  'DA'
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
                                                            set @v_glosa_softland     =   substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
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
    											            set @v_glosa_softland= @rd_tcom_tdesc+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
                                            
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
                 --print 'entra en factura 2 vesion'
       end 
                                    end
									        else
										  begin
											        set @v_glosa_softland= substring(@r_nombre_a,0,CHARINDEX(' ',@r_nombre_a))+' '+@r_paterno_a+' '+@r_materno_a+'-C'+cast(@p_mcaj_ncorr as varchar)+'-N'+cast(@r_ingr_nfolio_referencia as varchar)
										        end   

------------------------------------------------------------------------------------------                                    
--repactaciones               
if @r_ting_ccod=15
begin
    set @vsof_plan_cuenta   =   @v_vsof_cuenta_efe+'-'+@vsof_centro_costo_simple
end

--ingreso por regularizacion
/*if @r_ting_ccod=17
begin
--    set @rd_numero_doc          =   @rd_num_fox
   set @vsof_tipo_datos    =   'BD' --(becas y descuentos)
end
*/

--Pago de documento (Documento por Pagar)
if @r_ting_ccod=88
begin
    set @vsof_plan_cuenta       = protic.obtener_cuenta_soft(3,null)--simula cuenta de un cheque
    set @vsof_plan_cuenta       =   @vsof_plan_cuenta+'-'+@vsof_centro_costo_simple
    set @vsof_tipo_datos_ref    =   'CH' --(Cheque original pagado)
end
------------------------------------------------------------------------------------------
											
								

	        set @vsof_monto_generico = @rd_abon_mabono + @vsof_monto_generico


        /*
		Select  @v_csof_ncorr=csof_ncorr,@v_usa_controla_doc=usa_controla_doc, @v_usa_centro_costo=usa_centro_costo,
   @v_usa_auxiliar=usa_auxiliar, @v_usa_detalle_gasto=usa_detalle_gasto,
    @v_usa_conciliacion=usa_conciliacion, @v_usa_pto_caja=usa_pto_caja
        From cuentas_softland Where cuenta=@vsof_plan_cuenta
		*/

    if @rd_documento=5 and @rd_ting_ccod <> 5
        begin
            set @vsof_plan_cuenta='1-10-050-05-101350'
        end 

Select @v_csof_ncorr=isnull(csof_ncorr,'N'),@v_usa_controla_doc=isnull(usa_controla_doc,'N'), @v_usa_centro_costo=isnull(usa_centro_costo,'N'),
      @v_usa_auxiliar=isnull(usa_auxiliar,'N'), @v_usa_detalle_gasto=isnull(usa_detalle_gasto,'N'),
      @v_usa_conciliacion=isnull(usa_conciliacion,'N'), @v_usa_pto_caja=isnull(usa_pto_caja,'N')
    From cuentas_softland Where cuenta=@vsof_plan_cuenta

    set @h_otros_vsof_glosa_softland    =   @v_glosa_softland

        set @h_otros_vsof_cod_auxiliar      =   null
        set @h_otros_vsof_tipo_datos      =   null
      set @h_otros_vsof_numero_doc  =   null
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
                set @h_otros_vsof_tipo_datos    = @vsof_tipo_datos
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
        
 if @v_csof_ncorr is null
  begin
   set @h_otros_vsof_detalle_gasto     = null
            set @h_otros_vsof_cantidad_gasto    = null
            set @h_otros_vsof_cod_auxiliar      = null
       set @h_otros_vsof_centro_costo      = null
            set @h_otros_vsof_tipo_datos        = null
         set @h_otros_vsof_numero_doc    = null
            set @h_otros_vsof_fecha_emision     = null
set @h_otros_vsof_fecha_pago      = null
     set @h_otros_vsof_tipo_datos_ref   = null
            set @h_otros_vsof_numero_doc_ref    = null
        
    end
       
       
     --- fin otros calculos

select @v_calcula_iva=count(*) from tipos_detalle where tbol_ccod=1 and tdet_ccod=@rd_tipo_detalle

--if @rd_tipo_detalle=1338 or @rd_tipo_detalle=1245 or @rd_tipo_detalle=1246 or @rd_tipo_detalle=1223 or @rd_tipo_detalle=1221 or @rd_tipo_detalle=1215 or @rd_tipo_detalle=1389
if @v_calcula_iva>=1 
                -- cuenta del iva para items especificos (libro, impresiones,multas audio,muol.videos, imrepsiones b/n, poleras psicologia )
 begin
             set @v_nlinea = @v_nlinea + 1
                 
                        set @v_monto_iva=CEILING((@rd_abon_mabono / 1.19)*0.19) 
                     
                     
                             insert into traspasos_cajas_softland(mcaj_ncorr, ingr_nfolio_referencia,trca_nlinea,ting_ccod,audi_tusuario, audi_fmodificacion,
										          tsof_plan_cuenta,tsof_haber,tsof_nro_agrupador,tsof_glosa   )
				                values (@r_mcaj_ncorr, @r_ingr_nfolio_referencia,@v_nlinea,@r_ting_ccod,@p_audi_tusuario, getdate(),
										      @v_soft_cuenta_iva,@v_monto_iva,@v_agrupador,@h_otros_vsof_glosa_softland)
  
               set @rd_abon_mabono   = @rd_abon_mabono - @v_monto_iva
                        set @v_monto_iva =0
                    end 
                    
                    
                set @v_nlinea = @v_nlinea + 1

             if  @vsof_plan_cuenta='2-10-090-20-000001'
                begin
                    set @h_otros_vsof_cod_auxiliar=@v_auxiliar_mineduc
                end
                
                 
-- si esta pagando una orden de compra
    if @rd_documento=5
        begin
            select @v_auxiliar_auxiliar=case when CHARINDEX('-',ding_tcuenta_corriente)=0 then cast(@r_pers_nrut as varchar) else SUBSTRING(ding_tcuenta_corriente, 0, CHARINDEX('-',ding_tcuenta_corriente)) end
            from detalle_ingresos 
            where ding_ndocto=@rd_numero_doc 
            and ding_fdocto=@rd_fecha_pacta 
            and ting_ccod=5

            set @h_otros_vsof_cod_auxiliar=@v_auxiliar_auxiliar
        end

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
       --  print '_____________________________'   
    FETCH NEXT FROM c_haber_sof
    INTO  @rh_ding_fdocto,@rh_ting_ccod,
    @rd_ingr_ncorr, @rd_tcom_tdesc, @rd_comp_ndocto, @rd_abon_mabono,@rd_ding_ndocto,
    @rd_ingr_fpago, @rd_ting_ccod, @rd_post_ncorr, @rd_tipo_detalle,@rd_numero_doc,
    @rd_fecha_pacta,@rd_documento,@rd_tcom_ccod,@rd_tipo_tarjeta,@rd_num_fox
    end --fin while c_haber_sof

               		 CLOSE c_haber_sof 
						        DEALLOCATE c_haber_sof	 
