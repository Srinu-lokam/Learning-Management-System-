<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Assignments</title>
    <style>
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Body & Background */
        body {
            font-family: Arial, sans-serif;
            background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
            background-size: cover;
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }

        /* Container */
        .container {
            margin: 40px auto;
            max-width: 1250px;
            background: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        /* Headings */
        h2, h3 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* Form Layout */
        form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        form label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        form select,
        form input[type="text"],
        form input[type="date"],
        form input[type="file"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        /* Full-width for the assignment text field */
        form input[name="Assignment"] {
            grid-column: 1 / 3;
        }

        /* Upload button spanning full width */
        .upload-btn {
            grid-column: 1 / 3;
            justify-self: center;
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-info {
            background-color: #17a2b8;
            color: #fff;
        }
        .btn-info:hover {
            background-color: #117a8b;
        }
        .btn-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            vertical-align: middle;
        }
        th {
            background-color: #007bff;
            color: #fff;
        }
        /* Action buttons in table */
        .action-btns {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Manage Assignments</h2>

        <!-- Upload Assignment -->
        <h3>Upload Assignment</h3>
        <%
            // Retrieve instructor username from session
            String instructorUsername = (String) session.getAttribute("username");
            Connection conn = databaseConnetion.getConnetion();
            PreparedStatement ps = null;
            ResultSet rs = null;
        %>
        <form action="uploadassignments" method="post" enctype="multipart/form-data">
            <!-- Year -->
            <div>
                <label>Year:</label>
                <select name="year" required>
                    <%
                        ps = conn.prepareStatement(
                            "SELECT DISTINCT year FROM course " +
                            "WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        ps.setString(1, instructorUsername);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("year") %>">
                        <%= rs.getString("year") %> Year
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>

            <!-- Semester -->
            <div>
                <label>Semester:</label>
                <select name="semester" required>
                    <%
                        ps = conn.prepareStatement(
                            "SELECT DISTINCT semester FROM course " +
                            "WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        ps.setString(1, instructorUsername);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("semester") %>">
                        <%= rs.getString("semester") %> Semester
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>

            <!-- Course (Subject) -->
            <div>
                <label>Course:</label>
                <select name="courseName" required>
                    <%
                        ps = conn.prepareStatement(
                            "SELECT DISTINCT subject FROM instructor_subjects WHERE instructor_username = ?"
                        );
                        ps.setString(1, instructorUsername);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("subject") %>">
                        <%= rs.getString("subject") %>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>

            <!-- Assignment Title (Full width) -->
            <div>
                <label>Assignment Title:</label>
                <input type="text" name="Assignment" placeholder="Assignment Title" required>
            </div>

            <!-- Due Date -->
            <div>
                <label>Due Date:</label>
                <input type="date" name="duedate" required>
            </div>

            <!-- Regulation -->
            <div>
                <label>Regulation:</label>
                <select name="regg" required>
                    <%
                        ps = conn.prepareStatement(
                            "SELECT DISTINCT regulation FROM course " +
                            "WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        ps.setString(1, instructorUsername);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("regulation") %>">
                        <%= rs.getString("regulation") %>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>

            <!-- Upload PDF -->
            <div>
                <label>Upload PDF:</label>
                <input type="file" name="pdf" accept="application/pdf" required>
            </div>

            <!-- Upload Button -->
            <div class="upload-btn">
                <button type="submit" class="btn btn-primary">Upload</button>
            </div>
        </form><br>

        <hr>

        <!-- View Assignments -->
        <h3>View Assignments</h3>
        <%
            // Query all assignments (no filter)
            String query = "SELECT * FROM assignments";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
        %>
        <table>
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Title</th>
                    <th>Course</th>
                    <th>Year</th>
                    <th>Semester</th>
                    <th>Regulation</th>
                    <th>Due Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("aid") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("sub") %></td>
                    <td><%= rs.getString("yearr") %></td>
                    <td><%= rs.getString("sem") %></td>
                    <td><%= rs.getString("reg") %></td>
                    <td><%= rs.getString("duedate") %></td>
                    <td>
                        <div class="action-btns">
                            <button class="btn btn-info" onclick="viewAss('<%= rs.getString("afile") %>')">View</button>
                            <button class="btn btn-danger" onclick="deleteAss('<%= rs.getString("aid") %>')">Delete</button>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        function viewAss(afile) {
            window.location.href = "viewass?afile=" + afile;
        }

        function deleteAss(aid) {
            if (confirm("Are you sure you want to delete this assignment?")) {
                window.location.href = "deleteass?aid=" + aid;
            }
        }
    </script>
</body>
</html>
