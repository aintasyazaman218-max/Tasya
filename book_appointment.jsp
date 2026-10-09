<%-- 
    Document   : book_appointment
    Created on : 12 May 2026, 12:42:24 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%> <%-- Pastikan laluan package DBConnection kau betul --%>

<!DOCTYPE html>
<%
    // 1. SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Patient".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Appointment | Clinic Management System</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container-dashboard">
            <header>
                <h2 style="color: #4F6F52;">Book New Appointment</h2>
                <p style="text-align:center; color: #86A789;">Sila isi butiran di bawah untuk menempah slot anda.</p>
            </header>

            <div style="background-color: #D2E3C8; padding: 15px; border-radius: 12px; margin: 20px auto; max-width: 800px; border-left: 5px solid #4F6F52; font-size: 0.9rem;">
                <p style="margin: 0; color: #213555; line-height: 1.5;">
                    <strong>🕒 Reminder / Peringatan:</strong><br>
                    Patients must arrive at the clinic at least 15 minutes before the appointment time to ensure a smooth process.<br>
                    <span style="font-style: italic; opacity: 0.8;">Pesakit kena tiba di klinik sekurang-kurangnya 15 minit sebelum masa temu janji. Ini untuk memastikan temu janji anda berjalan dengan lancar.</span>
                </p>
            </div>

            <hr style="border: 1px solid #F5EFE7; margin: 20px 0;">

            <form action="BookAppointmentServlet" method="POST" style="max-width: 800px; margin: 0 auto;">
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                    <div>
                        <label style="font-weight: 600; color: #4F6F52;">1. Choose Date</label>
                        <input type="date" name="appDate" required style="width: 100%; padding: 10px; border: 2px solid #F5EFE7; border-radius: 10px;">
                    </div>

                    <div>
                        <label style="font-weight: 600; color: #4F6F52;">2. Choose Time Slot</label>
                        <select name="appTime" id="appTime" required style="width: 100%; padding: 10px; border: 2px solid #F5EFE7; border-radius: 10px;">
                            <option value="" disabled selected>-- Select Time --</option>
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="10:00 AM">10:00 AM</option>
                            <option value="11:00 AM">11:00 AM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="03:00 PM">03:00 PM</option>
                        </select>
                    </div>
                </div>

                <label style="font-weight: 600; color: #4F6F52;">3. Choose Available Doctor</label>
                <%-- Tukar name ke "doctorEmail" supaya simpan emel doktor, bukan sekadar nama --%>
                <select name="doctorEmail" id="doctor" required style="width: 100%; padding: 10px; border: 2px solid #F5EFE7; border-radius: 10px; margin-bottom: 20px;">
                    <option value="" disabled selected>-- Select Available Doctor --</option>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = DBConnection.getConnection();
                            String sql = "SELECT email, name FROM doctors";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            while(rs.next()) {
                    %>
                                <option value="<%= rs.getString("email") %>"><%= rs.getString("name") %></option>
                    <%
                            }
                        } catch(Exception e) {
                            out.println("<option value=''>Error loading doctors: " + e.getMessage() + "</option>");
                        } finally {
                            if(rs != null) rs.close();
                            if(ps != null) ps.close();
                            if(conn != null) conn.close();
                        }
                    %>
                </select>

                <label style="font-weight: 600; color: #4F6F52;">4. Reason for Visit / Symptoms</label>
                <textarea name="reason" rows="4" placeholder="e.g. Fever, Cough, or Medical Checkup" required
                    style="width: 100%; padding: 12px; border: 2px solid #F5EFE7; border-radius: 10px; margin-bottom: 20px; font-family: inherit;"></textarea>

                <div style="display: flex; gap: 15px; margin-top: 10px;">
                    <button type="submit" class="btn-main" style="flex: 2;">Confirm Booking</button>
                    <button type="reset" style="background: none; border: 1px solid #D8D3CC; color: #86A789; border-radius: 10px; padding: 10px 20px; cursor: pointer; flex: 1;">Clear Form</button>
                </div>
            </form>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>