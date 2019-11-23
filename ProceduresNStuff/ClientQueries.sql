DROP PROCEDURE ClientInsert
CREATE PROCEDURE  ClientInsert
@ID int, @fname nvarchar(20),@Lname nvarchar(20), @DoB date, @Email nvarchar(30),
@PhoneN int, @HomeN int, @Address nvarchar(80)
As
Begin

Insert Into dbo.Client(ID, Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) values(@ID,@fname, @Lname, @DoB,@Email,@PhoneN,@HomeN,@Address)

return @ID
end

exec ClientInsert @ID=696969 , @fname='Hello', @Lname='world', @DoB='1969-01-01', @Email='masdsa@gmail.com',@PhoneN=99832222,@HomeN=24555555,@Address='Odos trifilaras'


Drop Procedure ClientUpdateEmail
Create procedure ClientUpdateEmail
@ID int , @Email nvarchar(30)
As
begin
update dbo.Client
set Email=@Email
where ID=@ID
return @ID
END

exec ClientUpdateEmail @ID=101302 ,@Email='dsaqwewqewqeqw@gmail.com'
-----------------------------------------
Drop Procedure ClientUpdatePersonalPhone
Create procedure ClientUpdatePersonalPhone
@ID int , @Phone int
As
begin
update dbo.Client
set PhoneNumber=@Phone
where ID=@ID
return @ID
END


exec ClientUpdatePersonalPhone @ID=106830 ,@Phone=99696969
------------------------------------------
Drop Procedure ClientUpdateResidentHome
Create procedure ClientUpdateResidentHome
@ID int , @Phone int
As
begin
update dbo.Client
set HomeNumber=@Phone
where ID=@ID
return @ID
END

exec ClientUpdateResidentHome @ID=106830 ,@Phone=99696969

-----------------------------------
Drop Procedure ClientUpdateAddress
Create procedure ClientUpdateAddress
@ID int , @Address nvarchar(80)
As
begin
update dbo.Client
set Address=@Address
where ID=@ID
return @ID
END


exec ClientUpdateAddress @ID=106830 ,@Address='Odos Omonoias Lefkosias'
-------------------------
Drop Procedure ClientDelete
Create Procedure ClientDelete
@ID int
as
begin
delete
from dbo.Client
where ID=@ID
end

exec ClientDelete @ID=101302

--------------------------
Drop procedure ClientShow
Create Procedure ClientShow
@ID int
as begin

select *
from dbo.Client
where dbo.client.ID=@ID
END

exec ClientShow @ID=101302




