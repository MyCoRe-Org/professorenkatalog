function initEntityFacts(){
    document.querySelectorAll('[data-entityfacts-gnd]').forEach((entityfactsDiv) => {
      let gnd = entityfactsDiv.dataset.entityfactsGnd;
      let whiteList = entityfactsDiv.dataset.entityfactsWhitelist?.split(" ").filter((entry) => entry.length > 0);
      let blackList = entityfactsDiv.dataset.entityfactsBlacklist?.split(" ").filter((entry) => entry.length > 0);
      whiteList = whiteList == null ? [] : whiteList;
      blackList = blackList == null ? [] : blackList;

      fetch('https://hub.culturegraph.org/entityfacts/' + gnd)
        .then(response => {
          response.json()
            .then(data => {
              let itemHTML = '';
              data.sameAs.forEach((item) => {
                if ((whiteList.includes(item.collection.abbr) || whiteList.length == 0) && !blackList.includes(item.collection.abbr)) {
                  itemHTML += `\n<li><a href="${item['@id']}" data-entityfacts-abbr="${item.collection.abbr}" data-entityfacts-publisher="${item.collection.publisher}">${item.collection.name}</a></li>`;
               }
              });
              entityfactsDiv.innerHTML = '<ul>' + itemHTML + '</ul>';
            })
      });
  });
}

document.addEventListener("DOMContentLoaded", () => {
  initEntityFacts();
});