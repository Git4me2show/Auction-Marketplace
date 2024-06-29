<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.io.*,java.util.*,com.cs336.pkg.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div class="navbar">
        <a onclick="location.href='home.jsp'">Home</a>
    </div>
<%
    String userEmail = request.getParameter("email");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Check if the user email is not null or empty
    if (userEmail != null && !userEmail.trim().isEmpty()) {
        try {
            // Initialize the database connection using the ApplicationDB class
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();

            // Updated query to fetch all details from Listed_Item and determine the role
            String sql = "SELECT distinct Listed_Item.*, " +
                         "CASE WHEN Listed_Item.SellerEmail = ? THEN 'Seller' ELSE 'Bidder' END AS Role " +
                         "FROM Listed_Item " +
                         "LEFT JOIN Bid ON Listed_Item.List_Id = Bid.ItemID AND Bid.UserEmail = ? " +
                         "WHERE Listed_Item.SellerEmail = ? OR Bid.UserEmail = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userEmail);
            pstmt.setString(2, userEmail);
            pstmt.setString(3, userEmail);
            pstmt.setString(4, userEmail);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                int listID = rs.getInt("List_ID"); // Get the listing ID
        %>
                <!-- Wrap the listing details in an anchor tag -->
                <a href="Bid.jsp?itemID=<%= listID %>" style="text-decoration: none; color: black;">
                    <div class="listing-card">
                        <h3><%= rs.getString("Item_Name") %></h3>
                        <p>Description: <%= rs.getString("Item_description") %></p>
                        <p>Subcategory: <%= rs.getString("Subcategory") %></p>
                        <p>Subcategory Subtype: <%= rs.getString("Subcategory_Subtype") %></p>
                        <p>Initial Price <%= rs.getString("Initial_Price") %></p>
                        <p>Current Highest Bid: <%= rs.getFloat("Current_Highest_Bid") %></p>
                        <p>Role: <%= rs.getString("Role") %></p>
                       
                        <p>Close Date Time: <%= rs.getTimestamp("Close_Date_Time") %></p>
                        <!-- You can also add a 'Bid Now' button here if you want -->
                        <button type="button">Bid Now</button>
                        <a href="AuctionHistPull.jsp?itemID=<%= listID %>" style="text-decoration: none; color: black;">
                        <button type="button">See History</button>
                        </a>
       					
                    </div>
                </a>
        <%
            }
        } catch (Exception e) {
            out.println("<p>Error encountered: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException se) { se.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) { se.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException se) { se.printStackTrace(); }
        }
    } else {
        out.println("<p>Error: Email parameter is missing.</p>");
    }
%>
</body>
</html>