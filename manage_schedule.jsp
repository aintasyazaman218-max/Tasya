<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.DBConnection, java.util.*"%>
<%
    // 1. SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 2. RETRIEVE EMAIL (Ditambah fallback sekiranya attribute name berbeza)
    String email = (String) session.getAttribute("userEmail");
    if (email == null) email = (String) session.getAttribute("doctorEmail");
    if (email == null) email = (String) session.getAttribute("email");

    // 3. RETRIEVE CURRENT STATUS FOR TODAY
    String currentStatus = "OFF DUTY";
    if (email != null) {
        try (Connection conn = DBConnection.getConnection()) {
            String statusSql = "SELECT status FROM doctor_attendance WHERE doctor_email = ? AND work_date = CURDATE()";
            try (PreparedStatement ps = conn.prepareStatement(statusSql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if(rs.next()) {
                        currentStatus = rs.getString("status");
                    }
                }
            }
            session.setAttribute("currentStatus", currentStatus);
        } catch(Exception e) { 
            e.printStackTrace(); 
        }
    }
%>
<jsp:include page="header.jsp" />

<div class="container-dashboard">
    <header style="text-align: center; margin-bottom: 30px;">
        <h2 style="margin-bottom: 5px;">Doctor Shift & Attendance Center</h2>
        <p style="color: #86A789; font-weight: 600;">Logged in: <span style="color: #213555;"><%= (email != null) ? email : "Session Kosong!" %></span></p>
    </header>

    <% if (request.getParameter("success") != null) { %>
        <div class="status-badge status-confirmed" style="text-align: center; display: block; padding: 10px; margin-bottom: 20px;">
            Weekly Schedule successfully updated in Database!
        </div>
    <% } %>

    <section class="status-card" style="max-width: 100%; margin-bottom: 30px; background: #FBFBFB;">
        <h3 style="color: #4F6F52; margin-top: 0; margin-bottom: 20px; border-left: 4px solid #4F6F52; padding-left: 10px;">⚙️ Configure Weekly Working Hours</h3>
        <form action="SaveScheduleServlet" method="POST">
            
            <%
                Map<String, String[]> savedScheds = new HashMap<>();
                if (email != null) {
                    try (Connection conn = DBConnection.getConnection()) {
                        String getSched = "SELECT day_of_week, start_time, end_time FROM doctor_schedules WHERE doctor_email = ?";
                        try (PreparedStatement ps = conn.prepareStatement(getSched)) {
                            ps.setString(1, email);
                            try (ResultSet rs = ps.executeQuery()) {
                                while(rs.next()){
                                    String rawStart = rs.getString("start_time");
                                    String rawEnd = rs.getString("end_time");
                                    
                                    // Safe Substring Check: Elak crash kalau string kurang dari 5 character
                                    String startTime = (rawStart != null && rawStart.length() >= 5) ? rawStart.substring(0,5) : "09:00";
                                    String endTime = (rawEnd != null && rawEnd.length() >= 5) ? rawEnd.substring(0,5) : "17:00";
                                    
                                    savedScheds.put(rs.getString("day_of_week"), new String[]{startTime, endTime});
                                }
                            }
                        }
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                }

                String[] weekDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
                for (String day : weekDays) {
                    boolean hasData = savedScheds.containsKey(day);
                    String startVal = hasData ? savedScheds.get(day)[0] : "09:00";
                    String endVal = hasData ? savedScheds.get(day)[1] : "17:00";
                    String checkedStr = hasData ? "checked" : "";
            %>
            <div style="display: grid; grid-template-columns: 150px 100px 1fr 1fr; gap: 15px; align-items: center; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px dashed #eee;">
                <strong style="color: #213555;"><%= day %></strong>
                <label style="display:inline-flex; align-items:center; gap:5px; margin:0; text-transform:none;">
                    <input type="checkbox" name="<%= day %>_active" value="yes" style="width:auto; margin:0;" <%= checkedStr %>> Work
                </label>
                <div>
                    <span style="font-size:0.8rem; color:#86A789;">Start:</span>
                    <input type="time" name="<%= day %>_start" value="<%= startVal %>" style="margin:0; padding:5px;">
                </div>
                <div>
                    <span style="font-size:0.8rem; color:#86A789;">End:</span>
                    <input type="time" name="<%= day %>_end" value="<%= endVal %>" style="margin:0; padding:5px;">
                </div>
            </div>
            <% } %>
            
            <button type="submit" class="btn-main" style="margin-top: 15px; background-color: #4F6F52;">Save Weekly Schedule</button>
        </form>
    </section>

    <section class="status-card" style="max-width: 100%; background: #F0F4F8; margin-bottom: 30px;">
        <h3 style="color: #213555; margin-top: 0; margin-bottom: 20px;">⏱️ Daily Time Clock</h3>
        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px;">
            <div>
                <p style="margin: 0; color: #86A789; font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">Current Status</p>
                <p style="margin: 5px 0 0; font-size: 1.3rem; font-weight: 800; color: <%= "ON DUTY".equals(currentStatus) || "IN PROGRESS".equals(currentStatus) ? "#166534" : "#EF4444" %>;">
                    [<%= currentStatus %>]
                </p>
            </div>
            
            <form action="AttendanceServlet" method="POST" style="display: flex; gap: 15px; margin:0;">
                <button type="submit" name="action" value="in" class="btn-main" style="width: auto; padding: 12px 35px; background-color: #4F6F52;" <%= "ON DUTY".equals(currentStatus) || "IN PROGRESS".equals(currentStatus)?"disabled":"" %>>
                    Clock In
                </button>
                <button type="submit" name="action" value="out" class="btn-main" style="width: auto; padding: 12px 35px; background-color: #607274;" <%= !"ON DUTY".equals(currentStatus) && !"IN PROGRESS".equals(currentStatus)?"disabled":"" %>>
                    Clock Out
                </button>
            </form>
        </div>
    </section>

    <section>
        <h3 style="color: #4F6F52; margin-bottom: 15px; border-left: 4px solid #607274; padding-left: 10px;">📜 Weekly Attendance Logs (MySQL)</h3>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Clock In</th>
                    <th>Clock Out</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (email != null) {
                        try (Connection conn = DBConnection.getConnection()) {
                            String logSql = "SELECT work_date, clock_in, clock_out, status FROM doctor_attendance WHERE doctor_email = ? ORDER BY work_date DESC LIMIT 7";
                            try (PreparedStatement psLog = conn.prepareStatement(logSql)) {
                                psLog.setString(1, email);
                                try (ResultSet rsLog = psLog.executeQuery()) {
                                    
                                    boolean hasRows = false;
                                    while(rsLog.next()) {
                                        hasRows = true;
                                        java.sql.Time tIn = rsLog.getTime("clock_in");
                                        java.sql.Time tOut = rsLog.getTime("clock_out");
                                        
                                        String inTime = tIn != null ? tIn.toString() : "--:--";
                                        String outTime = tOut != null ? tOut.toString() : "--:--";
                %>
                                        <tr>
                                            <td style="font-weight: 600;"><%= rsLog.getDate("work_date") %></td>
                                            <td style="color: #166534; font-weight:bold;"><%= inTime %></td>
                                            <td style="color: #bc4749; font-weight:bold;"><%= outTime %></td>
                                            <td>
                                                <span class="status-badge" style="background: #E2E8F0; color: #1E40AF; padding: 3px 8px; border-radius: 4px;">
                                                    <%= rsLog.getString("status") %>
                                                </span>
                                            </td>
                                        </tr>
                <%
                                    }
                                    if(!hasRows) {
                %>
                                        <tr>
                                            <td colspan="4" style="text-align: center; padding: 30px; color: #86A789;">No attendance logs found in database.</td>
                                        </tr>
                <%
                                    }
                                }
                            }
                        } catch(Exception e) {
                            e.printStackTrace();
                %>
                            <tr><td colspan="4" style="color:red; text-align:center;">Error loading logs: <%= e.getMessage() %></td></tr>
                <%
                        }
                    } else {
                %>
                        <tr><td colspan="4" style="color:orange; text-align:center;">Error: Session email tidak dijumpai.</td></tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </section>
</div>

<jsp:include page="footer.jsp" />