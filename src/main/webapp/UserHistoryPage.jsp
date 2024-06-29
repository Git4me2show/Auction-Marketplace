<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.io.*,java.util.*,com.cs336.pkg.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<meta charset="ISO-8859-1">
<head>
    <title>User History Search</title>
</head>
<body>
<div class="navbar">
        <a onclick="location.href='home.jsp'">Home</a>
    </div>
<h1>Search User History</h1>
<form action="historyPull.jsp" method="post">
    <label for="email">Enter the Email of the User:</label><br>
    <input type="email" id="email" name="email" required><br><br>
    <input type="submit" value="Submit">
</form>
</body>
</html>