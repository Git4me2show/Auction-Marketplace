<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>BuyMe</title>
	</head>
	
	<body>

		Hello, Admin. <!-- the usual HTML way -->		  
		
	Insert a Customer Rep ID and password to create their account:
	<br>
		<form method="get" action="createCustomerRep.jsp">
			<table>
				<tr>    
					<td>ID</td><td><input type="text" name="repID"></td>
				</tr>
				<tr>    
					<td>password</td><td><input type="text" name="repPassword"></td>
				</tr>
			</table>
			<input type="submit" value="Create">
		</form>
	<br>
</body>
</html>