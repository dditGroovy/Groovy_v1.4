<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/resources/css/admin/manageEmployee.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 사원 추가 모달 -->
<div id="modal" class="modal-dim" style="display: none">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm emplCard" style="display: block">
        <div class="modal-top">
            <div class="modal-title"><i class="icon-user"></i>사원 추가</div>
            <button type="button" class="modal-close btn close">
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
                                    <label>휴대폰 번호</label><br/>
                                    <input type="text" name="emplTelno" id="emplTel" placeholder="휴대폰 번호 입력" required><br/>
                                </div>
                                <div class="accordion-row">
                                    <label>생년월일</label><br/>
                                    <input type="date" value="2000-01-01" name="emplBrthdy" required><br/>
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
<%--                                        <option value="DEPT015">경영자</option>--%>
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
<%--                                    <input type="radio" name="commonCodeClsf" id="empPos7" value="CLSF010">--%>
<%--                                    <label for="empPos7" class="radioLabel">대표이사</label>--%>
                                </div>
                            </div>
                            <div class="accordion-row">
                                <label>입사일</label> <br/>
                                <input type="date" value="" name="emplEncpn" id="joinDate" required><br/>
                            </div>
                            <div class="accordion-flex">
                                <div class="accordion-row">
                                    <label>사원번호</label>
                                    <button id="generateId" type="button" class="btn btn-free-blue empBtn">사원 번호 생성</button>
                                    <input type="text" name="emplId" id="emplId" required readonly>
                                </div>
                                <div class="accordion-row">
                                    <label>이메일</label><br/>
                                    <input type="email" name="emplEmail" id="emplEmail" placeholder="이메일 입력" required><br/>
                                </div>
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
                            <option value="">부서</option>
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
                            <option value="EMPL_NM">이름순</option>
                            <option value="EMPL_ENCPN">입사일순</option>
                            <option value="COMMON_CODE_CLSF">직급순</option>
                        </select>
                    </div>
                    <div class="search btn-fill-wh-lg">
                        <i class="icon i-search"></i>
                        <input type="text" name="searchName" id="findInput" class="search-input font-reg font-14" placeholder="이름, 사번">
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
    <div id="pagination"></div>
