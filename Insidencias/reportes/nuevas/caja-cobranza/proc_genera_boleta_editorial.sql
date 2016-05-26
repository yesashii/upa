CREATE procedure genera_boletas (
@p_opcion numeric,
@p_folio_ccod numeric,
@p_ting_ccod numeric,
@p_sede_ccod numeric,
@p_mcaj_ncorr numeric,
@p_audi_tusuario varchar (100)
)
as
begin

set @p_audi_tusuario=@p_audi_tusuario+'-crea boleta'


-- variable locales
declare @v_bole_ncorr numeric
declare @v_periodo numeric
declare @v_post_ncorr numeric
declare @v_pers_ncorr_aval numeric
declare @v_pers_ncorr_cajero numeric
declare @v_boleta_actual numeric
declare @v_rbca_ncorr numeric
declare @v_rbca_nfin numeric
declare @v_estado_rango numeric
declare @v_inst_ccod numeric

-- variables del cursor boletas
declare @r_tbol_ccod numeric
declare @r_monto_total numeric
declare @r_pers_ncorr numeric


-- variables del cursor c_detalle_boletas
declare @r_tdet_ccod numeric
declare @r_tcom_ccod numeric
declare @r_monto_detalle numeric


select @v_pers_ncorr_cajero=pers_ncorr 
from movimientos_cajas a, cajeros b
where a.caje_ccod=b.caje_ccod
and a.mcaj_ncorr=@p_mcaj_ncorr

--print 'pers_ncorr:'+cast(@v_pers_ncorr_cajero as varchar)  


--EN CASO DE CONTRATOS Y CURSOS
IF @p_ting_ccod=7 or @p_ting_ccod=33
    begin
        declare c_boletas cursor local for
        select td.tbol_ccod, SUM(ab.ABON_MABONO) monto_abono,ab.pers_ncorr
            from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
            where ii.ingr_ncorr = ab.ingr_ncorr
                and ii.ingr_nfolio_referencia = @p_folio_ccod
                and ii.ting_ccod    = @p_ting_ccod
                and ab.tcom_ccod    = dc.tcom_ccod
                and ab.inst_ccod    = dc.inst_ccod  
                and ab.comp_ndocto  = dc.comp_ndocto 
                and ab.dcom_ncompromiso = dc.dcom_ncompromiso
                and dc.tcom_ccod    = dd.tcom_ccod
                and dc.inst_ccod    = dd.inst_ccod
                and dc.comp_ndocto  = dd.comp_ndocto
                and dd.tdet_ccod    = td.tdet_ccod
				and dd.tdet_ccod not in (3,4,5)
                and td.tdet_bboleta = 'S'  
        GROUP BY td.tbol_ccod,ab.pers_ncorr
    end
