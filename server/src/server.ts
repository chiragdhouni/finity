import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import { createServer } from 'http'; // Import the createServer function
import { Server } from 'socket.io'; // Import the Server class from socket.io

import authRoutes from './routes/authRoutes';
import itemRoutes from './routes/itemRoutes';
import eventRoutes from './routes/eventRoutes';
import lostItemRoutes from './routes/lostItemRoutes';
import User from './models/user'; // Import the User model and initializeSocket function
import notificationRoutes from './routes/notificationRoutes';

const app = express();
const httpServer = createServer(app); // Create an HTTP server using the Express app
const io = new Server(httpServer, {
  cors: {
    origin: '*',
  },
});

app.use(express.json());
app.use(bodyParser.json());

const MONGO_URI: string = 'mongodb+srv://chirag:chirag@cluster0.dgdbyqm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

app.use('/api/auth', authRoutes);
app.use('/api/items', itemRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/lostItems', lostItemRoutes);
app.use('/api/notification',notificationRoutes);

app.get('/', (req, res) => {
  res.send('Hello World');
});

// Initialize the Socket.IO instance in your Mongoose model
// initializeSocket(io);

// io.on('connection', (socket) => {
//   console.log('a user connected');

//   // Handle joining a room for listening to user updates
//   socket.on('listen_to_user', (userId: string) => {
//     socket.join(`user_${userId}`);
//     console.log(`User ${userId} is now listening for updates.`);
//   });

//   // Handle leaving a room
//   socket.on('stop_listening_to_user', (userId: string) => {
//     socket.leave(`user_${userId}`);
//     console.log(`User ${userId} stopped listening for updates.`);
//   });

//   // Handle disconnection
//   socket.on('disconnect', () => {
//     console.log('a user disconnected');
//   });
// });

// Start the HTTP server
httpServer.listen(3001, () => {
  console.log(`Server is running on port 3001`);
});
