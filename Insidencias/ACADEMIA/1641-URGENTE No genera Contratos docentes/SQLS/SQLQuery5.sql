USE [sigaupa]
GO

/****** Object:  StoredProcedure [dbo].[GENERA_CONTRATO_DOCENTE]    Script Date: 02/29/2016 13:02:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[GENERA_CONTRATO_DOCENTE] (
@p_pers_ncorr numeric, 
@p_sede_ccod numeric, 
@p_carr_ccod char(3), 
@p_jorn_ccod numeric,
@p_tcdo_ccod numeric,
@p_audi_tusuario varchar(250)
)as
/*******************************************************************
DESCRIPCION		:  Generacion de contratos docentes
FECHA CREACIÓN	:
CREADO POR 		: Mario Riffo I.
ENTRADA		    :NA
SALIDA			:NA
MODULO QUE ES UTILIZADO: Contratos Docentes

--ACTUALIZACION--

FECHA ACTUALIZACION 	:25/04/2013
ACTUALIZADO POR		:JAIME PAINEMAL A.
MOTIVO			:Corregir código; eliminar sentencia *=
LINEA			:448 - 510

--ACTUALIZACION--

FECHA ACTUALIZACION :06/08/2013
ACTUALIZADO POR		:Mario Riffo
MOTIVO			:Actualizar fecha inicio contratos y anexos seg semstre (05/08)
LINEA			:127 - 286

FECHA ACTUALIZACION :06/08/2013
ACTUALIZADO POR		:Mario Riffo
MOTIVO			:Agrega validacion para contratos con ayudantes end bloques de laboratorio, terreno y e-learnign
LINEA			:127 - 286
********************************************************************/
Begin

------  Variables Generales --------
declare @v_contrato numeric -----\
declare @v_anex_ncorr numeric ----> Llaves
declare @v_dane_ncorr numeric -- /
declare @v_num_anexo numeric -- codigo del anexo
declare @v_fecha_inicio datetime
declare @v_fecha_fin datetime
declare @v_ano_actual numeric
declare @v_inicio_reg varchar(10)
declare @v_fin_reg varchar(10)
declare @v_mes_actual numeric
declare @v_mes_i_reg numeric
declare @v_mes_f_reg numeric
declare @v_num_cuotas numeric
declare @v_tipo_profe numeric
declare @v_horas_maximas numeric
declare @v_horas_asignadas numeric
declare @v_horas integer
declare @v_inicio_contrato datetime
declare @v_crear_fecha_fin numeric
declare @conteo_anexos numeric
declare @v_salida numeric
declare @v_coodinacion_antigua numeric
declare @v_cant_anexo numeric
declare @v_sin_fecha_fin numeric
declare @v_fin_mes varchar(2)
declare @v_fin_mesf varchar(2)
declare @v_num_reg numeric
declare @v_cont_reg numeric
declare @v_ultima_asig varchar(25)
declare @v_modo_on numeric 
------------------------------------


------  Variables del cursor c_anexos_escuela  ---------
declare @rae_duas_ccod numeric
declare @rae_sede_ccod numeric
declare @rae_carr_ccod numeric
declare @rae_jorn_ccod numeric
declare @rae_tcat_ccod numeric  
declare @rae_seccion  numeric
declare @rae_tipo_bloque numeric
--------------------------------------------------------

------  Variables del cursor c_detalle_anexos  ---------
declare @rda_asig_ccod varchar(25)
declare @rda_secc_ccod numeric
declare @rda_valor_sesion numeric
declare @rda_horas_asig numeric
declare @rda_bloque numeric
--------------------------------------------------------

--##########    INICIALIZACION DE VARIABLES ######################
select @v_ano_actual=datepart(year,getdate())
--select @v_ano_actual=2013 -- año fijo porque se siguen haciendo contratos en enero del año anterior
select @v_mes_actual=datepart(month,getdate())
set @conteo_anexos=0
set @v_salida=1 -- sin error

set transaction isolation level serializable
begin transaction

select @v_tipo_profe=tpro_ccod from profesores where pers_ncorr=@p_pers_ncorr and sede_ccod=@p_sede_ccod 
 
