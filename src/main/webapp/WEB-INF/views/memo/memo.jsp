<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memo/memo.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/employee/commute" class="on">메모장</a></h1>
        <h2 class="main-desc">나만의 메모 공간 &#x1F4AD;</h2>
    </header>
    <main>
        <div class="main-inner">
            <div class="memo-wrap">
                <div id="memoLists">
                    <div id="memoList">
                        <div id="inputMemo" class="memo">
                            <button id="inputMemoBtn" class="btn">
                                <i class="icon i-add"></i>
                            </button>
                        </div>
                        <div id="appendMemo" style="display: none"></div>
                        <c:forEach items="${memoList}" var="list">
                            <div class="memo list-memo">
                                <div class="btn-wrap">
                                    <button class="more btn"><i class="icon i-more"></i></button>
                                    <ul class="more-list">
                                        <li><button class="modifyBtn btn">수정</button></li>
                                        <li><button class="delete btn">삭제</button></li>
                                    </ul>
                                </div>
                                <div class="memo-content">
                                    <p class="memoSn">${list.memoSn}</p>
                                <c:choose>
                                    <c:when test="${not empty list.memoSj}">
                                        <p class="title">${list.memoSj}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="title">제목없음</p>
                                    </c:otherwise>
                                </c:choose>
                                    <p class="content">${list.memoCn}</p>
                                    <p><fmt:formatDate value="${list.memoWrtngDate}" type="date" pattern="yyyy-MM-dd"/></p>
                                </div>
                                <div class="save-btn-wrap" style="display: none">
                                    <button class="save btn btn-free-blue">저장</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
    const inputMemoBtn = document.querySelector("#inputMemoBtn");
    const memoLists = document.querySelector("#memoLists");
    let flug = true;
    let memoCnt = null;
    inputMemoBtn.addEventListener("click", () => {
        if (flug) {
            const memoElem = document.createElement("div");
            memoElem.className = "memo";

            const memoTitle = document.createElement("input");
            memoTitle.type = "text";
            memoTitle.name = "memoSj";
            memoTitle.id = "memoSj";
            memoTitle.placeholder = "제목을 입력해주세요";
            memoElem.appendChild(memoTitle);

            memoCnt = document.createElement("textarea");
            memoCnt.name = "memoCn";
            memoCnt.id = "memoCn";
            memoCnt.placeholder = "내용을 입력해주세요.";

            memoElem.appendChild(memoCnt);
            const saveBtn = document.createElement("button");

            saveBtn.className = "savebtn";
            saveBtn.classList.add("btn");
            saveBtn.classList.add("btn-free-blue");
            saveBtn.innerText = "저장";
            saveBtn.addEventListener("click", validateForm);
            memoElem.appendChild(saveBtn);


            document.querySelector("#appendMemo").append(memoElem);
            document.querySelector("#appendMemo").style.display = "block";
            flug = false;
        }
    })

    function validateForm() {
        if (memoCnt === null) {
        	 Swal.fire({
                 title: '내용을 입력해주세요',
                 showConfirmButton: false,
                 timer: 1500
             });
            return false;
        }

        const memoValue = memoCnt.value;

        if (memoValue === null || memoValue.trim() === "") {
        	Swal.fire({
                title: '내용을 입력해주세요',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }

        return true;
    }

    memoLists.addEventListener("click", (e) => {
        const target = e.target;
        if(target.classList.contains("more")){
            target.classList.add("on");
        }else if(target.closest(".more")){
            target.closest(".more").classList.add("on");
        }else {
        	const moreElements = document.querySelectorAll(".more");
            moreElements.forEach((element) => {
                element.classList.remove("on");
            });
        }
        if (target.classList.contains("savebtn")) {
            const memoElem = target.parentElement;
            const memoTitleInput = memoElem.querySelector('input[name="memoSj"]');
            const memoContentTextarea = memoElem.querySelector('textarea[name="memoCn"]');

            const memoSj = memoTitleInput.value;
            const memoCn = memoContentTextarea.value;

            const memoData = {
                memoSj: memoSj,
                memoCn: memoCn
            };

            $.ajax({
                url: "/memo/memoMain",
                type: "POST",
                dataType: "text",
                data: JSON.stringify(memoData),
                contentType: "application/json;charset=UTF-8",
                success: function (data) {
                    if (data == "success") {
                        location.href = location.href;
                    } else {
                    	Swal.fire({
                            title: '메모 등록을 실패했습니다',
                            showConfirmButton: false,
                            timer: 1500
                        });
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
            flug = true;
        }

        if (target.classList.contains("modifyBtn")) {
            const memo = target.closest(".memo");
            const memoContent = memo.querySelector(".memo-content");
            const more = memo.querySelector(".more");
            let title = memo.querySelector(".title");
            let content = memo.querySelector(".content");
            const memoSnElement = memo.querySelector(".memoSn");
            more.classList.remove("on");
            const memoSn = memoSnElement.innerText;
            const memoSnInput = document.createElement("input");
            memoSnInput.type = "hidden";
            memoSnInput.name = "memoSn";
            memoSnInput.id = "memoSn";
            memoSnInput.value = memoSn;

            const memoTitle = document.createElement("input");
            memoTitle.type = "text";
            memoTitle.name = "memoSj";
            memoTitle.id = "memoSj";
            memoTitle.value = title.innerText;

            const memoCnt = document.createElement("textarea");
            memoCnt.name = "memoCn"
            memoCnt.value = content.innerText;
            memoCnt.id = "memoCn";

            memoContent.innerHTML = "";
            memoContent.append(memoSnInput);
            memoContent.append(memoTitle);
            memoContent.append(memoCnt);

            memo.querySelector(".save-btn-wrap").style.display = "flex";

            $.ajax({
                url: `memoMain/\${memoSn}`,
                method: "GET",
                dataType: "text",
                success: function (response) {
                    if (response == "success") {
                    }
                }
            })
        }

        if (target.classList.contains("save")) {
            const memo = target.closest(".memo");
            const memoNumber = memo.querySelector(".memoSn");
            const memoContent = memo.querySelector(".memo-content");
            document.querySelector(".modifyBtn").style.display = "inline-block";
            document.querySelector(".delete").style.display = "inline-block";
            document.querySelector(".save").style.display = "none";

            let sn = document.createElement("p");
            sn.classList = "memoSn";
            let title = document.createElement("p");
            title.classList = "title";
            let content = document.createElement("p");
            content.classList = "content";

            sn.innerText = memo.querySelector("#memoSn").value;
            title.innerText = memo.querySelector("#memoSj").value;
            content.innerText = memo.querySelector("#memoCn").value;

            if (content.innerText === "") {
            	Swal.fire({
                    title: '내용을 입력해주세요',
                    showConfirmButton: false,
                    timer: 1500
                });
				document.querySelector(".save").style.display = "inline-block";
                return;
            }

            memoContent.innerHTML = "";
            memoContent.append(sn);
            memoContent.append(title);
            memoContent.append(content);

            let memoSn = sn.innerText;
            let memoSj = title.innerText;
            let memoCn = content.innerText;

            const updateData = {
                memoSn: memoSn,
                memoSj: memoSj,
                memoCn: memoCn
            };

            $.ajax({
                url: `memoMain/\${memoSn}`,
                type: "PUT",
                dataType: "text",
                data: JSON.stringify(updateData),
                contentType: "application/json;charset=UTF-8",
                success: function (data) {
                    if (data == "success") {
                        location.href = location.href;
                    } else {
                    	Swal.fire({
                            title: '메모 수정을 실패했습니다',
                            showConfirmButton: false,
                            timer: 1500
                        })
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
        }

        if (target.classList.contains("delete")) {
            const memo = target.closest(".memo");
            const more = memo.querySelector(".more");
            const memoNumber = memo.querySelector(".memoSn");
            memoSn = memoNumber.innerText;
            more.classList.remove("on");
            const deleteData = {
                memoSn: memoSn
            }

            $.ajax({
                url: `memoMain/\${memoSn}`,
                type: "DELETE",
                dataType: "text",
                data: JSON.stringify(deleteData),
                contentType: "application/json;charset=UTF-8",
                success: function (data) {
                    if (data == "success") {
                        location.href = location.href;
                    } else {
                    	Swal.fire({
                            title: '메모 삭제를 실패했습니다',
                            showConfirmButton: false,
                            timer: 1500
                        })
                    }
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            })
        }
    })

</script>