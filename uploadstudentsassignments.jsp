<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Assignments</title>
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
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
            transition: 0.3s;
            font-weight: 600;
        }
        .view-btn {
            background-color: #27ae60;
            color: white;
        }
        .download-btn {
            background-color: #f39c12;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <h2>Your Assignments</h2>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.html");
        return;
    }

    try {
        Connection conn = databaseConnetion.getConnetion();

        PreparedStatement studentStmt = conn.prepareStatement("SELECT year, semester, regulation, section FROM student WHERE username = ?");
        studentStmt.setString(1, username);
        ResultSet studentRs = studentStmt.executeQuery();

        if (studentRs.next()) {
            String year = studentRs.getString("year");
            String semester = studentRs.getString("semester");
            String regulation = studentRs.getString("regulation");
            String section = studentRs.getString("section");

            String sql = "SELECT a.aid, a.title, a.sub, a.duedate, a.afile, i.instructor_username, " +
                         "(SELECT COUNT(*) FROM submission s WHERE s.aid = a.aid AND s.student_id = ? AND s.submitted_file IS NOT NULL) AS submitted " +
                         "FROM assignments a " +
                         "JOIN instructor_subjects i ON a.sub = i.subject " +
                         "WHERE a.yearr = ? AND a.sem = ? AND a.reg = ?";

            PreparedStatement assignmentStmt = conn.prepareStatement(sql);
            assignmentStmt.setString(1, username);
            assignmentStmt.setString(2, year);
            assignmentStmt.setString(3, semester);
            assignmentStmt.setString(4, regulation);
            ResultSet rs = assignmentStmt.executeQuery();
%>
    <table>
        <tr>
            <th>Title</th>
            <th>Subject</th>
            <th>Due Date</th>
            <th>Actions</th>
            <th>Upload</th>
        </tr>
<%
            while (rs.next()) {
                int aid = rs.getInt("aid");
                String sub = rs.getString("sub");
                String afile = rs.getString("afile");
                String instructorUsername = rs.getString("instructor_username");
                boolean isSubmitted = rs.getInt("submitted") > 0;
%>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= sub %></td>
            <td><%= rs.getString("duedate") %></td>
            <td>
    <div style="display: flex; gap: 10px; justify-content: center;">
        <!-- View Button -->
        <form action="viewstudentsassignments">
            <input type="hidden" name="aid" value="<%= aid %>">
            <input type="hidden" name="sub" value="<%= sub %>">
            <input type="hidden" name="instructor_username" value="<%= instructorUsername %>">
            <input type="hidden" name="section" value="<%= section %>">
            <input type="hidden" name="file" value="<%= afile %>">
            <button class="btn view-btn">View</button>
        </form> 

        <!-- Download Button -->
        <a href="download_assignment?file=<%= afile %>">
            <button class="btn download-btn">Download</button>
        </a> 
    </div>
</td>

            <td>
                <% if (!isSubmitted) { %>
                    <form action="upload_assignment" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="aid" value="<%= aid %>">
                        <input type="hidden" name="sub" value="<%= sub %>">
                        <input type="file" name="file" accept=".pdf,.docx" required>
                        <button type="submit" class="btn upload-btn">Upload</button>
                    </form>
                <% } else { %>
                    <span style="color: green; font-weight: bold;">Submitted</span>
                <% } %>
            </td>
        </tr>
<%
            }
%>
    </table>
<%
        }
    } catch (Exception e) {
%>
    <p style="color: red;">Error: <%= e.getMessage() %></p>
<%
    }
%>
</body>
</html>
