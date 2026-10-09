<%-- 
    Document   : inventory
    Created on : 28 May 2026, 1:11:29 am
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
    <title>Medication Inventory | Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    
    <jsp:include page="header.jsp" />
    
    <div class="container-dashboard">
        
        <div class="inventory-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <header class="dashboard-header" style="margin: 0;">
                <h2>Medication Inventory</h2>
            </header>
            <button class="btn-update-stock" onclick="location.href='#restock-form'">
                <i class="fa-solid fa-arrows-rotate"></i> Update Stock
            </button>
        </div>

        <div class="inventory-grid">
            
            <div class="med-card">
                <div class="med-info">
                    <h3>Paracetamol 500mg</h3>
                    <span class="med-id">ID: MED-001 (Tablet)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value">1,500 tablets</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">500 tablets</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-safe" style="width: 75%;"></div>
                    </div>
                </div>
            </div>

            <div class="med-card">
                <div class="med-info">
                    <h3>Amoxicillin 250mg</h3>
                    <span class="med-id">ID: MED-002 (Antibiotic)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value">800 capsules</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">300 capsules</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-safe" style="width: 60%;"></div>
                    </div>
                </div>
            </div>

            <div class="med-card card-low-alert">
                <div class="med-info">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3>Metformin 500mg</h3>
                        <span class="badge-low">Low Stock</span>
                    </div>
                    <span class="med-id">ID: MED-003 (Diabetes)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value color-danger">450 tablets</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">500 tablets</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-danger" style="width: 40%;"></div>
                    </div>
                </div>
            </div>

            <div class="med-card">
                <div class="med-info">
                    <h3>Amlodipine 5mg</h3>
                    <span class="med-id">ID: MED-004 (Hypertension)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value">650 tablets</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">400 tablets</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-safe" style="width: 55%;"></div>
                    </div>
                </div>
            </div>

            <div class="med-card">
                <div class="med-info">
                    <h3>Cough Syrup (Guaifenesin)</h3>
                    <span class="med-id">ID: MED-005 (Liquid)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value">320 bottles</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">100 bottles</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-safe" style="width: 80%;"></div>
                    </div>
                </div>
            </div>

            <div class="med-card card-low-alert">
                <div class="med-info">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3>Gaviscon Liquid 10ml</h3>
                        <span class="badge-low">Low Stock</span>
                    </div>
                    <span class="med-id">ID: MED-006 (Gastric)</span>
                </div>
                <div class="med-stats">
                    <div class="stat-row">
                        <span>Current Stock:</span>
                        <span class="stat-value color-danger">15 sachets</span>
                    </div>
                    <div class="stat-row">
                        <span>Reorder Level:</span>
                        <span class="stat-value">100 sachets</span>
                    </div>
                </div>
                <div class="stock-progress-container">
                    <div class="stock-bar">
                        <div class="bar-fill bg-danger" style="width: 15%;"></div>
                    </div>
                </div>
            </div>

        </div>

        <section id="restock-form" class="form-section" style="margin-top: 60px;">
            <h3 class="section-title-restock">➕ Add / Restock Item</h3>
            <form action="AdminInventoryServlet" method="POST" class="styled-form">
                <fieldset class="form-fieldset">
                    <div class="form-group">
                        <label>Medicine ID / Code</label>
                        <input type="text" name="medCode" placeholder="E.g., MED-001" required>
                    </div>
                    <div class="form-group">
                        <label>Quantity to Add</label>
                        <input type="number" name="medQty" placeholder="E.g., 500" required>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-submit" style="background-color: #4F6F52;">Submit Update</button>
                    </div>
                </fieldset>
            </form>
        </section>

    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>