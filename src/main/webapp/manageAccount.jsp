<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .form-container, .user-list {
            margin-top: 20px;
        }
        .form-container form, .user-list {
            display: inline-block;
            margin-right: 20px;
        }
        .form-container input, .form-container button {
            display: block;
            margin-top: 10px;
            padding: 10px;
            font-size: 16px;
        }
        .user-list table {
            width: 100%;
            border-collapse: collapse;
        }
        .user-list table, .user-list th, .user-list td {
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
</head>
<body>
<div class="navbar">
    
    <a href="repHome.jsp">Home</a>
  
   
</div>
    <h2>Manage Account</h2>
    
    <div class="user-list">
        <h3>List of Users</h3>
        <table>
            <tr>
                <th>Email</th>
                <th>Name</th>
                <th>User Type</th>
                <th>Action</th>
            </tr>
            <%
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM end_user");

                while (rs.next()) {
                    String email = rs.getString("Email");
            %>
            <tr>
                <td><%= email %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getString("User_Type") %></td>
                <td>
                    <form method="POST" action="manageAccount.jsp" style="display:inline;">
                        <input type="hidden" name="delete_email" value="<%= email %>">
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

    <div class="form-container">
        <!-- Form to reset password -->
        <form method="POST" action="manageAccount.jsp">
            <h3>Reset Password</h3>
            <input type="email" name="reset_email" placeholder="Enter email" required>
            <input type="password" name="new_password" placeholder="Enter new password" required>
            <button type="submit" name="action" value="reset">Reset Password</button>
        </form>
    </div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");
            String email = request.getParameter(action.equals("delete") ? "delete_email" : "reset_email");

            db = new ApplicationDB();
            con = db.getConnection();
            PreparedStatement pstmt = null;

            try {
                if ("delete".equals(action)) {
                    String deleteSQL = "DELETE FROM end_user WHERE Email = ?";
                    pstmt = con.prepareStatement(deleteSQL);
                    pstmt.setString(1, email);
                    int rowsDeleted = pstmt.executeUpdate();
                    out.println(rowsDeleted > 0 ? "Account deleted successfully." : "");
                } else if ("reset".equals(action)) {
                    String newPassword = request.getParameter("new_password");
                    String updateSQL = "UPDATE end_user SET Password = ? WHERE Email = ?";
                    pstmt = con.prepareStatement(updateSQL);
                    pstmt.setString(1, newPassword);
                    pstmt.setString(2, email);
                    int rowsUpdated = pstmt.executeUpdate();
                    out.println(rowsUpdated > 0 ? "Password reset successfully." : "Password reset failed.");
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
