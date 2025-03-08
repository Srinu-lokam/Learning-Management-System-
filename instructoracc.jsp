<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instructor Accounts | LMS</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    /* General Styles */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Arial', sans-serif;
      background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
      background-size: cover;
      color: #333;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
    }
    .container {
      max-width: 1200px;
      background: rgba(255, 255, 255, 0.9);
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
      text-align: center;
    }
    h2 {
      color: #004085;
      font-size: 1.8rem;
      margin-bottom: 15px;
      border-bottom: 3px solid #004085;
      padding-bottom: 10px;
    }
    .button-container {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    .btn {
      padding: 10px 18px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      color: white;
      font-size: 1rem;
      transition: 0.3s ease-in-out;
    }
    .add-btn {
      background: #28a745;
    }
    .add-btn:hover {
      background: #218838;
    }
    .edit-btn {
      background: #ffc107;
    }
    .edit-btn:hover {
      background: #e0a800;
    }
    .delete-btn {
      background: #dc3545;
    }
    .delete-btn:hover {
      background: #c82333;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 15px;
      table-layout: fixed;
    }
    thead {
      background: #004085;
      color: white;
    }
    th, td {
      padding: 12px;
      text-align: center;
      border: 1px solid #ddd;
      word-wrap: break-word;
    }
    tbody tr:nth-child(even) {
      background: #f2f2f2;
    }
    tbody tr:hover {
      background: #d6e9f8;
    }
    .profile-photo {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #ddd;
    }
    /* Ensuring Edit and Delete buttons are aligned */
    td:last-child {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px; /* Adds space between Edit and Delete buttons */
    }
    td:last-child button {
      flex: none; /* Prevents buttons from stretching */
    }
    th:last-child, td:last-child {
      width: 180px; /* Adjust width as needed */
    }
    /* Added width for qualification column */
    th:nth-child(6), td:nth-child(6) {
      width: 150px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Instructor Accounts</h2>
    
    <div class="button-container">
      <button class="btn add-btn" onclick="addAccount()">Add Instructor</button>
      <button class="btn add-btn" onclick="addSubject()">Add Subject</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>Profile Photo</th>
          <th>Name</th>
          <th>Username</th>
          <th>Email</th>
          <th>Mobile</th>
          <th>Qualification</th>
          <th>Subjects</th>
          <th>Sections</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
          Connection conn = databaseConnetion.getConnetion();
          PreparedStatement ps = conn.prepareStatement(
              "SELECT i.name, i.username, i.email, i.mobile, i.photo, i.qualification, " +
              "GROUP_CONCAT(isub.subject ORDER BY isub.subject SEPARATOR ', ') AS subjects, " +
              "GROUP_CONCAT(isub.section ORDER BY isub.subject SEPARATOR ', ') AS sections " +
              "FROM instructor i " +
              "LEFT JOIN instructor_subjects isub ON i.username = isub.instructor_username " +
              "GROUP BY i.username"
          );
          ResultSet rs = ps.executeQuery();
          while (rs.next()) {
        %>
        <tr>
          <td>
            <%
              String photo = rs.getString("photo");
              if (photo != null && !photo.isEmpty()) {
            %>
              <img class="profile-photo" src="pdfs/<%= photo %>" alt="Profile Photo">
            <%
              } else {
            %>
              No photo
            <%
              }
            %>
          </td>
          <td><%= rs.getString("name") %></td>
          <td><%= rs.getString("username") %></td>
          <td><%= rs.getString("email") %></td>
          <td><%= rs.getString("mobile") %></td>
          <td><%= rs.getString("qualification") %></td>
          <td><%= rs.getString("subjects") != null ? rs.getString("subjects") : "No subjects assigned" %></td>
          <td><%= rs.getString("sections") != null ? rs.getString("sections") : "No sections assigned" %></td>
          <td>
            <button class="btn edit-btn" onclick="editAccount('<%= rs.getString("username") %>')">Edit</button>
            <button class="btn delete-btn" onclick="deleteAccount('<%= rs.getString("username") %>')">Delete</button>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  
  <script>
    function addAccount() {
      window.location.href = "createacc.html";
    }
    
    function addSubject() {
      window.location.href = "addsubject.html";
    }

    function editAccount(username) {
      window.location.href = "updateacc.jsp?username=" + username;
    }

    function deleteAccount(username) {
      if (confirm("Are you sure you want to delete this account?")) {
        window.location.href = "deleteacc?username=" + username;
      }
    }
  </script>
</body>
</html>
