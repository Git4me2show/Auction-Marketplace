<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.Date" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.*" %>

<%
    int itemID = Integer.parseInt(request.getParameter("itemID"));
    float bidAmount = Float.parseFloat(request.getParameter("bidAmount"));
    String userEmail = request.getParameter("userEmail"); // Assume this is fetched from session or input

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Start transaction
        con.setAutoCommit(false);

        // Get the current highest bid for the item
        String query = "SELECT Current_Highest_Bid FROM Listed_Item WHERE List_ID = ?";
        ps = con.prepareStatement(query);
        ps.setInt(1, itemID);
        rs = ps.executeQuery();

        float currentHighestBid = 0;
        if (rs.next()) {
            currentHighestBid = rs.getFloat("Current_Highest_Bid");
        }

        if (bidAmount > currentHighestBid) {
            // Update the item's current highest bid
            String updateQuery = "UPDATE Listed_Item SET Current_Highest_Bid = ? WHERE List_ID = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setFloat(1, bidAmount);
            ps.setInt(2, itemID);
            ps.executeUpdate();

            // Insert the bid into Bid table
            String insertBid = "INSERT INTO Bid (Bid_Amount, UserEmail, ItemID, date_time) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(insertBid);
            ps.setFloat(1, bidAmount);
            ps.setString(2, userEmail);
            ps.setInt(3, itemID);
            ps.setTimestamp(4, new Timestamp(new Date().getTime()));
            ps.executeUpdate();

            // Commit transaction
            con.commit();
        } else {
            // Handle the case where bid is not higher than current highest bid
            // Maybe redirect back with an error message
        }

    } catch (Exception e) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
        // Redirect or display error message
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Redirect back to the home page
    response.sendRedirect("home.jsp");
%>