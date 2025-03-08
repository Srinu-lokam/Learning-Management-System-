<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Instructor Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet">
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
      max-width: 800px;
      background: #fff;
      margin: 40px auto;
      padding: 30px 40px;
      border-radius: 10px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.2);
    }
    /* Header */
    .profile-header {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 20px;
      border-bottom: 1px solid #ddd;
      padding-bottom: 20px;
      margin-bottom: 20px;
      justify-content: center;
    }
    .profile-photo {
      width: 140px;
      height: 140px;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid #5563DE;
    }
    .profile-details {
      flex: 1;
      text-align: left;
      min-width: 250px;
    }
    .profile-details h1 {
      font-size: 2.2rem;
      color: #5563DE;
      margin-bottom: 10px;
    }
    .profile-details p {
      font-size: 1rem;
      margin-bottom: 6px;
      color: #666;
    }
    /* Assigned Subjects Section */
    .subject-container {
      margin-top: 20px;
    }
    .subject-container h2 {
      font-size: 1.6rem;
      color: #5563DE;
      margin-bottom: 10px;
      border-bottom: 1px solid #ddd;
      padding-bottom: 8px;
    }
    .subject-container ul {
      list-style-type: none;
      padding: 0;
    }
    .subject-container li {
      font-size: 1rem;
      padding: 10px;
      margin-bottom: 8px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background: #f9f9f9;
      color: #444;
    }
    @media (max-width: 600px) {
      .profile-header {
        flex-direction: column;
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
        // Retrieve instructor username from session
        String instructorUsername = (String) session.getAttribute("username");
        if (instructorUsername == null) {
          out.println("<script>alert('Please log in as an instructor.'); window.location.href='index.html';</script>");
          return;
        }
        Connection conn = databaseConnetion.getConnetion();
        String name = "", email = "", mobile = "", photo = "";
        try {
        	PreparedStatement ps = conn.prepareStatement("SELECT * FROM instructor WHERE username = ?");
            ps.setString(1, instructorUsername);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("name");
                    email = rs.getString("email");
                    mobile = rs.getString("mobile");
                    photo = rs.getString("photo");
                } else {
                    out.println("<p>Instructor not found.</p>");
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
          <img class="profile-photo" src="assets/images/profile.jpg" alt="Default Profile">
        <% } %>
      </div>
      <div class="profile-details">
        <h1><%= name %></h1>
        <p><strong>Username:</strong> <%= instructorUsername %></p>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Mobile:</strong> <%= mobile %></p>
      </div>
    </div>
    
    <div class="subject-container">
      <h2>Assigned Subjects and Sections</h2>
      <ul>
        <%
          try {
        	  PreparedStatement psSub = conn.prepareStatement("SELECT subject, section FROM instructor_subjects WHERE instructor_username = ?");
              psSub.setString(1, instructorUsername);
              try (ResultSet rsSub = psSub.executeQuery()) {
                  boolean hasSubjects = false;
                  while(rsSub.next()){
                      hasSubjects = true;
                      String subj = rsSub.getString("subject");
                      String section = rsSub.getString("section");
        %>
        <li><strong>Subject:</strong> <%= subj %> &nbsp;&nbsp; <strong>Section:</strong> <%= section %></li>
        <%
                  }
                  if (!hasSubjects) {
                      out.println("<li>No subjects assigned.</li>");
                  }
              }
          } catch (SQLException ex) {
              ex.printStackTrace();
              out.println("<li>Error retrieving subjects.</li>");
          }
        %>
      </ul>
    </div>
  </div>
</body>
</html>
