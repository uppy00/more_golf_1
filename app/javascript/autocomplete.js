// オートコンプリート用のJS

document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("autocomplete-input");
  const resultBox = document.getElementById("autocomplete-results");

  if (!input || !resultBox) return;

  let timeout;

  input.addEventListener("input", () => {
    clearTimeout(timeout);
    const query = input.value.trim();

    if (query.length < 2) {
      resultBox.innerHTML = "";
      resultBox.classList.add("hidden");
      return;
    }

    timeout = setTimeout(() => {
      fetch(`/posts/autocomplete_title?q=${encodeURIComponent(query)}`)
        .then(res => res.json())
        .then(data => {
          resultBox.innerHTML = "";
          if (data.length === 0) {
            resultBox.classList.add("hidden");
            return;
          }

          data.forEach(item => {
            const li = document.createElement("li");
            li.textContent = item;
            li.className = "px-4 py-2 hover:bg-green-100 cursor-pointer";
            li.addEventListener("click", () => {
              input.value = item;
              resultBox.innerHTML = "";
              resultBox.classList.add("hidden");
            });
            resultBox.appendChild(li);
          });

          resultBox.classList.remove("hidden");
        });
    }, 200);
  });

  document.addEventListener("click", (e) => {
    if (!resultBox.contains(e.target) && e.target !== input) {
      resultBox.classList.add("hidden");
    }
  });
});
