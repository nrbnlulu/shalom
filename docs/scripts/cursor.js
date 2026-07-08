(() => {
    if (window.matchMedia("(pointer: coarse)").matches) {
        return;
    }

    const cursor = document.createElement("div");
    cursor.className = "terminal-cursor";
    document.body.appendChild(cursor);

    const update = (event) => {
        const x = event.clientX;
        const y = event.clientY;
        cursor.style.transform = `translate(${x}px, ${y}px) translate(-50%, -50%)`;
        cursor.style.opacity = "1";
    };

    const isInteractive = (target) => {
        if (!target || !(target instanceof Element)) return false;
        return Boolean(
            target.closest(
                "a,button,summary,[role='button'],[role='link'],input,textarea,select,.md-button,.md-nav__link",
            ),
        );
    };

    document.addEventListener("mousemove", update, { passive: true });
    document.addEventListener("mouseleave", () => {
        cursor.style.opacity = "0";
    });

    document.addEventListener(
        "mouseover",
        (event) => {
            if (isInteractive(event.target)) {
                cursor.classList.add("terminal-cursor--active");
            }
        },
        { passive: true },
    );

    document.addEventListener(
        "mouseout",
        (event) => {
            if (isInteractive(event.target)) {
                cursor.classList.remove("terminal-cursor--active");
            }
        },
        { passive: true },
    );

    document.addEventListener(
        "mousedown",
        () => {
            cursor.classList.add("terminal-cursor--click");
        },
        { passive: true },
    );

    document.addEventListener(
        "mouseup",
        () => {
            cursor.classList.remove("terminal-cursor--click");
        },
        { passive: true },
    );
})();
