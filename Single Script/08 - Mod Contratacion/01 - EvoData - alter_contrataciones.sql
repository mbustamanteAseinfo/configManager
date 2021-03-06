ALTER PROCEDURE [acc].[finaliza_contratacion]
    @codigo int
AS
DECLARE
    @codExp int,
    @username varchar(50), --La logitud es de 50 igual que el usr_username
    @codUsuario int,
    @idRol varchar(50),
    @pais varchar(2),
    @mensaje varchar(255)
BEGIN
    ------------------------------------------------------------------------------
    --Validaciones
    ------------------------------------------------------------------------------
    select @codExp = con_codexp
      from acc.con_contrataciones 
     where con_codigo = @codigo
    
    --validando que no exista un usuario asociado al expediente
    if exists (select 1 from sec.eus_expediente_usuario where eus_codexp = @codExp)
    BEGIN
        --RAISERROR ('El usuario no fue creado, ya tiene uno.', 16, 1)
        RETURN
    END;
                        
    --validando si el nuevo empleado tiene un correo interno
    if not exists(select 1  
                    from exp.exp_expedientes
                   where exp_codigo = @codExp 
                     and len(ltrim(rtrim(isnull(exp_email_interno, ''))) ) > 0)
    BEGIN
        RAISERROR ('El usuario no fue creado, el empleado no tiene un correo interno.', 16, 1)
        RETURN
    END

    select @username = ltrim(rtrim(substring( substring(exp_email_interno, 0, charindex('@', exp_email_interno)), 0, 50)))
      from exp.exp_expedientes 
     where exp_codigo = @codExp
    
    select @pais = cia_codpai
      from acc.con_contrataciones
      join eor.plz_plazas on plz_codigo = con_codplz
      join eor.cia_companias on cia_codigo = plz_codcia
     where con_codigo = @codigo

    -- verificando si el usuario tiene subalternos para asignarle un rol jefe de lo contrario se le asigna un rol básico
    if exists(select 1
                from eor.pjf_plaza_jefes 
                join eor.plz_plazas on pjf_codplz_jefe = plz_codigo 
                join exp.emp_empleos on emp_codplz = plz_codigo 
                join exp.exp_expedientes on exp_codigo = emp_codexp
               where exp_codigo = @codExp 
                 and exists (select plz_codigo from eor.plz_plazas where plz_codigo = pjf_codplz and plz_estado != 'S'))
        select @idRol = gen.get_valor_parametro_varchar('RolJefe', @pais, null, null, null)
    else
        select @idRol = gen.get_valor_parametro_varchar('RolUsuario', @pais, null, null, null)
    
    --validando que el rol este configurado y que exista
    if @idRol is null or not exists (select 1 from sec.rol_roles where rol_id = @idRol)
    BEGIN
        RAISERROR ('El usuario no fue creado, el rol no esta configurado o el que se encuentra configurado no existe (Verificar parámetros de aplicación y los roles).', 16, 1)
        RETURN
    END;
    
    --Validando que el username no exista
    if exists(select 1 from sec.usr_users where usr_username = @username)
    BEGIN
        set @mensaje = 'El usuario no fue creado, username: ' + @username + ' ya existe. Modifique el usuario existente o el correo interno del nuevo empleado'
        RAISERROR (@mensaje, 16, 1)
        RETURN
    END;
        
    ------------------------------------------------------------------------------
    --Creando el usuario
    ------------------------------------------------------------------------------
    begin transaction

    insert into sec.usr_users
       (usr_username, usr_nombre_usuario, usr_activo, usr_modo_autenticacion, 
        usr_email, usr_password, 
        usr_pass_vence, usr_pass_cambiar_prox_acceso, usr_ver_mismo, usr_ver_subalternos, usr_ver_solo_subalt_inmediat,
        usr_estado_workflow, usr_codigo_workflow, usr_ingresado_portal)
    select @username, substring(exp_apellidos_nombres, 0, 100), 1, 'A',
           substring(exp_email_interno, 0, 50), 'gNNUG5GTVoPucd/PTSHF41UCLi+wfxXTgcbhGlRFjJ0=', --UFM2012
           0, 1, 1, 1, 0,
           'Autorizado', null, 0
      from exp.exp_expedientes where exp_codigo = @codExp
    
    insert into sec.eus_expediente_usuario (eus_codusr, eus_codexp)
    select usr_codigo, @codExp from sec.usr_users where usr_username = @username
      
    --asociando el rol al usuario creado
    insert sec.rus_roles_users (rus_rol_id, rus_codusr) 
    select @idRol, usr_codigo from sec.usr_users where usr_username = @username

	if exists(select 1 from con_contrataciones con inner join eor.plz_plazas plz  on plz.plz_codigo = con.con_codplz inner join eor.cia_companias cia on cia.cia_codigo = plz_codcia where con_codigo = @codigo and cia.cia_codpai = 'pa') begin
		update exp.emp_empleos set emp_property_bag_data = '
		<DocumentElement>
		  <Empleos>
			<emp_descuenta_seguro_social>S</emp_descuenta_seguro_social>
			<emp_descuenta_seguro_educativo>S</emp_descuenta_seguro_educativo>
			<emp_suspendido>N</emp_suspendido>
			<emp_renta>S</emp_renta>
			<emp_renta_gr>S</emp_renta_gr>
			<emp_marca_tarjeta>N</emp_marca_tarjeta>
			<emp_firmante>N</emp_firmante>
		  </Empleos>
		</DocumentElement>' from exp.emp_empleos 
						JOIN acc.con_contrataciones ON con_contrataciones.con_codemp = emp_empleos.emp_codigo
						WHERE con_codigo = @codigo

	end
    commit transaction
END
