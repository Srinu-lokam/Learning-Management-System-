<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Student Accounts | LMS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    /* General Styles */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Arial', sans-serif;
      background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
      background-size: cover;
      color: #333;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
    }
    .container {
      max-width: 1200px;
      background: rgba(255, 255, 255, 0.9);
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
      text-align: center;
    }
    h2 {
      color: #004085;
      font-size: 1.8rem;
      margin-bottom: 15px;
      border-bottom: 3px solid #004085;
      padding-bottom: 10px;
    }
    .button-container {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    .btn {
      padding: 10px 18px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      color: white;
      font-size: 1rem;
      transition: 0.3s ease-in-out;
    }
    .add-btn {
      background: #28a745;
    }
    .add-btn:hover {
      background: #218838;
    }
    .edit-btn {
      background: #ffc107;
    }
    .edit-btn:hover {
      background: #e0a800;
    }
    .delete-btn {
      background: #dc3545;
    }
    .delete-btn:hover {
      background: #c82333;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 15px;
      table-layout: fixed;
    }
    thead {
      background: #004085;
      color: white;
    }
    th, td {
      padding: 12px;
      text-align: center;
      border: 1px solid #ddd;
      word-wrap: break-word;
    }
    tbody tr:nth-child(even) {
      background: #f2f2f2;
    }
    tbody tr:hover {
      background: #d6e9f8;
    }
    td:last-child {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px;
    }
    td:last-child button {
      flex: none;
    }
    th:last-child, td:last-child {
      width: 180px;
    }
  </style>
</head>
<body>
    <div class="container">
        <h2>Manage Student Accounts</h2>
        <div class="button-container">
            <button class="btn add-btn" onclick="addAccount()">Add New Account</button>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Section</th>
                    <th>Year</th>
                    <th>Semester</th>
                    <th>Regulation</th>
                    <th>Email</th>
                    <th>Mobile</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    Connection conn = databaseConnetion.getConnetion();
                    PreparedStatement ps = conn.prepareStatement("SELECT fullname, username, section, year, semester, regulation, email, mobile FROM student");
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String fullname = rs.getString("fullname");
                        String username = rs.getString("username");
                        String section = rs.getString("section");
                        String year = rs.getString("year");
                        String semester = rs.getString("semester");
                        String regulation = rs.getString("regulation");
                        String email = rs.getString("email");
                        String mobile = rs.getString("mobile");

                        out.println("<tr>");
                        out.println("<td>" + fullname + "</td>");
                        out.println("<td>" + username + "</td>");
                        out.println("<td>" + section + "</td>");
                        out.println("<td>" + year + "</td>");
                        out.println("<td>" + semester + "</td>");
                        out.println("<td>" + regulation + "</td>");
                        out.println("<td>" + email + "</td>");
                        out.println("<td>" + mobile + "</td>");
                        out.println("<td>");
                        out.println("<div class='btn-group'>");
                        out.println("<button class='btn edit-btn' onclick=\"editAccount('" + username + "')\">Edit</button>");
                        out.println("<button class='btn delete-btn' onclick=\"deleteAccount('" + username + "')\">Delete</button>");
                        out.println("</div>");
                        out.println("</td>");
                        out.println("</tr>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>
    </div>

    <script>
        function addAccount() {
            window.location.href = "studentcreateacc.html";
        }

        function editAccount(username) {
            window.location.href = "studentupdateacc.jsp?username=" + username;
        }

        function deleteAccount(username) {
            if (confirm("Are you sure you want to delete this account?")) {
                window.location.href = "studentdeleteacc?username=" + username;
            }
        }
    </script>
</body>
</html>
