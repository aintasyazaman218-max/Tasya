<%-- 
    Document   : view_all_appointments
    Created on : 12 May 2026, 7:44:18 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Admin".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>All Appointments | Admin</title>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container">
    <nav><a href="admin_dashboard.jsp">Back</a></nav>
    <h2>All Clinic Appointment</h2>
    
    <div class="admin-nav">
        <a href="admin_dashboard.jsp">Dashboard</a>
        <a href="manage_users.jsp">Manage Users</a>
        <a href="view_all_appointments.jsp" class="active">Appointments</a>
        <a href="reports.jsp">Reports</a>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <table border="1" style="width:100%; text-align: left;">
        <thead>
            <tr>
                <th>Appt ID</th>
                <th>Patient Name</th>
                <th>Doctor Assigned</th>
                <th>Date</th>
                <th>Time</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>101</td>
                <td>Ryan Harith</td>
                <td>Dr. Sarah</td>
                <td>2026-05-12</td>
                <td>09:00 AM</td>
                <td><strong>Confirmed</strong></td>
            </tr>
        </tbody>
    </table>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>