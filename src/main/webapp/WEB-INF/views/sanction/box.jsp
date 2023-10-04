<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/sanction.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container sanction-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/sanction/box" class="on">결재 요청</a></h1>
            <h1><a href="${pageContext.request.contextPath}/sanction/document">결재 문서</a></h1>
        </header>

        <main>
            <div class="main-inner sanction-inner">
                <div class="status-wrap">
                    <ul id="sanctionStatus" class="total-status">
                        <li class="status-item total-item">
                            <p class="status-item-title total-item-title">기안한 결재</p>
                            <p class="status-item-content total-item-content"><a href="${pageContext.request.contextPath}/sanction/document" class="strong font-b font-32"></a>건</p>
                        </li>
                        <li class="status-item total-item">
                            <p class="status-item-title total-item-title">완료된 결재</p>
                            <p class="status-item-content total-item-content"><a href="${pageContext.request.contextPath}/sanction/document"  class="strong font-b font-32"></a>건</p>
                        </li>
                        <li class="status-item total-item">
                            <p class="status-item-title total-item-title">반려된 결재</p>
                            <p class="status-item-content total-item-content"><a href="${pageContext.request.contextPath}/sanction/document"  class="strong font-b font-32"></a>건</p>
                        </li>
                    </ul>
                </div>
                <div class="sanction-wrap">
                    <h3 class="main-title">결재 목록</h3>
                    <div class="main-content">
                        <ul class="sanction-list">
                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/vacation/request"
                                   class="btn-3d icon-area" id="refresh">
                                    <h4 class="main-title">연차</h4>
                                    <p class="main-desc">눈치 보지 말고 🙌</p>
                                </a>
                            </li>

                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/vacation/request"
                                   class="btn-3d icon-area" id="vacation">
                                    <h4 class="main-title">여름 휴가</h4>
                                    <p class="main-desc">으른이들의 방학 ✈️</p>
                                </a>
                            </li>
                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/vacation/request"
                                   class="btn-3d icon-area" id="birthday">
                                    <h4 class="main-title">생일</h4>
                                    <p class="main-desc">주인공은 점심에 퇴근해 🎈</p>
                                </a>
                            </li>
                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/vacation/request"
                                   class="btn-3d icon-area" id="event">
                                    <h4 class="main-title">경조사</h4>
                                    <p class="main-desc">기쁠 때나 슬플 때나 <br /> 그루비가 함께합니다 🙆‍♀️</p>
                                </a>
                            </li>
                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/vacation/request"
                                   class="btn-3d icon-area" id="sick">
                                    <h4 class="main-title">병가</h4>
                                    <p class="main-desc">아픈 것도 서러운데 퇴근 🏃‍♂️🏃‍♀️</p>
                                </a>
                            </li>
                            <li class="sanction-list-item">
                                <a href="${pageContext.request.contextPath}/card/request" class="btn-3d icon-area" id="card">
                                    <h4 class="main-title">법인카드 신청</h4>
                                    <p class="main-desc">긴히 쓸 일이 있어요  💳️</p>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script>
        $(document).ready(function () {
            let commonCodeSanctProgrsValues = ["SANCTN010", "SANCTN016", "SANCTN015"];
            let results = [];

            function sendAjaxRequest(index) {
                $.ajax({
                    url: "/sanction/api/status",
                    type: "GET",
                    data: {
                        emplId: "${CustomUser.employeeVO.emplId}",
                        progrs: commonCodeSanctProgrsValues[index]
                    },
                    success: function (data) {
                        results.push(data);
                        if (index < commonCodeSanctProgrsValues.length - 1) {
                            sendAjaxRequest(index + 1);
                        } else {
                            handleResults(results);
                        }
                    }
                });
            }

            sendAjaxRequest(0);

            function handleResults(results) {
                let status = $("#sanctionStatus");
                for (let i = 0; i < 3; i++) { //
                    let $li = status.find("li:eq(" + i + ")");
                    let result = results[i]
                    $li.find("a").text(result);
                }
            }
        });
    </script>
</sec:authorize>