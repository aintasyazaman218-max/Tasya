<%-- 
    Document   : invoice
    Created on : 28 May 2026, 1:29:54 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Tangkap data yang dihantar oleh Servlet tadi melalui URL
    String billId = request.getParameter("billId");
    String patientName = request.getParameter("name");
    String totalAmount = request.getParameter("amount");
    String paymentMethod = request.getParameter("method");
    
    if(billId == null) billId = "INV-2026-XXXX";
    if(patientName == null) patientName = "Contoh Pesakit";
    if(totalAmount == null) totalAmount = "0.00";
    if(paymentMethod == null) paymentMethod = "Cash";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Print Invoice - <%= billId %></title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=1.5">
</head>
<body style="background-color: white; padding: 40px; color: #333;">

    <div style="max-width: 600px; margin: 0 auto; border: 1px solid #E5E7EB; padding: 30px; border-radius: 8px;">
        
        <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #4F6F52; margin-bottom: 5px;">KLINIK AFEEYA</h1>
            <p style="font-size: 0.9rem; color: #666;">Lot 25825 Jalan Taman Sri Noor, Kampung Gong Badak, 21300 Kuala Terengganu, Terengganu</p>
            <p style="font-size: 0.9rem; color: #666;">Tel: 012-212 8900</p>
            <hr style="border: 0; border-top: 2px dashed #D2E3C8; margin-top: 20px;">
        </div>

        <div style="margin-bottom: 25px; line-height: 1.6;">
            <p><strong>Invoice No:</strong> <%= billId %></p>
            <p><strong>Date / Time:</strong> 2026-05-28 01:30 AM</p> 
            <p><strong>Patient Name:</strong> <%= patientName %></p>
            <p><strong>Payment Method:</strong> <%= paymentMethod %></p>
            <p><strong>Status:</strong> <span style="color: #166534; font-weight: bold;">PAID / LUNAS</span></p>
        </div>

        <table class="activity-table" style="margin-bottom: 25px;">
            <thead>
                <tr style="background-color: #4F6F52 !important; color: white;">
                    <th>Description</th>
                    <th style="text-align: right;">Amount (RM)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Doctor Consultation Fee</td>
                    <td style="text-align: right;">30.00</td>
                </tr>
                <tr>
                    <td>Medicine & Treatment Charges</td>
                    <td style="text-align: right;"><%= String.format("%.2f", Double.parseDouble(totalAmount) - 30.00) %></td>
                </tr>
                <tr style="font-weight: bold; background-color: #F9FAFB;">
                    <td>TOTAL PAID:</td>
                    <td style="text-align: right; color: #4F6F52; font-size: 1.1rem;">RM <%= totalAmount %></td>
                </tr>
            </tbody>
        </table>

        <div style="text-align: center; margin-top: 40px; font-size: 0.85rem; color: #888;">
            <p>Thank you for choosing Klinik Afeeya.</p>
            <p>Get well soon!</p>
            
            <button onclick="window.print()" style="margin-top: 20px; padding: 8px 15px; background: #607274; color: white; border: none; border-radius: 4px; cursor: pointer;">
                Print Again
            </button>
            <br>
            <a href="payments.jsp" style="display: inline-block; margin-top: 10px; color: #4F6F52; text-decoration: none;">← Back to Payments Dashboard</a>
        </div>

    </div>

    <script>
        window.onload = function() {
            window.print();
        };
    </script>

</body>
</html>
