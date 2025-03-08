<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Global Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #74ABE2, #5563DE);
            color: #333;
            padding: 20px;
        }
        /* Profile Container */
        .profile-container {
            max-width: 700px;
            background: #fff;
            margin: 40px auto;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        /* Header */
        .profile-header {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            border-bottom: 2px solid #ddd;
            padding-bottom: 20px;
            margin-bottom: 20px;
            justify-content: center;
        }
        .profile-photo {
    width: 150px;
    height: 150px;
    border-radius: 50%;  /* Makes the image circular */
    object-fit: cover;  /* Ensures the image fits properly */
    border: 4px solid #5563DE; /* Adds a border */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Adds a subtle shadow */
}

        .profile-details {
            flex: 1;
            text-align: left;
            min-width: 250px;
        }
        .profile-details h1 {
            font-size: 2rem;
            color: #5563DE;
            margin-bottom: 10px;
        }
        .profile-details p {
            font-size: 1rem;
            margin-bottom: 6px;
            color: #444;
        }
        .profile-details p i {
            color: #5563DE;
            margin-right: 10px;
        }
        /* Responsive Design */
        @media (max-width: 600px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }
            .profile-details h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

<div class="profile-container">
    <div class="profile-header">
        <%
            // Retrieve student username from session
            String studentUsername = (String) session.getAttribute("username");
            if (studentUsername == null) {
                out.println("<script>alert('Please log in as a student.'); window.location.href='index.html';</script>");
                return;
            }
            Connection conn = databaseConnetion.getConnetion();
            String fullname = "", email = "", mobile = "", photo = "", section = "", year = "", semester = "", regulation = "";
            
            try {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM student WHERE username = ?");
                ps.setString(1, studentUsername);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fullname = rs.getString("fullname");
                        email = rs.getString("email");
                        mobile = rs.getString("mobile");
                        photo = rs.getString("photo");
                        section = rs.getString("section");
                        year = rs.getString("year");
                        semester = rs.getString("semester");
                        regulation = rs.getString("regulation");
                    } else {
                        out.println("<p>Student not found.</p>");
                        return;
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
                out.println("<p>Database error: " + ex.getMessage() + "</p>");
                return;
            }
        %>

        <div>
            <% if(photo != null && !photo.isEmpty()) { %>
                <img class="profile-photo" src="pdfs/<%= photo %>" alt="Profile Photo">
            <% } else { %>
                <img class="profile-photo" src="assets/images/default-profile.jpg" alt="Default Profile">
            <% } %>
        </div>
        <div class="profile-details">
            <h1><%= fullname %></h1>
            <p><i class="fas fa-user"></i><strong>Username:</strong> <%= studentUsername %></p>
            <p><i class="fas fa-envelope"></i><strong>Email:</strong> <%= email %></p>
            <p><i class="fas fa-phone"></i><strong>Mobile:</strong> <%= mobile %></p>
            <p><i class="fas fa-users"></i><strong>Section:</strong> <%= section %></p>
            <p><i class="fas fa-calendar"></i><strong>Year:</strong> <%= year %></p>
            <p><i class="fas fa-graduation-cap"></i><strong>Semester:</strong> <%= semester %></p>
            <p><i class="fas fa-university"></i><strong>Regulation:</strong> <%= regulation %></p>
        </div>
    </div>
</div>

</body>
</html>
