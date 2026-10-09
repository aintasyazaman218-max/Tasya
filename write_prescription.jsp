<%-- 
    Document   : write_prescription
    Created on : 12 May 2026, 1:07:47 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<%
    // 1. SECURITY CHECK: Hanya Doctor boleh masuk
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Doctor".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 2. AMBIL ID TEMU JANJI DARI URL
    String appId = request.getParameter("id"); // Ditukar dari appId ke id supaya match dengan link asal
    String patientName = "Unknown Patient";
    
    // Tarik nama pesakit secara dinamik daripada database menggunakan appId
    if (appId != null && !appId.trim().isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT p.name FROM appointments a JOIN patients p ON a.patient_id = p.id WHERE a.id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(appId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientName = rs.getString("name");
                    }
                }
            }
        } catch (Exception e) {
            patientName = "Error Loading Name";
        }
    } else {
        // Jika tiada ID dihantar, tendang balik ke list pesakit demi keselamatan data
        response.sendRedirect("view_assigned_patients.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Write Prescription | Clinic Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .treatment-card {
            background: #FBFBFB;
            border: 1px solid #F5EFE7;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
        }
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            font-weight: 700;
            color: #4F6F52;
            margin-bottom: 8px;
            font-size: 0.85rem;
            text-transform: uppercase;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #D2E3C8;
            border-radius: 8px;
            font-family: inherit;
            font-size: 1rem;
            box-sizing: border-box;
        }
        textarea:focus, input[type="text"]:focus {
            outline: none;
            border-color: #4F6F52;
            box-shadow: 0 0 0 3px rgba(79, 111, 82, 0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container-dashboard">
        <header style="text-align: center; margin-bottom: 30px;">
            <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2.2rem; margin-bottom: 5px;">Patient Treatment</h2>
            <p style="color: #86A789; font-weight: 600;">Currently Treating: <span style="color: #213555;"><%= patientName %></span></p>
        </header>

        <hr style="border: 1px solid #F5EFE7; margin-bottom: 30px;">

        <form action="SaveMedicalRecordServlet" method="POST">
            <input type="hidden" name="appId" value="<%= appId %>">

            <div class="treatment-card">
                <h3 style="color: #4F6F52; margin-top: 0; font-size: 1.1rem; margin-bottom: 20px; border-bottom: 2px solid #D2E3C8; padding-bottom: 10px;">
                    Diagnosis & Notes
                </h3>
                
                <div class="form-group">
                    <label>Diagnosis / Problem:</label>
                    <input type="text" name="diagnosis" placeholder="Contoh: Influenza A" required>
                </div>

                <div class="form-group">
                    <label>Doctor Notes:</label>
                    <textarea name="doctorNotes" rows="4" placeholder="Catatan tambahan tentang keadaan pesakit..."></textarea>
                </div>
            </div>

            <div class="treatment-card">
                <h3 style="color: #4F6F52; margin-top: 0; font-size: 1.1rem; margin-bottom: 20px; border-bottom: 2px solid #D2E3C8; padding-bottom: 10px;">
                    Medication Prescription
                </h3>
                
                <div class="form-group">
                    <label>Medication List & Dosage:</label>
                    <textarea name="medications" rows="6" placeholder="1. Paracetamol 500mg (2 biji, 3 kali sehari)&#10;2. Cough Syrup (10ml, 2 kali sehari)" required></textarea>
                </div>
            </div>

            <div style="display: flex; gap: 15px; justify-content: center; margin-top: 30px;">
                <button type="submit" class="btn-main" style="width: auto; padding: 15px 40px; background-color: #4F6F52; color: white; border: none; border-radius: 12px; cursor: pointer; font-weight: 700;">
                    Selesai & Simpan Rekod
                </button>
                <button type="reset" style="background: white; border: 1px solid #EF4444; color: #EF4444; padding: 15px 30px; border-radius: 12px; cursor: pointer; font-weight: 700;">
                    Reset Form
                </button>
            </div>
        </form>

        <div style="text-align: center; margin-top: 40px;">
            <a href="view_assigned_patients.jsp" style="color: #4F6F52; text-decoration: none; font-weight: 700; font-size: 0.9rem;">
                ← Back to Patient List
            </a>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>