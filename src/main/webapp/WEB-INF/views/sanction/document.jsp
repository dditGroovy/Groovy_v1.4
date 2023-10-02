<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/sanction.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container sanction-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/sanction/box">결재 요청</a></h1>
            <h1><a href="${pageContext.request.contextPath}/sanction/document" class="on">결재 문서</a></h1>
        </header>
        <main>
            <div class="main-inner">
                <div class="tab-wrap">
                    <div id="tabs">
                        <input type="radio" name="tabs" id="request" checked>
                        <label for="request" class="tab">기안 문서</label>
                        <input type="radio" name="tabs" id="approve">
                        <label for="approve" class="tab">결재 문서</label>
                        <input type="radio" name="tabs" id="reference">
                        <label for="reference" class="tab">참조 문서</label>
                        <div class="glider"></div>
                    </div>
                </div>
                <div id="inProgress" class="card-df">
                </div>
            </div>
        </main>
</div>
    <script src="${pageContext.request.contextPath}/resources/js/sanction.js"></script>

    <script>
        $(document).ready(function () {
            let emplId = "${CustomUser.employeeVO.emplId}";
            loadRequest(); // 기본적으로 기안 문서 불러오기
           /* const gridRegistOptions = {
                columnDefs: columnDefsRequest,
                rowData: rowDataRequest,
                pagination:true,
                paginationPageSize: 10,
            };*/
            function loadRequest(){
                $.ajax({
                    type: "GET",
                    url: `/sanction/api/request/\${emplId}`,
                    success: function (res) {
                        let code = "<table class='form approval-form'>";
                        code += `<thead><tr><th class="sticky-th">문서번호</th><th class="sticky-th">상태</th><th class="sticky-th">결재양식</th><th class="sticky-th">제목</th><th class="sticky-th">기안일시</th></tr></thead><tbody>`;
                        if (res.length === 0) {
                            code += "<tr style='height: 100%;'><td colspan='8'>기안 결재 문서가 없습니다</td></tr>";
                        } else {
                            for (let i = 0; i < res.length; i++) {
                                code += `<tr><td><a href="${pageContext.request.contextPath}/sanction/read/\${res[i].elctrnSanctnEtprCode}" class="openSanction link"> \${res[i].elctrnSanctnEtprCode}</a></td>`;
                                code += `<td>\${res[i].commonCodeSanctProgrs}</td>`;
                                code += `<td>\${res[i].elctrnSanctnFormatCode}</td>`;
                                code += `<td>\${res[i].elctrnSanctnSj}</td>`;
                                code += `<td>\${res[i].elctrnSanctnRecomDate}</td>`;
                                code += "</tr>";
                            }
                        }
                        code += "</tbody></table>";
                        $("#inProgress").html(code);
                        $(".openSanction").click(function (event) {
                            event.preventDefault();
                            window.open($(this).attr("href"), "결재", getWindowSize());
                        });
                    }
                });
            }
            $("#request").on("click", function () {
                // 진행 중(상신)
                loadRequest();
            })
            /*
              결재 문서 불러오기
            */
            $("#approve").on("click", function () {
                $.ajax({
                    url: `/sanction/api/awaiting/\${emplId}`,
                    type: 'GET',
                    success: function (res) {

                        let code = "<table class='form approval-form'>";
                        code += `<thead><tr><th class="sticky-th">문서번호</th><th class="sticky-th">상태</th><th class="sticky-th">제목</th><th class="sticky-th">기안자</th><th class="sticky-th">기안일시</th></tr></thead><tbody>`;
                        if (res.length === 0) {
                            code += "<tr style='height: 100%;'><td colspan='8'>결재 대기 및 예정 문서가 없습니다</td></tr>";
                        } else {
                            for (let i = 0; i < res.length; i++) {
                                code += `<tr><td><a href="${pageContext.request.contextPath}/sanction/read/\${res[i].elctrnSanctnEtprCode}" class="openSanction link"> \${res[i].elctrnSanctnEtprCode}</a></td>`;
                                code += `<td>\${res[i].commonCodeSanctProgrs}</td>`;
                                code += `<td>\${res[i].elctrnSanctnSj}</td>`;
                                code += `<td>\${res[i].emplNm}</td>`;
                                code += `<td>\${res[i].elctrnSanctnRecomDate}</td>`;
                                code += "</tr>";
                            }
                        }
                        code += "</tbody></table>";
                        $("#inProgress").html(code);
                        $(".openSanction").click(function (event) {
                            event.preventDefault();
                            window.open($(this).attr("href"), "결재", getWindowSize());
                        });
                    }
                })
            })
            /*
              참조 문서 불러오기
            */
            $("#reference").on("click", function () {
                $.ajax({
                    url: `/sanction/api/reference/\${emplId}`,
                    type: 'GET',
                    success: function (res) {
                        let code = "<table class='form approval-form'>";
                        code += `<thead><tr><th class="sticky-th">문서번호</th><th class="sticky-th">상태</th><th class="sticky-th">제목</th><th class="sticky-th">기안자</th><th class="sticky-th">기안일시</th></tr></thead><tbody>`;
                        if (res.length === 0) {
                            code += "<tr style='height: 100%;'><td colspan='8'>참조 결재 문서가 없습니다</td></tr>";
                        } else {
                            for (let i = 0; i < res.length; i++) {
                                code += `<tr><td><a href="${pageContext.request.contextPath}/sanction/read/\${res[i].elctrnSanctnEtprCode}" class="openSanction link"> \${res[i].elctrnSanctnEtprCode}</a></td>`;
                                code += `<td>\${res[i].commonCodeSanctProgrs}</td>`;
                                code += `<td>\${res[i].elctrnSanctnSj}</td>`;
                                code += `<td>\${res[i].emplNm}</td>`;
                                code += `<td>\${res[i].elctrnSanctnRecomDate}</td>`;
                                code += "</tr>";
                            }
                        }
                        code += "</tbody></table>";
                        $("#inProgress").html(code);
                        $(".openSanction").click(function (event) {
                            event.preventDefault();
                            window.open($(this).attr("href"), "결재", getWindowSize());
                        });
                    }
                })
            })

        })
    </script>

</sec:authorize>
