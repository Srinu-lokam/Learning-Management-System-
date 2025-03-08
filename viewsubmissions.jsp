<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Submissions | LMS</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background: #f9f9f9;
      margin: 0;
      padding: 20px;
    }
    .container {
      max-width: 1100px;
      margin: auto;
      background: #fff;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
      color: #004085;
      text-align: center;
      font-size: 1.8rem;
      border-bottom: 3px solid #004085;
      padding-bottom: 10px;
      margin-bottom: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    thead {
      background: #004085;
      color: white;
    }
    th, td {
      padding: 12px;
      text-align: center;
      border: 1px solid #ddd;
    }
    tbody tr:nth-child(even) {
      background: #f2f2f2;
    }
    tbody tr:hover {
      background: #d6e9f8;
    }
    .btn {
      padding: 8px 14px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: 0.3s;
    }
    .btn-warning {
      background: #ff9800;
      color: #fff;
    }
    .btn-warning:hover {
      background: #e68900;
    }
    .filter-section {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-bottom: 20px;
    }
    select {
      padding: 8px;
      font-size: 1rem;
      border: 1px solid #ccc;
      border-radius: 5px;
      width: 200px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Student Submissions</h2>
    
    <%
      String instructorUsername = (String) session.getAttribute("username");
      if (instructorUsername == null) {
          out.println("<script>alert('Please log in as an instructor.'); window.location.href='index.html';</script>");
          return;
      }
      
      Connection conn = databaseConnetion.getConnetion();
      PreparedStatement ps;
      ResultSet rs;

      ps = conn.prepareStatement("SELECT DISTINCT subject FROM instructor_subjects WHERE instructor_username = ?");
      ps.setString(1, instructorUsername);
      rs = ps.executeQuery();

      String selectedSubject = request.getParameter("subject");
      if (selectedSubject == null && rs.next()) {
          selectedSubject = rs.getString("subject");
      }
    %>

    <!-- Subject Filter Form -->
    <div class="filter-section">
      <form method="GET" action="viewsubmissions.jsp">
        <label for="subject">Select Subject:</label>
        <select name="subject" id="subject" onchange="this.form.submit()">
          <% 
            rs.beforeFirst();
            while (rs.next()) { 
              String subject = rs.getString("subject");
          %>
          <option value="<%= subject %>" <%= subject.equals(selectedSubject) ? "selected" : "" %>><%= subject %></option>
          <% } %>
        </select>
      </form>
    </div>

    <%
      // Fetch submissions based on selected subject
      ps = conn.prepareStatement(
          "SELECT s.sid, s.student_id, a.title, s.sub, s.submitted_file, s.submitted_at, s.feedback, s.grade ,s.viewed_time " +
          "FROM submission s " +
          "JOIN assignments a ON s.aid = a.aid " +
          "WHERE s.instructor_username = ? AND s.sub = ? " +
          "ORDER BY s.submitted_at DESC"
      );
      ps.setString(1, instructorUsername);
      ps.setString(2, selectedSubject);
      rs = ps.executeQuery();
    %>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Student ID</th>
          <th>Assignment Title</th>
          <th>Subject</th>
          <th>Submitted File</th>
          <th>Submitted At</th>
          <th>Feedback</th>
          <th>Grade</th>
          <th>Seen At</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
          while (rs.next()) {
              int sid = rs.getInt("sid");
              String studentId = rs.getString("student_id");
              String title = rs.getString("title");
              String subject = rs.getString("sub");
              String submittedFile = rs.getString("submitted_file");
              Timestamp submittedAt = rs.getTimestamp("submitted_at");
              String feedback = rs.getString("feedback");
              String grade = rs.getString("grade");
              String dt = rs.getString("viewed_time");
        %>
        <tr>
          <td><%= sid %></td>
          <td><%= studentId %></td>
          <td><%= title %></td>
          <td><%= subject %></td>
          <td>
            <% if (submittedFile != null && !submittedFile.isEmpty()) { %>
                <a href="viewsubmission?file=<%= submittedFile %>" target="_blank">View File</a>
            <% } else { %>
                Not Submitted
            <% } %>
          </td>
          <td><% if (submittedAt != null ) { %>
                <%= submittedAt %>
            <% } else { %>
                Not Submitted
            <% } %></td>
          <td><%= feedback != null ? feedback : "N/A" %></td>
          <td><%= grade != null ? grade : "N/A" %></td>
          <td><%if(dt!=null && !dt.isEmpty()){%>
        	  Seen
        	  <%}else{%>
        	  Not Seen
        	  <%}%></td>
          
          <td>
            <button class="btn btn-warning" onclick="giveFeedback('<%= sid %>')">Feedback/Grade</button>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>

  <script>
      function giveFeedback(sid) {
          window.location.href = "givefeedback.jsp?sid=" + sid;
      }
  </script>
</body>
</html>
