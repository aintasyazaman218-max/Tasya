<%-- 
    Document   : payments
    Created on : 28 May 2026, 1:23:54 am
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Billing & Payments | Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=1.4">
</head>
<body>
    
    <jsp:include page="header.jsp" />
    
    <div class="container-dashboard">
        
        <header class="dashboard-header">
            <h2>Billing & Payments</h2>
        </header>

        <section class="activity-section" style="margin-bottom: 40px;">
            <h3 class="section-title-billing">💳 Pending Payments</h3>
            <table class="activity-table">
                <thead>
                    <tr>
                        <th>Queue No</th>
                        <th>Patient Name</th>
                        <th>Doctor / Treatment</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Q1005</td>
                        <td>Ahmad Zaki</td>
                        <td>Dr. Amir (Consultation + Meds)</td>
                        <td><strong>RM 65.00</strong></td>
                        <td><span class="status-badge status-unpaid">Unpaid</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminPaymentServlet" method="POST" style="display: flex; gap: 10px; align-items: center; margin: 0;">
                                    <input type="hidden" name="billId" value="BIL9901">
                                    <input type="hidden" name="patientName" value="Ahmad Zaki">
                                    <input type="hidden" name="totalAmount" value="65.00">
                                    
                                    <select name="paymentMethod" style="padding: 6px 10px; border-radius: 6px; border: 1px solid #D2E3C8; background: #FFF;">
                                        <option value="Cash">Cash</option>
                                        <option value="QR / TNG">QR / TNG</option>
                                        <option value="Card">Card</option>
                                    </select>
                                    
                                    <button type="submit" class="btn-checkin">Process & Print</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Q1006</td>
                        <td>Siti Nurhaliza</td>
                        <td>Dr. Amir (Follow-up Checkup)</td>
                        <td><strong>RM 30.00</strong></td>
                        <td><span class="status-badge status-unpaid">Unpaid</span></td>
                        <td>
                            <div class="action-bundle">
                                <form action="AdminPaymentServlet" method="POST" style="display: flex; gap: 10px; align-items: center; margin: 0;">
                                    <input type="hidden" name="billId" value="BIL9902">
                                    <input type="hidden" name="patientName" value="Siti Nurhaliza">
                                    <input type="hidden" name="totalAmount" value="30.00">
                                    
                                    <select name="paymentMethod" style="padding: 6px 10px; border-radius: 6px; border: 1px solid #D2E3C8; background: #FFF;">
                                        <option value="Cash">Cash</option>
                                        <option value="QR / TNG">QR / TNG</option>
                                        <option value="Card">Card</option>
                                    </select>
                                    
                                    <button type="submit" class="btn-checkin">Process & Print</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </section>

        <section class="activity-section">
            <h3 class="section-title-history">📜 Payment History</h3>
            <table class="activity-table history-table-style">
                <thead>
                    <tr class="history-th-style">
                        <th>Invoice No</th>
                        <th>Patient Name</th>
                        <th>Date & Time</th>
                        <th>Amount Paid</th>
                        <th>Payment Method</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>INV-2026-001</td>
                        <td>Mhd Ridzuan</td>
                        <td>2026-05-28 10:15 AM</td>
                        <td>RM 45.00</td>
                        <td>Cash</td>
                        <td><span class="status-badge history-badge">Paid</span></td>
                    </tr>
                    <tr>
                        <td>INV-2026-002</td>
                        <td>Chong Wei</td>
                        <td>2026-05-27 03:40 PM</td>
                        <td>RM 120.00</td>
                        <td>QR / TNG</td>
                        <td><span class="status-badge history-badge">Paid</span></td>
                    </tr>
                </tbody>
            </table>
        </section>

    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>