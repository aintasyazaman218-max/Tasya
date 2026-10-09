<%-- 
    Document   : view_profile
    Created on : 12 May 2026, 12:38:04 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="util.DBConnection"%>

<%
    // 1. SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Patient".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    Integer patientId = (Integer) session.getAttribute("patientId");
    if (patientId == null) {
        response.sendRedirect("index.jsp?error=invalid");
        return; 
    }

    // 2. TARIK DATA PALING REALTIME DARI DATABASE
    String name = "", email = "", ic = "", phone = "", profilePic = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT * FROM patients WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, patientId);
        rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            ic = rs.getString("ic_number");
            phone = rs.getString("phone_number");
            profilePic = rs.getString("profile_pic");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (SQLException e) {}
    }

    // Set default avatar sekiranya rekod di DB kosong atau null
    if (profilePic == null || profilePic.isEmpty()) {
        profilePic = "https://cdn-icons-png.flaticon.com/128/16385/16385147.png"; 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Profile | Clinic Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .view-profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #4F6F52;
            margin-bottom: 15px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container-dashboard">
        
        <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h2 style="margin: 0; font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2rem;">My Profile</h2>
            <button class="btn-main" onclick="location.href='edit_profile.jsp'" style="width: auto; padding: 12px 25px;">
                Edit Profile
            </button>
        </header>

        <div style="background: #FBFBFB; border: 1px solid #F5EFE7; border-radius: 20px; padding: 40px; max-width: 800px; margin: 0 auto;">
            <div style="display: grid; grid-template-columns: 180px 1fr; gap: 40px; align-items: center;">
                
                <div style="text-align: center; border-right: 1px solid #E5E7EB; padding-right: 40px;">
                    <img src="<%= profilePic %>" alt="Profile Picture" class="view-profile-pic">
                    <p style="font-weight: 700; color: #4F6F52; margin: 0;">Verified Patient</p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px;">
                    <div>
                        <label style="display: block; font-size: 0.75rem; color: #86A789; font-weight: 700; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px;">Full Name</label>
                        <p style="font-size: 1.1rem; font-weight: 600; color: #213555; margin: 0;"><%= name != null ? name : "" %></p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.75rem; color: #86A789; font-weight: 700; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px;">Email Address</label>
                        <p style="font-size: 1.1rem; font-weight: 600; color: #213555; margin: 0;"><%= email != null ? email : "" %></p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.75rem; color: #86A789; font-weight: 700; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px;">No. IC</label>
                        <p style="font-size: 1.1rem; font-weight: 600; color: #213555; margin: 0;"><%= ic != null ? ic : "" %></p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.75rem; color: #86A789; font-weight: 700; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px;">Contact Number</label>
                        <p style="font-size: 1.1rem; font-weight: 600; color: #213555; margin: 0;"><%= phone != null ? phone : "" %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 40px;">
            <a href="patient_dashboard.jsp" style="color: #4F6F52; text-decoration: none; font-weight: 700; font-size: 0.9rem; padding: 10px 20px; border: 1px solid #D2E3C8; border-radius: 12px; transition: 0.3s;">
                ← Back to Dashboard
            </a>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>