------------------------------------------------------------------------------------------
 --     Obtiene el ultimo contrato activo que posee el docente
    Select  @v_contrato=CDOC_NCORR, @v_fecha_inicio=CDOC_FINICIO, @v_fecha_fin=CDOC_FFIN 
    From CONTRATOS_DOCENTES_UPA 
    where pers_ncorr=@p_pers_ncorr 
    and ecdo_ccod=1
------------------------------------------------------------------------------------------


if @v_contrato is null   -- Crear un nuevo contrato
begin
	set @v_crear_fecha_fin=1
    --obtiene el ultimo anexo que se habia generado en la contratacion antigua
    --select @v_num_anexo=max(bloq_anexo) from  bloques_profesores where pers_ncorr=@p_pers_ncorr and proc_ccod is not null
	if @v_num_anexo is null
    begin
		set @v_num_anexo=0
    end
    if @v_mes_actual=3 -- si es Marzo (1er Semestre- Inicio año academico)
    begin
		set @v_inicio_contrato='09-03-'+cast(@v_ano_actual as varchar)
        set @v_mes_actual=null
    end
else
    begin   
    if @v_mes_actual=8 -- si es Agosto (2do Semestre)
    begin
	    set @v_inicio_contrato='05-'+cast(@v_mes_actual as varchar)+'-'+cast(@v_ano_actual as varchar)
    end
    else
    begin
		set @v_inicio_contrato='09-'+cast(@v_mes_actual as varchar)+'-'+cast(@v_ano_actual as varchar)
    end 
end
         
            
            exec protic.RetornarSecuencia 'contrato_docente',@v_contrato output
    
            insert into contratos_docentes_upa(CDOC_NCORR,PERS_NCORR,TPRO_CCOD,CDOC_FCONTRATO,cdoc_finicio,ECDO_CCOD,ANO_CONTRATO,TCDO_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION)
            values (@v_contrato,@p_pers_ncorr,@v_tipo_profe,getdate(),@v_inicio_contrato,1,@v_ano_actual,@p_tcdo_ccod,@p_audi_tusuario,getdate())
           
        end 
     else
        begin

           select @v_num_anexo=max(ANEX_NCODIGO) from anexos where CDOC_NCORR=@v_contrato and eane_ccod not in (3)

        /*
		-- si existe un contrato se verifica si todos sus anexos estan nulos,
        -- de ser asi se vuelve a obtener el ultimo anexo antiguo
    		if @v_num_anexo is null
                begin
				    select @v_cant_anexo=count(ANEX_NCODIGO) from anexos where CDOC_NCORR=@v_contrato
				    if @v_cant_anexo>0 --existian contratos previamente creados
					    begin
                                --se obtiene el ultimo antiguo
						       select @v_num_anexo=max(bloq_anexo) from  bloques_profesores where pers_ncorr=@p_pers_ncorr and proc_ccod is not null
					    end
				    else
					    begin
	                	    set @v_num_anexo=0
					    end
                end  
		*/
			--validacion extra (por cualquier anomalia)
			if @v_num_anexo is null
				begin
					set @v_num_anexo=0
				end 
			  
        end   
        
   
 -- obtiene los anexos a generar en esta escuela para el docente seleccionado
 declare c_anexos_escuela cursor LOCAL STATIC for
	SELECT  F.DUAS_CCOD,A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD, protic.obtiene_categoria_carrera(@p_pers_ncorr,@p_sede_ccod,@p_carr_ccod,@p_jorn_ccod,max(d.peri_ccod),isnull(b.bloq_ayudantia,0)) AS CATEGORIA,
	max(D.SECC_CCOD) as secc_ccod,isnull(b.bloq_ayudantia,0) as tipo_bloque
	FROM BLOQUES_PROFESORES A, BLOQUES_HORARIOS B, SECCIONES D, CARRERAS_DOCENTE E, asignaturas F
	WHERE   A.BLOQ_ANEXO IS null
			and A.CDOC_NCORR IS null
            and E.TCAT_CCOD IS NOT NULL
			and B.BLOQ_CCOD     = A.BLOQ_CCOD
			and D.SECC_CCOD     = B.SECC_CCOD
			and D.CARR_CCOD     = E.CARR_CCOD
            and D.SEDE_CCOD     = E.SEDE_CCOD
            and D.JORN_CCOD     = E.JORN_CCOD
			and E.PERS_NCORR    = A.PERS_NCORR
			and F.ASIG_CCOD     = D.ASIG_CCOD
            and E.SEDE_CCOD     = A.SEDE_CCOD
            and A.PERS_NCORR    = @p_pers_ncorr
            and E.SEDE_CCOD     = @p_sede_ccod
            and E.CARR_CCOD     = @p_carr_ccod
		    and E.JORN_CCOD     = @p_jorn_ccod
			--and isnull(D.seccion_completa,'N')='S' 
            and F.DUAS_CCOD not in (5)
    group by A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD,F.DUAS_CCOD,b.bloq_ayudantia
