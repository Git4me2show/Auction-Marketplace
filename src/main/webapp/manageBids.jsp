<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Bids</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .bid-list, .form-container {
            margin-top: 20px;
        }
        .bid-list table {
            width: 100%;
            border-collapse: collapse;
        }
        .bid-list table, .bid-list th, .bid-list td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
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
    <script>
        function refreshPage() {
            window.location.reload();
        }
    </script>
</head>
<body>
<div class="navbar">
    
    <a href="repHome.jsp">Home</a>
  
   
</div>
    <h2>Manage Bids</h2>
    
    <div class="bid-list">
        <h3>List of Bids</h3>
        <table>
            <tr>
                <th>Bid ID</th>
                <th>Bid Amount</th>
                <th>Date Time</th>
                <th>Item ID</th>
                <th>User Email</th>
                <th>Action</th>
            </tr>
            <%
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM bid");
                int itemID = 0;

                while (rs.next()) {
                    int bidID = rs.getInt("Bid_ID");
                    itemID = rs.getInt("itemID");
                    double bidAmount = rs.getDouble("Bid_Amount");
                    Timestamp dateTime = rs.getTimestamp("date_time");
                    itemID = rs.getInt("ItemID");
                    String userEmail = rs.getString("UserEmail");
            %>
            <tr>
                <td><%= bidID %></td>
                <td><%= bidAmount %></td>
                <td><%= dateTime %></td>
                <td><%= itemID %></td>
                <td><%= userEmail %></td>
                <td>
                    <form method="POST" action="manageBids.jsp" style="display:inline;">
                        <input type="hidden" name="delete_bid_id" value="<%= bidID %>">
                        <input type="hidden" name="item_ID" value="<%= itemID %>">
                        <button type="submit" name="action" value="delete">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                }
                rs.close();
                stmt.close();
                con.close();
            %>
        </table>
    </div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");
            int bidID = Integer.parseInt(request.getParameter("delete_bid_id"));
            db = new ApplicationDB();
            con = db.getConnection();
            PreparedStatement pstmt = null;
            int max = 0;
            
            try {
                if ("delete".equals(action)) {
                    String deleteSQL = "DELETE FROM bid WHERE Bid_ID = ?";
                    pstmt = con.prepareStatement(deleteSQL);
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("delete_bid_id")));
                    int rowsDeleted = pstmt.executeUpdate();
                    
                    
                    String findTopBid = "select max(bid_amount) as max from bid where itemID = ?";
                    pstmt = con.prepareStatement(findTopBid);
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("item_ID")));
					ResultSet rs2 = pstmt.executeQuery();
					while (rs2.next()) {
						max = rs2.getInt("max");
					}
					String updateTopBid = "update listed_item set current_highest_bid = ? where list_id = ?";
					pstmt = con.prepareStatement(updateTopBid);
					pstmt.setInt(1, max);
					pstmt.setInt(2, Integer.parseInt(request.getParameter("item_ID")));
					pstmt.executeUpdate();
                    if (rowsDeleted > 0) {
                        out.println("Bid deleted successfully.");
                        out.println("<script>setTimeout(refreshPage, 1000);</script>");
                    } else {
                        out.println("");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("An error occurred: " + e.getMessage());
            } finally {
                try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
                try { if (con != null) con.close(); } catch (SQLException ignored) {}
            }
        }
    %>

</body>
</html>
