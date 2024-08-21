"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const mongoose_1 = __importDefault(require("mongoose"));
const body_parser_1 = __importDefault(require("body-parser"));
const http_1 = require("http"); // Import the createServer function
const socket_io_1 = require("socket.io"); // Import the Server class from socket.io
const authRoutes_1 = __importDefault(require("./routes/authRoutes"));
const itemRoutes_1 = __importDefault(require("./routes/itemRoutes"));
const eventRoutes_1 = __importDefault(require("./routes/eventRoutes"));
const lostItemRoutes_1 = __importDefault(require("./routes/lostItemRoutes"));
// import notificationRoutes from './routes/notificationRoutes';
const app = (0, express_1.default)();
const httpServer = (0, http_1.createServer)(app); // Create an HTTP server using the Express app
const io = new socket_io_1.Server(httpServer, {
    cors: {
        origin: '*',
    },
});
app.use(express_1.default.json());
app.use(body_parser_1.default.json());
const MONGO_URI = 'mongodb+srv://chirag:chirag@cluster0.dgdbyqm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
mongoose_1.default.connect(MONGO_URI)
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.log(err));
app.use('/api/auth', authRoutes_1.default);
app.use('/api/items', itemRoutes_1.default);
app.use('/api/events', eventRoutes_1.default);
app.use('/api/lostItems', lostItemRoutes_1.default);
// app.use('/api/notification',notificationRoutes);
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
