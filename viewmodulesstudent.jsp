<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Modules</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            font-family: 'Montserrat', sans-serif;
            background-color: #e3f2fd;
            height: 100vh; /* Full viewport height */
            overflow: hidden;
        }
        h2 {
            color: #1565c0;
            font-size: 32px;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
            margin-bottom: 20px;
        }
        .container {
            display: flex;
            width: 100%;
            height: 100vh; /* Make container full height */
        }
        .sidebar {
            width: 250px;
            background: #f1f8ff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
        }
        .modules-list {
            list-style: none;
            padding: 0;
        }
        .modules-list li {
            background: #bbdefb;
            padding: 10px;
            margin-bottom: 5px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        .modules-list li:hover {
            background: #90caf9;
        }
        .pdf-viewer {
            flex-grow: 1; /* Takes up remaining space */
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-left: 20px;
            height: 100%; /* Makes it match sidebar height */
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="sidebar">
            <ul class="modules-list">
<%
    String subject = request.getParameter("subject");
    if (subject != null && !subject.trim().isEmpty()) {
        try {
            Connection conn = databaseConnetion.getConnetion();
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM modules WHERE subject = ?");
            pstmt.setString(1, subject);
            ResultSet rs = pstmt.executeQuery();
            boolean found = false;
            while (rs.next()) {
                found = true;
                String materialPath = "pdfs/" + rs.getString("material");
%>
                <li onclick="showPDF('<%= materialPath %>')">Module <%= rs.getInt("module_number") %></li>
<%
            }
            if (!found) {
%>
                <li>No modules found</li>
<%
            }
        } catch (Exception e) {
%>
            <li>Error: <%= e.getMessage() %></li>
<%
        }
    } else {
%>
        <li>Invalid subject selection</li>
<%
    }
%>
            </ul>
        </div>
        <div class="pdf-viewer">
            <iframe id="pdfFrame" src=""></iframe>
        </div>
    </div>
    <script>
        function showPDF(pdfUrl) {
            document.getElementById("pdfFrame").src = pdfUrl;
        }
    </script>
</body>
</html>
