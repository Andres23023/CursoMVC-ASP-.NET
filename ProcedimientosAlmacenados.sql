SELECT * 
  FROM DBCARRITO.INFORMATION_SCHEMA.ROUTINES
 WHERE ROUTINE_TYPE = 'PROCEDURE'

 create proc sp_RegistrarUsuario(
 @Nombres varchar(100),
 @Apellidos varchar(100),
 @Correo varchar(100),
 @Clave varchar(100),
 @Activo bit,
 @Mensaje varchar(500) output,
 @Resultado int output
 )
 as
 begin
	set @Resultado =0
	if not exists (select * from USUARIO where @Correo = Correo)
	begin
		insert into USUARIO(Nombres,Apellidos,Correo,Clave,Activo) 
		values(@Nombres,@Apellidos,@Correo,@Clave,@Activo)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'El correo del usuario ya existe'
end
		
------------------------------------------------------------------------

create proc sp_EditarUsuario(
 @IdUsuario int, 
 @Nombres varchar(100),
 @Apellidos varchar(100),
 @Correo varchar(100),
 @Activo bit,
 @Mensaje varchar(500) output,
 @Resultado bit output
)
as
begin
	set @Resultado =0
	if not exists (select * from USUARIO where Correo = @Correo and IdUsuario !=@IdUsuario)
	begin
		
		update top(1) USUARIO set 
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario

		set @Resultado = 1
	end
	else
	set @Mensaje = 'El correo del usuario ya existe'
end


--===================================================================================================--

select * from CATEGORIA

