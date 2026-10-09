<%-- 
    Document   : admin_dashboard
    Created on : 11 May 2026, 3:58:13 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="util.DBConnection"%>

<%
    // Dummy data untuk testing
    String email = "admin@clinic.com";
%> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard | Clinic Management System</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <script>
            // Dummy Action Logic - Simulasi untuk modul admin tanpa kacau database update
            function handleDummyAction(action, appointmentId) {
                alert("✨ [ADMIN LOG] Successfully " + action + "ed appointment ID: #" + appointmentId + "\nStatus simulation updated successfully!");
                location.reload();
            }
        </script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="container-dashboard">
            <header style="text-align: center; margin-bottom: 30px;">
                <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2.2rem;">Admin Control Center</h2>
                <p style="color: #86A789;">Welcome back, <strong>Master Admin</strong></p>
                <p style="font-size: 0.85rem; color: #607274;">Logged in as: <%= email %></p>
            </header>

            <hr style="border: 1px solid #F5EFE7; margin: 45px 0;">

            <section style="margin-bottom: 40px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h3 style="color: #4F6F52; border-left: 4px solid #4F6F52; padding-left: 10px; margin: 0;">👥 List of Registered Users</h3>
                    <button onclick="window.location.href='manage_users.jsp'" style="background: #4F6F52; color: white; border: none; padding: 8px 15px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 0.85rem;">+ Register Walk-In Patient</button>
                </div>
                
                <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                    <thead style="background: #4F6F52; color: white;">
                        <tr>
                            <th style="padding: 12px; text-align: left;">Patient ID</th>
                            <th style="padding: 12px; text-align: left;">Full Name</th>
                            <th style="padding: 12px; text-align: left;">No. IC (Password)</th>
                            <th style="padding: 12px; text-align: left;">Phone Number</th>
                            <th style="padding: 12px; text-align: left;">Email Address</th>
                            <th style="padding: 12px; text-align: center;">Account Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.sql.Connection connUsers = null;
                            java.sql.PreparedStatement psUsers = null;
                            java.sql.ResultSet rsUsers = null;
                            boolean hasUsers = false;

                            try {
                                connUsers = util.DBConnection.getConnection();
                                // Tarik semua senarai pesakit dalam database
                                String sqlUsers = "SELECT * FROM patients ORDER BY id DESC";
                                psUsers = connUsers.prepareStatement(sqlUsers);
                                rsUsers = psUsers.executeQuery();

                                while (rsUsers.next()) {
                                    hasUsers = true;
                                    String userEmail = rsUsers.getString("email");
                                    
                                    // Bezakan jenis user berdasarkan corak email atau data column
                                    String accountType = "Online (Self-Reg)";
                                    String badgeColor = "background: #E8F5E9; color: #2E7D32;"; // Hijau untuk self-reg
                                    
                                    if (userEmail != null && userEmail.contains("walkin_")) {
                                        accountType = "Walk-In (Admin-Reg)";
                                        badgeColor = "background: #E3F2FD; color: #1565C0;"; // Biru untuk walk-in
                                        userEmail = "<em>No Email Provided</em>"; // Paparan mesra alam kalau dia pakai dummy email walk-in
                                    }
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#PAT-<%= rsUsers.getInt("id") %></td>
                                        <td style="padding: 12px;"><%= rsUsers.getString("name") %></td>
                                        <td style="padding: 12px; font-family: monospace; color: #555;"><%= rsUsers.getString("ic_number") %></td>
                                        <td style="padding: 12px;"><%= rsUsers.getString("phone") %></td>
                                        <td style="padding: 12px;"><%= userEmail %></td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; <%= badgeColor %>">
                                                <%= accountType %>
                                            </span>
                                        </td>
                                    </tr>
                        <%
                                }

                                // Dummy data fallback kalau database betul-betul kosong krik-krik
                                if (!hasUsers) {
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#PAT-99</td>
                                        <td style="padding: 12px;">Nor Ain Natasya</td>
                                        <td style="padding: 12px; font-family: monospace;">05071811XXXX</td>
                                        <td style="padding: 12px;">011-2345678</td>
                                        <td style="padding: 12px;">natasya@email.com</td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; background: #E8F5E9; color: #2E7D32;">Online (Self-Reg)</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 12px; font-weight: 600;">#PAT-98</td>
                                        <td style="padding: 12px;">Pakcik Ahmad (Walk-in)</td>
                                        <td style="padding: 12px; font-family: monospace;">65010211XXXX</td>
                                        <td style="padding: 12px;">019-9876543</td>
                                        <td style="padding: 12px;"><em>No Email Provided</em></td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; background: #E3F2FD; color: #1565C0;">Walk-In (Admin-Reg)</span>
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (java.sql.SQLException e) {
                                e.printStackTrace();
                            } finally {
                                try { if (rsUsers != null) rsUsers.close(); if (psUsers != null) psUsers.close(); if (connUsers != null) connUsers.close(); } catch (java.sql.SQLException e) {}
                            }
                        %>
                    </tbody>
                </table>
            </section>

            <section>
                <h3 style="color: #4F6F52; border-left: 4px solid #4F6F52; padding-left: 10px; margin-bottom: 15px;">Live Appointment Requests</h3>
                <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                    <thead style="background: #4F6F52; color: white;">
                        <tr>
                            <th style="padding: 12px; text-align: left;">App ID</th>
                            <th style="padding: 12px; text-align: left;">Patient ID</th>
                            <th style="padding: 12px; text-align: left;">Date</th>
                            <th style="padding: 12px; text-align: left;">Time</th>
                            <th style="padding: 12px; text-align: left;">Reason</th>
                            <th style="padding: 12px; text-align: left;">Status</th>
                            <th style="padding: 12px; text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            boolean hasData = false;

                            try {
                                conn = DBConnection.getConnection();
                                // Tarik semua list booking daripada database secara live
                                String sql = "SELECT * FROM appointments ORDER BY id DESC";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    hasData = true;
                                    int appId = rs.getInt("id");
                                    String status = rs.getString("status");
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#<%= appId %></td>
                                        <td style="padding: 12px;">Patient #<%= rs.getInt("patient_id") %></td>
                                        <td style="padding: 12px;"><%= rs.getString("appointment_date") %></td>
                                        <td style="padding: 12px;"><%= rs.getString("appointment_time") %></td>
                                        <td style="padding: 12px;"><%= rs.getString("reason") %></td>
                                        <td style="padding: 12px;">
                                            <span style="font-weight: bold; color: <%= "Approved".equalsIgnoreCase(status) ? "#4F6F52" : "#D68100" %>;">
                                                <%= status %>
                                            </span>
                                        </td>
                                        <td style="padding: 12px; text-align: center; display: flex; gap: 5px; justify-content: center;">
                                            <form action="UpdateStatusServlet" method="POST" style="display:inline;">
                                                <input type="hidden" name="appId" value="<%= appId %>">
                                                <input type="hidden" name="newStatus" value="Approved">
                                                <button type="submit" style="background: #4F6F52; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">Approve</button>
                                            </form>

                                            <form action="UpdateStatusServlet" method="POST" style="display:inline;">
                                                <input type="hidden" name="appId" value="<%= appId %>">
                                                <input type="hidden" name="newStatus" value="Cancelled">
                                                <button type="submit" style="background: #bc4749; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">Reject</button>
                                            </form>
                                        </td>
                                    </tr>
                        <%
                                }

                                // Backup data kalau table database kosong melompong
                                if (!hasData) {
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#1001</td>
                                        <td style="padding: 12px;">Patient #1 (Ika Sabri)</td>
                                        <td style="padding: 12px;">2026-06-20</td>
                                        <td style="padding: 12px;">09:00</td>
                                        <td style="padding: 12px;">Fever and Flu symptoms</td>
                                        <td style="padding: 12px;"><span style="color: #D68100; font-weight: bold;">Pending</span></td>
                                        <td style="padding: 12px; text-align: center;">
                                            <button onclick="handleDummyAction('Approve', 1001)" style="background: #4F6F52; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">Approve</button>
                                            <button onclick="handleDummyAction('Reject', 1001)" style="background: #bc4749; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem; font-weight: 600; margin-left: 5px;">Reject</button>
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            } finally {
                                try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (SQLException e) {}
                            }
                        %>
                    </tbody>
                </table>
            </section>
        </div>   
        <jsp:include page="footer.jsp" />
    </body>
</html>