<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<style>
    .container {
        padding: 0px !important;
    }
</style>
<link rel="stylesheet" href="/resources/css/sanction/sanction.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content">
        <div class="content-line orgChart card-df border-radius-32">
            <div id="search" class="search input-free-white">
                <input type="text" id="searchLine" class=""/>
                <button type="button" class="btn-search btn-flat btn" id="searchLineBtn">검색</button>
            </div>
            <div id="line">
                <div class="inner">
                    <div id="ceo" class="org">
                        <div class="ceo dept" data-dept="DEPT015">
                            <button class="department btn">
                                <span>대표이사</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                    <div id="hrt" class="org">
                        <div class="dept1 dept" data-dept="DEPT010">
                            <button class="department btn">
                                <span>인사팀</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                    <div id="at" class="org">
                        <div class="dept2 dept" data-dept="DEPT011">
                            <button class="department btn">
                                <span>회계팀</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                    <div id="st" class="org">
                        <div class="dept3 dept" data-dept="DEPT012">
                            <button class="department btn">
                                <span>영업팀</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                    <div id="prt" class="org">
                        <div class="dept4 dept" data-dept="DEPT013">
                            <button class="department btn">
                                <span>홍보팀</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                    <div id="gat" class="org">
                        <div class="dept5 dept" data-dept="DEPT014">
                            <button class="department btn">
                                <span>총무팀</span>
                                <i class="icon i-arr-bt"></i>
                            </button>
                            <ol class="depth">
                            </ol>
                        </div>
                    </div>
                </div>
                <div id="searchResult"></div>
            </div>

        </div>
        <div class="approvalLine card-df border-radius-32">
            <div id="approval">
                <div id="sanctionLine" class="line-inner" style="display: flex;">
                    <div class="line-header">
                        <p class="badge sanction">결재</p>
                        <div class="btnWrap">
                            <button type="button" class="lineAddBtn btn-free-white btn">추가 +</button>
                        </div>
                    </div>
                    <div class="contentWrap">
                        <ul class="lineList"></ul>
                    </div>
                </div>
                <div id="referLine" class="line-inner">
                    <div class="line-header">
                        <p class="badge attachment">참조</p>
                        <div class="btnWrap">
                            <button type="button" class="lineAddBtn btn-free-white btn">추가 +</button>
                        </div>
                    </div>
                    <div class="contentWrap">
                    <div class="contentWrap">
                        <ul class="lineList"></ul>
                    </div>
                </div>
            </div>
            <div class="line-service">
                <div class="line-btn-wrapper">
                    <button type="button" class="btn btn-out-sm btn-modal bookmark-btn" data-name="bookmarkName"><i
                            class="icon i-save"></i> 결재선 저장
                    </button>
                    <button type="button" class="btn btn-out-sm btn-modal bookmark-btn" data-name="loadLine"
                            onclick="loadLine()"><i class="icon i-bookmark"></i> 나의 결재선
                    </button>
                </div>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="button" class="submitLine btn btn-fill-bl-sm">결재선 적용</button>
                <button type="button" class="btn btn-fill-wh-sm" onclick="window.close()">닫기</button>
            </div>
        </div>
    </div>
    <!-- 모달창 -->
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm bookmarkName">

            <div class="modal-top">
                <div class="modal-title">결재선으로 저장</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <div class="modal-content input-wrap">
                    <label for="bookmarkName" class="label-df">✍ 결재선 이름</label>
                    <input type="text" id="bookmarkName" class="input-max input">
                </div>
            </div>
            <div class="modal-foote btn-wrapper">
                <button type="button" id="saveBookmark" class="btn btn-fill-bl-sm" onclick="saveLine()">확인</button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
        </div>
        <div class="modal-layer card-df sm loadLine">
            <div class="modal-top">
                <div class="modal-title">저장된 결재선 불러오기</div>
                <button type="button" class="modal-close close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <div class="modal-content">
                    <div id="bookmarkLine">

                    </div>
                </div>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="button" class="btn btn-fill-bl-sm" id="lineSave">확인</button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        const lineAddBtn = document.querySelectorAll(".lineAddBtn");
        const lineInner = document.querySelectorAll(".line-inner");
        const lineSave = document.querySelector("#lineSave");
        const popClose = document.querySelector(".popClose");
        const submitLineBtn = document.querySelector(".submitLine");
        const emplId = "${CustomUser.employeeVO.emplId}";
        const emplDept = "${CustomUser.employeeVO.commonCodeDept}";
        let bookmarkName;
        let bookmarkLine = {};
        const accordians = document.querySelectorAll("div .dept");
        let keyword;

        loadOrgLine() // 로드 시 결재선 불러오기

        window.onload = function () {
            accordians.forEach(item => {
                let header = item.querySelector(".department");
                header.addEventListener("click", e => {
                    e.preventDefault();
                    accordians.forEach(item => {
                        item.classList.remove("active")
                    })
                    if (item.classList.contains("active")) {
                        item.classList.remove("active");
                    } else {
                        item.classList.add("active");
                    }
                });
            });
            openLine();
        };

        function openLine() {
            const departmentElement = document.querySelector(`[data-dept="\${emplDept}"]`);
            if (departmentElement) {
                departmentElement.classList.add('active');
            }
        }

        // 결재선 검색
        $("#searchLineBtn").on("click", function () {
            $('#searchResult').html("");
            loadOrgLine()
        })

        // 조직도 결재선 불러오기
        function loadOrgLine() {
            keyword = document.querySelector("#searchLine").value;
            $.ajax({
                url: `/sanction/api/line/\${emplId}?keyword=\${keyword}`,
                method: 'GET',
                contentType: "application/json;charset=utf-8",
                dataType: 'json',
                success: function (data) {
                    if (keyword == null || keyword === "") {
                        data.forEach(function (employee) {
                            let employeeLi = $('<li class=emplList>');
                            employeeLi.html(
                                `<label style="display: flex">
                            <input type="checkbox" class="lineChk">
                            <input type="hidden" value= "\${employee.emplId}"/>
                            <div class="line-block">
                             <span class="name">\${employee.emplNm}</span>
                             <span class="dept">\${employee.commonCodeDept}</span>
                             <span class="clsf">\${employee.commonCodeClsf}</span>
                       </div></label>`);
                            if (employee.commonCodeDept === '대표') {
                                $('#ceo .ceo > .depth').append(employeeLi);
                            } else if (employee.commonCodeDept === '영업') {
                                $('#st .dept3 > .depth').append(employeeLi);
                            } else if (employee.commonCodeDept === '홍보') {
                                $('#prt .dept4 > .depth').append(employeeLi);
                            } else if (employee.commonCodeDept === '총무') {
                                $('#gat .dept5 > .depth').append(employeeLi);
                            } else if (employee.commonCodeDept === '인사') {
                                $('#hrt .dept1 > .depth').append(employeeLi);
                            } else if (employee.commonCodeDept === '회계') {
                                $('#at .dept2 > .depth').append(employeeLi);
                            }
                        });
                    } else {
                        $(".inner").prop("hidden", true);
                        data.forEach(function (employee) {
                            let employeeLi = $('<li class=emplList>');
                            employeeLi.html(
                                `<label style="display: flex">
                            <input type="checkbox" class="lineChk">
                            <input type="hidden" value= "\${employee.emplId}"/>
                            <div class="line-block">
                             <span class="name">\${employee.emplNm}</span>
                             <span class="dept">\${employee.commonCodeDept}</span>
                             <span class="clsf">\${employee.commonCodeClsf}</span>
                       </div></label>`);
                            $('#searchResult').append(employeeLi);
                        });
                    }

                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }

        // 저장된 결재선 불러오기
        function loadLine() {
            $.ajax({
                url: `/sanction/api/bookmark/\${emplId}`,
                type: "GET",
                success: function (lines) {
                    let result = "";
                    if (lines.length == 0) {
                        result += `<p class="no-bookmark"style="font-size: var(--font-size-24); margin-left:88px" >저장된 결재선이 없습니다.</p>`;
                    } else {
                        result += `<ul class="line-list">`;
                        lines.forEach(function (line) {
                            result += `<li class="emplList">
                                <label style="display: flex" class="line-label">
                                <input type="checkbox" class="savedlineChk">`;
                            result += `<input type="hidden" value="\${line.no}"/>`;
                            result += `<span class="line-name badge font-14 font-md">\${line.name}</span><div class="line-block">`;

                            for (let key in line) {
                                if (line.hasOwnProperty(key) && key != 'no' && key != 'name') {
                                    let value = line[key];
                                    result += `<p class="line-detail" data-id="\${key}">\${value}</p>`;
                                }
                            }
                            result += '</div><button type="button" class="btn removeBtn">X</button></li>';
                            result += `</ul>`;
                        });
                    }
                    $("#bookmarkLine").html(result);
                },
                error: function (xhr) {
                }
            });
        }

        // 결제선 삭제
        $("#bookmarkLine").on("click", ".removeBtn", function () {
            let pLabel = $(this).closest("label");
            let sn = pLabel.find("input[type='hidden']").val();

            $.ajax({
                url: `/sanction/api/bookmark/\${sn}`,
                type: "DELETE",
                success: function (res) {
                    pLabel.remove();
                    loadLine()
                },
                error: function (xhr) {
                }
            });
        });

        // 결재선 저장
        function saveLine() {
            bookmarkName = $("#bookmarkName").val()
            $("#sanctionLine .lineList li label").each(function () {
                const emplId = $(this).find("input[type=hidden]").val();
                bookmarkLine[emplId] = $(this).find('.name').text() + ' ' + $(this).find('.dept').text() + ' ' + $(this).find('.clsf').text();
            });
            const jsonApprover = JSON.stringify(bookmarkLine);
            let jsonData = {
                elctrnSanctnDrftEmplId: emplId,
                elctrnSanctnBookmarkName: bookmarkName,
                elctrnSanctnLineBookmark: jsonApprover
            }
            $.ajax({
                url: "/sanction/api/bookmark",
                type: "POST",
                data: JSON.stringify(jsonData),
                contentType: "application/json",
                success: function (data) {
                    modalClose();
                },
                error: function (xhr) {
                    console.log("결재선 저장 실패");
                }
            });
        }


        /* 결재선 추가 */
        lineInner.forEach(item => {
            item.addEventListener("click", (e) => {
                const lineList = item.querySelector('.lineList');
                if (e.target.classList.contains("lineAddBtn")) {
                    const chkLineList = document.querySelectorAll('.lineChk:checked');
                    chkLineList.forEach(checkbox => {
                        const label = checkbox.closest('label').cloneNode(true);
                        let checkBox = label.querySelector("input[type=checkbox]");
                        checkbox.checked = false;
                        const newLi = document.createElement("li");
                        newLi.classList = "line-item";

                        const button = document.createElement("button");
                        button.classList = "deleteListBtn";
                        button.classList.add("btn");
                        button.innerHTML = "<i class='icon i-trash'></i>";
                        button.onclick = function () {
                            const target = this.closest("li");
                            target.remove();
                        }
                        newLi.appendChild(button);
                        newLi.appendChild(label);
                        if (lineList) lineList.appendChild(newLi);
                        checkBox.remove();
                        return;
                    });


                }

            })
        })

        /*  결재선 값 받아오기  */
        lineSave.addEventListener("click", () => {
            const selected = document.querySelector(".savedlineChk:checked");
            const selectedLabel = selected.closest(".line-label");
            const selectedLine = selectedLabel.querySelector(".line-block");
            const lineItem = selectedLine.querySelectorAll(".line-detail")

            lineInner.forEach(item => {
                const lineList = item.querySelector('.lineList');
                lineList.innerHTML = "";
            })

            lineItem.forEach(item => {
                const newLi = document.createElement("li");
                const text = item.innerText;
                const id = item.getAttribute("data-id");

                newLi.classList = "line-item";

                const newLabel = document.createElement("label");
                const newInput = document.createElement("input");
                newInput.type = "hidden";
                newInput.value = id;

                const newDiv = document.createElement("div");
                newDiv.classList = "line-block";

                const newText = document.createElement("p")
                newText.classList = "name"; // 이름
                newText.append(text);

                newDiv.append(newText);

                newLabel.append(newInput);
                newLabel.append(newDiv);

                const button = document.createElement("button");
                button.classList = "deleteListBtn";
                button.classList.add("btn");
                button.innerHTML = "<i class='icon i-trash'></i>";
                button.onclick = function () {
                    const target = this.closest("li");
                    target.remove();
                }
                newLi.appendChild(button);
                newLi.appendChild(newLabel);

                document.querySelector("#sanctionLine .lineList").append(newLi);
            })
            modalClose();
        })
        /*  데이터 보내기 */

        submitLineBtn.addEventListener("click", e => {
            // e.preventDefault();
            const sanctionLineItems = document.querySelectorAll('#sanctionLine .lineList label');
            const referLineItems = document.querySelectorAll('#referLine .lineList label');
            const data = {
                sanctionLine: {},
                referLine: {}
            };
            if (sanctionLineItems.length != 0) {
                data.sanctionLine = {};
                for (let index = sanctionLineItems.length - 1; index >= 0; index--) {
                    const item = sanctionLineItems[index];
                    const id = item.querySelector("input").value;
                    const name = item.querySelector(".name").innerText.split(' ')[0];
                    data.sanctionLine[sanctionLineItems.length - index] = {id, name};
                }
            } else {
                Swal.fire({
                    text: '결재선을 지정해야 합니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                return;
            }

            if (referLineItems.length != 0) {
                data.referLine = {};
                for (let index = referLineItems.length - 1; index >= 0; index--) {
                    const item = referLineItems[index];
                    const id = item.querySelector("input").value;
                    const name = item.querySelector(".name").innerText.split(' ')[0];
                    data.referLine[referLineItems.length - index + 1] = {id, name};
                }


            }
            // 부모 창으로 데이터를 보냅니다.
            window.opener.postMessage(data, '*');
            window.close();

        })
        /*document.querySelector("#sideBar").style.display = "none";*/

    </script>
</sec:authorize>