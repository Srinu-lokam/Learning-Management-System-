<%@page import="com.database.databaseConnetion"%>
<%@ page import="java.sql.*, java.io.*" %>
<%
    String username = request.getParameter("username");
    Connection conn = databaseConnetion.getConnetion();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM student WHERE username = ?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    String fullname = "", section = "", email = "", password = "", mobile = "", photo = "", year = "", semester = "";
    if (rs.next()) {
        fullname = rs.getString("fullname");
        section = rs.getString("section");
        email = rs.getString("email");
        password = rs.getString("password");
        mobile = rs.getString("mobile");
        photo = rs.getString("photo");
        year = rs.getString("year");
        semester = rs.getString("semester");

    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Account</title>
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
      max-width: 400px;
      padding: 30px;
      border-radius: 8px;
      text-align: center;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.5);
      backdrop-filter: blur(8px);
    }

    form {
      display: grid;
      gap: 10px;
    }

    h2 {
      color: white;
      font-size: 1.8rem;
    }

    label {
      color: white;
      text-align: left;
      display: block;
    }

    input, select {
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
    }

    .profile-photo-preview {
      margin-top: 10px;
      max-width: 150px;
      border-radius: 8px;
    }

  </style>
</head>
<body>
  <div class="wrapper">
    <form action="studentupdateacc" method="post" enctype="multipart/form-data">
      <h2>Update Account</h2>

      <input type="hidden" name="username" value="<%= username %>">

      <label>Full Name:</label>
      <input type="text" name="fullname" value="<%= fullname %>" required>
      
      <label>Section:</label>
      <input type="text" name="section" value="<%= section %>" required>

      <label>Email:</label>
      <input type="email" name="email" value="<%= email %>" required>

      <label>Password:</label>
      <input type="password" name="password" value="<%= password %>" required>

      <label>Mobile:</label>
      <input type="tel" name="mobile" value="<%= mobile %>" required>

      <label>Year:</label>
      <select name="year" required>
        <option value="1" <%= "1".equals(year) ? "selected" : "" %>>1st Year</option>
        <option value="2" <%= "2".equals(year) ? "selected" : "" %>>2nd Year</option>
        <option value="3" <%= "3".equals(year) ? "selected" : "" %>>3rd Year</option>
        <option value="4" <%= "4".equals(year) ? "selected" : "" %>>4th Year</option>
      </select>

      <label>Semester:</label>
      <select name="semester" required>
        <option value="1" <%= "1".equals(semester) ? "selected" : "" %>>1st Semester</option>
        <option value="2" <%= "2".equals(semester) ? "selected" : "" %>>2nd Semester</option>
      </select>


      <label>Profile Photo (Optional):</label>
      <input type="file" name="photo">

      <% if(photo != null && !photo.isEmpty()) { %>
        <div>
          <img src="images/<%= photo %>" alt="Profile Photo" class="profile-photo-preview">
        </div>
      <% } %>

      <button type="submit">Update Account</button>
    </form>
  </div>
</body>
</html>
