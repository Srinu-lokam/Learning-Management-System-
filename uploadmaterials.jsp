<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Module Material</title>
    <style>
        /* Reset & Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
            background-size: cover;
            color: #444;
            padding: 30px;
        }
        h2, h3 {
            color: #007bff;
            margin-bottom: 20px;
            text-align: center;
        }
        /* Container Styling */
        .container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        /* Form Styling */
        form {
            margin-bottom: 40px;
        }
        form .form-group {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        form .form-group label {
            flex: 0 0 180px;
            font-weight: bold;
            color: #333;
        }
        form .form-group select,
        form .form-group input {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
        }
        .upload-btn {
            text-align: center;
            margin-top: 20px;
        }
        .upload-btn button {
            background-color: #007bff;
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .upload-btn button:hover {
            background-color: #0056b3;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin: 40px 0;
        }
        /* Table Styling */
        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table thead {
            background-color: #f2f2f2;
        }
        table th, table td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 0.95rem;
        }
        /* Button Group Styling */
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            color: #fff;
            transition: background-color 0.3s ease;
        }
        .btn-info { background-color: #17a2b8; }
        .btn-info:hover { background-color: #138496; }
        .btn-danger { background-color: #dc3545; }
        .btn-danger:hover { background-color: #c82333; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Upload Module Material</h2>
        <!-- Upload Form -->
        <form action="uploadmaterials" method="post" enctype="multipart/form-data">
            <%
                // Retrieve instructor username from session
                String instructorUsername = (String) session.getAttribute("username");
                if (instructorUsername == null) {
                    out.println("<script>alert('You must be logged in as an instructor.'); window.location.href='index.html';</script>");
                    return;
                }
                Connection conn = databaseConnetion.getConnetion();
            %>
            <div class="form-group">
                <label for="year">Year:</label>
                <select id="year" name="year" required>
                    <%
                        PreparedStatement psYear = conn.prepareStatement(
                            "SELECT DISTINCT year FROM course WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        psYear.setString(1, instructorUsername);
                        ResultSet rsYear = psYear.executeQuery();
                        while (rsYear.next()) {
                    %>
                    <option value="<%= rsYear.getString("year") %>"><%= rsYear.getString("year") %> Year</option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="semester">Semester:</label>
                <select id="semester" name="semester" required>
                    <%
                        PreparedStatement psSem = conn.prepareStatement(
                            "SELECT DISTINCT semester FROM course WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        psSem.setString(1, instructorUsername);
                        ResultSet rsSem = psSem.executeQuery();
                        while (rsSem.next()) {
                    %>
                    <option value="<%= rsSem.getString("semester") %>"><%= rsSem.getString("semester") %> Semester</option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="regg">Regulation:</label>
                <select id="regg" name="regg" required>
                    <%
                        PreparedStatement psReg = conn.prepareStatement(
                            "SELECT DISTINCT regulation FROM course WHERE subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        psReg.setString(1, instructorUsername);
                        ResultSet rsReg = psReg.executeQuery();
                        while (rsReg.next()) {
                    %>
                    <option value="<%= rsReg.getString("regulation") %>"><%= rsReg.getString("regulation") %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="courseName">Course (Subject):</label>
                <select id="courseName" name="courseName" required>
                    <%
                        PreparedStatement psSub = conn.prepareStatement(
                            "SELECT DISTINCT subject FROM instructor_subjects WHERE instructor_username = ?"
                        );
                        psSub.setString(1, instructorUsername);
                        ResultSet rsSub = psSub.executeQuery();
                        while (rsSub.next()) {
                    %>
                    <option value="<%= rsSub.getString("subject") %>"><%= rsSub.getString("subject") %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="module_number">Module Number:</label>
                <select id="module_number" name="module_number" required>
                    <option value="1">Module 1</option>
                    <option value="2">Module 2</option>
                    <option value="3">Module 3</option>
                    <option value="4">Module 4</option>
                    <option value="5">Module 5</option>
                </select>
            </div>
            <div class="form-group">
                <label for="pdf">Upload PDF:</label>
                <input type="file" id="pdf" name="pdf" accept="application/pdf" required>
            </div>
            <div class="upload-btn">
                <button type="submit">Upload Material</button>
            </div>
        </form>
        
        <hr>
        <h3>Uploaded Module Materials</h3>
        
        <!-- Table Displaying Modules -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Year</th>
                        <th>Semester</th>
                        <th>Regulation</th>
                        <th>Course</th>
                        <th>Module</th>
                        <th>Material</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        PreparedStatement psModules = conn.prepareStatement(
                            "SELECT c.year, c.semester, c.regulation, c.subject, m.module_number, m.material " +
                            "FROM modules m JOIN course c ON m.subject = c.subject " +
                            "WHERE m.subject IN (SELECT subject FROM instructor_subjects WHERE instructor_username = ?)"
                        );
                        psModules.setString(1, instructorUsername);
                        ResultSet rsModules = psModules.executeQuery();
                        while (rsModules.next()) {
                            String yr = rsModules.getString("year");
                            String sem = rsModules.getString("semester");
                            String reg = rsModules.getString("regulation");
                            String subj = rsModules.getString("subject");
                            int modNum = rsModules.getInt("module_number");
                            String material = rsModules.getString("material");
                    %>
                    <tr>
                        <td><%= yr %></td>
                        <td><%= sem %></td>
                        <td><%= reg %></td>
                        <td><%= subj %></td>
                        <td><%= modNum %></td>
                        <td>
                            <%= (material != null && !material.isEmpty()) ? "Uploaded" : "Not Uploaded" %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <button class="btn btn-info" onclick="viewMaterial('<%= subj %>', '<%= modNum %>')">View</button>
                                <button class="btn btn-danger" onclick="deleteMaterial('<%= subj %>', '<%= modNum %>')">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
      function viewMaterial(subject, moduleNumber) {
          window.location.href = "viewmaterials?subject=" + encodeURIComponent(subject) + "&module_number=" + moduleNumber;
      }
      function deleteMaterial(subject, moduleNumber) {
          if(confirm("Are you sure you want to delete this material?")){
              window.location.href = "deletematerials?subject=" + encodeURIComponent(subject) + "&module_number=" + moduleNumber;
          }
      }
    </script>
</body>
</html>
