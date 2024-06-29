<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Question Page</title>
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

        .logout-btn {
            float: right;
            background-color: #1E90FF;
            border: none; 
            color: white; 
            padding: 10px 20px; 
            text-align: center; 
            text-decoration: none; 
            display: inline-block; 
            font-size: 16px; 
            font-weight: 700;
            margin: 4px 2px; 
            cursor: pointer; 
            border-radius: 8px; 
        }

        .logout-btn:hover {
            background-color: #45a049; 
        }

        .listing-container {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
        }

        .listing-card {
            width: 30%;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 10px;
            padding: 20px;
        }

        .listing-card h3 {
            margin-top: 0;
        }

        .listing-card p {
            margin-bottom: 0;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a onclick="location.href='home.jsp'">Home Page</a>
    <a onclick="location.href='questionpage.jsp'">Ask/Search Questions</a>
</div>

<h2>Welcome to the Question Page</h2>

<div class="listing-container">
    <% 
    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection(); 
        ResultSet rs = null;
        try {
        	
        	String keyword = request.getParameter("Keyword");
            String sql = "select * from question where question_ID in (select question_ID from question where text like ?) or question_ID in (select question_ID from question where answer like ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");    
            ps.setString(2, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
            	
    %>			
                <div class="listing-card">
                    <h3><%= rs.getString("text") %></h3>
                    <p>asked by <%= rs.getString("userEmail")  %></p>
                    <p><% if(rs.getString("answer") == null) { 
    						out.print("this question is unanswered."); 
                     	} 
                    	
                    	else out.print(rs.getString("answer")); %></p>
                    <p><% if(rs.getString("representative_ID") != null) { 
    						out.print("Answered by: " + rs.getString("representative_ID")); 
                     	} 
                    	
                    	 %></p>
                </div>
    <%
            }
        con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</div>

<script>
    function logout() {
        sessionStorage.setItem("logout", "true");
        location.href = "login.jsp";
    }
</script>

</body>
</html>