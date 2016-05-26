USE [sigaupa]
GO

/****** Object:  StoredProcedure [dbo].[ANULA_CONTRATO]    Script Date: 03/01/2016 18:35:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[ANULA_CONTRATO](
@p_cont_ncorr numeric,
@p_audi_tusuario varchar(50),
@p_caja_anulacion numeric,
@p_anular numeric 
) 
as 
BEGIN 

set @p_audi_tusuario=@p_audi_tusuario+'- anula contrato'

------- Variables Globales ----------------------
 declare @v_nerrores numeric
 declare @msj_error varchar(400)
 declare @v_nuevo_correlativo numeric
--------------------------------------------------
declare @estado_contrato numeric
declare @inst_ccod numeric
declare @matr_ncorr numeric
 
---------Variables cursor c_documentos_contrato_uno---------
declare @ingr_ncorr numeric
declare @ting_ccod numeric
declare @ding_ndocto numeric
declare @banc_ccod numeric
declare @ding_tcuenta_corriente varchar(100)
declare @ding_ncorrelativo numeric
-----------------------------------------------------------
Set @v_nerrores   = 0
Set @msj_error    = ''		

DECLARE c_contrato CURSOR LOCAL FOR
    select econ_ccod,inst_ccod,matr_ncorr
    from contratos
    where cont_ncorr = @p_cont_ncorr

-- inicio recorrido de cursor contrato
OPEN c_contrato
FETCH NEXT FROM c_contrato
INTO @estado_contrato, @inst_ccod,@matr_ncorr
    While @@FETCH_STATUS = 0
    
	begin
   
		 if @estado_contrato <> 3   --Si el contrato no está anulado
		 	begin

		   
			          if protic.total_abonado_contrato(@p_cont_ncorr) > 0 
		              begin
				  	 	      Set @v_nerrores   = 1
						      Set @msj_error    = @msj_error + 'Tiene pagos asociados.'				  				  
				      end 
		              else -- si no ha efectuano ingun pago aun
		              begin				
							update contratos
						      set econ_ccod = 3,
						          audi_tusuario = @p_audi_tusuario,
							      audi_fmodificacion = getdate()
						      where cont_ncorr = @p_cont_ncorr
				      
						      update compromisos
						      set ecom_ccod = 3,
						          audi_tusuario = @p_audi_tusuario,
							      audi_fmodificacion = getdate()
						      where comp_ndocto = @p_cont_ncorr
						        and inst_ccod   = @inst_ccod
						        and tcom_ccod in (1, 2)			
					
						      update detalle_compromisos
						      set ecom_ccod = 3,
						          audi_tusuario = @p_audi_tusuario,
							      audi_fmodificacion = getdate()
						      where comp_ndocto = @p_cont_ncorr
						        and inst_ccod   = @inst_ccod
						        and tcom_ccod in (1,2)			
					
						      update beneficios
						      set eben_ccod = 3,
						          audi_tusuario = @p_audi_tusuario,
							      audi_fmodificacion = getdate()
						      where cont_ncorr 	= @p_cont_ncorr
				      
						      update alumnos
						      set emat_ccod = 9,
						          audi_tusuario = @p_audi_tusuario,
							      audi_fmodificacion = getdate()
						      where matr_ncorr = @matr_ncorr	
						end

							DECLARE c_documentos_contrato_uno CURSOR FOR
						        SELECT b.ingr_ncorr, c.ting_ccod, isnull(c.ding_ndocto,0) as ding_ndocto,
								 isnull(c.banc_ccod,0) as banc_ccod, isnull(c.ding_tcuenta_corriente,0) as ding_tcuenta_corriente,
						         c.ding_ncorrelativo
						        FROM abonos a join ingresos b 
						            on a.ingr_ncorr = b.ingr_ncorr 
						        left outer join detalle_ingresos c 
						            on b.ingr_ncorr = c.ingr_ncorr
						        left outer join  estados_detalle_ingresos d
						            on c.edin_ccod  = d.edin_ccod  
						        left outer join tipos_ingresos e 
						            on c.ting_ccod  = e.ting_ccod
						        WHERE a.comp_ndocto = @p_cont_ncorr 
						          AND b.ting_ccod 	= 7 
						          AND a.tcom_ccod IN (1,2)

						     -- sea abre el segundo cursor que trae los documentos asociados a un contrato
                    

							OPEN c_documentos_contrato_uno
		   					FETCH NEXT FROM c_documentos_contrato_uno INTO @ingr_ncorr, @ting_ccod, @ding_ndocto,@banc_ccod,@ding_tcuenta_corriente,@ding_ncorrelativo
					
							While @@FETCH_STATUS = 0
							Begin
							
								if @p_anular=1  -- Asigna a una caja de anulacion
									begin
										update ingresos
								      	set eing_ccod = 6, 
								    		mcaj_ncorr	= @p_caja_anulacion, --caja nueva
											mcaj_ncorr_origen	= mcaj_ncorr, --caja original
									      	audi_tusuario = @p_audi_tusuario,
								      		audi_fmodificacion =getdate()
								      	where ingr_ncorr = @ingr_ncorr	
									end
								else
									begin
										update ingresos
								      	set eing_ccod = 6, 
								    		audi_tusuario = @p_audi_tusuario,
										  	audi_fmodificacion =getdate()
								      	where ingr_ncorr = @ingr_ncorr
								  	end
								  	
								 if @ting_ccod is not null 
		          					begin		  
					           
									    select @v_nuevo_correlativo=cast(cast(@ding_ncorrelativo as integer) + cast(count(ding_ncorrelativo)+1 as integer) as integer)* -1 
			                            from detalle_ingresos
			                            where ting_ccod = @ting_ccod
			                              and banc_ccod = @banc_ccod
			                              and ding_ndocto = @ding_ndocto
			                              and isnull(ding_tcuenta_corriente, ' ') = isnull(@ding_tcuenta_corriente, ' ')
			                              and cast(SUBSTRING(cast(abs(ding_ncorrelativo) as varchar), 1, 1) as integer) = @ding_ncorrelativo
			                              and ding_ncorrelativo < 0
                         
							
									  					      
								     update detalle_ingresos
								      set ding_ncorrelativo = @v_nuevo_correlativo, 
								          audi_tusuario = @p_audi_tusuario,
									      audi_fmodificacion = getdate()
								      where ingr_ncorr  = @ingr_ncorr
								        and ting_ccod   = @ting_ccod
									    and ding_ndocto = @ding_ndocto
							

							       end  -- if @ting_ccod is not null				    
							    
									  					      
							FETCH NEXT FROM c_documentos_contrato_uno INTO @ingr_ncorr, @ting_ccod, @ding_ndocto,@banc_ccod,@ding_tcuenta_corriente,@ding_ncorrelativo

		                    End -- fin while c_documentos_contrato_uno	

		                    CLOSE c_documentos_contrato_uno 
		                    DEALLOCATE c_documentos_contrato_uno
					      
	
		      
				      -----------------------------------------------------------------------------------------------------------------
									  					      
			end

  	FETCH NEXT FROM c_contrato INTO @estado_contrato, @inst_ccod,@matr_ncorr  
	end -- fin while cursor contratos
    
	CLOSE c_contrato 
    DEALLOCATE c_contrato	 	 
   select @v_nerrores as error  
end 

GO


