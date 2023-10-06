<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/detailEmployee.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/employee/manageEmp" class="on">사원 관리</a></h1>
    </header>
    <div class="side-header-wrap">
        <h1 class="font-md font-18 color-font-md">사원정보</h1>
        <button type="button" id="btn-modify" class="btn btn-free-white btn-sm color-font-md font-14 font-md">수정하기</button>
        <button type="button" id="btn-save" class="btn btn-free-white btn-sm color-font-md font-14 font-md" hidden="hidden">저장하기</button>
    </div>
    <div id="empDetail">
        <form action="#" method="post" id="modifyEmpForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <%--        <input type="hidden" name="enabled" value="1"/>--%>
            <table border="1" class="employeeTable">
                <tr>
                    <td class="title">사원 번호</td>
                    <td><input type="text" name="emplId" id="emplId" value="${empVO.emplId}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">이름</td>
                    <td><input type="text" name="emplNm" value="${empVO.emplNm}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">비밀번호</td>
                    <td><input type="password" name="emplPassword" value="${empVO.emplPassword}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">이메일</td>
                    <td><input type="email" name="#" id="emplEmail" value="${empVO.emplEmail}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">휴대폰 번호</td>
                    <td><input type="text" name="emplTelno" value="${empVO.emplTelno}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">우편번호</td>
                    <td class="addrBox">
                        <input type="text" name="emplZip" class="emplZip" value="${empVO.emplZip}" required readonly>
                        <button type="button" id="findZip" hidden="hidden" class="btn btn-free-blue">우편번호 찾기</button>
                    </td>
                </tr>
                <tr class="quater-row">
                    <td class="title quater-title">주소</td>
                    <td class="quater-content"><input type="text" name="emplAdres" class="emplAdres" value="${empVO.emplAdres}" required readonly></td>
                    <td class="title quater-title">상세주소</td>
                    <td><input type="text" name="emplDetailAdres" class="emplDetailAdres" value="${empVO.emplDetailAdres}" required
                               readonly></td>
                </tr>
                <tr>
                    <td class="title">생년월일</td>
                    <td><input type="date" name="#" value="${empVO.emplBrthdy}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">최종학력</td>
                    <td>
                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu1"
                               value="LAST_ACDMCR010" ${empVO.commonCodeLastAcdmcr == 'LAST_ACDMCR010' ? 'checked' : ''}>
                        <label for="empEdu1">고졸</label>
                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu2"
                               value="LAST_ACDMCR011" ${empVO.commonCodeLastAcdmcr == 'LAST_ACDMCR011' ? 'checked' : ''}>
                        <label for="empEdu2">학사</label>
                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu3"
                               value="LAST_ACDMCR012" ${empVO.commonCodeLastAcdmcr == 'LAST_ACDMCR012' ? 'checked' : ''}>
                        <label for="empEdu3">석사</label>
                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu4"
                               value="LAST_ACDMCR013" ${empVO.commonCodeLastAcdmcr == 'LAST_ACDMCR013' ? 'checked' : ''}>
                        <label for="empEdu4">박사</label>
                    </td>
                </tr>
                <tr>
                    <td class="title">직급</td>
                    <td>
                        <input type="radio" name="commonCodeClsf" id="empPos1"
                               value="CLSF016" ${empVO.commonCodeClsf == 'CLSF016' ? 'checked' : ''}>
                        <label for="empPos1">사원</label>
                        <input type="radio" name="commonCodeClsf" id="empPos2"
                               value="CLSF015" ${empVO.commonCodeClsf == 'CLSF015' ? 'checked' : ''}>
                        <label for="empPos2">대리</label>
                        <input type="radio" name="commonCodeClsf" id="empPos3"
                               value="CLSF014" ${empVO.commonCodeClsf == 'CLSF014' ? 'checked' : ''}>
                        <label for="empPos3">과장</label>
                        <input type="radio" name="commonCodeClsf" id="empPos4"
                               value="CLSF013" ${empVO.commonCodeClsf == 'CLSF013' ? 'checked' : ''}>
                        <label for="empPos4">차장</label>
                        <input type="radio" name="commonCodeClsf" id="empPos5"
                               value="CLSF012" ${empVO.commonCodeClsf == 'CLSF012' ? 'checked' : ''}>
                        <label for="empPos5">팀장</label>
                        <input type="radio" name="commonCodeClsf" id="empPos6"
                               value="CLSF011" ${empVO.commonCodeClsf == 'CLSF011' ? 'checked' : ''}>
                        <label for="empPos6">부장</label>
                        <input type="radio" name="commonCodeClsf" id="empPos7"
                               value="CLSF010" ${empVO.commonCodeClsf == 'CLSF010' ? 'checked' : ''}>
                        <label for="empPos7">대표이사</label>
                    </td>
                    <td class="title">부서</td>
                    <td>
                        <div class="select-wrapper">
                            <select name="commonCodeDept" id="emp-department" class="selectBox">
                                <option value="DEPT010" ${empVO.commonCodeDept == 'DEPT010' ? 'selected' : ''}>인사팀</option>
                                <option value="DEPT011" ${empVO.commonCodeDept == 'DEPT011' ? 'selected' : ''}>회계팀</option>
                                <option value="DEPT012" ${empVO.commonCodeDept == 'DEPT012' ? 'selected' : ''}>영업팀</option>
                                <option value="DEPT013" ${empVO.commonCodeDept == 'DEPT013' ? 'selected' : ''}>홍보팀</option>
                                <option value="DEPT014" ${empVO.commonCodeDept == 'DEPT014' ? 'selected' : ''}>총무팀</option>
                                <option value="DEPT015" ${empVO.commonCodeDept == 'DEPT015' ? 'selected' : ''}>관리직</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="title">입사일</td>
                    <td><input type="date" name="#" id="joinDate" value="${empVO.emplEncpn}" required readonly></td>
                </tr>
                <tr>
                    <td class="title">재직 상태 설정</td>
                    <td>
                        <input type="radio" name="commonCodeHffcSttus" id="office"
                               value="HFFC010" ${empVO.commonCodeHffcSttus == 'HFFC010' ? 'checked' : ''}>
                        <label for="office">재직</label>
                        <input type="radio" name="commonCodeHffcSttus" id="leave"
                               value="HFFC011" ${empVO.commonCodeHffcSttus == 'HFFC011' ? 'checked' : ''}>
                        <label for="leave">휴직</label>
                        <input type="radio" name="commonCodeHffcSttus" id="quit"
                               value="HFFC012" ${empVO.commonCodeHffcSttus == 'HFFC012' ? 'checked' : ''}>
                        <label for="quit">퇴사</label>
                    </td>
                </tr>
            </table>
        </form>

    </div>

</div>
<script>
    $("#btn-save").on("click", function () {
        let formData = new FormData($("#modifyEmpForm")[0]);
        $.ajax({
            type: "POST",
            url: "/employee/modifyEmp",
            data: formData,
            contentType: false,
            processData: false,
            success: function (response) {
                alert("사원 정보 수정 성공")
                $("#btn-save").hide();
                $("#btn-modify").show();
                $("#findZip").prop("hidden", true);
            },
            error: function (xhr, textStatus, error) {
                // 오류 발생 시 처리
            }
        });
    })

    $("#btn-modify").on("click", function () {
        $("#findZip").prop("hidden", false)
        let inputElements = $("#empDetail form input");
        inputElements.each(function () {
            $(this).removeAttr("readonly");
        });
        let saveBtn = $("#btn-save").removeAttr("hidden");
        $(this).hide();
    })

    // 다음 주소 API
    $("#findZip").on("click", function () {
        new daum.Postcode({
            oncomplete: function (data) {
                $(".emplZip").val(data.zonecode);
                $(".emplAdres").val(data.address);
                $(".emplDetailAdres").val("")
                $(".emplDetailAdres").focus();
            }
        }).open();
    })
</script>
