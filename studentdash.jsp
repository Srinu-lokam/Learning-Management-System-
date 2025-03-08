<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Student Dashboard</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- Additional CSS Files -->
    <link rel="stylesheet" href="assets/css/admin.css">
    <link rel="stylesheet" href="assets/css/sidebar.css">

    <style>
        /* Scrolling Notification Inside Content Area */
        .scroll-notification {
            width: 100%;
            overflow: hidden;
            white-space: nowrap;
            background-color: #ffcc00;
            color: #000;
            font-weight: bold;
            padding: 10px;
            text-align: center;
            margin-bottom: 10px; /* Adds space before the iframe */
        }
        @keyframes scrollText {
    0% {
        transform: translateX(100%);
    }
    90% {
        transform: translateX(-100%);
    }
    100% {
        transform: translateX(-100%);
    }
}

.scroll-text {
    display: inline-block;
    padding-left: 100%;
    animation: scrollText 20s linear infinite;
    animation-delay: 3s;
}

    </style>
</head>

<body>

<%
    // Fetch latest assignment from database
    String latestAssignment = "";
    try {
        Connection conn = databaseConnetion.getConnetion();
        PreparedStatement pstmt = conn.prepareStatement("SELECT title, sub, duedate FROM assignments ORDER BY createdat DESC LIMIT 1");
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            latestAssignment = "New Assignment: " + rs.getString("title") + " - " + rs.getString("sub") + " | Due Date: " + rs.getString("duedate");
        }
    } catch (Exception e) {
        latestAssignment = "Error fetching assignment updates.";
    }
%>


<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <button class="toggle-btn" id="toggle-btn">
        <i class="fas fa-angle-double-left"></i>
    </button>
    <div class="logo">
        <div class="user-profile">
            <div class="user-avatar">
                <img src="./assets/images/logo.png" alt="User">
            </div>
            <div class="user-details">
                <h2>SWRN LMS</h2>
            </div>
        </div>
    </div>
    <ul class="menu-list">
        <li class="link" id="home-link"><img src="assets/images/home.png" alt="Home"> <a href="studentdash.jsp"> Home</a></li>
        <li class="link" onclick="loadPage('viewsyllabus.jsp')">
            <img src="./assets/images/program.png" alt="Upload"> View Curriculum
        </li>
        <li class="link" onclick="loadPage('viewmaterialsstudent.jsp')">
            <img src="./assets/images/materials.png" alt="Upload"> Course Materials
        </li>
        <li class="link" onclick="loadPage('uploadstudentsassignments.jsp')">
            <img src="./assets/images/upload.png" alt="Upload"> Upload Assignments
        </li>
        <li class="link" onclick="loadPage('viewsubmissionstudent.jsp')">
            <img src="./assets/images/imp.png" alt="Topics"> View Submissions
        </li>
        <li class="link" onclick="loadPage('viewgradesstudent.jsp')">
            <img src="./assets/images/task.png" alt="Submissions"> Assigned Grades
        </li>
        <li class="link" onclick="loadPage('viewoldpapersstudent.jsp')">
            <img src="./assets/images/exam.png" alt="Submissions"> Previous Papers
        </li>
        <li class="link" onclick="loadPage('viewstudentprofile.jsp')">
            <img src="./assets/images/user.png" alt="Profile"> Profile
        </li>
        <li class="link">
            <a href="index.html" style="text-decoration: none; color: inherit;">
                <img src="assets/images/exit.png" alt=""> Logout
            </a>
        </li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content" id="main-content">
    <section class="instructor-dashboard" id="home-section">
        <div class="video-overlay header-text">
            <div class="caption">
                <h2><em>Student</em> Dashboard</h2>
                <div class="main-button">
                    <div class="scroll-to-section"><a href="#manage-accounts">Get Started</a></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Content Display Area -->
    <div class="content-container">
        <% if (!latestAssignment.isEmpty()) { %>
            <div class="scroll-notification">
                <div class="scroll-text"><%= latestAssignment %></div>
            </div>
        <% } %>
        
        <iframe id="content-frame" src="" style="width: 100%; height: 800px; border: none;"></iframe>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright by Learning Management System, All Rights Reserved.</p>
                </div>
            </div>
        </div>
    </footer>
</div>

<!-- JavaScript for Sidebar Toggle and Page Handling -->
<script>
    // Toggle Sidebar
    document.getElementById('toggle-btn').addEventListener('click', function () {
        document.body.classList.toggle('active');
    });

    // Load Pages inside iframe
    function loadPage(page) {
        document.getElementById('content-frame').src = page;
    }

    document.getElementById("content-frame").addEventListener("load", function () {
        if (!this.src.includes("home.html")) {
            document.getElementById("home-section").style.display = "none";
        }
    });
</script>

</body>
</html>