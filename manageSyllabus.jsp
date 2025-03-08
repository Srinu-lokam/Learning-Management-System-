<%@ page import="java.sql.*" %>
<%@ page import="com.database.databaseConnetion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Curriculum</title>
    <style>
        /* General Styling */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: url("assets/images/loginbg.jpg") no-repeat center center fixed;
            background-size: cover;
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        .section-heading h2 {
            text-align: center;
            color: #007bff;
            margin-top: 20px;
        }
        .container {
            margin: 60px auto;
            max-width: 1250px;
            background: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        /* Table Styles */
        .table-container {
            max-height: 300px;
            overflow-y: auto;
            overflow-x: auto;
            margin-top: 20px;
            border: 1px solid #ddd;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            word-wrap: break-word;
        }
        thead th {
            position: sticky;
            top: 0;
            background-color: #f2f2f2;
        }
        /* Button Styling */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-group {
            display: flex;
            gap: 5px;
        }
        /* Form Styling */
        form div {
            margin-bottom: 10px;
        }
        form label {
            display: inline-block;
            width: 120px;
        }
        form input, form select {
            padding: 5px;
            width: calc(100% - 130px);
        }
        /* Adjusted Spacing */
        .upload-form,
        .filter-form,
        .table-container {
            margin-bottom: 40px;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin: 40px 0;
        }
    </style>
</head>
<body>
   <br> 
   <section id="manage-course-materials">
        <div class="container">
            <div class="section-heading">
                <h2>MANAGE CURRICULUM</h2><br>
            </div>
            <!-- Upload Form -->
            <div class="upload-form">
                <h3>Upload Course Curriculum - BTech</h3><br>
                <form id="uploadForm" action="managesyllabus" method="post" enctype="multipart/form-data">
                    <div>
                        <label for="year">Year:</label>
                        <select id="year" name="year" required>
                            <option value="1">1st Year</option>
                            <option value="2">2nd Year</option>
                            <option value="3">3rd Year</option>
                            <option value="4">4th Year</option>
                        </select>
                    </div>
                    <div>
                        <label for="semester">Semester:</label>
                        <select id="semester" name="semester" required>
                            <option value="1">1st Semester</option>
                            <option value="2">2nd Semester</option>
                        </select>
                    </div>
                    <div>
                        <label for="courseName">Course Name:</label>
                        <input type="text" id="courseName" name="courseName" required>
                    </div>
                    <div>
                        <label for="pdfFile">Upload PDF:</label>
                        <input type="file" id="pdfFile" name="pdf" accept="application/pdf" required>

                    </div>
                    <div>
                        <label for="regg">Regulation:</label>
                        <input type="text" id="regg" name="regg" required>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">Upload</button>
                    </div>
                </form>
            </div>
            <hr>
            <!-- Filter Form -->
            <div class="filter-form">
                <h3>View Course Curriculum</h3><br>
                <form id="filterForm" action="manageSyllabus.jsp" method="get">
                    <div>
                        <label for="fyear">Year:</label>
                        <select id="fyear" name="fyear">
                            <option value="">All Years</option>
                            <option value="1" <%= "1".equals(request.getParameter("fyear")) ? "selected" : "" %>>1st Year</option>
                            <option value="2" <%= "2".equals(request.getParameter("fyear")) ? "selected" : "" %>>2nd Year</option>
                            <option value="3" <%= "3".equals(request.getParameter("fyear")) ? "selected" : "" %>>3rd Year</option>
                            <option value="4" <%= "4".equals(request.getParameter("fyear")) ? "selected" : "" %>>4th Year</option>
                        </select>
                    </div>
                    <div>
                        <label for="fsemester">Semester:</label>
                        <select id="fsemester" name="fsemester">
                            <option value="">All Semesters</option>
                            <option value="1" <%= "1".equals(request.getParameter("fsemester")) ? "selected" : "" %>>1st Semester</option>
                            <option value="2" <%= "2".equals(request.getParameter("fsemester")) ? "selected" : "" %>>2nd Semester</option>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">Filter</button>
                    </div>
                </form>
            </div>
            <hr>
            <!-- Data Table -->
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Year</th>
                            <th>Semester</th>
                            <th>Course Name</th>
                            <th>Regulation</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String fyear = request.getParameter("fyear");
                            String fsemester = request.getParameter("fsemester");
                            
                            String query = "SELECT * FROM course";
                            boolean addWhere = false;
                            if (fyear != null && !fyear.trim().isEmpty()) {
                                query += " WHERE year = ?";
                                addWhere = true;
                            }
                            if (fsemester != null && !fsemester.trim().isEmpty()) {
                                query += addWhere ? " AND semester = ?" : " WHERE semester = ?";
                            }
                            
                            try {
                                Connection conn = databaseConnetion.getConnetion();
                                PreparedStatement ps = conn.prepareStatement(query);
                                int paramIndex = 1;
                                if (fyear != null && !fyear.trim().isEmpty()) {
                                    ps.setString(paramIndex++, fyear);
                                }
                                if (fsemester != null && !fsemester.trim().isEmpty()) {
                                    ps.setString(paramIndex++, fsemester);
                                }
                                ResultSet rs = ps.executeQuery();
                                while(rs.next()){
                                    String yr = rs.getString("year");
                                    String sem = rs.getString("semester");
                                    String subject = rs.getString("subject");
                                    String regulation = rs.getString("regulation");
                                    String file=rs.getString("file");
                        %>
                        <tr>
                            <td><%= yr %></td>
                            <td><%= sem %></td>
                            <td><%= subject %></td>
                            <td><%= regulation %></td>
                            <td>
                                <div class="btn-group">
                                    <button class="btn btn-info" onclick="viewCourse('<%= file %>')">View</button>
                                    <button class="btn btn-danger" onclick="deleteCourse('<%= subject %>')">Delete</button>
                                </div>
                            </td>
                        </tr>
                        <% 
                                } 
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>

            </div>
        </div>
    </section>
</body>
<script>
    function viewCourse(file) {
        window.location.href = "viewcourse?file=" + file;
    }

    function deleteCourse(subject) {
        if (confirm("Are you sure you want to delete this account?")) {
            window.location.href = "deleteCourse?subject=" + subject;
        }
    }
</script>
</html> 