<%-- 
    Document   : appointments
    Created on : 28 May 2026, 12:53:35 am
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Appointments | Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=1.2">
</head>
<body>
    
    <jsp:include page="header.jsp" />
    
    <div class="container-dashboard">
        
        <header class="dashboard-header">
            <h2>Appointment Management</h2>
        </header>

        <div class="filter-container">
            <div class="filter-group">
                <label>Filter by Doctor:</label>
                <select name="doctorFilter">
                    <option value="all">All Doctors</option>
                    <option value="dr_amir">Dr. Amir</option>
                    <option value="dr_sarah">Dr. Sarah</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Search Patient:</label>
                <input type="text" name="searchPatient" placeholder="Enter patient name or IC...">
            </div>
            <button type="button" class="btn-filter-search">Search & Filter</button>
        </div>

        <section class="activity-section" style="margin-bottom: 40px;">
            <h3 class="section-title-today">📅 Today's Appointments</h3>
            <table class="activity-table">
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Patient Name</th>
                        <th>Doctor</th>
                        <th>Reason / Triage</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>09:00 AM</td>
                        <td>Ahmad Zaki</td>
                        <td>Dr. Amir</td>
                        <td>Demam & Selesema</td>
                        <td><span class="status-badge status-confirmed">Confirmed</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminAppointmentServlet" method="POST">
                                    <input type="hidden" name="appointmentId" value="APT001">
                                    <input type="hidden" name="actionType" value="CANCEL">
                                    <button type="submit" class="btn-cancel">Cancel</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>11:30 AM</td>
                        <td>Siti Nurhaliza</td>
                        <td>Dr. Amir</td>
                        <td>Follow-up Checkup</td>
                        <td><span class="status-badge status-pending">Pending</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminAppointmentServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="APT002">
                                    <input type="hidden" name="actionType" value="CHECKIN">
                                    <button type="submit" class="btn-checkin">Check-In</button>
                                </form>
                                <form action="AdminAppointmentServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="APT002">
                                    <input type="hidden" name="actionType" value="CANCEL">
                                    <button type="submit" class="btn-cancel">Cancel</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </section>

        <section class="activity-section" style="margin-bottom: 40px;">
            <h3 class="section-title-upcoming">🚀 Upcoming Appointments</h3>
            <table class="activity-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Patient Name</th>
                        <th>Doctor</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2026-06-01</td>
                        <td>02:00 PM</td>
                        <td>Mhd Ridzuan</td>
                        <td>Dr. Amir</td>
                        <td><span class="status-badge status-confirmed">Confirmed</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminAppointmentServlet" method="POST">
                                    <input type="hidden" name="appointmentId" value="APT003">
                                    <input type="hidden" name="actionType" value="CANCEL">
                                    <button type="submit" class="btn-cancel">Cancel</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>2026-06-03</td>
                        <td>10:00 AM</td>
                        <td>Chong Wei</td>
                        <td>Dr. Amir</td>
                        <td><span class="status-badge status-pending">Pending</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminAppointmentServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="APT004">
                                    <input type="hidden" name="actionType" value="APPROVE">
                                    <button type="submit" class="btn-checkin">Approve</button>
                                </form>
                                <form action="AdminAppointmentServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="APT004">
                                    <input type="hidden" name="actionType" value="CANCEL">
                                    <button type="submit" class="btn-cancel">Cancel</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </section>

        <section class="activity-section">
            <h3 class="section-title-history">📜 Past History</h3>
            <table class="activity-table history-table-style">
                <thead>
                    <tr class="history-th-style">
                        <th>Date</th>
                        <th>Patient Name</th>
                        <th>Doctor</th>
                        <th>Status</th>
                        <th>Notes</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2026-05-20</td>
                        <td>Muthu Samy</td>
                        <td>Dr. Amir</td>
                        <td><span class="status-badge history-badge">Completed</span></td>
                        <td>Ubat batuk & MC 1 hari</td>
                    </tr>
                    <tr>
                        <td>2026-05-18</td>
                        <td>Ali Baba</td>
                        <td>Dr. Amir</td>
                        <td><span class="status-badge status-cancelled-custom">Cancelled</span></td>
                        <td>Patient request change date</td>
                    </tr>
                </tbody>
            </table>
        </section>

    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