ELSE
    begin
    
        if @p_opcion <> 2 -- Opcion normal de generacion de boletas
            begin
            
                declare c_boletas cursor local for
                select td.tbol_ccod, SUM(ab.ABON_MABONO) monto_abono,ab.pers_ncorr
                    from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
                    where ii.ingr_ncorr = ab.ingr_ncorr
                        and ii.ingr_nfolio_referencia = @p_folio_ccod
                        and ii.ting_ccod    = @p_ting_ccod
                        and ab.tcom_ccod    = dc.tcom_ccod
                        and ab.inst_ccod    = dc.inst_ccod  
                        and ab.comp_ndocto  = dc.comp_ndocto 
                        and ab.dcom_ncompromiso = dc.dcom_ncompromiso
                        and dc.tcom_ccod    = dd.tcom_ccod
                        and dc.inst_ccod    = dd.inst_ccod
                        and dc.comp_ndocto  = dd.comp_ndocto
                        and dd.tdet_ccod    = td.tdet_ccod
				        and dd.tdet_ccod not in (5)
                        and td.tdet_bboleta = 'S'
                        and dc.tcom_ccod not in (1,2,7)
                GROUP BY td.tbol_ccod,ab.pers_ncorr
            end 
        else        -- Para las Repactaciones (intereses por repactacion)
            begin
                declare c_boletas cursor local for
                select td.tbol_ccod, SUM(ab.ABON_MABONO) monto_abono,ab.pers_ncorr
                    from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
                    where ii.ingr_ncorr = ab.ingr_ncorr
                        and ii.ingr_nfolio_referencia = @p_folio_ccod
                        and ii.ting_ccod    = @p_ting_ccod
                        and ab.tcom_ccod    = dc.tcom_ccod
                        and ab.inst_ccod    = dc.inst_ccod  
          and ab.comp_ndocto  = dc.comp_ndocto 
                        and ab.dcom_ncompromiso = dc.dcom_ncompromiso
         				and dc.tcom_ccod    = dd.tcom_ccod
                        and dc.inst_ccod    = dd.inst_ccod
                        and dc.comp_ndocto  = dd.comp_ndocto
                        and dd.tdet_ccod    = td.tdet_ccod
                        and td.tdet_bboleta = 'S'
                        and dc.tcom_ccod not in (1,2,7)
                GROUP BY td.tbol_ccod,ab.pers_ncorr
            end
    end
    
    

    OPEN c_boletas
    FETCH NEXT FROM c_boletas
    INTO @r_tbol_ccod, @r_monto_total, @r_pers_ncorr
        While @@FETCH_STATUS = 0
    
	    begin
            
            set @v_boleta_actual= null
                
                -- ######## OBTIENE EL CODEUDOR DE LA ULTIMA POSTULACION QUE TENGA EL USUARIO   ########
                select top 1 @v_periodo=a.peri_ccod,@v_post_ncorr=b.post_ncorr , @v_pers_ncorr_aval=b.pers_ncorr
                from postulantes a, codeudor_postulacion b 
                where a.pers_ncorr=@r_pers_ncorr
                    and a.post_ncorr=b.post_ncorr
                    order by a.peri_ccod desc,b.post_ncorr desc

				if @v_pers_ncorr_aval is null
					begin
						set @v_pers_ncorr_aval=@r_pers_ncorr
					end           

                select TOP 1 @v_boleta_actual=isnull(rbca_nactual,rbca_ninicio) , @v_rbca_ncorr=rbca_ncorr, @v_rbca_nfin=rbca_nfin
                from rangos_boletas_cajeros 
                where pers_ncorr=@v_pers_ncorr_cajero 
                    and tbol_ccod=@r_tbol_ccod
                    and sede_ccod=@p_sede_ccod
                    and erbo_ccod=1
            
            
              exec protic.RetornarSecuencia 'boletas',@v_bole_ncorr output
              
              if @r_tbol_ccod=1 then
                  begin
                    set @v_inst_ccod=3
                  end
              else
                  begin
                    set @v_inst_ccod=1
                  end
               --ebol_ccod=1 (boleta en estado pendiente) para luego activarla
              insert into boletas(bole_ncorr,bole_nboleta,ebol_ccod,tbol_ccod,bole_mtotal,bole_fboleta, ingr_nfolio_referencia,sede_ccod, pers_ncorr, pers_ncorr_aval,mcaj_ncorr,audi_tusuario,audi_fmodificacion, inst_ccod) 
                    values (@v_bole_ncorr,@v_boleta_actual,1,@r_tbol_ccod,@r_monto_total,getdate(),@p_folio_ccod,@p_sede_ccod, @r_pers_ncorr,@v_pers_ncorr_aval,@p_mcaj_ncorr,@p_audi_tusuario,getdate(),@v_inst_ccod)

            
            
            
            if @v_boleta_actual=@v_rbca_nfin 
                begin
                    set @v_estado_rango=2 --Terminado

                    -- se Debe actualizar el siguiente rango de boletas que estaban en espera.
                    update  rangos_boletas_cajeros set  erbo_ccod=1  
                     where pers_ncorr=@v_pers_ncorr_cajero 
                     and tbol_ccod=@r_tbol_ccod  
                     and sede_ccod=@p_sede_ccod 
                     and erbo_ccod=4     
                     
                     set @v_boleta_actual=@v_boleta_actual-1             

                end
            else
                begin
                    set @v_estado_rango=1 -- Activo
                end
                
          set @v_boleta_actual=@v_boleta_actual+1
          
            
            -- crea el detalle de las boletas, con el desglose de los item pagados
            
            IF @p_ting_ccod=7 or @p_ting_ccod=33
                begin
            --***********   CREA BOLETAS PARA LA PRIMERA VEZ QUE SE CREA UN CURSO O UN CONTRATO ************
                    declare c_detalle_boletas cursor LOCAL for
                    select dd.tdet_ccod, max(dc.tcom_ccod),SUM(ab.ABON_MABONO) monto_abono
                        from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
                        where ii.ingr_ncorr = ab.ingr_ncorr
                            and ii.ingr_nfolio_referencia = @p_folio_ccod
                            and ii.ting_ccod    =   @p_ting_ccod
                            and td.tbol_ccod    =   @r_tbol_ccod               
      and ab.tcom_ccod    =   dc.tcom_ccod
                            and ab.inst_ccod    =   dc.inst_ccod  
                            and ab.comp_ndocto  =   dc.comp_ndocto 
                            and ab.dcom_ncompromiso = dc.dcom_ncompromiso
                        and dc.tcom_ccod    =   dd.tcom_ccod
                            and dc.inst_ccod    =   dd.inst_ccod
                            and dc.comp_ndocto  =   dd.comp_ndocto
                            and dd.tdet_ccod    =   td.tdet_ccod
							and dd.tdet_ccod not in (3,4,5)
                            and td.tdet_bboleta =   'S'
                    GROUP BY dd.tdet_ccod --, td.tcom_ccod, dc.tcom_ccod,dc.inst_ccod,dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO

                end
            ELSE
                begin
                        
                    if @p_opcion <> 2 -- Opcion normal de generacion de boletas
                        begin 
                            declare c_detalle_boletas cursor LOCAL for
                            select dd.tdet_ccod, max(dc.tcom_ccod),SUM(ab.ABON_MABONO) monto_abono
                                from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
                                where ii.ingr_ncorr = ab.ingr_ncorr
                                    and ii.ingr_nfolio_referencia = @p_folio_ccod
                                    and ii.ting_ccod    =   @p_ting_ccod
                                    and td.tbol_ccod    =   @r_tbol_ccod                    
       							    and ab.tcom_ccod    =   dc.tcom_ccod
                                    and ab.inst_ccod    =   dc.inst_ccod  
                                    and ab.comp_ndocto  =   dc.comp_ndocto 
                                    and ab.dcom_ncompromiso = dc.dcom_ncompromiso
                                    and dc.tcom_ccod    =   dd.tcom_ccod
                                    and dc.inst_ccod    =   dd.inst_ccod
                                    and dc.comp_ndocto  =   dd.comp_ndocto
                                    and dd.tdet_ccod    =   td.tdet_ccod
                                    and td.tdet_bboleta =   'S'
								    and dd.tdet_ccod not in (5)
                                    and dc.tcom_ccod not in (1,2,7)
                            GROUP BY dd.tdet_ccod 
                        end 
                    else        -- Para las Repactaciones (intereses por repactacion)
                        begin
                            declare c_detalle_boletas cursor LOCAL for
                            select dd.tdet_ccod, max(dc.tcom_ccod),SUM(ab.ABON_MABONO) monto_abono
                                from ingresos ii,abonos ab,detalle_compromisos dc,detalles dd,tipos_detalle td
                                where ii.ingr_ncorr = ab.ingr_ncorr
                                    and ii.ingr_nfolio_referencia = @p_folio_ccod
                                    and ii.ting_ccod    =   @p_ting_ccod
                                    and td.tbol_ccod    =   @r_tbol_ccod                    
       							    and ab.tcom_ccod    =   dc.tcom_ccod
                                    and ab.inst_ccod    =   dc.inst_ccod  
                                    and ab.comp_ndocto  =   dc.comp_ndocto 
                                    and ab.dcom_ncompromiso = dc.dcom_ncompromiso
                                    and dc.tcom_ccod    =   dd.tcom_ccod
                                    and dc.inst_ccod    =   dd.inst_ccod
                                    and dc.comp_ndocto  =   dd.comp_ndocto
                                    and dd.tdet_ccod    =   td.tdet_ccod
                                    and td.tdet_bboleta =   'S'
                                    and dc.tcom_ccod not in (1,2,7)
                            GROUP BY dd.tdet_ccod 
                        
  end
                end
            
            OPEN c_detalle_boletas
     FETCH NEXT FROM c_detalle_boletas
            INTO @r_tdet_ccod, @r_tcom_ccod,@r_monto_detalle
                While @@FETCH_STATUS = 0
	            begin
                
                    -- inserta detalle de la boleta
                    insert into detalle_boletas(bole_ncorr,tdet_ccod,dbol_mtotal,audi_tusuario,audi_fmodificacion) 
                    values (@v_bole_ncorr,@r_tdet_ccod,@r_monto_detalle,@p_audi_tusuario,getdate())
            
                FETCH NEXT FROM c_detalle_boletas
                INTO  @r_tdet_ccod, @r_tcom_ccod,@r_monto_detalle
                End 
            close c_detalle_boletas
            deallocate c_detalle_boletas
           
           -- actualiza el correlativo de la boleta y cambia estado al rango si es necesario
           update rangos_boletas_cajeros set rbca_nactual=@v_boleta_actual, erbo_ccod=@v_estado_rango where rbca_ncorr=@v_rbca_ncorr
               
        FETCH NEXT FROM c_boletas
        INTO  @r_tbol_ccod, @r_monto_total, @r_pers_ncorr
        End 
    close c_boletas
    deallocate c_boletas

select 1    
end