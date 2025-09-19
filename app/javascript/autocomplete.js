// オートコンプリート用のJS

// app/javascript/autocomplete.js

function initAutocomplete() {
  setupAutocomplete("autocomplete-input", "autocomplete-results", "/posts/autocomplete_title");
  setupAutocomplete("autocomplete-nickname", "autocomplete-nickname-results", "/posts/autocomplete_nickname");
}

// フルリロードとTurbo遷移の両方で実行
document.addEventListener("DOMContentLoaded", initAutocomplete);
document.addEventListener("turbo:load", initAutocomplete);

function setupAutocomplete(inputId, resultBoxId, fetchUrl) {
  const input = document.getElementById(inputId);
  const resultBox = document.getElementById(resultBoxId);
  if (!input || !resultBox) return;

  // 二重バインド防止（Turboで複数回呼ばれるため）
  if (input.dataset.acBound === "1") return;
  input.dataset.acBound = "1";

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
      fetch(`${fetchUrl}?q=${encodeURIComponent(query)}`)
        .then(res => res.json())
        .then(data => {
          resultBox.innerHTML = "";
          if (!data.length) {
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
}
