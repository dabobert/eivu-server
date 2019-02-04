import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
import "babel-core/register"
import 'babel-polyfill'

Vue.prototype.$http = axios;
// Vue.use(axios) doesn't work i don't know why

Vue.component('tree-node', {
  props: ['node', 'children'],
  data() {
    return { showChildren: false, dataLoaded: false }
  },
  template: 
    `<li v-bind:id="node.id">
      <div v-bind:class="node.klass" @click="toggleChildren">{{ node.name }}</div>
      <ul v-if="node.children && showChildren">
        <tree-node v-for="child in node.children" v-bind:node="child" :key="child.vue_id">
        </tree-node>
      </ul>
    </li>`,
  methods: {
    toggleChildren() {
      fetchData()
      this.showChildren = !this.showChildren;
    },
    async fetchData() {
      debugger;
    }
  }
})

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!',
      treeData: []
    },
    mounted () {
      this.$http
        .get('/api/v1/folders')
        .then(
          response => (
          this.treeData = response.data.data))
    }
  })
})


// <tree-node
//       v-for="node in treeData"
//       v-bind:node="node"
//     ></tree-node>
//   </ul>