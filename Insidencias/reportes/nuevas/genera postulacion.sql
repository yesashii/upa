alter PROCEDURE proc_genera_postulacion_base(
@v_ofer_ncorr as numeric(10)
)
as
begin
--AUTOR: Mario Riffo
--FECHA: 04/04/2012
--------------------------------------------------------------------------------------
declare @peri_ccod numeric(3)
declare @nuevo_post numeric(10)
declare @v_existe_rut numeric(1)
declare @v_existe_pos numeric(1)
declare @v_cont_pos numeric
declare @v_cont_per numeric
declare @v_pers_ncorr numeric


declare @r_pers_nrut numeric
declare @r_pers_xdv  varchar(1)
declare @r_pers_tnombre varchar(30)
declare @r_pers_tape_paterno varchar(30)
declare @r_pers_tape_materno varchar(30)
declare @r_sexo_ccod numeric
        
    select @peri_ccod = peri_ccod from ofertas_academicas where ofer_ncorr = @v_ofer_ncorr

set @v_cont_pos=0
set @v_cont_per=0

DECLARE c_personas CURSOR LOCAL FOR
    select pers_nrut,pers_xdv,isnull(pers_tnombre,'.') as pers_tnombre,isnull(pers_tape_paterno,'.') as pers_tape_paterno,
    isnull(pers_tape_materno,'.') as pers_tape_materno,sexo_ccod from sd_diplomado_2009
    where pers_nrut in (5713893,13335016,10514632,12242608,5055512,8146471,7312687)

OPEN c_personas
FETCH NEXT FROM c_personas
INTO  @r_pers_nrut,@r_pers_xdv,@r_pers_tnombre,@r_pers_tape_paterno,@r_pers_tape_materno,@r_sexo_ccod

 While @@FETCH_STATUS = 0
    Begin
			
            select @v_existe_rut=count(*) from personas where pers_nrut=@r_pers_nrut
         
         set @v_cont_per=@v_cont_per+1
            
            if @v_existe_rut=0
                begin
                    -- Chequea que no exista en personas_postulantes
               print 'no existe como persona' 

                    select @v_existe_rut=count(*) from personas_postulante where pers_nrut=@r_pers_nrut
            
                    if @v_existe_rut=1
                        begin
                    
                            insert into personas (pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, sexo_ccod, audi_tusuario, audi_fmodificacion)
                            select pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, sexo_ccod, audi_tusuario, audi_fmodificacion 
                            from personas_postulante where pers_nrut=@r_pers_nrut
                    
                            insert into direcciones (pers_ncorr, tdir_ccod,ciud_ccod,dire_tcalle,dire_tnro,audi_tusuario, audi_fmodificacion)
                            select pers_ncorr, tdir_ccod,ciud_ccod,dire_tcalle,dire_tnro,audi_tusuario, audi_fmodificacion 
                            from direcciones_publicas where pers_nrut=@r_pers_nrut
                        end
                    else
                    begin
                        execute protic.RetornarSecuencia 'personas', @v_pers_ncorr output
                
                        insert into personas (pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, sexo_ccod, audi_tusuario, audi_fmodificacion)
                        values (@v_pers_ncorr,@r_pers_nrut,@r_pers_xdv,@r_pers_tnombre,@r_pers_tape_paterno,@r_pers_tape_materno,@r_sexo_ccod, 'proc postula diplo', getdate())
                
                        insert into direcciones (pers_ncorr, tdir_ccod,ciud_ccod,dire_tcalle,dire_tnro,audi_tusuario, audi_fmodificacion)
                        values (@v_pers_ncorr,1,1335,'Avenida Las Condes',11121, 'proc postula diplo', getdate())
                    end
                end
             else
             begin
                select @v_pers_ncorr=pers_ncorr from personas where pers_nrut=@r_pers_nrut
             end    

print 'pers_ncorr : '+cast(@v_pers_ncorr as varchar)
    select @v_existe_pos=count(*) from postulantes where ofer_ncorr=30341 and pers_ncorr=@v_pers_ncorr
          
          if @v_existe_pos=0
            begin  
            
                set @v_cont_pos=@v_cont_pos+1
                
			    execute protic.RetornarSecuencia 'postulantes', @nuevo_post output

                insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OFER_NCORR,POST_FPOSTULACION,AUDI_TUSUARIO,AUDI_FMODIFICACION)
                select @nuevo_post as post_ncorr,@v_pers_ncorr,1,1,@peri_ccod as peri_ccod,'S',@v_ofer_ncorr as ofer_ncorr,getdate(),getDate() as audi_fmodificacion,'proc postula diplo'
            
                insert into detalle_postulantes (post_ncorr,ofer_ncorr,audi_tusuario,audi_fmodificacion,dpos_tobservacion,eepo_ccod,dpos_ncalificacion,dpos_fexamen)
                values(@nuevo_post,@v_ofer_ncorr,'proc postula diplo',getDate(),'proc postula diplo',2,NULL,NULL)
        
                insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion)
                select @nuevo_post as post_ncorr,@v_pers_ncorr,0,'proc postula diplo' as audi_tusuario,getDate() as audi_fmodificacion
            end
           
        FETCH NEXT FROM c_personas
            INTO   @r_pers_nrut,@r_pers_xdv,@r_pers_tnombre,@r_pers_tape_paterno,@r_pers_tape_materno,@r_sexo_ccod
    End 
    
CLOSE c_personas 
DEALLOCATE c_personas	             

 print' Se termino el proceso, Personas: '+cast(@v_cont_per as varchar);

 print' Se termino el proceso, Postulados: '+cast(@v_cont_pos as varchar);

end