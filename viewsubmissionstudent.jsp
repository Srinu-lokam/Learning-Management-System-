<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Check if the student is logged in
    HttpSession sessionObj = request.getSession();
    String studentId = (String) sessionObj.getAttribute("username");

    if (studentId == null) {
        response.sendRedirect("index.html"); // Redirect to login if not logged in
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String selectedSubject = request.getParameter("subject"); // Get selected subject from dropdown

    try {
        conn = databaseConnetion.getConnetion();

        // Fetch student's year, semester, and regulation
        PreparedStatement studentStmt = conn.prepareStatement("SELECT year, semester, regulation FROM student WHERE username = ?");
        studentStmt.setString(1, studentId);
        ResultSet studentRs = studentStmt.executeQuery();

        String studentYear = "", studentSemester = "", studentRegulation = "";

        if (studentRs.next()) {
            studentYear = studentRs.getString("year");
            studentSemester = studentRs.getString("semester");
            studentRegulation = studentRs.getString("regulation");
        }
        studentRs.close();
        studentStmt.close();

        // Fetch available subjects for the student (for the dropdown)
        PreparedStatement subjectStmt = conn.prepareStatement(
            "SELECT DISTINCT sub FROM assignments WHERE yearr = ? AND sem = ? AND reg = ?"
        );
        subjectStmt.setString(1, studentYear);
        subjectStmt.setString(2, studentSemester);
        subjectStmt.setString(3, studentRegulation);
        ResultSet subjectRs = subjectStmt.executeQuery();

        // Fetch student's submitted assignments with filtering
        String query = "SELECT s.aid, a.title, s.sub, s.instructor_name, s.submitted_file, s.submitted_at, s.grade " +
                       "FROM submission s " +
                       "JOIN assignments a ON s.aid = a.aid " +
                       "WHERE s.student_id = ? " +
                       "AND a.yearr = ? AND a.sem = ? AND a.reg = ?";

        if (selectedSubject != null && !selectedSubject.isEmpty()) {
            query += " AND s.sub = ?";
        }

        stmt = conn.prepareStatement(query);
        stmt.setString(1, studentId);
        stmt.setString(2, studentYear);
        stmt.setString(3, studentSemester);
        stmt.setString(4, studentRegulation);

        if (selectedSubject != null && !selectedSubject.isEmpty()) {
            stmt.setString(5, selectedSubject);
        }

        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Submissions</title>
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
        .filter-container {
            text-align: center;
            margin-bottom: 20px;
        }
        select {
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ccc;
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
        .pending {
            color: red;
            font-weight: bold;
        }
        .graded {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>Your Submitted Assignments</h2>

    <!-- Subject Filter Dropdown -->
    <div class="filter-container">
        <form method="GET">
            <label for="subject">Filter by Subject:</label>
            <select name="subject" id="subject" onchange="this.form.submit()">
                <option value="">All Subjects</option>
                <%
                    while (subjectRs.next()) {
                        String subject = subjectRs.getString("sub");
                        boolean isSelected = (selectedSubject != null && selectedSubject.equals(subject));
                %>
                    <option value="<%= subject %>" <%= isSelected ? "selected" : "" %>><%= subject %></option>
                <%
                    }
                    subjectRs.close();
                    subjectStmt.close();
                %>
            </select>
        </form>
    </div>

    <table>
        <tr>
            <th>Assignment Title</th>
            <th>Subject</th>
            <th>Instructor</th>
            <th>Submitted File</th>
            <th>Submission Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>

        <%
            // Display assignment submissions
            while (rs.next()) {
                String submittedFile = rs.getString("submitted_file");
                String grade = rs.getString("grade");
                String status = (grade == null || grade.isEmpty()) ? "Pending" : "Graded";
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("sub") %></td>
            <td><%= rs.getString("instructor_name") %></td>
            <td><%= (submittedFile != null) ? submittedFile : "No file" %></td>
            <td><%= rs.getTimestamp("submitted_at") %></td>
            <td class="<%= status.equals("Pending") ? "pending" : "graded" %>"><%= status %></td>
            <td>
                <% if (submittedFile != null) { %>
                    <a href="pdfs/<%= submittedFile %>" class="btn view-btn" target="_blank">View</a>
                    <a href="pdfs/<%= submittedFile %>" class="btn download-btn" download>Download</a>
                <% } else { %>
                    <span>No file</span>
                <% } %>
            </td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
        %>
    </table>
</body>
</html>
