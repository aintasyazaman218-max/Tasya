<%-- 
    Document   : header
    Created on : 13 May 2026, 7:22:44 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String currentRole = (String) session.getAttribute("userRole");
    String currentEmail = (String) session.getAttribute("userEmail");
%>
<div class="header">
    <a href="index.jsp" class="site-title">Clinic Management System</a>
    
    <div class="nav-links">
        <% if (currentRole != null) { %>
            <% if ("Patient".equals(currentRole)) { %>
                <a href="patient_dashboard.jsp">Home</a>
                <a href="view_profile.jsp">My Profile</a>
                <a href="book_appointment.jsp">Book Appointment</a>
            <% } else if ("Doctor".equals(currentRole)) { %>
                <a href="doctor_dashboard.jsp">Home</a>
                <a href="manage_schedule.jsp">Schedule</a>
                <a href="view_assigned_patients.jsp">My Patients</a>
            <% } else if ("Admin".equals(currentRole)) { %>
                <a href="admin_dashboard.jsp">Home</a>
                <a href="manage_users.jsp">Manage Users</a>
                <a href="appointments.jsp">Appointments</a>
                <a href="payments.jsp">Payments & Invoices</a>
                <a href="inventory.jsp">Inventory Management</a>
                <a href="reports.jsp">Reports</a>
            <% } %>
            
            <a href="LogoutServlet" class="logout-link">Logout</a>
            
        <% } else { %>
            <a href="index.jsp">Home</a>
            <a href="signup.jsp">Register</a>
            <a href="index.jsp">Login</a>
        <% } %>
    </div>
</div>
</body>
</html>