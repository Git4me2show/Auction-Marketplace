<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<style>
	.navbar {
            overflow: hidden;
            background-color: #333;
        }

        .navbar a {
            float: left;
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
        }

        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }
	</style>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>BuyMe</title>
	</head>
	<div class="navbar">
    <a onclick="location.href='repHome.jsp'">Home Page</a>
    
	</div>
	<body>

		Hello, Customer Rep. <!-- the usual HTML way -->		  
		
	Enter the ID of a listing in order to delete it:
	<br>
		<form method="get" action="deleteListing.jsp">
			<table>
				<tr>    
					<td>ID</td><td><input type="text" name="listingID"></td>
				</tr>
			</table>
			<input type="submit" value="Delete">
		</form>
	<br>
	To edit a listing, enter its ID and the value for the given field:
	<br>
		<form method="get" action="editListing.jsp">
			<table>
				<tr>    
					<td>ID:</td><td><input type="text" name="listingIDedit"></td>
				</tr>
				<tr>    
					<td>Name:</td><td><input type="text" name="Name"></td>
				</tr>
				<tr>    
					<td>Description:</td><td><input type="text" name="Description"></td>
				</tr>
			</table>
			<input type="submit" value="Edit">
		</form>
	<br>
	
	
</body>
</html>