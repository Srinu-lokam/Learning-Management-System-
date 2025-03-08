<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Previous Papers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
            background-size: cover;
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            margin: 40px auto;
            max-width: 1000px;
            background: rgba(240, 240, 240, 0.9);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
        }
        h2, h3 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 30px;
        }
        label {
            font-weight: bold;
            font-size: 16px;
        }
        select, input[type="text"], input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #aaa;
            border-radius: 6px;
            font-size: 16px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: background 0.3s ease-in-out;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #388E3C;
        }
        .btn-danger {
            background-color: #F44336;
            color: #fff;
        }
        .btn-danger:hover {
            background-color: #D32F2F;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 14px;
            text-align: left;
            vertical-align: middle;
            font-size: 16px;
        }
        th {
            background-color: #444;
            color: #fff;
        }
        td a {
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Manage Previous Papers</h2>

        <!-- Upload Previous Paper -->
        <h3>Upload Previous Paper</h3>
        <form action="uploadpreviouspapers" method="post" enctype="multipart/form-data">
            <label>Subject:</label>
            <input type="text" name="subject" required placeholder="Enter Subject Name">
            
            <label>Upload PDF:</label>
            <input type="file" name="pdf" accept="application/pdf" required>

            <button type="submit" class="btn btn-primary">Upload</button>
        </form>

        <hr>

        <!-- View Previous Papers -->
        <h3>View Previous Papers</h3>
        <%
            Connection conn = databaseConnetion.getConnetion();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM previous_papers");
            ResultSet rs = ps.executeQuery();
        %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Subject</th>
                    <th>File Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("pid") %></td>
                    <td><%= rs.getString("subject") %></td>
                    <td><%= rs.getString("paper_file") %></td>
                    <td>
                        <a href="viewpreviouspaper?file=<%= rs.getString("paper_file") %>" class="btn btn-primary">View</a>
                        <a href="deletepreviouspaper?pid=<%= rs.getString("pid") %>" class="btn btn-danger" onclick="return confirm('Are you sure?');">Delete</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
