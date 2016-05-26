alter procedure sd_protesto_letras_notaria
as
begin

declare @v_secuencia numeric
declare @v_nuevo_ingr_ncorr numeric
declare @v_nuevo_folio_referencia numeric
declare @v_ding_nsecuencia numeric

--VARIABLES DE CURSOR
declare @r_ingr_ncorr numeric
declare @r_letra numeric
declare @r_pers_ncorr numeric

 declare c_protestos_letras cursor for
    select b.ingr_ncorr,b.ding_ndocto,c.pers_ncorr 
    from sd_letras_para_protesto a, detalle_ingresos b, ingresos c
    where a.letra=b.ding_ndocto
    and b.ingr_ncorr=c.ingr_ncorr
    and b.ting_ccod=4


    open c_protestos_letras
    fetch next from c_protestos_letras 
    into @r_ingr_ncorr,@r_letra,@r_pers_ncorr
    
    while @@FETCH_STATUS = 0
    begin
    
            exec protic.RetornarSecuencia 'referencias_cargos',@v_secuencia output

        -- sql_insertar_compromiso
            INSERT INTO compromisos (tcom_ccod, ecom_ccod, inst_ccod, comp_ndocto,  pers_ncorr, comp_fdocto,    
		                                          comp_ncuotas, comp_mneto, comp_mdescuento, comp_mintereses, comp_miva,    
										          comp_mexento, comp_mdocumento, sede_ccod, audi_tusuario, audi_fmodificacion)    
	                VALUES (5 ,1,1,  @v_secuencia  ,  @r_pers_ncorr  ,getdate(), 1,5000,null,null,null,null,  5000  ,  1  ,'mriffo protesto',getdate())    
	           


        -- sql_insertar_detalle_compromiso
             INSERT INTO detalle_compromisos (tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,dcom_fcompromiso,dcom_mneto,   
		                                             dcom_mintereses,dcom_mcompromiso,ecom_ccod,pers_ncorr,peri_ccod,audi_tusuario,audi_fmodificacion)    
			         VALUES (  5  ,'1',  @v_secuencia  ,'1',getdate(),  5000  , null,  5000  ,'1',  @r_pers_ncorr  ,  204  ,'mriffo protesto',getdate()) 


        --sql_insertar_detalle
             INSERT INTO detalles (tcom_ccod,inst_ccod,comp_ndocto,tdet_ccod,deta_ncantidad,deta_mvalor_unitario,   
		                                  deta_mvalor_detalle,deta_msubtotal,audi_tusuario, audi_fmodificacion )  
			         VALUES (  5  ,1,  @v_secuencia  ,  13  ,1,  5000  ,5000  ,  5000  ,'mriffo protesto',getdate()) 

        --*****************************************
        -- fin creacion de multa
        --*****************************************

        -- documento la multa creada

        exec protic.RetornarSecuencia 'ingresos',@v_nuevo_ingr_ncorr output
        exec protic.RetornarSecuencia 'ingresos_referencia',@v_nuevo_folio_referencia output
        exec protic.RetornarSecuencia 'detalle_ingresos',@v_ding_nsecuencia output


        --sql_ingreso_multa_protesto()
		        INSERT INTO ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal,    
		                                    ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, ingr_mintereses, ingr_mmultas,   
								            pers_ncorr, ingr_manticipado,inem_ccod, audi_tusuario, audi_fmodificacion)    
	   		               VALUES (@v_nuevo_ingr_ncorr,3505,4,getdate(),null,5000,5000,1,@v_nuevo_folio_referencia,87,1,null,null,@r_pers_ncorr  ,null,null,'mriffo protesto',getdate()) 


        --sql_detalle_ingresos_protesto()

               INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto,  ding_nsecuencia, ding_ncorrelativo, plaz_ccod,    
		                                            banc_ccod, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente,    
		   							                edin_ccod, envi_ncorr, repa_ncorr, audi_tusuario, audi_fmodificacion,ding_bpacta_cuota)    
 			         VALUES ( @v_nuevo_ingr_ncorr  ,87,  @r_letra  , @v_ding_nsecuencia ,1,null,null,getdate(),5000,5000,null,1,null,null,'mriffo protesto',getdate(),'S') 


        -- sql_abono_multa_protesto()
		       INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono,    
		                                     pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion)    
                         VALUES (@v_nuevo_ingr_ncorr,5,1,@v_secuencia,1,getdate(),5000,@r_pers_ncorr,204,null,'mriffo protesto',getdate()) 

        --************************
       -- sql_agregar_referencia_cargo()
          insert into REFERENCIAS_CARGOS (RECA_NCORR, TING_CCOD, DING_NDOCTO, INGR_NCORR, RECA_MMONTO, EDIN_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)    
                   values ( @v_secuencia , 4 , @r_letra , @r_ingr_ncorr , 5000 , 54 ,'mriffo protesto',getdate())  

            fetch next from c_protestos_letras
            into @r_ingr_ncorr,@r_letra,@r_pers_ncorr
        end
    CLOSE c_protestos_letras
    DEALLOCATE c_protestos_letras   
end