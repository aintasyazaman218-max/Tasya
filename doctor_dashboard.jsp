<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    // SECURITY CHECK: Pastikan hanya Doktor yang sah boleh masuk
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    String doctorEmail = (String) session.getAttribute("userEmail");
    String doctorName = (String) session.getAttribute("userName");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Dashboard | Clinic Management System</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <!-- Include navigasi menu atas doktor -->
        <jsp:include page="header.jsp" />

        <div class="container-dashboard" style="max-width: 1150px; margin: 40px auto; padding: 20px;">
            
            <!-- Banner Aluan Doktor -->
            <header style="text-align: center; margin-bottom: 35px;">
                <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2.3rem; margin-bottom: 5px;">
                    Welcome, <%= (doctorName != null) ? doctorName : "Doctor" %>
                </h2>
                <div style="font-weight: bold; color: #4F6F52; font-size: 0.9rem;">
                    Duty Status: <span style="color: #166534; background: #DCFCE7; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem;">ONLINE (LIVE MODE)</span>
                </div>
            </header>

            <!-- Navigation Tabs Section -->
            <div style="margin-bottom: 35px;">
                <h3 style="color: #213555; font-size: 1.1rem; margin-bottom: 12px;">| Doctor Navigation Tabs</h3>
                <div style="display: flex; gap: 12px;">
                    <button class="btn-main" onclick="location.href='view_assigned_patients.jsp'" style="width: auto; background-color: #4F6F52; padding: 10px 22px; font-size: 0.85rem; border-radius: 6px; font-weight: 600; color: white; border: none; cursor: pointer;">
                        👥 View My Patients & Upcoming
                    </button>
                    <button class="btn-main" onclick="location.href='search_history.jsp'" style="width: auto; background-color: #213555; padding: 10px 22px; font-size: 0.85rem; border-radius: 6px; font-weight: 600; color: white; border: none; cursor: pointer;">
                        🔍 Search Patients History
                    </button>
                </div>
            </div>

            <!-- JADUAL UTAMA: Today's Active Workload -->
            <section class="activity-section">
                <h3 style="color: #213555; font-size: 1.1rem; margin-bottom: 15px;">| Today's Active Workload</h3>
                <table style="width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.03);">
                    <thead>
                        <tr style="background-color: #4F6F52; color: white; text-align: left;">
                            <th style="padding: 15px;">TIME</th>
                            <th style="padding: 15px;">PATIENT NAME</th>
                            <th style="padding: 15px;">ROOM NO</th>
                            <th style="padding: 15px;">REASON</th>
                            <th style="padding: 15px;">STATUS</th>
                            <th style="padding: 15px; text-align: center;">ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = util.DBConnection.getConnection()) {
                            // Penapisan Bersih: Hanya tunjuk permohonan aktif hari ini yang belum selesai dirawat
                            String sql = "SELECT a.id, a.appointment_time, p.name AS patient_name, a.room_no, a.reason, a.status " +
                                         "FROM appointments a " +
                                         "JOIN patients p ON a.patient_email = p.email " +
                                         "WHERE a.doctor_email = ? AND a.appointment_date = CURDATE() AND a.status IN ('Approved', 'Pending', 'In Progress') " +
                                         "ORDER BY a.appointment_time ASC";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setString(1, doctorEmail);
                            ResultSet rs = ps.executeQuery();

                            boolean hasToday = false;
                            while (rs.next()) {
                                hasToday = true;
                                int appID = rs.getInt("id");
                                String time = rs.getString("appointment_time");
                                String pName = rs.getString("patient_name");
                                String roomNo = rs.getString("room_no");
                                String reason = rs.getString("reason");
                                String status = rs.getString("status");
                                
                                // Tukar paparan visual status 'Approved' kepada 'Pending' biar seragam
                                if("Approved".equalsIgnoreCase(status)) {
                                    status = "Pending";
                                }
                                
                                // Jika dalam database bertulis 'Patient Absent', tukar ke perkataan formal 'Absent'
                                if("Patient Absent".equalsIgnoreCase(status)) {
                                    status = "Absent";
                                }
                    %>
                        <tr style="border-bottom: 1px solid #F5EFE7;">
                            <td style="padding: 15px; font-weight: bold; color: #4F6F52;"><%= time %></td>
                            <td style="padding: 15px; font-weight: 600; color: #213555;"><%= pName %></td>
                            <td style="padding: 15px; font-weight: bold; color: #1E3A8A;"><%= (roomNo != null && !roomNo.equals("Not Assigned")) ? roomNo : "Not Assigned" %></td>
                            <td style="padding: 15px; color: #555;"><%= reason %></td>
                            <td style="padding: 15px;">
                                <span style="background: #FFF2CC; color: #B78103; padding: 5px 12px; border-radius: 6px; font-weight: bold; font-size: 0.8rem; display: inline-block;">
                                    <%= status %>
                                </span>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <!-- Butang bertukar wajah menjadi 'Consult' yang kemas & profesional -->
                                <button class="btn-main" onclick="location.href='write_prescription.jsp?id=<%= appID %>'" style="background-color: #4F6F52; color: white; padding: 7px 16px; border: none; border-radius: 5px; font-size: 0.8rem; font-weight: bold; cursor: pointer;">
                                    Consult
                                </button>
                            </td>
                        </tr>
                    <%
                            }
                            if (!hasToday) {
                    %>
                        <tr>
                            <td colspan="6" style="padding: 40px; text-align: center; color: #86A789; font-style: italic; font-size: 0.95rem;">
                                No active workload or pending patients for today.
                            </td>
                        </tr>
                    <%
                            }
                            rs.close(); ps.close();
                        } catch (Exception e) { 
                    %>
                        <tr><td colspan="6" style="color: red; padding: 15px; text-align: center; font-weight: bold;">Ralat Paparan: <%= e.getMessage() %></td></tr>
                    <% } %>
                    </tbody>
                </table>
            </section>

        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>