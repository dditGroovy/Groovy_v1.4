<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/resources/css/admin/manageEmployee.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 사원 추가 모달 -->
<div id="modal" class="modal-dim" style="display: none">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm emplCard" style="display: block">
        <div class="modal-top">
            <div class="modal-title"><i class="icon-user"></i>사원 추가</div>
            <button type="button" class="modal-close btn js-modal-close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form name="insertEmp" action="/employee/inputEmp" method="post">
                <div class="modal-content">
                    <div class="accordion-wrap">
                        <div class="que" onclick="accordion(this);">
                            <p class="font-md font-18 color-font-md">1. 기본 정보 입력</p>
                            <i class="icon i-arr-bt"></i>
                        </div>
                        <div class="anw">
                            <div class="grid-anw">
                                <!-- seoju : csrf 토큰 추가-->
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="enabled" value="1"/>
                                <input type="hidden" name="proflPhotoFileStreNm" value="groovy_noProfile.png"/>
                                <input type="hidden" name="signPhotoFileStreNm" value="groovy_noSign.png"/>
                                <div class="accordion-row">
                                    <label>이름</label><br/>
                                    <input type="text" name="emplNm" placeholder="이름 입력" required><br/>
                                </div>
                                <div class="accordion-row">
                                    <label>비밀번호</label><br/>
                                    <input type="password" name="emplPassword" placeholder="비밀번호 입력" required><br/>
                                </div>
                                <div class="accordion-row">
                                    <label>이메일</label><br/>
                                    <input type="email" name="emplEmail" id="emplEmail" placeholder="이메일 입력" required><br/>
                                </div>
                                <div class="accordion-row">
                                    <label>휴대폰 번호</label><br/>
                                    <input type="text" name="emplTelno" placeholder="휴대폰 번호 입력" required><br/>
                                </div>
                                <div class="accordion-row">
                                    <label class="checkBoxLabel">최종학력</label><br/>
                                    <div class="radioBox">
                                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu1" value="LAST_ACDMCR010" checked>
                                        <label for="empEdu1">고졸</label>
                                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu2" value="LAST_ACDMCR011">
                                        <label for="empEdu2">학사</label>
                                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu3" value="LAST_ACDMCR012">
                                        <label for="empEdu3">석사</label>
                                        <input type="radio" name="commonCodeLastAcdmcr" id="empEdu4" value="LAST_ACDMCR013">
                                        <label for="empEdu3">박사</label><br/>
                                    </div>
                                </div>
                                <div class="accordion-row">
                                    <label>생년월일</label><br/>
                                    <input type="date" value="2000-01-01" name="emplBrthdy" required><br/>
                                </div>
                            </div>
                            <div class="accordion-row">
                                <label>우편번호</label>
                                <button type="button" id="findZip" class="btn btn-free-blue">우편번호 찾기</button>
                                <input type="text" name="emplZip" class="emplZip" required><br/>
                                <div class="addrWrap">
                                    <div>
                                        <label>주소</label><br/>
                                        <input type="text" name="emplAdres" class="emplAdres" required>
                                    </div>
                                    <div>
                                        <label>상세주소</label>
                                        <input type="text" name="emplDetailAdres" class="emplDetailAdres" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-wrap">
                        <div class="que" onclick="accordion(this)">
                            <p class="font-md font-18 color-font-md">2. 인사 정보 입력</p>
                            <i class="icon i-arr-bt"></i>
                        </div>
                        <div class="anw">
                            <div class="accordion-row">
                                <label>부서</label> <br/>
                                <div class="select-wrapper">
                                    <select name="commonCodeDept" id="emp-department" class="stroke selectBox">
                                        <option value="DEPT010">인사팀</option>
                                        <option value="DEPT012">영업팀</option>
                                        <option value="DEPT013">홍보팀</option>
                                        <option value="DEPT014">총무팀</option>
                                        <option value="DEPT015">경영자</option>
                                    </select>
                                </div>
                            </div>
                            <div class="accordion-row">
                                <label>직급</label> <br/>
                                <div class="radioBox">
                                    <input type="radio" name="commonCodeClsf" id="empPos1" value="CLSF016" checked>
                                    <label for="empPos1" class="radioLabel">사원</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos2" value="CLSF015">
                                    <label for="empPos2" class="radioLabel">대리</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos3" value="CLSF014">
                                    <label for="empPos3" class="radioLabel">과장</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos4" value="CLSF013">
                                    <label for="empPos4" class="radioLabel">차장</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos5" value="CLSF012">
                                    <label for="empPos5" class="radioLabel">팀장</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos6" value="CLSF011">
                                    <label for="empPos6" class="radioLabel">부장</label>
                                    <input type="radio" name="commonCodeClsf" id="empPos7" value="CLSF010">
                                    <label for="empPos7" class="radioLabel">대표이사</label>
                                </div>
                            </div>
                            <div class="accordion-row">
                                <label>입사일</label> <br/>
                                <input type="date" value="" name="emplEncpn" id="joinDate" required><br/>
                            </div>
                            <div class="accordion-row">
                                <label>사원번호</label>
                                <button id="generateId" type="button" class="btn btn-free-blue empBtn">사원 번호 생성</button>
                                <input type="text" name="emplId" id="emplId" required readonly>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-wrap">
                        <div class="que" onclick="accordion(this)">
                            <p class="font-md font-18 color-font-md">3. 재직 상태 설정</p>
                            <i class="icon i-arr-bt"></i>
                        </div>
                        <div class="anw">
                            <div class="radioBox radio-box">
                                <input type="radio" name="commonCodeHffcSttus" id="office" value="HFFC010" checked>
                                <label for="office">재직</label>
                                <input type="radio" name="commonCodeHffcSttus" id="leave" value="HFFC011">
                                <label for="leave">휴직</label>
                                <input type="radio" name="commonCodeHffcSttus" id="quit" value="HFFC012">
                                <label for="quit">퇴사</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer btn-wrapper">
                        <button type="reset" class="btn btn-fill-wh-sm close">취소</button>
                        <button type="submit" id="insert" class="btn btn-fill-bl-sm">등록</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="content-container">
    <div class="header">
        <h1 class="font-md font-36">사원 관리</h1>
    </div>
    <div class="formBox">
        <form action="#" method="GET">
            <div class="headerWrap">
                <div class="header-container">
                    <div class="select-wrapper">
                        <select name="searchDepCode" class="stroke selectBox font-md font-14">
                            <option value="">부서 선택</option>
                            <option value="DEPT010">인사팀</option>
                            <option value="DEPT011">회계팀</option>
                            <option value="DEPT012">영업팀</option>
                            <option value="DEPT013">홍보팀</option>
                            <option value="DEPT014">총무팀</option>
                            <option value="DEPT015">경영자</option>
                        </select>
                    </div>
                    <div class="select-wrapper">
                        <select name="sortBy" class="sortBy stroke selectBox font-md font-14">
                            <option value="EMPL_ENCPN">입사일</option>
                            <option value="EMPL_NM">이름순</option>
                            <option value="COMMON_CODE_CLSF">직급순</option>
                        </select>
                    </div>
                    <div class="search btn-fill-wh-lg">
                        <i class="icon i-search"></i>
                        <input type="text" name="searchName" class="search-input font-reg font-14" placeholder="이름, 사번">
                        <button type="button" id="findEmp" class="btn-search btn-flat btn">검색</button>
                    </div>
                </div>
                <button type="button" id="addEmployee" data-name="emplCard"
                        class="btn btn-fill-bl-sm font-md font-18 btn-modal">사원추가 <i
                        class="icon i-add-white"></i></button>
            </div>
        </form>
    </div>
    <div id="countWrap" class="color-font-md">전체 <span id="countBox" class="font-b font-14"></span></div>

    <!-- 사원 목록 -->
    <div id="empList"></div>

