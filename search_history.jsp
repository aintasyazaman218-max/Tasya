<%-- 
    Document   : search_history
    Created on : 18 Jun 2026, 11:48:15 pm
    Author     : ASUS
--%>

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // SECURITY CHECK: Saja tambah keselamatan, pastikan hanya Doctor boleh akses
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient History Search</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container-dashboard" style="max-width: 1100px; margin: 40px auto; padding: 20px;">
            
            <header style="margin-bottom: 25px; text-align: center;">
                <h2 style="font-family: 'Playfair Display', serif; color: #213555; font-size: 2rem; margin: 0;">Global Patient History Search</h2>
                <p style="color: #86A789; margin-top: 5px; font-weight: 600;">Search and review past medical records of patients by name or email.</p>
            </header>

            <%
                // DIUBAH: Tukar dari searchEmail ke searchQuery untuk terima nama/emel
                String searchQuery = request.getParameter("searchQuery");
                if(searchQuery == null) searchQuery = "";
                searchQuery = searchQuery.trim();
            %>

            <form action="search_history.jsp" method="GET" style="margin-bottom: 30px; display: flex; gap: 10px;">
                <input type="text" name="searchQuery" value="<%= searchQuery %>" placeholder="Enter patient's name or email..." style="flex: 1; padding: 12px; border-radius: 6px; border: 1px solid #86A789; font-size: 1rem;" required>
                <button type="submit" class="btn-main" style="width: auto; padding: 0 25px; border-radius: 6px; background-color: #4F6F52; color: white; border: none; cursor: pointer; font-weight: bold;">Search Record</button>
            </form>

            <% if(!searchQuery.isEmpty()) { %>
                <h3 style="color: #4F6F52; margin-bottom: 15px;">Search Results For: <span style="color:#213555;"><%= searchQuery %></span></h3>
                
                <table style="width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.02);">
                    <thead>
                        <tr style="background-color: #213555; color: white; text-align: left;">
                            <th style="padding: 12px 15px;">VISIT DATE</th>
                            <th style="padding: 12px 15px;">PATIENT NAME (EMAIL)</th>
                            <th style="padding: 12px 15px;">DIAGNOSIS / NOTES</th>
                            <th style="padding: 12px 15px;">MEDICATIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = util.DBConnection.getConnection()) {
                            // DIUBAH: Query ditambah JOIN dengan table patients supaya boleh search pakai nama pesakit
                            String sql = "SELECT a.*, p.name AS pat_name, p.email AS pat_email " +
                                         "FROM appointments a " +
                                         "JOIN patients p ON a.patient_id = p.id " +
                                         "WHERE (p.name LIKE ? OR p.email = ?) AND a.status = 'Completed' " +
                                         "ORDER BY a.appointment_date DESC";
                            
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setString(1, "%" + searchQuery + "%"); // Guna LIKE untuk cari nama sebahagian
                            ps.setString(2, searchQuery);             // Guna direct match kalau input ialah emel tepat
                            ResultSet rs = ps.executeQuery();

                            boolean dataFound = false;
                            while(rs.next()) {
                                dataFound = true;
                                String date = rs.getString("appointment_date");
                                
                                // Tarik nama dan emel dari hasil JOIN table patients
                                String patientDisplayName = rs.getString("pat_name") + " (" + rs.getString("pat_email") + ")";
                                
                                String notes = "-";
                                String meds = "None";
                                
                                // Kekalkan logic asal kau yang cari column secara automatik (Dah ditambah baik)
                                ResultSetMetaData meta = rs.getMetaData();
                                int count = meta.getColumnCount();
                                for (int i = 1; i <= count; i++) {
                                    String colName = meta.getColumnName(i).toLowerCase();
                                    if (colName.contains("note") || colName.contains("reason") || colName.equals("notes") || colName.equals("doctor_notes")) {
                                        String val = rs.getString(i);
                                        if(val != null && !val.isEmpty()) {
                                            notes = val;
                                        }
                                    }
                                    if (colName.contains("med") || colName.contains("ubat") || colName.contains("prescription") || colName.equals("medications")) {
                                        String val = rs.getString(i);
                                        if(val != null && !val.isEmpty()) {
                                            meds = val;
                                        }
                                    }
                                }
                    %>
                            <tr style="border-bottom: 1px solid #F5EFE7;">
                                <td style="padding: 15px; font-weight: bold;"><%= date %></td>
                                <td style="padding: 15px; color: #4F6F52; font-weight: 600;"><%= patientDisplayName %></td>
                                <td style="padding: 15px; color: #333;"><%= notes.replace("\n", "<br>") %></td>
                                <td style="padding: 15px; font-weight: 600; color: #1E3A8A; white-space: pre-line;"><%= meds %></td>
                            </tr>
                    <%
                            }
                            if(!dataFound) {
                    %>
                            <tr><td colspan="4" style="padding: 30px; text-align: center; color: #86A789; font-style: italic;">No past records found for this patient name or email.</td></tr>
                    <%
                            }
                            rs.close(); ps.close();
                        } catch(Exception e) {
                    %>
                            <tr><td colspan="4" style="color: red; padding: 15px; text-align: center; font-weight: bold;">Search Error: <%= e.getMessage() %></td></tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <div style="text-align: center; margin-top: 30px;">
                <a href="doctor_dashboard.jsp" style="color: #4F6F52; text-decoration: none; font-weight: 700; font-size: 0.9rem;">
                    ← Back to Dashboard
                </a>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>