--	order by F.DUAS_CCOD,A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD

UNION

	SELECT  F.DUAS_CCOD,A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD, protic.obtiene_categoria_carrera(@p_pers_ncorr,@p_sede_ccod,@p_carr_ccod,@p_jorn_ccod,d.peri_ccod,isnull(b.bloq_ayudantia,0)) AS CATEGORIA,
	D.SECC_CCOD,isnull(b.bloq_ayudantia,0) as tipo_bloque
	FROM BLOQUES_PROFESORES A, BLOQUES_HORARIOS B, SECCIONES D, CARRERAS_DOCENTE E, asignaturas F
	WHERE   A.BLOQ_ANEXO IS null
			and A.CDOC_NCORR IS null
            and E.TCAT_CCOD IS NOT NULL
			and B.BLOQ_CCOD     = A.BLOQ_CCOD
			and D.SECC_CCOD     = B.SECC_CCOD
			and D.CARR_CCOD     = E.CARR_CCOD
            and D.SEDE_CCOD     = E.SEDE_CCOD
            and D.JORN_CCOD     = E.JORN_CCOD
			and E.PERS_NCORR    = A.PERS_NCORR
			and F.ASIG_CCOD     = D.ASIG_CCOD
            and E.SEDE_CCOD     = A.SEDE_CCOD
            and A.PERS_NCORR    = @p_pers_ncorr
            and E.SEDE_CCOD     = @p_sede_ccod
            and E.CARR_CCOD     = @p_carr_ccod
		    and E.JORN_CCOD     = @p_jorn_ccod
			--and isnull(D.seccion_completa,'N')='S'
            and F.DUAS_CCOD  in (5)
    group by A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD,F.DUAS_CCOD,D.SECC_CCOD,d.peri_ccod,b.bloq_ayudantia
	order by F.DUAS_CCOD,A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD

