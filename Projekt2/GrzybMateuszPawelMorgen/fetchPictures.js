const fetch = require("node-fetch");
const request = require("request");
const fs = require("fs");

var i = 1;

function fetchUntilCondition(n) {
  fetch("https://superheroapi.com/api/1277766529073624/" + i)
    .then(response => {
      return response.json();
    })
    .then(data => {
      request.get({url: data.image.url, encoding: null}, function (err, response, body) {
        fs.writeFile("pictures/" + i + ".jpg", body, "binary", function(err) {
          if(err)
            console.log(err);
          else
            console.log("The file was saved!");
            i += 1;
            if (i <= n) {
              fetchUntilCondition(n)
            }
        });
      });
    })
    .catch(err => {
      console.log(err);
    })
}

fetchUntilCondition(731);