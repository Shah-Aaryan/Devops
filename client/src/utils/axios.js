import axios from "axios";

const axiosInstance = axios.create({
  baseURL: "http://13.53.129.124:8000/api/v1/",
  withCredentials: true,
});

export default axiosInstance;
