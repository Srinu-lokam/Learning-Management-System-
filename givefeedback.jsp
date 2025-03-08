<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Give Feedback and Grade</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            padding: 30px;
            text-align: center;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group textarea, .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
        }
        .btn {
            background-color: #007bff;
            color: #fff;
            padding: 10px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Feedback and Grade</h2>
        <%
            String sidStr = request.getParameter("sid");
            int sid = 0;
            try {
                sid = Integer.parseInt(sidStr);
            } catch(NumberFormatException e){
                out.println("<p>Invalid submission ID.</p>");
                return;
            }
            
            Connection conn = databaseConnetion.getConnetion();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM submission WHERE sid = ?");
            ps.setInt(1, sid);
            ResultSet rs = ps.executeQuery();
            
            if(!rs.next()){
                out.println("<p>Submission not found.</p>");
                return;
            }
            
            String studentId = rs.getString("student_id");
            int aid = rs.getInt("aid");
            String currentFeedback = rs.getString("feedback");
            String currentGrade = rs.getString("grade");
            
            // Fetch assignment title separately
            String assignmentTitle = "N/A";
            PreparedStatement pst = conn.prepareStatement("SELECT title FROM assignments WHERE aid = ?");
            pst.setInt(1, aid);
            ResultSet rs2 = pst.executeQuery();
            if (rs2.next()) {
                assignmentTitle = rs2.getString("title");
            }
            rs2.close();
            pst.close();
        %>
        
        <form action="givefeedback" method="post">
            <input type="hidden" name="sid" value="<%= sid %>">
            <div class="form-group">
                <label>Student ID:</label>
                <input type="text" value="<%= studentId %>" readonly>
            </div>
            <div class="form-group">
                <label>Assignment Title:</label>
                <input type="text" value="<%= assignmentTitle %>" readonly>
            </div>
            <div class="form-group">
                <label for="feedback">Feedback:</label>
                <textarea id="feedback" name="feedback" rows="5" placeholder="Enter feedback..."><%= currentFeedback != null ? currentFeedback : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="grade">Grade:</label>
                <input type="text" id="grade" name="grade" placeholder="Enter grade..." value="<%= currentGrade != null ? currentGrade : "" %>">
            </div>
            <button type="submit" class="btn">Submit Feedback/Grade</button>
        </form>
    </div>
</body>
</html>
