<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Place Your Bid</title>
</head>
<body>
    <%
        try {
            // Get the database connection from ApplicationDB
            ApplicationDB db = new ApplicationDB();  
            Connection con = db.getConnection();

            // Get the item ID from the query string
            int itemID = Integer.parseInt(request.getParameter("itemID"));
            session.setAttribute("itemID", itemID);
            // Fetch item details
            String query = "SELECT * FROM Listed_Item WHERE List_ID = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, itemID);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()) {
                String itemName = rs.getString("Item_Name");
                float currentPrice = rs.getFloat("Current_Highest_Bid");
                %>
                <h2>Bid on Item: <%= itemName %></h2>
                <form action="submitBid.jsp" method="post">
                    <input type="hidden" name="itemID" value="<%= itemID %>">
                    <p>Current Bid: $<%= currentPrice %></p>
                    <p>Your Bid: $<input type="text" name="bidAmount" required></p>
                    <button type="submit">Place Bid</button>
                </form>
                <h2>Autobid</h2>
                <form action="submitAutoBid.jsp" method="post">
                    <input type="hidden" name="itemID" value="<%= itemID %>">
                    <p>Current Bid: $<%= currentPrice %></p>
                    <p>Increment(how much to bet above): $<input type="text" name="increment" required></p>
                    <p>Your Limit: $<input type="text" name="limit" required></p>
                    <button type="submit">Place Auto Bid</button>
                </form>
                
                <%
            } else {
                out.println("<p>Item not found.</p>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    %>
</body>
</html>