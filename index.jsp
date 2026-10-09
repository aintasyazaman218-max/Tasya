<%-- 
    Document   : index
    Created on : 11 May 2026, 3:57:29 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>

    <body>
        <div class="container-login">
            <h2>Clinic Login</h2>

            <form action="LoginServlet" method="POST">
                <label>Email Address / IC Number</label>
                <input type="text" name="uid" placeholder="Enter email or IC" required>

                <label>Password</label>
                <input type="password" name="pwd" required>

                <button type="submit">Login</button>
            </form>

            <p style="text-align: center; margin-top: 20px; font-size: 0.85rem;">
                New patient? <a href="signup.jsp" style="color: #4F6F52; font-weight: bold;">Register Here</a>
            </p>
        </div>

<%
    String error = request.getParameter("error");
    if ("invalid".equals(error)) {
%>
    <div class="alert alert-error" style="color: red; text-align: center; margin-top: 10px;">Wrong email/IC or password!</div>
<% } else if ("database".equals(error)) { %>
    <div class="alert alert-error" style="color: red; text-align: center; margin-top: 10px;">The system is busy. Please try again later.</div>
<% } %>

<%
    String signupStatus = request.getParameter("signup");
    if ("success".equals(signupStatus)) {
%>
    <div class="alert alert-success" style="color: green; text-align: center; margin-top: 10px;">
        Congratulations! Account successfully registered. Please log in.
    </div>
<% } %>

        <jsp:include page="footer.jsp" />
    </body>
</html>