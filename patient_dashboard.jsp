<%-- 
    Document   : patient_dashboard
    Created on : 11 May 2026, 3:59:49 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="util.DBConnection"%>

<!DOCTYPE html>
<%
    // 1. SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Patient".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Ambil data session yang di-set oleh LoginServlet baru
    Integer patientId = (Integer) session.getAttribute("patientId");
    String patientName = (String) session.getAttribute("patientName");
    String patientEmail = (String) session.getAttribute("patientEmail");

    if (patientId == null) {
        response.sendRedirect("index.jsp?error=invalid");
        return; 
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Dashboard | Clinic Management System</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <style>
            /* REKA BENTUK GRID BARU UNTUK KOTAK PROMOSI */
            .promo-slider-container {
                max-width: 1000px;
                margin: 0 auto 40px auto;
                box-shadow: 0 10px 25px rgba(79, 111, 82, 0.12);
                border-radius: 18px;
                overflow: hidden;
                background-color: #fff;
                display: grid;
                grid-template-columns: 1.2fr 1fr;
                border: 1px solid #F5EFE7;
            }

            /* Sisi Kiri - Kandungan Teks */
            .promo-text-side {
                padding: 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                background: linear-gradient(135deg, #FBFBFB 0%, #F5EFE7 100%);
            }

            .promo-badge {
                background-color: #4F6F52;
                color: white;
                padding: 6px 16px;
                border-radius: 50px;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                width: fit-content;
                margin-bottom: 15px;
                letter-spacing: 0.5px;
            }

            .promo-title {
                font-family: 'Playfair Display', serif;
                color: #213555;
                font-size: 1.8rem;
                margin: 0 0 15px 0;
                line-height: 1.3;
            }

            .promo-desc {
                color: #607274;
                font-size: 0.95rem;
                line-height: 1.6;
                margin-bottom: 20px;
            }

            .promo-features {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .promo-features li {
                color: #4F6F52;
                font-weight: 600;
                font-size: 0.9rem;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            /* Sisi Kanan - Paparan Gambar/Poster */
            .promo-media-side {
                background-color: #fff;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                border-left: 1px solid #EFECE9;
            }

            .slider-image {
                width: 100%;
                max-height: 300px;
                object-fit: contain;
                display: block;
                cursor: pointer;
                transition: transform 0.4s ease;
            }

            .slider-image:hover {
                transform: scale(1.03);
            }

            .fade {
                animation-name: fadeAnim;
                animation-duration: 1s;
            }

            @keyframes fadeAnim {
                from { opacity: 0.4; } 
                to { opacity: 1; }
            }

            .slider-dot {
                height: 8px;
                width: 8px;
                margin: 0 4px;
                background-color: #D8D3CC;
                border-radius: 50%;
                display: inline-block;
                transition: all 0.4s ease;
            }

            .slider-dot.active {
                background-color: #4F6F52;
                width: 22px;
                border-radius: 10px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container-dashboard">
            <header>
                <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52;">Patient Portal</h2>
                <h1>Selamat Datang, <%= patientName %>!</h1>
                <p>ID Pesakit Anda: #PAT-<%= patientId %></p>
            </header>
           
            <hr style="border: 1px solid #F5EFE7; margin: 20px 0;">
            
            <main>
                <%
                    String statusParam = request.getParameter("status");
                    if ("booked".equals(statusParam)) {
                %>
                    <div style="background-color: #D4EDDA; color: #155724; padding: 15px; border-radius: 10px; margin-bottom: 20px; font-weight: 600; text-align: center;">
                        🎉 Appointment successfully booked! It is currently pending review.
                    </div>
                <% } %>

                <div class="promo-slider-container">
                    <div class="promo-text-side">
                        <div class="promo-badge" id="promoBadge">Exclusive Service</div>
                        <h2 class="promo-title" id="promoTitle">Loading Offers...</h2>
                        <p class="promo-desc" id="promoDesc">Please wait while we fetch our latest promotions for you.</p>
                        <ul class="promo-features" id="promoFeatures">
                            </ul>
                    </div>

                    <div class="promo-media-side">
                        <div class="promo-slide fade">
                            <a href="https://www.instagram.com/p/DThIMeck0LX/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==" target="_blank">
                                <img src="image/poster1.png" alt="Iklan Klinik 1" class="slider-image">
                            </a>
                        </div>

                        <div class="promo-slide fade">
                            <a href="https://www.instagram.com/p/DTjXk-2E2P1/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==" target="_blank">
                                <img src="image/poster2.png" alt="Iklan Klinik 2" class="slider-image">
                            </a>
                        </div>

                        <div class="promo-slide fade">
                            <a href="https://www.instagram.com/p/DYPVm3cGnO_/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==" target="_blank">
                                <img src="image/poster3.png" alt="Iklan Klinik 3" class="slider-image">
                            </a>
                        </div>

                        <div style="text-align:center; margin-top: 15px;">
                            <span class="slider-dot"></span> 
                            <span class="slider-dot"></span> 
                            <span class="slider-dot"></span> 
                        </div>
                    </div>
                </div>

                <section id="appointments">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <h3 style="font-family: 'Playfair Display', serif; color: #4F6F52; margin: 0;">My Appointment History</h3>
                        <button class="btn-main" onclick="location.href='book_appointment.jsp'" style="width: auto; padding: 10px 20px;">+ Book New</button>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Reason / Symptoms</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (patientId != null) {
                                    Connection conn = null;
                                    PreparedStatement ps = null;
                                    ResultSet rs = null;
                                    boolean hasData = false;

                                    try {
                                        conn = DBConnection.getConnection();
                                        String sql = "SELECT * FROM appointments WHERE patient_id = ? ORDER BY appointment_date DESC, appointment_time DESC";
                                        ps = conn.prepareStatement(sql);
                                        ps.setInt(1, patientId);
                                        rs = ps.executeQuery();

                                        while (rs.next()) {
                                            hasData = true;
                                            String appStatus = rs.getString("status");
                                            
                                            String badgeClass = "status-pending";
                                            if ("Approved".equalsIgnoreCase(appStatus)) badgeClass = "status-confirmed";
                                            else if ("Cancelled".equalsIgnoreCase(appStatus)) badgeClass = "status-cancelled";
                            %>
                                            <tr>
                                                <td><%= rs.getString("appointment_date") %></td>
                                                <td><%= rs.getString("appointment_time") %></td>
                                                <td><%= rs.getString("reason") %></td>
                                                <td>
                                                    <span class="status-badge <%= badgeClass %>">
                                                        <%= appStatus %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if ("Pending".equalsIgnoreCase(appStatus)) { %>
                                                        <button class="btn-cancel" onclick="if(confirm('Are you sure you want to cancel?')) { location.href='CancelAppointmentServlet?id=<%= rs.getInt("id") %>'; }">Cancel</button>
                                                    <% } else { %>
                                                        <span style="color: #bbb; font-size: 0.85rem;">No Action</span>
                                                    <% } %>
                                                </td>
                                            </tr>
                            <%  
                                        }

                                        if (!hasData) {
                            %>
                                            <tr>
                                                <td colspan="5" style="text-align: center; padding: 30px; color: #86A789;">
                                                    No previous appointments found.
                                                </td>
                                            </tr>
                            <%
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                            %>
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: red; padding: 20px;">
                                                Error loading appointment data from server.
                                            </td>
                                        </tr>
                            <%
                                    } finally {
                                        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (SQLException e) {}
                                    }
                                } else {
                            %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 20px; color: red;">
                                            Session expired. Please login again.
                                        </td>
                                    </tr>
                            <% } %>
                        </tbody>
                    </table>
                </section>
                
                <br><br>
                
                <section id="history">
                    <h3 style="font-family: 'Playfair Display', serif; color: #4F6F52; margin-bottom: 15px;">Medical Records & Prescription</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Visit Date</th>
                                <th>Diagnosis</th>
                                <th>Medication</th>
                                <th>Doctor Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </section>
            </main>
        </div>

        <script>
            let slideIndex = 0;
            
            // Array kandungan teks bagi setiap poster iklan
            const slideData = [
                {
                    badge: "Siri Rawatan Rumah",
                    title: "Khidmat Home Visit Bersasar",
                    desc: "Kami faham kesukaran anda untuk bergerak. Kini anda boleh dapatkan rawatan cuci luka kronik, penukaran tiub kencing (CBD), dan pemasangan tiub makanan (Ryles Tube) terus di kediaman anda.",
                    features: ["✔ Dikendali Doktor & Jururawat Bertauliah", "✔ Peralatan Steril & Standard Hospital", "✔ Jimat Masa Tanpa Perlu Beratur"]
                },
                {
                    badge: "Fasiliti Komuniti",
                    title: "Klinik Mesra Komuniti Anda",
                    desc: "Komited dalam menjaga kesihatan seisi keluarga. Kami menyediakan fasiliti saringan awal yang lengkap, rawatan pesakit luar am, serta khidmat farmasi dalaman yang memudahkan urusan anda.",
                    features: ["✔ Saringan Kesihatan & Darah Am", "✔ Konsultasi Kanak-Kanak & Dewasa", "✔ Bekalan Ubat-Ubatan Berdaftar KKM"]
                },
                {
                    badge: "Pencegahan Awal",
                    title: "Suntikan Vaksinasi & Imunisasi",
                    desc: "Lindungi diri dan keluarga tersayang daripada risiko jangkitan bermusim. Kami menyediakan pelbagai jenis suntikan perlindungan yang disyorkan oleh Kementerian Kesihatan Malaysia.",
                    features: ["✔ Vaksinasi Umrah & Haji (Meningitis)", "✔ Suntikan Influenza Tahunan", "✔ Kemas Kini Rekod Imunisasi Segera"]
                }
            ];

            showSlides();

            function showSlides() {
                let i;
                let slides = document.getElementsByClassName("promo-slide");
                let dots = document.getElementsByClassName("slider-dot");
                
                for (i = 0; i < slides.length; i++) {
                    slides[i].style.display = "none";  
                }
                
                slideIndex++;
                if (slideIndex > slides.length) { slideIndex = 1; }    
                
                for (i = 0; i < dots.length; i++) {
                    dots[i].className = dots[i].className.replace(" active", "");
                }
                
                // Aktifkan imej slaid semasa
                slides[slideIndex-1].style.display = "block";  
                if (dots.length > 0) {
                    dots[slideIndex-1].className += " active";
                }
                
                // Tukar kandungan teks mengikut slaid poster yang aktif
                let currentData = slideData[slideIndex-1];
                document.getElementById("promoBadge").innerText = currentData.badge;
                document.getElementById("promoTitle").innerText = currentData.title;
                document.getElementById("promoDesc").innerText = currentData.desc;
                
                // Bina semula elemen list (bullet points)
                let featuresHtml = "";
                currentData.features.forEach(function(feature) {
                    featuresHtml += "<li>" + feature + "</li>";
                });
                document.getElementById("promoFeatures").innerHTML = featuresHtml;
                
                // Tukar slaid setiap 5 saat (memberi masa yang cukup untuk membaca teks)
                setTimeout(showSlides, 5000); 
            }
        </script>
        
        <jsp:include page="footer.jsp" />
    </body>
</html>