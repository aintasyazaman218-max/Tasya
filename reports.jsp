<%-- 
    Document   : reports
    Created on : 12 May 2026, 7:57:13 am
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
    <title>Reports & Analytics | Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=1.8">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    
    <jsp:include page="header.jsp" />
    
    <div class="container-dashboard">
        
        <div class="report-header-wrapper" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <header class="dashboard-header" style="margin: 0;">
                <h2>Reporting Module</h2>
            </header>
            
            <div class="report-filter-buttons">
                <button class="filter-btn active" onclick="updateReportData('daily', this)">Daily</button>
                <button class="filter-btn" onclick="updateReportData('weekly', this)">Weekly</button>
                <button class="filter-btn" onclick="updateReportData('monthly', this)">Monthly</button>
                <button class="filter-btn" onclick="updateReportData('yearly', this)">Yearly</button>
            </div>
        </div>

        <div class="charts-grid-layout" style="margin-bottom: 40px;">
            <div class="chart-wrapper-box">
                <h4 class="chart-box-title">Patient Visits</h4>
                <canvas id="patientBarChart"></canvas>
            </div>
            
            <div class="chart-wrapper-box">
                <h4 class="chart-box-title">Revenue (RM)</h4>
                <canvas id="revenueLineChart"></canvas>
            </div>
        </div>

        <div class="report-cards-container" style="margin-bottom: 40px;">
            <div class="report-card card-patients">
                <h4>Total Patients</h4>
                <p class="card-value" id="kpi-patients" style="color: #4F6F52;">2</p>
            </div>
            <div class="report-card card-pending-invoices">
                <h4>Pending Invoices</h4>
                <p class="card-value" id="kpi-invoices" style="color: #D97706;">1</p>
            </div>
            <div class="report-card card-alerts">
                <h4>Low Stock Items</h4>
                <p class="card-value" style="color: #DC2626;">1</p>
            </div>
            <div class="report-card card-revenue">
                <h4>Total Revenue</h4>
                <p class="card-value" id="kpi-revenue" style="color: #213555;">RM 430.00</p>
            </div>
        </div>

        <section class="activity-section" style="margin-bottom: 40px;">
            <h3 class="section-title-report">📈 Monthly Revenue Breakdown</h3>
            <table class="activity-table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Total Appointments</th>
                        <th>Consultation Fees</th>
                        <th>Medicine Sales</th>
                        <th>Total Gross Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>May 2026</td>
                        <td>120</td>
                        <td>RM 3,600.00</td>
                        <td>RM 4,850.00</td>
                        <td><strong>RM 8,450.00</strong></td>
                    </tr>
                </tbody>
            </table>
        </section>

    </div>
    
    <jsp:include page="footer.jsp" />

    <script>
        // TUKAR WARNA DI SINI JIKA TAK MASUK DENGAN SISTEM KAU
        // Contoh: #4F6F52 (Hijau Klinik) atau #213555 (Biru Gelap)
        const SYSTEM_THEME_COLOR = '#4F6F52'; 
        const SYSTEM_BG_COLOR = 'rgba(79, 111, 82, 0.1)';

        // DATA STORE UNTUK SETIAP JANGKA MASA
        const reportData = {
            daily: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                patients: [12, 15, 10, 18, 14, 8, 5],
                revenue: [1800, 2300, 1500, 2700, 2100, 1200, 750],
                kpi: { patients: '2', invoices: '1', revenue: 'RM 430.00' }
            },
            weekly: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                patients: [45, 58, 52, 64],
                revenue: [5400, 7200, 6100, 8450],
                kpi: { patients: '219', invoices: '4', revenue: 'RM 27,150.00' }
            },
            monthly: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                patients: [180, 210, 195, 240, 342, 290],
                revenue: [18000, 22000, 19500, 24500, 32000, 28500],
                kpi: { patients: '1,459', invoices: '12', revenue: 'RM 144,500.00' }
            },
            yearly: {
                labels: ['2024', '2025', '2026'],
                patients: [2100, 2800, 3400],
                revenue: [210000, 290000, 350000],
                kpi: { patients: '8,300', invoices: '45', revenue: 'RM 850,000.00' }
            }
        };

        // RENDER GRAF PERTAMA KALI (DEFAULT: DAILY)
        const ctxBar = document.getElementById('patientBarChart').getContext('2d');
        const patientChart = new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: reportData.daily.labels,
                datasets: [{
                    label: 'Patients',
                    data: reportData.daily.patients,
                    backgroundColor: SYSTEM_THEME_COLOR,
                    borderRadius: 4
                }]
            },
            options: { responsive: true }
        });

        const ctxLine = document.getElementById('revenueLineChart').getContext('2d');
        const revenueChart = new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: reportData.daily.labels,
                datasets: [{
                    label: 'Revenue (RM)',
                    data: reportData.daily.revenue,
                    borderColor: SYSTEM_THEME_COLOR,
                    backgroundColor: SYSTEM_BG_COLOR,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: { responsive: true }
        });

        // FUNGSI UNTUK UPDATE DATA BILA BUTANG DIKLIK
        function updateReportData(timeframe, buttonElement) {
            // 1. Tukar kelas active pada butang
            document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
            buttonElement.classList.add('active');
            
            // 2. Tarik data baru dari store
            const newData = reportData[timeframe];
            
            // 3. Kemas kini graf Bar
            patientChart.data.labels = newData.labels;
            patientChart.data.datasets[0].data = newData.patients;
            patientChart.update();
            
            // 4. Kemas kini graf Line
            revenueChart.data.labels = newData.labels;
            revenueChart.data.datasets[0].data = newData.revenue;
            revenueChart.update();

            // 5. Kemas kini angka KPI Cards biar seiring
            document.getElementById('kpi-patients').innerText = newData.kpi.patients;
            document.getElementById('kpi-invoices').innerText = newData.kpi.invoices;
            document.getElementById('kpi-revenue').innerText = newData.kpi.revenue;
        }
        
    </script>
    <script src="js/chart.js"></script>
</body>
</html>
