<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Previous Question Papers</title>
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
        }
        .btn-download {
            background-color: #27ae60;
            color: white;
        }
    </style>
</head>
<body>

    <h2>Previous Question Papers</h2>

    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Search by subject..." onkeyup="filterTable()">
    </div>

    <table id="papersTable">
        <tr>
            <th>Subject</th>
            <th>Paper</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Connection conn = databaseConnetion.getConnetion();
                PreparedStatement stmt = conn.prepareStatement(
                    "SELECT subject, paper_file FROM previous_papers"
                );
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String subject = rs.getString("subject");
                    String paperFile = rs.getString("paper_file");
        %>
        <tr>
            <td><%= subject %></td>
            <td><%= paperFile %></td>
            <td>
                <a href="uploads/<%= paperFile %>" target="_blank" class="btn btn-view">View</a>
                <a href="uploads/<%= paperFile %>" download class="btn btn-download">Download</a>
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
            let rows = document.querySelectorAll("#papersTable tr:not(:first-child)");

            rows.forEach(row => {
                let subject = row.cells[0].innerText.toLowerCase();
                row.style.display = subject.includes(input) ? "" : "none";
            });
        }
    </script>

</body>
</html>
