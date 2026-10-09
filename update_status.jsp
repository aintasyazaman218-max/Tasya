<%-- 
    Document   : update_status
    Created on : 13 May 2026, 9:23:05 am
    Author     : ASUS
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    String appId = request.getParameter("appId");
    String patientName = request.getParameter("patientName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update Appointment Status | Clinic Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container-dashboard">
        <header style="text-align: center; margin-bottom: 30px;">
            <h2 class="page-title">Update Status</h2>
            <p class="sub-title">Appointment ID: #<%= appId %></p>
        </header>

        <hr class="divider">

        <div class="status-card">
            <form action="UpdateStatusServlet" method="POST">
                <input type="hidden" name="appId" value="<%= appId %>">
                
                <p class="patient-info">Patient: <strong><%= patientName %></strong></p>
                
                <div class="form-group-status">
                    <label class="label-status">New Status:</label>
                    <select name="newStatus" class="select-status">
                        <option value="In Progress">In Progress</option>
                        <option value="Completed">Completed / Selesai</option>
                        <option value="Cancelled">Cancelled / Batal</option>
                        <option value="No Show">No Show (Pesakit Tak Datang)</option>
                    </select>
                </div>

                <div class="button-group-flex">
                    <button type="submit" class="btn-main" style="flex: 2;">Save Changes</button>
                    <button type="button" class="btn-secondary" onclick="history.back()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
