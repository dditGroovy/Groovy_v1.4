<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/vehicleResveList.css">

<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/reserve/manageVehicle">차량 관리</a></h1>
        <h1><a class="on" href="${pageContext.request.contextPath}/reserve/loadVehicle">예약 관리</a></h1>
    </header>
    <div class="wrap">
        <div id="search" class="input-free-white">
            <i class="icon i-search"></i>
            <input type="text" id="quickFilter" placeholder="검색어를 입력하세요." oninput="onQuickFilterChanged()"/>
        </div>
    </div>
    <div class="card-wrap">
        <div class="card">
            <div id="myGrid" class="ag-theme-material"></div>
        </div>
    </div>
</div>
<script>
    const returnCar = (params) => params.value;

    class ClassComp {
        init(params) {
            this.eGui = document.createElement('div');

            if (params.data.vhcleResveReturnAt === 'Y') {
                this.eGui.innerHTML = `
                    <button class="returnCarBtn" id="\${params.value}" style="display: none">반납 확인</button>
                    <p class="returnStatus">반납완료</p>
                `;
            } else if (params.data.vhcleResveReturnAt === 'N') {
                this.eGui.innerHTML = `
                    <button class="returnCarBtn" id="\${params.value}">반납 확인</button>
                    <p class="returnStatus" style="display: none;">반납완료</p>
                `;
            }
            this.id = params.value;
            this.returnCarBtn = this.eGui.querySelector(".returnCarBtn");
            this.returnStatus = this.eGui.querySelector(".returnStatus");
            this.returnCarBtn.onclick = () => {
                let vhcleResveNo = this.returnCarBtn.getAttribute("id");
                let xhr = new XMLHttpRequest();
                xhr.open("put", "/reserve/return", true);
                xhr.onreadystatechange = () => {
                    if (xhr.status == 200 && xhr.readyState == 4) {
                        if (xhr.responseText == 1) {
                            this.returnCarBtn.style.display = 'none';
                            this.returnStatus.style.display = 'block';
                        }
                    }
                }
                xhr.send(vhcleResveNo);
            }
        }

        getGui() {
            return this.eGui;
        }

        destroy() {
        }
    }

    const getMedalString = function (param) {
        const str = `\${param} `;
        return str;
    };
    const MedalRenderer = function (params) {
        return getMedalString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    const columnDefs = [
        {field: "vhcleResveNo", headerName: "예약번호", width: 120, cellRenderer: returnCar, cellStyle: {textAlign: "center"}},
        {
            field: "vhcleNo", headerName: "차량번호", getQuickFilterText: (params) => {
                return getMedalString(params.value);
            }, cellStyle: {textAlign: "center"}
        },
        {field: "vhcleResveBeginTime", headerName: "시작 일자", cellStyle: {textAlign: "center"}},
        {field: "vhcleResveEndTime", headerName: "끝 일자", cellStyle: {textAlign: "center"}},
        {field: "vhcleResveEmpNm", headerName: "예약 사원", width: 120, cellStyle: {textAlign: "center"}},
        {field: "vhcleResveEmplId", headerName: "사번", cellStyle: {textAlign: "center"}},
        {field: "chk", headerName: " ", cellRenderer: ClassComp, cellStyle: {textAlign: "center"}},
    ];
    const rowData = [];
    <c:forEach var="vehicleVO" items="${allReservation}" varStatus="status">
    <c:set var="beginTimeStr" value="${vehicleVO.vhcleResveBeginTime}"/>
    <fmt:formatDate var="beginTime" value="${beginTimeStr}" pattern="yyyy-MM-dd HH:mm"/>
    <c:set var="endTimeStr" value="${vehicleVO.vhcleResveEndTime}"/>
    <fmt:formatDate var="endTime" value="${endTimeStr}" pattern="yyyy-MM-dd HH:mm"/>
    rowData.push({
        vhcleResveNo: "${vehicleVO.vhcleResveNoRedefine}",
        vhcleNo: "${vehicleVO.vhcleNo}",
        vhcleResveBeginTime: "${beginTime}",
        vhcleResveEndTime: "${endTime}",
        vhcleResveEmpNm: "${vehicleVO.vhcleResveEmplNm}",
        vhcleResveEmplId: "${vehicleVO.vhcleResveEmplId}",
        chk: "${vehicleVO.vhcleResveNo}",
        vhcleResveReturnAt: "${vehicleVO.vhcleResveReturnAt}"
    })
    </c:forEach>
    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        rowHeight: 50,
        pagination: true,
        paginationPageSize: 10,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);

    });
</script>