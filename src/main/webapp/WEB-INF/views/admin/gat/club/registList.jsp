<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <h1 class="tab"><a href="/club/admin">동호회 관리</a></h1><br/><br/>
    <div class="content-wrapper">
        <div class="content-header">
            <h2>동호회 운영내역</h2>
        </div>
        <div class="content-body">
            <div id="listGrid" class="ag-theme-alpine">

            </div>
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
            console.log(clbConfmAt);
            this.eGui = document.createElement('div');
            if (clbConfmAt == 1) {
                this.eGui.innerHTML = `
                        <button class="closure">미운영 처리</button>
                        <button class="manageMember">회원 관리</button>
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
                    <p class="status">미운영</p>
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
        {field: "No", headerName: "No", valueGetter: generateRowNumber},
        {field: "clbChirmnEmplId", headerName: "사번"},
        {
            field: "clbNm", headerName: "동호회 이름", getQuickFilterText: (params) => {
                return params.data.clbNm
            }, cellRenderer: StringRenderer
        },
        {field: "clbDc", headerName: "동호회 설명", cellRenderer: StringRenderer},
        {field: "clbPsncpa", headerName: "동호회 정원"},
        {field: "clubMbrCnt", headerName: "전체 회원 수"},
        {field: "clbDate", headerName: "신청 날짜"},
        {field: "chk", headerName: " ", cellRenderer: ClassBtn},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true},
    ];
    const Options = {
        columnDefs: columnDefs,
        rowData: rowData,
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
