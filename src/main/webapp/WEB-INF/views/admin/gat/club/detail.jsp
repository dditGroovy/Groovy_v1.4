<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<style>
    .content-wrapper {
        display: grid;
        gap: var(--vw-24);
        grid-template-columns: repeat(2, 1fr);
    }

    .info-wrapper, .info-modify-wrapper {
        display: grid;
        width: calc((726 / 1920) * 100vw);
        grid-template-rows: repeat(3, 1fr);
        grid-template-columns: repeat(2, 1fr);
        border: 1px solid black;
    }

    .info-wrapper > .info-list {
        display: flex;
        flex-direction: column;
    }

    #modify-club {
        display: none;
    }

    #save {
        display: none;
    }
</style>
<div class="content-container">
    <h1 class="tab"><a href="/club/admin">동호회 관리</a></h1><br/><br/>
    <div class="content-wrapper">
        <section id="club-info">
            <div class="content-header">
                <h2>동호회 정보</h2>
                <button id="modify">수정</button>
            </div>
            <div class="content-body">
                <div class="info-wrapper">
                    <div class="info-list">
                        <h3 class="club-clbEtprCode">동호회 번호</h3>
                        <p class="content">${clubDetail.clbEtprCode}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbDate">등록일</h3>
                        <p class="content">${clubDetail.clbDate}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbKind">동호회 종류</h3>
                        <p class="content">${clubDetail.clbKind}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbNm">동호회 이름</h3>
                        <p class="content">${clubDetail.clbNm}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbDc">동호회 설명</h3>
                        <p class="content">${clubDetail.clbDc}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbPsncpa">동호회 정원(현재 / 전체)</h3>
                        <p class="content">${clubDetail.clubMbrCnt} / ${clubDetail.clbPsncpa}</p>
                    </div>
                    <div class="info-list">
                        <h3 class="club-clbChirmnEmplId">동호회 회장(사번)</h3>
                        <p class="content">${clubDetail.clbChirmnEmplNm}(${clubDetail.clbChirmnEmplId})</p>
                    </div>
                </div>
                <form id="modify-club" method="post">
                    <div class="info-modify-wrapper">
                        <div class="info-list">
                            <h3 class="club-clbEtprCode">동호회 번호</h3>
                            <input type="text" name="clbEtprCode" id="clbEtprCode" value="${clubDetail.clbEtprCode}"
                                   readonly>
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbDate">등록일</h3>
                            <input type="text" name="clbDate" id="clbDate" value="${clubDetail.clbDate}" readonly>
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbKind">동호회 종류</h3>
                            <input type="text" name="clbKind" id="clbKind" value="${clubDetail.clbKind}">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbNm">동호회 이름</h3>
                            <input type="text" name="clbNm" id="clbNm" value="${clubDetail.clbNm}">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbDc">동호회 설명</h3>
                            <input type="text" name="clbDc" id="clbDc" value="${clubDetail.clbDc}">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbPsncpa">동호회 정원(현재 / 전체)</h3>
                            <input type="text" name="clbPsncpa" id="clbPsncpa" value="${clubDetail.clbPsncpa}">
                        </div>
                        <div class="info-list">
                            <h3 class="club-clbChirmnEmplId">동호회 회장(사번)</h3>
                            <input type="text" name="clbChirmnEmplId" id="clbChirmnEmplId"
                                   value="${clubDetail.clbChirmnEmplNm}(${clubDetail.clbChirmnEmplId})">
                            <button id="loadOrgChart">사원 찾기</button>
                        </div>
                    </div>
                    <button id="save">저장하기</button>
                </form>
            </div>
        </section>
        <section id="club-member-info">
            <div class="content-header">
                <h2>회원 관리</h2>
            </div>
            <div class="content-body">
                <div id="agGrid" class="ag-theme-alpine">
                </div>
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
    console.log(clbEtprCode);
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
            this.eGui.id = "actionArea";
            if (clbMbrActAt == 0) {
                this.eGui.innerHTML = `
                        <button class="leave">탈퇴 처리</button>
                    `;
                this.id = params.data.notiEtprCode;
                this.leaveBtn = this.eGui.querySelector(".leave");

                this.leaveBtn.onclick = () => {
                    $.ajax({
                        url: `/club/admin/\${clbEtprCode}/\${clbMbrEmplId}`,
                        type: "PUT",
                        success: function (data) {
                            document.querySelector("#actionArea").innerHTML = '<p class="status">탈퇴</p>';
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
        {field: "clbMbrEmplId", headerName: "사번"},
        {
            field: "clbMbrEmplNm", headerName: "사원 이름", getQuickFilterText: (params) => {
                return params.data.clbMbrEmplNm
            }, cellRenderer: StringRenderer
        },
        {field: "clbMbrDept", headerName: "부서"},
        {field: "clbMbrClsf", headerName: "직급"},
        {field: "chk", headerName: " ", cellRenderer: ClassBtn},
        {field: "clbMbrActAt", headerName: "clbMbrActAt", hide: true, sortable: true},
        {field: "clbEtprCode", headerName: "clbEtprCode", hide: true, sortable: true},
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
    };
    document.addEventListener('DOMContentLoaded', () => {
        const listGrid = document.querySelector('#agGrid');
        new agGrid.Grid(listGrid, Options);
    });
</script>