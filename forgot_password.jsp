<%-- 
    Document   : forgot_password
    Created on : 18 Jun 2026, 11:15:00 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Reset Password | Clinic Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        /* Guna design token yang sama dengan edit_profile.jsp untuk consistency */
        .container-forgot {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block; 
            font-weight: 700; 
            color: #4F6F52; 
            margin-bottom: 8px; 
            font-size: 0.85rem; 
            text-transform: uppercase;
        }
        .form-input {
            width: 100%; 
            padding: 12px; 
            border: 2px solid #F5EFE7; 
            border-radius: 10px;
            box-sizing: border-box;
        }
        .form-input:focus {
            outline: none;
            border-color: #86A789;
        }
        .alert-msg {
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: center;
        }
        .alert-error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        .alert-success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container-dashboard">
        <div class="container-forgot">
            <header style="text-align: center; margin-bottom: 25px;">
                <h2 style="font-family: 'Playfair Display', serif; color: #4F6F52; font-size: 2rem; margin-bottom: 5px;">Reset Password</h2>
                <p style="color: #86A789; font-size: 0.95rem; margin: 0;">Enter your details to secure your account.</p>
            </header>

            <hr style="border: 1px solid #F5EFE7; margin-bottom: 25px;">

            <%-- Gunting bahagian ni kalau kau nak display mesej ralat/sukses dari servlet --%>
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                if ("notfound".equals(error)) {
            %>
                <div class="alert-msg alert-error">✗ Email address not found in our records.</div>
            <% } else if ("mismatch".equals(error)) { %>
                <div class="alert-msg alert-error">✗ Passwords do not match.</div>
            <% } else if ("true".equals(success)) { %>
                <div class="alert-msg alert-success">✓ Password updated successfully! <a href="index.jsp" style="color: #3c763d; font-weight: bold;">Login here</a></div>
            <% } %>

            <form action="ForgotPasswordServlet" method="POST">
                
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="fEmail" placeholder="Enter your registered email" required class="form-input">
                </div>

                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPassword" placeholder="Minimum 4 characters" required class="form-input">
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <input type="password" name="confirmPassword" placeholder="Re-enter new password" required class="form-input">
                </div>

                <button type="submit" class="btn-main" style="width: 100%; font-size: 1rem; padding: 15px; margin-top: 10px;">Update Password</button>

                <div style="text-align: center; margin-top: 25px;">
                    <a href="edit_profile.jsp" style="color: #86A789; text-decoration: none; font-size: 0.9rem; font-weight: 600;">← Back to Profile</a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>