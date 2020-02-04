const fetch = require('node-fetch');
const fs = require('fs');

var i = 1;

function fetchUntilCondition(n) {
  fetch('https://superheroapi.com/api/1277766529073624/' + i)
    .then(response => {
      return response.json();
    })
    .then(data => {
      fs.writeFile('data/' + i + ".json", JSON.stringify(data), function(err) {
        if (err) {
          console.log(err);
        }
      });
    })
    .then(function() {
      i += 1;
      if (i <= n) {
        fetchUntilCondition(n)
      }
    })
    .catch(err => {
      console.log(err);
    })
}

fetchUntilCondition(731);
