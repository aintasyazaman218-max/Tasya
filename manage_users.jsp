<%-- 
    Document   : manage_users
    Created on : 12 May 2026, 7:39:46 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.DBConnection"%>
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
    <title>Manage Users | Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    
    <jsp:include page="header.jsp"/>
    
    <div class="container-dashboard">
        
        <header class="dashboard-header" style="margin-bottom: 25px;">
            <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52;">User Management Portal</h2>
        </header>
        
        <div id="detailsModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
            <div style="background: white; padding: 25px; border-radius: 8px; width: 450px; max-width: 90%; box-shadow: 0px 4px 10px rgba(0,0,0,0.3); position: relative;">
                <h3 id="modalTitle" style="margin-top: 0; color: #2E5A44; border-bottom: 2px solid #2E5A44; padding-bottom: 10px;">User Details</h3>
                <div id="modalBody" style="margin-top: 15px; font-size: 0.95rem; line-height: 1.6;">
                    </div>
                <div style="text-align: right; margin-top: 20px;">
                    <button onclick="closeModal()" style="background: #666; color: white; border: none; padding: 6px 15px; border-radius: 4px; cursor: pointer;">Close</button>
                </div>
            </div>
        </div>

        <script>
        // FUNCTION 1: POP UP CONFIRMATION SEBELUM DELETE
        function confirmDelete(role, id, name) {
            let text = "Adakah anda pasti untuk memadam " + role + ": " + name.toUpperCase() + "?";
            if (confirm(text) == true) {
                // Hantar request ke servlet pemadam (DeleteUserServlet) beserta ID dan Role
                window.location.href = "DeleteUserServlet?role=" + role + "&id=" + id;
            }
        }

        // FUNCTION 2: POP UP MODAL UNTUK VIEW DETAILS secara dynamic
        function viewDetails(role, id, name) {
            document.getElementById("modalTitle").innerText = role + " Detail Center";
            let bodyContent = "";

            if(role === 'Patient') {
                bodyContent = `
                    <strong>Full Name:</strong> \${name.toUpperCase()}<br>
                    <strong>ID No:</strong> #PAT-\${id}<br><br>
                    <span style="color:#2E5A44; font-weight:bold;">[ Clinical Records ]</span><br>
                    <strong>Appointment History:</strong> 18-06-2026 (Completed), 22-06-2026 (Upcoming)<br>
                    <strong>Purpose of Visit:</strong> Demam panas dan selesema berpanjangan.
                `;
            } else {
                bodyContent = `
                    <strong>Doctor Name:</strong> \${name.toUpperCase()}<br>
                    <strong>Email Address:</strong> \${id == 99 ? 'amin@clinic.com' : 'live_doctor@clinic.com'}<br><br>
                    <span style="color:#2E5A44; font-weight:bold;">[ Shift & Attendance ]</span><br>
                    <strong>Working Schedule:</strong> Isnin - Jumaat (8:00 AM - 5:00 PM)<br>
                    <strong>Clock-In Time:</strong> 07:54 AM (On Time)<br>
                    <strong>Clock-Out Time:</strong> 05:03 PM
                `;
            }

            document.getElementById("modalBody").innerHTML = bodyContent;
            document.getElementById("detailsModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("detailsModal").style.display = "none";
        }
        </script>
        <section class="activity-section" style="margin-bottom: 40px;">
            <h3 style="color: #4F6F52; border-left: 4px solid #4F6F52; padding-left: 10px; margin-bottom: 15px;">List of Registered Users</h3>
            <table class="activity-table" style="width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                <thead style="background: #4F6F52; color: white;">
                    <tr>
                        <th style="padding: 12px; text-align: left;">Patient ID</th>
                        <th style="padding: 12px; text-align: left;">Full Name</th>
                        <th style="padding: 12px; text-align: left;">No. IC (Password)</th>
                        <th style="padding: 12px; text-align: left;">No. Phone</th>
                        <th style="padding: 12px; text-align: left;">Email Address</th>
                        <th style="padding: 12px; text-align: center;">User Role</th> </tr>
                </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement psPatient = null;
                            ResultSet rsPatient = null;

                            try {
                                conn = DBConnection.getConnection();

                                // 1. TARIK DATA PATIENTS
                                String sqlPatient = "SELECT id, name, ic_number, phone_number, email FROM patients ORDER BY id DESC";
                                psPatient = conn.prepareStatement(sqlPatient);
                                rsPatient = psPatient.executeQuery();

                                while(rsPatient.next()) {
                                    int pId = rsPatient.getInt("id");
                                    String pName = rsPatient.getString("name");
                                    String pIc = rsPatient.getString("ic_number");
                                    String pPhone = rsPatient.getString("phone_number");
                                    String pEmail = rsPatient.getString("email");

                                    String displayEmail = pEmail;
                                    String userRoleBadge = "Patient (Online)";

                                    if (pEmail == null || pEmail.trim().isEmpty() || pEmail.contains("walkin_")) {
                                        displayEmail = "<em style='color: #999;'>No Email (Walk-In)</em>";
                                        userRoleBadge = "Patient (Walk-In)";
                                    }
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#PAT-<%= pId %></td>
                                        <td style="padding: 12px;"><%= pName != null ? pName.toUpperCase() : "-" %></td>
                                        <td style="padding: 12px; font-family: monospace;"><%= pIc != null ? pIc : "-" %></td>
                                        <td style="padding: 12px;"><%= pPhone != null ? pPhone : "-" %></td>
                                        <td style="padding: 12px;"><%= displayEmail %></td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background:#e8f5e9; color:#1b5e20;">
                                                <%= userRoleBadge %>
                                            </span>
                                        </td>
                                        <td style="padding: 12px; text-align: center;">
                                            <button onclick="viewDetails('Patient', '<%= pId %>', '<%= pName %>')" style="background: #2E5A44; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; margin-right: 5px;">View</button>
                                            <button onclick="confirmDelete('Patient', '<%= pId %>', '<%= pName %>')" style="background: #c62828; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">Delete</button>
                                        </td>
                                    </tr>
                        <%
                                }
                                rsPatient.close();
                                psPatient.close();

                                // 2. TARIK DATA DOCTORS
                                PreparedStatement psDoc = null;
                                ResultSet rsDoc = null;
                                try {
                                    String sqlDoc = "SELECT id, name, ic_number, phone_number, email FROM doctors ORDER BY id DESC";
                                    psDoc = conn.prepareStatement(sqlDoc);
                                    rsDoc = psDoc.executeQuery();

                                    while(rsDoc.next()) {
                                        int dId = rsDoc.getInt("id");
                                        String dName = rsDoc.getString("name");
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#DOC-<%= dId %></td>
                                        <td style="padding: 12px;"><%= dName.toUpperCase() %></td>
                                        <td style="padding: 12px; font-family: monospace;"><%= rsDoc.getString("ic_number") %></td>
                                        <td style="padding: 12px;"><%= rsDoc.getString("phone_number") %></td>
                                        <td style="padding: 12px;"><%= rsDoc.getString("email") %></td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background:#e8eaf6; color:#1a237e;">Doctor</span>
                                        </td>
                                        <td style="padding: 12px; text-align: center;">
                                            <button onclick="viewDetails('Doctor', '<%= dId %>', '<%= dName %>')" style="background: #2E5A44; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; margin-right: 5px;">View</button>
                                            <button onclick="confirmDelete('Doctor', '<%= dId %>', '<%= dName %>')" style="background: #c62828; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">Delete</button>
                                        </td>
                                    </tr>
                        <%
                                    }
                                } catch (Exception eDoc) {
                                    // Mockup data doctor sementara kalau kawan kau belum siapkan table doctors
                        %>
                                    <tr style="border-bottom: 1px solid #F5EFE7;">
                                        <td style="padding: 12px; font-weight: 600;">#DOC-99</td>
                                        <td style="padding: 12px;">DR. MOHD AMIN (MOCKUP)</td>
                                        <td style="padding: 12px; font-family: monospace;">880420-11-5531</td>
                                        <td style="padding: 12px;">012-3456789</td>
                                        <td style="padding: 12px;">amin@clinic.com</td>
                                        <td style="padding: 12px; text-align: center;">
                                            <span style="padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; background:#e8eaf6; color:#1a237e;">Doctor</span>
                                        </td>
                                        <td style="padding: 12px; text-align: center;">
                                            <button onclick="viewDetails('Doctor', '99', 'DR. MOHD AMIN')" style="background: #2E5A44; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; margin-right: 5px;">View</button>
                                            <button onclick="confirmDelete('Doctor', '99', 'DR. MOHD AMIN')" style="background: #c62828; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">Delete</button>
                                        </td>
                                    </tr>
                        <%
                                } finally {
                                    if (rsDoc != null) rsDoc.close();
                                    if (psDoc != null) psDoc.close();
                                }
                            } catch(Exception e) {
                                System.out.println("Error: " + e.getMessage());
                            } finally {
                                if (conn != null) conn.close();
                            }
                        %>
                    </tbody>
            </table>
        </section>

        <section class="form-section">
            <h3 style="color: #4F6F52; border-left: 4px solid #4F6F52; padding-left: 10px; margin-bottom: 15px;">Walk-In Patient Register</h3>
            
            <form action="AdminRegisterServlet" method="POST" class="styled-form">
                <fieldset class="form-fieldset" style="border: 1px solid #4F6F52; padding: 20px; border-radius: 8px;">
                    <legend style="color: #4F6F52; font-weight: bold; padding: 0 10px;">Registration Information</legend>
                    
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 600;">Full Name:</label>
                        <input type="text" name="pName" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 600;">No. IC (Will auto-set as login password):</label>
                        <input type="text" name="pIC" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 600;">No. Phone:</label>
                        <input type="text" name="pPhone" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 600;">Patient Email (Optional - Leave blank for Walk-In):</label>
                        <input type="email" name="uEmail" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                        <span class="form-hint" style="font-size: 0.8rem; color: #666; display: block; margin-top: 3px;">*Leave empty if the patient doesn't have an email address.</span>
                    </div>

                    <input type="hidden" name="uRole" value="Patient">

                    <div class="form-actions" style="margin-top: 20px;">
                        <button type="submit" class="btn-submit" style="background: #4F6F52; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: bold;">Register Patient</button>
                    </div>
                </fieldset>
            </form>
        </section>
        
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>