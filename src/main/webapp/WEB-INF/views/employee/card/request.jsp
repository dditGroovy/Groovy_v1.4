<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <h1>법인카드 신청</h1>

        <br><br>

        <button type="button" class="btn btn-out-sm btn-modal" data-name="requestCard">법인카드 신청하기</button>
        <button type="button" class="btn btn-out-sm btn-modal" data-name="detailCard">법인카드 디테일</button>
        <br><br>
        <div>
            <h2>법인카드 신청 기록</h2>
            <table border="1">
                <tr>
                    <td>신청 번호</td>
                    <td>사용 기간</td>
                    <td>사용처</td>
                    <td>사용 목적</td>
                    <td>상신 여부</td>
                </tr>
                <c:forEach var="recodeVO" items="${cardRecord}" varStatus="stat">
                    <tr>
                        <td><a href="#" onclick="loadDetail(${recodeVO.cprCardResveSn})" data-name="detailCard">${recodeVO.cprCardResveSn}</a>
                        </td>
                        <td>${recodeVO.cprCardResveBeginDate} - ${recodeVO.cprCardResveClosDate}</td>
                        <td>${recodeVO.cprCardUseLoca}</td>
                        <td>${recodeVO.cprCardUsePurps}</td>
                        <td>${recodeVO.commonCodeYrycState == 'YRYC031'? '상신' : '미상신'}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm requestCard">
            <div class="modal-title">법인카드 신청</div>
            <div class="modal-container">
                <div class="modal-content input-wrap">
                    <form action="${pageContext.request.contextPath}/card/request" method="post"
                          id="cardRequestForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table border="1">
                            <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <tr>
                                <th>기간</th>
                                <td>
                                    <input type="date" name="cprCardResveBeginDate"
                                           placeholder="시작 날짜" required> ~
                                    <input type="date" name="cprCardResveClosDate" placeholder="끝 날짜" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용처</th>
                                <td>
                                    <input type="text" name="cprCardUseLoca" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용목적</th>
                                <td><textarea name="cprCardUsePurps" cols="30" rows="10" placeholder="사용 목적"
                                              required></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>사용예상금액</th>
                                <td>
                                    <input type="number" name="cprCardUseExpectAmount" required>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer btn-wrapper">
                            <button type="submit" class="btn btn-fill-bl-sm" id="requestCard">확인</button>
                            <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal-layer card-df sm detailCard">
            <div class="modal-title">법인카드 신청 내용</div>
            <div class="modal-container">
                <div class="modal-content input-wrap">
                    <table border="1">
                        <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                        <tr>
                            <th>기간</th>
                            <td>
                                <p name="cprCardResveBeginDate"></p> ~ <p name="cprCardResveClosDate"></p>
                            </td>
                        </tr>
                        <tr>
                            <th>사용처</th>
                            <td>
                                <p name="cprCardUseLoca"></p>
                            </td>
                        </tr>
                        <tr>
                            <th>사용목적</th>
                            <td>
                                <p name="cprCardUsePurps"></p>
                            </td>
                        </tr>
                        <tr>
                            <th>사용예상금액</th>
                            <td>
                                <p name="cprCardUseExpectAmount"></p>
                            </td>
                        </tr>
                    </table>
                    <div class="modal-footer btn-wrapper">
                        <button type="submit" class="btn btn-fill-bl-sm" id="modifyRequest">수정하기</button>
                        <button type="submit" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
                        <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/resources/js/modal.js"></script>
    <script>
        const detailCard = document.querySelector(".detailCard");
        $("#requestCard").on("click", function () {
            event.preventDefault();
            let formData = $("#cardRequestForm").serialize();

            $.ajax({
                type: "POST",
                url: $("#cardRequestForm").attr("action"),
                data: formData,
                success: function (res) {
                    alert("법인카드 신청 성공 ")
                },
                error: function (error) {
                    alert("법인카드 신청 실패 ")
                }
            });
        })

        function loadDetail(num,e) {
            e.preventDefault();
            $.ajax({
                type: "GET",
                url: `/card/data/\${num}`,
                success: function (data) {
                    modalOpen();
                    detailCard.classList.add("on");
                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let element = document.getElementById(key);
                            if (element) {
                                element.textContent = value;
                            }
                        }
                    }
                },
                error: function (error) {
                    alert("법인카드 신청 실패 ")
                }
            });
        }

    </script>
</sec:authorize>