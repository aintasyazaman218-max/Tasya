<%-- 
    Document   : edit_profile
    Created on : 12 May 2026, 12:56:07 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Patient".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // SELARASKAN NAMA ATRIBUT DENGAN LOGIN SERVLET
    String email = (String) session.getAttribute("patientEmail");
    String patientName = (String) session.getAttribute("patientName");
    String patientIC = (String) session.getAttribute("patientIC");
    String patientPhone = (String) session.getAttribute("patientPhone");
    String profilePic = (String) session.getAttribute("profilePic"); 
    
    if (profilePic == null || profilePic.isEmpty()) {
        profilePic = "https://cdn-icons-png.flaticon.com/128/16385/16385147.png"; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Profile | Clinic Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script>
        function previewImage(input) {
            var preview = document.getElementById('profilePreview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
    <style>
        .profile-pic-container {
            text-align: center;
            margin-bottom: 25px;
        }
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #4F6F52;
            margin-bottom: 10px;
        }
        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }
        .file-input-wrapper input[type=file] {
            position: absolute;
            left: -9999px;
        }
        .file-input-label {
            background: #4F6F52;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.85rem;
            display: inline-block;
        }
        .file-input-label:hover {
            background: #3D5A40;
        }
        .password-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #F5EFE7;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container-dashboard">
        <header style="text-align: center; margin-bottom: 30px;">
            <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2.2rem;">Update Profile</h2>
            <p style="color: #86A789;">Keep your information up to date.</p>
        </header>

        <hr style="border: 1px solid #F5EFE7; margin-bottom: 30px;">

        <form action="UpdateProfileServlet" method="POST" enctype="multipart/form-data" style="max-width: 800px; margin: 0 auto;">
    
            <div class="profile-pic-container">
                <img src="<%= profilePic %>" alt="Profile Picture" class="profile-pic" id="profilePreview">
                <br>
                <div class="file-input-wrapper">
                    <label for="profilePic" class="file-input-label">📷 Change Photo</label>
                    <input type="file" name="profilePic" id="profilePic" accept="image/*" onchange="previewImage(this)">
                </div>
                <p style="font-size: 0.75rem; color: #86A789; margin-top: 5px;">Max size: 2MB (JPG, PNG)</p>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 20px;">
                <div style="grid-column: span 2;">
                    <label style="display: block; font-weight: 700; color: #4F6F52; margin-bottom: 8px; font-size: 0.85rem; text-transform: uppercase;">Email Address</label>
                    <input type="email" name="uEmail" value="<%= email != null ? email : "" %>" placeholder="Enter email address" required  
                           style="width: 100%; padding: 12px; border: 2px solid #F5EFE7; border-radius: 10px;">
                </div>

                <div>
                    <label style="display: block; font-weight: 700; color: #4F6F52; margin-bottom: 8px; font-size: 0.85rem; text-transform: uppercase;">Full Name</label>
                    <input type="text" name="pName" value="<%= patientName != null ? patientName : "" %>" readonly
                           style="width: 100%; padding: 12px; background: #f0f0f0; border: 2px solid #eee; border-radius: 10px; color: #777; cursor: not-allowed;">
                </div>

                <div>
                    <label style="display: block; font-weight: 700; color: #4F6F52; margin-bottom: 8px; font-size: 0.85rem; text-transform: uppercase;">No. IC</label>
                    <input type="text" name="pIC" value="<%= patientIC != null ? patientIC : "" %>" readonly 
                           style="width: 100%; padding: 12px; background: #f0f0f0; border: 2px solid #eee; border-radius: 10px; color: #777; cursor: not-allowed;">
                </div>

                <div style="grid-column: span 2;">
                    <label style="display: block; font-weight: 700; color: #4F6F52; margin-bottom: 8px; font-size: 0.85rem; text-transform: uppercase;">No. Phone</label>
                    <input type="text" name="pPhone" value="<%= patientPhone != null ? patientPhone : "" %>" placeholder="Enter phone number" required 
                           style="width: 100%; padding: 12px; border: 2px solid #F5EFE7; border-radius: 10px;">
                </div>
            </div>

            <button type="submit" class="btn-main" style="width: 100%; font-size: 1rem; padding: 15px;">Save Changes</button>

            <div class="password-section">
                <p style="color: #86A789; font-size: 0.9rem;">
                    Want to change your password? 
                    <a href="forgot_password.jsp" style="color: #4F6F52; font-weight: 600;">Reset Password</a>
                </p>
            </div>

            <div style="text-align: center; margin-top: 20px;">
                <a href="view_profile.jsp" style="color: #86A789; text-decoration: none; font-size: 0.9rem; font-weight: 600;">← Cancel Changes</a>
            </div>
        </form>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>