<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Admin Sales Report</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select sum(Current_Highest_Bid) as total from listed_item where close_date_time < current_timestamp() and current_highest_bid >= Min_Price;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			Statement stmt2 = con.createStatement();
			String str2 = "select subcategory, sum(Current_Highest_Bid) as earnings from listed_item where Close_Date_Time < current_timestamp() and current_highest_bid >= min_price group by Subcategory";
			ResultSet result2 = stmt2.executeQuery(str2);
			
			Statement stmt3 = con.createStatement();
			String str3 = "select sellerEmail, sum(Current_Highest_Bid) as rev from listed_item where Close_Date_Time < current_timestamp() and current_highest_bid >= min_price group by sellerEmail";
			ResultSet result3 = stmt3.executeQuery(str3);
			
			Statement stmt6 = con.createStatement();
			String str6 = "select item_name, sum(Current_Highest_Bid) as earnings from listed_item where Close_Date_Time < current_timestamp() and current_highest_bid >= min_price group by item_name";
			ResultSet result6 = stmt6.executeQuery(str6);
			
			Statement stmt4 = con.createStatement();
			String str4 = "select winnerEmail, count(*) as items_bought from listed_item where Close_Date_Time < current_timestamp() and Current_Highest_Bid >= Min_Price group by winnerEmail";
			ResultSet result4 = stmt4.executeQuery(str4);
			
			Statement stmt5 = con.createStatement();
			String str5 = "select item_name, count(*) as items_bought from listed_item where Close_Date_Time < current_timestamp() and Current_Highest_Bid >= Min_Price group by item_name";
			ResultSet result5 = stmt5.executeQuery(str5);

		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>Total Sales Earnings: $<%= result.getString("total") %></td>
				</tr>
			 <% } %>
			
			<tr>
				<td>Earnings per Item Type:<td>
			<tr>
			
			<% 
			while (result2.next()) { %>
			<tr>
				<td><%= result2.getString("subcategory") %></td>
				<td>
					<%= result2.getString("earnings") %>
				</td>
			</tr>
			

		<% } %>
		
		<tr>
				<td>Earnings per Item:<td>
			<tr>
			
			<% 
			while (result6.next()) { %>
			<tr>
				<td><%= result6.getString("item_name") %></td>
				<td>
					<%= result6.getString("earnings") %>
				</td>
			</tr>
			

		<% } %>
			
			<tr>
				<td>Earnings per user:<td>
			<tr>
			 
		<%	while (result3.next()) { %>
			<tr>
				<td><%= result3.getString("sellerEmail") %></td>
				<td>
					<%= result3.getString("rev") %>
				</td>
			</tr>
			

					

			<% } %>
			
			<tr>
				<td>Users who've bought the most:<td>
			<tr>
			
			<% while (result4.next()) { %>
			<tr>
				<td><%= result4.getString("winnerEmail") %></td>
				<td>
					<%= result4.getString("items_bought") %> items
				</td>
			</tr>
			
			<% } %>
			
			<tr>
				<td>Best selling items:<td>
			<tr>
			
			<% while (result5.next()) { %>
			<tr>
				<td><%= result5.getString("item_name") %></td>
				<td>
					<%= result5.getString("items_bought") %> items
				</td>
			</tr>
			
			<% } 
			
			
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>