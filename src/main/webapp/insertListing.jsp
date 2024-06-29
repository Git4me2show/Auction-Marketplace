<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
try {
    //Get the database connection
    ApplicationDB db = new ApplicationDB();  
    Connection con = db.getConnection();

    //Get parameters from the HTML form at the AuctionPost.jsp
    String itemName = request.getParameter("itemName");
    String desc = request.getParameter("desc");
    float minPrice = Float.parseFloat(request.getParameter("minPrice"));
    float startPrice = Float.parseFloat(request.getParameter("price"));
    String closeDate = request.getParameter("closeDate") + " 00:00:00";
    
    // Retrieve the logged-in user's username from session or authentication mechanism
    String loggedInUsername = (String) session.getAttribute("username"); // Replace "username" with your session attribute name

    String category = request.getParameter("category");
    String subcategory = request.getParameter("subCategory");

		
		// SQL to find the highest current List_ID
		String getMaxIdSql = "SELECT MAX(List_ID) AS max_id FROM Listed_Item";
		PreparedStatement getMaxIdStmt = con.prepareStatement(getMaxIdSql);
		ResultSet rs = getMaxIdStmt.executeQuery();

		// Initialize listID
		int listID = 1; 
		if (rs.next()) {
			listID = rs.getInt("max_id") + 1;
		}

    //Make an insert statement for the Listed_Item table:
    //Make an insert statement for the Listed_Item table:
String insert = "INSERT INTO Listed_Item VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, null)";

PreparedStatement ps = con.prepareStatement(insert);


    ps.setInt(1, listID); //List Id
    ps.setFloat(2, 0); //Current highest bid
    ps.setString(3, itemName); //Item Name
    ps.setFloat(4, minPrice); //Min Price
    ps.setFloat(5, 0); //min next bid
    ps.setFloat(6, startPrice); //start price
    ps.setString(7, desc); //item description
    ps.setString(8, closeDate);//close date/time
    ps.setString(9, loggedInUsername); //Logged-in username as Seller email
    ps.setString(10, category); //category
    ps.setString(11, subcategory); //Subcategory

    ps.executeUpdate();
    con.close();
		out.println("<script>alert('Listing Posted'); window.location='home.jsp';</script>");
	
		ps.executeUpdate();
}
		
	 catch (Exception ex) {
		out.print(ex);
		out.print("Insert failed :()");
	}

%>
</body>
</html>
