alter procedure sd_crea_historial_eventos 
as
begin

declare @v_indice numeric
declare @v_even_ncorr numeric
declare @v_pers_ncorr_evento numeric
declare @v_cantidad numeric
declare @v_cantidad_pers_ncorr numeric

-- variables cursor c_eventos
declare @r_colegio numeric
declare @r_ciud_ccod_cole numeric
declare @r_fecha_evento datetime
declare @r_teve_ccod numeric
declare @r_cantidad numeric
declare @r_fecha_digitacion datetime

-- variables cursos c_personas_eventos
declare @r_tipo numeric
declare @r_fecha_evento_per datetime
declare @r_nombre_colegio numeric
declare @r_comuna_colegio numeric
declare @r_comuna  numeric
declare @r_rut numeric
declare @r_dig varchar (1)
declare @r_nombres varchar (150)
declare @r_paterno varchar (150)
declare @r_materno varchar (150)
declare @r_direccion varchar (150)
declare @r_fono varchar (50) 
declare @r_email varchar (100)
declare @r_curso numeric
declare @r_observaciones varchar (150)
declare @r_carrera1 varchar (100)
declare @r_carrera2 varchar (100)
declare @r_carrera3 varchar (100)
declare @r_preferencia numeric

 
DECLARE c_eventos CURSOR LOCAL FOR
 select distinct  tipo,nombre_colegio,comuna_colegio,
 convert(datetime,protic.trunc(fecha_evento),103) as fecha_evento, 
 convert(datetime,protic.trunc(max(fecha_digitacion)),103) as fecha_modificacion,
 count (*) as cantidad_fichas
 from fox..marketing_eventos
group by tipo,nombre_colegio, comuna_colegio,fecha_evento
 
  
    OPEN c_eventos
    FETCH NEXT FROM c_eventos
    INTO  @r_teve_ccod,@r_colegio,@r_ciud_ccod_cole,@r_fecha_evento, @r_fecha_digitacion, @r_cantidad

     While @@FETCH_STATUS = 0
        Begin
           
set @v_indice=0  
           exec protic.RetornarSecuencia 'eventos',@v_even_ncorr output
           
--print ' ---------------Evento---------------> '+cast(@v_even_ncorr as varchar)

	      insert into eventos_upa (EVEN_NCORR,TEVE_CCOD,EVEN_FEVENTO,EVEN_NCANTIDAD_FICHAS,EVEN_TRANGO_CURSOS,
           COLE_CCOD,EVEN_TRECIBIDO,EVEN_TNOMBRE,AUDI_TUSUARIO,AUDI_FMODIFICACION)   
            values(@v_even_ncorr,@r_teve_ccod,@r_fecha_evento,@r_cantidad,'historial eventos',
            @r_colegio,'informatica','evento migrado','mriffo',@r_fecha_digitacion) 

 

            -- llenado de los registros que contienen a los alumnos encuestados
                DECLARE c_personas_eventos CURSOR LOCAL FOR
                select  tipo,fecha_evento,nombre_colegio,comuna_colegio,comuna,rut,
                        dig,nombres,paterno, materno,direccion,fono, email, curso, observaciones,
                        carrera1, carrera2, carrera3, preferencia
                from fox..marketing_eventos
                where nombre_colegio=@r_colegio
                and tipo=@r_teve_ccod
                and comuna_colegio=@r_ciud_ccod_cole
                and fecha_evento=@r_fecha_evento

                OPEN c_personas_eventos
                FETCH NEXT FROM c_personas_eventos
                 into   @r_tipo,@r_fecha_evento_per,@r_nombre_colegio,@r_comuna_colegio,@r_comuna,@r_rut,@r_dig,@r_nombres,@r_paterno,@r_materno,
                        @r_direccion,@r_fono,@r_email,@r_curso,@r_observaciones,@r_carrera1,@r_carrera2,@r_carrera3,@r_preferencia

                     While @@FETCH_STATUS = 0
                        Begin
                     

                        set @v_indice=@v_indice+1     
                     
                            if @r_rut <> 0
                                begin
                                    select @v_pers_ncorr_evento=pers_ncorr_alumno from personas_eventos_upa where pers_nrut=@r_rut
                                    select @v_cantidad_pers_ncorr=count(*) from personas_eventos_upa where pers_nrut=@r_rut
                                end
                            else
                                begin
                                    select @v_pers_ncorr_evento=pers_ncorr_alumno from personas_eventos_upa where pers_nrut=@r_rut and pers_tnombre=@r_nombres and ciud_ccod=@r_comuna
                                    select @v_cantidad_pers_ncorr=count(*) from personas_eventos_upa where pers_nrut=@r_rut and pers_tnombre=@r_nombres and ciud_ccod=@r_comuna
                                end
                                
                     
                            If @v_cantidad_pers_ncorr =0
                                Begin
                    
                                    exec protic.RetornarSecuencia 'personas_eventos',@v_pers_ncorr_evento output
                                 
                                    insert into personas_eventos_upa 
                                    (PERS_NCORR_ALUMNO,PERS_NRUT,PERS_XDV,PERS_TNOMBRE,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,CIUD_CCOD,
                                    COLE_CCOD,CAEV_CCOD,PERS_TDIRECCION,PERS_TFONO,PERS_TEMAIL,AUDI_TUSUARIO ,AUDI_FMODIFICACION)
                                    Values 
                                    (@v_pers_ncorr_evento,@r_rut,@r_dig,@r_nombres,@r_paterno,@r_materno,@r_comuna,
                                    @r_nombre_colegio,@r_curso,@r_direccion,@r_fono,@r_email,'mriffo', getdate())
                        
                                End

                           select @v_cantidad=count(*) from eventos_alumnos where pers_ncorr_alumno=@v_pers_ncorr_evento and even_ncorr=@v_even_ncorr
                           
                           if @v_cantidad=0 
                                begin
                                    insert into eventos_alumnos
                                    ( EVEN_NCORR,PERS_NCORR_ALUMNO,CARRERA_1,CARRERA_2,CARRERA_3,PEST_CCOD,CAEV_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION)
                                    values
                                    (@v_even_ncorr,@v_pers_ncorr_evento,@r_carrera1,@r_carrera2,@r_carrera3,@r_preferencia,@r_curso,'mriffo', getdate())
                                end         

                    
                            FETCH NEXT FROM c_personas_eventos
                            INTO    @r_tipo,@r_fecha_evento_per,@r_nombre_colegio,@r_comuna_colegio,@r_comuna,@r_rut,@r_dig,@r_nombres,@r_paterno,@r_materno,
                                    @r_direccion,@r_fono,@r_email,@r_curso,@r_observaciones,@r_carrera1,@r_carrera2,@r_carrera3,@r_preferencia
                        End 
    
                CLOSE c_personas_eventos 
                DEALLOCATE c_personas_eventos	

--print ' ---------------Cantidad Ficha---------------> '+cast(@v_even_ncorr as varchar)+' ->'+cast(@v_indice as varchar)


            FETCH NEXT FROM c_eventos
            INTO  @r_teve_ccod,@r_colegio,@r_ciud_ccod_cole,@r_fecha_evento, @r_fecha_digitacion, @r_cantidad
        End 
    
    CLOSE c_eventos 
    DEALLOCATE c_eventos
 
end