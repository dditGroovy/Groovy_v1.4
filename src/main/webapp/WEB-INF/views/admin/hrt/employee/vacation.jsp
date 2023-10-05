<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageVacation.css">
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/vacation/manage" class="on">연차 관리</a></h1>
    </header>
    <main>
        <div>
            <div id="search" class="input-free-white">
                <i class="icon i-search"></i>
                <input type="text" id="quickFilter" placeholder="검색어를 입력하세요." oninput="onQuickFilterChanged()"/>
            </div>
            <div id="grid" class="ag-theme-material"></div>
        </div>
    </main>
</div>
<script>
    function updateValue(yrycEmpId, newValue) {
        const modifyData = {
            yrycEmpId: yrycEmpId,
            yrycNowCo: newValue
        };

        $.ajax({
            url: "/vacation/manage",
            type: "post",
            data: JSON.stringify(modifyData),
            contentType: "application/json;charset:utf-8",
            success: function (result) {
                if(result == 1) {
                    location.href = "/vacation/manage";
                }
            },
            error: function (xhr) {
                Swal.fire({
                    text: '오류로 인하여 연차 개수 수정을 실패했습니다',
                    showConfirmButton: false,
                    timer: 1500
                })
            }
        });
    }

    class ClassComp {
        init(params) {
            let data = params.node.data
            let yrycEmpId = data.yrycEmpId;
            let yrycNowCo = data.yrycNowCo;
            this.eGui = document.createElement('div');
            this.eGui.innerHTML = `
            <button class="minusBtn btn btn-fill-wh-sm"">-</button>
            <input type="number" class="yrycNowCo input-free-white" value="\${yrycNowCo}">
            <button class="plusBtn btn btn-fill-wh-sm">+</button>
            <button class="saveBtn btn btn-fill-bl-sm">저장</button>
        `;

            const minusBtn = this.eGui.querySelector(".minusBtn");
            const plusBtn = this.eGui.querySelector(".plusBtn");
            const saveBtn = this.eGui.querySelector(".saveBtn");
            const inputElement = this.eGui.querySelector(".yrycNowCo");

            minusBtn.addEventListener("click", () => {
                this.updateCellValue(-1.0);
            });

            plusBtn.addEventListener("click", () => {
                this.updateCellValue(1.0);
            });

            saveBtn.addEventListener("click", () => {
                const newValue = parseFloat(inputElement.value);
                if (parseFloat(yrycNowCo) != newValue) {
                    updateValue(yrycEmpId, newValue);
                }
            });
        }

        getGui() {
            return this.eGui;
        }

        destroy() {

        }

        updateCellValue(changeValue) {
            const inputElement = this.eGui.querySelector(".yrycNowCo");
            const currentValue = parseFloat(inputElement.value);
            if (!isNaN(currentValue)) {
                const newValue = currentValue + changeValue;
                inputElement.value = newValue;
            }
        }
    }

    const getMedalString = function (param) {
        const str = `${param} `;
        return str;
    };
    const MedalRenderer = function (params) {
        return getMedalString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    function refreshRow(rowNode, api) {
        var millis = frame++ * 100;
        var rowNodes = [rowNode];
        var params = {
            force: isForceRefreshSelected(),
            suppressFlash: isSuppressFlashSelected(),
            rowNodes: rowNodes,
        };
        callRefreshAfterMillis(params, millis, api);
    }

    const columnDefs = [
        {
            field: "yrycEmpId", headerName: "사번", width: 250, getQuickFilterText: (params) => {
                return getMedalString(params.value);
            }, cellStyle: {textAlign: "center"}
        },
        {field: "emplNm", headerName: "이름", cellStyle: {textAlign: "center"}},
        {field: "deptNm", headerName: "부서", cellStyle: {textAlign: "center"}},
        {field: "clsfNm", headerName: "직급", cellStyle: {textAlign: "center"}},
        {field: "emplEncpn", headerName: "입사일", cellStyle: {textAlign: "center"}},
        {
            field: "yrycNowCo",
            headerName: "보유 연차",
            width: 300,
            cellRenderer: "classCompRenderer",
            cellRendererParams: {
                updateValue: updateValue,
            }, cellStyle: {textAlign: "center"}
        },
    ];

    const rowData = [];
    <c:forEach items="${allEmplVacation}" var="vacation">
    <fmt:formatDate var= "emplEncpn" value="${vacation.emplEncpn}" type="date" pattern="yyyy-MM-dd" />
    rowData.push({
        yrycEmpId: "${vacation.yrycEmpId}",
        emplNm: "${vacation.emplNm}",
        deptNm: "${vacation.deptNm}",
        clsfNm: "${vacation.clsfNm}",
        emplEncpn: "${emplEncpn}",
        yrycNowCo: "${vacation.yrycNowCo}",
    })
    </c:forEach>

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData,
        components: {
            classCompRenderer: ClassComp,
        },
        // paginationAutoPageSize: true,
        pagination: true,
        paginationPageSize: 10,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#grid');
        new agGrid.Grid(gridDiv, gridOptions);
        // autoSizeAll(true);
    });
</script>