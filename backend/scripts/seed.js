import dotenv from "dotenv";
import mongoose from "mongoose";
import connectDB from "../src/db/db.js";
import { User } from "../src/models/user.model.js";
import { Video } from "../src/models/video.model.js";

dotenv.config({
  path: "./.env",
});

const run = async () => {
  await connectDB();

  await Promise.all([User.deleteMany({}), Video.deleteMany({})]);

  const users = await User.create([
    {
      username: "demo",
      email: "demo@example.com",
      password: "DemoPass123!",
      fullName: "Demo User",
      avatar: "https://placehold.co/128x128",
    },
    {
      username: "creator",
      email: "creator@example.com",
      password: "CreatorPass123!",
      fullName: "Creator User",
      avatar: "https://placehold.co/128x128",
    },
  ]);

  await Video.create([
    {
      videoFile: "https://example.com/videos/sample-1.mp4",
      thumbnail: "https://placehold.co/640x360",
      owner: users[0]._id,
      title: "Welcome to PlaybackSpace",
      description: "Seeded demo video.",
      duration: 120,
      views: 12,
      isPublished: true,
    },
    {
      videoFile: "https://example.com/videos/sample-2.mp4",
      thumbnail: "https://placehold.co/640x360",
      owner: users[1]._id,
      title: "Second Demo Video",
      description: "Another seeded video.",
      duration: 245,
      views: 5,
      isPublished: true,
    },
  ]);

  console.log("Seed complete.");
  await mongoose.connection.close();
};

run().catch(async (err) => {
  console.error("Seed failed:", err);
  await mongoose.connection.close();
  process.exit(1);
});
