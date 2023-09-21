<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="content-container">
    <h1>사원 관리</h1>
    <h2>사원추가</h2>
    <button>사원추가</button>
    <!--    사원 추가 모달   -->
    <div id="addEmployeeModal" class="modal">
        <div class="modal-content">
            <form name="insertEmp" action="/employee/inputEmp" method="post">
                <!-- seoju : csrf 토큰 추가-->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="enabled" value="1"/>
                <input type="hidden" name="proflPhotoFileStreNm" value="groovy_noProfile.png"/>
                <input type="hidden" name="signPhotoFileStreNm" value="groovy_noSign.png"/>
                <label>비밀번호</label>
                <input type="password" name="emplPassword" required><br/>

                <label>이름</label>
                <input type="text" name="emplNm" required><br/>

                <label>휴대폰 번호</label>
                <input type="text" name="emplTelno" required><br/>


                <label>우편번호</label>
                <input type="text" name="emplZip" class="emplZip" required><br/>
                <button type="button" id="findZip">우편번호 찾기</button>

                <label>주소</label>
                <input type="text" name="emplAdres" class="emplAdres" required><br/>
                <label>상세주소</label>
                <input type="text" name="emplDetailAdres" class="emplDetailAdres" required><br/>


                <label>생년월일</label>
                <input type="date" value="2000-01-01" name="emplBrthdy" required><br/>


                <%-- commonCodeLastAcdmcr --%>
                <label>최종학력</label>
                <input type="radio" name="commonCodeLastAcdmcr" id="empEdu1" value="LAST_ACDMCR010" checked>
                <label for="empEdu1">고졸</label>
                <input type="radio" name="commonCodeLastAcdmcr" id="empEdu2" value="LAST_ACDMCR011">
                <label for="empEdu2">학사</label>
                <input type="radio" name="commonCodeLastAcdmcr" id="empEdu3" value="LAST_ACDMCR012">
                <label for="empEdu3">석사</label>
                <input type="radio" name="commonCodeLastAcdmcr" id="empEdu4" value="LAST_ACDMCR013">
                <label for="empEdu3">박사</label><br/>

                <%-- commonCodeClsf --%>
                <label>직급</label>
                <input type="radio" name="commonCodeClsf" id="empPos1" value="CLSF016" checked>
                <label for="empPos1">사원</label>
                <input type="radio" name="commonCodeClsf" id="empPos2" value="CLSF015">
                <label for="empPos2">대리</label>
                <input type="radio" name="commonCodeClsf" id="empPos3" value="CLSF014">
                <label for="empPos3">과장</label>
                <input type="radio" name="commonCodeClsf" id="empPos4" value="CLSF013">
                <label for="empPos4">차장</label>
                <input type="radio" name="commonCodeClsf" id="empPos5" value="CLSF012">
                <label for="empPos5">팀장</label>
                <input type="radio" name="commonCodeClsf" id="empPos6" value="CLSF011">
                <label for="empPos6">부장</label>
                <%--TODO 지우기 --%>
                <input type="radio" name="commonCodeClsf" id="empPos7" value="CLSF010">
                <label for="empPos7">대표이사</label>

                <%-- commonCodeDept --%>
                <label>부서</label>
                <select name="commonCodeDept" id="emp-department">
                    <option value="DEPT010">인사팀</option>
                    <option value="DEPT011">회계팀</option>
                    <option value="DEPT012">영업팀</option>
                    <option value="DEPT013">홍보팀</option>
                    <option value="DEPT014">총무팀</option>
                    <%--TODO 지우기 --%>
                    <option value="DEPT015">경영자</option>
                </select><br/>

                <label>입사일</label>
                <input type="date" value="" name="emplEncpn" id="joinDate" required><br/>
                <label>사원번호</label>
                <input type="text" name="emplId" id="emplId" required readonly>
                <button id="generateId" type="button">사원 번호 생성</button>
                <br/>

                <label>이메일</label>
                <input type="email" name="emplEmail" id="emplEmail" required><br/>

                <label>재직 상태 설정</label>
                <input type="radio" name="commonCodeHffcSttus" id="office" value="HFFC010" checked>
                <label for="office">재직</label>
                <input type="radio" name="commonCodeHffcSttus" id="leave" value="HFFC011">
                <label for="leave">휴직</label>
                <input type="radio" name="commonCodeHffcSttus" id="quit" value="HFFC012">
                <label for="quit">퇴사</label>
                <br/><br/>
                <button type="submit" id="insert">등록</button>
                <button type="reset">지우기</button>
            </form>
        </div>
    </div>
    <hr/>


    <form action="#" method="GET">
        <label>부서 필터</label>
        <select name="searchDepCode">
            <option value="DEPT010">인사팀</option>
            <option value="DEPT011">회계팀</option>
            <option value="DEPT012">영업팀</option>
            <option value="DEPT013">홍보팀</option>
            <option value="DEPT014">총무팀</option>
            <option value="DEPT015">경영자</option>
        </select>
        <label>
            <input type="text" name="searchName">
        </label>
        <label>정렬</label>
        <select name="sortBy" class="sortBy">
            <option value="EMPL_ENCPN">입사일</option>
            <option value="EMPL_NM">이름순</option>
            <option value="COMMON_CODE_CLSF">직급순</option>
        </select>
        <button type="button" id="findEmp">검색</button>
    </form>

    <br/><br/>


    <%--<hr/>--%>
    <%--<h2>사원 조회 및 엑셀로 내보내기</h2>--%>
    <%--<form action="#" method="GET">--%>
    <%--    <button type="exportExc">엑셀로 내보내기</button>--%>
    <%--</form>--%>

    <!-- 사원 목록 -->
    <div id="empList"></div>

