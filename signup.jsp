<%-- 
    Document   : signup
    Created on : 11 May 2026, 5:07:44 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign Up - Clinic Management System</title>
    </head>
    <style>
    .container {
        max-width: 500px;
        margin: 50px auto;
        padding: 40px;
        background: #FBFBFB;
        border: 1px solid #F5EFE7;
        border-radius: 20px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
    }
    input {
        width: 100%;
        padding: 12px;
        margin: 10px 0 20px 0;
        border: 2px solid #F5EFE7;
        border-radius: 10px;
        box-sizing: border-box; /* Biar tak terkeluar dari container */
    }
    button {
        background-color: #4F6F52;
        color: white;
        padding: 15px;
        border: none;
        border-radius: 12px;
        width: 100%;
        cursor: pointer;
        font-weight: 700;
        transition: 0.3s;
    }
    button:hover { background-color: #86A789; }
</style>
    <body>
        <div class="container">
        <h2>Sign Up</h2>
        <form action="SignupServlet" method="POST">
            
            <label>Email:</label><br>
            <input type="email" name="uEmail" placeholder="contoh@gmail.com" required><br>

            <br><label>Password:</label><br>
            <input type="password" name="uPass" required><br><br>

            <hr>
            <h3>Personal Info</h3>
            <label>Full Name (refer IC):</label><br>
            <input type="text" name="pName" required><br>

            <label>No. IC:</label><br>
            <input type="text" name="pIC" placeholder="990101145566" required><br>

            <label>No. Phone:</label><br>
            <input type="text" name="pPhone" required><br><br>

            <button type="submit">Register Now</button>
        </form>
        <p>Existing Account? <a href="index.jsp">Login here</a></p>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>