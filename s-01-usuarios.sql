--@Autor:                 Jorge Octavio Barcenas Avelar - Ana Laura Reynoso Gálvez
--@Fecha de creación:     24/11/2019
--@descripción:           creacion de usuarios y roles necearios para el proyecto Virtual Trabel
prompt Proporcionar el password del usuario sys:

connect sys as sysdba

prompt creando al usuario barg_proy_admin

create user barg_proy_admin identified by barg
quota unlimited on users;


prompt creando al usuario barg_proy_invitado

create user barg_proy_invitado identified by invitado;


prompt creando roles

create role rol_admin;
grant create session,create table, create view, create synonym, create sequence, create trigger,
 create procedure to p0703_admin_rol;

create role rol_invitado;
grant create session to rol_invitado;

prompt asignar el rol rol_admin a barg_proy_admin

grant rol_admin to barg_proy_admin;

grant rol_invitado to barg_proy_invitado;

prompt Listo!
disconnect;
