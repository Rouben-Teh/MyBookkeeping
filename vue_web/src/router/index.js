import { createRouter, createWebHistory } from "vue-router";
import Landing from "../pages/Landing.vue";
import Login from "../pages/Login.vue";
import Register from "../pages/Register.vue";
import Dashboard from "../pages/Dashboard.vue";
import auth from "../plugins/auth";

const routes = [
  { path: "/", name: "Landing", component: Landing },
  { path: "/login", name: "Login", component: Login },
  { path: "/register", name: "Register", component: Register },
  {
    path: "/dashboard/:tab(records|profile|summary)?",
    name: "Dashboard",
    component: Dashboard,
    meta: { requiresAuth: true },
  },
  { path: "/:pathMatch(.*)*", redirect: "/" },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    }
    if (to.hash) {
      return { el: to.hash, top: 90, behavior: "smooth" };
    }
    return { top: 90 };
  },
});

router.beforeEach((to, from, next) => {
  const isAuth = auth.isAuthenticated();
  if (to.meta.requiresAuth && !isAuth) {
    return next({ name: "Login" });
  }
  if ((to.name === "Login" || to.name === "Register") && isAuth) {
    return next({ name: "Dashboard" });
  }
  next();
});

export default router;