</div>
<script>
    $("#findZip").on("click", function () {
        // 다음 주소 API
        new daum.Postcode({
            oncomplete: function (data) {
                $(".emplZip").val(data.zonecode);
                $(".emplAdres").val(data.address);
                $(".emplDetailAdres").focus();
            }
        }).open();
    })

    $(document).ready(function () {

        let joinDateVal = undefined;
        const emplEncpn = document.querySelector("input[name=emplEncpn]");
        const emplId = document.querySelector("input[name=emplId]");
        const emplEmail = document.querySelector("input[name=emplEmail]");

        $(document).on("click", "#findEmp", function () {
            const depCodeValue = $("select[name=searchDepCode]").val();
            const emplNameValue = $("input[name=searchName]").val();
            const sortByValue = $(".sortBy").val();

            $.ajax({
                url: "/employee/findEmp",
                type: "get",
                data: {
                    depCode: depCodeValue,
                    emplNm: emplNameValue,
                    sortBy: sortByValue
                },
                contentType: "application/json;charset=utf-8",
                success: function (res) {
                    console.log("findEmp success");
                    let code = "<table border=1>";
                    code += `<thead><tr><th>번호</th><th><input type="checkbox" id="selectAll"></th><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (res.length === 0) {
                        code += "<td colspan='8'>검색 결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < res.length; i++) {
                            code += `<tr><td>\${i+1}</td>`;
                            code += `<td><input type="checkbox" class="selectEmp"></td>`;
                            code += `<td>\${res[i].emplId}</td>`;
                            code += `<td>\${res[i].emplNm}</td>`;
                            code += `<td>\${res[i].commonCodeDept}</td>`;
                            code += `<td>\${res[i].commonCodeClsf}</td>`;
                            code += `<td>\${res[i].emplEncpn}</td>`;
                            code += `<td>\${res[i].emplBrthdy}</td>`;
                            code += `<td>\${res[i].signPhotoFileStreNm == 'groovy_noSign.png' ? "미등록" : "등록완료"}</td>`;
                            code += `<td>\${(res[i].commonCodeHffcSttus == 'HFFC010') ? "재직" : (res[i].commonCodeHffcSttus == 'HFFC011') ? "휴직" : "퇴직"}</td>`;
                            code += "</tr>";
                        }
                    }
                    code += "</tbody></table>";

                    $("#empList").html(code);
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + error);
                }
            });
        });

        // 입사일 선택 - value 값 변경
        emplEncpn.addEventListener("change", function () {
            joinDateVal = this.value;
            console.log(joinDateVal);
        });
        // 사번 생성 버튼 클릭 이벤트
        document.querySelector("#generateId").addEventListener("click", function () {
            // 사원 수 + 1 인덱스 처리
            $.ajax({
                url: "/employee/countEmp",
                type: 'GET',
                dataType: 'text',
                success: function (data) {
                    // 사번 생성 (idx 3글자로 설정함)
                    const dateSplit = joinDateVal.split("-");
                    let count = parseInt(data) + 1;
                    let idx = count.toString().padStart(3, '0');
                    emplId.value = dateSplit[0] + dateSplit[1] + idx;
                    // 사번에 따른 사원 이메일 생성
                    if (emplId.value !== "") {
                        emplEmail.value = emplId.value + "@groovy.co.kr";
                    }
                },
                error: function (xhr) {
                    console.log(xhr.status)
                }
            })
        })

        /*사원 목록 불러오기 */
        function getEmpList() {
            $.ajax({
                type: "get",
                url: "/employee/loadEmpList",
                dataType: "json",
                success: function (res) {
                    console.log("loadEmp success");
                    let code = "<table border=1>";
                    code += `<thead><tr><th>번호</th><th><input type="checkbox" id="selectAll"></th><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (res.length === 0) {
                        code += "<td colspan='8'>결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < res.length; i++) {
                            code += `<tr><td>\${i+1}</td>`;
                            code += `<td><input type="checkbox" class="selectEmp"></td>`;
                            code += `<td><a href="/employee/loadEmp/\${res[i].emplId}">\${res[i].emplId}</a></td>`;
                            code += `<td>\${res[i].emplNm}</td>`;
                            code += `<td>\${res[i].commonCodeDept}</td>`;
                            code += `<td>\${res[i].commonCodeClsf}</td>`;
                            code += `<td>\${res[i].emplEncpn}</td>`;
                            code += `<td>\${res[i].emplBrthdy}</td>`;
                            code += `<td>\${res[i].signPhotoFileStreNm == 'groovy_noSign.png' ? "미등록" : "등록완료"}</td>`;
                            code += `<td>\${(res[i].commonCodeHffcSttus == 'HFFC010') ? "재직" : (res[i].commonCodeHffcSttus == 'HFFC011') ? "휴직" : "퇴직"}</td>`;
                            code += "</tr>";
                        }
                    }
                    code += "</tbody></table>";
                    $("#empList").html(code);
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + error);
                }
            });
        }

        getEmpList();

        // 사원 리스트 - 전체 선택
        $(document).on("click", "#selectAll", function () {
            const checked = document.querySelectorAll(".selectEmp");
            checked.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
    })
</script>
