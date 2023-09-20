document.addEventListener("DOMContentLoaded",()=>{
    const navList = document.querySelectorAll(".nav-list > a");
    const tabHeader = document.querySelector("#tab-header");

    /*  aside   */
    navList.forEach((item, index) => {
        item.addEventListener("click", () => {
            sessionStorage.setItem("activeNavItem", index);
        });

        const activeIndex = sessionStorage.getItem("activeNavItem");
        if (activeIndex && index === parseInt(activeIndex)) {
            navList.forEach((otherItem) => {
                otherItem.classList.remove("active");
            });
            item.classList.add("active");
        }
    });


})