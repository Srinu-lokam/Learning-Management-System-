<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Courses</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #e3f2fd;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h2 {
            color: #1565c0;
            font-size: 32px;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
            margin-bottom: 20px;
        }
        .materials {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .material {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0px 6px 20px rgba(0, 0, 0, 0.1);
            width: 260px;
            text-align: center;
            font-size: 18px;
            font-weight: 600;
            color: #0d47a1;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        .material:hover {
            transform: scale(1.05);
            box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.2);
        }
        .no-result {
            background-color: #e0f7fa;
            border: 1px solid #4dd0e1;
            padding: 10px;
            text-align: center;
            width: 100%;
        }
    </style>
</head>
<body>
    <h2>Available Courses</h2>
<%
    // Retrieve the logged-in username
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if session is invalid
        return;
    }
    
    try {
        // Establish a connection to the database
        Connection conn = databaseConnetion.getConnetion();

        // Query to fetch year, semester, and regulation for the logged-in student
        PreparedStatement pstmt = conn.prepareStatement("SELECT year, semester, regulation FROM student WHERE username = ?");
        pstmt.setString(1, username);
        ResultSet studentRs = pstmt.executeQuery();

        if (studentRs.next()) {
            String year = studentRs.getString("year");
            String semester = studentRs.getString("semester");
            String regulation = studentRs.getString("regulation");

            // Query to fetch subjects for the respective year, semester, and regulation
            PreparedStatement courseStmt = conn.prepareStatement("SELECT subject FROM course WHERE year = ? AND semester = ? AND regulation = ?");
            courseStmt.setString(1, year);
            courseStmt.setString(2, semester);
            courseStmt.setString(3, regulation);
            ResultSet rs = courseStmt.executeQuery();
%>
    <div class="materials">
<%
            boolean found = false;
            while (rs.next()) {
                found = true;
%>
        <div class="material" onclick="location.href='viewmodulesstudent.jsp?subject=<%= rs.getString("subject") %>'">
            <div><strong>Subject:</strong> <%= rs.getString("subject") %></div>
            <div><strong>Year:</strong> <%= year %></div>
            <div><strong>Semester:</strong> <%= semester %></div>
        </div>
<%
            }
            if (!found) {
%>
        <div class="no-result">
            <p>No courses available for your selection.</p>
        </div>
<%
            }
        } else {
%>
        <div class="no-result">
            <p>Error: Student details not found.</p>
        </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="no-result">
        <p>Error: <%= e.getMessage() %></p>
    </div>
<%
    }
%>
</div>
</body>
</html>