-----------------------------------------------------------------------------------
        
        Open c_anexos_escuela
		Fetch next from c_anexos_escuela
        into @rae_duas_ccod,@rae_sede_ccod, @rae_carr_ccod,@rae_jorn_ccod,@rae_tcat_ccod,@rae_seccion,@rae_tipo_bloque
            while @@FETCH_STATUS = 0
                begin
				if @rae_tcat_ccod is not null
					begin
		                -- INSERTA UN NUEVO ANEXO PARA EL CONTRATO ACTIVO DEL DOCENTE
		                set @v_num_anexo=@v_num_anexo+1  
		     			set @conteo_anexos=@conteo_anexos+1
 
		            	--########################################################################
		                  -----   CALCULO PARA CREAR LAS FECHAS TENTATIVAS DE LOS ANEXOS  -----
		                    if @rae_duas_ccod=5 -- regimen periodo de la asignatura
		    					begin
		                   			select 
		                            @v_inicio_reg=replace(substring(protic.trunc(secc_finicio_sec),1,5),'/','-'),
		                            @v_fin_reg=replace(substring(protic.trunc(secc_ftermino_sec),1,5),'/','-'),
		                            @v_mes_i_reg=cast(substring(protic.trunc(secc_finicio_sec),4,2)as integer),
		                            @v_mes_f_reg=cast(substring(protic.trunc(secc_ftermino_sec),4,2)as integer)
		                            from secciones 
		                            where secc_ccod=@rae_seccion   
		                        end 
		                    else
		                        begin
                        
		                            select @v_inicio_reg=preg_inicio,@v_fin_reg=preg_fin,
		                                   @v_mes_i_reg=cast(substring(preg_inicio,4,2)as integer),
		                                   @v_mes_f_reg=cast(substring(preg_fin,4,2)as integer)
		                            from planificacion_regimen 
		                            where duas_ccod     =   @rae_duas_ccod 
		                                and tpro_ccod   =   @v_tipo_profe 
		                                and datepart(month,getdate())+1 between cast(substring(preg_inicio,4,2)as integer)
		                                and cast(substring(preg_fin,4,2)as integer)
		                        end           
                         
                         
		                            if @v_mes_actual >= @v_mes_i_reg  
		                                begin
                                   
		                                    if @v_mes_actual > @v_mes_f_reg
		                                        begin   -- en caso que calcule pasado el periodo asignado (limites fechas  regimen)
		                                            set @v_inicio_reg   =   '01-'+cast(@v_mes_f_reg as varchar)+'-'+cast(@v_ano_actual as varchar)
		                                            set @v_fin_reg      =   @v_fin_reg+'-'+cast(@v_ano_actual as varchar)
		                                        end 
		                                    else
		                                        begin
		                                            if @v_mes_actual = @v_mes_i_reg and @rae_duas_ccod=5 --(si es periodo y quedo dentro del mismo mes)
		                                                begin

		                                                    select @v_fin_mes = fdem_ndia from FIN_DE_MES where fdem_nmes=@v_mes_i_reg
		                                                    select @v_fin_mesf = fdem_ndia from FIN_DE_MES where fdem_nmes=@v_mes_f_reg

		                                                    set @v_inicio_reg   =   '01-'+cast(@v_mes_actual as varchar)+'-'+cast(@v_ano_actual as varchar)
		                                                    set @v_fin_reg      =   cast(@v_fin_mesf as varchar)+'-'+cast(@v_mes_f_reg as varchar)+'-'+cast(@v_ano_actual as varchar)
                 
														end
		                                   else -- si no es periodo
		                                                begin
                                                            if @v_mes_actual=8 -- si es Agosto (2do Semestre)
              begin
                                                                    set @v_inicio_reg='05-'+cast(@v_mes_actual as varchar)+'-'+cast(@v_ano_actual as varchar)
                                                                    set @v_fin_reg      =   @v_fin_reg+'-'+cast(@v_ano_actual as varchar)
                                                                end
                                                            else
                                                                begin
        		                                                    set @v_inicio_reg   =   '01-'+cast(@v_mes_actual as varchar)+'-'+cast(@v_ano_actual as varchar)
        		                                                    set @v_fin_reg      =   @v_fin_reg+'-'+cast(@v_ano_actual as varchar)
		                                                        end
                                                        end    
		                                     end
		                               end
		         else --calculo realizado un mes antes de iniciar la seccion
		                                begin
		                                    set @v_inicio_reg   =   @v_inicio_reg+'-'+cast(@v_ano_actual as varchar)
		                                    set @v_fin_reg      =   @v_fin_reg+'-'+cast(@v_ano_actual as varchar)
		              end
   --print 'inicio: '+cast(@v_inicio_reg as varchar) 
   --print 'fin: '+cast(@v_fin_reg as varchar)    
		  				select @v_num_cuotas=DATEDIFF(month, convert(datetime,@v_inicio_reg,103), convert(datetime,@v_fin_reg,103)) + 1
   --print 'cuotas '+cast(@v_num_cuotas as varchar)  

		                    --##############################################################################
                    
                    
		     				--##############################################################################
		                    --##########    OBTENCION DE LAS HORAS DE COORDINACION PARA EL DOCENTE    ############
		                    if @v_tipo_profe=1 and @rae_tipo_bloque=0
		                        begin
		                            
                                    Select @v_horas_maximas=duas_nhoras_coordina from duracion_asignatura where duas_ccod=@rae_duas_ccod
                    
		                            -- CALCULO DE LAS HORAS YA ASIGNADAS (Contratos Nuevos)
		                            Select @v_horas_asignadas=sum(b.anex_nhoras_coordina) 
		                            from contratos_docentes_upa a, anexos b
		                            Where a.cdoc_ncorr=b.cdoc_ncorr
		                                And a.pers_ncorr=@p_pers_ncorr
		                                and b.sede_ccod=@p_sede_ccod
		                                and b.carr_ccod=@p_carr_ccod
		                                and b.jorn_ccod=@p_jorn_ccod
		                                and a.ecdo_ccod=1
		                                and b.eane_ccod<>3     
                    
		                            --###########################################################
		                            --################# HORAS CONTRATOS ANTIGUOS ################
                            
                                    
		                    	        SELECT  @v_coodinacion_antigua=sum(a.hcor_valor1)
			                            FROM BLOQUES_PROFESORES A, BLOQUES_HORARIOS B, SECCIONES D, CARRERAS_DOCENTE E, asignaturas F
			                            WHERE   A.BLOQ_ANEXO IS not null
					                            and A.CDOC_NCORR IS not null
					                            and B.BLOQ_CCOD     = A.BLOQ_CCOD
					                            and D.SECC_CCOD     = B.SECC_CCOD
					                            and D.CARR_CCOD     = E.CARR_CCOD
		                     and D.SEDE_CCOD     = E.SEDE_CCOD
		                                        and D.JORN_CCOD     = E.JORN_CCOD
					                            and E.PERS_NCORR    = A.PERS_NCORR
					                            and F.ASIG_CCOD     = D.ASIG_CCOD
		                                        and E.SEDE_CCOD     = A.SEDE_CCOD
		                                        and A.PERS_NCORR    = @p_pers_ncorr
		                                        and E.SEDE_CCOD     = @p_sede_ccod
		                                        and E.CARR_CCOD     = @p_carr_ccod
				                                and E.JORN_CCOD     = @p_jorn_ccod
		                                group by A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD
                                    
                                    --set @v_coodinacion_antigua=0
                                        
		                            --###########################################################
    
                    
                                if @v_coodinacion_antigua is null
	                                begin
		                                set @v_coodinacion_antigua=0
	                                end
                                if @v_horas_asignadas is null
	                                begin
	                                  set @v_horas_asignadas=0
	                                end
		                    	-- si tenia antes horas de coordinacion por el primer semestre
		                    	-- entonces corresponde darle 2 mas para la escuela.
		                        if @v_coodinacion_antigua=2 and @rae_duas_ccod=2
                                    begin
		        						set @v_horas_maximas=@v_horas_maximas+2
		                            end
                    
		                        set @v_horas=@v_horas_maximas-(@v_horas_asignadas+@v_coodinacion_antigua)
       
		                        if @v_horas <= 0 or @v_tipo_profe <> 1
		                            begin
										set @v_horas=0
									end
		                    end 
		                else -- si es ayudante
		                        begin
		                            set @v_horas=0
		                        end
		                    --##########################################################################                    
                    
		                    exec protic.RetornarSecuencia 'anexos',@v_anex_ncorr output
                    
		                    insert into anexos(ANEX_NCORR,CDOC_NCORR,ANEX_NCODIGO,eane_ccod,TPRO_CCOD,ANEX_FINICIO,ANEX_FFIN,SEDE_CCOD,CARR_CCOD,JORN_CCOD,ANEX_NCUOTAS,ANEX_NHORAS_COORDINA,AUDI_TUSUARIO, AUDI_FMODIFICACION)
		                    values(@v_anex_ncorr,@v_contrato,@v_num_anexo,1,@v_tipo_profe,convert(datetime,@v_inicio_reg,103),convert(datetime,@v_fin_reg,103),@rae_sede_ccod,@rae_carr_ccod,@rae_jorn_ccod,@v_num_cuotas,@v_horas,@p_audi_tusuario,getdate())
                    
                    
		                    --**********************************************************************************************
		                    ----------          cursor para detalle de anexo        ------------
		                    if @rae_duas_ccod=5 
		                        begin
                    
		                         declare c_detalle_anexos cursor LOCAL STATIC for

		                    		    SELECT  distinct D.ASIG_CCOD,d.secc_ccod,protic.obtiene_monto_categoria(@rae_tcat_ccod) as monto,
		                                ISNULL(CASE WHEN d.MODA_CCOD in(1) THEN 
		                                isnull(Y.hopr_nhoras , case isnull(b.bloq_ayudantia,0) when 0 then protic.retorna_horas_seccion1(d.secc_ccod,@v_tipo_profe,e.pers_ncorr) else protic.retorna_horas_tipo_bloque(d.secc_ccod,b.bloq_ayudantia) end)
		                                 ELSE isnull(Y.hopr_nhoras,d.secc_nhoras_pagar)  END ,0) AS ASIG_NHORAS,
		                                 B.BLOQ_CCOD
			                           FROM BLOQUES_PROFESORES A
			                           INNER JOIN BLOQUES_HORARIOS B 
			                           ON B.BLOQ_CCOD = A.BLOQ_CCOD and A.BLOQ_ANEXO IS null AND A.PERS_NCORR = @p_pers_ncorr and isnull(b.bloq_ayudantia,0) = @rae_tipo_bloque
			                           INNER JOIN SECCIONES D 
			                           ON D.SECC_CCOD = B.SECC_CCOD and D.SECC_CCOD = @rae_seccion
			                           INNER JOIN CARRERAS_DOCENTE E 
			                           ON D.CARR_CCOD = E.CARR_CCOD 
			                           and D.SEDE_CCOD = E.SEDE_CCOD 
			                           and D.JORN_CCOD = E.JORN_CCOD 
			                           and E.PERS_NCORR = A.PERS_NCORR 
			                           and E.SEDE_CCOD  = A.SEDE_CCOD 
			                           and E.TCAT_CCOD IS NOT NULL 
			                           and E.CARR_CCOD = @p_carr_ccod AND E.SEDE_CCOD = @p_sede_ccod AND E.JORN_CCOD = @p_jorn_ccod 
			                           INNER JOIN asignaturas F 
			                           ON F.ASIG_CCOD = D.ASIG_CCOD And F.DUAS_CCOD = @rae_duas_ccod
			                           LEFT OUTER JOIN horas_profesores Y 
			                           ON E.PERS_NCORR = Y.pers_ncorr 
			                           and D.SECC_CCOD = Y.secc_ccod 
			                           and isnull(b.bloq_ayudantia,0) = Y.bloq_ayudantia 
			                           and Y.hopr_nhoras > 0 
			                            order by D.ASIG_CCOD,d.secc_ccod

		                        end
		                else
		                    begin
                   
		                        declare c_detalle_anexos cursor LOCAL STATIC for
		 						    SELECT  distinct D.ASIG_CCOD,d.secc_ccod,protic.obtiene_monto_categoria(@rae_tcat_ccod) as monto,
		                                ISNULL(CASE WHEN d.MODA_CCOD in(1) THEN 
		                                isnull(Y.hopr_nhoras , case isnull(b.bloq_ayudantia,0) when 0 then protic.retorna_horas_seccion1(d.secc_ccod,@v_tipo_profe,e.pers_ncorr) 
                                            else case when b.bloq_ayudantia in (2,3,4) and tpro_ccod=2 then protic.retorna_horas_seccion1(d.secc_ccod,2,e.pers_ncorr) 
                                            else protic.retorna_horas_tipo_bloque(d.secc_ccod,b.bloq_ayudantia) end end)
		                                 ELSE isnull(Y.hopr_nhoras,d.secc_nhoras_pagar)  END ,0) AS ASIG_NHORAS,B.BLOQ_CCOD
			                            FROM BLOQUES_PROFESORES A
			                            INNER JOIN BLOQUES_HORARIOS B 
			                            ON B.BLOQ_CCOD = A.BLOQ_CCOD AND A.PERS_NCORR = @p_pers_ncorr
			                            and A.BLOQ_ANEXO IS null and isnull(b.bloq_ayudantia,0) = @rae_tipo_bloque
			                            INNER JOIN SECCIONES D 
			                            ON D.SECC_CCOD = B.SECC_CCOD 
			                            INNER JOIN CARRERAS_DOCENTE E 
			                            ON D.CARR_CCOD = E.CARR_CCOD 
			                            and D.SEDE_CCOD = E.SEDE_CCOD 
			                            and D.JORN_CCOD = E.JORN_CCOD 
			                            and E.PERS_NCORR = A.PERS_NCORR 
			                            and E.SEDE_CCOD  = A.SEDE_CCOD 
			                            and E.TCAT_CCOD IS NOT NULL 
			                            and E.CARR_CCOD = @p_carr_ccod 
			                            AND E.SEDE_CCOD = @p_sede_ccod 
			                            AND E.JORN_CCOD = @p_jorn_ccod 
			                            INNER JOIN asignaturas F 
			                            ON F.ASIG_CCOD = D.ASIG_CCOD And F.DUAS_CCOD = @rae_duas_ccod 
			                            LEFT OUTER JOIN horas_profesores Y
			                            ON E.PERS_NCORR = Y.pers_ncorr 
			                            and D.SECC_CCOD = Y.secc_ccod 
			                            and isnull(b.bloq_ayudantia,0) = Y.bloq_ayudantia 
			                            and Y.hopr_nhoras > 0 
			                            order by D.ASIG_CCOD,d.secc_ccod

		                    end                
		                                
                Open c_detalle_anexos
                           -----------------------------------
                                        -- Variables para controlar anexos con mas de 10 secciones
                                        --select @v_num_reg=@@CURSOR_ROWS
                                        --set @v_modo_on=1 
                                        --set @v_cont_reg=0
                                        -----------------------------------
				                        Fetch next from c_detalle_anexos
		                                into @rda_asig_ccod,@rda_secc_ccod, @rda_valor_sesion,@rda_horas_asig,@rda_bloque
		                                    while @@FETCH_STATUS = 0
		                                        begin
                                            
                                                    /*if @v_num_reg >10
                                                        begin
 
                                                            if @v_cont_reg>=10 and @rda_asig_ccod<>@v_ultima_asig and @v_modo_on=1
                                                                begin
                                                                    set @v_modo_on=0 
                end

                                                            set @v_cont_reg=@v_cont_reg+1
                                                            set @v_ultima_asig=@rda_asig_ccod

                                                        end
         

       if @v_modo_on=1
   begin */
		                                                    exec protic.RetornarSecuencia 'detalle_anexo',@v_dane_ncorr output
                                            
		                                                    insert into detalle_anexos(dane_ncorr,cdoc_ncorr,anex_ncorr,secc_ccod,bloq_ccod,asig_ccod,dane_nsesiones,duas_ccod,dane_msesion,audi_tusuario,audi_fmodificacion)
		                                                    values(@v_dane_ncorr,@v_contrato,@v_anex_ncorr,@rda_secc_ccod,@rda_bloque,@rda_asig_ccod,@rda_horas_asig,@rae_duas_ccod,@rda_valor_sesion,@p_audi_tusuario,getdate())
                                                        
                                                            -- marco la tabla bloques profesores con el bloque correspondiente
                                                            update bloques_profesores set bloq_anexo=@v_anex_ncorr, cdoc_ncorr=@v_contrato where bloq_ccod=@rda_bloque and pers_ncorr=@p_pers_ncorr
                                                       -- end
                                            
		                                            
                                            
		                            Fetch next from c_detalle_anexos
		                            into @rda_asig_ccod,@rda_secc_ccod, @rda_valor_sesion,@rda_horas_asig,@rda_bloque
		                                     end
		                        CLOSE c_detalle_anexos 
				                DEALLOCATE c_detalle_anexos
                                        
                    end --fin si no tiene categoria

                    Fetch next from c_anexos_escuela
                    into @rae_duas_ccod,@rae_sede_ccod,@rae_carr_ccod,@rae_jorn_ccod,@rae_tcat_ccod,@rae_seccion,@rae_tipo_bloque 
                end
                
            CLOSE c_anexos_escuela 
		    DEALLOCATE c_anexos_escuela

    select @v_sin_fecha_fin=count(*) from contratos_docentes_upa  where cdoc_ncorr=@v_contrato and cdoc_ffin is null
    
      if @v_crear_fecha_fin=1 or @v_sin_fecha_fin>0
        begin
            update contratos_docentes_upa set cdoc_ffin=convert(datetime,@v_fin_reg,103) where cdoc_ncorr=@v_contrato
        end      

  if @conteo_anexos=0
      begin
        set @v_salida=2 --no se crearon anexos
        rollback transaction
      end
  else
      begin
        set @v_salida=1 -- sin errores
        commit transaction
      end
  select @v_salida
End
 -- Fin procedimiento
GO


