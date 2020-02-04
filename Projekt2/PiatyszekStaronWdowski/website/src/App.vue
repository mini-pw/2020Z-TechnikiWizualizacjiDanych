<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style>
body {
  background: url('assets/whitenoise.png');
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

a.button {
  display: inline-block;
  background: white;
  padding: 0.35em 1.2em;
  border: 0.2em solid rgba(200, 50, 100, 1);
  margin: 0 0.3em 0.3em 0;
  border-radius: 0.12em;
  box-sizing: border-box;
  text-decoration: none;
  font-family: 'Roboto', sans-serif;
  font-weight: 300;
  color: rgba(200, 50, 100, 1);
  text-align: center;
  transition: all 0.2s;
}
a.button:hover {
  color: white;
  background-color: rgba(200, 50, 100, 1);
}
</style>
