import { httpPost } from "../utils/NetUtils";

const COOKIE_NAME = "bookkeeping_token";
const COOKIE_MAX_AGE = 3600 * 24 * 7; // 7天

function setCookie(name, value, days) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString();
  document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=/; SameSite=Lax`;
}

function getCookie(name) {
  return document.cookie
    .split(";")
    .map((c) => c.trim())
    .find((c) => c.startsWith(`${name}=`))
    ?.split("=")[1];
}

function deleteCookie(name) {
  document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/`;
}

async function login(email, password) {
  if (!email || !password) {
    throw new Error("请输入邮箱和密码");
  }

  const res = await httpPost("login", {
    email: email,
    password: password,
    device_type: "WEB",
  });
  const data = res.data;

  console.log(data);

  localStorage.setItem("email", email);
  localStorage.setItem("id", data["id"]);
  localStorage.setItem("token", data["token"]);
  setCookie(COOKIE_NAME, data["token"], 7);

  return { token: data["id"] };
}

async function logout() {
  const res = await httpPost("logout");
  const data = res.data;

  if (data["ok"] != true) {
    console.log(`'登出失败: ${data["error"]}'`);
  } else {
    console.log("登出成功");
  }

  deleteCookie(COOKIE_NAME);
}

function getAuthToken() {
  return getCookie(COOKIE_NAME)
    ? decodeURIComponent(getCookie(COOKIE_NAME))
    : null;
}

function isAuthenticated() {
  return !!getAuthToken();
}

export default {
  login,
  logout,
  getAuthToken,
  isAuthenticated,
};