create proc sp_RegistrarCategoria(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(select * from CATEGORIA where Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion,Activo)
		values (@Descripcion,@Activo)
		
		set @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'La categoria ya existe'
end

-------------------------------------------------------------------------------------------------

create proc sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado =0
	if not exists(select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin
		
		update top(1) CATEGORIA set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria

		set @Resultado = 1
	end
	else
	set @Mensaje = 'La categoria ya existe'
end


-------------------------------------------------------------------------------------------------


create proc sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin 
	set @Resultado = 0

	if not exists(select * from PRODUCTO p
	inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
	where p.IdCategoria = @IdCategoria)
	
	begin
		delete top (1) from CATEGORIA where IdCategoria = @IdCategoria
		
		set @Resultado =1
	end
	else
	set @Mensaje = 'La categoria se encuentra relacionada a un producto'
end


--===================================================================================================--

select * from MARCA


create proc sp_RegistrarMarca(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as 
begin
	set @Resultado = 0
	if not exists (select * from MARCA where Descripcion =@Descripcion)
	begin
		insert into MARCA(Descripcion,Activo)
		values (@Descripcion,@Activo)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'La marca ya existe'
end

-------------------------------------------------------------------------------------------------

create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado =0
	if not exists(select * from MARCA where Descripcion = @Descripcion and IdMarca != @IdMarca)
	begin

		update top (1) MARCA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca

		set @Resultado = 1
	end
	else
		set @Mensaje = 'La marca ya existe'
end


-------------------------------------------------------------------------------------------------

create proc sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0

	if not exists (select * from PRODUCTO p 
	inner join MARCA m on m.IdMarca = p.IdMarca
	where p.IdMarca = @IdMarca)
	
	begin
		delete top (1) from MARCA where IdMarca = @IdMarca
		set @Resultado = 1
	end
	else
		set @Mensaje = 'La marca se encuentra relacionada a un producto'
end


--===================================================================================================--

create proc sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado =0
	if not exists (select * from PRODUCTO where Nombre = @Nombre)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo)
		values (@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El producto ya existe'
end


-------------------------------------------------------------------------------------------------


create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	if not exists(select * from PRODUCTO where Nombre = @Nombre and IdProducto != @IdProducto)
	begin
		
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		where IdProducto = @IdProducto

		set @Resultado = 1
	end
	else
	set @Mensaje = 'El rpducto ya existe'
end


-------------------------------------------------------------------------------------------------

create proc sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	if not exists(select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	
	begin
		delete top (1) from PRODUCTO where IdProducto = @IdProducto
		
		set @Resultado = 1
	end
	else
		set @Mensaje = 'El producto se encuentra relacionado a una venta'
end



--===================================================================================================--


create proc sp_ReporteDashboard
as
begin
	
	select
	(select count(*) from CLIENTE) [TotalCliente],
	(select ISNULL( sum(cantidad),0) from DETALLE_VENTA) [TotalVenta],
	(select count(*) from PRODUCTO)[TotalProducto]

end

-------------------------------------------------------------------------------------------------

create proc sp_ReporteVentas(
@FechaInicio varchar(10),
@FechaFin varchar(10),
@IdTransaccion varchar(50)
)
as
begin
	set dateformat dmy;
	select CONVERT(char(10), v.FechaVenta,103)[FechaVenta], CONCAT (c.Nombres,' ',c.Apellidos)[Cliente], 
	p.Nombre[Producto],p.Precio, dv.Cantidad,dv.Total,v.IdTransaccion
	from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	inner join VENTA v on v.IdVenta = dv.IdVenta
	inner join CLIENTE c on c.IdCliente = v.IdCliente
	where CONVERT(date,v.FechaVenta) between @FechaInicio and @FechaFin

	and v.IdTransaccion = iif(@IdTransaccion = '',v.IdTransaccion,@IdTransaccion)

end



--===================================================================================================--

create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(select * from CLIENTE where Correo = @Correo)
	begin 
		insert into CLIENTE(Nombres,Apellidos,Correo,Clave,Reestablecer)
		values (@Nombres,@Apellidos,@Correo,@Clave,0)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje='El correo del usuario ya existe'
end

--===================================================================================================--


declare @idcategoria int = 0

select distinct m.IdMarca,m.Descripcion from PRODUCTO p 
inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
inner join MARCA m on m.IdMarca = p.IdMarca and m.Activo =1
where c.IdCategoria = iif(@idcategoria = 0, c.IdCategoria,@idcategoria)

--===================================================================================================--




create proc sp_ExisteCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	if exists (select * from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto)
		set @Resultado =1
	else
		set @Resultado = 0
end

-------------------------------------------------------------------------------------------------

create proc sp_OperacionCarrito(
@IdCliente int,
@IdProducto int,
@Sumar bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado =1
	set @Mensaje =''

	declare @existecarrito bit = iif(exists(select * from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto),1,0)
	declare @stockproducto int = (select Stock from PRODUCTO where IdProducto = @IdProducto)

	begin try
		begin transaction OPERACION
		
		if(@Sumar = 1)
		begin
			if(@stockproducto>0)
			begin
				if(@existecarrito = 1)
					update CARRITO set Cantidad = Cantidad+1 where IdCliente = @IdCliente and IdProducto = @IdProducto
				else
					insert into CARRITO(IdCliente,IdProducto,Cantidad) values(@IdCliente,@IdProducto,1)

				update PRODUCTO set Stock = Stock - 1 where IdProducto = @IdProducto
			end
			else
			begin
				set @Resultado = 0
				set @Mensaje = 'El producto no cuenta con stock disponible'
			end
		end
		else
		begin
			update CARRITO set Cantidad = Cantidad - 1 where IdCliente = @IdCliente and IdProducto = @IdProducto
			update PRODUCTO set stock = stock + 1 where IdProducto = @IdProducto
		end

		commit transaction OPERACION
	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction OPERACION
	end catch
end
		
		

-------------------------------------------------------------------------------------------------

create proc sp_EliminarCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	declare @cantidadproducto int = (select Cantidad from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto)

	begin try
		begin transaction OPERACION

		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top (1) from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto

		commit transaction OPERACION
	end try
	begin catch
		set @Resultado = 0
		rollback transaction OPERACION
	end catch
end




--===================================================================================================--


create function fn_obtenerCarritoCliente(
@idcliente int
)
returns table
as
return(
	select p.IdProducto,m.Descripcion[DesMarca],p.Nombre,p.Precio,c.Cantidad,p.RutaImagen,p.NombreImagen 
	from CARRITO c
	inner join PRODUCTO p on p.IdProducto = c.IdProducto
	inner join MARCA m on m.IdMarca = p.IdMarca
	where c.IdCliente = @idcliente

)

select * from fn_obtenerCarritoCliente(1)


SELECT * FROM sys.objects WHERE type = 'FN'

--===================================================================================================--
select * from CLIENTE

create type [dbo].[EDetalle_Venta] as table(
	[IdProducto] int null,
	[Cantidad] int null,
	[Total] decimal(18,2) null
)



----------------------------------------------

create proc usp_RegistrarVenta(
@IdCliente int,
@TotalProducto int,
@MontoTotal decimal(18,2),
@Contacto varchar(100),
@IdDistrito varchar(6),
@Telefono varchar(10),
@Direccion varchar(100),
@IdTransaccion varchar(50),
@DetalleVenta [EDetalle_Venta] readonly,
@Resultado bit output,
@Mensaje varchar(500) output
)
as 
begin
	begin try
		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro

		insert into VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,IdDistrito,Telefono,Direccion,IdTransaccion)
		values (@IdCliente,@TotalProducto,@MontoTotal,@Contacto,@IdDistrito,@Telefono,@Direccion,@IdTransaccion)

		set @idventa = SCOPE_IDENTITY()

		insert into DETALLE_VENTA(IdVenta,IdProducto,Cantidad,Total)
		select @idventa,IdProducto,Cantidad,Total from @DetalleVenta

		delete from CARRITO where IdCliente = @IdCliente

		commit transaction registro

	end try
	begin catch 
		set @Resultado=0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end
