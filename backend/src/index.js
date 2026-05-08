import mongoose from "mongoose";
import connectDB from "./db/db.js";
import dotenv from "dotenv";
import { app } from "./app.js";

dotenv.config({
  path: "./.env",
});
console.log("ENV" , process.env.MONGO_URI);
console.log("JWT:", process.env.JWT_SECRET);
console.log("REFRESH:", process.env.REFRESH_TOKEN_SECRET);

connectDB()
  .then(() => {
    try {
      app.on("error", (err) => {
        console.log("⚠️ Server error", err);
        throw err;
      });
      app.listen(process.env.PORT || 8000, () => {
        console.log(`🚀 Server is running on port ${process.env.PORT || 8000}`);
      });
    } catch (err) {
      console.log("⚠️ Error starting the server", err);
    }
  })
  .catch((err) => {
    console.log("⚠️ Error connecting to the database", err);
  });


// 👇 ADD THIS LINE for Vercel support
export default app;