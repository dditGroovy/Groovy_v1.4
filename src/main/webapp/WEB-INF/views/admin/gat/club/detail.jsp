<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageClub.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <header id="tab-header">
        <h1><a class="on" href="/club/admin">동호회 관리</a></h1>
    </header>
    <div class="content-wrapper grid">
        <section id="club-info">
            <div class="content-header side-header-wrap">
                <h2 class="font-md font-18 color-font-md">동호회 정보</h2>
                <button id="modify"></button>
            </div>
            <div class="content-body">
                <div class="info-wrapper stroke bg-wht border-radius-24">
                    <div class="info-list">
                        <h3 class="club-clbEtprCode font-md font-14 color-font-high">동호회 번호</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbEtprCode}</p>
                    </div>
                    <div class="bar"></div>
                    <div class="info-list">
                        <h3 class="club-clbDate font-md font-14 color-font-high">등록일</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbDate}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbKind font-md font-14 color-font-high">동호회 종류</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbKind}</p>
                    </div>
                    <div class="bar"></div>
                    <div class="info-list">
                        <h3 class="club-clbNm font-md font-14 color-font-high">동호회 이름</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbNm}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbDc font-md font-14 color-font-high">동호회 설명</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbDc}</p>
                    </div>
                    <div class="bar"></div>
                    <div class="info-list">
                        <h3 class="club-clbPsncpa font-md font-14 color-font-high">동호회 정원(현재 / 전체)</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clubMbrCnt}
                            / ${clubDetail.clbPsncpa}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbChirmnEmplId font-md font-14 color-font-high">동호회 회장(사번)</h3>
                        <p class="content font-reg font-18 color-font-high">${clubDetail.clbChirmnEmplNm}(${clubDetail.clbChirmnEmplId})</p>
                    </div>
                    <div class="bar"></div>
                </div>
                <form id="modify-club" method="post">
                    <div class="info-modify-wrapper stroke bg-wht border-radius-24">
                        <div class="info-list">
                            <h3 class="club-clbEtprCode font-md font-14 color-font-high">동호회 번호</h3>
                            <input type="text" name="clbEtprCode" id="clbEtprCode" value="${clubDetail.clbEtprCode}"
                                   readonly class="content input-free-white">
                        </div>
                        <div class="bar"></div>
                        <div class="info-list">
                            <h3 class="club-clbDate font-md font-14 color-font-high">등록일</h3>
                            <input type="text" name="clbDate" id="clbDate" value="${clubDetail.clbDate}" readonly class="content input-free-white">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbKind font-md font-14 color-font-high">동호회 종류</h3>
                            <input type="text" name="clbKind" id="clbKind" value="${clubDetail.clbKind}" class="content input-free-white">
                        </div>
                        <div class="bar"></div>
                        <div class="info-list">
                            <h3 class="club-clbNm font-md font-14 color-font-high">동호회 이름</h3>
                            <input type="text" name="clbNm" id="clbNm" value="${clubDetail.clbNm}" class="content input-free-white">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbDc font-md font-14 color-font-high">동호회 설명</h3>
                            <input type="text" name="clbDc" id="clbDc" value="${clubDetail.clbDc}" class="content input-free-white">
                        </div>
                        <div class="bar"></div>
                        <div class="info-list">
                            <h3 class="club-clbPsncpa font-md font-14 color-font-high">동호회 정원(현재 / 전체)</h3>
                            <input type="text" name="clbPsncpa" id="clbPsncpa" value="${clubDetail.clbPsncpa}" class="content input-free-white">
                        </div>
                        <div class="info-list ">
                            <h3 class="club-clbChirmnEmplId font-md font-14 color-font-high">동호회 회장(사번)</h3>
                            <div class="display">
                                <input type="text" name="clbChirmnEmplId" id="clbChirmnEmplId"
                                       value="${clubDetail.clbChirmnEmplNm}(${clubDetail.clbChirmnEmplId})" class="content input-free-white">
                                <button id="loadOrgChart" class="btn btn-flat org">사원 찾기</button>
                            </div>
                        </div>
                    </div>
                    <button id="save" class="btn-fill-bl-sm">저장하기</button>
                </form>
            </div>
        </section>
        <section id="club-member-info">
            <div class="content-header side-header-wrap">
                <h2 class="font-md font-18 color-font-md">회원 관리</h2>
            </div>
            <div class="content-body card">
                <div id="agGrid" class="ag-theme-alpine"></div>
            </div>
        </section>
    </div>
