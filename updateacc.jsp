

<%@page import="java.sql.*"%>
<%@page import="com.database.databaseConnetion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String username = request.getParameter("username");
    Connection conn = databaseConnetion.getConnetion();

    // Retrieve instructor details
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM instructor WHERE username = ?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    String name = "", email = "", password = "", mobile = "", photo = "",qualification="";
    if (rs.next()) {
        name = rs.getString("name");
        email = rs.getString("email");
        password = rs.getString("password");
        mobile = rs.getString("mobile");
        photo = rs.getString("photo");
        qualification =    rs.getString("qualification");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Account</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    @import url("https://fonts.googleapis.com/css2?family=Open+Sans:wght@200;300;400;500;600;700&display=swap");
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Open Sans", sans-serif;
    }
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
      background-size: cover;
    }
    .wrapper {
      width: 90%;
      max-width: 500px;
      padding: 30px;
      border-radius: 8px;
      text-align: center;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.5);
      backdrop-filter: blur(8px);
      -webkit-backdrop-filter: blur(8px);
      margin-top: 50px;
      margin-bottom: 50px;
    }
    form {
      display: grid;
      gap: 15px;
    }
    h2 {
      color: white;
      font-size: 1.8rem;
      margin-bottom: 15px;
    }
    label {
      color: white;
      text-align: left;
    }
    input {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 3px;
    }
    button {
      padding: 12px;
      background: white;
      cursor: pointer;
      font-weight: bold;
      border: none;
      border-radius: 3px;
    }
    .subjects-container {
      text-align: left;
      margin-top: 20px;
      color: white;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    th, td {
      border: 1px solid white;
      padding: 8px;
      text-align: left;
      color: white;
    }
    th {
      background: rgba(255, 255, 255, 0.3);
    }
    .remove-btn {
      background: red;
      color: white;
      border: none;
      padding: 5px 10px;
      border-radius: 3px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="wrapper">
    <% if (photo != null && !photo.isEmpty()) { %>
      <div class="profile-photo-container">
        <img src="uploads/<%= photo %>" class="profile-photo" alt="Profile Photo">
      </div>
    <% } %>

    <form action="updateacc" method="post" enctype="multipart/form-data">
      <h2>Update Account</h2>
      
      <input type="hidden" name="username" value="<%= username %>">
      
      <label>Name:</label>
      <input type="text" name="name" value="<%= name %>" required>
      
      <label>Email:</label>
      <input type="email" name="email" value="<%= email %>" required>
      
      <label>Password:</label>
      <input type="password" name="password" value="<%= password %>" required>
      
      <label>Qualification:</label>
      <input type="password" name="qualification" value="<%= qualification %>" required>
      
      <label>Mobile:</label>
      <input type="tel" name="mobile" value="<%= mobile %>" required>
      
      <label>Profile Photo (Optional):</label>
      <input type="file" name="photo">

      <div class="subjects-container">
        <h3>Assigned Subjects & Sections</h3>
        <table>
          <tr>
            <th>Subject</th>
            <th>Section</th>
            <th>Action</th>
          </tr>
          <%
            PreparedStatement psSub = conn.prepareStatement(
              "SELECT subject, section FROM instructor_subjects WHERE instructor_username = ?"
            );
            psSub.setString(1, username);
            ResultSet rsSub = psSub.executeQuery();

            while (rsSub.next()) {
              String subject = rsSub.getString("subject");
              String section = rsSub.getString("section");
          %>
          <tr>
            <td><%= subject %></td>
            <td><%= section %></td>
            <td>
              <input type="checkbox" name="remove_subject" value="<%= subject %>" onclick="markForDeletion(this)"> Remove
            </td>
          </tr>
          <% } %>
        </table>
      </div>

      <button type="submit">Update Account</button>
    </form>
  </div>
</body>
</html>