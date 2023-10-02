<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<style>
    .short {
        display: flex;
        align-items: center;
    }

    #request-club {
        height: 200px;
    }

    #manage-club {
        height: 400px;
    }
</style>
<div class="content-container">
    <h1 class="tab"><a href="/club/admin">동호회 관리</a></h1><br/><br/>
    <div class="content-wrapper">
        <div class="request-club-wrap">
            <div class="short">
                <h3>동호회 제안</h3>
                <div class="total">
                    <a href="#" class="total-count"></a>
                    건
                    <a href="/club/admin/proposalList" class="more">더보기</a>
                </div>
            </div>
            <div id="request-club" class="ag-theme-alpine"></div>
        </div>
        <br/><br/>
        <div class="manage-club-wrap">
            <div class="short">
                <h3>등록된 동호회</h3>
                <div class="total">
                    <a href="#" class="total-club"></a>
                    개
                    <a href="/club/admin/registList" class="more">더보기</a>
                </div>
            </div>
            <div id="manage-club" class="ag-theme-alpine"></div>
        </div>
    </div>
</div>
<script>
    const returnString = (params) => params.value;
    let totalProposal = 0;
    let totalClub = 0;
    const totalCnt = document.querySelector(".total-count");
    let totalClubCnt = document.querySelector(".total-club");


    class ClassProposalBtn {
        init(params) {
            console.log(params);
            const clbEtprCode = params.data.clbEtprCode
            this.eGui = document.createElement('div');
            this.eGui.innerHTML = `
                        <button class="approve">승인</button>
                        <button class="disapprove">거절</button>
                    `;
            this.id = params.data.notiEtprCode;
            this.approveBtn = this.eGui.querySelector(".approve");
            this.disapproveBtn = this.eGui.querySelector(".disapprove");

            this.approveBtn.onclick = () => {
                acceptAjax(clbEtprCode, '1');
            };
            this.disapproveBtn.onclick = () => {
                acceptAjax(clbEtprCode, '2');
            };
        }

        getGui() {
            return this.eGui;
        }
    }

    class ClassClubBtn {
        init(params) {
            const clbEtprCode = params.data.clbEtprCode
            this.eGui = document.createElement('div');
            this.eGui.innerHTML = `
                        <button class="dormacy">미운영 처리</button>
                        <button class="manage">회원 관리</button>
                    `;
            this.id = params.data.notiEtprCode;
            this.dormacyBtn = this.eGui.querySelector(".dormacy");
            this.manageBtn = this.eGui.querySelector(".manage");

            this.dormacyBtn.onclick = () => {
                acceptAjax(clbEtprCode, "3");
            };
            this.manageBtn.onclick = () => {
                window.location.href = "/club/admin/" + clbEtprCode;
            };
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
                window.location.href = "/club/admin";
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        })
    }

    let rowDataRequest = [];
    const columnDefsRequest = [
        {field: "No", headerName: "No"},
        {field: "clbChirmnEmplId", headerName: "요청한 사원(사번)"},
        {
            field: "clbNm", headerName: "동호회 이름", getQuickFilterText: (params) => {
                return params.data.clbNm
            }
        },
        {field: "clbDc", headerName: "동호회 설명"},
        {field: "clbPsncpa", headerName: "동호회 정원"},
        {field: "clbDate", headerName: "신청 날짜"},
        {field: "chk", headerName: " ", cellRenderer: ClassProposalBtn},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true},
    ];
    <c:forEach var="clubVO" items="${clubList}" varStatus="status">
    rowDataRequest.push({
        No: "${status.count}",
        clbChirmnEmplId: "${clubVO.clbChirmnEmplNm} (${clubVO.clbChirmnEmplId})",
        clbNm: "${clubVO.clbNm}",
        clbDc: "${clubVO.clbDc}",
        clbPsncpa: "${clubVO.clbPsncpa}",
        clbDate: "${clubVO.clbDate}",
        clbEtprCode: "${clubVO.clbEtprCode}",
    })
    totalProposal = ${status.count};
    </c:forEach>
    const gridProposalOptions = {
        columnDefs: columnDefsRequest,
        rowData: rowDataRequest,
    };

    let rowDataRegist = [];
    const columnDefsRegist = [
        {field: "No", headerName: "No"},
        {field: "clbDate", headerName: "등록일"},
        {
            field: "clbNm", headerName: "동호회 이름", getQuickFilterText: (params) => {
                return params.data.clbNm
            }
        },
        {field: "clbPsncpa", headerName: "전체 회원수/정원"},
        {field: "clbChirmnEmplId", headerName: "동호회장(사번)"},
        {field: "chk", headerName: " ", cellRenderer: ClassClubBtn},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true},
    ];
    <c:forEach var="clubRegist" items="${clubRegistList}" varStatus="status">
    rowDataRegist.push({
        No: "${status.count}",
        clbDate: "${clubRegist.clbDate}",
        clbNm: "${clubRegist.clbNm}",
        clbPsncpa: "${clubRegist.clubMbrCnt}/${clubRegist.clbPsncpa}",
        clbChirmnEmplId: "${clubRegist.clbChirmnEmplNm} (${clubRegist.clbChirmnEmplId})",
        clbEtprCode: "${clubRegist.clbEtprCode}",
    })
    totalClub = ${status.count};
    </c:forEach>
    const gridRegistOptions = {
        columnDefs: columnDefsRegist,
        rowData: rowDataRegist,
    };
    document.addEventListener('DOMContentLoaded', () => {
        const requestClubGrid = document.querySelector('#request-club');
        const ManageClubGrid = document.querySelector('#manage-club');
        new agGrid.Grid(requestClubGrid, gridProposalOptions);
        new agGrid.Grid(ManageClubGrid, gridRegistOptions);
        totalCnt.innerText = totalProposal;
        totalClubCnt.innerText = totalClub;
        /*new agGrid.Grid(ManageClubGrid, gridOptions);*/

    });
</script>
