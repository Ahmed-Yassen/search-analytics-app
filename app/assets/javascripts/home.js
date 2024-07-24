document.addEventListener("DOMContentLoaded", function() {
  const searchInput = document.getElementById('search-input');
  const relatedArticles = document.getElementById('related-articles');

  if (searchInput) {
    searchInput.addEventListener('input', function() {
      const query = searchInput.value;

      fetch(`/search?query=${encodeURIComponent(query)}`, {
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
            articleElement.innerText = article.title;
            relatedArticles.appendChild(articleElement);
          });
        } else {
          relatedArticles.innerText = 'No related articles found';
        }
      })
      .catch(error => console.error('Error fetching articles:', error));
    });
  }
});
