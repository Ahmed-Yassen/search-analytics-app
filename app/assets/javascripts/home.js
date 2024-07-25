document.addEventListener("DOMContentLoaded", function() {
  const searchInput = document.getElementById('search-input');
  const relatedArticles = document.getElementById('related-articles');

  let query = '';
  let enterKeyPressed = false;

  if (searchInput) {
    searchInput.addEventListener('input', function(event) {
      query = searchInput.value;
      sendSearchRequest(query, enterKeyPressed);
    });

    searchInput.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        event.preventDefault();
        enterKeyPressed = true;
        sendSearchRequest(searchInput.value, enterKeyPressed);
        enterKeyPressed = false;
      }
    });
  }

  function sendSearchRequest(query, enterKeyPressed) {
    fetch(`/search?query=${encodeURIComponent(query)}&enter_key_pressed=${enterKeyPressed}`, {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      relatedArticles.innerHTML = '';

      if (data.articles.length > 0) {
        data.articles.forEach(article => {
          const articleElement = document.createElement('div');
          articleElement.className = 'article';
          articleElement.innerText = article.title;
          relatedArticles.appendChild(articleElement);
        });
      } else {
        relatedArticles.innerText = 'No related articles found';
      }
    })
    .catch(error => console.error('Error fetching articles:', error));
  }
});
