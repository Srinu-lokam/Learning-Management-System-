<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Check if the student is logged in
    HttpSession sessionObj = request.getSession();
    String studentId = (String) sessionObj.getAttribute("username");

    if (studentId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    String selectedSubject = request.getParameter("subject");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Feedback & Grades</title>
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
        .graded {
            color: green;
            font-weight: bold;
        }
        .filter-container {
            text-align: center;
            margin-bottom: 20px;
        }
        select {
            padding: 8px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <h2>Your Graded Assignments</h2>
    <div class="filter-container">
        <form method="GET" action="viewgradesstudent.jsp">
            <label for="subject">Filter by Subject:</label>
            <select name="subject" id="subject" onchange="this.form.submit()">
                <option value="">All Subjects</option>
                <%
                    try {
                        Connection conn = databaseConnetion.getConnetion();
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT DISTINCT sub FROM submission WHERE student_id = ? AND grade IS NOT NULL"
                        );
                        stmt.setString(1, studentId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            String subject = rs.getString("sub");
                %>
                <option value="<%= subject %>" <%= subject.equals(selectedSubject) ? "selected" : "" %>><%= subject %></option>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </form>
    </div>
    
    <table>
        <tr>
            <th>Assignment ID</th>
            <th>Assignment Title</th>
            <th>Subject</th>
            <th>Instructor</th>
            <th>Grade</th>
            <th>Feedback</th>
        </tr>

        <%
            try {
                Connection conn = databaseConnetion.getConnetion();
                String query = "SELECT s.aid, a.title, s.sub, s.instructor_name, s.grade, s.feedback " +
                               "FROM submission s " +
                               "JOIN assignments a ON s.aid = a.aid " +
                               "WHERE s.student_id = ? AND s.grade IS NOT NULL";
                
                if (selectedSubject != null && !selectedSubject.isEmpty()) {
                    query += " AND s.sub = ?";
                }
                
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, studentId);
                if (selectedSubject != null && !selectedSubject.isEmpty()) {
                    stmt.setString(2, selectedSubject);
                }
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("aid") %></td>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("sub") %></td>
            <td><%= rs.getString("instructor_name") %></td>
            <td class="graded"><%= rs.getString("grade") %></td>
            <td><%= (rs.getString("feedback") != null) ? rs.getString("feedback") : "No feedback provided" %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } 
        %>
    </table>
</body>
</html>