</div>
<script>
    const loadOrgChart = document.querySelector("#loadOrgChart");
    const formClub = document.querySelector("#modify-club");
    const modifyBtn = document.querySelector("#modify");
    const saveBtn = document.querySelector("#save");
    let emplId = undefined;
    let clbEtprCode = "${clubDetail.clbEtprCode}";
    loadOrgChart.addEventListener("click", () => {
        let popup = window.open('${pageContext.request.contextPath}/job/jobOrgChart', "조직도", "width = 600, height = 600")
        popup.addEventListener("load", () => {
            const orgCheck = popup.document.querySelector("#orgCheck");
            orgCheck.addEventListener("click", () => {
                const checkboxes = popup.document.querySelectorAll("input[name=orgCheckbox]");
                let str = ``;
                checkboxes.forEach((checkbox) => {
                    if (checkbox.checked) {
                        const label = checkbox.closest("label");
                        emplId = checkbox.id;
                        const emplNm = label.querySelector("span").innerText;
                        document.querySelector("#clbChirmnEmplId").value = `\${emplNm}(\${emplId}`;
                    }
                });
                popup.close();
            });
        });
    })
    formClub.addEventListener("submit", e => e.preventDefault());
    modifyBtn.addEventListener("click", () => {
        saveBtn.style.display = "inline-block";

        document.querySelector("#modify-club").style.display = "block";
        document.querySelector(".info-wrapper").style.display = "none";
        modifyBtn.style.display = "none";
    })
    saveBtn.addEventListener("click", () => {
        clbChirmnEmplId.value = emplId;
        let formData = new FormData(formClub);

        $.ajax({
            url: '/club/admin/updateClubInfo',
            type: 'post',
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function () {
                window.location.href = "/club/admin/" + clbEtprCode;
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
        return false;
    })
    const returnString = (params) => params.value;

    class ClassBtn {
        init(params) {
            const clbEtprCode = params.data.clbEtprCode;
            const clbMbrActAt = params.data.clbMbrActAt;
            const clbMbrEmplId = params.data.clbMbrEmplId;
            this.eGui = document.createElement('div');
            this.eGui.classList = "actionArea";
            if (clbMbrActAt == 0) {
                this.eGui.innerHTML = `
                        <button class="leave font-md font-11 color-font-md">탈퇴 처리</button>
                    `;
                this.id = params.data.notiEtprCode;
                this.leaveBtn = this.eGui.querySelector(".leave");

                this.leaveBtn.onclick = (e) => {
                    const target = e.target;
                    $.ajax({
                        url: `/club/admin/\${clbEtprCode}/\${clbMbrEmplId}`,
                        type: "PUT",
                        success: function (data) {
                            target.closest(".actionArea").innerHTML = '<p class="status">탈퇴</p>';
                        },
                        error: function (request, status, error) {
                            console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                        }
                    })
                };
            } else if (clbMbrActAt == 1) {
                this.eGui.innerHTML = `
                    <p class="status">탈퇴</p>
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

    const columnDefs = [
        {field: "clbMbrEmplId", headerName: "사번", cellStyle: {textAlign: "center"}},
        {
            field: "clbMbrEmplNm", headerName: "사원 이름", getQuickFilterText: (params) => {
                return params.data.clbMbrEmplNm
            }, cellRenderer: StringRenderer, cellStyle: {textAlign: "center"}
        },
        {field: "clbMbrDept", headerName: "부서", cellStyle: {textAlign: "center"}},
        {field: "clbMbrClsf", headerName: "직급", cellStyle: {textAlign: "center"}},
        {field: "chk", headerName: " ", cellRenderer: ClassBtn, cellStyle: {textAlign: "center"}},
        {field: "clbMbrActAt", headerName: "clbMbrActAt", hide: true, sortable: true, cellStyle: {textAlign: "center"}},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true, sortable: true, cellStyle: {textAlign: "center"}},
    ];

    function customSort(a, b) {
        if (a.clbMbrActAt == 0 && b.clbMbrActAt != 0) {
            return -1;
        } else if (a.clbMbrActAt != 0 && b.clbMbrActAt == 0) {
            return 1;
        }
        return 0;
    }

    let rowData = [];
    <c:forEach var="clubMbrVO" items="${clubDetail.clubMbr}" varStatus="status">
    rowData.push({
        clbMbrEmplId: "${clubMbrVO.clbMbrEmplId}",
        clbMbrEmplNm: "${clubMbrVO.clbMbrEmplNm}",
        clbMbrDept: "${clubMbrVO.clbMbrDept}",
        clbMbrClsf: "${clubMbrVO.clbMbrClsf}",
        clbEtprCode: "${clubMbrVO.clbEtprCode}",
        clbMbrActAt: "${clubMbrVO.clbMbrActAt}",
    })
    </c:forEach>
    const Options = {
        columnDefs: columnDefs,
        rowData: rowData,
        onGridReady: function (event) {
            event.api.sizeColumnsToFit();
        },
        pagination: true,
        paginationPageSize: 10,
        rowHeight: 50,
    };
    document.addEventListener('DOMContentLoaded', () => {
        const listGrid = document.querySelector('#agGrid');
        new agGrid.Grid(listGrid, Options);
    });
</script>