</div>
<script src="/resources/js/modal.js"></script>
<script>
    function accordion(element) {
        var before = document.querySelector(".accordion-active");
        var content = element.nextElementSibling;

        if (before && before !== element) {
            before.nextElementSibling.style.maxHeight = null;
            before.classList.remove("accordion-active");
        }
        element.classList.toggle("accordion-active");

        if (content.style.maxHeight !== "0px") {
            content.style.maxHeight = "0px";
        } else {
            let anws = document.querySelectorAll(".anw");
            anws.forEach( anw => {
                anw.style.maxHeight = "0px";
            });
            content.style.maxHeight = content.scrollHeight + "px";
            content.style.borderTop = "1px solid var(--color-stroke)";
        }
    }

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
        let count;

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
                    console.log(res);
                    count = res.length;
                    document.querySelector("#countBox").innerText = count;
                    console.log("findEmp success");
                    let code = "<table border=1 class='employeeTable'>";
                    code += `<thead><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (res.length === 0) {
                        code += "<td colspan='8'>검색 결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < res.length; i++) {
                            code += `<td>\${res[i].emplId}</td>`;
                            code += `<td>\${res[i].emplNm}</td>`;
                            code += `<td>\${res[i].commonCodeDept}</td>`;
                            code += `<td>\${res[i].commonCodeClsf}</td>`;
                            code += `<td>\${res[i].emplEncpn}</td>`;
                            code += `<td>\${res[i].emplBrthdy}</td>`;
                            code += `<td>\${res[i].signPhotoFileStreNm == 'groovy_noSign.png' ? '<button type="button" class="signBtn btn">서명 등록 요청</button>' : "등록완료"}</td>`;
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
                    count = res.length;
                    document.querySelector("#countBox").innerText = count;
                    console.log("loadEmp success");
                    let code = "<table border=1 class='employeeTable'>";
                    code += `<thead><tr><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (res.length === 0) {
                        code += "<td colspan='8'>결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < res.length; i++) {
                            code += `<td><a href="/employee/loadEmp/\${res[i].emplId}">\${res[i].emplId}</a></td>`;
                            code += `<td>\${res[i].emplNm}</td>`;
                            code += `<td>\${res[i].commonCodeDept}</td>`;
                            code += `<td>\${res[i].commonCodeClsf}</td>`;
                            code += `<td>\${res[i].emplEncpn}</td>`;
                            code += `<td>\${res[i].emplBrthdy}</td>`;
                            code += `<td>\${res[i].signPhotoFileStreNm == 'groovy_noSign.png' ? '<button type="button" class="signBtn btn border-radius-50">서명 등록 요청</button>' : "등록완료"}</td>`;
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
