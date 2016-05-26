CREATE procedure genera_ofertas_anticipadas(@peri_origen numeric,@peri_destino numeric) 
AS
BEGIN
declare @aran_ncorr numeric
declare @ofer_ncorr numeric
declare @espe_ccod numeric
declare @espe_tdesc varchar(100)
------------------------------------------------------------------------------------
--------------------------------variable del cursos c_tabla-----------------------
declare @vca_sede_ccod numeric
declare @vca_carr_ccod char(3)
declare @vca_jorn_ccod numeric
declare @vca_valor numeric
declare @vca_carrera varchar(100)

-------------------------------variables del cursor c_usuarios-----------------------
declare @vcc_pers_ncorr numeric


----------------------------------cursor c_tabla-----------------------------------
declare c_tabla cursor for
select sede_ccod,carr_ccod,jorn_ccod,valor,ltrim(rtrim(carrera))
from matriculas_anticipadas 
where peri_ccod=@peri_origen
and mant_bactiva='S' 
---------------------------------------------fin cursor c_tabla---------------------------------  
open c_tabla
   fetch next from c_tabla
   into   @vca_sede_ccod,@vca_carr_ccod,@vca_jorn_ccod,@vca_valor,@vca_carrera
   while @@FETCH_STATUS = 0
    begin
   	            set @espe_ccod = 0
                select top 1 @espe_tdesc = b.carr_tdesc + ' ('+case a.jorn_ccod when 1 then 'D' else 'V' end + ')' 
                from matriculas_anticipadas a, carreras b
                where a.carr_ccod = b.carr_ccod 
				and a.carr_ccod=@vca_carr_ccod 
				and a.jorn_ccod=@vca_jorn_ccod
				and a.mant_bactiva='S'
                
                select @espe_ccod = isnull(espe_ccod,0) 
                from  especialidades 
                where espe_tdesc = @espe_tdesc
                
                if (@espe_ccod = 0 )--la especialidad aún no ha sido creada, procedemos a crearla
                 begin
                     
                     EXECUTE protic.RetornarSecuencia 'especialidades', @espe_ccod OUTPUT
                     
                     insert into especialidades (ESPE_CCOD,TTIT_CCOD,CARR_CCOD,EESP_CCOD,ESPE_TDESC,ESPE_FINI_VIGENCIA,ESPE_FFIN_VIGENCIA,
                     ESPE_TTITULO,ESPE_NDURACION,ESPE_BEXAMEN_ADM,AUDI_TUSUARIO,AUDI_FMODIFICACION,DUAS_CCOD,ESPE_TCERTIFIC,ESPE_NPLANIFICABLE)
                     values (@espe_ccod,1,@vca_carr_ccod,1,@espe_tdesc,null,null,@vca_carrera,11,'S','creación anticipada',getDate(),null,null,1)
                     
                  end
                    
                     -----------------debemos crear un registro para que los usuarios puedan acceder a esta nueva especialidad
                     declare c_usuarios cursor for
                     select distinct pers_ncorr
                     from sis_especialidades_usuario a, especialidades b
                     where a.espe_ccod=b.espe_ccod and b.carr_ccod=@vca_carr_ccod and a.jorn_ccod=@vca_jorn_ccod
                     open c_usuarios
                     fetch next from c_usuarios
                     into   @vcc_pers_ncorr
                     while @@FETCH_STATUS = 0
                        begin
                                insert into sis_especialidades_usuario (pers_ncorr,espe_ccod,jorn_ccod,audi_tusuario,audi_fmodificacion)
                                values (@vcc_pers_ncorr,@espe_ccod,@vca_jorn_ccod,'matricula anticipada',getDate())
                                fetch next from c_usuarios
                                into   @vcc_pers_ncorr
                        end
                      close c_usuarios
                      DEALLOCATE c_usuarios
                     ---------------------------------------------------------------------------------------------------------
                 
               
                EXECUTE protic.RetornarSecuencia 'aranceles', @aran_ncorr OUTPUT  
                     
                insert into aranceles (ARAN_NCORR,MONE_CCOD,OFER_NCORR,ARAN_TDESC,ARAN_MMATRICULA,ARAN_MCOLEGIATURA,ARAN_NANO_INGRESO,AUDI_TUSUARIO,
          AUDI_FMODIFICACION,sede_ccod,espe_ccod,carr_ccod,peri_ccod,jorn_ccod,aran_cvigente_fup)
                            values(@aran_ncorr,1,null,@vca_Carrera + ' 2006' ,@vca_valor,0,2006,'Matricula anticipada 2006',
                            getdate(),@vca_sede_ccod,@espe_ccod,@vca_carr_ccod,@peri_destino,@vca_jorn_ccod,'S')           
               
                EXECUTE protic.RetornarSecuencia 'ofertas_academicas', @ofer_ncorr OUTPUT
               
                insert into ofertas_academicas (OFER_NCORR,SEDE_CCOD,PERI_CCOD,ESPE_CCOD,JORN_CCOD,POST_BNUEVO,ARAN_NCORR,OFER_NVACANTES,
                                            	OFER_NQUORUM,OFER_BPAGA_EXAMEN,AUDI_TUSUARIO,AUDI_FMODIFICACION,OFER_BPUBLICA,OFER_BACTIVA)
                values (@ofer_ncorr, @vca_sede_ccod,@peri_destino,@espe_ccod,@vca_jorn_ccod,'S',@aran_ncorr,100,
                1,'S','Matricula anticipada 2006',getDate(),'S','S')
               
               
                update aranceles set ofer_ncorr=@ofer_ncorr where aran_ncorr=@aran_ncorr
          
    fetch next from c_tabla
    into   @vca_sede_ccod,@vca_carr_ccod,@vca_jorn_ccod,@vca_valor,@vca_carrera
			  
    END --fin while
    close c_tabla
    DEALLOCATE c_tabla
    print 'Termino la ejecución del procedimiento';
END