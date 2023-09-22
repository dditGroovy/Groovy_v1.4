<div id="modal" class="modal-dim">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm requestVacation">
        <div class="modal-top">
            <div class="modal-title">휴가 신청</div>
            <button type="button" class="modal-close btn js-modal-close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form action="${pageContext.request.contextPath}/vacation/request" method="post"
                  id="vacationRequestForm">
                <div class="modal-content input-wrap">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <table class="form">
                        <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                        <tr>
                            <th>휴가 구분</th>
                            <td>
                                <input type="radio" name="commonCodeYrycUseKind" value="YRYC010" id="vacation1">
                                <label for="vacation1">연차</label>

                                <input type="radio" name="commonCodeYrycUseKind" value="YRYC011" id="vacation2">
                                <label for="vacation2">공가</label>
                            </td>
                        </tr>
                        <tr>
                            <th>종류</th>
                            <td>
                                <input type="radio" name="commonCodeYrycUseSe" id="morning" value="YRYC020">
                                <label for="morning">오전 반차</label>
                                <input type="radio" name="commonCodeYrycUseSe" id="afternoon" value="YRYC021">
                                <label for="afternoon">오후 반차</label>
                                <input type="radio" name="commonCodeYrycUseSe" id="allDay" value="YRYC022">
                                <label for="allDay">종일</label>
                            </td>
                        </tr>
                        <tr>
                            <th>기간</th>
                            <td>
                                <input type="date" name="yrycUseDtlsBeginDate" id="startDay" placeholder="시작 날짜"> ~
                                <input type="date" name="yrycUseDtlsEndDate" id="endDay" placeholder="끝 날짜">
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea name="yrycUseDtlsRm" id="content" cols="30" rows="10"
                                          placeholder="내용"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
        <div class="modal-footer btn-wrapper">
            <button type="submit" class="btn btn-fill-bl-sm" id="requestCard">확인</button>
            <button type="button" class="btn btn-fill-wh-sm close">취소</button>
        </div>
    </div>


    <%--   디테일/수정 모달     --%>
    <div class="modal-layer card-df sm detailVacation">
        <div class="modal-top">
            <div class="modal-title">휴가 신청 내용</div>
            <button type="button" class="modal-close btn js-modal-close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form action="${pageContext.request.contextPath}/vacation/modify/request" method="post"
                  id="vacationModifyForm">
                <div class="modal-content input-wrap">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <table class="form">
                        <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                        <input type="hidden" name="yrycUseDtlsSn" id="sanctionNum"/>
                        <tr>
                            <th>휴가 구분</th>
                            <td>
                                <input type="radio" name="commonCodeYrycUseKind" value="YRYC010" id="vacation1">
                                <label for="vacation1">연차</label>

                                <input type="radio" name="commonCodeYrycUseKind" value="YRYC011" id="vacation2">
                                <label for="vacation2">공가</label>
                            </td>
                        </tr>
                        <tr>
                            <th>종류</th>
                            <td>
                                <input type="radio" name="commonCodeYrycUseSe" id="morning" value="YRYC020">
                                <label for="morning">오전 반차</label>
                                <input type="radio" name="commonCodeYrycUseSe" id="afternoon" value="YRYC021">
                                <label for="afternoon">오후 반차</label>
                                <input type="radio" name="commonCodeYrycUseSe" id="allDay" value="YRYC022">
                                <label for="allDay">종일</label>
                            </td>
                        </tr>
                        <tr>
                            <th>기간</th>
                            <td>
                                <input type="date" name="yrycUseDtlsBeginDate" id="startDay" placeholder="시작 날짜"> ~
                                <input type="date" name="yrycUseDtlsEndDate" id="endDay" placeholder="끝 날짜">
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea name="yrycUseDtlsRm" id="content" cols="30" rows="10"
                                          placeholder="내용"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
        <div class="modal-footer btn-wrapper">
            <div id="beforeBtn">
                <button type="button" class="btn btn-fill-bl-sm" id="modifyRequest">수정하기</button>
                <button type="button" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
            </div>
            <div id="submitBtn" style="display: none">
                <button type="submit" class="btn btn-fill-bl-sm" id="modifySubmit" form="vacationRequestForm">저장하기
                </button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
            <button type="button" class="btn btn-fill-wh-sm close" id="closeBtn" hidden="hidden">닫기</button>
        </div>
    </div>
</div>
    
    
    