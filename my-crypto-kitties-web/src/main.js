import { createApp } from 'vue'
import App from './App.vue'
import { routes } from './router';
import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
    mode: 'history',
    history: createWebHistory(),
    routes,
});

createApp(App).use(router).mount('#app')
