<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.*" %>
<script>
function showAlert(message) {
    alert(message);
}
function redirectToHome() {
    window.location.href = "home.jsp";
}
</script>
<%

    int itemID = (int)session.getAttribute("itemID");
    float bidAmount = Float.parseFloat(request.getParameter("bidAmount"));
    String userEmail = (String)session.getAttribute("username"); // Assume this is fetched from session or input
    Timestamp currentTime = new Timestamp(new Date().getTime());
    float minPrice = 0;
    Timestamp closeDateTime = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Start transaction

        // Get the current highest bid for the item
        String query = "SELECT Current_Highest_Bid, close_date_time, initial_price FROM Listed_Item WHERE List_ID = ?";
        ps = con.prepareStatement(query);
        ps.setInt(1, itemID);
        rs = ps.executeQuery();

        float currentHighestBid = 0;
        if (rs.next()) {
            currentHighestBid = rs.getFloat("Current_Highest_Bid");
            closeDateTime = rs.getTimestamp("close_date_time");
            minPrice = rs.getFloat("initial_price");
        }
		
        if (bidAmount > currentHighestBid && bidAmount >= minPrice && currentTime.before(closeDateTime)) {
        	String winner = userEmail;
        	
        	
        	String insertBid = "INSERT INTO Bid VALUES (null, ?, ?, ?, ?, null)";
            ps = con.prepareStatement(insertBid);
            ps.setFloat(1, bidAmount);
            ps.setTimestamp(2, currentTime);
            ps.setInt(3, itemID);
            ps.setString(4, userEmail);
            ps.executeUpdate();
        	//check for auto bids, update if necessary
        	String autoBidQuery = "select * from place join auto_bid using (auto_bid_id) where ItemID = ?";
        	ps = con.prepareStatement(autoBidQuery);
        	ps.setInt(1, itemID);
        	rs = ps.executeQuery();
        	
        	while  (rs.next()) {
        		float autoBidIncrement = rs.getFloat("Bid_Increment");
        		float cap = rs.getFloat("highest_bid");
    			float bidSum = autoBidIncrement + bidAmount;
        		if(bidSum <= cap) {
        		 winner = rs.getString("userEmail");
        		 bidAmount = bidSum;
        		}
        		
        		String bid = "insert into bid values(null, ?, ?, ?, ?, null)";
        		ps = con.prepareStatement(bid);
        		ps.setFloat(1, bidAmount);
        		ps.setTimestamp(2, currentTime);
        		ps.setInt(3,itemID);
        		ps.setString(4,userEmail);
        		
        	}
        	
            // Update the item's current highest bid
            String updateQuery = "UPDATE Listed_Item SET Current_Highest_Bid = ? WHERE List_ID = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setFloat(1, bidAmount);
            ps.setInt(2, itemID);
            ps.executeUpdate();

            // Insert the bid into Bid table
            
            
            
           String winnerQuery = "update listed_item set winnerEmail = ? where list_id = ?";
           PreparedStatement ws = con.prepareStatement(winnerQuery);
           ws.setString(1, winner);
           ws.setInt(2,itemID);
           ws.executeUpdate();
            
            
            

            
            

	        response.sendRedirect("home.jsp");
        } else {
        	if (currentTime.after(closeDateTime)) {
        	 out.println("<script>showAlert('This bid has closed.'); redirectToHome();</script>");
        	}
        	else out.println("<script>showAlert('Bid too low.'); redirectToHome();</script>");
 	 	    
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
%>
