<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Courses</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7fc;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        .search-container {
            text-align: center;
            margin-bottom: 20px;
        }
        #searchInput {
            width: 50%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #34495e;
            color: white;
        }
        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-view {
            background-color: #3498db;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
    </style>
</head>
<body>

    <h2>Courses</h2>

    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Search by subject..." onkeyup="filterTable()">
    </div>

    <table id="coursesTable">
        <tr>
            <th>Year</th>
            <th>Semester</th>
            <th>Subject</th>
            <th>Regulation</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Connection conn = databaseConnetion.getConnetion();
                PreparedStatement stmt = conn.prepareStatement("SELECT year, semester, subject, file, regulation FROM course");
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    String year = rs.getString("year");
                    String semester = rs.getString("semester");
                    String subject = rs.getString("subject");
                    String file = rs.getString("file");
                    String regulation = rs.getString("regulation");
        %>
        <tr>
            <td><%= year %></td>
            <td><%= semester %></td>
            <td><%= subject %></td>
            <td><%= regulation %></td>
            <td>
                <a href="viewcourse?file=<%= file %>" class="btn btn-view">View</a>
            </td>
        </tr>
        <%
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>

    <script>
        function filterTable() {
            let input = document.getElementById("searchInput").value.toLowerCase();
            let rows = document.querySelectorAll("#coursesTable tr:not(:first-child)");

            rows.forEach(row => {
                let subject = row.cells[2].innerText.toLowerCase();
                row.style.display = subject.includes(input) ? "" : "none";
            });
        }
    </script>

</body>
</html>
