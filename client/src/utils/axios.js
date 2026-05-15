import axios from "axios";

const axiosInstance = axios.create({
  baseURL: "http://3.27.112.177:8000/api/v1/",
  withCredentials: true,
});

export default axiosInstance;
