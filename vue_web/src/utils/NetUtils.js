import axios from "axios";

export async function httpPost(api, body) {
  const token = localStorage.getItem("token");

  const response = await axios.post(
    `http://localhost:8000/api.php?action=${api}`,
    body,
    {
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
    },
  );

  return response;
}
