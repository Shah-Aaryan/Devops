import axios from "axios";

const axiosInstance = axios.create({
  baseURL: "http://13.239.176.14:8000/api/v1/",
  withCredentials: true,
});

export default axiosInstance;
