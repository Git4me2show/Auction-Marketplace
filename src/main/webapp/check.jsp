<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Page</title>
<script>
function showAlert(message) {
    alert(message);
}

function redirectToLogin() {
    window.location.href = "login.jsp";
}
</script>
</head>
<body>
<%
try {
    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection();        

    Statement stmt = con.createStatement();
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String sql = "SELECT password FROM end_user WHERE email = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, username);

    ResultSet rs = pstmt.executeQuery();

    Boolean isAuthenticated = false;

    if(rs.next()) {
        String dbPassword = rs.getString("password");
        isAuthenticated = dbPassword.equals(password);
    }

    if(isAuthenticated) {
        // Redirect to home.jsp if login is successful
        session.setAttribute("username", username);
        response.sendRedirect("home.jsp");
    }
    
    else {
        
    
	    String sqlRep = "SELECT representative_password FROM Customer_Representative WHERE representative_ID = ?";
	    PreparedStatement pstmtRep = con.prepareStatement(sqlRep);
	    pstmtRep.setString(1, username);
	    
	    ResultSet rsRep = pstmtRep.executeQuery();
	    
	    Boolean isAuthenticatedRep = false;
	    if(rsRep.next()) {
	        String dbPassword = rsRep.getString("representative_password");
	        isAuthenticatedRep = dbPassword.equals(password);
	    }
	
	    if(isAuthenticatedRep) {
	        // Redirect to home.jsp if login is successful
	        response.sendRedirect("repHome.jsp");
	    }
	    else {
	    	 String sqlAdmin = "SELECT Password FROM admin WHERE Email = ?";
	 	    PreparedStatement pstmtAdmin = con.prepareStatement(sqlAdmin);
	 	    pstmtAdmin.setString(1, username);
	 	    
	 	    ResultSet rsAdmin = pstmtAdmin.executeQuery();
	 	    
	 	    Boolean isAuthenticatedAdmin = false;
	 	    if(rsAdmin.next()) {
	 	        String dbPassword = rsAdmin.getString("password");
	 	        isAuthenticatedRep = dbPassword.equals(password);
	 	    }
	 	
	 	    if(isAuthenticatedRep) {
	 	        // Redirect to home.jsp if login is successful
	 	        response.sendRedirect("adminHome.jsp");
	 	    }
	    	
	 	    else {
		       out.println("<script>showAlert('Invalid username or password.'); redirectToLogin();</script>");
	 	    }
	    	
	    }
	     
	        // Display alert message and redirect to login.jsp
	    }
    
    db.closeConnection(con);
} catch (Exception e) {
    out.print(e);
}
%>
</body>
</html>
