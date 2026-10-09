<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    // 1. SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // BACKUP CHECK: Pastikan kita dapat emel doktor tak kira apa nama attribute session dia
    String doctorEmail = (String) session.getAttribute("userEmail");
    if (doctorEmail == null) doctorEmail = (String) session.getAttribute("doctorEmail");
    if (doctorEmail == null) doctorEmail = (String) session.getAttribute("email");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Today's Patient List | Clinic Management System</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container-dashboard" style="max-width: 1100px; margin: 40px auto; padding: 20px;">
            
            <header style="text-align: center; margin-bottom: 25px;">
                <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2.2rem; margin: 0;">Today's Patient List</h2>
                <p style="color: #86A789; font-weight: 600; margin-top: 5px;">Manage and treat your assigned patients for today.</p>
            </header>
            
            <table style="width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 50px;">
                <thead>
                    <tr style="background-color: #4F6F52; color: white; text-align: left;">
                        <th style="padding: 15px;">TIME</th>
                        <th style="padding: 15px;">PATIENT NAME</th>
                        <th style="padding: 15px;">REASON TO VISIT</th>
                        <th style="padding: 15px;">ROOM NO</th>
                        <th style="padding: 15px; text-align: center;">ACTION</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = util.DBConnection.getConnection()) {
                        // FIX: Ditukar a.appointment_id kepada a.id, dan JOIN diselaraskan mengikut kesesuaian table pesakit
                        String sql = "SELECT a.id AS app_id, a.appointment_time, p.name AS patient_name, a.reason, a.room_no " +
                                     "FROM appointments a " +
                                     "JOIN patients p ON a.patient_id = p.id " +
                                     "WHERE a.doctor_email = ? AND a.appointment_date = CURDATE() AND a.status IN ('Approved', 'In Progress', 'Pending') " +
                                     "ORDER BY a.appointment_time ASC";
                        
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setString(1, doctorEmail);
                        ResultSet rs = ps.executeQuery();

                        boolean hasToday = false;
                        while (rs.next()) {
                            hasToday = true;
                            int appID = rs.getInt("app_id"); // Guna alias app_id yang selamat
                            String time = rs.getString("appointment_time");
                            String pName = rs.getString("patient_name");
                            String reason = rs.getString("reason");
                            String roomNo = rs.getString("room_no");
                %>
                    <tr style="border-bottom: 1px solid #F5EFE7;">
                        <td style="padding: 15px; font-weight: bold; color: #4F6F52;"><%= time %></td>
                        <td style="padding: 15px; font-weight: 600;"><%= pName %></td>
                        <td style="padding: 15px; color: #555;"><%= reason %></td>
                        <td style="padding: 15px; font-weight: bold; color: #1E3A8A;"><%= (roomNo != null && !roomNo.isEmpty()) ? roomNo : "-" %></td>
                        <td style="padding: 15px; text-align: center;">
                            <button class="btn-main" onclick="location.href='write_prescription.jsp?id=<%= appID %>'" style="background-color: #7A9D54; color: white; padding: 6px 15px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">Consult</button>
                        </td>
                    </tr>
                <%
                        }
                        if (!hasToday) {
                %>
                    <tr><td colspan="5" style="padding: 30px; text-align: center; color: #86A789; font-style: italic;">No patient appointments for today.</td></tr>
                <%
                        }
                        rs.close(); ps.close();
                    } catch (Exception e) { 
                        out.println("<tr><td colspan='5' style='color:red; padding:15px;'>Ralat Jadual 1: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace(); 
                    }
                %>
                </tbody>
            </table>

            <header style="text-align: center; margin-bottom: 25px;">
                <h2 style="font-family: 'Playfair Display', serif; color: #213555; font-size: 2rem; margin: 0;">Upcoming Appointments</h2>
                <p style="color: #86A789; font-weight: 600; margin-top: 5px;">Upcoming Appointments Schedule.</p>
            </header>

            <table style="width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 40px;">
                <thead>
                    <tr style="background-color: #213555; color: white; text-align: left;">
                        <th style="padding: 15px;">DATE</th>
                        <th style="padding: 15px;">TIME</th>
                        <th style="padding: 15px;">PATIENT NAME</th>
                        <th style="padding: 15px;">ROOM NO</th>
                        <th style="padding: 15px;">REASON</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = util.DBConnection.getConnection()) {
                        // FIX: Menyelaraskan JOIN condition kepada patient_id demi keselamatan data
                        String sql = "SELECT a.appointment_date, a.appointment_time, p.name AS patient_name, a.room_no, a.reason " +
                                     "FROM appointments a " +
                                     "JOIN patients p ON a.patient_id = p.id " +
                                     "WHERE a.doctor_email = ? AND a.appointment_date > CURDATE() AND a.status IN ('Approved', 'Pending') " +
                                     "ORDER BY a.appointment_date ASC, a.appointment_time ASC";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setString(1, doctorEmail);
                        ResultSet rs = ps.executeQuery();

                        boolean hasUpcoming = false;
                        while (rs.next()) {
                            hasUpcoming = true;
                            String date = rs.getString("appointment_date");
                            String time = rs.getString("appointment_time");
                            String pName = rs.getString("patient_name");
                            String roomNo = rs.getString("room_no");
                            String reason = rs.getString("reason");
                %>
                    <tr style="border-bottom: 1px solid #F5EFE7;">
                        <td style="padding: 15px; font-weight: bold; color: #213555;"><%= date %></td>
                        <td style="padding: 15px; color: #4F6F52; font-weight: bold;"><%= time %></td>
                        <td style="padding: 15px; font-weight: 600;"><%= pName %></td>
                        <td style="padding: 15px; font-weight: bold; color: #4F6F52;"><%= (roomNo != null && !roomNo.isEmpty()) ? roomNo : "Not Assigned" %></td>
                        <td style="padding: 15px; color: #666;"><%= reason %></td>
                    </tr>
                <%
                        }
                        if (!hasUpcoming) {
                %>
                        <tr><td colspan="5" style="padding: 30px; text-align: center; color: #86A789; font-style: italic;">No upcoming appointments.</td></tr>
                <%
                        }
                        rs.close(); ps.close();
                    } catch (Exception e) { 
                        out.println("<tr><td colspan='5' style='color:red; padding:15px;'>Ralat Jadual 2: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace(); 
                    }
                %>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 30px;">
                <a href="doctor_dashboard.jsp" style="text-decoration: none; color: #4F6F52; font-weight: bold;">← Back to Dashboard</a>
            </div>

        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>