
//조직도 팝업
let orgBtn = document.querySelector("#orgBtn");
let receive = document.querySelector("#receive");

orgBtn.addEventListener("click", () => {
    fetch("/job/jobOrgChart")
        .then((response) => response.text())
        .then((data) => {
            let popup = window.open("", "_blank", "width=800,height=600");

            popup.document.write(data);

            popup.document.querySelector("#orgCheck").addEventListener("click", () => {
                const checkboxes = popup.document.querySelectorAll("input[name=orgCheckbox]");
                let str = ``;
                checkboxes.forEach((checkbox) => {
                    if (checkbox.checked) {
                        const label = checkbox.closest("label");
                        const emplId = checkbox.id;
                        const emplNm = label.querySelector("span").innerText;

                        let empl = {
                            emplId,
                            emplNm
                        }
                        str += `<span data-id="${empl.emplId}"> ${empl.emplNm} <button type="button" class="close-empl btn">X</button> </span>`;
                    }
                });
                receive.innerHTML = str;

            });

            popup.document.querySelector("#orgCheck").addEventListener("click", () => {
                popup.close();
            });
        })
        .catch((error) => {
            console.error("데이터 가져오기 실패:", error);
        });
});

document.addEventListener("click", function(event) {
    if (event.target && event.target.classList.contains("close-empl")) {
        let spanToRemove = event.target.closest("span");
        if (spanToRemove) {
            spanToRemove.remove(); // 해당 span 태그 삭제
        }
    }
});