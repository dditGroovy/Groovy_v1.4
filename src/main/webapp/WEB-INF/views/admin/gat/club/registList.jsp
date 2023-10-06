<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageClub.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <header id="tab-header">
        <h1><a class="on" href="/club/admin">동호회 관리</a></h1>
    </header>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="side-header-wrap">
                <h1 class="font-md color-font-md font-18 h1">동호회 운영내역</h1>
            </div>
        </div>
        <div class="content-body card">
            <div id="listGrid" class="ag-theme-alpine"></div>
        </div>
    </div>
</div>
<script>
    const returnString = (params) => params.value;

    class ClassBtn {
        init(params) {
            const clbEtprCode = params.data.clbEtprCode;
            const clbConfmAt = params.data.clbConfmAt;
            const clbComfmAtWord = '미운영';
            this.eGui = document.createElement('div');
            if (clbConfmAt == 1) {
                this.eGui.innerHTML = `
                        <button class="closure font-md font-11 color-font-md">미운영 처리</button>
                        <button class="manageMember font-md font-11 color-font-md">회원 관리</button>
                    `;
                this.id = params.data.notiEtprCode;
                this.closureBtn = this.eGui.querySelector(".closure");
                this.manageMemberBtn = this.eGui.querySelector(".manageMember");

                this.closureBtn.onclick = () => {
                    acceptAjax(clbEtprCode, '3');
                };
                this.manageMemberBtn.onclick = () => {
                    window.location.href = `/club/admin/${clbEtprCode}`;
                };
            } else if (clbConfmAt == 3) {
                this.eGui.innerHTML = `
                    <p class="status font-md font-11 color-font-md">미운영</p>
               `;
                const status = this.eGui.querySelector(".status");
            }
        }

        getGui() {
            return this.eGui;
        }
    }

    /* 검색 */
    const getString = function (param) {
        const str = param;
        return str;
    };
    const StringRenderer = function (params) {
        return getString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    function generateRowNumber(params) {
        return params.node.rowIndex + 1;
    }

    function acceptAjax(clbEtprCode, text) {
        $.ajax({
            url: `/club/admin/update`,
            type: "PUT",
            data: JSON.stringify({
                clbConfmAt: text,
                clbEtprCode: clbEtprCode
            }),
            contentType: "application/json; charset=utf-8",
            <%--beforeSend : function(xhr) {--%>
            <%--    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");--%>
            <%--},--%>
            success: function (data) {
                window.location.href = "/club/admin/registList";
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        })
    }

    let rowData = [];
    const columnDefs = [
        {field: "No", headerName: "No", valueGetter: generateRowNumber, cellStyle: {textAlign: "center"}},
        {field: "clbChirmnEmplId", headerName: "사번", cellStyle: {textAlign: "center"}},
        {
            field: "clbNm", headerName: "동호회 이름", getQuickFilterText: (params) => {
                return params.data.clbNm
            }, cellRenderer: StringRenderer, cellStyle: {textAlign: "center"}
        },
        {field: "clbDc", headerName: "동호회 설명", cellRenderer: StringRenderer, cellStyle: {textAlign: "center"}},
        {field: "clbPsncpa", headerName: "동호회 정원", cellStyle: {textAlign: "center"}},
        {field: "clubMbrCnt", headerName: "전체 회원 수", cellStyle: {textAlign: "center"}},
        {field: "clbDate", headerName: "신청 날짜", cellStyle: {textAlign: "center"}},
        {field: "chk", headerName: " ", cellRenderer: ClassBtn, cellStyle: {textAlign: "center"}},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true, cellStyle: {textAlign: "center"}},
    ];
    const Options = {
        columnDefs: columnDefs,
        rowData: rowData,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        rowHeight: 50,
        pagination: true,
        paginationPageSize: 10,
    };

    function customSort(a, b) {
        if (a.clbConfmAt == 1 && b.clbConfmAt != 1) {
            return -1;
        } else if (a.clbConfmAt != 1 && b.clbConfmAt == 1) {
            return 1;
        }
        return 0;
    }

    function loadProposalList() {
        $.ajax({
            url: `/club/admin/registList`,
            type: "POST",
            success: function (data) {
                const sortedData = data.sort(customSort);
                Options.api.setRowData(sortedData);
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        })
    }

    document.addEventListener('DOMContentLoaded', () => {
        const listGrid = document.querySelector('#listGrid');
        loadProposalList();
        new agGrid.Grid(listGrid, Options);
    });
</script>
