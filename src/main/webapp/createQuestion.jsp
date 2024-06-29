<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title></title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String question = request.getParameter("Question");
			String email = request.getParameter("username");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "INSERT INTO question VALUES (null,?,?,null,null)";
			//Run the query against the database.
			PreparedStatement ps = con.prepareStatement(str);
			ps.setString(1, question);
			ps.setString(2, email);
			ps.executeUpdate();
			con.close();
			response.sendRedirect("viewquestions.jsp");
			
			
		
		} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>