</div>
<script>
    let page = `${pageVO.page}`;
    let depCode = `${pageVO.depCode}`;
    let emplNm = `${pageVO.emplNm}`;
    let sortBy = `${pageVO.sortBy}`;
    let ques = document.querySelectorAll(".que");
    let anws = document.querySelectorAll(".anw");
    function queZero() {
        anws[0].style.maxHeight = anws[0].scrollHeight + "px";
        anws[1].style.maxHeight = "0px";
        anws[2].style.maxHeight = "0px";
    }

    document.querySelector("#addEmployee").addEventListener("click", () => {
        queZero();
    });


    $("#findInput").click(function () {
        let currentInputValue = $(this).val();
        if (currentInputValue !== "") {
            $(this).val("");
        }
    })
    let telInput = $("#emplTel")
    telInput.on('input', function () {
        let telno =  telInput.val().replace(/-/g, '');

        if (telno.length >= 4) {
            telno = telno.slice(0, 3) + '-' + telno.slice(3);
        }
        if (telno.length >= 9) {
            telno = telno.slice(0, 8) + '-' + telno.slice(8);
        }
        if (telno.length > 13) {
            telno = telno.slice(0, 13);
        }
        telInput.val(telno);
    });
    function accordion(element) {
        var content = element.nextElementSibling;

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
            findEmpList();
        });

        // 입사일 선택 - value 값 변경
        emplEncpn.addEventListener("change", function () {
            joinDateVal = this.value;
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

        function findEmpList() {
            const depCodeValue = $("select[name=searchDepCode]").val(); //없음
            const emplNameValue = $("input[name=searchName]").val(); //있음
            const sortByValue = $("select[name=sortBy]").val(); //있음

            $.ajax({
                url: "/employee/findEmp",
                type: "get",
                data: {
                    depCode: depCodeValue,
                    emplNm: emplNameValue,
                    sortBy: sortByValue,
                    page: page
                },
                contentType: "application/json;charset=utf-8",
                success: function (res) {
                    let empList = res.empList;

                    count = empList.length;
                    document.querySelector("#countBox").innerText = count;
                    let pCode = ``;
                    let code = "<table border=1 class='employeeTable'>";
                    code += `<thead><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (res.length === 0) {
                        code += "<td colspan='8'>검색 결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < empList.length; i++) {
                            code += `<td>\${empList[i].emplId}</td>`;
                            code += `<td>\${empList[i].emplNm}</td>`;
                            code += `<td>\${empList[i].commonCodeDept}</td>`;
                            code += `<td>\${empList[i].commonCodeClsf}</td>`;
                            code += `<td>\${empList[i].emplEncpn}</td>`;
                            code += `<td>\${empList[i].emplBrthdy}</td>`;
                            if (empList[i].signPhotoFileStreNm == 'groovy_noSign.png') {
                                code += `<td><button type="button" class="signBtn btn font-14" data-id="\${empList[i].emplId}">서명 등록 요청</button></td>`;
                            } else {
                                code += `<td>등록완료</td>`;
                            }
                            code += `<td>\${(empList[i].commonCodeHffcSttus == 'HFFC010') ? "재직" : (empList[i].commonCodeHffcSttus == 'HFFC011') ? "휴직" : "퇴직"}</td>`;
                            code += "</tr>";
                        }

                        let pager = res.pager;

                        pCode += `
                                    <div class="pagination-wrapper">
                                          <ul class="pagination">
                                             <li class="page-item \${pager.pre==false?'disabled':''}" id="pre">
                                               <a class="page-link" href="./manageEmp?page=\${pager.page-1}&depCode=\${depCodeValue}&emplNm=\${emplNameValue}&sortBy=\${sortByValue}" aria-label="Previous">
                                                 <span aria-hidden="true" class="color-font-high">Prev</span>
                                               </a>
                                             </li>
                                `;
                        for (let i = pager.startNum; i <= pager.lastNum ; i++) {
                            if (i != 0) {
                                pCode += `
                                        <li class="page-item \${pager.page==i? 'active':''}">
                                            <a class="page-link page-num" href="./manageEmp?page=\${i}&depCode=\${depCodeValue}&emplNm=\${emplNameValue}&sortBy=\${sortByValue}">\${i}</a>
                                         </li>
                                      `;
                            }
                        }
                        pCode += `
                                     <li class="\${pager.next?'':'disabled'}" id="next">
                                         <a href="./manageEmp?page=\${pager.page+1}&depCode=\${depCodeValue}&emplNm=\${emplNameValue}&sortBy=\${sortByValue}" aria-label="Next">
                                            <span class="color-font-high">Next</span>
                                          </a>
                                      </li>
                                   </ul>
                                </nav>
                            </div>
                                `;
                    }
                    code += "</tbody></table>";

                    $("#empList").html(code);
                    $("#pagination").html(pCode);
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + error);
                }
            });
        }
        /*사원 목록 불러오기 */
        function getEmpList() {
            $.ajax({
                type: "get",
                url: `/employee/loadEmpList?page=\${page}`,
                dataType: "json",
                success: function (res) {
                    count = res.empList.length;
                    document.querySelector("#countBox").innerText = count;
                    let empList = res.empList;
                    let code = "<table border=1 class='employeeTable'>";
                    let pCode = ``;
                    code += `<thead><tr><th>사번</th><th>이름</th><th>팀</th><th>직급</th><th>입사일</th><th>생년월일</th><th>전자서명</th><th>재직상태</th></tr></thead><tbody>`;
                    if (empList.length === 0) {
                        code += "<td colspan='8'>결과가 없습니다</td>";
                    } else {
                        for (let i = 0; i < empList.length; i++) {
                            code += `<td><a href="/employee/loadEmp/\${empList[i].emplId}">\${empList[i].emplId}</a></td>`;
                            code += `<td>\${empList[i].emplNm}</td>`;
                            code += `<td>\${empList[i].commonCodeDept}</td>`;
                            code += `<td>\${empList[i].commonCodeClsf}</td>`;
                            code += `<td>\${empList[i].emplEncpn}</td>`;
                            code += `<td>\${empList[i].emplBrthdy}</td>`;
                            if (empList[i].signPhotoFileStreNm == 'groovy_noSign.png') {
                                code += `<td><button type="button" class="signBtn btn font-14" data-id="\${empList[i].emplId}">서명 등록 요청</button></td>`;
                            } else {
                                code += `<td>등록완료</td>`;
                            }
                            code += `<td>\${empList[i].commonCodeHffcSttus === 'HFFC010' ? "재직" : empList[i].commonCodeHffcSttus === 'HFFC011' ? "휴직" : "퇴직"}</td>`;
                            code += "</tr>";
                        }
                        code += "</tbody></table>";

                        let pager = res.pageVO;
                        pCode += `
                                    <div class="pagination-wrapper">
                                          <ul class="pagination">
                                             <li class="page-item \${pager.pre==false?'disabled':''}" id="pre">
                                               <a class="page-link" href="./manageEmp?page=\${pager.page-1}" aria-label="Previous">
                                                 <span aria-hidden="true" class="color-font-high">Prev</span>
                                               </a>
                                             </li>
                                `;
                        for (let i = pager.startNum; i <= pager.lastNum ; i++) {
                            pCode += `
                                        <li class="page-item \${pager.page==i? 'active':''}">
                                            <a class="page-link page-num" href="./manageEmp?page=\${i}">\${i}</a>
                                         </li>
                                      `;
                        }
                        pCode += `
                                     <li class="\${pager.next?'':'disabled'}" id="next">
                                         <a href="./manageEmp?page=\${pager.page+1}" aria-label="Next">
                                            <span class="color-font-high">Next</span>
                                          </a>
                                      </li>
                                   </ul>
                                </nav>
                            </div>
                                `;
                    }
                    $("#empList").html(code);
                    $("#pagination").html(pCode);
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                    console.log("message: " + xhr.responseText);
                    console.log("error: " + error);
                }
            });
        }

        if (depCode != '') {
            $("select[name=searchDepCode]").val(depCode);
            $("select[name=sortBy]").val(sortBy);
            $("input[name=searchName]").val(emplNm);
            findEmpList();
        } else {
            getEmpList();
        }

        // 사원 리스트 - 전체 선택
        $(document).on("click", "#selectAll", function () {
            const checked = document.querySelectorAll(".selectEmp");
            checked.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });

        $(document).on("click", ".signBtn", function () {
            let emplId = this.getAttribute("data-id");

            $.get("/alarm/getMaxAlarm")
                .then(function (maxNum) {
                    maxNum = parseInt(maxNum) + 1;

                    let ntcnEmplId = emplId;
                    let url = '/employee/confirm/info';
                    let content = `<div class="alarmListBox">
                                    <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                        <h1>[서명 등록 요청]</h1>
                                        <div class="alarm-textbox">
                                            <p>내 정보 관리에서 서명을 등록해주세요.</p>
                                        </div>
                                    </a>
                                    <button type="button" class="readBtn">읽음</button>
                                </div>`;
                    let alarmVO = {
                        "ntcnEmplId": ntcnEmplId,
                        "ntcnSn": maxNum,
                        "ntcnUrl": url,
                        "ntcnCn": content,
                        "commonCodeNtcnKind": 'NONE'
                    };

                    //알림 생성 및 페이지 이동
                    $.ajax({
                        type: 'post',
                        url: '/alarm/insertAlarmTarget',
                        data: alarmVO,
                        success: function (rslt) {
                            if (socket) {
                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디
                                let msg = maxNum + ",sign," + url + "," + ntcnEmplId;
                                socket.send(msg);
                            }
                        },
                        error: function (xhr) {
                            console.log(xhr.status);
                        }
                    });
                })
                .catch(function (error) {
                    console.log("최대 알람 번호 가져오기 오류:", error);
                });
        })
    })
</script>
<script src="/resources/js/modal.js"></script>
