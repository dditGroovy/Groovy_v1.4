<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/card/request" class="on">법인카드 신청</a></h1>
        </header>
        <button type="button" class="btn btn-out-sm btn-modal" data-name="requestCard" data-action="request">법인카드 신청하기
        </button>
        <br><br>
        <div>
            <h3 class="content-title font-b">법인카드 신청 기록</h3>
            <table border="1">
                <tr>
                    <td>신청 번호</td>
                    <td>사용 기간</td>
                    <td>사용처</td>
                    <td>사용 목적</td>
                    <td>결재 상태</td>
                </tr>
                <c:forEach var="recodeVO" items="${cardRecord}" varStatus="stat">
                    <tr>
                        <td><a href="#" data-name="detailCard" data-seq="${recodeVO.cprCardResveSn}"
                               class="detailLink">${stat.count}</a></td>
                        <td>${recodeVO.cprCardResveBeginDate} - ${recodeVO.cprCardResveClosDate}</td>
                        <td>${recodeVO.cprCardUseLoca}</td>
                        <td>${recodeVO.cprCardUsePurps}</td>
                        <td>${(recodeVO.commonCodeYrycState == 'YRYC030')? '미상신' : (recodeVO.commonCodeYrycState == 'YRYC031') ? '상신' : '승인'}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm requestCard">
            <div class="modal-top">
                <div class="modal-title">법인카드 신청</div>
                <button type="button" class="modal-close btn js-modal-close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
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
                                    <input type="date" name="cprCardResveBeginDate" class="input-free-white"
                                           placeholder="시작 날짜" required> ~
                                    <input type="date" name="cprCardResveClosDate" class="input-free-white"
                                           placeholder="끝 날짜" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용처</th>
                                <td>
                                    <input type="text" name="cprCardUseLoca" class="input-free-white" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용목적</th>
                                <td><textarea name="cprCardUsePurps" class="input-free-white" cols="30" rows="10"
                                              placeholder="사용 목적"
                                              required></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>사용예상금액</th>
                                <td>
                                    <input type="number" name="cprCardUseExpectAmount" class="input-free-white"
                                           required>
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
            <div class="modal-top">
                <div class="modal-title">법인카드 신청 내용</div>
                <button type="button" class="modal-close btn js-modal-close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <div class="modal-content input-wrap">
                    <form action="${pageContext.request.contextPath}/card/modify/request" method="post"
                          id="cardModifyForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table border="1">
                            <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <input type="hidden" name="cprCardResveSn" id="sanctionNum"/>
                            <tr>
                                <th>기간</th>
                                <td>
                                    <input type="date" name="cprCardResveBeginDate" class="input-free-white"
                                           placeholder="시작 날짜" required> ~
                                    <input type="date" name="cprCardResveClosDate" class="input-free-white"
                                           placeholder="끝 날짜" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용처</th>
                                <td>
                                    <input type="text" name="cprCardUseLoca" class="input-free-white" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용목적</th>
                                <td><textarea name="cprCardUsePurps" class="input-free-white" cols="30" rows="10"
                                              required></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>사용예상금액</th>
                                <td>
                                    <input type="text" name="cprCardUseExpectAmount" class="input-free-white" required>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer btn-wrapper" id="beforeBtn" style="display: none">
                            <button type="button" class="btn btn-fill-bl-sm" id="modifyRequest">수정하기</button>
                            <button type="button" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
                        </div>
                        <div class="modal-footer btn-wrapper" id="submitBtn" style="display: none">
                            <button type="submit" class="btn btn-fill-bl-sm" id="modifySubmit">저장하기</button>
                        </div>
                        <div class="modal-footer btn-wrapper">
                                <%--  TODO 나중에 헤더에 X로 처리하기 버튼 세개라 별루  --%>
                            <button type="button" class="btn btn-fill-wh-sm close">닫기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="/resources/js/modal.js"></script>
    <script>
        const detailCard = document.querySelector(".detailCard");
        const detailLink = document.querySelectorAll(".detailLink");

        detailLink.forEach(link => {
            link.addEventListener("click", e => {
                const num = link.getAttribute("data-seq");
                loadDetail(num);
            })

        })

        $("#startSanction").on("click", function () {
            $("#modifyRequest").prop("disabled", true)
            window.open('/sanction/format/DEPT011/SANCTN_FORMAT010', "결재", "width = 1200, height = 1200")
        })

        function refreshParent() {
            window.location.reload(); // 새로고침
            $("#modifyRequest").prop("disabled", false)
        }

        // 수정 후 제출
        $("#modifySubmit").on("click", function () {
            event.preventDefault();
            let formData = $("#cardModifyForm").serialize();

            $.ajax({
                type: "POST",
                url: $("#cardModifyForm").attr("action"),
                data: formData,
                success: function (res) {
                    alert("법인카드 수정 성공 ")
                    resetModal();
                },
                error: function (error) {
                    alert("법인카드 수정 실패 ")
                }
            });
        })
        // 법인카드 사용 신청 제출
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

        function loadDetail(num) {
            $.ajax({
                type: "GET",
                url: `/card/data/\${num}`,
                success: function (data) {
                    modalOpen();
                    detailCard.classList.add("on");
                    let form = $("#cardModifyForm");

                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let inputElement = form.find(`input[name="\${key}"]`);
                            let textareaElement = form.find(`textarea[name="\${key}"]`);

                            if (inputElement.length) {
                                if (key === "cprCardUseExpectAmount") {
                                    value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + "원";
                                }
                                inputElement.val(value);
                                inputElement.css("border", "none");
                            } else if (textareaElement.length) {
                                textareaElement.val(value);
                                textareaElement.css("border", "none");
                            }
                        }
                    }

                    if (data['commonCodeYrycState'] === 'YRYC030') {
                        $('#beforeBtn').css("display", "");
                    } else {
                        $('#beforeBtn').css("display", "none");
                    }

                },
                error: function (error) {
                    console.log("loadDatail 실패")
                }
            });
        }

        $("#modifyRequest").on("click", function () {
            let form = $("#cardModifyForm");
            let inputElement = form.find("input[name='cprCardUseExpectAmount']");
            let value = inputElement.val();
            value = value.replace(/,/g, '').replace('원', '');
            inputElement.val(value);
            $("#startSanction").prop("hidden", true)
            $("#beforeBtn").css("display", "none");
            $("#submitBtn").css("display", "");
        });

        $(".close").on("click", function () {
            resetModal();
        });

        function resetModal() {
            $("#submitBtn").css("display", "none");
            $("#beforeBtn").css("display", "");
            $("#startSanction").prop("hidden", false);
        }
    </script>
</sec:authorize>

