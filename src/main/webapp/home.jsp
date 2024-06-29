<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.sql.*, java.util.Date" %>


<%
    // Preventing page caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Function to fetch categories and subcategories from the database
    ArrayList<String> categories = new ArrayList<String>();
    HashMap<String, ArrayList<String>> subcategoriesMap = new HashMap<String, ArrayList<String>>();
    try {
        ApplicationDB dba = new ApplicationDB();    
        Connection cona = dba.getConnection(); 
        Statement stmt = cona.createStatement();
        ResultSet rsCategories = stmt.executeQuery("SELECT DISTINCT SubCategory FROM Category");
        while (rsCategories.next()) {
            String category = rsCategories.getString("SubCategory");
            categories.add(category);

            // Fetch subcategories for each category
            ArrayList<String> subcategories = new ArrayList<String>();
            ResultSet rsSubcategories = stmt.executeQuery("SELECT Field1, Field2, Field3 FROM Category WHERE SubCategory = '" + category + "'");
            while (rsSubcategories.next()) {
                subcategories.add(rsSubcategories.getString("Field1"));
                subcategories.add(rsSubcategories.getString("Field2"));
                subcategories.add(rsSubcategories.getString("Field3"));
            }
            subcategoriesMap.put(category, subcategories);
        }
        cona.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home Page</title>
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
            width: 20%;
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
        .delete-btn {
        float: right;
        background-color: #ff6347;
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

    .delete-btn:hover {
        background-color: #e53e30; 
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
    </style>
</head>
<body>

<div class="navbar">
    <a onclick="location.href='home.jsp'">Home</a>
    <a onclick="location.href='UpdateAuctionPost.jsp'">Add a new Listing</a>
    <a onclick="location.href='myListing.jsp'">My Listing</a>
    <a onclick="location.href='viewquestions.jsp'">Question Page</a>
    <a onclick="location.href='setalert.jsp'">Set Alert</a>
    <a onclick="location.href='UserHistoryPage.jsp'">User History Search</a>
    <a onclick="location.href='AuctionHistoryPage.jsp'">Bid History Search</a>
    <button class="delete-btn" onclick="deleteAccount()">Delete Account</button>
    <button class="logout-btn" onclick="logout()">Logout</button>
</div>

<h2>Welcome to the Home Page</h2>
<h2>Hello, <%out.print((String)session.getAttribute("username") + ".");%> </h2>
<% 
try {
    ApplicationDB dba = new ApplicationDB();    
    Connection cona = dba.getConnection(); 
    ResultSet rsa = null;
    String alerts = "select itemName from alert where userEmail = ? and itemName in (select item_name from listed_item where close_date_time > current_timestamp())";
    PreparedStatement ps = cona.prepareStatement(alerts);
    ps.setString(1, (String)session.getAttribute("username"));
    rsa = ps.executeQuery();
    String alert = "Alert! item(s) you want currently on sale: ";
    while(rsa.next()) {
        alert += rsa.getString("itemName") + ", ";
    }
    if(alert.equals("Alert! item(s) you want currently on sale: ") == false) {
        out.println(alert.substring(0, alert.length() - 2));
    }
    
}
catch (Exception e) {
	out.println(e);
}%>
<br>
<% 
try {
	ApplicationDB dba = new ApplicationDB();    
	Connection cona = dba.getConnection(); 
	ResultSet rsa = null;
	String alerts = "select item_name from listed_item where winnerEmail = ? and close_date_time <= current_timestamp()";
	PreparedStatement ps = cona.prepareStatement(alerts);
	ps.setString(1, (String)session.getAttribute("username"));
	rsa = ps.executeQuery();
	String alert = "Alert! Auctions you've won: ";
	while(rsa.next()) {
		alert += rsa.getString("item_name") + ", ";
	}
	if(alert.equals( "Alert! Auctions you've won: ") == false) {
		out.println(alert.substring(0, alert.length() - 2));
	}
	
}
catch (Exception e) {
	out.println(e);
}%>
<br>
<% 
try {
	ApplicationDB dba = new ApplicationDB();    
	Connection cona = dba.getConnection(); 
	ResultSet rsa = null;
	String first ="select * from bid join listed_item on bid.itemID = listed_item.list_id where userEmail = ? and close_date_time > current_timestamp()";
	PreparedStatement ps = cona.prepareStatement(first);
	ps.setString(1, (String)session.getAttribute("username"));
	rsa = ps.executeQuery();
	String alert = "Alert! You've been outbid for the following items: ";;
	while(rsa.next()) {
		int itemID = rsa.getInt("itemID");
		float price = rsa.getFloat("bid_amount");
		String itemName = rsa.getString("item_name");
		ResultSet rsb = null;
		String second  = "select max(bid_amount) as max from bid where itemID = ? group by itemID";
		PreparedStatement ps2 = cona.prepareStatement(second);
		ps2.setInt(1, itemID);
		rsb = ps2.executeQuery();
		while(rsb.next()) {
			int max = rsb.getInt("max");
			if(price != max) {
				alert += itemName + ", ";
			}
		}
		
		
	}
	if(alert.equals("Alert! You've been outbid for the following items: ") == false) {
		out.println(alert.substring(0, alert.length() - 2));
	}
	
}
catch (Exception e) {
	out.println(e);
}%>
<br>
<% 
try {
	ApplicationDB dba = new ApplicationDB();    
	Connection cona = dba.getConnection(); 
	ResultSet rsa = null;
	String first = "select itemID, item_name, max(Highest_Bid) as max from auto_bid join listed_item on auto_bid.itemID  = listed_item.List_ID join place using(auto_bid_id) where userEmail = ? and close_date_time > current_timestamp() group by itemID, item_name";
	PreparedStatement ps = cona.prepareStatement(first);
	ps.setString(1, (String)session.getAttribute("username"));
	rsa = ps.executeQuery();
	String alert = "Alert! Your autobids for the following items have hit their limit: ";
	while(rsa.next()) {
		int itemID = rsa.getInt("itemID");
		float max = rsa.getFloat("max");
		String itemName = rsa.getString("item_name");
		ResultSet rsb = null;
		String second  = "select distinct itemID from bid where bid_amount > ? and itemID = ?";
		PreparedStatement ps2 = cona.prepareStatement(second);
		ps2.setFloat(1, max);
		ps2.setInt(2, itemID);
		rsb = ps2.executeQuery();
		while(rsb.next()) {
			int item = rsb.getInt("itemID");
			if(item == itemID) {
				alert += itemName + ", ";
			}
		}
		
		
	}
	if(alert.equals("Alert! Your autobids for the following items have hit their limit: ") == false) {
		out.println(alert.substring(0, alert.length() - 2));
	}
	
}
catch (Exception e) {
	out.println(e);
}%>



<!-- Add the category and subcategory selection -->
<div>
    <form method="GET" action="">
        <select name="category_sort" id="category_sort" onchange="populateSubcategories()">
            <option value="">Sort by Category</option>
            <option value="Electronics">Electronics</option>
            <option value="Laptop">Laptop</option>
            <option value="Mobile">Mobile</option>
            <option value="Television">Television</option>
        </select>
        
        <select name="subcategory_sort" id="subcategory_sort">
            <option value="">All</option>
        </select>
        
        <button type="submit">Search by Category & Subcategory</button>
    </form>
</div>

<!-- Add the search bar for search query and field selection -->
<div>
    <form method="GET" action="">
        <input type="text" name="search_query" placeholder="Search...">
        <select name="search_field">
            <option value="Item_Name">Item Name</option>
            <option value="Item_description">Description</option>
            <option value="Subcategory">Subcategory</option>
            <option value="Subcategory_Subtype">Subcategory Subtype</option>
            <!-- Add other fields as options if needed -->
        </select>
        
        <button type="submit">Search by Query & Field</button>
    </form>
</div>

<!-- Add Clear Filters button -->
<button onclick="clearFilters()">Clear Filters</button>

<!-- Add the sort by product name button -->
<button onclick="sortByProductName()">Sort by Product Name</button>

<!-- Add the sort by initial price button -->
<button onclick="sortByInitialPrice()">Sort by Initial Price</button>

<!-- Add the sort by current highest bid button -->
<button onclick="sortByCurrentHighestBid()">Sort by Current Highest Bid</button>

<!-- Add the sort by close date time button -->
<button onclick="sortByCloseDateTime()">Sort by Close Date Time</button>

<div class="listing-container">
    <% 
    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection(); 
    ResultSet rs = null;
    try {
        String searchQuery = request.getParameter("search_query");
        String searchField = request.getParameter("search_field");
        String categorySort = request.getParameter("category_sort");
        String subcategorySort = request.getParameter("subcategory_sort");
        String sortBy = request.getParameter("sort");

        String sql;
        PreparedStatement pstmt;

        if (sortBy != null && sortBy.equals("product_name")) {
            sql = "SELECT * FROM Listed_Item ORDER BY Item_Name";
            pstmt = con.prepareStatement(sql);
        } else if (sortBy != null && sortBy.equals("initial_price")) {
            sql = "SELECT * FROM Listed_Item ORDER BY Initial_Price";
            pstmt = con.prepareStatement(sql);
        } else if (sortBy != null && sortBy.equals("current_highest_bid")) {
            sql = "SELECT * FROM Listed_Item ORDER BY Current_Highest_Bid";
            pstmt = con.prepareStatement(sql);
        } else if (sortBy != null && sortBy.equals("close_date_time")) {
            sql = "SELECT * FROM Listed_Item ORDER BY Close_Date_Time";
            pstmt = con.prepareStatement(sql);
        } else if (searchQuery != null && searchField != null) {
            // Construct SQL query based on selected field
            sql = "SELECT * FROM Listed_Item WHERE " + searchField + " LIKE ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + searchQuery + "%");
        } else if (categorySort != null && !categorySort.isEmpty()) {
            // If category selected, show items in that category
            if (subcategorySort != null && !subcategorySort.equals("All")) {
            // Category and specific subcategory selected
            sql = "SELECT * FROM Listed_Item WHERE Subcategory = ? AND Subcategory_Subtype = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, categorySort);
            pstmt.setString(2, subcategorySort);
	        } else {
	            // Only category selected or category with 'All' subcategories
	            sql = "SELECT * FROM Listed_Item WHERE Subcategory = ?";
	            pstmt = con.prepareStatement(sql);
	            pstmt.setString(1, categorySort);
	        }
        } else {
            sql = "SELECT * FROM Listed_Item";
            pstmt = con.prepareStatement(sql);
        }

        rs = pstmt.executeQuery();

        while (rs.next()) {
            int listID = rs.getInt("List_ID"); // Get the listing ID
            Timestamp closetime = rs.getTimestamp("Close_Date_Time");
    %>
            <!-- Wrap the listing details in an anchor tag -->
            <a href="Bid.jsp?itemID=<%= listID %>" style="text-decoration: none; color: black;">
                <div class="listing-card">
                    <h3><%= rs.getString("Item_Name") %></h3>
                    <p>Product ID: <%= rs.getString("List_ID") %></p>
                    <p>Description: <%= rs.getString("Item_description") %></p>
                    <p>Subcategory: <%= rs.getString("Subcategory") %></p>
                    <p>Subcategory Subtype: <%= rs.getString("Subcategory_Subtype") %></p>
                    <p>Initial Price <%= rs.getString("Initial_Price") %></p>
                    <p>Current Highest Bid: <%= rs.getFloat("Current_Highest_Bid") %></p>
                    <p>Close Date Time: <%= closetime %></p>
                    <p>Current Winner:   
                    <% String winner = rs.getString("winnerEmail");
                    Timestamp currentTime = new Timestamp(new Date().getTime());

                    if(currentTime.before(closetime)){
                    	out.println("Undetermined");
                    }
                    
                    else if( winner != null) {
                    		out.println(winner);
                    		
                    	} else out.println("None");
                    		%>
                    	
                    
                    
                    
                     </p>

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
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
</div>

<script>
function logout() {
    sessionStorage.setItem("logout", "true");
    location.href = "login.jsp";
}

function deleteAccount() {
    if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
        location.href = "deleteAccount.jsp";
    }
}


		function populateSubcategories() {
		    var categorySelect = document.getElementById("category_sort");
		    var subcategorySelect = document.getElementById("subcategory_sort");
		    var selectedCategory = categorySelect.options[categorySelect.selectedIndex].value;
		    subcategorySelect.innerHTML = ''; // Clear existing options
		        
        var options;
        switch(selectedCategory) {
            case 'Electronics':
                options = ['All', 'Speaker', 'Mouse', 'Other'];
                break;
            case 'Laptop':
                options = ['All', 'Dell', 'Lenovo', 'Other'];
                break;
            case 'Mobile':
                options = ['All', 'Samsung', 'Apple', 'Other'];
                break;
            case 'Television':
                options = ['All', 'Samsung', 'Sony', 'Other'];
                break;
            default:
                options = ['All']; // Provide 'All' option if no category or invalid category is selected
        }
        
        for (var i = 0; i < options.length; i++) {
            var option = document.createElement("option");
            option.text = options[i];
            option.value = options[i];
            subcategorySelect.add(option);
        }

        // Select 'All' by default
        subcategorySelect.value = 'All';
    }
    
    function clearFilters() {
        document.getElementById("category_sort").selectedIndex = 0;
        document.getElementById("subcategory_sort").innerHTML = '';
        document.getElementById("subcategory_sort").append(new Option("All", "All")); // Set default value for subcategory
        document.getElementById("search_query").value = '';
        document.getElementById("search_field").selectedIndex = 0;
    }

    function sortByProductName() {
        // Redirect to the same page with a parameter indicating sorting by product name
        window.location.href = "home.jsp?sort=product_name";
    }

    function sortByInitialPrice() {
        // Redirect to the same page with a parameter indicating sorting by initial price
        window.location.href = "home.jsp?sort=initial_price";
    }

    function sortByCurrentHighestBid() {
        // Redirect to the same page with a parameter indicating sorting by current highest bid
        window.location.href = "home.jsp?sort=current_highest_bid";
    }

    function sortByCloseDateTime() {
        // Redirect to the same page with a parameter indicating sorting by close date time
        window.location.href = "home.jsp?sort=close_date_time";
    }
</script>

</body>
</html>
